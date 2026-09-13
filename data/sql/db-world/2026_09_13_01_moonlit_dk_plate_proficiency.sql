-- ===========================================================================
--  MOONLIT NIGHTS -- Death Knight plate proficiency at level 1
-- ===========================================================================
--  PROBLEM
--
--  mod-classic-deathknight removes plate from Death Knight character creation:
--        DELETE FROM playercreateinfo_skills
--         WHERE classMask = 32 AND skill IN (129, 762, 293);
--  ...and re-grants it later from C++ (ApplyProgression) with:
--        player->SetSkill(SKILL_PLATE_MAIL, 0, 1, player->GetMaxSkillValueForLevel());
--
--  That path is broken in two ways, both confirmed live on this realm:
--    1. GetMaxSkillValueForLevel() returns the WEAPON skill cap (275 at level
--       55). Every other armor proficiency on the same character is 1/1;
--       plate came out 1/275.
--    2. SetSkill() grants the SKILL but not the proficiency SPELL. Characters
--       had 8737 (Mail), 9077 (Leather) and 9078 (Cloth) but no 750 (Plate
--       Mail), so the spellbook showed no plate proficiency at all.
--
--  A creation-time grant produces both halves correctly, which is why the
--  other three armor types were fine.
--
--  FIX
--
--  Phase 1's "All Classes" rework already grants plate at level 1 via
--  playercreateinfo_skills, at skill 293 / classMask 3 (Warrior + Paladin).
--  Death Knight (bit 32) was simply never included. Adding it makes the row
--  exactly symmetrical with the existing Mail row (skill 413, classMask 35 =
--  Warrior + Paladin + Death Knight).
--
--  Written as a bitwise OR rather than a literal 3 -> 35 so it stays correct
--  if Phase 1's mask is ever changed independently.
--
--  SIDE EFFECT, AND IT IS THE POINT: once plate is granted at creation,
--  ApplyProgression's guard
--        if (level >= plateLevel && !player->HasSkill(SKILL_PLATE_MAIL))
--  is false from the first login, so the module's buggy SetSkill() call never
--  executes and the 1/275 malformation can no longer occur. The upstream bug
--  is neutralised without patching C++.
--
--  NOTE: the module's own DELETE targets classMask = 32 exactly. This row is
--  classMask 35, so that statement will not remove it on any future re-run.
--
--  NOTE: creation data affects NEW characters only. Death Knights created
--  before this file applies keep their 1/275 plate and missing spell 750 --
--  recreate test characters rather than debugging the old ones.
--  ~Moonlit Team
-- ===========================================================================

UPDATE `playercreateinfo_skills`
   SET `classMask` = `classMask` | 32,
       `comment`   = 'MNS All Classes rework (+Death Knight, Phase 1.5)'
 WHERE `skill` = 293
   AND `classMask` & 32 = 0;

-- ~Moonlit Team
