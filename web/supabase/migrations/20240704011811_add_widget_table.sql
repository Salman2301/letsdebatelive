create policy "users DELETE access to own folder"
on "storage"."objects"
as permissive
for delete
to public
using (((bucket_id = 'user_asset'::text) AND (( SELECT (auth.uid())::text AS uid) = (storage.foldername(name))[1])));


create policy "users INSERT access to own folder"
on "storage"."objects"
as permissive
for insert
to public
with check (((bucket_id = 'user_asset'::text) AND (( SELECT (auth.uid())::text AS uid) = (storage.foldername(name))[1])));


create policy "users READ access to own folder"
on "storage"."objects"
as permissive
for select
to public
using (((bucket_id = 'user_asset'::text) AND (( SELECT (auth.uid())::text AS uid) = (storage.foldername(name))[1])));


create policy "users UPDATE access to own folder"
on "storage"."objects"
as permissive
for update
to public
using (((bucket_id = 'user_asset'::text) AND (( SELECT (auth.uid())::text AS uid) = (storage.foldername(name))[1])));



create type "public"."asset_type" as enum ('image', 'video', 'background', 'frame', 'logo', 'watermark');

create type "public"."widget_type" as enum ('background', 'watermark', 'logo', 'alert', 'running_text', 'sounds_board');

create table "public"."live_widget" (
    "created_at" timestamp with time zone not null default now(),
    "widget_type" widget_type not null,
    "data" jsonb not null,
    "live_feed" uuid not null,
    "id" uuid not null default gen_random_uuid()
);


alter table "public"."live_widget" enable row level security;

create table "public"."live_widget_background" (
    "live_widget" uuid not null,
    "created_at" timestamp with time zone not null default now(),
    "asset" uuid not null
);


alter table "public"."live_widget_background" enable row level security;

create table "public"."live_widget_logo" (
    "live_widget" uuid not null,
    "created_at" timestamp with time zone not null default now(),
    "asset" uuid,
    "position" text default 'top-right'::text
);


alter table "public"."live_widget_logo" enable row level security;

create table "public"."live_widget_running_text" (
    "live_widget" uuid not null,
    "created_at" timestamp with time zone not null default now(),
    "text" text,
    "position" text,
    "color_text" text,
    "color_background" text
);


alter table "public"."live_widget_running_text" enable row level security;

create table "public"."live_widget_watermark" (
    "live_widget" uuid not null,
    "created_at" timestamp with time zone not null default now(),
    "type" text,
    "image_asset" uuid,
    "text_value" text,
    "position" text
);


alter table "public"."live_widget_watermark" enable row level security;

create table "public"."user_asset" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "type" asset_type default 'image'::asset_type,
    "path" text not null,
    "user_id" uuid not null,
    "fav" boolean default false,
    "ext" text,
    "mime" text
);


alter table "public"."user_asset" enable row level security;

CREATE UNIQUE INDEX live_widget_background_pkey ON public.live_widget_background USING btree (live_widget);

CREATE UNIQUE INDEX live_widget_id_key ON public.live_widget USING btree (id);

CREATE UNIQUE INDEX live_widget_logo_pkey ON public.live_widget_logo USING btree (live_widget);

CREATE UNIQUE INDEX live_widget_pkey ON public.live_widget USING btree (widget_type, live_feed);

CREATE UNIQUE INDEX live_widget_running_text_pkey ON public.live_widget_running_text USING btree (live_widget);

CREATE UNIQUE INDEX live_widget_watermark_pkey ON public.live_widget_watermark USING btree (live_widget);

CREATE UNIQUE INDEX user_asset_pkey ON public.user_asset USING btree (id);

alter table "public"."live_widget" add constraint "live_widget_pkey" PRIMARY KEY using index "live_widget_pkey";

alter table "public"."live_widget_background" add constraint "live_widget_background_pkey" PRIMARY KEY using index "live_widget_background_pkey";

alter table "public"."live_widget_logo" add constraint "live_widget_logo_pkey" PRIMARY KEY using index "live_widget_logo_pkey";

alter table "public"."live_widget_running_text" add constraint "live_widget_running_text_pkey" PRIMARY KEY using index "live_widget_running_text_pkey";

alter table "public"."live_widget_watermark" add constraint "live_widget_watermark_pkey" PRIMARY KEY using index "live_widget_watermark_pkey";

alter table "public"."user_asset" add constraint "user_asset_pkey" PRIMARY KEY using index "user_asset_pkey";

alter table "public"."live_widget" add constraint "live_widget_id_key" UNIQUE using index "live_widget_id_key";

alter table "public"."live_widget" add constraint "live_widget_live_feed_fkey" FOREIGN KEY (live_feed) REFERENCES live_feed(id) not valid;

alter table "public"."live_widget" validate constraint "live_widget_live_feed_fkey";

alter table "public"."live_widget_background" add constraint "live_widget_background_asset_fkey" FOREIGN KEY (asset) REFERENCES user_asset(id) not valid;

alter table "public"."live_widget_background" validate constraint "live_widget_background_asset_fkey";

alter table "public"."live_widget_background" add constraint "live_widget_background_live_widget_fkey" FOREIGN KEY (live_widget) REFERENCES live_widget(id) not valid;

alter table "public"."live_widget_background" validate constraint "live_widget_background_live_widget_fkey";

alter table "public"."live_widget_logo" add constraint "live_widget_logo_asset_fkey" FOREIGN KEY (asset) REFERENCES user_asset(id) not valid;

alter table "public"."live_widget_logo" validate constraint "live_widget_logo_asset_fkey";

alter table "public"."live_widget_logo" add constraint "live_widget_logo_live_widget_fkey" FOREIGN KEY (live_widget) REFERENCES live_widget(id) not valid;

alter table "public"."live_widget_logo" validate constraint "live_widget_logo_live_widget_fkey";

alter table "public"."live_widget_running_text" add constraint "live_widget_running_text_live_widget_fkey" FOREIGN KEY (live_widget) REFERENCES live_widget(id) not valid;

alter table "public"."live_widget_running_text" validate constraint "live_widget_running_text_live_widget_fkey";

alter table "public"."live_widget_watermark" add constraint "live_widget_watermark_image_asset_fkey" FOREIGN KEY (image_asset) REFERENCES user_asset(id) not valid;

alter table "public"."live_widget_watermark" validate constraint "live_widget_watermark_image_asset_fkey";

alter table "public"."live_widget_watermark" add constraint "live_widget_watermark_live_widget_fkey" FOREIGN KEY (live_widget) REFERENCES live_widget(id) not valid;

alter table "public"."live_widget_watermark" validate constraint "live_widget_watermark_live_widget_fkey";

grant delete on table "public"."live_widget" to "anon";

grant insert on table "public"."live_widget" to "anon";

grant references on table "public"."live_widget" to "anon";

grant select on table "public"."live_widget" to "anon";

grant trigger on table "public"."live_widget" to "anon";

grant truncate on table "public"."live_widget" to "anon";

grant update on table "public"."live_widget" to "anon";

grant delete on table "public"."live_widget" to "authenticated";

grant insert on table "public"."live_widget" to "authenticated";

grant references on table "public"."live_widget" to "authenticated";

grant select on table "public"."live_widget" to "authenticated";

grant trigger on table "public"."live_widget" to "authenticated";

grant truncate on table "public"."live_widget" to "authenticated";

grant update on table "public"."live_widget" to "authenticated";

grant delete on table "public"."live_widget" to "service_role";

grant insert on table "public"."live_widget" to "service_role";

grant references on table "public"."live_widget" to "service_role";

grant select on table "public"."live_widget" to "service_role";

grant trigger on table "public"."live_widget" to "service_role";

grant truncate on table "public"."live_widget" to "service_role";

grant update on table "public"."live_widget" to "service_role";

grant delete on table "public"."live_widget_background" to "anon";

grant insert on table "public"."live_widget_background" to "anon";

grant references on table "public"."live_widget_background" to "anon";

grant select on table "public"."live_widget_background" to "anon";

grant trigger on table "public"."live_widget_background" to "anon";

grant truncate on table "public"."live_widget_background" to "anon";

grant update on table "public"."live_widget_background" to "anon";

grant delete on table "public"."live_widget_background" to "authenticated";

grant insert on table "public"."live_widget_background" to "authenticated";

grant references on table "public"."live_widget_background" to "authenticated";

grant select on table "public"."live_widget_background" to "authenticated";

grant trigger on table "public"."live_widget_background" to "authenticated";

grant truncate on table "public"."live_widget_background" to "authenticated";

grant update on table "public"."live_widget_background" to "authenticated";

grant delete on table "public"."live_widget_background" to "service_role";

grant insert on table "public"."live_widget_background" to "service_role";

grant references on table "public"."live_widget_background" to "service_role";

grant select on table "public"."live_widget_background" to "service_role";

grant trigger on table "public"."live_widget_background" to "service_role";

grant truncate on table "public"."live_widget_background" to "service_role";

grant update on table "public"."live_widget_background" to "service_role";

grant delete on table "public"."live_widget_logo" to "anon";

grant insert on table "public"."live_widget_logo" to "anon";

grant references on table "public"."live_widget_logo" to "anon";

grant select on table "public"."live_widget_logo" to "anon";

grant trigger on table "public"."live_widget_logo" to "anon";

grant truncate on table "public"."live_widget_logo" to "anon";

grant update on table "public"."live_widget_logo" to "anon";

grant delete on table "public"."live_widget_logo" to "authenticated";

grant insert on table "public"."live_widget_logo" to "authenticated";

grant references on table "public"."live_widget_logo" to "authenticated";

grant select on table "public"."live_widget_logo" to "authenticated";

grant trigger on table "public"."live_widget_logo" to "authenticated";

grant truncate on table "public"."live_widget_logo" to "authenticated";

grant update on table "public"."live_widget_logo" to "authenticated";

grant delete on table "public"."live_widget_logo" to "service_role";

grant insert on table "public"."live_widget_logo" to "service_role";

grant references on table "public"."live_widget_logo" to "service_role";

grant select on table "public"."live_widget_logo" to "service_role";

grant trigger on table "public"."live_widget_logo" to "service_role";

grant truncate on table "public"."live_widget_logo" to "service_role";

grant update on table "public"."live_widget_logo" to "service_role";

grant delete on table "public"."live_widget_running_text" to "anon";

grant insert on table "public"."live_widget_running_text" to "anon";

grant references on table "public"."live_widget_running_text" to "anon";

grant select on table "public"."live_widget_running_text" to "anon";

grant trigger on table "public"."live_widget_running_text" to "anon";

grant truncate on table "public"."live_widget_running_text" to "anon";

grant update on table "public"."live_widget_running_text" to "anon";

grant delete on table "public"."live_widget_running_text" to "authenticated";

grant insert on table "public"."live_widget_running_text" to "authenticated";

grant references on table "public"."live_widget_running_text" to "authenticated";

grant select on table "public"."live_widget_running_text" to "authenticated";

grant trigger on table "public"."live_widget_running_text" to "authenticated";

grant truncate on table "public"."live_widget_running_text" to "authenticated";

grant update on table "public"."live_widget_running_text" to "authenticated";

grant delete on table "public"."live_widget_running_text" to "service_role";

grant insert on table "public"."live_widget_running_text" to "service_role";

grant references on table "public"."live_widget_running_text" to "service_role";

grant select on table "public"."live_widget_running_text" to "service_role";

grant trigger on table "public"."live_widget_running_text" to "service_role";

grant truncate on table "public"."live_widget_running_text" to "service_role";

grant update on table "public"."live_widget_running_text" to "service_role";

grant delete on table "public"."live_widget_watermark" to "anon";

grant insert on table "public"."live_widget_watermark" to "anon";

grant references on table "public"."live_widget_watermark" to "anon";

grant select on table "public"."live_widget_watermark" to "anon";

grant trigger on table "public"."live_widget_watermark" to "anon";

grant truncate on table "public"."live_widget_watermark" to "anon";

grant update on table "public"."live_widget_watermark" to "anon";

grant delete on table "public"."live_widget_watermark" to "authenticated";

grant insert on table "public"."live_widget_watermark" to "authenticated";

grant references on table "public"."live_widget_watermark" to "authenticated";

grant select on table "public"."live_widget_watermark" to "authenticated";

grant trigger on table "public"."live_widget_watermark" to "authenticated";

grant truncate on table "public"."live_widget_watermark" to "authenticated";

grant update on table "public"."live_widget_watermark" to "authenticated";

grant delete on table "public"."live_widget_watermark" to "service_role";

grant insert on table "public"."live_widget_watermark" to "service_role";

grant references on table "public"."live_widget_watermark" to "service_role";

grant select on table "public"."live_widget_watermark" to "service_role";

grant trigger on table "public"."live_widget_watermark" to "service_role";

grant truncate on table "public"."live_widget_watermark" to "service_role";

grant update on table "public"."live_widget_watermark" to "service_role";

grant delete on table "public"."user_asset" to "anon";

grant insert on table "public"."user_asset" to "anon";

grant references on table "public"."user_asset" to "anon";

grant select on table "public"."user_asset" to "anon";

grant trigger on table "public"."user_asset" to "anon";

grant truncate on table "public"."user_asset" to "anon";

grant update on table "public"."user_asset" to "anon";

grant delete on table "public"."user_asset" to "authenticated";

grant insert on table "public"."user_asset" to "authenticated";

grant references on table "public"."user_asset" to "authenticated";

grant select on table "public"."user_asset" to "authenticated";

grant trigger on table "public"."user_asset" to "authenticated";

grant truncate on table "public"."user_asset" to "authenticated";

grant update on table "public"."user_asset" to "authenticated";

grant delete on table "public"."user_asset" to "service_role";

grant insert on table "public"."user_asset" to "service_role";

grant references on table "public"."user_asset" to "service_role";

grant select on table "public"."user_asset" to "service_role";

grant trigger on table "public"."user_asset" to "service_role";

grant truncate on table "public"."user_asset" to "service_role";

grant update on table "public"."user_asset" to "service_role";

create policy "Enable delete for users based on user_id"
on "public"."user_asset"
as permissive
for delete
to public
using ((( SELECT auth.uid() AS uid) = user_id));


create policy "Enable insert for users based on user_id"
on "public"."user_asset"
as permissive
for insert
to public
with check ((( SELECT auth.uid() AS uid) = user_id));


create policy "Enable read access for all users"
on "public"."user_asset"
as permissive
for select
to public
using (true);


create policy "only user id can update"
on "public"."user_asset"
as permissive
for update
to authenticated, anon
using ((( SELECT auth.uid() AS uid) = user_id));



