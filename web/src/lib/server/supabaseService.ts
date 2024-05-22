import { SUPABASE_SECRET_KEY } from "$env/static/private";
import { PUBLIC_SUPABASE_URL } from "$env/static/public";
import type { Database } from "$lib/schema/database.types";
import { createClient } from "@supabase/supabase-js";

const supabase = createClient<Database>(PUBLIC_SUPABASE_URL, SUPABASE_SECRET_KEY);

export default supabase;
