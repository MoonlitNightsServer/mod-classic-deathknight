-- ===========================================================================
--  MOONLIT NIGHTS -- Death Knight: ungoverned spells + Rune Strike correction
-- ===========================================================================
--  Four abilities reach a level-1 Death Knight with no level gate at all.
--  They are auto-granted by SkillLineAbility (acquireMethod 2), which the core
--  applies when the skill line is learned WITHOUT consulting Spell.dbc level.
--  The module only removes spells listed in classic_dk_spell_progression, so
--  anything absent from that table leaks in at character creation.
--
--  Adding them here does not grant them -- it puts them under the module's
--  control so ApplyProgression strips them below their level.
--
--  Also corrects Rune Strike: 56816 is the passive proc enabler (Effect 6,
--  aura 42, triggers 56817); 56815 is the castable attack. A prior file gated
--  the passive at 14 and left the button on the trainer at 29.
--  ~Moonlit Team
-- ===========================================================================

INSERT INTO `classic_dk_spell_progression` (`spell_id`, `level`, `requires_progression`) VALUES
( 61455,  1, 0),   -- Runic Focus (Passive)        LEAK -> 1    (underpins the runic power bar; foundational)
( 49410,  1, 0),   -- Forceful Deflection (Passive) LEAK -> 1   (kept at 1 by ruling; Spell.dbc level tag fixed separately)
( 59921,  2, 0),   -- Frost Fever (Passive)        LEAK -> 2    (lands with Icy Touch Rank 1)
( 59879,  4, 0),   -- Blood Plague (Passive)       LEAK -> 4    (lands with Plague Strike Rank 1)
( 56815, 14, 0),   -- Rune Strike (castable)       NEW GATE     (the actual button; matches Warrior Revenge Rank 1)
( 51423, 52, 0)    -- Obliterate (Rank 2)          RESTORED     (parity with Blood Strike / Icy Touch / Plague Strike R2 at 52)
ON DUPLICATE KEY UPDATE
    `level` = VALUES(`level`),
    `requires_progression` = VALUES(`requires_progression`);

-- Rune Strike's button sat on DK trainer template 130 at level 29 while the
-- passive arrived at 14. Align the trainer so the pair cannot desync if the
-- progression grant is ever disabled.
UPDATE `trainer_spell` SET `ReqLevel` = 14 WHERE `TrainerId` = 130 AND `SpellId` = 56815;
