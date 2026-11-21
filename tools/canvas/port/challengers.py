"""The GBA game's challengers built at the time (src/gym_challenge.c, src/gym_candidate.c) as data for our engine
(engine/src/canvas_candidate.c builds them, into trainer TRAINER_GYM_CHALLENGER) and for the porter (their lines).

So far the Guest Leader battles (the candidacy: GymChallenge_GenerateGuest): a random class and name, a team of any
type from the practice pools by tier (BuildTeam), their lines picked at random. Their in-battle defeat line is a
trainer's own text here, so each defeat line is a trainer of its own (GUEST_TRAINERS, made by trainers.py, their
party and name replaced as the battle starts).

    python3 tools/canvas/port/challengers.py     (the porter runs it too) -> tools/canvas/data/canvas_challengers.h
"""
import json, os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.dirname(HERE))
import gba as G
import slots

ENGINE = os.path.join(slots.ROOT, 'engine')
OUT = os.path.join(slots.ROOT, 'tools', 'canvas', 'data', 'canvas_challengers.h')     # (build_rom.sh copies it to engine/data)
SRC = G.P('src/gym_challenge.c')
POOL_LAST_GEN3 = 386          # (SPECIES_DEOXYS: the GBA's random teams draw from the first three generations...)
EEVEELUTIONS = ['ODEON', 'ASSASSEON', 'HYPEREON', 'POISEON', 'SUBTERRANEON', 'OBSIDEON', 'LENNEON', 'APPARITEON',
                'AUTOMATEON', 'VALYREON']    # (...and the new eeveelutions: build_species.py)
LEGENDARY = {'ARTICUNO', 'ZAPDOS', 'MOLTRES', 'MEWTWO', 'MEW', 'RAIKOU', 'ENTEI', 'SUICUNE', 'LUGIA', 'HO_OH', 'CELEBI',
             'REGIROCK', 'REGICE', 'REGISTEEL', 'LATIAS', 'LATIOS', 'KYOGRE', 'GROUDON', 'RAYQUAZA', 'JIRACHI', 'DEOXYS'}
TIER_AI = ['F_PRIORITIZE_SUPER_EFFECTIVE',                                              # Rookie: AI_FLAG_CHECK_BAD_MOVE
           'F_PRIORITIZE_SUPER_EFFECTIVE | F_EVALUATE_ATTACKS | F_PRIORITIZE_DAMAGE',     # Skilled: AI_FLAG_BASIC_TRAINER
           'F_TRAINER_EXPERT_AI | F_PRIORITIZE_DAMAGE']                                 # Expert: AI_FLAG_SMART_TRAINER
GUEST_TRAINERS = 'TRAINER_CANVAS_GUEST_%d'      # (one a defeat line: trainers.py)
GUEST_DOUBLES = 'TRAINER_CANVAS_GUEST_DOUBLE_%d'  # (the same, for a double battle)


def _src():
    return open(SRC).read()


def strings(name, src=None):
    """a GBA array of COMPOUND_STRING(...) -> its strings, as the GBA's text (\\n, \\p, {STR_VAR_3}...)"""
    src = src or _src()
    body = re.search(r'%s\[\]\s*=\s*\{(.*?)\n\};' % re.escape(name), src, re.S).group(1)
    return [''.join(re.findall(r'"((?:[^"\\]|\\.)*)"', s)) for s in re.findall(r'COMPOUND_STRING\((.*?)\)\s*,?\s*$', body, re.M | re.S)]


def guest_texts():
    src = _src()
    return {k: strings(n, src) for k, n in (('intro', 'sGuestIntros'), ('defeat', 'sGuestDefeats'),
                                              ('after', 'sGuestAfters'), ('win', 'sGuestWins'))}


def classes():
    """sClasses: [(the GBA class (trainers.py's name), female, the GBA look)]"""
    body = re.search(r'sClasses\[\]\s*=\s*\{(.*?)\n\};', _src(), re.S).group(1)
    out = []
    for cls, female, gfx in re.findall(r'\{TRAINER_CLASS_(\w+?)(?:_FRLG)?,\s*\w+,\s*(TRUE|FALSE),\s*OBJ_EVENT_GFX_(\w+)\}', body):
        out.append((cls.replace('_', ' ').title(), female == 'TRUE', gfx))
    return out


def hg_class(name, female):
    import trainers as TR
    v = TR.CLASSES.get(name)
    if v is None: return 'TRAINERCLASS_YOUNGSTER'
    if isinstance(v, tuple): v = v[1] if female else v[0]
    return 'TRAINERCLASS_' + v


def names(which):
    """sMaleNames / sFemaleNames, as HeartGold writes names (Aiden)"""
    return [n.title() for n in re.findall(r'COMPOUND_STRING\("(\w+)"\)', re.search(r'%s\[\]\s*=\s*\{(.*?)\};' % which, _src(), re.S).group(1))]


def held_items():
    return re.findall(r'(ITEM_\w+)', re.search(r'sHeldItems\[\]\s*=\s*\{(.*?)\};', _src(), re.S).group(1))


def pool():
    """the species random teams draw from, as our engine needs them: (species, first type, how many times it has
    evolved, whether it evolves, whether it's legendary), from hg-engine's own species and evolutions"""
    sp_src = open(os.path.join(ENGINE, 'data', 'Species.c')).read()
    ev_src = open(os.path.join(ENGINE, 'data', 'Evolutions.c')).read()
    consts = re.findall(r'#define\s+(SPECIES_\w+)\s+(\d+)', open(os.path.join(ENGINE, 'include', 'constants', 'species.h')).read())
    num = {k: int(v) for k, v in consts}
    num.update({'SPECIES_' + e: 1075 + 1 + i for i, e in enumerate(EEVEELUTIONS)})   # (after Pecharunt)
    name = {}
    for k, v in consts: name.setdefault(int(v), k)
    types = {m.group(1): m.group(2) for m in re.finditer(r'\[(SPECIES_\w+)\] = \{.*?\.types = \{ (TYPE_\w+),', sp_src, re.S)}
    evolves = {}
    for m in re.finditer(r'\[(SPECIES_\w+)\] = \{\s*\.entries = \{(.*?)\n    \},', ev_src, re.S):
        evolves[m.group(1)] = [t for t in re.findall(r'\{ EVO_\w+, [^,]+, (SPECIES_\w+) \}', m.group(2)) if t != 'SPECIES_NONE']
    species = [name[i] for i in range(1, POOL_LAST_GEN3 + 1)] + ['SPECIES_' + e for e in EEVEELUTIONS]
    in_pool = set(species)
    pre = {}
    for s in species:
        for t in evolves.get(s, []):
            if t in in_pool and num.get(t, 0) <= POOL_LAST_GEN3: pre[t] = s
    out = []
    for s in species:
        stage, x = 0, s
        if num[s] > POOL_LAST_GEN3: stage = 1           # (the new eeveelutions: Eevee's evolutions)
        else:
            while x in pre and stage < 3: x = pre[x]; stage += 1
        out.append((s, types.get(s, 'TYPE_NORMAL'), stage, bool([t for t in evolves.get(s, []) if t in in_pool]),
                    s[8:] in LEGENDARY))
    return out


def main():
    cls = classes()
    out = ['// Pokemon Canvas: the GBA game\'s challengers (src/gym_challenge.c) for engine/src/canvas_candidate.c.',
           '// tools/canvas/port/challengers.py: don\'t edit.', '',
           'static const struct CanvasChallengerClass sCanvasClasses[] = {']
    for name, female, gfx in cls:
        out.append('    { %s, %d },   // %s %s' % (hg_class(name, female), int(female), name, gfx))
    out += ['};', '']
    for which, var in (('sMaleNames', 'sCanvasMaleNames'), ('sFemaleNames', 'sCanvasFemaleNames')):
        out.append('static const u8 %s[][8] = {' % var)
        for n in names(which):
            assert re.match(r'^[A-Za-z]{1,7}$', n), n          # (the engine spells them out: letters only)
            out.append('    "%s",' % n)
        out += ['};', '']
    out.append('static const u16 sCanvasHeldItems[] = { %s };' % ', '.join(held_items()))
    out += ['', 'static const u32 sCanvasTierAI[] = { %s };' % ', '.join('(%s)' % a for a in TIER_AI), '',
            '// a byte a species, Bulbasaur to Deoxys and then ours: first type (POOL_LEGENDARY: never picked) | stage << 5 | evolves << 7',
            'static const u8 sCanvasPool[] = {']
    for k, (s, t, stage, evo, leg) in enumerate(pool()):
        out.append('    %s | %d << 5 | %d << 7,   // %s' % ('POOL_LEGENDARY' if leg else t, stage, int(evo), s))
    out += ['};', '']
    open(OUT, 'w').write('\n'.join(out))
    return len(cls)


if __name__ == '__main__':
    print('challengers: %d classes' % main(), OUT)
