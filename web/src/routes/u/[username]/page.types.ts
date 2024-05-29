import type { Tables } from '$lib/schema/database.types';
import type { User } from '@supabase/supabase-js';

export interface PageData {
	userJoined: boolean;
	isLoggedIn: boolean;
	user: User | null; // TODO: why do we need to send user, should it not be userData
	live_debate: Tables<'live_debate'> | null;
	participants: Tables<'live_debate_participants'>[];
	myBackstageInfo: Tables<'live_debate_participants'> | null;
	isJoined: boolean;
	teams: Tables<"live_debate_team">[] | [];
	teamMapColor: Record<string, string>;
	host: Tables<"user_data"> | null;
}
