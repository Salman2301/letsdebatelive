drop policy "Enable insert for users based on user_id, also check if the use" on "public"."user_data";

drop policy "Enable update for users based on id, also check if username is " on "public"."user_data";

create policy "Enable insert for users based on user_id, also check if the use"
on "public"."user_data"
as permissive
for insert
to public
with check ((( SELECT auth.uid() AS uid) = id));


create policy "Enable update for users based on id, also check if username is "
on "public"."user_data"
as permissive
for update
to public
using ((( SELECT auth.uid() AS uid) = id))
with check ((( SELECT auth.uid() AS uid) = id));



