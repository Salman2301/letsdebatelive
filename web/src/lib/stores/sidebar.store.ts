import { type Writable, writable } from 'svelte/store';

export type SidebarKey =
	| 'screen'
	| 'participants'
	| 'backstage'
	| 'chatLive'
	| 'widget'
	| 'poll'
	| 'qa'
	| 'banner'
	| 'chatModerator'
	| 'broadcast';

export let currentSidebar: Writable<SidebarKey> = writable('widget');
