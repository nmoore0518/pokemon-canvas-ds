"""Canvas: the GBA game's trainers -> hg-engine trainer data.

    python3 tools/canvas/port/trainers.py

Writes tools/canvas/data/canvas_trainers.h (entries appended to hg-engine's sTrainerData, from id 738 on) and
canvas_trainer_order.h (their place in the text order); build_rom.sh copies both into engine/data, where the
engine patch includes them in data/Trainers.c. Ids are kept in tools/canvas/data/canvas_trainers.json (scripts
use the numbers, and saves keep the trainer flags, so an id never moves).

So far: the rival's teams (src/data/rival_teams_frlg.party: one team per stage of the story and per type he can
take). The porter turns each rival battle into a choice on VAR_RIVAL_TYPE (see RIVAL_STAGES).
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


def const(name, prefix):
    n = name.strip().upper().replace('♀', '_F').replace('♂', '_M').replace('. ', '_').replace('.', '')
    n = re.sub(r"['’]", '', n)
    n = re.sub(r'[^A-Z0-9]+', '_', n).strip('_')
    return prefix + n


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


def entry(t, num, known_species, known_items, report, texts=None):
    lines = ['    [%d] = {   // %s' % (num, t['id']), '        .name = "%s",' % t.get('Name', '').title(), '        .data = {']
    items = any(m['item'] for m in t['mons'])
    lines += ['            .trainerType = %s,' % ('TRAINER_DATA_TYPE_ITEMS' if items else 'TRAINER_DATA_TYPE_NOTHING'),
              '            .trainerClass = %s,' % CLASS.get(t.get('Class'), 'TRAINERCLASS_RIVAL'),
              '            .items = { ITEM_NONE, ITEM_NONE, ITEM_NONE, ITEM_NONE },',
              '            .aiFlags = %s,' % AI,
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
        lines += ['                .ballSeal = 0,', '            },']
    lines.append('        },')
    if texts:
        lines.append('        .text = {')
        for k, v in texts.items():
            lines += ['            {', '                .type = %s,' % k, '                .text = "%s",' % v, '            },']
        lines.append('        },')
    lines += ['    },', '']
    return lines


def main():
    ids = json.load(open(IDS)) if os.path.exists(IDS) else {}
    known_species = set(re.findall(r'#define\s+(SPECIES_\w+)', open(ENGINE_SPECIES).read()))
    known_items = set(re.findall(r'#define\s+(ITEM_\w+)', open(ENGINE_ITEMS).read()))
    report, out, order = [], ['// Pokemon Canvas: trainers from the GBA game, by tools/canvas/port/trainers.py. Do not edit.', ''], []
    teams = read_party(G.P('src/data/rival_teams_frlg.party'))
    for t in teams:
        if t['id'] not in ids: ids[t['id']] = FIRST + len(ids)
    by_num = sorted(teams, key=lambda t: ids[t['id']])
    nums = [ids[t['id']] for t in by_num]
    assert nums == list(range(FIRST, FIRST + len(nums))), 'trainer ids must run on from %d with no gaps' % FIRST
    g = G.Gba()
    rt = rival_texts(g)
    stages = sorted(set(rival_stages().values()), key=len, reverse=True)
    for t in by_num:
        stage = next((st for st in stages if t['id'].startswith('RIVAL_TEAM_%s_' % st)), None)
        texts = {k: c_text(g, v) for k, v in rt.get(stage, {}).items()}
        out += entry(t, ids[t['id']], known_species, known_items, report, texts)
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
