export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  public: {
    Tables: {
      live_debate: {
        Row: {
          backstage_allow_only: string | null
          backstage_max: number | null
          chat_filter_words: string | null
          chat_follower_only: boolean | null
          chat_rules: string | null
          chat_support_only: boolean | null
          chat_team_only: string | null
          created_at: string
          debate_type: string | null
          debater_card_show: boolean | null
          host: string | null
          id: string
          studio_mode: boolean | null
          title: string | null
          viewer_type: string | null
        }
        Insert: {
          backstage_allow_only?: string | null
          backstage_max?: number | null
          chat_filter_words?: string | null
          chat_follower_only?: boolean | null
          chat_rules?: string | null
          chat_support_only?: boolean | null
          chat_team_only?: string | null
          created_at?: string
          debate_type?: string | null
          debater_card_show?: boolean | null
          host?: string | null
          id?: string
          studio_mode?: boolean | null
          title?: string | null
          viewer_type?: string | null
        }
        Update: {
          backstage_allow_only?: string | null
          backstage_max?: number | null
          chat_filter_words?: string | null
          chat_follower_only?: boolean | null
          chat_rules?: string | null
          chat_support_only?: boolean | null
          chat_team_only?: string | null
          created_at?: string
          debate_type?: string | null
          debater_card_show?: boolean | null
          host?: string | null
          id?: string
          studio_mode?: boolean | null
          title?: string | null
          viewer_type?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "live_debate_chat_team_only_fkey"
            columns: ["chat_team_only"]
            isOneToOne: false
            referencedRelation: "live_debate_team"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "public_live_debate_host_fkey"
            columns: ["host"]
            isOneToOne: false
            referencedRelation: "user_data"
            referencedColumns: ["id"]
          },
        ]
      }
      live_debate_agenda: {
        Row: {
          completed: boolean | null
          created_at: string
          id: string
          live_debate: string | null
          team: string | null
          time: string | null
          title: string | null
        }
        Insert: {
          completed?: boolean | null
          created_at?: string
          id?: string
          live_debate?: string | null
          team?: string | null
          time?: string | null
          title?: string | null
        }
        Update: {
          completed?: boolean | null
          created_at?: string
          id?: string
          live_debate?: string | null
          team?: string | null
          time?: string | null
          title?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "debate_agenda_live_debate_fkey"
            columns: ["live_debate"]
            isOneToOne: false
            referencedRelation: "live_debate"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "debate_agenda_team_fkey"
            columns: ["team"]
            isOneToOne: false
            referencedRelation: "live_debate_team"
            referencedColumns: ["id"]
          },
        ]
      }
      live_debate_backstage_chat: {
        Row: {
          chat: string
          created_at: string
          id: string
          live_debate_id: string
          sender_id: string
        }
        Insert: {
          chat: string
          created_at?: string
          id?: string
          live_debate_id: string
          sender_id: string
        }
        Update: {
          chat?: string
          created_at?: string
          id?: string
          live_debate_id?: string
          sender_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "live_debate_backstage_chat_live_debate_id_fkey"
            columns: ["live_debate_id"]
            isOneToOne: false
            referencedRelation: "live_debate"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "live_debate_backstage_chat_sender_id_fkey"
            columns: ["sender_id"]
            isOneToOne: false
            referencedRelation: "user_data"
            referencedColumns: ["id"]
          },
        ]
      }
      live_debate_chat: {
        Row: {
          chat: string
          created_at: string
          id: string
          live_debate: string
          sender_id: string
        }
        Insert: {
          chat: string
          created_at?: string
          id?: string
          live_debate: string
          sender_id: string
        }
        Update: {
          chat?: string
          created_at?: string
          id?: string
          live_debate?: string
          sender_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "live_debate_chat_live_debate_fkey"
            columns: ["live_debate"]
            isOneToOne: false
            referencedRelation: "live_debate"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "live_debate_chat_sender_id_fkey"
            columns: ["sender_id"]
            isOneToOne: false
            referencedRelation: "user_data"
            referencedColumns: ["id"]
          },
        ]
      }
      live_debate_kick: {
        Row: {
          created_at: string
          id: string
          kicked_by: string
          live_debate: string
          reason: string | null
          user_id: string
        }
        Insert: {
          created_at?: string
          id?: string
          kicked_by: string
          live_debate: string
          reason?: string | null
          user_id: string
        }
        Update: {
          created_at?: string
          id?: string
          kicked_by?: string
          live_debate?: string
          reason?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "live_debate_kick_kicked_by_fkey"
            columns: ["kicked_by"]
            isOneToOne: false
            referencedRelation: "user_data"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "live_debate_kick_live_debate_fkey"
            columns: ["live_debate"]
            isOneToOne: false
            referencedRelation: "live_debate"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "live_debate_kick_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "user_data"
            referencedColumns: ["id"]
          },
        ]
      }
      live_debate_notification: {
        Row: {
          created_at: string
          has_read: boolean
          live_debate: string
          missed_count: number | null
          service: Database["public"]["Enums"]["notification_service"]
        }
        Insert: {
          created_at?: string
          has_read: boolean
          live_debate: string
          missed_count?: number | null
          service: Database["public"]["Enums"]["notification_service"]
        }
        Update: {
          created_at?: string
          has_read?: boolean
          live_debate?: string
          missed_count?: number | null
          service?: Database["public"]["Enums"]["notification_service"]
        }
        Relationships: [
          {
            foreignKeyName: "live_debate_notification_live_debate_fkey"
            columns: ["live_debate"]
            isOneToOne: false
            referencedRelation: "live_debate"
            referencedColumns: ["id"]
          },
        ]
      }
      live_debate_participants: {
        Row: {
          cam_available: boolean | null
          cam_enable: boolean | null
          cam_id: string | null
          created_at: string
          current_stage: string | null
          display_name: string
          hand_raised: boolean | null
          host_id: string | null
          is_host: boolean
          is_kicked: boolean | null
          live_debate: string
          location: Database["public"]["Enums"]["participant_location"]
          mic_available: boolean | null
          mic_enable: boolean | null
          mic_id: string | null
          participant_id: string
          profile_image_enable: boolean | null
          screenshare_available: boolean | null
          screenshare_enable: boolean | null
          speaker_available: boolean | null
          speaker_enable: boolean | null
          speaker_id: string | null
          team: string
        }
        Insert: {
          cam_available?: boolean | null
          cam_enable?: boolean | null
          cam_id?: string | null
          created_at?: string
          current_stage?: string | null
          display_name: string
          hand_raised?: boolean | null
          host_id?: string | null
          is_host: boolean
          is_kicked?: boolean | null
          live_debate: string
          location: Database["public"]["Enums"]["participant_location"]
          mic_available?: boolean | null
          mic_enable?: boolean | null
          mic_id?: string | null
          participant_id?: string
          profile_image_enable?: boolean | null
          screenshare_available?: boolean | null
          screenshare_enable?: boolean | null
          speaker_available?: boolean | null
          speaker_enable?: boolean | null
          speaker_id?: string | null
          team: string
        }
        Update: {
          cam_available?: boolean | null
          cam_enable?: boolean | null
          cam_id?: string | null
          created_at?: string
          current_stage?: string | null
          display_name?: string
          hand_raised?: boolean | null
          host_id?: string | null
          is_host?: boolean
          is_kicked?: boolean | null
          live_debate?: string
          location?: Database["public"]["Enums"]["participant_location"]
          mic_available?: boolean | null
          mic_enable?: boolean | null
          mic_id?: string | null
          participant_id?: string
          profile_image_enable?: boolean | null
          screenshare_available?: boolean | null
          screenshare_enable?: boolean | null
          speaker_available?: boolean | null
          speaker_enable?: boolean | null
          speaker_id?: string | null
          team?: string
        }
        Relationships: [
          {
            foreignKeyName: "live_debate_participants_host_id_fkey"
            columns: ["host_id"]
            isOneToOne: false
            referencedRelation: "user_data"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "live_debate_participants_id_fkey"
            columns: ["participant_id"]
            isOneToOne: false
            referencedRelation: "user_data"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "live_debate_participants_live_debate_fkey"
            columns: ["live_debate"]
            isOneToOne: false
            referencedRelation: "live_debate"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "public_live_debate_participants_team_fkey"
            columns: ["team"]
            isOneToOne: false
            referencedRelation: "live_debate_team"
            referencedColumns: ["id"]
          },
        ]
      }
      live_debate_team: {
        Row: {
          color: string
          created_at: string
          id: string
          live_debate: string
          slug: string
          title: string
        }
        Insert: {
          color: string
          created_at?: string
          id?: string
          live_debate: string
          slug: string
          title: string
        }
        Update: {
          color?: string
          created_at?: string
          id?: string
          live_debate?: string
          slug?: string
          title?: string
        }
        Relationships: [
          {
            foreignKeyName: "live_debate_team_live_debate_fkey"
            columns: ["live_debate"]
            isOneToOne: false
            referencedRelation: "live_debate"
            referencedColumns: ["id"]
          },
        ]
      }
      live_host_ban: {
        Row: {
          banned_by: string
          created_at: string
          live_debate: string | null
          live_host_id: string
          reason: string | null
          reason_title: string | null
          user_id: string
        }
        Insert: {
          banned_by: string
          created_at?: string
          live_debate?: string | null
          live_host_id: string
          reason?: string | null
          reason_title?: string | null
          user_id: string
        }
        Update: {
          banned_by?: string
          created_at?: string
          live_debate?: string | null
          live_host_id?: string
          reason?: string | null
          reason_title?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "live_host_ban_banned_by_fkey"
            columns: ["banned_by"]
            isOneToOne: false
            referencedRelation: "user_data"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "live_host_ban_live_debate_fkey"
            columns: ["live_debate"]
            isOneToOne: false
            referencedRelation: "live_debate"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "live_host_ban_live_host_id_fkey"
            columns: ["live_host_id"]
            isOneToOne: false
            referencedRelation: "user_data"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "live_host_ban_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "user_data"
            referencedColumns: ["id"]
          },
        ]
      }
      live_host_follower: {
        Row: {
          count: number | null
          created_at: string
          id: string
        }
        Insert: {
          count?: number | null
          created_at?: string
          id?: string
        }
        Update: {
          count?: number | null
          created_at?: string
          id?: string
        }
        Relationships: [
          {
            foreignKeyName: "live_host_follower_id_fkey"
            columns: ["id"]
            isOneToOne: true
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      live_host_support: {
        Row: {
          count: number | null
          created_at: string
          id: string
        }
        Insert: {
          count?: number | null
          created_at?: string
          id?: string
        }
        Update: {
          count?: number | null
          created_at?: string
          id?: string
        }
        Relationships: [
          {
            foreignKeyName: "live_host_support_id_fkey"
            columns: ["id"]
            isOneToOne: true
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      social_links: {
        Row: {
          created_at: string
          id: string
          link: string | null
          media: string | null
          user_id: string | null
        }
        Insert: {
          created_at?: string
          id?: string
          link?: string | null
          media?: string | null
          user_id?: string | null
        }
        Update: {
          created_at?: string
          id?: string
          link?: string | null
          media?: string | null
          user_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "social_links_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      user_data: {
        Row: {
          created_at: string
          displayName: string | null
          email: string | null
          firstName: string | null
          fullName: string | null
          id: string
          initials: string | null
          lastName: string | null
          oneLineDesc: string | null
          username: string
        }
        Insert: {
          created_at?: string
          displayName?: string | null
          email?: string | null
          firstName?: string | null
          fullName?: string | null
          id?: string
          initials?: string | null
          lastName?: string | null
          oneLineDesc?: string | null
          username: string
        }
        Update: {
          created_at?: string
          displayName?: string | null
          email?: string | null
          firstName?: string | null
          fullName?: string | null
          id?: string
          initials?: string | null
          lastName?: string | null
          oneLineDesc?: string | null
          username?: string
        }
        Relationships: [
          {
            foreignKeyName: "user_data_id_fkey"
            columns: ["id"]
            isOneToOne: true
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      user_email: {
        Row: {
          created_at: string
          email: string | null
          id: string
          user_id: string | null
          verified: boolean | null
        }
        Insert: {
          created_at?: string
          email?: string | null
          id?: string
          user_id?: string | null
          verified?: boolean | null
        }
        Update: {
          created_at?: string
          email?: string | null
          id?: string
          user_id?: string | null
          verified?: boolean | null
        }
        Relationships: [
          {
            foreignKeyName: "user_email_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      user_phone: {
        Row: {
          country: string | null
          created_at: string
          id: string
          phone: string | null
          user_id: string | null
          verified: boolean | null
        }
        Insert: {
          country?: string | null
          created_at?: string
          id?: string
          phone?: string | null
          user_id?: string | null
          verified?: boolean | null
        }
        Update: {
          country?: string | null
          created_at?: string
          id?: string
          phone?: string | null
          user_id?: string | null
          verified?: boolean | null
        }
        Relationships: []
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      [_ in never]: never
    }
    Enums: {
      notification_service:
        | "live_chat"
        | "backstage_chat"
        | "screen_share_new"
        | "backstage_new_participant"
        | "poll_result"
        | "question_answer"
        | "activity_feed"
      participant_location: "stage" | "backstage"
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type PublicSchema = Database[Extract<keyof Database, "public">]

export type Tables<
  PublicTableNameOrOptions extends
    | keyof (PublicSchema["Tables"] & PublicSchema["Views"])
    | { schema: keyof Database },
  TableName extends PublicTableNameOrOptions extends { schema: keyof Database }
    ? keyof (Database[PublicTableNameOrOptions["schema"]]["Tables"] &
        Database[PublicTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = PublicTableNameOrOptions extends { schema: keyof Database }
  ? (Database[PublicTableNameOrOptions["schema"]]["Tables"] &
      Database[PublicTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : PublicTableNameOrOptions extends keyof (PublicSchema["Tables"] &
        PublicSchema["Views"])
    ? (PublicSchema["Tables"] &
        PublicSchema["Views"])[PublicTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  PublicTableNameOrOptions extends
    | keyof PublicSchema["Tables"]
    | { schema: keyof Database },
  TableName extends PublicTableNameOrOptions extends { schema: keyof Database }
    ? keyof Database[PublicTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = PublicTableNameOrOptions extends { schema: keyof Database }
  ? Database[PublicTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : PublicTableNameOrOptions extends keyof PublicSchema["Tables"]
    ? PublicSchema["Tables"][PublicTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  PublicTableNameOrOptions extends
    | keyof PublicSchema["Tables"]
    | { schema: keyof Database },
  TableName extends PublicTableNameOrOptions extends { schema: keyof Database }
    ? keyof Database[PublicTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = PublicTableNameOrOptions extends { schema: keyof Database }
  ? Database[PublicTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : PublicTableNameOrOptions extends keyof PublicSchema["Tables"]
    ? PublicSchema["Tables"][PublicTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  PublicEnumNameOrOptions extends
    | keyof PublicSchema["Enums"]
    | { schema: keyof Database },
  EnumName extends PublicEnumNameOrOptions extends { schema: keyof Database }
    ? keyof Database[PublicEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = PublicEnumNameOrOptions extends { schema: keyof Database }
  ? Database[PublicEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : PublicEnumNameOrOptions extends keyof PublicSchema["Enums"]
    ? PublicSchema["Enums"][PublicEnumNameOrOptions]
    : never

