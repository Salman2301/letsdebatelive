import { fail, redirect, type ActionFailure } from '@sveltejs/kit';
import type { PageData } from './page.types';

export async function load({ locals, params }) {
	const PAGE_DATA: PageData = {
		userJoined: false,
		isLoggedIn: false,
		user: null,
		participants: [],
		isJoined: false,
		live_debate: null,
		myBackstageInfo: null,
		teamMapColor: {},
		host: null,
	};
	const supabase = locals.supabase;

	const { session, user } = await locals.safeGetSession();
	if (!session || !session.user) return PAGE_DATA;

	// get the live debate id from the username
	// Get all the participant
	// Check if one of the participant match with the userid
	PAGE_DATA.isLoggedIn = true;
	PAGE_DATA.user = session.user;
	let userId = session.user.id;

	const username = params.username;
	if (!username) throw redirect(303, '/?error=INVALID_USERID');

	// TODO: get only the published!
	const { data: live_debates, error } = await supabase
		.from('live_debate')
		.select('*, host(*)')
		.eq('host.username', username)
		.not('host', 'is', null);

	PAGE_DATA.live_debate = live_debates?.[0] ?? null;
	const liveDebateId = live_debates?.[0]?.id;
	PAGE_DATA.host = JSON.parse(JSON.stringify(PAGE_DATA?.live_debate?.host || {}));

	if (error || live_debates.length === 0 || typeof liveDebateId !== 'string') {
		throw redirect(303, '/?error=FAILED_LIVE_DEBATE_INFO');
	}

	const [
		{ data: live_debate_participants, error: participantsError },
		{ data: live_debate_team, error: teamError }
	] = await Promise.all([
		supabase.from('live_debate_participants').select('*').eq('live_debate', liveDebateId),
		supabase.from('live_debate_team').select('*').eq('live_debate', liveDebateId)
	]);

	PAGE_DATA.teamMapColor = (live_debate_team || []).reduce((obj: Record<string, string>, team) => {
		obj[team.id] = team.color;
		return obj;
	}, {});

	PAGE_DATA.participants = live_debate_participants || [];
	PAGE_DATA.myBackstageInfo =
		live_debate_participants?.find((item) => item.participant_id === userId) || null;
	PAGE_DATA.isJoined = !!PAGE_DATA.myBackstageInfo;

	return PAGE_DATA;
}

type FormResponse = Promise<
	| ActionFailure<{
			message: string;
			error_code?: string;
	  }>
	| {
			success: boolean;
	  }
>;

/** @type {import('./$types').Actions} */
export const actions = {
	join_backstage: async ({ locals, request, params }): FormResponse => {
		// TODO: CHECK IF THE USER IS BANNED FROM PLATFORM
		// TODO: CHECK IF THE USER IS KICKED FROM THE LIVE DEBATE
		// TODO: CHECK IF THE USER IS BANNED FROM HOST

		const data = await request.formData();

		const supabase = locals.supabase;
		const { user, session, userData } = await locals.safeGetSession();

		const is_anonymous = user?.is_anonymous;
		if (!user && !is_anonymous) return fail(401, { message: 'User must be signed in' });

		if (!userData) return fail(401, { message: 'Invalid user info' });

		const username = params.username;

		if (typeof username !== 'string' || username === '')
			return fail(404, { message: 'Invalid username!' });

		const { data: live_debates, error } = await supabase
			.from('live_debate')
			.select('*, host(*)')
			.eq('host.username', username)
			.not('host', 'is', null);

		const live_debate = live_debates?.[0];
		const liveDebateId = live_debate?.id;
		if (error || !live_debate || live_debates.length === 0 || typeof liveDebateId !== 'string') {
			return fail(404, { message: 'Failed to get the live_debate info from db' });
		}

		// temp fnc to get the team id, This should be sent from the current user
		// or under live_debate_team
		async function getAnyTeamId(liveDebateId: string): Promise<string> {
			const { data, error } = await supabase
				.from('live_debate_team')
				.select('id')
				.eq('live_debate', liveDebateId);
			if (!data?.[0]?.id) console.error(`Invalid team found for ${liveDebateId}`);
			return data?.[0]?.id || 'invalid';
		}

		const toInsert = {
			live_debate: liveDebateId,
			participant_id: userData?.id,
			is_host: liveDebateId === live_debates[0].host,
			location: 'backstage',
			display_name: userData?.username as string,
			team: await getAnyTeamId(liveDebateId) // must get from the formdata
		} as const;
		const { data: insert, error: errorInsert } = await supabase
			.from('live_debate_participants')
			.insert(toInsert)
			.select('*');

		if (errorInsert) {
			// Check if the partocipant is full and update the error
			const { count, error } = await supabase
				.from('live_debate_participants')
				.select('*', { count: 'exact' })
				.eq('live_debate', liveDebateId);

			if (typeof count === 'number' && count >= live_debate.max_participants) {
				return fail(400, { message: 'Max. Participants reached!', error_code: 'MAX_PARTICIPANT' });
			}
			return fail(400, { message: 'Bad request sent', errorInsert });
		}

		return { success: true };
	},
	leave_backstage: async ({ locals, request, params }) => {
		const data = await request.formData();

		const supabase = locals.supabase;
		const { user, session, userData } = await locals.safeGetSession();

		const is_anonymous = user?.is_anonymous;
		if (!user || is_anonymous) return fail(401, { message: 'User must be signed in' });

		if (!userData) return fail(401, { message: 'Invalid user info' });

		const username = params.username;

		if (typeof username !== 'string' || username === '')
			return fail(404, { message: 'Invalid username!' });

		const { data: live_debates, error } = await supabase
			.from('live_debate')
			.select('*, host(*)')
			.eq('host.username', username)
			.not('host', 'is', null);

		const liveDebateId = live_debates?.[0]?.id;

		if (error || live_debates.length === 0 || typeof liveDebateId !== 'string') {
			return fail(404, { message: 'Failed to get the live_debate info from db' });
		}

		const { data: removed, error: errorRemoved } = await supabase
			.from('live_debate_participants')
			.delete()
			.eq('live_debate', liveDebateId)
			.eq('participant_id', user.id);

		if (errorRemoved) {
			return fail(404, { message: 'Bad request sent', errorRemoved });
		}

		return { success: true };
	}
};
