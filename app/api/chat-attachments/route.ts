import { validateUserIdentity } from "@/lib/server/api"
import { NextRequest, NextResponse } from "next/server"

export async function POST(request: NextRequest) {
  try {
    const body = await request.json()
    const { chat_id, user_id, file_url, file_name, file_type, file_size, isAuthenticated } = body

    if (!chat_id || !user_id || !file_url) {
      return NextResponse.json(
        { error: "Missing required fields: chat_id, user_id, file_url" },
        { status: 400 }
      )
    }

    // Validate user identity and get appropriate Supabase client
    const supabase = await validateUserIdentity(user_id, isAuthenticated || false)
    
    if (!supabase) {
      return NextResponse.json(
        { error: "Failed to initialize database connection" },
        { status: 500 }
      )
    }

    // Insert the chat attachment record
    const { data, error } = await supabase
      .from("chat_attachments")
      .insert({
        chat_id,
        user_id,
        file_url,
        file_name,
        file_type,
        file_size,
      })
      .select()
      .single()

    if (error) {
      console.error("Error inserting chat attachment:", error)
      return NextResponse.json(
        { error: `Failed to save attachment: ${error.message}` },
        { status: 500 }
      )
    }

    return NextResponse.json({ data }, { status: 201 })
  } catch (error) {
    console.error("Error in chat-attachments API:", error)
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 }
    )
  }
} 