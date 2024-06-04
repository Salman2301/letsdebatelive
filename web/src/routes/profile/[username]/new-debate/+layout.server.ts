import { redirect } from '@sveltejs/kit';

export async function load({ locals, params, parent }) {
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
    throw redirect(303, `/profile/${pathUsername}/control-room?error=DEBATE_EXIST`)
  }

}
