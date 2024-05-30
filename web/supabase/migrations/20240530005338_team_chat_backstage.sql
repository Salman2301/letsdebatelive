alter table "public"."live_debate_user_team" drop constraint "live_debate_user_team_team_fkey";

alter table "public"."live_debate_user_team" drop constraint "live_debate_user_team_pkey";

drop index if exists "public"."live_debate_user_team_pkey";

alter table "public"."live_debate_participants" alter column "team" drop not null;

CREATE UNIQUE INDEX live_debate_user_team_pkey ON public.live_debate_user_team USING btree (user_id, live_debate);

alter table "public"."live_debate_user_team" add constraint "live_debate_user_team_pkey" PRIMARY KEY using index "live_debate_user_team_pkey";


