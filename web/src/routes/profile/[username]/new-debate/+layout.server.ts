import { SUPABASE_SECRET_KEY } from '$env/static/private';
import { PUBLIC_SUPABASE_URL } from '$env/static/public';
import { createClient, type SupabaseClient } from '@supabase/supabase-js';
import { redirect } from '@sveltejs/kit';
import type { Database, Tables } from '$src/lib/schema/database.types';

const supabaseAdmin = createClient<Database>(PUBLIC_SUPABASE_URL, SUPABASE_SECRET_KEY); 

type ReturnCreateLiveDebate = {
  liveDebate: Tables<'live_debate'> | null;
  hostParticipant: Tables<'live_debate_participants'> | null;
}

export async function load({ locals, params, parent }): Promise<ReturnCreateLiveDebate> {
  await parent();
  const supabase = locals.supabase;

  const { userData} = await locals.safeGetSession();
  const pathUsername = params.username;

  if (!pathUsername || !userData) throw redirect(303, '/?error=INVALID_USERNAME');

  if (pathUsername !== userData.username) throw redirect(303, '/?error=FORBIDDEN_USERNAME');


	// TODO: check only for published VOD
	// check username against the live debate and get the live debate
	const { data, error } = await supabase
		.from('live_debate')
		.select('*, host(*)')
		.eq('host.username', userData.username)
    .not('host', 'is', null)
		.not('published', 'is', null)
    .not("ended", 'is', true);

  if (data && data?.length > 0) {
    // Redirect to the control room, If there is a live debate exist

    throw redirect(303, `/profile/${pathUsername}/control-room?error=DEBATE_EXIST`)
  }

  const { data: oldLiveDebateData , error: oldLiveDebateError } = await oldLiveDebate(supabase, userData);
  if (oldLiveDebateData) return oldLiveDebateData;

  const { data: newLiveDebate, error: newLiveDebateError } = await supabase
    .from('live_debate')
    .insert({
      host: userData.id
    })
    .select();
  if (!newLiveDebate?.[0]?.id) return { liveDebate: null, hostParticipant: null };

  const liveDebateId = newLiveDebate[0].id;

  const { data: hostData, error: hostDataError} = await supabase
    .from('live_debate_participants')
    .insert({
      participant_id: userData.id,
      role: 'host',
      live_debate: liveDebateId,
      display_name: userData.displayName || "",
      location: "stage",
    })
    .select();
  
  const { error: roleError } = await supabaseAdmin
    .from('live_debate_participant_role')
    .insert({
      live_debate: liveDebateId,
      participant_id: userData.id,
      role: 'host',
    });
  
  if (roleError || newLiveDebateError || hostDataError || !hostData?.[0]?.participant_id || !newLiveDebate || !hostData) {
    console.error(roleError, newLiveDebateError, hostDataError, hostData);
    throw redirect(303, `/?error=FAILED_TO_CREATE_OR_FETCH_LIVE_DEBATE`);
  }

  return { liveDebate: newLiveDebate[0], hostParticipant: hostData[0] };
}

async function oldLiveDebate(supabase: SupabaseClient<Database>, userData: Tables<"user_data">)
  : Promise<{ data: ReturnCreateLiveDebate | null ; error: any }> {
  const { data: oldLiveDebates, error } = await supabase
    .from('live_debate')
    .select('*, host(*)')
    .eq('host.username', userData.username)
    .not('host', 'is', null)
    .not('published', 'is', true)
    .order('created_at', { ascending: false });
  
  if (error) return { data: null, error };
  
  const liveDebateId = oldLiveDebates?.[0]?.id;
  if (!liveDebateId) return { data: null, error };

  if (oldLiveDebates.length > 1) {
    console.error("corrupted-data: Multiple live debates found");
    // Mark the old live debates as ended except the first one
    const expiredLiveDebate = oldLiveDebates.slice(1).map((liveDebate) => liveDebate.id);
    await supabaseAdmin
      .from('live_debate')
      .update({ ended: true, ended_tz: new Date().toISOString() })
      .in('id',expiredLiveDebate);
  }
  
  const { data: hostData, error: hostDataError } = await supabase
    .from('live_debate_participants')
    .select()
    .eq("participant_id", userData.id)
    .eq("role", "host")
    .eq("live_debate", liveDebateId);
  
  const { error: roleError } = await supabaseAdmin
    .from('live_debate_participant_role')
    .select()
    .eq('live_debate', liveDebateId)
    .eq('participant_id', userData.id)
    .eq('role', 'host')
    .single();
  
  if( roleError || hostDataError || !hostData?.[0]?.participant_id || !hostData) {
    console.error(roleError, hostDataError, hostData);
    return { data: null, error };
  }

  return { data: { liveDebate: oldLiveDebates[0], hostParticipant: hostData[0] }, error: null };
}
