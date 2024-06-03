import { redirect } from '@sveltejs/kit';

export async function load({ locals, params }) {
	const supabase = locals.supabase;
	const username = params.username;
	if (!username) throw redirect(303, '/?error=INVALID_USERNAME');
	// TODO: check only for published VOD
	// check username against the live debate and get the live debate
	const { data, error } = await supabase
		.from('live_debate')
		.select('*, host(*)')
		.eq('host.username', username)
		.not('host', 'is', null)
		.not('published', 'is', null)
		.not("ended", "is", true);

	if (error) {
		console.error(error);
		throw redirect(303, '/?error=SERVER_ERROR_LIVE_DEBATE');
	}

	if (!data || data.length === 0) throw redirect(303, `/profile/${username}/new-debate?error=NO_DEBATE_CREATE_ONE`);

	const liveDebateId = data[0].id;

	const [
		{ data: teamData, error: teamError },
		{ data: participantsData, error: participantsError }
	] = await Promise.all([
		supabase.from('live_debate_team').select().eq('live_debate', liveDebateId).order('title'),
		supabase.from('live_debate_participants').select().eq('live_debate', liveDebateId)
	]);
	if (teamError) {
		console.error(teamError);
		throw redirect(303, '/?error=SERVER_ERROR_TEAM');
	}

	if (participantsError) {
		console.error(participantsError);
		throw redirect(303, '/?error=SERVER_ERROR_PARTICIPANTS');
	}

	return {
		live_debate: data[0],
		teamData,
		participantsData
	};
}
