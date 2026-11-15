#!/usr/bin/env bash
# Build Pokemon Canvas DS: the decomp ROM (maps, our data), then hg-engine on top of it.
#   tools/canvas/build_rom.sh        -> build/canvas.nds
set -euo pipefail
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT"
make rom -j"$(nproc)"
engine/.venv/bin/python tools/canvas/check_code_layout.py build/heartgold.us/pokeheartgold.us.nds
cp build/heartgold.us/pokeheartgold.us.nds engine/rom.nds
make -C engine ROM_TOOL=tools/ndstool -j"$(nproc)"
cp engine/test.nds build/canvas.nds
echo "built build/canvas.nds"
