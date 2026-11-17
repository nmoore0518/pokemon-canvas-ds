"""Canvas: build the GBA game's caves (Mt. Moon's three floors) as HeartGold caves.

HeartGold's Mt. Moon is one small floor; the GBA game's is three, with its trainers, the Rockets and the fossils.
Each floor is modelled from its GBA layout in HeartGold's cave look (HeartGold's own textures for that cave: see AREAS), the way HeartGold builds its own caves (read off its Mt. Moon with bmdview.py):
  - the floor is `droad01` (a 32-texel texture over two blocks);
  - rock rises from the floor in tiers a block high, one per ring of blocked squares, up to two: faces of
    `dwall_n/e/s/w` (named for the side of the floor they stand on: dwall_n is the wall north of you, facing
    south), tier tops of `dcliff01`, and the dark `d_ro` above the second tier, as in HeartGold;
  - ladders are HeartGold's own models (69 up, 70 down, from its cave building set) on squares that take you
    up (0x3C) or down (0x3E); a way out is a cave mouth: 0x6E north (into the wall), 0x6F south, 0x6C/0x6D
    east/west, as HeartGold's caves have them; the floor carries HeartGold's cave-floor behaviour (0x08:
    wild Pokemon) and flags (0x0A00).
Floors bigger than a land (32x32) span a matrix of lands. Each floor is a map of our own (MAP_CANVAS_*), with
the header of HeartGold's Mt. Moon (its wild Pokemon, camera, music) and its own events from the GBA map.
HeartGold's own Mt. Moon (and Mt. Moon Square) stays as it was; the doors on Route 3 and Route 4 that led into
it lead into ours (see EXITS / DOORS).

Run after build_rooms.py (our lands follow the rooms'), and before the porter.
"""
import json, math, os, struct, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from nitro import read_narc, write_narc
from g3d import Mesh, build_model
import gba_map
import cave_kit as K
import slots
from slots import SLOTS, new_map, NO_SCRIPTS, header, set_header, new_events_file, events_file, gba_warps
from build_rooms import texdims

ROOT = slots.ROOT
LAND_NARC = os.path.join(ROOT, 'files/a/0/6/5')
CAVE_LAND_BASE = 720            # our cave lands (rooms are 690 on)
# Each cave has the look HeartGold gives its own: the area (its texture set has the same number, and the same
# texture names in every one of them) of HeartGold's cave of that name. Mt. Moon and Victory Road share the grey
# one; Rock Tunnel's is its own grey, Diglett's Cave is brown earth, Cerulean Cave purple with crystals for rocks,
# the Seafoam Islands ice (HeartGold's lower floors; the GBA's are ice from the first).
AREAS = {'RockTunnel': 83, 'DiglettsCave': 82, 'CeruleanCave': 73, 'SeafoamIslands': 104}
area_of = lambda spec: next((a for k, a in AREAS.items() if spec['gba'].startswith(k)), 70)
LADDER_UP, LADDER_DOWN = 69, 70
FLOOR = 0x0A08                  # walkable cave floor (behaviour 0x08), as HeartGold's Mt. Moon
TIER = 16                       # a tier of rock: a block high
WATER_Y = -8                    # cave water lies half a block below the floor, as in HeartGold's Union Cave, with its bank round it (BANK)
# HeartGold's wall profile (read off its Mt. Moon): per tier, (how far back in blocks, height, texture row)
PROFILE = [[(0, 0, 15.75), (0.21, 1.6, 13), (0.67, 16, 4), (1.0, 16, 0.25)],
           [(1.0, 16, 15.75), (1.21, 17.6, 13), (1.67, 32, 4), (2.0, 32, 0.25)]]
WALL_TEX = {(0, -1): 'dwall_n', (0, 1): 'dwall_s', (1, 0): 'dwall_e', (-1, 0): 'dwall_w'}   # by where the rock is

CAVES = [   # GBA map, our map, how deep (ladders go up or down by it), the GBA's ways out -> (HeartGold map, warp),
    # the HeartGold cave whose header (wild Pokemon, music, camera) it takes. A way out is keyed by the GBA's
    # destination map, or (map, warp id) where two ways out go to one map.
    dict(gba='MtMoon_1F_Frlg', map='MAP_CANVAS_MT_MOON_1F', depth=0, exits={'MAP_ROUTE4': ('MAP_ROUTE_3', 0)}),
    dict(gba='MtMoon_B1F_Frlg', map='MAP_CANVAS_MT_MOON_B1F', depth=1, exits={'MAP_ROUTE4': ('MAP_ROUTE_4', 0)}),
    dict(gba='MtMoon_B2F_Frlg', map='MAP_CANVAS_MT_MOON_B2F', depth=2, exits={}),
    dict(gba='RockTunnel_1F_Frlg', map='MAP_CANVAS_ROCK_TUNNEL_1F', depth=0, template='MAP_ROCK_TUNNEL_1F',
         exits={('MAP_ROUTE10', '0'): ('MAP_ROUTE_10', 0), ('MAP_ROUTE10', '1'): ('MAP_ROUTE_10_SOUTH', 0)}),
    dict(gba='RockTunnel_B1F_Frlg', map='MAP_CANVAS_ROCK_TUNNEL_B1F', depth=1, template='MAP_ROCK_TUNNEL_B1F', exits={}),
    dict(gba='DiglettsCave_NorthEntrance_Frlg', map='MAP_CANVAS_DIGLETTS_CAVE_N', depth=0, template='MAP_DIGLETT_CAVE',
         exits={'MAP_ROUTE2': ('MAP_ROUTE_2_EAST', 4)}),
    dict(gba='DiglettsCave_B1F_Frlg', map='MAP_CANVAS_DIGLETTS_CAVE_B1F', depth=1, template='MAP_DIGLETT_CAVE', exits={}),
    dict(gba='DiglettsCave_SouthEntrance_Frlg', map='MAP_CANVAS_DIGLETTS_CAVE_S', depth=0, template='MAP_DIGLETT_CAVE',
         exits={'MAP_ROUTE11': ('MAP_ROUTE_11', 2)}),
    # (HeartGold has no Route 23: Victory Road runs from the League's reception gate to the Plateau)
    dict(gba='VictoryRoad_1F_Frlg', map='MAP_CANVAS_VICTORY_ROAD_1F', depth=0, template='MAP_VICTORY_ROAD_1F',
         exits={'MAP_ROUTE23': ('MAP_ROUTE_22_POKEMON_LEAGUE_RECEPTION_GATE', 1)}),
    dict(gba='VictoryRoad_2F_Frlg', map='MAP_CANVAS_VICTORY_ROAD_2F', depth=-1, template='MAP_VICTORY_ROAD_2F',
         exits={'MAP_ROUTE23': ('MAP_INDIGO_PLATEAU', 0)}),
    dict(gba='VictoryRoad_3F_Frlg', map='MAP_CANVAS_VICTORY_ROAD_3F', depth=-2, template='MAP_VICTORY_ROAD_3F', exits={}),
    dict(gba='CeruleanCave_1F_Frlg', map='MAP_CANVAS_CERULEAN_CAVE_1F', depth=0, template='MAP_CERULEAN_CAVE_1F',
         exits={'MAP_CERULEAN_CITY': ('MAP_CERULEAN', 7)}),
    dict(gba='CeruleanCave_2F_Frlg', map='MAP_CANVAS_CERULEAN_CAVE_2F', depth=-1, template='MAP_CERULEAN_CAVE_2F', exits={}),
    dict(gba='CeruleanCave_B1F_Frlg', map='MAP_CANVAS_CERULEAN_CAVE_B1F', depth=1, template='MAP_CERULEAN_CAVE_B1F', exits={}),
    dict(gba='SeafoamIslands_1F_Frlg', map='MAP_CANVAS_SEAFOAM_1F', depth=0, template='MAP_SEAFOAM_ISLANDS_1F',
         exits={('MAP_ROUTE20', '0'): ('MAP_ROUTE_20', 1), ('MAP_ROUTE20', '1'): ('MAP_ROUTE_20', 0)}),
    dict(gba='SeafoamIslands_B1F_Frlg', map='MAP_CANVAS_SEAFOAM_B1F', depth=1, template='MAP_SEAFOAM_ISLANDS_B1F', exits={}),
    dict(gba='SeafoamIslands_B2F_Frlg', map='MAP_CANVAS_SEAFOAM_B2F', depth=2, template='MAP_SEAFOAM_ISLANDS_B2F', exits={}),
    dict(gba='SeafoamIslands_B3F_Frlg', map='MAP_CANVAS_SEAFOAM_B3F', depth=3, template='MAP_SEAFOAM_ISLANDS_B3F', exits={}),
    dict(gba='SeafoamIslands_B4F_Frlg', map='MAP_CANVAS_SEAFOAM_B4F', depth=4, template='MAP_SEAFOAM_ISLANDS_B4F', exits={}),
]
TEMPLATE = 'MAP_MOUNT_MOON'
WATER_MB = {16, 17, 18, 19, 20, 21, 24, 26, 44, 45, 80, 81, 82, 83}   # GBA behaviours of water you surf (currents too)
GBA_IDS = {c['gba']: gba_map.map_json(c['gba'])['id'] for c in CAVES}
# HeartGold's doors into its caves -> ours: (map, its warp index) -> (our map, GBA warp index there)
DOORS = {('MAP_ROUTE_3', 0): ('MAP_CANVAS_MT_MOON_1F', 3), ('MAP_ROUTE_4', 0): ('MAP_CANVAS_MT_MOON_B1F', 7),
         ('MAP_ROUTE_10', 0): ('MAP_CANVAS_ROCK_TUNNEL_1F', 0), ('MAP_ROUTE_10_SOUTH', 0): ('MAP_CANVAS_ROCK_TUNNEL_1F', 5),
         ('MAP_ROUTE_2_EAST', 4): ('MAP_CANVAS_DIGLETTS_CAVE_N', 1), ('MAP_ROUTE_11', 2): ('MAP_CANVAS_DIGLETTS_CAVE_S', 0),
         ('MAP_ROUTE_22_POKEMON_LEAGUE_RECEPTION_GATE', 1): ('MAP_CANVAS_VICTORY_ROAD_1F', 1),
         ('MAP_INDIGO_PLATEAU', 0): ('MAP_CANVAS_VICTORY_ROAD_2F', 5),
         ('MAP_CERULEAN', 7): ('MAP_CANVAS_CERULEAN_CAVE_1F', 0),
         ('MAP_ROUTE_20', 0): ('MAP_CANVAS_SEAFOAM_1F', 4), ('MAP_ROUTE_20', 1): ('MAP_CANVAS_SEAFOAM_1F', 3)}


STAIRS_MT = {0x284, 0x2B4}      # the GBA cave tileset's steps: they climb north
UNDER = True                    # (the floor laid again under it all: see build_floor)
RINGS = 3                       # tiers of rock above the floor nearest it; then the rim, then the dark
DIRS4_ = ((1, 0), (-1, 0), (0, 1), (0, -1))
DIRS8_ = [(dx, dy) for dx in (-1, 0, 1) for dy in (-1, 0, 1) if dx or dy]
# HeartGold's bank round its cave water (read off Union Cave): across the water's edge, (how far onto the land,
# height from the floor, texture row); the water lies at WATER_Y
BANK = [(3.6, 2.0, 0.3), (0.2, 1.7, 3.3), (-1.8, -0.6, 5.6), (-2.6, -6.3, 12.1), (-4.7, -7.6, 15.6)]


BORDER_NEED = {}            # texture set -> the corner pieces of the floor's border its caves use (border_texture)
# (they go in one picture a texture set - `cv_border` for the floor's border, `cv_rim` for the rim - a grid of
# 16x16 pieces, so that a land has one material for them all: a land's model has a size limit)
# The pictures are no bigger than their pieces need (HeartGold's biggest texture set is 56 KB, and the game
# loads a set into a space of about that size): main counts the pieces in a first pass, then builds.
ATLAS = {'cvb': 'cv_border', 'cvr': 'cv_rim'}
ATLAS_DIM = {}              # (texture set, prefix) -> (width, height) of its picture, once counted
_atlas_order = {}


PER_ATLAS = 32             # (a picture is one column of pieces, 16 wide: the DS read the second column of a wider
                           # one wrongly. Past 64 pieces, another picture: cv_border1, ...)


def atlas_size(n):
    """the picture (16 wide, a power of two high) for n pieces"""
    return 16, next(h for h in (16, 32, 64, 128, 256, 512, 1024) if h // 16 >= n)


def atlas_name(prefix, a):
    return ATLAS[prefix] + ('%d' % a if a else '')


_atlas_cells = {}          # (texture set, prefix) -> {key: its picture's place}, once the pieces are drawn (pieces
_atlas_pics = {}           # that come out alike share one) and the pictures, in order


def atlas_cell(texset, prefix, key):
    """-> the texture, and the corner (s, t) in it of a piece's cell"""
    lst = _atlas_order.setdefault((texset, prefix), [])
    if key not in lst: lst.append(key)
    BORDER_NEED.setdefault(texset, set()).add((prefix, key))
    cells = _atlas_cells.get((texset, prefix))
    if cells is None:
        i = lst.index(key)
    else:
        if key not in cells:      # (a piece the last pass did not have: drawn now, and another pass to size the pictures)
            draw_piece(texset, prefix, key)
            _atlas_new.append(key)
        i = cells[key]
    return atlas_name(prefix, i // PER_ATLAS), 0, (i % PER_ATLAS) * 16


_atlas_new = []
_sources = {}


def draw_piece(st, prefix, key):
    if st not in _sources: _sources[st] = piece_sources(read_narc(open(TEX_NARC, 'rb').read())[0], st)
    straight, floor, _ = _sources[st][prefix]
    pics, cells = _atlas_pics.setdefault((st, prefix), []), _atlas_cells.setdefault((st, prefix), {})
    px_ = tuple(border_texture(straight, key, floor))
    if px_ not in pics: pics.append(px_)
    cells[key] = pics.index(px_)


def piece_sources(ts, st):
    """-> {prefix: (straight piece's rows of indices, the floor in its colours or None, its texture entry)} for a
    texture set"""
    from nitro import read_tex0, tex0_of
    from texview import decode
    texs, pals = read_tex0(ts[st], tex0_of(ts[st]))
    pd = {n.decode(): d_ for n, _, d_ in pals}
    out = {}
    for prefix, src in (('cvb', b'droad01_r'), ('cvr', b'dcliff01_r')):
        ent = next(t for t in texs if t[0] == src)
        prm, data = ent[1], ent[3]
        w = 8 << ((prm >> 20) & 7)
        assert (prm >> 26) & 7 == 3, 'a 16-colour straight piece'
        idx = [(data[i // 2] >> (4 * (i % 2))) & 15 for i in range(len(data) * 2)]
        straight = [idx[r * w:r * w + 16] for r in range(32)]
        floor = None
        if prefix == 'cvb':
            # the floor's texture in the border's colours (each texel the nearest of its 16)
            bpal = pd[next(p_ for p_ in (src.decode() + '_pl', src.decode()) if p_ in pd)]
            cols = [((c & 31) << 3, ((c >> 5) & 31) << 3, ((c >> 10) & 31) << 3) for c in struct.unpack('<16H', bpal[:32])]
            fl = next(t for t in texs if t[0] == b'droad01')
            fimg = decode(fl[1], fl[3], fl[4], pd[next(p_ for p_ in ('droad01_pl', 'droad01') if p_ in pd)]).convert('RGB')
            near_ = lambda c: min(range(1, 16), key=lambda k: sum((a_ - b_) ** 2 for a_, b_ in zip(c, cols[k])))
            floor = [[near_(fimg.getpixel((x_, y_))) for x_ in range(32)] for y_ in range(32)]
        out[prefix] = (straight, floor, ent)
    return out


def draw_pieces():
    """After a counting pass: every piece drawn; alike ones share a cell. Sets the atlases' sizes."""
    for (st, prefix), lst in _atlas_order.items():
        for key in lst:
            if key not in _atlas_cells.get((st, prefix), {}): draw_piece(st, prefix, key)
    ATLAS_DIM.clear()
    for (st, prefix), pics in _atlas_pics.items():
        for a in range(0, len(pics), PER_ATLAS):
            ATLAS_DIM[(st, atlas_name(prefix, a // PER_ATLAS))] = atlas_size(min(PER_ATLAS, len(pics) - a))
TEX_NARC = os.path.join(ROOT, 'files/a/0/4/4')


def texset_of(area):
    d = read_narc(open(os.path.join(ROOT, 'files/a/0/4/2'), 'rb').read())[0][area]
    return struct.unpack_from('<H', d, 2)[0]


def anim_slots(area):
    """How many of a land's first materials the area's texture animation scrolls (HeartGold binds it by index:
    Union Cave's, which our caves' areas share, scrolls materials 0..4 - its river, river_r, sea_line02, sea_un and
    sea_on), so those places are held empty: anything put there would slide about."""
    from nitro import read_dict, u32
    d = read_narc(open(os.path.join(ROOT, 'files/a/0/4/2'), 'rb').read())[0][area]
    fid = struct.unpack_from('<H', d, 4)[0]
    if fid == 0xFFFF: return []
    b = read_narc(open(os.path.join(ROOT, 'files/a/1/4/0'), 'rb').read())[0][fid]
    srt = u32(b, 0x10)
    (_, e), = read_dict(b, srt + 8)[:1]
    return [n.decode() for n, _ in read_dict(b, srt + u32(e, 0) + 8)]


BAND_END = 16             # (texels from the rock: past that - where HeartGold's straight piece ends - a border piece is the floor's own texture)
ROUND_R = 17              # (how far HeartGold's rounded outside corner's foot is from its centre, about)


def border_texture(straight, key, floor=None):
    """A square of the floor's border with rock on more than one side (or round a corner of rock), as 16x16
    texel indices: each texel takes the colour HeartGold's straight piece (`straight`: rows of indices, the wall
    at column 0, two squares long) has at its distance from the nearest rock, along that rock's edge.
    key: (sides against rock, bits N S W E; corners of rock poking in, bits NW NE SW SE; x and y of the square, odd
    or even: the straight piece is two squares long, and the corner keeps step with the pieces either side)"""
    sides, pokes, px, py = key[:4]
    rounds = key[4] if len(key) > 4 else ()
    out = []
    for v in range(16):
        for u in range(16):
            cu, cv = u + 0.5, v + 0.5
            near = []
            for k, (d, along) in enumerate(((cv, cu + 16 * px), (16 - cv, cu + 16 * px), (cu, cv + 16 * py), (16 - cu, cv + 16 * py))):
                if sides >> k & 1: near.append((d, along))
            for k, (qx, qy) in enumerate(((0, 0), (16, 0), (0, 16), (16, 16))):
                if pokes >> k & 1:
                    d = ((cu - qx) ** 2 + (cv - qy) ** 2) ** 0.5
                    # (along the corner: by the angle round it, so the band's pattern carries on from either side)
                    ang = math.atan2(abs(cv - qy), abs(cu - qx)) / (math.pi / 2)
                    near.append((d, (cu if qy == 0 else 16 - cu) * (1 - ang) + 16 * px + ang * (cv + 16 * py)))
            for qx, qy in rounds:
                # (a rounded outside corner: its curve is about a circle round (qx, qy), HeartGold's a little out)
                r = ((cu - qx) ** 2 + (cv - qy) ** 2) ** 0.5
                ang = math.atan2(abs(cv - qy), abs(cu - qx)) / (math.pi / 2)
                near.append((max(0.0, r - ROUND_R), (cu + 16 * px) * (1 - ang) + ang * (cv + 16 * py)))
            if not near: near.append((99, 0))
            d, along = min(near)
            if floor is not None and d >= BAND_END:
                # (past the band, the floor itself, in step with the floor's texture round it: two squares a repeat)
                out.append(floor[(v + 16 * py) % 32][(u + 16 * px) % 32])
            else:
                out.append(straight[int(along) % 32][min(15, int(d))])
    return out


def write_border_textures():
    """Adds the border's corner pieces (border_texture) to the cave texture sets; they share the straight piece's
    palette and format. (Pieces of an earlier run are dropped first.)"""
    from nitro import read_tex0, tex0_of, write_btx0
    ts, btnf = read_narc(open(TEX_NARC, 'rb').read())
    for st, keys in BORDER_NEED.items():
        texs, pals = read_tex0(ts[st], tex0_of(ts[st]))
        texs = [t for t in texs if not t[0].startswith(b'cvb') and not t[0].startswith(b'cvr') and not any(t[0].startswith(a.encode()) for a in ATLAS.values())]
        srcs = piece_sources(ts, st)
        for prefix in ('cvb', 'cvr'):
            pics = _atlas_pics.get((st, prefix), [])
            if not pics: continue
            prm = srcs[prefix][2][1]
            for a in range(0, len(pics), PER_ATLAS):
                name = atlas_name(prefix, a // PER_ATLAS)
                AW, AH = ATLAS_DIM[(st, name)]
                grid = [0] * (AW * AH)
                for i, px_ in enumerate(pics[a:a + PER_ATLAS]):
                    for k in range(256):
                        grid[(i * 16 + k // 16) * AW + k % 16] = px_[k]
                raw = bytes(grid[i] | (grid[i + 1] << 4) for i in range(0, len(grid), 2))
                sw, sh = AW.bit_length() - 4, AH.bit_length() - 4
                p_ = (sw << 20) | (sh << 23) | (3 << 26) | (prm & (1 << 29))
                texs.append((name.encode(), p_, AW | (AH << 11) | 0x80000000, raw, b''))
        ts[st] = write_btx0(texs, pals)
        size = sum(len(t[3]) + len(t[4]) for t in texs)
        print('  texture set %d: %d pieces of the floor\'s border and the rim, %d different (%s); the set is %d bytes' % (
            st, len(keys), sum(len(_atlas_pics.get((st, p_), [])) for p_ in ('cvb', 'cvr')),
            ', '.join('%s %dx%d' % ((n_,) + d_) for (s_, n_), d_ in ATLAS_DIM.items() if s_ == st), size))
        assert size <= 56 * 1024, ('texture set too big for the game to load', st, size)
    open(TEX_NARC, 'wb').write(write_narc(ts, btnf))


def _reachable(gm, blocked, W, H):
    """closes what cannot be got to from a ladder, a mouth or where someone stands (the GBA leaves squares open in
    its borders)"""
    seen = {(e['x'], e['y']) for k in ('warp_events', 'object_events') for e in gm.get(k, []) if 0 <= e['x'] < W and 0 <= e['y'] < H and not blocked[e['y']][e['x']]}
    todo = list(seen)
    while todo:
        x, y = todo.pop()
        for dx, dy in DIRS4_:
            n = (x + dx, y + dy)
            if 0 <= n[0] < W and 0 <= n[1] < H and not blocked[n[1]][n[0]] and n not in seen: seen.add(n); todo.append(n)
    for y in range(H):
        for x in range(W):
            if (x, y) not in seen: blocked[y][x] = True


def cave_open(gm, lay):
    """-> blocked (a ladder or a mouth is walkable), boulders: little patches of rock out on the floor (the GBA
    game's rock piles), which stand on the floor as HeartGold's rock rather than being built out of walls"""
    W, H = lay.w, lay.h
    blocked = [[lay.collision(x, y) != 0 for x in range(W)] for y in range(H)]
    for w in gm.get('warp_events', []):
        blocked[w['y']][w['x']] = False
    _reachable(gm, blocked, W, H)
    boulders, seen = set(), set()
    for y in range(H):
        for x in range(W):
            if not blocked[y][x] or (x, y) in seen: continue
            comp, stack, edge = [], [(x, y)], False
            seen.add((x, y))
            while stack:
                c = stack.pop(); comp.append(c)
                if c[0] in (0, W - 1) or c[1] in (0, H - 1): edge = True
                for dx, dy in DIRS4_:
                    n = (c[0] + dx, c[1] + dy)
                    if 0 <= n[0] < W and 0 <= n[1] < H and blocked[n[1]][n[0]] and n not in seen:
                        seen.add(n); stack.append(n)
            if len(comp) <= 3 and not edge: boulders |= set(comp)
    return blocked, boulders


def cave_heights(gm, lay, blocked, boulders, plain=()):
    """How high the ground is, in tiers: -> ({square: height} for every square that is no rock or step, {a step's
    square: the height at its foot}). The GBA says it two ways: its elevation (3 the ground, 4 a tier up; you get
    onto water, 1, from 3), and steps drawn in a cliff with the same elevation both ends (Mt. Moon, Seafoam 1F),
    which climb a tier going north."""
    W, H = lay.w, lay.h
    open_ = lambda x, y: 0 <= x < W and 0 <= y < H and (not blocked[y][x] or (x, y) in boulders)
    stairs = {(x, y) for y in range(H) for x in range(W) if open_(x, y) and (x, y) not in boulders and (x, y) not in plain and lay.metatile(x, y) in STAIRS_MT}
    warps = {(w['x'], w['y']) for w in gm.get('warp_events', [])}

    def cls(x, y):
        e = lay.elevation(x, y)
        if (x, y) in plain and lay.metatile(x, y) in STAIRS_MT: return None     # (floor at a flight's head: as the ground north of it)
        return None if (x, y) in warps or (x, y) in boulders or e in (0, 2, 15) else 3 if e == 1 else e
    reg, regs = {}, []
    for y in range(H):
        for x in range(W):
            if not open_(x, y) or (x, y) in stairs or (x, y) in reg or cls(x, y) is None: continue
            reg[(x, y)] = len(regs); comp, stack = [], [(x, y)]
            while stack:
                c = stack.pop(); comp.append(c)
                for dx, dy in DIRS4_:
                    n = (c[0] + dx, c[1] + dy)
                    if open_(*n) and n not in stairs and n not in reg and cls(*n) == cls(*c): reg[n] = reg[c]; stack.append(n)
            regs.append(comp)
    rcls = [cls(*c[0]) for c in regs]
    edges = {}
    link = lambda a, b, d: (edges.setdefault(a, []).append((b, d)), edges.setdefault(b, []).append((a, -d)))
    # squares with no elevation of their own (ladders, mouths, rock piles) join the ground beside them, and tie
    # the grounds either side of them together
    grew = True
    while grew:
        grew = False
        for y in range(H):
            for x in range(W):
                if not open_(x, y) or (x, y) in stairs or (x, y) in reg: continue
                near = [reg[(x + dx, y + dy)] for dx, dy in DIRS4_ if (x + dx, y + dy) in reg]
                if not near: continue
                reg[(x, y)] = near[0]; regs[near[0]].append((x, y)); grew = True
                for r in near[1:]:
                    if r != near[0]: link(near[0], r, (rcls[r] or 3) - (rcls[near[0]] or 3))
    for y in range(H):
        for x in range(W):
            if open_(x, y) and (x, y) not in stairs and (x, y) not in reg:
                reg[(x, y)] = len(regs); regs.append([(x, y)]); rcls.append(3)
    for (x, y) in stairs:                  # a flight: its head is a tier (or as many as it has squares) above its foot
        if (x, y - 1) in stairs: continue
        e = y
        while (x, e + 1) in stairs: e += 1
        if (x, y - 1) in reg and (x, e + 1) in reg: link(reg[(x, e + 1)], reg[(x, y - 1)], e - y + 1)
    for (x, y), r in list(reg.items()):    # two elevations side by side
        for dx, dy in ((1, 0), (0, 1)):
            n = (x + dx, y + dy)
            if n in reg and reg[n] != r and cls(x, y) is not None and cls(*n) is not None and cls(*n) != cls(x, y):
                link(r, reg[n], cls(*n) - cls(x, y))
    hreg = {}
    for r0 in sorted(range(len(regs)), key=lambda r: -len(regs[r])):
        if r0 in hreg: continue
        hreg[r0] = (rcls[r0] or 3) - 3; todo = [r0]
        while todo:
            a_ = todo.pop()
            for b_, d in edges.get(a_, []):
                if b_ not in hreg: hreg[b_] = hreg[a_] + d; todo.append(b_)
    hts = {sq: hreg[r] for sq, r in reg.items()}
    foot = {}
    for (x, y) in stairs:
        e = y
        while (x, e + 1) in stairs: e += 1
        t = y
        while (x, t - 1) in stairs: t -= 1
        base = hts[(x, e + 1)] if (x, e + 1) in hts else hts.get((x, t - 1), e - t + 1) - (e - t + 1)
        foot[(x, y)] = base + (e - y)
    return hts, foot


_plans = {}


def cave_widen(gba):
    """Columns and rows to double, so that no wall is thinner than HeartGold's pieces need: a face is a square
    deep and a block high and is never squeezed, so a wall one square thick can only be a step up of one tier.
    Between two floors of the same height it takes two squares (a face each side); between floors n tiers apart,
    n. -> dict(cols=[(column, copies more)], rows=[...]) for build_rooms' widen"""
    if gba not in _plans:
        gm = gba_map.map_json(gba); lay = gba_map.Layout(gm['layout'])
        blocked, boulders = cave_open(gm, lay)
        hts, foot = cave_heights(gm, lay, blocked, boulders)
        cols, rows = {}, {}
        for axis, need, n_lines, n in ((0, cols, lay.h, lay.w), (1, rows, lay.w, lay.h)):
            for line in range(n_lines):
                sq = (lambda i: (i, line)) if axis == 0 else (lambda i: (line, i))
                i = 0
                while i < n:
                    if sq(i) in hts: i += 1; continue
                    j = i
                    while j < n and sq(j) not in hts: j += 1
                    if i > 0 and j < n and not any(sq(k) in foot for k in range(i, j)):
                        a, b = hts[sq(i - 1)], hts[sq(j)]
                        T = 2 if a == b else abs(a - b)
                        if j - i < T: need[i] = max(need.get(i, 0), T - (j - i))
                    i = j
                # (and two floors of different heights side by side with nothing between them: the GBA keeps you
                # from stepping across by elevation alone. The cliff needs squares to stand on: floor_plan closes
                # the new ones there)
                for i in range(1, n):
                    if sq(i - 1) in hts and sq(i) in hts and hts[sq(i - 1)] != hts[sq(i)]:
                        need[i] = max(need.get(i, 0), abs(hts[sq(i - 1)] - hts[sq(i)]))
        _plans[gba] = dict(cols=sorted(cols.items()), rows=sorted(rows.items()), boulders=boulders, hts=hts)
    return _plans[gba]


def cave_xy(gba):
    """where a square of the GBA map is in ours (for the porter)"""
    w = cave_widen(gba)
    return lambda x, y, kind='pos': (x + sum(n for c, n in w['cols'] if c <= x), y + sum(n for r, n in w['rows'] if r <= y))


def floor_plan(gba):
    """-> the GBA map widened (cave_widen), its layout, blocked, boulders, level (tiers up, for every square with
    a level: floor, steps (their head) and the rock within RINGS + 1 rings of them), D (rings of rock from the
    floor), the floors' heights and the steps' feet"""
    gm = gba_map.map_json(gba); lay = gba_map.Layout(gm['layout'])
    plan = cave_widen(gba)
    # (a rock pile stays where it stood: of a column or row doubled through it, the copy is floor)
    cmap = [x for x in range(lay.w) for _ in range(1 + dict(plan['cols']).get(x, 0))]
    rmap = [y for y in range(lay.h) for _ in range(1 + dict(plan['rows']).get(y, 0))]
    if plan['cols'] or plan['rows']:
        from build_rooms import widen
        gm = widen(gm, lay, cols=plan['cols'], rows=plan['rows'])
    W, H = lay.w, lay.h
    blocked = [[lay.collision(x, y) != 0 for x in range(W)] for y in range(H)]
    for w in gm.get('warp_events', []):
        blocked[w['y']][w['x']] = False
    _reachable(gm, blocked, W, H)
    last = lambda m, i: i == len(m) - 1 or m[i + 1] != m[i]
    boulders = set()
    for y in range(H):
        for x in range(W):
            if (cmap[x], rmap[y]) in plan['boulders']:
                if last(cmap, x) and last(rmap, y): boulders.add((x, y))
                else: blocked[y][x] = False
    h0 = plan['hts']
    step = lambda a, b: a in h0 and b in h0 and h0[a] != h0[b]
    for y in range(H):
        for x in range(W):
            sx, sy = cmap[x], rmap[y]
            if (not last(cmap, x) and step((sx - 1, sy), (sx, sy))) or (not last(rmap, y) and step((sx, sy - 1), (sx, sy))):
                blocked[y][x] = True           # (a new square between two heights: the cliff)
    # (of a row doubled through a flight of steps, the copy is floor at its head: the flight stays as long as it was)
    plain = {(x, y) for y in range(H) for x in range(W) if not last(rmap, y)}
    hts, foot = cave_heights(gm, lay, blocked, boulders, plain)
    fixed = dict(hts); fixed.update({s: f + 1 for s, f in foot.items()})
    M_ = RINGS + 2
    # rings of rock from the floor (8 ways round, so outside corners are round as HeartGold's are)
    dist, frontier = {s: 0 for s in fixed}, list(fixed)
    for d in range(1, RINGS + 2):
        nxt = []
        for (x, y) in frontier:
            for dx, dy in DIRS8_:
                n = (x + dx, y + dy)
                if -M_ <= n[0] < W + M_ and -M_ <= n[1] < H + M_ and n not in dist: dist[n] = d; nxt.append(n)
        frontier = nxt
    D = lambda x, y: dist.get((x, y), 99)
    rocks = [s for s, d in dist.items() if d > 0]
    L = {s: 99 for s in rocks}
    get = lambda s: fixed[s] if s in fixed else L.get(s)

    def settle():
        # rock rises a tier a ring from the floor, whichever floor is lowest from there: no step of more than one
        ch = True
        while ch:
            ch = False
            for s in rocks:
                m = min((v for v in (get((s[0] + dx, s[1] + dy)) for dx, dy in DIRS8_) if v is not None), default=None)
                if m is not None and L[s] > m + 1 and (L[s] != 99 or dist[s] <= RINGS): L[s] = m + 1; ch = True
    settle()
    for s in rocks:        # (the rim, a ring past the last tier, lies level with it)
        if dist[s] == RINGS + 1:
            L[s] = max((L[n] for n in ((s[0] + dx, s[1] + dy) for dx, dy in DIRS8_) if n in L and dist[n] <= RINGS and L[n] != 99), default=99)
    for s in [s for s in rocks if L[s] == 99]: del L[s]
    rocks = list(L)
    # a square higher than the squares on two opposite sides of it would need a face from each, squeezed: it is
    # the flat top between them instead (a wall three squares thick is a block with a flat top)
    left = 0
    while True:
        settle()
        ch = False
        for s in rocks:
            v = L[s]
            for a_, b_ in (((1, 0), (-1, 0)), ((0, 1), (0, -1))):
                la, lb = get((s[0] + a_[0], s[1] + a_[1])), get((s[0] + b_[0], s[1] + b_[1]))
                if la is not None and lb is not None and la < v and lb < v:
                    if any(hts.get((s[0] + dx, s[1] + dy), -99) > v - 1 for dx, dy in DIRS4_): left += 1; continue
                    L[s] = v - 1; ch = True; break
        if not ch: break
    if left: print('  (%s: %d squares of wall still too thin for whole faces)' % (gba, left))
    steps = sum(1 for (x, y), h in hts.items() for n in ((x + 1, y), (x, y + 1)) if n in hts and hts[n] != h)
    if steps: print('  (%s: %d places where floors of two heights still touch)' % (gba, steps))
    # rock that lies level with the floor beside it is floor (the row behind a cliff's lip where the wall was
    # doubled): the plateau runs to its edge
    ch = True
    while ch:
        ch = False
        for s in list(L):
            x, y = s
            if not (0 <= x < W and 0 <= y < H) or s in hts: continue
            if any(v is not None and v < L[s] for v in (get((x + dx, y + dy)) for dx, dy in DIRS8_)): continue
            if any(hts.get((x + dx, y + dy)) == L[s] for dx, dy in DIRS4_):
                hts[s] = fixed[s] = L[s]; blocked[y][x] = False; ch = True
    for s in hts:
        L.pop(s, None)
    level = dict(fixed); level.update(L)
    # rock piles: HeartGold's rocks at HeartGold's sizes, one to a pile's square (or its big rock over two side by
    # side), none on a square whose rock to the south leans over it. Nothing stands over anything else: a pile by a
    # ladder, a mouth or a person moves to open floor nearby (as one small rock), or goes if there is none.
    water = {q for q in hts if lay.behavior(lay.metatile(*q)) in WATER_MB and q not in boulders}
    warps = {(w['x'], w['y']) for w in gm.get('warp_events', [])}
    people = {(o['x'], o['y']) for o in gm.get('object_events', [])}
    keep = {(wx + dx, wy + dy) for wx, wy in warps for dx in (-1, 0, 1) for dy in (-2, -1, 0, 1)} | people | {(px, py + 1) for px, py in people} \
        | {(sx + dx, sy + dy) for sx, sy in foot for dx in (-2, -1, 0, 1, 2) for dy in (-2, -1, 0, 1, 2)}       # (nor by a flight of steps)
    piles, seen = [], set()
    for q in sorted(boulders):
        if q in seen: continue
        comp, stack = [], [q]; seen.add(q)
        while stack:
            c = stack.pop(); comp.append(c)
            for dx, dy in DIRS4_:
                n = (c[0] + dx, c[1] + dy)
                if n in boulders and n not in seen: seen.add(n); stack.append(n)
        piles.append(comp)
    for comp in piles:
        if not any(q in keep for q in comp): continue
        for (x, y) in comp:
            boulders.discard((x, y)); blocked[y][x] = False
        del comp[1:]
        cx, cy = comp[0]
        free = lambda q: q in hts and hts[q] == hts[(cx, cy)] and q not in water and q not in foot and q not in boulders and q not in keep
        spot = min((q for q in hts if abs(q[0] - cx) + abs(q[1] - cy) <= 7 and free(q)
                    and all(free((q[0] + dx, q[1] + dy)) for dx, dy in DIRS8_)), key=lambda q: (abs(q[0] - cx) + abs(q[1] - cy), q), default=None)
        if spot is None: comp.clear(); continue
        comp[0] = spot; boulders.add(spot); blocked[spot[1]][spot[0]] = True
    cards = []
    for comp in piles:
        got = set()
        for (x, y) in sorted(comp, key=lambda q: (-q[1], q[0])):
            if (x, y) in got or (x, y + 1) in got: continue
            if (x + 1, y) in comp and (x + 1, y) not in got and (x + 1, y + 1) not in got and hts[(x + 1, y)] == hts[(x, y)]:
                cards.append(('big', x, y)); got |= {(x, y), (x + 1, y)}
            else: cards.append(('small', x, y)); got.add((x, y))
    return gm, lay, blocked, boulders, level, D, hts, foot, cards


def build_floor(spec, depth_of):
    gm, lay, blocked, boulders, level, D, hts, foot, cards = floor_plan(spec['gba'])
    W, H = lay.w, lay.h
    LV = lambda x, y: level.get((x, y))                    # (None: rock past the rim, in the dark)
    HT = lambda x, y: hts.get((x, y), 0) * TIER            # a floor square's height
    below = lambda p, lv: LV(*p) is not None and LV(*p) < lv
    # water (to surf: HeartGold's cave water, behaviour 0x15, drawn a little below the floor in its river texture)
    water = {(x, y) for y in range(H) for x in range(W) if not blocked[y][x] and (x, y) in hts and lay.behavior(lay.metatile(x, y)) in WATER_MB}
    nx, nz = math.ceil(W / 32), math.ceil(H / 32)
    dims, pals = texdims(area_of(spec))
    texset = texset_of(area_of(spec))
    anim_held = anim_slots(area_of(spec))
    pal_of = lambda t: pal_of('droad01_r') if t.startswith(ATLAS['cvb']) else pal_of('dcliff01_r') if t.startswith(ATLAS['cvr']) else next(p for p in (t + '_pl', t) if p in pals)
    # ladders and mouths
    ladders, mouths, holes = {}, {}, set()
    for w in gm.get('warp_events', []):
        x, y = w['x'], w['y']
        dest = w['dest_map']
        if dest in depth_of:
            # (only the GBA's ladders are ladders (behaviour 0x61); its holes (0x0F) are holes you drop through; any
            # other square that leads to another floor is where you land, falling from the floor above: floor)
            mb = lay.behavior(lay.metatile(x, y))
            if mb == 0x61: ladders[(x, y)] = LADDER_DOWN if depth_of[dest] > spec['depth'] else LADDER_UP
            elif mb == 0x0F: holes.add((x, y))
        else:
            b = lambda dx, dy: not (0 <= x + dx < W and 0 <= y + dy < H) or blocked[y + dy][x + dx]
            mouths[(x, y)] = 0x6E if b(0, -1) else 0x6F if b(0, 1) else 0x6C if b(1, 0) else 0x6D
    DIRS4 = ((0, -1), (0, 1), (-1, 0), (1, 0))
    kit_corners = K.corner_pieces(LAND_NARC)
    kit_strips = {k: K.stripify(v) for k, v in kit_corners.items()}
    # (what each wall square's piece is, ahead: the floor's border goes round a corner of rock that pokes into the
    # floor, but HeartGold's rounded outside corner stands back from its square's corner, so not round that)
    # (and its curve: about a circle round the square's corner away from its two lower sides - its centre, in texels)
    rounded = {}
    for (x, y), lv in level.items():
        if (x, y) in hts or (x, y) in foot: continue
        lower = [(dx, dz) for dx in (-1, 0, 1) for dz in (-1, 0, 1) if (dx or dz) and level.get((x + dx, y + dz)) is not None and level[(x + dx, y + dz)] < lv]
        if False and lower and K.classify(lower)[0] == 'outside':      # (none now: outside corners are mitred, see rock_square)
            rounded[(x, y)] = (0 if (1, 0) in lower else 16, 0 if (0, 1) in lower else 16)
    PIECE_NORMAL = {}
    lands = []
    for lz in range(nz):
        for lx in range(nx):
            meshes = {}
            bordered = set()
            M = lambda t: meshes.setdefault(t, Mesh())
            ORDER_FIRST = ('droad01_r', 'd_ro')      # (drawn before the floor, which lies at their height: see the border)
            ox, oz = lx * 32, lz * 32
            U = lambda v, o: (v - o) * 16 - 256
            up = (0, 1, 0)
            perm = [0x8000] * 1024
            props = []
            flats = {}
            inland = lambda x, y: ox <= x < ox + 32 and oz <= y < oz + 32
            straight = {}       # (lower side, foot height, the line it runs on) -> squares along it

            def rock_square(x, y, lv):
                """a square of rock: a wall piece where there is lower ground round it (cave_kit), else its flat top
                - a tier's rocky top, or the rim past the last tier (light at the cave's side, dark beyond)"""
                lower = [(dx, dz) for dx in (-1, 0, 1) for dz in (-1, 0, 1)
                         if (dx or dz) and LV(x + dx, y + dz) is not None and LV(x + dx, y + dz) < lv]
                top = lv * TIER
                if not lower:
                    if D(x, y) <= RINGS:
                        flats.setdefault(('dcliff01', top, None), set()).add((x, y))
                    elif D(x, y) == RINGS + 1:
                        inner = lambda q: D(*q) < D(x, y)
                        key = (sum(1 << k for k, n in enumerate(DIRS4) if inner((x + n[0], y + n[1]))),
                               sum(1 << k for k, c in enumerate(((-1, -1), (1, -1), (-1, 1), (1, 1)))
                                   if inner((x + c[0], y + c[1])) and not inner((x + c[0], y)) and not inner((x, y + c[1]))), x % 2, y % 2)
                        name, cs, ct = atlas_cell(texset, 'cvr', key)
                        x0_, x1_, z0_, z1_ = U(x, ox), U(x + 1, ox), U(y, oz), U(y + 1, oz)
                        M(name).quad([((x0_, top, z1_), (cs + 0.5, ct + 15.5)), ((x1_, top, z1_), (cs + 15.5, ct + 15.5)),
                                      ((x1_, top, z0_), (cs + 15.5, ct + 0.5)), ((x0_, top, z0_), (cs + 0.5, ct + 0.5))], up)
                    return
                base = top - TIER
                kind, what = K.classify(lower)
                if kind == 'straight':
                    n = what
                    straight.setdefault((n, base, y if n[0] == 0 else x), set()).add(x if n[0] == 0 else y)
                elif kind == 'inside':
                    nrm = up      # (HeartGold's walls carry no normals: lit evenly, their shading is in the textures)
                    # (HeartGold's own piece, in strips as HeartGold's are: a land's model has a size limit)
                    for form, poly in kit_strips[(kind, what)]:
                        vs = [((U(x, ox) + u, base + h, U(y, oz) + v), (s_, t_)) for u, v, h, s_, t_ in poly]
                        {'q': M(what).qstrip, 't': M(what).tstrip, 'quad': M(what).quad, 'tri': M(what).tri}[form](vs, nrm)
                elif kind == 'outside':
                    # the two straight faces, meeting on the square's diagonal from its outer corner (between its two
                    # lower sides) to its inner one: it fills the square to its corners, as the floor round it expects
                    # (HeartGold's own rounded piece stands back from the corner, and the floor's border would have
                    # to follow its curve)
                    sides = [n for n in DIRS4 if n in lower]
                    oc = (1 if any(n[0] > 0 for n in sides) else 0, 1 if any(n[1] > 0 for n in sides) else 0)
                    ic = (1 - oc[0], 1 - oc[1])
                    fns = K.distance_fns(sides)
                    for n in sides:
                        third = (ic[0], oc[1]) if n[0] == 0 else (oc[0], ic[1])      # (the other corner on n's side)
                        tri = [ic, oc, third]
                        tex, sgn, ax = K.FACE[n]
                        f = lambda u, v, n=n: (1 - v if n[1] > 0 else v) if n[0] == 0 else (1 - u if n[0] > 0 else u)
                        marks = [p_[0] for p_ in K.PROFILE]
                        for lo, hi in zip(marks, marks[1:]):
                            poly = K._clip(tri, f, lo, hi)
                            if not poly: continue
                            vs = []
                            for u, v in poly:
                                h, r = K.along_profile(K.PROFILE, f(u, v))
                                vs.append(((U(x + u, ox), base + h, U(y + v, oz)), (sgn * ((x + u) if ax == 'x' else (y + v)) * 16, r)))
                            (M(tex).quad if len(vs) == 4 else M(tex).tri)(vs, up)
                else:
                    for part, rng, f, poly in K.laid(lower, K.PROFILE, top=True):
                        if part == 'top':
                            tex = 'dcliff01'
                            vs = [((U(x + u, ox), top, U(y + v, oz)), ((x + u) * 16, (y + v) * 16)) for u, v in poly]
                        else:
                            tex, sgn, ax = K.FACE[(part[1], 0) if part[0] == 'x' else (0, part[1])]
                            vs = []
                            for u, v in poly:
                                h, r = K.along_profile(K.PROFILE, f(u, v))
                                vs.append(((U(x + u, ox), base + h, U(y + v, oz)), (sgn * ((x + u) if ax == 'x' else (y + v)) * 16, r)))
                        vs = K.facing_up(vs)
                        # (a normal for each way a face looks, not one a piece: a land's model has a size limit)
                        nrm = up      # (lit evenly, as HeartGold's walls)
                        (M(tex).quad if len(vs) == 4 else M(tex).tri)(vs, nrm)
                # a side against floor as high as the top: the wall's end, from the face up to that floor
                fns = K.distance_fns(lower)
                row = lambda h: 15.75 - h * 15.5 / 16
                for n in DIRS4:
                    q = (x + n[0], y + n[1])
                    if n in lower or q not in hts or HT(*q) < top - 0.5: continue
                    E = (lambda w: (w, 1.0 if n[1] > 0 else 0.0)) if n[0] == 0 else (lambda w: (1.0 if n[0] > 0 else 0.0, w))
                    ws = {0.0, 0.5, 1.0}
                    for w0, w1 in ((0.0, 0.5), (0.5, 1.0)):
                        d0, d1 = K.distance(fns, *E(w0))[0], K.distance(fns, *E(w1))[0]
                        for m_ in (p[0] for p in K.PROFILE):
                            if (d0 - m_) * (d1 - m_) < 0: ws.add(w0 + (m_ - d0) / (d1 - d0) * (w1 - w0))
                    ws = sorted(ws)
                    for w0, w1 in zip(ws, ws[1:]):
                        pts = []
                        for w in (w0, w1):
                            u, v = E(w)
                            pts.append((u, v, K.along_profile(K.PROFILE, K.distance(fns, u, v)[0])[0]))
                        if all(p_[2] >= 15.9 for p_ in pts): continue
                        (ua, va, ha), (ub, vb, hb_) = pts
                        sa, sb = [((x + uu) if n[0] == 0 else (y + vv)) * 16 for uu, vv in ((ua, va), (ub, vb))]
                        vs = [((U(x + ua, ox), base + ha, U(y + va, oz)), (sa, row(ha))), ((U(x + ub, ox), base + hb_, U(y + vb, oz)), (sb, row(hb_))),
                              ((U(x + ub, ox), top, U(y + vb, oz)), (sb, row(16))), ((U(x + ua, ox), top, U(y + va, oz)), (sa, row(16)))]
                        M(K.FACE[n][0]).quad(vs, up)
            for y in range(oz, oz + 32):
                for x in range(ox, ox + 32):
                    i = (y - oz) * 32 + (x - ox)
                    inside = x < W and y < H
                    x0, x1, z0, z1 = U(x, ox), U(x + 1, ox), U(y, oz), U(y + 1, oz)
                    if inside and not blocked[y][x]:
                        perm[i] = 0x0015 if (x, y) in water else FLOOR
                    lv = LV(x, y)
                    rockq = lv is not None and (x, y) not in hts and (x, y) not in foot
                    # flat pieces are gathered here and drawn in runs below (the DS draws 2048 polygons a frame,
                    # people included: a cave drawn square by square leaves none for them)
                    if (x, y) in hts and (x, y) not in water and (x, y) not in holes and not ((x, y) in ladders and ladders[(x, y)] == LADDER_DOWN):
                        # the floor's darker border, HeartGold's (`droad01_r`: its left half is the straight piece, the
                        # foot of the wall at s=0, floor by s=16) all round the floor: along the foot of a wall, the
                        # lip of a cliff, the water's bank. It is laid by how far a point is from the nearest rock, so
                        # the band keeps one width all the way round. A square with one side against rock is the
                        # straight piece whole (drawn in runs below). Any other is cut into the four triangles from
                        # its middle to its sides: a side against rock takes the straight piece from that side (where
                        # two meet they mitre on the diagonal); a side of floor takes it from the rock beside it, or
                        # fans it round a corner of rock that pokes in.
                        notfloor = lambda q: (q not in hts or q in water) and q not in foot and q not in rounded
                        wall = {n: notfloor((x + n[0], y + n[1])) for n in DIRS4}
                        poke = {(dx, dz) for dx in (-1, 1) for dz in (-1, 1)
                                if notfloor((x + dx, y + dz)) and not wall[(dx, 0)] and not wall[(0, dz)]}
                        # (a rounded outside corner beside it: the border keeps its distance from the corner's curve)
                        # (only one near enough to change the square: within the band's reach of it)
                        reach = lambda c: ((max(0, -c[0], c[0] - 16)) ** 2 + (max(0, -c[1], c[1] - 16)) ** 2) ** 0.5 < ROUND_R + BAND_END
                        rounds = tuple(sorted(c for c in ((dx * 16 + rounded[(x + dx, y + dz)][0], dz * 16 + rounded[(x + dx, y + dz)][1])
                                              for dx in (-1, 0, 1) for dz in (-1, 0, 1) if (dx or dz) and (x + dx, y + dz) in rounded) if reach(c)))
                        # (at the floor's own height, as HeartGold lays it: the DS cannot tell a unit's difference in
                        # depth from up here, and of two things at one depth the one drawn first stays - the border's
                        # material comes before the floor's, which is drawn last)
                        hh_ = lv * TIER
                        sides = [n for n in DIRS4 if wall[n]]
                        if sides or poke or rounds: bordered.add((x, y))       # (no floor under it: the border is the whole square, as in HeartGold)
                        if len(sides) == 1 and not poke and not rounds and not wall[(-sides[0][0], -sides[0][1])]:
                            flats.setdefault(('droad01_r', hh_, sides[0]), set()).add((x, y))
                        elif sides or poke or rounds:
                            # (any other square: a picture of its own, drawn from HeartGold's straight piece by how far
                            # each texel is from the nearest rock - the band mitres in a corner and rounds a corner of
                            # rock - and laid as one square, as HeartGold lays its pieces. See border_texture.)
                            key = (sum(1 << k for k, n in enumerate(DIRS4) if wall[n]),
                                   sum(1 << k for k, c in enumerate(((-1, -1), (1, -1), (-1, 1), (1, 1))) if c in poke), x % 2, y % 2, rounds)
                            name, cs, ct = atlas_cell(texset, 'cvb', key)
                            M(name).quad([((x0, hh_, z1), (cs + 0.5, ct + 15.5)), ((x1, hh_, z1), (cs + 15.5, ct + 15.5)),
                                          ((x1, hh_, z0), (cs + 15.5, ct + 0.5)), ((x0, hh_, z0), (cs + 0.5, ct + 0.5))], up)
                    if rockq:
                        rock_square(x, y, lv)
                    if (x, y) in ladders:
                        m = ladders[(x, y)]
                        perm[i] = 0x0A3C if m == LADDER_UP else 0x0A3E
                        # (two ladder squares side by side, as the GBA has for a wide ladder: one ladder over both)
                        if ladders.get((x - 1, y)) != m:
                            px = x + (1.0 if ladders.get((x + 1, y)) == m else 0.5)
                            props.append((m, U(px, ox), HT(x, y), U(y + 0.5, oz)))
                    if (x, y) in holes:      # a hole in the floor: dark, round, a little in from the square's sides, the floor round it
                        perm[i] = 0x0A3E
                        hb, cx_, cz_ = HT(x, y), x + 0.5, y + 0.5
                        ring = [(cx_ + 0.4 * math.cos(math.pi * k / 4), cz_ + 0.4 * math.sin(math.pi * k / 4)) for k in range(8)]
                        edge = [(cx_ + 0.5 * max(-1, min(1, math.cos(math.pi * k / 4) * 2 ** 0.5)), cz_ + 0.5 * max(-1, min(1, math.sin(math.pi * k / 4) * 2 ** 0.5))) for k in range(8)]
                        for k in range(8):
                            for tex_, pts in (('d_ro', [(cx_, cz_), ring[(k + 1) % 8], ring[k]]),
                                              ('droad01', [ring[k], ring[(k + 1) % 8], edge[(k + 1) % 8], edge[k]])):
                                vs = [((U(px, ox), hb, U(pz, oz)), (4, 4) if tex_ == 'd_ro' else (px * 16, pz * 16)) for px, pz in pts]
                                ar = sum(vs[j][0][0] * vs[(j + 1) % len(vs)][0][2] - vs[(j + 1) % len(vs)][0][0] * vs[j][0][2] for j in range(len(vs)))
                                if ar > 0: vs.reverse()          # (facing up)
                                (M(tex_).quad if len(vs) == 4 else M(tex_).tri)(vs, up)
                    if (x, y) in mouths:
                        b = mouths[(x, y)]
                        perm[i] = 0x0A00 | b
                        if b == 0x6F and y + 1 < oz + 32: perm[i + 32] = 0x8065
                        if b == 0x6E:     # the mouth: a dark opening in the wall above
                            hb = HT(x, y)
                            M('d_ro').quad([((x0 + 2, hb, z0 - 0.5), (0, 8)), ((x1 - 2, hb, z0 - 0.5), (8, 8)),
                                            ((x1 - 2, hb + 28, z0 - 0.5), (8, 0)), ((x0 + 2, hb + 28, z0 - 0.5), (0, 0))], (0, 0, 1))
            # flat pieces in runs: along rows, or down columns for an edge running north-south
            for (tex, hh, orient), cells in flats.items():
                along_x = not (isinstance(orient, tuple) and len(orient) == 2 and orient[0] != 0)
                if isinstance(orient, tuple) and orient[0] == 'corner':
                    for (x, y) in cells:
                        dg = orient[1:]
                        x0, x1, z0, z1 = U(x, ox), U(x + 1, ox), U(y, oz), U(y + 1, oz)
                        cx_, cz_ = (x0 if dg[0] < 0 else x1), (z0 if dg[1] < 0 else z1)
                        fx_, fz_ = (x1 if dg[0] < 0 else x0), (z1 if dg[1] < 0 else z0)
                        M(tex).quad([((cx_, hh, cz_), (16.4, 0.4)), ((fx_, hh, cz_), (31.6, 0.4)),
                                     ((fx_, hh, fz_), (31.6, 15.6)), ((cx_, hh, fz_), (16.4, 15.6))], up)
                    continue
                left = set(cells)
                for (x, y) in sorted(cells, key=(lambda c: (c[1], c[0])) if along_x else (lambda c: (c[0], c[1]))):
                    if (x, y) not in left: continue
                    k = 1
                    step = (1, 0) if along_x else (0, 1)
                    while (x + step[0] * k, y + step[1] * k) in left: k += 1
                    for j in range(k): left.discard((x + step[0] * j, y + step[1] * j))
                    xe, ye = (x + k, y + 1) if along_x else (x + 1, y + k)
                    x0, x1, z0, z1 = U(x, ox), U(xe, ox), U(y, oz), U(ye, oz)
                    if orient is None:
                        M(tex).quad([((x0, hh, z1), (x * 16, ye * 16)), ((x1, hh, z1), (xe * 16, ye * 16)),
                                     ((x1, hh, z0), (xe * 16, y * 16)), ((x0, hh, z0), (x * 16, y * 16))], up)
                    else:
                        # an edge texture: its edge (s=0) on the orient side, running along the run (t)
                        n = orient
                        s0, si = (0.4, 15.0) if tex == 'droad01_r' else (0.4, 15.6)
                        corners = {(0, -1): [((x0, z0), s0, x * 16), ((x1, z0), s0, xe * 16), ((x1, z1), si, xe * 16), ((x0, z1), si, x * 16)],
                                   (0, 1): [((x0, z1), s0, x * 16), ((x1, z1), s0, xe * 16), ((x1, z0), si, xe * 16), ((x0, z0), si, x * 16)],
                                   (-1, 0): [((x0, z0), s0, y * 16), ((x0, z1), s0, ye * 16), ((x1, z1), si, ye * 16), ((x1, z0), si, y * 16)],
                                   (1, 0): [((x1, z0), s0, y * 16), ((x1, z1), s0, ye * 16), ((x0, z1), si, ye * 16), ((x0, z0), si, y * 16)]}[n]
                        M(tex).quad([((p[0], hh, p[1]), (sv, tv)) for p, sv, tv in corners], up)
            # the floor, in runs along each row at each height (a ladder down is a hole); boulders stand on it
            for y in range(oz, oz + 32):
                fl = lambda x: (x, y) in hts and not ((x, y) in ladders and ladders[(x, y)] == LADDER_DOWN) and (x, y) not in water \
                    and (x, y) not in bordered and (x, y) not in holes
                for kind, tex, dy in ((fl, 'droad01', 0), (lambda x: (x, y) in water, 'driver', WATER_Y)):
                    x = ox
                    while x < ox + 32:
                        if not kind(x): x += 1; continue
                        e = x + 1
                        while e < ox + 32 and kind(e) and hts[(e, y)] == hts[(x, y)]: e += 1
                        x0, x1, z0, z1, hh = U(x, ox), U(e, ox), U(y, oz), U(y + 1, oz), HT(x, y) + dy
                        M(tex).quad([((x0, hh, z1), (x * 16, (y + 1) * 16)), ((x1, hh, z1), (e * 16, (y + 1) * 16)),
                                     ((x1, hh, z0), (e * 16, y * 16)), ((x0, hh, z0), (x * 16, y * 16))], up)
                        x = e
            # under it all, the floor again, well down: where two of the pieces above meet at a point along another's
            # side (a run's long edge, say) the DS leaves a pixel open now and then, and through it the dark would show.
            # (Laid in a few rectangles over the squares the cave draws; the dark past the rim stays dark.)
            under = {(x, y) for x in range(ox, ox + 32) for y in range(oz, oz + 32) if LV(x, y) is not None}
            if under and UNDER:
                hb = min([HT(x, y) for (x, y) in under if (x, y) in hts] or [0]) + WATER_Y - 8
                for (x, y) in sorted(under, key=lambda c: (c[1], c[0])):
                    if (x, y) not in under: continue
                    e = x + 1
                    while (e, y) in under: e += 1
                    b = y + 1
                    while all((k, b) in under for k in range(x, e)): b += 1
                    for k in range(x, e):
                        for j in range(y, b): under.discard((k, j))
                    x0, x1, z0, z1 = U(x, ox), U(e, ox), U(y, oz), U(b, oz)
                    M('droad01').quad([((x0, hb, z1), (x * 16, b * 16)), ((x1, hb, z1), (e * 16, b * 16)),
                                       ((x1, hb, z0), (e * 16, y * 16)), ((x0, hb, z0), (x * 16, y * 16))], up)
            # the pool's bank: HeartGold's (`dpond_line`), inside the water's squares, laid by distance from the land
            # round it (cave_kit.BANK), so it turns the corners
            tw_, th_ = dims.get('dpond_line', (16, 16))
            bank_runs = {}
            for (x, y) in water:
                if not inland(x, y): continue
                land_ = [(dx, dz) for dx in (-1, 0, 1) for dz in (-1, 0, 1) if (dx or dz) and (x + dx, y + dz) not in water]
                if not land_: continue
                hb = HT(x, y)
                kind_, n_ = K.classify(land_)
                if kind_ == 'straight':         # (land on one side: in runs, below)
                    bank_runs.setdefault((n_, hb, y if n_[0] == 0 else x), set()).add(x if n_[0] == 0 else y)
                    continue
                for part, rng, f, poly in K.laid(land_, K.BANK):
                    vs = []
                    for (u, v) in poly:
                        h, r = K.along_profile(K.BANK, f(u, v))
                        s_ = ((x + u) if part[0] == 'z' else (y + v)) * 16
                        vs.append(((U(x + u, ox), hb + h, U(y + v, oz)), (s_ * tw_ / 16, r * th_ / 16)))
                    vs = K.facing_up(vs)
                    (M('dpond_line').quad if len(vs) == 4 else M('dpond_line').tri)(vs, up)
            # straight faces and banks, in runs along their lines (the profile across the square, from its foot)
            for (n, base, line), xs, profile, tex_of in [(k, v, K.PROFILE, None) for k, v in straight.items()] + \
                    [(k, v, K.BANK, 'dpond_line') for k, v in bank_runs.items()]:
                xs = sorted(xs)
                tex, sgn, ax = K.FACE[n] if tex_of is None else (tex_of, 1, None)
                rs = 1 if tex_of is None else th_ / 16.0
                runs_, st = [], xs[0]
                for a_, b_ in zip(xs, xs[1:] + [None]):
                    if b_ != a_ + 1: runs_.append((st, a_ + 1)); st = b_
                for a_, b_ in runs_:
                    # the foot's line, and from it back into the rock (-n) by each profile point
                    def P(w, d, h):
                        if n[0] == 0:
                            fz = line + (1 if n[1] > 0 else 0)
                            return (U(w, ox), base + h, U(fz - n[1] * d, oz))
                        fx_ = line + (1 if n[0] > 0 else 0)
                        return (U(fx_ - n[0] * d, ox), base + h, U(w, oz))
                    # (one quad strip across the profile: a land's model has a size limit)
                    vs = [v_ for d0, h0, r0 in profile for v_ in ((P(a_, d0, h0), (sgn * a_ * 16, r0 * rs)), (P(b_, d0, h0), (sgn * b_ * 16, r0 * rs)))]
                    M(tex).qstrip(vs, up)      # (lit evenly, as HeartGold's walls)
            # rock piles: HeartGold's rocks            # rock piles: HeartGold's rocks as HeartGold stands them (read off Union Cave): the small one (half of
            # `d_rock01s`) a square wide, the big one (`d_rock01`) two, leaning back
            for kind, x, y in cards:
                if not inland(x, y): continue
                hb = HT(x, y)
                if kind == 'big' and 'd_rock01' in dims:
                    zf = U(y + 1, oz) - 4.7
                    M('d_rock01').quad([((U(x, ox), hb + 0.7, zf), (0.6, 31.4)), ((U(x + 2, ox), hb + 0.7, zf), (31.4, 31.4)),
                                        ((U(x + 2, ox), hb + 23.3, zf - 22.6), (31.4, 0.4)), ((U(x, ox), hb + 23.3, zf - 22.6), (0.6, 0.4))], (0, 0.7, 0.7))
                    continue
                for i_ in range(2 if kind == 'big' else 1):
                    zf, u0 = U(y + 1, oz) + 1.7, 16.0 * ((x + i_ + y) % 2)
                    M('d_rock01s').quad([((U(x + i_, ox), hb + 2.5, zf), (u0 + 0.6, 31.5)), ((U(x + i_ + 1, ox), hb + 2.5, zf), (u0 + 15.5, 31.5)),
                                         ((U(x + i_ + 1, ox), hb + 23.6, zf - 22.5), (u0 + 15.5, 0.5)), ((U(x + i_, ox), hb + 23.6, zf - 22.5), (u0 + 0.6, 0.5))], (0, 0.7, 0.7))
            # steps: HeartGold's (`dslope`), a tier in a square, climbing north; and the ends of the cliff's faces
            # either side of them, closed (the wall's section, as high as the higher of it and the steps)
            for (x, y), f in foot.items():
                if not inland(x, y): continue
                x0, x1, z0, z1, yl, yh = U(x, ox), U(x + 1, ox), U(y, oz), U(y + 1, oz), f * TIER, (f + 1) * TIER
                M('dslope').quad([((x0, yl, z1), (0, 23.2)), ((x1, yl, z1), (32, 23.2)), ((x1, yh, z0), (32, 0.8)), ((x0, yh, z0), (0, 0.8))], (0, 0.7, 0.7))
                for xs, nx_, tex in ((x0, -1, 'dwall_w'), (x1, 1, 'dwall_e')):
                    nb = (x + nx_, y)
                    if nb in foot: continue
                    # (how far up the square, how high: beside a cliff's face, the higher of it and the steps; beside
                    # floor, the side of the upper floor, or the wedge under the steps)
                    sec = [(0, 0), (0.325, 5.2), (0.67, 16), (1, 16)] if nb not in hts else [(0, 16), (1, 16)] if hts[nb] > f else [(0, 0), (1, 16)]
                    for (q0, h0), (q1, h1) in zip(sec, sec[1:]):
                        Q = lambda q, h: ((xs, yl + h, z1 - q * 16), (q * 16, 15.75 - h * 15.5 / 16))
                        for quad in ([Q(q0, 0), Q(q1, 0), Q(q1, h1), Q(q0, h0)], [Q(q0, h0), Q(q1, h1), Q(q1, 0), Q(q0, 0)]):
                            M(tex).quad(quad, (-nx_, 0, 0))
            if not meshes:      # (a land all rock, past the cave's edge: the dark, as in HeartGold)
                M('d_ro').quad([((-256, 32, 256), (0, 8)), ((256, 32, 256), (8, 8)), ((256, 32, -256), (8, 0)), ((-256, 32, -256), (0, 0))], up)
            order = list(meshes)
            held = [t for t in anim_held if t not in meshes]
            assert len(held) == len(anim_held), ("an animated texture in a cave", anim_held)
            # (the pictures' sizes from this run: the set on disk has the last run's)
            atlas_dims = {n_: d_ for (st_, n_), d_ in ATLAS_DIM.items() if st_ == texset}
            groups = [('hold%d' % k, 'd_ro', pal_of('d_ro'), Mesh(), {'repeat': 3, 'size': dims['d_ro']}) for k in range(len(anim_held))] + \
                [(t, t, pal_of(t), meshes[t], {'repeat': 3, 'size': atlas_dims.get(t) or dims.get(t) or (256, 1024)}) for t in order]
            model = build_model('cv_cave_%d' % (spec['depth'] * 10 + len(lands)), groups)     # (names: 16 at most)
            model += b'\0' * (-len(model) % 4)
            bld = b''.join(struct.pack('<I3i3i3i8x', m, int(px * 4096), int(py * 4096), int(pz * 4096), 0, 0, 0, 4096, 4096, 4096)
                           for m, px, py, pz in props)
            # heights walked on: the floor's, the water's, the steps' slope; a plate for every run of a row
            fx = lambda v: int(round(v * 4096))
            pts, nrm, cst, plates, strips, access = [], [], [], [], [], []
            idx = lambda lst, v: lst.index(v) if v in lst else (lst.append(v) or len(lst) - 1)
            hkey = lambda x, y: ('step', foot[(x, y)]) if (x, y) in foot else ('flat', HT(x, y) + (WATER_Y if (x, y) in water else 0)) if (x, y) in hts \
                else ('flat', (LV(x, y) or 0) * TIER)
            for y in range(oz, oz + 32):
                row, x = [], ox
                while x < ox + 32:
                    key, e = hkey(x, y), x + 1
                    while e < ox + 32 and hkey(e, y) == key: e += 1
                    z0, z1 = U(y, oz), U(y + 1, oz)
                    if key[0] == 'flat': nv, dv = (0, 4096, 0), -fx(key[1])
                    else:               # (down a tier from its north edge to its south)
                        yb, sl = (key[1] + 1) * TIER, -1.0
                        ln = (1 + sl * sl) ** 0.5
                        nv, dv = (0, fx(1 / ln), fx(-sl / ln)), fx(-(yb - sl * z0) / ln)
                    plates.append((idx(pts, (fx(U(x, ox)), fx(z0))), idx(pts, (fx(U(e, ox)), fx(z1))), idx(nrm, nv), idx(cst, dv)))
                    row.append(len(plates) - 1); x = e
                strips.append((fx(U(y + 1, oz)), len(row), len(access))); access += row
            bdhc = struct.pack('<4s6H', b'BDHC', len(pts), len(nrm), len(cst), len(plates), len(strips), len(access)) + \
                b''.join(struct.pack('<2i', *q) for q in pts) + b''.join(struct.pack('<3i', *q) for q in nrm) + b''.join(struct.pack('<i', q) for q in cst) + \
                b''.join(struct.pack('<4H', *q) for q in plates) + b''.join(struct.pack('<iHH', *q) for q in strips) + \
                b''.join(struct.pack('<H', q) for q in access)
            p = struct.pack('<1024H', *perm)
            lands.append(struct.pack('<4I2H', len(p), len(bld), len(model), len(bdhc), 0x1234, 0) + p + bld + model + bdhc)
            assert len(model) < int(os.environ.get('CAVE_LIMIT', 61400)), ('model too big for a land', spec['gba'], len(lands), len(model))     # (HeartGold's biggest: 61420)
            build_floor.biggest = max(getattr(build_floor, 'biggest', 0), len(model))
    return gm, (nx, nz), lands


def matrix_file(tag, w, h, land_ids):
    d = slots.MATRIX_DIR
    existing = [f for f in os.listdir(d) if f.endswith('.bin')]
    mine = [f for f in existing if f.endswith('_CV_%s.bin' % tag)]
    name = mine[0] if mine else 'map_matrix_%04d_CV_%s.bin' % (max(int(f[11:15]) for f in existing if f[11:15].isdigit()) + 1, tag)
    nm = ('cv_' + tag.lower())[:16].encode()
    open(os.path.join(d, name), 'wb').write(bytes([w, h, 0, 0, len(nm)]) + nm + struct.pack('<%dH' % len(land_ids), *land_ids))
    slots._add_to_list(os.path.join(d, 'meson.build'), name)
    return 'NARC_map_matrix_' + name[:-4] + '_bin'


def main():
    for g, m in GBA_IDS.items():
        SLOTS[m] = next(c['map'] for c in CAVES if c['gba'] == g)
    depth_of = {GBA_IDS[c['gba']]: c['depth'] for c in CAVES}
    land, btnf = read_narc(open(LAND_NARC, 'rb').read())
    lid = CAVE_LAND_BASE

    def build(spec, quiet=False):
        # (a land's model has to stay under 61440 bytes, as HeartGold's do: a floor too busy for three tiers of rock
        # round it has fewer)
        # round it has fewer; first, it goes without the floor under it all)
        global RINGS, UNDER
        tries = [(r, u) for r in (3, 2, 1) for u in (True, False)]
        for RINGS, UNDER in tries:
            try:
                out = build_floor(spec, depth_of); break
            except AssertionError as e:
                if (RINGS, UNDER) == tries[-1] or 'model too big' not in str(e): raise
                if not quiet: print('  (%s: %s: %s)' % (spec['gba'], 'no floor under it all' if UNDER else '%d tiers of rock round it, not %d' % (RINGS - 1, RINGS), e.args[0][3]))
        RINGS, UNDER = 3, True
        return out
    # (first, the pieces of the border and rim each texture set needs, to size their pictures; again while a pass
    # turns up pieces the last did not have - the sizes of the lands' models change with them)
    for spec in CAVES:
        build(spec, quiet=True)
    draw_pieces()
    for _ in range(4):
        del _atlas_new[:]
        for spec in CAVES:
            build(spec, quiet=True)
        if not _atlas_new: break
        draw_pieces()
    assert not _atlas_new, 'the pieces did not settle'
    for spec in CAVES:
        tmpl = header(spec.get('template', TEMPLATE))
        gm, (nx, nz), lands = build(spec)
        ids = list(range(lid, lid + len(lands)))
        land += [b''] * max(0, ids[-1] + 1 - len(land))
        for i, d in zip(ids, lands): land[i] = d
        lid += len(lands)
        new_map(spec['map'])
        tag = spec['map'].replace('MAP_CANVAS_', '')
        mat = matrix_file(tag, nx, nz, ids)
        ev = json.load(open(os.path.join(slots.EVENT_DIR, events_file(TEMPLATE))))
        ev['warps'] = [{k: v for k, v in w.items() if not k.startswith('_')} for w in gba_warps(gm)]
        for w, gw in zip(ev['warps'], gm['warp_events']):
            ex = spec['exits'].get((gw['dest_map'], str(gw['dest_warp_id'])), spec['exits'].get(gw['dest_map']))
            if ex:
                w.update(x=gw['x'], z=gw['y'], y=0, header=ex[0], anchor=ex[1])
        ev['objects'], ev['bgs'], ev['coords'] = [], [], []
        evn = new_events_file(tag, ev)
        fields = {k: v for k, v in tmpl.items() if k not in ('matrixId', 'eventsBank')}
        fields.update(matrixId=mat, eventsBank=evn, areaDataBank=str(area_of(spec)), **NO_SCRIPTS)     # (HeartGold's look for that cave)
        fields['weather'] = '11' if gm.get('requires_flash') else '0'      # (dark until Flash only where the GBA's is)
        set_header(spec['map'], fields)
        set_header(spec['map'], {'matrixId': mat, 'eventsBank': evn})
        print(spec['gba'], '->', spec['map'], '%dx%d lands' % (nx, nz), ids)
    print('biggest land model: %d bytes' % build_floor.biggest)
    write_border_textures()
    land = [d if d else land[209] for d in land]
    open(LAND_NARC, 'wb').write(write_narc(land, btnf))
    # HeartGold's doors into its Mt. Moon lead into ours
    for (m, i), (to, anchor) in DOORS.items():
        path = os.path.join(slots.EVENT_DIR, events_file(m))
        ev = json.load(open(path))
        ev['warps'][i].update(header=to, anchor=anchor)
        json.dump(ev, open(path, 'w'), indent=4); open(path, 'a').write('\n')


if __name__ == '__main__':
    main()
