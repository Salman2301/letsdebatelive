import { createClient } from '@supabase/supabase-js';
import * as readline from 'readline';


if (!process.env.PUBLIC_SUPABASE_URL) throw new Error('PUBLIC_SUPABASE_URL is not defined');
if (!process.env.SUPABASE_SECRET_KEY) throw new Error('PUBLIC_SUPABASE_URL is not defined');

const supabase = createClient(process.env.PUBLIC_SUPABASE_URL, process.env.SUPABASE_SECRET_KEY);


// SQL script to drop all functions and tables in the public schema
const sql = `
-- Drop all functions in the public schema
DO $$ DECLARE
  r RECORD;
BEGIN
  FOR r IN (SELECT proname, oidvectortypes(proargtypes) AS args
            FROM pg_proc
            JOIN pg_namespace ns ON (pg_proc.pronamespace = ns.oid)
            WHERE ns.nspname = 'public') LOOP
    EXECUTE 'DROP FUNCTION IF EXISTS public.' || r.proname || '(' || r.args || ') CASCADE';
  END LOOP;
END $$;

-- Drop all tables in the public schema
DO $$ DECLARE
  r RECORD;
BEGIN
  FOR r IN (SELECT tablename
            FROM pg_tables
            WHERE schemaname = 'public') LOOP
    EXECUTE 'DROP TABLE IF EXISTS public.' || r.tablename || ' CASCADE';
  END LOOP;
END $$;

-- Drop all enum types in the public schema
DO $$ DECLARE
  r RECORD;
BEGIN
  FOR r IN (SELECT t.typname
            FROM pg_type t
            JOIN pg_namespace n ON n.oid = t.typnamespace
            WHERE n.nspname = 'public' AND t.typtype = 'e') LOOP
    EXECUTE 'DROP TYPE IF EXISTS public.' || r.typname || ' CASCADE';
  END LOOP;
END $$;

-- Drop storage policies
DROP POLICY IF EXISTS "anyone can see" ON "storage"."objects";
DROP POLICY IF EXISTS "only auth can insert" ON "storage"."objects";
`;

async function init() {
  const rl = readline.createInterface({
		input: process.stdin,
		output: process.stdout
	});

  rl.question(`Are you sure you want to delete all functions and tables in the public schema on ${process.env.PUBLIC_SUPABASE_URL}? (y/n)`, (answer) => {
    if (answer !== 'y') {
      console.log('Aborted.');
      rl.close();
      return;
    }
    dropAllFunctionsAndTables();
    rl.close();
  });
}

async function dropAllFunctionsAndTables() {
  console.log("Dropping all functions and tables in the public schema...");
  // supabase.
	const { data, error } = await supabase.rpc('execute_sql', { sql });

	if (error) {
		console.error('Error executing SQL:', error);
    if (error.code === "PGRST202") {
      console.info(`


Follow these steps to create a supabase function to continue.

Create a supabase function to continue.
      
1. Goto supabase dashboard and create a new function
2. Name the function 'execute_sql'
3. Add a argument named 'sql' of type 'text'
4. Paste the following code into the function body:
BEGIN
  EXECUTE sql;
END;
5. Click 'Advance' and change the security as 'Definer' instead of 'Invoker'
6. Click 'Save'
`)
    }
	} else {
		console.log('Successfully dropped all functions and tables in the public schema.');
	}
}

init();