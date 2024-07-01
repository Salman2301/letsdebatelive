create table "public"."user_follow" (
    "user_id" uuid not null default auth.uid(),
    "created_at" timestamp with time zone not null default now(),
    "follow" uuid not null
);


alter table "public"."user_follow" enable row level security;

alter table "public"."live_host_follower" add column "last_updated" timestamp with time zone;

CREATE UNIQUE INDEX user_follow_pkey ON public.user_follow USING btree (user_id, follow);

alter table "public"."user_follow" add constraint "user_follow_pkey" PRIMARY KEY using index "user_follow_pkey";

alter table "public"."user_follow" add constraint "user_follow_follow_fkey" FOREIGN KEY (follow) REFERENCES user_data(id) ON DELETE CASCADE not valid;

alter table "public"."user_follow" validate constraint "user_follow_follow_fkey";

alter table "public"."user_follow" add constraint "user_follow_user_id_fkey" FOREIGN KEY (user_id) REFERENCES user_data(id) ON DELETE CASCADE not valid;

alter table "public"."user_follow" validate constraint "user_follow_user_id_fkey";

grant delete on table "public"."user_follow" to "anon";

grant insert on table "public"."user_follow" to "anon";

grant references on table "public"."user_follow" to "anon";

grant select on table "public"."user_follow" to "anon";

grant trigger on table "public"."user_follow" to "anon";

grant truncate on table "public"."user_follow" to "anon";

grant update on table "public"."user_follow" to "anon";

grant delete on table "public"."user_follow" to "authenticated";

grant insert on table "public"."user_follow" to "authenticated";

grant references on table "public"."user_follow" to "authenticated";

grant select on table "public"."user_follow" to "authenticated";

grant trigger on table "public"."user_follow" to "authenticated";

grant truncate on table "public"."user_follow" to "authenticated";

grant update on table "public"."user_follow" to "authenticated";

grant delete on table "public"."user_follow" to "service_role";

grant insert on table "public"."user_follow" to "service_role";

grant references on table "public"."user_follow" to "service_role";

grant select on table "public"."user_follow" to "service_role";

grant trigger on table "public"."user_follow" to "service_role";

grant truncate on table "public"."user_follow" to "service_role";

grant update on table "public"."user_follow" to "service_role";

create policy "Anyone can read"
on "public"."user_follow"
as permissive
for select
to authenticated
using (true);


create policy "Enable delete for users based on user_id"
on "public"."user_follow"
as permissive
for delete
to public
using ((( SELECT auth.uid() AS uid) = user_id));


create policy "Enable insert for users based on user_id"
on "public"."user_follow"
as permissive
for insert
to public
with check ((( SELECT auth.uid() AS uid) = user_id));



