
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

CREATE EXTENSION IF NOT EXISTS "pg_net" WITH SCHEMA "extensions";

CREATE EXTENSION IF NOT EXISTS "pgsodium" WITH SCHEMA "pgsodium";

COMMENT ON SCHEMA "public" IS 'standard public schema';

CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";

CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";

CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";

CREATE EXTENSION IF NOT EXISTS "pgjwt" WITH SCHEMA "extensions";

CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";

CREATE TYPE "public"."audience_service" AS ENUM (
    'viewer',
    'chat',
    'backstage'
);

ALTER TYPE "public"."audience_service" OWNER TO "postgres";

CREATE TYPE "public"."audience_type" AS ENUM (
    'supporter',
    'follower',
    'team-only',
    'registered',
    'anonymous',
    'invite_only',
    'none'
);

ALTER TYPE "public"."audience_type" OWNER TO "postgres";

CREATE TYPE "public"."notification_service" AS ENUM (
    'live_chat',
    'backstage_chat',
    'screen_share_new',
    'backstage_new_participant',
    'poll_result',
    'question_answer',
    'activity_feed'
);

ALTER TYPE "public"."notification_service" OWNER TO "postgres";

CREATE TYPE "public"."participant_location" AS ENUM (
    'stage',
    'backstage'
);

ALTER TYPE "public"."participant_location" OWNER TO "postgres";

CREATE TYPE "public"."role" AS ENUM (
    'host',
    'co-host',
    'mod',
    'guest'
);

ALTER TYPE "public"."role" OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."is_space_left"("live_debate_id" "uuid") RETURNS boolean
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$BEGIN
  RETURN (
    (SELECT COUNT(*) 
      FROM live_debate_participants AS ldp
      WHERE ldp.live_debate = live_debate_id) < 
    (SELECT ld.max_participants 
      FROM live_debate AS ld 
      WHERE ld.id = live_debate_id)
  );
END;$$;

ALTER FUNCTION "public"."is_space_left"("live_debate_id" "uuid") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."turn_on_realtime"() RETURNS "text"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$DECLARE
row record;
BEGIN
FOR row IN SELECT tablename FROM pg_tables AS t
WHERE t.schemaname = 'public'
AND t.tablename LIKE 'live_%'
OR t.tablename = 'user_data'
LOOP
    -- Check if the table is already part of the publication
    IF NOT EXISTS (
        SELECT 1 FROM pg_publication_tables
        WHERE pubname = 'supabase_realtime' 
        AND schemaname = 'public'
        AND tablename = row.tablename
    ) THEN
        -- Run query to add table to publication
        EXECUTE format('ALTER PUBLICATION supabase_realtime ADD TABLE %I;', row.tablename);
    END IF;
END LOOP;
RETURN 'success';
END;$$;

ALTER FUNCTION "public"."turn_on_realtime"() OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."user_atleast_co_host"("live_debate_id" "uuid") RETURNS boolean
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$BEGIN
  RETURN EXISTS (
    SELECT 1 
    FROM live_debate_user_role
    WHERE (SELECT auth.uid() as uid) = user_id
    AND live_debate = live_debate_id
    AND role IN ('host', 'co-host')
  );
END;$$;

ALTER FUNCTION "public"."user_atleast_co_host"("live_debate_id" "uuid") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."user_atleast_mod"("live_debate_id" "uuid") RETURNS boolean
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$BEGIN
  RETURN EXISTS (
    SELECT 1 
    FROM live_debate_user_role
    WHERE (SELECT auth.uid() as uid) = user_id
    AND live_debate = live_debate_id
    AND role IN ('host', 'co-host', 'mod')
  );
END;$$;

ALTER FUNCTION "public"."user_atleast_mod"("live_debate_id" "uuid") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."user_is_host"("live_debate_id" "uuid") RETURNS boolean
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$BEGIN
  RETURN EXISTS (
    SELECT 1 
    FROM live_debate_user_role
    WHERE (SELECT auth.uid() as uid) = user_id
    AND live_debate = live_debate_id
    AND role IN ('host')
  );
END;$$;

ALTER FUNCTION "public"."user_is_host"("live_debate_id" "uuid") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."user_not_banned"() RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$BEGIN
  RETURN NOT EXISTS (
    SELECT 1 
    FROM live_user_ban
    WHERE (SELECT auth.uid() as uid) = user_id
  );
END;$$;

ALTER FUNCTION "public"."user_not_banned"() OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";

CREATE TABLE IF NOT EXISTS "public"."host_stream_key" (
    "id" "uuid" DEFAULT "auth"."uid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "stream_key" "text" NOT NULL
);

ALTER TABLE "public"."host_stream_key" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."live_debate" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "title" "text",
    "host" "uuid" DEFAULT "auth"."uid"(),
    "chat_rules" "text",
    "debate_type" "text",
    "chat_filter_words" "text",
    "backstage_max" integer,
    "studio_mode" boolean,
    "debater_card_show" boolean,
    "published" boolean,
    "max_participants" bigint DEFAULT '40'::bigint NOT NULL,
    "max_stage" bigint DEFAULT '30'::bigint NOT NULL,
    "backstage_audience" "public"."audience_type"[],
    "chat_audience" "public"."audience_type"[],
    "viewer_audience" "public"."audience_type"[],
    "auto_move_to_stage" boolean,
    "ended" boolean,
    "ended_tz" timestamp with time zone,
    "published_tz" timestamp with time zone
);

ALTER TABLE "public"."live_debate" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."live_debate_agenda" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "live_debate" "uuid",
    "title" "text",
    "time" time without time zone,
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "completed" boolean,
    "team" "uuid"
);

ALTER TABLE "public"."live_debate_agenda" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."live_debate_audience_team_only" (
    "live_debate" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "service" "public"."audience_service" NOT NULL,
    "team" "uuid" NOT NULL
);

ALTER TABLE "public"."live_debate_audience_team_only" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."live_debate_backstage_chat" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "chat" "text" NOT NULL,
    "live_debate_id" "uuid" NOT NULL,
    "sender_id" "uuid" NOT NULL
);

ALTER TABLE "public"."live_debate_backstage_chat" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."live_debate_chat" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "chat" "text" NOT NULL,
    "live_debate" "uuid" NOT NULL,
    "sender_id" "uuid" NOT NULL
);

ALTER TABLE "public"."live_debate_chat" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."live_debate_invite_co_host" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "invited_by" "uuid" NOT NULL,
    "status" "text" NOT NULL,
    "email" "text" NOT NULL,
    "team" "uuid",
    "live_debate" "uuid" NOT NULL
);

ALTER TABLE "public"."live_debate_invite_co_host" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."live_debate_kick" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "kicked_by" "uuid" NOT NULL,
    "live_debate" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "reason" "text"
);

ALTER TABLE "public"."live_debate_kick" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."live_debate_notification" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "live_debate" "uuid" NOT NULL,
    "service" "public"."notification_service" NOT NULL,
    "has_read" boolean NOT NULL,
    "missed_count" integer
);

ALTER TABLE "public"."live_debate_notification" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."live_debate_participants" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "speaker_id" "text",
    "mic_id" "text",
    "cam_id" "text",
    "speaker_enable" boolean DEFAULT true,
    "mic_enable" boolean DEFAULT true,
    "cam_enable" boolean DEFAULT true,
    "screenshare_available" boolean,
    "speaker_available" boolean,
    "mic_available" boolean,
    "cam_available" boolean,
    "current_stage" "text",
    "is_kicked" boolean,
    "display_name" "text" NOT NULL,
    "team" "uuid",
    "hand_raised" boolean,
    "live_debate" "uuid" NOT NULL,
    "location" "public"."participant_location" NOT NULL,
    "participant_id" "uuid" DEFAULT "auth"."uid"() NOT NULL,
    "host_id" "uuid",
    "profile_image_enable" boolean,
    "screenshare_enable" boolean,
    "hand_raised_at" timestamp with time zone,
    "role" "public"."role" NOT NULL
);

ALTER TABLE "public"."live_debate_participants" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."live_debate_team" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "color" "text" NOT NULL,
    "title" "text" NOT NULL,
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "live_debate" "uuid" NOT NULL,
    "slug" character varying NOT NULL,
    "is_default" boolean
);

ALTER TABLE "public"."live_debate_team" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."live_debate_user_role" (
    "user_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "live_debate" "uuid" NOT NULL,
    "role" "public"."role" NOT NULL
);

ALTER TABLE "public"."live_debate_user_role" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."live_debate_user_team" (
    "user_id" "uuid" DEFAULT "auth"."uid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "live_debate" "uuid" NOT NULL,
    "team" "uuid" NOT NULL
);

ALTER TABLE "public"."live_debate_user_team" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."live_host_ban" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "live_debate" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "reason_title" "text",
    "reason" "text",
    "banned_by" "uuid" DEFAULT "auth"."uid"() NOT NULL
);

ALTER TABLE "public"."live_host_ban" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."live_host_follower" (
    "id" "uuid" DEFAULT "auth"."uid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "count" bigint
);

ALTER TABLE "public"."live_host_follower" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."live_host_support" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "count" bigint
);

ALTER TABLE "public"."live_host_support" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."live_user_ban" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "title" "text",
    "description" "text",
    "banned_until" timestamp with time zone
);

ALTER TABLE "public"."live_user_ban" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."social_links" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "link" "text",
    "media" "text",
    "user_id" "uuid" DEFAULT "auth"."uid"()
);

ALTER TABLE "public"."social_links" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."user_data" (
    "id" "uuid" DEFAULT "auth"."uid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "displayName" "text",
    "email" "text",
    "firstName" "text",
    "lastName" "text",
    "fullName" "text",
    "username" "text" NOT NULL,
    "initials" "text",
    "oneLineDesc" "text",
    "profile_image" "text"
);

ALTER TABLE "public"."user_data" OWNER TO "postgres";

COMMENT ON TABLE "public"."user_data" IS 'User data extra info';

CREATE TABLE IF NOT EXISTS "public"."user_email" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "user_id" "uuid",
    "email" "text",
    "verified" boolean
);

ALTER TABLE "public"."user_email" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."user_phone" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "user_id" "uuid" DEFAULT "auth"."uid"(),
    "phone" "text",
    "country" "text",
    "verified" boolean
);

ALTER TABLE "public"."user_phone" OWNER TO "postgres";

ALTER TABLE ONLY "public"."live_debate_agenda"
    ADD CONSTRAINT "debate_agenda_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."live_debate_team"
    ADD CONSTRAINT "debate_team_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."host_stream_key"
    ADD CONSTRAINT "host_stream_key_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."live_debate_audience_team_only"
    ADD CONSTRAINT "live_debate_audience_team_only_pkey" PRIMARY KEY ("team", "live_debate", "service");

ALTER TABLE ONLY "public"."live_debate_backstage_chat"
    ADD CONSTRAINT "live_debate_backstage_chat_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."live_debate_chat"
    ADD CONSTRAINT "live_debate_chat_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."live_debate_invite_co_host"
    ADD CONSTRAINT "live_debate_invite_co_host_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."live_debate_kick"
    ADD CONSTRAINT "live_debate_kick_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."live_debate_notification"
    ADD CONSTRAINT "live_debate_notification_pkey" PRIMARY KEY ("live_debate", "service");

ALTER TABLE ONLY "public"."live_debate_participants"
    ADD CONSTRAINT "live_debate_participants_pkey" PRIMARY KEY ("live_debate", "participant_id");

ALTER TABLE ONLY "public"."live_debate"
    ADD CONSTRAINT "live_debate_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."live_debate_user_role"
    ADD CONSTRAINT "live_debate_user_role_pkey" PRIMARY KEY ("user_id", "live_debate");

ALTER TABLE ONLY "public"."live_debate_user_team"
    ADD CONSTRAINT "live_debate_user_team_pkey" PRIMARY KEY ("user_id", "live_debate");

ALTER TABLE ONLY "public"."live_host_ban"
    ADD CONSTRAINT "live_host_ban_pkey" PRIMARY KEY ("live_debate", "user_id");

ALTER TABLE ONLY "public"."live_host_follower"
    ADD CONSTRAINT "live_host_follower_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."live_host_support"
    ADD CONSTRAINT "live_host_support_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."live_user_ban"
    ADD CONSTRAINT "live_user_ban_pkey" PRIMARY KEY ("id", "user_id");

ALTER TABLE ONLY "public"."social_links"
    ADD CONSTRAINT "social_links_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."user_data"
    ADD CONSTRAINT "user_data_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."user_data"
    ADD CONSTRAINT "user_data_username_key" UNIQUE ("username");

ALTER TABLE ONLY "public"."user_email"
    ADD CONSTRAINT "user_email_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."user_phone"
    ADD CONSTRAINT "user_phone_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."live_debate_agenda"
    ADD CONSTRAINT "debate_agenda_live_debate_fkey" FOREIGN KEY ("live_debate") REFERENCES "public"."live_debate"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."live_debate_agenda"
    ADD CONSTRAINT "debate_agenda_team_fkey" FOREIGN KEY ("team") REFERENCES "public"."live_debate_team"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."live_debate_audience_team_only"
    ADD CONSTRAINT "live_debate_audience_team_only_live_debate_fkey" FOREIGN KEY ("live_debate") REFERENCES "public"."live_debate"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."live_debate_audience_team_only"
    ADD CONSTRAINT "live_debate_audience_team_only_team_fkey" FOREIGN KEY ("team") REFERENCES "public"."live_debate_team"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."live_debate_backstage_chat"
    ADD CONSTRAINT "live_debate_backstage_chat_live_debate_id_fkey" FOREIGN KEY ("live_debate_id") REFERENCES "public"."live_debate"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."live_debate_backstage_chat"
    ADD CONSTRAINT "live_debate_backstage_chat_sender_id_fkey" FOREIGN KEY ("sender_id") REFERENCES "public"."user_data"("id");

ALTER TABLE ONLY "public"."live_debate_chat"
    ADD CONSTRAINT "live_debate_chat_live_debate_fkey" FOREIGN KEY ("live_debate") REFERENCES "public"."live_debate"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."live_debate_chat"
    ADD CONSTRAINT "live_debate_chat_sender_id_fkey" FOREIGN KEY ("sender_id") REFERENCES "public"."user_data"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."live_debate_invite_co_host"
    ADD CONSTRAINT "live_debate_invite_co_host_invited_by_fkey" FOREIGN KEY ("invited_by") REFERENCES "public"."user_data"("id");

ALTER TABLE ONLY "public"."live_debate_invite_co_host"
    ADD CONSTRAINT "live_debate_invite_co_host_live_debate_fkey" FOREIGN KEY ("live_debate") REFERENCES "public"."live_debate"("id");

ALTER TABLE ONLY "public"."live_debate_invite_co_host"
    ADD CONSTRAINT "live_debate_invite_co_host_team_fkey" FOREIGN KEY ("team") REFERENCES "public"."live_debate_team"("id");

ALTER TABLE ONLY "public"."live_debate_kick"
    ADD CONSTRAINT "live_debate_kick_kicked_by_fkey" FOREIGN KEY ("kicked_by") REFERENCES "public"."user_data"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."live_debate_kick"
    ADD CONSTRAINT "live_debate_kick_live_debate_fkey" FOREIGN KEY ("live_debate") REFERENCES "public"."live_debate"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."live_debate_kick"
    ADD CONSTRAINT "live_debate_kick_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."user_data"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."live_debate_notification"
    ADD CONSTRAINT "live_debate_notification_live_debate_fkey" FOREIGN KEY ("live_debate") REFERENCES "public"."live_debate"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."live_debate_participants"
    ADD CONSTRAINT "live_debate_participants_host_id_fkey" FOREIGN KEY ("host_id") REFERENCES "public"."user_data"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."live_debate_participants"
    ADD CONSTRAINT "live_debate_participants_id_fkey" FOREIGN KEY ("participant_id") REFERENCES "public"."user_data"("id");

ALTER TABLE ONLY "public"."live_debate_participants"
    ADD CONSTRAINT "live_debate_participants_live_debate_fkey" FOREIGN KEY ("live_debate") REFERENCES "public"."live_debate"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."live_debate_team"
    ADD CONSTRAINT "live_debate_team_live_debate_fkey" FOREIGN KEY ("live_debate") REFERENCES "public"."live_debate"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."live_debate_user_role"
    ADD CONSTRAINT "live_debate_user_role_live_debate_fkey" FOREIGN KEY ("live_debate") REFERENCES "public"."live_debate"("id");

ALTER TABLE ONLY "public"."live_debate_user_role"
    ADD CONSTRAINT "live_debate_user_role_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."user_data"("id");

ALTER TABLE ONLY "public"."live_debate_user_team"
    ADD CONSTRAINT "live_debate_user_team_live_debate_fkey" FOREIGN KEY ("live_debate") REFERENCES "public"."live_debate"("id");

ALTER TABLE ONLY "public"."live_debate_user_team"
    ADD CONSTRAINT "live_debate_user_team_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."user_data"("id");

ALTER TABLE ONLY "public"."live_host_ban"
    ADD CONSTRAINT "live_host_ban_banned_by_fkey" FOREIGN KEY ("banned_by") REFERENCES "public"."user_data"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."live_host_ban"
    ADD CONSTRAINT "live_host_ban_live_debate_fkey" FOREIGN KEY ("live_debate") REFERENCES "public"."live_debate"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."live_host_ban"
    ADD CONSTRAINT "live_host_ban_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."user_data"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."live_host_follower"
    ADD CONSTRAINT "live_host_follower_id_fkey" FOREIGN KEY ("id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."live_host_support"
    ADD CONSTRAINT "live_host_support_id_fkey" FOREIGN KEY ("id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."live_user_ban"
    ADD CONSTRAINT "live_user_ban_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."user_data"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."live_debate"
    ADD CONSTRAINT "public_live_debate_host_fkey" FOREIGN KEY ("host") REFERENCES "public"."user_data"("id");

ALTER TABLE ONLY "public"."live_debate_participants"
    ADD CONSTRAINT "public_live_debate_participants_team_fkey" FOREIGN KEY ("team") REFERENCES "public"."live_debate_team"("id") ON DELETE SET NULL;

ALTER TABLE ONLY "public"."social_links"
    ADD CONSTRAINT "social_links_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."user_data"
    ADD CONSTRAINT "user_data_id_fkey" FOREIGN KEY ("id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."user_email"
    ADD CONSTRAINT "user_email_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;

CREATE POLICY "Anyone can insert" ON "public"."live_debate_chat" FOR INSERT TO "authenticated", "anon" WITH CHECK (true);

CREATE POLICY "Anyone can read" ON "public"."live_debate_user_role" FOR SELECT TO "authenticated", "anon" USING (true);

CREATE POLICY "Anyone can see" ON "public"."live_debate_audience_team_only" FOR SELECT USING (true);

CREATE POLICY "Anyone can see" ON "public"."live_debate_chat" FOR SELECT USING (true);

CREATE POLICY "Anyone can see" ON "public"."live_debate_user_team" FOR SELECT TO "authenticated", "anon" USING (true);

CREATE POLICY "Anyone can see" ON "public"."social_links" FOR SELECT TO "authenticated", "anon" USING (true);

CREATE POLICY "Anyone can view" ON "public"."user_data" FOR SELECT USING (true);

CREATE POLICY "Atleast co-host" ON "public"."live_debate_team" FOR INSERT TO "authenticated" WITH CHECK ("public"."user_atleast_co_host"("live_debate"));

CREATE POLICY "Atleast mod or the user can see" ON "public"."live_host_ban" FOR SELECT TO "authenticated" USING (("public"."user_atleast_mod"("live_debate") OR ("user_id" = "auth"."uid"())));

CREATE POLICY "Delete either by host or current owner" ON "public"."live_debate_participants" FOR DELETE TO "authenticated" USING (((( SELECT "auth"."uid"() AS "uid") = "participant_id") OR "public"."user_atleast_co_host"("live_debate")));

CREATE POLICY "Enable delete for users based on user_id" ON "public"."social_links" FOR DELETE USING ((( SELECT "auth"."uid"() AS "uid") = "user_id"));

CREATE POLICY "Enable insert for authenticated users only" ON "public"."live_debate" FOR INSERT TO "authenticated" WITH CHECK ("public"."user_not_banned"());

CREATE POLICY "Enable insert for authenticated users only" ON "public"."live_debate_participants" FOR INSERT TO "authenticated", "anon" WITH CHECK (((( SELECT "auth"."uid"() AS "uid") = "participant_id") AND "public"."is_space_left"("live_debate")));

CREATE POLICY "Enable insert for users based on user_id" ON "public"."social_links" FOR INSERT WITH CHECK ((( SELECT "auth"."uid"() AS "uid") = "user_id"));

CREATE POLICY "Enable insert for users based on user_id, also check if the use" ON "public"."user_data" FOR INSERT WITH CHECK ((( SELECT "auth"."uid"() AS "uid") = "id"));

CREATE POLICY "Enable read access for all users" ON "public"."live_debate" FOR SELECT USING (true);

CREATE POLICY "Enable read access for all users" ON "public"."live_debate_participants" FOR SELECT USING (true);

CREATE POLICY "Enable read access for all users" ON "public"."live_user_ban" FOR SELECT TO "authenticated" USING (( SELECT ("auth"."uid"() = "live_user_ban"."user_id")));

CREATE POLICY "Enable read access for any" ON "public"."live_debate_team" FOR SELECT USING (true);

CREATE POLICY "Enable update for users based on id, also check if username is " ON "public"."user_data" FOR UPDATE USING ((( SELECT "auth"."uid"() AS "uid") = "id")) WITH CHECK ((( SELECT "auth"."uid"() AS "uid") = "id"));

CREATE POLICY "Enable update for users based on user id" ON "public"."live_debate_participants" FOR UPDATE TO "authenticated", "anon" USING (((( SELECT "auth"."uid"() AS "uid") = "participant_id") OR "public"."user_atleast_co_host"("live_debate"))) WITH CHECK (((( SELECT "auth"."uid"() AS "uid") = "participant_id") OR "public"."user_atleast_co_host"("live_debate")));

CREATE POLICY "Only mods can ban" ON "public"."live_host_ban" FOR INSERT TO "authenticated" WITH CHECK ("public"."user_atleast_mod"("live_debate"));

CREATE POLICY "Only mods can delete" ON "public"."live_debate_kick" FOR DELETE TO "authenticated" USING ("public"."user_atleast_mod"("live_debate"));

CREATE POLICY "Only mods can delete" ON "public"."live_host_ban" FOR DELETE TO "authenticated" USING ("public"."user_atleast_mod"("live_debate"));

CREATE POLICY "Only mods can kick" ON "public"."live_debate_kick" FOR INSERT TO "authenticated" WITH CHECK ("public"."user_atleast_mod"("live_debate"));

CREATE POLICY "Only mods can update" ON "public"."live_debate_kick" FOR UPDATE TO "authenticated" USING ("public"."user_atleast_mod"("live_debate"));

CREATE POLICY "Only mods can update" ON "public"."live_host_ban" FOR UPDATE TO "authenticated" USING ("public"."user_atleast_mod"("live_debate"));

CREATE POLICY "Only user and mods can see" ON "public"."live_debate_kick" FOR SELECT TO "authenticated" USING (("public"."user_atleast_mod"("live_debate") OR ("user_id" = "auth"."uid"())));

CREATE POLICY "User atleast co-host" ON "public"."live_debate_team" FOR UPDATE TO "authenticated" USING ("public"."user_atleast_co_host"("live_debate"));

CREATE POLICY "User not banned" ON "public"."live_debate" FOR UPDATE TO "authenticated" USING ("public"."user_atleast_co_host"("id"));

CREATE POLICY "host only" ON "public"."live_debate_audience_team_only" FOR INSERT TO "authenticated" WITH CHECK ("public"."user_atleast_co_host"("live_debate"));

ALTER TABLE "public"."host_stream_key" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."live_debate" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."live_debate_agenda" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."live_debate_audience_team_only" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."live_debate_backstage_chat" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."live_debate_chat" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."live_debate_invite_co_host" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."live_debate_kick" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."live_debate_notification" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."live_debate_participants" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."live_debate_team" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."live_debate_user_role" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."live_debate_user_team" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."live_host_ban" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."live_host_follower" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."live_host_support" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."live_user_ban" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "only host can delete" ON "public"."live_debate_invite_co_host" FOR DELETE TO "authenticated" USING ("public"."user_is_host"("live_debate"));

CREATE POLICY "only host can insert" ON "public"."live_debate_invite_co_host" FOR INSERT TO "authenticated" WITH CHECK ("public"."user_is_host"("live_debate"));

CREATE POLICY "only host can see" ON "public"."live_debate_invite_co_host" FOR SELECT TO "authenticated" USING ("public"."user_is_host"("live_debate"));

CREATE POLICY "only host can update" ON "public"."live_debate_invite_co_host" FOR UPDATE TO "authenticated" USING ("public"."user_is_host"("live_debate"));

CREATE POLICY "only owner can update" ON "public"."social_links" FOR UPDATE TO "authenticated", "anon" USING ((( SELECT "auth"."uid"() AS "uid") = "user_id"));

CREATE POLICY "only user can delete" ON "public"."live_debate_user_team" FOR DELETE TO "authenticated", "anon" USING ((( SELECT "auth"."uid"() AS "uid") = "user_id"));

ALTER TABLE "public"."social_links" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "user atleast co-host" ON "public"."live_debate_audience_team_only" FOR SELECT USING ("public"."user_atleast_co_host"("live_debate"));

CREATE POLICY "user atleast co-host" ON "public"."live_debate_team" FOR DELETE TO "authenticated" USING ("public"."user_atleast_co_host"("live_debate"));

CREATE POLICY "user atleast code-host" ON "public"."live_debate_audience_team_only" FOR UPDATE TO "authenticated" USING ("public"."user_atleast_co_host"("live_debate"));

CREATE POLICY "user insert" ON "public"."live_debate_user_team" FOR INSERT TO "authenticated", "anon" WITH CHECK ((( SELECT "auth"."uid"() AS "uid") = "user_id"));

CREATE POLICY "user update" ON "public"."live_debate_user_team" FOR UPDATE TO "authenticated", "anon" USING ((( SELECT "auth"."uid"() AS "uid") = "user_id"));

ALTER TABLE "public"."user_data" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."user_email" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."user_phone" ENABLE ROW LEVEL SECURITY;

ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";

ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."live_host_follower";

ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."live_host_support";

GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";

GRANT ALL ON FUNCTION "public"."is_space_left"("live_debate_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."is_space_left"("live_debate_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."is_space_left"("live_debate_id" "uuid") TO "service_role";

GRANT ALL ON FUNCTION "public"."turn_on_realtime"() TO "anon";
GRANT ALL ON FUNCTION "public"."turn_on_realtime"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."turn_on_realtime"() TO "service_role";

GRANT ALL ON FUNCTION "public"."user_atleast_co_host"("live_debate_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."user_atleast_co_host"("live_debate_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."user_atleast_co_host"("live_debate_id" "uuid") TO "service_role";

GRANT ALL ON FUNCTION "public"."user_atleast_mod"("live_debate_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."user_atleast_mod"("live_debate_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."user_atleast_mod"("live_debate_id" "uuid") TO "service_role";

GRANT ALL ON FUNCTION "public"."user_is_host"("live_debate_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."user_is_host"("live_debate_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."user_is_host"("live_debate_id" "uuid") TO "service_role";

GRANT ALL ON FUNCTION "public"."user_not_banned"() TO "anon";
GRANT ALL ON FUNCTION "public"."user_not_banned"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."user_not_banned"() TO "service_role";

GRANT ALL ON TABLE "public"."host_stream_key" TO "anon";
GRANT ALL ON TABLE "public"."host_stream_key" TO "authenticated";
GRANT ALL ON TABLE "public"."host_stream_key" TO "service_role";

GRANT ALL ON TABLE "public"."live_debate" TO "anon";
GRANT ALL ON TABLE "public"."live_debate" TO "authenticated";
GRANT ALL ON TABLE "public"."live_debate" TO "service_role";

GRANT ALL ON TABLE "public"."live_debate_agenda" TO "anon";
GRANT ALL ON TABLE "public"."live_debate_agenda" TO "authenticated";
GRANT ALL ON TABLE "public"."live_debate_agenda" TO "service_role";

GRANT ALL ON TABLE "public"."live_debate_audience_team_only" TO "anon";
GRANT ALL ON TABLE "public"."live_debate_audience_team_only" TO "authenticated";
GRANT ALL ON TABLE "public"."live_debate_audience_team_only" TO "service_role";

GRANT ALL ON TABLE "public"."live_debate_backstage_chat" TO "anon";
GRANT ALL ON TABLE "public"."live_debate_backstage_chat" TO "authenticated";
GRANT ALL ON TABLE "public"."live_debate_backstage_chat" TO "service_role";

GRANT ALL ON TABLE "public"."live_debate_chat" TO "anon";
GRANT ALL ON TABLE "public"."live_debate_chat" TO "authenticated";
GRANT ALL ON TABLE "public"."live_debate_chat" TO "service_role";

GRANT ALL ON TABLE "public"."live_debate_invite_co_host" TO "anon";
GRANT ALL ON TABLE "public"."live_debate_invite_co_host" TO "authenticated";
GRANT ALL ON TABLE "public"."live_debate_invite_co_host" TO "service_role";

GRANT ALL ON TABLE "public"."live_debate_kick" TO "anon";
GRANT ALL ON TABLE "public"."live_debate_kick" TO "authenticated";
GRANT ALL ON TABLE "public"."live_debate_kick" TO "service_role";

GRANT ALL ON TABLE "public"."live_debate_notification" TO "anon";
GRANT ALL ON TABLE "public"."live_debate_notification" TO "authenticated";
GRANT ALL ON TABLE "public"."live_debate_notification" TO "service_role";

GRANT ALL ON TABLE "public"."live_debate_participants" TO "anon";
GRANT ALL ON TABLE "public"."live_debate_participants" TO "authenticated";
GRANT ALL ON TABLE "public"."live_debate_participants" TO "service_role";

GRANT ALL ON TABLE "public"."live_debate_team" TO "anon";
GRANT ALL ON TABLE "public"."live_debate_team" TO "authenticated";
GRANT ALL ON TABLE "public"."live_debate_team" TO "service_role";

GRANT ALL ON TABLE "public"."live_debate_user_role" TO "anon";
GRANT ALL ON TABLE "public"."live_debate_user_role" TO "authenticated";
GRANT ALL ON TABLE "public"."live_debate_user_role" TO "service_role";

GRANT ALL ON TABLE "public"."live_debate_user_team" TO "anon";
GRANT ALL ON TABLE "public"."live_debate_user_team" TO "authenticated";
GRANT ALL ON TABLE "public"."live_debate_user_team" TO "service_role";

GRANT ALL ON TABLE "public"."live_host_ban" TO "anon";
GRANT ALL ON TABLE "public"."live_host_ban" TO "authenticated";
GRANT ALL ON TABLE "public"."live_host_ban" TO "service_role";

GRANT ALL ON TABLE "public"."live_host_follower" TO "anon";
GRANT ALL ON TABLE "public"."live_host_follower" TO "authenticated";
GRANT ALL ON TABLE "public"."live_host_follower" TO "service_role";

GRANT ALL ON TABLE "public"."live_host_support" TO "anon";
GRANT ALL ON TABLE "public"."live_host_support" TO "authenticated";
GRANT ALL ON TABLE "public"."live_host_support" TO "service_role";

GRANT ALL ON TABLE "public"."live_user_ban" TO "anon";
GRANT ALL ON TABLE "public"."live_user_ban" TO "authenticated";
GRANT ALL ON TABLE "public"."live_user_ban" TO "service_role";

GRANT ALL ON TABLE "public"."social_links" TO "anon";
GRANT ALL ON TABLE "public"."social_links" TO "authenticated";
GRANT ALL ON TABLE "public"."social_links" TO "service_role";

GRANT ALL ON TABLE "public"."user_data" TO "anon";
GRANT ALL ON TABLE "public"."user_data" TO "authenticated";
GRANT ALL ON TABLE "public"."user_data" TO "service_role";

GRANT ALL ON TABLE "public"."user_email" TO "anon";
GRANT ALL ON TABLE "public"."user_email" TO "authenticated";
GRANT ALL ON TABLE "public"."user_email" TO "service_role";

GRANT ALL ON TABLE "public"."user_phone" TO "anon";
GRANT ALL ON TABLE "public"."user_phone" TO "authenticated";
GRANT ALL ON TABLE "public"."user_phone" TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "service_role";

RESET ALL;

--
-- Dumped schema changes for auth and storage
--

CREATE POLICY "anyone can see" ON "storage"."objects" FOR SELECT TO "authenticated", "anon" USING (("bucket_id" = 'profile_image'::"text"));

CREATE POLICY "only auth can insert" ON "storage"."objects" FOR INSERT TO "authenticated" WITH CHECK (("bucket_id" = 'profile_image'::"text"));

