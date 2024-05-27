import { type SupabaseClient } from '@supabase/supabase-js';
import type { Database } from './schema/database.types';

export function getSupabase(getContext: (key: string) => any): SupabaseClient<Database> {
	return getContext('lib_supabase');
}
