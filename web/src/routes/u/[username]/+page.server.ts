import { fail, redirect, type ActionFailure } from '@sveltejs/kit';
import { createClient, type SupabaseClient } from '@supabase/supabase-js';
import { PUBLIC_SUPABASE_URL } from '$env/static/public';
import { SUPABASE_SECRET_KEY } from '$env/static/private';
import { participantsWithUserDataSelect, type ParticipantsWithUserData } from '$src/lib/types';

import type { PageData } from './page.types';
import type { Database, Tables, TablesInsert } from '$src/lib/schema/database.types';

const supabaseAdmin = createClient<Database>(PUBLIC_SUPABASE_URL, SUPABASE_SECRET_KEY);

export async function load({ locals, params }) {
	const PAGE_DATA: PageData = {
		userJoined: false,
		isLoggedIn: false,
		user: null,
		participants: [],
		isJoined: false,
		live_feed: null,
		myBackstageInfo: null,
		teamMapColor: {},
		host: null,
		teams: [],
		followerCount: 0
	};

	const supabase = locals.supabase;

	const { session, user } = await locals.safeGetSession();
	if (!session || !session.user) return PAGE_DATA;

	// get the live feed id from the username
	// Get all the participant
	// Check if one of the participant match with the userid
	PAGE_DATA.isLoggedIn = true;
	PAGE_DATA.user = session.user;
	let userId = session.user.id;

	const username = params.username;
	if (!username) throw redirect(303, '/?error=INVALID_USERID');

	const { data: live_feeds, error } = await getLatestLiveFeedId(supabase, username);

	const live_feed = live_feeds?.[0] ?? null; 
	const liveFeedId = live_feed?.id;

	PAGE_DATA.live_feed = live_feed;

	if (live_feeds && live_feeds?.length > 1) {
		console.error('Cleanup: Database has more than one live feed');
	}

	if (error || !live_feeds || !live_feed || live_feeds.length === 0 || typeof liveFeedId !== 'string') {
		throw redirect(303, '/?error=FAILED_live_feed_INFO');
	}

	const [
		{ data: host, error: hostError },
		{ data: live_feed_participants, error: participantsError },
		{ data: live_feed_team, error: teamError },
		{ count: followerCount, error: followerCountError }
	] = await Promise.all([
		supabase.from("user_data").select().eq("username", username),
		supabase
			.from('live_feed_participants')
			.select(participantsWithUserDataSelect)
			.eq('live_feed', liveFeedId)
			.order('created_at', { ascending: true })
			.returns<ParticipantsWithUserData[]>(),
		supabase.from('live_feed_team').select('*').eq('live_feed', liveFeedId),
		supabase.from("user_follow").select("*", { count: "exact" }).eq("user_id", live_feed.host!)
	]);

	PAGE_DATA.host = host?.[0]!;
	await supabaseAdmin.from('live_feed_user_role').insert({
		live_feed: liveFeedId,
		user_id: PAGE_DATA.user.id,
		role: 'guest'
	});

	PAGE_DATA.teams = live_feed_team || [];
	PAGE_DATA.teamMapColor = PAGE_DATA.teams.reduce((obj: Record<string, string>, team) => {
		obj[team.id] = team.color;
		return obj;
	}, {});

	PAGE_DATA.participants = live_feed_participants || [];
	PAGE_DATA.myBackstageInfo =
		live_feed_participants?.find((item) => item.participant_id.id === userId) || null;
	PAGE_DATA.isJoined = !!PAGE_DATA.myBackstageInfo;
	PAGE_DATA.followerCount = followerCount || 0;

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

		const { data: live_feeds, error } = await getLatestLiveFeedId(supabase, username);

		const live_feed = live_feeds?.[0];
		const liveFeedId = live_feed?.id;
		if (error || !live_feed || live_feeds.length === 0 || typeof liveFeedId !== 'string') {
			return fail(404, { message: 'Failed to get the live_feed info from db' });
		}

		// temp fnc to get the team id, This should be sent from the current user
		// or under live_feed_team
		async function getAnyTeamId(liveFeedId: string): Promise<string | null> {
			if (!userData || !userData.id) return null;

			const { data, error } = await supabase
				.from('live_feed_user_team')
				.select('team')
				.eq('live_feed', liveFeedId)
				.eq('user_id', userData?.id);

			if (!data?.[0]?.team) console.error(`Invalid team found for ${liveFeedId}`);
			return data?.[0]?.team || null;
		}

		const toInsert: TablesInsert<'live_feed_participants'> = {
			live_feed: liveFeedId,
			participant_id: userData?.id,
			role: 'guest',
			location: 'backstage',
			display_name: userData?.username as string,
			team: await getAnyTeamId(liveFeedId) // must get from the formdata
		};

		const { error: errorInsert } = await supabase
			.from('live_feed_participants')
			.insert(toInsert)
			.select('*');

		if (errorInsert) {
			// Check if the partocipant is full and update the error
			const { count, error } = await supabase
				.from('live_feed_participants')
				.select('*', { count: 'exact' })
				.eq('live_feed', liveFeedId);

			if (typeof count === 'number' && count >= live_feed.max_participants) {
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

		const { data: live_feeds, error } = await getLatestLiveFeedId(supabase, username);

		const liveFeedId = live_feeds?.[0]?.id;

		if (error || !live_feeds || live_feeds.length === 0 || typeof liveFeedId !== 'string') {
			return fail(404, { message: 'Failed to get the live_feed info from db' });
		}

		const { data: removed, error: errorRemoved } = await supabase
			.from('live_feed_participants')
			.delete()
			.eq('live_feed', liveFeedId)
			.eq('participant_id', user.id);

		if (errorRemoved) {
			return fail(404, { message: 'Bad request sent', errorRemoved });
		}

		return { success: true };
	}
};

async function getLatestLiveFeedId(
	supabase: SupabaseClient,
	username: string
): Promise<{
	data: Tables<'live_feed'>[] | null;
	error: any;
}> {
	const { data, error } = await supabase
		.from('live_feed')
		.select()
		.eq('host_username', username)
		.eq('published', true)
		.not('ended', 'is', true)
		.not('host', 'is', null)
		.order('published_tz', { ascending: false });

	return { data, error };
}
