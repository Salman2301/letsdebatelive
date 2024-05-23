SET session_replication_role = replica;

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.1 (Ubuntu 15.1-1.pgdg20.04+1)
-- Dumped by pg_dump version 15.6 (Ubuntu 15.6-1.pgdg20.04+1)

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

--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."audit_log_entries" ("instance_id", "id", "payload", "created_at", "ip_address") VALUES
	('00000000-0000-0000-0000-000000000000', 'aad55883-4e23-42e9-8322-1361be0d24bc', '{"action":"user_signedup","actor_id":"26d288ae-1bfa-4a01-8469-d694b52a8972","actor_username":"teamuser3-c@example.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}', '2024-05-21 03:56:54.990949+00', ''),
	('00000000-0000-0000-0000-000000000000', 'b20a663e-f6dd-4c70-bd54-d6f091fc3b98', '{"action":"login","actor_id":"26d288ae-1bfa-4a01-8469-d694b52a8972","actor_username":"teamuser3-c@example.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2024-05-21 03:56:54.993816+00', ''),
	('00000000-0000-0000-0000-000000000000', '92de1ea0-088a-46cb-8001-75f9b650b5b8', '{"action":"logout","actor_id":"26d288ae-1bfa-4a01-8469-d694b52a8972","actor_username":"teamuser3-c@example.com","actor_via_sso":false,"log_type":"account"}', '2024-05-21 03:57:04.654413+00', ''),
	('00000000-0000-0000-0000-000000000000', 'd0ccc657-08e7-447b-8473-22152fad1383', '{"action":"user_signedup","actor_id":"dc81fe33-706b-40eb-962b-14ebf3eadc58","actor_username":"teamuser1-a@example.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}', '2024-05-21 03:57:14.809798+00', ''),
	('00000000-0000-0000-0000-000000000000', '61306a7d-31b6-40ed-8f54-a3a3b16756f1', '{"action":"login","actor_id":"dc81fe33-706b-40eb-962b-14ebf3eadc58","actor_username":"teamuser1-a@example.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2024-05-21 03:57:14.811387+00', ''),
	('00000000-0000-0000-0000-000000000000', '90ed04c7-e28b-4660-87c0-cea3c2b69245', '{"action":"logout","actor_id":"dc81fe33-706b-40eb-962b-14ebf3eadc58","actor_username":"teamuser1-a@example.com","actor_via_sso":false,"log_type":"account"}', '2024-05-21 03:57:19.065229+00', ''),
	('00000000-0000-0000-0000-000000000000', 'eceadf34-820e-43e7-965c-5b77fef4a9ff', '{"action":"user_signedup","actor_id":"28170dd2-8ad5-4752-95df-b4853cda2bfb","actor_username":"teamuser2-b@example.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"email"}}', '2024-05-21 03:57:54.485729+00', ''),
	('00000000-0000-0000-0000-000000000000', 'd3d511f1-0f82-4897-996c-b01bbf2d02e9', '{"action":"login","actor_id":"28170dd2-8ad5-4752-95df-b4853cda2bfb","actor_username":"teamuser2-b@example.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2024-05-21 03:57:54.487821+00', ''),
	('00000000-0000-0000-0000-000000000000', '51b73cb2-ec6f-4a1a-a2d3-1bf2617d1c0a', '{"action":"token_refreshed","actor_id":"28170dd2-8ad5-4752-95df-b4853cda2bfb","actor_username":"teamuser2-b@example.com","actor_via_sso":false,"log_type":"token"}', '2024-05-21 05:25:08.95848+00', ''),
	('00000000-0000-0000-0000-000000000000', '296ed874-1c2a-416b-a83a-93b35c3d4bce', '{"action":"token_revoked","actor_id":"28170dd2-8ad5-4752-95df-b4853cda2bfb","actor_username":"teamuser2-b@example.com","actor_via_sso":false,"log_type":"token"}', '2024-05-21 05:25:08.959144+00', ''),
	('00000000-0000-0000-0000-000000000000', '501cd29f-9f74-449b-b692-d7812af3e6f0', '{"action":"logout","actor_id":"28170dd2-8ad5-4752-95df-b4853cda2bfb","actor_username":"teamuser2-b@example.com","actor_via_sso":false,"log_type":"account"}', '2024-05-21 05:28:47.879751+00', ''),
	('00000000-0000-0000-0000-000000000000', '99c13541-eae8-4cb8-858c-506495a1ef49', '{"action":"login","actor_id":"dc81fe33-706b-40eb-962b-14ebf3eadc58","actor_username":"teamuser1-a@example.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2024-05-21 05:28:56.960574+00', ''),
	('00000000-0000-0000-0000-000000000000', 'e5fe7abb-b315-47fa-bc8d-d5f1f32e1422', '{"action":"token_refreshed","actor_id":"dc81fe33-706b-40eb-962b-14ebf3eadc58","actor_username":"teamuser1-a@example.com","actor_via_sso":false,"log_type":"token"}', '2024-05-21 06:30:18.456804+00', ''),
	('00000000-0000-0000-0000-000000000000', '24e7cdb3-d417-4be2-bad4-6faed52359b8', '{"action":"token_revoked","actor_id":"dc81fe33-706b-40eb-962b-14ebf3eadc58","actor_username":"teamuser1-a@example.com","actor_via_sso":false,"log_type":"token"}', '2024-05-21 06:30:18.459161+00', ''),
	('00000000-0000-0000-0000-000000000000', 'fab17e09-6aad-417a-b4fa-2aef8b8131f4', '{"action":"token_refreshed","actor_id":"dc81fe33-706b-40eb-962b-14ebf3eadc58","actor_username":"teamuser1-a@example.com","actor_via_sso":false,"log_type":"token"}', '2024-05-21 07:43:30.863065+00', ''),
	('00000000-0000-0000-0000-000000000000', '473bb406-c99a-447a-99b4-74c4156eff59', '{"action":"token_revoked","actor_id":"dc81fe33-706b-40eb-962b-14ebf3eadc58","actor_username":"teamuser1-a@example.com","actor_via_sso":false,"log_type":"token"}', '2024-05-21 07:43:30.869678+00', ''),
	('00000000-0000-0000-0000-000000000000', '707c99ef-7cfb-4a24-9e3f-313b72de40d3', '{"action":"token_refreshed","actor_id":"dc81fe33-706b-40eb-962b-14ebf3eadc58","actor_username":"teamuser1-a@example.com","actor_via_sso":false,"log_type":"token"}', '2024-05-21 08:42:10.724733+00', ''),
	('00000000-0000-0000-0000-000000000000', '9929ffee-ee06-4160-9291-bbd395af7bd9', '{"action":"token_revoked","actor_id":"dc81fe33-706b-40eb-962b-14ebf3eadc58","actor_username":"teamuser1-a@example.com","actor_via_sso":false,"log_type":"token"}', '2024-05-21 08:42:10.727093+00', ''),
	('00000000-0000-0000-0000-000000000000', 'b83d9fa7-2af8-408d-95b2-8c60448bab02', '{"action":"logout","actor_id":"dc81fe33-706b-40eb-962b-14ebf3eadc58","actor_username":"teamuser1-a@example.com","actor_via_sso":false,"log_type":"account"}', '2024-05-21 08:43:10.744717+00', ''),
	('00000000-0000-0000-0000-000000000000', 'df883458-3d21-4dea-8fb5-ad40e5ebd434', '{"action":"login","actor_id":"26d288ae-1bfa-4a01-8469-d694b52a8972","actor_username":"teamuser3-c@example.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}', '2024-05-21 08:43:21.254067+00', ''),
	('00000000-0000-0000-0000-000000000000', '998b3849-67bb-4289-b3ce-fd5b1c9aa0c9', '{"action":"token_refreshed","actor_id":"26d288ae-1bfa-4a01-8469-d694b52a8972","actor_username":"teamuser3-c@example.com","actor_via_sso":false,"log_type":"token"}', '2024-05-21 09:48:26.438069+00', ''),
	('00000000-0000-0000-0000-000000000000', '2ac7ee41-0818-4611-be09-0663c63029d8', '{"action":"token_revoked","actor_id":"26d288ae-1bfa-4a01-8469-d694b52a8972","actor_username":"teamuser3-c@example.com","actor_via_sso":false,"log_type":"token"}', '2024-05-21 09:48:26.445294+00', '');


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."users" ("instance_id", "id", "aud", "role", "email", "encrypted_password", "email_confirmed_at", "invited_at", "confirmation_token", "confirmation_sent_at", "recovery_token", "recovery_sent_at", "email_change_token_new", "email_change", "email_change_sent_at", "last_sign_in_at", "raw_app_meta_data", "raw_user_meta_data", "is_super_admin", "created_at", "updated_at", "phone", "phone_confirmed_at", "phone_change", "phone_change_token", "phone_change_sent_at", "email_change_token_current", "email_change_confirm_status", "banned_until", "reauthentication_token", "reauthentication_sent_at", "is_sso_user", "deleted_at", "is_anonymous") VALUES
	('00000000-0000-0000-0000-000000000000', '28170dd2-8ad5-4752-95df-b4853cda2bfb', 'authenticated', 'authenticated', 'teamuser2-b@example.com', '$2a$10$N8k09cWqYeMqpWnVxZ.Cgegssyd1pUF9Nwu1tBpfXmbL4j/7OPUZa', '2024-05-21 03:57:54.486055+00', NULL, '', NULL, '', NULL, '', '', NULL, '2024-05-21 03:57:54.488054+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "28170dd2-8ad5-4752-95df-b4853cda2bfb", "email": "teamuser2-b@example.com", "email_verified": false, "phone_verified": false}', NULL, '2024-05-21 03:57:54.480764+00', '2024-05-21 05:25:08.961874+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', 'dc81fe33-706b-40eb-962b-14ebf3eadc58', 'authenticated', 'authenticated', 'teamuser1-a@example.com', '$2a$10$kdcAumTjLvdiS//t5fKLjOywdzdC.wvNfS.2rBaREXw5rmp89BoV6', '2024-05-21 03:57:14.810281+00', NULL, '', NULL, '', NULL, '', '', NULL, '2024-05-21 05:28:56.961208+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "dc81fe33-706b-40eb-962b-14ebf3eadc58", "email": "teamuser1-a@example.com", "email_verified": false, "phone_verified": false}', NULL, '2024-05-21 03:57:14.80597+00', '2024-05-21 08:42:10.730753+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', '26d288ae-1bfa-4a01-8469-d694b52a8972', 'authenticated', 'authenticated', 'teamuser3-c@example.com', '$2a$10$Loc3Uo6brgCHKXOFJwT2TeFzAi18YJxOng5knkN4copJNPz1y2tV2', '2024-05-21 03:56:54.992156+00', NULL, '', NULL, '', NULL, '', '', NULL, '2024-05-21 08:43:21.254673+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "26d288ae-1bfa-4a01-8469-d694b52a8972", "email": "teamuser3-c@example.com", "email_verified": false, "phone_verified": false}', NULL, '2024-05-21 03:56:54.970676+00', '2024-05-21 09:48:26.450032+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false);


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."identities" ("provider_id", "user_id", "identity_data", "provider", "last_sign_in_at", "created_at", "updated_at", "id") VALUES
	('26d288ae-1bfa-4a01-8469-d694b52a8972', '26d288ae-1bfa-4a01-8469-d694b52a8972', '{"sub": "26d288ae-1bfa-4a01-8469-d694b52a8972", "email": "teamuser3-c@example.com", "email_verified": false, "phone_verified": false}', 'email', '2024-05-21 03:56:54.988159+00', '2024-05-21 03:56:54.988196+00', '2024-05-21 03:56:54.988196+00', 'cdac8cf1-59cf-4e40-b9df-703cbdd994e5'),
	('dc81fe33-706b-40eb-962b-14ebf3eadc58', 'dc81fe33-706b-40eb-962b-14ebf3eadc58', '{"sub": "dc81fe33-706b-40eb-962b-14ebf3eadc58", "email": "teamuser1-a@example.com", "email_verified": false, "phone_verified": false}', 'email', '2024-05-21 03:57:14.808216+00', '2024-05-21 03:57:14.808253+00', '2024-05-21 03:57:14.808253+00', '6cd18358-2bdb-45cd-8b9c-d834ea2f2cde'),
	('28170dd2-8ad5-4752-95df-b4853cda2bfb', '28170dd2-8ad5-4752-95df-b4853cda2bfb', '{"sub": "28170dd2-8ad5-4752-95df-b4853cda2bfb", "email": "teamuser2-b@example.com", "email_verified": false, "phone_verified": false}', 'email', '2024-05-21 03:57:54.484336+00', '2024-05-21 03:57:54.484364+00', '2024-05-21 03:57:54.484364+00', '5256820c-da36-4014-b0cd-37db5906a9fc');


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."sessions" ("id", "user_id", "created_at", "updated_at", "factor_id", "aal", "not_after", "refreshed_at", "user_agent", "ip", "tag") VALUES
	('92ff04e1-a9a8-406b-8fe8-7654c6978b47', '26d288ae-1bfa-4a01-8469-d694b52a8972', '2024-05-21 08:43:21.256217+00', '2024-05-21 09:48:26.452083+00', NULL, 'aal1', NULL, '2024-05-21 09:48:26.452045', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36', '192.168.65.1', NULL);


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."mfa_amr_claims" ("session_id", "created_at", "updated_at", "authentication_method", "id") VALUES
	('92ff04e1-a9a8-406b-8fe8-7654c6978b47', '2024-05-21 08:43:21.25876+00', '2024-05-21 08:43:21.25876+00', 'password', '5d949617-5404-4cd4-b52c-a6f2344b4fae');


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."refresh_tokens" ("instance_id", "id", "token", "user_id", "revoked", "created_at", "updated_at", "parent", "session_id") VALUES
	('00000000-0000-0000-0000-000000000000', 9, 'pojNcBw6f4UwyKBUsH5M7A', '26d288ae-1bfa-4a01-8469-d694b52a8972', true, '2024-05-21 08:43:21.257545+00', '2024-05-21 09:48:26.445868+00', NULL, '92ff04e1-a9a8-406b-8fe8-7654c6978b47'),
	('00000000-0000-0000-0000-000000000000', 10, 'wiWCVtDVID9I_GkFQm5nmw', '26d288ae-1bfa-4a01-8469-d694b52a8972', false, '2024-05-21 09:48:26.447149+00', '2024-05-21 09:48:26.447149+00', 'pojNcBw6f4UwyKBUsH5M7A', '92ff04e1-a9a8-406b-8fe8-7654c6978b47');


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: key; Type: TABLE DATA; Schema: pgsodium; Owner: supabase_admin
--



--
-- Data for Name: user_data; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."user_data" ("id", "created_at", "displayName", "email", "firstName", "lastName", "fullName", "username", "initials", "oneLineDesc") VALUES
	('26d288ae-1bfa-4a01-8469-d694b52a8972', '2024-05-21 03:57:00.174814+00', 'Jhon Doe', 'teamuser3-c@example.com', 'Jhon', 'Doe', 'Jhon Doe', 'user3', NULL, NULL),
	('dc81fe33-706b-40eb-962b-14ebf3eadc58', '2024-05-21 03:57:17.2026+00', 'Jane Doe', 'teamuser1-a@example.com', 'Jane', 'Doe', 'Jane Doe', 'user1', NULL, NULL),
	('28170dd2-8ad5-4752-95df-b4853cda2bfb', '2024-05-21 03:57:56.481485+00', 'Sarah smith', 'teamuser2-b@example.com', 'Sarah', 'Smith', 'Sarah Smith', 'user2', NULL, NULL);


--
-- Data for Name: live_debate; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."live_debate" ("id", "created_at", "title", "host", "chat_rules", "debate_type", "chat_filter_words", "chat_follower_only", "chat_support_only", "chat_team_only", "backstage_allow_only", "backstage_max", "viewer_type", "studio_mode", "debater_card_show") VALUES
	('4167bf11-dc10-46d3-9d32-e5b7ad9d3e67', '2024-05-21 04:02:18.994689+00', 'Test debate', '26d288ae-1bfa-4a01-8469-d694b52a8972', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	('b39f5e45-df05-42d2-b9b0-53d87e3ab647', '2024-05-21 06:29:27.177735+00', 'test dummy', 'dc81fe33-706b-40eb-962b-14ebf3eadc58', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


--
-- Data for Name: live_debate_team; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."live_debate_team" ("created_at", "color", "title", "id", "live_debate", "slug") VALUES
	('2024-05-21 04:06:53.917601+00', '#32DE8A', 'Team A', '5932f887-2683-4489-b659-2024f57fd80d', '4167bf11-dc10-46d3-9d32-e5b7ad9d3e67', 'team-a'),
	('2024-05-21 04:07:21.815976+00', '#EF7674', 'Team B', 'f64dab6d-0271-4a90-8deb-654dab220ce6', '4167bf11-dc10-46d3-9d32-e5b7ad9d3e67', 'team-b'),
	('2024-05-21 04:07:52.407531+00', '#F2AF29', 'Team C', '8dd04996-eddd-49ee-8e36-c459202e87e4', '4167bf11-dc10-46d3-9d32-e5b7ad9d3e67', 'team-c');


--
-- Data for Name: live_debate_agenda; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: live_debate_backstage_chat; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: live_debate_chat; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: live_debate_kick; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: live_debate_notification; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: live_debate_participants; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."live_debate_participants" ("created_at", "speaker_id", "mic_id", "cam_id", "speaker_enable", "mic_enable", "cam_enable", "screenshare_available", "speaker_available", "mic_available", "cam_available", "current_stage", "is_kicked", "display_name", "team", "hand_raised", "is_host", "live_debate", "location", "participant_id", "host_id", "screenshare_enable", "profile_image_enable") VALUES
	('2024-05-21 04:12:07.360691+00', '1', 'qew', NULL, true, true, true, NULL, NULL, NULL, NULL, NULL, NULL, 'Jhonny', '5932f887-2683-4489-b659-2024f57fd80d', NULL, true, '4167bf11-dc10-46d3-9d32-e5b7ad9d3e67', 'backstage', '26d288ae-1bfa-4a01-8469-d694b52a8972', '26d288ae-1bfa-4a01-8469-d694b52a8972', false, false),
	('2024-05-21 04:13:06.013692+00', '1', '', NULL, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, 'Smitty', 'f64dab6d-0271-4a90-8deb-654dab220ce6', NULL, false, '4167bf11-dc10-46d3-9d32-e5b7ad9d3e67', 'backstage', '28170dd2-8ad5-4752-95df-b4853cda2bfb', '26d288ae-1bfa-4a01-8469-d694b52a8972', true, false),
	('2024-05-21 07:29:56.819559+00', '12', NULL, NULL, true, true, false, NULL, NULL, NULL, NULL, NULL, NULL, 'test', '5932f887-2683-4489-b659-2024f57fd80d', NULL, false, '4167bf11-dc10-46d3-9d32-e5b7ad9d3e67', 'backstage', 'dc81fe33-706b-40eb-962b-14ebf3eadc58', '26d288ae-1bfa-4a01-8469-d694b52a8972', true, true);


--
-- Data for Name: live_host_ban; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: live_host_follower; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: live_host_support; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: social_links; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: user_email; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: user_phone; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: hooks; Type: TABLE DATA; Schema: supabase_functions; Owner: supabase_functions_admin
--



--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--



--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('"auth"."refresh_tokens_id_seq"', 10, true);


--
-- Name: key_key_id_seq; Type: SEQUENCE SET; Schema: pgsodium; Owner: supabase_admin
--

SELECT pg_catalog.setval('"pgsodium"."key_key_id_seq"', 1, false);


--
-- Name: hooks_id_seq; Type: SEQUENCE SET; Schema: supabase_functions; Owner: supabase_functions_admin
--

SELECT pg_catalog.setval('"supabase_functions"."hooks_id_seq"', 1, false);


--
-- PostgreSQL database dump complete
--

RESET ALL;
