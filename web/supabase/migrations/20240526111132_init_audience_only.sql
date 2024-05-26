create type "public"."audience_service" as enum ('viewer', 'chat', 'backstage');

create type "public"."audience_type" as enum ('supporter', 'follower', 'team-only', 'registered', 'anonymous', 'invite_only');

alter table "public"."live_debate" drop constraint "live_debate_chat_team_only_fkey";

create table "public"."live_debate_audience_team_only" (
    "live_debate" uuid not null,
    "created_at" timestamp with time zone not null default now(),
    "service" audience_service not null,
    "team" uuid not null
);


alter table "public"."live_debate_audience_team_only" enable row level security;

alter table "public"."live_debate" drop column "backstage_allow_only";

alter table "public"."live_debate" drop column "chat_follower_only";

alter table "public"."live_debate" drop column "chat_support_only";

alter table "public"."live_debate" drop column "chat_team_only";

alter table "public"."live_debate" drop column "viewer_type";

alter table "public"."live_debate" add column "backstage_audience" audience_type[];

alter table "public"."live_debate" add column "chat_audience" audience_type[];

alter table "public"."live_debate" add column "viewer_audience" audience_type[];

CREATE UNIQUE INDEX live_debate_audience_team_only_pkey ON public.live_debate_audience_team_only USING btree (team, live_debate, service);

alter table "public"."live_debate_audience_team_only" add constraint "live_debate_audience_team_only_pkey" PRIMARY KEY using index "live_debate_audience_team_only_pkey";

alter table "public"."live_debate_audience_team_only" add constraint "live_debate_audience_team_only_live_debate_fkey" FOREIGN KEY (live_debate) REFERENCES live_debate(id) ON DELETE CASCADE not valid;

alter table "public"."live_debate_audience_team_only" validate constraint "live_debate_audience_team_only_live_debate_fkey";

alter table "public"."live_debate_audience_team_only" add constraint "live_debate_audience_team_only_team_fkey" FOREIGN KEY (team) REFERENCES live_debate_team(id) ON DELETE CASCADE not valid;

alter table "public"."live_debate_audience_team_only" validate constraint "live_debate_audience_team_only_team_fkey";

grant delete on table "public"."live_debate_audience_team_only" to "anon";

grant insert on table "public"."live_debate_audience_team_only" to "anon";

grant references on table "public"."live_debate_audience_team_only" to "anon";

grant select on table "public"."live_debate_audience_team_only" to "anon";

grant trigger on table "public"."live_debate_audience_team_only" to "anon";

grant truncate on table "public"."live_debate_audience_team_only" to "anon";

grant update on table "public"."live_debate_audience_team_only" to "anon";

grant delete on table "public"."live_debate_audience_team_only" to "authenticated";

grant insert on table "public"."live_debate_audience_team_only" to "authenticated";

grant references on table "public"."live_debate_audience_team_only" to "authenticated";

grant select on table "public"."live_debate_audience_team_only" to "authenticated";

grant trigger on table "public"."live_debate_audience_team_only" to "authenticated";

grant truncate on table "public"."live_debate_audience_team_only" to "authenticated";

grant update on table "public"."live_debate_audience_team_only" to "authenticated";

grant delete on table "public"."live_debate_audience_team_only" to "service_role";

grant insert on table "public"."live_debate_audience_team_only" to "service_role";

grant references on table "public"."live_debate_audience_team_only" to "service_role";

grant select on table "public"."live_debate_audience_team_only" to "service_role";

grant trigger on table "public"."live_debate_audience_team_only" to "service_role";

grant truncate on table "public"."live_debate_audience_team_only" to "service_role";

grant update on table "public"."live_debate_audience_team_only" to "service_role";


