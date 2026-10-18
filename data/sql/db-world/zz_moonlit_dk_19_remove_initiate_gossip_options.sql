-- ===========================================================================
--  MOONLIT NIGHTS -- remove the guard gossip options that pointed at the Initiate trainers
-- ===========================================================================
--  The module added one "where is the Death Knight trainer" option to each
--  capital's stock guard menu, each marking a map point (POI 910009-910016).
--  Those points and trainers are gone (zz_moonlit_dk_18), so the options would
--  only log "non-existing ActionPoiID" at startup and lead nowhere.
--  ~Moonlit Nights Team
-- ===========================================================================

DELETE FROM `gossip_menu_option` WHERE `ActionPoiID` BETWEEN 910000 AND 910099;
