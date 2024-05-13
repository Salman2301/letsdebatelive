alter table "public"."live_debate" drop constraint "live_debate_host_fkey";

alter table "public"."live_debate_participants" add column "debate" uuid;

alter table "public"."live_debate_participants" add column "is_debate_owner" boolean;

alter table "public"."live_debate" add constraint "public_live_debate_host_fkey" FOREIGN KEY (host) REFERENCES user_data(id) not valid;

alter table "public"."live_debate" validate constraint "public_live_debate_host_fkey";

alter table "public"."live_debate_participants" add constraint "public_live_debate_participants_debate_fkey" FOREIGN KEY (debate) REFERENCES live_debate(id) not valid;

alter table "public"."live_debate_participants" validate constraint "public_live_debate_participants_debate_fkey";

create policy "Enable insert for authenticated users only"
on "public"."live_debate"
as permissive
for insert
to authenticated
with check (true);


create policy "Enable read access for all users"
on "public"."live_debate"
as permissive
for select
to public
using ((( SELECT auth.uid() AS uid) = host));


create policy "Enable insert for authenticated users only"
on "public"."live_debate_participants"
as permissive
for insert
to authenticated
with check ((( SELECT auth.uid() AS uid) = id));


create policy "Enable read access for all users"
on "public"."live_debate_participants"
as permissive
for select
to public
using (true);


create policy "Enable update for users based on email"
on "public"."live_debate_participants"
as permissive
for update
to public
using ((( SELECT auth.uid() AS uid) = id))
with check ((( SELECT auth.uid() AS uid) = id));



