import supabase from "$lib/supabase";
import { authUserData } from "./auth.store";


export async function getUserId() {
  const { data: { session } } = await supabase.auth.getSession();
  return session?.user.id;
}

export async function checkLoginSetStore() {
  const { data: { session } } = await supabase.auth.getSession();
  if (!session) {
    authUserData.set(null);
  }
  else {
    const { data, error } = await supabase.from("user_data").select();
    if (error) {
      authUserData.set(null);
    }
    authUserData.set(data?.[0] || null);
    
  }
}


export async function logoutUser() {
  await supabase.auth.signOut();
  authUserData.set(null);
}

export async function refreshSession() {
  await supabase.auth.refreshSession();
  const { data, error } = await supabase.from("user_data").select();
  if (error) {
    authUserData.set(null);
  }
  authUserData.set(data?.[0] || null);
}
