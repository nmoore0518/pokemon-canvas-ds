#!/usr/bin/env bash
# One-time setup for building Pokémon Canvas DS and testing it headless (Ubuntu 24.04).
#  - the DS compiler (metroskrew) is a 32-bit program: it needs i386 libc
#  - the yyjson wrap is pre-seeded from GitHub (wrapdb.mesonbuild.com may be unreachable)
#  - a headless DeSmuME (libdesmume + py-desmume) is built under tools/canvas/emu for ds_run.py
set -euo pipefail
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
dpkg --add-architecture i386
apt-get update -qq
apt-get install -y -qq libc6:i386 bison flex g++ gcc-arm-none-eabi make ninja-build pkg-config python3 xz-utils nasm libpng-dev \
  meson zlib1g-dev libpcap-dev libsoundtouch-dev libopenal-dev libglib2.0-dev libsdl2-dev python3-pil faketime

mkdir -p "$ROOT/subprojects/packagecache"; cd "$ROOT/subprojects/packagecache"
[ -f yyjson-0.12.0.tar.gz ] || curl -sSLo yyjson-0.12.0.tar.gz https://github.com/mesonbuild/wrapdb/releases/download/yyjson_0.12.0-1/yyjson-0.12.0.tar.gz
[ -f yyjson_0.12.0-1_patch.zip ] || curl -sSLo yyjson_0.12.0-1_patch.zip https://github.com/mesonbuild/wrapdb/releases/download/yyjson_0.12.0-1/yyjson_0.12.0-1_patch.zip

EMU="$ROOT/tools/canvas/emu"
if [ ! -f "$EMU/py-desmume/desmume/libdesmume.so" ]; then
  mkdir -p "$EMU"; cd "$EMU"
  [ -d py-desmume ] || git clone -q --depth 1 https://github.com/SkyTemple/py-desmume
  cd py-desmume; rm -rf desmume_src; git init -q desmume_src; cd desmume_src
  git remote add origin https://github.com/SkyTemple/desmume.git
  git fetch -q --depth 1 origin 42ee6ea4c93416d1d77ddb2906f3a596ea8065ba && git checkout -q FETCH_HEAD   # the commit py-desmume pins
  cd desmume/src/frontend/interface && meson setup build --buildtype=release >/dev/null && ninja -C build >/dev/null
  cp build/libdesmume.so "$EMU/py-desmume/desmume/"
fi
echo "ready: make -j16, then python3 tools/canvas/ds_run.py build/heartgold.us/pokeheartgold.us.nds out/boot"
