create type "public"."notification_service" as enum ('live_chat', 'backstage_chat', 'screen_share_new', 'backstage_new_participant', 'poll_result', 'question_answer', 'activity_feed');

create type "public"."participant_location" as enum ('stage', 'backstage');

drop policy "Enable insert for authenticated users only" on "public"."live_debate_participants";

drop policy "Enable update for users based on email" on "public"."live_debate_participants";

alter table "public"."live_debate_participants" drop constraint "public_live_debate_participants_debate_fkey";

alter table "public"."live_debate_participants" drop constraint "live_debate_participants_pkey";

drop index if exists "public"."live_debate_participants_pkey";

create table "public"."live_debate_backstage_chat" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "chat" text not null,
    "live_debate_id" uuid not null,
    "sender_id" uuid not null
);


alter table "public"."live_debate_backstage_chat" enable row level security;

create table "public"."live_debate_chat" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "chat" text not null,
    "live_debate" uuid not null,
    "sender_id" uuid not null
);


alter table "public"."live_debate_chat" enable row level security;

create table "public"."live_debate_kick" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "kicked_by" uuid not null,
    "live_debate" uuid not null,
    "user_id" uuid not null,
    "reason" text
);


alter table "public"."live_debate_kick" enable row level security;

create table "public"."live_debate_notification" (
    "created_at" timestamp with time zone not null default now(),
    "live_debate" uuid not null,
    "service" notification_service not null,
    "has_read" boolean not null,
    "missed_count" integer
);


alter table "public"."live_debate_notification" enable row level security;

create table "public"."live_host_ban" (
    "created_at" timestamp with time zone not null default now(),
    "live_debate" uuid,
    "user_id" uuid not null,
    "live_host_id" uuid not null,
    "reason_title" text,
    "reason" text,
    "banned_by" uuid not null
);


alter table "public"."live_host_ban" enable row level security;

alter table "public"."live_debate_participants" drop column "debate";

alter table "public"."live_debate_participants" drop column "id";

alter table "public"."live_debate_participants" drop column "is_debate_owner";

alter table "public"."live_debate_participants" add column "hand_raised" boolean;

alter table "public"."live_debate_participants" add column "is_host" boolean not null;

alter table "public"."live_debate_participants" add column "live_debate" uuid not null;

alter table "public"."live_debate_participants" add column "location" participant_location not null;

alter table "public"."live_debate_participants" add column "participant_id" uuid not null default auth.uid();

alter table "public"."live_debate_participants" alter column "display_name" set not null;

alter table "public"."live_debate_participants" alter column "team" set not null;

CREATE UNIQUE INDEX live_debate_backstage_chat_pkey ON public.live_debate_backstage_chat USING btree (id);

CREATE UNIQUE INDEX live_debate_chat_pkey ON public.live_debate_chat USING btree (id);

CREATE UNIQUE INDEX live_debate_kick_pkey ON public.live_debate_kick USING btree (id);

CREATE UNIQUE INDEX live_debate_notification_pkey ON public.live_debate_notification USING btree (live_debate, service);

CREATE UNIQUE INDEX live_host_ban_pkey ON public.live_host_ban USING btree (user_id, live_host_id);

CREATE UNIQUE INDEX live_debate_participants_pkey ON public.live_debate_participants USING btree (participant_id, live_debate);

alter table "public"."live_debate_backstage_chat" add constraint "live_debate_backstage_chat_pkey" PRIMARY KEY using index "live_debate_backstage_chat_pkey";

alter table "public"."live_debate_chat" add constraint "live_debate_chat_pkey" PRIMARY KEY using index "live_debate_chat_pkey";

alter table "public"."live_debate_kick" add constraint "live_debate_kick_pkey" PRIMARY KEY using index "live_debate_kick_pkey";

alter table "public"."live_debate_notification" add constraint "live_debate_notification_pkey" PRIMARY KEY using index "live_debate_notification_pkey";

alter table "public"."live_host_ban" add constraint "live_host_ban_pkey" PRIMARY KEY using index "live_host_ban_pkey";

alter table "public"."live_debate_participants" add constraint "live_debate_participants_pkey" PRIMARY KEY using index "live_debate_participants_pkey";

alter table "public"."live_debate_backstage_chat" add constraint "live_debate_backstage_chat_live_debate_id_fkey" FOREIGN KEY (live_debate_id) REFERENCES live_debate(id) ON DELETE CASCADE not valid;

alter table "public"."live_debate_backstage_chat" validate constraint "live_debate_backstage_chat_live_debate_id_fkey";

alter table "public"."live_debate_backstage_chat" add constraint "live_debate_backstage_chat_sender_id_fkey" FOREIGN KEY (sender_id) REFERENCES user_data(id) not valid;

alter table "public"."live_debate_backstage_chat" validate constraint "live_debate_backstage_chat_sender_id_fkey";

alter table "public"."live_debate_chat" add constraint "live_debate_chat_live_debate_fkey" FOREIGN KEY (live_debate) REFERENCES live_debate(id) ON DELETE CASCADE not valid;

alter table "public"."live_debate_chat" validate constraint "live_debate_chat_live_debate_fkey";

alter table "public"."live_debate_chat" add constraint "live_debate_chat_sender_id_fkey" FOREIGN KEY (sender_id) REFERENCES user_data(id) ON DELETE CASCADE not valid;

alter table "public"."live_debate_chat" validate constraint "live_debate_chat_sender_id_fkey";

alter table "public"."live_debate_kick" add constraint "live_debate_kick_kicked_by_fkey" FOREIGN KEY (kicked_by) REFERENCES user_data(id) ON DELETE CASCADE not valid;

alter table "public"."live_debate_kick" validate constraint "live_debate_kick_kicked_by_fkey";

alter table "public"."live_debate_kick" add constraint "live_debate_kick_live_debate_fkey" FOREIGN KEY (live_debate) REFERENCES live_debate(id) ON DELETE CASCADE not valid;

alter table "public"."live_debate_kick" validate constraint "live_debate_kick_live_debate_fkey";

alter table "public"."live_debate_kick" add constraint "live_debate_kick_user_id_fkey" FOREIGN KEY (user_id) REFERENCES user_data(id) ON DELETE CASCADE not valid;

alter table "public"."live_debate_kick" validate constraint "live_debate_kick_user_id_fkey";

alter table "public"."live_debate_notification" add constraint "live_debate_notification_live_debate_fkey" FOREIGN KEY (live_debate) REFERENCES live_debate(id) ON DELETE CASCADE not valid;

alter table "public"."live_debate_notification" validate constraint "live_debate_notification_live_debate_fkey";

alter table "public"."live_debate_participants" add constraint "live_debate_participants_id_fkey" FOREIGN KEY (participant_id) REFERENCES user_data(id) not valid;

alter table "public"."live_debate_participants" validate constraint "live_debate_participants_id_fkey";

alter table "public"."live_debate_participants" add constraint "live_debate_participants_live_debate_fkey" FOREIGN KEY (live_debate) REFERENCES live_debate(id) ON DELETE CASCADE not valid;

alter table "public"."live_debate_participants" validate constraint "live_debate_participants_live_debate_fkey";

alter table "public"."live_host_ban" add constraint "live_host_ban_banned_by_fkey" FOREIGN KEY (banned_by) REFERENCES user_data(id) ON DELETE CASCADE not valid;

alter table "public"."live_host_ban" validate constraint "live_host_ban_banned_by_fkey";

alter table "public"."live_host_ban" add constraint "live_host_ban_live_debate_fkey" FOREIGN KEY (live_debate) REFERENCES live_debate(id) ON DELETE CASCADE not valid;

alter table "public"."live_host_ban" validate constraint "live_host_ban_live_debate_fkey";

alter table "public"."live_host_ban" add constraint "live_host_ban_live_host_id_fkey" FOREIGN KEY (live_host_id) REFERENCES user_data(id) ON DELETE CASCADE not valid;

alter table "public"."live_host_ban" validate constraint "live_host_ban_live_host_id_fkey";

alter table "public"."live_host_ban" add constraint "live_host_ban_user_id_fkey" FOREIGN KEY (user_id) REFERENCES user_data(id) ON DELETE CASCADE not valid;

alter table "public"."live_host_ban" validate constraint "live_host_ban_user_id_fkey";

grant delete on table "public"."live_debate_backstage_chat" to "anon";

grant insert on table "public"."live_debate_backstage_chat" to "anon";

grant references on table "public"."live_debate_backstage_chat" to "anon";

grant select on table "public"."live_debate_backstage_chat" to "anon";

grant trigger on table "public"."live_debate_backstage_chat" to "anon";

grant truncate on table "public"."live_debate_backstage_chat" to "anon";

grant update on table "public"."live_debate_backstage_chat" to "anon";

grant delete on table "public"."live_debate_backstage_chat" to "authenticated";

grant insert on table "public"."live_debate_backstage_chat" to "authenticated";

grant references on table "public"."live_debate_backstage_chat" to "authenticated";

grant select on table "public"."live_debate_backstage_chat" to "authenticated";

grant trigger on table "public"."live_debate_backstage_chat" to "authenticated";

grant truncate on table "public"."live_debate_backstage_chat" to "authenticated";

grant update on table "public"."live_debate_backstage_chat" to "authenticated";

grant delete on table "public"."live_debate_backstage_chat" to "service_role";

grant insert on table "public"."live_debate_backstage_chat" to "service_role";

grant references on table "public"."live_debate_backstage_chat" to "service_role";

grant select on table "public"."live_debate_backstage_chat" to "service_role";

grant trigger on table "public"."live_debate_backstage_chat" to "service_role";

grant truncate on table "public"."live_debate_backstage_chat" to "service_role";

grant update on table "public"."live_debate_backstage_chat" to "service_role";

grant delete on table "public"."live_debate_chat" to "anon";

grant insert on table "public"."live_debate_chat" to "anon";

grant references on table "public"."live_debate_chat" to "anon";

grant select on table "public"."live_debate_chat" to "anon";

grant trigger on table "public"."live_debate_chat" to "anon";

grant truncate on table "public"."live_debate_chat" to "anon";

grant update on table "public"."live_debate_chat" to "anon";

grant delete on table "public"."live_debate_chat" to "authenticated";

grant insert on table "public"."live_debate_chat" to "authenticated";

grant references on table "public"."live_debate_chat" to "authenticated";

grant select on table "public"."live_debate_chat" to "authenticated";

grant trigger on table "public"."live_debate_chat" to "authenticated";

grant truncate on table "public"."live_debate_chat" to "authenticated";

grant update on table "public"."live_debate_chat" to "authenticated";

grant delete on table "public"."live_debate_chat" to "service_role";

grant insert on table "public"."live_debate_chat" to "service_role";

grant references on table "public"."live_debate_chat" to "service_role";

grant select on table "public"."live_debate_chat" to "service_role";

grant trigger on table "public"."live_debate_chat" to "service_role";

grant truncate on table "public"."live_debate_chat" to "service_role";

grant update on table "public"."live_debate_chat" to "service_role";

grant delete on table "public"."live_debate_kick" to "anon";

grant insert on table "public"."live_debate_kick" to "anon";

grant references on table "public"."live_debate_kick" to "anon";

grant select on table "public"."live_debate_kick" to "anon";

grant trigger on table "public"."live_debate_kick" to "anon";

grant truncate on table "public"."live_debate_kick" to "anon";

grant update on table "public"."live_debate_kick" to "anon";

grant delete on table "public"."live_debate_kick" to "authenticated";

grant insert on table "public"."live_debate_kick" to "authenticated";

grant references on table "public"."live_debate_kick" to "authenticated";

grant select on table "public"."live_debate_kick" to "authenticated";

grant trigger on table "public"."live_debate_kick" to "authenticated";

grant truncate on table "public"."live_debate_kick" to "authenticated";

grant update on table "public"."live_debate_kick" to "authenticated";

grant delete on table "public"."live_debate_kick" to "service_role";

grant insert on table "public"."live_debate_kick" to "service_role";

grant references on table "public"."live_debate_kick" to "service_role";

grant select on table "public"."live_debate_kick" to "service_role";

grant trigger on table "public"."live_debate_kick" to "service_role";

grant truncate on table "public"."live_debate_kick" to "service_role";

grant update on table "public"."live_debate_kick" to "service_role";

grant delete on table "public"."live_debate_notification" to "anon";

grant insert on table "public"."live_debate_notification" to "anon";

grant references on table "public"."live_debate_notification" to "anon";

grant select on table "public"."live_debate_notification" to "anon";

grant trigger on table "public"."live_debate_notification" to "anon";

grant truncate on table "public"."live_debate_notification" to "anon";

grant update on table "public"."live_debate_notification" to "anon";

grant delete on table "public"."live_debate_notification" to "authenticated";

grant insert on table "public"."live_debate_notification" to "authenticated";

grant references on table "public"."live_debate_notification" to "authenticated";

grant select on table "public"."live_debate_notification" to "authenticated";

grant trigger on table "public"."live_debate_notification" to "authenticated";

grant truncate on table "public"."live_debate_notification" to "authenticated";

grant update on table "public"."live_debate_notification" to "authenticated";

grant delete on table "public"."live_debate_notification" to "service_role";

grant insert on table "public"."live_debate_notification" to "service_role";

grant references on table "public"."live_debate_notification" to "service_role";

grant select on table "public"."live_debate_notification" to "service_role";

grant trigger on table "public"."live_debate_notification" to "service_role";

grant truncate on table "public"."live_debate_notification" to "service_role";

grant update on table "public"."live_debate_notification" to "service_role";

grant delete on table "public"."live_host_ban" to "anon";

grant insert on table "public"."live_host_ban" to "anon";

grant references on table "public"."live_host_ban" to "anon";

grant select on table "public"."live_host_ban" to "anon";

grant trigger on table "public"."live_host_ban" to "anon";

grant truncate on table "public"."live_host_ban" to "anon";

grant update on table "public"."live_host_ban" to "anon";

grant delete on table "public"."live_host_ban" to "authenticated";

grant insert on table "public"."live_host_ban" to "authenticated";

grant references on table "public"."live_host_ban" to "authenticated";

grant select on table "public"."live_host_ban" to "authenticated";

grant trigger on table "public"."live_host_ban" to "authenticated";

grant truncate on table "public"."live_host_ban" to "authenticated";

grant update on table "public"."live_host_ban" to "authenticated";

grant delete on table "public"."live_host_ban" to "service_role";

grant insert on table "public"."live_host_ban" to "service_role";

grant references on table "public"."live_host_ban" to "service_role";

grant select on table "public"."live_host_ban" to "service_role";

grant trigger on table "public"."live_host_ban" to "service_role";

grant truncate on table "public"."live_host_ban" to "service_role";

grant update on table "public"."live_host_ban" to "service_role";

create policy "Enable insert for authenticated users only"
on "public"."live_debate_participants"
as permissive
for insert
to authenticated
with check ((( SELECT auth.uid() AS uid) = participant_id));


create policy "Enable update for users based on email"
on "public"."live_debate_participants"
as permissive
for update
to public
using ((( SELECT auth.uid() AS uid) = participant_id))
with check ((( SELECT auth.uid() AS uid) = participant_id));



