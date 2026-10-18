-- ===========================================================================
--  MOONLIT NIGHTS -- Death Knight trainer: required level follows the grant level
-- ===========================================================================
--  The module teaches these spells automatically at the levels in
--  classic_dk_spell_progression (the Moonlit curve agreed 2026-09-13), but the
--  DK trainer (id 130) still listed them at the module's original, earlier
--  levels, so a Death Knight could buy them before the curve grants them.
--  Found in the first generation-2 in-game test (2026-10-18): Icy Touch and
--  Plague Strike Rank 1 were trainable at level 1.
--
--  Only rows where the trainer level was BELOW the grant level are changed.
--  Rows where the trainer is later than the grant are harmless (the automatic
--  grant arrives first) and are left alone.
--  ~Moonlit Nights Team
-- ===========================================================================

UPDATE `trainer_spell` SET `ReqLevel` = 2  WHERE `TrainerId` = 130 AND `SpellId` = 45477;  -- Icy Touch (Rank 1)
UPDATE `trainer_spell` SET `ReqLevel` = 4  WHERE `TrainerId` = 130 AND `SpellId` = 45462;  -- Plague Strike (Rank 1)
UPDATE `trainer_spell` SET `ReqLevel` = 18 WHERE `TrainerId` = 130 AND `SpellId` = 46584;  -- Raise Dead
UPDATE `trainer_spell` SET `ReqLevel` = 34 WHERE `TrainerId` = 130 AND `SpellId` = 47476;  -- Strangulate
UPDATE `trainer_spell` SET `ReqLevel` = 52 WHERE `TrainerId` = 130 AND `SpellId` = 53344;  -- Rune of the Fallen Crusader
