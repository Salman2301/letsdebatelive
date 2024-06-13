revoke delete on table "public"."live_debate_participant_role" from "anon";

revoke insert on table "public"."live_debate_participant_role" from "anon";

revoke references on table "public"."live_debate_participant_role" from "anon";

revoke select on table "public"."live_debate_participant_role" from "anon";

revoke trigger on table "public"."live_debate_participant_role" from "anon";

revoke truncate on table "public"."live_debate_participant_role" from "anon";

revoke update on table "public"."live_debate_participant_role" from "anon";

revoke delete on table "public"."live_debate_participant_role" from "authenticated";

revoke insert on table "public"."live_debate_participant_role" from "authenticated";

revoke references on table "public"."live_debate_participant_role" from "authenticated";

revoke select on table "public"."live_debate_participant_role" from "authenticated";

revoke trigger on table "public"."live_debate_participant_role" from "authenticated";

revoke truncate on table "public"."live_debate_participant_role" from "authenticated";

revoke update on table "public"."live_debate_participant_role" from "authenticated";

revoke delete on table "public"."live_debate_participant_role" from "service_role";

revoke insert on table "public"."live_debate_participant_role" from "service_role";

revoke references on table "public"."live_debate_participant_role" from "service_role";

revoke select on table "public"."live_debate_participant_role" from "service_role";

revoke trigger on table "public"."live_debate_participant_role" from "service_role";

revoke truncate on table "public"."live_debate_participant_role" from "service_role";

revoke update on table "public"."live_debate_participant_role" from "service_role";

alter table "public"."live_debate_invite_co_host" drop constraint "live_debate_invite_co_host_invited_by_live_debate_fkey";

alter table "public"."live_debate_participant_role" drop constraint "live_debate_participant_role_live_debate_fkey";

alter table "public"."live_debate_participant_role" drop constraint "live_debate_participant_role_participant_id_live_debate_fkey";

alter table "public"."live_debate_participant_role" drop constraint "live_debate_participant_role_pkey";

drop index if exists "public"."live_debate_participant_role_pkey";

drop table "public"."live_debate_participant_role";

create table "public"."live_debate_user_role" (
    "user_id" uuid not null,
    "created_at" timestamp with time zone not null default now(),
    "live_debate" uuid not null,
    "role" role not null
);


alter table "public"."live_debate_user_role" enable row level security;

CREATE UNIQUE INDEX live_debate_user_role_pkey ON public.live_debate_user_role USING btree (user_id, live_debate);

alter table "public"."live_debate_user_role" add constraint "live_debate_user_role_pkey" PRIMARY KEY using index "live_debate_user_role_pkey";

alter table "public"."live_debate_invite_co_host" add constraint "live_debate_invite_co_host_invited_by_fkey" FOREIGN KEY (invited_by) REFERENCES user_data(id) not valid;

alter table "public"."live_debate_invite_co_host" validate constraint "live_debate_invite_co_host_invited_by_fkey";

alter table "public"."live_debate_user_role" add constraint "live_debate_user_role_live_debate_fkey" FOREIGN KEY (live_debate) REFERENCES live_debate(id) not valid;

alter table "public"."live_debate_user_role" validate constraint "live_debate_user_role_live_debate_fkey";

alter table "public"."live_debate_user_role" add constraint "live_debate_user_role_user_id_fkey" FOREIGN KEY (user_id) REFERENCES user_data(id) not valid;

alter table "public"."live_debate_user_role" validate constraint "live_debate_user_role_user_id_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.user_atleast_co_host(live_debate_id uuid)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$BEGIN
  RETURN EXISTS (
    SELECT 1 
    FROM live_debate_user_role
    WHERE (SELECT auth.uid() as uid) = user_id
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
    FROM live_debate_user_role
    WHERE (SELECT auth.uid() as uid) = user_id
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
    FROM live_debate_user_role
    WHERE (SELECT auth.uid() as uid) = user_id
    AND live_debate = live_debate_id
    AND role IN ('host')
  );
END;$function$
;

grant delete on table "public"."live_debate_user_role" to "anon";

grant insert on table "public"."live_debate_user_role" to "anon";

grant references on table "public"."live_debate_user_role" to "anon";

grant select on table "public"."live_debate_user_role" to "anon";

grant trigger on table "public"."live_debate_user_role" to "anon";

grant truncate on table "public"."live_debate_user_role" to "anon";

grant update on table "public"."live_debate_user_role" to "anon";

grant delete on table "public"."live_debate_user_role" to "authenticated";

grant insert on table "public"."live_debate_user_role" to "authenticated";

grant references on table "public"."live_debate_user_role" to "authenticated";

grant select on table "public"."live_debate_user_role" to "authenticated";

grant trigger on table "public"."live_debate_user_role" to "authenticated";

grant truncate on table "public"."live_debate_user_role" to "authenticated";

grant update on table "public"."live_debate_user_role" to "authenticated";

grant delete on table "public"."live_debate_user_role" to "service_role";

grant insert on table "public"."live_debate_user_role" to "service_role";

grant references on table "public"."live_debate_user_role" to "service_role";

grant select on table "public"."live_debate_user_role" to "service_role";

grant trigger on table "public"."live_debate_user_role" to "service_role";

grant truncate on table "public"."live_debate_user_role" to "service_role";

grant update on table "public"."live_debate_user_role" to "service_role";

create policy "Anyone can read"
on "public"."live_debate_user_role"
as permissive
for select
to authenticated, anon
using (true);



