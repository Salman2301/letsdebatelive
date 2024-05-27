// See https://kit.svelte.dev/docs/types#app

import type { Database, Tables } from '$lib/schema/database.types';
import type { Session, SupabaseClient, User } from '@supabase/supabase-js';

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
			supabase: SupabaseClient<Database>;
			userData: Tables<'user_data'> | null;
			safeGetSession: () => Promise<
				| {
						session: Session;
						user: User | null;
						userData: Tables<'user_data'> | null;
				  }
				| {
						session: null;
						user: null;
						userData: null;
				  }
			>;
		}
	}

	interface Window {
		webkitAudioContext: typeof AudioContext;
		audioContext: AudioContext;
	}
}

export {};
