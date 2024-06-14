import type { Tables } from './schema/database.types';

export const participantsWithUserDataSelect = '*, participant_id(*), team(*)' as const;
export type ParticipantsWithUserData = Omit<
	Tables<'live_feed_participants'>,
	'participant_id' | 'team'
> & { participant_id: Tables<'user_data'>; team: Tables<'live_feed_team'> };

export const chatWithSenderData = '*, sender_id(*)' as const;
export type ChatWithSenderData = Omit<Tables<'live_feed_chat'>, 'sender_id'> & {
	sender_id: Tables<'user_data'>;
};
