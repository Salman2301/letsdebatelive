alter table "public"."live_debate_participants" add column "hand_raised_at" timestamp with time zone;

alter table "public"."live_debate_team" alter column "color" set not null;

alter table "public"."live_debate_team" alter column "live_debate" set not null;

alter table "public"."live_debate_team" alter column "slug" set not null;

alter table "public"."live_debate_team" alter column "title" set not null;


