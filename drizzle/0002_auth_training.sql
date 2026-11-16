CREATE TABLE auth_links (supabase_id TEXT PRIMARY KEY, profile_id TEXT NOT NULL UNIQUE REFERENCES profiles(id));
--> statement-breakpoint
CREATE TABLE training_sessions (user_id TEXT NOT NULL REFERENCES profiles(id), puzzle_id TEXT NOT NULL, seed INTEGER NOT NULL, created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY(user_id,puzzle_id));
