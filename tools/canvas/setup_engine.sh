#!/usr/bin/env bash
# Fetch hg-engine (BluRosie/hg-engine) at the pinned commit into engine/ and build its tools.
# hg-engine supplies the battle engine and the Gen 5-9 Pokemon, moves, abilities and sprites; it patches the ROM
# that the decomp builds (see tools/canvas/build_rom.sh). Our changes to it live in tools/canvas/engine/patches.
set -euo pipefail
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
COMMIT=dbb321327c59b821507f9fc4cb6c41d45a9d2698
E="$ROOT/engine"
apt-get install -y -qq python3-pandas python3-yaml python3-pil python3-venv cmake build-essential autoconf automake >/dev/null || true
if [ ! -d "$E/.git" ]; then
  git init -q "$E"; git -C "$E" remote add origin https://github.com/BluRosie/hg-engine
fi
git -C "$E" fetch -q --depth 1 origin $COMMIT && git -C "$E" checkout -q -f FETCH_HEAD
git -C "$E" submodule update --init --depth 1
for p in "$ROOT"/tools/canvas/engine/patches/*.patch; do [ -e "$p" ] && git -C "$E" apply "$p"; done
# python: system packages plus ndspy (PyPI may be unreachable, so take it from GitHub)
if [ ! -f "$E/.venv/bin/activate" ]; then
  python3 -m venv --system-site-packages "$E/.venv"
  T=$(mktemp -d); git clone -q --depth 1 --branch v4.1.0 https://github.com/RoadrunnerWMC/ndspy "$T/ndspy"
  cp -r "$T/ndspy/ndspy" "$("$E/.venv/bin/python" -c 'import site; print(site.getsitepackages()[0])')/"
fi
# its tools (one at a time: building them in parallel races)
make -C "$E" ROM_TOOL=tools/ndstool tools/ndstool tools/armips
echo "engine ready"
