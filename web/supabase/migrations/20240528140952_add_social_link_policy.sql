create policy "Anyone can see"
on "public"."social_links"
as permissive
for select
to authenticated, anon
using (true);


create policy "Enable delete for users based on user_id"
on "public"."social_links"
as permissive
for delete
to public
using ((( SELECT auth.uid() AS uid) = user_id));


create policy "Enable insert for users based on user_id"
on "public"."social_links"
as permissive
for insert
to public
with check ((( SELECT auth.uid() AS uid) = user_id));


create policy "only owner can update"
on "public"."social_links"
as permissive
for update
to authenticated, anon
using ((( SELECT auth.uid() AS uid) = user_id));



