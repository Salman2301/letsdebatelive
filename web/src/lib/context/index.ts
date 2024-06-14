import { getContext, setContext } from 'svelte';

import type { ContextTypes as ControlRoomCtx } from './control-room';
import type { ContextTypes as LiveCtx } from './live-page';
import type { ContextTypes as NewFeedCtx } from './new-feed';

// This file contains all the context needed for the +page
// Create the context type in a new file and import it here
// add the type to below `AllPageCtx`

type AllPageCtx = {
	live: LiveCtx;
	'new-feed': NewFeedCtx;
	'control-room': ControlRoomCtx;
};

export class PageCtx<T extends keyof AllPageCtx> {
	page: T;
	constructor(page: T) {
		this.page = page;
	}

	set(obj: AllPageCtx[T]) {
		for (const [key, value] of Object.entries(obj)) {
			setContext(key, value);
		}
	}

	get<K extends keyof AllPageCtx[T]>(key: K): AllPageCtx[T][K] {
		return getContext(key);
	}
}
