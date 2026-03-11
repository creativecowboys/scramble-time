-- ============================================================
-- SCRAMBLE TIME — ARCHIVE MIGRATION
-- Run this in: supabase.com → Your Project → SQL Editor
-- ============================================================

-- 1. Create sessions table (one row per match/outing)
create table if not exists sessions (
  id          uuid primary key default gen_random_uuid(),
  label       text default '',
  played_at   date default current_date,
  created_at  timestamptz default now()
);

-- 2. Enable Row Level Security
alter table sessions enable row level security;

-- 3. Allow public access (same as hole_scores)
create policy "Allow all access" on sessions
  for all using (true) with check (true);

-- 4. Add session_id column to hole_scores
alter table hole_scores
  add column if not exists session_id uuid references sessions(id) on delete cascade;

-- 5. Delete old data that has no session_id (clean slate)
--    Comment out this line if you want to keep historical data as-is
delete from hole_scores where session_id is null;

-- 6. Drop the old unique constraint (was just round+hole)
alter table hole_scores drop constraint if exists hole_scores_round_hole_key;

-- 7. Add new unique constraint that scopes uniqueness per session
alter table hole_scores
  add constraint hole_scores_session_round_hole unique(session_id, round, hole);

-- 8. Enable realtime on sessions table too
alter publication supabase_realtime add table sessions;

-- Done! The app will now create a session record each time you start a new match.
