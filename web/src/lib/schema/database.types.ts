export type Json = string | number | boolean | null | { [key: string]: Json | undefined } | Json[];

export type Database = {
	public: {
		Tables: {
			host_stream_key: {
				Row: {
					created_at: string;
					id: string;
					stream_key: string;
				};
				Insert: {
					created_at?: string;
					id?: string;
					stream_key: string;
				};
				Update: {
					created_at?: string;
					id?: string;
					stream_key?: string;
				};
				Relationships: [];
			};
			live_feed: {
				Row: {
					auto_move_to_stage: boolean | null;
					backstage_audience: Database['public']['Enums']['audience_type'][] | null;
					backstage_max: number | null;
					chat_audience: Database['public']['Enums']['audience_type'][] | null;
					chat_filter_words: string | null;
					chat_rules: string | null;
					created_at: string;
					ended: boolean | null;
					ended_tz: string | null;
					feed_type: string | null;
					feeder_card_show: boolean | null;
					host: string | null;
					host_username: string | null;
					id: string;
					max_participants: number;
					max_stage: number;
					published: boolean | null;
					published_tz: string | null;
					studio_mode: boolean | null;
					title: string | null;
					viewer_audience: Database['public']['Enums']['audience_type'][] | null;
				};
				Insert: {
					auto_move_to_stage?: boolean | null;
					backstage_audience?: Database['public']['Enums']['audience_type'][] | null;
					backstage_max?: number | null;
					chat_audience?: Database['public']['Enums']['audience_type'][] | null;
					chat_filter_words?: string | null;
					chat_rules?: string | null;
					created_at?: string;
					ended?: boolean | null;
					ended_tz?: string | null;
					feed_type?: string | null;
					feeder_card_show?: boolean | null;
					host?: string | null;
					host_username?: string | null;
					id?: string;
					max_participants?: number;
					max_stage?: number;
					published?: boolean | null;
					published_tz?: string | null;
					studio_mode?: boolean | null;
					title?: string | null;
					viewer_audience?: Database['public']['Enums']['audience_type'][] | null;
				};
				Update: {
					auto_move_to_stage?: boolean | null;
					backstage_audience?: Database['public']['Enums']['audience_type'][] | null;
					backstage_max?: number | null;
					chat_audience?: Database['public']['Enums']['audience_type'][] | null;
					chat_filter_words?: string | null;
					chat_rules?: string | null;
					created_at?: string;
					ended?: boolean | null;
					ended_tz?: string | null;
					feed_type?: string | null;
					feeder_card_show?: boolean | null;
					host?: string | null;
					host_username?: string | null;
					id?: string;
					max_participants?: number;
					max_stage?: number;
					published?: boolean | null;
					published_tz?: string | null;
					studio_mode?: boolean | null;
					title?: string | null;
					viewer_audience?: Database['public']['Enums']['audience_type'][] | null;
				};
				Relationships: [
					{
						foreignKeyName: 'public_live_feed_host_fkey';
						columns: ['host'];
						isOneToOne: false;
						referencedRelation: 'user_data';
						referencedColumns: ['id'];
					}
				];
			};
			live_feed_agenda: {
				Row: {
					completed: boolean | null;
					created_at: string;
					id: string;
					live_feed: string | null;
					team: string | null;
					time: string | null;
					title: string | null;
				};
				Insert: {
					completed?: boolean | null;
					created_at?: string;
					id?: string;
					live_feed?: string | null;
					team?: string | null;
					time?: string | null;
					title?: string | null;
				};
				Update: {
					completed?: boolean | null;
					created_at?: string;
					id?: string;
					live_feed?: string | null;
					team?: string | null;
					time?: string | null;
					title?: string | null;
				};
				Relationships: [
					{
						foreignKeyName: 'feed_agenda_live_feed_fkey';
						columns: ['live_feed'];
						isOneToOne: false;
						referencedRelation: 'live_feed';
						referencedColumns: ['id'];
					},
					{
						foreignKeyName: 'feed_agenda_team_fkey';
						columns: ['team'];
						isOneToOne: false;
						referencedRelation: 'live_feed_team';
						referencedColumns: ['id'];
					}
				];
			};
			live_feed_audience_team_only: {
				Row: {
					created_at: string;
					live_feed: string;
					service: Database['public']['Enums']['audience_service'];
					team: string;
				};
				Insert: {
					created_at?: string;
					live_feed: string;
					service: Database['public']['Enums']['audience_service'];
					team: string;
				};
				Update: {
					created_at?: string;
					live_feed?: string;
					service?: Database['public']['Enums']['audience_service'];
					team?: string;
				};
				Relationships: [
					{
						foreignKeyName: 'live_feed_audience_team_only_live_feed_fkey';
						columns: ['live_feed'];
						isOneToOne: false;
						referencedRelation: 'live_feed';
						referencedColumns: ['id'];
					},
					{
						foreignKeyName: 'live_feed_audience_team_only_team_fkey';
						columns: ['team'];
						isOneToOne: false;
						referencedRelation: 'live_feed_team';
						referencedColumns: ['id'];
					}
				];
			};
			live_feed_backstage_chat: {
				Row: {
					chat: string;
					created_at: string;
					id: string;
					live_feed_id: string;
					sender_id: string;
				};
				Insert: {
					chat: string;
					created_at?: string;
					id?: string;
					live_feed_id: string;
					sender_id: string;
				};
				Update: {
					chat?: string;
					created_at?: string;
					id?: string;
					live_feed_id?: string;
					sender_id?: string;
				};
				Relationships: [
					{
						foreignKeyName: 'live_feed_backstage_chat_live_feed_id_fkey';
						columns: ['live_feed_id'];
						isOneToOne: false;
						referencedRelation: 'live_feed';
						referencedColumns: ['id'];
					},
					{
						foreignKeyName: 'live_feed_backstage_chat_sender_id_fkey';
						columns: ['sender_id'];
						isOneToOne: false;
						referencedRelation: 'user_data';
						referencedColumns: ['id'];
					}
				];
			};
			live_feed_chat: {
				Row: {
					chat: string;
					created_at: string;
					id: string;
					live_feed: string;
					sender_id: string;
				};
				Insert: {
					chat: string;
					created_at?: string;
					id?: string;
					live_feed: string;
					sender_id: string;
				};
				Update: {
					chat?: string;
					created_at?: string;
					id?: string;
					live_feed?: string;
					sender_id?: string;
				};
				Relationships: [
					{
						foreignKeyName: 'live_feed_chat_live_feed_fkey';
						columns: ['live_feed'];
						isOneToOne: false;
						referencedRelation: 'live_feed';
						referencedColumns: ['id'];
					},
					{
						foreignKeyName: 'live_feed_chat_sender_id_fkey';
						columns: ['sender_id'];
						isOneToOne: false;
						referencedRelation: 'user_data';
						referencedColumns: ['id'];
					}
				];
			};
			live_feed_invite_co_host: {
				Row: {
					created_at: string;
					email: string;
					id: string;
					invited_by: string;
					live_feed: string;
					status: string;
					team: string | null;
				};
				Insert: {
					created_at?: string;
					email: string;
					id?: string;
					invited_by: string;
					live_feed: string;
					status: string;
					team?: string | null;
				};
				Update: {
					created_at?: string;
					email?: string;
					id?: string;
					invited_by?: string;
					live_feed?: string;
					status?: string;
					team?: string | null;
				};
				Relationships: [
					{
						foreignKeyName: 'live_feed_invite_co_host_invited_by_fkey';
						columns: ['invited_by'];
						isOneToOne: false;
						referencedRelation: 'user_data';
						referencedColumns: ['id'];
					},
					{
						foreignKeyName: 'live_feed_invite_co_host_live_feed_fkey';
						columns: ['live_feed'];
						isOneToOne: false;
						referencedRelation: 'live_feed';
						referencedColumns: ['id'];
					},
					{
						foreignKeyName: 'live_feed_invite_co_host_team_fkey';
						columns: ['team'];
						isOneToOne: false;
						referencedRelation: 'live_feed_team';
						referencedColumns: ['id'];
					}
				];
			};
			live_feed_kick: {
				Row: {
					created_at: string;
					id: string;
					kicked_by: string;
					live_feed: string;
					reason: string | null;
					user_id: string;
				};
				Insert: {
					created_at?: string;
					id?: string;
					kicked_by: string;
					live_feed: string;
					reason?: string | null;
					user_id: string;
				};
				Update: {
					created_at?: string;
					id?: string;
					kicked_by?: string;
					live_feed?: string;
					reason?: string | null;
					user_id?: string;
				};
				Relationships: [
					{
						foreignKeyName: 'live_feed_kick_kicked_by_fkey';
						columns: ['kicked_by'];
						isOneToOne: false;
						referencedRelation: 'user_data';
						referencedColumns: ['id'];
					},
					{
						foreignKeyName: 'live_feed_kick_live_feed_fkey';
						columns: ['live_feed'];
						isOneToOne: false;
						referencedRelation: 'live_feed';
						referencedColumns: ['id'];
					},
					{
						foreignKeyName: 'live_feed_kick_user_id_fkey';
						columns: ['user_id'];
						isOneToOne: false;
						referencedRelation: 'user_data';
						referencedColumns: ['id'];
					}
				];
			};
			live_feed_notification: {
				Row: {
					created_at: string;
					has_read: boolean;
					live_feed: string;
					missed_count: number | null;
					service: Database['public']['Enums']['notification_service'];
				};
				Insert: {
					created_at?: string;
					has_read: boolean;
					live_feed: string;
					missed_count?: number | null;
					service: Database['public']['Enums']['notification_service'];
				};
				Update: {
					created_at?: string;
					has_read?: boolean;
					live_feed?: string;
					missed_count?: number | null;
					service?: Database['public']['Enums']['notification_service'];
				};
				Relationships: [
					{
						foreignKeyName: 'live_feed_notification_live_feed_fkey';
						columns: ['live_feed'];
						isOneToOne: false;
						referencedRelation: 'live_feed';
						referencedColumns: ['id'];
					}
				];
			};
			live_feed_participants: {
				Row: {
					cam_available: boolean | null;
					cam_enable: boolean | null;
					cam_id: string | null;
					created_at: string;
					current_stage: string | null;
					display_name: string;
					hand_raised: boolean | null;
					hand_raised_at: string | null;
					host_id: string | null;
					is_kicked: boolean | null;
					live_feed: string;
					location: Database['public']['Enums']['participant_location'];
					mic_available: boolean | null;
					mic_enable: boolean | null;
					mic_id: string | null;
					participant_id: string;
					profile_image_enable: boolean | null;
					role: Database['public']['Enums']['role'];
					screenshare_available: boolean | null;
					screenshare_enable: boolean | null;
					speaker_available: boolean | null;
					speaker_enable: boolean | null;
					speaker_id: string | null;
					team: string | null;
				};
				Insert: {
					cam_available?: boolean | null;
					cam_enable?: boolean | null;
					cam_id?: string | null;
					created_at?: string;
					current_stage?: string | null;
					display_name: string;
					hand_raised?: boolean | null;
					hand_raised_at?: string | null;
					host_id?: string | null;
					is_kicked?: boolean | null;
					live_feed: string;
					location: Database['public']['Enums']['participant_location'];
					mic_available?: boolean | null;
					mic_enable?: boolean | null;
					mic_id?: string | null;
					participant_id?: string;
					profile_image_enable?: boolean | null;
					role: Database['public']['Enums']['role'];
					screenshare_available?: boolean | null;
					screenshare_enable?: boolean | null;
					speaker_available?: boolean | null;
					speaker_enable?: boolean | null;
					speaker_id?: string | null;
					team?: string | null;
				};
				Update: {
					cam_available?: boolean | null;
					cam_enable?: boolean | null;
					cam_id?: string | null;
					created_at?: string;
					current_stage?: string | null;
					display_name?: string;
					hand_raised?: boolean | null;
					hand_raised_at?: string | null;
					host_id?: string | null;
					is_kicked?: boolean | null;
					live_feed?: string;
					location?: Database['public']['Enums']['participant_location'];
					mic_available?: boolean | null;
					mic_enable?: boolean | null;
					mic_id?: string | null;
					participant_id?: string;
					profile_image_enable?: boolean | null;
					role?: Database['public']['Enums']['role'];
					screenshare_available?: boolean | null;
					screenshare_enable?: boolean | null;
					speaker_available?: boolean | null;
					speaker_enable?: boolean | null;
					speaker_id?: string | null;
					team?: string | null;
				};
				Relationships: [
					{
						foreignKeyName: 'live_feed_participants_host_id_fkey';
						columns: ['host_id'];
						isOneToOne: false;
						referencedRelation: 'user_data';
						referencedColumns: ['id'];
					},
					{
						foreignKeyName: 'live_feed_participants_id_fkey';
						columns: ['participant_id'];
						isOneToOne: false;
						referencedRelation: 'user_data';
						referencedColumns: ['id'];
					},
					{
						foreignKeyName: 'live_feed_participants_live_feed_fkey';
						columns: ['live_feed'];
						isOneToOne: false;
						referencedRelation: 'live_feed';
						referencedColumns: ['id'];
					},
					{
						foreignKeyName: 'public_live_feed_participants_team_fkey';
						columns: ['team'];
						isOneToOne: false;
						referencedRelation: 'live_feed_team';
						referencedColumns: ['id'];
					}
				];
			};
			live_feed_team: {
				Row: {
					color: string;
					created_at: string;
					id: string;
					is_default: boolean | null;
					live_feed: string;
					slug: string;
					title: string;
				};
				Insert: {
					color: string;
					created_at?: string;
					id?: string;
					is_default?: boolean | null;
					live_feed: string;
					slug: string;
					title: string;
				};
				Update: {
					color?: string;
					created_at?: string;
					id?: string;
					is_default?: boolean | null;
					live_feed?: string;
					slug?: string;
					title?: string;
				};
				Relationships: [
					{
						foreignKeyName: 'live_feed_team_live_feed_fkey';
						columns: ['live_feed'];
						isOneToOne: false;
						referencedRelation: 'live_feed';
						referencedColumns: ['id'];
					}
				];
			};
			live_feed_user_role: {
				Row: {
					created_at: string;
					live_feed: string;
					role: Database['public']['Enums']['role'];
					user_id: string;
				};
				Insert: {
					created_at?: string;
					live_feed: string;
					role: Database['public']['Enums']['role'];
					user_id: string;
				};
				Update: {
					created_at?: string;
					live_feed?: string;
					role?: Database['public']['Enums']['role'];
					user_id?: string;
				};
				Relationships: [
					{
						foreignKeyName: 'live_feed_user_role_live_feed_fkey';
						columns: ['live_feed'];
						isOneToOne: false;
						referencedRelation: 'live_feed';
						referencedColumns: ['id'];
					},
					{
						foreignKeyName: 'live_feed_user_role_user_id_fkey';
						columns: ['user_id'];
						isOneToOne: false;
						referencedRelation: 'user_data';
						referencedColumns: ['id'];
					}
				];
			};
			live_feed_user_team: {
				Row: {
					created_at: string;
					live_feed: string;
					team: string;
					user_id: string;
				};
				Insert: {
					created_at?: string;
					live_feed: string;
					team: string;
					user_id?: string;
				};
				Update: {
					created_at?: string;
					live_feed?: string;
					team?: string;
					user_id?: string;
				};
				Relationships: [
					{
						foreignKeyName: 'live_feed_user_team_live_feed_fkey';
						columns: ['live_feed'];
						isOneToOne: false;
						referencedRelation: 'live_feed';
						referencedColumns: ['id'];
					},
					{
						foreignKeyName: 'live_feed_user_team_user_id_fkey';
						columns: ['user_id'];
						isOneToOne: false;
						referencedRelation: 'user_data';
						referencedColumns: ['id'];
					}
				];
			};
			live_host_ban: {
				Row: {
					banned_by: string;
					created_at: string;
					live_feed: string;
					reason: string | null;
					reason_title: string | null;
					user_id: string;
				};
				Insert: {
					banned_by?: string;
					created_at?: string;
					live_feed: string;
					reason?: string | null;
					reason_title?: string | null;
					user_id: string;
				};
				Update: {
					banned_by?: string;
					created_at?: string;
					live_feed?: string;
					reason?: string | null;
					reason_title?: string | null;
					user_id?: string;
				};
				Relationships: [
					{
						foreignKeyName: 'live_host_ban_banned_by_fkey';
						columns: ['banned_by'];
						isOneToOne: false;
						referencedRelation: 'user_data';
						referencedColumns: ['id'];
					},
					{
						foreignKeyName: 'live_host_ban_live_feed_fkey';
						columns: ['live_feed'];
						isOneToOne: false;
						referencedRelation: 'live_feed';
						referencedColumns: ['id'];
					},
					{
						foreignKeyName: 'live_host_ban_user_id_fkey';
						columns: ['user_id'];
						isOneToOne: false;
						referencedRelation: 'user_data';
						referencedColumns: ['id'];
					}
				];
			};
			live_host_follower: {
				Row: {
					count: number | null;
					created_at: string;
					id: string;
				};
				Insert: {
					count?: number | null;
					created_at?: string;
					id?: string;
				};
				Update: {
					count?: number | null;
					created_at?: string;
					id?: string;
				};
				Relationships: [
					{
						foreignKeyName: 'live_host_follower_id_fkey';
						columns: ['id'];
						isOneToOne: true;
						referencedRelation: 'users';
						referencedColumns: ['id'];
					}
				];
			};
			live_host_support: {
				Row: {
					count: number | null;
					created_at: string;
					id: string;
				};
				Insert: {
					count?: number | null;
					created_at?: string;
					id?: string;
				};
				Update: {
					count?: number | null;
					created_at?: string;
					id?: string;
				};
				Relationships: [
					{
						foreignKeyName: 'live_host_support_id_fkey';
						columns: ['id'];
						isOneToOne: true;
						referencedRelation: 'users';
						referencedColumns: ['id'];
					}
				];
			};
			live_user_ban: {
				Row: {
					banned_until: string | null;
					created_at: string;
					description: string | null;
					id: string;
					title: string | null;
					user_id: string;
				};
				Insert: {
					banned_until?: string | null;
					created_at?: string;
					description?: string | null;
					id?: string;
					title?: string | null;
					user_id: string;
				};
				Update: {
					banned_until?: string | null;
					created_at?: string;
					description?: string | null;
					id?: string;
					title?: string | null;
					user_id?: string;
				};
				Relationships: [
					{
						foreignKeyName: 'live_user_ban_user_id_fkey';
						columns: ['user_id'];
						isOneToOne: false;
						referencedRelation: 'user_data';
						referencedColumns: ['id'];
					}
				];
			};
			social_links: {
				Row: {
					created_at: string;
					id: string;
					link: string | null;
					media: string | null;
					user_id: string | null;
				};
				Insert: {
					created_at?: string;
					id?: string;
					link?: string | null;
					media?: string | null;
					user_id?: string | null;
				};
				Update: {
					created_at?: string;
					id?: string;
					link?: string | null;
					media?: string | null;
					user_id?: string | null;
				};
				Relationships: [
					{
						foreignKeyName: 'social_links_user_id_fkey';
						columns: ['user_id'];
						isOneToOne: false;
						referencedRelation: 'users';
						referencedColumns: ['id'];
					}
				];
			};
			user_data: {
				Row: {
					created_at: string;
					displayName: string | null;
					email: string | null;
					firstName: string | null;
					fullName: string | null;
					id: string;
					initials: string | null;
					lastName: string | null;
					oneLineDesc: string | null;
					profile_image: string | null;
					username: string;
				};
				Insert: {
					created_at?: string;
					displayName?: string | null;
					email?: string | null;
					firstName?: string | null;
					fullName?: string | null;
					id?: string;
					initials?: string | null;
					lastName?: string | null;
					oneLineDesc?: string | null;
					profile_image?: string | null;
					username: string;
				};
				Update: {
					created_at?: string;
					displayName?: string | null;
					email?: string | null;
					firstName?: string | null;
					fullName?: string | null;
					id?: string;
					initials?: string | null;
					lastName?: string | null;
					oneLineDesc?: string | null;
					profile_image?: string | null;
					username?: string;
				};
				Relationships: [
					{
						foreignKeyName: 'user_data_id_fkey';
						columns: ['id'];
						isOneToOne: true;
						referencedRelation: 'users';
						referencedColumns: ['id'];
					}
				];
			};
			user_email: {
				Row: {
					created_at: string;
					email: string | null;
					id: string;
					user_id: string | null;
					verified: boolean | null;
				};
				Insert: {
					created_at?: string;
					email?: string | null;
					id?: string;
					user_id?: string | null;
					verified?: boolean | null;
				};
				Update: {
					created_at?: string;
					email?: string | null;
					id?: string;
					user_id?: string | null;
					verified?: boolean | null;
				};
				Relationships: [
					{
						foreignKeyName: 'user_email_user_id_fkey';
						columns: ['user_id'];
						isOneToOne: false;
						referencedRelation: 'users';
						referencedColumns: ['id'];
					}
				];
			};
			user_phone: {
				Row: {
					country: string | null;
					created_at: string;
					id: string;
					phone: string | null;
					user_id: string | null;
					verified: boolean | null;
				};
				Insert: {
					country?: string | null;
					created_at?: string;
					id?: string;
					phone?: string | null;
					user_id?: string | null;
					verified?: boolean | null;
				};
				Update: {
					country?: string | null;
					created_at?: string;
					id?: string;
					phone?: string | null;
					user_id?: string | null;
					verified?: boolean | null;
				};
				Relationships: [];
			};
		};
		Views: {
			[_ in never]: never;
		};
		Functions: {
			is_space_left: {
				Args: {
					live_feed_id: string;
				};
				Returns: boolean;
			};
			turn_on_realtime: {
				Args: Record<PropertyKey, never>;
				Returns: string;
			};
			user_atleast_co_host: {
				Args: {
					live_feed_id: string;
				};
				Returns: boolean;
			};
			user_atleast_mod: {
				Args: {
					live_feed_id: string;
				};
				Returns: boolean;
			};
			user_is_host: {
				Args: {
					live_feed_id: string;
				};
				Returns: boolean;
			};
			user_not_banned: {
				Args: Record<PropertyKey, never>;
				Returns: boolean;
			};
		};
		Enums: {
			audience_service: 'viewer' | 'chat' | 'backstage';
			audience_type:
				| 'supporter'
				| 'follower'
				| 'team-only'
				| 'registered'
				| 'anonymous'
				| 'invite_only'
				| 'none';
			notification_service:
				| 'live_chat'
				| 'backstage_chat'
				| 'screen_share_new'
				| 'backstage_new_participant'
				| 'poll_result'
				| 'question_answer'
				| 'activity_feed';
			participant_location: 'stage' | 'backstage';
			role: 'host' | 'co-host' | 'mod' | 'guest';
		};
		CompositeTypes: {
			[_ in never]: never;
		};
	};
	storage: {
		Tables: {
			buckets: {
				Row: {
					allowed_mime_types: string[] | null;
					avif_autodetection: boolean | null;
					created_at: string | null;
					file_size_limit: number | null;
					id: string;
					name: string;
					owner: string | null;
					owner_id: string | null;
					public: boolean | null;
					updated_at: string | null;
				};
				Insert: {
					allowed_mime_types?: string[] | null;
					avif_autodetection?: boolean | null;
					created_at?: string | null;
					file_size_limit?: number | null;
					id: string;
					name: string;
					owner?: string | null;
					owner_id?: string | null;
					public?: boolean | null;
					updated_at?: string | null;
				};
				Update: {
					allowed_mime_types?: string[] | null;
					avif_autodetection?: boolean | null;
					created_at?: string | null;
					file_size_limit?: number | null;
					id?: string;
					name?: string;
					owner?: string | null;
					owner_id?: string | null;
					public?: boolean | null;
					updated_at?: string | null;
				};
				Relationships: [];
			};
			migrations: {
				Row: {
					executed_at: string | null;
					hash: string;
					id: number;
					name: string;
				};
				Insert: {
					executed_at?: string | null;
					hash: string;
					id: number;
					name: string;
				};
				Update: {
					executed_at?: string | null;
					hash?: string;
					id?: number;
					name?: string;
				};
				Relationships: [];
			};
			objects: {
				Row: {
					bucket_id: string | null;
					created_at: string | null;
					id: string;
					last_accessed_at: string | null;
					metadata: Json | null;
					name: string | null;
					owner: string | null;
					owner_id: string | null;
					path_tokens: string[] | null;
					updated_at: string | null;
					version: string | null;
				};
				Insert: {
					bucket_id?: string | null;
					created_at?: string | null;
					id?: string;
					last_accessed_at?: string | null;
					metadata?: Json | null;
					name?: string | null;
					owner?: string | null;
					owner_id?: string | null;
					path_tokens?: string[] | null;
					updated_at?: string | null;
					version?: string | null;
				};
				Update: {
					bucket_id?: string | null;
					created_at?: string | null;
					id?: string;
					last_accessed_at?: string | null;
					metadata?: Json | null;
					name?: string | null;
					owner?: string | null;
					owner_id?: string | null;
					path_tokens?: string[] | null;
					updated_at?: string | null;
					version?: string | null;
				};
				Relationships: [
					{
						foreignKeyName: 'objects_bucketId_fkey';
						columns: ['bucket_id'];
						isOneToOne: false;
						referencedRelation: 'buckets';
						referencedColumns: ['id'];
					}
				];
			};
			s3_multipart_uploads: {
				Row: {
					bucket_id: string;
					created_at: string;
					id: string;
					in_progress_size: number;
					key: string;
					owner_id: string | null;
					upload_signature: string;
					version: string;
				};
				Insert: {
					bucket_id: string;
					created_at?: string;
					id: string;
					in_progress_size?: number;
					key: string;
					owner_id?: string | null;
					upload_signature: string;
					version: string;
				};
				Update: {
					bucket_id?: string;
					created_at?: string;
					id?: string;
					in_progress_size?: number;
					key?: string;
					owner_id?: string | null;
					upload_signature?: string;
					version?: string;
				};
				Relationships: [
					{
						foreignKeyName: 's3_multipart_uploads_bucket_id_fkey';
						columns: ['bucket_id'];
						isOneToOne: false;
						referencedRelation: 'buckets';
						referencedColumns: ['id'];
					}
				];
			};
			s3_multipart_uploads_parts: {
				Row: {
					bucket_id: string;
					created_at: string;
					etag: string;
					id: string;
					key: string;
					owner_id: string | null;
					part_number: number;
					size: number;
					upload_id: string;
					version: string;
				};
				Insert: {
					bucket_id: string;
					created_at?: string;
					etag: string;
					id?: string;
					key: string;
					owner_id?: string | null;
					part_number: number;
					size?: number;
					upload_id: string;
					version: string;
				};
				Update: {
					bucket_id?: string;
					created_at?: string;
					etag?: string;
					id?: string;
					key?: string;
					owner_id?: string | null;
					part_number?: number;
					size?: number;
					upload_id?: string;
					version?: string;
				};
				Relationships: [
					{
						foreignKeyName: 's3_multipart_uploads_parts_bucket_id_fkey';
						columns: ['bucket_id'];
						isOneToOne: false;
						referencedRelation: 'buckets';
						referencedColumns: ['id'];
					},
					{
						foreignKeyName: 's3_multipart_uploads_parts_upload_id_fkey';
						columns: ['upload_id'];
						isOneToOne: false;
						referencedRelation: 's3_multipart_uploads';
						referencedColumns: ['id'];
					}
				];
			};
		};
		Views: {
			[_ in never]: never;
		};
		Functions: {
			can_insert_object: {
				Args: {
					bucketid: string;
					name: string;
					owner: string;
					metadata: Json;
				};
				Returns: undefined;
			};
			extension: {
				Args: {
					name: string;
				};
				Returns: string;
			};
			filename: {
				Args: {
					name: string;
				};
				Returns: string;
			};
			foldername: {
				Args: {
					name: string;
				};
				Returns: string[];
			};
			get_size_by_bucket: {
				Args: Record<PropertyKey, never>;
				Returns: {
					size: number;
					bucket_id: string;
				}[];
			};
			list_multipart_uploads_with_delimiter: {
				Args: {
					bucket_id: string;
					prefix_param: string;
					delimiter_param: string;
					max_keys?: number;
					next_key_token?: string;
					next_upload_token?: string;
				};
				Returns: {
					key: string;
					id: string;
					created_at: string;
				}[];
			};
			list_objects_with_delimiter: {
				Args: {
					bucket_id: string;
					prefix_param: string;
					delimiter_param: string;
					max_keys?: number;
					start_after?: string;
					next_token?: string;
				};
				Returns: {
					name: string;
					id: string;
					metadata: Json;
					updated_at: string;
				}[];
			};
			search: {
				Args: {
					prefix: string;
					bucketname: string;
					limits?: number;
					levels?: number;
					offsets?: number;
					search?: string;
					sortcolumn?: string;
					sortorder?: string;
				};
				Returns: {
					name: string;
					id: string;
					updated_at: string;
					created_at: string;
					last_accessed_at: string;
					metadata: Json;
				}[];
			};
		};
		Enums: {
			[_ in never]: never;
		};
		CompositeTypes: {
			[_ in never]: never;
		};
	};
};

type PublicSchema = Database[Extract<keyof Database, 'public'>];

export type Tables<
	PublicTableNameOrOptions extends
		| keyof (PublicSchema['Tables'] & PublicSchema['Views'])
		| { schema: keyof Database },
	TableName extends PublicTableNameOrOptions extends { schema: keyof Database }
		? keyof (Database[PublicTableNameOrOptions['schema']]['Tables'] &
				Database[PublicTableNameOrOptions['schema']]['Views'])
		: never = never
> = PublicTableNameOrOptions extends { schema: keyof Database }
	? (Database[PublicTableNameOrOptions['schema']]['Tables'] &
			Database[PublicTableNameOrOptions['schema']]['Views'])[TableName] extends {
			Row: infer R;
		}
		? R
		: never
	: PublicTableNameOrOptions extends keyof (PublicSchema['Tables'] & PublicSchema['Views'])
		? (PublicSchema['Tables'] & PublicSchema['Views'])[PublicTableNameOrOptions] extends {
				Row: infer R;
			}
			? R
			: never
		: never;

export type TablesInsert<
	PublicTableNameOrOptions extends keyof PublicSchema['Tables'] | { schema: keyof Database },
	TableName extends PublicTableNameOrOptions extends { schema: keyof Database }
		? keyof Database[PublicTableNameOrOptions['schema']]['Tables']
		: never = never
> = PublicTableNameOrOptions extends { schema: keyof Database }
	? Database[PublicTableNameOrOptions['schema']]['Tables'][TableName] extends {
			Insert: infer I;
		}
		? I
		: never
	: PublicTableNameOrOptions extends keyof PublicSchema['Tables']
		? PublicSchema['Tables'][PublicTableNameOrOptions] extends {
				Insert: infer I;
			}
			? I
			: never
		: never;

export type TablesUpdate<
	PublicTableNameOrOptions extends keyof PublicSchema['Tables'] | { schema: keyof Database },
	TableName extends PublicTableNameOrOptions extends { schema: keyof Database }
		? keyof Database[PublicTableNameOrOptions['schema']]['Tables']
		: never = never
> = PublicTableNameOrOptions extends { schema: keyof Database }
	? Database[PublicTableNameOrOptions['schema']]['Tables'][TableName] extends {
			Update: infer U;
		}
		? U
		: never
	: PublicTableNameOrOptions extends keyof PublicSchema['Tables']
		? PublicSchema['Tables'][PublicTableNameOrOptions] extends {
				Update: infer U;
			}
			? U
			: never
		: never;

export type Enums<
	PublicEnumNameOrOptions extends keyof PublicSchema['Enums'] | { schema: keyof Database },
	EnumName extends PublicEnumNameOrOptions extends { schema: keyof Database }
		? keyof Database[PublicEnumNameOrOptions['schema']]['Enums']
		: never = never
> = PublicEnumNameOrOptions extends { schema: keyof Database }
	? Database[PublicEnumNameOrOptions['schema']]['Enums'][EnumName]
	: PublicEnumNameOrOptions extends keyof PublicSchema['Enums']
		? PublicSchema['Enums'][PublicEnumNameOrOptions]
		: never;
