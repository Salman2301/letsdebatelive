import type { Tables } from '$lib/schema/database.types';
import type { getContext, setContext } from 'svelte';
import type { Readable, Writable } from 'svelte/store';

// This file contains all the context needed for the control-room page
// Pass the svelte setContext and getContext to the below helper function
// Along with the key and/or value
// To register a new context for control room use below object

type ContextTypes = {
	ctx_table$live_debate: Writable<Tables<'live_debate'> | null>;

	ctx_table$live_debate_participants: Writable<Tables<'live_debate_participants'>[] | null>;

	ctx_table$live_debate_participants_stage: Readable<Tables<'live_debate_participants'>[] | null>;

	ctx_table$live_debate_participants_backstage: Readable<
		Tables<'live_debate_participants'>[] | null
	>;

	ctx_table$live_debate_team: Writable<Tables<'live_debate_team'>[]>;

	ctx_map$teamColor: Readable<Record<string, string>>;
};

export function setControlRoomCtx<T extends keyof ContextTypes>(
	setCtx: typeof setContext,
	key: T,
	value: ContextTypes[T]
): void {
	return setCtx(key, value) as any;
}

export function getControlRoomCtx<T extends keyof ContextTypes>(
	getCtx: typeof getContext,
	key: T
): ContextTypes[T] {
	return getCtx(key) as any;
}
