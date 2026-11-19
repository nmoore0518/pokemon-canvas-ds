"""Canvas: the GBA's room furniture as HeartGold's own room models (files/a/1/4/8, bm_room), by patches.

A rule names the metatiles one kind of thing is drawn with in a GBA tileset; every connected patch of them is one
thing (or a row of them), and becomes HeartGold's model for it, sized to the patch: a GBA table three squares by two
is HeartGold's table03_2 (tables come in 1-4 x 1-3 squares), a row of bookcases its bookcase every so many squares,
a row of pot plants its plant over each pot. A patch reaching up into the room's wall rows stands against the back
wall, in the first floor row (as build_rooms' wall furniture; those squares are closed). Kinds:

    ('model', m)           HeartGold model m, at the patch's middle (or against the wall)
    ('each', m)            model m on every square of the patch (chairs, crates)
    ('cols', m, w)         model m every w squares along the patch (bookcases, cabinets), on its bottom row
    ('plant',)             HeartGold's pot plant over each column's lowest square (the pot)
    ('table',)             HeartGold's tables tiling the patch, the biggest first
    ('hang', m)            model m hung on the back wall over the patch's columns (pictures, maps)
    ('rug', texture)       a rug of HeartGold's (its texture) laid over the patch's box
    ('window',)            HeartGold's window picture on the back wall over each column
    ('skip',)              nothing: floor marks and the like, part of the floor

A rule may also carry `need`: the patch is the thing only if it has one of those metatiles (a TV's stand is the
same metatile as some other things' feet). Anything closed in a room that no rule claims is left to the builder
(build_rooms draws the GBA's own art for it, standing up: drawing where HeartGold has nothing).
Nick: real assets wherever HeartGold has them.
"""

# bm_room models
PLANT, TV, SINK, FRIDGE, BED, TOWNMAP, BIN = 23, 19, 20, 21, 17, 15, 22
CHAIR, STOOL, CHAIR_Y, CHAIR_B = 53, 54, 57, 58
SHELF01, SHELF_NARROW, BOOKCASE, BOOKS_NARROW, CABINET_GLASS = 64, 65, 66, 67, 30
CAB_GREEN, CAB_RED = 70, 71
CRATE, CRATE_TALL = 75, 76
DESK_PC, LABBENCH = 24, 25
PICTURE, PAINTING = 60, 139
GLOBE, TERMINAL, TERMINAL_B, MACHINE = 87, 136, 137, 27
SOFA_R, SOFA_L = 102, 103
COUNTER = 41
GLASS_TABLE = 42


def table_model(w, h):
    """HeartGold's table w x h squares (w 1-4, h 1-3): table01_1 (89) .. table03_4 (100)"""
    return 89 + (h - 1) * 4 + (w - 1)


R = lambda *a: set(a)
RULES = {
    # the houses' tileset (metatiles below 0x280, shared by every house)
    'gTileset_BuildingFrlg': [
        ('kitchen', R(0xD8, 0xD9, 0xE0, 0xE1, 0xE8, 0xE9, 0x148, 0x149), ('model', SINK)),
        ('cupboard', R(0xAF, 0xB7, 0xBF), ('model', CAB_RED)),
        ('tv', R(0xAA, 0x35, 0xBA, 0x11A), ('model', TV), R(0xAA)),
        ('desk', R(0xAC, 0xAD, 0xB4, 0xB5, 0xB6, 0x11C, 0x11D), ('model', DESK_PC)),
        ('cabinet', R(0xAB, 0xB3, 0x11B), ('model', CAB_GREEN)),
        ('bookcase', R(0xDD, 0xDE, 0xE5, 0xE6, 0x14D, 0x14E), ('cols', BOOKCASE, 2)),
        ('town map', R(0x170, 0x171, 0x178, 0x179), ('hang', TOWNMAP)),
        ('window', R(0x161, 0x169, 0xB8, 0xC0), ('window',), R(0x161, 0xB8)),
        ('rug', R(0xC3, 0xC4, 0xC5, 0xCB, 0xCD, 0xD3, 0xD4, 0xD5), ('rug', 'red_h_mat1_4')),
        ('rug', R(0x123, 0x124, 0x125, 0x12B, 0x12D, 0x133, 0x134, 0x135), ('rug', 'red_h_mat1_3')),
        ('table', R(0xC8, 0xC9, 0xD0, 0xD1, 0x128, 0x129, 0x130, 0x131, 0x165, 0x166, 0x16D, 0x16E), ('table',)),
        ('chair', R(0xC6, 0xC7, 0x126, 0x127, 0x167, 0x16F, 0x12C), ('each', CHAIR)),
        ('plant', R(0xF5, 0xF6, 0xFD, 0xFE, 0x155, 0x156, 0x15D, 0x15E, 0xCA, 0x132, 0x102, 0x103, 0x12E, 0x136, 0x8C, 0x94), ('plant',)),
        ('mat', R(0xDF, 0xE7, 0xEF, 0x13F, 0x147, 0x14F, 0x12, 0x13, 0x14), ('skip',)),
    ],
    'gTileset_TcgHouse': [
        ('bookcase', R(0x2A4, 0x2A5, 0x2A6), ('model', SHELF_NARROW)),
        ('card table', R(*range(0x298, 0x2A0)), ('table',)),
    ],
    'gTileset_School': [
        ('window', R(0x286), ('window',)),
        ('painting', R(0x2A8, 0x2A9), ('hang', PAINTING)),
        ('cabinet', R(0x29B, 0x29C, 0x2A3, 0x2A4), ('model', CABINET_GLASS)),
        ('desk', R(0x299, 0x29A), ('table',)),
        ('stool', R(0x290), ('each', STOOL)),
        ('plant', R(0x281, 0x289, 0x282, 0x28A), ('plant',)),
    ],
    'gTileset_LeaderAcademyHall': [
        ('bookcase', R(0x286, 0x287, 0x288, 0x289, 0x28A, 0x28B), ('cols', SHELF_NARROW, 1)),
        ('globe', R(0x29B), ('model', GLOBE)),
        ('desk', R(0x29C, 0x29D, 0x298, 0x299, 0x29A), ('table',)),
    ],
    'gTileset_RestaurantHotel': [
        ('window', R(0x282), ('window',)),
        ('counter', R(0x2AA, 0x2AB, 0x2AC), ('cols', COUNTER, 2)),
        ('sofa', R(0x2B0, 0x2B8, 0x2C0), ('model', SOFA_R)),
        ('armchair', R(0x29F), ('each', CHAIR_B)),
        ('table', R(0x292, 0x293, 0x29A, 0x29B), ('table',)),
        ('plant', R(0x281, 0x289), ('plant',)),
    ],
    'gTileset_FanClubDaycare': [
        ('sofa', R(0x2C0, 0x2C8), ('model', SOFA_L)),
        ('sofa', R(0x2C1, 0x2C9), ('model', SOFA_R)),
        ('table', R(0x29D, 0x29E, 0x29F, 0x2A5, 0x2A6, 0x2A7), ('table',)),
        ('bookcase', R(0x2A0, 0x2A1, 0x2A8, 0x2A9), ('cols', BOOKCASE, 2)),
        ('shelves', R(0x2B2, 0x2B4, 0x2BC), ('cols', SHELF01, 2)),
        ('rug', R(0x29A, 0x29B, 0x29C, 0x2B5, 0x2B6, 0x2AA, 0x2AB, 0x2AC), ('rug', 'red_h_mat1_4')),
    ],
    'gTileset_MedicalCenter': [
        ('bed', R(0x280, 0x281), ('cols', BED, 1)),
        ('counter', R(0x29A, 0x29B, 0x29C, 0x29D, 0x29E), ('cols', COUNTER, 2)),
        ('chair', R(0x2CE), ('each', CHAIR_Y)),
        ('chair', R(0x2CF), ('each', CHAIR_B)),
        ('cabinet', R(0x292, 0x293, 0x294, 0x295), ('model', CABINET_GLASS)),
        ('plant', R(0x2A3, 0x2A4), ('plant',)),
        ('monitor', R(0x284, 0x285), ('model', MACHINE)),
    ],
    'gTileset_Lab_Frlg': [
        ('plant', R(0x2BF, 0x2C7, 0x294, 0x29C), ('plant',)),
        ('glass table', R(0x2C8, 0x2C9, 0x2D0, 0x2D1), ('model', GLASS_TABLE)),
        ('chair', R(0x2CA, 0x2D2, 0x2CB, 0x2F8, 0x2F3), ('each', CHAIR)),
        ('table', R(0x2E0, 0x2E1, 0x2E2, 0x2E8, 0x2E9, 0x2EA, 0x2F0, 0x2F1, 0x2F2), ('table',)),
        ('sofa', R(0x2DE, 0x2E6), ('model', SOFA_R)),
        ('sofa', R(0x2E3, 0x2EB), ('model', SOFA_L)),
        ('cabinet', R(0x301, 0x302, 0x309, 0x30A), ('cols', CABINET_GLASS, 2)),
        ('rug', R(0x2EC, 0x2ED, 0x2EE, 0x2F4, 0x2F5, 0x2F6, 0x2F7, 0x2EF), ('rug', 'o_kido_mat1')),
    ],
    'gTileset_Mart': [
        ('counter', R(0x2A8, 0x2A9, 0x2AA, 0x2B0, 0x2B1, 0x2B2, 0x2A5, 0x2AD), ('model', 43)),
        ('rack', R(0x296, 0x297, 0x29E, 0x29F, 0x2A6, 0x2A7, 0x2AE, 0x2AF), ('cols', 47, 1)),
        ('wall shelves', R(0x29A, 0x29B, 0x29C, 0x2A2, 0x2A3, 0x2A4), ('cols', 45, 2)),
        ('case', R(0x2C1, 0x2C2), ('model', 44)),
    ],
    'gTileset_ExoticSafari': [
        ('plant', R(0x28F, 0x297), ('plant',)),
    ],
    'gTileset_SafariZoneBuilding': [
        ('plant', R(0x28E, 0x296, 0x2B2, 0x2BF, 0x2B7), ('plant',)),
        ('bookcase', R(0x2B0, 0x2B1, 0x2B8, 0x2B9), ('cols', CABINET_GLASS, 2)),
        ('table', R(0x2CC, 0x2CD, 0x2CE, 0x2CF), ('table',)),
        ('cushion', R(0x291), ('each', STOOL)),
    ],
}
# (the Lab's primary metatiles, under the houses' set: bookcases)
RULES['gTileset_BuildingFrlg'].append(('bookcase', R(0x73, 0x74, 0x7B, 0x7C), ('cols', BOOKCASE, 2)))


def patches(lay, tsn, rules=RULES, skip=(), full=False):
    """[(name, kind, squares)] for every patch of a rule's metatiles (one rule per patch); full: [(rule, squares)]"""
    W, H = lay.w, lay.h
    taken = set(skip)
    out = []
    for y in range(H):
        for x in range(W):
            if (x, y) in taken: continue
            m = lay.metatile(x, y)
            for rule in rules.get(tsn(m), ()):
                name, mts, kind = rule[:3]
                if m not in mts: continue
                comp, st = {(x, y)}, [(x, y)]
                while st:
                    c = st.pop()
                    for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                        n = (c[0] + dx, c[1] + dy)
                        if 0 <= n[0] < W and 0 <= n[1] < H and n not in comp and n not in taken and lay.metatile(*n) in mts \
                                and tsn(lay.metatile(*n)) == tsn(m):
                            comp.add(n); st.append(n)
                if len(rule) > 3 and rule[3] and not any(lay.metatile(*c) in rule[3] for c in comp):
                    continue
                taken |= comp
                out.append((rule, comp) if full else (name, kind, comp))
                break
    return out


def place(kind, comp, first, closed):
    """a patch -> (props [(model, cx, cz, y off)] in squares, squares to close, rugs [(tex, x0, y0, x1, y1)],
    windows [x]). first: the room's first floor row (rows above it are wall); closed(x, y): the GBA's collision"""
    xs = [c[0] for c in comp]; ys = [c[1] for c in comp]
    x0, x1, y0, y1 = min(xs), max(xs) + 1, min(ys), max(ys) + 1
    floor_rows = [y for y in range(y0, y1) if y >= first]
    props, close, rugs, wins = [], [], [], []
    wall = y0 < first
    k = kind[0]
    if k == 'skip': return props, close, rugs, wins
    if k == 'window':
        return props, close, rugs, sorted({x for x, y in comp if y < first})
    if k == 'rug':
        return props, close, [(kind[1], x0, max(y0, first), x1, y1)], wins
    if k == 'hang':
        return [(kind[1], (x0 + x1) / 2, first - 0.4, 16)], close, rugs, wins
    if k == 'plant':
        for x in sorted(set(xs)):
            yb = max(y for cx, y in comp if cx == x)
            if yb < first: yb = first        # (a plant in the wall rows: stood in front of the wall)
            props.append((PLANT, x + 0.5, yb + 0.5, 0))
            if wall: close.append((x, yb))
        return props, close, rugs, wins
    if k == 'each':
        for x, y in sorted(comp):
            if y < first: continue
            props.append((kind[1], x + 0.5, y + 0.5, 0))
        return props, close, rugs, wins
    if k == 'table':
        rows = [y for y in floor_rows if closed is None or any(closed(x, y) for x in range(x0, x1))] or floor_rows or [first]
        ya, yb = rows[0], rows[-1] + 1
        y = ya
        while y < yb:
            h = min(3, yb - y)
            x = x0
            while x < x1:
                w = min(4, x1 - x)
                props.append((table_model(w, h), x + w / 2, y + h / 2, 0))
                x += w
            y += h
        return props, close, rugs, wins
    if k in ('model', 'cols'):
        step = kind[2] if k == 'cols' else x1 - x0
        n = max(1, round((x1 - x0) / step))
        cz = first + 0.4 if wall else (floor_rows[0] + floor_rows[-1] + 1) / 2
        for i in range(n):
            cx = x0 + (x1 - x0) * (i + 0.5) / n
            props.append((kind[1], cx, cz, 0))
        if wall:
            close += [(x, first) for x in range(x0, x1)]
        return props, close, rugs, wins
    raise ValueError(kind)


# the big interiors laid from the kit (interior_kit.py, looks with kit furnish=True): (name, metatiles, kind, need,
# up), up = how many of the patch's top rows are the GBA's wall (a terminal against it, a picture on it)
KIT = {
    'gTileset_SSAnne': [
        ('galley counter', R(0x2D0, 0x2D1, 0x2D2, 0x2D3, 0x2D4, 0x2D8, 0x2D9, 0x2DA, 0x2DB), ('table',), None, 0),
        ('bin', R(0x28A), ('each', BIN), None, 0),
        ('bookcase', R(0x2FA, 0x302), ('model', BOOKS_NARROW), R(0x302), 1),
        ('painting', R(0x2F3, 0x2F4), ('hang', PAINTING), None, 1),
        ('chair', R(0x303), ('each', CHAIR_Y), None, 0),
    ],
    'gTileset_PokemonMansion': [
        ('table', R(0x310, 0x311, 0x312, 0x318, 0x319, 0x31A, 0x320, 0x321, 0x322, 0x375, 0x376, 0x377), ('table',), None, 0),
        ('plant', R(0x30B, 0x313), ('plant',), None, 0),
        ('statue', R(0x314, 0x31C), ('model', 78), R(0x31C), 0),
    ],
    'gTileset_SilphCo': [
        ('plant', R(0x34D, 0x34E, 0x355, 0x356), ('plant',), None, 0),
        ('terminal', R(0x37D, 0x385, 0x386, 0x37E), ('cols', TERMINAL, 1), R(0x37E), 2),
        ('cabinet', R(0x38A, 0x38B, 0x38C, 0x38D, 0x38E, 0x38F), ('cols', CABINET_GLASS, 2), R(0x38E, 0x38F), 2),
        ('picture', R(0x365), ('hang', PICTURE), None, 1),
        ('painting', R(0x35E, 0x35F, 0x366, 0x367), ('hang', PAINTING), None, 2),
        ('meeting table', R(0x2B8, 0x2B9, 0x2BA, 0x2BB, 0x2B0, 0x2C3, 0x2C4, 0x380, 0x381, 0x382, 0x397, 0x398), ('table',), None, 0),
        ('stool', R(0x312), ('each', STOOL), None, 0),
        ('crates', R(0x99, 0x392, 0x395, 0x318, 0x394, 0x310, 0x311, 0x393), ('each', CRATE), None, 0),
        ('table', R(0x343, 0x344, 0x34B, 0x34C), ('table',), None, 0),
        ('bed', R(0x39A, 0x39B, 0x3A2, 0x3A3, 0x3A4), ('cols', BED, 1), None, 0),
    ],
}
