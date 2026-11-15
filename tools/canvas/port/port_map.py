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
import slots

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

    def __init__(self, slot, pairs):
        self.slot, self.pairs, self.used = slot, pairs, set()
        self.indoor = 'EVERYWHERE' not in slots.header(slot)['matrixId']
        self.hg_signs = self.hg_trees = None

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
        return v is not None and not v & 0x8000 and (v & 0xFF) not in (0x10, 0x11, 0x13, 0x15, 0x62, 0x63, 0x64, 0x65, 0x69, 0x6E)

    def __call__(self, x, y, kind='pos'):
        dx, dy = self.offset(x, y)
        X, Z = x + dx, y + dy
        if kind == 'tree' and self.hg_trees:     # (a cuttable tree goes where HeartGold has one: they block paths)
            X, Z = min(self.hg_trees, key=lambda b: (b[0] - X) ** 2 + (b[1] - Z) ** 2)
            self.hg_trees.remove((X, Z)); self.used.add((X, Z))
            return X, Z
        if kind == 'sign':
            if self.hg_signs:
                X, Z = min(self.hg_signs, key=lambda b: (b[0] - X) ** 2 + (b[1] - Z) ** 2)
                self.hg_signs.remove((X, Z))
            return X, Z
        if kind in ('object', 'trigger'):
            for r in range(0, 6):
                ring = [(X + i, Z + j) for i in range(-r, r + 1) for j in range(-r, r + 1) if max(abs(i), abs(j)) == r]
                for c in sorted(ring, key=lambda c: (c[0] - X) ** 2 + (c[1] - Z) ** 2):
                    if self.open(*c) and (kind == 'trigger' or c not in self.used):
                        if kind == 'object': self.used.add(c)
                        return c
        return X, Z


# HeartGold's Viridian (doors and exits, GBA square -> HeartGold square)
VIRIDIAN = Anchored('MAP_VIRIDIAN', [((36, 10), (1045, 239)), ((25, 11), (1034, 244)), ((25, 18), (1036, 253)),
                                     ((36, 19), (1042, 253)), ((26, 26), (1032, 262)), ((35, 26), (1041, 262)),
                                     ((0, 17), (996, 258)), ((21, 0), (1030, 216)), ((24, 39), (1036, 280))])
# HeartGold's Route 1 is longer than the GBA's (64 squares to 40): its corners and middle anchor the stretch
ROUTE1 = Anchored('MAP_ROUTE_1', [((12, 0), (1036, 289)), ((12, 39), (1039, 351)), ((1, 1), (1028, 291)), ((22, 1), (1050, 291)),
                                  ((1, 20), (1027, 320)), ((22, 20), (1050, 320)), ((1, 38), (1027, 349)), ((22, 38), (1050, 349))])
VIRIDIAN_MART = Anchored('MAP_VIRIDIAN_POKEMART', [((4, 7), (4, 11)), ((2, 3), (2, 6)), ((9, 5), (10, 4))])

MAPS = {   # GBA map dir: (HeartGold map slot, square transform)
    'PalletTown_Frlg': ('MAP_PALLET', pallet_xy),
    'PalletTown_PlayersHouse_1F_Frlg': ('MAP_PALLET_TOWN_REDS_HOUSE_1F', same),
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
    'ViridianCity_Mart_Frlg': ('MAP_VIRIDIAN_POKEMART', VIRIDIAN_MART),
    'ViridianCity_PennysHouse_Frlg': ('MAP_CANVAS_VIRIDIAN_PENNYS_HOUSE', same),
}

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


INSERTS = {
    'PalletTown_OnTransition': (None, new_game),
    'PalletTown_ProfessorOaksLab_ChooseStarterScene': ('msgbox', [
        'GoToIfSet {flag[CV_RIVAL_NAMED]}, _cv_rival_named',
        'FadeScreen 6, 1, 0, RGB_BLACK', 'WaitFade', 'NameRival VAR_SPECIAL_RESULT', 'FadeScreen 6, 1, 1, RGB_BLACK', 'WaitFade',
        'SetFlag {flag[CV_RIVAL_NAMED]}', '_cv_rival_named:']),
}


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
        m = re.match(r'VAR_TEMP_(\w+)$', name)
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
    s = re.sub(r"(?<![{\w])([A-ZÉ][A-Zé'É.]*[A-Zé])(?![\w}])", lambda m: unshout(m.group(1)), s)
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

SPRITE = {   # GBA graphics id (without OBJ_EVENT_GFX_ and _FRLG) -> HeartGold sprite (without SPRITE_)
    'WOMAN_1': 'GSWOMAN1', 'WOMAN_2': 'GSWOMAN2', 'WOMAN_3': 'GSWOMAN3', 'WOMAN_4': 'GSWOMAN2', 'WOMAN_5': 'GSWOMAN3',
    'MAN_1': 'GSMAN1', 'MAN_2': 'GSMAN2', 'MAN_3': 'GSMAN3', 'MAN_4': 'GSMIDDLEMAN1', 'MAN_5': 'GSMAN2', 'MAN': 'GSMAN1',
    'FAT_MAN': 'GSBIGMAN', 'OLD_MAN': 'GSOLDMAN1', 'OLD_MAN_1': 'GSOLDMAN1', 'OLD_WOMAN': 'GSOLDWOMAN1',
    'BOY': 'GSBOY1', 'BOY_1': 'GSBOY1', 'BOY_2': 'GSBOY2', 'BOY_3': 'GSBOY3', 'LITTLE_BOY': 'GSBABYBOY1',
    'LITTLE_GIRL': 'GSBABYGIRL1', 'GIRL_1': 'GSGIRL1', 'GIRL_2': 'GSGIRL2', 'GIRL_3': 'GSGIRL3', 'LASS': 'GSGIRL2',
    'YOUNGSTER': 'GSBOY2', 'BUG_CATCHER': 'GSBOY1', 'GENTLEMAN': 'GSGENTLEMAN', 'SCIENTIST': 'GSASSISTANTM',
    'SCIENTIST_1': 'GSASSISTANTM', 'NURSE': 'PCWOMAN1', 'CLERK': 'SHOPM1_2', 'MART_EMPLOYEE': 'SHOPM1_2',
    'PROF_OAK': 'OOKIDO', 'MOM': 'GSMAMA', 'BLUE': 'GSLEADER16', 'DAISY': 'NANAMI', 'GIOVANNI': 'SAKAKI',
    'ROCKET_M': 'ROCKETM', 'ROCKET_F': 'ROCKETW', 'POLICEMAN': 'POLICEMAN', 'SAILOR': 'SEAMAN_2', 'FISHERMAN': 'FISHING_2',
    'HIKER': 'MOUNT_2', 'SWIMMER_M': 'GSSWIMMERM', 'SWIMMER_F': 'GSSWIMMERW', 'BLACK_BELT': 'GSFIGHTER',
    'CAMPER': 'CAMPBOY_2', 'PICNICKER': 'PICNICGIRL_2', 'BEAUTY': 'GSWOMAN3', 'COOLTRAINER_M': 'GSMAN3',
    'COOLTRAINER_F': 'GSWOMAN3', 'POKE_MANIAC': 'MANIA', 'ITEM_BALL': 'MONSTARBALL', 'PUSHABLE_BOULDER': 'ROCK',
    'BREAKABLE_ROCK': 'BREAKROCK', 'CUTTABLE_TREE': 'TREE', 'WORKER_M': 'WORKMAN', 'BALDING_MAN': 'GSMIDDLEMAN1',
    'GYM_GUY': 'GSMAN1', 'CHANNELER': 'ITAKO', 'ROCKER': 'GSMAN2', 'BIKER': 'CYCLEM', 'EXPERT_M': 'GSOLDMAN1',
    'EXPERT_F': 'GSOLDWOMAN1', 'POKEFAN_M': 'GSMIDDLEMAN1', 'POKEFAN_F': 'MIDDLEWOMAN1_2', 'TWIN': 'GSGIRL1',
    'WORKER_F': 'GSWOMAN1', 'LEADER_AIDE': 'GSASSISTANTM', 'POKEDEX': 'SCROLL', 'TOWN_MAP': 'SCROLL',
    'CEREMONY_PODIUM': 'GTOROPHY', 'OLD_MAN_LYING_DOWN': 'GSOLDMAN1', 'GAUNTLET_PENNY': 'GSWOMAN1',
    'PAINT_FIGURE': 'GSMAN2',
}
# Pokemon in the overworld: hg-engine's walking sprite of that species
for _n in re.findall(r'#define SPRITE_FOLLOWER_MON_(?!STATIC)([A-Z0-9_]+)\s', open(os.path.join(ROOT, 'include/constants/sprites.h')).read()):
    SPRITE.setdefault(_n, 'FOLLOWER_MON_' + _n)

NO_OPS = ('opendoor', 'closedoor', 'waitdooranim', 'signmsg', 'normalmsg', 'waitstate', 'savebgm',
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

SYS_FLAGS = {'FLAG_SYS_GAME_CLEAR': 'FLAG_GAME_CLEAR'}      # GBA flags that are HeartGold's own
HG_NAMES = {'ITEM_PARALYZE_HEAL': 'ITEM_PARLYZ_HEAL', 'ITEM_TINY_MUSHROOM': 'ITEM_TINYMUSHROOM',
            'ITEM_BIG_MUSHROOM': 'ITEM_BIGMUSHROOM', 'ITEM_X_SP_ATK': 'ITEM_X_SPECIAL', 'ITEM_X_SP_DEF': 'ITEM_X_SP__DEF',
            'ITEM_THUNDER_STONE': 'ITEM_THUNDERSTONE', 'ITEM_SILK_SCARF': 'ITEM_SILK_SCARF', 'ITEM_BLACK_GLASSES': 'ITEM_BLACKGLASSES',
            'ITEM_NEVER_MELT_ICE': 'ITEM_NEVERMELTICE', 'ITEM_TWISTED_SPOON': 'ITEM_TWISTEDSPOON', 'ITEM_DEEP_SEA_TOOTH': 'ITEM_DEEPSEATOOTH',
            'ITEM_DEEP_SEA_SCALE': 'ITEM_DEEPSEASCALE', 'ITEM_ENERGY_POWDER': 'ITEM_ENERGYPOWDER', 'ITEM_HP_UP': 'ITEM_HP_UP'}
# the GBA's scripts for things anyone can use (cut a tree, smash a rock...) -> HeartGold's
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
        self.xy = MAPS[gba_map][1]
        self.dyn, self.faded = [], False
        self.mapscript_labels = set()
        self.ox, self.oy = self.xy(0, 0)
        self.hide_flags = {}          # a person's flag -> their local ids
        self.flag_of = {}             # a person's local id -> their flag
        for o in G.map_json(gba_map).get('object_events', []):
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
            return 'SPRITE_' + SPRITE.get(gfx, 'GSMAN1')
        if a in ('DIR_NORTH', 'DIR_SOUTH', 'DIR_WEST', 'DIR_EAST'): return str(['DIR_NORTH', 'DIR_SOUTH', 'DIR_WEST', 'DIR_EAST'].index(a))
        if a.startswith(('SPECIES_', 'ITEM_', 'MOVE_')):
            a = HG_NAMES.get(a, a)
            if a in HG_DEFINES: return a
            self.todo.append('constant %s not in HeartGold' % a)
            return '0'
        v = self.g.value(a)
        if v is None and re.match(r'^[A-Z_][A-Z0-9_]*$', a) and not a.startswith(('SPECIES_', 'ITEM_')):
            self.todo.append('constant %s unknown' % a); return '0'
        return str(v) if v is not None else a

    def localid(self, a):
        if a in ('OBJ_EVENT_ID_PLAYER', 'LOCALID_PLAYER', '255'): return 'obj_player'
        a = self.alias(a)
        if a.startswith('VAR_'): return self.var(a)
        v = self.g.value(a)
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
        m = self.msg(label)
        bufs = self.msgs[label][1]
        if 'player' in bufs: self.emit('BufferPlayersName 6')
        if 'rival' in bufs: self.emit('BufferRivalsName 7')
        self.emit('NPCMsg %s' % m)
        if wait: self.emit('WaitButton')

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
        if dest in MAPS: slot, xy = MAPS[dest]
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
        it, n = self.val(item), self.val(n)
        if item.startswith('ITEM_') and item not in HG_DEFINES:
            # (an item HeartGold doesn't have yet: carried as a flag until we add it)
            f = self.flag('CV_HAS_' + item)
            if cmd in ('giveitem', 'additem'): self.emit('SetFlag %s' % f, 'SetVar VAR_SPECIAL_RESULT, 1')
            elif cmd == 'removeitem': self.emit('ClearFlag %s' % f, 'SetVar VAR_SPECIAL_RESULT, 1')
            elif cmd == 'checkitemspace': self.emit('SetVar VAR_SPECIAL_RESULT, 1')
            else:
                l = self.new('has')
                self.emit('SetVar VAR_SPECIAL_RESULT, 0', 'GoToIfUnset %s, %s' % (f, l), 'SetVar VAR_SPECIAL_RESULT, 1', l + ':')
            return
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
        if cmds is None:
            self.todo.append('script %s missing' % label)
            self.movements[label] = []          # (made in C in the GBA game: a still movement here, for now)
            return
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
            elif cmd in ('lock', 'lockall'): self.emit('LockAll')
            elif cmd in ('release', 'releaseall'): self.emit(*close, 'ReleaseAll'); open_msg = False
            elif cmd == 'faceplayer': self.emit('FacePlayer')
            elif cmd == 'goto': self.emit('GoTo %s' % self.label(a[0]))
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
            elif cmd == 'setvar': self.emit('SetVar %s, %s' % (self.var(a[0]), self.val(a[1])))
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
            elif cmd == 'waitfanfare': self.emit('WaitFanfare')
            elif cmd == 'checkplayergender': self.emit('GetPlayerGender VAR_SPECIAL_RESULT')
            elif cmd == 'playmoncry': self.emit('PlayCry %s, 0' % self.val(a[0]))
            elif cmd == 'waitmoncry': self.emit('WaitCry')
            elif cmd == 'specialvar':
                lines = SP.special(self, a[1], self.var(a[0]))
                if lines is None:
                    self.emit('SetVar %s, 0  // TODO(gba) specialvar %s' % (self.var(a[0]), a[1])); self.todo.append('special %s (%s)' % (a[1], label)); self.stop(label)
                else: self.emit(*lines)
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
            elif cmd == 'dynmultichoice':
                if a[5] not in ('DYN_MULTICHOICE_CB_NONE', 'NULL'): self.todo.append('menu callback %s (%s)' % (a[5], label))
                self.menu([(t, str(i)) for i, t in enumerate(a[6:])], a[2], a[4])
            elif cmd == 'goto_if_defeated':
                self.emit('GoToIfSet %s, %s' % (self.flag('CV_DEFEATED_' + a[0]), self.label(a[1])))
            elif cmd in ('trainerbattle_earlyrival', 'trainerbattle_no_intro', 'trainerbattle_single') and a[0] in RIVAL_STAGES:
                self.rival_battle(a[0], lose_ok=(cmd == 'trainerbattle_earlyrival'))
            elif cmd in ('cleartrainerflag', 'settrainerflag'):
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
    slot, xy = MAPS[gba_map]
    if 'EVERYWHERE' in slots.header(slot)['scriptsBank']:
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
        xy.hg_trees = [(o['x'], o['z']) for o in json.load(open(snap)).get('objects', []) if o['spriteId'] == 'SPRITE_TREE']
    mj = G.map_json(gba_map)
    p = Port(g, ids, bank, gba_map)
    # entry points: people and signs (in order), then map scripts
    entries = []
    people = [o for o in mj.get('object_events', []) if o.get('type', 'object') == 'object'
              and 'TYPE_TUTOR_DECOR' not in o['graphics_id']]       # (the tutors' decorations come with the tutors' own sprites)
    signs = [b for b in mj.get('bg_events', []) if b.get('type') == 'sign']
    for o in people:
        if o['script'] not in ('0x0', '0') and o['script'] not in STD_OBJECT_SCRIPTS and o['script'] not in entries:
            entries.append(o['script'])
    for b in signs:
        if b['script'] not in entries: entries.append(b['script'])
    triggers = [c for c in mj.get('coord_events', []) if c.get('type') == 'trigger' and c.get('script') not in ('0x0', '0', None)]
    for c in triggers:
        if c['script'] not in entries: entries.append(c['script'])
    mapscripts = [(c, a) for c, a in g.labels.get(gba_map.replace('_Frlg', '') + '_Frlg_MapScripts', g.labels.get(gba_map + '_MapScripts', []))]
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
        if o.get('local_id'): eh.append('#define %s %d' % (o['local_id'], g.value(o['local_id'])))
    eh += ['', '#endif', '']
    open(os.path.join(SCR, 'event_%s.h' % tag), 'w').write('\n'.join(eh))
    # ---- people and signs
    objs = []
    for i, o in enumerate(people):
        gfx = o['graphics_id'].replace('OBJ_EVENT_GFX_', '').replace('_FRLG', '')
        sm = re.match(r'SPECIES\((\w+)\)$', gfx)            # (a Pokemon: its walking sprite, or Eevee's for ones HeartGold lacks)
        if sm: gfx = sm.group(1) if sm.group(1) in SPRITE else 'EEVEE'
        mv = MOVETYPE.get(o['movement_type'], 15)
        x, z = xy(o['x'], o['y'], 'tree' if 'CUTTABLE_TREE' in o['graphics_id'] else 'object')
        lid = g.value(o['local_id']) if o.get('local_id') else i + 1
        m = re.match(r'VAR_(\d|[0-9A-F])$', gfx)
        objs.append({'id': o.get('local_id') or str(lid), 'spriteId': (str(101 + int(m.group(1), 16)) if m else 'SPRITE_' + SPRITE.get(gfx, 'GSMAN1')),
                     'movement': mv, 'type': 0, 'eventFlag': p.flag(o['flag']) if o['flag'] not in ('0', '0x0') else 'FLAG_NOTHING',
                     'scriptId': STD_OBJECT_SCRIPTS.get(o['script']) or (('_EV_%s + 1' % o['script']) if o['script'] not in ('0x0', '0') else '0'),
                     'facingDirection': FACING.get(mv, 1), 'param0': 0, 'param1': 0, 'param2': 0,
                     'xRange': int(o.get('movement_range_x', 0)), 'yRange': int(o.get('movement_range_y', 0)), 'x': x, 'z': z, 'y': 0})
        if gfx not in SPRITE and not m: report.append('sprite %s -> GSMAN1 (no match yet)' % gfx)
    bgs = []
    for b in signs:
        x, z = xy(b['x'], b['y'], 'sign')
        bgs.append({'scriptId': '_EV_%s + 1' % b['script'], 'type': 0, 'x': x, 'z': z, 'y': 0, 'dir': 4})
    coords = []
    for c in triggers:
        x, z = xy(c['x'], c['y'], 'trigger')
        if c['script'] in unfinished:
            continue                                  # (a half-ported scene could leave you stuck)
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
