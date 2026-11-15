# Pokémon Canvas DS: story plan

Living notes on where the story is going, so the port and new work stay pointed at it. Nick writes the
final dialogue; anything here marked *suggestion* is Claude's, to workshop.

## Decisions so far

- **Exotic Safari zones: removed for good.** Their maps, scripts and the species they gave access to don't come
  over. Pokémon that were only obtainable there need new homes (see *Open questions*).
- **Gym Leader Convention: shelved.** Not ported now; may come back later.
- **Kanto stays as the GBA game has it.** The player becomes Pallet's gym leader, masters a type, and Oak
  offers a type switch as before.
- **New: the gym challenge for a new type only opens after that type's region is cleared** (a change from the
  GBA game, where switching type let you take challengers straight away).

- **Each region is missing one colour until it's cleared** (Nick, 2026-11-15): e.g. Johto green, so the grass and
  trees are grey; clearing the region brings the colour back. The final challenge ties to **Arceus**, who holds
  all the colours.
- **Region tickets are the player's to use when they like**, but each region is tied to a type, and that type
  can't be cleared (no gym challenge with it) without going there.
- **The 8 regions**: Johto, Hoenn, Sinnoh, Unova, Kalos, Alola, Galar, Paldea. **Johto is HeartGold's own Johto.**
- **Pokémon only the Exotic Safari gave** go to the regions they come from, as those regions are built.

## Regions, types and colours (Nick, 2026-11-15)

Two types per region (so any starter can see a region through), one colour per region; together they cover
all 18 types once.

| Region | Types | Missing colour until cleared |
|---|---|---|
| Kanto | Psychic / Poison | Purple; the finale turns Kanto fully greyscale until Arceus is beaten |
| Johto | Bug / Grass | Green |
| Hoenn | Water / Ice | Blue |
| Sinnoh | Electric / Flying | Yellow |
| Unova | Steel / Normal | Grey (needs a different effect: can't grey out grey) |
| Kalos | Ghost / Dark | Black (same problem) |
| Alola | Fire / Fighting | Red |
| Galar | Fairy / Dragon | Pink |
| Paldea | Rock / Ground | Brown |

**Mastery changes** (after the first type): no more win streaks; a type is mastered by beating that region's
Elite Four with it. The first time is through the region's story; the second is with the region's other type.

## How the missing colour works *(plan)*

HeartGold's map textures are palette-based, so the colour can be taken out where the palettes are loaded:
every palette colour whose hue falls in the region's band (and that isn't already grey) is replaced by a grey of
the same brightness, while the region's clear flag is unset. One hook in the engine covers terrain, buildings
and trees, costs no extra ROM, and the colour comes back the moment the flag is set (next map load). The same
filter can go on battle backgrounds and, if wanted, people and Pokémon in that region. Mock-up of Johto-style
green taken out: `color-drain-mockup.png` (shared 2026-11-15). Colours for the other regions are to be chosen.

## The arc past Kanto (Nick's outline, 2026-11-15)

1. The player masters a gym type. Oak casually asks whether they want to switch types, as before.
2. A legendary appears. Once the player catches or defeats it, a new NPC arrives and introduces the wider story:
   the legendary's appearance ties into their research, and the player is in some sense chosen.
3. An overarching story runs through the other 8 regions, built around a mysterious force tied to the idea of
   devotion to a single type (not called "monotype").
4. The player travels to the new region and beats all of its gym leaders and its Elite Four with the new type, to
   prove their worth with it.
5. Reward: a **region trophy**, displayable, and the right to take gym challengers with the new type.
6. Mastering that type again brings another legendary, and the NPC again (expected this time, so different
   dialogue). The player gets another **region ticket**.
7. Travel is by **airport**, which sends the player to the regions they have tickets for.
8. Repeat until all regions are cleared, then a **final challenge** that ties the story together.

## Suggestions to workshop *(Claude)*

- **The force fits the game's name.** Canvas already frames things in colour and paint (the Smeargle painter,
  Canvas Smeargle). Treat each type as a colour: a trainer devoted to one type is a pure colour, and the
  legendaries are drawn to that purity. The mysterious force is something draining colour from the world (a
  "grey" spreading region by region), and each region's legendary is a keeper of one part of the spectrum. Each
  region cleared restores a colour; the final challenge is the full canvas, every type you've mastered at once.
- **The NPC** could be a researcher of type resonance (a "chromatic" researcher) who has been tracking where the
  grey appears; the legendaries surfacing near the player is the first hard evidence for their theory. They
  become the guide for the ticket and the airport, and their own stake in the grey can be the late-game twist.
- **Which legendary appears** can foreshadow the next region (e.g. a Johto legendary before the Johto ticket),
  so catching it is the hook into that region rather than a random encounter.
- **Region order** could follow the player's type choices instead of being fixed: each region's gyms and Elite
  Four would need to scale to the player's level, which fits "prove your worth with the new type".
- **The airport** fits Vermilion (the port city, already the travel hub) or a new small area east of it. A
  departures board listing only the regions you have tickets for keeps it simple.
- **Trophies** fit the gym decorating system: a trophy case decoration that fills in as regions are cleared,
  so challengers see your history.
- **Final challenge** (now Arceus): a gauntlet where the player wins with a team from each mastered type in turn,
  then Arceus, holder of every colour, with a mixed team for the first time.

## Open questions

- Which colour belongs to which region (Johto green is the working example).
- Does the drained colour also hit people, Pokémon and battle backgrounds in that region, or only the land?
- Which type goes with which region, and is that fixed or chosen by the player's type?
