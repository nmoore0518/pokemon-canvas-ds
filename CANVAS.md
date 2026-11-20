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
python3 tools/canvas/port/barriers.py  # first: the squares scripts open and close (data/barriers.json, our overworlds)
python3 tools/canvas/build_caves.py  # then the caves we model from the GBA layouts (Mt. Moon, Rock Tunnel, ...)
python3 tools/canvas/build_interiors.py  # then the big GBA-only interiors (Pokemon Tower, Silph Co., S.S. Anne, ...)
python3 tools/canvas/build_cinnabar.py   # then our Cinnabar Island (the GBA town in place of HeartGold's ruin)
python3 tools/canvas/build_overworld.py  # then the rest of Kanto's towns and routes on the GBA's layouts
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
  0..7, so those slots are placeholders (only slot 4, sea_un, is used) or the ground scrolls. The area data's
  third half-word is the animation (a member of `a/1/4/0`, 0xFFFF none); every builder must hold those slots
  (the caves' areas scroll 0..4, the Safari Zone's 0..7)

## Left out for good (`tools/canvas/scrapped.py`)

The Exotic Pokemon Safari (STORY.md) is not in the port at all, and the GBA hack gets no more work (Nick), so it is
cut on the way in: the GBA's maps are read without the way into it and its sign (`clean`: Fuchsia's door, the last
of its warps, so no other warp moves), Fuchsia's sign square is ground (`LAYOUT_EDITS`), and its scripts as the
porter reads them lose what points at it (`SOURCE_EDITS`: the AIDE's EXOTIC SAFARI topic, the lines about it in the
Johto letter and Oak's every-type speech). Its hall, its flags and its map id are gone.

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

**People on the furniture**: the GBA seats people on its sofas (the Fan Club); HeartGold's sofa stands taller than
a person, so a sofa someone sits on is HeartGold's low seats instead. A bed a square wide (the Medical Center's)
is HeartGold's bed drawn narrower (a prop's scale), and one with a Pokemon in it sunk to its mattress, so the
Pokemon lies on top rather than inside it.

**Real assets first; draw only what HeartGold has nothing for** (Nick, the interior pass: rooms looked flat and
unfinished, the Celadon old man's house empty). Every room built as a house (`build_rooms.build_room`: the small
houses, and the rooms `build_interiors.py` builds in the `room` / `labroom` looks, each with an area of its own from
200 and, when it has GBA art, a texture set at the same number) is furnished in three steps:
- **HeartGold's room models by patch** (`furnish.py RULES`, by GBA tileset): a rule names the metatiles one kind of
  thing is drawn with; each connected patch of them is one thing, sized to the patch - a GBA table 3x2 is
  HeartGold's `table02_3` (tables 1-4 by 1-3, tiled for bigger), a row of bookcases one every so many squares, a row
  of pot plants a plant over each pot, chairs and crates one a square. A patch reaching into the wall rows stands
  against the wall in the first floor row (those squares closed; the porter moves people off them). Rugs are
  HeartGold's rug textures over the patch, windows its window on the wall, pictures and maps hung on it. The older
  `FURNITURE` table (by top-left metatile) still serves Pallet's rooms.
- **the GBA's own art where no rule has a model** (`build_rooms.gba_art`): a closed patch out on the floor is its
  picture folded into a solid (a top, then a face standing up: the Medical Center's curtains, the Fan Club's fish
  tanks, a wheelchair); a picture in the wall rows that isn't plain wall (a sign, a poster, a door, a blackboard) is
  laid on HeartGold's wall at its height there; a walkable patch in metatiles of its own whose colour isn't the
  floor's (a battle mat, a carpet; not the floor's own darker boards) is laid flat on the floor.
- a door in a house look's back wall (a warp square up in the wall rows) doesn't make that row floor: the wall's art
  shows it.
Kit looks take the same rules (`furnish.KIT`, with `up` = how many of a patch's top rows are the GBA's wall) when
their kit says `furnish`.

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
  get the last four they'd have learned; the GBA's own Eeveelutions are species of ours (below). A
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

## People's sprites

`SPRITE` in `port/port_map.py` gives each of the GBA's people HeartGold's nearest person (checked side by side
with HeartGold's own pictures: Misty is HeartGold's `GSLEADER11`, Erika `GSLEADER12`, Blaine `GSLEADER15`; a Biker
its bald biker, `BADMAN`; a Beauty its blonde `WOMAN2`). Where HeartGold has no one like them (a chef), the GBA's own
picture is an overworld of ours (`port/barriers.py PEOPLE`, written after the barriers': each 16x32 frame stood in a
32x32 one, in HeartGold's person layout - its waiter's frame names, so the walking works as theirs), and the porter
reads its tag from `data/custom_people.json`.

## Squares the scripts change (`port/barriers.py`, the porter, `engine/src/canvas_boulders.c`)

The GBA game opens and closes ways with `setmetatile`: Silph Co.'s card-key doors, the Pokemon Mansion's switch
barriers, the Rocket Hideout's barriers, the Cinnabar Gym's quiz doors, Victory Road's rock walls. HeartGold has no
command that changes a map's square, so:
- a square the scripts that can run on its map make both closed and open (the layout's own state counting as one)
  is a **barrier square**. It is built open (`gba_map.Layout` applies `data/barriers.json`: the open metatile, no
  collision) and closed by an object standing on it.
- the object on a front square (nothing closed south of it) is the barrier's own picture: the GBA metatiles the
  closing script puts there and above, standing up, 32x32, as an overworld of our own (engine
  `data/graphics/overworlds/custom/0002..`, a scroll's settings: still, no shadow; Silph's side-on doors use its
  front-on picture). Behind it, an invisible one (`0001`). Run `barriers.py` when the scripts change, then
  `tools/canvas/engine/make_patch.sh` (it rewrites the engine's overworld table and `MON_OVERWORLD_GFX_START`).
- each square has a flag of its own (`CV_BAR_<map>_<x>_<y>`), set while open: the object's flag. `setmetatile` on
  it becomes that flag plus `HidePerson`/`ShowPerson` (guarded, so a person is never shown twice); a sign on the
  square is the object's script (talking to the door is reading the GBA's sign there).
- on entering the map (OnTransition, before the objects are made) the flags start as the layout has them and a copy
  of the GBA's OnLoad that returns sets them as it would the squares; `VAR_CV_BARRIER_INIT` is 1 meanwhile, so no
  object is shown or hidden then.
- `special SetHiddenItemFlag` is `SetFlagVar 0x8004` (a `FLAG_` given as a value is our flag's number).
- a boulder: hg-engine's hook replaces the boulder-pushing task (ov01_021F1ECC) with the same steps and, where the
  boulder comes to rest on a coord event whose value is 0xB0B0..0xB0BF, runs that event's script with the boulder as
  the one talked to. The porter writes the GBA's boulder switches (`MB_STRENGTH_BUTTON` squares) as 0xB0B0 and its
  holes (`MB_MT_PYRE_HOLE`: Victory Road 3F's, Seafoam's) as 0xB0B1 with a script that takes the boulder away, sets
  its flag and clears the one below's (the flag the GBA keeps in its trainer type). No var ever holds those values,
  so walking on the square does nothing.
- not done this way: the Game Corner's hideout stairs (shown once the poster's switch is found; the stairs are
  always there), the League's doors and the Vermilion Gym's beams (HeartGold's own rooms).

Wild battles the GBA sets up (`setwildbattle`, then `dowildbattle` or `special BattleSetup_StartLegendaryBattle`)
are HeartGold's `WildBattle` (lose and you white out); `GetBattleOutcome` gives the GBA's numbers (caught 7, ran 4)
from HeartGold's outcome. Someone whose flag the script sets before the battle with `FLAG_SYS_CTRL_OBJ_DELETE` is
taken away after it (Snorlax).

## Our own species (the ten new Eeveelutions)

`build_species.py` adds the GBA game's Odeon, Assasseon, Hypereon, Poiseon, Subterraneon, Obsideon, Lenneon,
Appariteon, Automateon and Valyreon to hg-engine as its fakemon: `SPECIES_ODEON..` are
`MAX_CANONICAL_MON_NUM + 1..10` (1076-1085) with `NUM_OF_FAKEMONS 10`, so hg-engine's megas and forms all move up
ten. It is run once and its output lives in the engine patch (it is safe to run again; `engine/make_patch.sh`
writes the patch). What it writes, from the GBA repo's `canvas_families.h`, learnsets and `graphics/pokemon/`:
- stats, types, abilities (the hidden one in `HiddenAbilityTable.c`), dex text, level-up and teachable moves
  (level 0 = learned on evolving), base exp, and the small tables (baby = Eevee, heights, icon palette, sprite
  offsets, follower size);
- Eevee's evolutions: a method of ours, `EVO_LEVEL_HOLD_ITEM` (level up holding the type's item, any time of day;
  the item is used up, as on the GBA). They come first in Eevee's list, as the game takes the first that fits.
  `MAX_EVOS_PER_POKE` is 19 for it;
- cries: each borrows an Eeveelution's, as on the GBA (`canvas_cries.h`, read in `GrabCryNumSpeciesForm`), so
  the forms' cries stay where they are in the sound data;
- art: the GBA's 64x64 front (two frames) and back set in the DS's 80x80 frames, the back carrying the shiny
  palette; the icon on the nearest of the DS's three icon palettes; the overworld sprite (follower, and Penny's
  plush) is the front and back shrunk to the size of hg-engine's Eeveelutions. Those shrunk sprites are the
  weakest art: hg-engine's own are drawn for that size.
Not done: they aren't in the Pokedex's lists (hg-engine's dex data is laid out for exactly its 1075 species;
`NUM_OF_MONS` stays 1075), and their dex text is the GBA's four lines where the DS page shows three.
After a change to the species list, clear `engine/build` except `engine/build/sdat` (the converted cries) before
building: its sprite and form files are named by species number, and make only looks at dates.
Checked in the emulator: a wild Odeon, Valyreon's back, icon, summary and moves, and an Eevee holding a Dragon
Fang levelling up into Valyreon (the Fang gone afterwards).

## Caves

HeartGold's Mt. Moon is one small floor; the GBA game's is three. `build_caves.py` models each floor from its GBA
layout in HeartGold's cave look, built the way HeartGold builds its own caves (`bmdview.py` reads a map model's
geometry, `texview.py` shows a texture set, `landview.py` renders lands to a PNG without the game):
- rock rises from the floor in tiers a block high, by rings of rock, each tier built from the **tile kit**
  (below): square pieces that all meet one another, never stretched;
- **only whole pieces, never squeezed** (Nick): a face is one square deep and one block high, always. So a wall
  one square thick can only be a step between two floors a tier apart; the heights are real (below), and
  anything thinner than the pieces need is made thicker by doubling columns and rows of the GBA map
  (`cave_widen`: two squares between floors of the same height, n between floors n tiers apart; where the GBA
  has two elevations side by side with nothing between, the new squares are the cliff). People, items and ladders
  move with the squares (`cave_xy`, which the porter uses). A rock square higher than the squares on two opposite
  sides of it is lowered to a flat top (a wall three thick is a block with a pale top, as HeartGold's are).
- **heights** (`cave_heights`): the GBA's elevation where it uses it (3 the ground, 4 a tier up; water is got
  onto from 3), and its steps (metatiles 0x284/0x2B4, which climb a tier going north) where both ends have the
  same elevation (Mt. Moon B2F, Seafoam 1F). Rock is a tier higher each ring out from the lowest floor near it,
  for `RINGS` (3) tiers, then the rim, then the dark. Steps are HeartGold's `dslope`, a tier in a square; the
  heights walked on are in the land's BDHC (a plate a run, sloped on steps); ladders and people stand at their
  floor's height.
- only what can be reached from a ladder, a mouth or where someone stands is floor (the GBA leaves squares open
  in its borders);
- a face that stops against steps or against floor as high as its lip gets the wall's side there (`caps`, and
  the steps' own); an inside corner is HeartGold's own corner piece and has no top of its own (the pale squares
  that used to sit in corners were that top, drawn over the faces);
- **no gaps**: `holes.py`-style check: render the lands with `landview` on a magenta ground and look for
  enclosed magenta (a ladder down's square is one by design);
- above the second tier, the rim (`dcliff01_r`: light at the edge, fading to the dark), then the dark; a tier's
  top and anything the faces leave open is `dcliff01`; the floor (`droad01`) has its darker edge (`droad01_r`)
  along the foot of every wall;
- little patches of rock out on the floor (the GBA's rock piles) are HeartGold's rocks at HeartGold's sizes (read
  off Union Cave): the small one (half of `d_rock01s`) a square wide, the big one (`d_rock01`) over two squares
  side by side; one to a pile's square, none on a square whose rock to the south leans over it (a card a square
  made the ice crystals cut each other up);
- **the floor's darker border** (`droad01_r`) runs along every edge of the floor: the foot of a wall, the lip of
  a cliff, the water's bank, and round a corner of rock that pokes into it (the tile kit's border pieces, below);
- rock that lies level with the floor beside it is floor (a plateau is floor to its edge, not a paler tile);
- HeartGold's ladder models (69 up, 70 down) on squares of behaviour 0x3C/0x3E; cave mouths 0x6E (north), 0x6F
  (south), 0x6C/0x6D (east/west); HeartGold's cave floor (0x0A08, wild Pokemon).
- **Polygons**: the DS draws 2048 a frame, people included; a cave drawn square by square leaves none for them
  (they vanish). Flat pieces are drawn in runs, straight faces as one strip.

### The tile kit (`cave_kit.py`, laid by `build_caves.py`)
Every square of rock with lower ground in the 8 squares round it is one wall piece a tier high, chosen by which of
those squares are lower (`classify`):
- **straight** (one side lower): HeartGold's face (`PROFILE`, three bands leaning back, `dwall_n/e/s/w` by the
  side), drawn in runs as quad strips;
- **inside corner** (only the square cornerwise lower): HeartGold's own piece (`dwall_wn/ne/es/sw`), read out of
  Union Cave's lands at build time (`corner_pieces`, `SOURCES`);
- **outside corner** (two neighbouring sides lower): the straight face on each lower side, mitred along the
  diagonal (two triangles a side, cut at the profile's bands). HeartGold's outside corner is rounded and stands
  back from the square; drawn on our squares it left pale crosses, and a floor border that follows its curve
  needed more pictures than a texture set holds;
- **anything else**: laid by distance (`laid`): each point as far up the profile as it is from the nearest lower
  square, so it meets whatever is beside it. The water's bank is laid the same way (`BANK`).
- every piece has the profile along each side of its square, so any piece meets any other. All normals point up
  (HeartGold's walls carry none and are lit evenly; real normals made north faces dark).
- **the floor's border** (`droad01_r`'s left half is HeartGold's straight piece): a square against rock on one
  side is the straight piece, in runs; any other border square (rock on two or more sides, a corner of rock poking
  in) is a picture of its own, made from the straight piece by each texel's distance from the nearest rock
  (`border_texture`; past `BAND_END` = 16 texels it is the floor's own texture, in the border's colours). The rim
  above the top tier is done the same way from `dcliff01_r`. A border square has no floor under it (the DS cannot
  tell a unit's difference in depth and the two fought).
- those pictures go in **atlases** in the cave's texture set (`cv_border*`, `cv_rim*`): 16 texels wide, at most 512
  high (32 pieces each; wider or taller ones read wrongly on the DS), alike pieces sharing a cell. A first pass over
  every cave counts the pieces, then passes repeat until no new piece turns up, then the real pass. A HeartGold
  area's texture set must stay under 56 KB (asserted).
- **material order**: the cave areas share Union Cave's texture animation, which scrolls a land's materials 0..4
  by index (its river, river_r, sea_line02, sea_un, sea_on: `anim_slots` reads them from `a/1/4/0`), so those
  places are held by empty materials. Anything put there slides (the atlases there drew the wrong pieces, half a
  square out: the ice caves' pale blocks).
- **under it all**, the floor again, well below everything, in a few rectangles under the floor and the water:
  where pieces meet at a point along another's side the DS leaves a pixel open now and then, and the dark showed
  through as black dots. Not under rock: the rim's dark is open, and through it at a slant the floor underneath
  showed (Diglett's Cave). Dropped first (before a tier of rock) when a land is too big (Victory Road 1F).
- a land's model must stay under 61400 bytes (`CAVE_LIMIT`): a land too busy goes without the floor under it all,
  then with fewer tiers of rock (`RINGS` 3, 2, 1).
- ladders are behaviour 0x61 only; a hole (0x0F) is cut into its square (dark `d_ro` with floor round it);
  arrival squares are plain floor.
Floors bigger than a land span a matrix of lands. They are maps of our own (`MAP_CANVAS_MT_MOON_*`) with the header
of HeartGold's Mt. Moon (its wild Pokemon for now); the doors on Route 3 and Route 4 into HeartGold's Mt. Moon lead
into ours, and HeartGold's own (with Mt. Moon Square) is left alone.

The rest of Kanto's caves are built the same way (`CAVES` in `build_caves.py`): Rock Tunnel, Diglett's Cave (its
two entrance rooms too), Victory Road, Cerulean Cave and the Seafoam Islands, each with the header of HeartGold's
cave of that name (wild Pokemon, music) **and its look** (`AREAS`: HeartGold's caves share texture names across
their sets, so the area is all that changes): Rock Tunnel 83, Diglett's Cave 82 (brown earth), Cerulean Cave 73
(purple, crystals for boulders), the Seafoam Islands 104 (ice, HeartGold's lower floors), Mt. Moon and Victory
Road 70. Water you surf is HeartGold's cave water (behaviour 0x15, `driver`), half a block below its floor, with
HeartGold's bank round every edge of it (`BANK`, read off Union Cave: a lip on the land, then down into the
water), against walls as well as floor. A floor is dark until Flash
only where the GBA's is (Rock Tunnel). HeartGold has no
Route 23: its League reception gate leads into our Victory Road 1F, and Victory Road 2F's way out is the Plateau.
A square of no elevation between ground a tier up north of it and ground south of it is a flight of steps (Cerulean
Cave draws its steps in its own tileset, not with `STAIRS_MT`); without that, widening put a closed row between the
tiers and cut off half of Cerulean Cave.
Boulder switches and holes: see "Squares the scripts change". Not yet: Seafoam's currents (its lower floors' water
is calm water you surf anywhere - you need Surf to reach Seafoam, so nothing is cut off), ledges inside a floor.

**Big NARCs**: once a NARC has 1000 members, hg-engine's unpacker names them `2_0003` while its rules copy `2_003` in;
our `engine/tools/narcpy.py` packs members by number (the newer of two wins), or the scripts come out shuffled and
the game stops at the first map it loads.

**The VBlank task queue holds 64** (`src/system.c`; retail 32). The field loads 44 effect models as it starts and
each waits in that queue for its textures; how many wait at once depends on where the frames fall while the map
loads, and in Diglett's Cave the 33rd found it full: an assert, and the effect drawn as noise. A constant only,
so the code's layout is unchanged.

**Cliffs outside** (Pallet's plateaus and terraces, `build_pallet.py`) are the tile kit's (`route_kit`, as the
Safari Zone's): a piece to each square of cliff by which of the 8 squares round it are a tier lower - the straight
face, HeartGold's rounded outside corner and `wall01_d` inside corner, odd squares laid by distance; the face
`wall01_g`, its lip `wall01_h`, its foot the ground's (`wall01_h` on the road's sand). The terraces down to the
shore are two such tiers. A straight face that stops against something at its top's height shows that thing's
side above its profile (the ends of the bridge between the two gardens); against stairs, its own end.
**Pallet's bridge** between the two north gardens is the town's gateway, in brick and dressed stone (Fuchsia's,
`sek_fe01`/`sek_fe02`, brought into set 18; its deck the paving in a warm grey, `cv_deck`). Its deck is a block
above the gardens, with a flight of steps (four risers, brick side walls with a sloping coping) down into each:
level with the gardens, someone walking the road under it stood through the deck. Each face an arch over the road
springing from the piers high enough to clear them (27 over the road), a ring of voussoirs and a keystone standing
out of the brick, a string course along the deck, a parapet with a coping and a post every square, and a pier at
each end on the walls' line, with an impost under the springing, rising above the parapet, capped, with a stone
lantern's globe (`nib_stone`, set 17). Its faces lean back as HeartGold's cliffs do: from its camera a face
standing straight up is a line. The GBA's road ran both over and under it; HeartGold has no such bridge (a square
has one height, and none of HGSS's behaviours is the DPPt walk-under bridge), so the road keeps its way under it
and the bridge is to look at: its ends and its steps (a square of each garden) are closed.
**Pallet's water** is HeartGold's sea (its Pallet's and Route 21's): the clear layer (`sea_on`) half a block under
the ground, the water (`sea_un`) a unit under that, and from the land round it the bank (`pond_line`) and the
water's edge sloping under (`sea_line02`), laid by distance, straight sides in runs. `sea_un`, `sea_on` and
`sea_line02` sit in the area animation's places (4, 5, 3). Its road (`P`) has HeartGold's edge (`road01_r`) in the
grass beside it, as the Safari Zone's sand.

## Rules for every map we build (from Nick's review of Pallet)

**Build from a tile kit** (Nick, after the caves were rebuilt that way: all caves, and any map of ours in every
region, new or already built a different way): before laying a map, read the pieces HeartGold builds that kind of
place from out of its own lands (`bmdview.py`; `cave_kit.corner_pieces` reads Union Cave's), then lay the map a
square at a time from those pieces, each chosen by what is round its square. Every piece is whole (never
stretched, squeezed or warped) and has the same edge on every side, so any piece meets any other; where the GBA
layout is too tight for whole pieces, widen the map rather than squeeze a piece. Use HeartGold's own piece where
it has one, and make a piece only where it has none (from its own textures, in its own colours: the floor border's
corner pictures are drawn from its straight piece), and only as many as the texture set has room for (56 KB).
**Ground first, then what stands on it** (Nick, from the Safari Zone's paths): a square's ground is laid as the
GBA's ground under it (the bottom layer of its metatile: sand under a sign, a fence, a bush, a house), and its
things (signs, fences, bushes, trees, buildings) stand on that. A path never stops square at a thing standing on
it: it runs on underneath and ends with its own edge, as it does in the open.
Before checking a map in game: hold the area's animated material slots (`anim_slots`), check the model sizes
(61400) and the texture set's size, look for holes with `landview.py`, then look at it in game.

**Nothing stands over anything else** (Nick, from the caves: rocks over ladders): where two things overlap that
shouldn't - a rock and a ladder, a person and furniture, a sign and a door - one of them moves. In the caves a
rock pile by a ladder, a mouth or a person moves to open floor nearby (`floor_plan`); indoors the porter moves
people (`settle`, `clear_of`). Check for it in every map built from now on.

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

From Nick's review of the Kanto build (rooms, `build_rooms.py`):
- doormats (room models 1 and 3) stand a unit off the floor (`MAT_LIFT`), and every room's floor runs a quarter
  square past its last row under the mat's front: level with the floor, or hanging over the dark, the mat showed
  in two pieces
- a staircase down: the floor reaches right up to the stairs model (`STAIR_DOWN_RECT`, its footprint), never a
  hole of whole squares (that left a black border round it)
- HeartGold's models can be bigger than the GBA furniture they stand for (its TV is two squares wide to the GBA's
  one): check each room for models that overlap, and widen the room with a plain column where they do
  (`widen=dict(cols=[(col, n, plain_col)])`; the porter moves the room's people and warps into it to match)
- a GBA map script that changes a room's metatiles (a bookcase over stairs until the story opens them) becomes a
  room variant: the room's own land is drawn as the script first leaves it, a second land as it is once the flag
  is set, and the engine shows that one while the flag is set (`variant=` in ROOMS -> `canvas_variants.h`)
- GBA art that reaches up into the wall rows (the basement's hopper) is drawn once, on its card: the wall strip
  behind it carries on the wall from the nearest clear column
- HeartGold's wall furniture (kitchen, cupboard, TV, bookshelf, PC, machines) stands in the first floor row, where
  the GBA's stood in the wall rows with open floor in front: those squares are closed (you could walk into the
  sink), and the porter moves what the GBA had there (`room_furniture.json`, `off_furniture`): a sign on the
  furniture comes down onto its square, to be read from in front; a person steps one square forward
- nobody and nothing stands beside a model that is wider than its squares either (the TV reaches half a square
  each side): a plush next to it looked tucked under it
- a room that needs more floor than the GBA's gets plain columns and rows (`widen` with a list of squares to copy
  the blocks from, where no whole column is plain); people of ours placed on its new squares go in the porter's
  `PEOPLE` (Penny's house: twelve Eeveelution plushes left about the room, facing different ways, not lined up
  along the walls)
- a person's height is the floor's whatever its event says: something meant to sit on a table stands inside it
  (a chair's square works: the sprite hides the seat). Lines of ours for things the GBA has no script for go in
  the porter's `OWN_GBA`, in the GBA's notation, as stand-ins for Nick's own


## Big interiors HeartGold has no building for

`build_interiors.py` builds the Pokemon Tower, Silph Co.'s 2F-11F, the Power Plant and the S.S. Anne from their GBA
layouts the way caves are built, but as buildings in a HeartGold building's textures (`LOOKS`: the Sprout Tower's
for the Tower, the Power Plant's for Silph Co. and the Power Plant, the S.S. Aqua's for the ship): the floor, walls a
block and a half high round it, little blocked patches (tables, machines, gravestones) as low blocks, stairs and
pads drawn in `mark`. A way out at the foot of a wall is an exit mat (0x65); stairs and pads are step-on warps.
HeartGold's doors stand in for them: Lavender's Radio Tower is the Pokemon Tower, Silph Co.'s elevator door goes to
our 2F, Route 10's Power Plant is ours, and Vermilion's ferry building boards the S.S. Anne (its dock outside is
left out). Not yet: Silph Co.'s card-key doors, the GBA furniture.
The Rocket Hideout is under the Game Corner (stairs added where the GBA's hidden ones are: `ADD_WARPS`), built
from the interior tile kit (below), its spin tiles working. The Safari Zone's four areas are built from a tile kit of HeartGold's own
Safari Zone (below), behind a door added at the back of HeartGold's Pal Park entrance; its rest houses and the
Secret House (Surf) are rooms (`house`). Cinnabar's Gym, Lab, Mart and the Pokemon Mansion are rooms the same way.
**Cinnabar Island** (`build_cinnabar.py`): HeartGold's is the ruin after the eruption, so its land (205) is redrawn
from the GBA town: HeartGold's sand, grass, sea and sea rocks, and HeartGold building models on the GBA's doors
(Center, Mart, Gym; Oak's lab model for the Lab and the Mansion). HeartGold's buildings are wider than the GBA's
(its Lab reached into the Center), so the town is **widened** to 28x26: columns of copied ground put in at the
west shore and between the Lab and the Center, one at the east shore so it runs straight down past the Gym's
east wall (the GBA's Missingno. coast; the Center and Mart side by side as the GBA's, HeartGold's wider Mart
meeting that shore too), a beach along the top, three rows on the way between the Mansion and Gym and the Lab,
Center and Mart; one of the three sea columns west of it left out (`INS_COLS`, `DROP_COLS`, `INS_ROWS`; inserted
squares copy the GBA's beside them, its buildings and signs as open ground). Route 20's crag just off that shore
(a piece of HeartGold's volcano) is taken out of its land, its squares sea. A building's collision is its model's box (squares it covers more than a third of, to its door's
row), not the GBA's block; the GBA's signs are HeartGold's sign (29) where no building stands. The ground is
grass in the middle, a beach two squares wide round it (the south keeps the GBA's own beach running into the
grass), and between them HeartGold's road edge with the beach's sand in place of the road's (`cv_sand_r`, built
in set 18 by `build_pallet.py`: HeartGold has no beach-to-grass edge). Its warps are the GBA's, in order; the
porter places its people by `build_cinnabar.to_world`. (Movements aren't remapped: the scenes that walk people
across the town are Bill's Sevii trip, which the hack removed.)

### The interior tile kit (`interior_kit.py`: a look with a `kit`)

Big interiors are laid from **pieces of HeartGold's own rooms** (Nick: the tile kit, indoors too). A piece is every
polygon of a HeartGold land in a box of squares, clipped to the box (texture coordinates carried along, with its
material's repeat, flip and alpha), laid elsewhere unchanged; a kit names the land it cuts from (`src`) and its
floor height (`base`). The GBA map is read as `ship_parts` reads it (floor what can be reached, walls the closed
squares with the dark beyond, little closed patches inside rooms its things), then, ground first:
- floor under every square that is no wall, in runs (its texture mapping read off the kit's floor square);
- a wall square with floor south of it is HeartGold's wall face (its end piece where the wall stops beside floor;
  the GBA's wall art where the GBA has it - a vent is HeartGold's duct -, else its lights every `lit_every` squares);
  any other wall square is HeartGold's wall top. HeartGold's wall face stands three squares tall, so **a wall with
  floor right behind it** (a partition a square thick, or a maze's walls out in a room with no dark beside them)
  would hide that floor: those are low blocks (the kit's `block`), as the GBA draws them low;
- furniture by the GBA's metatiles (`things`: a piece of a HeartGold room, centred on the GBA's patch, or a model at
  its middle); anything else closed inside a room is the kit's `block`;
- stairs are HeartGold's own (a piece of its room, mirrored for the other side) in place of room models;
- the GBA's spin tiles are HeartGold's slide tiles (0x40-0x43, stop 0x4D, floor flags 0x0600 on the walkable
  squares) with the Viridian Gym's arrow (`to_j_i1`, turned by its texture coordinates; `to_j_mark` the stop),
  imported into the look's texture set (`IMPORTS`); their maps' map-load script runs `ViridianGymInit` (the
  porter's `GYMMICK_INIT`), which the slide tiles need;
- HeartGold's untextured polygons take the texel nearest their material's colour (`untextured`).
- pieces of furniture are cut whole (`whole`: every polygon whose middle is in the box, uncut: a desk cut square by
  square was twice the polygons); a kit can stand a thing up as a card (`each`: HeartGold's cave boulder for the
  Power Plant's rubble) or as a stone (a block with a texture's picture on top: a gravestone);
- a kit's furniture metatiles are furniture wherever they stand, against a wall too (`named`);
- a land must stay under 61400 bytes and about 1500 polygons: wall tops are drawn in runs where the kit's top is
  one flat polygon; pieces from other lands bring their texture set's textures (`IMPORTS`, palettes by the source
  model's own binding); HeartGold's indoor camera (type 4) for every kit floor.
The looks (each HeartGold's own place of that kind):
- **the Rocket Hideout**: Team Rocket HQ (area 64, its B1F, land 498): grey panelled walls with their lights and
  ducts, desks with monitors (B3F's), its potted plant (23) and blue machine (77) models, crates for the spin
  mazes' partitions (`low_inner`: a maze's walls out in a room are low);
- **the Pokemon Tower** (Nick: remade - the walls were off, the floor no native tile, the gravestones cubes):
  `tower_kit.py`, the GBA's octagon square by square in the Sprout Tower's look (area 120: its own texture set 77
  and building set; the tombstone picture brought in from the House of Memories' set). The Sprout Tower's boards
  for the floor; its purple panelled wall (`d15_wall01`, a panel to three squares, 64 high) wherever the floor meets
  the GBA's wall band or the dark - along the north and down both sides - its dark top over it, its shadow along
  the north wall's foot; nothing along the south, as HeartGold's rooms; a wall with any of the room north of it
  within three squares (the octagon stepping in toward the south) a kerb 8 high, so it never stands in front of the
  floor. **Gravestones stand up** (HeartGold's own lie flat - a slab with the picture on top): an arched stone a
  square wide, leaning back a little, the House of Memories' tombstone picture (`so_tomb02`) on its face, on a flat
  stone; 10 polygons each (the 7F's 104 graves fill a land). Every GBA grave is one (by metatile, `GRAVE_MT`, not
  by what is joined to a wall); the 7F's statues are the same stone twice as tall; the 1F's counter a low box.
  Stairs are the Sprout Tower's own ladders (66 up, 67 down in the field models: an area whose byte 6 is 1 places
  a/0/4/0's models, else a/1/4/8's rooms - the old tower's area drew them as shelves); its wall lamps (68) on the
  north wall every six squares. The walls are HeartGold's texture at HeartGold's own scale (a 32-texel panel over
  three squares and the wall's 64 units: the Sprout Tower's are as soft). The Sprout Tower's camera (0), not a
  house's (4). **Roomier** (Nick: the rooms looked much smaller than they should): plain columns before the GBA's
  5, 7, 14, 16 and rows before 5, 13, 14 (`tower_widen`: a grave or anything closed on one side only is cut with
  floor, so the graves' rows get aisles and nothing is doubled; clear of the stairs, the 5F's purifying ground, the
  2F rival's triggers). The porter redoes the scripted walks (`MOVES`: the 2F rival, the 7F grunts) and turns
  `getplayerxy` back into the GBA's squares on any widened map (`unwiden`), so the GBA's comparisons hold.
- **after build_interiors.py, run build_cinnabar, build_overworld and the porter** (the order at the top): it
  writes the interiors' headers with no scripts and their events bare, and the later steps fill them in. A build
  that stops after it ships interiors with no scripts.
- **Silph Co. 2F-11F**: HeartGold's offices, the Radio Tower's (land 462, its textures imported into Silph Co.'s
  set, area 39): its grey zigzag floor, cream wall with a window every few squares, its dark top (`top_solid`: one
  texel, however long the run; stretched, the top ran into the texture's grey), its desks and stairs; the lobby's
  (land 303) elevator door; the GBA's dark partition strips are walls wherever they stand (`wall_mt`); its plants,
  terminals, glass cabinets, meeting tables, pictures, crates and beds as HeartGold's models (`furnish.KIT`).
  (Cinnabar's Lab and Mart are rooms now: the `labroom` look.)
  **Roomier than the GBA's** (Nick: cramped; widths at HeartGold's, err bigger): each floor gets a new row or
  column at every line where one can go (`silph_widen`; up to twice the size; the porter moves everything with its
  square), and two rows just before a wall across the floor (HeartGold's wall hides the floor behind it). Each
  square of a new line is a copy of the floor beyond (a corridor longer) or of the wall (a wall deeper; a line
  that is mostly wall isn't put in: it would only thicken a partition), plain floor between two things; a table,
  a crate, a desk grows a line (HeartGold's models are laid to fit), and across, a terminal row or a cabinet too;
  never stairs, nor anything against a wall a row down. Through a card-key door the new square is wall where it
  would make a way round the door, else floor (shut in by the door's own squares). Where a new row crosses a new
  column the square is floor if either has floor (a wall run stays straight). A scripted walk is redone over the
  bigger floor (`port_map.rescaled`: each GBA step as many as its squares are apart now: the 7F rival's way to
  the warp pad, 11F Giovanni's); only the squares between someone and who they walk up to stay as the GBA's
  (`SILPH_SCENES`).
  **Walls**: a wall across the floor (floor north of it too: a partition) stands half as high (`partition`: its
  face cut down from HeartGold's, its top the light grey of HeartGold's wall top, `partition_top`), an office's
  partition, so it doesn't hide the room behind it; every wall's ends and sides are closed (`sides`: a column of
  the Radio Tower's wall texture down each side that has floor beside it, as its own rooms draw them); its windows
  only on a face two squares long. The GBA's walls drawn from above (its partition strips and their ends,
  `wall_mt`) are walls however thin. Warp pads are Saffron Gym's panel (`pad`, imported from its model) laid on
  the floor. A card-key door across an east-west way is seen edge on (`port/barriers.py edge_image`: a thin
  upright slab down the middle of the passage, each square its share), one across a north-south way face on.
- **the Power Plant and Cinnabar's Gym**: Route 10's Power Plant (area 44, land 367): stone tiles, a wall of
  machine cabinets; the GBA's rubble as Mt. Moon's boulder card, its coils as blocks of the generator's yellow;
- **the Pokemon Mansion**: the Burned Tower (area 78, land 449): charred plank walls (scorched now and then), its
  wooden floor, charred blocks for its rubble, the Sprout Tower's stairs; HeartGold's tables, plants and statue for
  the GBA's (`furnish.KIT`). Its walls are walls however deep (`tall_walls`: as low walls they lay flat on the floor).
- **the S.S. Anne inside** (not its deck): HeartGold's S.S. Aqua (area 42, land 643): its patterned carpet, cream
  walls with portholes, its cabin doors, HeartGold's ship furniture; a mat before each cabin's way in; the galley's
  counters as tables, its bins, the captain's bookcase, picture and chairs (`furnish.KIT`).
**Low walls**: a wall three or more squares deep with walkable floor along its north side (the S.S. Anne's block of
cabins, walked round on every side) would stand HeartGold's wall over that walkway: it is a low wall instead, the
kit's top a little off the floor with its faces round it.
Silph Co.'s elevator is its own small room (last in `INTERIORS`); the porter turns the GBA's floor list
(`SCROLL_LISTS`) into a HeartGold menu and `setdynamicwarp` into HeartGold's `SetDynamicWarp` to that floor's
elevator door (`dynamic_warp`); the room's way out is HeartGold's dynamic warp (header 4095, anchor 256: the floor
chosen, or back where you came in). HeartGold's 1F's elevator door leads in. The Celadon Department Store's
elevator keeps HeartGold's own script (its floors are HeartGold's).
Not yet: Silph Co.'s card-key doors (they stand open: the GBA's map scripts close them), the Mansion's statue
switches (they change walls).

### How a big interior is drawn now (`build_ship_floor`, from the S.S. Anne redo)

Nick: Gen 4 graphics like the rest of the game, with the GBA's layout, style and things in the GBA's places (not
the GBA's own tile art: that was tried for the S.S. Anne and dropped). Each look in `LOOKS` (and `SHIP`) is a set
of HeartGold textures for one builder, which reads the GBA map like this:
- squares the GBA draws black are nothing; **floor is only what you can reach** from a door or from where a
  person stands (the GBA leaves squares open out in the black and in the borders; the first pass drew those as
  floor, and that was most of what looked wrong);
- the wall above a stretch of floor (up to three rows of GBA wall, with black beyond) stands up at the floor's
  far edge; where a bed or table stands against it, the wall comes from the columns either side. A warp square set
  in it is a door (HeartGold's door picture on the ship), a porthole tile a porthole;
- walls at the sides and the near edge are a low kerb, so they hide nothing; small closed patches are low blocks,
  or in the Tower standing stones (gravestones);
- furniture the look has models for is HeartGold's (`SHIP_FURNITURE`: bed, table, chair, plant; stairs between
  decks are HeartGold's staircase), and `ship_models` adds those models to the area's building set;
- a room can be widened like build_rooms' (`widen=`; the cabins are two columns and a row bigger).
The porter then moves anyone the GBA has on open floor who lands on a closed square to the nearest open one
(`settle`), in maps we built.
More, from the pass after it:
- **stairs** stand on the two closed squares beside the square that takes you there (as the GBA draws them),
  rising or going down away from it, the model chosen by which side is closed; stairs down are a well in the
  floor. A warp with open floor all round is a warp pad (`pad_model`).
- **the deck**: a rail (`maq_pt02` on its side) along every edge of the planks, sea below; widened so the bow has
  room.
- **a look can carry its room's things**: `furniture` (metatile -> model), `wall_art` (a cabinet on the wall),
  `cushions` (a texture laid on a floor square), `low_mt` (metatiles that are a low block wherever they are),
  `floor_mt` (closed in the GBA but floor: under a plant's pot). The Safari Zone's rest houses use all five.
- **the Game Corner and Prize Room** are the GBA's layouts in the looks of HeartGold's own (`corner`, `prize`);
  HeartGold's rooms are left unused. The slot machines are not ported (no script).
- **the Safari Zone** (`build_safari.py`, pieces in `route_kit.py`): HeartGold's own Safari Zone's look - its
  texture set 75 in an area of ours (121: those textures with Fuchsia's buildings, `OWN_AREAS`) - laid a square at a
  time from pieces read off its Plains (land 652), each chosen by the 8 squares round it:
  - a square's kind comes from the GBA metatile where colour would lie (`SAND_MT`, `CLIFF_MT`, `FENCE_MT`,
    `HEDGE_MT`, `STAIR_MT`; the GBA's sand edges are half grass, its boulder is cliff metatiles on their own);
  - plateaus (elevation 4) are a tier up, sand on top; their cliff squares are HeartGold's ledge pieces: the straight
    face (foot / face / lip: the lip `wall01_h`, sand; the foot `wall01_g` on grass, `wall01_h` on sand), its rounded
    outside corner and `wall01_d` inside corner copied from the Plains, odd squares laid by distance. The GBA draws a
    plateau's north edge inside its top row, so a row is added there for the face (`plan`, as caves are widened;
    the porter moves people with it). A face beside stairs gets its side (`_cap`); stairs are Pallet's ramp and rails;
  - tall grass: `egrass` two units up, with HeartGold's bushy edge in the quarters of the squares round it
    (`egrass_u` along a row, `egrass_v` down a column, `egrass_ro`/`egrass_ri` round corners), merged into runs;
  - sand: `road01`, its edge (`road01_r`) in the grass squares round it - HeartGold puts it inside the road, which
    left the GBA's small patches nearly all edge - by the straight piece (its sand side, s=16, against the sand)
    or a corner quadrant, else laid by distance;
  - ponds: `pond_line` bank, `pond_edge`, `pond_on` (materials 0 and 2: the area's animation moves them), laid by
    distance from the land, straight sides in runs (a pond drawn by distance everywhere was 80 KB a land);
  - trees stand two squares apart, as HeartGold's do: one to a 2x2 block of woods, the blocks never overlapping,
    taken from the woods' edge inwards (one to every block that fits made a thicket); a square of woods left over
    at the edge is a round bush;
  - the ground under fences, signs, bushes, trees and houses is the GBA metatile's bottom layer (`_sand_under`),
    so the sand runs on under them and its edge lies round them as anywhere else (`OBJECTS`, `ON_GROUND`);
  - ways out stay open: a way out's path past its warp is the GBA's sand (closed) and drawn as sand, never woods;
    a fence, hedge or sign copied into a row we added becomes closed grass (or the fence is two deep);
  - cards as HeartGold stands them (`CARDS`): trees over 2x2 blocks with their shadow, `etc_a`'s round bush for a
    hedge, `rock01` for the boulder, `fence_b` along a row and as posts down a column, its sign model (29) on the
    GBA's signs only (not on a sign copied into an added row);
  - a rest house is Fuchsia's house (297, 5 squares to the GBA's 4) centred on the GBA's, its door (307) where the
    model has it, the warp moved to it; bushes and fences under its roof go. Only warps on house metatiles are
    doors (the ways between the areas are not). The Center's way out below the gate's roof is a path between
    trees, as HeartGold's areas' ways out are.
- the porter keeps people clear of doors and stairs and of each other (`clear_of`): anyone who stood three or
  more squares from someone on the GBA stays at least a square apart here.
Still rough: the low blocks (tables, machines) are plain boxes, and inner walls are low kerbs with a flat top
(Silph, the Hideout, the Power Plant, the Mansion read as floor plans more than rooms); no elevator, card-key
doors or spin tiles; the Game Corner's machines do nothing.

## Where our land meets HeartGold's (the sea round Cinnabar and below Pallet)

HeartGold's ground is at 16 and its sea at 7 (with a clear layer, `sea_on`, at 8, where someone surfing is). A
land of ours beside one of theirs has to be at those levels at the edge, or there is a black line along it and
the player sinks or jumps crossing it:
- **Cinnabar** (`build_cinnabar.py`) is built at them: ground 16, sea 7, heights 16 and 8. Its rocks are
  HeartGold's sea rocks as Route 21 stands them: the big one (`sea_rock`) over a 2x2 block of rock squares, the
  blocks never overlapping, the small one (`sea_rock_m`) on a square left over. The beach is HeartGold's: the sand
  slopes from the ground's edge down across the whole sea square beside it (`swave_un`, 16 to 7), its foam a unit
  over it (`swave_p`, animated), laid by distance, straight sides in runs; the sea has its clear layer (`sea_on`,
  8) over the water (7). A sheet of sea lies just under it all
  and out past the edges: where the corners of our squares fall along a neighbour's bigger ones, single pixels
  show through otherwise.
- **what the neighbours still draw of the old map** comes out of their models: `landedit.strip(land, drop)` takes
  faces out of one of HeartGold's land models in place (the model keeps its size). Routes 20 and 21 drew the foam
  along the shore HeartGold's own Cinnabar had at their edge.
- **Pallet's bay** is two blocks below the town (the cliffs), so its sea was 32 below Route 21's: the last nine
  rows of the region (sea and forest only) lean up to meet it (`tilt` in `build_pallet.py`: everything in them,
  and the heights walked on, lifted by how far down the rows it is). From above a sea leaning ten degrees is
  still a sea.
The map matrix has an altitude for each cell (8 units a step: HeartGold's plain sea land is drawn one step up),
if a whole land ever needs moving.

## The rest of Kanto: the GBA's towns and routes (`build_overworld.py`)

Every town and route is the GBA's own layout (Nick: "the towns and routes rebuilt to GBA's layout"). The GBA's
outdoor maps meet one another by their connections; `world()` walks them from Pallet Town, nearest first (the GBA's
maps don't quite close their loops, so the far side of a loop gives), and lays them out as one world of 14 x 15 of
HeartGold's lands, its corner at matrix cell (30, 2): Pallet lands on our Pallet's own lands (cells 31..33, 11..12),
Cinnabar on our Cinnabar's (32, 15; the town is widened, so its GBA map is put where that land draws it). Those
seven lands stay `build_pallet.py`'s and `build_cinnabar.py`'s. The rest of HeartGold's Kanto in the matrix (and
the west end of its Route 22) is emptied; Johto is untouched. Saffron's town map is bigger than the map its routes
meet (`SaffronCity_Connection`): it sits over the routes' ends, its gatehouses on theirs.

Each square of each GBA map is read as one kind (`kinds`: grass, tall grass, road, sand, water, woods, rock, ledges,
fences, hedges, signs, flowers, stairs, the closed squares round a door: a building); squares no map covers are the
sea where the nearest square of a map is open sea (water along a side of a map that is half water or more), else
woods. The lands are laid from HeartGold's pieces a square at a time (as the Safari Zone: ground runs, the road and its
edge, tall grass and its bushy edge, rock tiers with HeartGold's cliff pieces - straight faces in runs - ledges, the
pond's water and banks, trees one to a 2x2 block of woods at HG density, cards for bushes, fences and stones), at
HeartGold's ground height, 16 (as Pallet's and Cinnabar's lands: the matrix's altitude moves a land's model but not the heights people stand at, so it stays 0). Lands must stay
under 61,400 bytes of model (`build_land` prints the biggest).

**Ledges** (Nick: ledges looked flat) are a raised lip on level ground: the ground rising from the side you jump from
to a crest 8 high, then HeartGold's cliff face (`wall01_g`, the cliff's profile squeezed into the square's front 0.42)
down to the side you land on, its ends closed with the face's texture (`ledge` in `build_land`). HeartGold's own
Kanto draws them flatter still (a painted strip, `allpeak_pgs`, a unit over the ground: compare in the map viewer).
A ledge can't be a real tier step as the GBA lays them out: every area above a ledge is reached on foot some other
way (the only stairs in its Kanto are Pallet's), so a step needs a ramp or stairs added on that way - as HeartGold's
own Route 1 has one cliff with stairs across it. (A solver for that is not in: every ledge came out a lip.)

**Buildings** are HeartGold's own: for each GBA door, the building HeartGold's town has for that room
(`hg_buildings`: read once off HeartGold's Kanto as it was, kept in `data/hg_buildings.json`), its door model, and
the squares its box covers closed. Gatehouses are HeartGold's two (doors north and south: 246; west and east: 247),
stretched or squeezed between the GBA's two doors. A room HeartGold has no building for gets **its own town's**
(Nick: no generic red-roofed house shrunk to fit; the right asset in the right place - `STYLE`): of that town's
HeartGold houses and apartment blocks, the one nearest the GBA building's size (Saffron's `ybc_` houses and yellow
apartments, Celadon's `ta_` houses, hotel and condominiums, the Academy's school - Violet's, up to half again its
size so the main hall is one building - and so on; a house on a route is the nearest town's), centred on the GBA's
building with the town's door on the GBA's door, never shrunk below 0.85. A block of the GBA's closed squares
with no door is filled the same way (apartments where it is 4 deep or more in Saffron and Celadon); the Academy's
market carts are HeartGold's market tents (`msg_tn01..04`). A building never stands over another: one beside
another up already keeps to the room between them (buildings in a row share it, halfway between their doors), a
second door of a building up already (a back door) is only its door, and a block with no room for a house of its
own is trees. A warp at the foot of a building in a town on a square the GBA draws open (the Academy's halls) is a
door too.
A cave's mouth (a warp at the foot of a rock face) is HeartGold's arch off Route 11 (`data/cave_mouth.json`),
walked into (behaviour 0x6E).

**The towns' ground** is each HeartGold town's own (`GROUND_STYLE`, its textures brought into set 18 by
`build_interiors.py`; what each of HeartGold's towns lays most of): Saffron paved all over (`ymb_fe02`, its grass
too) with its grey streets (`ymb_fe01`) wherever road is a square from anything else, Celadon `tama_yuka` with
`tama_yuka2` streets the same way, the Academy `tama_yuka`, Vermilion as HeartGold's (its orange tiles `kbc_rd02`, its
plank-brick streets `kbc_rd01` with the `kbc_rd03` curb in a strip along them, a row of `kbc_rd10` blocks along the
water, and its grass edge `kbc_rd07` laid over the tiles: its outer half is see-through, black with nothing under it), Cerulean and Pewter `han_fe02`,
Lavender `sio_fe02` (paved all over); each with its own edge in the grass beside it (laid as
`road01_r`: their edges share its layout). Routes, Viridian and Fuchsia keep `road01` (Nick: not Fuchsia's dark red,
`sek_fe03`). The GBA's pale short grass (Fuchsia's walks, Route 2's) is HeartGold's lighter plaza grass, `grass02`,
with its own edge `grass02_r`. **No stitching** (Nick: two edge
pieces back to back look stitched): a strip of grass between two roads narrower than three squares is road, and so
is a square of grass no edge piece fits; roads with the same edge are one road to the grass beside them.

**Check every map against HeartGold's own** (Nick: "verify with the HeartGold maps when you make a route/town and
make sure it matches (for everything)"): `hgland.py`-style renders of HeartGold's map as it was (HG_REV), and the
ground textures it lays most against ours, map by map; whatever HeartGold builds a thing of (a bridge, a pen, a quay)
is what ours is built of. **`hg_kit.py`** reads HeartGold's own pieces out of its lands into `data/kit_*.json`:
- a *kit*: each square of a thing (polygons cut at the square's sides, so a square's piece is its own), keyed by
  which of the 24 squares round it are that thing too; ours take the piece whose surroundings are most like theirs
  (and of their class: a boardwalk's platforms or its planks). The GBA's wooden walkways (`BRIDGE_MT`, by tileset)
  are HeartGold's: Route 12 and 13's boardwalks and Vermilion's planks Route 12's (its Silence Bridge), Route 24's
  Nugget Bridge Route 24's, their decks just above the ground, the sea under them (the sea goes on under a walkway).
  **Widths are HeartGold's** (Nick: things come out too narrow - check the width against HeartGold's own, and err
  bigger): its boardwalks are three squares across (the GBA's two: widened over the water on the side with room),
  its Nugget Bridge six (the GBA's three take in their railings: five, and the grass strip beside it is the river,
  as HeartGold's spans water). Every boardwalk square grows by one east and south, so the GBA's two-wide ways and
  2 x 2 crossings become three-wide ways and 3 x 3 crossings, all lined up. A boardwalk's planks are laid square by
  square as Route 12's are (trims half a square each side, the deck's planks across the whole width, faces down to
  the water); its crossings are HeartGold's crate platforms (two a square apart are one), each square laid by its own
  neighbours as HeartGold's 3 x 3 (corners, sides, middle); the sea's foam (Pallet's shore's) runs along every side.
- rivers: HeartGold's river water where its own maps have a river (`RIVERS`: Route 10, 24, Cerulean); Viridian's
  paving is its `tok_fe01`, meeting the grass with an edge made of it (`cv_tok_r`, `MADE_EDGES` in build_interiors:
  road01_r's layout with a paving's texels - a transition everywhere); a patch of pale grass under eight squares
  against a road is road; Route 14's road `road02`. Snorlax is HeartGold's own sleeping one (`SPRITE_KABIGON`).
- a *stamp*: every polygon over a block, fitted to the GBA's: Fuchsia's hedged pens (`PENS`: HeartGold's three, with a
  pond, a raised flower bed, flowers - the GBA's water ones its pond's walls round the GBA's water), only the faces the
  camera can see (a land must stay under 61,400 bytes: six pens fill one). The pens' Pokemon stand inside them.
A house (narrower than 5.5 squares) is centred on the GBA's building, its door model on the GBA's door; HeartGold's
own buildings go up before the town's houses.

**The Academy's front** (`PLAZAS`; Nick: "our flowers and Roserade statue... make it look pretty") is laid anew: paved,
raised flower beds (HeartGold's grass and flowers on Fuchsia's brick), Goldenrod's street lamps (model 95) where the
GBA's lamps stand, and the GBA's statue as HeartGold's own Roserade (its overworld frame from hg-engine,
`data/roserade_overworld.png`, in `STATUE_FINISH` on the GBA's pedestal: `cv_roserade`, made by `build_pallet.py` as
the Chansey statue is) on a 2x2 pedestal.

**Signs** never stand in front of a door (a real one or a look-only house's) or under a building: such a sign moves
to the nearest open square beside (not a person's, a door's front, or a narrow way), and its words move with it
(`moved` in `data/kanto_world.json`, which the porter applies to the GBA's sign events). Signs side by side under a
building (Cerulean's bike shop's bicycles) are one sign, the front one. A look-only house shows no door where
something stands in front of it. Gatehouses are one to each GBA gatehouse: two of the GBA's to one room of
HeartGold's (Route 11's east gate and Route 12's north gate) are two (once, one gatehouse stood between them).

**Maps and areas**: each land is the HeartGold map of the GBA map with most squares in it (Route 23 and the Leader
Academy get maps of ours); each of those maps gets an area of its own (140 on: set 18's textures, a building set of
the models in its lands and those in the lands round it within 14 squares, `SEEN`: a model a set lacks is drawn as
model 0, an empty box, so 0 is in every set). One building set with every model came to 100 KB of textures and
the game crashed, and so did Saffron's at 63 KB once set 18 was 48 KB: the two together must stay near 100 KB
(the biggest set is now 41 KB).

**Doors**: a map's warps are the GBA's doors in its lands; each room's way out leads back to the door it was come
in by (`wire`: rooms built from the GBA's layouts by its warp numbers, HeartGold's rooms by matching their ways out
to the doors, side by side and in order).

**Viridian Forest** is laid the same way in its own lands (`WOODS`: the GBA map in the middle of HeartGold's 2x3
lands for it; its trees are tiles of its own, so its closed squares are woods), with its own area; its warps are the
GBA's and the gatehouses' ways in lead to them.

**People** (`port_map.py`, `data/kanto_world.json`): a HeartGold map's people, signs and trigger squares are the
GBA's standing in its lands, from whichever GBA map, at their own squares; its map scripts are its main GBA map's.
People from another GBA map get ids after the main map's (`LID_OVER`). Scripted walks need no redoing: the layout
is the GBA's.

Fly points and the places you come back to are moved in front of each town's new Pokemon Center (`spawns`:
sSpawnMaps in the ARM9's data, changed in place). Rooms of the GBA's that HeartGold has no building for are built from
their layouts: the small houses by `build_rooms.py` (HeartGold's house look and furniture), the rest (the Hotel,
the Fan Club, the Safari Office, the Medical Center, the Academy's rooms, the Underground Path's east-west way...)
by `build_interiors.py` in a plain house look. `test/world_reach.py` checks every door can be walked up to.

**The world must be walkable round, both ways** (`test/reach_all.py`): a walk over every square of the world and of
every room and cave, through their warps (water and ledges as with every HM), from Pallet and back. It reports warps
you can't get to, squares you can get to but not back from (a trap), and with `--objects` the people and things
whose square, made free, would open anything (cut trees, rocks, boulders, barriers, Snorlax and items left out, as
they are meant to be moved). What it found and what was done:
- the GBA game's map connections don't close their loops: round the south (Route 21, Cinnabar, Routes 20 and 19 to
  Fuchsia) is 15 squares across and 32 down more than round the north. Placing Fuchsia's side from the south left
  Celadon's road east, Vermilion's to Route 11 and Lavender's to Route 12 running into the woods, and Celadon a
  pocket you could only get into by the Route 16 gate. The sea routes are placed last (`SEA_ROUTES`), so the land
  meets and the gap is open sea.
- a HeartGold gatehouse with more doors outside than in (the GBA's Route 16 gate, two storeys each side) pairs each
  door with the way out on its own side (by where each lies from the middle of its doors), not by row.
- a GBA map we don't build that only passes you on (the S.S. Anne's outside at Vermilion's harbour) is `THROUGH`: the
  harbour leads aboard, onto the ship's ways out to it. (The S.S. Anne could not be reached at all.)
- a doormat three or five wide is come in on in its middle, and all of it leads out.
- in a room of HeartGold's layout, a person who cuts off part of it steps aside (`unchoke`: the Celadon Restaurant's
  worker stood in the only way into its corridor).
- the Safari Zone's rest-house signs stood in front of the model's door (it is a square right of the GBA's): they
  go in front of the GBA's door square (`build_safari.py` writes `data/safari_moved.json`, the porter reads it).
Left as the GBA has them (the scripts move them): the Cerulean Cave guard, the Academy gate guards, Saffron's
Rockets, the S.S. Anne rival, the Pallet ceremony. Not yet: the Elite Four (their scripts stop at the gym-candidate
specials and the League's lighting; the Hall of Fame isn't ported).

Not yet: the town map (Pokegear) still shows HeartGold's Kanto; the Route 21 stadium cave and the rooms further in
(the Pit, the Medical Center's upper floors) aren't built; the open ground round the
world is woods or sea by whichever map is nearest, which leaves straight-edged shores in places.
`test/shots.py LIST DIR` takes a screenshot per place from one ROM (it points the new-game location in RAM);
`test/places.py` writes the list.

## Plan

1. Toolchain + headless emulator (done)
2. First playable slice: our Pallet Town layout, new game starts there (done)
3. Foundation: Gen 1-9 species, Fairy, newer moves/abilities/mechanics, Terastal, sprites (hg-engine; in)
4. Canvas systems one at a time (gym leader mode, type tutors, Academy + market, TCG, Pit, ...);
   Safari Zones and the gym leader convention are left out for now
5. Kanto story maps, then the region-unlock framework

## Map viewer (tools/canvas/viewer)

- `python3 tools/canvas/viewer/export.py build/viewer` writes every built map (models, textures, people, signs, warps, triggers) as `maps.json` plus `m/<map>.txt` (base64: published pages serve no plain binary files); `index.html` is the three.js viewer that reads them.
- After a build that changes maps, re-export and republish the viewer to the same page so Nick can fly through what changed.
