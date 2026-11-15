# Pokémon Canvas DS

Pokémon Canvas (the FireRed-based gym-leader game, `nmoore0518/gym-trainer-hack`) rebuilt on the
HeartGold decompilation. This fork tracks `pret/pokeheartgold`.

## Build and test

```
sudo tools/canvas/setup_env.sh       # once: 32-bit libc for the DS compiler, build deps, headless DeSmuME
sudo tools/canvas/setup_engine.sh    # once: hg-engine (battle engine, Gen 5-9 Pokemon) into engine/
python3 tools/canvas/build_pallet.py # regenerate our Pallet Town into the game's data files (idempotent)
python3 tools/canvas/build_rooms.py  # then the rooms we model from the GBA layouts (houses, lab)
python3 tools/canvas/build_clones.py # then the rooms that borrow a HeartGold room (Pokemon Center, Mart, Training Hall)
tools/canvas/build_rom.sh            # decomp ROM, then hg-engine on top -> build/canvas.nds
tools/canvas/test/newgame.sh t1      # boot headless, play the intro, save st/t1_field.dst (+ .png)
python3 tools/canvas/test/walk.py st/t1_field.dst - tour R5 U6 s   # walk by tiles, screenshots -> st_tour.png
```

`make` (rather than `make rom`) also compares against the retail checksums, which Canvas changes are expected to fail.

## Two stages: decomp + hg-engine

The decomp builds HeartGold with our maps and data; `engine/` (BluRosie/hg-engine at a pinned commit, our changes
as patches in `tools/canvas/engine/patches`) then patches in the modern battle engine, Pokemon through Gen 9,
moves, abilities, items and sprites. hg-engine hooks HeartGold's code at fixed addresses, so the decomp's code must
keep its retail layout: change data in place, put new code in the engine (`check_code_layout.py` enforces this,
comparing decompressed sizes, since the compressed ARM9 changes size with any data change).
New maps reuse HeartGold's unused map slots rather than growing the header table. hg-engine is free-use only
(no money, no donations) and its CREDITS.md must be carried into ours.
If `engine/build` is wiped, `touch engine/data/learnsets/learnsets.json` before rebuilding.

## Our Pallet Town

`tools/canvas/build_pallet.py` turns the GBA layout (`tools/canvas/data/pallet_layout.json`) into four HeartGold map
blocks at overworld matrix cells (31..33, 11..12) (the GBA map sits 27 blocks in, so its centre road meets Route 1): collision, height data (BDHC), a terrain model built from
Pallet's own texture set, HeartGold building models placed on our doors, HeartGold's waterfall model
stretched over our falls, and our Chansey statue (pedestal + the GBA art standing up like HeartGold's trees). It also adds recoloured copies of
Kanto's red house (blue, green, purple), the models our town uses to Pallet's building set, and their textures to
the set's shared texture file (`a/0/7/0`). Things learned the hard way:

- the field loads building models from `a/0/4/0` (the `fielddata/build_model` copy is not the one used), with
  one entry per model in `a/1/0/7`, and binds them to the per-set textures in `a/0/7/0`, matched by name
- a land's terrain model must stay under ~61 KB (flat ground is merged into rectangles to get there)
- materials need their texture size filled in, or every texel samples the same spot
- the DS file system's tables are read at boot, so a savestate from before a data change is no good after it
- map texture animations are bound to materials by index, not name: Pallet's area animation scrolls materials
  0..7, so those slots are placeholders (only slot 4, sea_un, is used) or the ground scrolls

## Interiors

`tools/canvas/slots.py` says which HeartGold map slot each GBA map lives in. Rooms with a matching HeartGold slot
(Red's house, Blue's house, Oak's lab) take it over; others get an unused slot (`MAP_FIGHT_AREA_UNUSED_*`) with a
header copied from a template room and an events/matrix file of our own appended to the archives.
`build_rooms.py` models a room from its GBA layout: HeartGold floor/wall textures, furniture from HeartGold's room
models (tables in the script, by GBA metatile id), GBA warps, collision and behaviours (stairs, PC, TV, exit mats).
`build_clones.py` gives rooms that look the same in both games (Pokemon Center, Mart, Training Hall) a copy of a
HeartGold room, wired to our doors. GBA lets you leave from any square of a doormat; HeartGold only from an exit-mat
square, so all of them are made exit mats.
Rooms HeartGold has nothing like (the basement) are drawn in the GBA art (`gba_look` in `build_rooms.py`): the GBA
wall rows on the wall, the plain floor tile on the floor, floor marks as flat decals, and each object folded into a
solid from its picture: a profile says which rows are top surface (laid flat) and which are faces (stood up, 1.3x
tall since the camera looks down), with sides in the face's edge colours and a soft shadow underneath. The room
gets its own texture set and area entry so no other room pays for its textures.

## The Pallet Gym

Built in GBA art like the basement, with solid walls joined all the way round (the GBA wall-base tile along the
bottom of each face, plain wall colour above and on the caps), HeartGold's gym statues, the gym PCs folded into
solids, and doorways in the walls (open for now; the GBA game opens them at run time). Oak's rooms and the
expansions, by kinds of POKeMON caught (Nick's design):

| caught | what you get |
|---|---|
| 50 | the main hall gets bigger (25 -> 31 wide) |
| 100 | the back room (as on the GBA) |
| 150 | the back room gets bigger (17x15 -> 21x17) |
| 200 | the left room |
| 250 | the left room gets bigger |
| 300 | the right room |
| 350 | the right room gets bigger |

Each size is its own map (`widen` in `build_rooms.py` repeats columns/rows and moves the events with them;
slots in `slots.py`); the door scripts, when the GBA scripts come over, send you to the size you've earned.

## Rules for every map we build (from Nick's review of Pallet)

- stairs: HeartGold's striped `slope` ramp, about three steps per block of height, with a low rail down each side;
  never a texture slot that animates
- waterfalls: use HeartGold's animated waterfall models (`dsm_fal1` etc.), scaled to fit, with water behind them
- HeartGold's trees lean back over roughly a block behind them: leave an extra walkable row before a tree line
  wherever the GBA map has people walking right up to it (fields, paths along the edge)
- keep paths between features centred, and line exits up with the neighbouring map's path (move our map if needed)
- don't leave two signs side by side; carry over decorations like the Chansey statue rather than dropping them
- our own GBA art gets dimension: fold it into top surfaces and faces (with sides and a shadow), never a flat card;
  Pokemon statues use HeartGold's own overworld sprite of that Pokemon (hg-engine has one for every species in
  `a/0/8/1`), enlarged and recoloured to stone or gold (`STATUE_FINISH`), standing like HeartGold's people


## Plan

1. Toolchain + headless emulator (done)
2. First playable slice: our Pallet Town layout, new game starts there (done)
3. Foundation: Gen 1-9 species, Fairy, newer moves/abilities/mechanics, Terastal, sprites (hg-engine; in)
4. Canvas systems one at a time (gym leader mode, type tutors, Academy + market, TCG, Pit, ...);
   Safari Zones and the gym leader convention are left out for now
5. Kanto story maps, then the region-unlock framework
