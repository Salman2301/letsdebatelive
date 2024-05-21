alter table "public"."live_debate_team" drop constraint "debate_team_user_id_fkey";

alter table "public"."live_debate" alter column "chat_team_only" drop default;

alter table "public"."live_debate_team" drop column "user_id";

alter table "public"."live_debate_team" add column "live_debate" uuid;

alter table "public"."live_debate_team" add column "slug" character varying;

alter table "public"."live_debate" add constraint "live_debate_chat_team_only_fkey" FOREIGN KEY (chat_team_only) REFERENCES live_debate_team(id) ON DELETE SET NULL not valid;

alter table "public"."live_debate" validate constraint "live_debate_chat_team_only_fkey";

alter table "public"."live_debate_team" add constraint "live_debate_team_live_debate_fkey" FOREIGN KEY (live_debate) REFERENCES live_debate(id) ON DELETE SET NULL not valid;

alter table "public"."live_debate_team" validate constraint "live_debate_team_live_debate_fkey";


