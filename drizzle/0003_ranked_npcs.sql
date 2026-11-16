ALTER TABLE profiles ADD COLUMN is_npc INTEGER NOT NULL DEFAULT 0 CHECK(is_npc IN (0,1));
--> statement-breakpoint
ALTER TABLE games ADD COLUMN npc_id TEXT;
--> statement-breakpoint
DROP TRIGGER game_rating;
--> statement-breakpoint
CREATE TRIGGER game_rating AFTER UPDATE OF status ON games WHEN OLD.status='active' AND NEW.status='finished' AND NEW.ranked=1 BEGIN
UPDATE profiles SET rating=rating+NEW.delta,played=played+1,wins=wins+CASE WHEN NEW.result='black' THEN 1 ELSE 0 END,draws=draws+CASE WHEN NEW.result='draw' THEN 1 ELSE 0 END WHERE id=NEW.black AND is_npc=0;
UPDATE profiles SET rating=rating-NEW.delta,played=played+1,wins=wins+CASE WHEN NEW.result='white' THEN 1 ELSE 0 END,draws=draws+CASE WHEN NEW.result='draw' THEN 1 ELSE 0 END WHERE id=NEW.white AND is_npc=0;
END;
