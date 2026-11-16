CREATE TABLE profiles (id TEXT PRIMARY KEY, handle TEXT NOT NULL UNIQUE COLLATE NOCASE, name TEXT NOT NULL, bio TEXT NOT NULL DEFAULT '', color TEXT NOT NULL DEFAULT 'sage', rating INTEGER NOT NULL DEFAULT 1200, puzzle_rating INTEGER NOT NULL DEFAULT 1200, played INTEGER NOT NULL DEFAULT 0, wins INTEGER NOT NULL DEFAULT 0, draws INTEGER NOT NULL DEFAULT 0, created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP);
--> statement-breakpoint
CREATE TABLE friendships (sender TEXT NOT NULL REFERENCES profiles(id), receiver TEXT NOT NULL REFERENCES profiles(id), status TEXT NOT NULL DEFAULT 'pending', created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY(sender,receiver), CHECK(sender <> receiver));
--> statement-breakpoint
CREATE TABLE games (id TEXT PRIMARY KEY, black TEXT NOT NULL REFERENCES profiles(id), white TEXT REFERENCES profiles(id), invited TEXT REFERENCES profiles(id), status TEXT NOT NULL DEFAULT 'waiting', moves TEXT NOT NULL DEFAULT '[]', revision INTEGER NOT NULL DEFAULT 0, result TEXT, delta INTEGER NOT NULL DEFAULT 0, created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, CHECK(black <> white));
--> statement-breakpoint
CREATE INDEX games_black_status ON games(black,status);
--> statement-breakpoint
CREATE INDEX games_white_status ON games(white,status);
--> statement-breakpoint
CREATE TABLE puzzle_progress (user_id TEXT NOT NULL REFERENCES profiles(id), puzzle_id TEXT NOT NULL, solved INTEGER NOT NULL DEFAULT 0, attempts INTEGER NOT NULL DEFAULT 0, rated INTEGER NOT NULL DEFAULT 0, created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY(user_id,puzzle_id));
--> statement-breakpoint
CREATE TRIGGER game_rating AFTER UPDATE OF status ON games WHEN OLD.status = 'active' AND NEW.status = 'finished' BEGIN
UPDATE profiles SET rating=rating+NEW.delta, played=played+1, wins=wins+CASE WHEN NEW.result='black' THEN 1 ELSE 0 END, draws=draws+CASE WHEN NEW.result='draw' THEN 1 ELSE 0 END WHERE id=NEW.black;
UPDATE profiles SET rating=rating-NEW.delta, played=played+1, wins=wins+CASE WHEN NEW.result='white' THEN 1 ELSE 0 END, draws=draws+CASE WHEN NEW.result='draw' THEN 1 ELSE 0 END WHERE id=NEW.white;
END;

--> statement-breakpoint
CREATE UNIQUE INDEX friendships_pair ON friendships(MIN(sender,receiver),MAX(sender,receiver));
--> statement-breakpoint
CREATE TRIGGER one_game_create BEFORE INSERT ON games WHEN EXISTS(SELECT 1 FROM games WHERE (black=NEW.black OR white=NEW.black) AND status IN ('waiting','active')) BEGIN SELECT RAISE(ABORT,'Player already has an open game'); END;
--> statement-breakpoint
CREATE TRIGGER one_game_join BEFORE UPDATE OF white ON games WHEN NEW.white IS NOT NULL AND EXISTS(SELECT 1 FROM games WHERE id<>NEW.id AND (black=NEW.white OR white=NEW.white) AND status IN ('waiting','active')) BEGIN SELECT RAISE(ABORT,'Player already has an open game'); END;
