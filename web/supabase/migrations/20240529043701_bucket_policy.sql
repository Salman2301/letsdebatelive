create policy "anyone can see"
on "storage"."objects"
as permissive
for select
to anon, authenticated
using ((bucket_id = 'profile_image'::text));


create policy "only auth can insert"
on "storage"."objects"
as permissive
for insert
to authenticated
with check ((bucket_id = 'profile_image'::text));



