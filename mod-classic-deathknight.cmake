# ---------------------------------------------------------------------------
#  mod-classic-deathknight  --  Moonlit Nights fork
# ---------------------------------------------------------------------------
#  Upstream shipped exactly one line in this file: a target_include_directories
#  adding mod-individual-progression/src to the include path. That module is
#  NOT installed on this server, which made the dependency a hard compile- and
#  link-time requirement rather than the optional one the catalogue implied.
#  The two places its API was used have been stubbed out in
#  src/ClassicDeathKnight.cpp, so the include is no longer needed.
#
#  Replaced with the SQL-copy step upstream is missing entirely. Without it,
#  data/sql/updates/db_world/ never reaches the core's own updater path and
#  none of this module's SQL is ever applied -- the root cause of upstream
#  issues #1 and #2, both still open. Fix is the one from issue #1.
#  ~Moonlit Team
# ---------------------------------------------------------------------------

file(COPY "${CMAKE_CURRENT_LIST_DIR}/data/sql/updates/db_world/"
     DESTINATION "${CMAKE_SOURCE_DIR}/data/sql/updates/db_world/")
