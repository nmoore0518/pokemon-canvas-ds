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
python3 tools/canvas/build_caves.py  # then the caves we model from the GBA layouts (Mt. Moon's three floors)
python3 tools/canvas/port/port_map.py  # then the GBA game's people, signs, text and scripts onto all of them
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
New maps get ids of their own past HeartGold's 540 (`slots.new_map`; defines between the canvas markers in
`include/constants/maps.h`, headers in `src/data/map_headers_canvas.h`). Their headers can't go in the ARM9, so
`build_map_headers.py` compiles them with the decomp's compiler (checking HeartGold's own table compiles to the
bytes in the ARM9) into `engine/data/canvas_map_headers.bin`, which goes into a/0/2/8 as member 21; our engine
patch (`tools/canvas/engine/patches`) hooks `MapNumberBoundsCheck` so that one of our ids has its header copied
into the spare `MAP_UNUSED` entry, through a small cache. Map ids are 16-bit, so there's room for thousands.
(The first rooms used HeartGold's unused slots instead; those stay where they are.) hg-engine is free-use only
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
bottom of each face, plain wall colour above and on the caps), HeartGold's gym statues, HeartGold's Pokemon Center PC for
the gym PCs, and doorways in the walls (open for now; the GBA game opens them at run time). Oak's rooms and the
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

## Viridian Gym

Our spin-tile maze from the GBA, in HeartGold's Viridian Gym slot. GBA spin/stop tiles become HeartGold's own
slide tiles (behaviours 0x40-0x43, stop 0x4D), which HeartGold uses in its Viridian Gym: they need the Viridian
gymmick running (HeartGold's map-load script for the gym starts it, so the gym keeps its scripts) and the floor
flags 0x0600 on the squares you slide over. The partitions are solid blocks (`blocks` in `gba_look`).
Decals sit one unit above the floor: model positions are whole units, so half a unit lands in the floor.

## Scripts, people and text (the port)

`tools/canvas/port/port_map.py <GBA map>` brings a GBA map's people, signs, text and scripts over to its
HeartGold map (table `MAPS`: the slot and how GBA squares map to it). It replaces HeartGold's script file,
map-script header, event header and message bank for that map, and copies in whatever shared scripts it uses.
Commands it can't translate yet stay as `// TODO(gba)` comments and are listed in `build/canvas_port_report.txt`;
a person or sign whose script reaches one says "(Canvas DS: this part of the game isn't ported yet.)" instead of
half-running, and scenes on the frame table are left out until they're complete.
Text: `\p` -> new box (`\r`), `\l` -> scroll (`\f`), `{PLAYER}`/`{RIVAL}` -> string buffers 6/7.
Flags and vars: the GBA game's own are numbered in `tools/canvas/data/canvas_ids.json` (keep: saves depend on the
numbers) as flags 0x2000+ and vars 0x5000+. The engine patch hooks HeartGold's flag/var lookups so those live in
our part of the save (`engine/src/canvas_flags.c`), and every ordinary command works with them.
See STORY.md for where the story is going.

Run the porter after the map generators (build_pallet/rooms/clones/kanto), since those rewrite the events it fills.
What else it does:
- **Specials** (the GBA game's C functions) are written as HeartGold script in `port/specials.py` wherever they're
  small (the starter table, the rival's choice, Pokedex counts...). Ones that need the engine come later.
- **Trainers**: `port/trainers.py` turns the GBA party files into hg-engine trainer entries from id 738 on
  (`tools/canvas/data/canvas_trainers.h`, copied into `engine/data` by build_rom.sh; ids kept in
  `canvas_trainers.json`): the rival's 108 teams (every rival battle picks his team for that stage by
  `VAR_RIVAL_TYPE`), then the 624 others. Classes map to HeartGold's (by gender where it has both; leaders and the
  Elite Four by name: HeartGold has no Lorelei or Agatha picture, stand-ins for now); Pokemon without moves listed
  get the last four they'd have learned; the GBA's own Eeveelutions are Eevee until we add them as species. A
  trainer whose script is just the battle and a line after uses HeartGold's own trainer script (`std_trainer`),
  with sight; their intro/defeat/after lines go in the trainer data. Others battle from their own script.
  Our trainers' defeated flags live in our flags from 3072 on (`engine/src/canvas_flags.c` hooks
  TrainerFlagCheck/Set/Clear); hg-engine's trainer script table (`data/scr_seq/scr_seq_00953_trainerscript.s`)
  runs to 1599. (Trainer 740 can't have sight: 739 is HeartGold's approach script. It's a rival team.)
  In maps with HeartGold's layout, trainers, item balls and cuttable trees take HeartGold's own spots
  (trainers with its facing and sight).
- **Menus**: the GBA's scrolling multichoice becomes HeartGold's top-screen list (as wide as its longest item),
  in pages of 6 with "More…".
- **The rival** is our own hg-engine trainer class (`TRAINERCLASS_CANVAS_RIVAL`, 138): Blue's battle picture, the
  class name "Rival", and the name the player gave him; in the overworld he's Blue's sprite.
- **Capitals**: names the GBA text writes in capitals (PALLET TOWN, HOT AIR BALLOON) come out as HeartGold writes
  them (Pallet Town, Hot Air Balloon); a few acronyms (PC, TM, HP...) stay.
- **New game**: the GBA's new-game flags (EventScript_ResetAllMapFlagsFrlg) are set the first time Pallet loads.
- **Maps with HeartGold's own layout** (Viridian, Route 1, the Viridian Mart...): `Anchored` in port_map.py places the GBA's
  people by landmarks seen in both games (doors, exits), weighted by distance, then on the nearest open square;
  signs and cuttable trees go where HeartGold has its own. HeartGold's original events for such a map are kept in
  `tools/canvas/data/hg_events` (its hidden items stay).
- **Unported parts**: a person or sign runs until it reaches something not ported yet, then says so (`_cv_stop`);
  scenes on the frame table and trigger squares are held back whole (they'd only start over and over).
- **HeartGold rules the porter follows**: map scripts (on load/transition) can't touch the special vars 0x8000-0x800D
  (it asserts), so they use temp vars 0x4010-0x401D; people whose look is a var use sprites 101-116 (VAR_OBJ_0-15:
  the decomp's SPRITE_VAR_n names are off by one).
- **Engine commands** (208, ours from 100): flags/vars 100-105, `CanvasMart` 106 (a shop with a given list),
  `CanvasBufferMsg` 107 (a message into a string slot).
- **Items HeartGold doesn't have** (Oak's Parcel, the balloon...) are carried as flags until we add the items.
- **Trigger squares** (coord events) come over; HeartGold doesn't respawn a removed person when their flag clears,
  so the porter shows them again itself.
- **The rival is named** the first time he speaks (HeartGold's intro only names the player).
- **Message banks 829-853 belong to hg-engine** (it lays its own text over them): our own banks start at 854.
- **Walks redone for HeartGold's layout** (`MOVES` in port_map.py): where a GBA scene walks you somewhere (Pewter's
  guides lead you to the Gym and the Museum), the walk is HeartGold's shortest path there (`path`, `lead`), not
  the GBA's steps. A `fixed` square can be `None` (a GBA trigger HeartGold's layout has no place for).
- **Lines built in C** (`gStringVar4`): the special that picks one sets a temp var to its number (`Port.str4`) and
  `msgbox gStringVar4` shows the one picked (`_cv_str4`). Used for the mentors' lines (`specials.MENTOR_TEXTS`,
  read from `src/gym_candidate.c`).
- **hg-engine's own items, Pokemon and moves** (Bottle Cap...) go into scripts by number.
- **Not yet**: the Guest Leader challenges after each badge (GymCandidate_*: Brock's badge, TM and gifts work, then
  "not ported yet"), type tutors, the painter's loft in Pewter (her paintings), the Museum's second floor, in-game
  trades, the fossil pictures.
- **Split maps**: a GBA map HeartGold splits in two (Route 2) gets two `MAPS` entries, `Map#part`, each with a
  test for which squares it takes.
- **Testing**: a savestate made with an older build can't be used with a new one (the game keeps the ROM's file
  table from boot), so tests start from a new game: `tools/canvas/test/opening.sh TAG` plays from the title
  screen through Oak, the lab, the type choice and the rival battle.

## Caves

HeartGold's Mt. Moon is one small floor; the GBA game's is three. `build_caves.py` models each floor from its GBA
layout in HeartGold's cave look, built the way HeartGold builds its own caves (`bmdview.py` reads a map model's
geometry, `texview.py` shows a texture set, `landview.py` renders lands to a PNG without the game):
- rock rises from the floor in tiers a block high, by rings of rock (two tiers; one where the wall is thin):
  each tier's face is HeartGold's profile (it leans back two thirds of a block while rising, then a lip back to
  the whole block), textured `dwall_n/e/s/w` by where the rock is; corners are mitred along the diagonal;
- above the second tier, the rim (`dcliff01_r`: light at the edge, fading to the dark), then the dark; a tier's
  top and anything the faces leave open is `dcliff01`; the floor (`droad01`) has its darker edge (`droad01_r`)
  along the foot of every wall;
- little patches of rock out on the floor (the GBA's rock piles) are HeartGold's boulder (`d_rock01`), stood up;
- HeartGold's ladder models (69 up, 70 down) on squares of behaviour 0x3C/0x3E; cave mouths 0x6E (north), 0x6F
  (south), 0x6C/0x6D (east/west); HeartGold's cave floor (0x0A08, wild Pokemon).
- **Polygons**: the DS draws 2048 a frame, people included; a cave drawn square by square leaves none for them
  (they vanish). Flat pieces are drawn in runs, straight faces as one strip.
Floors bigger than a land span a matrix of lands. They are maps of our own (`MAP_CANVAS_MT_MOON_*`) with the header
of HeartGold's Mt. Moon (its wild Pokemon for now); the doors on Route 3 and Route 4 into HeartGold's Mt. Moon lead
into ours, and HeartGold's own (with Mt. Moon Square) is left alone.

The rest of Kanto's caves are built the same way (`CAVES` in `build_caves.py`): Rock Tunnel, Diglett's Cave (its
two entrance rooms too), Victory Road, Cerulean Cave and the Seafoam Islands, each with the header of HeartGold's
cave of that name (wild Pokemon, music) but Mt. Moon's look (area 70). Water you surf is HeartGold's cave water
(behaviour 0x15, `driver`); a floor is dark until Flash only where the GBA's is (Rock Tunnel). HeartGold has no
Route 23: its League reception gate leads into our Victory Road 1F, and Victory Road 2F's way out is the Plateau.
Not yet: Victory Road's and Seafoam's boulder switches and currents, ledges inside a floor.

**Big NARCs**: once a NARC has 1000 members, hg-engine's unpacker names them `2_0003` while its rules copy `2_003` in;
our `engine/tools/narcpy.py` packs members by number (the newer of two wins), or the scripts come out shuffled and
the game stops at the first map it loads.

**Cliffs outside** (Pallet's plateaus and terraces, `build_pallet.py`) use the same HeartGold profile: the face
slopes back across the rim square (`wall01_g`/`wall01_h`); the terraces down to the shore are two such tiers.

## Rules for every map we build (from Nick's review of Pallet)

- cave walls and cliffs: HeartGold's own textures and profile (`dwall_*` faces that lean back with a lip, the
  `dcliff01_r` rim, `droad01_r` floor edges in caves; `wall01_g/h` outside), never flat upright walls; no black
  triangles or holes where faces meet (check with `landview.py`); rocks are HeartGold's boulders, not walls

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


## The rest of Kanto (towns, routes, the rooms HeartGold has)

Maps that keep HeartGold's layout get the GBA game's people by landmarks worked out in `port/auto_anchor.py`: a
GBA warp to a room pairs with HeartGold's warp to that room's HeartGold map (`DEST` in `port_map.py`), and each GBA
connection pairs the middle of the open GBA edge with the middle of HeartGold's open border to that map. `Auto`
maps keep their people on their own part of the world; a GBA route HeartGold splits in two (Route 10, Route 16)
ports into both halves (`on_map`). Pokemon Centers and Marts share one set of landmarks (`center`, `mart`). Cut
trees go where HeartGold has its own; one HeartGold has no place for is left out (it could close a road).
Places HeartGold has no building for (the GBA's Pokemon Tower, Silph Co.'s upper floors, the S.S. Anne, the Rocket
Hideout, Cinnabar's Gym, Lab and Mansion, the Hotel, the hack's own halls...) aren't reachable yet; their doors
pair with the nearest HeartGold building for placing people.
`test/shots.py LIST DIR` takes a screenshot per place from one ROM (it points the new-game location in RAM);
`test/places.py` writes the list.

## Plan

1. Toolchain + headless emulator (done)
2. First playable slice: our Pallet Town layout, new game starts there (done)
3. Foundation: Gen 1-9 species, Fairy, newer moves/abilities/mechanics, Terastal, sprites (hg-engine; in)
4. Canvas systems one at a time (gym leader mode, type tutors, Academy + market, TCG, Pit, ...);
   Safari Zones and the gym leader convention are left out for now
5. Kanto story maps, then the region-unlock framework
