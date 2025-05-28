-- Row Level Security Policies
-- This migration creates comprehensive RLS policies for all tables

-- =============================================
-- USERS TABLE POLICIES
-- =============================================

-- Users can view and update their own data
CREATE POLICY "Users can view their own data" ON users 
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update their own data" ON users 
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert their own data" ON users 
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Service role can manage all users (for auth callbacks and admin operations)
CREATE POLICY "Service role can manage users" ON users 
  FOR ALL USING (auth.jwt() ->> 'role' = 'service_role');

-- =============================================
-- AGENTS TABLE POLICIES
-- =============================================

-- Public agents are viewable by everyone
CREATE POLICY "Public agents are viewable by everyone" ON agents 
  FOR SELECT USING (is_public = true);

-- Users can view their own agents
CREATE POLICY "Users can view their own agents" ON agents 
  FOR SELECT USING (auth.uid() = creator_id);

-- Users can create agents
CREATE POLICY "Users can create agents" ON agents 
  FOR INSERT WITH CHECK (auth.uid() = creator_id);

-- Users can update their own agents
CREATE POLICY "Users can update their own agents" ON agents 
  FOR UPDATE USING (auth.uid() = creator_id);

-- Users can delete their own agents
CREATE POLICY "Users can delete their own agents" ON agents 
  FOR DELETE USING (auth.uid() = creator_id);

-- Service role can manage all agents
CREATE POLICY "Service role can manage agents" ON agents 
  FOR ALL USING (auth.jwt() ->> 'role' = 'service_role');

-- =============================================
-- CHATS TABLE POLICIES
-- =============================================

-- Users can view their own chats
CREATE POLICY "Users can view their own chats" ON chats 
  FOR SELECT USING (auth.uid() = user_id);

-- Public chats are viewable by everyone
CREATE POLICY "Public chats are viewable by everyone" ON chats 
  FOR SELECT USING (public = true);

-- Users can create their own chats
CREATE POLICY "Users can create their own chats" ON chats 
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Users can update their own chats
CREATE POLICY "Users can update their own chats" ON chats 
  FOR UPDATE USING (auth.uid() = user_id);

-- Users can delete their own chats
CREATE POLICY "Users can delete their own chats" ON chats 
  FOR DELETE USING (auth.uid() = user_id);

-- Service role can manage all chats (for anonymous users)
CREATE POLICY "Service role can manage chats" ON chats 
  FOR ALL USING (auth.jwt() ->> 'role' = 'service_role');

-- =============================================
-- MESSAGES TABLE POLICIES
-- =============================================

-- Users can view messages from their own chats
CREATE POLICY "Users can view messages from their own chats" ON messages 
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM chats 
      WHERE chats.id = messages.chat_id 
      AND chats.user_id = auth.uid()
    )
  );

-- Users can view messages from public chats
CREATE POLICY "Users can view messages from public chats" ON messages 
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM chats 
      WHERE chats.id = messages.chat_id 
      AND chats.public = true
    )
  );

-- Users can insert messages to their own chats
CREATE POLICY "Users can insert messages to their own chats" ON messages 
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM chats 
      WHERE chats.id = messages.chat_id 
      AND chats.user_id = auth.uid()
    )
  );

-- Users can update messages in their own chats
CREATE POLICY "Users can update messages in their own chats" ON messages 
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM chats 
      WHERE chats.id = messages.chat_id 
      AND chats.user_id = auth.uid()
    )
  );

-- Users can delete messages from their own chats
CREATE POLICY "Users can delete messages from their own chats" ON messages 
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM chats 
      WHERE chats.id = messages.chat_id 
      AND chats.user_id = auth.uid()
    )
  );

-- Service role can manage all messages (for anonymous users)
CREATE POLICY "Service role can manage messages" ON messages 
  FOR ALL USING (auth.jwt() ->> 'role' = 'service_role');

-- =============================================
-- CHAT ATTACHMENTS TABLE POLICIES
-- =============================================

-- Users can view attachments from their own chats (works for both auth and anon users)
CREATE POLICY "Users can view attachments from their own chats" ON chat_attachments 
  FOR SELECT USING (
    -- Allow if user owns the chat (for authenticated users)
    (auth.uid() IS NOT NULL AND EXISTS (
      SELECT 1 FROM chats 
      WHERE chats.id = chat_attachments.chat_id 
      AND chats.user_id = auth.uid()
    ))
    OR
    -- Allow if user_id matches (for anonymous users with service role)
    (auth.jwt() ->> 'role' = 'service_role' AND user_id IS NOT NULL)
  );

-- Users can view attachments from public chats
CREATE POLICY "Users can view attachments from public chats" ON chat_attachments 
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM chats 
      WHERE chats.id = chat_attachments.chat_id 
      AND chats.public = true
    )
  );

-- Users can upload attachments (works for both auth and anon users)
CREATE POLICY "Users can upload attachments to their own chats" ON chat_attachments 
  FOR INSERT WITH CHECK (
    -- Allow if authenticated user owns the chat
    (auth.uid() IS NOT NULL AND 
     auth.uid() = user_id AND
     EXISTS (
       SELECT 1 FROM chats 
       WHERE chats.id = chat_attachments.chat_id 
       AND chats.user_id = auth.uid()
     ))
    OR
    -- Allow service role to insert for any user (for anonymous users)
    (auth.jwt() ->> 'role' = 'service_role' AND user_id IS NOT NULL)
  );

-- Users can delete their own attachments
CREATE POLICY "Users can delete their own attachments" ON chat_attachments 
  FOR DELETE USING (
    (auth.uid() IS NOT NULL AND auth.uid() = user_id)
    OR
    (auth.jwt() ->> 'role' = 'service_role')
  );

-- =============================================
-- FEEDBACK TABLE POLICIES
-- =============================================

-- Users can view their own feedback
CREATE POLICY "Users can view their own feedback" ON feedback 
  FOR SELECT USING (auth.uid() = user_id);

-- Users can create their own feedback
CREATE POLICY "Users can create their own feedback" ON feedback 
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Users can update their own feedback
CREATE POLICY "Users can update their own feedback" ON feedback 
  FOR UPDATE USING (auth.uid() = user_id);

-- Users can delete their own feedback
CREATE POLICY "Users can delete their own feedback" ON feedback 
  FOR DELETE USING (auth.uid() = user_id);

-- Service role can manage all feedback
CREATE POLICY "Service role can manage feedback" ON feedback 
  FOR ALL USING (auth.jwt() ->> 'role' = 'service_role'); 