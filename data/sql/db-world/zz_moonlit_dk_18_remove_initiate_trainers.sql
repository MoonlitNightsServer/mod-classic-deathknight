-- ===========================================================================
--  MOONLIT NIGHTS -- remove the "Death Knight Initiate" trainer NPCs
-- ===========================================================================
--  Every class now learns its trainer spells automatically at the trainer's
--  required level (mod-learn-spells, Moonlit fork: one rule for all ten
--  classes, Death Knights included), so the 17 module-owned trainer NPCs in
--  the starting zones and capitals are not needed.
--
--  Removed: creature spawns, default-trainer links, models and templates for
--  creatures 910000-910016 (module-owned, foreign-reserved range), their
--  gossip menus and npc_text 910100-910107, and points of interest
--  910009-910016.
--
--  NOT removed: trainer 130 and its trainer_spell rows. They are the Death
--  Knight level curve that Learn Spells reads, and the module's own
--  progression rows refer to the same spells.
--  ~Moonlit Nights Team
-- ===========================================================================

DELETE FROM `creature_addon` WHERE `guid` IN (SELECT `guid` FROM `creature` WHERE `id` BETWEEN 910000 AND 910099);
DELETE FROM `creature` WHERE `id` BETWEEN 910000 AND 910099;
DELETE FROM `creature_default_trainer` WHERE `CreatureId` BETWEEN 910000 AND 910099;
DELETE FROM `creature_template_model` WHERE `CreatureID` BETWEEN 910000 AND 910099;
DELETE FROM `creature_template` WHERE `entry` BETWEEN 910000 AND 910099;
DELETE FROM `gossip_menu_option` WHERE `MenuID` BETWEEN 910100 AND 910107;
DELETE FROM `gossip_menu` WHERE `MenuID` BETWEEN 910100 AND 910107;
DELETE FROM `npc_text` WHERE `ID` BETWEEN 910100 AND 910107;
DELETE FROM `points_of_interest` WHERE `ID` BETWEEN 910000 AND 910099;
