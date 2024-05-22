import { v4 as uuid } from "uuid";
import type { Tables } from "$lib/schema/database.types";

type CallBackParticipant = (participant: Tables<"live_debate_participants">) => void

interface onParticpantChangeReturn {
  participantSubId: string;
  destroy: () => void;
};
interface ParticipantSubList {
  [participantSubId: string]: CallBackParticipant;
}

export let registeredCallBacks: Record<string, ParticipantSubList> = {};

export function onParticpantChange(id: string, cb: CallBackParticipant):onParticpantChangeReturn {
  const participantSubId = uuid();
  
  if (!registeredCallBacks[id]) registeredCallBacks[id] = {};
  registeredCallBacks[id][participantSubId] = cb;

  return {
    participantSubId,
    destroy: () => {
      delete registeredCallBacks[id]?.[participantSubId];
    }
  }
}

export function triggerParticipantChange(id: string, participant: Tables<"live_debate_participants">) {
  if (registeredCallBacks[id]) {
    for (const cb of Object.values(registeredCallBacks[id])) {
      cb(participant);
    }
  }
}
