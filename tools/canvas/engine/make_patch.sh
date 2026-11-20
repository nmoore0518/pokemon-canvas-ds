#!/usr/bin/env bash
# Write our changes to hg-engine (the engine/ checkout, as tools/canvas/setup_engine.sh leaves it plus edits)
# back into tools/canvas/engine/patches/0001-canvas.patch.
#   tools/canvas/engine/make_patch.sh
# Only the paths below go in: the rest of what differs in engine/ is made at build time (build_rom.sh copies our
# data headers into engine/data and regenerates data/graphics/pokegra.mk). A new file or folder of ours must be
# listed here. (data/Encounters.c and data/canvas_encounters.h: build_encounters.py makes them.)
set -euo pipefail
ROOT=$(cd "$(dirname "$0")/../../.." && pwd)
cd "$ROOT/engine"
SPECIES="odeon assasseon hypereon poiseon subterraneon obsideon lenneon appariteon automateon valyreon"   # build_species.py
PATHS="Makefile narcs.mk rom.ld armips/include/constants.s data/codetables.mk data/Trainers.c data/text/730.txt data/text/731.txt
 data/graphics/trainer_gfx data/graphics/overworlds/custom data/scr_seq hooks include src tools/source/trainerdatagen tools/narcpy.py
 data/Species.c data/BabyMons.c data/BaseExperienceTable.c data/Evolutions.c data/FollowerProperties.c data/HeightTable.c
 data/HiddenAbilityTable.c data/IconPaletteTable.c data/SpeciesToOWFormFemale.c data/SpriteOffsets.c data/learnsets/learnsets.json"
for s in $SPECIES; do PATHS="$PATHS data/graphics/sprites/$s"; done
git add -N $PATHS 2>/dev/null || true        # (new files show in a diff only once git knows of them)
git diff --binary -- $PATHS > "$ROOT/tools/canvas/engine/patches/0001-canvas.patch"
git apply --check -R "$ROOT/tools/canvas/engine/patches/0001-canvas.patch"
echo "wrote tools/canvas/engine/patches/0001-canvas.patch ($(wc -c < "$ROOT/tools/canvas/engine/patches/0001-canvas.patch") bytes)"
