# Pokémon Canvas DS

Pokémon Canvas (the FireRed-based gym-leader game, `nmoore0518/gym-trainer-hack`) rebuilt on the
HeartGold decompilation. This fork tracks `pret/pokeheartgold`.

## Build and test

```
sudo tools/canvas/setup_env.sh       # once: 32-bit libc for the DS compiler, build deps, headless DeSmuME
python3 tools/canvas/build_pallet.py # regenerate our Pallet Town into the game's data files (idempotent)
make rom -j16                        # -> build/heartgold.us/pokeheartgold.us.nds
tools/canvas/test/newgame.sh t1      # boot headless, play the intro, save st/t1_field.dst (+ .png)
python3 tools/canvas/test/walk.py st/t1_field.dst - tour R5 U6 s   # walk by tiles, screenshots -> st_tour.png
```

`make` (rather than `make rom`) also compares against the retail checksums, which Canvas changes are expected to fail.

## Our Pallet Town

`tools/canvas/build_pallet.py` turns the GBA layout (`tools/canvas/data/pallet_layout.json`) into four HeartGold map
blocks at overworld matrix cells (32..33, 11..12): collision, height data (BDHC), a terrain model built from
Pallet's own texture set, and HeartGold building models placed on our doors. It also adds recoloured copies of
Kanto's red house (blue, green, purple), the models our town uses to Pallet's building set, and their textures to
the set's shared texture file (`a/0/7/0`). Things learned the hard way:

- the field loads building models from `a/0/4/0` (the `fielddata/build_model` copy is not the one used), with
  one entry per model in `a/1/0/7`, and binds them to the per-set textures in `a/0/7/0`, matched by name
- a land's terrain model must stay under ~61 KB (flat ground is merged into rectangles to get there)
- materials need their texture size filled in, or every texel samples the same spot
- the DS file system's tables are read at boot, so a savestate from before a data change is no good after it


## Plan

1. Toolchain + headless emulator (done)
2. First playable slice: our Pallet Town layout, new game starts there (done)
3. Foundation: Gen 1-9 species, Fairy, newer moves/abilities/mechanics, Terastal, sprites
4. Canvas systems one at a time (gym leader mode, type tutors, Academy + market, TCG, Pit, ...);
   Safari Zones and the gym leader convention are left out for now
5. Kanto story maps, then the region-unlock framework
