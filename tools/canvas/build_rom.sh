#!/usr/bin/env bash
# Build Pokemon Canvas DS: the decomp ROM (maps, our data), then hg-engine on top of it.
#   tools/canvas/build_rom.sh        -> build/canvas.nds
set -euo pipefail
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT"
make rom -j"$(nproc)"
engine/.venv/bin/python tools/canvas/check_code_layout.py build/heartgold.us/pokeheartgold.us.nds
python3 tools/canvas/build_map_headers.py   # our maps past HeartGold's 540, handed to the engine
cp tools/canvas/data/canvas_trainers.h tools/canvas/data/canvas_trainer_order.h engine/data/   # (port/trainers.py)
cp build/heartgold.us/pokeheartgold.us.nds engine/rom.nds
make -C engine ROM_TOOL=tools/ndstool -j"$(nproc)"
cp engine/test.nds build/canvas.nds
echo "built build/canvas.nds"
