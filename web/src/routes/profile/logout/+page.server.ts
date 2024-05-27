import { redirect } from '@sveltejs/kit';

export async function load({ locals, cookies }) {
	await locals.supabase.auth.signOut();
	cookies.delete('sb:token', { path: '/' });
	throw redirect(303, `/?${Date.now()}`);
}
