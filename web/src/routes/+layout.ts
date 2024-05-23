import { PUBLIC_SUPABASE_ANON_KEY, PUBLIC_SUPABASE_URL } from '$env/static/public';
import { createBrowserClient, isBrowser, parse } from '@supabase/ssr';

import type { Database, Tables } from '$lib/schema/database.types';
import type { LayoutLoad } from './$types';

export const load: LayoutLoad = async ({ fetch, data, depends }) => {
  depends('supabase:auth');

  const supabase = createBrowserClient<Database>(PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_ANON_KEY, {
    global: {
      fetch,
    },
    cookies: {
      get(key) {
        if (!isBrowser()) {
          return JSON.stringify(data.session)
        }

        const cookie = parse(document.cookie)
        return cookie[key]
      },
    },
  })

  /**
   * It's fine to use `getSession` here, because on the client, `getSession` is
   * safe, and on the server, it reads `session` from the `LayoutData`, which
   * safely checked the session using `safeGetSession`.
   */
  const {
    data: { session },
  } = await supabase.auth.getSession()

  let userData: Tables<"user_data"> | null = null;

  if (session?.user) {
    const { data, error: userDataError } = await supabase.from("user_data").select().eq("id", session?.user?.id as string).single(); 
    if (userDataError) {
      
      const email = session.user.email as string;
      const { data } = await supabase.from("user_data").insert({
        username: email,
        email: email,
      }).select().single();

      userData = data;
      

    } else {
      userData = data;
    }
    
  }

  return { supabase, session, userData }
}