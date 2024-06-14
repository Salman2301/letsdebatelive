import type { Writable } from 'svelte/store';
import type { Tables } from '../schema/database.types';

export type ContextTypes = {
	liveFeed: Writable<Tables<'live_feed'> | null>;
	hostParticipant: Writable<Tables<'live_feed_participants'> | null>;
	teams: Writable<Tables<'live_feed_team'>[]>;
	title: Writable<string>;
	inviteCohost: Writable<Tables<'live_feed_invite_co_host'>[]>;
};
