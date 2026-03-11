-- Run this in your Supabase SQL Editor (supabase.com > your project > SQL Editor)

-- 1. Create the table
create table hole_scores (
  id bigint generated always as identity primary key,
  round smallint not null check (round in (1, 2)),
  hole smallint not null check (hole between 1 and 18),
  drives text[] default '{}',
  approach text[] default '{}',
  chips text[] default '{}',
  putts text[] default '{}',
  done boolean default false,
  updated_at timestamptz default now(),
  unique(round, hole)
);

-- 2. Enable Row Level Security
alter table hole_scores enable row level security;

-- 3. Allow public access (this is a simple shared app, no auth needed)
create policy "Allow all access" on hole_scores
  for all
  using (true)
  with check (true);

-- 4. Enable realtime so all phones see updates instantly
alter publication supabase_realtime add table hole_scores;
