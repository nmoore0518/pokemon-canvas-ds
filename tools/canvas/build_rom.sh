#!/usr/bin/env bash
# Build Pokemon Canvas DS: the decomp ROM (maps, our data), then hg-engine on top of it.
#   tools/canvas/build_rom.sh        -> build/canvas.nds
set -euo pipefail
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT"
make rom -j"$(nproc)"
engine/.venv/bin/python tools/canvas/check_code_layout.py build/heartgold.us/pokeheartgold.us.nds
python3 tools/canvas/build_map_headers.py   # our maps past HeartGold's 540, handed to the engine
cp tools/canvas/data/canvas_trainers.h tools/canvas/data/canvas_trainer_order.h tools/canvas/data/canvas_variants.h tools/canvas/data/canvas_cries.h tools/canvas/data/canvas_challengers.h engine/data/   # (port/trainers.py, build_rooms.py, build_species.py, port/challengers.py)
cp build/heartgold.us/pokeheartgold.us.nds engine/rom.nds
# the engine's sprite rules follow its species list (ours come after Pecharunt: build_species.py)
(cd engine && .venv/bin/python scripts/reformat_sprite_data.py build_pokegra.mk && { cmp -s build_pokegra.mk data/graphics/pokegra.mk || cp build_pokegra.mk data/graphics/pokegra.mk; } && rm -f build_pokegra.mk)
mkdir -p engine/build/narc     # (a fresh engine checkout lacks it, and its NARC rules write there)
make -C engine ROM_TOOL=tools/ndstool -j"$(nproc)"
cp engine/test.nds build/canvas.nds
echo "built build/canvas.nds"
