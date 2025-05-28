-- Storage Bucket Policies
-- These policies should be applied in the Supabase Storage dashboard
-- or via the Supabase CLI

-- =============================================
-- AVATARS BUCKET POLICIES
-- =============================================

-- Public read access for avatars
CREATE POLICY "Public read access for avatars" ON storage.objects 
  FOR SELECT USING (bucket_id = 'avatars');

-- Users can upload their own avatars
CREATE POLICY "Users can upload their own avatars" ON storage.objects 
  FOR INSERT WITH CHECK (
    bucket_id = 'avatars' AND 
    auth.uid()::text = (storage.foldername(name))[1]
  );

-- Users can update their own avatars
CREATE POLICY "Users can update their own avatars" ON storage.objects 
  FOR UPDATE USING (
    bucket_id = 'avatars' AND 
    auth.uid()::text = (storage.foldername(name))[1]
  );

-- Users can delete their own avatars
CREATE POLICY "Users can delete their own avatars" ON storage.objects 
  FOR DELETE USING (
    bucket_id = 'avatars' AND 
    auth.uid()::text = (storage.foldername(name))[1]
  );

-- Service role can manage all avatars
CREATE POLICY "Service role can manage avatars" ON storage.objects 
  FOR ALL USING (
    bucket_id = 'avatars' AND 
    auth.jwt() ->> 'role' = 'service_role'
  );

-- =============================================
-- CHAT-ATTACHMENTS BUCKET POLICIES
-- =============================================

-- Users can view attachments from their chats
CREATE POLICY "Users can view attachments from their chats" ON storage.objects 
  FOR SELECT USING (
    bucket_id = 'chat-attachments' AND
    (
      -- Allow authenticated users to view their own attachments
      (auth.uid() IS NOT NULL AND EXISTS (
        SELECT 1 FROM chat_attachments ca
        JOIN chats c ON ca.chat_id = c.id
        WHERE ca.file_url LIKE '%' || name || '%'
        AND c.user_id = auth.uid()
      ))
      OR
      -- Allow viewing attachments from public chats
      EXISTS (
        SELECT 1 FROM chat_attachments ca
        JOIN chats c ON ca.chat_id = c.id
        WHERE ca.file_url LIKE '%' || name || '%'
        AND c.public = true
      )
      OR
      -- Allow service role to view all attachments
      (auth.jwt() ->> 'role' = 'service_role')
    )
  );

-- Users can upload to chat-attachments
CREATE POLICY "Users can upload to chat-attachments" ON storage.objects 
  FOR INSERT WITH CHECK (
    bucket_id = 'chat-attachments' AND 
    (
      -- Allow authenticated users to upload
      auth.uid() IS NOT NULL
      OR
      -- Allow service role to upload (for anonymous users)
      auth.jwt() ->> 'role' = 'service_role'
    )
  );

-- Users can delete their own attachments
CREATE POLICY "Users can delete their own attachments" ON storage.objects 
  FOR DELETE USING (
    bucket_id = 'chat-attachments' AND
    (
      -- Allow authenticated users to delete their own attachments
      (auth.uid() IS NOT NULL AND EXISTS (
        SELECT 1 FROM chat_attachments ca
        WHERE ca.file_url LIKE '%' || name || '%'
        AND ca.user_id = auth.uid()
      ))
      OR
      -- Allow service role to delete any attachment
      (auth.jwt() ->> 'role' = 'service_role')
    )
  ); 