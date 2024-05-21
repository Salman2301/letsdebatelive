drop policy "Enable update for users based on email" on "public"."live_debate_participants";

drop policy "Enable read access for all users" on "public"."live_debate";

alter table "public"."live_debate_participants" drop constraint "live_debate_participants_pkey";

drop index if exists "public"."live_debate_participants_pkey";

alter table "public"."live_debate_participants" add column "host_id" uuid;

alter table "public"."live_debate_participants" add column "profile_image_enable" boolean;

alter table "public"."live_debate_participants" add column "screenshare_enable" boolean;

CREATE UNIQUE INDEX live_debate_participants_pkey ON public.live_debate_participants USING btree (live_debate, participant_id);

alter table "public"."live_debate_participants" add constraint "live_debate_participants_pkey" PRIMARY KEY using index "live_debate_participants_pkey";

alter table "public"."live_debate_participants" add constraint "live_debate_participants_host_id_fkey" FOREIGN KEY (host_id) REFERENCES user_data(id) ON DELETE CASCADE not valid;

alter table "public"."live_debate_participants" validate constraint "live_debate_participants_host_id_fkey";

create policy "Enable update for users based on user id"
on "public"."live_debate_participants"
as permissive
for update
to authenticated, anon
using (((( SELECT auth.uid() AS uid) = participant_id) OR (( SELECT auth.uid() AS uid) = host_id)))
with check (((( SELECT auth.uid() AS uid) = participant_id) OR (( SELECT auth.uid() AS uid) = host_id)));


create policy "Enable read access for any"
on "public"."live_debate_team"
as permissive
for select
to public
using (true);


create policy "Enable read access for all users"
on "public"."live_debate"
as permissive
for select
to public
using (true);



