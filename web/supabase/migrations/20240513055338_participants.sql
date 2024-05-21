revoke delete on table "public"."debate_agenda" from "anon";
revoke insert on table "public"."debate_agenda" from "anon";
revoke references on table "public"."debate_agenda" from "anon";
revoke select on table "public"."debate_agenda" from "anon";
revoke trigger on table "public"."debate_agenda" from "anon";
revoke truncate on table "public"."debate_agenda" from "anon";
revoke update on table "public"."debate_agenda" from "anon";
revoke delete on table "public"."debate_agenda" from "authenticated";
revoke insert on table "public"."debate_agenda" from "authenticated";
revoke references on table "public"."debate_agenda" from "authenticated";
revoke select on table "public"."debate_agenda" from "authenticated";
revoke trigger on table "public"."debate_agenda" from "authenticated";
revoke truncate on table "public"."debate_agenda" from "authenticated";
revoke update on table "public"."debate_agenda" from "authenticated";
revoke delete on table "public"."debate_agenda" from "service_role";
revoke insert on table "public"."debate_agenda" from "service_role";
revoke references on table "public"."debate_agenda" from "service_role";
revoke select on table "public"."debate_agenda" from "service_role";
revoke trigger on table "public"."debate_agenda" from "service_role";
revoke truncate on table "public"."debate_agenda" from "service_role";
revoke update on table "public"."debate_agenda" from "service_role";
revoke delete on table "public"."debate_team" from "anon";
revoke insert on table "public"."debate_team" from "anon";
revoke references on table "public"."debate_team" from "anon";
revoke select on table "public"."debate_team" from "anon";
revoke trigger on table "public"."debate_team" from "anon";
revoke truncate on table "public"."debate_team" from "anon";
revoke update on table "public"."debate_team" from "anon";
revoke delete on table "public"."debate_team" from "authenticated";
revoke insert on table "public"."debate_team" from "authenticated";
revoke references on table "public"."debate_team" from "authenticated";
revoke select on table "public"."debate_team" from "authenticated";
revoke trigger on table "public"."debate_team" from "authenticated";
revoke truncate on table "public"."debate_team" from "authenticated";
revoke update on table "public"."debate_team" from "authenticated";
revoke delete on table "public"."debate_team" from "service_role";
revoke insert on table "public"."debate_team" from "service_role";
revoke references on table "public"."debate_team" from "service_role";
revoke select on table "public"."debate_team" from "service_role";
revoke trigger on table "public"."debate_team" from "service_role";
revoke truncate on table "public"."debate_team" from "service_role";
revoke update on table "public"."debate_team" from "service_role";
alter table "public"."debate_agenda" drop constraint "debate_agenda_live_debate_fkey";
alter table "public"."debate_agenda" drop constraint "debate_agenda_team_fkey";
alter table "public"."debate_team" drop constraint "debate_team_user_id_fkey";
alter table "public"."debate_agenda" drop constraint "debate_agenda_pkey";
alter table "public"."debate_team" drop constraint "debate_team_pkey";
drop index if exists "public"."debate_agenda_pkey";
drop index if exists "public"."debate_team_pkey";
drop table "public"."debate_agenda";
drop table "public"."debate_team";
create table "public"."live_debate_agenda" (
    "created_at" timestamp with time zone not null default now(),
    "live_debate" uuid,
    "title" text,
    "time" time without time zone,
    "id" uuid not null default gen_random_uuid(),
    "completed" boolean,
    "team" uuid
);
alter table "public"."live_debate_agenda" enable row level security;
create table "public"."live_debate_participants" (
    "id" uuid not null default auth.uid(),
    "created_at" timestamp with time zone not null default now(),
    "speaker_id" text,
    "mic_id" text,
    "cam_id" text,
    "speaker_enable" boolean default true,
    "mic_enable" boolean default true,
    "cam_enable" boolean default true,
    "screenshare_available" boolean,
    "speaker_available" boolean,
    "mic_available" boolean,
    "cam_available" boolean,
    "current_stage" text,
    "is_kicked" boolean,
    "display_name" text,
    "team" uuid
);
alter table "public"."live_debate_participants" enable row level security;
create table "public"."live_debate_team" (
    "created_at" timestamp with time zone not null default now(),
    "user_id" uuid default auth.uid(),
    "color" text,
    "title" text,
    "id" uuid not null default gen_random_uuid()
);
alter table "public"."live_debate_team" enable row level security;
CREATE UNIQUE INDEX live_debate_participants_pkey ON public.live_debate_participants USING btree (id);
CREATE UNIQUE INDEX debate_agenda_pkey ON public.live_debate_agenda USING btree (id);
CREATE UNIQUE INDEX debate_team_pkey ON public.live_debate_team USING btree (id);
alter table "public"."live_debate_agenda" add constraint "debate_agenda_pkey" PRIMARY KEY using index "debate_agenda_pkey";
alter table "public"."live_debate_participants" add constraint "live_debate_participants_pkey" PRIMARY KEY using index "live_debate_participants_pkey";
alter table "public"."live_debate_team" add constraint "debate_team_pkey" PRIMARY KEY using index "debate_team_pkey";
alter table "public"."live_debate_agenda" add constraint "debate_agenda_live_debate_fkey" FOREIGN KEY (live_debate) REFERENCES live_debate(id) ON DELETE CASCADE not valid;
alter table "public"."live_debate_agenda" validate constraint "debate_agenda_live_debate_fkey";
alter table "public"."live_debate_agenda" add constraint "debate_agenda_team_fkey" FOREIGN KEY (team) REFERENCES live_debate_team(id) ON DELETE CASCADE not valid;
alter table "public"."live_debate_agenda" validate constraint "debate_agenda_team_fkey";
alter table "public"."live_debate_participants" add constraint "public_live_debate_participants_team_fkey" FOREIGN KEY (team) REFERENCES live_debate_team(id) ON DELETE SET NULL not valid;
alter table "public"."live_debate_participants" validate constraint "public_live_debate_participants_team_fkey";
alter table "public"."live_debate_team" add constraint "debate_team_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;
alter table "public"."live_debate_team" validate constraint "debate_team_user_id_fkey";
grant delete on table "public"."live_debate_agenda" to "anon";
grant insert on table "public"."live_debate_agenda" to "anon";
grant references on table "public"."live_debate_agenda" to "anon";
grant select on table "public"."live_debate_agenda" to "anon";
grant trigger on table "public"."live_debate_agenda" to "anon";
grant truncate on table "public"."live_debate_agenda" to "anon";
grant update on table "public"."live_debate_agenda" to "anon";
grant delete on table "public"."live_debate_agenda" to "authenticated";
grant insert on table "public"."live_debate_agenda" to "authenticated";
grant references on table "public"."live_debate_agenda" to "authenticated";
grant select on table "public"."live_debate_agenda" to "authenticated";
grant trigger on table "public"."live_debate_agenda" to "authenticated";
grant truncate on table "public"."live_debate_agenda" to "authenticated";
grant update on table "public"."live_debate_agenda" to "authenticated";
grant delete on table "public"."live_debate_agenda" to "service_role";
grant insert on table "public"."live_debate_agenda" to "service_role";
grant references on table "public"."live_debate_agenda" to "service_role";
grant select on table "public"."live_debate_agenda" to "service_role";
grant trigger on table "public"."live_debate_agenda" to "service_role";
grant truncate on table "public"."live_debate_agenda" to "service_role";
grant update on table "public"."live_debate_agenda" to "service_role";
grant delete on table "public"."live_debate_participants" to "anon";
grant insert on table "public"."live_debate_participants" to "anon";
grant references on table "public"."live_debate_participants" to "anon";
grant select on table "public"."live_debate_participants" to "anon";
grant trigger on table "public"."live_debate_participants" to "anon";
grant truncate on table "public"."live_debate_participants" to "anon";
grant update on table "public"."live_debate_participants" to "anon";
grant delete on table "public"."live_debate_participants" to "authenticated";
grant insert on table "public"."live_debate_participants" to "authenticated";
grant references on table "public"."live_debate_participants" to "authenticated";
grant select on table "public"."live_debate_participants" to "authenticated";
grant trigger on table "public"."live_debate_participants" to "authenticated";
grant truncate on table "public"."live_debate_participants" to "authenticated";
grant update on table "public"."live_debate_participants" to "authenticated";
grant delete on table "public"."live_debate_participants" to "service_role";
grant insert on table "public"."live_debate_participants" to "service_role";
grant references on table "public"."live_debate_participants" to "service_role";
grant select on table "public"."live_debate_participants" to "service_role";
grant trigger on table "public"."live_debate_participants" to "service_role";
grant truncate on table "public"."live_debate_participants" to "service_role";
grant update on table "public"."live_debate_participants" to "service_role";
grant delete on table "public"."live_debate_team" to "anon";
grant insert on table "public"."live_debate_team" to "anon";
grant references on table "public"."live_debate_team" to "anon";
grant select on table "public"."live_debate_team" to "anon";
grant trigger on table "public"."live_debate_team" to "anon";
grant truncate on table "public"."live_debate_team" to "anon";
grant update on table "public"."live_debate_team" to "anon";
grant delete on table "public"."live_debate_team" to "authenticated";
grant insert on table "public"."live_debate_team" to "authenticated";
grant references on table "public"."live_debate_team" to "authenticated";
grant select on table "public"."live_debate_team" to "authenticated";
grant trigger on table "public"."live_debate_team" to "authenticated";
grant truncate on table "public"."live_debate_team" to "authenticated";
grant update on table "public"."live_debate_team" to "authenticated";
grant delete on table "public"."live_debate_team" to "service_role";
grant insert on table "public"."live_debate_team" to "service_role";
grant references on table "public"."live_debate_team" to "service_role";
grant select on table "public"."live_debate_team" to "service_role";
grant trigger on table "public"."live_debate_team" to "service_role";
grant truncate on table "public"."live_debate_team" to "service_role";
grant update on table "public"."live_debate_team" to "service_role";
