INSERT INTO public.live_debate (id,created_at,title,host,chat_rules,debate_type,chat_filter_words,chat_follower_only,chat_support_only,chat_team_only,backstage_allow_only,backstage_max,viewer_type,studio_mode,debater_card_show,ended) VALUES
	 ('55384d86-d9ca-4b6e-a12d-4c32e966e6b9','2024-05-20 21:18:39.230345+05:30','Test live debate','dd9b3940-6a35-47ee-a7f1-1421b41bae44','This is a dummy rules test',NULL,NULL,NULL,NULL,'35f7b650-1a86-4948-a4f2-af237907cf89',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO public.user_data (id,created_at,"displayName",email,"firstName","lastName","fullName",username,initials,"oneLineDesc") VALUES
	 ('dd9b3940-6a35-47ee-a7f1-1421b41bae44','2024-05-20 21:17:40.737834+05:30','Salman','salmanhammed77@gmail.com','Salman','K A A',NULL,'salman2301',NULL,NULL);

-- create test users
INSERT INTO
    auth.users (
        instance_id,
        id,
        aud,
        role,
        email,
        encrypted_password,
        email_confirmed_at,
        recovery_sent_at,
        last_sign_in_at,
        raw_app_meta_data,
        raw_user_meta_data,
        created_at,
        updated_at,
        confirmation_token,
        email_change,
        email_change_token_new,
        recovery_token
    ) (
        select
            '00000000-0000-0000-0000-000000000000',
            'dd9b3940-6a35-47ee-a7f1-1421b41bae44',
            'authenticated',
            'authenticated',
            'testuser@example.com',
            crypt ('testpass', gen_salt ('bf')),
            current_timestamp,
            current_timestamp,
            current_timestamp,
            '{"provider":"email","providers":["email"]}',
            '{}',
            current_timestamp,
            current_timestamp,
            '',
            '',
            '',
            ''
        FROM
            generate_series(1, 10)
    );

-- test user email identities
INSERT INTO
    auth.identities (
        id,
        user_id,
        identity_data,
        provider,
        last_sign_in_at,
        created_at,
        updated_at
    ) (
        select
            uuid_generate_v4 (),
            id,
            format('{"sub":"%s","email":"%s"}', id::text, email)::jsonb,
            'email',
            current_timestamp,
            current_timestamp,
            current_timestamp
        from
            auth.users
    );
