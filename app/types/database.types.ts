import { Attachment } from "@ai-sdk/ui-utils"

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
      agents: {
        Row: {
          avatar_url: string | null
          category: string | null
          created_at: string | null
          creator_id: string | null
          description: string
          example_inputs: string[] | null
          id: string
          is_public: boolean
          model_preference: string | null
          name: string
          remixable: boolean
          slug: string
          system_prompt: string
          tags: string[] | null
          tools_enabled: boolean
          updated_at: string | null
        }
        Insert: {
          avatar_url?: string | null
          category?: string | null
          created_at?: string | null
          creator_id?: string | null
          description: string
          example_inputs?: string[] | null
          id?: string
          is_public?: boolean
          model_preference?: string | null
          name: string
          remixable?: boolean
          slug: string
          system_prompt: string
          tags?: string[] | null
          tools_enabled?: boolean
          updated_at?: string | null
        }
        Update: {
          avatar_url?: string | null
          category?: string | null
          created_at?: string | null
          creator_id?: string | null
          description?: string
          example_inputs?: string[] | null
          id?: string
          is_public?: boolean
          model_preference?: string | null
          name?: string
          remixable?: boolean
          slug?: string
          system_prompt?: string
          tags?: string[] | null
          tools_enabled?: boolean
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "agents_creator_id_fkey"
            columns: ["creator_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      chat_attachments: {
        Row: {
          chat_id: string
          created_at: string
          file_name: string | null
          file_size: number | null
          file_type: string | null
          file_url: string
          id: string
          user_id: string
        }
        Insert: {
          chat_id: string
          created_at?: string
          file_name?: string | null
          file_size?: number | null
          file_type?: string | null
          file_url: string
          id?: string
          user_id: string
        }
        Update: {
          chat_id?: string
          created_at?: string
          file_name?: string | null
          file_size?: number | null
          file_type?: string | null
          file_url?: string
          id?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "fk_chat"
            columns: ["chat_id"]
            isOneToOne: false
            referencedRelation: "chats"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fk_user"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      chats: {
        Row: {
          agent_id: string | null
          created_at: string | null
          id: string
          model: string | null
          title: string | null
          user_id: string
          system_prompt: string | null
        }
        Insert: {
          agent_id?: string | null
          created_at?: string | null
          id?: string
          model?: string | null
          title?: string | null
          user_id: string
          system_prompt?: string | null
        }
        Update: {
          agent_id?: string | null
          created_at?: string | null
          id?: string
          model?: string | null
          title?: string | null
          user_id?: string
          system_prompt?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "chats_agent_id_fkey"
            columns: ["agent_id"]
            isOneToOne: false
            referencedRelation: "agents"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "chats_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      messages: {
        Row: {
          experimental_attachments: Attachment[]
          chat_id: string
          content: string
          created_at: string | null
          id: number
          role: "system" | "user" | "assistant" | "data"
        }
        Insert: {
          experimental_attachments?: Attachment[]
          chat_id: string
          content: string
          created_at?: string | null
          id?: number
          role: "system" | "user" | "assistant" | "data"
        }
        Update: {
          experimental_attachments?: Attachment[]
          chat_id?: string
          content?: string
          created_at?: string | null
          id?: number
          role?: "system" | "user" | "assistant" | "data"
        }
        Relationships: []
      }
      users: {
        Row: {
          anonymous: boolean | null
          created_at: string | null
          daily_message_count: number | null
          daily_reset: string | null
          display_name: string | null
          email: string
          id: string
          message_count: number | null
          preferred_model: string | null
          premium: boolean | null
          profile_image: string | null
          last_active_at: string | null
        }
        Insert: {
          anonymous?: boolean | null
          created_at?: string | null
          daily_message_count?: number | null
          daily_reset?: string | null
          display_name?: string | null
          email: string
          id: string
          message_count?: number | null
          preferred_model?: string | null
          premium?: boolean | null
          profile_image?: string | null
          last_active_at?: string | null
        }
        Update: {
          anonymous?: boolean | null
          created_at?: string | null
          daily_message_count?: number | null
          daily_reset?: string | null
          display_name?: string | null
          email?: string
          id?: string
          message_count?: number | null
          preferred_model?: string | null
          premium?: boolean | null
          profile_image?: string | null
          last_active_at?: string | null
        }
        Relationships: []
      }
      feedback: {
        Row: {
          created_at: string | null
          id: string
          message: string
          user_id: string
        }
        Insert: {
          created_at?: string | null
          id?: string
          message: string
          user_id: string
        }
        Update: {
          created_at?: string | null
          id?: string
          message?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "feedback_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      [_ in never]: never
    }
    Enums: {
      orderstatus:
        | "UNPAID"
        | "PAID"
        | "SHIPPED"
        | "OUT"
        | "CANCELLED"
        | "PENDING"
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

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof PublicSchema["CompositeTypes"]
    | { schema: keyof Database },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof Database
  }
    ? keyof Database[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends { schema: keyof Database }
  ? Database[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof PublicSchema["CompositeTypes"]
    ? PublicSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never
