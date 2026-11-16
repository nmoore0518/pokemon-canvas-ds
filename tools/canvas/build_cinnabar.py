"""Canvas: Cinnabar Island as the GBA game has it, in place of HeartGold's (the ruin after the eruption, with only
its Pokemon Center).

The GBA town (24x20) is drawn into HeartGold's Cinnabar land (205, matrix cell 32,15) at its east and north edges,
where the GBA's Route 20 and Route 21 meet it; the rest of the land is sea. Ground is HeartGold's sand and grass
(by the colour of the GBA's ground there), the sea HeartGold's (behaviour 0x15, surf), the GBA's rocks in the sea
HeartGold's sea rocks. The buildings are HeartGold models on the GBA's doors: its Pokemon Center and Mart, its Gym,
and Oak's lab model for the Pokemon Lab and the Mansion. Collision is the GBA's; door squares are HeartGold doors.
The town's warps become the GBA's, in its order (Mansion, Gym, Lab, Center, Mart), and HeartGold's Center leads
back to its own door.

Run after build_interiors.py (Cinnabar's rooms), and before the porter.
"""
import json, os, struct, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from nitro import read_narc, write_narc
from g3d import Mesh, build_model
import gba_map, slots
from build_rooms import texdims

LAND_NARC = os.path.join(slots.ROOT, 'files/a/0/6/5')
LAND = 205                        # HeartGold's Cinnabar
CELL = (32, 15)
OX, OZ = 8, 0                     # the GBA map's corner in the land
TEXSET = 18
ANIM_SLOTS = ['pond_on', 'swave_p', 'pond_edge', 'sea_line02', 'sea_un', 'sea_on', 'river', 'river_r']   # (see build_pallet.py)
GROUND, SEA = 0, -2
WATER_MB = {16, 17, 18, 19, 20, 21, 24, 26, 44, 45}
# by the GBA door they stand on: HeartGold model, its door model, door offset from the model (units), door centre x
BUILDINGS = {
    'MAP_POKEMON_MANSION_1F': (314, 311, (10.0, 2.64, 19.52), -10.0),
    'MAP_CINNABAR_ISLAND_GYM': (318, 16, (0, 0, 22.48), 0),
    'MAP_CINNABAR_ISLAND_POKEMON_LAB_ENTRANCE': (314, 311, (10.0, 2.64, 19.52), -10.0),
    'MAP_CINNABAR_ISLAND_POKEMON_CENTER_1F': (40, 15, (0, 0, 25.73), 0),
    'MAP_CINNABAR_ISLAND_MART': (39, 15, (-8.93, 0, 12.11), 0),
}
ROOMS = {   # GBA room -> our map (HeartGold's Center for the Center)
    'MAP_POKEMON_MANSION_1F': 'MAP_CANVAS_POKEMON_MANSION_1F', 'MAP_CINNABAR_ISLAND_GYM': 'MAP_CANVAS_CINNABAR_GYM',
    'MAP_CINNABAR_ISLAND_POKEMON_LAB_ENTRANCE': 'MAP_CANVAS_CINNABAR_LAB', 'MAP_CINNABAR_ISLAND_MART': 'MAP_CANVAS_CINNABAR_MART',
    'MAP_CINNABAR_ISLAND_POKEMON_CENTER_1F': 'MAP_CINNABAR_ISLAND_POKECENTER_1F',
}
GX0, GZ0 = CELL[0] * 32 + OX, CELL[1] * 32 + OZ      # the GBA map's corner in the world


def main():
    gm = gba_map.map_json('CinnabarIsland_Frlg')
    lay = gba_map.Layout(gm['layout'])
    W, H = lay.w, lay.h
    dims, pals = texdims(TEXSET)
    pal_of = lambda t: next(p for p in (t + '_pl', t, t.replace('gs', '')) if p in pals)
    doors = {(w['x'], w['y']): w for w in gm['warp_events']}

    def at(lx, lz):
        """-> 'sea' | 'rock' | 'ground' | 'block' for a square of the land"""
        x, y = lx - OX, lz - OZ
        if not (0 <= x < W and 0 <= y < H): return 'sea'
        mb = lay.behavior(lay.metatile(x, y))
        if mb in WATER_MB: return 'rock' if lay.collision(x, y) else 'sea'
        if lay.collision(x, y) and (x, y) not in doors:
            # (the GBA's rocks out in the sea: blocked squares with sea round them)
            if all(lay.behavior(lay.metatile(x + dx, y + dy)) in WATER_MB for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))
                   if 0 <= x + dx < W and 0 <= y + dy < H):
                return 'rock'
            return 'block'
        return 'ground'

    def ground_tex(lx, lz):
        r, g, b = lay.render_metatile(lay.metatile(lx - OX, lz - OZ)).convert('RGB').resize((1, 1)).getpixel((0, 0))
        return 'grass02' if g > r + 10 and g > b else 'beach01'

    meshes = {t: Mesh() for t in ANIM_SLOTS}
    M = lambda t: meshes.setdefault(t, Mesh())
    U = lambda v: v * 16 - 256
    up = (0, 1, 0)
    perm = [0x8000] * 1024
    rows = {}
    for lz in range(32):
        for lx in range(32):
            k = at(lx, lz)
            i = lz * 32 + lx
            if k == 'sea':
                perm[i] = 0x0015; tex, h = 'sea_un', SEA
            elif k == 'rock':
                perm[i] = 0x8000; tex, h = 'sea_rock', SEA
            elif k == 'ground':
                perm[i] = 0x0000; tex, h = ground_tex(lx, lz), GROUND
            else:
                perm[i] = 0x8000; tex, h = ground_tex(lx, lz), GROUND
            rows.setdefault((tex, h, lz), []).append(lx)
    for (tex, h, lz), xs in rows.items():
        xs.sort()
        tw, th = dims[tex]
        runs, start = [], xs[0]
        for a, b in zip(xs, xs[1:] + [None]):
            if b != a + 1 or tex == 'sea_rock':
                runs.append((start, a + 1)); start = b
        for x0, x1 in runs:
            M(tex).quad([((U(x0), h, U(lz + 1)), (x0 * 16, (lz + 1) * 16)), ((U(x1), h, U(lz + 1)), (x1 * 16, (lz + 1) * 16)),
                         ((U(x1), h, U(lz)), (x1 * 16, lz * 16)), ((U(x0), h, U(lz)), (x0 * 16, lz * 16))], up)
    # the shore: a face from the ground down to the sea where they meet
    for lz in range(32):
        for lx in range(32):
            if at(lx, lz) not in ('ground', 'block'): continue
            for n in ((0, 1), (0, -1), (1, 0), (-1, 0)):
                if 0 <= lx + n[0] < 32 and 0 <= lz + n[1] < 32 and at(lx + n[0], lz + n[1]) in ('sea', 'rock'):
                    if n[0] == 0:
                        z = U(lz + (1 if n[1] > 0 else 0)); a, b = (U(lx), z), (U(lx + 1), z)
                        if n[1] < 0: a, b = b, a
                    else:
                        x = U(lx + (1 if n[0] > 0 else 0)); a, b = (x, U(lz + 1)), (x, U(lz))
                        if n[0] < 0: a, b = b, a
                    M('beach01_r2').quad([((a[0], SEA, a[1]), (0, 16)), ((b[0], SEA, b[1]), (16, 16)), ((b[0], GROUND, b[1]), (16, 0)),
                                          ((a[0], GROUND, a[1]), (0, 0))], (n[0], 0, n[1]))
    # buildings on the GBA's doors; door squares are HeartGold doors (blocked, behaviour 0x69: walk into them)
    props = []
    f = lambda v: int(round(v * 4096))
    for (x, y), w in doors.items():
        if w['dest_map'] not in BUILDINGS: continue
        model, door, off, cx = BUILDINGS[w['dest_map']]
        lx, lz = x + OX, y + OZ
        perm[lz * 32 + lx] = 0x8069
        ox, oz = (lx + 0.5) * 16 - off[0] - cx, (lz + 1) * 16 - off[2]
        props.append(struct.pack('<I3i3i3i8x', model, f(ox - 256), f(GROUND), f(oz - 256), 0, 0, 0, 4096, 4096, 4096))
        props.append(struct.pack('<I3i3i3i8x', door, f(ox + off[0] - 256), f(GROUND + off[1]), f(oz + off[2] - 256), 0, 0, 0, 4096, 4096, 4096))
    # (HeartGold animates this area's first eight materials by index: they hold their places, sea_un's is the sea)
    groups = [(t, 'sea_un', pal_of('sea_un'), meshes[t] if t == 'sea_un' else Mesh(), {'repeat': 3, 'flip': 0, 'size': dims['sea_un']})
              for t in ANIM_SLOTS] + \
             [(t, t, pal_of(t), m, {'repeat': 3, 'size': dims[t]}) for t, m in meshes.items() if t not in ANIM_SLOTS]
    model = build_model('cv_cinnabar', groups)
    model += b'\0' * (-len(model) % 4)
    assert len(model) < 60000, len(model)
    bld = b''.join(props)
    bdhc = struct.pack('<4s6H', b'BDHC', 2, 1, 1, 1, 1, 1) + struct.pack('<2i2i', -256 * 4096, -256 * 4096, 256 * 4096, 256 * 4096) + \
        struct.pack('<3i', 0, 4096, 0) + struct.pack('<i', 0) + struct.pack('<4H', 0, 1, 0, 0) + struct.pack('<iHH', 256 * 4096, 1, 0) + struct.pack('<H', 0)
    p = struct.pack('<1024H', *perm)
    land, btnf = read_narc(open(LAND_NARC, 'rb').read())
    land[LAND] = struct.pack('<4I2H', len(p), len(bld), len(model), len(bdhc), 0x1234, 0) + p + bld + model + bdhc
    open(LAND_NARC, 'wb').write(write_narc(land, btnf))
    # the town's warps: the GBA's, in its order
    path = os.path.join(slots.EVENT_DIR, slots.events_file('MAP_CINNABAR_ISLAND'))
    ev = json.load(open(path))
    ev['warps'] = []
    for w in gm['warp_events']:
        to = ROOMS[w['dest_map']]
        anchor = 0 if to == 'MAP_CINNABAR_ISLAND_POKECENTER_1F' else int(w['dest_warp_id'])
        ev['warps'].append({'x': GX0 + w['x'], 'z': GZ0 + w['y'], 'header': to, 'anchor': anchor, 'y': 0})
    json.dump(ev, open(path, 'w'), indent=4); open(path, 'a').write('\n')
    # HeartGold's Center leads back to its door
    pc = next(i for i, w in enumerate(gm['warp_events']) if w['dest_map'] == 'MAP_CINNABAR_ISLAND_POKEMON_CENTER_1F')
    path = os.path.join(slots.EVENT_DIR, slots.events_file('MAP_CINNABAR_ISLAND_POKECENTER_1F'))
    ev = json.load(open(path))
    for w in ev['warps']:
        if w['header'] == 'MAP_CINNABAR_ISLAND': w['anchor'] = pc
    json.dump(ev, open(path, 'w'), indent=4); open(path, 'a').write('\n')
    print('Cinnabar: land %d, %d buildings, model %d bytes' % (LAND, len(props) // 2, len(model)))


if __name__ == '__main__':
    main()
