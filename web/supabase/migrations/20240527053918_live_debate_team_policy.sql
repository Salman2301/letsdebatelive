create policy "Atleast co-host"
on "public"."live_debate_team"
as permissive
for insert
to authenticated
with check (user_atleast_co_host(live_debate));


create policy "User atleast co-host"
on "public"."live_debate_team"
as permissive
for update
to authenticated
using (user_atleast_co_host(live_debate));


create policy "user atleast co-host"
on "public"."live_debate_team"
as permissive
for delete
to authenticated
using (user_atleast_co_host(live_debate));



