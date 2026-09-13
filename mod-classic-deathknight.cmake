# ---------------------------------------------------------------------------
#  mod-classic-deathknight  --  Moonlit Nights fork
# ---------------------------------------------------------------------------
#  This file intentionally contains no build logic. It is kept, rather than
#  deleted, because what it used to contain matters.
#
#  1. REMOVED DEPENDENCY
#     Upstream shipped exactly one line here:
#         target_include_directories(modules PRIVATE
#             "${CMAKE_SOURCE_DIR}/modules/mod-individual-progression/src")
#     That made mod-individual-progression a hard COMPILE- and LINK-time
#     dependency, not the optional runtime one the catalogue implies -- the
#     GateAcherus config toggle does not remove it. That module is not
#     installed on this realm, so both of its API call sites are stubbed in
#     src/ClassicDeathKnight.cpp and the include is gone.
#
#  2. UPSTREAM ISSUES #1 AND #2 -- fixed, but NOT the way issue #1 proposes
#     Symptom: "SQL files did not import automatically." Root cause, read from
#     this core's own src/server/database/Updater/UpdateFetcher.cpp:
#
#         path = <source>/modules/<module>/data/sql/
#         for each IMMEDIATE subdirectory of that path:
#             dirName = subdirectory name                    // e.g. "db-world"
#             if (dirName.find(_dbModuleName) == npos)        // "world"
#                 continue;
#
#     The updater inspects only the immediate subdirectories of data/sql/, and
#     keeps only those whose NAME contains "world" / "characters" / "auth".
#     Upstream placed its SQL at data/sql/updates/db_world/, so the scanner
#     sees a directory named "updates", finds no "world" in it, skips it, and
#     never descends into db_world. The SQL is not misplaced by one level --
#     it is entirely invisible to the updater. That is why it has never
#     auto-applied for anyone.
#
#     Fix applied in this fork: the SQL was moved to data/sql/db-world/, the
#     canonical module path, which is what mod-uac and mod-worgoblin-high-elf
#     already use successfully on this realm. AzerothCore then applies it
#     natively at worldserver boot, with no CMake step required at all.
#
#     Deliberately NOT using issue #1's suggested workaround:
#         file(COPY "${CMAKE_CURRENT_LIST_DIR}/data/sql/updates/db_world/"
#              DESTINATION "${CMAKE_SOURCE_DIR}/data/sql/updates/db_world/")
#     That copies two dozen module SQL files into the CORE repository's tracked
#     source tree on every configure, and registers them as core updates rather
#     than module updates. It makes the symptom go away by putting the module's
#     data somewhere it does not belong.
#  ~Moonlit Team
# ---------------------------------------------------------------------------
