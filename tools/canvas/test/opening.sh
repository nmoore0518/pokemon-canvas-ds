#!/bin/bash
# opening.sh TAG : new game -> Oak stops you at Route 1 -> lab (names the rival) -> leaves st/TAG_lab.dst
# Run from the repo root (ROM=build/canvas.nds by default).
set -e
T=$1; D=$(dirname "$0"); export ROM=${ROM:-build/canvas.nds}
bash $D/newgame.sh $T
OUT=st/${T}_n.dst python3 $D/tour.py st/${T}_field.dst $T g1040,355 >/dev/null 2>&1
python3 $D/mv.py st/${T}_n.dst st/${T}_o.dst ${T}_1 U1 w60 A w100 A w100 A w100 A w100 A w100 A w200 A w300 A w300 A w300 A w300 A w300 A w300 A w300 s >/dev/null 2>&1
python3 $D/mv.py st/${T}_o.dst st/${T}_lab.dst ${T}_2 A A A START w30 A w200 s A w100 A w200 A w200 A w200 A w200 A w200 A w200 A w200 s >/dev/null 2>&1
# the type menu at the Poke Ball shelf (Grass), Bulbasaur, no nickname
python3 $D/mv.py st/${T}_lab.dst st/${T}_m.dst ${T}_3 B w30 B w30 D1 R3 U1 A w60 A w100 w100 s >/dev/null 2>&1
python3 $D/step.py st/${T}_m.dst st/${T}_s.dst w60 DOWN DOWN DOWN DOWN s:${T}_menu A w120 A w100 A w100 A w100 A w150 A w150 A w200 A w200 A w200 B w300 A w150 A w150 A w150 A w200 A w200 A w200 >/dev/null 2>&1
# walk to the door: the rival's battle (Vine Whip until it's over), then on to the gym
OUT=st/${T}_b.dst python3 $D/tour.py st/${T}_s.dst ${T}b mMAP_PALLET_TOWN_OAKS_LAB g6,9 >/dev/null 2>&1
R="t:128:90 w40 t:64:105 w900"
python3 $D/step.py st/${T}_b.dst st/${T}_gym.dst w300 $R $R $R $R $R $R A w300 A w300 A w300 A w300 A w300 A w300 A w300 A w300 A w300 A w300 w300 s:${T}_gym >/dev/null 2>&1
