#!/bin/bash
# mtmoon.sh TAG : after pewter.sh TAG's walk into town (st/TAG_w5.dst): along Route 3 into Mt. Moon (our three
# floors) and round them (st/TAG_m*.png). Use a test ROM without Pewter's guide trigger
# (no_triggers.py ... 48), or he walks you to the Gym.
set -e
T=$1; D=$(dirname "$0"); export ROM=${ROM:-build/canvas_test.nds}
export POSADDR=${POSADDR:-0x227d6f0}
OUT=st/${T}_m1.dst python3 $D/tour.py st/${T}_w5.dst ${T}m g1080,103 g1120,104 g1172,103 >/dev/null 2>&1
python3 $D/step.py st/${T}_m1.dst st/${T}_m2.dst hUP:30 w300 s:${T}_m2 >/dev/null 2>&1
# 1F: to the first ladder down (5,6) and down it; B1F; back up; then the far ladders
OUT=st/${T}_m3.dst python3 $D/tour.py st/${T}_m2.dst ${T}m mMAP_CANVAS_MT_MOON_1F g18,30 g10,20 g5,7 >/dev/null 2>&1
python3 $D/step.py st/${T}_m3.dst st/${T}_m4.dst hUP:30 w300 s:${T}_m4 >/dev/null 2>&1
