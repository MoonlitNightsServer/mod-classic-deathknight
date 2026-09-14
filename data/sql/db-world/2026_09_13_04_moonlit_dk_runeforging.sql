-- ===========================================================================
--  MOONLIT NIGHTS -- Death Knight: Runeforging, Death Gate, and the rune arc
-- ===========================================================================
--  Runeforging (53428) and Death Gate (50977) both sat at 55, which on a
--  level-60 cap made the class signature mechanic unreachable for 54 of 60
--  levels. Both move to 20, alongside Apprentice Riding.
--
--  MECHANICAL CONSTRAINT, NOT A PREFERENCE:
--  Rune of Cinderglacier (53341) and Rune of Razorice (53343) are the only
--  two runes with acquireMethod = 1 on skill line 776. The core grants them
--  automatically the moment a player gains that skill -- which happens the
--  instant Runeforging is learned, because 53428 carries a SpellLearnSkill
--  for 776. Their progression rows MUST therefore equal Runeforging's level.
--  If they were later, a DK would receive them on learning Runeforging and
--  then silently lose them at the next login, when _LoadSkills re-grants them
--  from the skill and ApplyProgression immediately strips them again.
--
--  Neither of those two persists in character_spell -- AzerothCore does not
--  save spells learned as a consequence of a skill. They are rebuilt from
--  skill 776 on every login. Absence from that table is expected, not a bug.
--
--  The remaining eight runes have acquireMethod = 0 and are granted purely by
--  this table. Runes are percentage-based, so no value rebalancing is needed
--  when they arrive earlier than retail.
--
--  Rune of the Stoneskin Gargoyle (62158) and Rune of the Nerubian Carapace
--  (70164) had no progression row and appear on no trainer -- they were
--  unobtainable on this realm. They are added here.
--  ~Moonlit Team
-- ===========================================================================

INSERT INTO `classic_dk_spell_progression` (`spell_id`, `level`, `requires_progression`) VALUES
-- --- unlock: the forge itself, plus the pair welded to it
( 53428, 20, 0),   -- Runeforging                      was 55 -> 20  (grants skill 776; the craft container)
( 50977, 20, 0),   -- Death Gate                       was 55 -> 20  (no dependency; paired with the forge unlock)
( 53341, 20, 0),   -- Rune of Cinderglacier            was 52 -> 20  (acquireMethod 1 - MUST match Runeforging)
( 53343, 20, 0),   -- Rune of Razorice                 was 54 -> 20  (acquireMethod 1 - MUST match Runeforging)

-- --- second set: the anti-magic pair
( 54447, 28, 0),   -- Rune of Spellbreaking            was 54 -> 28
( 53342, 28, 0),   -- Rune of Spellshattering          was 52 -> 28

-- --- third: solo
( 53331, 36, 0),   -- Rune of Lichbane                 was 50 -> 36

-- --- fourth set: the anti-melee pair
( 54446, 44, 0),   -- Rune of Swordbreaking            was 54 -> 44
( 53323, 44, 0),   -- Rune of Swordshattering          was 54 -> 44

-- --- fifth: solo, the strongest damage rune, one tier before cap
( 53344, 52, 0),   -- Rune of the Fallen Crusader      was 50 -> 52

-- --- sixth set: tank capstone, previously unobtainable
( 62158, 60, 0),   -- Rune of the Stoneskin Gargoyle   NEW  (no prior row, no trainer entry)
( 70164, 60, 0)    -- Rune of the Nerubian Carapace    NEW  (no prior row, no trainer entry)
ON DUPLICATE KEY UPDATE
    `level` = VALUES(`level`),
    `requires_progression` = VALUES(`requires_progression`);