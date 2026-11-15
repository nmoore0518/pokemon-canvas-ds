"""Canvas: build the GBA game's interiors as HeartGold rooms.

Each room comes from a GBA map (layout + events). Its walkable squares become a floor, the wall rows become
HeartGold's back wall, and recognised furniture (a table per GBA tileset, FURNITURE below) becomes HeartGold's
own room models. Rooms go into existing HeartGold map slots (ROOMS below): the slot's matrix is pointed at a new
land, and its events are rewritten from the GBA map's.
"""
import json, os, re, struct, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from nitro import read_narc, write_narc, read_dict, read_tex0, tex0_of, write_btx0, u16, u32
from g3d import Mesh, build_model
import gba_map
import cards
from slots import SLOTS, ROOM_SLOTS, matrix_file, events_file, gba_warps, header, set_header, new_events_file, new_matrix_file

ROOT = os.path.normpath(os.path.join(HERE, '..', '..'))
F = lambda p: os.path.join(ROOT, p)
LAND_NARC = F('files/a/0/6/5')
TEXSETS = F('files/a/0/4/4')
AREA_DATA = F('files/a/0/4/2')
AREA_BUILD = F('files/a/0/4/3')
AREA_BUILD_TEX = F('files/a/0/7/0')
BM_ROOM = F('files/a/1/4/8')
MATRIX_DIR = F('files/fielddata/mapmatrix/map_matrix')
EVENT_DIR = F('files/fielddata/eventdata/zone_event')
ROOM_LAND_BASE = 690            # our room lands start here (Pallet's outdoor lands are 676..681)
OUR_SETS_BASE = 106             # rooms drawn in GBA art get a texture set + area entry of their own from here on

# ---------------------------------------------------------------- furniture: GBA metatile -> HeartGold room model
# key: the object's top-left metatile id in the GBA tileset; value: (bm_room model, width, height in squares,
# where it stands: 'wall' = against the back wall in the first floor row, 'floor' = centred on its footprint)
FURNITURE = {
    # (what, bm_room model, width, height, where, height off the floor in units)
    'gTileset_BuildingFrlg': {
        0x31: ('kitchen', 20, 2, 2, 'wall', 0),
        0x36: ('cupboard', 64, 2, 2, 'wall', 0),
        0x2D: ('tv', 19, 1, 3, 'wall', 0),
        0x2B: ('bookshelf', 66, 2, 3, 'wall', 0),
        0x184: ('painting', 60, 1, 2, 'wallhang', 16),
        0x96: ('poster', 60, 1, 2, 'wallhang', 16),
        0x98: ('poster', 60, 1, 2, 'wallhang', 16),
        0x47: ('plant', 23, 1, 2, 'floor', 0),
        0x57: ('plant', 23, 1, 2, 'floor', 0),
        0x4C: ('table', 94, 2, 2, 'floor', 0),
        0x4B: ('chair', 53, 1, 1, 'floor', 0),
        0x4E: ('chair', 53, 1, 1, 'floor', 0),
        0x13: ('mat', 1, 1, 1, 'floor', 0),
        0x35: ('tv', 19, 1, 1, 'floorif', 0),     # (a TV on its own; under 0x2D it is part of that one)
        0x73: ('bookshelf', 30, 2, 1, 'shelf', 0),
        0x75: ('monitor', 33, 1, 2, 'wall', 0),
        0x85: ('machine', 27, 1, 2, 'wall', 0),
    },
    'gTileset_GenericBuilding1': {
        0x287: ('pc', 33, 1, 3, 'wall', 0),
        0x283: ('bed', 17, 3, 3, 'floor', 0),
    },
    'gTileset_Lab_Frlg': {
        0x29D: ('pc', 34, 1, 3, 'wall', 0),
        0x2A6: ('machine', 29, 1, 2, 'wall', 0),
        0x295: ('bench', 24, 2, 2, 'wall', 0),
        0x2AB: ('starter machine', 119, 2, 2, 'floor', 0),
        0x32F: ('desk', 24, 2, 1, 'floor', 0),
        0x293: ('plant', 23, 1, 2, 'floor', 0),
        0x294: ('plant', 23, 1, 2, 'floor', 0),
        0x290: ('mat', 3, 3, 1, 'floor', 0),
    },
}
WINDOWS = {'gTileset_BuildingFrlg': {0x21: 2}}              # window metatile -> width
RUGS = {'gTileset_BuildingFrlg': {0x43: 'red_h_mat1_4'}}     # big rug's top-left -> floor texture
STAIRS_UP = {'gTileset_BuildingFrlg': {0x16: 7}, 'gTileset_PlayersBasement': {0x2A8: 7}}   # top-left of a staircase going up -> model
STAIRS_DOWN = {'gTileset_BuildingFrlg': {0x05: 9}}

# GBA behaviour -> HeartGold behaviour, for the squares that do something
BEHAVIOR = {0x65: 0x65, 0xEB: 0x5E, 0xEE: 0x5F, 0x86: 0x86, 0x83: 0x83, 0x85: 0x85}

# ---------------------------------------------------------------- rooms
HOUSE = dict(floor='red_h_yuka1', wall='red_h_kabe1', texset=43, buildset=41)
LAB = dict(floor='o_kido_yuka1', wall='o_kido_kaeb1', texset=43, buildset=41)
ROOMS = [   # GBA map, its GBA map constant (SLOTS gives the HeartGold slot), look, keep HeartGold's people there
    dict(gba='PalletTown_PlayersHouse_1F_Frlg', map='MAP_PALLET_TOWN_PLAYERS_HOUSE_1F', keep_people=True, **HOUSE),
    dict(gba='PalletTown_PlayersHouse_2F_Frlg', map='MAP_PALLET_TOWN_PLAYERS_HOUSE_2F', keep_people=True, **HOUSE),
    dict(gba='PalletTown_RivalsHouse_Frlg', map='MAP_PALLET_TOWN_RIVALS_HOUSE', keep_people=True, **HOUSE),
    dict(gba='PalletTown_House1_Frlg', map='MAP_PALLET_TOWN_HOUSE1', keep_people=False, **HOUSE),
    dict(gba='PalletTown_House2_Frlg', map='MAP_PALLET_TOWN_HOUSE2', keep_people=False, template='MAP_PALLET_TOWN_BLUES_HOUSE_1F', **HOUSE),
    dict(gba='PalletTown_ProfessorOaksLab_Frlg', map='MAP_PALLET_TOWN_PROFESSOR_OAKS_LAB', keep_people=False, **LAB),
    # our own rooms, drawn with the GBA art: floor = the plain floor metatile; cards = (x, y, w, h) squares of things
    # HeartGold has no model for, stood up leaning back like HeartGold's billboards; other floor marks become decals
    dict(gba='PalletTown_PlayersHouse_B1F_Frlg', map='MAP_PALLET_TOWN_PLAYERS_HOUSE_B1F', keep_people=False,
         template='MAP_PALLET_TOWN_REDS_HOUSE_1F', texset=43, buildset=41, area=43,
         gba_look=dict(tag='b1', floor=0x2AA, things=[
             (16, 32, 34, 32, [('v', 6), ('h', 6), ('v', 20)]),      # rail bench
             (48, 16, 32, 48, [('h', 6), ('v', 42)]),                 # synthesizer tank
             (96, 16, 56, 48, [('h', 4), ('v', 44)]),                 # ball maker
             (176, 0, 16, 32, [('h', 6), ('v', 26)]),                 # bookshelf
             (0, 80, 32, 32, [('h', 15), ('v', 17)]),                 # workbench
             (80, 104, 16, 24, [('h', 5), ('v', 19)]),                # ball changer: pillar
             (96, 112, 32, 16, [('h', 4), ('v', 12)]),                #   console
             (128, 104, 16, 24, [('h', 5), ('v', 19)]),               #   pillar
             (176, 96, 32, 32, [('v', 12), ('h', 6), ('v', 14)]),     # lab table and flasks
             (208, 80, 32, 32, [('v', 8), ('h', 8), ('v', 16)]),      # desk
             (0, 144, 16, 16, [('h', 4), ('v', 12)]),                 # trash can
             (224, 128, 16, 16, [('h', 3), ('v', 13)]),               # crates
             (208, 144, 32, 16, [('h', 3), ('v', 13)]),
         ])),
]


def texdims(texset):
    ts, _ = read_narc(open(TEXSETS, 'rb').read())
    d = ts[texset]
    t = tex0_of(d)
    dims = {}
    for nm, e in read_dict(d, t + u16(d, t + 0xE)):
        p = u32(e, 0)
        dims[nm.decode()] = (8 << ((p >> 20) & 7), 8 << ((p >> 23) & 7))
    pals = {nm.decode() for nm, _ in read_dict(d, t + u32(d, t + 0x34))}
    return dims, pals


V_SCALE = 1.3     # the camera looks down on rooms, so stood-up GBA art is drawn a little taller to read the same


def box(mesh, px, py, pw, ph, profile):
    """GBA art of a thing (pw x ph pixels at room pixel px, py) folded into a solid: `profile` runs down the picture
    from its top, ('h', n) = n rows of top surface lying flat, ('v', n) = n rows of face standing up.
    It is built from the front bottom edge (the bottom of the picture, at the front of its squares) backwards."""
    U = lambda v: v - 256                 # room pixels are land units
    a, b = U(px), U(px + pw)
    z, y, row = U(py + ph), 0.0, ph       # (texture row: counts up from the bottom of the picture)
    for kind, n in reversed(profile):
        if kind == 'v':
            hgt = n * V_SCALE
            mesh.quad([((a, y, z), (0, row)), ((b, y, z), (pw, row)), ((b, y + hgt, z), (pw, row - n)), ((a, y + hgt, z), (0, row - n))], (0, 0, 1))
            y += hgt
        else:
            mesh.quad([((a, y, z), (0, row)), ((b, y, z), (pw, row)), ((b, y, z - n), (pw, row - n)), ((a, y, z - n), (0, row - n))], (0, 1, 0))
            # its sides, from the floor up to here, in the colours of the face's edge
            for xx, uu, nx in ((a, 0.5, -1), (b, pw - 0.5, 1)):
                mesh.quad([((xx, 0, z), (uu, ph)), ((xx, 0, z - n), (uu, ph)), ((xx, y, z - n), (uu, row)), ((xx, y, z), (uu, row))], (nx, 0, 0))
            z -= n
        row -= n


def build_room(spec, land_id):
    gm = gba_map.map_json(spec['gba'])
    lay = gba_map.Layout(gm['layout'])
    ts_name = gba_map.layouts()[gm['layout']]['primary_tileset']
    sec_name = gba_map.layouts()[gm['layout']]['secondary_tileset']
    tsn = lambda m: ts_name if m < lay.n_prim else sec_name
    W, H = lay.w, lay.h
    dims, pals = texdims(spec['texset'])
    own = []                      # (texture entry, palette entry) made from the GBA art for this room
    look = spec.get('gba_look')
    if look:
        tag = look['tag']
        def add(name, im, colours=255):
            t, p_, wh = cards.texture(name, im, colours)
            own.append((t, p_)); dims[name] = wh; pals.add(name + '_pl')
            return wh
        floor_im = lay.render_metatile(look['floor'])
        spec = dict(spec, floor='cv_%s_floor' % tag, wall='cv_%s_wall' % tag)
        add(spec['floor'], floor_im, 15)
        dims[spec['floor']] = (16, 16)
    pal_of = lambda t: next(p for p in (t + '_pl', t, t.replace('gs', '')) if p in pals)
    mid = lambda x, y: lay.metatile(x, y)
    blocked = lambda x, y: lay.collision(x, y) != 0
    # the first floor row: the first row with a walkable square
    first = next(y for y in range(H) if any(not blocked(x, y) for x in range(W)))
    wall_z = first - 0.5
    meshes = {}
    M = lambda t: meshes.setdefault(t, Mesh())
    U = lambda v: v * 16 - 256          # block -> land units
    up, fwd = (0, 1, 0), (0, 0, 1)
    # floor: every square from the first floor row down to the last row with anything walkable
    last = max(y for y in range(H) if any(not blocked(x, y) for x in range(W)))
    cols = [x for x in range(W) if any(not blocked(x, y) for y in range(first, last + 1))]
    x0, x1 = min(cols), max(cols) + 1
    fw, fh = dims[spec['floor']]
    holes = set()          # floor squares a staircase down goes through
    for y in range(H):
        for x in range(W):
            if mid(x, y) in STAIRS_DOWN.get(tsn(mid(x, y)), {}):
                holes |= {(x + i, y + j) for i in (0, 1) for j in (0, 1)}
    for y in range(first, last + 1):
        x = x0
        while x < x1:
            if (x, y) in holes: x += 1; continue
            e = x
            while e < x1 and (e, y) not in holes: e += 1
            z0f = wall_z if y == first else y
            M(spec['floor']).quad([((U(x), 0, U(y + 1)), ((x - x0) * fw, (y + 1 - wall_z) * fh)), ((U(e), 0, U(y + 1)), ((e - x0) * fw, (y + 1 - wall_z) * fh)),
                                   ((U(e), 0, U(z0f)), ((e - x0) * fw, (z0f - wall_z) * fh)), ((U(x), 0, U(z0f)), ((x - x0) * fw, (z0f - wall_z) * fh))], up)
            x = e
    # back wall, three blocks tall like HeartGold's
    ww, wh = dims[spec['wall']] if not look else (0, 0)
    if look:     # the GBA wall rows, stretched to HeartGold's wall height
        full = lay.render()
        strip = full.crop((x0 * 16, 0, x1 * 16, first * 16))
        add(spec['wall'], strip)
        M(spec['wall']).quad([((U(x0), 0, U(wall_z)), (0, first * 16)), ((U(x1), 0, U(wall_z)), ((x1 - x0) * 16, first * 16)),
                              ((U(x1), 48, U(wall_z)), ((x1 - x0) * 16, 0)), ((U(x0), 48, U(wall_z)), (0, 0))], fwd)
        covered = set()
        if look.get('things'):
            t, q, wh = cards.shadow_texture('cv_shadow')
            own.append((t, q)); dims['cv_shadow'] = wh; pals.add('cv_shadow_pl')
        for i, (px, py, pw, ph, profile) in enumerate(look.get('things', [])):
            im = cards.cut_out(full.crop((px, py, px + pw, py + ph)), floor_im, (px, py))
            name = 'cv_%s_t%d' % (tag, i)
            add(name, im)
            covered |= {(x, y) for x in range(px // 16, (px + pw + 15) // 16) for y in range(py // 16, (py + ph + 15) // 16)}
            box(M(name), px, py, pw, ph, profile)
            # a soft shadow a little wider than its footprint
            depth = sum(n for k, n in profile if k == 'h') or 4
            a_, b_, zf = U(px / 16) - 3, U((px + pw) / 16) + 3, U((py + ph) / 16) + 3
            zb = zf - depth - 8
            M('cv_shadow').quad([((a_, 0.25, zf), (0, 16)), ((b_, 0.25, zf), (32, 16)), ((b_, 0.25, zb), (32, 0)), ((a_, 0.25, zb), (0, 0))], up)
        for y in range(first, H):
            for x in range(W):
                m = mid(x, y)
                if (x, y) in covered or m == look['floor'] or m in STAIRS_UP.get(tsn(m), {}): continue
                if blocked(x, y):
                    near_stairs = any(mid(x - i_, y - j) in STAIRS_UP.get(tsn(mid(x - i_, y - j)), {})
                                      for i_ in (0, 1) for j in (0, 1) if x - i_ >= 0 and y - j >= 0)
                    if not near_stairs:
                        print('  (nothing drawn for blocked square', x, y, hex(m), ')')
                    continue
                name = 'cv_%s_m%x' % (tag, m)
                if name not in dims:
                    add(name, cards.cut_out(lay.render_metatile(m), floor_im), 15)
                M(name).quad([((U(x), 0.5, U(y + 1)), (0, 16)), ((U(x + 1), 0.5, U(y + 1)), (16, 16)),
                              ((U(x + 1), 0.5, U(y)), (16, 0)), ((U(x), 0.5, U(y)), (0, 0))], up)
    else:
        M(spec['wall']).quad([((U(x0), 0, U(wall_z)), (0, wh)), ((U(x1), 0, U(wall_z)), ((x1 - x0) * ww, wh)),
                              ((U(x1), 48, U(wall_z)), ((x1 - x0) * ww, 0)), ((U(x0), 48, U(wall_z)), (0, 0))], fwd)
    props, perm = [], [0x8000] * 1024
    for y in range(H):
        for x in range(W):
            if not blocked(x, y):
                perm[y * 32 + x] = 0x0000
            b = BEHAVIOR.get(lay.behavior(mid(x, y)))
            if b is not None:
                perm[y * 32 + x] = (perm[y * 32 + x] & 0x8000) | b
    # GBA lets you leave from any warp square of a doormat by walking into the wall below it; HeartGold
    # only from an exit-mat square, so every walkable warp square with a wall below becomes one
    for w in gm.get('warp_events', []):
        x, y = w['x'], w['y']
        if x < W and y < H and not blocked(x, y) and (y + 1 >= H or blocked(x, y + 1)) and perm[y * 32 + x] & 0xFF == 0:
            perm[y * 32 + x] = 0x65
    for y in range(H):
        for x in range(W):
            m = mid(x, y)
            fur = FURNITURE.get(tsn(m), {})
            if m in fur:
                name, model, w, h, where, yoff = fur[m]
                if where == 'floorif' and y > 0 and mid(x, y - 1) == 0x2D: continue
                cx = x + w / 2
                if where == 'wall': cz = first + 0.4
                elif where == 'wallhang': cz = wall_z + 0.1
                elif where == 'shelf': cz = y + 0.5 if y >= first else first + 0.4
                else: cz = y + h / 2
                props.append((model, U(cx), yoff, U(cz)))
            if m in WINDOWS.get(tsn(m), {}):
                w = WINDOWS[tsn(m)][m]          # HeartGold's window picture on the wall
                a, b = U(x + 0.1), U(x + w - 0.1)
                zz = U(wall_z) + 1
                M('red_h_mado').quad([((a, 17, zz), (0, 16)), ((b, 17, zz), (16, 16)), ((b, 40, zz), (16, 0)), ((a, 40, zz), (0, 0))], fwd)
            if m in STAIRS_UP.get(tsn(m), {}):
                props.append((STAIRS_UP[tsn(m)][m], U(x + 1), 0, U(first + 0.5)))
            if m in STAIRS_DOWN.get(tsn(m), {}):
                props.append((STAIRS_DOWN[tsn(m)][m], U(x + 1), 0, U(first + 0.5)))
            if m in RUGS.get(tsn(m), {}):
                t = RUGS[tsn(m)][m]
                # the rug runs to the end of its row/column of rug metatiles
                rw = 1                         # out to the top-right corner piece
                while x + rw < W and mid(x + rw - 1, y) != 0x46: rw += 1
                rh = 1                         # down to the bottom-left corner piece
                while y + rh < H and mid(x, y + rh - 1) != 0x5B: rh += 1
                tw, th = dims[t]
                M(t).quad([((U(x), 1, U(y + rh)), (0, th)), ((U(x + rw), 1, U(y + rh)), (tw, th)),
                           ((U(x + rw), 1, U(y)), (tw, 0)), ((U(x), 1, U(y)), (0, 0))], up)
    groups = []
    for t, mesh in meshes.items():
        rep = 0 if t.startswith('red_h_mat') or (t.startswith('cv_') and t != spec['floor']) else 3
        if t == 'cv_shadow': groups.append((t, t, pal_of(t), mesh, {'repeat': 0, 'size': dims[t], 'both_faces': False})); continue
        groups.append((t, t, pal_of(t), mesh, {'repeat': rep, 'size': dims[t]}))
    model = build_model('canvas_room_%d' % land_id, groups)
    model += b'\0' * (-len(model) % 4)
    bld = b''.join(struct.pack('<I3i3i3i8x', m, int(x * 4096), int(y * 4096), int(z * 4096), 0, 0, 0, 4096, 4096, 4096) for m, x, y, z in props)
    bdhc = struct.pack('<4s6H', b'BDHC', 2, 1, 1, 1, 1, 1) + struct.pack('<2i2i', -256 * 4096, -256 * 4096, 256 * 4096, 256 * 4096) + \
        struct.pack('<3i', 0, 4096, 0) + struct.pack('<i', 0) + struct.pack('<4H', 0, 1, 0, 0) + struct.pack('<iHH', 256 * 4096, 1, 0) + struct.pack('<H', 0)
    p = struct.pack('<1024H', *perm)
    land = struct.pack('<4I2H', len(p), len(bld), len(model), len(bdhc), 0x1234, 0) + p + bld + model + bdhc
    return land, props, gm, own


def write_events(spec, gm):
    slot = SLOTS[spec['map']]
    if slot in ROOM_SLOTS.values():        # a slot of our own: start from its template's events
        path = None
        ev = json.load(open(os.path.join(EVENT_DIR, events_file(spec['template']))))
    else:
        path = os.path.join(EVENT_DIR, events_file(slot))
        ev = json.load(open(path))
    ev['warps'] = [{k: v for k, v in w.items() if not k.startswith('_')} for w in gba_warps(gm)]
    if spec['keep_people']:
        # HeartGold's own people and signs, moved to where the GBA map has its people and signs (in order)
        for obj, g in zip(ev.get('objects', []), gm.get('object_events', [])):
            obj['x'], obj['z'] = g['x'], g['y']
        ev['bgs'] = ev.get('bgs', [])[:len(gm.get('bg_events', []))]
        for bg, g in zip(ev['bgs'], gm.get('bg_events', [])):
            bg['x'], bg['z'] = g['x'], g['y']
    else:
        ev['objects'], ev['bgs'] = [], []           # (the GBA game's people come over with its scripts)
    if path is None:
        return new_events_file(slot.replace('MAP_', ''), ev)
    json.dump(ev, open(path, 'w'), indent=4)
    open(path, 'a').write('\n')


def main():
    land, land_btnf = read_narc(open(LAND_NARC, 'rb').read())
    land += [b''] * max(0, ROOM_LAND_BASE + len(ROOMS) - len(land))
    all_props = []
    texsets, texsets_btnf = read_narc(open(TEXSETS, 'rb').read())
    areas, areas_btnf = read_narc(open(AREA_DATA, 'rb').read())
    n_own = 0
    for i, spec in enumerate(ROOMS):
        lid = ROOM_LAND_BASE + i
        data, props, gm, own = build_room(spec, lid)
        all_props.append(props)
        land[lid] = data
        slot = SLOTS[spec['map']]
        if slot in ROOM_SLOTS.values():
            mat = new_matrix_file(slot.replace('MAP_', ''), lid)
            evn = write_events(spec, gm)
            t = header(spec['template'])
            fields = {k: v for k, v in t.items() if k not in ('matrixId', 'eventsBank', 'scriptsBank', 'scriptHeaderBank', 'msgBank')}
            fields.update(matrixId=mat, eventsBank=evn)
            set_header(slot, fields)
        else:
            mpath = os.path.join(MATRIX_DIR, matrix_file(slot))
            m = bytearray(open(mpath, 'rb').read())
            w, h, hh, ha, nl = m[:5]
            p = 5 + nl + (2 * w * h if hh else 0) + (w * h if ha else 0)
            struct.pack_into('<H', m, p, lid)
            open(mpath, 'wb').write(bytes(m))
            write_events(spec, gm)
        if own:     # a texture set of its own: the base set plus this room's GBA art, and an area entry using it
            k = OUR_SETS_BASE + n_own; n_own += 1
            texsets += [texsets[spec['texset']]] * max(0, k + 1 - len(texsets))
            areas += [areas[spec['area']]] * max(0, k + 1 - len(areas))
            bt, bp = read_tex0(texsets[spec['texset']], tex0_of(texsets[spec['texset']]))
            texsets[k] = write_btx0(bt + [t for t, _ in own], bp + [q for _, q in own])
            a = bytearray(areas[spec['area']]); struct.pack_into('<H', a, 2, k); areas[k] = bytes(a)
            set_header(slot, {'areaDataBank': str(k)})
        print(spec['gba'], '-> land', lid, len(props), 'props', '(%d textures of its own)' % len(own) if own else '')
    # each room's building set must list its furniture, and the set's texture file must hold their textures
    used = {}
    for i, spec in enumerate(ROOMS):
        used.setdefault(spec['buildset'], set()).update(m for m, *_ in all_props[i])
    sets, sets_btnf = read_narc(open(AREA_BUILD, 'rb').read())
    atex, atex_btnf = read_narc(open(AREA_BUILD_TEX, 'rb').read())
    bm, _ = read_narc(open(BM_ROOM, 'rb').read())
    for bs, models in used.items():
        ids = list(struct.unpack_from('<%dH' % u16(sets[bs], 0), sets[bs], 2))
        ids += sorted(m for m in models if m not in ids)
        sets[bs] = struct.pack('<H%dH' % len(ids), len(ids), *ids)
        texs, pals = read_tex0(atex[bs], tex0_of(atex[bs]))
        have_t, have_p = {t[0] for t in texs}, {q[0] for q in pals}
        for mid in ids:
            t0 = tex0_of(bm[mid])
            if t0 is None: continue
            mt, mp = read_tex0(bm[mid], t0)
            texs += [t for t in mt if t[0] not in have_t]; have_t |= {t[0] for t in mt}
            pals += [q for q in mp if q[0] not in have_p]; have_p |= {q[0] for q in mp}
        atex[bs] = write_btx0(texs, pals)
    open(AREA_BUILD, 'wb').write(write_narc(sets, sets_btnf))
    open(TEXSETS, 'wb').write(write_narc(texsets, texsets_btnf))
    open(AREA_DATA, 'wb').write(write_narc(areas, areas_btnf))
    open(AREA_BUILD_TEX, 'wb').write(write_narc(atex, atex_btnf))
    # fill any gap between the retail lands and ours with a copy of an empty one
    land = [d if d else land[209] for d in land]
    open(LAND_NARC, 'wb').write(write_narc(land, land_btnf))


if __name__ == '__main__':
    main()
