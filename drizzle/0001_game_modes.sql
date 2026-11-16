ALTER TABLE games ADD COLUMN ranked INTEGER NOT NULL DEFAULT 1 CHECK(ranked IN (0,1));
--> statement-breakpoint
DROP TRIGGER game_rating;
--> statement-breakpoint
CREATE TRIGGER game_rating AFTER UPDATE OF status ON games WHEN OLD.status = 'active' AND NEW.status = 'finished' AND NEW.ranked = 1 BEGIN
UPDATE profiles SET rating=rating+NEW.delta, played=played+1, wins=wins+CASE WHEN NEW.result='black' THEN 1 ELSE 0 END, draws=draws+CASE WHEN NEW.result='draw' THEN 1 ELSE 0 END WHERE id=NEW.black;
UPDATE profiles SET rating=rating-NEW.delta, played=played+1, wins=wins+CASE WHEN NEW.result='white' THEN 1 ELSE 0 END, draws=draws+CASE WHEN NEW.result='draw' THEN 1 ELSE 0 END WHERE id=NEW.white;
END;
