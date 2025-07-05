# 🚀 AI Threat Intel Bulletin - Setup Guide

Complete deployment guide from git clone to generating automated threat intelligence bulletins with AI.

## Prerequisites

- **Docker** (v20.10+) and **Docker Compose** (v2.0+)
- **Git** for cloning the repository
- **Google Gemini API Key** (free from [Google AI Studio](https://aistudio.google.com/))
- **Discord Webhook URL** (for bulletin notifications)

---

## 🎯 Quick Deployment

### 1. Clone & Configure

```bash
git clone https://github.com/yourusername/ai-threat-intel-bulletin.git
cd ai-threat-intel-bulletin
cp .env.example .env
```

### 2. Edit Environment Variables

Open `.env` and configure these essential variables:

```bash
# Security Keys (generate strong random strings)
N8N_ENCRYPTION_KEY=your-32-character-encryption-key-here
POSTGRES_PASSWORD=your-super-secret-and-long-postgres-password
JWT_SECRET=your-super-secret-jwt-token-with-at-least-32-characters-long
ANON_KEY=
SERVICE_ROLE_KEY=
DASHBOARD_USERNAME=supabase
DASHBOARD_PASSWORD=this_password_is_insecure_and_should_be_updated
VAULT_ENC_KEY=your-encryption-key-32-chars-min
```

- Use "[https://supabase.com/docs/guides/self-hosting/docker#generate-api-keys](https://supabase.com/docs/guides/self-hosting/docker#generate-api-keys)" for `JWT_SECRET`, `SERVICE_ROLE_KEY` and `ANON_KEY`.


### 3. Launch Platform

```bash
docker compose up -d
```

This automatically:
- Sets up PostgreSQL database with bulletins table
- Imports n8n workflows for threat intelligence automation
- Launches all services

### 4. Verify Services Running

```bash
docker compose ps
```

All services should show "healthy" status.

---

## 🔧 n8n Configuration

### Access n8n Editor

1. Open **http://localhost:5678**
2. Create your admin account
3. Configure credentials (this is the only manual step required)

### Add Supabase Credentials

**Settings** → **Credentials** → **Add New**

**Supabase API Credential:**
- **Name**: `Supabase Local`
- **URL**: `http://kong:8000`
- **Service Role Key**: Use `SERVICE_ROLE_KEY` from your `.env` file

### Add Google Gemini Credentials

**Add Google PaLM API Credential:**
- **Name**: `Gemini API`
- **API Key**: Your Google Gemini API key

### Add Discord Webhook Credentials

**Add Discord Webhook Credential:**
- **Name**: `Discord Webhook`
- **Webhook URL**: Your Discord webhook URL

### Update Workflow Credentials

**Important**: Even if nodes don't show errors, manually verify credentials in the main workflow:

**ai_generated_bulletin:**
- "Google Gemini Chat Model" node (add Gemini credential)
- "Save Bulletin to Supabase" node (add Supabase credential)
- "Send Bulletin to Discord" node (add Discord credential)
- "Update Discord Status in Supabase" node (add Supabase credential)

### Activate Workflow

1. Go to **Workflows** in n8n
2. Click **Activate** toggle for the **ai_generated_bulletin** workflow

---

## 🎉 Start Using the Platform

Access the n8n interface: **http://localhost:5678**

**Basic Workflow:**
1. **Generate Bulletin** - Trigger automated threat intelligence collection
2. **Review Content** - See AI-generated threat bulletins with sources
3. **Discord Notification** - Bulletins automatically sent to Discord channel
4. **Manage Bulletins** - View, edit, and manage all generated bulletins

---

## ☁️ Cloud Supabase Option (Recommended for Production)

The project uses self-hosted Supabase which can consume significant resources. For better performance, use cloud Supabase:

### Setup Cloud Supabase

1. **Create Project**: Sign up at [supabase.com](https://supabase.com)
2. **Get Credentials**: Note your Project URL and anon/service_role keys
3. **Create Database Table**: Run this SQL in Supabase SQL editor:

```sql
-- Copy the table schema from supabase/volumes/db/init/01-init.sql
CREATE TABLE public.bulletins (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  language text NULL DEFAULT 'en-US'::text,
  title text NOT NULL,
  content text NULL,
  sources text[] NULL,
  sent_to_discord boolean NULL DEFAULT false,
  sent_to_discord_date timestamp with time zone NULL,
  embedding public.vector NULL,
  CONSTRAINT bulletins_pkey PRIMARY KEY (id),
  CONSTRAINT bulletins_title_key UNIQUE (title),
  CONSTRAINT bulletins_sources_key UNIQUE (sources)
);

-- Create index for vector search
CREATE INDEX IF NOT EXISTS idx_bulletins_embedding ON public.bulletins 
USING ivfflat (embedding vector_cosine_ops)
WITH (lists = '100');
```

### Update Configuration

**In your `.env` file:**
```bash
# Replace with your cloud Supabase values
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
```

**In n8n Supabase credential:**
- **URL**: `https://your-project.supabase.co`
- **Service Role Key**: Your cloud service role key

**Benefits of Cloud Supabase:**
- No local resource usage
- Better performance and reliability
- Automatic backups and scaling
- Real-time dashboard and analytics

---

## 🔄 Changing AI Models

### Switch from Gemini to Other Models

**In ai_generated_bulletin workflow:**

**For OpenAI:**
1. Add OpenAI credential in n8n
2. Replace "Google Gemini Chat Model" node with "OpenAI Chat Model"
3. Update credential reference

You can do the same with any other LLM provider like Claude Anthropic, Ollama, DeepSeek, etc.

---

## 🛠️ Service URLs

| Service | URL | Purpose |
|---------|-----|---------|
| **n8n Workflows** | http://localhost:5678 | Workflow management interface |
| **n8n Editor** | http://localhost:5678 | Workflow management |
| **Supabase Studio** | http://localhost:8000 | Database management |

---

## 🔧 Troubleshooting

### Common Issues

**Services not starting:**
```bash
docker compose logs -f [service-name]
docker compose restart [service-name]
```

**n8n credential errors:**
- Verify all credentials are saved in n8n UI
- Check service URLs and API keys
- Ensure Discord webhook is accessible

**AI bulletin generation failures:**
- Check Google Gemini API quota
- Verify threat intelligence sources are accessible
- Test with simple bulletin generation first

**Discord notifications not working:**
- Verify webhook URL is correct
- Check Discord channel permissions
- Test webhook manually

### Reset Everything

```bash
# Complete reset (removes all data)
docker compose down -v --remove-orphans
docker compose up -d
```

---

🎉 **You're Ready!** Access **http://localhost:5678** to manage your workflow and start generating automated threat intelligence bulletins with AI.