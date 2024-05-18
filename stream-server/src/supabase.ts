import { PUBLIC_SUPABASE_ANON, PUBLIC_SUPABASE_URL } from "./env/index";
import { createClient } from "@supabase/supabase-js";
import type { Database } from "./db/schema/database.types";

const supabase = createClient<Database>(PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_ANON);

export default supabase;
