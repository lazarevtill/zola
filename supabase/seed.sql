-- Seed data for Zola application
-- This file contains sample data for development and testing

-- Insert sample public agents
INSERT INTO agents (
  id,
  name,
  slug,
  description,
  avatar_url,
  system_prompt,
  model_preference,
  is_public,
  remixable,
  tools_enabled,
  example_inputs,
  tags,
  category,
  creator_id
) VALUES 
(
  '550e8400-e29b-41d4-a716-446655440001',
  'Code Assistant',
  'code-assistant',
  'A helpful AI assistant specialized in programming and software development. Can help with code review, debugging, and explaining complex programming concepts.',
  '/avatars/agents/code-assistant.png',
  'You are a helpful AI assistant specialized in programming and software development. You excel at code review, debugging, explaining programming concepts, and helping with various programming languages and frameworks. Always provide clear, well-commented code examples and explain your reasoning.',
  'gpt-4',
  true,
  true,
  true,
  ARRAY['Help me debug this Python function', 'Explain how React hooks work', 'Review my JavaScript code'],
  ARRAY['programming', 'development', 'coding', 'debugging'],
  'Development',
  NULL
),
(
  '550e8400-e29b-41d4-a716-446655440002',
  'Writing Assistant',
  'writing-assistant',
  'An AI assistant focused on helping with writing tasks, from creative writing to technical documentation and content creation.',
  '/avatars/agents/writing-assistant.png',
  'You are a skilled writing assistant who helps with various writing tasks including creative writing, technical documentation, content creation, editing, and proofreading. You provide constructive feedback, suggest improvements, and help maintain consistent tone and style.',
  'gpt-4',
  true,
  true,
  false,
  ARRAY['Help me write a blog post about AI', 'Proofread this email', 'Create a technical documentation outline'],
  ARRAY['writing', 'content', 'editing', 'documentation'],
  'Writing',
  NULL
),
(
  '550e8400-e29b-41d4-a716-446655440003',
  'Data Analyst',
  'data-analyst',
  'Specialized in data analysis, statistics, and helping interpret data insights. Great for working with datasets and creating visualizations.',
  '/avatars/agents/data-analyst.png',
  'You are a data analyst AI assistant with expertise in statistics, data analysis, and data visualization. You help users understand their data, perform statistical analysis, create meaningful visualizations, and derive actionable insights from datasets.',
  'gpt-4',
  true,
  true,
  true,
  ARRAY['Analyze this CSV dataset', 'Create a visualization for sales data', 'Explain statistical significance'],
  ARRAY['data', 'analytics', 'statistics', 'visualization'],
  'Analytics',
  NULL
),
(
  '550e8400-e29b-41d4-a716-446655440004',
  'Research Assistant',
  'research-assistant',
  'Helps with research tasks, fact-checking, summarizing information, and finding reliable sources on various topics.',
  '/avatars/agents/research-assistant.png',
  'You are a research assistant AI that helps users with research tasks, fact-checking, information synthesis, and finding reliable sources. You excel at summarizing complex topics, identifying key insights, and presenting information in a clear, organized manner.',
  'gpt-4',
  true,
  true,
  true,
  ARRAY['Research the latest developments in renewable energy', 'Summarize this research paper', 'Find reliable sources about climate change'],
  ARRAY['research', 'fact-checking', 'analysis', 'sources'],
  'Research',
  NULL
),
(
  '550e8400-e29b-41d4-a716-446655440005',
  'Creative Assistant',
  'creative-assistant',
  'Focused on creative tasks like brainstorming, storytelling, creative writing, and generating innovative ideas.',
  '/avatars/agents/creative-assistant.png',
  'You are a creative AI assistant that excels at brainstorming, storytelling, creative writing, and generating innovative ideas. You help users think outside the box, develop creative concepts, and bring imaginative ideas to life.',
  'gpt-4',
  true,
  true,
  false,
  ARRAY['Help me brainstorm ideas for a short story', 'Create a creative marketing campaign', 'Generate innovative product concepts'],
  ARRAY['creativity', 'brainstorming', 'storytelling', 'innovation'],
  'Creative',
  NULL
);

-- Note: In a real deployment, you would not insert actual user data
-- This is just for development/testing purposes
-- Users will be created automatically when they sign up 