
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

SET default_tablespace = '';

SET default_table_access_method = "heap";

CREATE TABLE IF NOT EXISTS "public"."debate_agenda" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "live_debate" "uuid",
    "title" "text",
    "time" time without time zone,
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "completed" boolean,
    "team" "uuid"
);

ALTER TABLE "public"."debate_agenda" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."debate_team" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "user_id" "uuid" DEFAULT "auth"."uid"(),
    "color" "text",
    "title" "text",
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);

ALTER TABLE "public"."debate_team" OWNER TO "postgres";

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

ALTER TABLE ONLY "public"."debate_agenda"
    ADD CONSTRAINT "debate_agenda_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."debate_team"
    ADD CONSTRAINT "debate_team_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."live_debate"
    ADD CONSTRAINT "live_debate_pkey" PRIMARY KEY ("id");

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

ALTER TABLE ONLY "public"."debate_agenda"
    ADD CONSTRAINT "debate_agenda_live_debate_fkey" FOREIGN KEY ("live_debate") REFERENCES "public"."live_debate"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."debate_agenda"
    ADD CONSTRAINT "debate_agenda_team_fkey" FOREIGN KEY ("team") REFERENCES "public"."debate_team"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."debate_team"
    ADD CONSTRAINT "debate_team_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."live_debate"
    ADD CONSTRAINT "live_debate_host_fkey" FOREIGN KEY ("host") REFERENCES "auth"."users"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."live_host_follower"
    ADD CONSTRAINT "live_host_follower_id_fkey" FOREIGN KEY ("id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."live_host_support"
    ADD CONSTRAINT "live_host_support_id_fkey" FOREIGN KEY ("id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."social_links"
    ADD CONSTRAINT "social_links_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."user_data"
    ADD CONSTRAINT "user_data_id_fkey" FOREIGN KEY ("id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."user_email"
    ADD CONSTRAINT "user_email_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;

CREATE POLICY "Enable insert for users based on user_id" ON "public"."user_data" FOR INSERT WITH CHECK ((( SELECT "auth"."uid"() AS "uid") = "id"));

CREATE POLICY "Enable update for users based on id" ON "public"."user_data" FOR UPDATE USING ((( SELECT "auth"."uid"() AS "uid") = "id")) WITH CHECK ((( SELECT "auth"."uid"() AS "uid") = "id"));

CREATE POLICY "Only user owner can view the content" ON "public"."user_data" FOR SELECT USING ((( SELECT "auth"."uid"() AS "uid") = "id"));

ALTER TABLE "public"."debate_agenda" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."debate_team" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."live_debate" ENABLE ROW LEVEL SECURITY;

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

GRANT ALL ON TABLE "public"."debate_agenda" TO "anon";
GRANT ALL ON TABLE "public"."debate_agenda" TO "authenticated";
GRANT ALL ON TABLE "public"."debate_agenda" TO "service_role";

GRANT ALL ON TABLE "public"."debate_team" TO "anon";
GRANT ALL ON TABLE "public"."debate_team" TO "authenticated";
GRANT ALL ON TABLE "public"."debate_team" TO "service_role";

GRANT ALL ON TABLE "public"."live_debate" TO "anon";
GRANT ALL ON TABLE "public"."live_debate" TO "authenticated";
GRANT ALL ON TABLE "public"."live_debate" TO "service_role";

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
