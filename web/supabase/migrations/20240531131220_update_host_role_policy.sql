drop policy "User not banned" on "public"."live_debate";

drop policy "host only" on "public"."live_debate_audience_team_only";

drop policy "user atleast co-host" on "public"."live_debate_audience_team_only";

drop policy "user atleast code-host" on "public"."live_debate_audience_team_only";

drop policy "Only mods can delete" on "public"."live_debate_kick";

drop policy "Only mods can kick" on "public"."live_debate_kick";

drop policy "Only mods can update" on "public"."live_debate_kick";

drop policy "Only user and mods can see" on "public"."live_debate_kick";

drop policy "Delete either by host or current owner" on "public"."live_debate_participants";

drop policy "Enable update for users based on user id" on "public"."live_debate_participants";

drop policy "Only host can delete" on "public"."live_debate_roles";

drop policy "Only host can insert" on "public"."live_debate_roles";

drop policy "Only host can update" on "public"."live_debate_roles";

drop policy "Atleast co-host" on "public"."live_debate_team";

drop policy "User atleast co-host" on "public"."live_debate_team";

drop policy "user atleast co-host" on "public"."live_debate_team";

drop policy "Atleast mod or the user can see" on "public"."live_host_ban";

drop policy "Only mods can ban" on "public"."live_host_ban";

drop policy "Only mods can delete" on "public"."live_host_ban";

drop policy "Only mods can update" on "public"."live_host_ban";

drop function if exists "public"."user_atleast_co_host"(live_debate_id uuid);

drop function if exists "public"."user_atleast_mod"(live_debate_id uuid);

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.user_atleast_co_host_role(live_debate_id uuid)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$BEGIN
  RETURN EXISTS (
    SELECT 1 
    FROM live_debate_roles
    WHERE (SELECT auth.uid() as uid) = user_id 
    AND live_debate = live_debate_id
    AND role IN ('host', 'co-host')
  );
END;$function$
;

CREATE OR REPLACE FUNCTION public.user_atleast_mod_role(live_debate_id uuid)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$BEGIN
  RETURN EXISTS (
    SELECT 1 
    FROM live_debate_roles
    WHERE (SELECT auth.uid() as uid) = user_id 
    AND live_debate = live_debate_id
  );
END;$function$
;

CREATE OR REPLACE FUNCTION public.user_is_host(live_debate_id uuid)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$BEGIN
  RETURN EXISTS (
    SELECT 1
    FROM live_debate
    WHERE host = auth.uid()
    AND id = live_debate_id
  );
END;$function$
;

CREATE OR REPLACE FUNCTION public.user_not_banned()
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$BEGIN
  RETURN NOT EXISTS (
    SELECT 1 
    FROM live_user_ban
    WHERE (SELECT auth.uid() as uid) = user_id
  );
END;$function$
;

create policy "User not banned"
on "public"."live_debate"
as permissive
for update
to authenticated
using (user_atleast_co_host_role(id));


create policy "host only"
on "public"."live_debate_audience_team_only"
as permissive
for insert
to authenticated
with check (user_atleast_co_host_role(live_debate));


create policy "user atleast co-host"
on "public"."live_debate_audience_team_only"
as permissive
for select
to public
using (user_atleast_co_host_role(live_debate));


create policy "user atleast code-host"
on "public"."live_debate_audience_team_only"
as permissive
for update
to authenticated
using (user_atleast_co_host_role(live_debate));


create policy "Only mods can delete"
on "public"."live_debate_kick"
as permissive
for delete
to authenticated
using (user_atleast_mod_role(live_debate));


create policy "Only mods can kick"
on "public"."live_debate_kick"
as permissive
for insert
to authenticated
with check (user_atleast_mod_role(live_debate));


create policy "Only mods can update"
on "public"."live_debate_kick"
as permissive
for update
to authenticated
using (user_atleast_mod_role(live_debate));


create policy "Only user and mods can see"
on "public"."live_debate_kick"
as permissive
for select
to authenticated
using ((user_atleast_mod_role(live_debate) OR (user_id = auth.uid())));


create policy "Delete either by host or current owner"
on "public"."live_debate_participants"
as permissive
for delete
to authenticated
using (((( SELECT auth.uid() AS uid) = participant_id) OR user_atleast_co_host_role(live_debate)));


create policy "Enable update for users based on user id"
on "public"."live_debate_participants"
as permissive
for update
to authenticated, anon
using (((( SELECT auth.uid() AS uid) = participant_id) OR user_atleast_co_host_role(live_debate)))
with check (((( SELECT auth.uid() AS uid) = participant_id) OR user_atleast_co_host_role(live_debate)));


create policy "Only host can delete"
on "public"."live_debate_roles"
as permissive
for delete
to authenticated
using ((user_is_host(live_debate) OR user_atleast_co_host_role(live_debate)));


create policy "Only host can insert"
on "public"."live_debate_roles"
as permissive
for insert
to authenticated
with check ((user_is_host(live_debate) OR user_atleast_co_host_role(live_debate)));


create policy "Only host can update"
on "public"."live_debate_roles"
as permissive
for update
to authenticated
using ((user_is_host(live_debate) OR user_atleast_co_host_role(live_debate)));


create policy "Atleast co-host"
on "public"."live_debate_team"
as permissive
for insert
to authenticated
with check (user_atleast_co_host_role(live_debate));


create policy "User atleast co-host"
on "public"."live_debate_team"
as permissive
for update
to authenticated
using (user_atleast_co_host_role(live_debate));


create policy "user atleast co-host"
on "public"."live_debate_team"
as permissive
for delete
to authenticated
using (user_atleast_co_host_role(live_debate));


create policy "Atleast mod or the user can see"
on "public"."live_host_ban"
as permissive
for select
to authenticated
using ((user_atleast_mod_role(live_debate) OR (user_id = auth.uid())));


create policy "Only mods can ban"
on "public"."live_host_ban"
as permissive
for insert
to authenticated
with check (user_atleast_mod_role(live_debate));


create policy "Only mods can delete"
on "public"."live_host_ban"
as permissive
for delete
to authenticated
using (user_atleast_mod_role(live_debate));


create policy "Only mods can update"
on "public"."live_host_ban"
as permissive
for update
to authenticated
using (user_atleast_mod_role(live_debate));



