"""Canvas: bring a GBA map's people, signs, text and scripts over to its HeartGold map.

    python3 tools/canvas/port/port_map.py PalletTown_Frlg [more maps...]

For each map (see MAPS): its scripts become the HeartGold map's script file (scr_seq_*.s, replacing HeartGold's),
its map scripts the header script (*_hdr.s), its text the map's message bank (msg_*.json), and its people and
signs the map's events (objects and bgs). Scripts from elsewhere that it uses (Common_*, std scripts...) are
copied in. Commands we can't translate yet are left as `// TODO(gba)` comments and listed in the report; a
person whose script still has one says so in game instead of running it half-done.

Flags and vars: the GBA game's own get ids of their own (tools/canvas/data/canvas_ids.json), which hg-engine
keeps in our part of the save: flags 0x2000+, vars 0x5000+ (engine/src/canvas_flags.c). Temp flags/vars and the
special vars map onto HeartGold's.
"""
import json, os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.dirname(HERE))
import gba as G
import specials as SP
import trainers as TR
RIVAL_STAGES, RIVAL_TEAMS = TR.rival_stages(), TR.rival_team_ids()
TRAINER_IDS, SIMPLE_TRAINERS = TR.trainer_ids(), TR.simple_trainers()
import slots
import build_cinnabar as _CN     # (Cinnabar is widened: its squares move with it)

ROOT = slots.ROOT
SCR = os.path.join(ROOT, 'files/fielddata/script/scr_seq')
MSG = os.path.join(ROOT, 'files/msgdata/msg')
IDS = os.path.join(os.path.dirname(HERE), 'data', 'canvas_ids.json')
REPORT = os.path.join(ROOT, 'build', 'canvas_port_report.txt')

# ---------------------------------------------------------------- where each GBA map's things go
PALLET_OX, PALLET_CELL = 27, (31, 11)


def pallet_xy(x, y, kind='pos'):
    if (x, y) == (16, 28): x, y = 25, 27          # (the sign we moved off the gym's other sign)
    return 32 * PALLET_CELL[0] + PALLET_OX + x, 32 * PALLET_CELL[1] + y


same = lambda x, y, kind='pos': (x, y)       # rooms we built from the GBA layouts keep its squares


class Anchored:
    """For maps that keep HeartGold's own layout (Viridian, Route 1...): GBA squares go by the offsets of nearby
    landmarks (doors, exits) seen in both games, weighted by distance; then people and trigger squares move to the
    nearest open square, and signs to the nearest of HeartGold's own signs."""

    def __init__(self, slot, pairs, fixed=None, extra=None):
        self.slot, self.pairs, self.used = slot, pairs, set()
        self.fixed = fixed or {}           # GBA square -> HeartGold square, by hand (trigger lines across a road...)
        self.extra = extra or []           # (GBA trigger square, another HeartGold square for it): wider roads
        self.indoor = 'EVERYWHERE' not in slots.header(slot)['matrixId']
        self.hg_signs = self.hg_trees = self.hg_trainers = self.hg_items = None
        self.last_spot = None
        self.warps = ()                    # (HeartGold's doors: nobody stands in or right before one)

    def offset(self, x, y):
        tw = tx = ty = 0.0
        for (gx, gy), (hx, hz) in self.pairs:
            d2 = (gx - x) ** 2 + (gy - y) ** 2
            if d2 == 0: return hx - gx, hz - gy
            w = 1.0 / d2
            tw += w; tx += w * (hx - gx); ty += w * (hz - gy)
        return round(tx / tw), round(ty / tw)

    def perm(self, x, z):
        import world
        return world.perm_in(self.slot, x, z) if self.indoor else world.perm(x, z)

    def open(self, x, z):
        v = self.perm(x, z)
        ok = v is not None and not v & 0x8000 and (v & 0xFF) not in (0x10, 0x11, 0x13, 0x15, 0x62, 0x63, 0x64, 0x65, 0x69, 0x6E)
        if ok and self.indoor and self.warps:
            return (x, z) in self.inside()
        return ok

    def wet(self, x, z):
        """water a swimmer can be in"""
        v = self.perm(x, z)
        return v is not None and not v & 0x8000 and (v & 0xFF) in (0x10, 0x11, 0x15)

    def inside(self):
        """a room's floor: the squares you can walk to from its doors (the land around a room reads as open too)"""
        if getattr(self, '_inside', None) is None:
            from collections import deque
            seen, q = set(), deque()
            for w in self.warps:
                for dx, dz in ((0, 0), (0, -1), (0, 1), (-1, 0), (1, 0)):
                    c = (w[0] + dx, w[1] + dz)
                    v = self.perm(*c)
                    if v is not None and not v & 0x8000 and c not in seen: seen.add(c); q.append(c)
            while q:
                c = q.popleft()
                for dx, dz in ((0, -1), (0, 1), (-1, 0), (1, 0)):
                    n = (c[0] + dx, c[1] + dz)
                    v = self.perm(*n)
                    if n not in seen and v is not None and not v & 0x8000 and 0 <= n[0] < 64 and 0 <= n[1] < 64:
                        seen.add(n); q.append(n)
            self._inside = seen
        return self._inside

    def __call__(self, x, y, kind='pos'):
        if (x, y) in self.fixed and kind != 'raw': return self.fixed[(x, y)]
        dx, dy = self.offset(x, y)
        X, Z = x + dx, y + dy
        if kind == 'raw': return X, Z
        # (a cuttable tree, a trainer or an item ball goes where HeartGold has one: trees block paths, trainers'
        # sight lines and items' spots are laid out for HeartGold's map; spots left over stay empty)
        spots = {'tree': self.hg_trees, 'trainer': self.hg_trainers, 'item': self.hg_items}.get(kind)
        if spots:
            best = min(spots, key=lambda b: (b[0] - X) ** 2 + (b[1] - Z) ** 2)
            spots.remove(best); self.used.add(best[:2]); self.last_spot = best
            return best[0], best[1]
        if kind == 'tree' and spots is not None: return None       # (no tree of HeartGold's left: a tree elsewhere could close a road)
        if kind in ('trainer', 'item', 'tree'): kind = 'object'
        if kind == 'sign':
            if self.hg_signs:
                X, Z = min(self.hg_signs, key=lambda b: (b[0] - X) ** 2 + (b[1] - Z) ** 2)
                self.hg_signs.remove((X, Z))
            return X, Z
        if kind in ('object', 'trigger'):
            for r in range(0, 12):
                ring = [(X + i, Z + j) for i in range(-r, r + 1) for j in range(-r, r + 1) if max(abs(i), abs(j)) == r]
                for c in sorted(ring, key=lambda c: (c[0] - X) ** 2 + (c[1] - Z) ** 2):
                    near_door = kind == 'object' and any(abs(c[0] - w[0]) + abs(c[1] - w[1]) <= 1 for w in self.warps)
                    if (self.wet(*c) if getattr(self, 'want_water', False) else self.open(*c)) and not near_door \
                            and (kind == 'trigger' or c not in self.used):
                        if kind == 'object': self.used.add(c)
                        return c
        return X, Z


class Auto(Anchored):
    """An Anchored map whose landmarks are worked out (auto_anchor.py): doors to the same rooms and exits to the same
    maps in both games, plus any pairs given. Outdoors, people stay on their own map's part of the world."""

    def __init__(self, slot, pairs=(), gba=None, **kw):
        super().__init__(slot, list(pairs), **kw)
        self.given, self.gba, self._auto = list(pairs), gba, None

    def offset(self, x, y):
        if self._auto is None:
            import auto_anchor
            gdir = self.gba or next(d for d, v in MAPS.items() if v[1] is self)
            self._auto = auto_anchor.pairs(self.slot, gdir, DEST, PRIMARIES)
            self.pairs = self.given + self._auto
            if not self.pairs: self.pairs = [((0, 0), (0, 0))]
        return super().offset(x, y)

    def open(self, x, z):
        if not self.indoor:
            import auto_anchor
            if auto_anchor.header_at(x, z) not in self._own(): return False
        return super().open(x, z)

    def _own(self):
        import auto_anchor
        if getattr(self, '_ownids', None) is None:
            ids = auto_anchor.map_ids()
            self._ownids = {ids[self.slot]} | {ids[s] for s in getattr(self, 'also', ())}
        return self._ownids


def on_map(T, slot):
    """for a GBA map split over HeartGold maps: the squares T puts on slot's part of the world"""
    def f(x, y):
        import auto_anchor
        return auto_anchor.header_at(*T(x, y, 'raw')) == auto_anchor.map_ids()[slot]
    return f


def center(slot):
    """a Kanto Pokemon Center (HeartGold's are all one layout; the GBA's floor beside the counter is its floor in front)"""
    return Anchored(slot, [((7, 8), (8, 19)), ((7, 2), (8, 11)), ((1, 2), (2, 13)), ((13, 2), (14, 13)),
                           ((1, 7), (2, 18)), ((13, 7), (14, 18))], fixed={(7, 2): (8, 11)})


def mart(slot):
    return Anchored(slot, [((4, 7), (4, 11)), ((2, 3), (2, 6)), ((9, 5), (10, 4))], fixed={(2, 3): (2, 6)})


# HeartGold's Viridian (doors and exits, GBA square -> HeartGold square)
VIRIDIAN = Anchored('MAP_VIRIDIAN', [((36, 10), (1045, 239)), ((25, 11), (1034, 244)), ((25, 18), (1036, 253)),
                                     ((36, 19), (1042, 253)), ((26, 26), (1032, 262)), ((35, 26), (1041, 262)),
                                     ((0, 17), (996, 258)), ((21, 0), (1030, 216)), ((24, 39), (1036, 280))])
# HeartGold's Route 1 is longer than the GBA's (64 squares to 40): its corners and middle anchor the stretch
ROUTE1 = Anchored('MAP_ROUTE_1', [((12, 0), (1036, 289)), ((12, 39), (1039, 351)), ((1, 1), (1028, 291)), ((22, 1), (1050, 291)),
                                  ((1, 20), (1027, 320)), ((22, 20), (1050, 320)), ((1, 38), (1027, 349)), ((22, 38), (1050, 349))])
ROUTE2_SOUTH = Anchored('MAP_ROUTE_2', [((5, 51), (1034, 192)), ((6, 51), (1035, 192)), ((18, 46), (1050, 192)),
                                        ((9, 79), (1030, 215)), ((18, 41), (1050, 178))])
ROUTE2_NORTH = Anchored('MAP_ROUTE_2_EAST', [((5, 13), (1028, 138)), ((17, 11), (1048, 137)), ((17, 22), (1047, 155)),
                                            ((18, 41), (1050, 178))])
VIRIDIAN_FOREST = Anchored('MAP_VIRIDIAN_FOREST', [((29, 62), (32, 77)), ((5, 9), (12, 15))])
# (the rival waits where the road from Viridian narrows: HeartGold's is four squares wide there, the GBA's three)
ROUTE22 = Anchored('MAP_ROUTE_22', [((8, 5), (936, 266)), ((9, 5), (936, 267)), ((47, 7), (995, 258)), ((47, 12), (995, 263))],
                   fixed={(33, 4): (974, 265), (33, 5): (974, 266), (33, 6): (974, 267)}, extra=[((33, 6), (974, 268))])
VIRIDIAN_MART = Anchored('MAP_VIRIDIAN_POKEMART', [((4, 7), (4, 11)), ((2, 3), (2, 6)), ((9, 5), (10, 4))], fixed={(2, 3): (2, 6)})
# Pewter: HeartGold's town is laid out differently (its Gym is reached from the north road). The guide who stops
# you at the east road before Brock, and the aide with the Running Shoes after, stand at its narrowest point
# (four squares wide); their walks are HeartGold's own paths (PEWTER_MOVES).
PEWTER = Anchored('MAP_PEWTER', [((17, 6), (1048, 78)), ((15, 16), (1047, 92)), ((28, 18), (1060, 97)), ((33, 11), (1068, 87)),
                                 ((17, 25), (1048, 106)), ((9, 30), (1037, 111)), ((22, 39), (1041, 121)), ((23, 39), (1042, 121)),
                                 ((47, 21), (1089, 103))],
                  fixed={(42, 20): (1075, 101), (42, 21): (1076, 102), (42, 22): (1076, 103), (42, 23): (1076, 104),
                         (43, 23): (1076, 105), (46, 20): (1077, 101), (46, 21): (1077, 102), (46, 22): (1077, 103),
                         (46, 23): (1077, 104), (33, 17): (1068, 98)},
                  extra=[((46, 23), (1077, 105)), ((46, 23), (1077, 106))])
# (the GBA's Route 3 climbs north to Route 4 and Mt. Moon; HeartGold's ends at Mt. Moon's door)
ROUTE3 = Anchored('MAP_ROUTE_3', [((0, 9), (1084, 103)), ((0, 11), (1084, 105)), ((72, 0), (1172, 104)), ((40, 10), (1128, 110))])
ROUTE3_CENTER = Anchored('MAP_ROUTE_3_POKECENTER_1F', [((7, 8), (8, 19)), ((7, 2), (8, 11)), ((1, 2), (2, 13)), ((13, 2), (14, 13)),
                                                         ((1, 7), (2, 18)), ((13, 7), (14, 18))], fixed={(7, 2): (8, 11)})
# (the GBA's Route 4 starts west of Mt. Moon, by its Pokemon Center: HeartGold's Route 3 has those; this is the
# part east of Mt. Moon, from its exit to Cerulean)
ROUTE4 = Anchored('MAP_ROUTE_4', [((32, 6), (1195, 113)), ((107, 3), (1269, 107)), ((107, 17), (1269, 119)), ((60, 10), (1230, 113))])
# Cerulean: HeartGold's town has seven buildings to the GBA's ten (the GBA's House4/5 aren't built yet). The rival
# waits where the road north narrows to the bridge (six squares wide: the side lanes take the nearer trigger).
CERULEAN = Anchored('MAP_CERULEAN', [((22, 19), (1309, 131)), ((31, 21), (1318, 134)), ((29, 28), (1308, 144)), ((13, 28), (1298, 144)),
                                     ((15, 17), (1304, 131)), ((10, 11), (1305, 116)), ((30, 11), (1319, 123)), ((1, 12), (1290, 107)),
                                     ((23, 0), (1324, 97)), ((0, 19), (1280, 120)), ((47, 18), (1339, 107)), ((24, 39), (1303, 151))],
                    fixed={(22, 6): (1323, 102), (23, 6): (1324, 102), (24, 6): (1325, 102),
                           (22, 0): (1323, 97), (23, 0): (1324, 97), (24, 0): (1325, 97)},
                    extra=[((22, 6), (1322, 102)), ((24, 6), (1326, 102)), ((24, 6), (1327, 102))])
CERULEAN_GYM = Anchored('MAP_CERULEAN_GYM', [((8, 18), (10, 25)), ((8, 6), (10, 1))])
CERULEAN_MART = Anchored('MAP_CERULEAN_POKEMART', [((4, 7), (4, 11)), ((2, 3), (2, 6)), ((9, 5), (10, 4))], fixed={(2, 3): (2, 6)})
CERULEAN_CENTER = Anchored('MAP_CERULEAN_POKECENTER_1F', [((7, 8), (8, 19)), ((7, 2), (8, 11)), ((1, 2), (2, 13)), ((13, 2), (14, 13)),
                                                         ((1, 7), (2, 18)), ((13, 7), (14, 18))], fixed={(7, 2): (8, 11)})
CERULEAN_HOUSE1 = Anchored('MAP_CERULEAN_NORTH_HOUSE', [((3, 9), (4, 8))])
CERULEAN_HOUSE2 = Anchored('MAP_CERULEAN_EAST_HOUSE', [((3, 7), (4, 8))])
CERULEAN_HOUSE3 = Anchored('MAP_CERULEAN_WEST_HOUSE', [((4, 7), (4, 8))])
CERULEAN_BIKE_SHOP = Anchored('MAP_CERULEAN_BIKE_MANIAC_HOUSE', [((5, 9), (6, 11))])
# Nugget Bridge: HeartGold's is four squares wide to the GBA's three
ROUTE24 = Anchored('MAP_ROUTE_24', [((11, 39), (1334, 95)), ((11, 11), (1334, 54)), ((5, 7), (1320, 46)), ((23, 8), (1330, 47))],
                   fixed={(10, 15): (1334, 58), (11, 15): (1335, 58)}, extra=[((10, 15), (1333, 58)), ((11, 15), (1336, 58))])
ROUTE25 = Anchored('MAP_ROUTE_25', [((0, 7), (1330, 47)), ((51, 4), (1407, 38)), ((24, 8), (1362, 46)), ((41, 8), (1385, 46))])
SEA_COTTAGE = Anchored('MAP_ROUTE_25_SEA_COTTAGE', [((7, 9), (7, 11)), ((7, 5), (7, 7))])
PEWTER_GYM = Anchored('MAP_PEWTER_GYM', [((6, 14), (7, 27)), ((6, 5), (7, 4))])
PALLET_MART = Anchored('MAP_FIGHT_AREA_UNUSED_3', [((4, 7), (4, 11)), ((2, 3), (2, 6)), ((9, 5), (10, 4))], fixed={(2, 3): (2, 6)})
PEWTER_MART = Anchored('MAP_PEWTER_POKEMART', [((4, 7), (4, 11)), ((2, 3), (2, 6)), ((9, 5), (10, 4))], fixed={(2, 3): (2, 6)})
# (HeartGold's Center is deeper: the GBA's floor beside the counter is its floor in front of it)
PEWTER_CENTER = Anchored('MAP_PEWTER_POKECENTER_1F', [((7, 8), (8, 19)), ((7, 2), (8, 11)), ((1, 2), (2, 13)), ((13, 2), (14, 13)),
                                                      ((1, 7), (2, 18)), ((13, 7), (14, 18))], fixed={(7, 2): (8, 11)})
# (the GBA museum's two floors share HeartGold's one; its ticket counter is HeartGold's turnstile)
PEWTER_MUSEUM = Anchored('MAP_PEWTER_MUSEUM_OF_SCIENCE', [((14, 9), (10, 19)), ((13, 5), (10, 15)), ((4, 5), (6, 8)), ((26, 5), (25, 8))],
                         fixed={(12, 5): None, (13, 5): None, (14, 5): (10, 16), (16, 5): (12, 15)})
PEWTER_HOUSE_NE = Anchored('MAP_PEWTER_NORTHEAST_HOUSE', [((4, 7), (4, 8))])
PEWTER_HOUSE_SW = Anchored('MAP_PEWTER_SOUTHWEST_HOUSE', [((4, 7), (4, 8))])
ROUTE2_HOUSE = Anchored('MAP_ROUTE_2_HOUSE', [((4, 7), (4, 8))])
FOREST_GATE_N = Anchored('MAP_ROUTE_2_VIRIDIAN_FOREST_NORTH_GATEHOUSE', [((7, 10), (5, 12)), ((7, 1), (5, 2))])
FOREST_GATE_S = Anchored('MAP_ROUTE_2_VIRIDIAN_FOREST_SOUTH_GATEHOUSE', [((7, 10), (5, 12)), ((7, 1), (5, 2))])

# ---------------------------------------------------------------- the rest of Kanto: landmarks worked out (Auto)
ROUTE10 = Auto('MAP_ROUTE_10', gba='Route10_Frlg'); ROUTE10.also = ('MAP_ROUTE_10_SOUTH',)
ROUTE16 = Auto('MAP_ROUTE_16', gba='Route16_Frlg'); ROUTE16.also = ('MAP_ROUTE_16_EAST',)

MAPS = {   # GBA map dir: (HeartGold map slot, square transform)
    'PalletTown_Frlg': ('MAP_PALLET', pallet_xy),
    'PalletTown_PlayersHouse_1F_Frlg': ('MAP_PALLET_TOWN_REDS_HOUSE_1F', None),     # (widened: room_xy below)
    'PalletTown_PlayersHouse_2F_Frlg': ('MAP_PALLET_TOWN_REDS_HOUSE_2F', same),
    'PalletTown_PlayersHouse_B1F_Frlg': ('MAP_FIGHT_AREA_UNUSED_6', same),
    'PalletTown_RivalsHouse_Frlg': ('MAP_PALLET_TOWN_BLUES_HOUSE_1F', same),
    'PalletTown_House1_Frlg': ('MAP_PALLET_TOWN_BLUES_HOUSE_2F', same),
    'PalletTown_House2_Frlg': ('MAP_FIGHT_AREA_UNUSED_1', same),
    'PalletTown_ProfessorOaksLab_Frlg': ('MAP_PALLET_TOWN_OAKS_LAB', same),
    'PalletTown_Gym_Frlg': ('MAP_FIGHT_AREA_UNUSED_7', same),
    'PalletTown_Gym_BackRoom': ('MAP_FIGHT_AREA_UNUSED_8', same),
    'PalletTown_Gym_LeftRoom': ('MAP_FIGHT_AREA_UNUSED_9', same),
    'PalletTown_Gym_RightRoom': ('MAP_BATTLE_PARK_UNUSED_1', same),
    'ViridianCity_Frlg': ('MAP_VIRIDIAN', VIRIDIAN),
    'Route1_Frlg': ('MAP_ROUTE_1', ROUTE1),
    'Route2_Frlg': ('MAP_ROUTE_2', ROUTE2_SOUTH, lambda x, y: y >= 40),         # (HeartGold splits Route 2 in two)
    'Route2_Frlg#north': ('MAP_ROUTE_2_EAST', ROUTE2_NORTH, lambda x, y: y < 40),
    'ViridianForest_Frlg': ('MAP_VIRIDIAN_FOREST', VIRIDIAN_FOREST),
    'Route22_Frlg': ('MAP_ROUTE_22', ROUTE22),
    'ViridianCity_Mart_Frlg': ('MAP_VIRIDIAN_POKEMART', VIRIDIAN_MART),
    'PalletTown_Mart_Frlg': ('MAP_FIGHT_AREA_UNUSED_3', PALLET_MART),     # (our copy of HeartGold's Viridian Mart)
    'ViridianCity_PennysHouse_Frlg': ('MAP_CANVAS_VIRIDIAN_PENNYS_HOUSE', None),      # (a bigger room: build_rooms.py)
    'CeruleanCity_House4_Frlg': ('MAP_CANVAS_CERULEAN_HOUSE4', None),
    'CeruleanCity_House5_Frlg': ('MAP_CANVAS_CERULEAN_HOUSE5', None),
    'FuchsiaCity_House2_Frlg': ('MAP_CANVAS_FUCHSIA_HOUSE2', None),
    'FuchsiaCity_House3_Frlg': ('MAP_CANVAS_FUCHSIA_HOUSE3', None),
    'PewterCity_PainterLoft_Frlg': ('MAP_CANVAS_PEWTER_PAINTER_LOFT', None),
    'Route19_UnusedHouse_Frlg': ('MAP_CANVAS_ROUTE19_HOUSE', None),
    'SaffronCity_House_Frlg': ('MAP_CANVAS_SAFFRON_HOUSE', None),
    'SaffronCity_TcgHouse_Frlg': ('MAP_CANVAS_SAFFRON_TCG_HOUSE', None),
    'CeladonCity_House1_Frlg': ('MAP_CANVAS_CELADON_HOUSE1', None),
    'PewterCity_Frlg': ('MAP_PEWTER', PEWTER),
    'PewterCity_Gym_Frlg': ('MAP_PEWTER_GYM', PEWTER_GYM),
    'Route3_Frlg': ('MAP_ROUTE_3', ROUTE3),
    'CeruleanCity_Frlg': ('MAP_CERULEAN', CERULEAN),
    'CeruleanCity_Gym_Frlg': ('MAP_CERULEAN_GYM', CERULEAN_GYM),
    'CeruleanCity_Mart_Frlg': ('MAP_CERULEAN_POKEMART', CERULEAN_MART),
    'CeruleanCity_PokemonCenter_1F_Frlg': ('MAP_CERULEAN_POKECENTER_1F', CERULEAN_CENTER),
    'CeruleanCity_House1_Frlg': ('MAP_CERULEAN_NORTH_HOUSE', CERULEAN_HOUSE1),
    'CeruleanCity_House2_Frlg': ('MAP_CERULEAN_EAST_HOUSE', CERULEAN_HOUSE2),
    'CeruleanCity_House3_Frlg': ('MAP_CERULEAN_WEST_HOUSE', CERULEAN_HOUSE3),
    'CeruleanCity_BikeShop_Frlg': ('MAP_CERULEAN_BIKE_MANIAC_HOUSE', CERULEAN_BIKE_SHOP),
    'Route24_Frlg': ('MAP_ROUTE_24', ROUTE24),
    'Route25_Frlg': ('MAP_ROUTE_25', ROUTE25),
    'Route25_SeaCottage_Frlg': ('MAP_ROUTE_25_SEA_COTTAGE', SEA_COTTAGE),
    'MtMoon_1F_Frlg': ('MAP_CANVAS_MT_MOON_1F', same),
    'MtMoon_B1F_Frlg': ('MAP_CANVAS_MT_MOON_B1F', same),
    'MtMoon_B2F_Frlg': ('MAP_CANVAS_MT_MOON_B2F', same),
    'RockTunnel_1F_Frlg': ('MAP_CANVAS_ROCK_TUNNEL_1F', same),
    'RockTunnel_B1F_Frlg': ('MAP_CANVAS_ROCK_TUNNEL_B1F', same),
    'DiglettsCave_NorthEntrance_Frlg': ('MAP_CANVAS_DIGLETTS_CAVE_N', same),
    'DiglettsCave_B1F_Frlg': ('MAP_CANVAS_DIGLETTS_CAVE_B1F', same),
    'DiglettsCave_SouthEntrance_Frlg': ('MAP_CANVAS_DIGLETTS_CAVE_S', same),
    'VictoryRoad_1F_Frlg': ('MAP_CANVAS_VICTORY_ROAD_1F', same),
    'VictoryRoad_2F_Frlg': ('MAP_CANVAS_VICTORY_ROAD_2F', same),
    'VictoryRoad_3F_Frlg': ('MAP_CANVAS_VICTORY_ROAD_3F', same),
    'CeruleanCave_1F_Frlg': ('MAP_CANVAS_CERULEAN_CAVE_1F', same),
    'CeruleanCave_2F_Frlg': ('MAP_CANVAS_CERULEAN_CAVE_2F', same),
    'CeruleanCave_B1F_Frlg': ('MAP_CANVAS_CERULEAN_CAVE_B1F', same),
    'SeafoamIslands_1F_Frlg': ('MAP_CANVAS_SEAFOAM_1F', same),
    'SeafoamIslands_B1F_Frlg': ('MAP_CANVAS_SEAFOAM_B1F', same),
    'SeafoamIslands_B2F_Frlg': ('MAP_CANVAS_SEAFOAM_B2F', same),
    'SeafoamIslands_B3F_Frlg': ('MAP_CANVAS_SEAFOAM_B3F', same),
    'SeafoamIslands_B4F_Frlg': ('MAP_CANVAS_SEAFOAM_B4F', same),
    'Route4_Frlg': ('MAP_ROUTE_4', ROUTE4, lambda x, y: x >= 30),
    'Route4_PokemonCenter_1F_Frlg': ('MAP_ROUTE_3_POKECENTER_1F', ROUTE3_CENTER),
    'PewterCity_Mart_Frlg': ('MAP_PEWTER_POKEMART', PEWTER_MART),
    'PewterCity_PokemonCenter_1F_Frlg': ('MAP_PEWTER_POKECENTER_1F', PEWTER_CENTER),
    'PewterCity_Museum_1F_Frlg': ('MAP_PEWTER_MUSEUM_OF_SCIENCE', PEWTER_MUSEUM),
    'PewterCity_House1_Frlg': ('MAP_PEWTER_NORTHEAST_HOUSE', PEWTER_HOUSE_NE),
    'PewterCity_House2_Frlg': ('MAP_PEWTER_SOUTHWEST_HOUSE', PEWTER_HOUSE_SW),
    'Route2_House_Frlg': ('MAP_ROUTE_2_HOUSE', ROUTE2_HOUSE),
    'Route2_ViridianForest_NorthEntrance_Frlg': ('MAP_ROUTE_2_VIRIDIAN_FOREST_NORTH_GATEHOUSE', FOREST_GATE_N),
    'Route2_ViridianForest_SouthEntrance_Frlg': ('MAP_ROUTE_2_VIRIDIAN_FOREST_SOUTH_GATEHOUSE', FOREST_GATE_S),
    'VermilionCity_Frlg': ('MAP_VERMILION', Auto('MAP_VERMILION')),
    'LavenderTown_Frlg': ('MAP_LAVENDER', Auto('MAP_LAVENDER')),
    'CeladonCity_Frlg': ('MAP_CELADON', Auto('MAP_CELADON')),
    'SaffronCity_Frlg': ('MAP_SAFFRON', Auto('MAP_SAFFRON')),
    'FuchsiaCity_Frlg': ('MAP_FUCHSIA', Auto('MAP_FUCHSIA')),
    'CinnabarIsland_Frlg': ('MAP_CINNABAR_ISLAND', lambda x, y, kind='pos': _CN.to_world(x, y)),   # (our town, widened: build_cinnabar.py)
    'IndigoPlateau_Exterior_Frlg': ('MAP_INDIGO_PLATEAU', Auto('MAP_INDIGO_PLATEAU')),
    'Route5_Frlg': ('MAP_ROUTE_5', Auto('MAP_ROUTE_5')),
    'Route6_Frlg': ('MAP_ROUTE_6', Auto('MAP_ROUTE_6')),
    'Route7_Frlg': ('MAP_ROUTE_7', Auto('MAP_ROUTE_7')),
    'Route8_Frlg': ('MAP_ROUTE_8', Auto('MAP_ROUTE_8')),
    'Route9_Frlg': ('MAP_ROUTE_9', Auto('MAP_ROUTE_9')),
    'Route11_Frlg': ('MAP_ROUTE_11', Auto('MAP_ROUTE_11')),
    'Route12_Frlg': ('MAP_ROUTE_12', Auto('MAP_ROUTE_12')),
    'Route13_Frlg': ('MAP_ROUTE_13', Auto('MAP_ROUTE_13')),
    'Route14_Frlg': ('MAP_ROUTE_14', Auto('MAP_ROUTE_14')),
    'Route15_Frlg': ('MAP_ROUTE_15', Auto('MAP_ROUTE_15')),
    'Route17_Frlg': ('MAP_ROUTE_17', Auto('MAP_ROUTE_17')),
    'Route18_Frlg': ('MAP_ROUTE_18', Auto('MAP_ROUTE_18')),
    'Route19_Frlg': ('MAP_ROUTE_19', Auto('MAP_ROUTE_19')),
    'Route20_Frlg': ('MAP_ROUTE_20', Auto('MAP_ROUTE_20')),
    'Route10_Frlg': ('MAP_ROUTE_10', ROUTE10, lambda x, y: not on_map(ROUTE10, 'MAP_ROUTE_10_SOUTH')(x, y)),
    'Route10_Frlg#south': ('MAP_ROUTE_10_SOUTH', ROUTE10, on_map(ROUTE10, 'MAP_ROUTE_10_SOUTH')),
    'Route16_Frlg': ('MAP_ROUTE_16', ROUTE16, lambda x, y: not on_map(ROUTE16, 'MAP_ROUTE_16_EAST')(x, y)),
    'Route16_Frlg#east': ('MAP_ROUTE_16_EAST', ROUTE16, on_map(ROUTE16, 'MAP_ROUTE_16_EAST')),
    # (HeartGold's Route 21 is one map for the GBA's North and South: the two stretched over its 64 rows)
    'Route21_North_Frlg+Route21_South_Frlg': ('MAP_ROUTE_21', Anchored('MAP_ROUTE_21', [((0, 0), (1028, 416)), ((23, 0), (1051, 416)),
                                                                                    ((0, 99), (1028, 479)), ((23, 99), (1051, 479))])),
    'VermilionCity_PokemonCenter_1F_Frlg': ('MAP_VERMILION_POKECENTER_1F', center('MAP_VERMILION_POKECENTER_1F')),
    'VermilionCity_Mart_Frlg': ('MAP_VERMILION_POKEMART', mart('MAP_VERMILION_POKEMART')),
    'LavenderTown_PokemonCenter_1F_Frlg': ('MAP_LAVENDER_POKECENTER_1F', center('MAP_LAVENDER_POKECENTER_1F')),
    'LavenderTown_Mart_Frlg': ('MAP_LAVENDER_POKEMART', mart('MAP_LAVENDER_POKEMART')),
    'CeladonCity_PokemonCenter_1F_Frlg': ('MAP_CELADON_POKECENTER_1F', center('MAP_CELADON_POKECENTER_1F')),
    'SaffronCity_PokemonCenter_1F_Frlg': ('MAP_SAFFRON_POKECENTER_1F', center('MAP_SAFFRON_POKECENTER_1F')),
    'SaffronCity_Mart_Frlg': ('MAP_SAFFRON_POKEMART', mart('MAP_SAFFRON_POKEMART')),
    'FuchsiaCity_PokemonCenter_1F_Frlg': ('MAP_FUCHSIA_POKECENTER_1F', center('MAP_FUCHSIA_POKECENTER_1F')),
    'FuchsiaCity_Mart_Frlg': ('MAP_FUCHSIA_POKEMART', mart('MAP_FUCHSIA_POKEMART')),
    'CinnabarIsland_PokemonCenter_1F_Frlg': ('MAP_CINNABAR_ISLAND_POKECENTER_1F', center('MAP_CINNABAR_ISLAND_POKECENTER_1F')),
    'ViridianCity_PokemonCenter_1F_Frlg': ('MAP_VIRIDIAN_POKECENTER_1F', center('MAP_VIRIDIAN_POKECENTER_1F')),
    'PalletTown_PokemonCenter_1F_Frlg': ('MAP_FIGHT_AREA_UNUSED_2', center('MAP_FIGHT_AREA_UNUSED_2')),
    'Route10_PokemonCenter_1F_Frlg': ('MAP_ROUTE_10_POKECENTER_1F', center('MAP_ROUTE_10_POKECENTER_1F')),
    'VermilionCity_PokemonFanClub_Frlg': ('MAP_VERMILION_POKEMON_FAN_CLUB', Auto('MAP_VERMILION_POKEMON_FAN_CLUB')),
    'VermilionCity_House1_Frlg': ('MAP_VERMILION_FISHING_DUDE_HOUSE', Auto('MAP_VERMILION_FISHING_DUDE_HOUSE')),
    'VermilionCity_House2_Frlg': ('MAP_VERMILION_CENTRAL_HOUSE', Auto('MAP_VERMILION_CENTRAL_HOUSE')),
    'VermilionCity_House3_Frlg': ('MAP_VERMILION_SOUTH_HOUSE', Auto('MAP_VERMILION_SOUTH_HOUSE')),
    'VermilionCity_Gym_Frlg': ('MAP_VERMILION_GYM', Auto('MAP_VERMILION_GYM')),
    'LavenderTown_VolunteerPokemonHouse_Frlg': ('MAP_LAVENDER_VOLUNTEER_POKEMON_HOUSE', Auto('MAP_LAVENDER_VOLUNTEER_POKEMON_HOUSE')),
    'LavenderTown_House1_Frlg': ('MAP_LAVENDER_SOUTHWEST_HOUSE', Auto('MAP_LAVENDER_SOUTHWEST_HOUSE')),
    'LavenderTown_House2_Frlg': ('MAP_LAVENDER_NAME_RATER', Auto('MAP_LAVENDER_NAME_RATER')),
    'CeladonCity_DepartmentStore_1F_Frlg': ('MAP_CELADON_DEPARTMENT_STORE_1F', Auto('MAP_CELADON_DEPARTMENT_STORE_1F')),
    'CeladonCity_DepartmentStore_2F_Frlg': ('MAP_CELADON_DEPARTMENT_STORE_2F', Auto('MAP_CELADON_DEPARTMENT_STORE_2F')),
    'CeladonCity_DepartmentStore_3F_Frlg': ('MAP_CELADON_DEPARTMENT_STORE_3F', Auto('MAP_CELADON_DEPARTMENT_STORE_3F')),
    'CeladonCity_DepartmentStore_4F_Frlg': ('MAP_CELADON_DEPARTMENT_STORE_4F', Auto('MAP_CELADON_DEPARTMENT_STORE_4F')),
    'CeladonCity_DepartmentStore_5F_Frlg': ('MAP_CELADON_DEPARTMENT_STORE_5F', Auto('MAP_CELADON_DEPARTMENT_STORE_5F')),
    'CeladonCity_DepartmentStore_Roof_Frlg': ('MAP_CELADON_DEPARTMENT_STORE_ROOF', Auto('MAP_CELADON_DEPARTMENT_STORE_ROOF')),
    # (the Department Store's elevator keeps HeartGold's own script: its floors are HeartGold's)
    'CeladonCity_Condominiums_1F_Frlg': ('MAP_CELADON_CONDOMINIUMS_1F', Auto('MAP_CELADON_CONDOMINIUMS_1F')),
    'CeladonCity_Condominiums_2F_Frlg': ('MAP_CELADON_CONDOMINIUMS_2F', Auto('MAP_CELADON_CONDOMINIUMS_2F')),
    'CeladonCity_Condominiums_3F_Frlg': ('MAP_CELADON_CONDOMINIUMS_3F', Auto('MAP_CELADON_CONDOMINIUMS_3F')),
    'CeladonCity_Condominiums_Roof_Frlg': ('MAP_CELADON_CONDOMINIUMS_ROOF', Auto('MAP_CELADON_CONDOMINIUMS_ROOF')),
    'CeladonCity_Condominiums_RoofRoom_Frlg': ('MAP_CELADON_CONDOMINIUMS_ROOF_ROOM', Auto('MAP_CELADON_CONDOMINIUMS_ROOF_ROOM')),
    'CeladonCity_GameCorner_Frlg': ('MAP_CELADON_GAME_CORNER', Auto('MAP_CELADON_GAME_CORNER')),
    'CeladonCity_GameCorner_PrizeRoom_Frlg': ('MAP_CELADON_PRIZE_CORNER', Auto('MAP_CELADON_PRIZE_CORNER')),
    'CeladonCity_Gym_Frlg': ('MAP_CELADON_GYM', Auto('MAP_CELADON_GYM')),
    'CeladonCity_Restaurant_Frlg': ('MAP_CELADON_RESTAURANT', Auto('MAP_CELADON_RESTAURANT')),
    'SaffronCity_Dojo_Frlg': ('MAP_SAFFRON_FIGHTING_DOJO', Auto('MAP_SAFFRON_FIGHTING_DOJO')),
    'SaffronCity_Gym_Frlg': ('MAP_SAFFRON_GYM', Auto('MAP_SAFFRON_GYM')),
    'SaffronCity_MrPsychicsHouse_Frlg': ('MAP_SAFFRON_MR_PSYCHIC_HOUSE', Auto('MAP_SAFFRON_MR_PSYCHIC_HOUSE')),
    'SaffronCity_CopycatsHouse_1F_Frlg': ('MAP_SAFFRON_COPYCAT_HOUSE_1F', Auto('MAP_SAFFRON_COPYCAT_HOUSE_1F')),
    'SaffronCity_CopycatsHouse_2F_Frlg': ('MAP_SAFFRON_COPYCAT_HOUSE_2F', Auto('MAP_SAFFRON_COPYCAT_HOUSE_2F')),
    'SilphCo_1F_Frlg': ('MAP_SAFFRON_SILPH_CO_HQ', Auto('MAP_SAFFRON_SILPH_CO_HQ')),
    'FuchsiaCity_Gym_Frlg': ('MAP_FUCHSIA_GYM', Auto('MAP_FUCHSIA_GYM')),
    'FuchsiaCity_WardensHouse_Frlg': ('MAP_FUCHSIA_SAFARI_ZONE_WARDEN_HOUSE', Auto('MAP_FUCHSIA_SAFARI_ZONE_WARDEN_HOUSE')),
    'FuchsiaCity_House1_Frlg': ('MAP_FUCHSIA_SOUTHWEST_HOUSE', Auto('MAP_FUCHSIA_SOUTHWEST_HOUSE')),
    'FuchsiaCity_SafariZone_Entrance_Frlg': ('MAP_FUCHSIA_PAL_PARK_ENTRANCE', Auto('MAP_FUCHSIA_PAL_PARK_ENTRANCE')),
    'ViridianCity_House_Frlg': ('MAP_VIRIDIAN_NORTHEAST_HOUSE', Auto('MAP_VIRIDIAN_NORTHEAST_HOUSE')),
    'ViridianCity_School_Frlg': ('MAP_VIRIDIAN_TRAINER_HOUSE_1F', Auto('MAP_VIRIDIAN_TRAINER_HOUSE_1F')),
    'ViridianCity_Gym_Frlg': ('MAP_VIRIDIAN_GYM', Auto('MAP_VIRIDIAN_GYM')),
    'PalletTown_TrainingHall_Frlg': ('MAP_FIGHT_AREA_UNUSED_4', Auto('MAP_FIGHT_AREA_UNUSED_4')),
    'Route5_PokemonDayCare_Frlg': ('MAP_ROUTE_5_HOUSE', Auto('MAP_ROUTE_5_HOUSE')),
    'Route5_SouthEntrance_Frlg': ('MAP_ROUTE_5_SAFFRON_GATEHOUSE', Auto('MAP_ROUTE_5_SAFFRON_GATEHOUSE')),
    'Route6_NorthEntrance_Frlg': ('MAP_ROUTE_6_SAFFRON_GATEHOUSE', Auto('MAP_ROUTE_6_SAFFRON_GATEHOUSE')),
    'Route7_EastEntrance_Frlg': ('MAP_ROUTE_7_SAFFRON_GATEHOUSE', Auto('MAP_ROUTE_7_SAFFRON_GATEHOUSE')),
    'Route8_WestEntrance_Frlg': ('MAP_ROUTE_8_SAFFRON_GATEHOUSE', Auto('MAP_ROUTE_8_SAFFRON_GATEHOUSE')),
    'UndergroundPath_NorthEntrance_Frlg': ('MAP_ROUTE_5_UNDERGROUND_PATH_GATE', Auto('MAP_ROUTE_5_UNDERGROUND_PATH_GATE')),
    'UndergroundPath_SouthEntrance_Frlg': ('MAP_ROUTE_6_UNDERGROUND_PATH_GATE', Auto('MAP_ROUTE_6_UNDERGROUND_PATH_GATE')),
    'UndergroundPath_NorthSouthTunnel_Frlg': ('MAP_ROUTE_5_UNDERGROUND_PATH', Auto('MAP_ROUTE_5_UNDERGROUND_PATH')),
    'Route11_EastEntrance_1F_Frlg': ('MAP_ROUTE_19_ROUTE_12_GATEHOUSE', Auto('MAP_ROUTE_19_ROUTE_12_GATEHOUSE')),
    'Route12_FishingHouse_Frlg': ('MAP_ROUTE_12_FISHING_BROTHER_HOUSE', Auto('MAP_ROUTE_12_FISHING_BROTHER_HOUSE')),
    'Route15_WestEntrance_1F_Frlg': ('MAP_ROUTE_15_FUCHSIA_GATEHOUSE', Auto('MAP_ROUTE_15_FUCHSIA_GATEHOUSE')),
    'Route16_NorthEntrance_1F_Frlg': ('MAP_ROUTE_16_GATEHOUSE', Auto('MAP_ROUTE_16_GATEHOUSE')),
    'Route16_House_Frlg': ('MAP_ROUTE_16_HOUSE', Auto('MAP_ROUTE_16_HOUSE')),
    'Route18_EastEntrance_1F_Frlg': ('MAP_ROUTE_18_GATEHOUSE', Auto('MAP_ROUTE_18_GATEHOUSE')),
    'Route22_NorthEntrance_Frlg': ('MAP_ROUTE_22_POKEMON_LEAGUE_RECEPTION_GATE', Auto('MAP_ROUTE_22_POKEMON_LEAGUE_RECEPTION_GATE')),
    'Route2_EastBuilding_Frlg': ('MAP_ROUTE_2_SOUTHEAST_GATEHOUSE', Auto('MAP_ROUTE_2_SOUTHEAST_GATEHOUSE')),
    'IndigoPlateau_PokemonCenter_1F_Frlg': ('MAP_POKEMON_LEAGUE_ENTRANCE', Auto('MAP_POKEMON_LEAGUE_ENTRANCE')),
    'PokemonLeague_LoreleisRoom_Frlg': ('MAP_POKEMON_LEAGUE_WILL_ROOM', Auto('MAP_POKEMON_LEAGUE_WILL_ROOM')),
    'PokemonLeague_BrunosRoom_Frlg': ('MAP_POKEMON_LEAGUE_KOGA_ROOM', Auto('MAP_POKEMON_LEAGUE_KOGA_ROOM')),
    'PokemonLeague_AgathasRoom_Frlg': ('MAP_POKEMON_LEAGUE_BRUNO_ROOM', Auto('MAP_POKEMON_LEAGUE_BRUNO_ROOM')),
    'PokemonLeague_LancesRoom_Frlg': ('MAP_POKEMON_LEAGUE_KAREN_ROOM', Auto('MAP_POKEMON_LEAGUE_KAREN_ROOM')),
    'PokemonLeague_ChampionsRoom_Frlg': ('MAP_POKEMON_LEAGUE_LANCE_ROOM', Auto('MAP_POKEMON_LEAGUE_LANCE_ROOM')),
    'PokemonLeague_HallOfFame_Frlg': ('MAP_POKEMON_LEAGUE_HALL_OF_FAME', Auto('MAP_POKEMON_LEAGUE_HALL_OF_FAME')),
}
import build_interiors as _BI      # (the big interiors HeartGold has no building for: built from the GBA layouts)


# Penny's house: her Eeveelution plushes. The GBA had room (and sprite palettes) for eight in a row along the
# walls; our room is bigger (build_rooms.py: 17x11) and they are left about the place the way she'd leave them:
# one watching the TV, one at the sink, one on a chair, one beside her. Seven are HeartGold's own species, five
# the GBA game's new ones (Valyreon with the GBA's line, the other four with lines of ours in its mould: OWN_GBA).
# None stands on, in front of or beside the wall furniture (HeartGold's models reach over those squares), and
# none on the table: a person's height is the floor's whatever the event says, so it stood inside it.
#   species: (x, z, facing, its script: None = the GBA's shared one)
PENNY_PLUSHES = {
    'EEVEE': (9, 8, 'DOWN', None),            # on the rug, facing the door
    'VAPOREON': (1, 3, 'UP', None),           # at the sink
    'FLAREON': (8, 4, 'UP', None),            # watching the TV
    'JOLTEON': (4, 7, 'RIGHT', None),
    'ESPEON': (10, 6, 'LEFT', None),          # on a chair
    'SYLVEON': (3, 5, 'DOWN', None),
    'UMBREON': (15, 8, 'LEFT', None),         # in the corner by the plant
    'VALYREON': (12, 5, 'LEFT', 'ViridianCity_PennysHouse_EventScript_PlushNew'),      # beside Penny
    'ODEON': (10, 2, 'DOWN', 'Canvas_PennysHouse_EventScript_PlushOdeon'),             # under the map
    'HYPEREON': (14, 3, 'LEFT', 'Canvas_PennysHouse_EventScript_PlushHypereon'),
    'AUTOMATEON': (3, 2, 'DOWN', 'Canvas_PennysHouse_EventScript_PlushAutomateon'),
    'APPARITEON': (1, 8, 'RIGHT', 'Canvas_PennysHouse_EventScript_PlushAppariteon'),   # behind the plant
}
# Scripts and text of ours in the GBA game's own notation (read as if they were in its files). Nick writes the
# final dialogue: these are stand-ins in the mould of the GBA's Valyreon plush line.
OWN_GBA = {
    'Canvas_PennysHouse_EventScript_PlushOdeon':
        "It's an ODEON plush.\\p…ODEON? One of its eyes is sewn\\nshut, and it looks deliberate.$",
    'Canvas_PennysHouse_EventScript_PlushHypereon':
        "It's a HYPEREON plush.\\pIts felt wings are spread wide,\\nas if it's about to take off.$",
    'Canvas_PennysHouse_EventScript_PlushAutomateon':
        "It's an AUTOMATEON plush.\\pThe little brass gear on its collar\\nactually turns!$",
    'Canvas_PennysHouse_EventScript_PlushAppariteon':
        "It's an APPARITEON plush.\\p…Wasn't it facing the other way\\na second ago?$",
}


def own_gba(g):
    """our sign scripts above, added to the GBA game's as it reads them"""
    for label, s in OWN_GBA.items():
        g.texts[label + '_Text'] = s
        g.labels[label] = [('msgbox', [label + '_Text', 'MSGBOX_SIGN']), ('end', [])]


def pennys_plushes(people):
    plush = lambda o: re.match(r'OBJ_EVENT_GFX_SPECIES\((\w+)\)$', o['graphics_id'])
    have = {plush(o).group(1): o for o in people if plush(o)}
    out = [o for o in people if not plush(o)]
    for n, (x, z, face, script) in PENNY_PLUSHES.items():
        o = dict(have['SYLVEON'], graphics_id='OBJ_EVENT_GFX_SPECIES(%s)' % n, movement_type='MOVEMENT_TYPE_FACE_' + face, _at=(x, z))
        if script: o['script'] = script
        o.pop('local_id', None)
        out.append(o)
    return out


# Rooms build_rooms.py made: the squares of the first floor row that HeartGold's wall furniture stands on (the
# GBA's stood in the wall rows, with open floor in front). Those are closed, so what the GBA had there moves:
# a sign on the furniture (the TV's screen, a shelf) comes down onto its square, to be read from the square in
# front; a person standing there steps one square forward.
def _furniture():
    try: return json.load(open(os.path.join(os.path.dirname(HERE), 'data', 'room_furniture.json')))
    except FileNotFoundError: return {}


def off_furniture(slot, x, z, sign=False):
    f = _FURN.get(slot)
    if not f: return x, z
    sq = set(map(tuple, f['squares']))
    if sign: return (x, f['first']) if z < f['first'] and (x, f['first']) in sq else (x, z)
    return (x, z + 1) if (x, z) in sq else (x, z)


_FURN = _furniture()


_lay = {}


def _open_on_gba(mj, o):
    """is the GBA square this person stands on open floor? (a clerk behind a counter, a statue: no)"""
    if '_open' in o: return o['_open']
    try:
        if mj['layout'] not in _lay:
            import gba_map
            _lay[mj['layout']] = gba_map.Layout(mj['layout'])
        L = _lay[mj['layout']]
        return 0 <= o['x'] < L.w and 0 <= o['y'] < L.h and L.collision(o['x'], o['y']) == 0
    except Exception:
        return False


def clear_of(slot, x, z, o, mj, hg_warps, placed):
    """Where someone ends up must not block a way in or crowd the people beside them, unless the GBA has it so:
    a person the GBA keeps clear of its doors and stairs who lands on or next to one of ours, or lands beside
    somebody they stood well apart from on the GBA, steps to the nearest open square clear of both.
    placed: [(square here, square on the GBA)] of the people already put down."""
    import world, auto_anchor as AA
    outdoor = 'EVERYWHERE' in slots.header(slot)['matrixId']
    pf = (lambda a, b: world.perm(a, b)) if outdoor else (lambda a, b: world.perm_in(slot, a, b))
    own = (lambda a, b: world.land_at(a, b) is not None and world.land_at(a, b)[1] == AA.map_ids()[slot]) if outdoor else (lambda a, b: True)
    ok = lambda a, b: a >= 0 and b >= 0 and own(a, b) and (lambda v: v is not None and not v & 0x8000 and (v & 0xFF) == 0)(pf(a, b))
    g = (o['x'], o['y'])
    d1 = lambda p, q: abs(p[0] - q[0]) + abs(p[1] - q[1])
    g_at_door = any(d1(g, (w['x'], w['y'])) <= 1 for w in mj.get('warp_events', []))
    doors = [] if g_at_door else hg_warps
    crowd = [h for h, gq in placed if d1(g, gq) >= 3]                 # (people they were not beside on the GBA)
    bad = lambda c: any(d1(c, w) <= 1 for w in doors) or any(d1(c, h) <= 1 for h in crowd) or any(c == h for h, _ in placed)
    if not bad((x, z)): return x, z
    for r in range(1, 5):
        ring = sorted(((x + i, z + j) for i in range(-r, r + 1) for j in range(-r, r + 1) if max(abs(i), abs(j)) == r),
                      key=lambda c: d1(c, (x, z)))
        for c in ring:
            if ok(*c) and not bad(c): return c
    return x, z


def settle(slot, x, z, taken):
    """In a map we built: someone the GBA has on open floor who lands on a closed square here (furniture of
    HeartGold's is bigger, a wall stands where the GBA drew one flat) steps to the nearest open square that is
    free and is no door."""
    import world
    ok = lambda a, b: (lambda v: v is not None and not v & 0x8000 and (v & 0xFF) == 0)(world.perm_in(slot, a, b))
    v = world.perm_in(slot, x, z)
    if v is None or not v & 0x8000: return x, z       # (open, or water, grass, a mat: where the GBA has them)
    for r in range(1, 4):
        ring = sorted(((x + i, z + j) for i in range(-r, r + 1) for j in range(-r, r + 1) if max(abs(i), abs(j)) == r),
                      key=lambda c: (abs(c[0] - x) + abs(c[1] - z), c[1] < z))
        for c in ring:
            if c[0] >= 0 and c[1] >= 0 and ok(*c) and c not in taken: return c
    return x, z
PEOPLE = {'ViridianCity_PennysHouse_Frlg': pennys_plushes}     # GBA map -> its people, changed (an '_at' is a HeartGold square)


def room_xy(gba):
    """a room build_rooms.py built wider or longer than the GBA's (widen): its squares move with the columns/rows added"""
    import build_rooms
    w = next((r.get('widen') for r in list(build_rooms.ROOMS) + list(_BI.INTERIORS) if r['gba'] == gba and r.get('widen')), None) or {}
    cols = [c if len(c) == 3 else (c[0], c[1], c[0]) for c in w.get('cols', [])]
    rows = [r if len(r) == 3 else (r[0], r[1], r[0]) for r in w.get('rows', [])]
    return lambda x, y, kind='pos': (x + sum(n for c, n, _ in cols if c <= x), y + sum(n for r, n, _ in rows if r <= y))


for _d, _v in list(MAPS.items()):
    if _v[1] is None: MAPS[_d] = (_v[0], room_xy(_d)) + tuple(_v[2:])
for _c in _BI.INTERIORS:
    MAPS[_c['gba']] = (_c['map'], room_xy(_c['gba']) if _c.get('widen') else same)
import build_caves as _BC           # (caves are widened where a wall is too thin for HeartGold's pieces: cave_widen)
for _c in _BC.CAVES:
    MAPS[_c['gba']] = (_c['map'], _BC.cave_xy(_c['gba']))
# GBA map constant -> HeartGold map, for pairing doors (rooms we port, and places we only need to find)
DEST_EXTRA = {
    'MAP_SSANNE_EXTERIOR': 'MAP_SS_AQUA_VERMILION_PORT_INTERIOR', 'MAP_POKEMON_TOWER_1F': 'MAP_LAVENDER_RADIO_STATION',
    'MAP_SAFFRON_CITY_CONNECTION': 'MAP_SAFFRON', 'MAP_ROCK_TUNNEL_1F': 'MAP_ROCK_TUNNEL_1F', 'MAP_POWER_PLANT': 'MAP_ROUTE_10_POWER_PLANT_REPAIRED',
    'MAP_DIGLETTS_CAVE_SOUTH_ENTRANCE': 'MAP_DIGLETT_CAVE', 'MAP_DIGLETTS_CAVE_NORTH_ENTRANCE': 'MAP_DIGLETT_CAVE',
    'MAP_SEAFOAM_ISLANDS_1F': 'MAP_SEAFOAM_ISLANDS_1F', 'MAP_ROUTE12_NORTH_ENTRANCE_1F': 'MAP_ROUTE_19_ROUTE_12_GATEHOUSE',
    'MAP_VICTORY_ROAD_1F': 'MAP_VICTORY_ROAD_1F', 'MAP_CERULEAN_CAVE_1F': 'MAP_CERULEAN_CAVE_1F', 'MAP_ROUTE21_SOUTH': 'MAP_ROUTE_21',
    'MAP_ROUTE21_NORTH': 'MAP_ROUTE_21', 'MAP_ROUTE23': 'MAP_VICTORY_ROAD_1F', 'MAP_SILPH_CO_1F': 'MAP_SAFFRON_SILPH_CO_HQ',
}

# ---------------------------------------------------------------- Kanto on the GBA's layouts (build_overworld.py)
# The towns and routes are the GBA's own maps laid side by side (data/kanto_world.json: each GBA map's corner in
# HeartGold's squares, the HeartGold map each land is). A HeartGold map's people, signs and trigger squares are the
# GBA's that stand in its lands, whichever GBA map they come from, at their own squares; its map scripts are its
# main GBA map's (the one with most squares there). People from other GBA maps get ids after the main map's.
WORLD_FILE = os.path.join(os.path.dirname(HERE), 'data', 'kanto_world.json')
WORLD = json.load(open(WORLD_FILE)) if os.path.exists(WORLD_FILE) else None
WORLD_EVENTS = {}           # MAPS key -> the GBA events it ports (in its main map's squares)
LID_OVER = {}               # a GBA local id -> its id in the HeartGold map it ended up in


def _world_entries():
    W = WORLD
    cells = {tuple(int(v) for v in k.split(',')): m for k, m in W['cells'].items()}
    owner = lambda gx, gz: cells.get((gx // 32, gz // 32))
    outdoor = set(W['maps'])
    for k in [k for k in MAPS if any(p_ in outdoor for p_ in k.split('#')[0].split('+'))]:
        if k not in ('PalletTown_Frlg', 'CinnabarIsland_Frlg'): del MAPS[k]
    by_map = {}
    for d, (x0, y0, w, h) in W['maps'].items():
        for gz in range(y0, y0 + h):
            for gx in range(x0, x0 + w):
                X = owner(gx, gz)
                if X: by_map.setdefault(X, {}); by_map[X][d] = by_map[X].get(d, 0) + 1
    for X, counts in sorted(by_map.items()):
        if X == 'MAP_CINNABAR_ISLAND': continue           # (our widened town: its own squares, build_cinnabar.py)
        if X == 'MAP_PALLET': prim, key = 'PalletTown_Frlg', 'PalletTown_Frlg'
        else:
            prim = max(counts, key=lambda d: (W['hg'][d] == X, counts[d]))
            key = prim + '#world'
            ox, oy = W['maps'][prim][:2]
            MAPS[key] = (X, (lambda ox, oy: lambda x, y, kind='pos': (ox + x, oy + y))(ox, oy))
        T0 = W['maps'][prim][:2]
        base = json.loads(json.dumps(G.map_json(prim)))
        out = {k: [] for k in ('object_events', 'bg_events', 'coord_events')}
        nxt = len(base.get('object_events', [])) + 1
        for d in [prim] + sorted(d for d in counts if d != prim):
            gx0, gy0 = W['maps'][d][:2]
            mj = G.map_json(d)
            import gba_map as _gm
            lay = _gm.Layout(mj['layout'])
            for k in out:
                for i, e in enumerate(mj.get(k, [])):
                    gx, gy = gx0 + e['x'], gy0 + e['y']
                    if owner(gx, gy) != X: continue
                    e = dict(e, x=gx - T0[0], y=gy - T0[1],
                             _open=0 <= e['x'] < lay.w and 0 <= e['y'] < lay.h and lay.collision(e['x'], e['y']) == 0)
                    if k == 'object_events':
                        if d == prim: e['_lid'] = i + 1
                        else:
                            e['_lid'] = nxt; nxt += 1
                            if e.get('local_id'): LID_OVER[e['local_id']] = e['_lid']
                    out[k].append(e)
        base.update(out)
        WORLD_EVENTS[key] = base


MAPS_HG = dict(MAPS)        # (the outdoor maps' own HeartGold maps, as build_overworld.py reads them)
if WORLD:
    _world_entries()
    for _d, (_m, _ox, _oz) in WORLD.get('woods', {}).items():      # (Viridian Forest: the GBA's, in its own lands)
        MAPS[_d] = (_m, (lambda ox, oz: lambda x, y, kind='pos': (ox + x, oz + y))(_ox, _oz))
    INSERTS_DROP = ('PewterCity_EventScript_GymGuideTrigger',)     # (walks fitted to HeartGold's Pewter)


def events_json(gba_map):
    """the GBA events a MAPS entry ports"""
    return WORLD_EVENTS.get(gba_map) or merged_json(gba_map.split('#')[0])


PRIMARIES = set(v[0] for k, v in MAPS.items() if '#' not in k) | (set(WORLD['hg'].values()) if WORLD else set())


def _dest():
    out = dict(slots.SLOTS)
    for d, v in MAPS.items():
        if '#' in d: continue
        try: out[G.map_json(d)['id']] = v[0]
        except Exception: pass
    for k, v in DEST_EXTRA.items(): out.setdefault(k, v)
    if WORLD:
        for d, m in WORLD['hg'].items(): out[G.map_json(d)['id']] = m
    return out


DEST = _dest()

# ---------------------------------------------------------------- walks redone for HeartGold's layout
DIRS = {'up': (0, -1), 'down': (0, 1), 'left': (-1, 0), 'right': (1, 0)}


def path(xy, a, b, avoid=()):
    """the shortest walk (GBA step names) from square a to b over open squares of xy's map, or None"""
    from collections import deque
    prev, q = {a: None}, deque([a])
    while q:
        c = q.popleft()
        if c == b: break
        for d, (dx, dz) in DIRS.items():
            n = (c[0] + dx, c[1] + dz)
            if n in prev or n in avoid or not xy.open(*n): continue
            prev[n] = (c, d); q.append(n)
    if b not in prev: return None
    out, c = [], b
    while prev[c]: c, d = prev[c]; out.append(d)
    return out[::-1]


def walk(steps, kind='walk'):
    return [('%s_%s' % (kind, d), []) for d in steps]


def lead(xy, guide, player, front, aside, then=None):
    """A guide leads the player (next to them) to the square in front of a door: the guide walks there and steps
    aside, the player follows a square behind and ends facing the door (up). -> (guide's walk, player's walk)"""
    p = path(xy, guide, front, avoid={player})
    if p is None: return [], []
    into = next(d for d, v in DIRS.items() if (player[0] + v[0], player[1] + v[1]) == guide)
    # (the guide steps aside across the way the player comes in, not back into them)
    side = [d for d in (('left', 'right') if p[-1] in ('up', 'down') else ('down', 'up'))
            if xy.open(front[0] + DIRS[d][0], front[1] + DIRS[d][1])]
    aside = aside if aside in side or not side else side[0]
    back = {'left': 'right', 'right': 'left', 'up': 'down', 'down': 'up'}[aside]
    return walk(p + [aside]) + walk([back], 'walk_in_place_faster'), walk([into] + p) + walk(['up'], 'walk_in_place_faster')


def pewter_moves(xy):
    """Pewter's guides walk you to the Gym and the Museum; HeartGold's town needs its own paths for that"""
    gym, museum = (1047, 93), (1048, 79)
    m = {}
    # the Gym guide (1075, 101) stops you on the east road, lanes 102-105 at x 1076
    for lane, (z, mv, pw, gw) in enumerate([(102, 'GuideMoveToLeadTop', 'PlayerWalkToGymTop', 'GuideWalkToGymTop'),
                                           (103, 'GuideMoveToLeadMid', 'PlayerWalkToGymMid', 'GuideWalkToGymMid'),
                                           (104, 'GuideMoveToLeadBottom', 'PlayerWalkToGymBottom', 'GuideWalkToGymBottom'),
                                           (105, 'GuideApproachPlayerRight', 'PlayerWalkToGymRight', 'GuideWalkToGymRight')]):
        m['PewterCity_Movement_' + mv] = walk(['down'] * (z - 101)) + walk(['right'], 'walk_in_place_faster')
        g, pl = lead(xy, (1075, z), (1076, z), gym, 'right')
        m['PewterCity_Movement_' + gw], m['PewterCity_Movement_' + pw] = g, pl
    # talked to from the west
    m['PewterCity_Movement_PlayerWaitForGuideEast'] = []
    m['PewterCity_Movement_GuideMoveToLeadEast'] = []
    g, pl = lead(xy, (1075, 101), (1074, 101), gym, 'right')
    m['PewterCity_Movement_GuideWalkToGymEast'], m['PewterCity_Movement_PlayerWalkToGymEast'] = g, pl
    m['PewterCity_Movement_GymGuideExit'] = walk(['down'] * 4)
    # the Museum guide (1068, 98) walks you to the Museum's door
    guide = (1068, 98)
    for facing, (dx, dz) in (('North', (0, 1)), ('South', (0, -1)), ('West', (1, 0)), ('East', (-1, 0))):
        player = (guide[0] + dx, guide[1] + dz)
        g, pl = lead(xy, guide, player, museum, 'right') if xy.open(*player) else ([], [])
        m['PewterCity_Movement_GuideWalkToMuseum' + facing], m['PewterCity_Movement_PlayerWalkToMuseum' + facing] = g, pl
    m['PewterCity_Movement_MuseumGuideExit'] = walk(['down'] * 3)
    # the aide (1077, 101) with the Running Shoes: lanes 102-104 at x 1077; he leaves by the east road
    m['PewterCity_Movement_AideApproachPlayerMid'] = [('delay_4', [])] + walk(['down'])
    m['PewterCity_Movement_AideApproachPlayerBottom'] = [('delay_4', [])] + walk(['down'] * 2)
    for i in range(4):
        m['PewterCity_Movement_AideExit%d' % i] = walk(['right'] * 7)
    return m


MOVES = {'PewterCity_Frlg': pewter_moves}


def pewter_gym_guide_lane4(p):
    """the GBA game never walks you from the fourth lane (unreachable there); HeartGold's road is four wide"""
    l = p.new('lane')
    return ['CompareVarToValue %s, 3' % p.var('VAR_TEMP_1'), 'GoToIfNe %s' % l,
            'Call %s' % p.label('PewterCity_EventScript_WalkToGymRight'), l + ':']


# Lines of our own, before the first given command of a label. The GBA game names the rival in Oak's intro;
# HeartGold's intro only names the player, so he's named the first time he speaks.
def new_game(p):
    """The GBA game sets up its flags on a new game (EventScript_ResetAllMapFlagsFrlg: people who aren't there
    yet, and so on). A new game here begins in Pallet Town, so its map script does the same, once."""
    done = p.new('new_game')
    out = ['GoToIfSet %s, %s' % (p.flag('CV_NEW_GAME_SET_UP'), done)]
    for cmd, a in p.g.labels['EventScript_ResetAllMapFlagsFrlg']:
        if cmd == 'setflag': out.append('SetFlag %s' % p.flag(a[0]))
        elif cmd == 'setvar': out.append('SetVar %s, %s' % (p.var(a[0]), p.val(a[1])))
    return out + ['SetFlag %s' % p.flag('CV_NEW_GAME_SET_UP'), done + ':']


# maps of ours with the GBA's spin tiles (HeartGold's slide tiles): their map-load script starts the Viridian gymmick
GYMMICK_INIT = {'RocketHideout_B2F_Frlg', 'RocketHideout_B3F_Frlg'}
INSERTS = {
    'PewterCity_EventScript_GymGuideTrigger': ('call_if_eq', pewter_gym_guide_lane4),
    'PalletTown_OnTransition': (None, new_game),
    'PalletTown_ProfessorOaksLab_ChooseStarterScene': ('msgbox', [
        'GoToIfSet {flag[CV_RIVAL_NAMED]}, _cv_rival_named',
        'FadeScreen 6, 1, 0, RGB_BLACK', 'WaitFade', 'NameRival VAR_SPECIAL_RESULT', 'FadeScreen 6, 1, 1, RGB_BLACK', 'WaitFade',
        'SetFlag {flag[CV_RIVAL_NAMED]}', '_cv_rival_named:']),
}
if WORLD:
    for _k in INSERTS_DROP: INSERTS.pop(_k, None)


def map_safe(line):
    """Map scripts (on load, on transition) run before HeartGold sets up the special vars (0x8000-0x800D): using
    one there fails an assert. They use temp vars 0x4010-0x401D in their place."""
    line = line.replace('VAR_SPECIAL_RESULT', '0x800C').replace('VAR_SPECIAL_LAST_TALKED', '0x800D')
    return re.sub(r'\b0x800([0-9A-D])\b', lambda m: '0x%X' % (0x4010 + int(m.group(1), 16)), line)


class _Lookup:
    def __init__(self, f): self.f = f
    def __getitem__(self, k): return self.f(k)


# ---------------------------------------------------------------- ids
class Ids:
    """Our flags and vars, numbered once and kept (saves depend on the numbers)"""
    FLAG_BASE, VAR_BASE = 0x2000, 0x5000

    def __init__(self):
        self.d = json.load(open(IDS)) if os.path.exists(IDS) else {'flags': {}, 'vars': {}}

    def flag(self, name):
        m = re.match(r'FLAG_TEMP_(\w+)$', name)
        if m:   # GBA temp flags (cleared on entering a map) -> HeartGold's map-temp flags
            return str(int(m.group(1), 16) if re.match(r'^[0-9A-F]+$', m.group(1)) else 1)
        if name in ('0', 'FLAG_NONE'): return '0'
        f = self.d['flags']
        if name not in f: f[name] = len(f)
        return '0x%X' % (self.FLAG_BASE + f[name])

    def var(self, name):
        m = re.match(r'VAR_TEMP_([0-9A-F])$', name)
        if m: return '0x%X' % (0x4000 + int(m.group(1), 16))
        m = re.match(r'VAR_0x(80[0-9A-F]{2})$', name)
        if m: return '0x' + m.group(1)
        special = {'VAR_RESULT': 'VAR_SPECIAL_RESULT', 'VAR_LAST_TALKED': 'VAR_SPECIAL_LAST_TALKED'}
        if name in special: return special[name]
        m = re.match(r'VAR_OBJ_GFX_ID_([0-9A-F])$', name)
        if m: return '0x%X' % (0x4020 + int(m.group(1), 16))
        v = self.d['vars']
        if name not in v: v[name] = len(v)
        return '0x%X' % (self.VAR_BASE + v[name])

    def save(self):
        os.makedirs(os.path.dirname(IDS), exist_ok=True)
        json.dump(self.d, open(IDS, 'w'), indent=1, sort_keys=True)


# ---------------------------------------------------------------- text
WORDS = [('POKéMON', 'Pokémon'), ('POKéDEX', 'Pokédex'), ('POKé BALL', 'Poké Ball'), ('POKéMART', 'Poké Mart'),
         ('POKéNAV', 'PokéNav'), ('POKé', 'Poké'), ('PROF. OAK', 'Prof. Oak'), ('TRAINER', 'Trainer'), ('GYM', 'Gym'),
         ('LEADER', 'Leader'), ('PC', 'PC')]


# The GBA game writes names in capitals (PALLET TOWN, OAK, HOT AIR BALLOON); HeartGold doesn't (Pallet Town, Oak).
KEEP_CAPS = {'PC', 'TM', 'HM', 'HP', 'PP', 'TV', 'KO', 'OK', 'BP', 'GBA', 'ID', 'MC', 'EXP', 'S.S', 'DS', 'NPC', 'UFO'}
LOWER = {'YOU', 'YOUR', 'MY', 'ME', 'THE', 'OF', 'TO', 'AND', 'OR', 'IS', 'IT', 'A', 'AN', 'IN', 'ON', 'AT', 'FOR',
         'NOT', 'NO', 'YES', "I'M", "YOU'RE", "DON'T", "CAN'T", 'THIS', 'THAT', 'WAS', 'ARE', 'BE', 'WE', 'US', 'OUT'}


def unshout(w):
    if w in KEEP_CAPS or w.rstrip('.') in KEEP_CAPS: return w
    if w in LOWER: return w.lower()
    return '.'.join(p[:1] + p[1:].lower() for p in w.split('.'))


def text(s):
    """GBA string -> HeartGold message lines (\\n line, \\r new box, \\f scroll); returns (lines, buffers)"""
    s = s.split('$')[0]
    for a, b in WORDS: s = re.sub(re.escape(a) + r'S\b', b + 's', s).replace(a, b)     # (POKé BALLS -> Poké Balls)
    s = re.sub(r"(?:(?<![{\w])|(?<=\\[pln]))([A-ZÉ][A-Zé'É.]*[A-Zé])(?![\w}])", lambda m: unshout(m.group(1)), s)
    bufs = set()

    def code(m):
        c = m.group(1)
        if c == 'PLAYER': bufs.add('player'); return '{STRVAR_1 3, 6, 0}'
        if c == 'RIVAL': bufs.add('rival'); return '{STRVAR_1 3, 7, 0}'
        mm = re.match(r'STR_VAR_(\d)', c)
        if mm: return '{STRVAR_1 3, %d, 0}' % (int(mm.group(1)) - 1)
        if c in ('PKMN',): return 'Pokémon'
        return ''          # colours, pauses, fonts: dropped
    s = re.sub(r'\{([^}]*)\}', code, s)
    s = s.replace('\\p', '\r').replace('\\l', '\f').replace('\\n', '\n').replace("'", '’')
    out, cur = [], ''
    for ch in s:
        cur += ch
        if ch in '\r\n\f':
            out.append(cur); cur = ''
    if cur: out.append(cur)
    return out, bufs


# ---------------------------------------------------------------- sounds, items, sprites, movement
SE = {'SE_SELECT': 'SEQ_SE_DP_SELECT', 'SE_PIN': 'SEQ_SE_DP_SELECT', 'SE_DOOR': 'SEQ_SE_DP_DOOR', 'SE_EXIT': 'SEQ_SE_DP_KAIDAN2',
      'SE_SUCCESS': 'SEQ_SE_DP_SELECT', 'SE_FAILURE': 'SEQ_SE_DP_BOX03', 'SE_BALL': 'SEQ_SE_DP_SELECT'}
FANFARE = {'MUS_OBTAIN_ITEM': 'SEQ_ME_ITEM', 'MUS_OBTAIN_KEY_ITEM': 'SEQ_ME_KEYITEM', 'MUS_LEVEL_UP': 'SEQ_ME_LVUP',
           'MUS_OBTAIN_BADGE': 'SEQ_ME_BADGE', 'MUS_HEAL': 'SEQ_ME_ASA', 'MUS_OBTAIN_TMHM': 'SEQ_ME_WAZA'}

SPRITE = {   # GBA graphics id (without OBJ_EVENT_GFX_ and _FRLG) -> HeartGold sprite (without SPRITE_); '#n': an
    # overworld of our own by its tag (engine: data/graphics/overworlds/custom, src/field/overworld_table.c from 7000)
    'WOMAN_1': 'GSWOMAN1', 'WOMAN_2': 'GSWOMAN2', 'WOMAN_3': 'GSWOMAN3', 'WOMAN_4': 'GSWOMAN2', 'WOMAN_5': 'GSWOMAN3',
    'MAN_1': 'GSMAN1', 'MAN_2': 'GSMAN2', 'MAN_3': 'GSMAN3', 'MAN_4': 'GSMIDDLEMAN1', 'MAN_5': 'GSMAN2', 'MAN': 'GSMAN1',
    'FAT_MAN': 'GSBIGMAN', 'OLD_MAN': 'GSOLDMAN1', 'OLD_MAN_1': 'GSOLDMAN1', 'OLD_WOMAN': 'GSOLDWOMAN1',
    'BOY': 'GSBOY1', 'BOY_1': 'GSBOY1', 'BOY_2': 'GSBOY2', 'BOY_3': 'GSBOY3', 'LITTLE_BOY': 'GSBABYBOY1',
    'LITTLE_GIRL': 'GSBABYGIRL1', 'GIRL_1': 'GSGIRL1', 'GIRL_2': 'GSGIRL2', 'GIRL_3': 'GSGIRL3', 'LASS': 'GSGIRL2',
    'YOUNGSTER': 'GSBOY2', 'BUG_CATCHER': 'GSBOY3', 'GENTLEMAN': 'GSGENTLEMAN', 'SCIENTIST': 'GSASSISTANTM',
    'SCIENTIST_1': 'GSASSISTANTM', 'NURSE': 'PCWOMAN1', 'CLERK': 'SHOPM1_2', 'MART_EMPLOYEE': 'SHOPM1_2',
    'PROF_OAK': 'OOKIDO', 'MOM': 'GSMAMA', 'BLUE': 'GSLEADER16', 'DAISY': 'NANAMI', 'GIOVANNI': 'SAKAKI',
    'ROCKET_M': 'ROCKETM', 'ROCKET_F': 'ROCKETW', 'POLICEMAN': 'POLICEMAN', 'SAILOR': 'SEAMAN_2', 'FISHERMAN': 'FISHING_2',
    'HIKER': 'MOUNT_2', 'SWIMMER_M': 'GSSWIMMERM', 'SWIMMER_F': 'GSSWIMMERW', 'BLACK_BELT': 'GSFIGHTER',
    'CAMPER': 'CAMPBOY_2', 'PICNICKER': 'PICNICGIRL_2', 'BEAUTY': 'GSWOMAN3', 'COOLTRAINER_M': 'GSMAN3',
    'COOLTRAINER_F': 'GSWOMAN3', 'POKE_MANIAC': 'MANIA', 'ITEM_BALL': 'MONSTARBALL', 'PUSHABLE_BOULDER': 'ROCK',
    'BREAKABLE_ROCK': 'BREAKROCK', 'CUTTABLE_TREE': 'TREE', 'WORKER_M': 'WORKMAN', 'BALDING_MAN': 'GSMIDDLEMAN1',
    'GYM_GUY': 'SUNGLASSES', 'CHANNELER': 'ITAKO', 'ROCKER': 'GSMAN2', 'BIKER': 'CYCLEM', 'EXPERT_M': 'GSOLDMAN1',
    'EXPERT_F': 'GSOLDWOMAN1', 'POKEFAN_M': 'GSMIDDLEMAN1', 'POKEFAN_F': 'MIDDLEWOMAN1_2', 'TWIN': 'GSGIRL1',
    'WORKER_F': 'GSWOMAN1', 'LEADER_AIDE': 'GSASSISTANTM', 'POKEDEX': 'SCROLL', 'TOWN_MAP': 'SCROLL',
    'CEREMONY_PODIUM': 'GTOROPHY', 'OLD_MAN_LYING_DOWN': 'GSOLDMAN1', 'GAUNTLET_PENNY': 'GSWOMAN1',
    'LT_SURGE': 'GSLEADER9', 'SABRINA': 'GSLEADER10', 'ERIKA': 'GSLEADER11', 'KOGA': 'GSBIGFOUR2', 'BLAINE': 'GSLEADER13',
    'LORELEI': 'GSBIGFOUR4', 'BRUNO': 'GSBIGFOUR3', 'AGATHA': 'GSOLDWOMAN1', 'LANCE': 'WATARU', 'MR_FUJI': 'GSOLDMAN1',
    'FISHER': 'FISHING_2', 'OLD_MAN_2': 'OLDMAN1', 'TUBER_M_WATER': 'GSSWIMMERM', 'SWIMMER_M_LAND': 'GSSWIMMERM', 'SWIMMER_F_LAND': 'GSSWIMMERW',
    'CRUSH_GIRL': 'GSGIRL3', 'CHEF': 'GSMAN3', 'GAUNTLET_ARCHER': 'GSMAN2',
    **{'TYPE_TUTOR_' + t: 'GSMIDDLEMAN1' for t in ('NORMAL', 'FIRE', 'WATER', 'GRASS', 'ELECTRIC', 'ICE', 'FIGHTING', 'POISON', 'GROUND',
                                                   'FLYING', 'PSYCHIC', 'BUG', 'ROCK', 'GHOST', 'DRAGON', 'DARK', 'STEEL', 'FAIRY')},
    'PAINT_FIGURE': 'GSMAN2', 'BROCK': 'GSLEADER14', 'MISTY': 'GSLEADER15', 'GBA_KID': 'GSDSBOY', 'OLD_AMBER': 'MEDAL', 'FOSSIL': '#7000', 'CLIPBOARD': 'SCROLL', 'BILL': 'MASAKI', 'SWIMMER_M_WATER': 'GSSWIMMERM', 'SWIMMER_F_WATER': 'GSSWIMMERW',
}
# Pokemon in the overworld: HeartGold's standing sprite of that species where it has one (FOLLOWER_MON_STATIC_*),
# else hg-engine's walking sprite (its tag is 2500 + the species: hg-engine has none of HeartGold's own follower
# tags, SPRITE_FOLLOWER_MON_X without STATIC, and the game stops on them)
_sprites_h = open(os.path.join(ROOT, 'include/constants/sprites.h')).read()
_static = set(re.findall(r'#define SPRITE_FOLLOWER_MON_STATIC_([A-Z0-9_]+)\s', _sprites_h))
for _n, _v in re.findall(r'#define SPECIES_([A-Z0-9_]+)\s+(\d+)', open(os.path.join(ROOT, 'engine/include/constants/species.h')).read()):
    if _n in ('NONE', 'EGG') or int(_v) == 0: continue
    SPRITE.setdefault(_n, 'FOLLOWER_MON_STATIC_' + _n if _n in _static else '#%d' % (2500 + int(_v)))
# (our own species, after hg-engine's last: tools/canvas/build_species.py)
_last = int(re.search(r'#define SPECIES_PECHARUNT\s+(\d+)', open(os.path.join(ROOT, 'engine/include/constants/species.h')).read()).group(1))
for _n, _v in re.findall(r'#define SPECIES_([A-Z0-9_]+)\s+\(MAX_CANONICAL_MON_NUM \+ (\d+)\)', open(os.path.join(ROOT, 'engine/include/constants/species.h')).read()):
    SPRITE.setdefault(_n, '#%d' % (2500 + _last + int(_v)))

NO_OPS = ('addpcitem', 'opendoor', 'closedoor', 'waitdooranim', 'signmsg', 'normalmsg', 'waitstate', 'savebgm',
          'fadeoutbgm', 'fadeinbgm', 'showmonpic', 'hidemonpic', 'setrespawn')
MOVETYPE = {'MOVEMENT_TYPE_NONE': 0, 'MOVEMENT_TYPE_LOOK_AROUND': 2, 'MOVEMENT_TYPE_WANDER_AROUND': 3,
            'MOVEMENT_TYPE_WANDER_UP_AND_DOWN': 4, 'MOVEMENT_TYPE_WANDER_LEFT_AND_RIGHT': 5, 'MOVEMENT_TYPE_FACE_UP': 14,
            'MOVEMENT_TYPE_FACE_DOWN': 15, 'MOVEMENT_TYPE_FACE_LEFT': 16, 'MOVEMENT_TYPE_FACE_RIGHT': 17}
FACING = {14: 0, 15: 1, 16: 2, 17: 3}

# HeartGold's (hg-engine's) type numbers; the GBA game numbers them differently
HG_TYPES = ['NORMAL', 'FIGHTING', 'FLYING', 'POISON', 'GROUND', 'ROCK', 'BUG', 'GHOST', 'STEEL', 'FAIRY', 'FIRE', 'WATER',
            'GRASS', 'ELECTRIC', 'PSYCHIC', 'ICE', 'DRAGON', 'DARK']
HG_DEFINES = {}
for _h in ('include/constants/items.h', 'include/constants/species.h', 'include/constants/moves.h'):
    for _n in re.findall(r'#define\s+((?:ITEM|SPECIES|MOVE)_\w+)\s', open(os.path.join(ROOT, _h)).read()):
        HG_DEFINES[_n] = True

# hg-engine's own items, Pokemon and moves (newer than HeartGold): scripts use their numbers
ENGINE_DEFINES = {}
for _h in ('item.h', 'species.h', 'moves.h'):
    for _n, _v in re.findall(r'#define\s+((?:ITEM|SPECIES|MOVE)_\w+)\s+(\d+)', open(os.path.join(ROOT, 'engine/include/constants', _h)).read()):
        ENGINE_DEFINES.setdefault(_n, _v)

def _multichoices():
    """the GBA game's fixed menus (src/data/script_menu.h): MULTI_* -> [item text]"""
    src = open(G.P('src/data/script_menu.h')).read()
    strings = {}
    for f in ('src/strings.c',):
        try: t = open(G.P(f)).read()
        except OSError: continue
        for n, v in re.findall(r'const u8 (gText_\w+)\[\]\s*=\s*_\("((?:[^"\\]|\\.)*)"\)', t): strings[n] = v
    lists = {}
    for n, body in re.findall(r'MenuAction (\w+)\[\]\s*=\s*\{(.*?)\n\};', src, re.S):
        items = []
        for m in re.finditer(r'\{\s*(?:COMPOUND_STRING\("((?:[^"\\]|\\.)*)"\)|(gText_\w+))', body):
            items.append(m.group(1) if m.group(1) is not None else strings.get(m.group(2), m.group(2)))
        lists[n] = [re.sub(r'\{CLEAR_TO \d+\}', '  ', re.sub(r'\{FONT_\w+\}', '', i)) for i in items]
    out = {}
    for k, n in re.findall(r'\[(MULTI_\w+)\]\s*=\s*MULTICHOICE\((\w+)\)', src):
        if n in lists: out[k] = lists[n]
    return out


MULTICHOICES = _multichoices()

SYS_FLAGS = {'FLAG_SYS_GAME_CLEAR': 'FLAG_GAME_CLEAR'}      # GBA flags that are HeartGold's own
HG_NAMES = {'ITEM_PARALYZE_HEAL': 'ITEM_PARLYZ_HEAL', 'ITEM_TINY_MUSHROOM': 'ITEM_TINYMUSHROOM',
            'ITEM_BIG_MUSHROOM': 'ITEM_BIGMUSHROOM', 'ITEM_X_SP_ATK': 'ITEM_X_SPECIAL', 'ITEM_X_SP_DEF': 'ITEM_X_SP__DEF',
            'ITEM_THUNDER_STONE': 'ITEM_THUNDERSTONE', 'ITEM_SILK_SCARF': 'ITEM_SILK_SCARF', 'ITEM_BLACK_GLASSES': 'ITEM_BLACKGLASSES',
            'ITEM_NEVER_MELT_ICE': 'ITEM_NEVERMELTICE', 'ITEM_TWISTED_SPOON': 'ITEM_TWISTEDSPOON', 'ITEM_DEEP_SEA_TOOTH': 'ITEM_DEEPSEATOOTH',
            'ITEM_DEEP_SEA_SCALE': 'ITEM_DEEPSEASCALE', 'ITEM_ENERGY_POWDER': 'ITEM_ENERGYPOWDER', 'ITEM_HP_UP': 'ITEM_HP_UP'}
# the GBA's scripts for things anyone can use (cut a tree, smash a rock...) -> HeartGold's
STD_CALLS = {   # GBA shared scripts that HeartGold has its own of
    'EventScript_PkmnCenterNurse_Frlg': ['SetVar VAR_SPECIAL_x8007, 0', 'CallStd std_nurse_joy'],
    'EventScript_PkmnCenterNurse': ['SetVar VAR_SPECIAL_x8007, 0', 'CallStd std_nurse_joy'],
}
STD_OBJECT_SCRIPTS = {'EventScript_CutTree': 'std_field_cut', 'EventScript_RockSmash': 'std_field_rock_smash',
                      'EventScript_StrengthBoulder': 'std_field_strength'}
BGM = {'MUS_RG_ENCOUNTER_RIVAL': 'SEQ_GS_E_RIVAL1', 'MUS_RG_RIVAL_EXIT': 'SEQ_GS_E_RIVAL2', 'MUS_RG_OAK': 'SEQ_GS_OHKIDO',
       'MUS_RG_FOLLOW_ME': 'SEQ_GS_E_TSURETEKE1', 'MUS_FOLLOW_ME': 'SEQ_GS_E_TSURETEKE1', 'MUS_RG_ENCOUNTER_ROCKET': 'SEQ_GS_EYE_ROCKET',
       'MUS_RG_ENCOUNTER_BOY': 'SEQ_GS_EYE_K_SHOUNEN', 'MUS_RG_ENCOUNTER_GIRL': 'SEQ_GS_EYE_K_SHOUJO',
       'MUS_RG_SLOW_PALLET': 'SEQ_GS_T_MASARA', 'MUS_RG_PALLET': 'SEQ_GS_T_MASARA', 'MUS_POKE_CENTER': 'SEQ_GS_POKESEN',
       'MUS_RG_POKE_CENTER': 'SEQ_GS_POKESEN', 'MUS_RG_ENCOUNTER_GYM_LEADER': 'SEQ_GS_GYM', 'MUS_RG_GYM': 'SEQ_GS_GYM',
       'MUS_RG_POKE_MANSION': 'SEQ_GS_D_AJITO', 'MUS_RG_ENCOUNTER_DEOXYS': 'SEQ_GS_E_ARCEUS'}
SCRATCH = ('0x401E', '0x401F')
MENU_PAGE, MENU_MORE = 6, 254
OWN_TEXT = {'cv_more': ['More…']}       # free temp vars (the GBA's VAR_TEMP_0..F are 0x4000..0x400F)

STEP = {'up': 'North', 'down': 'South', 'left': 'West', 'right': 'East'}


QUIET_STEPS = ('face_original_direction',)   # (HeartGold people turn back by themselves)


def step(cmd):
    """GBA movement step -> HeartGold movement command, or None"""
    m = re.match(r'^(walk|walk_slow|walk_fast|walk_faster|walk_fastest|walk_in_place|walk_in_place_slow|'
                 r'walk_in_place_fast|walk_in_place_faster|face|jump|jump_2|jump_in_place|player_run|slide)_(up|down|left|right)$', cmd)
    if m:
        kind, d = m.group(1), STEP[m.group(2)]
        return {'walk': 'WalkNormal', 'walk_slow': 'WalkSlow', 'walk_fast': 'WalkFast', 'walk_faster': 'WalkFaster',
                'walk_fastest': 'WalkFastest', 'walk_in_place': 'WalkOnSpotNormal', 'walk_in_place_slow': 'WalkOnSpotSlow',
                'walk_in_place_fast': 'WalkOnSpotFast', 'walk_in_place_faster': 'WalkOnSpotFaster', 'face': 'Face',
                'jump': 'JumpNearFast', 'jump_2': 'JumpFar', 'jump_in_place': 'JumpOnSpotFast', 'player_run': 'Run',
                'slide': 'WalkFastest'}[kind] + d
    simple = {'delay_1': 'Delay1', 'delay_2': 'Delay2', 'delay_4': 'Delay4', 'delay_8': 'Delay8', 'delay_16': 'Delay16',
              'emote_exclamation_mark': 'EmoteExclamationMark', 'emote_question_mark': 'EmoteQuestionMark',
              'set_invisible': 'SetInvisible', 'set_visible': 'SetVisible', 'lock_facing_direction': 'LockDir',
              'unlock_facing_direction': 'UnlockDir'}
    return simple.get(cmd)


# ---------------------------------------------------------------- scripts
class Port:
    def __init__(self, g, ids, bank, gba_map):
        self.g, self.ids, self.bank, self.gba_map = g, ids, bank, gba_map
        self.lines, self.done, self.todo, self.queue = [], set(), [], []
        self.msgs, self.msg_order = {}, []
        self.movements, self.n = {}, 0
        self.str4s = []
        self.moves = MOVES[gba_map](MAPS[gba_map][1]) if gba_map in MOVES else {}    # (walks redone for HeartGold's layout)
        self.xy = MAPS[gba_map][1]
        self.dyn, self.faded = [], False
        self.mapscript_labels = set()
        self.ox, self.oy = self.xy(0, 0)
        self.hide_flags = {}          # a person's flag -> their local ids
        self.flag_of = {}             # a person's local id -> their flag
        for o in events_json(gba_map).get('object_events', []):
            if o.get('flag') not in (None, '0', '0x0') and o.get('local_id'):
                self.hide_flags.setdefault(o['flag'], []).append(self.localid(o['local_id']))
                self.flag_of[self.localid(o['local_id'])] = o['flag']

    def msg(self, label):
        if label not in self.msgs and label in OWN_TEXT:
            self.msgs[label] = (OWN_TEXT[label], set()); self.msg_order.append(label)
        if label not in self.msgs:
            if label not in self.g.texts:
                self.todo.append('text %s missing' % label)
                self.msgs[label] = (['(missing text)'], set())
            else:
                self.msgs[label] = text(self.g.texts[label])
            self.msg_order.append(label)
        return '%s_%s' % (self.bank, label)

    def alias(self, a):
        """follow .equ names (PLAYER_STARTER_SPECIES -> VAR_TEMP_2)"""
        for _ in range(5):
            b = self.g.equ.get(a)
            if b is None or not re.match(r'^[A-Za-z_]\w*$', b): break
            a = b
        return a

    def flag(self, f):
        f = self.alias(f)
        if f in SYS_FLAGS: return SYS_FLAGS[f]
        return f if re.match(r'^(0x)?\d', f) else self.ids.flag(f)

    def var(self, v):
        v = self.alias(v)
        return v if re.match(r'^(0x)?\d', v) else self.ids.var(v)

    def val(self, a):
        """a value: number, constant, or a var"""
        a = self.alias(a)
        if a.startswith('VAR_'): return self.var(a)
        if a in ('TRUE', 'YES'): return '1'
        if a in ('FALSE', 'NO'): return '0'
        if a.startswith('TYPE_') and a[5:] in HG_TYPES: return str(HG_TYPES.index(a[5:]))
        if a.startswith('OBJ_EVENT_GFX_'):        # a person's look, for a sprite var
            gfx = a.replace('OBJ_EVENT_GFX_', '').replace('_FRLG', '')
            if gfx not in SPRITE: self.todo.append('sprite %s (as a value)' % gfx)
            spr = SPRITE.get(gfx, 'GSMAN1')
            return spr[1:] if spr.startswith('#') else 'SPRITE_' + spr
        if a in ('DIR_NORTH', 'DIR_SOUTH', 'DIR_WEST', 'DIR_EAST'): return str(['DIR_NORTH', 'DIR_SOUTH', 'DIR_WEST', 'DIR_EAST'].index(a))
        if a.startswith(('SPECIES_', 'ITEM_', 'MOVE_')):
            a = HG_NAMES.get(a, a)
            if a in HG_DEFINES: return a
            if a in ENGINE_DEFINES: return ENGINE_DEFINES[a]
            self.todo.append('constant %s not in HeartGold' % a)
            return '0'
        v = self.g.value(a)
        if v is None and re.search(r'[-+*/()]', a):         # (an expression of GBA constants: work it out)
            def one(m):
                w = self.g.value(m.group(0))
                if w is None: w = {'MAX_COINS': 9999, 'MAX_MONEY': 999999}.get(m.group(0))
                return str(w) if w is not None else m.group(0)
            e = re.sub(r'\b[A-Z_][A-Z0-9_]*\b', one, a)
            try: return str(int(eval(e, {}, {})))
            except Exception: return e
        if v is None and re.match(r'^[A-Z_][A-Z0-9_]*$', a) and not a.startswith(('SPECIES_', 'ITEM_')):
            self.todo.append('constant %s unknown' % a); return '0'
        return str(v) if v is not None else a

    def localid(self, a):
        if a in ('OBJ_EVENT_ID_PLAYER', 'LOCALID_PLAYER', '255'): return 'obj_player'
        a = self.alias(a)
        if a in LID_OVER: return str(LID_OVER[a])
        if a.startswith('VAR_'): return self.var(a)
        v = self.g.value(a)
        if v is None and re.search(r'[-+*/()]', a):         # (an expression of GBA constants: work it out)
            def one(m):
                w = self.g.value(m.group(0))
                if w is None: w = {'MAX_COINS': 9999, 'MAX_MONEY': 999999}.get(m.group(0))
                return str(w) if w is not None else m.group(0)
            e = re.sub(r'\b[A-Z_][A-Z0-9_]*\b', one, a)
            try: return str(int(eval(e, {}, {})))
            except Exception: return e
        if v is None and re.match(r'^[A-Z_][A-Z0-9_]*$', a) and not a.startswith(('SPECIES_', 'ITEM_')):
            self.todo.append('constant %s unknown' % a); return '0'
        return str(v) if v is not None else a

    def label(self, l):
        if l not in self.done and l not in self.queue: self.queue.append(l)
        return l

    def new(self, tag):
        self.n += 1
        return '_cv_%s_%d' % (tag, self.n)

    def emit(self, *ls):
        if getattr(self, 'cur', None) in self.mapscript_labels:
            ls = [map_safe(l) for l in ls]
        self.lines.extend('\t' + l if not l.endswith(':') else l for l in ls)

    def say(self, label, wait=True):
        if label == 'gStringVar4':           # (a line a special picked: see str4)
            self.emit('Call _cv_str4')
            if wait: self.emit('WaitButton')
            return
        m = self.msg(label)
        bufs = self.msgs[label][1]
        if 'player' in bufs: self.emit('BufferPlayersName 6')
        if 'rival' in bufs: self.emit('BufferRivalsName 7')
        self.emit('NPCMsg %s' % m)
        if wait: self.emit('WaitButton')

    def str4(self, key, gba_text):
        """A line the GBA game builds in C into gStringVar4: it becomes one of this map's messages, and the special
        that picks it sets SCRATCH[1] to its number; `msgbox gStringVar4` shows the one picked. -> its number"""
        if key not in self.msgs:
            self.msgs[key] = text(gba_text); self.msg_order.append(key)
        if key not in self.str4s: self.str4s.append(key)
        return self.str4s.index(key) + 1

    def own_msg(self, key, text):
        """a message of our own in this map's bank -> its id"""
        if key not in self.msgs:
            self.msgs[key] = ([text], set()); self.msg_order.append(key)
        return '%s_%s' % (self.bank, key)

    def stop(self, label):
        """a command we can't do yet: a person stops here and says so (map scripts just carry on past it)"""
        if label not in self.mapscript_labels:
            self.emit('GoTo _cv_stop')

    def strvar(self, a):
        return int(a[-1]) - 1 if a.startswith('STR_VAR_') else int(self.val(a))

    def place(self, x, y):
        """a GBA square (numbers, constants or vars) -> this map's x, z (vars go through the scratch vars)"""
        x, y = self.alias(x), self.alias(y)
        vx, vy = self.g.value(x), self.g.value(y)
        if vx is not None and vy is not None and not x.startswith('VAR_') and not y.startswith('VAR_'):
            return tuple(str(c) for c in self.xy(vx, vy))
        out = []
        for v, o, s in ((x, self.ox, SCRATCH[0]), (y, self.oy, SCRATCH[1])):
            if v.startswith('VAR_'):
                self.emit('CopyVar %s, %s' % (s, self.var(v)))
                if o: self.emit('AddVar %s, %d' % (s, o))
                out.append(s)
            else:
                out.append(str(self.g.value(v) + o))
        return tuple(out)

    def face_movement(self, d):
        l = '_cv_face_%d' % d
        self.movements[l] = [[['FaceNorth', 'FaceSouth', 'FaceWest', 'FaceEast'][d], 1]]
        return l

    def warp(self, a):
        dest = G.map_dir(a[0])
        if dest in MAPS: slot, xy = MAPS[dest][:2]
        elif a[0] in slots.ROOM_SLOTS: slot, xy = slots.ROOM_SLOTS[a[0]], same    # (rooms built from the GBA layouts)
        else: return None
        if len(a) >= 3:
            x, y = self.g.value(a[1]), self.g.value(a[2])
        else:
            w = G.map_json(dest)['warp_events'][self.g.value(a[1])]
            x, y = w['x'], w['y']
        if x is None or y is None: return None
        return (slot,) + tuple(xy(x, y))

    def item(self, cmd, item, n):
        if item.startswith('ITEM_') and HG_NAMES.get(item, item) not in HG_DEFINES and item not in ENGINE_DEFINES:
            # (an item HeartGold doesn't have yet: carried as a flag until we add it)
            f = self.flag('CV_HAS_' + item)
            if cmd in ('giveitem', 'additem'): self.emit('SetFlag %s' % f, 'SetVar VAR_SPECIAL_RESULT, 1')
            elif cmd == 'removeitem': self.emit('ClearFlag %s' % f, 'SetVar VAR_SPECIAL_RESULT, 1')
            elif cmd == 'checkitemspace': self.emit('SetVar VAR_SPECIAL_RESULT, 1')
            else:
                l = self.new('has')
                self.emit('SetVar VAR_SPECIAL_RESULT, 0', 'GoToIfUnset %s, %s' % (f, l), 'SetVar VAR_SPECIAL_RESULT, 1', l + ':')
            return
        it, n = self.val(item), self.val(n)
        op = {'giveitem': 'GiveItem', 'additem': 'GiveItem', 'checkitem': 'HasItem', 'removeitem': 'TakeItem',
              'checkitemspace': 'HasSpaceForItem'}[cmd]
        self.emit('%s %s, %s, VAR_SPECIAL_RESULT' % (op, it, n))

    def menu(self, items, ignore_b, initial):
        """a GBA dynamic multichoice -> a HeartGold list menu; B gives the GBA's MULTI_B_PRESSED (127)"""
        b = self.val(ignore_b) in ('1', 'TRUE')
        first = self.val(initial)
        if not re.match(r'^\d+$', first): first = '0'      # (HeartGold's menus start on a fixed item)
        if not items: self.todo.append('menu items pushed in another script (%s)' % self.cur)
        # (HeartGold's script menus don't scroll: a long list goes in pages of 6, with "More" between them)
        pages = [items[i:i + MENU_PAGE] for i in range(0, len(items), MENU_PAGE)] or [[]]
        names = [self.new('page') for _ in pages]
        self.emit('TouchscreenMenuHide')          # (or the list never shows: the touch screen keeps the input)
        for k, page in enumerate(pages):
            if len(pages) > 1: self.emit(names[k] + ':')
            # (the top-screen list: its window is as wide as the longest item)
            self.emit('ScrCmd_065 1, 1, %s, %d, VAR_SPECIAL_RESULT' % (first if k == 0 else '0', 0 if b else 1))
            for t, v in page: self.emit('ScrCmd_559 %s, %s' % (self.msg(t), self.val(v)))
            if len(pages) > 1: self.emit('ScrCmd_559 %s, %d' % (self.msg('cv_more'), MENU_MORE))
            self.emit('ScrCmd_067')
            if len(pages) > 1:
                self.emit('CompareVarToValue VAR_SPECIAL_RESULT, %d' % MENU_MORE, 'GoToIfEq %s' % names[(k + 1) % len(pages)])
                if k < len(pages) - 1: self.emit('GoTo %s' % names[-1] + '_end')
        if len(pages) > 1: self.emit(names[-1] + '_end:')
        self.emit('TouchscreenMenuShow')
        l = self.new('menu')
        self.emit('CompareVarToValue VAR_SPECIAL_RESULT, 65000', 'GoToIfLt %s' % l, 'SetVar VAR_SPECIAL_RESULT, 127', l + ':')

    def trainer_battle(self, cmd, a, label):
        """a GBA trainer battle in a script of its own: if not beaten yet, the intro, the battle (lose and you black
        out), then the script ends there (or goes on to the GBA's continue-script)"""
        n = TRAINER_IDS[a[0]]
        intro = a[1] if cmd in ('trainerbattle_single', 'trainerbattle_double') else None
        cont = None
        if cmd == 'trainerbattle_single' and len(a) > 3: cont = a[3]
        if cmd == 'trainerbattle_double' and len(a) > 4: cont = a[4]
        if cmd == 'trainerbattle_no_intro' and len(a) > 2 and a[2] in self.g.labels: cont = a[2]
        beaten, won = self.new('beaten'), self.new('won')
        self.emit('CheckTrainerFlag %d' % n, 'GoToIf TRUE, %s' % beaten)
        if intro and intro in self.g.texts: self.say(intro); self.emit('CloseMsg')
        self.emit('TrainerBattle %d, 0, 0, 0' % n, 'CheckBattleWon VAR_SPECIAL_RESULT', 'CompareVarToValue VAR_SPECIAL_RESULT, 0',
                  'GoToIfNe %s' % won, 'WhiteOut', 'End', won + ':', 'SetTrainerFlag %d' % n)
        if cont: self.emit('GoTo %s' % self.label(cont))
        else: self.emit('ReleaseAll', 'End')
        self.emit(beaten + ':')

    def rival_battle(self, trainer, lose_ok):
        """the rival's team is the one for this stage and the type he took (VAR_RIVAL_TYPE)"""
        teams = RIVAL_TEAMS.get(RIVAL_STAGES[trainer], {})
        done = self.new('battle')
        rv = self.var('VAR_RIVAL_TYPE')
        for t, num in sorted(teams.items()):
            nxt = self.new('next')
            self.emit('CompareVarToValue %s, %s' % (rv, self.val('TYPE_' + t)), 'GoToIfNe %s' % nxt,
                      'TrainerBattle %d, 0, %d, 0' % (num, 1 if lose_ok else 0), 'GoTo %s' % done, nxt + ':')
        self.emit('TrainerBattle %d, 0, %d, 0' % (min(teams.values()), 1 if lose_ok else 0), done + ':')
        if not lose_ok:
            won = self.new('won')
            self.emit('CheckBattleWon VAR_SPECIAL_RESULT', 'CompareVarToValue VAR_SPECIAL_RESULT, 0', 'GoToIfNe %s' % won,
                      'WhiteOut', 'End', won + ':')
        self.emit('SetFlag %s' % self.flag('CV_DEFEATED_' + trainer))

    def cond(self, kind, a, b, dest, call=False):
        va = self.var(a)
        if b.startswith('VAR_'): self.emit('CompareVarToVar %s, %s' % (va, self.var(b)))
        else: self.emit('CompareVarToValue %s, %s' % (va, self.val(b)))
        self.emit('%s%s %s' % ('CallIf' if call else 'GoToIf', kind, self.label(dest)))

    def script(self, label):
        """translate one label's commands (recursively queues what it reaches)"""
        if label in self.done: return
        self.done.add(label)
        cmds = self.g.labels.get(label)
        if cmds is None and label in self.moves:
            return self.movement(label, self.moves[label])
        if cmds is None:
            self.todo.append('script %s missing' % label)
            self.movements[label] = []          # (made in C in the GBA game: a still movement here, for now)
            return
        if label in self.moves:
            return self.movement(label, self.moves[label])
        if cmds and step(cmds[0][0]) is not None or (cmds and cmds[0][0] in ('step_end', 'face_player', 'face_away_player') + QUIET_STEPS):
            return self.movement(label, cmds)
        self.emit('', label + ':')
        self.cur, self.dyn = label, []
        removed = set()
        open_msg = False
        sw = None
        insert = INSERTS.get(label)
        if insert and insert[0] is None:          # (at the very start)
            self.emit(*insert[1](self)); insert = None
        for cmd, a in cmds:
            if insert and cmd == insert[0]:
                self.emit(*(insert[1](self) if callable(insert[1]) else [l.format(flag=_Lookup(self.flag)) for l in insert[1]]))
                insert = None
            close = ['CloseMsg'] if open_msg else []
            if cmd == 'end':
                self.emit(*close, 'End'); open_msg = False
            elif cmd == 'return': self.emit('Return')
            elif cmd == 'cv_raw': self.emit(*a)
            elif cmd in ('lock', 'lockall'): self.emit('LockAll')
            elif cmd in ('release', 'releaseall'): self.emit(*close, 'ReleaseAll'); open_msg = False
            elif cmd == 'faceplayer': self.emit('FacePlayer')
            elif cmd == 'goto': self.emit('GoTo %s' % self.label(a[0]))
            elif cmd == 'call' and a[0] in STD_CALLS: self.emit(*STD_CALLS[a[0]])
            elif cmd == 'call': self.emit('Call %s' % self.label(a[0]))
            elif cmd == 'msgbox':
                kind = a[1] if len(a) > 1 else 'MSGBOX_DEFAULT'
                if kind == 'MSGBOX_NPC':
                    self.emit('PlaySE SEQ_SE_DP_SELECT', 'LockAll', 'FacePlayer'); self.say(a[0])
                    self.emit('CloseMsg', 'ReleaseAll'); open_msg = False
                elif kind == 'MSGBOX_SIGN':
                    self.emit('PlaySE SEQ_SE_DP_SELECT', 'LockAll'); self.say(a[0]); self.emit('CloseMsg', 'ReleaseAll'); open_msg = False
                elif kind == 'MSGBOX_YESNO':
                    self.say(a[0], wait=False)
                    yes, done = self.new('yes'), self.new('yn')
                    # (HeartGold's YesNo gives 0 for yes; the GBA scripts expect YES = 1)
                    self.emit('YesNo VAR_SPECIAL_RESULT', 'CompareVarToValue VAR_SPECIAL_RESULT, 0', 'GoToIfEq %s' % yes,
                              'SetVar VAR_SPECIAL_RESULT, 0', 'GoTo %s' % done, yes + ':', 'SetVar VAR_SPECIAL_RESULT, 1', done + ':')
                    open_msg = True
                elif kind == 'MSGBOX_AUTOCLOSE':
                    self.say(a[0]); self.emit('CloseMsg'); open_msg = False
                else:
                    self.say(a[0]); open_msg = True
            elif cmd == 'message': self.say(a[0], wait=False); open_msg = True
            elif cmd in ('waitmessage', 'textcolor', 'famechecker', 'setflashlevel'): pass
            elif cmd == 'waitbuttonpress': self.emit('WaitButton')
            elif cmd == 'closemessage': self.emit('CloseMsg'); open_msg = False
            elif cmd == 'setflag':
                self.emit('SetFlag %s' % self.flag(a[0]))
                if self.alias(a[0]) == 'FLAG_SYS_POKEDEX_GET': self.emit('GivePokedex')
                if self.alias(a[0]) == 'FLAG_SYS_B_DASH': self.emit('GiveRunningShoes')
            elif cmd == 'setworldmapflag':     # (where you've been: HeartGold's Fly points)
                m = re.match(r'FLAG_WORLD_MAP_(\w+?)(_CITY|_TOWN|_ISLAND)?$', a[0])
                town = m and {'PALLET': 'PALLET', 'VIRIDIAN': 'VIRIDIAN', 'PEWTER': 'PEWTER', 'CERULEAN': 'CERULEAN',
                              'LAVENDER': 'LAVENDER', 'VERMILION': 'VERMILION', 'CELADON': 'CELADON', 'FUCHSIA': 'FUCHSIA',
                              'CINNABAR': 'CINNABAR', 'SAFFRON': 'SAFFRON', 'INDIGO_PLATEAU_EXTERIOR': 'INDIGO'}.get(m.group(1))
                if town: self.emit('SetFlag FLAG_SYS_FLYPOINT_%s' % town)
            elif cmd == 'clearflag':
                self.emit('ClearFlag %s' % self.flag(a[0]))
                # (the GBA game brings a removed person back as soon as their flag is clear and they're in view;
                # HeartGold only on the next map load)
                for lid in self.hide_flags.get(self.alias(a[0]), []):
                    if lid in removed: self.emit('ShowPerson %s' % lid)
            elif cmd in ('goto_if_set', 'goto_if_unset', 'call_if_set', 'call_if_unset'):
                self.emit('%sIf%s %s, %s' % ('GoTo' if cmd.startswith('goto') else 'Call', 'Set' if cmd.endswith('_set') else 'Unset',
                                             self.flag(a[0]), self.label(a[1])))
            elif re.match(r'^(goto|call)_if_(eq|ne|lt|gt|le|ge)$', cmd):
                kind = cmd.split('_')[-1].capitalize()
                self.cond(kind, a[0], a[1], a[2], call=cmd.startswith('call'))
            elif cmd == 'setvar':
                if a[0] == 'VAR_0x8004': self.v8004 = a[1]          # (a scrollable list's id, for ShowScrollableMultichoice)
                self.emit('SetVar %s, %s' % (self.var(a[0]), self.val(a[1])))
            elif cmd == 'special' and a[0] == 'ShowScrollableMultichoice' and getattr(self, 'v8004', None) in SCROLL_LISTS:
                items = []
                for i, t in enumerate(SCROLL_LISTS[self.v8004]):
                    key = 'cv_sm_%s_%d' % (self.v8004[13:].lower(), i)
                    if key not in self.msgs: self.msgs[key] = text(t); self.msg_order.append(key)
                    items.append((key, str(i)))
                self.menu(items, '0', '0')
            elif cmd == 'setdynamicwarp':
                to = dynamic_warp(a[0], int(self.val(a[2])), int(self.val(a[3])))
                if to is None:
                    self.emit('// TODO(gba) setdynamicwarp %s' % a[0]); self.todo.append('setdynamicwarp %s (%s)' % (a[0], label))
                else: self.emit('SetDynamicWarp %s, %d, %d, %d, 1' % to)
            elif cmd == 'addvar': self.emit('AddVar %s, %s' % (self.var(a[0]), self.val(a[1])))
            elif cmd == 'subvar': self.emit('SubVar %s, %s' % (self.var(a[0]), self.val(a[1])))
            elif cmd == 'copyvar': self.emit('CopyVar %s, %s' % (self.var(a[0]), self.var(a[1])))
            elif cmd == 'switch': sw = a[0]
            elif cmd == 'case' and sw: self.cond('Eq', sw, a[0], a[1])
            elif cmd == 'applymovement' and a[1] == 'Common_Movement_FacePlayer':
                self.emit('FacePlayer')            # (HeartGold has no 'face the player' movement step)
            elif cmd == 'applymovement':
                self.emit('ApplyMovement %s, %s' % (self.localid(a[0]), self.label(a[1])))
            elif cmd == 'waitmovement': self.emit('WaitMovement')
            elif cmd == 'removeobject':
                # (the GBA sets the person's flag as it removes them; HeartGold only deletes the object)
                lid = self.localid(a[0])
                self.emit('HidePerson %s' % lid); removed.add(lid)
                if lid in self.flag_of: self.emit('SetFlag %s' % self.flag(self.flag_of[lid]))
            elif cmd == 'addobject':
                # (the GBA shows a person whatever their flag says, and leaves the flag alone; HeartGold won't show one
                # whose flag is set)
                lid = self.localid(a[0])
                if lid in self.flag_of:
                    f, plain, done = self.flag(self.flag_of[lid]), self.new('show'), self.new('shown')
                    self.emit('GoToIfUnset %s, %s' % (f, plain), 'ClearFlag %s' % f, 'ShowPerson %s' % lid, 'SetFlag %s' % f,
                              'GoTo %s' % done, plain + ':', 'ShowPerson %s' % lid, done + ':')
                else:
                    self.emit('ShowPerson %s' % lid)
            elif cmd == 'delay': self.emit('Wait %s, VAR_SPECIAL_RESULT' % self.val(a[0]))
            elif cmd == 'playse': self.emit('PlaySE %s' % SE.get(a[0], 'SEQ_SE_DP_SELECT'))
            elif cmd == 'waitse': self.emit('WaitSE SEQ_SE_DP_SELECT')
            elif cmd == 'playfanfare': self.emit('PlayFanfare %s' % FANFARE.get(a[0], 'SEQ_ME_ITEM'))
            elif cmd == 'msgreceiveditem':      # (the message with the item fanfare; the item itself is given apart)
                self.emit('PlayFanfare %s' % FANFARE.get(a[3] if len(a) > 3 else '', 'SEQ_ME_ITEM')); self.say(a[0], wait=False)
                self.emit('WaitFanfare', 'WaitButton'); open_msg = True
            elif cmd == 'waitfanfare': self.emit('WaitFanfare')
            elif cmd == 'checkplayergender': self.emit('GetPlayerGender VAR_SPECIAL_RESULT')
            elif cmd == 'playmoncry': self.emit('PlayCry %s, 0' % self.val(a[0]))
            elif cmd == 'waitmoncry': self.emit('WaitCry')
            elif cmd == 'specialvar':
                lines = SP.special(self, a[1], self.var(a[0]))
                if lines is None:
                    self.emit('SetVar %s, 0  // TODO(gba) specialvar %s' % (self.var(a[0]), a[1])); self.todo.append('special %s (%s)' % (a[1], label)); self.stop(label)
                else: self.emit(*lines)
            elif cmd == 'showmoneybox': self.emit('ShowMoneyBox 20, 2')
            elif cmd == 'hidemoneybox': self.emit('HideMoneyBox')
            elif cmd == 'updatemoneybox': self.emit('UpdateMoneyBox')
            elif cmd == 'checkmoney': self.emit('HasEnoughMoneyImmediate VAR_SPECIAL_RESULT, %s' % self.val(a[0]))
            elif cmd == 'removemoney': self.emit('SubMoneyImmediate %s' % self.val(a[0]))
            elif cmd == 'addmoney': self.emit('AddMoney %s' % self.val(a[0]))
            elif cmd == 'set_gym_trainers_frlg':
                self.emit('SetVar %s, %s' % (self.var('VAR_0x8008'), self.val(a[0])),
                          'Call %s' % self.label('Common_EventScript_SetGymTrainers_Frlg'))
            elif cmd == 'special':
                lines = SP.special(self, a[0], None)
                if lines is None:
                    self.emit('// TODO(gba) special %s' % a[0]); self.todo.append('special %s (%s)' % (a[0], label)); self.stop(label)
                else: self.emit(*lines)
            elif cmd in ('fadescreen', 'fadescreenswapbuffers', 'fadescreenspeed'):
                mode = self.g.value(a[0])
                to = mode in (1, 3)
                self.emit('FadeScreen 6, 1, %d, %s' % (0 if to else 1, 'RGB_WHITE' if mode in (2, 3) else 'RGB_BLACK'), 'WaitFade')
                self.faded = to
            elif cmd == 'setobjectxyperm':
                self.emit('MovePerson %s, %s, %s' % ((self.localid(a[0]),) + self.place(a[1], a[2])))
            elif cmd == 'copyobjectxytoperm':
                self.emit('GetPersonCoords %s, %s, %s' % (self.localid(a[0]), SCRATCH[0], SCRATCH[1]),
                          'MovePerson %s, %s, %s' % (self.localid(a[0]), SCRATCH[0], SCRATCH[1]))
            elif cmd == 'getplayerxy':
                vx, vy = self.var(a[0]), self.var(a[1])
                self.emit('GetPlayerCoords %s, %s' % (vx, vy))
                if self.ox: self.emit('SubVar %s, %d' % (vx, self.ox))
                if self.oy: self.emit('SubVar %s, %d' % (vy, self.oy))
            elif cmd == 'setobjectmovementtype':
                mv = MOVETYPE.get(a[1])
                if mv is None:
                    self.emit('// TODO(gba) %s %s' % (cmd, ', '.join(a))); self.todo.append('%s %s (%s)' % (cmd, a[1], label)); self.stop(label)
                else:
                    self.emit('SetObjectMovementType %s, %d' % (self.localid(a[0]), mv))
                    if mv in FACING: self.emit('SetObjectFacing %s, %d' % (self.localid(a[0]), FACING[mv]))
            elif cmd == 'turnobject':
                d = {'DIR_NORTH': 0, 'DIR_SOUTH': 1, 'DIR_WEST': 2, 'DIR_EAST': 3}.get(a[1])
                self.emit('ApplyMovement %s, %s' % (self.localid(a[0]), self.face_movement(d)), 'WaitMovement')
            elif cmd == 'warp' or cmd == 'warpsilent':
                w = self.warp(a)
                if w is None:
                    self.emit('// TODO(gba) %s %s' % (cmd, ', '.join(a))); self.todo.append('%s %s (%s)' % (cmd, a[0], label)); self.stop(label)
                else:
                    if not self.faded: self.emit('FadeScreen 6, 1, 0, RGB_BLACK', 'WaitFade')
                    self.emit('Warp %s, 0, %s, %s, DIR_SOUTH' % w, 'FadeScreen 6, 1, 1, RGB_BLACK', 'WaitFade')
                    self.faded = False
            elif cmd == 'playbgm':
                if a[0] in BGM: self.emit('PlayBGM %s' % BGM[a[0]])
                else: self.emit('// (music %s: no HeartGold match yet)' % a[0])
            elif cmd == 'fadedefaultbgm': self.emit('ResetBGM')
            elif cmd in NO_OPS: pass
            elif cmd == 'callnative' and a[0] in SP.CALLNATIVE_NO_OPS: pass
            elif cmd in ('giveitem', 'additem', 'checkitem', 'removeitem', 'checkitemspace'):
                self.item(cmd, a[0], a[1] if len(a) > 1 else '1')
            elif cmd == 'giveitem_msg':
                self.item('giveitem', a[1], a[2] if len(a) > 2 else '1')
                self.emit('BufferItemName 1, %s' % self.val(a[1]))
                self.say(a[0], wait=False)
                self.emit('PlayFanfare %s' % FANFARE.get(a[3] if len(a) > 3 else 'MUS_LEVEL_UP', 'SEQ_ME_ITEM'), 'WaitFanfare', 'WaitButton')
                open_msg = True
            elif cmd == 'buffernumberstring': self.emit('BufferInt %d, %s' % (self.strvar(a[0]), self.val(a[1])))
            elif cmd == 'bufferitemname': self.emit('BufferItemName %d, %s' % (self.strvar(a[0]), self.val(a[1])))
            elif cmd == 'bufferspeciesname': self.emit('BufferSpeciesName %d, %s, 0, 0' % (self.strvar(a[0]), self.val(a[1])))
            elif cmd == 'buffermovename': self.emit('BufferMoveName %d, %s' % (self.strvar(a[0]), self.val(a[1])))
            elif cmd == 'buffertypename': self.emit('BufferTypeName %d, %s' % (self.strvar(a[0]), self.val(a[1])))
            elif cmd == 'dynmultipush': self.dyn.append((a[0], a[1]))
            elif cmd == 'dynmultistack':
                if a[6] not in ('DYN_MULTICHOICE_CB_NONE', 'NULL'): self.todo.append('menu callback %s (%s)' % (a[6], label))
                self.menu(self.dyn, a[2], a[5]); self.dyn = []
            elif cmd in ('multichoice', 'multichoicedefault', 'multichoicegrid') and a[2] in MULTICHOICES:
                items = []
                for i, t in enumerate(MULTICHOICES[a[2]]):
                    key = 'cv_mc_%s_%d' % (a[2][6:].lower(), i)
                    if key not in self.msgs: self.msgs[key] = text(t); self.msg_order.append(key)
                    items.append((key, str(i)))
                self.menu(items, a[4] if cmd == 'multichoicedefault' else a[3], a[3] if cmd == 'multichoicedefault' else '0')
            elif cmd == 'random':
                self.emit('Random VAR_SPECIAL_RESULT, %s' % self.val(a[0]))
            elif cmd == 'dynmultichoice':
                if a[5] not in ('DYN_MULTICHOICE_CB_NONE', 'NULL'): self.todo.append('menu callback %s (%s)' % (a[5], label))
                self.menu([(t, str(i)) for i, t in enumerate(a[6:])], a[2], a[4])
            elif cmd == 'goto_if_defeated' and a[0] not in TRAINER_IDS:     # (the rival's battles)
                self.emit('GoToIfSet %s, %s' % (self.flag('CV_DEFEATED_' + a[0]), self.label(a[1])))
            elif cmd in ('trainerbattle_earlyrival', 'trainerbattle_no_intro', 'trainerbattle_single') and a[0] in RIVAL_STAGES:
                self.rival_battle(a[0], lose_ok=(cmd == 'trainerbattle_earlyrival'))
            elif cmd in ('cleartrainerflag', 'settrainerflag') and a[0] not in TRAINER_IDS:     # (the rival's battles)
                self.emit('%s %s' % ('ClearFlag' if cmd.startswith('clear') else 'SetFlag', self.flag('CV_DEFEATED_' + a[0])))
            elif cmd == 'finditem':
                it = self.val(a[0])
                if a[0].startswith('ITEM_') and it == '0':
                    self.item('giveitem', a[0], '1'); self.emit('HidePerson VAR_SPECIAL_LAST_TALKED')
                else:
                    self.emit('SetVar 0x8004, %s' % it, 'SetVar 0x8005, %s' % (self.val(a[1]) if len(a) > 1 else '1'),
                              'CallStd std_obtain_item_verbose', 'HidePerson VAR_SPECIAL_LAST_TALKED')
            elif cmd in ('pokemart', 'pokemartdecoration'):
                items = []
                for c2, a2 in self.g.labels.get(a[0], []):
                    if c2 != '.2byte' or a2[0] in ('ITEM_NONE', '0'): break
                    v = self.val(a2[0])
                    if v != '0': items.append(v)
                self.emit('CanvasMart %d' % len(items), *['.short %s' % v for v in items])
            elif cmd.startswith('trainerbattle') and a and a[0] in TRAINER_IDS and not cmd.startswith('trainerbattle_rematch'):
                self.trainer_battle(cmd, a, label)
            elif cmd.startswith('trainerbattle_rematch'):
                self.emit('// (rematches come later)', 'ReleaseAll', 'End')
            elif cmd in ('checktrainerflag', 'goto_if_defeated', 'goto_if_not_defeated') and a[0] in TRAINER_IDS:
                n = TRAINER_IDS[a[0]]
                if cmd == 'checktrainerflag':
                    l = self.new('tr')
                    self.emit('SetVar VAR_SPECIAL_RESULT, 0', 'CheckTrainerFlag %d' % n, 'GoToIf FALSE, %s' % l, 'SetVar VAR_SPECIAL_RESULT, 1', l + ':')
                else:
                    self.emit('CheckTrainerFlag %d' % n, 'GoToIf %s, %s' % ('TRUE' if cmd == 'goto_if_defeated' else 'FALSE', self.label(a[1])))
            elif cmd in ('settrainerflag', 'cleartrainerflag') and a[0] in TRAINER_IDS:
                self.emit('%s %d' % ('SetTrainerFlag' if cmd.startswith('set') else 'ClearTrainerFlag', TRAINER_IDS[a[0]]))
            elif cmd == 'givemon':
                pos = [x for x in a if '=' not in x]
                kw = dict(x.split('=', 1) for x in a if '=' in x)
                if set(kw) - {'item'}: self.todo.append('givemon %s (%s)' % (', '.join(sorted(kw)), label))
                item = kw.get('item', pos[2] if len(pos) > 2 else '0')
                self.emit('GiveMon %s, %s, %s, 0, 0, VAR_SPECIAL_RESULT' % (self.val(pos[0]), self.val(pos[1]), self.val(item)))
            else:
                self.emit('// TODO(gba) %s %s' % (cmd, ', '.join(a))); self.todo.append('%s (%s)' % (cmd, label)); self.stop(label)
        if not cmds or cmds[-1][0] not in ('end', 'return', 'goto'):
            self.emit('End')

    def movement(self, label, cmds):
        out = []
        for cmd, a in cmds:
            if cmd == 'step_end': break
            s = step(cmd)
            if s is None and cmd in QUIET_STEPS: continue
            if s is None:
                if cmd in ('face_player', 'face_away_player'):
                    s = None; self.todo.append('movement %s (%s)' % (cmd, label))
                else:
                    self.todo.append('movement %s (%s)' % (cmd, label))
                continue
            if out and out[-1][0] == s: out[-1][1] += 1
            else: out.append([s, 1])
        self.movements[label] = out

    def run(self, entry_points):
        for e in entry_points: self.label(e)
        while self.queue:
            self.script(self.queue.pop(0))


def write_messages(port, msg_file):
    path = os.path.join(MSG, msg_file)
    old = json.load(open(path)) if os.path.exists(path) else {'key': 0x4A2B}
    out = {'key': old['key'], 'messages': []}
    for label in port.msg_order:
        lines = port.msgs[label][0]
        out['messages'].append({'id': '%s_%s' % (port.bank, label), 'en_US': lines if len(lines) > 1 else lines[0]})
    if not out['messages']:
        out['messages'].append({'id': '%s_unused' % port.bank, 'en_US': ''})
    json.dump(out, open(path, 'w'), indent=2, ensure_ascii=False)
    open(path, 'a').write('\n')


_crefs = []


def c_object_refs():
    if not _crefs:
        for d, _, fs in os.walk(os.path.join(ROOT, 'src')):
            for f in fs:
                if f.endswith('.c'): _crefs.extend(re.findall(r'\bobj_[A-Z0-9]+_\w+', open(os.path.join(d, f), errors='replace').read()))
        _crefs.append('')
    return set(_crefs) - {''}


def shared_banks(slot):
    """another map uses this map's scripts or text (a copy of a room, two halves of a route): writing ours over them
    would break it"""
    h = slots.header(slot)
    txt = open(os.path.join(ROOT, 'src/data/map_headers.h')).read() + open(slots.CANVAS_HEADERS).read()
    return any(txt.count('= %s,' % h[k]) > 1 for k in ('scriptsBank', 'msgBank'))


def own_banks(slot):
    """A map in one of our slots still shares HeartGold's EVERYWHERE scripts and text: give it files of its own
    (script, map-script header, event header, message bank), numbered after HeartGold's"""
    tag = 'CV_' + slot.replace('MAP_', '')
    names = sorted(os.listdir(SCR))
    have = [n for n in names if n.startswith('scr_seq_') and n.endswith('_%s.s' % tag)]
    if have:
        num = int(have[0].split('_')[2])
    else:
        num = max(int(n.split('_')[2].split('.')[0]) for n in names if re.match(r'scr_seq_\d{4}', n)) + 1
    scr, hdr = 'scr_seq_%04d_%s.s' % (num, tag), 'scr_seq_%04d_%s_hdr.s' % (num + 1, tag)
    if not have:
        hdr = 'scr_seq_%04d_%s_hdr.s' % (num + 1, tag)
    else:
        hdr = [n for n in names if n.endswith('_%s_hdr.s' % tag)][0]
    msgs = sorted(os.listdir(MSG))
    mh = [n for n in msgs if n.endswith('_%s.json' % tag)]
    mnum = int(mh[0].split('_')[1]) if mh else max(int(n.split('_')[1].split('.')[0]) for n in msgs if re.match(r'msg_\d{4}', n)) + 1
    msg = 'msg_%04d_%s.json' % (mnum, tag)
    for f in (os.path.join(SCR, scr), os.path.join(SCR, hdr)):
        if not os.path.exists(f): open(f, 'w').write('')
    if not os.path.exists(os.path.join(MSG, msg)):
        json.dump({'key': 0x4A2B + mnum, 'messages': []}, open(os.path.join(MSG, msg), 'w'))
    meson = os.path.join(SCR, 'meson.build')
    m = open(meson).read()
    if "'%s'" % scr not in m:
        i = m.index('scr_seq_asm = files(')
        j = m.index(')', i)
        m = m[:j] + "    '%s',\n    '%s',\n" % (scr, hdr) + m[j:]
        i = m.index('scr_seq_event_headers = files(')
        j = m.index(')', i)
        m = m[:j] + "    'event_%s.h',\n" % tag + m[j:]
        open(meson, 'w').write(m)
    txt = os.path.join(ROOT, 'files/msgdata/NARC_msg.txt')
    t = open(txt).read()
    const = 'NARC_msg_%s_bin' % msg[:-5]
    if const not in t:
        open(txt, 'w').write(t.rstrip('\n') + '\n' + const + '\n')
    slots.set_header(slot, {'scriptsBank': scr[:-2] + '_bin', 'scriptHeaderBank': hdr[:-2] + '_bin', 'msgBank': msg[:-5]})


def port(gba_map, g, ids, report):
    slot, xy = MAPS[gba_map][:2]
    part = MAPS[gba_map][2] if len(MAPS[gba_map]) > 2 else (lambda x, y: True)   # (a GBA map split over two of HeartGold's)
    if 'EVERYWHERE' in slots.header(slot)['scriptsBank'] or shared_banks(slot):
        own_banks(slot)
    h = slots.header(slot)
    bank = h['msgBank']                           # e.g. msg_0446_T01
    scr = h['scriptsBank'][:-4] + '.s'           # scr_seq_0735_T01_bin -> scr_seq_0735_T01.s
    hdr = h['scriptHeaderBank'][:-4] + '.s'
    tag = re.match(r'scr_seq_\d+_(\w+)$', scr[:-2]).group(1)
    ev_path = os.path.join(slots.EVENT_DIR, slots.events_file(slot))
    ev = json.load(open(ev_path))
    if isinstance(xy, Anchored):
        # HeartGold's own events, as they were before we ported over them (its signs are where signs go)
        snap = os.path.join(os.path.dirname(HERE), 'data', 'hg_events', os.path.basename(ev_path))
        if not os.path.exists(snap):
            os.makedirs(os.path.dirname(snap), exist_ok=True)
            json.dump(ev, open(snap, 'w'), indent=1)
        xy.hg_signs = [(b['x'], b['z']) for b in json.load(open(snap)).get('bgs', []) if not str(b.get('scriptId', '')).startswith('std_hidden')]
        xy.used = set()
        hg = json.load(open(snap)).get('objects', [])
        xy.hg_trees = [(o['x'], o['z']) for o in hg if o['spriteId'] == 'SPRITE_TREE']
        xy.hg_trainers = [(o['x'], o['z'], o['facingDirection'], o['movement'], o['param0']) for o in hg if o.get('type') == 1]
        xy.hg_items = [(o['x'], o['z']) for o in hg if o['spriteId'] == 'SPRITE_MONSTARBALL']
        xy.warps = [(w['x'], w['z']) for w in ev.get('warps', [])]
    mj = events_json(gba_map)
    p = Port(g, ids, bank, gba_map)
    # entry points: people and signs (in order), then map scripts
    entries = []
    people = [o for o in mj.get('object_events', []) if o.get('type', 'object') == 'object'
              and 'TYPE_TUTOR_DECOR' not in o['graphics_id'] and part(o['x'], o['y'])]       # (the tutors' decorations come with the tutors' own sprites)
    signs = [b for b in mj.get('bg_events', []) if b.get('type') == 'sign' and part(b['x'], b['y'])]
    # (an invisible person is something to read, such as a journal on a shelf: HeartGold reads those as signs)
    signs += [dict(o, _read=True) for o in people if o['graphics_id'] == '0' and o['movement_type'] == 'MOVEMENT_TYPE_INVISIBLE'
              and o['script'] not in ('0x0', '0')]
    people = [o for o in people if not (o['graphics_id'] == '0' and o['movement_type'] == 'MOVEMENT_TYPE_INVISIBLE')]
    if gba_map in PEOPLE: people = PEOPLE[gba_map](people)
    def trainer_of(o):
        """a trainer whose script is just their battle and a line after: HeartGold's own trainer script runs it"""
        c = g.labels.get(o['script'], [])
        if c and c[0][0] in ('trainerbattle_single', 'trainerbattle_double') and c[0][1][0] in SIMPLE_TRAINERS \
                and c[0][1][0] in TRAINER_IDS and o.get('trainer_type', 'TRAINER_TYPE_NONE') != 'TRAINER_TYPE_NONE':
            return TRAINER_IDS[c[0][1][0]]
    for o in people:
        if o['script'] not in ('0x0', '0') and o['script'] not in STD_OBJECT_SCRIPTS and o['script'] not in entries and not trainer_of(o):
            entries.append(o['script'])
    for b in signs:
        if b['script'] not in entries: entries.append(b['script'])
    triggers = [c for c in mj.get('coord_events', []) if c.get('type') == 'trigger' and c.get('script') not in ('0x0', '0', None)
                and part(c['x'], c['y'])]
    for c in triggers:
        if c['script'] not in entries: entries.append(c['script'])
    gdir = gba_map.split('#')[0].split('+')[0]
    mapscripts = [(c, a) for c, a in g.labels.get(gdir.replace('_Frlg', '') + '_Frlg_MapScripts', g.labels.get(gdir + '_MapScripts', []))]
    on = {}
    for c, a in mapscripts:
        if c == 'map_script' and a[0] in ('MAP_SCRIPT_ON_TRANSITION', 'MAP_SCRIPT_ON_LOAD', 'MAP_SCRIPT_ON_RESUME'):
            on[a[0]] = a[1]
            if a[1] not in entries: entries.append(a[1])
        elif c == 'map_script' and a[0] == 'MAP_SCRIPT_ON_FRAME_TABLE':
            for c2, a2 in g.labels.get(a[1], []):
                if c2 == 'map_script_2':
                    on.setdefault('frame', []).append(a2)
                    if a2[2] not in entries: entries.append(a2[2])
    if gba_map in GYMMICK_INIT:       # (HeartGold's slide tiles need its Viridian Gym's gymmick running)
        if 'MAP_SCRIPT_ON_TRANSITION' in on:
            INSERTS[on['MAP_SCRIPT_ON_TRANSITION']] = (None, lambda p_: ['ViridianGymInit'])
        else:
            lbl = gdir + '_cv_OnTransition'
            g.labels[lbl] = [('cv_raw', ['ViridianGymInit']), ('end', [])]
            on['MAP_SCRIPT_ON_TRANSITION'] = lbl
            entries.append(lbl)
    mapscript_entries = set(on.get(k) for k in ('MAP_SCRIPT_ON_TRANSITION', 'MAP_SCRIPT_ON_LOAD', 'MAP_SCRIPT_ON_RESUME'))
    for e in mapscript_entries:
        if e: p.mapscript_labels |= reachable(p, e)
    p.run(entries)
    p.msgs['cv_unported'] = (['(Canvas DS: this part of the game\n', 'isn’t ported yet.)'], set())
    p.msg_order.append('cv_unported')
    # People and signs run until they reach something we can't do yet, then say so (_cv_stop). Scenes (the frame
    # table) and trigger squares are left out whole until they're complete: they'd only start again and again.
    unfinished = set()
    scenes = set(a[2] for a in on.get('frame', [])) | set(c['script'] for c in triggers)
    stops = []
    for e in entries:
        if e in mapscript_entries:
            continue          # (map scripts run what they can; the TODOs are comments)
        reach = reachable(p, e)
        if any(t.endswith('(%s)' % r) for t in p.todo for r in reach):
            (unfinished.add(e) if e in scenes else stops.append(e))
    # ---- the script file
    out = ['#include "constants/scrcmd.h"', '#include "fielddata/script/scr_seq/event_%s.h"' % tag,
           '#include "msgdata/msg/%s.h"' % bank, '#include "macros/script.inc"', '',
           '// Pokemon Canvas: ported from the GBA game\'s %s by tools/canvas/port/port_map.py. Edit the GBA scripts' % gba_map,
           '// or the porter, not this file.', '']
    for e in entries:
        out.append('\tScrDef %s' % ('_cv_unported_%d' % entries.index(e) if e in unfinished else e))
    out.append('\tScrDefEnd')
    out += p.lines
    p_msg_unported = '%s_cv_unported' % bank
    for e in entries:
        if e in unfinished:
            out += ['', '_cv_unported_%d:' % entries.index(e), '\tPlaySE SEQ_SE_DP_SELECT', '\tLockAll',
                    '\tNPCMsg %s' % p_msg_unported, '\tWaitButton', '\tCloseMsg', '\tReleaseAll', '\tEnd']
    if p.str4s or any('Call _cv_str4' in l for l in p.lines):
        out += ['', '_cv_str4:', '\tBufferPlayersName 6', '\tBufferRivalsName 7']
        for i, k in enumerate(p.str4s):
            out += ['\tCompareVarToValue %s, %d' % (SCRATCH[1], i + 1), '\tGoToIfNe _cv_str4_%d' % i,
                    '\tNPCMsg %s_%s' % (bank, k), '\tReturn', '_cv_str4_%d:' % i]
        out += ['\tReturn']
    out += ['', '_cv_stop:', '\tNPCMsg %s' % p_msg_unported, '\tWaitButton', '\tCloseMsg', '\tReleaseAll', '\tEnd']
    for l, steps in p.movements.items():
        out += ['', '\t.balign 4, 0', l + ':']
        out += ['\t%s%s' % (s, ' %d' % n if n > 1 else '') for s, n in steps] + ['\tEndMovement']
    out += ['\t.balign 4, 0', '']
    open(os.path.join(SCR, scr), 'w').write('\n'.join(out))
    write_messages(p, bank + '.json')
    # ---- the map-script header
    hl = ['#include "constants/scrcmd.h"', '#include "fielddata/script/scr_seq/event_%s.h"' % tag,
          '#include "constants/init_script_types.h"', '#include "macros/script.inc"', '']
    num = lambda l: '_EV_%s + 1' % l
    if 'frame' in on: hl.append('\tInitScriptEntry_OnFrameTable _cv_%s_frame' % tag)
    if 'MAP_SCRIPT_ON_TRANSITION' in on: hl.append('\tInitScriptEntry_OnTransition %s' % num(on['MAP_SCRIPT_ON_TRANSITION']))
    if 'MAP_SCRIPT_ON_LOAD' in on: hl.append('\tInitScriptEntry_OnLoad %s' % num(on['MAP_SCRIPT_ON_LOAD']))
    if 'MAP_SCRIPT_ON_RESUME' in on: hl.append('\tInitScriptEntry_OnResume %s' % num(on['MAP_SCRIPT_ON_RESUME']))
    hl.append('\tInitScriptEntryEnd')
    if 'frame' in on:
        hl += ['', '_cv_%s_frame:' % tag]
        for a in on['frame']:
            if a[2] in unfinished:
                hl.append('\t// (not yet: %s)' % a[2]); continue       # a half-ported scene could leave you stuck
            hl.append('\tInitScriptGoToIfEqual %s, %s, %s' % (p.var(a[0]), p.val(a[1]), num(a[2])))
        hl.append('\tInitScriptFrameTableEnd')
    hl += ['', '\tInitScriptEnd', '']
    open(os.path.join(SCR, hdr), 'w').write('\n'.join(hl))
    # ---- the event header: script numbers and people's ids
    eh = ['#ifndef SCR_SEQ_%s_H_' % tag, '#define SCR_SEQ_%s_H_' % tag, '']
    for i, e in enumerate(entries): eh.append('#define _EV_%s %d' % (e, i))
    eh.append('')
    for o in people:
        if o.get('local_id'): eh.append('#define %s %d' % (o['local_id'], LID_OVER.get(o['local_id'], g.value(o['local_id']))))
    # (HeartGold's own code that names this map's people, such as a gym's moving gates: their ids stay defined,
    # as nobody's, so it still builds)
    for k, n in enumerate(sorted(n for n in c_object_refs() if n.startswith('obj_%s_' % tag))):
        eh.append('#define %s 0x%X' % (n, 0x7F00 + k))
    eh += ['', '#endif', '']
    open(os.path.join(SCR, 'event_%s.h' % tag), 'w').write('\n'.join(eh))
    # ---- people and signs
    objs = []
    _taken, _placed = set(), []
    _hg_warps = [(w_['x'], w_['z']) for w_ in ev.get('warps', [])]
    for i, o in enumerate(people):
        gfx = o['graphics_id'].replace('OBJ_EVENT_GFX_', '').replace('_FRLG', '')
        sm = re.match(r'SPECIES\((\w+)\)$', gfx)            # (a Pokemon: its walking sprite, or Eevee's for ones HeartGold lacks)
        if sm: gfx = sm.group(1) if sm.group(1) in SPRITE else 'EEVEE'
        mv = MOVETYPE.get(o['movement_type'], 15)
        kind = 'tree' if 'CUTTABLE_TREE' in o['graphics_id'] else 'trainer' if trainer_of(o) else \
            'item' if o['graphics_id'] == 'OBJ_EVENT_GFX_ITEM_BALL' else 'object'
        if isinstance(xy, Anchored):
            xy.last_spot = None
            xy.want_water = '_WATER' in o['graphics_id']        # (swimmers stay in the water)
        at = o['_at'] if '_at' in o else xy(o['x'], o['y'], kind)
        if isinstance(xy, Anchored): xy.want_water = False
        if at is None: continue
        x, z = off_furniture(slot, *at)
        if not isinstance(xy, Anchored) and '_at' not in o and kind in ('object', 'trainer') and _open_on_gba(mj, o):
            x, z = settle(slot, x, z, _taken)
        if '_at' not in o and kind in ('object', 'trainer') and gfx not in ('ITEM_BALL', 'BOULDER') and 'TREE' not in gfx and 'ROCK' not in gfx \
                and not (spot if False else None) and _open_on_gba(mj, o):
            x, z = clear_of(slot, x, z, o, mj, _hg_warps, _placed)
        _placed.append(((x, z), (o['x'], o['y'])))
        _taken.add((x, z))
        if (x, z) != tuple(at): report.append('  %s at %s moved (off something closed, clear of a door or of the people beside): now at %s' % (gfx, tuple(at), (x, z)))
        spot = xy.last_spot if isinstance(xy, Anchored) and kind == 'trainer' else None
        lid = o.get('_lid') or (g.value(o['local_id']) if o.get('local_id') else i + 1)
        m = re.match(r'VAR_(\d|[0-9A-F])$', gfx)
        spr = SPRITE.get(gfx, 'GSMAN1')
        objs.append({'id': o.get('local_id') or str(lid), 'spriteId': (str(101 + int(m.group(1), 16)) if m else spr[1:] if spr.startswith('#') else 'SPRITE_' + spr),
                     'movement': spot[3] if spot else mv, 'type': 1 if trainer_of(o) else 0, 'eventFlag': p.flag(o['flag']) if o['flag'] not in ('0', '0x0') else 'FLAG_NOTHING',
                     'scriptId': ('std_trainer(%d)' % trainer_of(o)) if trainer_of(o) else STD_OBJECT_SCRIPTS.get(o['script']) or (('_EV_%s + 1' % o['script']) if o['script'] not in ('0x0', '0') else '0'),
                     'facingDirection': spot[2] if spot else FACING.get(mv, 1), 'param0': (spot[4] if spot else int(o.get('trainer_sight_or_berry_tree_id', 0) or 0)) if trainer_of(o) else 0,
                     'param1': 0, 'param2': 0,
                     'xRange': int(o.get('movement_range_x', 0)), 'yRange': int(o.get('movement_range_y', 0)), 'x': x, 'z': z, 'y': 0})
        if gfx not in SPRITE and not m: report.append('sprite %s -> GSMAN1 (no match yet)' % gfx)
    bgs = []
    for b in signs:
        x, z = xy(b['x'], b['y'], 'pos' if b.get('_read') else 'sign')
        x, z = off_furniture(slot, x, z, sign=True)
        bgs.append({'scriptId': '_EV_%s + 1' % b['script'], 'type': 0, 'x': x, 'z': z, 'y': 0, 'dir': 4})
    coords = []
    for c in triggers:
        at = xy(c['x'], c['y'], 'trigger')
        if at is None: continue                       # (a trigger square HeartGold's layout has no place for)
        x, z = at
        if c['script'] in unfinished:
            continue                                  # (a half-ported scene could leave you stuck)
        where = [(x, z)] + [hz for gs, hz in getattr(xy, 'extra', []) if gs == (c['x'], c['y'])]
        for x, z in where:
            coords.append({'scriptId': '_EV_%s + 1' % c['script'], 'x': x, 'z': z, 'w': 1, 'h': 1, 'y': 0,
                           'val': int(p.val(c['var_value']), 0), 'var': p.var(c['var'])})
    if isinstance(xy, Anchored):     # (HeartGold's hidden items stay where they are, for now)
        snap = os.path.join(os.path.dirname(HERE), 'data', 'hg_events', os.path.basename(ev_path))
        bgs += [b for b in json.load(open(snap)).get('bgs', []) if str(b.get('scriptId', '')).startswith('std_hidden')]
    ev['objects'], ev['bgs'], ev['coords'] = objs, bgs, coords
    ev['header'] = 'fielddata/script/scr_seq/event_%s.h' % tag
    json.dump(ev, open(ev_path, 'w'), indent=4); open(ev_path, 'a').write('\n')
    report.append('%s -> %s: %d scripts, %d messages, %d people, %d signs, %d triggers; %d entry points not finished' %
                  (gba_map, slot, len(p.done), len(p.msg_order), len(objs), len(bgs), len(coords), len(unfinished)))
    report += ['  unfinished: ' + e for e in entries if e in unfinished]
    report += ['  stops early: ' + e for e in stops]
    report += ['  todo: ' + t for t in sorted(set(p.todo))]


def merged_json(name):
    """a GBA map, or GBA maps joined top to bottom ('A+B': B's squares below A's) where HeartGold has one map for
    them (its Route 21 is the GBA's North and South)"""
    parts = name.split('+')
    mj = json.loads(json.dumps(G.map_json(parts[0])))
    import gba_map
    dy = gba_map.Layout(mj['layout']).h
    for p_ in parts[1:]:
        m2 = G.map_json(p_)
        for k in ('object_events', 'bg_events', 'coord_events'):
            for e in m2.get(k, []):
                e = dict(e, y=e['y'] + dy)
                if k == 'object_events' and e.get('local_id'): e['local_id'] = e['local_id']
                mj.setdefault(k, []).append(e)
        dy += gba_map.Layout(m2['layout']).h
    return mj


SCROLL_LISTS = {      # the GBA's scrollable lists (src/scrollable_multichoice: its texts), in the order it gives
    'SCROLL_MULTI_SILPHCO_FLOORS': ['11F', '10F', '9F', '8F', '7F', '6F', '5F', '4F', '3F', '2F', '1F', 'EXIT'],
}


def dynamic_warp(gba_const, x, y):
    """an elevator's way out to a floor (the GBA's setdynamicwarp: map, square) -> (our map, the warp there that is
    the elevator's door, its square): HeartGold puts you at that warp"""
    d = next((k for k in MAPS if '#' not in k and '+' not in k and G.map_json(k).get('id') == gba_const), None)
    if d is None: return None
    slot, xy = MAPS[d][:2]
    ev = json.load(open(os.path.join(slots.EVENT_DIR, slots.events_file(slot))))
    want = xy(x, y) if xy else (x, y)
    ws = ev.get('warps', [])
    if not ws: return None
    i = min(range(len(ws)), key=lambda i: abs(ws[i]['x'] - want[0]) + abs(ws[i]['z'] - want[1]) +
            (0 if 'ELEVATOR' in str(ws[i]['header']) else 100))
    return slot, i, ws[i]['x'], ws[i]['z']


def reachable(p, e):
    seen, todo = set(), [e]
    while todo:
        l = todo.pop()
        if l in seen: continue
        seen.add(l)
        for c, a in p.g.labels.get(l, []):
            for x in a:
                if x in p.g.labels and x not in seen: todo.append(x)
    return seen


def main():
    g, ids = G.Gba(), Ids()
    own_gba(g)
    report = []
    for m in sys.argv[1:] or list(MAPS):
        port(m, g, ids, report)
    ids.save()
    os.makedirs(os.path.dirname(REPORT), exist_ok=True)
    open(REPORT, 'w').write('\n'.join(report) + '\n')
    print('\n'.join(l for l in report if not l.startswith('  todo')))
    print('(details: %s)' % REPORT)


if __name__ == '__main__':
    main()
