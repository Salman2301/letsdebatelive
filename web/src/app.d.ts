// See https://kit.svelte.dev/docs/types#app

import type { SupabaseClient, User } from "@supabase/supabase-js";

// for information about these interfaces
declare global {
	namespace App {
		// interface Error {}
		// interface Locals {}
		// interface PageData {}
		// interface PageState {}
		// interface Platform {}
		interface Locals {
			user: User | null;
			supabase: SupabaseClient;
		}
	}

	interface Window {
		webkitAudioContext: typeof AudioContext;
		audioContext:  AudioContext;
	}

}

export {};
