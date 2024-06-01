create type "public"."role" as enum ('host', 'co-host', 'mod', 'guest');

drop policy "Anyone can see" on "public"."live_debate_roles";

drop policy "Only host can delete" on "public"."live_debate_roles";

drop policy "Only host can insert" on "public"."live_debate_roles";

drop policy "Only host can update" on "public"."live_debate_roles";

revoke delete on table "public"."live_debate_roles" from "anon";

revoke insert on table "public"."live_debate_roles" from "anon";

revoke references on table "public"."live_debate_roles" from "anon";

revoke select on table "public"."live_debate_roles" from "anon";

revoke trigger on table "public"."live_debate_roles" from "anon";

revoke truncate on table "public"."live_debate_roles" from "anon";

revoke update on table "public"."live_debate_roles" from "anon";

revoke delete on table "public"."live_debate_roles" from "authenticated";

revoke insert on table "public"."live_debate_roles" from "authenticated";

revoke references on table "public"."live_debate_roles" from "authenticated";

revoke select on table "public"."live_debate_roles" from "authenticated";

revoke trigger on table "public"."live_debate_roles" from "authenticated";

revoke truncate on table "public"."live_debate_roles" from "authenticated";

revoke update on table "public"."live_debate_roles" from "authenticated";

revoke delete on table "public"."live_debate_roles" from "service_role";

revoke insert on table "public"."live_debate_roles" from "service_role";

revoke references on table "public"."live_debate_roles" from "service_role";

revoke select on table "public"."live_debate_roles" from "service_role";

revoke trigger on table "public"."live_debate_roles" from "service_role";

revoke truncate on table "public"."live_debate_roles" from "service_role";

revoke update on table "public"."live_debate_roles" from "service_role";

alter table "public"."live_debate_roles" drop constraint "live_debate_roles_live_debate_fkey";

alter table "public"."live_debate_roles" drop constraint "live_debate_roles_user_id_fkey";

drop function if exists "public"."user_is_host"(live_debate_id uuid);

alter table "public"."live_debate_roles" drop constraint "live_debate_roles_pkey";

drop index if exists "public"."live_debate_roles_pkey";

drop table "public"."live_debate_roles";

alter table "public"."live_debate_participants" add column "role" role not null;

drop type "public"."roles";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.user_is_host_role(live_debate_id uuid)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$BEGIN
  RETURN EXISTS (
    SELECT 1 
    FROM live_debate
    WHERE (SELECT auth.uid() as uid) = user_id 
    AND live_debate = live_debate_id
    AND role IN ('host')
  );
END;$function$
;

CREATE OR REPLACE FUNCTION public.user_atleast_co_host_role(live_debate_id uuid)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$BEGIN
  RETURN EXISTS (
    SELECT 1 
    FROM live_debate
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
    FROM live_debate
    WHERE (SELECT auth.uid() as uid) = user_id 
    AND live_debate = live_debate_id
    AND role IN ('host', 'co-host', 'mod')
  );
END;$function$
;


