import { PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_ANON_KEY } from '$env/static/public'
import { createServerClient } from '@supabase/ssr'
import { redirect, type Handle } from '@sveltejs/kit'

export const handle: Handle = async ({ event, resolve }) => {
  event.locals.supabase = createServerClient(PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_ANON_KEY, {
    cookies: {
      get: (key) => event.cookies.get(key),
      /**
       * Note: You have to add the `path` variable to the
       * set and remove method due to sveltekit's cookie API
       * requiring this to be set, setting the path to an empty string
       * will replicate previous/standard behaviour (https://kit.svelte.dev/docs/types#public-types-cookies)
       */
      set: (key, value, options) => {
        event.cookies.set(key, value, { ...options, path: '/' })
      },
      remove: (key, options) => {
        event.cookies.delete(key, { ...options, path: '/' })
      },
    },
  })

  /**
   * Unlike `supabase.auth.getSession()`, which returns the session _without_
   * validating the JWT, this function also calls `getUser()` to validate the
   * JWT before returning the session.
   */
  event.locals.safeGetSession = async () => {
    const {
      data: { session },
    } = await event.locals.supabase.auth.getSession()
    if (!session) {
      return { session: null, user: null, userData: null }
    }

    const {
      data: { user },
      error,
    } = await event.locals.supabase.auth.getUser();

    if (!user) {
      await event.locals.supabase.auth.signOut();
      return { session: null, user: null, userData: null };
    }

    const { data: userData, error: userDataError } = await event.locals.supabase.from("user_data").select().eq("id", user?.id as string).single();
    if (error || userDataError) {
      // JWT validation has failed
      return { session: null, user: null, userData: null }
    }

    return { session, user, userData }
  }


  const { session, user, userData } = await event.locals.safeGetSession();

  if (event.url.pathname.startsWith("/profile") &&  !event.url.pathname.startsWith("/profile/logout")) {
    if (!session || !session.user || !user || !userData ) throw redirect(303, "/");

    if (event.params.username !== userData.username) {
      throw redirect(303, "/?ERROR=USERNAME_MISMATCH");
    } 
  }

  return resolve(event, {
    filterSerializedResponseHeaders(name) {
      return name === 'content-range' || name === 'x-supabase-api-version'
    },
  })
}