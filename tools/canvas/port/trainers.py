"""Canvas: the GBA game's trainers -> hg-engine trainer data.

    python3 tools/canvas/port/trainers.py

Writes tools/canvas/data/canvas_trainers.h (entries appended to hg-engine's sTrainerData, from id 738 on) and
canvas_trainer_order.h (their place in the text order); build_rom.sh copies both into engine/data, where the
engine patch includes them in data/Trainers.c. Ids are kept in tools/canvas/data/canvas_trainers.json (scripts
use the numbers, and saves keep the trainer flags, so an id never moves).

The rival's teams (src/data/rival_teams_frlg.party: one per stage of the story and per type he can take; the porter
turns each rival battle into a choice on VAR_RIVAL_TYPE), then every other trainer (src/data/trainers_frlg.party).
Their lines come from the GBA scripts that battle them: intro, defeat, and the line after (trainer text, as
HeartGold's own trainer script shows it). Pokemon without listed moves get the last four they'd have learned.
"""
import json, os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.dirname(HERE))
import gba as G
import slots

ROOT = slots.ROOT
DATA = os.path.join(os.path.dirname(HERE), 'data')
IDS = os.path.join(DATA, 'canvas_trainers.json')
FIRST = 738                     # HeartGold's trainers are 0..737
ENGINE_SPECIES = os.path.join(ROOT, 'engine/include/constants/species.h')
ENGINE_ITEMS = os.path.join(ROOT, 'engine/include/constants/item.h')

CLASS = {'Rival Early Frlg': 'TRAINERCLASS_CANVAS_RIVAL', 'Rival Late Frlg': 'TRAINERCLASS_CANVAS_RIVAL',
         'Champion Frlg': 'TRAINERCLASS_CANVAS_RIVAL'}   # (our class: Blue's look, the rival's chosen name)
AI = 'F_PRIORITIZE_SUPER_EFFECTIVE | F_EVALUATE_ATTACKS | F_PRIORITIZE_DAMAGE'
ENGINE_MOVES = os.path.join(ROOT, 'engine/include/constants/moves.h')
LEARNSETS = os.path.join(ROOT, 'engine/data/learnsets/learnsets.json')

# GBA trainer class -> HeartGold's (by gender where HeartGold has both)
CLASSES = {
    'Team Rocket': ('TEAM_ROCKET', 'TEAM_ROCKET_F'), 'Picnicker': 'PICNICKER', 'Bird Keeper': 'BIRD_KEEPER_GS',
    'Youngster': 'YOUNGSTER', 'Swimmer M': 'SWIMMER_M', 'Swimmer F': 'SWIMMER_F', 'Lass': 'LASS', 'Biker': 'BIKER',
    'Cooltrainer': ('ACE_TRAINER_M_GS', 'ACE_TRAINER_F_GS'), 'Hiker': 'HIKER', 'Bug Catcher': 'BUG_CATCHER',
    'Camper': 'CAMPER', 'Gentleman': 'GENTLEMAN', 'Channeler': 'MEDIUM', 'Fisherman': 'FISHERMAN',
    'Black Belt': 'BLACK_BELT', 'Beauty': 'BEAUTY', 'Scientist': 'SCIENTIST_GS', 'Pokemaniac': 'POKE_MANIAC',
    'Lady': 'LADY', 'Cue Ball': 'ROUGHNECK', 'Psychic': ('PSYCHIC_M', 'PSYCHIC_F'), 'Super Nerd': 'SUPER_NERD',
    'Pkmn Ranger': ('PKMN_RANGER_M', 'PKMN_RANGER_F'), 'Juggler': 'JUGGLER', 'Crush Girl': 'BATTLE_GIRL',
    'Tamer': 'ROUGHNECK', 'Sailor': 'SAILOR', 'Ruin Maniac': 'RUIN_MANIAC', 'Gamer': 'GENTLEMAN',
    'Crush Kin': 'BLACK_BELT', 'Twins': 'TWINS', 'Burglar': 'BURGLAR', 'Young Couple': 'YOUNG_COUPLE',
    'Sis And Bro': 'DOUBLE_TEAM', 'Painter': 'ARTIST', 'Pkmn Breeder': ('PKMN_BREEDER_M', 'PKMN_BREEDER_F'),
    'Engineer': 'WORKER', 'Aroma Lady': 'AROMA_LADY', 'Tuber': ('TUBER_M', 'TUBER_F'), 'Rocker': 'GUITARIST',
    'Cool Couple': 'YOUNG_COUPLE', 'Boss': 'ROCKET_BOSS', 'Pkmn Prof': 'ELDER', 'Pkmn Trainer 1': 'PKMN_TRAINER_ETHAN',
    'Stadium': 'ACE_TRAINER_M_GS', 'Nurse': 'AROMA_LADY',
}
# Leaders and the Elite Four go by name. (HeartGold has no Lorelei or Agatha: stand-ins for now.)
NAMED = {'BROCK': 'LEADER_BROCK', 'MISTY': 'LEADER_MISTY', 'LT. SURGE': 'LEADER_LT_SURGE', 'ERIKA': 'LEADER_ERIKA',
         'KOGA': 'ELITE_FOUR_KOGA', 'SABRINA': 'LEADER_SABRINA', 'BLAINE': 'LEADER_BLAINE', 'GIOVANNI': 'ROCKET_BOSS',
         'LORELEI': 'ACE_TRAINER_F_GS', 'BRUNO': 'ELITE_FOUR_BRUNO', 'AGATHA': 'MEDIUM', 'LANCE': 'CHAMPION'}
AI_FLAGS = {'Check Bad Move': 'F_PRIORITIZE_SUPER_EFFECTIVE', 'Try To Faint': 'F_PRIORITIZE_DAMAGE',
            'Check Viability': 'F_EVALUATE_ATTACKS', 'Setup First Turn': 'F_PRIORITIZE_STATUS_MOVES',
            'Risky': 'F_RISKY_ATTACKS', 'Prefer Strongest Move': 'F_PRIORITIZE_DAMAGE', 'Smart Switching': 'F_EXPERT_ATTACKS',
            'Hp Aware': 'F_PRIORITIZE_HEALING', 'Smart Mon Choices': 'F_EXPERT_ATTACKS', 'Omniscient': 'F_EXPERT_ATTACKS'}
RIVAL_CLASSES = ('Rival Early Frlg', 'Rival Late Frlg', 'Champion Frlg')


def trainer_class(t, report):
    c = t.get('Class', '')
    if c in CLASS: return CLASS[c]
    name = t.get('Name', '').upper()
    if c.startswith(('Leader', 'Elite Four')) or name in NAMED and c.startswith('Boss'):
        if name in NAMED: return 'TRAINERCLASS_' + NAMED[name]
    k = c.replace(' Frlg', '')
    v = CLASSES.get(k)
    if v is None:
        report.append('%s: class %s -> Youngster' % (t['id'], c)); return 'TRAINERCLASS_YOUNGSTER'
    if isinstance(v, tuple): v = v[1] if t.get('Gender') == 'Female' else v[0]
    return 'TRAINERCLASS_' + v


def ai_flags(t):
    fl = []
    for part in (t.get('AI') or '').split('/'):
        f = AI_FLAGS.get(part.strip())
        if f and f not in fl: fl.append(f)
    return ' | '.join(fl) or 'F_PRIORITIZE_SUPER_EFFECTIVE'


_LEARN = None


def default_moves(species, level):
    """the last four moves a wild one of that level would know"""
    global _LEARN
    if _LEARN is None: _LEARN = json.load(open(LEARNSETS))
    out = []
    for e in (_LEARN.get(species) or {}).get('LevelMoves', []):
        if e['Level'] <= level and e['Move'] not in out: out.append(e['Move'])
    return out[-4:]


ALIASES = {'MOVE_FAINT_ATTACK': 'MOVE_FEINT_ATTACK', 'MOVE_SOFTBOILED': 'MOVE_SOFT_BOILED'}


def const(name, prefix):
    n = name.strip().upper().replace('♀', '_F').replace('♂', '_M').replace('. ', '_').replace('.', '')
    n = re.sub(r"['’]", '', n)
    n = re.sub(r'[^A-Z0-9]+', '_', n).strip('_')
    return ALIASES.get(prefix + n, prefix + n)


def read_party(path):
    """the .party format: '=== ID ===', 'Key: value' lines, then mons ('Species @ Item', 'Level: n', 'IVs: ...')"""
    out, cur, mon = [], None, None
    for line in open(path):
        line = line.rstrip('\n')
        m = re.match(r'^=== (\w+) ===$', line)
        if m:
            cur = {'id': m.group(1), 'mons': []}; out.append(cur); mon = None; continue
        if cur is None or not line.strip() or line.startswith(('/*', '*/')): continue
        if line.startswith('- '):
            if mon: mon.setdefault('moves', []).append(line[2:].strip())
            continue
        k, _, v = line.partition(': ')
        if mon is None and k in ('Name', 'Class', 'Pic', 'Gender', 'Music', 'Double Battle', 'AI', 'Mugshot', 'Items'):
            cur[k] = v; continue
        if mon is not None and k in ('Level', 'IVs', 'Ability', 'Nature', 'EVs', 'Ball', 'Shiny'):
            mon[k] = v; continue
        if ':' not in line or ' @ ' in line:
            sp, _, item = line.partition(' @ ')
            mon = {'species': sp.strip(), 'item': item.strip()}; cur['mons'].append(mon)
    return out


def ivs(s):
    n = [int(x) for x in re.findall(r'(\d+) \w+', s or '')]
    return round((sum(n) / len(n) if n else 0) * 255 / 31)


def c_text(g, label):
    import port_map
    lines, _ = port_map.text(g.texts.get(label, ''))
    s = ''.join(lines)
    s = re.sub(r'\{STRVAR_1 3, 6, 0\}', 'you', s)          # (battle text can't show the player's name here)
    s = re.sub(r'^\{STRVAR_1 3, 7, 0\}: ', '', s)          # (the speaker's name: it's on the battle screen)
    s = re.sub(r'\{STRVAR_1 3, 7, 0\}', 'I', s)
    s = re.sub(r'\{[^}]*\}', '', s)
    # hg-engine's trainer text takes the message escapes as written: a backslash, then n / r / f
    return s.replace('\\', '\\\\\\\\').replace('"', '\\"').replace('\n', '\\\\n').replace('\r', '\\\\r').replace('\f', '\\\\f')


def rival_texts(g):
    """stage -> {TRMSG_LOSE: label, TRMSG_WIN: label}, from the GBA's rival battles"""
    st, out = rival_stages(), {}
    for l, cmds in g.labels.items():
        for cmd, a in cmds:
            if cmd == 'trainerbattle_earlyrival' and a[0] in st:
                out[st[a[0]]] = {'TRMSG_LOSE': a[2], 'TRMSG_WIN': a[3]}
            elif cmd == 'trainerbattle_no_intro' and a[0] in st:
                out.setdefault(st[a[0]], {'TRMSG_LOSE': a[1]})
    return out


def entry(t, num, known_species, known_items, report, texts=None, known_moves=None):
    lines = ['    [%d] = {   // %s' % (num, t['id']), '        .name = "%s",' % t.get('Name', '').title().replace('"', ''), '        .data = {']
    items = any(m['item'] for m in t['mons'])
    moves = any(m.get('moves') for m in t['mons'])
    kind = ' | '.join(k for k, on in (('TRAINER_DATA_TYPE_MOVES', moves), ('TRAINER_DATA_TYPE_ITEMS', items)) if on) or 'TRAINER_DATA_TYPE_NOTHING'
    bag = []
    for it in (t.get('Items') or '').split('/'):
        if it.strip():
            c = const(it, 'ITEM_')
            if c in known_items: bag.append(c)
            else: report.append('%s: bag item %s not in hg-engine' % (t['id'], c))
    bag = (bag + ['ITEM_NONE'] * 4)[:4]
    lines += ['            .trainerType = %s,' % kind,
              '            .trainerClass = %s,' % trainer_class(t, report),
              '            .items = { %s },' % ', '.join(bag),
              '            .aiFlags = %s,' % (AI if t.get('Class') in RIVAL_CLASSES else ai_flags(t)),
              '            .battleType = %s,' % ('DOUBLE_BATTLE' if t.get('Double Battle') == 'Yes' and len(t['mons']) > 1 else 'SINGLE_BATTLE'),
              '        },', '        .party = {']
    for m in t['mons']:
        sp = const(m['species'], 'SPECIES_')
        if sp not in known_species: report.append('%s: species %s not in hg-engine' % (t['id'], sp)); sp = 'SPECIES_RATTATA'
        lines += ['            {', '                .ivs = %d,' % ivs(m.get('IVs')), '                .abilitySlot = TRAINER_POKEMON_ABILITY_1,',
                  '                .level = %s,' % m.get('Level', '5'), '                .species = %s,' % sp]
        if items:
            it = const(m['item'], 'ITEM_') if m['item'] else 'ITEM_NONE'
            if it not in known_items: report.append('%s: item %s not in hg-engine' % (t['id'], it)); it = 'ITEM_NONE'
            lines.append('                .item = %s,' % it)
        if moves:
            mv = [const(x, 'MOVE_') for x in m.get('moves', [])] or default_moves(sp, int(m.get('Level', '5')))
            ok = []
            for x in mv:
                if known_moves is not None and x not in known_moves: report.append('%s: move %s not in hg-engine' % (t['id'], x))
                else: ok.append(x)
            lines.append('                .moves = { %s },' % ', '.join((ok + ['MOVE_NONE'] * 4)[:4]))
        lines += ['                .ballSeal = 0,', '            },']
    lines.append('        },')
    if texts:
        lines.append('        .text = {')
        for k, v in texts.items():
            lines += ['            {', '                .type = %s,' % k, '                .text = "%s",' % v, '            },']
        lines.append('        },')
    lines += ['    },', '']
    return lines


def trainer_scripts(g):
    """GBA trainer id -> (the trainerbattle command, its args, the label it's in, the commands after it)"""
    out = {}
    for l, cmds in g.labels.items():
        for i, (cmd, a) in enumerate(cmds):
            if cmd.startswith('trainerbattle') and a and a[0].startswith('TRAINER_') and a[0] not in out:
                out[a[0]] = (cmd, a, l, cmds[i + 1:])
    return out


def after_text(rest):
    """the line after a simple trainer's battle: skip the rematch check and fame checker, then msgbox X + end"""
    rest = [c for c in rest if c[0] not in ('famechecker',)]
    if rest and rest[0][0] == 'specialvar' and 'ShouldTryRematchBattle' in rest[0][1]:
        rest = rest[2:]
    if len(rest) >= 2 and rest[0][0] == 'msgbox' and (rest[1][0] == 'end' or rest[1][0] == 'release' and len(rest) > 2 and rest[2][0] == 'end'):
        return rest[0][1][0]
    return None


def simple_trainers():
    """GBA trainer ids whose whole script is battle + one line after: HeartGold's own trainer script does them"""
    g = G.Gba()
    out = set()
    for tid, (cmd, a, l, rest) in trainer_scripts(g).items():
        if cmd in ('trainerbattle_single', 'trainerbattle_double') and len(a) <= (3 if cmd == 'trainerbattle_single' else 4) \
                and g.labels[l][0][0] == cmd and after_text(rest):
            out.add(tid)
    return out


def trainer_texts(g, tid, ts):
    if tid not in ts: return {}
    cmd, a, l, rest = ts[tid]
    t = {}
    if cmd in ('trainerbattle_single', 'trainerbattle_double', 'trainerbattle_rematch', 'trainerbattle_rematch_double'):
        t['TRMSG_INTRO'], t['TRMSG_LOSE'] = a[1], a[2]
        if cmd.endswith('double'):
            t.update(TRMSG_DBL_INTRO_1=a[1], TRMSG_DBL_LOSE_1=a[2])
            if len(a) > 3 and not a[3].startswith(('Script', 'EventScript')) and a[3] in g.texts: t['TRMSG_DBL_1POKE_1'] = a[3]
    elif cmd == 'trainerbattle_no_intro':
        t['TRMSG_LOSE'] = a[1]
    after = after_text(rest)
    if after:
        t['TRMSG_AFTER'] = after
        if cmd.endswith('double'): t['TRMSG_DBL_AFTER_1'] = after
    return {k: v for k, v in t.items() if v in g.texts}


def main():
    ids = json.load(open(IDS)) if os.path.exists(IDS) else {}
    known_species = set(re.findall(r'#define\s+(SPECIES_\w+)', open(ENGINE_SPECIES).read()))
    known_items = set(re.findall(r'#define\s+(ITEM_\w+)', open(ENGINE_ITEMS).read()))
    report, out, order = [], ['// Pokemon Canvas: trainers from the GBA game, by tools/canvas/port/trainers.py. Do not edit.', ''], []
    known_moves = set(re.findall(r'#define\s+(MOVE_\w+)', open(ENGINE_MOVES).read()))
    teams = read_party(G.P('src/data/rival_teams_frlg.party'))
    others = [t for t in read_party(G.P('src/data/trainers_frlg.party'))
              if t['id'] != 'TRAINER_NONE' and t.get('Class') not in RIVAL_CLASSES]
    teams += others
    for t in teams:
        if t['id'] not in ids: ids[t['id']] = FIRST + len(ids)
    by_num = sorted(teams, key=lambda t: ids[t['id']])
    nums = [ids[t['id']] for t in by_num]
    assert nums == list(range(FIRST, FIRST + len(nums))), 'trainer ids must run on from %d with no gaps' % FIRST
    g = G.Gba()
    rt = rival_texts(g)
    stages = sorted(set(rival_stages().values()), key=len, reverse=True)
    ts = trainer_scripts(g)
    for t in by_num:
        if t['id'].startswith('RIVAL_TEAM_'):
            stage = next((st for st in stages if t['id'].startswith('RIVAL_TEAM_%s_' % st)), None)
            labels = rt.get(stage, {})
        else:
            labels = trainer_texts(g, t['id'], ts)
        texts = {k: c_text(g, v) for k, v in labels.items()}
        out += entry(t, ids[t['id']], known_species, known_items, report, texts, known_moves)
        order.append('    %d,' % ids[t['id']])
    open(os.path.join(DATA, 'canvas_trainers.h'), 'w').write('\n'.join(out))
    open(os.path.join(DATA, 'canvas_trainer_order.h'), 'w').write('\n'.join(['// (see canvas_trainers.h)'] + order) + '\n')
    json.dump(ids, open(IDS, 'w'), indent=1)
    print('%d trainers (%d..%d)' % (len(ids), FIRST, FIRST + len(ids) - 1))
    for r in report: print('  ' + r)


# ---------------------------------------------------------------- the rival's battles, for the porter
def rival_stages():
    """GBA rival trainer id -> stage name (LAB, CERULEAN...), from GetRivalStage in src/gym_hack.c"""
    src = open(G.P('src/gym_hack.c')).read()
    body = src[src.index('static u32 GetRivalStage(u32 trainerId)'):]
    body = body[:body.index('\n}\n')]
    out, pending = {}, []
    for line in body.split('\n'):
        m = re.match(r'\s*case (TRAINER_\w+):', line)
        if m: pending.append(m.group(1)); continue
        m = re.match(r'\s*return RIVAL_STAGE_(\w+);', line)
        if m:
            for p in pending: out[p] = m.group(1)
            pending = []
    return out


def trainer_ids():
    """GBA trainer id -> our trainer number"""
    return json.load(open(IDS)) if os.path.exists(IDS) else {}


def double_trainers():
    """our trainer numbers that fight double battles (data/canvas_trainers.h): HeartGold starts one by naming the
    trainer twice (its SetupAndStartTrainerBattle: the same trainer on both sides is a double battle)"""
    h = os.path.join(os.path.dirname(IDS), 'canvas_trainers.h')
    if not os.path.exists(h): return set()
    return {int(n) for n, t in re.findall(r'\[(\d+)\] = \{.*?\.battleType = (\w+)', open(h).read(), re.S) if t == 'DOUBLE_BATTLE'}


def rival_team_ids():
    """stage -> {rival type name: canvas trainer id}"""
    ids = json.load(open(IDS)) if os.path.exists(IDS) else {}
    out = {}
    for k, v in ids.items():
        m = re.match(r'RIVAL_TEAM_(\w+)_(FIRE|WATER|FIGHTING|PSYCHIC|DARK|GROUND|STEEL|ICE|ELECTRIC|POISON|GRASS|ROCK)$', k)
        if m: out.setdefault(m.group(1), {})[m.group(2)] = v
    return out


if __name__ == '__main__':
    main()
