import { participantsWithUserDataSelect, type ParticipantsWithUserData } from '$src/lib/types';
import { redirect } from '@sveltejs/kit';

export async function load({ locals, params }) {
	const supabase = locals.supabase;
	const username = params.username;
	if (!username) throw redirect(303, '/?error=INVALID_USERNAME');
	// TODO: check only for published VOD
	// check username against the live feed and get the live feed
	const { data, error } = await supabase
		.from('live_feed')
		.select()
		.eq('host_username', username)
		.not('host', 'is', null)
		.not('published', 'is', null)
		.not('ended', 'is', true);

	if (error) {
		console.error(error);
		throw redirect(303, '/?error=SERVER_ERROR_live_feed');
	}

	if (!data || data.length === 0)
		throw redirect(303, `/profile/${username}/new-feed?error=NO_DEBATE_CREATE_ONE`);

	const liveFeedId = data[0].id;

	const [
		{ data: teamData, error: teamError },
		{ data: participantsData, error: participantsError }
	] = await Promise.all([
		supabase.from('live_feed_team').select().eq('live_feed', liveFeedId).order('title'),
		supabase
			.from('live_feed_participants')
			.select(participantsWithUserDataSelect)
			.eq('live_feed', liveFeedId)
			.order('created_at', { ascending: true })
			.returns<ParticipantsWithUserData[]>()
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
		live_feed: data[0],
		teamData,
		userData: locals.userData,
		participantsData
	};
}
