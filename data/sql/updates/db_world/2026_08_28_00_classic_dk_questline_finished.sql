-- Classic DK: consider the DK questline finished for every character
-- with no rewards (no XP, no items, no money, no honor, no title, no
-- faction, no talents, no arena points). The DK intro is fully skipped
-- (DKs start in racial zones at level 1), so the Scarlet Enclave chain
-- should never block a DK and should give nothing.
--
-- Special rules kept (separate, already in classic_dk_spell_progression):
--   * runeforge + Death Gate at 55 (ProvidedItemCount / trainer_spell)
--   * riding + Death Charger at 60 (classic_dk_spell_progression)
--   * Sigil of the Dark Rider mail at 55 (quest_template_addon RewardMailTemplateID)
--
-- Reversible: restore the reward fields and delete the rewarded rows.
-- Apply: worldserver module updater (fresh realms) or
-- relog (character_queststatus_rewarded is read at login).

-- 1) Strip all rewards from quest_template for the DK questline.
UPDATE quest_template
SET RewardMoney = 0,
    RewardMoneyDifficulty = 0,
    RewardItem1 = 0, RewardAmount1 = 0,
    RewardItem2 = 0, RewardAmount2 = 0,
    RewardItem3 = 0, RewardAmount3 = 0,
    RewardItem4 = 0, RewardAmount4 = 0,
    RewardChoiceItemID1 = 0, RewardChoiceItemQuantity1 = 0,
    RewardChoiceItemID2 = 0, RewardChoiceItemQuantity2 = 0,
    RewardChoiceItemID3 = 0, RewardChoiceItemQuantity3 = 0,
    RewardChoiceItemID4 = 0, RewardChoiceItemQuantity4 = 0,
    RewardChoiceItemID5 = 0, RewardChoiceItemQuantity5 = 0,
    RewardChoiceItemID6 = 0, RewardChoiceItemQuantity6 = 0,
    RewardSpell = 0, RewardDisplaySpell = 0,
    RewardHonor = 0, RewardKillHonor = 0,
    RewardTitle = 0, RewardTalents = 0, RewardArenaPoints = 0,
    RewardFactionID1 = 0, RewardFactionValue1 = 0, RewardFactionOverride1 = 0,
    RewardFactionID2 = 0, RewardFactionValue2 = 0, RewardFactionOverride2 = 0,
    RewardFactionID3 = 0, RewardFactionValue3 = 0, RewardFactionOverride3 = 0,
    RewardFactionID4 = 0, RewardFactionValue4 = 0, RewardFactionOverride4 = 0,
    RewardFactionID5 = 0, RewardFactionValue5 = 0, RewardFactionOverride5 = 0,
    RewardXPDifficulty = 0
WHERE id IN (12593,12619,12641,12670,12687,12706,12714,12715,12716,12720,12722,12723,12724,12725,12727,12738,12739,12740,12741,12742,12743,12744,12745,12746,12747,12748,12749,12750,12751,12754,12755,12756,12757,12779,12800,12801,13188,13189);

-- 2) Mark the whole DK questline as rewarded for every existing character
--    (so a DK who skipped the intro is never blocked by the chain).
--    active = 1 per AzerothCore character_queststatus_rewarded semantics.
DELETE FROM character_queststatus_rewarded
WHERE quest IN (12593,12619,12641,12670,12687,12706,12714,12715,12716,12720,12722,12723,12724,12725,12727,12738,12739,12740,12741,12742,12743,12744,12745,12746,12747,12748,12749,12750,12751,12754,12755,12756,12757,12779,12800,12801,13188,13189);

INSERT INTO character_queststatus_rewarded (guid, quest, active)
SELECT c.guid, q.id, 1
FROM characters c
CROSS JOIN (
    SELECT 12593 AS id UNION ALL SELECT 12619 UNION ALL SELECT 12641 UNION ALL SELECT 12670 UNION ALL
    SELECT 12687 UNION ALL SELECT 12706 UNION ALL SELECT 12714 UNION ALL SELECT 12715 UNION ALL
    SELECT 12716 UNION ALL SELECT 12720 UNION ALL SELECT 12722 UNION ALL
    SELECT 12723 UNION ALL SELECT 12724 UNION ALL SELECT 12725 UNION ALL
    SELECT 12727 UNION ALL SELECT 12738 UNION ALL SELECT 12739 UNION ALL
    SELECT 12740 UNION ALL SELECT 12741 UNION ALL SELECT 12742 UNION ALL
    SELECT 12743 UNION ALL SELECT 12744 UNION ALL SELECT 12745 UNION ALL
    SELECT 12746 UNION ALL SELECT 12747 UNION ALL SELECT 12748 UNION ALL
    SELECT 12749 UNION ALL SELECT 12750 UNION ALL SELECT 12751 UNION ALL
    SELECT 12754 UNION ALL SELECT 12755 UNION ALL SELECT 12756 UNION ALL
    SELECT 12757 UNION ALL SELECT 12779 UNION ALL SELECT 12800 UNION ALL
    SELECT 12801 UNION ALL SELECT 13188 UNION ALL SELECT 13189
) q;
