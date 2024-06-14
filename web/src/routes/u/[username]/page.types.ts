import type { Tables } from '$lib/schema/database.types';
import type { ParticipantsWithUserData } from '$src/lib/types';
import type { User } from '@supabase/supabase-js';

export interface PageData {
	userJoined: boolean;
	isLoggedIn: boolean;
	user: User | null; // TODO: why do we need to send user, should it not be userData
	live_feed: Tables<'live_feed'> | null;
	participants: ParticipantsWithUserData[];
	myBackstageInfo: ParticipantsWithUserData | null;
	isJoined: boolean;
	teams: Tables<'live_feed_team'>[] | [];
	teamMapColor: Record<string, string>;
	host: Tables<'user_data'> | null;
}
