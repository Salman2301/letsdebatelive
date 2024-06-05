create table "public"."live_debate_participant_role" (
    "participant_id" uuid not null,
    "created_at" timestamp with time zone not null default now(),
    "live_debate" uuid not null,
    "role" role not null
);


alter table "public"."live_debate_participant_role" enable row level security;

CREATE UNIQUE INDEX live_debate_participant_role_pkey ON public.live_debate_participant_role USING btree (participant_id, live_debate, role);

alter table "public"."live_debate_participant_role" add constraint "live_debate_participant_role_pkey" PRIMARY KEY using index "live_debate_participant_role_pkey";

alter table "public"."live_debate_participant_role" add constraint "live_debate_participant_role_live_debate_fkey" FOREIGN KEY (live_debate) REFERENCES live_debate(id) not valid;

alter table "public"."live_debate_participant_role" validate constraint "live_debate_participant_role_live_debate_fkey";

alter table "public"."live_debate_participant_role" add constraint "live_debate_participant_role_participant_id_live_debate_fkey" FOREIGN KEY (participant_id, live_debate) REFERENCES live_debate_participants(participant_id, live_debate) ON DELETE CASCADE not valid;

alter table "public"."live_debate_participant_role" validate constraint "live_debate_participant_role_participant_id_live_debate_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.user_atleast_co_host(live_debate_id uuid)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$BEGIN
  RETURN EXISTS (
    SELECT 1 
    FROM live_debate_participant_role
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
    FROM live_debate_participant_role
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
    FROM live_debate_participant_role
    WHERE (SELECT auth.uid() as uid) = participant_id
    AND live_debate = live_debate_id
    AND role IN ('host')
  );
END;$function$
;

grant delete on table "public"."live_debate_participant_role" to "anon";

grant insert on table "public"."live_debate_participant_role" to "anon";

grant references on table "public"."live_debate_participant_role" to "anon";

grant select on table "public"."live_debate_participant_role" to "anon";

grant trigger on table "public"."live_debate_participant_role" to "anon";

grant truncate on table "public"."live_debate_participant_role" to "anon";

grant update on table "public"."live_debate_participant_role" to "anon";

grant delete on table "public"."live_debate_participant_role" to "authenticated";

grant insert on table "public"."live_debate_participant_role" to "authenticated";

grant references on table "public"."live_debate_participant_role" to "authenticated";

grant select on table "public"."live_debate_participant_role" to "authenticated";

grant trigger on table "public"."live_debate_participant_role" to "authenticated";

grant truncate on table "public"."live_debate_participant_role" to "authenticated";

grant update on table "public"."live_debate_participant_role" to "authenticated";

grant delete on table "public"."live_debate_participant_role" to "service_role";

grant insert on table "public"."live_debate_participant_role" to "service_role";

grant references on table "public"."live_debate_participant_role" to "service_role";

grant select on table "public"."live_debate_participant_role" to "service_role";

grant trigger on table "public"."live_debate_participant_role" to "service_role";

grant truncate on table "public"."live_debate_participant_role" to "service_role";

grant update on table "public"."live_debate_participant_role" to "service_role";


