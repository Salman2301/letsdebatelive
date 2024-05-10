import { PUBLIC_SUPABASE_ANON, PUBLIC_SUPABASE_URL } from "$env/static/public";
import { createClient } from "@supabase/supabase-js";
import type { Database } from "./schema/database.types";

const supabase = createClient<Database>(PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_ANON);

export default supabase;
