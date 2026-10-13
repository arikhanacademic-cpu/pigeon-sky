-- Pigeon Sky database setup. Paste into Supabase -> SQL Editor -> Run.

create extension if not exists pgcrypto;

create table if not exists public.pigeons (
  id          uuid primary key default gen_random_uuid(),
  img         text not null,
  artist      text not null,
  owner_token text not null,
  created_at  timestamptz not null default now(),
  constraint img_is_png   check (img like 'data:image/png;base64,%'),
  constraint img_size     check (length(img) < 400000),
  constraint artist_len   check (char_length(artist) between 1 and 40),
  constraint token_len    check (char_length(owner_token) between 16 and 100)
);

alter table public.pigeons enable row level security;

-- Visitors can see pigeons and add new ones, but never edit or delete directly.
drop policy if exists "anyone can read"   on public.pigeons;
drop policy if exists "anyone can insert" on public.pigeons;
create policy "anyone can read"   on public.pigeons for select to anon, authenticated using (true);
create policy "anyone can insert" on public.pigeons for insert to anon, authenticated with check (true);

-- Hide each pigeon's secret owner_token from everyone.
revoke all on public.pigeons from anon, authenticated;
grant select (id, img, artist, created_at) on public.pigeons to anon, authenticated;
grant insert (id, img, artist, owner_token)    on public.pigeons to anon, authenticated;

-- An artist can remove their own pigeon with the secret token their browser saved.
create or replace function public.delete_pigeon(pid uuid, token text)
returns void
language sql
security definer
set search_path = public
as $$
  delete from public.pigeons where id = pid and owner_token = token;
$$;
revoke all on function public.delete_pigeon(uuid, text) from public;
grant execute on function public.delete_pigeon(uuid, text) to anon, authenticated;
