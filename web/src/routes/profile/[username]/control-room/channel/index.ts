import type { SupabaseClient } from '@supabase/supabase-js';
import type { ScenePayload } from '$lib/components/video-feed/video-feed.types';

// Trigger on host broadcast start | broadcast stop -> In future
// Future we can use it for paid supporters or YouTube or Facebook only medium
type BroadcastEvent = 'broadcast_start' | 'broadcast_end';

export function emitBroadcastEvent(
	supabase: SupabaseClient,
	event: BroadcastEvent,
	liveDebateId: string,
	payload = {}
) {
	if (!liveDebateId) throw new Error('Invalid liveDebateId id!');
	return supabase.channel(`broadcast_${liveDebateId}`).send({
		type: 'broadcast',
		event: event, // broadcast_suspended broadcast_ended
		payload: payload
	});
}

export function emitSceneChange(
	supabase: SupabaseClient,
	liveDebateId: string,
	payload: ScenePayload
) {
	if (!liveDebateId) throw new Error('Invalid host id!');

	// Scene change also trigger self by default both the host and ghost have read
	return supabase.channel(`scene_${liveDebateId}`, { config: { broadcast: { self: true } } }).send({
		type: 'broadcast',
		event: 'scene_change',
		liveDebateId,
		payload: payload
	});
}
