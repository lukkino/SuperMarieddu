-- Classifica online di Monreale (Supabase)
-- Da incollare in: Supabase > SQL Editor > New query > Run

create table if not exists public.classifica (
  id     bigint generated always as identity primary key,
  nome   text        not null check (nome ~ '^[A-Z0-9 .!-]{1,10}$'),
  punti  integer     not null check (punti between 1 and 999999),
  vinto  boolean     not null default false,
  creato timestamptz not null default now()
);
create index if not exists classifica_punti on public.classifica (punti desc, creato);

-- Sicurezza: chiunque può leggere e aggiungere punteggi, nessuno può modificarli o cancellarli
alter table public.classifica enable row level security;

drop policy if exists "classifica: lettura" on public.classifica;
create policy "classifica: lettura" on public.classifica
  for select to anon using (true);

drop policy if exists "classifica: inserimento" on public.classifica;
create policy "classifica: inserimento" on public.classifica
  for insert to anon with check (creato > now() - interval '1 minute');

grant select, insert on public.classifica to anon;
