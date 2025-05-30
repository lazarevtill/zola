"use client"

import { Button } from "@/components/ui/button"
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Switch } from "@/components/ui/switch"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { useSettingsStore } from "@/lib/settings-store/store"
import { OpenAICompatibleProvider } from "@/lib/settings-store/types"
import { Gear, Plus, Trash, Eye, EyeSlash } from "@phosphor-icons/react"
import { useState } from "react"

interface SettingsDialogProps {
  children?: React.ReactNode
}

export function SettingsDialog({ children }: SettingsDialogProps) {
  const { providers, customProviders, updateProvider, addCustomProvider, removeCustomProvider } = useSettingsStore()
  const [isOpen, setIsOpen] = useState(false)
  const [isAdding, setIsAdding] = useState(false)
  const [showApiKey, setShowApiKey] = useState(false)
  const [newProvider, setNewProvider] = useState({
    name: '',
    baseUrl: '',
    apiKey: '',
  })

  const handleAddCustomProvider = async () => {
    if (!newProvider.name.trim() || !newProvider.baseUrl.trim()) return

    setIsAdding(true)
    try {
      const provider: OpenAICompatibleProvider = {
        id: `custom-${Date.now()}`,
        name: newProvider.name.trim(),
        baseUrl: newProvider.baseUrl.trim(),
        apiKey: newProvider.apiKey.trim(),
        enabled: true,
        type: 'openai-compatible',
      }

      addCustomProvider(provider)
      setNewProvider({ name: '', baseUrl: '', apiKey: '' })
      setShowApiKey(false)
    } finally {
      setIsAdding(false)
    }
  }

  const isFormValid = newProvider.name.trim() && newProvider.baseUrl.trim()

  const trigger = children || (
    <Button variant="ghost" size="sm">
      <Gear className="size-4" />
      Settings
    </Button>
  )

  return (
    <Dialog open={isOpen} onOpenChange={setIsOpen}>
      <DialogTrigger asChild>{trigger}</DialogTrigger>
      <DialogContent className="max-w-2xl max-h-[80vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle>Settings</DialogTitle>
          <DialogDescription>
            Configure model providers and API settings
          </DialogDescription>
        </DialogHeader>

        <Tabs defaultValue="providers" className="w-full">
          <TabsList className="grid w-full grid-cols-2">
            <TabsTrigger value="providers">Providers</TabsTrigger>
            <TabsTrigger value="custom">Custom Providers</TabsTrigger>
          </TabsList>

          <TabsContent value="providers" className="space-y-4">
            <div className="space-y-4">
              <h3 className="text-lg font-medium">Model Providers</h3>
              {providers.map((provider) => (
                <div key={provider.id} className="flex items-center justify-between p-4 border rounded-lg">
                  <div className="space-y-1">
                    <div className="font-medium">{provider.name}</div>
                    <div className="text-sm text-muted-foreground">
                      {provider.type === 'ollama' ? 'Local AI models' : `${provider.name} API`}
                    </div>
                  </div>
                  <div className="flex items-center space-x-4">
                    {provider.type === 'ollama' && (
                      <div className="space-y-2">
                        <Label htmlFor={`${provider.id}-url`} className="text-sm">Base URL</Label>
                        <Input
                          id={`${provider.id}-url`}
                          value={provider.baseUrl || ''}
                          onChange={(e) => updateProvider(provider.id, { baseUrl: e.target.value })}
                          placeholder="http://localhost:11434"
                          className="w-48"
                        />
                      </div>
                    )}
                    {provider.type !== 'ollama' && (
                      <div className="space-y-2">
                        <Label htmlFor={`${provider.id}-key`} className="text-sm">API Key</Label>
                        <Input
                          id={`${provider.id}-key`}
                          type="password"
                          value={provider.apiKey || ''}
                          onChange={(e) => updateProvider(provider.id, { apiKey: e.target.value })}
                          placeholder="Enter API key..."
                          className="w-48"
                        />
                      </div>
                    )}
                    <Switch
                      checked={provider.enabled}
                      onCheckedChange={(enabled) => updateProvider(provider.id, { enabled })}
                    />
                  </div>
                </div>
              ))}
            </div>
          </TabsContent>

          <TabsContent value="custom" className="space-y-4">
            <div className="space-y-4">
              <h3 className="text-lg font-medium">Custom OpenAI-Compatible Providers</h3>
              
              {/* Add new provider form */}
              <div className="p-4 border rounded-lg space-y-4">
                <h4 className="font-medium">Add New Provider</h4>
                <div className="grid grid-cols-2 gap-4">
                  <div className="space-y-2">
                    <Label htmlFor="provider-name">Provider Name *</Label>
                    <Input
                      id="provider-name"
                      value={newProvider.name}
                      onChange={(e) => setNewProvider({ ...newProvider, name: e.target.value })}
                      placeholder="My Custom Provider"
                      disabled={isAdding}
                    />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="provider-url">Base URL *</Label>
                    <Input
                      id="provider-url"
                      value={newProvider.baseUrl}
                      onChange={(e) => setNewProvider({ ...newProvider, baseUrl: e.target.value })}
                      placeholder="https://api.example.com/v1"
                      disabled={isAdding}
                    />
                  </div>
                </div>
                <div className="space-y-2">
                  <Label htmlFor="provider-key">API Key (Optional)</Label>
                  <div className="relative">
                    <Input
                      id="provider-key"
                      type={showApiKey ? "text" : "password"}
                      value={newProvider.apiKey}
                      onChange={(e) => setNewProvider({ ...newProvider, apiKey: e.target.value })}
                      placeholder="sk-..."
                      disabled={isAdding}
                      className="pr-10"
                    />
                    <Button
                      type="button"
                      variant="ghost"
                      size="sm"
                      className="absolute right-0 top-0 h-full px-3 py-2 hover:bg-transparent"
                      onClick={() => setShowApiKey(!showApiKey)}
                      disabled={isAdding}
                    >
                      {showApiKey ? (
                        <EyeSlash className="size-4" />
                      ) : (
                        <Eye className="size-4" />
                      )}
                    </Button>
                  </div>
                </div>
                <Button 
                  onClick={handleAddCustomProvider} 
                  disabled={!isFormValid || isAdding}
                >
                  <Plus className="size-4 mr-2" />
                  {isAdding ? "Adding..." : "Add Provider"}
                </Button>
              </div>

              {/* Existing custom providers */}
              {customProviders.length > 0 && (
                <div className="space-y-2">
                  <h4 className="font-medium">Your Custom Providers</h4>
                  {customProviders.map((provider) => (
                    <div key={provider.id} className="flex items-center justify-between p-4 border rounded-lg">
                      <div className="space-y-1">
                        <div className="font-medium">{provider.name}</div>
                        <div className="text-sm text-muted-foreground">{provider.baseUrl}</div>
                        {provider.apiKey && (
                          <div className="text-xs text-muted-foreground">
                            API Key: ••••••••
                          </div>
                        )}
                      </div>
                      <div className="flex items-center space-x-2">
                        <Switch
                          checked={provider.enabled}
                          onCheckedChange={(enabled) => updateProvider(provider.id, { enabled })}
                        />
                        <Button
                          variant="ghost"
                          size="sm"
                          onClick={() => removeCustomProvider(provider.id)}
                          className="text-destructive hover:text-destructive"
                        >
                          <Trash className="size-4" />
                        </Button>
                      </div>
                    </div>
                  ))}
                </div>
              )}

              {customProviders.length === 0 && (
                <div className="text-center py-8 text-muted-foreground">
                  No custom providers configured yet.
                </div>
              )}
            </div>
          </TabsContent>
        </Tabs>
      </DialogContent>
    </Dialog>
  )
} 