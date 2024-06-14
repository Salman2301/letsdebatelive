import { SUPABASE_SECRET_KEY } from '$env/static/private';
import { PUBLIC_SUPABASE_URL } from '$env/static/public';
import { createClient, type SupabaseClient } from '@supabase/supabase-js';
import { redirect } from '@sveltejs/kit';
import type { Database, Tables } from '$src/lib/schema/database.types';

const supabaseAdmin = createClient<Database>(PUBLIC_SUPABASE_URL, SUPABASE_SECRET_KEY);

type ReturnCreateLiveFeed = {
	liveFeed: Tables<'live_feed'> | null;
	hostParticipant: Tables<'live_feed_participants'> | null;
};

export async function load({ locals, params, parent }): Promise<ReturnCreateLiveFeed> {
	await parent();
	const supabase = locals.supabase;

	const { userData } = await locals.safeGetSession();
	const pathUsername = params.username;

	if (!pathUsername || !userData) throw redirect(303, '/?error=INVALID_USERNAME');

	if (pathUsername !== userData.username) throw redirect(303, '/?error=FORBIDDEN_USERNAME');

	// TODO: check only for published VOD
	// check username against the live feed and get the live feed
	const { data, error } = await supabase
		.from('live_feed')
		.select('*, host(*)')
		.eq('host.username', userData.username)
		.not('host', 'is', null)
		.not('published', 'is', null)
		.not('ended', 'is', true);

	if (data && data?.length > 0) {
		// Redirect to the control room, If there is a live feed exist

		throw redirect(303, `/profile/${pathUsername}/control-room?error=DEBATE_EXIST`);
	}

	const { data: oldLiveFeedData, error: oldLiveFeedError } = await oldLiveFeed(supabase, userData);
	if (oldLiveFeedData) return oldLiveFeedData;

	const { data: newLiveFeed, error: newLiveFeedError } = await supabase
		.from('live_feed')
		.insert({
			host: userData.id
		})
		.select();
	if (!newLiveFeed?.[0]?.id) return { liveFeed: null, hostParticipant: null };

	const liveFeedId = newLiveFeed[0].id;

	const { data: hostData, error: hostDataError } = await supabase
		.from('live_feed_participants')
		.insert({
			participant_id: userData.id,
			role: 'host',
			live_feed: liveFeedId,
			display_name: userData.displayName || '',
			location: 'stage'
		})
		.select();

	const { data: newHostRole, error: roleError } = await supabaseAdmin
		.from('live_feed_user_role')
		.insert({
			live_feed: liveFeedId,
			user_id: userData.id,
			role: 'host'
		})
		.select();
	console.error(JSON.stringify(roleError, null, 4));
	if (
		roleError ||
		newLiveFeedError ||
		hostDataError ||
		!hostData?.[0]?.participant_id ||
		!newLiveFeed ||
		!hostData
	) {
		console.error(roleError, newLiveFeedError, hostDataError, hostData);
		throw redirect(303, `/?error=FAILED_TO_CREATE_OR_FETCH_live_feed`);
	}

	return { liveFeed: newLiveFeed[0], hostParticipant: hostData[0] };
}

async function oldLiveFeed(
	supabase: SupabaseClient<Database>,
	userData: Tables<'user_data'>
): Promise<{ data: ReturnCreateLiveFeed | null; error: any }> {
	const { data: oldLiveFeeds, error } = await supabase
		.from('live_feed')
		.select('*, host(*)')
		.eq('host.username', userData.username)
		.not('host', 'is', null)
		.not('published', 'is', true)
		.order('created_at', { ascending: false });

	if (error) return { data: null, error };

	const liveFeedId = oldLiveFeeds?.[0]?.id;
	if (!liveFeedId) return { data: null, error };

	if (oldLiveFeeds.length > 1) {
		console.error('corrupted-data: Multiple live feeds found');
		// Mark the old live feeds as ended except the first one
		const expiredLiveFeed = oldLiveFeeds.slice(1).map((liveFeed) => liveFeed.id);
		await supabaseAdmin
			.from('live_feed')
			.update({ ended: true, ended_tz: new Date().toISOString() })
			.in('id', expiredLiveFeed);
	}

	const { data: hostData, error: hostDataError } = await supabase
		.from('live_feed_participants')
		.select()
		.eq('participant_id', userData.id)
		.eq('role', 'host')
		.eq('live_feed', liveFeedId);

	const { error: roleError } = await supabaseAdmin
		.from('live_feed_user_role')
		.select()
		.eq('live_feed', liveFeedId)
		.eq('user_id', userData.id)
		.eq('role', 'host')
		.single();

	if (roleError || hostDataError || !hostData?.[0]?.participant_id || !hostData) {
		console.error(roleError, hostDataError, hostData);
		return { data: null, error };
	}

	return { data: { liveFeed: oldLiveFeeds[0], hostParticipant: hostData[0] }, error: null };
}
