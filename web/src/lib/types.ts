import type { Tables } from "./schema/database.types";

export const participantsWithUserDataSelect = "*, participant_id(*), team(*)" as const;
export type ParticipantsWithUserData = Omit<Tables<"live_debate_participants">, 'participant_id' | 'team'> & { participant_id: Tables<"user_data">;  team: Tables<"live_debate_team">}