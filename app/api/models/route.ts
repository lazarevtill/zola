import { NextRequest, NextResponse } from "next/server"
import { getAllModels, refreshModelsCache } from "@/lib/models"

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const refresh = searchParams.get("refresh") === "true"
    
    if (refresh) {
      refreshModelsCache()
    }
    
    const models = await getAllModels()
    
    return NextResponse.json({
      models,
      timestamp: new Date().toISOString(),
      count: models.length,
    })
  } catch (error) {
    console.error("Failed to fetch models:", error)
    return NextResponse.json(
      { error: "Failed to fetch models" },
      { status: 500 }
    )
  }
}

export async function POST(request: NextRequest) {
  try {
    // Refresh the models cache
    refreshModelsCache()
    const models = await getAllModels()
    
    return NextResponse.json({
      message: "Models cache refreshed",
      models,
      timestamp: new Date().toISOString(),
      count: models.length,
    })
  } catch (error) {
    console.error("Failed to refresh models:", error)
    return NextResponse.json(
      { error: "Failed to refresh models" },
      { status: 500 }
    )
  }
} 