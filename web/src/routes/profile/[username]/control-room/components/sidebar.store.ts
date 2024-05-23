import { type Writable, writable } from "svelte/store";

export const currentSidebar: Writable<string> = writable("backstage");
