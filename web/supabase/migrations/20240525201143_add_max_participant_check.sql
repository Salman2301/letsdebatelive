drop policy "Enable insert for authenticated users only" on "public"."live_debate_participants";

alter table "public"."live_debate_team" drop constraint "live_debate_team_live_debate_fkey";

alter table "public"."live_debate" add column "max_participants" bigint not null default '40'::bigint;

alter table "public"."live_debate" add column "max_stage" bigint not null default '30'::bigint;

alter table "public"."live_debate_team" add constraint "live_debate_team_live_debate_fkey" FOREIGN KEY (live_debate) REFERENCES live_debate(id) ON DELETE CASCADE not valid;

alter table "public"."live_debate_team" validate constraint "live_debate_team_live_debate_fkey";

create policy "Enable insert for authenticated users only"
on "public"."live_debate_participants"
as permissive
for insert
to authenticated, anon
with check (((( SELECT auth.uid() AS uid) = participant_id) AND (( SELECT count(*) AS count
   FROM live_debate_participants l
  WHERE (l.live_debate = l.live_debate)) < ( SELECT ld.max_participants
   FROM live_debate ld
  WHERE (ld.id = live_debate_participants.live_debate)))));



