

if (!process.env.PUBLIC_SUPABASE_ANON) throw new Error(`Missing Env 'PUBLIC_SUPABASE_ANON'`);
if (!process.env.PUBLIC_SUPABASE_URL) throw new Error(`Missing Env 'PUBLIC_SUPABASE_URL'`);
if (!process.env.FRONTEND_URL) throw new Error(`Missing Env 'FRONTEND_URL'`);


export const PUBLIC_SUPABASE_ANON = process.env.PUBLIC_SUPABASE_ANON;
export const PUBLIC_SUPABASE_URL = process.env.PUBLIC_SUPABASE_URL;
export const FRONTEND_URL = process.env.FRONTEND_URL;
