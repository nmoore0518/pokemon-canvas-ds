#!/bin/bash
# parcel.sh TAG : after opening.sh TAG (st/TAG_gym.dst): win the battle, Oak's gym scene, Route 1 to the Viridian Mart
# (Oak's Parcel), back to the lab and Oak's Pokedex scene. Shots: st/TAG_p*.png. Use the no-encounter test ROM.
set -e
T=$1; D=$(dirname "$0"); export ROM=${ROM:-build/canvas_test.nds}
R="t:128:90 w60 t:64:105 w1000"
A=$(for i in $(seq 1 60); do printf "A w250 "; done)
python3 $D/step.py st/${T}_gym.dst st/${T}_p1.dst $R $R $R $R $R $R $R $A B w100 B w100 s:${T}_p1 >/dev/null 2>&1
python3 $D/step.py st/${T}_p1.dst st/${T}_p2.dst hDOWN:60 w300 s:${T}_p2 >/dev/null 2>&1
OUT=st/${T}_p3.dst python3 $D/tour.py st/${T}_p2.dst ${T}p g1036,290 >/dev/null 2>&1
python3 $D/step.py st/${T}_p3.dst st/${T}_p4.dst hUP:900 w200 s:${T}_p4 >/dev/null 2>&1
OUT=st/${T}_p5.dst python3 $D/tour.py st/${T}_p4.dst ${T}p g1042,254 >/dev/null 2>&1
python3 $D/step.py st/${T}_p5.dst st/${T}_p6.dst hUP:20 w300 A w200 A w200 A w200 A w200 A w200 A w200 A w300 A w200 A w200 s:${T}_p6 >/dev/null 2>&1
# back to Pallet with the parcel: out of the Mart, south through the gate, into the lab, talk to Oak
python3 $D/step.py st/${T}_p6.dst st/${T}_p7.dst A w200 B w200 hDOWN:40 w300 hDOWN:30 w300 >/dev/null 2>&1
OUT=st/${T}_p8.dst python3 $D/tour.py st/${T}_p7.dst ${T}p g1036,279 >/dev/null 2>&1
python3 $D/step.py st/${T}_p8.dst st/${T}_p9.dst hDOWN:900 w200 >/dev/null 2>&1
OUT=st/${T}_p10.dst NOEXIT=1 python3 $D/tour.py st/${T}_p9.dst ${T}p 2 >/dev/null 2>&1
A=$(for i in $(seq 1 14); do printf "A w300 "; done)
python3 $D/mv.py st/${T}_p10.dst st/${T}_p11.dst ${T}_dex U7 w60 $A s A w300 s A w300 s A w300 s A w300 s >/dev/null 2>&1
