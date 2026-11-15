#!/bin/bash
# to_viridian.sh TAG (ROM=a test ROM without Pallet's triggers: test/no_triggers.py ROM OUT 46)
# new game -> Route 1 -> through the gate -> Viridian: st/$1_vir.png
set -e
T=$1; D=tools/canvas/test
bash $D/newgame.sh $T >/dev/null 2>&1
OUT=st/${T}_r1.dst python3 $D/tour.py st/${T}_field.dst $T g1036,290 >/dev/null 2>&1
python3 $D/step.py st/${T}_r1.dst st/${T}_vir.dst hUP:900 w200 s:${T}_vir >/dev/null 2>&1
