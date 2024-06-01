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

drop policy "Atleast co-host" on "public"."live_debate_team";

drop policy "User atleast co-host" on "public"."live_debate_team";

drop policy "user atleast co-host" on "public"."live_debate_team";

drop policy "Atleast mod or the user can see" on "public"."live_host_ban";

drop policy "Only mods can ban" on "public"."live_host_ban";

drop policy "Only mods can delete" on "public"."live_host_ban";

drop policy "Only mods can update" on "public"."live_host_ban";

drop function if exists "public"."user_atleast_co_host_role"(live_debate_id uuid);

drop function if exists "public"."user_atleast_mod_role"(live_debate_id uuid);

drop function if exists "public"."user_is_host_role"(live_debate_id uuid);

create table "public"."live_debate_invite_co_host" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "invited_by" uuid not null,
    "status" text not null,
    "email" text not null,
    "team" uuid not null,
    "live_debate" uuid not null
);


alter table "public"."live_debate_invite_co_host" enable row level security;

CREATE UNIQUE INDEX live_debate_invite_co_host_pkey ON public.live_debate_invite_co_host USING btree (id);

alter table "public"."live_debate_invite_co_host" add constraint "live_debate_invite_co_host_pkey" PRIMARY KEY using index "live_debate_invite_co_host_pkey";

alter table "public"."live_debate_invite_co_host" add constraint "live_debate_invite_co_host_invited_by_live_debate_fkey" FOREIGN KEY (invited_by, live_debate) REFERENCES live_debate_participants(participant_id, live_debate) not valid;

alter table "public"."live_debate_invite_co_host" validate constraint "live_debate_invite_co_host_invited_by_live_debate_fkey";

alter table "public"."live_debate_invite_co_host" add constraint "live_debate_invite_co_host_live_debate_fkey" FOREIGN KEY (live_debate) REFERENCES live_debate(id) not valid;

alter table "public"."live_debate_invite_co_host" validate constraint "live_debate_invite_co_host_live_debate_fkey";

alter table "public"."live_debate_invite_co_host" add constraint "live_debate_invite_co_host_team_fkey" FOREIGN KEY (team) REFERENCES live_debate_team(id) not valid;

alter table "public"."live_debate_invite_co_host" validate constraint "live_debate_invite_co_host_team_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.user_atleast_co_host(live_debate_id uuid)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$BEGIN
  RETURN EXISTS (
    SELECT 1 
    FROM live_debate_participants
    WHERE (SELECT auth.uid() as uid) = participant_id
    AND live_debate = live_debate_id
    AND role IN ('host', 'co-host')
  );
END;$function$
;

CREATE OR REPLACE FUNCTION public.user_atleast_mod(live_debate_id uuid)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$BEGIN
  RETURN EXISTS (
    SELECT 1 
    FROM live_debate_participants
    WHERE (SELECT auth.uid() as uid) = participant_id
    AND live_debate = live_debate_id
    AND role IN ('host', 'co-host', 'mod')
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
    FROM live_debate_participants
    WHERE (SELECT auth.uid() as uid) = participant_id
    AND live_debate = live_debate_id
    AND role IN ('host')
  );
END;$function$
;

grant delete on table "public"."live_debate_invite_co_host" to "anon";

grant insert on table "public"."live_debate_invite_co_host" to "anon";

grant references on table "public"."live_debate_invite_co_host" to "anon";

grant select on table "public"."live_debate_invite_co_host" to "anon";

grant trigger on table "public"."live_debate_invite_co_host" to "anon";

grant truncate on table "public"."live_debate_invite_co_host" to "anon";

grant update on table "public"."live_debate_invite_co_host" to "anon";

grant delete on table "public"."live_debate_invite_co_host" to "authenticated";

grant insert on table "public"."live_debate_invite_co_host" to "authenticated";

grant references on table "public"."live_debate_invite_co_host" to "authenticated";

grant select on table "public"."live_debate_invite_co_host" to "authenticated";

grant trigger on table "public"."live_debate_invite_co_host" to "authenticated";

grant truncate on table "public"."live_debate_invite_co_host" to "authenticated";

grant update on table "public"."live_debate_invite_co_host" to "authenticated";

grant delete on table "public"."live_debate_invite_co_host" to "service_role";

grant insert on table "public"."live_debate_invite_co_host" to "service_role";

grant references on table "public"."live_debate_invite_co_host" to "service_role";

grant select on table "public"."live_debate_invite_co_host" to "service_role";

grant trigger on table "public"."live_debate_invite_co_host" to "service_role";

grant truncate on table "public"."live_debate_invite_co_host" to "service_role";

grant update on table "public"."live_debate_invite_co_host" to "service_role";

create policy "only host can delete"
on "public"."live_debate_invite_co_host"
as permissive
for delete
to authenticated
using (user_is_host(live_debate));


create policy "only host can insert"
on "public"."live_debate_invite_co_host"
as permissive
for insert
to authenticated
with check (user_is_host(live_debate));


create policy "only host can see"
on "public"."live_debate_invite_co_host"
as permissive
for select
to authenticated
using (user_is_host(live_debate));


create policy "only host can update"
on "public"."live_debate_invite_co_host"
as permissive
for update
to authenticated
using (user_is_host(live_debate));


create policy "User not banned"
on "public"."live_debate"
as permissive
for update
to authenticated
using (user_atleast_co_host(id));


create policy "host only"
on "public"."live_debate_audience_team_only"
as permissive
for insert
to authenticated
with check (user_atleast_co_host(live_debate));


create policy "user atleast co-host"
on "public"."live_debate_audience_team_only"
as permissive
for select
to public
using (user_atleast_co_host(live_debate));


create policy "user atleast code-host"
on "public"."live_debate_audience_team_only"
as permissive
for update
to authenticated
using (user_atleast_co_host(live_debate));


create policy "Only mods can delete"
on "public"."live_debate_kick"
as permissive
for delete
to authenticated
using (user_atleast_mod(live_debate));


create policy "Only mods can kick"
on "public"."live_debate_kick"
as permissive
for insert
to authenticated
with check (user_atleast_mod(live_debate));


create policy "Only mods can update"
on "public"."live_debate_kick"
as permissive
for update
to authenticated
using (user_atleast_mod(live_debate));


create policy "Only user and mods can see"
on "public"."live_debate_kick"
as permissive
for select
to authenticated
using ((user_atleast_mod(live_debate) OR (user_id = auth.uid())));


create policy "Delete either by host or current owner"
on "public"."live_debate_participants"
as permissive
for delete
to authenticated
using (((( SELECT auth.uid() AS uid) = participant_id) OR user_atleast_co_host(live_debate)));


create policy "Enable update for users based on user id"
on "public"."live_debate_participants"
as permissive
for update
to authenticated, anon
using (((( SELECT auth.uid() AS uid) = participant_id) OR user_atleast_co_host(live_debate)))
with check (((( SELECT auth.uid() AS uid) = participant_id) OR user_atleast_co_host(live_debate)));


create policy "Atleast co-host"
on "public"."live_debate_team"
as permissive
for insert
to authenticated
with check (user_atleast_co_host(live_debate));


create policy "User atleast co-host"
on "public"."live_debate_team"
as permissive
for update
to authenticated
using (user_atleast_co_host(live_debate));


create policy "user atleast co-host"
on "public"."live_debate_team"
as permissive
for delete
to authenticated
using (user_atleast_co_host(live_debate));


create policy "Atleast mod or the user can see"
on "public"."live_host_ban"
as permissive
for select
to authenticated
using ((user_atleast_mod(live_debate) OR (user_id = auth.uid())));


create policy "Only mods can ban"
on "public"."live_host_ban"
as permissive
for insert
to authenticated
with check (user_atleast_mod(live_debate));


create policy "Only mods can delete"
on "public"."live_host_ban"
as permissive
for delete
to authenticated
using (user_atleast_mod(live_debate));


create policy "Only mods can update"
on "public"."live_host_ban"
as permissive
for update
to authenticated
using (user_atleast_mod(live_debate));



