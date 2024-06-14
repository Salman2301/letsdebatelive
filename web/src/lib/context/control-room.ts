import type { Tables } from '$lib/schema/database.types';
import type { ParticipantsWithUserData } from '$src/lib/types';
import type { Readable, Writable } from 'svelte/store';

export type ContextTypes = {
	ctx_table$live_feed: Writable<Tables<'live_feed'> | null>;

	ctx_table$live_feed_participants: Writable<ParticipantsWithUserData[] | null>;

	ctx_table$live_feed_participants_stage: Readable<ParticipantsWithUserData[] | null>;

	ctx_table$live_feed_participants_backstage: Readable<ParticipantsWithUserData[] | null>;

	ctx_table$live_feed_team: Writable<Tables<'live_feed_team'>[]>;

	ctx_map$teamColor: Readable<Record<string, string>>;
};
