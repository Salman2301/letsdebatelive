alter type "public"."roles" rename to "roles__old_version_to_be_dropped";

create type "public"."roles" as enum ('host', 'co-host', 'mod', 'guest');

create table "public"."host_stream_key" (
    "id" uuid not null default auth.uid(),
    "created_at" timestamp with time zone not null default now(),
    "stream_key" text not null
);


alter table "public"."host_stream_key" enable row level security;

alter table "public"."live_debate_roles" alter column role type "public"."roles" using role::text::"public"."roles";

drop type "public"."roles__old_version_to_be_dropped";

alter table "public"."live_debate" drop column "publishedTz";

alter table "public"."live_debate" add column "ended" boolean;

alter table "public"."live_debate" add column "ended_tz" timestamp with time zone;

alter table "public"."live_debate" add column "published_tz" timestamp with time zone;

CREATE UNIQUE INDEX host_stream_key_pkey ON public.host_stream_key USING btree (id);

alter table "public"."host_stream_key" add constraint "host_stream_key_pkey" PRIMARY KEY using index "host_stream_key_pkey";

grant delete on table "public"."host_stream_key" to "anon";

grant insert on table "public"."host_stream_key" to "anon";

grant references on table "public"."host_stream_key" to "anon";

grant select on table "public"."host_stream_key" to "anon";

grant trigger on table "public"."host_stream_key" to "anon";

grant truncate on table "public"."host_stream_key" to "anon";

grant update on table "public"."host_stream_key" to "anon";

grant delete on table "public"."host_stream_key" to "authenticated";

grant insert on table "public"."host_stream_key" to "authenticated";

grant references on table "public"."host_stream_key" to "authenticated";

grant select on table "public"."host_stream_key" to "authenticated";

grant trigger on table "public"."host_stream_key" to "authenticated";

grant truncate on table "public"."host_stream_key" to "authenticated";

grant update on table "public"."host_stream_key" to "authenticated";

grant delete on table "public"."host_stream_key" to "service_role";

grant insert on table "public"."host_stream_key" to "service_role";

grant references on table "public"."host_stream_key" to "service_role";

grant select on table "public"."host_stream_key" to "service_role";

grant trigger on table "public"."host_stream_key" to "service_role";

grant truncate on table "public"."host_stream_key" to "service_role";

grant update on table "public"."host_stream_key" to "service_role";


