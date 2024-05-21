set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.turn_on_realtime()
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
row record;
BEGIN
FOR row IN SELECT tablename FROM pg_tables AS t
WHERE t.schemaname = 'public'
AND t.tablename LIKE 'live_%'
LOOP
    -- Check if the table is already part of the publication
    IF NOT EXISTS (
        SELECT 1 FROM pg_publication_tables
        WHERE pubname = 'supabase_realtime' 
        AND schemaname = 'public'
        AND tablename = row.tablename
    ) THEN
        -- Run query to add table to publication
        EXECUTE format('ALTER PUBLICATION supabase_realtime ADD TABLE %I;', row.tablename);
    END IF;
END LOOP;
RETURN 'success';
END;
$function$
;