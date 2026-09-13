-- ===========================================================================
--  MOONLIT NIGHTS -- Custom-race Death Knight support for mod-classic-deathknight
-- ===========================================================================
--  WHY THIS FILE EXISTS
--
--  Upstream mod-classic-deathknight rebuilds every class-6 character-creation
--  row from scratch:
--        DELETE FROM playercreateinfo        WHERE class = 6;
--        DELETE FROM playercreateinfo_item   WHERE class = 6;   (3 files do this)
--        DELETE FROM playercreateinfo_action WHERE class = 6;
--  ...and then re-seeds races 1-8, 10, 11 only -- the ten stock races.
--
--  This realm has four more: Goblin (9), Worgen (12), High Elf (13) and
--  Mag'har Orc (14), all DK-capable via mod-uac. Without this file they would
--  be left with no creation entry, no starting gear and no action bar.
--
--  It is additionally required because the module's Acherus "strip" rows use
--  race = 0, which means EVERY race: our four receive the full Acherus Knight
--  set from charstartoutfit_dbc, the module strips all of it, and its
--  replacement gear rows do not cover them. Net result without this file is
--  naked custom-race Death Knights.
--
--  FILENAME ORDERING IS LOAD-BEARING. The module's own SQL runs through
--  2026_08_28. AzerothCore's updater applies in filename order, so this file
--  must sort AFTER all of them or the module's DELETEs wipe everything below.
--
--  Every statement is scoped to race IN (9,12,13,14) AND class = 6, and each
--  section deletes its own scope before inserting, so the file is idempotent
--  and never touches stock-race data.
--  ~Moonlit Team
-- ===========================================================================


-- ---------------------------------------------------------------------------
--  1. Character creation -- racial starting zones
--
--  Coordinates are taken verbatim from this realm's live playercreateinfo, as
--  established by mod-uac. They already place custom-race DKs in racial zones
--  rather than Acherus, which is exactly what this module does for the stock
--  ten -- so these are preserved, not invented.
--    Goblin (9)  + Mag'har (14) -> Durotar, Valley of Trials
--    Worgen (12)                -> Teldrassil
--    High Elf (13)              -> Elwynn Forest
-- ---------------------------------------------------------------------------
DELETE FROM `playercreateinfo` WHERE `class` = 6 AND `race` IN (9, 12, 13, 14);

INSERT INTO `playercreateinfo`
    (`race`, `class`, `map`, `zone`, `position_x`, `position_y`, `position_z`, `orientation`) VALUES
( 9, 6, 1,  14,  -618.518, -4251.67,   38.718,  0),
(12, 6, 1, 141,   10311.3,  832.463,  1326.41,  5.69632),
(13, 6, 0,  12,  -8949.95, -132.493,  83.5312,  0),
(14, 6, 1,  14,  -618.518, -4251.67,   38.718,  0);


-- ---------------------------------------------------------------------------
--  2. Starting gear -- Human's kit, cloned to all four custom races
--
--  Matches the Phase 1 "All Classes" principle: every race receives Human's
--  exact starting gear for a given class rather than a per-faction reference
--  race. All six items verified present in item_template with no class or race
--  restriction that excludes a Death Knight (Worn Greatsword: AllowableClass
--  262143 includes DK's bit 32; AllowableRace 2147483647 includes 256/2048/
--  4096/8192).
--
--  The module's own race = 0 rows already strip the Acherus set from every
--  race, ours included, so no strip rows are repeated here.
-- ---------------------------------------------------------------------------
DELETE FROM `playercreateinfo_item` WHERE `class` = 6 AND `race` IN (9, 12, 13, 14);

INSERT INTO `playercreateinfo_item` (`race`, `class`, `itemid`, `amount`, `Note`) VALUES
-- Goblin
( 9, 6,    38, 1, 'Recruit''s Shirt'),
( 9, 6,    39, 1, 'Recruit''s Pants'),
( 9, 6,    40, 1, 'Recruit''s Boots'),
( 9, 6, 49778, 1, 'Worn Greatsword'),
( 9, 6,   117, 5, 'Tough Jerky'),
( 9, 6,   159, 5, 'Refreshing Spring Water'),
-- Worgen
(12, 6,    38, 1, 'Recruit''s Shirt'),
(12, 6,    39, 1, 'Recruit''s Pants'),
(12, 6,    40, 1, 'Recruit''s Boots'),
(12, 6, 49778, 1, 'Worn Greatsword'),
(12, 6,   117, 5, 'Tough Jerky'),
(12, 6,   159, 5, 'Refreshing Spring Water'),
-- High Elf
(13, 6,    38, 1, 'Recruit''s Shirt'),
(13, 6,    39, 1, 'Recruit''s Pants'),
(13, 6,    40, 1, 'Recruit''s Boots'),
(13, 6, 49778, 1, 'Worn Greatsword'),
(13, 6,   117, 5, 'Tough Jerky'),
(13, 6,   159, 5, 'Refreshing Spring Water'),
-- Mag'har Orc
(14, 6,    38, 1, 'Recruit''s Shirt'),
(14, 6,    39, 1, 'Recruit''s Pants'),
(14, 6,    40, 1, 'Recruit''s Boots'),
(14, 6, 49778, 1, 'Worn Greatsword'),
(14, 6,   117, 5, 'Tough Jerky'),
(14, 6,   159, 5, 'Refreshing Spring Water');


-- ---------------------------------------------------------------------------
--  3. Action bar -- normalized to the stock 7-button Death Knight layout
--
--  Buttons 0-5 are identical across all ten stock races:
--      0  6603   Attack          3  45462  Plague Strike
--      1  49576  Death Grip      4  45902  Blood Strike
--      2  45477  Icy Touch       5  47541  Death Coil
--
--  Button 10 carries the race's own active racial. This follows the majority
--  stock convention -- races 2-8 and 11 all use button 10; Human (11) and
--  Blood Elf (6) are the two outliers and are not copied here.
--
--  NOTE: before this file, the four custom races had only four buttons
--  (0, 1, 4, 5) and no racial in any slot -- on ANY class, not just DK.
--  Adding a racial button here is therefore NEW behavior for them, adopted by
--  explicit decision, not a restoration of previous parity.
--
--  Racial choices:
--    Goblin      69041  Rocket Barrage    -- chosen over Rocket Jump (69070),
--                                            whose momentum-loss bug is still
--                                            open; a default bar is the wrong
--                                            place for a known-broken ability
--    Worgen      68992  Darkflight        -- its only active
--    High Elf   110007  Quel'dorei Meditation (DK variant; 110005 is the
--                                            non-DK version, ClassMask 1503,
--                                            which excludes class 6)
--    Mag'har    110001  Ancestral Call    -- its only active
-- ---------------------------------------------------------------------------
DELETE FROM `playercreateinfo_action` WHERE `class` = 6 AND `race` IN (9, 12, 13, 14);

INSERT INTO `playercreateinfo_action` (`race`, `class`, `button`, `action`, `type`) VALUES
-- Goblin
( 9, 6,  0,   6603, 0),
( 9, 6,  1,  49576, 0),
( 9, 6,  2,  45477, 0),
( 9, 6,  3,  45462, 0),
( 9, 6,  4,  45902, 0),
( 9, 6,  5,  47541, 0),
( 9, 6, 10,  69041, 0),
-- Worgen
(12, 6,  0,   6603, 0),
(12, 6,  1,  49576, 0),
(12, 6,  2,  45477, 0),
(12, 6,  3,  45462, 0),
(12, 6,  4,  45902, 0),
(12, 6,  5,  47541, 0),
(12, 6, 10,  68992, 0),
-- High Elf
(13, 6,  0,   6603, 0),
(13, 6,  1,  49576, 0),
(13, 6,  2,  45477, 0),
(13, 6,  3,  45462, 0),
(13, 6,  4,  45902, 0),
(13, 6,  5,  47541, 0),
(13, 6, 10, 110007, 0),
-- Mag'har Orc
(14, 6,  0,   6603, 0),
(14, 6,  1,  49576, 0),
(14, 6,  2,  45477, 0),
(14, 6,  3,  45462, 0),
(14, 6,  4,  45902, 0),
(14, 6,  5,  47541, 0),
(14, 6, 10, 110001, 0);

-- ~Moonlit Team
