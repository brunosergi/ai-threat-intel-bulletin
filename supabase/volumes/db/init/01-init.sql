-- 1. ENABLE EXTENSIONS
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- 2. CREATE N8N CUSTOM SCHEMA (Keep N8N data organized)
CREATE SCHEMA IF NOT EXISTS n8n_data;

-- 3. CREATE THE BULLETINS TABLE IN PUBLIC SCHEMA (N8N compatibility)
CREATE TABLE public.bulletins (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  language text NULL DEFAULT 'en-US'::text,
  title text NOT NULL,
  content text NULL,
  sources text[] NULL,
  sent_to_discord boolean NULL DEFAULT false,
  sent_to_discord_date timestamp with time zone NULL,
  CONSTRAINT bulletins_pkey PRIMARY KEY (id),
  CONSTRAINT bulletins_title_key UNIQUE (title),
  CONSTRAINT bulletins_sources_key UNIQUE (sources)
);

-- Enable RLS on the table
ALTER TABLE public.bulletins ENABLE ROW LEVEL SECURITY;

-- Create policy for public access
CREATE POLICY "Allow public access" ON public.bulletins
    FOR ALL
    USING (true)
    WITH CHECK (true);