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
    # (buildings: build_ship_floor draws them. The Tower's area is our own, 120 (OWN_AREAS): the Sprout Tower's textures
    # (set 77) with room models, which its own area, a dungeon's, does not take. stretch: the texture spans two squares, as HeartGold lays these;
    # slab: a lone closed square is a stone standing up - a gravestone - not a low block)
    'tower': dict(area=120, texset=77, ship=True, floor='d15_yuka01', wall='d17_wall01', cap='d15_wall01a', side='d17_wall01', low='d17_ita',
                  lowside='d17_wall01', mat='d15_yuka03', stairs=(7, 8, 9, 10), stretch=True, slab=True, wall_top=32),
    'plant': dict(area=44, ship=True, floor='kn_c_yuka2', wall='kn_c_kabe1', cap='mpwr_r04', side='kn_c_kabe1', low='counter_g02',
                  lowside='kn_c_kabe1', mat='kn_c_stair', stairs=(168, 169, 171, 170), stretch=True, wall_top=32),
    'ship': dict(area=42, ship=True),         # the S.S. Anne: SHIP below
    'house': dict(area=42, ship=True, plain=('r39_kabe', 'fs_room8', 'maq_pt13'), floor='mo_yuka', wall='r39_kabe', cap='fs_room8', side='maq_pt13',
                  low='table01', lowside='re_ki', mat='d_mat01', stairs=(7, 8, 9, 10), wall_top=40),
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
# plain columns (a list of the squares whose blocks make one: build_rooms.widen) and a plain row for the cabins
CABIN1 = dict(cols=[(2, 2, [(0, 0), (0, 1), (1, 2), (1, 3), (1, 3), (1, 3), (1, 3), (1, 3)])], rows=[(3, 1)])
CABIN2 = dict(cols=[(3, 2, [(0, 0), (0, 1), (1, 5), (1, 5), (1, 5), (1, 5), (1, 5), (1, 5), (0, 8)])], rows=[(5, 1)])
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
     # (the bow is small on the GBA: six columns and two rows of planks more)
     dict(gba='SSAnne_Deck_Frlg', map='MAP_CANVAS_SSANNE_DECK', look='ship', template=SS, depth=-4,
          widen=dict(cols=[(9, 3), (11, 3)], rows=[(10, 2)])),
     dict(gba='SSAnne_Kitchen_Frlg', map='MAP_CANVAS_SSANNE_KITCHEN', look='ship', template=SS, depth=-1),
     dict(gba='SSAnne_CaptainsOffice_Frlg', map='MAP_CANVAS_SSANNE_CAPTAIN', look='ship', template=SS, depth=-2.5)] +
    # (the cabins are 6 squares wide on the GBA, with up to four people in them: two plain columns and a row more)
    [dict(gba='SSAnne_%s_Room%d_Frlg' % (f, i), map='MAP_CANVAS_SSANNE_%s_R%d' % (f, i), look='ship', template=SS,
          widen=CABIN1 if f == '1F' else CABIN2,
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


# ---------------------------------------------------------------- the S.S. Anne: the GBA's layout in HeartGold's ship look
# Textures of HeartGold's S.S. Aqua and the rooms that share its set (42): plank floors, cabin carpets, the cabins'
# wallpaper, its doors and portholes; furniture is HeartGold's room models (the set's own: bed, table, chair, plant).
WALL_TOP = 40             # a ship wall's height
SHIP = dict(area=42, ship=True, plain=('re_kabe', 'fs_room8', 'maq_pt13', 'maq_rs11', 'maq_pt07'), wall_top=WALL_TOP, floor='sn_h_yuka1', carpet={'1F': 'maq_rs03', '2F': 'maq_rs13', 'B1F': 'maq_rs07'}, wall='re_kabe', paper='maq_rs08',
            base='maq_pt13', line='maq_rs11', cap='fs_room8', side='maq_pt13', low='table01', lowside='re_ki', steel='maq_rm09',
            door=('maq_pt01', 16, 0, 16, 32), porthole=('maq_pt01', 0, 0, 16, 16), mat='d_mat01', sea='maq_pt07', stairs=(7, 8, 9, 10), rail='maq_pt02', furniture=True)
# GBA things -> HeartGold room models: top-left metatile -> (model, width, height in squares, squares the model is
# moved by). The squares are closed whatever the GBA says (a bed's walkable half), like the wall furniture of rooms.
SHIP_FURNITURE = {
    0x338: (94, 2, 3, (0, 0)), 0x342: (94, 3, 2, (0, 0)), 0x305: (94, 3, 2, (0, 0)),     # tables, the captain's desk
    0x329: (17, 2, 2, (0, 0)), 0x309: (17, 2, 2, (0, 0)),                                  # beds
    0x328: (53, 1, 2, (0, 0.5)), 0x308: (53, 1, 2, (0, 0.5)),                              # chairs
    0x32B: (23, 1, 2, (0, 0.5)), 0x30B: (23, 1, 2, (0, 0.5)),                              # plants
}
SHIP_PORTHOLES = {0x282, 0x33A, 0x33B}    # GBA wall metatiles with a porthole
# HeartGold's staircases, `stairs` in a look: (up rising right, up rising left, down to the left, down to the right);
# each one's box about where it is placed (x0, x1, z0, z1 in units), and how far down the square's row it stands
STAIR_BOX = {7: (-17, 16, -12, 18, 0.75), 8: (-16, 17, -12, 18, 0.75), 9: (-13, 15, -12, 18, 0.75), 10: (-15, 13, -12, 18, 0.75),
             168: (-16, 16, -16, 16, 1), 169: (-16, 16, -16, 16, 1), 170: (-16, 16, -16, 16, 1), 171: (-16, 16, -16, 16, 1)}
USED_MODELS = {}          # area -> the room models its maps place (ship_models lists them in the area's building set)
OWN_AREAS = {120: (77, 40)}   # an area of ours: (the area whose textures it has, the area whose room-model set it starts from)


def ship_parts(spec):
    """-> the GBA map (widened), its layout, and what each square is"""
    gm = gba_map.map_json(spec['gba'])
    lay = gba_map.Layout(gm['layout'])
    if spec.get('widen'):
        from build_rooms import widen
        gm = widen(gm, lay, **spec['widen'])
    W, H = lay.w, lay.h
    mids = set(lay.metatile(x, y) for y in range(H) for x in range(W))
    void = {m for m in mids if not any(px[:3] != (0, 0, 0) for px in lay.render_metatile(m).convert('RGB').getdata())}
    inb = lambda x, y: 0 <= x < W and 0 <= y < H
    warps = {(w['x'], w['y']): w for w in gm.get('warp_events', [])}
    isvoid = lambda x, y: not inb(x, y) or lay.metatile(x, y) in void
    free = lambda x, y: inb(x, y) and not isvoid(x, y) and lay.collision(x, y) == 0
    # (the GBA leaves squares open outside its rooms, in the borders: floor is what you can get to from a door)
    # (and from where people stand: a room behind a door that a script opens is floor too)
    people = {(o['x'], o['y']) for o in gm.get('object_events', [])}
    reach = set(warps) | {s for s in people if free(*s)}
    todo = list(reach)
    while todo:
        x, y = todo.pop()
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            n = (x + dx, y + dy)
            if n not in reach and free(*n): reach.add(n); todo.append(n)
    open_ = lambda x, y: (x, y) in reach and free(x, y) and (x, y) not in warps
    # a door in a wall: a warp square with wall either side of it and floor in front
    door = lambda x, y: (x, y) in warps and open_(x, y + 1) and not open_(x - 1, y) and not open_(x + 1, y) and not open_(x, y - 1)
    walk = lambda x, y: open_(x, y) or (x, y) in warps
    wallish = lambda x, y: inb(x, y) and ((not walk(x, y) and not isvoid(x, y)) or door(x, y))
    # the walls: above a floor square, a run of wall squares with nothing (black) beyond it; and the squares of
    # those rows either side (above a bed or a table that stands against the wall, and the wall's corners)
    band = {}                 # square -> (the floor row it stands behind, rows up from the floor)
    for y in range(H):
        for x in range(W):
            if not open_(x, y) or not wallish(x, y - 1): continue
            n_ = 1
            while wallish(x, y - n_ - 1): n_ += 1
            if not isvoid(x, y - n_ - 1): continue          # (a counter or a block between two floors: not a wall)
            if n_ > 3: continue                             # (something stands against the wall here: its wall comes from the columns beside it)
            for k in range(1, n_ + 1):
                band[(x, y - k)] = (y, k - 1)
    todo = list(band)
    while todo:
        x, y = todo.pop()
        for dx in (-1, 1):
            if (wallish(x + dx, y) or (x + dx, y) in warps) and (x + dx, y) not in band:
                band[(x + dx, y)] = band[(x, y)]; todo.append((x + dx, y))
    # things on the floor: small patches of closed squares that are no wall
    things, seen = set(), set()
    for y in range(H):
        for x in range(W):
            if (x, y) in seen or not wallish(x, y) or (x, y) in band: continue
            comp, stack = [], [(x, y)]
            seen.add((x, y))
            while stack:
                c = stack.pop(); comp.append(c)
                for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                    n = (c[0] + dx, c[1] + dy)
                    if n not in seen and wallish(*n) and n not in band: seen.add(n); stack.append(n)
            # (a wall has the dark beyond it somewhere; a thing stands clear of it)
            edge = any(inb(c[0] + dx, c[1] + dy) and isvoid(c[0] + dx, c[1] + dy) for c in comp for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)))
            if len(comp) <= 12 and not edge: things |= set(comp)
    return dict(gm=gm, lay=lay, W=W, H=H, warps=warps, people=people, isvoid=isvoid, open=open_, door=door, walk=walk, wallish=wallish,
                band=band, things=things)


def build_ship_floor(spec, depth_of):
    """A floor of the S.S. Anne: the GBA's layout, square for square, in HeartGold's ship look. Walkable squares are
    floor (planks; carpet in the cabins); the wall above each stretch of floor stands at its far edge, white with
    a blue foot and a yellow line (the cabins' papered), with HeartGold's door where the GBA has one and its
    porthole where the GBA has one; the walls at the sides and the near edge are a low kerb, so they hide nothing;
    the GBA's furniture is HeartGold's (SHIP_FURNITURE), or a low block."""
    P = ship_parts(spec)
    gm, lay, W, H, warps, band, things = P['gm'], P['lay'], P['W'], P['H'], P['warps'], P['band'], P['things']
    walk, door, wallish, isvoid = P['walk'], P['door'], P['wallish'], P['isvoid']
    SHIP = globals()['SHIP'] if spec['look'] == 'ship' else LOOKS[spec['look']]      # (the look's textures)
    WALL_TOP = SHIP['wall_top']
    plain = set(SHIP.get('plain', ()))            # textures used for their colour: one texel of them
    dims, pals = texdims(SHIP.get('texset', SHIP['area']))
    pal_of = lambda t_: next(p for p in (t_ + '_pl', t_) if p in pals)
    room = spec['look'] == 'ship' and 'Room' in spec['gba']
    floor_tex = SHIP['carpet'][spec['gba'].split('_')[1]] if room else SHIP['floor']
    wall_tex = SHIP['paper'] if room else SHIP['wall']
    low_tex = SHIP['steel'] if 'Kitchen' in spec['gba'] else SHIP['low']
    stones = {c for c in things if SHIP.get('slab') and not any((c[0] + dx, c[1] + dy) in things for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)))}
    # furniture of HeartGold's
    props, closed = [], set()
    for y in range(H):
        for x in range(W):
            f = SHIP_FURNITURE.get(lay.metatile(x, y)) if SHIP.get('furniture') else None
            if not f: continue
            model, w, h, (mx, mz) = f
            props.append((model, x + w / 2 + mx, y + h / 2 + mz))
            if model != 53:      # (a chair is sat on; and nobody the GBA stands somewhere is shut in)
                closed |= {(x + i, y + j) for i in range(w) for j in range(h)} - P['people']
    # stairs to another floor: HeartGold's staircase, where the GBA draws its own: on the two closed squares beside
    # the square that takes you there (and the two in front of those), climbing or going down away from it; stairs
    # down are a well in the floor
    under, hole_sq, holes = set(), set(), []
    for (x, y), w in warps.items():
        if not (w['dest_map'] in depth_of and w['dest_map'] != gm['id'] and not door(x, y) and depth_of[w['dest_map']] != spec['depth']): continue
        up_ = depth_of[w['dest_map']] < spec['depth']
        left = not walk(x - 1, y) and walk(x + 1, y)          # (the closed side: left, else right)
        ur, ul, dl, dr = SHIP['stairs']
        model = (ul if left else ur) if up_ else (dl if left else dr)
        cx = x - 1 if left else x + 2
        bx0, bx1, bz0, bz1, dz = STAIR_BOX[model]
        cz = y + dz
        props.append((model, cx, cz))
        block = {(cx - 1, y), (cx, y), (cx - 1, y + 1), (cx, y + 1)}
        closed |= {s for s in block if s not in warps}
        if up_: under |= block
        else:
            hole_sq |= block
            holes.append(((cx - 1) * 16, y * 16, (cx + 1) * 16, (y + 2) * 16, cx * 16 + bx0, cz * 16 + bz0, cx * 16 + bx1, cz * 16 + bz1))
    USED_MODELS.setdefault(SHIP['area'], set()).update(m for m, *_ in props)
    floor = lambda x, y: ((walk(x, y) and (x, y) not in band) or (x, y) in things or (x, y) in closed or (x, y) in under) and (x, y) not in hole_sq
    kind = {}
    for (x, y), w in warps.items():
        dest = w['dest_map']
        if dest in depth_of and dest != gm['id'] and not door(x, y) and depth_of[dest] != spec['depth']:
            kind[(x, y)] = 0x3C if depth_of[dest] < spec['depth'] else 0x3E      # (stairs to another deck)
        elif not walk(x, y + 1) and walk(x, y - 1):
            kind[(x, y)] = 0x65             # (a way out at the foot of the wall: walk on into it)
        else:
            kind[(x, y)] = 0x3E
    # out on deck, what is closed and not beside the planks is the sea
    deck = spec['look'] == 'ship' and 'Deck' in spec['gba']
    by_floor = lambda x, y: any(floor(x + dx, y + dy) for dx in (-1, 0, 1) for dy in (-1, 0, 1))
    nx, nz = math.ceil(W / 32), math.ceil(H / 32)
    lands = []
    U = lambda v, o: (v - o) * 16 - 256
    up, fwd = (0, 1, 0), (0, 0, 1)
    for lz in range(nz):
        for lx in range(nx):
            meshes = {}
            M = lambda t_: meshes.setdefault(t_, Mesh())
            ox, oz = lx * 32, lz * 32
            X0, X1, Z0, Z1 = ox, min(ox + 32, W), oz, min(oz + 32, H)
            perm = [0x8000] * 1024
            globals_plain = plain

            def top(tex, x, k, y, h, plain=False):
                """a flat face over squares x..x+k of row y at height h"""
                tw, th = dims[tex]
                f = tw / 32 if SHIP.get('stretch') else 1
                s0, s1, t0, t1 = (1, 2, 1, 2) if plain or tex in globals_plain else (x * 16 * f, (x + k) * 16 * f, y * 16 * f, (y + 1) * 16 * f)
                M(tex).quad([((U(x, ox), h, U(y + 1, oz)), (s0, t1)), ((U(x + k, ox), h, U(y + 1, oz)), (s1, t1)),
                             ((U(x + k, ox), h, U(y, oz)), (s1, t0)), ((U(x, ox), h, U(y, oz)), (s0, t0))], up)

            def face(tex, a, b, y0, y1, n, uv=None):
                """an upright face from point a to b (x, z in land units), y0 up to y1"""
                if uv is None and tex not in globals_plain:      # (a textured wall: along it by its length, its height over the face)
                    tw, th = dims[tex]
                    d0 = (a[0] + a[1]) * tw / 32; d1 = d0 + (abs(b[0] - a[0]) + abs(b[1] - a[1])) * tw / 32
                    uv = (d0, 0, d1, th * (y1 - y0) / WALL_TOP)
                s0, t0, s1, t1 = uv or (1, 1, 2, 2)
                M(tex).quad([((a[0], y0, a[1]), (s0, t1)), ((b[0], y0, b[1]), (s1, t1)), ((b[0], y1, b[1]), (s1, t0)), ((a[0], y1, a[1]), (s0, t0))], n)

            def runs(cells):
                """squares of a row -> (x, length) runs"""
                out = []
                for x in sorted(cells):
                    if out and out[-1][0] + out[-1][1] == x: out[-1][1] += 1
                    else: out.append([x, 1])
                return out
            height = lambda x, y: None if (x, y) in hole_sq else 0 if floor(x, y) and (x, y) not in things else 0 if (x, y) in stones else 10 if (x, y) in things and (x, y) not in closed else \
                0 if (x, y) in closed else None if (x, y) in band or isvoid(x, y) or not wallish(x, y) else \
                -4 if deck and not by_floor(x, y) else 1 if deck else 6
            for y in range(Z0, Z1):
                for x in range(X0, X1):
                    if walk(x, y) and (x, y) not in closed: perm[(y - oz) * 32 + (x - ox)] = kind.get((x, y), 0)
                row = lambda pred: runs([x for x in range(X0, X1) if pred(x, y)])
                for x, k in row(floor): top(floor_tex, x, k, y, 0)
                for x, k in row(lambda x, y: height(x, y) == 10): top(low_tex, x, k, y, 10)
                for x, k in row(lambda x, y: height(x, y) == 6): top(SHIP['cap'], x, k, y, 6)
                for x, k in row(lambda x, y: height(x, y) == -4): top(SHIP['sea'], x, k, y, -4, plain=True)
                for x, k in row(lambda x, y: kind.get((x, y)) == 0x65): top(SHIP['mat'], x, k, y, 1)
                for x, k in row(lambda x, y: height(x, y) == 1): top(SHIP['cap'], x, k, y, 0)       # (the deck's edge, under its rail)
                if deck:        # a rail along every edge of the planks (HeartGold's ship ladder on its side: two bars and posts)
                    for x in range(X0, X1):
                        if not floor(x, y) or (x, y) in warps: continue
                        for n in ((0, 1), (0, -1), (1, 0), (-1, 0)):
                            if floor(x + n[0], y + n[1]) or (x + n[0], y + n[1]) in warps: continue
                            if n[0] == 0:
                                zz = U(y + (1 if n[1] > 0 else 0), oz); a, b = (U(x, ox), zz), (U(x + 1, ox), zz)
                            else:
                                xx = U(x + (1 if n[0] > 0 else 0), ox); a, b = (xx, U(y + 1, oz)), (xx, U(y, oz))
                            for p0, p1, nn in ((a, b, (n[0], 0, n[1])), (b, a, (-n[0], 0, -n[1]))):
                                M(SHIP['rail']).quad([((p0[0], 0, p0[1]), (0, 0)), ((p1[0], 0, p1[1]), (0, 32)), ((p1[0], 11, p1[1]), (22, 32)), ((p0[0], 11, p0[1]), (22, 0))], nn)
                for x in range(X0, X1):              # a stone standing on its square
                    if (x, y) not in stones: continue
                    a0, a1, b0, b1 = U(x, ox) + 3, U(x + 1, ox) - 3, U(y, oz) + 5, U(y + 1, oz) - 4
                    M(SHIP['low']).quad([((a0, 16, b1), (0, 8)), ((a1, 16, b1), (8, 8)), ((a1, 16, b0), (8, 0)), ((a0, 16, b0), (0, 0))], up)
                    for a, b, n in (((a0, b1), (a1, b1), (0, 0, 1)), ((a1, b1), (a1, b0), (1, 0, 0)), ((a0, b0), (a0, b1), (-1, 0, 0))):
                        M(SHIP['low']).quad([((a[0], 0, a[1]), (0, 16)), ((b[0], 0, b[1]), (10, 16)), ((b[0], 16, b[1]), (10, 0)), ((a[0], 16, a[1]), (0, 0))], n)
                # the sides of blocks and kerbs
                for hh, tex in ((10, SHIP['lowside']), (6, SHIP['side'])):
                    for n in ((0, 1), (0, -1), (1, 0), (-1, 0)):
                        for x in range(X0, X1):
                            if height(x, y) != hh: continue
                            hn = height(x + n[0], y + n[1])
                            if hn is None or hn >= hh: continue
                            if n[0] == 0:
                                zz = U(y + (1 if n[1] > 0 else 0), oz); a, b = (U(x, ox), zz), (U(x + 1, ox), zz)
                                if n[1] < 0: a, b = b, a
                            else:
                                xx = U(x + (1 if n[0] > 0 else 0), ox); a, b = (xx, U(y + 1, oz)), (xx, U(y, oz))
                                if n[0] < 0: a, b = b, a
                            face(tex, a, b, hn, hh, (n[0], 0, n[1]))
                # the wall behind this row of floor
                cols = sorted(x for x in range(X0, X1) if any(band.get((x, y - k)) == (y, k - 1) for k in (1, 2, 3)))
                z = U(y, oz)
                for x, k in runs(cols):
                    a, b = (U(x, ox), z), (U(x + k, ox), z)
                    if 'base' in SHIP:
                        face(SHIP['base'], a, b, 0, 6, fwd)
                        face(SHIP['line'], a, b, 6, 8, fwd)
                        if wall_tex == SHIP['paper']: face(wall_tex, a, b, 8, WALL_TOP, fwd, (x * 16, 8 - (WALL_TOP - 8), (x + k) * 16, 8))
                        else: face(wall_tex, a, b, 8, WALL_TOP, fwd)
                    else: face(wall_tex, a, b, 0, WALL_TOP, fwd)
                    M(SHIP['cap']).quad([((a[0], WALL_TOP, z), (1, 2)), ((b[0], WALL_TOP, z), (1 + (k * 8 if SHIP['cap'] not in plain else 1), 2)), ((b[0], WALL_TOP, z - 8), (1 + (k * 8 if SHIP['cap'] not in plain else 1), 1)), ((a[0], WALL_TOP, z - 8), (1, 1))], up)
                for x in cols:
                    sq = [(x, y - k) for k in (1, 2, 3) if band.get((x, y - k)) == (y, k - 1)]
                    if 'door' not in SHIP: continue
                    if any(door(*s) for s in sq):
                        tex, s, t_, w, h = SHIP['door']
                        face(tex, (U(x, ox), z + 2), (U(x + 1, ox), z + 2), 0, 32, fwd, (s, t_, s + w, t_ + h))
                    elif any(lay.metatile(*s) in SHIP_PORTHOLES for s in sq):
                        tex, s, t_, w, h = SHIP['porthole']
                        face(tex, (U(x, ox), z + 2), (U(x + 1, ox), z + 2), 14, 30, fwd, (s, t_, s + w, t_ + h))
            # round a staircase going down, the floor up to its well
            for hx0, hz0, hx1, hz1, rx0, rz0, rx1, rz1 in holes:
                if not (X0 * 16 <= hx0 < X1 * 16 and Z0 * 16 <= hz0 < Z1 * 16): continue
                L = lambda ax, az: (ax - ox * 16 - 256, az - oz * 16 - 256)
                for sx0, sz0, sx1, sz1 in ((hx0, hz0, hx1, rz0), (hx0, rz1, hx1, hz1), (hx0, rz0, rx0, rz1), (rx1, rz0, hx1, rz1)):
                    if sx1 - sx0 < 0.5 or sz1 - sz0 < 0.5: continue
                    (a0, b0), (a1, b1) = L(sx0, sz0), L(sx1, sz1)
                    M(floor_tex).quad([((a0, 0, b1), (sx0, sz1)), ((a1, 0, b1), (sx1, sz1)), ((a1, 0, b0), (sx1, sz0)), ((a0, 0, b0), (sx0, sz0))], up)
            if not meshes:
                top(SHIP['cap'], X0, 1, Z0, -1)
            groups = [(t_, t_, pal_of(t_), mesh, {'repeat': 3, 'size': dims[t_]}) for t_, mesh in meshes.items()]
            model = build_model('cv_in_%d' % (len(lands) + 10 * (spec['depth'] + 20)), groups)
            model += b'\0' * (-len(model) % 4)
            f4 = lambda v: int(round(v * 4096))
            bld = b''.join(struct.pack('<I3i3i3i8x', m, f4(U(x, ox)), 0, f4(U(z_, oz)), 0, 0, 0, 4096, 4096, 4096)
                           for m, x, z_ in props if X0 <= x < X1 and Z0 <= z_ < Z1)
            bdhc = struct.pack('<4s6H', b'BDHC', 2, 1, 1, 1, 1, 1) + struct.pack('<2i2i', -256 * 4096, -256 * 4096, 256 * 4096, 256 * 4096) + \
                struct.pack('<3i', 0, 4096, 0) + struct.pack('<i', 0) + struct.pack('<4H', 0, 1, 0, 0) + struct.pack('<iHH', 256 * 4096, 1, 0) + struct.pack('<H', 0)
            p = struct.pack('<1024H', *perm)
            lands.append(struct.pack('<4I2H', len(p), len(bld), len(model), len(bdhc), 0x1234, 0) + p + bld + model + bdhc)
            assert len(model) < 60000, ('model too big for a land', spec['gba'], len(lands), len(model))
    return gm, (nx, nz), lands


def build_floor(spec, depth_of):
    if LOOKS[spec['look']].get('ship'): return build_ship_floor(spec, depth_of)
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


def ship_models():
    """each area's building set must list the room models its maps place, and its texture file hold theirs"""
    import build_rooms as R
    from nitro import read_tex0, tex0_of, write_btx0, u16
    sets, sets_btnf = read_narc(open(R.AREA_BUILD, 'rb').read())
    atex, atex_btnf = read_narc(open(R.AREA_BUILD_TEX, 'rb').read())
    areas, _ = read_narc(open(R.AREA_DATA, 'rb').read())
    areas_btnf = _
    bm, _ = read_narc(open(R.BM_ROOM, 'rb').read())
    for area, (tex_area, model_area) in OWN_AREAS.items():
        for lst in (areas, sets, atex): lst += [lst[model_area]] * max(0, area + 1 - len(lst))
        src = u16(areas[model_area], 0)
        sets[area], atex[area] = sets[src], atex[src]
        areas[area] = struct.pack('<HH', area, u16(areas[tex_area], 2)) + areas[model_area][4:]
    open(R.AREA_DATA, 'wb').write(write_narc(areas, areas_btnf))
    for area, models in USED_MODELS.items():
        buildset = u16(areas[area], 0)
        ids = list(struct.unpack_from('<%dH' % u16(sets[buildset], 0), sets[buildset], 2))
        ids += sorted(m for m in models if m not in ids)
        sets[buildset] = struct.pack('<H%dH' % len(ids), len(ids), *ids)
        texs, pals = read_tex0(atex[buildset], tex0_of(atex[buildset]))
        have_t, have_p = {t[0] for t in texs}, {q[0] for q in pals}
        for mid in ids:
            t0 = tex0_of(bm[mid])
            if t0 is None: continue
            mt, mp = read_tex0(bm[mid], t0)
            texs += [t for t in mt if t[0] not in have_t]; have_t |= {t[0] for t in mt}
            pals += [q for q in mp if q[0] not in have_p]; have_p |= {q[0] for q in mp}
        atex[buildset] = write_btx0(texs, pals)
    open(R.AREA_BUILD, 'wb').write(write_narc(sets, sets_btnf))
    open(R.AREA_BUILD_TEX, 'wb').write(write_narc(atex, atex_btnf))


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
    ship_models()
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
