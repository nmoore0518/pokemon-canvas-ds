"""Canvas: the GBA game's big interiors that HeartGold has no building for (the Pokemon Tower, Silph Co.'s upper
floors, the S.S. Anne, the Power Plant), built from their GBA layouts in a HeartGold building's look.

Each floor is modelled from its GBA layout the way build_caves.py models a cave, but as a building: the walkable
squares are a floor of HeartGold's (`floor`), every blocked square next to the floor is a wall a block and a half
high, faced with HeartGold's wall texture (`wall`) and topped with `top`; little blocked patches out on the floor
(the GBA's tables, machines, gravestones) are low blocks (`low`, faced with `wall`). Squares that take you
elsewhere are drawn in `mark` (stairs, pads), and carry HeartGold's behaviours: a way out at the foot of a wall is
an exit mat (0x65), any other a step-on warp (0x3C up / 0x3E down by floor, as caves' ladders).
Looks come from HeartGold's own texture sets (LOOKS): the Sprout Tower's for the Pokemon Tower, the Power Plant's
for Silph Co. and the Power Plant, the S.S. Aqua's for the S.S. Anne.
Floors bigger than a land (32x32) span a matrix of lands. Each floor is a map of our own (MAP_CANVAS_*), with the
header of a HeartGold map like it (TEMPLATE) and its own events from the GBA map; HeartGold doors that stood for the
place lead into ours (DOORS).

Run after build_caves.py (our lands follow the caves'), and before the porter.
"""
import json, math, os, struct, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from nitro import read_narc, write_narc
from g3d import Mesh, build_model
import gba_map
import slots
from slots import SLOTS, new_map, NO_SCRIPTS, header, set_header, new_events_file, events_file, gba_warps
from build_rooms import texdims
from build_caves import matrix_file

ROOT = slots.ROOT
LAND_NARC = os.path.join(ROOT, 'files/a/0/6/5')
LAND_BASE = 800                 # our interiors' lands (caves are 720 on)
WALL_H, LOW_H = 24, 12          # a wall a block and a half high; a table or a machine, three quarters of a block

LOOKS = {   # HeartGold texture set (and area), floor, wall face, wall top, low block top, warp squares
    'tower': dict(area=77, floor='d15_yuka01', wall='d17_wall01', top='d15_wall01a', low='d17_ita', mark='d15_yuka03'),
    'plant': dict(area=44, floor='kn_c_yuka2', wall='kn_c_kabe1', top='mpwr_r04', low='counter_g02', mark='kn_c_stair'),
    'ship': dict(area=42, floor='sn_h_yuka1', wall='sn_h_kabe1', top='h_kage', low='table01', mark='ar_s_mat'),
    'house': dict(area=42, floor='mo_yuka', wall='mo_kabe', top='h_kage', low='table01', mark='d_mat01'),
    # outdoors (the Safari Zone): Fuchsia's set; the GBA's trees are a hedge of HeartGold's trees (a row of them
    # on each face, the canopy on top), with its tall grass and ponds
    'safari': dict(area=16, floor='grass02', wall='tree01_re', top='tree01_un', low='etc_a', mark='road01',
                   grass='egrass', water='pond_un'),
}
TALL_GRASS_MB = {2}
WATER_MB = {16, 17, 18, 19, 20, 21, 24, 26, 44, 45}


def _floors(name, n, look, template, first=1):
    return [dict(gba='%s_%dF_Frlg' % (name, i), map='MAP_CANVAS_%s_%dF' % (name.upper(), i), look=look, template=template,
                 depth=-i) for i in range(first, n + 1)]


SS = 'MAP_SS_AQUA_1F'
INTERIORS = (
    # the Pokemon Tower stands where HeartGold's Lavender has its Radio Tower: that door leads in
    [dict(gba='PokemonTower_1F_Frlg', map='MAP_CANVAS_POKEMON_TOWER_1F', look='tower', template='MAP_SPROUT_TOWER_1F', place='MAP_LAVENDER',
          depth=-1, exits={'MAP_LAVENDER_TOWN': ('MAP_LAVENDER', 6)})] +
    [dict(gba='PokemonTower_%dF_Frlg' % i, map='MAP_CANVAS_POKEMON_TOWER_%dF' % i, look='tower', template='MAP_SPROUT_TOWER_2F',
          place='MAP_LAVENDER', depth=-i) for i in range(2, 8)] +
    # Silph Co.: HeartGold's headquarters is the 1F (ported there); its elevator door leads to our 2F's stairs
    [dict(gba='SilphCo_%dF_Frlg' % i, map='MAP_CANVAS_SILPH_CO_%dF' % i, look='plant', template='MAP_SAFFRON_SILPH_CO_HQ',
          depth=-i, exits={('MAP_SILPH_CO_1F', '3'): ('MAP_SAFFRON_SILPH_CO_HQ', 1)}) for i in range(2, 12)] +
    [dict(gba='PowerPlant_Frlg', map='MAP_CANVAS_POWER_PLANT', look='plant', template='MAP_ROUTE_10_POWER_PLANT_REPAIRED',
          depth=0, exits={'MAP_ROUTE10': ('MAP_ROUTE_10', 1)})] +
    # the S.S. Anne: HeartGold's ferry building at Vermilion's dock leads aboard (the GBA's dock outside is left out)
    [dict(gba='SSAnne_1F_Corridor_Frlg', map='MAP_CANVAS_SSANNE_1F', look='ship', template=SS, depth=-1,
          exits={'MAP_SSANNE_EXTERIOR': ('MAP_VERMILION', 7)}),
     dict(gba='SSAnne_2F_Corridor_Frlg', map='MAP_CANVAS_SSANNE_2F', look='ship', template=SS, depth=-2),
     dict(gba='SSAnne_3F_Corridor_Frlg', map='MAP_CANVAS_SSANNE_3F', look='ship', template=SS, depth=-3),
     dict(gba='SSAnne_B1F_Corridor_Frlg', map='MAP_CANVAS_SSANNE_B1F', look='ship', template=SS, depth=0),
     dict(gba='SSAnne_Deck_Frlg', map='MAP_CANVAS_SSANNE_DECK', look='ship', template=SS, depth=-4),
     dict(gba='SSAnne_Kitchen_Frlg', map='MAP_CANVAS_SSANNE_KITCHEN', look='ship', template=SS, depth=-1),
     dict(gba='SSAnne_CaptainsOffice_Frlg', map='MAP_CANVAS_SSANNE_CAPTAIN', look='ship', template=SS, depth=-2)] +
    [dict(gba='SSAnne_%s_Room%d_Frlg' % (f, i), map='MAP_CANVAS_SSANNE_%s_R%d' % (f, i), look='ship', template=SS,
          depth={'1F': -1, '2F': -2, 'B1F': 0}[f]) for f, n in (('1F', 7), ('2F', 6), ('B1F', 5)) for i in range(1, n + 1)] +
    # the Rocket Hideout, under the Game Corner (stairs added there: ADD_WARPS). Its spin-tile mazes are plain floor
    # for now (HeartGold's slide tiles need a gym's code running), and its elevator (a GBA dynamic warp) isn't built
    [dict(gba='RocketHideout_B%dF_Frlg' % i, map='MAP_CANVAS_ROCKET_HIDEOUT_B%dF' % i, look='plant', template='MAP_SAFFRON_SILPH_CO_HQ', place='MAP_CELADON',
          depth=i, exits={'MAP_CELADON_CITY_GAME_CORNER': ('MAP_CELADON_GAME_CORNER', 1)}) for i in range(1, 5)]
)
# Cinnabar (our town: build_cinnabar.py draws the GBA's in place of HeartGold's ruin)
CIN = {('MAP_CINNABAR_ISLAND', str(i)): ('MAP_CINNABAR_ISLAND', i) for i in range(5)}   # (build_cinnabar.py: the GBA's warps, in order)
INTERIORS += (
    [dict(gba='CinnabarIsland_Gym_Frlg', map='MAP_CANVAS_CINNABAR_GYM', look='plant', template='MAP_SEAFOAM_ISLANDS_CINNABAR_GYM', depth=0, exits=CIN,
          place='MAP_CINNABAR_ISLAND'),
     dict(gba='CinnabarIsland_Mart_Frlg', map='MAP_CANVAS_CINNABAR_MART', look='plant', template='MAP_VIRIDIAN_POKEMART', depth=0, exits=CIN, place='MAP_CINNABAR_ISLAND'),
     dict(gba='CinnabarIsland_PokemonLab_Entrance_Frlg', map='MAP_CANVAS_CINNABAR_LAB', look='plant', template='MAP_SAFFRON_SILPH_CO_HQ', depth=0, exits=CIN, place='MAP_CINNABAR_ISLAND')] +
    [dict(gba='CinnabarIsland_PokemonLab_%s_Frlg' % r, map='MAP_CANVAS_CINNABAR_LAB_%s' % r.upper(), look='plant', template='MAP_SAFFRON_SILPH_CO_HQ',
          depth=0) for r in ('Lounge', 'ResearchRoom', 'ExperimentRoom')] +
    [dict(gba='PokemonMansion_%s_Frlg' % f, map='MAP_CANVAS_POKEMON_MANSION_%s' % f, look='tower', template='MAP_BURNED_TOWER_1F',
          depth={'1F': -1, '2F': -2, '3F': -3, 'B1F': 0}[f], exits=CIN, place='MAP_CINNABAR_ISLAND') for f in ('1F', '2F', '3F', 'B1F')]
)
# the Safari Zone, through a door we add at the back of HeartGold's Pal Park entrance (where the GBA's is)
SZ = 'MAP_SAFARI_ZONE_01'
INTERIORS += (
    [dict(gba='SafariZone_Center_Frlg', map='MAP_CANVAS_SAFARI_CENTER', look='safari', template=SZ, depth=0,
          exits={'MAP_FUCHSIA_CITY_SAFARI_ZONE_ENTRANCE': ('MAP_FUCHSIA_PAL_PARK_ENTRANCE', 1)}),
     dict(gba='SafariZone_East_Frlg', map='MAP_CANVAS_SAFARI_EAST', look='safari', template=SZ, depth=0),
     dict(gba='SafariZone_North_Frlg', map='MAP_CANVAS_SAFARI_NORTH', look='safari', template=SZ, depth=0),
     dict(gba='SafariZone_West_Frlg', map='MAP_CANVAS_SAFARI_WEST', look='safari', template=SZ, depth=0)] +
    [dict(gba='SafariZone_%s_Frlg' % r, map='MAP_CANVAS_SAFARI_%s' % r.upper().replace('_RESTHOUSE', '_REST'), look='house',
          template='MAP_FUCHSIA_SOUTHWEST_HOUSE', depth=0)
     for r in ('Center_RestHouse', 'East_RestHouse', 'North_RestHouse', 'West_RestHouse', 'SecretHouse')]
)
# warps we add to HeartGold's rooms: (map, square, its behaviour, our map, GBA warp index there). Each goes last in
# the room's warp list, so no other warp's number moves.
ADD_WARPS = [('MAP_CELADON_GAME_CORNER', (12, 3), 0x3E, 'MAP_CANVAS_ROCKET_HIDEOUT_B1F', 0),    # (the GBA's hidden stairs)
             ('MAP_FUCHSIA_PAL_PARK_ENTRANCE', (8, 4), 0x3E, 'MAP_CANVAS_SAFARI_CENTER', 1)]
# HeartGold's doors that stood for these places -> ours: (map, its warp index) -> (our map, GBA warp index there)
DOORS = {('MAP_LAVENDER', 6): ('MAP_CANVAS_POKEMON_TOWER_1F', 1),
         ('MAP_SAFFRON_SILPH_CO_HQ', 1): ('MAP_CANVAS_SILPH_CO_2F', 3),
         ('MAP_ROUTE_10', 1): ('MAP_CANVAS_POWER_PLANT', 1),
         ('MAP_VERMILION', 7): ('MAP_CANVAS_SSANNE_1F', 2)}


def gba_ids():
    return {c['gba']: gba_map.map_json(c['gba'])['id'] for c in INTERIORS}


def build_floor(spec, depth_of):
    gm = gba_map.map_json(spec['gba'])
    lay = gba_map.Layout(gm['layout'])
    W, H = lay.w, lay.h
    look = LOOKS[spec['look']]
    dims, pals = texdims(look['area'])
    pal_of = lambda t: next(p for p in (t + '_pl', t) if p in pals)
    warps = {(w['x'], w['y']): w for w in gm.get('warp_events', [])}
    blocked = lambda x, y: not (0 <= x < W and 0 <= y < H) or (lay.collision(x, y) != 0 and (x, y) not in warps)
    # little patches of blocked squares out on the floor: low blocks (tables, machines, gravestones)
    low, seen = set(), set()
    for y in range(H):
        for x in range(W):
            if not blocked(x, y) or (x, y) in seen: continue
            comp, stack, edge = [], [(x, y)], False
            seen.add((x, y))
            while stack:
                c = stack.pop(); comp.append(c)
                if c[0] in (0, W - 1) or c[1] in (0, H - 1): edge = True
                for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                    n = (c[0] + dx, c[1] + dy)
                    if 0 <= n[0] < W and 0 <= n[1] < H and blocked(*n) and n not in seen:
                        seen.add(n); stack.append(n)
            if len(comp) <= 6 and not edge: low |= set(comp)
    floor = lambda x, y: not blocked(x, y)
    near_floor = lambda x, y: any(floor(x + dx, y + dy) for dx in (-1, 0, 1) for dy in (-1, 0, 1))
    outdoors = 'grass' in look            # (outdoors every tree is drawn: no dark between the hedges)
    height = lambda x, y: 0 if floor(x, y) else LOW_H if (x, y) in low else WALL_H if outdoors or near_floor(x, y) else None
    nx, nz = math.ceil(W / 32), math.ceil(H / 32)
    mb = lambda x, y: lay.behavior(lay.metatile(x, y))
    water = {(x, y) for y in range(H) for x in range(W) if floor(x, y) and 'water' in look and mb(x, y) in WATER_MB}
    grass = {(x, y) for y in range(H) for x in range(W) if floor(x, y) and 'grass' in look and mb(x, y) in TALL_GRASS_MB}
    # how each warp square acts
    kind = {}
    for (x, y), w in warps.items():
        dest = w['dest_map']
        if dest in depth_of and dest != gm['id']:
            kind[(x, y)] = 0x3C if depth_of[dest] < spec['depth'] else 0x3E
        elif blocked(x, y + 1) and not blocked(x, y - 1):
            kind[(x, y)] = 0x65             # (a way out at the foot of the wall: walk on into it)
        else:
            kind[(x, y)] = 0x3E
    lands = []
    U = lambda v, o: (v - o) * 16 - 256
    up = (0, 1, 0)
    for lz in range(nz):
        for lx in range(nx):
            meshes = {}
            M = lambda t: meshes.setdefault(t, Mesh())
            ox, oz = lx * 32, lz * 32
            perm = [0x8000] * 1024
            tops = {}                         # (texture, height) -> squares, drawn in runs
            faces = {}                        # (height, side) -> edges, drawn in runs
            for y in range(oz - 1, oz + 33):
                for x in range(ox - 1, ox + 33):
                    inland = ox <= x < ox + 32 and oz <= y < oz + 32
                    h = height(x, y)
                    if inland and 0 <= x < W and 0 <= y < H:
                        i = (y - oz) * 32 + (x - ox)
                        if floor(x, y):
                            perm[i] = kind.get((x, y), 0x0010 if (x, y) in water else 0x0002 if (x, y) in grass else 0x0000)
                    if not inland or h is None: continue
                    tex = look['floor'] if h == 0 else look['low'] if h == LOW_H else look['top']
                    if (x, y) in warps and kind[(x, y)] != 0x65: tex = look['mark']
                    elif (x, y) in water: tex, h = look['water'], -2
                    elif (x, y) in grass: tex = look['grass']
                    tops.setdefault((tex, h), set()).add((x, y))
                    if h:
                        for n in ((0, 1), (0, -1), (1, 0), (-1, 0)):
                            hn = height(x + n[0], y + n[1])
                            if hn is not None and hn < h:
                                faces.setdefault((h, hn, n), set()).add((x, y))
            for (tex, h), cells in tops.items():
                tw, th = dims[tex]
                left = set(cells)
                for (x, y) in sorted(cells, key=lambda c: (c[1], c[0])):
                    if (x, y) not in left: continue
                    k = 1
                    while (x + k, y) in left and tex != look['mark']: k += 1
                    for j in range(k): left.discard((x + j, y))
                    x0, x1, z0, z1 = U(x, ox), U(x + k, ox), U(y, oz), U(y + 1, oz)
                    s0, s1, t0, t1 = x * 16 * tw / 32, (x + k) * 16 * tw / 32, y * 16 * th / 32, (y + 1) * 16 * th / 32
                    M(tex).quad([((x0, h, z1), (s0, t1)), ((x1, h, z1), (s1, t1)), ((x1, h, z0), (s1, t0)), ((x0, h, z0), (s0, t0))], up)
            wall = look['wall']
            tw, th = dims[wall]
            for (h, hn, n), cells in faces.items():
                along_x = n[0] == 0
                left = set(cells)
                for (x, y) in sorted(cells, key=(lambda c: (c[1], c[0])) if along_x else (lambda c: (c[0], c[1]))):
                    if (x, y) not in left: continue
                    k = 1
                    step = (1, 0) if along_x else (0, 1)
                    while (x + step[0] * k, y + step[1] * k) in left: k += 1
                    for j in range(k): left.discard((x + step[0] * j, y + step[1] * j))
                    # the edge on side n of squares x..x+k (or y..y+k)
                    if along_x:
                        zz = U(y + (1 if n[1] > 0 else 0), oz)
                        a, b = (U(x, ox), zz), (U(x + k, ox), zz)
                        if n[1] < 0: a, b = b, a
                        s0, s1 = x * 16 * tw / 32, (x + k) * 16 * tw / 32
                    else:
                        xx = U(x + (1 if n[0] > 0 else 0), ox)
                        a, b = (xx, U(y + k, oz)), (xx, U(y, oz))
                        if n[0] < 0: a, b = b, a
                        s0, s1 = y * 16 * tw / 32, (y + k) * 16 * tw / 32
                    v1 = th * (h - hn) / WALL_H
                    M(wall).quad([((a[0], hn, a[1]), (s0, v1)), ((b[0], hn, b[1]), (s1, v1)), ((b[0], h, b[1]), (s1, 0)), ((a[0], h, a[1]), (s0, 0))],
                                 (n[0], 0, n[1]))
            if not meshes:
                M(look['top']).quad([((-256, WALL_H, 256), (0, 8)), ((256, WALL_H, 256), (8, 8)), ((256, WALL_H, -256), (8, 0)), ((-256, WALL_H, -256), (0, 0))], up)
            groups = [(t, t, pal_of(t), mesh, {'repeat': 3, 'size': dims[t]}) for t, mesh in meshes.items()]
            model = build_model('cv_in_%d' % (len(lands) + 10 * (spec['depth'] + 20)), groups)
            model += b'\0' * (-len(model) % 4)
            bdhc = struct.pack('<4s6H', b'BDHC', 2, 1, 1, 1, 1, 1) + struct.pack('<2i2i', -256 * 4096, -256 * 4096, 256 * 4096, 256 * 4096) + \
                struct.pack('<3i', 0, 4096, 0) + struct.pack('<i', 0) + struct.pack('<4H', 0, 1, 0, 0) + struct.pack('<iHH', 256 * 4096, 1, 0) + struct.pack('<H', 0)
            p = struct.pack('<1024H', *perm)
            lands.append(struct.pack('<4I2H', len(p), 0, len(model), len(bdhc), 0x1234, 0) + p + model + bdhc)
            assert len(model) < 60000, ('model too big for a land', spec['gba'], len(lands), len(model))
    return gm, (nx, nz), lands


def main():
    ids = gba_ids()
    for g, m in ids.items():
        SLOTS[m] = next(c['map'] for c in INTERIORS if c['gba'] == g)
    depth_of = {ids[c['gba']]: c['depth'] for c in INTERIORS}
    land, btnf = read_narc(open(LAND_NARC, 'rb').read())
    lid = LAND_BASE
    for spec in INTERIORS:
        tmpl = header(spec['template'])
        gm, (nx, nz), lands = build_floor(spec, depth_of)
        lids = list(range(lid, lid + len(lands)))
        land += [b''] * max(0, lids[-1] + 1 - len(land))
        for i, d in zip(lids, lands): land[i] = d
        lid += len(lands)
        new_map(spec['map'])
        tag = spec['map'].replace('MAP_CANVAS_', '')
        mat = matrix_file(tag, nx, nz, lids)
        ev = json.load(open(os.path.join(slots.EVENT_DIR, events_file(spec['template']))))
        ev['warps'] = [{k: v for k, v in w.items() if not k.startswith('_')} for w in gba_warps(gm)]
        for w, gw in zip(ev['warps'], gm['warp_events']):
            ex = spec.get('exits', {}).get((gw['dest_map'], str(gw['dest_warp_id'])), spec.get('exits', {}).get(gw['dest_map']))
            if ex:
                w.update(x=gw['x'], z=gw['y'], y=0, header=ex[0], anchor=ex[1])
        ev['objects'], ev['bgs'], ev['coords'] = [], [], []
        evn = new_events_file(tag, ev)
        fields = {k: v for k, v in tmpl.items() if k not in ('matrixId', 'eventsBank')}
        fields.update(matrixId=mat, eventsBank=evn, areaDataBank=str(LOOKS[spec['look']]['area']), weather='0', **NO_SCRIPTS)
        if spec.get('place'):       # (the name shown on entering: the town's, where the template is elsewhere)
            fields['mapsec'] = header(spec['place'])['mapsec']
        set_header(spec['map'], fields)
        print(spec['gba'], '->', spec['map'], '%dx%d lands' % (nx, nz), lids)
    land = [d if d else land[209] for d in land]
    open(LAND_NARC, 'wb').write(write_narc(land, btnf))
    import world
    for m, (x, z), beh, to, anchor in ADD_WARPS:
        w_, h_, ls = world.map_matrix(m)
        lid = ls[(z // 32) * w_ + x // 32]
        d = bytearray(land[lid])
        struct.pack_into('<H', d, 0x14 + ((z % 32) * 32 + x % 32) * 2, beh)
        land[lid] = bytes(d)
        path = os.path.join(slots.EVENT_DIR, events_file(m))
        ev = json.load(open(path))
        ev['warps'] = [w for w in ev['warps'] if not (w['x'] == x and w['z'] == z)]
        ev['warps'].append({'x': x, 'z': z, 'header': to, 'anchor': anchor, 'y': 0})
        json.dump(ev, open(path, 'w'), indent=4); open(path, 'a').write('\n')
    open(LAND_NARC, 'wb').write(write_narc(land, btnf))
    for (m, i), (to, anchor) in DOORS.items():
        path = os.path.join(slots.EVENT_DIR, events_file(m))
        ev = json.load(open(path))
        ev['warps'][i].update(header=to, anchor=anchor)
        json.dump(ev, open(path, 'w'), indent=4); open(path, 'a').write('\n')


if __name__ == '__main__':
    main()
