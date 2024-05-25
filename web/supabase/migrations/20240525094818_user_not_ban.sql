drop policy "Enable insert for authenticated users only" on "public"."live_debate";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.user_not_banned()
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$BEGIN
  RETURN NOT EXISTS (
    SELECT 1 
    FROM live_user_ban
    WHERE (SELECT auth.uid()) = user_id
  );
END;$function$
;

create policy "Enable read access for all users"
on "public"."live_user_ban"
as permissive
for select
to authenticated
using (( SELECT (auth.uid() = live_user_ban.user_id)));


create policy "Enable insert for authenticated users only"
on "public"."live_debate"
as permissive
for insert
to authenticated
with check (user_not_banned());



