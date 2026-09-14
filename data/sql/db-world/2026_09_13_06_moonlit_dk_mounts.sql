-- ===========================================================================
--  MOONLIT NIGHTS -- Death Knight mount progression
-- ===========================================================================
--  Supersedes the abandoned 110025 approach. A duplicate spell with
--  SkillLineAbility.spellIdParent cannot hide a mount: mounts render in the
--  Pets & Mounts tab, not the spellbook, and the supersede mechanism is
--  spellbook-only. Both versions stayed visible. 110025 has been removed from
--  Spell.dbc and SkillLineAbility.dbc; this file drops its progression row.
--
--  Instead the Acherus Deathcharger itself becomes the level-20 mount, retuned
--  to 60% in Spell.dbc (EffectBasePoints[1] 99 -> 59, level tag 55 -> 20), and
--  two existing mounts fill the later tiers.
--
--  Riding requirements, from item_template:
--    73313  Crimson Deathcharger    item 52200, needs riding 75  -> Apprentice (20)
--    54729  Winged Steed            item 40775, needs riding 225 -> Expert    (60)
--  Expert Riding is granted at 60 so the flying mount is actually usable;
--  without it the spell is known but cannot be cast.
--  ~Moonlit Team
-- ===========================================================================

DELETE FROM `classic_dk_spell_progression` WHERE `spell_id` = 110025;

INSERT INTO `classic_dk_spell_progression` (`spell_id`, `level`, `requires_progression`) VALUES
( 48778, 20, 0),   -- Acherus Deathcharger   was 40 -> 20   now the 60% mount (Spell.dbc retuned)
( 73313, 40, 0),   -- Crimson Deathcharger   NEW            100% ground; pairs with Journeyman Riding at 40
( 34090, 60, 0),   -- Expert Riding          NEW            riding 225, prerequisite for the flyer
( 54729, 60, 0)    -- Winged Steed of the Ebon Blade  NEW   flying capstone
ON DUPLICATE KEY UPDATE
    `level` = VALUES(`level`),
    `requires_progression` = VALUES(`requires_progression`);