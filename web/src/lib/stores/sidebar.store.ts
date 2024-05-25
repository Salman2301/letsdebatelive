import { type Writable, writable } from "svelte/store";

export type SidebarKey =
| 'participants'
| 'backstage'
| 'chatLive'
| 'agenda'
| 'poll'
| 'qa'
| 'banner'
| 'chatModerator'
| 'broadcast';

export let currentSidebar: Writable<SidebarKey> = writable('backstage');
