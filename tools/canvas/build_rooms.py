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
import furnish
from PIL import Image
from slots import SLOTS, ROOM_SLOTS, new_map, NO_SCRIPTS, matrix_file, events_file, gba_warps, header, set_header, new_events_file, new_matrix_file

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
    'gTileset_ViridianGym': {
        0x2A9: ('gym statue', 78, 1, 1, 'floor', 0),
        0x2AA: ('mat', 3, 3, 1, 'floor', 0),
    },
    'gTileset_PalletGym': {
        0x2A9: ('gym statue', 78, 1, 1, 'floor', 0),
        0x2AA: ('mat', 3, 3, 1, 'floor', 0),
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
STAIR_DOWN_RECT = (-13, 15, -12, 18)    # model 9's footprint about where it's placed (x0, x1, z0, z1, units)
MAT_LIFT = 1      # doormats (models 1, 3) stand a unit off the floor (level with it, the floor showed through in pieces)

# GBA behaviour -> HeartGold behaviour, for the squares that do something
BEHAVIOR = {0x65: 0x65, 0xEB: 0x5E, 0xEE: 0x5F, 0x86: 0x86, 0x83: 0x83, 0x85: 0x85,
            0x54: 0x40, 0x55: 0x41, 0x56: 0x42, 0x57: 0x43, 0x58: 0x4D}   # spin tiles -> HeartGold's slide tiles

# ---------------------------------------------------------------- rooms
HOUSE = dict(floor='red_h_yuka1', wall='red_h_kabe1', texset=43, buildset=41, area=43)
LAB = dict(floor='o_kido_yuka1', wall='o_kido_kaeb1', texset=43, buildset=41, area=43)
GYM = dict(texset=55, buildset=53, area=55, template='MAP_VIRIDIAN_GYM', keep_people=False)
PENNY_COL = [(4, 0), (4, 1), (4, 2), (1, 3), (1, 3), (1, 3), (1, 3), (1, 7), (0, 8)]   # a column of plain wall and floor in Penny's house
ROOMS = [   # GBA map, its GBA map constant (SLOTS gives the HeartGold slot), look, keep HeartGold's people there
    # (the house's 1F: a column more between the TV and the stairs down, as HeartGold's TV is two squares wide; until
    # MOM shows them, a cupboard stands over the stairs, as the GBA's map script draws it: the room's own land is
    # that, and the engine shows the open one once FLAG_BASEMENT_REVEALED is set)
    dict(gba='PalletTown_PlayersHouse_1F_Frlg', map='MAP_PALLET_TOWN_PLAYERS_HOUSE_1F', keep_people=True, widen=dict(cols=[(7, 1, 5)]),
         variant=dict(flag='FLAG_BASEMENT_REVEALED', file='data/scripts/dad_story.inc', script='DadStory_EventScript_HideStairs', tag='HOUSE_1F_OPEN'),
         **HOUSE),
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
    # Viridian City: the Gym, our spin-tile maze (GBA spin tiles = HeartGold's slide tiles) in HeartGold's slot.
    # HeartGold's own scripts stay: their map-load script starts the Viridian gymmick, which the slide tiles need
    dict(gba='ViridianCity_Gym_Frlg', map='MAP_VIRIDIAN_CITY_GYM', keep_people=False, pad=0x291, floor_flags=0x0600,
         exits={'MAP_VIRIDIAN_CITY': ('MAP_VIRIDIAN', 0)},
         gba_look=dict(tag='vg', floor=0x281, skip=(0x2A1, 0x2AB, 0x2AC), walls=dict(face=0x299, cap=0x291, emblems=[0x2D3]),
                       blocks=dict(top=(180, 180, 164), face=0x2A3, height=24), things=[]),
         texset=55, buildset=53, area=55),
    # Viridian City: Penny's house (its door is added to HeartGold's Viridian by build_kanto.py, warp 7 there)
    # (bigger than the GBA's 11x9, with room for her plushes about the floor: three plain columns each side of the rug and
    # two plain rows above it, 17x11. The plushes' squares are the porter's: port_map.pennys_plushes)
    dict(gba='ViridianCity_PennysHouse_Frlg', map='MAP_VIRIDIAN_CITY_PENNYS_HOUSE', keep_people=False,
         widen=dict(cols=[(2, 3, PENNY_COL), (9, 3, PENNY_COL)], rows=[(3, 2, [(1, 3)] * 11)]),
         template='MAP_VIRIDIAN_NORTHEAST_HOUSE', exits={'MAP_VIRIDIAN_CITY': ('MAP_VIRIDIAN', 7)}, **HOUSE),
    # the Pallet Gym (the decorating system fills it at run time) and the rooms Oak builds on: every 100 kinds of
    # POKeMON caught adds a room (back, left, right), and 50, 150, 250, 350 make the hall and those rooms bigger
    dict(gba='PalletTown_Gym_Frlg', map='MAP_PALLET_TOWN_GYM', gba_look=dict(tag='gy', floor=0x281, skip=(0x2A1, 0x2AB, 0x2AC), pc_script='GymDecor_EventScript_GymPC', walls=dict(face=0x299, cap=0x291, emblems=[0x2D3]), things=[]), **GYM),
    dict(gba='PalletTown_Gym_BackRoom', map='MAP_PALLET_TOWN_GYM_BACK_ROOM', gba_look=dict(tag='gb', floor=0x281, skip=(0x2A1, 0x2AB, 0x2AC), pc_script='GymDecor_EventScript_GymPC', walls=dict(face=0x299, cap=0x291), things=[]), **GYM),
    dict(gba='PalletTown_Gym_LeftRoom', map='MAP_PALLET_TOWN_GYM_LEFT_ROOM', gba_look=dict(tag='gl', floor=0x281, skip=(0x2A1, 0x2AB, 0x2AC), pc_script='GymDecor_EventScript_GymPC', walls=dict(face=0x299, cap=0x291), things=[]), **GYM),
    dict(gba='PalletTown_Gym_RightRoom', map='MAP_PALLET_TOWN_GYM_RIGHT_ROOM', gba_look=dict(tag='gr', floor=0x281, skip=(0x2A1, 0x2AB, 0x2AC), pc_script='GymDecor_EventScript_GymPC', walls=dict(face=0x299, cap=0x291), things=[]), **GYM),
    dict(gba='PalletTown_Gym_Frlg', map='MAP_PALLET_TOWN_GYM+50', gba_look=dict(tag='gY', floor=0x281, skip=(0x2A1, 0x2AB, 0x2AC), pc_script='GymDecor_EventScript_GymPC', walls=dict(face=0x299, cap=0x291, emblems=[0x2D3]), things=[]), widen=dict(cols=[(6, 3), (18, 3)]), **GYM),
    dict(gba='PalletTown_Gym_BackRoom', map='MAP_PALLET_TOWN_GYM_BACK_ROOM+150', gba_look=dict(tag='gB', floor=0x281, skip=(0x2A1, 0x2AB, 0x2AC), pc_script='GymDecor_EventScript_GymPC', walls=dict(face=0x299, cap=0x291), things=[]), widen=dict(cols=[(4, 2), (12, 2)], rows=[(6, 2)]), **GYM),
    dict(gba='PalletTown_Gym_LeftRoom', map='MAP_PALLET_TOWN_GYM_LEFT_ROOM+250', gba_look=dict(tag='gL', floor=0x281, skip=(0x2A1, 0x2AB, 0x2AC), pc_script='GymDecor_EventScript_GymPC', walls=dict(face=0x299, cap=0x291), things=[]), widen=dict(cols=[(4, 2), (12, 2)], rows=[(4, 2)]), **GYM),
    dict(gba='PalletTown_Gym_RightRoom', map='MAP_PALLET_TOWN_GYM_RIGHT_ROOM+350', gba_look=dict(tag='gR', floor=0x281, skip=(0x2A1, 0x2AB, 0x2AC), pc_script='GymDecor_EventScript_GymPC', walls=dict(face=0x299, cap=0x291), things=[]), widen=dict(cols=[(4, 2), (12, 2)], rows=[(4, 2)]), **GYM),
    # houses of the GBA's that HeartGold has none for (their doors in the GBA-layout towns: build_overworld.py)
    dict(gba='CeruleanCity_House4_Frlg', map='MAP_CERULEAN_CITY_HOUSE4', keep_people=False, template='MAP_CERULEAN_NORTH_HOUSE', **HOUSE),
    dict(gba='CeruleanCity_House5_Frlg', map='MAP_CERULEAN_CITY_HOUSE5', keep_people=False, template='MAP_CERULEAN_NORTH_HOUSE', **HOUSE),
    dict(gba='FuchsiaCity_House2_Frlg', map='MAP_FUCHSIA_CITY_HOUSE2', keep_people=False, template='MAP_FUCHSIA_SOUTHWEST_HOUSE', **HOUSE),
    dict(gba='FuchsiaCity_House3_Frlg', map='MAP_FUCHSIA_CITY_HOUSE3', keep_people=False, template='MAP_FUCHSIA_SOUTHWEST_HOUSE', **HOUSE),
    dict(gba='PewterCity_PainterLoft_Frlg', map='MAP_PEWTER_CITY_PAINTER_LOFT', keep_people=False, template='MAP_PEWTER_NORTHEAST_HOUSE', **HOUSE),
    dict(gba='Route19_UnusedHouse_Frlg', map='MAP_ROUTE19_UNUSED_HOUSE', keep_people=False, template='MAP_FUCHSIA_SOUTHWEST_HOUSE', **HOUSE),
    dict(gba='SaffronCity_House_Frlg', map='MAP_SAFFRON_CITY_HOUSE', keep_people=False, template='MAP_SAFFRON_MR_PSYCHIC_HOUSE', **HOUSE),
    dict(gba='SaffronCity_TcgHouse_Frlg', map='MAP_SAFFRON_CITY_TCG_HOUSE', keep_people=False, template='MAP_SAFFRON_MR_PSYCHIC_HOUSE', **HOUSE),
    dict(gba='CeladonCity_House1_Frlg', map='MAP_CELADON_CITY_HOUSE1', keep_people=False, template='MAP_CELADON_CONDOMINIUMS_1F', **HOUSE),
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


PC_MODEL, PC_OFFSET = 33, 0.375     # bm_room pc01, placed as in HeartGold's Pokemon Centers
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


def gba_art(lay, spec, first, last, x0, x1, wall_z, blocked, mid, tsn, claimed, warp_sq, M, add, dims, U):
    """What the GBA draws in a room that HeartGold has no model for (no FURNITURE, no furnish.py rule): its own art.
    A closed patch out on the floor is its picture folded into a solid (box: a top, then a face standing up); a
    picture on the back wall (a sign, a door, a blackboard) is laid on HeartGold's wall at its height there (the
    GBA's lowest wall row at the floor). Drawing only where HeartGold has nothing (Nick)."""
    from collections import Counter
    W, H = lay.w, lay.h
    covered = set(claimed)
    for y in range(H):
        for x in range(W):
            m = mid(x, y)
            f = FURNITURE.get(tsn(m), {}).get(m)
            if f: covered |= {(x + i, y + j) for i in range(f[2]) for j in range(f[3])}
            if m in WINDOWS.get(tsn(m), {}): covered |= {(x + i, y) for i in range(WINDOWS[tsn(m)][m])}
            if m in WINDOWS.get(tsn(m), {}): covered |= {(x + i, y + 1) for i in range(WINDOWS[tsn(m)][m])}   # (and its sill)
            if m in STAIRS_UP.get(tsn(m), {}) or m in STAIRS_DOWN.get(tsn(m), {}):
                covered |= {(x + i, y + j) for i in range(-1, 3) for j in range(-3, 3)}
            if m in RUGS.get(tsn(m), {}):          # (HeartGold's rug: as build_room lays it)
                rw = 1
                while x + rw < W and mid(x + rw - 1, y) != 0x46: rw += 1
                rh = 1
                while y + rh < H and mid(x, y + rh - 1) != 0x5B: rh += 1
                covered |= {(x + i, y + j) for i in range(rw) for j in range(rh)}
    full = lay.render()
    _dark = {}

    def dark(m):            # (the black beyond the room)
        if m not in _dark: _dark[m] = sum(sum(px[:3]) for px in lay.render_metatile(m).convert('RGB').getdata()) / 256 < 60
        return _dark[m]
    floor_cnt = Counter(mid(x, y) for y in range(first, last + 1) for x in range(x0, x1) if not blocked(x, y))
    if not floor_cnt: return
    floor_mt = floor_cnt.most_common(1)[0][0]
    floor_im = lay.render_metatile(floor_mt)
    n = [0]
    dbg = os.environ.get('CV_ART_DEBUG')

    def mean(im):
        px = [p_ for p_ in im.convert('RGBA').getdata() if p_[3]]
        return tuple(sum(p_[k] for p_ in px) / max(1, len(px)) for k in range(3))

    def comps(sq):
        out, sq = [], set(sq)
        while sq:
            c = sq.pop(); comp, st = {c}, [c]
            while st:
                q = st.pop()
                for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                    nb = (q[0] + dx, q[1] + dy)
                    if nb in sq: sq.discard(nb); comp.add(nb); st.append(nb)
            out.append(comp)
        return out
    # out on the floor
    for comp in comps({(x, y) for y in range(first, last + 1) for x in range(x0, x1)
                       if blocked(x, y) and (x, y) not in covered and (x, y) not in warp_sq and not dark(mid(x, y))}):
        xs = [c[0] for c in comp]; ys = [c[1] for c in comp]
        a, b, c0, c1 = min(xs), max(xs) + 1, min(ys), max(ys) + 1
        if c0 - 1 >= first and all(not blocked(x, c0 - 1) and mid(x, c0 - 1) != floor_mt and (x, c0 - 1) not in covered for x in range(a, b)):
            c0 -= 1                # (its top, over the square behind it)
        px, py, pw, ph = a * 16, c0 * 16, (b - a) * 16, (c1 - c0) * 16
        im = cards.cut_out(full.crop((px, py, px + pw, py + ph)), floor_im, (px, py))
        if sum(1 for p_ in im.getdata() if p_[3]) < pw * ph * 0.08: continue
        name = 'cv_t%d' % n[0]; n[0] += 1
        if dbg: print('   art', spec['gba'], name, (a, c0), sorted({'%x' % mid(*c) for c in comp}))
        add(name, im, 15)
        top = 6 if ph <= 16 else 8
        box(M(name), px, py, pw, ph, [('h', top), ('v', ph - top)])
    # mats and carpets: a patch of walkable squares in metatiles of their own (three kinds at least: edges and
    # corners), laid on the floor in the GBA's art (HeartGold's floor is plain where the GBA's has its battle mat)
    fm = mean(floor_im)
    hue = lambda c: tuple(v / max(1, sum(c)) for v in c)
    # (unlike the floor in colour, not just its shading: a mat, not the floor's darker boards)
    unlike = {m for m in floor_cnt if m != floor_mt and sum(abs(p_ - q_) for p_, q_ in zip(hue(mean(lay.render_metatile(m))), hue(fm))) >= 0.08}
    for comp in comps({(x, y) for y in range(first, last + 1) for x in range(x0, x1)
                       if not blocked(x, y) and (x, y) not in covered and (x, y) not in warp_sq and mid(x, y) in unlike}):
        if len(comp) < 4 or len({mid(*c) for c in comp}) < 3: continue
        xs = [c[0] for c in comp]; ys = [c[1] for c in comp]
        a, b, c0, c1 = min(xs), max(xs) + 1, min(ys), max(ys) + 1
        px, py, pw, ph = a * 16, c0 * 16, (b - a) * 16, (c1 - c0) * 16
        im = full.crop((px, py, px + pw, py + ph)).convert('RGBA')
        for x in range(a, b):            # (only its own squares)
            for y in range(c0, c1):
                if (x, y) not in comp: im.paste((0, 0, 0, 0), ((x - a) * 16, (y - c0) * 16, (x - a + 1) * 16, (y - c0 + 1) * 16))
        name = 'cv_f%d' % n[0]; n[0] += 1
        add(name, im, 15)
        M(name).quad([((U(a), 1, U(c1)), (0, ph)), ((U(b), 1, U(c1)), (pw, ph)), ((U(b), 1, U(c0)), (pw, 0)), ((U(a), 1, U(c0)), (0, 0))], (0, 1, 0))
    # on the back wall
    wall_sq = [(x, y) for y in range(first) for x in range(x0, x1)]
    cnt = Counter(mid(x, y) for x, y in wall_sq)
    row_plain = {y: Counter(mid(x, y) for x in range(x0, x1)).most_common(1)[0][0] for y in range(first)}
    plain = {m for m, k in cnt.items() if k >= 4} | set(row_plain.values())
    zz = U(wall_z) + 0.5
    for comp in comps({(x, y) for x, y in wall_sq if mid(x, y) not in plain and (x, y) not in covered and not dark(mid(x, y))}):
        xs = [c[0] for c in comp]; ys = [c[1] for c in comp]
        a, b, c0, c1 = min(xs), max(xs) + 1, min(ys), max(ys) + 1
        px, py, pw, ph = a * 16, c0 * 16, (b - a) * 16, (c1 - c0) * 16
        im = full.crop((px, py, px + pw, py + ph)).convert('RGBA')
        bg = Image.new('RGBA', (pw, ph))
        for y in range(c0, c1):
            for x in range(a, b):
                bg.paste(lay.render_metatile(row_plain[y]).convert('RGBA'), ((x - a) * 16, (y - c0) * 16))
        im = cards.cut_out(im, bg)
        if sum(1 for p_ in im.getdata() if p_[3]) < pw * ph * 0.08: continue
        name = 'cv_w%d' % n[0]; n[0] += 1
        if dbg: print('   art', spec['gba'], name, (a, c0), sorted({'%x' % mid(*c) for c in comp}))
        add(name, im, 15)
        ylo, yhi = (first - c1) * 16, min(48, (first - c0) * 16)
        M(name).quad([((U(a), ylo, zz), (0, ph)), ((U(b), ylo, zz), (pw, ph)), ((U(b), yhi, zz), (pw, ph - (yhi - ylo))), ((U(a), yhi, zz), (0, ph - (yhi - ylo)))], (0, 0, 1))


def widen(gm, lay, cols=(), rows=()):
    """A bigger copy of a GBA room: before each (old column, n) of `cols`, n more copies of that column (likewise
    `rows`); its events move with the squares they stand on"""
    import copy
    gm = copy.deepcopy(gm)
    # (an entry (col, n, src) puts n copies of column src before col instead: a plain column into a gap. src may
    # also be a list of (x, y) squares of the room, one per row, whose blocks make up the new column: plain wall
    # and floor where no whole column is plain. Likewise rows; where a new row crosses a new column, the row's
    # square for the column it was put before)
    blk = lambda s: [lay.blocks[y][x] for x, y in s] if isinstance(s, (list, tuple)) else s
    cols = [(c[0], c[1], blk(c[2] if len(c) == 3 else c[0])) for c in cols]
    rows = [(r[0], r[1], blk(r[2] if len(r) == 3 else r[0])) for r in rows]
    cmap = [s_ for x in range(lay.w) for s_ in [(x, src) for c, n, src in cols if c == x for _ in range(n)] + [(x, x)]]
    rmap = [s_ for y in range(lay.h) for s_ in [(y, src) for r, n, src in rows if r == y for _ in range(n)] + [(y, y)]]

    def cell(r, c):
        (ay, rs), (ax, cs) = r, c
        if isinstance(rs, list): return rs[ax]
        if isinstance(cs, list): return cs[rs]
        return lay.blocks[rs][cs]
    lay.blocks = [[cell(r, c) for c in cmap] for r in rmap]
    lay.w, lay.h = len(cmap), len(rmap)
    sx = lambda x: x + sum(n for c, n, _ in cols if c <= x)
    sy = lambda y: y + sum(n for r, n, _ in rows if r <= y)
    for k in ('warp_events', 'bg_events', 'object_events'):
        for e in gm.get(k, []):
            e['x'], e['y'] = sx(e['x']), sy(e['y'])
    return gm


def pad(gm, lay, metatile):
    """A blocked column of `metatile` either side (for rooms whose floor runs to the GBA map's edges: the walls
    need squares to stand on); events move one square right"""
    import copy
    gm = copy.deepcopy(gm)
    wall = metatile | (1 << 10)
    lay.blocks = [[wall] + row + [wall] for row in lay.blocks]
    lay.w += 2
    for k in ('warp_events', 'bg_events', 'object_events'):
        for e in gm.get(k, []):
            e['x'] += 1
    return gm


def hidden_edits(v):
    """the setmetatile lines of a GBA script (v['script'] in v['file']) -> [(x, y, metatile, collision)]"""
    src = open(os.path.join(gba_map.P(v['file']))).read()
    body = src[src.index(v['script'] + '::'):]
    body = body[:body.index('\n\tend')]
    return [(int(x), int(y), int(m, 16), 1 if c == 'TRUE' else 0)
            for x, y, m, c in re.findall(r'setmetatile (\d+), (\d+), (0x[0-9A-Fa-f]+), (TRUE|FALSE)', body)]


def write_variants(variants):
    """tools/canvas/data/canvas_variants.h for the engine (canvas_map_headers.c): a map shows another matrix while
    one of our flags is set"""
    ids = json.load(open(os.path.join(HERE, 'data', 'canvas_ids.json')))
    maps = {n: int(v_) for n, v_ in re.findall(r'#define (MAP_\w+)\s+(\d+)', open(os.path.join(ROOT, 'include/constants/maps.h')).read())}
    lines = ['// Pokemon Canvas: generated by tools/canvas/build_rooms.py (VARIANTS). { map, our flag (0x2000 + n: n), matrix }',
             '#define CANVAS_VARIANTS \\']
    for slot, flag, mat in variants:
        num = int(re.match(r'NARC_map_matrix_map_matrix_(\d+)_', mat).group(1))
        lines.append('    { %d, %d, %d },   /* %s while %s */ \\' % (maps[slot], ids['flags'][flag] if 'flags' in ids else ids[flag], num, slot, flag))
    lines.append('')
    open(os.path.join(HERE, 'data', 'canvas_variants.h'), 'w').write('\n'.join(lines) + '\n')


STANDS = {}       # map slot -> its first floor row and the squares of it HeartGold's wall furniture stands on


def build_room(spec, land_id):
    gm = gba_map.map_json(spec['gba'])
    lay = gba_map.Layout(gm['layout'])
    for x, y, mt, coll in spec.get('edits') or ():      # (the room as a map script first draws it: see VARIANTS)
        lay.blocks[y][x] = (lay.blocks[y][x] & ~0x7FF) | mt | (coll << 10)
    if spec.get('widen'):
        gm = widen(gm, lay, **spec['widen'])
    if spec.get('pad'):
        gm = pad(gm, lay, spec['pad'])
    ts_name = gba_map.layouts()[gm['layout']]['primary_tileset']
    sec_name = gba_map.layouts()[gm['layout']]['secondary_tileset']
    tsn = lambda m: ts_name if m < lay.n_prim else sec_name
    W, H = lay.w, lay.h
    dims, pals = texdims(spec['texset'])
    own = []                      # (texture entry, palette entry) made from the GBA art for this room
    look = spec.get('gba_look')
    extra_props = []

    def add(name, im, colours=255):
        t, p_, wh = cards.texture(name, im, colours)
        own.append((t, p_)); dims[name] = wh; pals.add(name + '_pl')
        return wh
    if look:
        tag = look['tag']
        floor_im = lay.render_metatile(look['floor'])
        spec = dict(spec, floor='cv_%s_floor' % tag, wall='cv_%s_wall' % tag)
        add(spec['floor'], floor_im, 15)
        dims[spec['floor']] = (16, 16)
    pal_of = lambda t: next(p for p in (t + '_pl', t, t.replace('gs', '')) if p in pals)
    mid = lambda x, y: lay.metatile(x, y)
    blocked = lambda x, y: lay.collision(x, y) != 0
    # the first floor row: the first row with a walkable square
    # (in a house look a door in the back wall - a warp square up in the wall rows - doesn't count: the wall's art
    # shows it, and it is walked into, north)
    wsq = set() if look else {(w['x'], w['y']) for w in gm.get('warp_events', [])}
    first = next(y for y in range(H) if any(not blocked(x, y) and ((x, y) not in wsq or y == H - 1 or not blocked(x, y - 1) and (x, y - 1) not in wsq) for x in range(W)))
    wall_z = first - 0.5
    meshes = {}
    M = lambda t: meshes.setdefault(t, Mesh())
    U = lambda v: v * 16 - 256          # block -> land units
    up, fwd = (0, 1, 0), (0, 0, 1)
    # floor: every square from the first floor row down to the last row with anything walkable
    last = max(y for y in range(H) if any(not blocked(x, y) for x in range(W)))
    # (a doorway in a side wall - a warp square - doesn't move the wall)
    warp_sq = {(w['x'], w['y']) for w in gm.get('warp_events', [])}
    cols = [x for x in range(W) if any(not blocked(x, y) and (x, y) not in warp_sq for y in range(first, last + 1))]
    x0, x1 = min(cols), max(cols) + 1
    # doorways: warps in the walls (GBA gyms open these at run time; here they are open). -> behaviour
    doors = {}
    for w in gm.get('warp_events', []):
        x, y = w['x'], w['y']
        if x < x0: doors[(x, y)] = 0x63          # walk west through it
        elif x >= x1: doors[(x, y)] = 0x62       # east
        elif y < first: doors[(x, y)] = 0x64     # north
    fw, fh = dims[spec['floor']]
    # the GBA's furniture by patches (furnish.py): HeartGold's models sized to the GBA's things
    fz = []                 # (model, x, y off, z) in squares
    fz_close, fz_rugs, fz_wins, claimed = set(), [], [], set()
    if not look:
        for name, kind, comp in furnish.patches(lay, tsn):
            pr, cl, rg, wn = furnish.place(kind, comp, first, blocked)
            fz += [(m, x, yo, z) for m, x, z, yo in pr]
            fz_close |= {c for c in cl if c not in warp_sq}
            fz_rugs += rg; fz_wins += wn
            claimed |= comp

    def stair_model(x, y, model):
        """HeartGold's staircases come both ways round (7 up to the right, 8 up to the left; 9 down to the left, 10 down
        to the right): the GBA's climbs or goes down towards the closed side of its two squares, so ours does"""
        shut = lambda xx: not (0 <= xx < W) or blocked(xx, max(y, first)) or not any(not blocked(xx, yy) for yy in range(first, last + 1))
        left = shut(x - 1) and not shut(x + 2)
        if model == 7: return 8 if left else 7
        if model == 9: return 9 if left or not shut(x + 2) else 10
        return model
    down_rect = lambda x, y: (-15, 13, -12, 18) if stair_model(x, y, 9) == 10 else STAIR_DOWN_RECT
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
    # round a staircase down, the floor reaches the stairs model (its footprint, from STAIR_DOWN_RECT): a hole of
    # whole squares left a black border round it
    for y in range(H):
        for x in range(W):
            if mid(x, y) not in STAIRS_DOWN.get(tsn(mid(x, y)), {}): continue
            R_ = down_rect(x, y)
            ax, bx = x + 1 + R_[0] / 16, x + 1 + R_[1] / 16
            az, bz = first + 0.5 + R_[2] / 16, first + 0.5 + R_[3] / 16
            zt, zb_ = (wall_z if y <= first else y), y + 2
            for (qa, qb, qc, qd) in ((x, ax, zt, zb_), (bx, x + 2, zt, zb_), (ax, bx, zt, az), (ax, bx, bz, zb_)):
                if qb - qa < 0.01 or qd - qc < 0.01: continue
                M(spec['floor']).quad([((U(qa), 0, U(qd)), ((qa - x0) * fw, (qd - wall_z) * fh)), ((U(qb), 0, U(qd)), ((qb - x0) * fw, (qd - wall_z) * fh)),
                                       ((U(qb), 0, U(qc)), ((qb - x0) * fw, (qc - wall_z) * fh)), ((U(qa), 0, U(qc)), ((qa - x0) * fw, (qc - wall_z) * fh))], up)
    # the bottom edge: the floor runs a quarter square on past the last row, under the doormat's front (HeartGold's
    # mat hangs that far over the floor's edge; past our edge it floated over the dark, cut in two)
    M(spec['floor']).quad([((U(x0), 0, U(last + 1.25)), (0, (last + 1.25 - wall_z) * fh)), ((U(x1), 0, U(last + 1.25)), ((x1 - x0) * fw, (last + 1.25 - wall_z) * fh)),
                           ((U(x1), 0, U(last + 1)), ((x1 - x0) * fw, (last + 1 - wall_z) * fh)), ((U(x0), 0, U(last + 1)), (0, (last + 1 - wall_z) * fh))], up)
    for (x, y) in doors:
        z0f = y if y >= first else y
        M(spec['floor']).quad([((U(x), 0, U(y + 1)), (0, fh)), ((U(x + 1), 0, U(y + 1)), (fw, fh)),
                               ((U(x + 1), 0, U(y)), (fw, 0)), ((U(x), 0, U(y)), (0, 0))], up)
    # back wall, three blocks tall like HeartGold's
    ww, wh = dims[spec['wall']] if not look else (0, 0)
    if look and look.get('walls'):
        # solid walls all round, joined up: the GBA wall-base tile along the bottom of every face, plain wall
        # colour above it and on the caps (the GBA wall-top tile is striped, and repeats badly)
        full = lay.render()
        wl = look['walls']
        face, plain = 'cv_%s_wface' % tag, 'cv_%s_wall' % tag
        add(face, lay.render_metatile(wl['face']), 15)
        add(plain, Image.new('RGBA', (8, 8), lay.render_metatile(wl['cap']).getpixel(wl.get('cap_pixel', (8, 12)))), 15)
        dark = 'cv_dark'
        add(dark, Image.new('RGBA', (8, 8), (16, 16, 24, 255)), 15)

        def wallface(p0, p1, ylo, yhi, n):
            (xa, za), (xb, zb_) = p0, p1
            if ylo < 16:
                y2 = min(16, yhi)
                M(face).quad([((xa, ylo, za), (0, 16 - ylo)), ((xb, ylo, zb_), (16, 16 - ylo)), ((xb, y2, zb_), (16, 16 - y2)), ((xa, y2, za), (0, 16 - y2))], n)
            if yhi > 16:
                y1 = max(16, ylo)
                M(plain).quad([((xa, y1, za), (0, 8)), ((xb, y1, zb_), (8, 8)), ((xb, yhi, zb_), (8, 0)), ((xa, yhi, za), (0, 0))], n)

        def capquad(a_, b_, z0_, z1_, y=48, n=up):
            M(plain).quad([((a_, y, z1_), (0, 8)), ((b_, y, z1_), (8, 8)), ((b_, y, z0_), (8, 0)), ((a_, y, z0_), (0, 0))], n)
        zb = U(wall_z)
        top = U(wall_z) - 16                     # the cap runs one block back
        north = {x for (x, y) in doors if doors[(x, y)] == 0x64}
        for x in range(x0 - 1, x1 + 1):          # back wall, a block at a time; a doorway is a dark opening
            a_, b_ = U(x), U(x + 1)
            if x0 <= x < x1:
                if x in north:
                    wallface((a_, zb), (b_, zb), 32, 48, fwd)
                    M(dark).quad([((a_, 0, zb - 8), (0, 8)), ((b_, 0, zb - 8), (8, 8)), ((b_, 32, zb - 8), (8, 0)), ((a_, 32, zb - 8), (0, 0))], fwd)
                    wallface((a_, zb - 8), (a_, zb), 0, 32, (1, 0, 0))
                    wallface((b_, zb), (b_, zb - 8), 0, 32, (-1, 0, 0))
                    capquad(a_, b_, zb - 8, zb, 32, (0, -1, 0))
                else:
                    wallface((a_, zb), (b_, zb), 0, 48, fwd)
            capquad(a_, b_, top, zb)
        bottom = last + 1
        for xs, inner, nx in ((x0 - 1, U(x0), 1), (x1, U(x1), -1)):     # side walls; doorways are gaps
            a_, b_ = U(xs), U(xs + 1)
            for yy in range(first, bottom):
                z0_, z1_ = U(wall_z if yy == first else yy), U(yy + 1)
                if (xs, yy) in doors:            # the wall's thickness either side, and a lintel
                    wallface((a_, z0_), (b_, z0_), 0, 48, (0, 0, 1))
                    wallface((b_, z1_), (a_, z1_), 0, 48, (0, 0, -1))
                    capquad(a_, b_, z0_, z1_, 32, (0, -1, 0))
                    wallface((a_, z1_), (b_, z1_), 32, 48, (0, 0, 1))
                    capquad(a_, b_, z0_, z1_)
                    continue
                capquad(a_, b_, z0_, z1_)
                wallface((inner, z1_), (inner, z0_), 0, 48, (nx, 0, 0)) if nx > 0 else wallface((inner, z0_), (inner, z1_), 0, 48, (nx, 0, 0))
        for mt, ex in [(m_, x_) for m_ in wl.get('emblems', []) for x_ in range(W) for y_ in range(first) if mid(x_, y_) == m_]:
            nm = 'cv_%s_m%x' % (tag, mt)     # pictures on the wall (by GBA metatile, at their column)
            add(nm, lay.render_metatile(mt), 15)
            M(nm).quad([((U(ex), 26, zb + 0.5), (0, 16)), ((U(ex + 1), 26, zb + 0.5), (16, 16)), ((U(ex + 1), 42, zb + 0.5), (16, 0)), ((U(ex), 42, zb + 0.5), (0, 0))], fwd)
    elif look:     # the GBA wall rows, stretched to HeartGold's wall height
        full = lay.render()
        strip = full.crop((x0 * 16, 0, x1 * 16, first * 16))
        # (a thing that reaches up into the wall rows is drawn whole on its own card: in the wall strip its top would
        # show twice, so there the wall carries on behind it, copied from the nearest clear column)
        tall = [(px, py, pw) for px, py, pw, ph, _ in look.get('things', []) if py < first * 16]
        covered_x = {X for px, py, pw in tall for X in range(px, px + pw)}
        clear = [X for X in range(x0 * 16, x1 * 16) if X not in covered_x]
        for px, py, pw in tall:
            for X in range(max(px, x0 * 16), min(px + pw, x1 * 16)):
                ref = min(clear, key=lambda c: abs(c - X)) if clear else X
                for Y in range(py, first * 16):
                    strip.putpixel((X - x0 * 16, Y), strip.getpixel((ref - x0 * 16, Y)))
        add(spec['wall'], strip)
        M(spec['wall']).quad([((U(x0), 0, U(wall_z)), (0, first * 16)), ((U(x1), 0, U(wall_z)), ((x1 - x0) * 16, first * 16)),
                              ((U(x1), 48, U(wall_z)), ((x1 - x0) * 16, 0)), ((U(x0), 48, U(wall_z)), (0, 0))], fwd)
    if look:
        covered = set()
        things = list(look.get('things', []))
        for b in gm.get('bg_events', []):        # the gym PCs: HeartGold's Pokemon Center PC
            if look.get('pc_script') and b.get('script') == look['pc_script']:
                extra_props.append((PC_MODEL, U(b['x'] + PC_OFFSET), 0, U(b['y'] + PC_OFFSET)))
                covered.add((b['x'], b['y']))
        if things:
            t, q, wh = cards.shadow_texture('cv_shadow')
            own.append((t, q)); dims['cv_shadow'] = wh; pals.add('cv_shadow_pl')
        for i, (px, py, pw, ph, profile) in enumerate(things):
            im = cards.cut_out(full.crop((px, py, px + pw, py + ph)), floor_im, (px, py))
            name = 'cv_%s_t%d' % (tag, i)
            add(name, im)
            covered |= {(x, y) for x in range(px // 16, (px + pw + 15) // 16) for y in range(py // 16, (py + ph + 15) // 16)}
            box(M(name), px, py, pw, ph, profile)
            # a soft shadow a little wider than its footprint
            depth = sum(n for k, n in profile if k == 'h') or 4
            a_, b_, zf = U(px / 16) - 3, U((px + pw) / 16) + 3, U((py + ph) / 16) + 3
            zb = zf - depth - 8
            M('cv_shadow').quad([((a_, 1, zf), (0, 16)), ((b_, 1, zf), (32, 16)), ((b_, 1, zb), (32, 0)), ((a_, 1, zb), (0, 0))], up)
        bl = look.get('blocks')
        if bl:
            # the room's low inner walls (the GBA gym partitions): every blocked square inside the room that
            # isn't furniture becomes a solid block, a plain top and the GBA partition face on its open sides
            btop, bface = 'cv_%s_btop' % tag, 'cv_%s_bface' % tag
            add(btop, Image.new('RGBA', (8, 8), tuple(bl['top']) + (255,)), 15)
            add(bface, lay.render_metatile(bl['face']), 15)
            hgt = bl.get('height', 24)
            inner = {(x, y) for y in range(first, last + 1) for x in range(x0, x1)
                     if blocked(x, y) and (x, y) not in covered and (x, y) not in doors
                     and mid(x, y) not in FURNITURE.get(tsn(mid(x, y)), {})}
            covered |= inner
            for (x, y) in inner:
                a_, b_, z0_, z1_ = U(x), U(x + 1), U(y), U(y + 1)
                M(btop).quad([((a_, hgt, z1_), (0, 8)), ((b_, hgt, z1_), (8, 8)), ((b_, hgt, z0_), (8, 0)), ((a_, hgt, z0_), (0, 0))], up)
                v = 16 * hgt / 24.0
                for (nx, nz), pts in (((0, 1), [(a_, z1_), (b_, z1_)]), ((0, -1), [(b_, z0_), (a_, z0_)]),
                                      ((1, 0), [(b_, z1_), (b_, z0_)]), ((-1, 0), [(a_, z0_), (a_, z1_)])):
                    if (x + nx, y + nz) in inner or not (x0 <= x + nx < x1) or (y + nz < first): continue
                    (pa, qa), (pb, qb) = pts
                    M(bface).quad([((pa, 0, qa), (0, 16)), ((pb, 0, qb), (16, 16)), ((pb, hgt, qb), (16, 16 - v)), ((pa, hgt, qa), (0, 16 - v))], (nx, 0, nz))
        for y in range(first, H):
            for x in range(W):
                m = mid(x, y)
                if not (x0 <= x < x1) or y > last or (x, y) in doors: continue
                if (x, y) in covered or m == look['floor'] or m in STAIRS_UP.get(tsn(m), {}): continue
                if m in FURNITURE.get(tsn(m), {}) or m in look.get('skip', ()): continue
                if blocked(x, y):
                    near_stairs = any(mid(x - i_, y - j) in STAIRS_UP.get(tsn(mid(x - i_, y - j)), {})
                                      for i_ in (0, 1) for j in (0, 1) if x - i_ >= 0 and y - j >= 0)
                    if not near_stairs:
                        print('  (nothing drawn for blocked square', x, y, hex(m), ')')
                    continue
                name = 'cv_%s_m%x' % (tag, m)
                if name not in dims:
                    add(name, cards.cut_out(lay.render_metatile(m), floor_im), 15)
                # (1 unit up: the model's positions are whole units, so half a unit would sit in the floor)
                M(name).quad([((U(x), 1, U(y + 1)), (0, 16)), ((U(x + 1), 1, U(y + 1)), (16, 16)),
                              ((U(x + 1), 1, U(y)), (16, 0)), ((U(x), 1, U(y)), (0, 0))], up)
    else:
        M(spec['wall']).quad([((U(x0), 0, U(wall_z)), (0, wh)), ((U(x1), 0, U(wall_z)), ((x1 - x0) * ww, wh)),
                              ((U(x1), 48, U(wall_z)), ((x1 - x0) * ww, 0)), ((U(x0), 48, U(wall_z)), (0, 0))], fwd)
    props, perm = list(extra_props), [0x8000] * 1024
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
    for (x, y), b in doors.items():
        perm[y * 32 + x] = b
    if spec.get('floor_flags'):    # (HeartGold's slide tiles only carry you over squares with these flags set)
        perm = [v if v & 0x8000 else v | spec['floor_flags'] for v in perm]
    stands = []
    for (x, y) in fz_close:
        perm[y * 32 + x] = 0x8000
        stands.append((x, y))
    for m, x, yo, z in fz:
        props.append((m, U(x), yo, U(z)))
    for t, ax, ay, bx, by in fz_rugs:
        tw, th = dims[t]
        M(t).quad([((U(ax), 1, U(by)), (0, th)), ((U(bx), 1, U(by)), (tw, th)), ((U(bx), 1, U(ay)), (tw, 0)), ((U(ax), 1, U(ay)), (0, 0))], up)
    for x in fz_wins:
        a, b = U(x + 0.1), U(x + 0.9)
        zz = U(wall_z) + 1
        M('red_h_mado').quad([((a, 17, zz), (0, 16)), ((b, 17, zz), (16, 16)), ((b, 40, zz), (16, 0)), ((a, 40, zz), (0, 0))], fwd)
    if not look:
        gba_art(lay, spec, first, last, x0, x1, wall_z, blocked, mid, tsn, claimed | {(x, y) for x, y in doors}, warp_sq, M, add, dims, U)
    for y in range(H):
        for x in range(W):
            m = mid(x, y)
            fur = FURNITURE.get(tsn(m), {})
            if (x, y) in claimed: continue
            if m in fur:
                name, model, w, h, where, yoff = fur[m]
                if where == 'floorif' and y > 0 and mid(x, y - 1) in (0x2D, 0xAA): continue
                cx = x + w / 2
                if where == 'wall': cz = first + 0.4
                elif where == 'wallhang': cz = wall_z + 0.1
                elif where == 'shelf': cz = y + 0.5 if y >= first else first + 0.4
                else: cz = y + h / 2
                if where == 'wall' or (where == 'shelf' and y < first):
                    # (HeartGold's model stands in the first floor row, where the GBA's stood in the wall rows above:
                    # its squares there are closed, or you could walk into it; the porter moves the GBA's people
                    # and signs off them, room_furniture.json)
                    for dx in range(w):
                        if x + dx < W and (x + dx, first) not in warp_sq:
                            perm[first * 32 + x + dx] = 0x8000
                            stands.append((x + dx, first))
                props.append((model, U(cx), yoff + (MAT_LIFT if name == 'mat' else 0), U(cz)))
            if m in WINDOWS.get(tsn(m), {}):
                w = WINDOWS[tsn(m)][m]          # HeartGold's window picture on the wall
                a, b = U(x + 0.1), U(x + w - 0.1)
                zz = U(wall_z) + 1
                M('red_h_mado').quad([((a, 17, zz), (0, 16)), ((b, 17, zz), (16, 16)), ((b, 40, zz), (16, 0)), ((a, 40, zz), (0, 0))], fwd)
            if m in STAIRS_UP.get(tsn(m), {}):
                props.append((stair_model(x, y, STAIRS_UP[tsn(m)][m]), U(x + 1), 0, U(first + 0.5)))
            if m in STAIRS_DOWN.get(tsn(m), {}):
                props.append((stair_model(x, y, STAIRS_DOWN[tsn(m)][m]), U(x + 1), 0, U(first + 0.5)))
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
    s = STANDS.setdefault(SLOTS[spec['map']], {'first': first, 'squares': []})
    s['squares'] = sorted(set(map(tuple, s['squares'])) | set(stands))
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
    # rooms off HeartGold's own maps: their doors go back to the warp we added there (see build_kanto.py)
    for w, g in zip(ev['warps'], gm.get('warp_events', [])):
        if g['dest_map'] in spec.get('exits', {}):
            w.update(x=g['x'], z=g['y'], y=0, header=spec['exits'][g['dest_map']][0], anchor=spec['exits'][g['dest_map']][1])
    if spec['keep_people']:
        # HeartGold's own people and signs, moved to where the GBA map has its people and signs (in order)
        for obj, g in zip(ev.get('objects', []), gm.get('object_events', [])):
            obj['x'], obj['z'] = g['x'], g['y']
        ev['bgs'] = ev.get('bgs', [])[:len(gm.get('bg_events', []))]
        for bg, g in zip(ev['bgs'], gm.get('bg_events', [])):
            bg['x'], bg['z'] = g['x'], g['y']
    else:
        # (the GBA game's people come over with its scripts; the template's trigger squares run the template's)
        ev['objects'], ev['bgs'], ev['coords'] = [], [], []
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
    sets, sets_btnf = read_narc(open(AREA_BUILD, 'rb').read())
    atex, atex_btnf = read_narc(open(AREA_BUILD_TEX, 'rb').read())
    n_own = 0
    bset = {}               # room -> the building set it uses (its own, for rooms with their own textures)
    variants = []
    for i, spec in enumerate(ROOMS):
        lid = ROOM_LAND_BASE + i
        v = spec.get('variant')
        if v:
            # the room as its map script draws it at first is the room's own land; as it is once the flag is set,
            # a land of its own that the engine shows in its place (canvas_variants.h)
            vlid = ROOM_LAND_BASE + len(ROOMS) + len(variants)
            land += [b''] * max(0, vlid + 1 - len(land))
            vdata, vprops, _, _ = build_room(dict(spec, edits=None), vlid)
            land[vlid] = vdata
            vmat = new_matrix_file(v['tag'], vlid)
            variants.append((SLOTS[spec['map']], v['flag'], vmat))
            spec = dict(spec, edits=hidden_edits(v))
        data, props, gm, own = build_room(spec, lid)
        if v: props = props + vprops
        all_props.append(props)
        land[lid] = data
        slot = SLOTS[spec['map']]
        if slot in ROOM_SLOTS.values():
            if slot.startswith('MAP_CANVAS_'):
                new_map(slot)                       # an id of our own past HeartGold's maps
            mat = new_matrix_file(slot.replace('MAP_', ''), lid)
            evn = write_events(spec, gm)
            t = header(spec['template'])
            fields = {k: v for k, v in t.items() if k not in ('matrixId', 'eventsBank', 'scriptsBank', 'scriptHeaderBank', 'msgBank')}
            fields.update(matrixId=mat, eventsBank=evn, areaDataBank=str(spec['area']))   # (the look we built it in)
            if slot.startswith('MAP_CANVAS_'):
                fields.update(NO_SCRIPTS)
            set_header(slot, fields)
        else:
            if spec.get('no_scripts'):           # (HeartGold's scripts there are for HeartGold's people)
                set_header(slot, dict(NO_SCRIPTS))
            mpath = os.path.join(MATRIX_DIR, matrix_file(slot))
            m = bytearray(open(mpath, 'rb').read())
            nl = m[4]
            # our room is one land: the slot's matrix becomes 1x1 (some HeartGold rooms span two)
            m = bytearray(bytes([1, 1, 0, 0, nl]) + bytes(m[5:5 + nl]) + struct.pack('<H', lid))
            open(mpath, 'wb').write(bytes(m))
            write_events(spec, gm)
        if own:     # a texture set of its own: the base set plus this room's GBA art, and an area entry using it
            k = OUR_SETS_BASE + n_own; n_own += 1
            texsets += [texsets[spec['texset']]] * max(0, k + 1 - len(texsets))
            areas += [areas[spec['area']]] * max(0, k + 1 - len(areas))
            bt, bp = read_tex0(texsets[spec['texset']], tex0_of(texsets[spec['texset']]))
            texsets[k] = write_btx0(bt + [t for t, _ in own], bp + [q for _, q in own])
            # and a building set of its own, so its furniture doesn't land in a HeartGold room's set
            for lst in (sets, atex):
                lst += [lst[spec['buildset']]] * max(0, k + 1 - len(lst))
            sets[k], atex[k] = sets[spec['buildset']], atex[spec['buildset']]
            bset[i] = k
            a = bytearray(areas[spec['area']]); struct.pack_into('<HH', a, 0, k, k); areas[k] = bytes(a)
            set_header(slot, {'areaDataBank': str(k)})
        print(spec['gba'], '-> land', lid, len(props), 'props', '(%d textures of its own)' % len(own) if own else '')
    json.dump(STANDS, open(os.path.join(HERE, 'data', 'room_furniture.json'), 'w'), indent=1, sort_keys=True)
    # each room's building set must list its furniture, and the set's texture file must hold their textures
    used = {}
    for i, spec in enumerate(ROOMS):
        used.setdefault(bset.get(i, spec['buildset']), set()).update(m for m, *_ in all_props[i])
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
    write_variants(variants)
    # fill any gap between the retail lands and ours with a copy of an empty one
    land = [d if d else land[209] for d in land]
    open(LAND_NARC, 'wb').write(write_narc(land, land_btnf))


if __name__ == '__main__':
    main()
