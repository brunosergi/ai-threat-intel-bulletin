create table public.bulletins (
  id uuid not null default gen_random_uuid (),
  created_at timestamp with time zone not null default now(),
  language text null default 'en-US'::text,
  title text not null,
  content text null,
  sources text[] null,
  sent_to_discord boolean null default false,
  sent_to_discord_date timestamp with time zone null,
  embedding public.vector null,
  constraint bulletins_pkey primary key (id),
  constraint bulletins_title_key unique (title),
  constraint bulletins_sources_key unique (sources)
) TABLESPACE pg_default;

create index IF not exists idx_bulletins_embedding on public.bulletins using ivfflat (embedding vector_cosine_ops)
with
  (lists = '100') TABLESPACE pg_default;