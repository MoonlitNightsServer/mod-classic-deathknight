-- ===========================================================================
--  MOONLIT NIGHTS -- Death Knight: remove dead starting-item strip rows
-- ===========================================================================
--  Every boot logged 56 lines:
--      Item 34666 specified to be removed from original create info not found in dbc!
--      Item 34667 specified to be removed from original create info not found in dbc!
--
--  The message is misleading. Both items DO exist in Item.dbc. AzerothCore
--  emits it when a negative playercreateinfo_item row names an item that is
--  absent from that race/class/gender CharStartOutfit entry -- the removal has
--  nothing to remove.
--
--  There are 14 Death Knight races x 2 genders = 28 combinations, and each
--  item produced exactly 28 errors, so neither appears in ANY Death Knight
--  starting outfit. The rows have never done anything.
--
--  34656 (Acherus Knight's Legplates) logs no error, so it IS in the outfit
--  and its strip row is kept.
--  ~Moonlit Team
-- ===========================================================================

DELETE FROM `playercreateinfo_item`
 WHERE `class` = 6
   AND `amount` < 0
   AND `itemid` IN (34666, 34667);