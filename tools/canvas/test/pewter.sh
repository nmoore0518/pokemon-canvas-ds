#!/bin/bash
# pewter.sh TAG : after forest.sh TAG (st/TAG_f7.dst, at the forest's south door): through Viridian Forest, its north
# gate and the top of Route 2 into Pewter City (st/TAG_w*.png). POSADDR: the player's square in the field state.
set -e
T=$1; D=$(dirname "$0"); export ROM=${ROM:-build/canvas_test.nds}
export POSADDR=${POSADDR:-0x227d6f0}
OUT=st/${T}_w1.dst python3 $D/tour.py st/${T}_f7.dst ${T}w mMAP_VIRIDIAN_FOREST g12,17 >/dev/null 2>&1
python3 $D/step.py st/${T}_w1.dst st/${T}_w2.dst hUP:60 w200 s:${T}_w2 hUP:400 w200 s:${T}_w3 >/dev/null 2>&1
OUT=st/${T}_w4.dst python3 $D/tour.py st/${T}_w2.dst ${T}w g1041,118 >/dev/null 2>&1
python3 $D/step.py st/${T}_w4.dst st/${T}_w5.dst w60 s:${T}_w5 >/dev/null 2>&1
# east to the road out of town: the Gym guide stops you and walks you to the Gym; then in to Brock
OUT=st/${T}_w6.dst python3 $D/tour.py st/${T}_w5.dst ${T}w g1075,103 >/dev/null 2>&1
python3 $D/step.py st/${T}_w6.dst st/${T}_w7.dst hRIGHT:20 w60 s:${T}_w7 A w100 A w100 A w100 s:${T}_w8 w400 s:${T}_w9 w400 s:${T}_w10 \
    A w100 A w100 A w100 w300 s:${T}_w11 hUP:40 w300 s:${T}_w12 >/dev/null 2>&1
