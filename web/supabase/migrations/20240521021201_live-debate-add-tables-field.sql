
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

SET default_tablespace = '';

SET default_table_access_method = "heap";

CREATE TABLE IF NOT EXISTS "public"."live_debate" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "title" "text",
    "host" "uuid" DEFAULT "auth"."uid"(),
    "chat_rules" "text",
    "debate_type" "text",
    "chat_filter_words" "text",
    "chat_follower_only" boolean,
    "chat_support_only" boolean,
    "chat_team_only" "uuid" DEFAULT "gen_random_uuid"(),
    "backstage_allow_only" "text",
    "backstage_max" integer,
    "viewer_type" "text",
    "studio_mode" boolean,
    "debater_card_show" boolean
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
    "team" "uuid" NOT NULL,
    "hand_raised" boolean,
    "is_host" boolean NOT NULL,
    "live_debate" "uuid" NOT NULL,
    "location" "public"."participant_location" NOT NULL,
    "participant_id" "uuid" DEFAULT "auth"."uid"() NOT NULL
);

ALTER TABLE "public"."live_debate_participants" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."live_debate_team" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "user_id" "uuid" DEFAULT "auth"."uid"(),
    "color" "text",
    "title" "text",
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);

ALTER TABLE "public"."live_debate_team" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."live_host_ban" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "live_debate" "uuid",
    "user_id" "uuid" NOT NULL,
    "live_host_id" "uuid" NOT NULL,
    "reason_title" "text",
    "reason" "text",
    "banned_by" "uuid" NOT NULL
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
    "oneLineDesc" "text"
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

ALTER TABLE ONLY "public"."live_debate_backstage_chat"
    ADD CONSTRAINT "live_debate_backstage_chat_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."live_debate_chat"
    ADD CONSTRAINT "live_debate_chat_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."live_debate_kick"
    ADD CONSTRAINT "live_debate_kick_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."live_debate_notification"
    ADD CONSTRAINT "live_debate_notification_pkey" PRIMARY KEY ("live_debate", "service");

ALTER TABLE ONLY "public"."live_debate_participants"
    ADD CONSTRAINT "live_debate_participants_pkey" PRIMARY KEY ("participant_id", "live_debate");

ALTER TABLE ONLY "public"."live_debate"
    ADD CONSTRAINT "live_debate_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."live_host_ban"
    ADD CONSTRAINT "live_host_ban_pkey" PRIMARY KEY ("user_id", "live_host_id");

ALTER TABLE ONLY "public"."live_host_follower"
    ADD CONSTRAINT "live_host_follower_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."live_host_support"
    ADD CONSTRAINT "live_host_support_pkey" PRIMARY KEY ("id");

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

ALTER TABLE ONLY "public"."live_debate_team"
    ADD CONSTRAINT "debate_team_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."live_debate_backstage_chat"
    ADD CONSTRAINT "live_debate_backstage_chat_live_debate_id_fkey" FOREIGN KEY ("live_debate_id") REFERENCES "public"."live_debate"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."live_debate_backstage_chat"
    ADD CONSTRAINT "live_debate_backstage_chat_sender_id_fkey" FOREIGN KEY ("sender_id") REFERENCES "public"."user_data"("id");

ALTER TABLE ONLY "public"."live_debate_chat"
    ADD CONSTRAINT "live_debate_chat_live_debate_fkey" FOREIGN KEY ("live_debate") REFERENCES "public"."live_debate"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."live_debate_chat"
    ADD CONSTRAINT "live_debate_chat_sender_id_fkey" FOREIGN KEY ("sender_id") REFERENCES "public"."user_data"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."live_debate_kick"
    ADD CONSTRAINT "live_debate_kick_kicked_by_fkey" FOREIGN KEY ("kicked_by") REFERENCES "public"."user_data"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."live_debate_kick"
    ADD CONSTRAINT "live_debate_kick_live_debate_fkey" FOREIGN KEY ("live_debate") REFERENCES "public"."live_debate"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."live_debate_kick"
    ADD CONSTRAINT "live_debate_kick_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."user_data"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."live_debate_notification"
    ADD CONSTRAINT "live_debate_notification_live_debate_fkey" FOREIGN KEY ("live_debate") REFERENCES "public"."live_debate"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."live_debate_participants"
    ADD CONSTRAINT "live_debate_participants_id_fkey" FOREIGN KEY ("participant_id") REFERENCES "public"."user_data"("id");

ALTER TABLE ONLY "public"."live_debate_participants"
    ADD CONSTRAINT "live_debate_participants_live_debate_fkey" FOREIGN KEY ("live_debate") REFERENCES "public"."live_debate"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."live_host_ban"
    ADD CONSTRAINT "live_host_ban_banned_by_fkey" FOREIGN KEY ("banned_by") REFERENCES "public"."user_data"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."live_host_ban"
    ADD CONSTRAINT "live_host_ban_live_debate_fkey" FOREIGN KEY ("live_debate") REFERENCES "public"."live_debate"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."live_host_ban"
    ADD CONSTRAINT "live_host_ban_live_host_id_fkey" FOREIGN KEY ("live_host_id") REFERENCES "public"."user_data"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."live_host_ban"
    ADD CONSTRAINT "live_host_ban_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."user_data"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."live_host_follower"
    ADD CONSTRAINT "live_host_follower_id_fkey" FOREIGN KEY ("id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."live_host_support"
    ADD CONSTRAINT "live_host_support_id_fkey" FOREIGN KEY ("id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;

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

CREATE POLICY "Enable insert for authenticated users only" ON "public"."live_debate" FOR INSERT TO "authenticated" WITH CHECK (true);

CREATE POLICY "Enable insert for authenticated users only" ON "public"."live_debate_participants" FOR INSERT TO "authenticated" WITH CHECK ((( SELECT "auth"."uid"() AS "uid") = "participant_id"));

CREATE POLICY "Enable insert for users based on user_id" ON "public"."user_data" FOR INSERT WITH CHECK ((( SELECT "auth"."uid"() AS "uid") = "id"));

CREATE POLICY "Enable read access for all users" ON "public"."live_debate" FOR SELECT USING ((( SELECT "auth"."uid"() AS "uid") = "host"));

CREATE POLICY "Enable read access for all users" ON "public"."live_debate_participants" FOR SELECT USING (true);

CREATE POLICY "Enable update for users based on email" ON "public"."live_debate_participants" FOR UPDATE USING ((( SELECT "auth"."uid"() AS "uid") = "participant_id")) WITH CHECK ((( SELECT "auth"."uid"() AS "uid") = "participant_id"));

CREATE POLICY "Enable update for users based on id" ON "public"."user_data" FOR UPDATE USING ((( SELECT "auth"."uid"() AS "uid") = "id")) WITH CHECK ((( SELECT "auth"."uid"() AS "uid") = "id"));

CREATE POLICY "Only user owner can view the content" ON "public"."user_data" FOR SELECT USING ((( SELECT "auth"."uid"() AS "uid") = "id"));

ALTER TABLE "public"."live_debate" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."live_debate_agenda" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."live_debate_backstage_chat" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."live_debate_chat" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."live_debate_kick" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."live_debate_notification" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."live_debate_participants" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."live_debate_team" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."live_host_ban" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."live_host_follower" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."live_host_support" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."social_links" ENABLE ROW LEVEL SECURITY;

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

GRANT ALL ON TABLE "public"."live_debate" TO "anon";
GRANT ALL ON TABLE "public"."live_debate" TO "authenticated";
GRANT ALL ON TABLE "public"."live_debate" TO "service_role";

GRANT ALL ON TABLE "public"."live_debate_agenda" TO "anon";
GRANT ALL ON TABLE "public"."live_debate_agenda" TO "authenticated";
GRANT ALL ON TABLE "public"."live_debate_agenda" TO "service_role";

GRANT ALL ON TABLE "public"."live_debate_backstage_chat" TO "anon";
GRANT ALL ON TABLE "public"."live_debate_backstage_chat" TO "authenticated";
GRANT ALL ON TABLE "public"."live_debate_backstage_chat" TO "service_role";

GRANT ALL ON TABLE "public"."live_debate_chat" TO "anon";
GRANT ALL ON TABLE "public"."live_debate_chat" TO "authenticated";
GRANT ALL ON TABLE "public"."live_debate_chat" TO "service_role";

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

GRANT ALL ON TABLE "public"."live_host_ban" TO "anon";
GRANT ALL ON TABLE "public"."live_host_ban" TO "authenticated";
GRANT ALL ON TABLE "public"."live_host_ban" TO "service_role";

GRANT ALL ON TABLE "public"."live_host_follower" TO "anon";
GRANT ALL ON TABLE "public"."live_host_follower" TO "authenticated";
GRANT ALL ON TABLE "public"."live_host_follower" TO "service_role";

GRANT ALL ON TABLE "public"."live_host_support" TO "anon";
GRANT ALL ON TABLE "public"."live_host_support" TO "authenticated";
GRANT ALL ON TABLE "public"."live_host_support" TO "service_role";

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

