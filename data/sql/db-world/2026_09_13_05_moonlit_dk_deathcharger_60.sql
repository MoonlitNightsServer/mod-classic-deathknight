-- ===========================================================================
--  MOONLIT NIGHTS -- Death Knight: 60% Acherus Deathcharger
-- ===========================================================================
--  The class mount existed only as a 100% version (48778), so a Death Knight
--  had no mount at all between Apprentice Riding (20) and Journeyman (40).
--
--  Spell 110025 is a byte-for-byte copy of 48778 in Spell.dbc with a single
--  change: EffectBasePoints[1] 99 -> 59. That field stores value-minus-one,
--  so 99 is +100% speed and 59 is +60%.
--
--  Hiding the slow version copies Worgen's Running Wild exactly. Two new
--  SkillLineAbility rows (31475 on line 772, 31476 on line 777) carry
--  spellIdParent = 48778, so the client hides 110025 once 48778 is learned --
--  the same wiring as 31468 (87840 -> 110010) and 31470 (87841 -> 110011).
--  Both spells stay KNOWN; the supercede is display-only, which is why no
--  removal row is needed here.
--
--  DBC edits live outside this file, in Spell.dbc and SkillLineAbility.dbc
--  (server Data/dbc and client patch-A.mpq/DBFilesClient). This row only
--  tells the module when to grant it.
--  ~Moonlit Team
-- ===========================================================================

INSERT INTO `classic_dk_spell_progression` (`spell_id`, `level`, `requires_progression`) VALUES
( 110025, 20, 0)   -- Acherus Deathcharger (60%)   lands with Apprentice Riding; superseded by 48778 at 40
ON DUPLICATE KEY UPDATE
    `level` = VALUES(`level`),
    `requires_progression` = VALUES(`requires_progression`);