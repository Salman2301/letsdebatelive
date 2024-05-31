import { getContext } from 'svelte';

import { type SupabaseClient } from '@supabase/supabase-js';
import type { Database } from './schema/database.types';

export function getSupabase(): SupabaseClient<Database> {
	return getContext('lib_supabase');
}
