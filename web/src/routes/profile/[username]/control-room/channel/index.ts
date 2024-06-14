import type { SupabaseClient } from '@supabase/supabase-js';
import type { ScenePayload } from '$lib/components/video-feed/video-feed.types';

// Trigger on host broadcast start | broadcast stop -> In future
// Future we can use it for paid supporters or YouTube or Facebook only medium
type BroadcastEvent = 'broadcast_start' | 'broadcast_end';

export function emitBroadcastEvent(
	supabase: SupabaseClient,
	event: BroadcastEvent,
	liveFeedId: string,
	payload = {}
) {
	if (!liveFeedId) throw new Error('Invalid liveFeedId id!');
	return supabase.channel(`broadcast_${liveFeedId}`).send({
		type: 'broadcast',
		event: event, // broadcast_suspended broadcast_ended
		payload: payload
	});
}

export function emitSceneChange(
	supabase: SupabaseClient,
	liveFeedId: string,
	payload: ScenePayload
) {
	if (!liveFeedId) throw new Error('Invalid host id!');

	// Scene change also trigger self by default both the host and ghost have read
	return supabase.channel(`scene_${liveFeedId}`, { config: { broadcast: { self: true } } }).send({
		type: 'broadcast',
		event: 'scene_change',
		liveFeedId,
		payload: payload
	});
}
