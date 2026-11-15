#!/bin/bash
# newgame.sh TAG : boot the built ROM, play through the intro (daytime clock) and save st/TAG_field.dst + .png
# Run from the repo root. Needs tools/canvas/setup_env.sh (and faketime: apt install faketime).
set -e
T=$1; D=$(dirname "$0"); mkdir -p st
export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/faketime/libfaketime.so.1 FAKETIME="@2026-11-14 13:00:00" DONT_FAKE_MONOTONIC=1
python3 $D/step.py - st/${T}_t.dst A w100 A w100 A w100 A w100 A w100 A w100 A w100 A w100 START w200 >/dev/null 2>&1
python3 $D/auto.py st/${T}_t.dst st/${T}_a.dst 120 1000 x >/dev/null 2>&1
python3 $D/step.py st/${T}_a.dst st/${T}_b0.dst t:128:152 w60 >/dev/null 2>&1
python3 $D/auto.py st/${T}_b0.dst st/${T}_b.dst 130 1000 x >/dev/null 2>&1
python3 $D/step.py st/${T}_b.dst st/${T}_field.dst w900 s:${T}_field >/dev/null 2>&1
