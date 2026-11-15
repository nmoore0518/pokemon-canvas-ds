"""Which HeartGold map slot each GBA map lives in. Warps are copied from the GBA maps in order, so a GBA
dest_warp_id is the anchor in the destination slot's warp list."""
import os, re

SLOTS = {
    'MAP_PALLET_TOWN': 'MAP_PALLET',
    'MAP_PALLET_TOWN_PLAYERS_HOUSE_1F': 'MAP_PALLET_TOWN_REDS_HOUSE_1F',
    'MAP_PALLET_TOWN_PLAYERS_HOUSE_2F': 'MAP_PALLET_TOWN_REDS_HOUSE_2F',
    'MAP_PALLET_TOWN_RIVALS_HOUSE': 'MAP_PALLET_TOWN_BLUES_HOUSE_1F',
    'MAP_PALLET_TOWN_HOUSE1': 'MAP_PALLET_TOWN_BLUES_HOUSE_2F',
    'MAP_PALLET_TOWN_PROFESSOR_OAKS_LAB': 'MAP_PALLET_TOWN_OAKS_LAB',
}

ROOT = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..'))


def header(ds_map):
    """The fields of a map's entry in src/data/map_headers.h"""
    s = open(os.path.join(ROOT, 'src/data/map_headers.h')).read()
    m = re.search(r'\[%s\] = \{(.*?)\n\s*\},' % re.escape(ds_map), s, re.S)
    return dict(re.findall(r'\.(\w+) = ([^,]+),', m.group(1)))


def matrix_file(ds_map):
    return re.match(r'NARC_map_matrix_(\w+)_bin', header(ds_map)['matrixId']).group(1) + '.bin'


def events_file(ds_map):
    return re.match(r'NARC_zone_event_(\w+)_bin', header(ds_map)['eventsBank']).group(1) + '.json'


def gba_warps(gba_map_json, shift=(0, 0)):
    """HeartGold warp entries for a GBA map's warps, in the same order (unbuilt destinations become dead warps)"""
    out = []
    for w in gba_map_json.get('warp_events', []):
        dest = SLOTS.get(w['dest_map'])
        if dest is None:
            out.append({'x': 0, 'z': 0, 'header': 'MAP_PALLET', 'anchor': 0, 'y': 0, '_dead': w['dest_map']})
        else:
            anchor = 0 if any(c[0] == w['dest_map'] for c in CLONES) else int(w['dest_warp_id'])   # (a copy's door is its first warp)
            out.append({'x': w['x'] + shift[0], 'z': w['y'] + shift[1], 'header': dest, 'anchor': anchor, 'y': 0})
    return out


# ---------------------------------------------------------------- cloned rooms: an unused slot made a copy of a
# HeartGold room (same land, scripts and people), with its own events so its doors lead back to our map
FREE_SLOTS = ['MAP_FIGHT_AREA_UNUSED_%d' % i for i in range(1, 10)] + ['MAP_BATTLE_PARK_UNUSED_1', 'MAP_BATTLE_PARK_UNUSED_2'] + \
    ['MAP_BATTLE_TOWER_UNUSED_%d' % i for i in range(1, 5)] + ['MAP_ROUTE_20_UNUSED', 'MAP_UNUSED']
CLONES = [  # GBA map, HeartGold room to copy, which of its people stay (by id suffix; None = all), slot.
    # Slots are fixed here so adding a room never moves another one.
    ('MAP_PALLET_TOWN_POKEMON_CENTER_1F', 'MAP_VIRIDIAN_POKECENTER_1F', ('pcwoman1', 'pcwoman2', 'pcwoman2_2', 'pcwoman2_3'), 'MAP_FIGHT_AREA_UNUSED_2'),
    ('MAP_PALLET_TOWN_MART', 'MAP_VIRIDIAN_POKEMART', ('shopm1_2', 'shopm1_2_2'), 'MAP_FIGHT_AREA_UNUSED_3'),
    ('MAP_PALLET_TOWN_TRAINING_HALL', 'MAP_SAFFRON_FIGHTING_DOJO', (), 'MAP_FIGHT_AREA_UNUSED_4'),
    # (the GBA Center's upstairs is its link room; HeartGold's is downstairs)
    ('MAP_PALLET_TOWN_POKEMON_CENTER_2F', 'MAP_VIRIDIAN_POKECENTER_B1F', None, 'MAP_FIGHT_AREA_UNUSED_5'),
]
ROOM_SLOTS = {   # GBA rooms built from their own layouts in unused slots (see build_rooms.py)
    'MAP_PALLET_TOWN_HOUSE2': 'MAP_FIGHT_AREA_UNUSED_1',
    'MAP_PALLET_TOWN_PLAYERS_HOUSE_B1F': 'MAP_FIGHT_AREA_UNUSED_6',
    'MAP_PALLET_TOWN_GYM': 'MAP_FIGHT_AREA_UNUSED_7',
    'MAP_PALLET_TOWN_GYM_BACK_ROOM': 'MAP_FIGHT_AREA_UNUSED_8',
    'MAP_PALLET_TOWN_GYM_LEFT_ROOM': 'MAP_FIGHT_AREA_UNUSED_9',
    'MAP_PALLET_TOWN_GYM_RIGHT_ROOM': 'MAP_BATTLE_PARK_UNUSED_1',
    # the bigger versions (by POKeMON caught; the game picks the one you've earned)
    'MAP_PALLET_TOWN_GYM+50': 'MAP_BATTLE_PARK_UNUSED_2',
    'MAP_PALLET_TOWN_GYM_BACK_ROOM+150': 'MAP_BATTLE_TOWER_UNUSED_1',
    'MAP_PALLET_TOWN_GYM_LEFT_ROOM+250': 'MAP_BATTLE_TOWER_UNUSED_2',
    'MAP_PALLET_TOWN_GYM_RIGHT_ROOM+350': 'MAP_BATTLE_TOWER_UNUSED_3',
}
for _gba, _tmpl, _keep, _slot in CLONES:
    SLOTS[_gba] = _slot
SLOTS.update(ROOM_SLOTS)
CLONE_OF = {c[1]: c[3] for c in CLONES}     # HeartGold room -> the slot holding our copy of it

HEADERS = os.path.join(ROOT, 'src/data/map_headers.h')
EVENT_DIR = os.path.join(ROOT, 'files/fielddata/eventdata/zone_event')
MATRIX_DIR = os.path.join(ROOT, 'files/fielddata/mapmatrix/map_matrix')


def set_header(ds_map, fields):
    s = open(HEADERS).read()
    m = re.search(r'(\[%s\] = \{)(.*?)(\n\s*\},)' % re.escape(ds_map), s, re.S)
    body = m.group(2)
    for k, v in fields.items():
        body, n = re.subn(r'(\.%s = )[^,]+,' % k, lambda mm: mm.group(1) + v + ',', body)
        assert n == 1, (ds_map, k)
    s = s[:m.start(2)] + body + s[m.end(2):]
    open(HEADERS, 'w').write(s)


def _add_to_list(meson, name):
    s = open(meson).read()
    if "'%s'" % name in s: return
    i = s.rindex("'")
    j = s.index('\n', i)
    s = s[:j] + "\n    '%s'," % name + s[j:]
    open(meson, 'w').write(s)


def new_events_file(tag, content):
    """A zone_event file of our own (appended to the archive, so no other map's numbering moves)"""
    existing = [f for f in os.listdir(EVENT_DIR) if f.endswith('.json')]
    mine = [f for f in existing if f.split('_', 1)[1] == 'CV_%s.json' % tag]
    name = mine[0] if mine else '%03d_CV_%s.json' % (max(int(f.split('_')[0]) for f in existing) + 1, tag)
    json.dump(content, open(os.path.join(EVENT_DIR, name), 'w'), indent=4)
    open(os.path.join(EVENT_DIR, name), 'a').write('\n')
    _add_to_list(os.path.join(EVENT_DIR, 'meson.build'), name)
    return 'NARC_zone_event_' + name[:-5] + '_bin'


def new_matrix_file(tag, land_id):
    existing = [f for f in os.listdir(MATRIX_DIR) if f.endswith('.bin')]
    mine = [f for f in existing if f.endswith('_CV_%s.bin' % tag)]
    name = mine[0] if mine else 'map_matrix_%04d_CV_%s.bin' % (max(int(f[11:15]) for f in existing if f[11:15].isdigit()) + 1, tag)
    nm = ('cv_' + tag.lower())[:16].encode()
    open(os.path.join(MATRIX_DIR, name), 'wb').write(bytes([1, 1, 0, 0, len(nm)]) + nm + struct.pack('<H', land_id))
    _add_to_list(os.path.join(MATRIX_DIR, 'meson.build'), name)
    return 'NARC_map_matrix_' + name[:-4] + '_bin'


import json, struct  # noqa: E402  (used by the helpers above)
