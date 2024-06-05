import type { Tables } from '$lib/schema/database.types';
import type { ParticipantsWithUserData } from '$src/lib/types';
import type { Readable, Writable } from 'svelte/store';

export type ContextTypes = {
	ctx_table$live_debate: Writable<Tables<'live_debate'> | null>;

	ctx_table$live_debate_participants: Writable<ParticipantsWithUserData[] | null>;

	ctx_table$live_debate_participants_stage: Readable<ParticipantsWithUserData[] | null>;

	ctx_table$live_debate_participants_backstage: Readable<
		ParticipantsWithUserData[] | null
	>;

	ctx_table$live_debate_team: Writable<Tables<'live_debate_team'>[]>;

	ctx_map$teamColor: Readable<Record<string, string>>;
};
