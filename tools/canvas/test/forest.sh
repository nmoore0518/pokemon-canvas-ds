#!/bin/bash
# forest.sh TAG : after parcel.sh TAG (st/TAG_p11.dst, Pokedex in hand): out of the lab, up Route 1, through Viridian,
# up Route 2 and into Viridian Forest (st/TAG_f*.png). Use a ROM with trainers (test/no_encounters.py --keep-trainers).
set -e
T=$1; D=$(dirname "$0"); export ROM=${ROM:-build/canvas_tr.nds}
A=$(for i in $(seq 1 42); do printf "A w300 "; done)
python3 $D/step.py st/${T}_p11.dst st/${T}_f1.dst $A B w100 B w100 hDOWN:200 w300 s:${T}_f1 >/dev/null 2>&1
OUT=st/${T}_f2.dst python3 $D/tour.py st/${T}_f1.dst ${T}f g1036,290 >/dev/null 2>&1
python3 $D/step.py st/${T}_f2.dst st/${T}_f3.dst hUP:900 w200 >/dev/null 2>&1
OUT=st/${T}_f4.dst python3 $D/tour.py st/${T}_f3.dst ${T}f g1030,217 >/dev/null 2>&1
python3 $D/step.py st/${T}_f4.dst st/${T}_f5.dst hUP:60 w200 s:${T}_f5 >/dev/null 2>&1
OUT=st/${T}_f6.dst python3 $D/tour.py st/${T}_f5.dst ${T}f g1034,193 >/dev/null 2>&1
python3 $D/step.py st/${T}_f6.dst st/${T}_f7.dst hUP:600 w300 s:${T}_f7 >/dev/null 2>&1
