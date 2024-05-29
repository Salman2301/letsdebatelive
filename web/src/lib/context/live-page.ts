import { getContext, setContext } from 'svelte';

import type { Readable, Writable } from 'svelte/store';
import type { PageData } from '../../routes/u/[username]/$types';
import type { ParticipantsWithUserData } from '$src/routes/u/[username]/page.types';

// This file contains all the context needed for the live-room page
// Pass the svelte setContext and getContext to the below helper function
// Along with the key and/or value
// To register a new context for control room use below object

type ContextTypes = {
	pageDataProps: PageData;
	myBackstageInfo: Writable<ParticipantsWithUserData | null >
};

export function setLiveRoomCtx<T extends keyof ContextTypes>(
	key: T,
	value: ContextTypes[T]
): void {
	return setContext(key, value) as any;
}

export function getLiveRoomCtx<T extends keyof ContextTypes>(
	key: T
): ContextTypes[T] {
	return getContext(key) as any;
}
