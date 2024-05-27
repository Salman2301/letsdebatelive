import { createClient } from '@supabase/supabase-js';

if (!process.env.PUBLIC_SUPABASE_URL) throw new Error('PUBLIC_SUPABASE_URL is not defined');
if (!process.env.SUPABASE_SECRET_KEY) throw new Error('PUBLIC_SUPABASE_URL is not defined');

const supabase = createClient(process.env.PUBLIC_SUPABASE_URL, process.env.SUPABASE_SECRET_KEY);

let { error } = await supabase.rpc('turn_on_realtime');
if (error) {
	console.log(`Sometimes 127.0.0.1 throws error use localhost and try again >`);
	console.error({ error, url: process.env.PUBLIC_SUPABASE_URL });
	throw new Error(error.message);
} else console.log(`Real-time is turned on for 'live_*' table`);
