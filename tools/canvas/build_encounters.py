"""The GBA game's wild Pokemon as HeartGold encounter tables, for maps of ours (Nick, the Safari Zone first; the
rest of Kanto's routes and caves go here too when their turn comes).

HeartGold's tables are hg-engine's (engine/data/Encounters.c, a/0/3/7: 143 of them, ENCDATA_*). Ours follow its last,
from CANVAS_ENCDATA_FIRST, in engine/data/canvas_encounters.h (Encounters.c includes it at the end of its table),
and each of our maps' headers takes its table's number. The slots line up: HeartGold's land table has the GBA's 12
slots with the same chances (20 20 10 10 10 10 5 5 4 4 1 1) and its water table the GBA's 5 (60 30 5 4 1); the GBA's
rods (2, 3 and 5 slots) go into HeartGold's 5 a rod, each of its slots taking the GBA slot that keeps the chances
nearest. The GBA has no time of day: morning, day and night are the same.

Run after build_interiors.py (it writes our maps' headers afresh), before the porter. Idempotent."""
import itertools, json, os, re
HERE = os.path.dirname(os.path.abspath(__file__))
import slots

GBA = '/home/claude/gym-trainer-hack'
ENGINE = os.path.join(slots.ROOT, 'engine')
OUT = os.path.join(ENGINE, 'data', 'canvas_encounters.h')
ENCOUNTERS_C = os.path.join(ENGINE, 'data', 'Encounters.c')
CANVAS_ENCDATA_FIRST = 143
# our map -> the GBA's encounter table (its FireRed side)
TABLES = [
    ('MAP_CANVAS_SAFARI_CENTER', 'sSafariZoneCenter_FireRed'),
    ('MAP_CANVAS_SAFARI_EAST', 'sSafariZoneEast_FireRed'),
    ('MAP_CANVAS_SAFARI_NORTH', 'sSafariZoneNorth_FireRed'),
    ('MAP_CANVAS_SAFARI_WEST', 'sSafariZoneWest_FireRed'),
]
HG_OTHER = [60, 30, 5, 4, 1]
GBA_FISH = {'old': ([0, 1], [70, 30]), 'good': ([2, 3, 4], [60, 20, 20]), 'super': ([5, 6, 7, 8, 9], [40, 40, 15, 4, 1])}
HG_ROD_RATES = {'old': 25, 'good': 50, 'super': 75}       # (HeartGold's chance of a bite, as on its own maps)


def gba_tables():
    d = json.load(open(os.path.join(GBA, 'src/data/wild_encounters.json')))
    return {e['base_label']: e for g in d['wild_encounter_groups'] for e in g['encounters'] if 'base_label' in e}


def species(s):
    return s if re.search(r'#define\s+%s\b' % s, open(os.path.join(ENGINE, 'include/constants/species.h')).read()) else 'SPECIES_NONE'


def best_fit(gba_slots, gba_rates):
    """HeartGold's five slots (60 30 5 4 1), each given one of the GBA's: the choice nearest the GBA's chances, keeping
    every GBA slot where it can (a rare Dratini stays rare rather than gone)"""
    best = None
    for pick in itertools.product(range(len(gba_slots)), repeat=5):
        got = [sum(r for r, p in zip(HG_OTHER, pick) if p == i) for i in range(len(gba_slots))]
        err = sum(abs(a - b) for a, b in zip(got, gba_rates)) + 10 * got.count(0)    # (and every GBA slot kept)
        if best is None or err < best[0]: best = (err, pick)
    return [gba_slots[i] for i in best[1]]


def slot(m):
    return '{ %d, %d, %s }' % (m['min_level'], m['max_level'], species(m['species']))


def entry(n, e):
    land = e.get('land_mons', {}).get('mons', [])
    water = e.get('water_mons', {}).get('mons', [])
    fish = e.get('fishing_mons', {}).get('mons', [])
    out = ['    [%d] = {' % n,
           '        .rateWalk = %d,' % e.get('land_mons', {}).get('encounter_rate', 0),
           '        .rateSurf = %d,' % e.get('water_mons', {}).get('encounter_rate', 0),
           '        .rateRockSmash = 0,']
    for rod in ('old', 'good', 'super'):
        out.append('        .rate%sRod = %d,' % (rod.capitalize(), HG_ROD_RATES[rod] if fish else 0))
    lv = ', '.join(str(m['max_level']) for m in land) if land else ', '.join(['0'] * 12)
    sp = ', '.join(species(m['species']) for m in land) if land else ', '.join(['SPECIES_NONE'] * 12)
    out += ['        .landSlots = {', '            .levels = { %s },' % lv]
    for t in ('Morning', 'Day', 'Night'):
        out.append('            .species%s = { %s },' % (t, sp))
    out.append('        },')
    none = '{ 0, 0, SPECIES_NONE }'
    out.append('        .surfSlots = { %s },' % ', '.join(slot(m) for m in water) if water else '        .surfSlots = { %s },' % ', '.join([none] * 5))
    out.append('        .rockSmashSlots = { %s },' % ', '.join([none] * 2))
    for rod, field in (('old', 'oldRodSlots'), ('good', 'goodRodSlots'), ('super', 'superRodSlots')):
        if fish:
            idx, rates = GBA_FISH[rod]
            out.append('        .%s = { %s },' % (field, ', '.join(slot(fish[i]) for i in best_fit(idx, rates))))
        else:
            out.append('        .%s = { %s },' % (field, ', '.join([none] * 5)))
    out.append('    },')
    return out


def main():
    g = gba_tables()
    lines = ['// Pokemon Canvas: the GBA game\'s wild Pokemon for maps of ours (tools/canvas/build_encounters.py: don\'t edit)']
    for i, (ds_map, label) in enumerate(TABLES):
        n = CANVAS_ENCDATA_FIRST + i
        lines += ['    // %s: the GBA\'s %s' % (ds_map, label)] + entry(n, g[label])
        slots.set_header(ds_map, {'wildEncounterBank': str(n)})
    open(OUT, 'w').write('\n'.join(lines) + '\n')
    src = open(ENCOUNTERS_C).read()
    if 'canvas_encounters.h' not in src:      # (Encounters.c ends its table with "};")
        i = src.rindex('};')
        src = src[:i] + '#include "canvas_encounters.h"\n' + src[i:]
        open(ENCOUNTERS_C, 'w').write(src)
    print('encounters: %d tables of ours, from %d' % (len(TABLES), CANVAS_ENCDATA_FIRST))


if __name__ == '__main__':
    main()
