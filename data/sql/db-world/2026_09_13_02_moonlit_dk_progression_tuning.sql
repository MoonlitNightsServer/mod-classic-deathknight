-- ===========================================================================
--  MOONLIT NIGHTS -- Death Knight progression tuning + action bar rebuild
-- ===========================================================================
--  Applies the level curve agreed 2026-09-13, restores an ability the module
--  made unobtainable, and rebuilds the class-6 starting action bar.
--
--  Every level below is a deliberate decision, not a default. Where a level
--  was chosen to match another class, the reference is named.
--  ~Moonlit Team
-- ===========================================================================


-- ---------------------------------------------------------------------------
--  1. Progression levels
--
--  classic_dk_spell_progression is keyed on spell_id, so ON DUPLICATE KEY
--  UPDATE both edits existing rows and inserts the two new ones, idempotently.
-- ---------------------------------------------------------------------------
INSERT INTO `classic_dk_spell_progression` (`spell_id`, `level`, `requires_progression`) VALUES
-- --- early kit reordered: Blood Strike first, then Icy Touch, then Plague Strike
( 45902,  1, 0),   -- Blood Strike (Rank 1)        was 4  -> 1   (level-1 attack, mirrors Warrior Heroic Strike)
( 45477,  2, 0),   -- Icy Touch (Rank 1)           was 1  -> 2
( 45462,  4, 0),   -- Plague Strike (Rank 1)       was 1  -> 4
(   674,  1, 0),   -- Dual Wield (Passive)         was 10 -> 1   (parity with every other dual-wield class)

-- --- mid-level utility
( 50842, 12, 0),   -- Pestilence                   was 14 -> 12
( 48263, 14, 0),   -- Frost Presence               was 18 -> 14
( 56816, 14, 0),   -- Rune Strike                  NEW GATE       (matches Warrior Revenge Rank 1, ReqLevel 14 on this realm)
( 46584, 18, 0),   -- Raise Dead                   was 12 -> 18
( 56222, 22, 0),   -- Dark Command                 was 34 -> 22   (swapped with Strangulate)
( 49020, 24, 0),   -- Obliterate (Rank 1)          RESTORED       (matches Death Strike Rank 1 at 24) -- see section 2
( 47476, 34, 0),   -- Strangulate                  was 22 -> 34   (swapped with Dark Command)

-- --- mounts, aligned to the rest of the realm
( 33388, 20, 0),   -- Apprentice Riding            was 60 -> 20   (riding trainers on this realm: ReqLevel 20)
( 33391, 40, 0),   -- Journeyman Riding            was 60 -> 40   (riding trainers on this realm: ReqLevel 40)
( 48778, 40, 0),   -- Acherus Deathcharger         was 60 -> 40   (100% mount; needs Journeyman, so it lands with it)

-- --- capstone
( 42650, 60, 0)    -- Army of the Dead             level unchanged; requires_progression 13 -> 0
ON DUPLICATE KEY UPDATE
    `level` = VALUES(`level`),
    `requires_progression` = VALUES(`requires_progression`);

-- Unholy Presence (48265) deliberately LEFT at level 42. It was considered for
-- an earlier grant as a movement-speed option, but with mounts now at level 20
-- there is no longer a reason to move it.


-- ---------------------------------------------------------------------------
--  2. Obliterate was unobtainable -- restored above
--
--  Upstream's 2026_07_23_00_classic_dk_strip_talent_spells.sql removed seven
--  spells from progression on the stated premise that "Talent Rank 1 comes
--  from the talent tree". That premise is correct for six of them and WRONG
--  for Obliterate. Verified against the binary Talent.dbc (892 rows, DK tabs
--  398/399/400, all nine rank slots):
--
--      49143 Frost Strike (R1)      -> talent 1975, Frost tree      OK
--      55050 Heart Strike (R1)      -> talent 1957, Blood tree      OK
--      49158 Corpse Explosion (R1)  -> talent 1985, Unholy tree     OK
--      49020 Obliterate  (R1)       -> NOT GRANTED BY ANY TALENT
--
--  Obliterate is a baseline trained ability in WotLK, not a talent. The same
--  upstream file also ran
--      DELETE FROM trainer_spell WHERE TrainerId = 130 AND SpellId = 49020;
--  so with the progression row gone as well there was NO path to learn it at
--  all -- and Obliterate Rank 2 (51423) still sits on trainer 130 at ReqLevel
--  52 with ReqAbility1 = 49020, a prerequisite that could never be met. The
--  entire Obliterate line was dead.
--
--  Restoring the progression row at level 24 fixes both: Rank 1 is granted on
--  level-up, and Rank 2 becomes purchasable at 52 as intended.
--
--  NOTE, not changed here: Obliterate Rank 2 remains trainer-only, whereas the
--  other strike ranks (Blood/Icy Touch/Plague Strike Ranks 2-4) are all in the
--  progression table at 50/52/54. That inconsistency is left alone pending a
--  decision rather than silently normalised.


-- ---------------------------------------------------------------------------
--  3. Starting action bar -- rebuilt for all fourteen races
--
--  CURRENT STATE, which is not what it should be. Upstream's
--  2026_07_11_02_classic_dk_skills_actions.sql runs
--      DELETE FROM playercreateinfo_action WHERE class = 6;
--  and re-seeds a single race = 0 row set (Attack / Icy Touch / Plague
--  Strike). That wiped Blizzard's per-race bars, so every stock-race Death
--  Knight lost its racial button. Our earlier file then added race-specific
--  rows for 9/12/13/14, which OVERLAP the race-0 rows on buttons 0/1/2 with
--  different actions.
--
--  TARGET, matching how Warriors are laid out on this realm (Attack, one
--  attack, racial in the eleventh slot):
--      button  0 -> 6603   Attack
--      button  1 -> 45902  Blood Strike   (granted at level 1 by section 1)
--      button 10 -> the race's own active racial
--
--  Explicit per-race rows for all fourteen races -- no race = 0 entries, so
--  there is no ambiguity about which row wins. Stock-race racials are the
--  values that were live before the module was installed; the four custom
--  races use the racials confirmed from skilllineability_dbc.
-- ---------------------------------------------------------------------------
DELETE FROM `playercreateinfo_action` WHERE `class` = 6;

INSERT INTO `playercreateinfo_action` (`race`, `class`, `button`, `action`, `type`) VALUES
-- Human
( 1, 6,  0,   6603, 0), ( 1, 6,  1,  45902, 0), ( 1, 6, 10,  59752, 0),  -- Every Man for Himself
-- Orc
( 2, 6,  0,   6603, 0), ( 2, 6,  1,  45902, 0), ( 2, 6, 10,  20572, 0),  -- Blood Fury
-- Dwarf
( 3, 6,  0,   6603, 0), ( 3, 6,  1,  45902, 0), ( 3, 6, 10,   2481, 0),  -- Find Treasure
-- Night Elf
( 4, 6,  0,   6603, 0), ( 4, 6,  1,  45902, 0), ( 4, 6, 10,  58984, 0),  -- Shadowmeld
-- Undead
( 5, 6,  0,   6603, 0), ( 5, 6,  1,  45902, 0), ( 5, 6, 10,  20577, 0),  -- Cannibalize
-- Tauren
( 6, 6,  0,   6603, 0), ( 6, 6,  1,  45902, 0), ( 6, 6, 10,  20549, 0),  -- War Stomp
-- Gnome
( 7, 6,  0,   6603, 0), ( 7, 6,  1,  45902, 0), ( 7, 6, 10,  20589, 0),  -- Escape Artist
-- Troll
( 8, 6,  0,   6603, 0), ( 8, 6,  1,  45902, 0), ( 8, 6, 10,  26297, 0),  -- Berserking
-- Goblin (custom)
( 9, 6,  0,   6603, 0), ( 9, 6,  1,  45902, 0), ( 9, 6, 10,  69041, 0),  -- Rocket Barrage
-- Blood Elf
(10, 6,  0,   6603, 0), (10, 6,  1,  45902, 0), (10, 6, 10,  50613, 0),  -- Arcane Torrent (DK variant)
-- Draenei
(11, 6,  0,   6603, 0), (11, 6,  1,  45902, 0), (11, 6, 10,  59545, 0),  -- Gift of the Naaru (DK variant)
-- Worgen (custom)
(12, 6,  0,   6603, 0), (12, 6,  1,  45902, 0), (12, 6, 10,  68992, 0),  -- Darkflight
-- High Elf (custom)
(13, 6,  0,   6603, 0), (13, 6,  1,  45902, 0), (13, 6, 10, 110007, 0),  -- Quel'dorei Meditation (DK variant)
-- Mag'har Orc (custom)
(14, 6,  0,   6603, 0), (14, 6,  1,  45902, 0), (14, 6, 10, 110001, 0);  -- Ancestral Call

-- ~Moonlit Team
