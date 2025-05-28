# Docker Deployment Guide

This guide provides comprehensive Docker deployment options for Zola, including self-hosted Supabase configurations with and without Ollama.

## 📋 Available Deployment Options

1. **Standard Deployment** - Zola only (existing `docker-compose.ollama.yml`)
2. **Supabase + Zola** - Self-hosted Supabase with Zola (`docker-compose.supabase.yml`)
3. **Supabase + Zola + Ollama** - Complete self-hosted stack (`docker-compose.supabase-ollama.yml`)

## 🚀 Quick Start

### Option 1: Supabase + Zola (Cloud AI Models)

Perfect for production deployments where you want self-hosted database but use cloud AI services.

```bash
# 1. Copy environment file
cp env.supabase.example .env.supabase

# 2. Edit environment variables (see Configuration section below)
nano .env.supabase

# 3. Generate secure keys (see Security section below)

# 4. Start services
docker-compose -f docker-compose.supabase.yml --env-file .env.supabase up -d

# 5. Access services
# - Zola App: http://localhost:3000
# - Supabase Studio: http://localhost:8000
# - Supabase API: http://localhost:8000
```

### Option 2: Supabase + Zola + Ollama (Fully Self-Hosted)

Complete self-hosted solution with local AI models.

```bash
# 1. Copy environment file
cp env.supabase.example .env.supabase

# 2. Edit environment variables
nano .env.supabase

# 3. Set Ollama URL for internal use
echo "OLLAMA_URL=http://ollama:11434" >> .env.supabase

# 4. Start services
docker-compose -f docker-compose.supabase-ollama.yml --env-file .env.supabase up -d

# 5. Download AI models (after Ollama starts)
docker exec ollama ollama pull llama3.2
docker exec ollama ollama pull codellama
docker exec ollama ollama pull mistral

# 6. Access services
# - Zola App: http://localhost:3000
# - Supabase Studio: http://localhost:8000
# - Ollama API: http://localhost:11434
```

## ⚙️ Configuration

### Required Environment Variables

Copy `env.supabase.example` to `.env.supabase` and update these critical values:

```bash
# 🔐 SECURITY - MUST CHANGE THESE
POSTGRES_PASSWORD=your-super-secret-and-long-postgres-password
JWT_SECRET=your-super-secret-jwt-token-with-at-least-32-characters-long
LOGFLARE_API_KEY=your-super-secret-and-long-logflare-key
CSRF_SECRET=your-csrf-secret-key

# 🔑 API Keys (add your actual keys)
OPENAI_API_KEY=your-openai-api-key
ANTHROPIC_API_KEY=your-anthropic-api-key
# ... other AI provider keys

# 📧 Email Configuration (for auth emails)
SMTP_HOST=smtp.gmail.com
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-email-password
```

### Ollama Configuration

For **Supabase + Zola** deployment (without Ollama container):
```bash
# Leave empty or set external Ollama URL
OLLAMA_URL=http://your-external-ollama:11434
```

For **Supabase + Zola + Ollama** deployment:
```bash
# Use internal container URL
OLLAMA_URL=http://ollama:11434
```

## 🔐 Security Setup

### 1. Generate Secure Keys

```bash
# Generate JWT Secret (40+ characters)
openssl rand -base64 32

# Generate strong passwords
openssl rand -base64 24
```

### 2. Generate Supabase API Keys

Use the [Supabase JWT Generator](https://supabase.com/docs/guides/hosting/overview#api-keys) or:

```bash
# Install supabase CLI
npm install -g supabase

# Generate keys with your JWT secret
supabase gen keys --project-ref your-project --experimental
```

### 3. Update Default Credentials

**Important**: Change these default values in `.env.supabase`:

```bash
# Database
POSTGRES_PASSWORD=your-super-secret-and-long-postgres-password

# JWT (use your generated secret)
JWT_SECRET=your-super-secret-jwt-token-with-at-least-32-characters-long

# API Keys (generate with your JWT secret)
ANON_KEY=your-generated-anon-key
SERVICE_ROLE_KEY=your-generated-service-role-key

# Logs
LOGFLARE_API_KEY=your-super-secret-and-long-logflare-key
```

## 🗄️ Database Setup

The database will be automatically initialized with:

1. **Schema**: All tables, indexes, and relationships
2. **RLS Policies**: Row-level security for data isolation
3. **Sample Data**: 5 public agents for development
4. **Storage Buckets**: Avatars and chat-attachments

### Manual Database Access

```bash
# Connect to database
docker exec -it supabase-db psql -U postgres

# Or use external connection
psql "postgresql://postgres:your-password@localhost:5432/postgres"
```

## 📁 Service Architecture

### Supabase Services

| Service | Port | Description |
|---------|------|-------------|
| **Kong** | 8000/8443 | API Gateway |
| **Studio** | - | Dashboard (via Kong) |
| **Auth** | - | Authentication (GoTrue) |
| **REST** | - | PostgREST API |
| **Realtime** | - | WebSocket subscriptions |
| **Storage** | - | File storage |
| **Database** | 5432 | PostgreSQL |
| **Analytics** | 4000 | Logging (Logflare) |

### Application Services

| Service | Port | Description |
|---------|------|-------------|
| **Zola** | 3000 | Main application |
| **Ollama** | 11434 | Local AI models (optional) |

## 🔧 Management Commands

### Service Management

```bash
# Start services
docker-compose -f docker-compose.supabase.yml --env-file .env.supabase up -d

# Stop services
docker-compose -f docker-compose.supabase.yml down

# View logs
docker-compose -f docker-compose.supabase.yml logs -f zola
docker-compose -f docker-compose.supabase.yml logs -f supabase-db

# Restart specific service
docker-compose -f docker-compose.supabase.yml restart zola
```

### Database Management

```bash
# Backup database
docker exec supabase-db pg_dump -U postgres postgres > backup.sql

# Restore database
docker exec -i supabase-db psql -U postgres postgres < backup.sql

# Reset database (⚠️ DESTRUCTIVE)
docker-compose -f docker-compose.supabase.yml down -v
docker-compose -f docker-compose.supabase.yml up -d
```

### Ollama Model Management

```bash
# List available models
docker exec ollama ollama list

# Download models
docker exec ollama ollama pull llama3.2:latest
docker exec ollama ollama pull codellama:7b
docker exec ollama ollama pull mistral:7b

# Remove models
docker exec ollama ollama rm model-name

# Check Ollama status
curl http://localhost:11434/api/tags
```

## 🔍 Monitoring & Troubleshooting

### Health Checks

```bash
# Check all services
docker-compose -f docker-compose.supabase.yml ps

# Test Zola app
curl http://localhost:3000/api/health

# Test Supabase API
curl http://localhost:8000/rest/v1/

# Test Ollama (if using)
curl http://localhost:11434/api/tags
```

### Common Issues

#### 1. Database Connection Issues
```bash
# Check database logs
docker logs supabase-db

# Verify database is ready
docker exec supabase-db pg_isready -U postgres
```

#### 2. Authentication Issues
```bash
# Check auth service
docker logs supabase-auth

# Verify JWT secret matches
docker exec supabase-auth env | grep JWT_SECRET
```

#### 3. File Upload Issues
```bash
# Check storage service
docker logs supabase-storage

# Verify storage permissions
docker exec supabase-storage ls -la /var/lib/storage
```

#### 4. Ollama Issues
```bash
# Check Ollama logs
docker logs ollama

# Verify GPU access (if using)
docker exec ollama nvidia-smi

# Test model loading
docker exec ollama ollama run llama3.2 "Hello"
```

## 🚀 Production Deployment

### 1. Security Hardening

```bash
# Use strong passwords
POSTGRES_PASSWORD=$(openssl rand -base64 32)
JWT_SECRET=$(openssl rand -base64 32)
CSRF_SECRET=$(openssl rand -base64 32)

# Disable signup if not needed
DISABLE_SIGNUP=true

# Use production SMTP
SMTP_HOST=your-production-smtp.com
```

### 2. Performance Optimization

```bash
# Increase database resources
# Edit docker-compose.yml:
# deploy:
#   resources:
#     limits:
#       memory: 2G
#       cpus: '1.0'

# Use external storage
STORAGE_BACKEND=s3
GLOBAL_S3_BUCKET=your-s3-bucket
```

### 3. Backup Strategy

```bash
# Automated backups
# Add to crontab:
# 0 2 * * * docker exec supabase-db pg_dump -U postgres postgres | gzip > /backups/$(date +\%Y\%m\%d).sql.gz
```

## 🔗 External Integrations

### Using External Supabase

If you prefer using Supabase Cloud instead of self-hosted:

```bash
# Use standard deployment
docker-compose -f docker-compose.ollama.yml up -d

# Set Supabase Cloud credentials in .env.local
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE=your-service-role-key
```

### Using External Ollama

For distributed deployments:

```bash
# In .env.supabase
OLLAMA_URL=http://your-ollama-server:11434

# Use supabase-only deployment
docker-compose -f docker-compose.supabase.yml --env-file .env.supabase up -d
```

## 📚 Additional Resources

- [Supabase Self-Hosting Guide](https://supabase.com/docs/guides/self-hosting/docker)
- [Ollama Documentation](https://ollama.ai/docs)
- [Docker Compose Reference](https://docs.docker.com/compose/)
- [Zola Documentation](./README.md)

## 🤝 Support

For deployment issues:

1. Check the logs: `docker-compose logs -f service-name`
2. Verify environment variables: `docker exec container-name env`
3. Test connectivity: `docker exec container-name curl http://other-service:port`
4. Review this guide and the [main README](./README.md)

---

**Note**: Always use strong, unique passwords and API keys in production. Never use the default values provided in the example files. 