import type { Tables } from "$lib/schema/database.types.js";
import type { User } from "@supabase/supabase-js";
import { fail, redirect } from "@sveltejs/kit";
import type { PageData } from "./page.types";

export async function load({ locals, params }) {

  const PAGE_DATA: PageData = {
    userJoined: false,
    isLoggedIn: false,
    user: null,
    participants: [],
    isJoined: false,
    myBackstageInfo: null
  }
  const supabase = locals.supabase;
  
  const { session, user } = await locals.safeGetSession();
  if (!session|| !session.user) return PAGE_DATA

  // get the live debate id from the username
  // Get all the participant
  // Check if one of the participant match with the userid
  PAGE_DATA.isLoggedIn = true;
  PAGE_DATA.user = session.user;
  let userId = session.user.id;

  const username = params.username;
  if (!username) throw redirect(303, "/?error=INVALID_USERID");
  
  // TODO: get only the published!
  const { data: live_debates, error } = await supabase.from("live_debate").select("*, host(*)").eq("host.username", username)

  const liveDebateId = live_debates?.[0]?.id;

  if (error || live_debates.length === 0 || typeof liveDebateId !== "string" ) {
    throw redirect(303, "/?error=FAILED_LIVE_DEBATE_INFO" );
  }

  const { data: live_debate_participants, error: participantsError } = await supabase.from("live_debate_participants").select("*").eq("live_debate", liveDebateId);

  PAGE_DATA.participants = live_debate_participants || [];
  PAGE_DATA.myBackstageInfo = live_debate_participants?.find(item => item.participant_id === userId) || null;
  PAGE_DATA.isJoined = !!PAGE_DATA.myBackstageInfo;

  return PAGE_DATA;
}


/** @type {import('./$types').Actions} */
export const actions = {
  join_backstage: async ({ locals, request, params }) => {

    const data = await request.formData();

    const supabase = locals.supabase;
    const { user, session, userData } = await locals.safeGetSession();

    const is_anonymous = user?.is_anonymous;
    if (!user && !is_anonymous) return fail(401, { message: "User must be signed in" });

    if (!userData) return  fail(401, { message: "Invalid user info" })

    const username = params.username;

    if( typeof username !== "string" || username === "" ) return fail(404, { message: "Invalid username!"})

      
    const { data: live_debates, error } = await supabase.from("live_debate").select("*, host(*)").eq("host.username", username)

    const liveDebateId = live_debates?.[0]?.id;

    if (error || live_debates.length === 0 || typeof liveDebateId !== "string" ) {
      return fail(404, { messagae: "Failed to get the live_debate info from db"} );
    }

    const toInsert = {
      live_debate: liveDebateId,
      participant_id: userData?.id,
      is_host: liveDebateId === live_debates[0].host,
      location: "backstage",
      display_name: userData?.username as string,
      team: "5932f887-2683-4489-b659-2024f57fd80d", // must get from the formdata
    } as const;
    const { data: insert, error: errorInsert } = await supabase.from("live_debate_participants")
      .insert(toInsert)
      .select("*");
    
    if (errorInsert) {
      return fail(404, { message: "Bad request sent", errorInsert });
    }

    return { success: true }
  },
  leave_backstage: async ({ locals, request, params }) => {

    const data = await request.formData();

    const supabase = locals.supabase;
    const { user, session, userData } = await locals.safeGetSession();

    const is_anonymous = user?.is_anonymous;
    if (!user || is_anonymous) return fail(401, { message: "User must be signed in" });

    if (!userData) return  fail(401, { message: "Invalid user info" })

    const username = params.username;

    if( typeof username !== "string" || username === "" ) return fail(404, { message: "Invalid username!"})

      
    const { data: live_debates, error } = await supabase.from("live_debate").select("*, host(*)").eq("host.username", username)

    const liveDebateId = live_debates?.[0]?.id;

    if (error || live_debates.length === 0 || typeof liveDebateId !== "string" ) {
      return fail(404, { messagae: "Failed to get the live_debate info from db"} );
    }

    const { data: removed, error: errorRemoved } = await supabase.from("live_debate_participants")
      .delete()
      .eq("live_debate", liveDebateId)
      .eq("participant_id", user.id)
  
    if (errorRemoved) {
      return fail(404, { message: "Bad request sent", errorRemoved });
    }

    return { success: true }
	}
};


