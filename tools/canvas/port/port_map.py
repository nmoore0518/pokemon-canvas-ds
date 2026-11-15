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
import slots

ROOT = slots.ROOT
SCR = os.path.join(ROOT, 'files/fielddata/script/scr_seq')
MSG = os.path.join(ROOT, 'files/msgdata/msg')
IDS = os.path.join(os.path.dirname(HERE), 'data', 'canvas_ids.json')
REPORT = os.path.join(ROOT, 'build', 'canvas_port_report.txt')

# ---------------------------------------------------------------- where each GBA map's things go
PALLET_OX, PALLET_CELL = 27, (31, 11)


def pallet_xy(x, y):
    if (x, y) == (16, 28): x, y = 25, 27          # (the sign we moved off the gym's other sign)
    return 32 * PALLET_CELL[0] + PALLET_OX + x, 32 * PALLET_CELL[1] + y


MAPS = {   # GBA map dir: (HeartGold map slot, square transform)
    'PalletTown_Frlg': ('MAP_PALLET', pallet_xy),
}

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


def text(s):
    """GBA string -> HeartGold message lines (\\n line, \\r new box, \\f scroll); returns (lines, buffers)"""
    s = s.split('$')[0]
    for a, b in WORDS: s = s.replace(a, b)
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
    'PROF_OAK': 'OOKIDO', 'MOM': 'GSMAMA', 'BLUE': 'GSRIVEL', 'DAISY': 'NANAMI', 'GIOVANNI': 'SAKAKI',
    'ROCKET_M': 'ROCKETM', 'ROCKET_F': 'ROCKETW', 'POLICEMAN': 'POLICEMAN', 'SAILOR': 'SEAMAN_2', 'FISHERMAN': 'FISHING_2',
    'HIKER': 'MOUNT_2', 'SWIMMER_M': 'GSSWIMMERM', 'SWIMMER_F': 'GSSWIMMERW', 'BLACK_BELT': 'GSFIGHTER',
    'CAMPER': 'CAMPBOY_2', 'PICNICKER': 'PICNICGIRL_2', 'BEAUTY': 'GSWOMAN3', 'COOLTRAINER_M': 'GSMAN3',
    'COOLTRAINER_F': 'GSWOMAN3', 'POKE_MANIAC': 'MANIA', 'ITEM_BALL': 'MONSTARBALL', 'PUSHABLE_BOULDER': 'ROCK',
    'BREAKABLE_ROCK': 'BREAKROCK', 'CUTTABLE_TREE': 'TREE', 'WORKER_M': 'WORKMAN', 'BALDING_MAN': 'GSMIDDLEMAN1',
    'GYM_GUY': 'GSMAN1', 'CHANNELER': 'ITAKO', 'ROCKER': 'GSMAN2', 'BIKER': 'CYCLEM', 'EXPERT_M': 'GSOLDMAN1',
    'EXPERT_F': 'GSOLDWOMAN1', 'POKEFAN_M': 'GSMIDDLEMAN1', 'POKEFAN_F': 'MIDDLEWOMAN1_2', 'TWIN': 'GSGIRL1',
}

MOVETYPE = {'MOVEMENT_TYPE_NONE': 0, 'MOVEMENT_TYPE_LOOK_AROUND': 2, 'MOVEMENT_TYPE_WANDER_AROUND': 3,
            'MOVEMENT_TYPE_WANDER_UP_AND_DOWN': 4, 'MOVEMENT_TYPE_WANDER_LEFT_AND_RIGHT': 5, 'MOVEMENT_TYPE_FACE_UP': 14,
            'MOVEMENT_TYPE_FACE_DOWN': 15, 'MOVEMENT_TYPE_FACE_LEFT': 16, 'MOVEMENT_TYPE_FACE_RIGHT': 17}
FACING = {14: 0, 15: 1, 16: 2, 17: 3}

STEP = {'up': 'North', 'down': 'South', 'left': 'West', 'right': 'East'}


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

    def msg(self, label):
        if label not in self.msgs:
            if label not in self.g.texts:
                self.todo.append('text %s missing' % label)
                self.msgs[label] = (['(missing text)'], set())
            else:
                self.msgs[label] = text(self.g.texts[label])
            self.msg_order.append(label)
        return '%s_%s' % (self.bank, label)

    def flag(self, f): return f if re.match(r'^(0x)?\d', f) else self.ids.flag(f)
    def var(self, v): return v if re.match(r'^(0x)?\d', v) else self.ids.var(v)

    def val(self, a):
        """a value: number, constant, or a var"""
        if a.startswith('VAR_'): return self.var(a)
        if a in ('TRUE', 'YES'): return '1'
        if a in ('FALSE', 'NO'): return '0'
        v = self.g.value(a)
        return str(v) if v is not None else a

    def localid(self, a):
        if a in ('OBJ_EVENT_ID_PLAYER', 'LOCALID_PLAYER', '255'): return 'obj_player'
        v = self.g.value(a)
        return str(v) if v is not None else a

    def label(self, l):
        if l not in self.done and l not in self.queue: self.queue.append(l)
        return l

    def new(self, tag):
        self.n += 1
        return '_cv_%s_%d' % (tag, self.n)

    def emit(self, *ls): self.lines.extend('\t' + l if not l.endswith(':') else l for l in ls)

    def say(self, label, wait=True):
        m = self.msg(label)
        bufs = self.msgs[label][1]
        if 'player' in bufs: self.emit('BufferPlayersName 6')
        if 'rival' in bufs: self.emit('BufferRivalsName 7')
        self.emit('NPCMsg %s' % m)
        if wait: self.emit('WaitButton')

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
            self.todo.append('script %s missing' % label); return
        if cmds and step(cmds[0][0]) is not None or (cmds and cmds[0][0] in ('step_end', 'face_player', 'face_away_player')):
            return self.movement(label, cmds)
        self.emit('', label + ':')
        open_msg = False
        sw = None
        for cmd, a in cmds:
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
            elif cmd == 'setflag': self.emit('SetFlag %s' % self.flag(a[0]))
            elif cmd == 'clearflag': self.emit('ClearFlag %s' % self.flag(a[0]))
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
            elif cmd == 'removeobject': self.emit('HidePerson %s' % self.localid(a[0]))
            elif cmd == 'addobject': self.emit('ShowPerson %s' % self.localid(a[0]))
            elif cmd == 'delay': self.emit('Wait %s, VAR_SPECIAL_RESULT' % self.val(a[0]))
            elif cmd == 'playse': self.emit('PlaySE %s' % SE.get(a[0], 'SEQ_SE_DP_SELECT'))
            elif cmd == 'waitse': self.emit('WaitSE SEQ_SE_DP_SELECT')
            elif cmd == 'playfanfare': self.emit('PlayFanfare %s' % FANFARE.get(a[0], 'SEQ_ME_ITEM'))
            elif cmd == 'waitfanfare': self.emit('WaitFanfare')
            elif cmd == 'checkplayergender': self.emit('GetPlayerGender VAR_SPECIAL_RESULT')
            elif cmd == 'playmoncry': self.emit('PlayCry %s, 0' % a[0])
            elif cmd == 'waitmoncry': self.emit('WaitCry')
            elif cmd == 'specialvar':
                self.emit('SetVar %s, 0  // TODO(gba) specialvar %s' % (self.var(a[0]), a[1])); self.todo.append('special %s' % a[1])
            else:
                self.emit('// TODO(gba) %s %s' % (cmd, ', '.join(a))); self.todo.append('%s (%s)' % (cmd, label))
        if not cmds or cmds[-1][0] not in ('end', 'return', 'goto'):
            self.emit('End')

    def movement(self, label, cmds):
        out = []
        for cmd, a in cmds:
            if cmd == 'step_end': break
            s = step(cmd)
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


def port(gba_map, g, ids, report):
    slot, xy = MAPS[gba_map]
    h = slots.header(slot)
    bank = h['msgBank']                           # e.g. msg_0446_T01
    scr = h['scriptsBank'][:-4] + '.s'           # scr_seq_0735_T01_bin -> scr_seq_0735_T01.s
    hdr = h['scriptHeaderBank'][:-4] + '.s'
    tag = re.match(r'scr_seq_\d+_(\w+)$', scr[:-2]).group(1)
    ev_path = os.path.join(slots.EVENT_DIR, slots.events_file(slot))
    ev = json.load(open(ev_path))
    mj = G.map_json(gba_map)
    p = Port(g, ids, bank, gba_map)
    # entry points: people and signs (in order), then map scripts
    entries = []
    people = [o for o in mj.get('object_events', []) if o.get('type', 'object') == 'object']
    signs = [b for b in mj.get('bg_events', []) if b.get('type') == 'sign']
    for o in people:
        if o['script'] not in ('0x0', '0') and o['script'] not in entries: entries.append(o['script'])
    for b in signs:
        if b['script'] not in entries: entries.append(b['script'])
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
    p.run(entries)
    p.msgs['cv_unported'] = (['(Canvas DS: this part of the game\n', 'isn’t ported yet.)'], set())
    p.msg_order.append('cv_unported')
    # people whose script still has a TODO say so instead of half-running it
    unfinished = set()
    mapscript_entries = set(on.get(k) for k in ('MAP_SCRIPT_ON_TRANSITION', 'MAP_SCRIPT_ON_LOAD', 'MAP_SCRIPT_ON_RESUME'))
    for e in entries:
        if e in mapscript_entries:
            continue          # (map scripts run what they can; the TODOs are comments)
        reach = reachable(p, e)
        if any(t.endswith('(%s)' % r) for t in p.todo for r in reach):
            unfinished.add(e)
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
        mv = MOVETYPE.get(o['movement_type'], 15)
        x, z = xy(o['x'], o['y'])
        lid = g.value(o['local_id']) if o.get('local_id') else i + 1
        m = re.match(r'VAR_(\d|[0-9A-F])$', gfx)
        objs.append({'id': o.get('local_id') or str(lid), 'spriteId': ('0x%X' % (0x4020 + int(m.group(1), 16)) if m else 'SPRITE_' + SPRITE.get(gfx, 'GSMAN1')),
                     'movement': mv, 'type': 0, 'eventFlag': p.flag(o['flag']) if o['flag'] not in ('0', '0x0') else 'FLAG_NOTHING',
                     'scriptId': ('_EV_%s + 1' % o['script']) if o['script'] not in ('0x0', '0') else '0',
                     'facingDirection': FACING.get(mv, 1), 'param0': 0, 'param1': 0, 'param2': 0,
                     'xRange': int(o.get('movement_range_x', 0)), 'yRange': int(o.get('movement_range_y', 0)), 'x': x, 'z': z, 'y': 0})
        if gfx not in SPRITE and not m: report.append('sprite %s -> GSMAN1 (no match yet)' % gfx)
    bgs = []
    for b in signs:
        x, z = xy(b['x'], b['y'])
        bgs.append({'scriptId': '_EV_%s + 1' % b['script'], 'type': 0, 'x': x, 'z': z, 'y': 0, 'dir': 4})
    ev['objects'], ev['bgs'] = objs, bgs
    ev['header'] = 'fielddata/script/scr_seq/event_%s.h' % tag
    json.dump(ev, open(ev_path, 'w'), indent=4); open(ev_path, 'a').write('\n')
    report.append('%s -> %s: %d scripts, %d messages, %d people, %d signs; %d entry points not finished' %
                  (gba_map, slot, len(p.done), len(p.msg_order), len(objs), len(bgs), len(unfinished)))
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
