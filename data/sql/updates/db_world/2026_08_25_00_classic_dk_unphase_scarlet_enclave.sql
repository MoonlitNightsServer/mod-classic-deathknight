-- Classic DK: disable Scarlet Enclave phasing so the phased Plaguelands are
-- not hidden from classic DKs who skip the DK intro.
--
-- The Scarlet Enclave (area 4298) uses spell_area phase-shift auras gated by
-- the DK starting quest chain (12687 -> 12779). On a realm that skips the
-- DK intro (DKs start in racial zones via classic_dk_spawn.sql), these auras
-- still phase out the eastern Plaguelands for any DK who visits the area,
-- hiding Blood of Heroes (GO 176213, phaseMask 1) and other normal-phase
-- content from the very players the intro was meant to fast-track.
--
-- Removing the 8 quest-gated spell_area entries disables the DK
-- phase progression in the Scarlet Enclave, so the area renders in normal
-- phase (phaseMask 1) for everyone. Blood of Heroes and the rest
-- of the eastern Plaguelands become visible/interactable for classic DKs.
--
-- The two quest_start = 0 (always-on) auras are intentionally left alone:
--   51852 The Eye of Acherus, 51915 Undying Resolve (quest-effect auras
--   applied to everyone in the area, not phase shifts; separate concern).
--
-- Reversible: re-insert the rows below to restore the phased DK intro.
-- Apply: worldserver module updater (fresh realms) or
-- .reload spell_area on a running worldserver (live realm).

DELETE FROM `spell_area`
WHERE `area` = 4298
  AND `spell` IN (52693, 52597, 52598, 52707, 52950, 53081, 53107, 53405)
  AND `quest_start` > 0;
