import { create } from 'zustand'
import { persist } from 'zustand/middleware'
import { SettingsState, SettingsActions, ProviderSettings, OpenAICompatibleProvider } from './types'

const defaultProviders: ProviderSettings[] = [
  {
    id: 'openai',
    name: 'OpenAI',
    enabled: true,
    type: 'openai',
  },
  {
    id: 'anthropic',
    name: 'Anthropic',
    enabled: true,
    type: 'anthropic',
  },
  {
    id: 'google',
    name: 'Google',
    enabled: true,
    type: 'google',
  },
  {
    id: 'mistral',
    name: 'Mistral AI',
    enabled: true,
    type: 'mistral',
  },
  {
    id: 'xai',
    name: 'xAI',
    enabled: true,
    type: 'xai',
  },
  {
    id: 'deepseek',
    name: 'DeepSeek',
    enabled: true,
    type: 'deepseek',
  },
  {
    id: 'ollama',
    name: 'Ollama',
    enabled: true,
    type: 'ollama',
    baseUrl: typeof window !== 'undefined' ? 'http://localhost:11434' : process.env.OLLAMA_BASE_URL || 'http://localhost:11434',
  },
]

type SettingsStore = SettingsState & SettingsActions

export const useSettingsStore = create<SettingsStore>()(
  persist(
    (set) => ({
      providers: defaultProviders,
      customProviders: [],

      updateProvider: (id: string, settings: Partial<ProviderSettings>) => {
        set((state: SettingsStore) => {
          // Check if it's a regular provider
          const providerIndex = state.providers.findIndex(p => p.id === id)
          if (providerIndex !== -1) {
            return {
              ...state,
              providers: state.providers.map((provider: ProviderSettings) =>
                provider.id === id ? { ...provider, ...settings } : provider
              ),
            }
          }
          
          // Check if it's a custom provider
          const customProviderIndex = state.customProviders.findIndex(p => p.id === id)
          if (customProviderIndex !== -1) {
            return {
              ...state,
              customProviders: state.customProviders.map((provider: OpenAICompatibleProvider) =>
                provider.id === id ? { ...provider, ...settings } as OpenAICompatibleProvider : provider
              ),
            }
          }
          
          // If provider not found, return current state
          return state
        })
      },

      addCustomProvider: (provider: OpenAICompatibleProvider) => {
        set((state: SettingsStore) => ({
          customProviders: [...state.customProviders, provider],
        }))
      },

      removeCustomProvider: (id: string) => {
        set((state: SettingsStore) => ({
          customProviders: state.customProviders.filter((provider: OpenAICompatibleProvider) => provider.id !== id),
        }))
      },

      resetSettings: () => {
        set({
          providers: defaultProviders,
          customProviders: [],
        })
      },
    }),
    {
      name: 'zola-settings',
      version: 1,
    }
  )
) 