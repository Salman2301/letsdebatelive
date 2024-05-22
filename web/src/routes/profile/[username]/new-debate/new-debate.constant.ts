import type { Tables } from "$lib/schema/database.types";
import type { Writable } from "svelte/store";

export const CTX_KEY_NEW_DEBATE = "CTX_KEY_NEW_DEBATE"; 
export const CTX_KEY_HOST_PARTICIPANT = "CTX_KEY_HOST_PARTICIPANT"; 
export const CTX_KEY_TITLE = "CTX_KEY_TITLE"; 


export type CTX_KEY_NEW_DEBATE_TYPE = Writable<Partial<Tables<"live_debate">>> | null;
export type CTX_KEY_HOST_PARTICIPANT_TYPE = Writable<Partial<Tables<"live_debate_participants">>> | null;
export type CTX_KEY_TITLE_TYPE = Writable<string> | null;
