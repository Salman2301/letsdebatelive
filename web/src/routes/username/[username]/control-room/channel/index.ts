import supabase from "$lib/supabase";
import type { ScenePayload } from "../components/videoFeed/video-feed.types";


// Trigger on host broadcast start | broadcast stop -> In future
// Future we can use it for paid supporters or YouTube or Facebook only medium
type BroadcastEvent = "broadcast_start" | "broadcast_end";

export function emitBroadcastEvent(event: BroadcastEvent, hostId: string, payload = {}) {
  if (!hostId) throw new Error("Invalid host id!");
  
  return supabase.channel(`broadcast_${hostId}`).send({
    type: "broadcast",
    event: event,// broadcast_suspended broadcast_ended
    payload: payload
  });
}


export function emitSceneChange(hostId: string, payload: ScenePayload) {
  if (!hostId) throw new Error("Invalid host id!");
  
  // Scene change also trigger self by default both the host and ghost have read
  return supabase.channel(`scene_${hostId}`, { config: {broadcast: {self: true }}}).send({
    type: "broadcast",
    event: "scene_change",
    payload: payload
  });
}

