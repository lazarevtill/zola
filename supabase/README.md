# Supabase Database Setup

This directory contains all the database migrations, policies, and configurations for the Zola chat application.

## 📁 Directory Structure

```
supabase/
├── migrations/           # Database schema migrations
├── storage/             # Storage bucket policies
├── config.toml          # Local development configuration
├── seed.sql            # Sample data for development
└── README.md           # This file
```

## 🚀 Quick Setup

### Option 1: Using Supabase Dashboard (Recommended for Production)

1. **Create a new Supabase project** at [supabase.com](https://supabase.com)

2. **Run the migrations** in order in your Supabase SQL Editor:
   ```sql
   -- Copy and paste each file in order:
   -- 1. migrations/20240101000000_initial_schema.sql
   -- 2. migrations/20240101000001_enable_rls.sql
   -- 3. migrations/20240101000002_rls_policies.sql
   ```

3. **Set up storage buckets**:
   - Go to Storage in your Supabase dashboard
   - Create two buckets: `avatars` and `chat-attachments`
   - Apply the policies from `storage/policies.sql`

4. **Configure authentication**:
   - Go to Authentication > Settings
   - Enable "Allow anonymous sign-ins"
   - Configure Google OAuth (optional)

5. **Seed sample data** (optional for development):
   ```sql
   -- Copy and paste seed.sql content
   ```

### Option 2: Using Supabase CLI (For Local Development)

1. **Install Supabase CLI**:
   ```bash
   npm install -g supabase
   ```

2. **Initialize and start local Supabase**:
   ```bash
   # From the project root
   supabase init
   supabase start
   ```

3. **Apply migrations**:
   ```bash
   supabase db reset
   ```

4. **Access local dashboard**:
   - Dashboard: http://localhost:54323
   - API URL: http://localhost:54321
   - DB URL: postgresql://postgres:postgres@localhost:54322/postgres

## 📋 Migration Files

### `20240101000000_initial_schema.sql`
- Creates all database tables (users, agents, chats, messages, chat_attachments, feedback)
- Sets up foreign key relationships
- Creates indexes for performance
- Adds triggers for automatic timestamp updates

### `20240101000001_enable_rls.sql`
- Enables Row Level Security on all tables
- Essential for data isolation and security

### `20240101000002_rls_policies.sql`
- Comprehensive RLS policies for all tables
- Handles both authenticated and anonymous users
- Ensures proper data access control

## 🔒 Security Features

### Row Level Security (RLS)
- **Users**: Can only access their own data
- **Agents**: Public agents visible to all, private agents only to creators
- **Chats**: Users can only access their own chats, public chats visible to all
- **Messages**: Access controlled through chat ownership
- **Attachments**: Linked to chat permissions
- **Feedback**: Users can only access their own feedback

### Anonymous User Support
- Anonymous users can create chats and upload files
- Uses service role for database operations
- Proper isolation between anonymous sessions

### Storage Security
- **Avatars bucket**: Public read, user-specific write
- **Chat-attachments bucket**: Access controlled by chat ownership
- File upload size limits and type validation

## 🔧 Environment Variables

Make sure these are set in your `.env.local`:

```bash
# Supabase Configuration
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE=your_supabase_service_role_key
```

## 🧪 Testing the Setup

After setting up the database, test the following:

1. **User Registration**: Create a new user account
2. **Anonymous Access**: Try using the app without signing in
3. **File Upload**: Upload an image in a chat
4. **Agent Creation**: Create a new agent (authenticated users only)
5. **Public Content**: Verify public agents and chats are accessible

## 🔄 Making Changes

### Adding New Migrations

1. Create a new migration file with timestamp:
   ```bash
   # Example: 20240102000000_add_new_feature.sql
   ```

2. Write your SQL changes:
   ```sql
   -- Add new columns, tables, or modify existing schema
   ALTER TABLE users ADD COLUMN new_field TEXT;
   ```

3. Apply the migration:
   ```bash
   # Local development
   supabase db reset
   
   # Production
   # Copy and paste in Supabase SQL Editor
   ```

### Updating RLS Policies

1. Modify the policy in `migrations/20240101000002_rls_policies.sql`
2. To update existing policies:
   ```sql
   DROP POLICY IF EXISTS "policy_name" ON table_name;
   CREATE POLICY "new_policy_name" ON table_name ...;
   ```

## 🐛 Troubleshooting

### Common Issues

1. **File Upload Errors**:
   - Check storage bucket policies are applied
   - Verify RLS policies for chat_attachments table
   - Ensure service role key is correct

2. **Anonymous User Issues**:
   - Verify "Allow anonymous sign-ins" is enabled
   - Check service role policies are in place

3. **Permission Denied Errors**:
   - Review RLS policies
   - Check user authentication status
   - Verify foreign key relationships

### Debugging Queries

```sql
-- Check if RLS is enabled
SELECT schemaname, tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public';

-- View current policies
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual 
FROM pg_policies 
WHERE schemaname = 'public';

-- Test user permissions
SELECT auth.uid(), auth.jwt();
```

## 📚 Additional Resources

- [Supabase Documentation](https://supabase.com/docs)
- [Row Level Security Guide](https://supabase.com/docs/guides/auth/row-level-security)
- [Storage Policies](https://supabase.com/docs/guides/storage/security/access-control)
- [Supabase CLI Reference](https://supabase.com/docs/reference/cli)

## 🤝 Contributing

When contributing database changes:

1. Always create a new migration file
2. Test locally with `supabase start`
3. Verify RLS policies work correctly
4. Update this README if needed
5. Test with both authenticated and anonymous users 