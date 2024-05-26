create policy "User not banned"
on "public"."live_debate"
as permissive
for update
to authenticated
using (user_atleast_co_host(id));


create policy "Anyone can see"
on "public"."live_debate_audience_team_only"
as permissive
for select
to public
using (true);


create policy "host only"
on "public"."live_debate_audience_team_only"
as permissive
for insert
to authenticated
with check (user_atleast_co_host(live_debate));


create policy "user atleast co-host"
on "public"."live_debate_audience_team_only"
as permissive
for select
to public
using (user_atleast_co_host(live_debate));


create policy "user atleast code-host"
on "public"."live_debate_audience_team_only"
as permissive
for update
to authenticated
using (user_atleast_co_host(live_debate));



