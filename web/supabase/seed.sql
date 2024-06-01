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
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."users" ("instance_id", "id", "aud", "role", "email", "encrypted_password", "email_confirmed_at", "invited_at", "confirmation_token", "confirmation_sent_at", "recovery_token", "recovery_sent_at", "email_change_token_new", "email_change", "email_change_sent_at", "last_sign_in_at", "raw_app_meta_data", "raw_user_meta_data", "is_super_admin", "created_at", "updated_at", "phone", "phone_confirmed_at", "phone_change", "phone_change_token", "phone_change_sent_at", "email_change_token_current", "email_change_confirm_status", "banned_until", "reauthentication_token", "reauthentication_sent_at", "is_sso_user", "deleted_at", "is_anonymous") VALUES
	('00000000-0000-0000-0000-000000000000', '28170dd2-8ad5-4752-95df-b4853cda2bfb', 'authenticated', 'authenticated', 'teamuser2-b@example.com', '$2a$10$N8k09cWqYeMqpWnVxZ.Cgegssyd1pUF9Nwu1tBpfXmbL4j/7OPUZa', '2024-05-21 03:57:54.486055+00', NULL, '', NULL, '', NULL, '', '', NULL, '2024-05-21 03:57:54.488054+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "28170dd2-8ad5-4752-95df-b4853cda2bfb", "email": "teamuser2-b@example.com", "email_verified": false, "phone_verified": false}', NULL, '2024-05-21 03:57:54.480764+00', '2024-05-21 05:25:08.961874+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', 'dc81fe33-706b-40eb-962b-14ebf3eadc58', 'authenticated', 'authenticated', 'teamuser1-a@example.com', '$2a$10$kdcAumTjLvdiS//t5fKLjOywdzdC.wvNfS.2rBaREXw5rmp89BoV6', '2024-05-21 03:57:14.810281+00', NULL, '', NULL, '', NULL, '', '', NULL, '2024-05-21 05:28:56.961208+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "dc81fe33-706b-40eb-962b-14ebf3eadc58", "email": "teamuser1-a@example.com", "email_verified": false, "phone_verified": false}', NULL, '2024-05-21 03:57:14.80597+00', '2024-05-21 08:42:10.730753+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', '26d288ae-1bfa-4a01-8469-d694b52a8972', 'authenticated', 'authenticated', 'teamuser3-c@example.com', '$2a$10$Loc3Uo6brgCHKXOFJwT2TeFzAi18YJxOng5knkN4copJNPz1y2tV2', '2024-05-21 03:56:54.992156+00', NULL, '', NULL, '', NULL, '', '', NULL, '2024-06-01 10:11:23.308047+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "26d288ae-1bfa-4a01-8469-d694b52a8972", "email": "teamuser3-c@example.com", "email_verified": false, "phone_verified": false}', NULL, '2024-05-21 03:56:54.970676+00', '2024-06-01 10:11:23.310754+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false);


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
	('bbd01c54-248f-41a3-8f1e-91f1fd2888ef', '26d288ae-1bfa-4a01-8469-d694b52a8972', '2024-05-29 19:41:44.365784+00', '2024-05-30 00:48:56.788308+00', NULL, 'aal1', NULL, '2024-05-30 00:48:56.788271', 'node', '192.168.65.1', NULL),
	('8c2fde82-ceda-43b7-8f32-596ee629dfa7', '26d288ae-1bfa-4a01-8469-d694b52a8972', '2024-06-01 10:11:23.308109+00', '2024-06-01 10:11:23.308109+00', NULL, 'aal1', NULL, NULL, 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36', '192.168.65.1', NULL);


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."mfa_amr_claims" ("session_id", "created_at", "updated_at", "authentication_method", "id") VALUES
	('bbd01c54-248f-41a3-8f1e-91f1fd2888ef', '2024-05-29 19:41:44.367726+00', '2024-05-29 19:41:44.367726+00', 'password', '054d2316-e0f1-4dbf-8a59-7e04862982a0'),
	('8c2fde82-ceda-43b7-8f32-596ee629dfa7', '2024-06-01 10:11:23.311293+00', '2024-06-01 10:11:23.311293+00', 'password', '8e0c9bff-ad69-4e6a-82c9-b3407befcb85');


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
	('00000000-0000-0000-0000-000000000000', 22, 'TfkqHLtg7ndRH8ruK2T4Ag', '26d288ae-1bfa-4a01-8469-d694b52a8972', true, '2024-05-29 19:41:44.366475+00', '2024-05-29 20:41:41.685291+00', NULL, 'bbd01c54-248f-41a3-8f1e-91f1fd2888ef'),
	('00000000-0000-0000-0000-000000000000', 23, 'ZcMUY7gvSyBIwd1C4LaHpQ', '26d288ae-1bfa-4a01-8469-d694b52a8972', true, '2024-05-29 20:41:41.685894+00', '2024-05-29 21:44:51.795744+00', 'TfkqHLtg7ndRH8ruK2T4Ag', 'bbd01c54-248f-41a3-8f1e-91f1fd2888ef'),
	('00000000-0000-0000-0000-000000000000', 24, 'AG50XsBEKrE5Bn8LgZag-Q', '26d288ae-1bfa-4a01-8469-d694b52a8972', true, '2024-05-29 21:44:51.797311+00', '2024-05-29 22:47:57.003171+00', 'ZcMUY7gvSyBIwd1C4LaHpQ', 'bbd01c54-248f-41a3-8f1e-91f1fd2888ef'),
	('00000000-0000-0000-0000-000000000000', 25, '1dRr9qgjSJ1YKQy898bMSw', '26d288ae-1bfa-4a01-8469-d694b52a8972', true, '2024-05-29 22:47:57.003744+00', '2024-05-29 23:48:44.892601+00', 'AG50XsBEKrE5Bn8LgZag-Q', 'bbd01c54-248f-41a3-8f1e-91f1fd2888ef'),
	('00000000-0000-0000-0000-000000000000', 26, '9VwU_PEJukEQhwgMA28kAg', '26d288ae-1bfa-4a01-8469-d694b52a8972', true, '2024-05-29 23:48:44.893357+00', '2024-05-30 00:48:56.785003+00', '1dRr9qgjSJ1YKQy898bMSw', 'bbd01c54-248f-41a3-8f1e-91f1fd2888ef'),
	('00000000-0000-0000-0000-000000000000', 27, 'NLQWqjajtPtqtJ5ls6wYig', '26d288ae-1bfa-4a01-8469-d694b52a8972', false, '2024-05-30 00:48:56.786181+00', '2024-05-30 00:48:56.786181+00', '9VwU_PEJukEQhwgMA28kAg', 'bbd01c54-248f-41a3-8f1e-91f1fd2888ef'),
	('00000000-0000-0000-0000-000000000000', 28, 'duRmtqu_WVEmyBF80AQS9g', '26d288ae-1bfa-4a01-8469-d694b52a8972', false, '2024-06-01 10:11:23.309293+00', '2024-06-01 10:11:23.309293+00', NULL, '8c2fde82-ceda-43b7-8f32-596ee629dfa7');


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
-- Data for Name: host_stream_key; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: user_data; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."user_data" ("id", "created_at", "displayName", "email", "firstName", "lastName", "fullName", "username", "initials", "oneLineDesc", "profile_image") VALUES
	('dc81fe33-706b-40eb-962b-14ebf3eadc58', '2024-05-21 03:57:17.2026+00', 'Jane Doe', 'teamuser1-a@example.com', 'Jane', 'Doe', 'Jane Doe', 'user1', NULL, NULL, NULL),
	('28170dd2-8ad5-4752-95df-b4853cda2bfb', '2024-05-21 03:57:56.481485+00', 'Sarah smith', 'teamuser2-b@example.com', 'Sarah', 'Smith', 'Sarah Smith', 'user2', NULL, NULL, NULL),
	('26d288ae-1bfa-4a01-8469-d694b52a8972', '2024-05-21 03:57:00.174814+00', 'Jhon Doe', 'teamuser3-c@example.com', 'Jhon', 'Doe', 'Jhon Doe', 'user3', NULL, NULL, '41d1f6aa-11e9-4a85-9f8f-cdd5fdbf8d91.png');


--
-- Data for Name: live_debate; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."live_debate" ("id", "created_at", "title", "host", "chat_rules", "debate_type", "chat_filter_words", "backstage_max", "studio_mode", "debater_card_show", "published", "max_participants", "max_stage", "backstage_audience", "chat_audience", "viewer_audience", "auto_move_to_stage", "ended", "ended_tz", "published_tz") VALUES
	('b39f5e45-df05-42d2-b9b0-53d87e3ab647', '2024-05-21 06:29:27.177735+00', 'test dummy', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 40, 30, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	('4167bf11-dc10-46d3-9d32-e5b7ad9d3e67', '2024-05-21 04:02:18.994689+00', 'Test debate', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 40, 30, '{anonymous}', '{anonymous}', '{anonymous}', false, NULL, NULL, NULL),
	('9178d46f-3090-4392-85f1-3b5c84867dd7', '2024-05-29 06:22:19.396393+00', NULL, NULL, NULL, NULL, NULL, NULL, true, NULL, NULL, 40, 30, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	('275cd341-f3d8-4cd1-87c4-0f947505ce75', '2024-06-01 10:11:26.247219+00', NULL, '26d288ae-1bfa-4a01-8469-d694b52a8972', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 40, 30, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


--
-- Data for Name: live_debate_team; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."live_debate_team" ("created_at", "color", "title", "id", "live_debate", "slug", "is_default") VALUES
	('2024-05-21 04:06:53.917601+00', '#32DE8A', 'Team A', '5932f887-2683-4489-b659-2024f57fd80d', '4167bf11-dc10-46d3-9d32-e5b7ad9d3e67', 'team-a', NULL),
	('2024-05-21 04:07:21.815976+00', '#EF7674', 'Team B', 'f64dab6d-0271-4a90-8deb-654dab220ce6', '4167bf11-dc10-46d3-9d32-e5b7ad9d3e67', 'team-b', NULL),
	('2024-05-21 04:07:52.407531+00', '#F2AF29', 'Team C', '8dd04996-eddd-49ee-8e36-c459202e87e4', '4167bf11-dc10-46d3-9d32-e5b7ad9d3e67', 'team-c', NULL);


--
-- Data for Name: live_debate_agenda; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: live_debate_audience_team_only; Type: TABLE DATA; Schema: public; Owner: postgres
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

INSERT INTO "public"."live_debate_participants" ("created_at", "speaker_id", "mic_id", "cam_id", "speaker_enable", "mic_enable", "cam_enable", "screenshare_available", "speaker_available", "mic_available", "cam_available", "current_stage", "is_kicked", "display_name", "team", "hand_raised", "is_host", "live_debate", "location", "participant_id", "host_id", "profile_image_enable", "screenshare_enable", "hand_raised_at", "role") VALUES
	('2024-05-29 06:22:19.411647+00', 'default', 'default', '0026ce49354cda2550e2098d9cd9f254afa121d671cc6ff55e3ae3a8ed0bb12c', true, true, true, true, true, true, true, NULL, NULL, 'Host', '8dd04996-eddd-49ee-8e36-c459202e87e4', NULL, true, '9178d46f-3090-4392-85f1-3b5c84867dd7', 'stage', '26d288ae-1bfa-4a01-8469-d694b52a8972', NULL, NULL, NULL, NULL, 'host'),
	('2024-05-30 00:51:27.131184+00', NULL, NULL, NULL, true, true, true, NULL, NULL, NULL, NULL, NULL, NULL, 'user3', 'f64dab6d-0271-4a90-8deb-654dab220ce6', NULL, false, '4167bf11-dc10-46d3-9d32-e5b7ad9d3e67', 'backstage', '26d288ae-1bfa-4a01-8469-d694b52a8972', NULL, NULL, NULL, NULL, 'co-host'),
	('2024-05-21 04:13:06.013692+00', '1', '', NULL, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, 'Smitty', 'f64dab6d-0271-4a90-8deb-654dab220ce6', NULL, false, '4167bf11-dc10-46d3-9d32-e5b7ad9d3e67', 'stage', '28170dd2-8ad5-4752-95df-b4853cda2bfb', '26d288ae-1bfa-4a01-8469-d694b52a8972', false, false, NULL, 'co-host'),
	('2024-05-21 07:29:56.819559+00', '12', NULL, NULL, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, 'test', '5932f887-2683-4489-b659-2024f57fd80d', NULL, false, '4167bf11-dc10-46d3-9d32-e5b7ad9d3e67', 'stage', 'dc81fe33-706b-40eb-962b-14ebf3eadc58', '26d288ae-1bfa-4a01-8469-d694b52a8972', true, false, NULL, 'co-host');


--
-- Data for Name: live_debate_user_team; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."live_debate_user_team" ("user_id", "created_at", "live_debate", "team") VALUES
	('26d288ae-1bfa-4a01-8469-d694b52a8972', '2024-05-30 00:37:39.245962+00', '4167bf11-dc10-46d3-9d32-e5b7ad9d3e67', 'f64dab6d-0271-4a90-8deb-654dab220ce6');


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
-- Data for Name: live_user_ban; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: social_links; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."social_links" ("id", "created_at", "link", "media", "user_id") VALUES
	('36c28061-fb99-4a19-b17b-7f7978e180d7', '2024-05-29 20:56:37.788198+00', 'https://github.com/salman2301', NULL, '26d288ae-1bfa-4a01-8469-d694b52a8972');


--
-- Data for Name: user_email; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: user_phone; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

INSERT INTO "storage"."buckets" ("id", "name", "owner", "created_at", "updated_at", "public", "avif_autodetection", "file_size_limit", "allowed_mime_types", "owner_id") VALUES
	('profile_image', 'profile_image', NULL, '2024-05-29 04:31:00.902662+00', '2024-05-29 04:31:00.902662+00', true, false, 12582912, '{image/*}', NULL);


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

INSERT INTO "storage"."objects" ("id", "bucket_id", "name", "owner", "created_at", "updated_at", "last_accessed_at", "metadata", "version", "owner_id") VALUES
	('ed833350-af25-42d7-b8cf-2483dc82bd7c', 'profile_image', '6e3dbe74-8e57-46c4-b3cc-c1bb3a73895a.png', '26d288ae-1bfa-4a01-8469-d694b52a8972', '2024-05-29 04:32:46.286436+00', '2024-05-29 04:32:46.286436+00', '2024-05-29 04:32:46.286436+00', '{"eTag": "\"395dc3ab5f7415c6afb77b8e1704ee9c\"", "size": 166053, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2024-05-29T04:32:46.274Z", "contentLength": 166053, "httpStatusCode": 200}', '3cf51259-d27f-4ff0-9938-016e69076506', '26d288ae-1bfa-4a01-8469-d694b52a8972'),
	('bd2f93d7-a67b-4669-a7f5-c725a78e68b5', 'profile_image', '4dce927c-5b47-4285-8ce0-8da648793921.png', '26d288ae-1bfa-4a01-8469-d694b52a8972', '2024-05-29 21:20:14.867299+00', '2024-05-29 21:20:14.867299+00', '2024-05-29 21:20:14.867299+00', '{"eTag": "\"ec22505d7f1ec8588676e4ce95fc7dcc\"", "size": 3511419, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2024-05-29T21:20:14.815Z", "contentLength": 3511419, "httpStatusCode": 200}', '635172c1-f880-4d83-adc0-a274461d7231', '26d288ae-1bfa-4a01-8469-d694b52a8972'),
	('78dcac5a-6191-4906-a009-a5bcfeef063e', 'profile_image', 'e5b5991f-a3e2-4e34-8470-1eb5abc6afc0.png', '26d288ae-1bfa-4a01-8469-d694b52a8972', '2024-05-29 22:09:10.100699+00', '2024-05-29 22:09:10.100699+00', '2024-05-29 22:09:10.100699+00', '{"eTag": "\"458be2884a995decf97a3473843484e0\"", "size": 176702, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2024-05-29T22:09:10.090Z", "contentLength": 176702, "httpStatusCode": 200}', '975b9fae-60f4-4627-83dc-4f13a6d2958e', '26d288ae-1bfa-4a01-8469-d694b52a8972'),
	('e2091a5a-4b9a-4115-a9e1-eb897f8efc75', 'profile_image', '954c9491-6f9b-4926-83a4-b8ae28bb9caa.png', '26d288ae-1bfa-4a01-8469-d694b52a8972', '2024-05-29 22:09:32.696595+00', '2024-05-29 22:09:32.696595+00', '2024-05-29 22:09:32.696595+00', '{"eTag": "\"784d3877b5fb3bfcb4ba2f4af5484255\"", "size": 87217, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2024-05-29T22:09:32.692Z", "contentLength": 87217, "httpStatusCode": 200}', 'aec0543d-eed6-4bec-9e1d-f0d739fc8afb', '26d288ae-1bfa-4a01-8469-d694b52a8972'),
	('7e8c553f-95ea-419f-9018-e7738f3e9bd4', 'profile_image', '41d1f6aa-11e9-4a85-9f8f-cdd5fdbf8d91.png', '26d288ae-1bfa-4a01-8469-d694b52a8972', '2024-05-29 22:09:52.103724+00', '2024-05-29 22:09:52.103724+00', '2024-05-29 22:09:52.103724+00', '{"eTag": "\"ec22505d7f1ec8588676e4ce95fc7dcc\"", "size": 3511419, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2024-05-29T22:09:52.074Z", "contentLength": 3511419, "httpStatusCode": 200}', '29e57818-5e78-45f9-bfca-efab55384f1e', '26d288ae-1bfa-4a01-8469-d694b52a8972');


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('"auth"."refresh_tokens_id_seq"', 28, true);


--
-- PostgreSQL database dump complete
--

RESET ALL;
