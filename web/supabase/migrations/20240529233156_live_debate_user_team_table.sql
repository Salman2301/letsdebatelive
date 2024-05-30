create table "public"."live_debate_user_team" (
    "user_id" uuid not null default auth.uid(),
    "created_at" timestamp with time zone not null default now(),
    "live_debate" uuid not null,
    "team" uuid not null
);


alter table "public"."live_debate_user_team" enable row level security;

CREATE UNIQUE INDEX live_debate_user_team_pkey ON public.live_debate_user_team USING btree (user_id, live_debate, team);

alter table "public"."live_debate_user_team" add constraint "live_debate_user_team_pkey" PRIMARY KEY using index "live_debate_user_team_pkey";

alter table "public"."live_debate_user_team" add constraint "live_debate_user_team_live_debate_fkey" FOREIGN KEY (live_debate) REFERENCES live_debate(id) not valid;

alter table "public"."live_debate_user_team" validate constraint "live_debate_user_team_live_debate_fkey";

alter table "public"."live_debate_user_team" add constraint "live_debate_user_team_team_fkey" FOREIGN KEY (team) REFERENCES live_debate_team(id) not valid;

alter table "public"."live_debate_user_team" validate constraint "live_debate_user_team_team_fkey";

alter table "public"."live_debate_user_team" add constraint "live_debate_user_team_user_id_fkey" FOREIGN KEY (user_id) REFERENCES user_data(id) not valid;

alter table "public"."live_debate_user_team" validate constraint "live_debate_user_team_user_id_fkey";

grant delete on table "public"."live_debate_user_team" to "anon";

grant insert on table "public"."live_debate_user_team" to "anon";

grant references on table "public"."live_debate_user_team" to "anon";

grant select on table "public"."live_debate_user_team" to "anon";

grant trigger on table "public"."live_debate_user_team" to "anon";

grant truncate on table "public"."live_debate_user_team" to "anon";

grant update on table "public"."live_debate_user_team" to "anon";

grant delete on table "public"."live_debate_user_team" to "authenticated";

grant insert on table "public"."live_debate_user_team" to "authenticated";

grant references on table "public"."live_debate_user_team" to "authenticated";

grant select on table "public"."live_debate_user_team" to "authenticated";

grant trigger on table "public"."live_debate_user_team" to "authenticated";

grant truncate on table "public"."live_debate_user_team" to "authenticated";

grant update on table "public"."live_debate_user_team" to "authenticated";

grant delete on table "public"."live_debate_user_team" to "service_role";

grant insert on table "public"."live_debate_user_team" to "service_role";

grant references on table "public"."live_debate_user_team" to "service_role";

grant select on table "public"."live_debate_user_team" to "service_role";

grant trigger on table "public"."live_debate_user_team" to "service_role";

grant truncate on table "public"."live_debate_user_team" to "service_role";

grant update on table "public"."live_debate_user_team" to "service_role";

create policy "Anyone can see"
on "public"."live_debate_user_team"
as permissive
for select
to anon, authenticated
using (true);


create policy "only user can delete"
on "public"."live_debate_user_team"
as permissive
for delete
to anon, authenticated
using ((( SELECT auth.uid() AS uid) = user_id));


create policy "user insert"
on "public"."live_debate_user_team"
as permissive
for insert
to anon, authenticated
with check ((( SELECT auth.uid() AS uid) = user_id));


create policy "user update"
on "public"."live_debate_user_team"
as permissive
for update
to anon, authenticated
using ((( SELECT auth.uid() AS uid) = user_id));



