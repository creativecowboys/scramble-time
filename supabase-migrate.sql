-- Run this if you already created the table and need to add the 'done' column
alter table hole_scores add column if not exists done boolean default false;
