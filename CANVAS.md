# Pokémon Canvas DS

Pokémon Canvas (the FireRed-based gym-leader game, `nmoore0518/gym-trainer-hack`) rebuilt on the
HeartGold decompilation. This fork tracks `pret/pokeheartgold`.

## Build and test

```
sudo tools/canvas/setup_env.sh       # once: 32-bit libc for the DS compiler, build deps, headless DeSmuME
make -j16                            # -> build/heartgold.us/pokeheartgold.us.nds
python3 tools/canvas/ds_run.py build/heartgold.us/pokeheartgold.us.nds out/boot   # boot headless, save screenshots
```

An unmodified tree builds the original ROM byte for byte (sha1 4fcded0e2713dc03929845de631d0932ea2b5a37);
`make` checks this. Once Canvas changes land, that check is expected to fail.

## Plan

1. Toolchain + headless emulator (done)
2. First playable slice: our Pallet Town layout, new game starts there
3. Foundation: Gen 1-9 species, Fairy, newer moves/abilities/mechanics, Terastal, sprites
4. Canvas systems one at a time (gym leader mode, type tutors, Academy + market, TCG, Pit, ...);
   Safari Zones and the gym leader convention are left out for now
5. Kanto story maps, then the region-unlock framework
