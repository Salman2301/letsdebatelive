import type { Tables } from "$lib/schema/database.types";
import type { User } from "@supabase/supabase-js";

export interface PageData {
  userJoined: boolean,
  isLoggedIn: boolean,
  user: User | null,
  participants: Tables<"live_debate_participants">[],
  myBackstageInfo: Tables<"live_debate_participants"> | null;
  isJoined: boolean;
}
