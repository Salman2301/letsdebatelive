alter table "public"."live_widget_background" drop constraint "live_widget_background_live_widget_fkey";

alter table "public"."live_widget_logo" drop constraint "live_widget_logo_live_widget_fkey";

alter table "public"."live_widget_running_text" drop constraint "live_widget_running_text_live_widget_fkey";

alter table "public"."live_widget_watermark" drop constraint "live_widget_watermark_live_widget_fkey";

alter table "public"."live_widget_background" drop constraint "live_widget_background_asset_fkey";

alter table "public"."live_widget_background" drop constraint "live_widget_background_pkey";

alter table "public"."live_widget_logo" drop constraint "live_widget_logo_pkey";

alter table "public"."live_widget_running_text" drop constraint "live_widget_running_text_pkey";

alter table "public"."live_widget_watermark" drop constraint "live_widget_watermark_pkey";

drop index if exists "public"."live_widget_background_pkey";

drop index if exists "public"."live_widget_logo_pkey";

drop index if exists "public"."live_widget_running_text_pkey";

drop index if exists "public"."live_widget_watermark_pkey";

alter table "public"."live_widget" drop column "data";

alter table "public"."live_widget_background" drop column "live_widget";

alter table "public"."live_widget_background" add column "live_feed" uuid not null;

alter table "public"."live_widget_background" add column "widget_type" widget_type not null default 'background'::widget_type;

alter table "public"."live_widget_logo" drop column "live_widget";

alter table "public"."live_widget_logo" drop column "position";

alter table "public"."live_widget_logo" add column "live_feed" uuid not null;

alter table "public"."live_widget_logo" add column "pos_col_index" smallint default '0'::smallint;

alter table "public"."live_widget_logo" add column "pos_row_index" smallint default '0'::smallint;

alter table "public"."live_widget_logo" add column "widget_type" widget_type not null default 'logo'::widget_type;

alter table "public"."live_widget_logo" alter column "asset" set not null;

alter table "public"."live_widget_running_text" drop column "live_widget";

alter table "public"."live_widget_running_text" add column "live_feed" uuid not null;

alter table "public"."live_widget_running_text" add column "widget_type" widget_type not null default 'running_text'::widget_type;

alter table "public"."live_widget_watermark" drop column "live_widget";

alter table "public"."live_widget_watermark" drop column "position";

alter table "public"."live_widget_watermark" add column "live_feed" uuid not null;

alter table "public"."live_widget_watermark" add column "pos_col_index" smallint default '0'::smallint;

alter table "public"."live_widget_watermark" add column "pos_row_index" smallint default '0'::smallint;

alter table "public"."live_widget_watermark" add column "widget_type" widget_type not null default 'watermark'::widget_type;

CREATE UNIQUE INDEX live_widget_background_pkey ON public.live_widget_background USING btree (live_feed, widget_type);

CREATE UNIQUE INDEX live_widget_logo_pkey ON public.live_widget_logo USING btree (live_feed, widget_type);

CREATE UNIQUE INDEX live_widget_running_text_pkey ON public.live_widget_running_text USING btree (live_feed, widget_type);

CREATE UNIQUE INDEX live_widget_watermark_pkey ON public.live_widget_watermark USING btree (live_feed, widget_type);

alter table "public"."live_widget_background" add constraint "live_widget_background_pkey" PRIMARY KEY using index "live_widget_background_pkey";

alter table "public"."live_widget_logo" add constraint "live_widget_logo_pkey" PRIMARY KEY using index "live_widget_logo_pkey";

alter table "public"."live_widget_running_text" add constraint "live_widget_running_text_pkey" PRIMARY KEY using index "live_widget_running_text_pkey";

alter table "public"."live_widget_watermark" add constraint "live_widget_watermark_pkey" PRIMARY KEY using index "live_widget_watermark_pkey";

alter table "public"."live_widget_background" add constraint "live_widget_background_live_feed_fkey" FOREIGN KEY (live_feed) REFERENCES live_feed(id) not valid;

alter table "public"."live_widget_background" validate constraint "live_widget_background_live_feed_fkey";

alter table "public"."live_widget_logo" add constraint "live_widget_logo_live_feed_fkey" FOREIGN KEY (live_feed) REFERENCES live_feed(id) not valid;

alter table "public"."live_widget_logo" validate constraint "live_widget_logo_live_feed_fkey";

alter table "public"."live_widget_running_text" add constraint "live_widget_running_text_live_feed_fkey" FOREIGN KEY (live_feed) REFERENCES live_feed(id) not valid;

alter table "public"."live_widget_running_text" validate constraint "live_widget_running_text_live_feed_fkey";

alter table "public"."live_widget_watermark" add constraint "live_widget_watermark_live_feed_fkey" FOREIGN KEY (live_feed) REFERENCES live_feed(id) not valid;

alter table "public"."live_widget_watermark" validate constraint "live_widget_watermark_live_feed_fkey";

alter table "public"."live_widget_background" add constraint "live_widget_background_asset_fkey" FOREIGN KEY (asset) REFERENCES user_asset(id) ON DELETE CASCADE not valid;

alter table "public"."live_widget_background" validate constraint "live_widget_background_asset_fkey";

create policy "User atlease co-host insert"
on "public"."live_widget"
as permissive
for insert
to authenticated
with check (user_atleast_co_host(live_feed));


create policy "User atlease cohost update"
on "public"."live_widget"
as permissive
for update
to public
using (user_atleast_co_host(live_feed));


create policy "User atleast cohost delete"
on "public"."live_widget"
as permissive
for delete
to authenticated
using (user_atleast_co_host(live_feed));


create policy "anyone can see"
on "public"."live_widget"
as permissive
for select
to public
using (true);


create policy "User atlease cohost insert"
on "public"."live_widget_background"
as permissive
for insert
to authenticated
with check (user_atleast_co_host(live_feed));


create policy "User atleast cohost delete"
on "public"."live_widget_background"
as permissive
for delete
to authenticated
using (user_atleast_co_host(live_feed));


create policy "Usert atlease cohost update"
on "public"."live_widget_background"
as permissive
for update
to authenticated
using (user_atleast_co_host(live_feed));


create policy "anyone can see"
on "public"."live_widget_background"
as permissive
for select
to public
using (true);


create policy "Anyone can read"
on "public"."live_widget_logo"
as permissive
for select
to public
using (true);


create policy "User atleast cohost delete"
on "public"."live_widget_logo"
as permissive
for delete
to public
using (user_atleast_co_host(live_feed));


create policy "User atleast cohost insert"
on "public"."live_widget_logo"
as permissive
for insert
to authenticated
with check (user_atleast_co_host(live_feed));


create policy "User atleast cohost update"
on "public"."live_widget_logo"
as permissive
for update
to authenticated
using (user_atleast_co_host(live_feed));


create policy "Anyone can see"
on "public"."live_widget_running_text"
as permissive
for select
to public
using (true);


create policy "User atleast cohost delete"
on "public"."live_widget_running_text"
as permissive
for delete
to authenticated
using (user_atleast_co_host(live_feed));


create policy "User atleast cohost insert"
on "public"."live_widget_running_text"
as permissive
for insert
to authenticated
with check (user_atleast_co_host(live_feed));


create policy "User atleast cohost update"
on "public"."live_widget_running_text"
as permissive
for update
to authenticated
using (user_atleast_co_host(live_feed));


create policy "Anyone can see"
on "public"."live_widget_watermark"
as permissive
for select
to public
using (true);


create policy "User atleast cohost delete"
on "public"."live_widget_watermark"
as permissive
for delete
to authenticated
using (user_atleast_co_host(live_feed));


create policy "User atleast cohost insert"
on "public"."live_widget_watermark"
as permissive
for insert
to authenticated
with check (user_atleast_co_host(live_feed));


create policy "User atleast cohost update"
on "public"."live_widget_watermark"
as permissive
for update
to authenticated
using (user_atleast_co_host(live_feed));



