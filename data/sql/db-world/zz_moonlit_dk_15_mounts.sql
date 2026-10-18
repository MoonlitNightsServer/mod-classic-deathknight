-- Generation-2 replay (Phase 3) of the generation-1 file 2026_09_13_06_moonlit_dk_mounts.sql.
-- Racial spell IDs remapped to the gen-2 allocations (110007 -> 3410011, 110001 -> 4010010).
-- ===========================================================================
--  MOONLIT NIGHTS -- Death Knight mount progression
-- ===========================================================================
--  Generation-2 replay of the generation-1 mount tiers.
--
--  The Acherus Deathcharger itself becomes the level-20 mount, retuned
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

INSERT INTO `classic_dk_spell_progression` (`spell_id`, `level`, `requires_progression`) VALUES
( 48778, 20, 0),   -- Acherus Deathcharger   was 40 -> 20   now the 60% mount (Spell.dbc retuned)
( 73313, 40, 0),   -- Crimson Deathcharger   NEW            100% ground; pairs with Journeyman Riding at 40
( 34090, 60, 0),   -- Expert Riding          NEW            riding 225, prerequisite for the flyer
( 54729, 60, 0)    -- Winged Steed of the Ebon Blade  NEW   flying capstone
ON DUPLICATE KEY UPDATE
    `level` = VALUES(`level`),
    `requires_progression` = VALUES(`requires_progression`);