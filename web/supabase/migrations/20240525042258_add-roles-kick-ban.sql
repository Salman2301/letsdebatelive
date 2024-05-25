create type "public"."roles" as enum ('host', 'co-host', 'mods');

drop policy "Only user owner can view the content" on "public"."user_data";

drop policy "Enable insert for authenticated users only" on "public"."live_debate_participants";

alter table "public"."live_host_ban" drop constraint "live_host_ban_live_host_id_fkey";

alter table "public"."live_host_ban" drop constraint "live_host_ban_pkey";

drop index if exists "public"."live_host_ban_pkey";

create table "public"."live_debate_roles" (
    "created_at" timestamp with time zone not null default now(),
    "user_id" uuid not null,
    "live_debate" uuid not null,
    "role" roles not null
);


alter table "public"."live_debate_roles" enable row level security;

alter table "public"."live_host_ban" drop column "live_host_id";

alter table "public"."live_host_ban" alter column "banned_by" set default auth.uid();

alter table "public"."live_host_ban" alter column "live_debate" set not null;

CREATE UNIQUE INDEX live_debate_roles_pkey ON public.live_debate_roles USING btree (user_id, live_debate);

CREATE UNIQUE INDEX live_host_ban_pkey ON public.live_host_ban USING btree (live_debate, user_id);

alter table "public"."live_debate_roles" add constraint "live_debate_roles_pkey" PRIMARY KEY using index "live_debate_roles_pkey";

alter table "public"."live_host_ban" add constraint "live_host_ban_pkey" PRIMARY KEY using index "live_host_ban_pkey";

alter table "public"."live_debate_roles" add constraint "live_debate_roles_live_debate_fkey" FOREIGN KEY (live_debate) REFERENCES live_debate(id) ON DELETE CASCADE not valid;

alter table "public"."live_debate_roles" validate constraint "live_debate_roles_live_debate_fkey";

alter table "public"."live_debate_roles" add constraint "live_debate_roles_user_id_fkey" FOREIGN KEY (user_id) REFERENCES user_data(id) ON DELETE CASCADE not valid;

alter table "public"."live_debate_roles" validate constraint "live_debate_roles_user_id_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.user_atleast_co_host(live_debate_id uuid)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$BEGIN
  RETURN EXISTS (
    SELECT 1 
    FROM live_debate_roles
    WHERE (SELECT auth.uid()) = user_id 
    AND live_debate = live_debate_id
    AND role IN ('host', 'co-host')
  );
END;$function$
;

CREATE OR REPLACE FUNCTION public.user_atleast_mod(live_debate_id uuid)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$BEGIN
  RETURN EXISTS (
    SELECT 1 
    FROM live_debate_roles
    WHERE (SELECT auth.uid()) = user_id 
    AND live_debate = live_debate_id
  );
END;$function$
;

grant delete on table "public"."live_debate_roles" to "anon";

grant insert on table "public"."live_debate_roles" to "anon";

grant references on table "public"."live_debate_roles" to "anon";

grant select on table "public"."live_debate_roles" to "anon";

grant trigger on table "public"."live_debate_roles" to "anon";

grant truncate on table "public"."live_debate_roles" to "anon";

grant update on table "public"."live_debate_roles" to "anon";

grant delete on table "public"."live_debate_roles" to "authenticated";

grant insert on table "public"."live_debate_roles" to "authenticated";

grant references on table "public"."live_debate_roles" to "authenticated";

grant select on table "public"."live_debate_roles" to "authenticated";

grant trigger on table "public"."live_debate_roles" to "authenticated";

grant truncate on table "public"."live_debate_roles" to "authenticated";

grant update on table "public"."live_debate_roles" to "authenticated";

grant delete on table "public"."live_debate_roles" to "service_role";

grant insert on table "public"."live_debate_roles" to "service_role";

grant references on table "public"."live_debate_roles" to "service_role";

grant select on table "public"."live_debate_roles" to "service_role";

grant trigger on table "public"."live_debate_roles" to "service_role";

grant truncate on table "public"."live_debate_roles" to "service_role";

grant update on table "public"."live_debate_roles" to "service_role";

create policy "Only mods can delete"
on "public"."live_debate_kick"
as permissive
for delete
to authenticated
using (user_atleast_mod(live_debate));


create policy "Only mods can kick"
on "public"."live_debate_kick"
as permissive
for insert
to authenticated
with check (user_atleast_mod(live_debate));


create policy "Only mods can update"
on "public"."live_debate_kick"
as permissive
for update
to authenticated
using (user_atleast_mod(live_debate));


create policy "Only user and mods can see"
on "public"."live_debate_kick"
as permissive
for select
to authenticated
using ((user_atleast_mod(live_debate) OR (user_id = auth.uid())));


create policy "Anyone can see"
on "public"."live_debate_roles"
as permissive
for select
to public
using (true);


create policy "Only host can delete"
on "public"."live_debate_roles"
as permissive
for delete
to authenticated
using (user_atleast_co_host(live_debate));


create policy "Only host can insert"
on "public"."live_debate_roles"
as permissive
for insert
to authenticated
with check (user_atleast_co_host(live_debate));


create policy "Only host can update"
on "public"."live_debate_roles"
as permissive
for update
to authenticated
using (user_atleast_co_host(live_debate));


create policy "Atleast mod or the user can see"
on "public"."live_host_ban"
as permissive
for select
to authenticated
using ((user_atleast_mod(live_debate) OR (user_id = auth.uid())));


create policy "Only mods can ban"
on "public"."live_host_ban"
as permissive
for insert
to authenticated
with check (user_atleast_mod(live_debate));


create policy "Only mods can delete"
on "public"."live_host_ban"
as permissive
for delete
to authenticated
using (user_atleast_mod(live_debate));


create policy "Only mods can update"
on "public"."live_host_ban"
as permissive
for update
to authenticated
using (user_atleast_mod(live_debate));


create policy "Anyone can view"
on "public"."user_data"
as permissive
for select
to public
using (true);


create policy "Enable insert for authenticated users only"
on "public"."live_debate_participants"
as permissive
for insert
to authenticated, anon
with check ((( SELECT auth.uid() AS uid) = participant_id));



