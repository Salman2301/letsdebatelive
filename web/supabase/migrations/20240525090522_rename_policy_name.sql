drop policy "Delete either by host or current owner" on "public"."live_debate_participants";

drop policy "Enable update for users based on user id" on "public"."live_debate_participants";

create table "public"."live_user_ban" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "user_id" uuid not null,
    "title" text,
    "description" text,
    "banned_until" timestamp with time zone
);


alter table "public"."live_user_ban" enable row level security;

CREATE UNIQUE INDEX live_user_ban_pkey ON public.live_user_ban USING btree (id, user_id);

alter table "public"."live_user_ban" add constraint "live_user_ban_pkey" PRIMARY KEY using index "live_user_ban_pkey";

alter table "public"."live_user_ban" add constraint "live_user_ban_user_id_fkey" FOREIGN KEY (user_id) REFERENCES user_data(id) ON DELETE CASCADE not valid;

alter table "public"."live_user_ban" validate constraint "live_user_ban_user_id_fkey";

grant delete on table "public"."live_user_ban" to "anon";

grant insert on table "public"."live_user_ban" to "anon";

grant references on table "public"."live_user_ban" to "anon";

grant select on table "public"."live_user_ban" to "anon";

grant trigger on table "public"."live_user_ban" to "anon";

grant truncate on table "public"."live_user_ban" to "anon";

grant update on table "public"."live_user_ban" to "anon";

grant delete on table "public"."live_user_ban" to "authenticated";

grant insert on table "public"."live_user_ban" to "authenticated";

grant references on table "public"."live_user_ban" to "authenticated";

grant select on table "public"."live_user_ban" to "authenticated";

grant trigger on table "public"."live_user_ban" to "authenticated";

grant truncate on table "public"."live_user_ban" to "authenticated";

grant update on table "public"."live_user_ban" to "authenticated";

grant delete on table "public"."live_user_ban" to "service_role";

grant insert on table "public"."live_user_ban" to "service_role";

grant references on table "public"."live_user_ban" to "service_role";

grant select on table "public"."live_user_ban" to "service_role";

grant trigger on table "public"."live_user_ban" to "service_role";

grant truncate on table "public"."live_user_ban" to "service_role";

grant update on table "public"."live_user_ban" to "service_role";

create policy "Delete either by host or current owner"
on "public"."live_debate_participants"
as permissive
for delete
to authenticated
using (((( SELECT auth.uid() AS uid) = participant_id) OR user_atleast_co_host(live_debate)));


create policy "Enable update for users based on user id"
on "public"."live_debate_participants"
as permissive
for update
to authenticated, anon
using (((( SELECT auth.uid() AS uid) = participant_id) OR user_atleast_co_host(live_debate)))
with check (((( SELECT auth.uid() AS uid) = participant_id) OR user_atleast_co_host(live_debate)));



