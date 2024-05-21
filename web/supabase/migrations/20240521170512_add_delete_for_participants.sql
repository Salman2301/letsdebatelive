create policy "Delete either by host or current owner"
on "public"."live_debate_participants"
as permissive
for delete
to authenticated
using (((( SELECT auth.uid() AS uid) = participant_id) OR (( SELECT auth.uid() AS uid) = host_id)));



