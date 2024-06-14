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
	('00000000-0000-0000-0000-000000000000', '26d288ae-1bfa-4a01-8469-d694b52a8972', 'authenticated', 'authenticated', 'teamuser3-c@example.com', '$2a$10$Loc3Uo6brgCHKXOFJwT2TeFzAi18YJxOng5knkN4copJNPz1y2tV2', '2024-05-21 03:56:54.992156+00', NULL, '', NULL, '', NULL, '', '', NULL, '2024-06-05 16:51:26.619807+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "26d288ae-1bfa-4a01-8469-d694b52a8972", "email": "teamuser3-c@example.com", "email_verified": false, "phone_verified": false}', NULL, '2024-05-21 03:56:54.970676+00', '2024-06-13 13:28:30.749773+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', 'dc81fe33-706b-40eb-962b-14ebf3eadc58', 'authenticated', 'authenticated', 'teamuser1-a@example.com', '$2a$10$kdcAumTjLvdiS//t5fKLjOywdzdC.wvNfS.2rBaREXw5rmp89BoV6', '2024-05-21 03:57:14.810281+00', NULL, '', NULL, '', NULL, '', '', NULL, '2024-06-13 13:55:10.707893+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "dc81fe33-706b-40eb-962b-14ebf3eadc58", "email": "teamuser1-a@example.com", "email_verified": false, "phone_verified": false}', NULL, '2024-05-21 03:57:14.80597+00', '2024-06-13 13:55:10.711824+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false);


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
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



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
-- Data for Name: live_feed; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."live_feed" ("id", "created_at", "title", "host", "chat_rules", "feed_type", "chat_filter_words", "backstage_max", "studio_mode", "feeder_card_show", "published", "max_participants", "max_stage", "backstage_audience", "chat_audience", "viewer_audience", "auto_move_to_stage", "ended", "ended_tz", "published_tz") VALUES
	('369fa6a1-1311-4b37-b9d3-3ba82e3c056a', '2024-06-02 07:46:06.015748+00', 'New feed', '26d288ae-1bfa-4a01-8469-d694b52a8972', NULL, NULL, NULL, NULL, NULL, NULL, true, 20, 10, '{anonymous}', '{anonymous}', '{anonymous}', true, true, NULL, '2024-06-02 07:47:16.018+00'),
	('7cb41530-2726-4d9a-8825-07bddc65807a', '2024-06-13 13:55:48.405212+00', NULL, 'dc81fe33-706b-40eb-962b-14ebf3eadc58', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 40, 30, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	('0834497a-bdd8-4529-8769-5b619111ea0c', '2024-06-13 13:56:09.08793+00', NULL, 'dc81fe33-706b-40eb-962b-14ebf3eadc58', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 40, 30, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
	('89d84603-d8c6-4296-b6c6-e0e3c40210e0', '2024-06-13 13:50:47.664498+00', 'test', '26d288ae-1bfa-4a01-8469-d694b52a8972', NULL, NULL, NULL, NULL, NULL, NULL, true, 10, 4, '{anonymous}', '{anonymous}', '{anonymous}', false, NULL, NULL, '2024-06-13 13:51:56.385+00');


--
-- Data for Name: live_feed_team; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."live_feed_team" ("created_at", "color", "title", "id", "live_feed", "slug", "is_default") VALUES
	('2024-06-13 13:51:07.731273+00', '#32DE8A', 'Team A', 'eb32685d-ada6-4c04-badc-5c3392e516c8', '89d84603-d8c6-4296-b6c6-e0e3c40210e0', 'team-a', true),
	('2024-06-13 13:51:09.859461+00', '#EF7674', 'Team B', '242675f6-779d-4297-829d-fdc2d5fb5ba0', '89d84603-d8c6-4296-b6c6-e0e3c40210e0', 'team-b', false),
	('2024-06-13 13:51:11.293583+00', '#F2AF29', 'Team C', '2f3e1d79-ec63-4ec3-88ca-c9797c504d0d', '89d84603-d8c6-4296-b6c6-e0e3c40210e0', 'team-c', false);


--
-- Data for Name: live_feed_agenda; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: live_feed_audience_team_only; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: live_feed_backstage_chat; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: live_feed_chat; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: live_feed_invite_co_host; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."live_feed_invite_co_host" ("id", "created_at", "invited_by", "status", "email", "team", "live_feed") VALUES
	('c8d8d0c1-f777-4a63-b7a3-ddaacccd2cdc', '2024-06-13 13:51:46.837921+00', '26d288ae-1bfa-4a01-8469-d694b52a8972', 'invited', 'salman@test.com', '242675f6-779d-4297-829d-fdc2d5fb5ba0', '89d84603-d8c6-4296-b6c6-e0e3c40210e0');


--
-- Data for Name: live_feed_kick; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: live_feed_notification; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: live_feed_participants; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."live_feed_participants" ("created_at", "speaker_id", "mic_id", "cam_id", "speaker_enable", "mic_enable", "cam_enable", "screenshare_available", "speaker_available", "mic_available", "cam_available", "current_stage", "is_kicked", "display_name", "team", "hand_raised", "live_feed", "location", "participant_id", "host_id", "profile_image_enable", "screenshare_enable", "hand_raised_at", "role") VALUES
	('2024-06-13 13:56:23.234111+00', NULL, NULL, NULL, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, 'What', 'eb32685d-ada6-4c04-badc-5c3392e516c8', NULL, '89d84603-d8c6-4296-b6c6-e0e3c40210e0', 'backstage', 'dc81fe33-706b-40eb-962b-14ebf3eadc58', NULL, true, true, NULL, 'guest'),
	('2024-06-13 13:50:47.675445+00', 'default', 'default', 'f99be2ea021149ba773fdb26c805335c8dfdd9b9eff8b6af99b572de5ecf633c', true, false, false, true, true, true, false, NULL, NULL, 'Jhon Doe', '2f3e1d79-ec63-4ec3-88ca-c9797c504d0d', NULL, '89d84603-d8c6-4296-b6c6-e0e3c40210e0', 'stage', '26d288ae-1bfa-4a01-8469-d694b52a8972', NULL, NULL, false, NULL, 'host');


--
-- Data for Name: live_feed_user_role; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."live_feed_user_role" ("user_id", "created_at", "live_feed", "role") VALUES
	('26d288ae-1bfa-4a01-8469-d694b52a8972', '2024-06-13 13:50:51.604693+00', '89d84603-d8c6-4296-b6c6-e0e3c40210e0', 'host');


--
-- Data for Name: live_feed_user_team; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."live_feed_user_team" ("user_id", "created_at", "live_feed", "team") VALUES
	('dc81fe33-706b-40eb-962b-14ebf3eadc58', '2024-06-13 13:56:35.15754+00', '89d84603-d8c6-4296-b6c6-e0e3c40210e0', 'eb32685d-ada6-4c04-badc-5c3392e516c8');


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

SELECT pg_catalog.setval('"auth"."refresh_tokens_id_seq"', 151, true);


--
-- PostgreSQL database dump complete
--

RESET ALL;
