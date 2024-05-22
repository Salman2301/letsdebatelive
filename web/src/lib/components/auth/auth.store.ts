import type { Tables } from "$lib/schema/database.types";
import { derived, writable, type Readable, type Writable } from "svelte/store";

export const authUserData: Writable<Tables<"user_data"> | null> = writable(null); 

export const isLoggedIn: Readable<boolean> = derived(authUserData, $authUserData=>!!$authUserData);
