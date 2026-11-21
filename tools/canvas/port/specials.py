"""Canvas: the GBA game's specials (its C functions that scripts call), written as HeartGold script.

    special(port, name, retvar) -> list of script lines, or None if we don't have that special yet

Most of the GBA game's specials are small: a table lookup, setting a few vars, buffering names. Those are done
here in script, so they need no engine code. The ones that need the engine (party checks, the gym challenge...)
come later as hg-engine script commands.
"""
import json, os, re
import gba as G

# ---------------------------------------------------------------- the starters (src/gym_hack.c, sStarters)
def _starters():
    src = open(G.P('src/gym_hack.c')).read()
    body = src[src.index('sStarters[] ='):]
    body = body[:body.index('};')]
    out = []
    for sp, rival, own in re.findall(r'\{\s*(SPECIES_\w+),\s*TYPE_(\w+)\s*\},\s*//\s*(\w+)', body):
        out.append((sp, own.upper(), rival))
    return out


STARTERS = _starters()          # [(species, its type, the rival's type)] in the lab's menu order


def _type(port, name):
    return port.val('TYPE_' + name)


def chain(port, var, cases, done=None):
    """CompareVarToValue var, v / GoToIfNe next / lines / GoTo done, for each (v, lines)"""
    done = done or port.new('done')
    out = []
    for v, lines in cases:
        nxt = port.new('next')
        out += ['CompareVarToValue %s, %s' % (var, v), 'GoToIfNe %s' % nxt] + lines + ['GoTo %s' % done, nxt + ':']
    return out + [done + ':']


def starter_for(t):
    return next((sp for sp, own, _ in STARTERS if own == t), 'SPECIES_NONE')


# ---------------------------------------------------------------- the specials
def prepare_starter_choice(port, ret):
    # VAR_RESULT = the menu index -> VAR_TEMP_2 = the species; STR_VAR_1 its name, STR_VAR_2 its type
    sp, t = port.var('VAR_TEMP_2'), '0x401E'
    cases = [(i, ['SetVar %s, %s' % (sp, s), 'SetVar %s, %s' % (t, _type(port, own))]) for i, (s, own, _) in enumerate(STARTERS)]
    return chain(port, 'VAR_SPECIAL_RESULT', cases) + ['BufferSpeciesName 0, %s, 0, 0' % sp, 'BufferTypeName 1, %s' % t]


def lock_in_player_type(port, ret):
    sp, player, rival, rsp = port.var('VAR_TEMP_2'), port.var('VAR_PLAYER_TYPE'), port.var('VAR_RIVAL_TYPE'), port.var('VAR_TEMP_3')
    cases = [(s, ['SetVar %s, %s' % (player, _type(port, own)), 'SetVar %s, %s' % (rival, _type(port, r)),
                  'SetVar %s, %s' % (rsp, starter_for(r))]) for s, own, r in STARTERS]
    return chain(port, sp, cases)


def buffer_rival_choice(port, ret):
    rival = port.var('VAR_RIVAL_TYPE')
    types = sorted(set(r for _, _, r in STARTERS))
    cases = [(_type(port, r), ['BufferSpeciesName 0, %s, 0, 0' % starter_for(r)]) for r in types]
    return chain(port, rival, cases) + ['BufferTypeName 1, %s' % port.var('VAR_PLAYER_TYPE'), 'BufferTypeName 2, %s' % rival]


def frlg_pokedex_count(port, ret):
    # VAR_0x8005 / 8006 = seen / caught (the Kanto count comes with our own Pokedex; the national one stands in);
    # returns whether the National Pokedex is on
    l = port.new('dex')
    out = ['CountNationalDexSeen 0x8005', 'CountNationalDexOwned 0x8006']
    if ret:
        out += ['SetVar %s, 0' % ret, 'GoToIfUnset %s, %s' % (port.flag('FLAG_SYS_NATIONAL_DEX'), l), 'SetVar %s, 1' % ret, l + ':']
    return out


def is_national_dex(port, ret):
    l = port.new('dex')
    return ['SetVar %s, 0' % ret, 'GoToIfUnset %s, %s' % (port.flag('FLAG_SYS_NATIONAL_DEX'), l), 'SetVar %s, 1' % ret, l + ':']


def battle_outcome(port, ret):
    # the last battle's outcome, as the GBA numbers them: HeartGold's 1 won, 2 lost, 3 drew, 4 caught, 5 ran, 6 it
    # fled; the GBA's B_OUTCOME_WON 1, LOST 2, DREW 3, RAN 4, MON_FLED 6, CAUGHT 7
    ret = ret or 'VAR_SPECIAL_RESULT'
    a, z = port.new('outcome'), port.new('outcome')
    return ['GetStaticEncounterOutcome %s' % ret, 'CompareVarToValue %s, 4' % ret, 'GoToIfNe %s' % a, 'SetVar %s, 7' % ret,
            'GoTo %s' % z, a + ':', 'CompareVarToValue %s, 5' % ret, 'GoToIfNe %s' % z, 'SetVar %s, 4' % ret, z + ':']


def mastered_flag(port, t):
    """the flag for a mastered gym type (the GBA game counts FLAG_GYM_TYPE_MASTERED + its own type number)"""
    return port.flag('FLAG_GYM_TYPE_MASTERED_' + t)


def gym_rooms_oak_reward(port, ret):
    # VAR_RESULT = the gym room the player has earned and doesn't have yet (1 back, 2 left, 3 right), STR_VAR_1 how many
    # kinds it took; 0 if none (every 100 caught)
    done, n = port.new('rooms'), '0x401E'
    out = ['SetVar VAR_SPECIAL_RESULT, 0', 'GoToIfUnset %s, %s' % (port.flag('FLAG_PALLET_GYM_OPEN'), done),
           'CountNationalDexOwned %s' % n]
    for i, f in enumerate(('FLAG_GYM_ROOM_BACK', 'FLAG_GYM_ROOM_LEFT', 'FLAG_GYM_ROOM_RIGHT')):
        nxt = port.new('room')
        out += ['GoToIfSet %s, %s' % (port.flag(f), nxt), 'CompareVarToValue %s, %d' % (n, (i + 1) * 100),
                'GoToIfLt %s' % done, 'SetVar VAR_SPECIAL_RESULT, %d' % (i + 1), 'BufferInt 0, %d' % ((i + 1) * 100),
                'GoTo %s' % done, nxt + ':']
    return out + [done + ':']


def event_mons_partner_ready(port, ret):
    # 1: Electric mastered and no Pikachu yet; 2: Normal mastered and no Eevee yet
    done, b = port.new('partner'), port.new('partner')
    return ['SetVar VAR_SPECIAL_RESULT, 0',
            'GoToIfUnset %s, %s' % (mastered_flag(port, 'ELECTRIC'), b), 'GoToIfSet %s, %s' % (port.flag('FLAG_EVENT_PARTNER_PIKACHU'), b),
            'SetVar VAR_SPECIAL_RESULT, 1', 'GoTo %s' % done, b + ':',
            'GoToIfUnset %s, %s' % (mastered_flag(port, 'NORMAL'), done), 'GoToIfSet %s, %s' % (port.flag('FLAG_EVENT_PARTNER_EEVEE'), done),
            'SetVar VAR_SPECIAL_RESULT, 2', done + ':']


LEADERS = ['BROCK', 'MISTY', 'SURGE', 'ERIKA', 'KOGA', 'SABRINA', 'BLAINE', 'GIOVANNI']


def candidate_approvals(port, ret):
    out = ['SetVar VAR_SPECIAL_RESULT, 0']
    for who in LEADERS:
        l = port.new('appr')
        out += ['GoToIfUnset %s, %s' % (port.flag('FLAG_GYM_APPROVAL_' + who), l), 'AddVar VAR_SPECIAL_RESULT, 1', l + ':']
    return out + ['BufferInt 0, VAR_SPECIAL_RESULT']


MENTORS = {   # the player's type -> the leader or Elite Four member who mentors it (src/gym_candidate.c, sMentors)
    'ROCK': 'Brock', 'NORMAL': 'Brock', 'WATER': 'Misty', 'ELECTRIC': 'Lt. Surge', 'STEEL': 'Lt. Surge', 'GRASS': 'Erika',
    'POISON': 'Koga', 'BUG': 'Koga', 'PSYCHIC': 'Sabrina', 'FAIRY': 'Sabrina', 'FIRE': 'Blaine', 'GROUND': 'Bruno',
    'DARK': 'Agatha', 'ICE': 'Lorelei', 'FIGHTING': 'Bruno', 'GHOST': 'Agatha', 'DRAGON': 'Lance', 'FLYING': 'Lance'}


def candidate_mentor_name(port, ret):
    pt = port.var('VAR_PLAYER_TYPE')
    cases = [(_type(port, t), ['CanvasBufferMsg 0, %s' % port.own_msg('cv_name_' + re.sub(r'\W', '', who), who),
                               'SetVar VAR_SPECIAL_RESULT, 1']) for t, who in MENTORS.items()]
    return ['SetVar VAR_SPECIAL_RESULT, 0'] + chain(port, pt, cases)


ELITE_FOUR = ['LORELEI', 'BRUNO', 'AGATHA', 'LANCE']       # (src/gym_candidate.c: 8-11)


def _elite_four():
    """src/gym_candidate.c sEliteFour: each one's approval, when they don't mentor the player's type"""
    src = open(G.P('src/gym_candidate.c')).read()
    body = src[src.index('sEliteFour[GYM_CANDIDATE_ELITE_FOUR] ='):].split('};')[0]
    return dict(re.findall(r'\{COMPOUND_STRING\("(\w+)"\),\s*\w+,\s*COMPOUND_STRING\("((?:[^"\\]|\\.)*)"\)\}', body))


def elite_four_approval(port, ret):
    """VAR_0x8009 = an Elite Four member (8-11) -> gStringVar4 = their approval (their mentor's line, if they mentor
    the player's type)"""
    pt, who = port.var('VAR_PLAYER_TYPE'), port.var('VAR_0x8009')
    own = _elite_four()
    cases = []
    for i, name in enumerate(ELITE_FOUR):
        k = port.str4('cv_e4_approve_%s' % name.lower(), own[name])
        mine = [(_type(port, t), ['SetVar %s, %d' % (SCRATCH4, port.str4('cv_mentor_approve_%s' % t.lower(), approve))])
                for t, (w, intro, first, approve) in MENTOR_TEXTS.items() if w == 8 + i]
        cases.append((8 + i, ['SetVar %s, %d' % (SCRATCH4, k)] + (chain(port, pt, mine) if mine else [])))
    return chain(port, who, cases)


def hall_of_fame(port, ret):
    """EnterHallOfFame: HeartGold's Hall of Fame and save (engine: CanvasHallOfFame), then as the GBA's
    SetWarpsToRollCredits: the credits scene outside the League (it ends at CB2_StartCreditsSequence)"""
    w = port.warp(['MAP_INDIGO_PLATEAU_EXTERIOR', '11', '6'])
    return ['CanvasHallOfFame', 'RestoreOverworld', 'SetVar %s, 1' % port.var('VAR_MAP_SCENE_INDIGO_PLATEAU_EXTERIOR'),
            'Warp %s, 0, %s, %s, DIR_SOUTH' % w, 'FadeScreen 6, 1, 1, RGB_BLACK', 'WaitFade']


# the Cinnabar Lab's doctor revives any fossil in the bag (src/medical_center.c sFossils: the Vermilion
# foreman's dig turns up more than FireRed's three)
FOSSILS = [('ITEM_HELIX_FOSSIL', 'SPECIES_OMANYTE', 'Helix Fossil'), ('ITEM_DOME_FOSSIL', 'SPECIES_KABUTO', 'Dome Fossil'),
           ('ITEM_OLD_AMBER', 'SPECIES_AERODACTYL', 'Old Amber'), ('ITEM_ROOT_FOSSIL', 'SPECIES_LILEEP', 'Root Fossil'),
           ('ITEM_CLAW_FOSSIL', 'SPECIES_ANORITH', 'Claw Fossil'), ('ITEM_SKULL_FOSSIL', 'SPECIES_CRANIDOS', 'Skull Fossil'),
           ('ITEM_ARMOR_FOSSIL', 'SPECIES_SHIELDON', 'Armor Fossil')]
OLD_FOSSILS = {1: 'SPECIES_OMANYTE', 2: 'SPECIES_KABUTO', 3: 'SPECIES_AERODACTYL'}     # (FireRed's 1-3, older saves)


def fossil_list(port, ret):
    """Fossil_PushList: the fossils in the bag as the next menu (each item there only while the bag has it; its
    value is its place in FOSSILS); VAR_RESULT = how many"""
    ret = ret or 'VAR_SPECIAL_RESULT'
    out = ['SetVar %s, 0' % ret]
    port.dyn = []
    for i, (item, _, name) in enumerate(FOSSILS):
        skip = port.new('fossil')
        out += ['HasItem %s, 1, 0x401E' % item, 'CompareVarToValue 0x401E, 0', 'GoToIfEq %s' % skip, 'AddVar %s, 1' % ret, skip + ':']
        port.own_msg('cv_fossil_%d' % i, name)
        port.dyn.append(('cv_fossil_%d' % i, str(i), item))
    return out


def fossil_pick(port, ret):
    """Fossil_Pick: the menu's choice -> VAR_0x8005 its item; STR_VAR_1 the Pokemon, STR_VAR_2 the fossil"""
    v = port.var('VAR_0x8005')
    return chain(port, 'VAR_SPECIAL_RESULT', [(str(i), ['SetVar %s, %s' % (v, item), 'BufferSpeciesName 0, %s, 0, 0' % sp,
                                                       'BufferItemName 1, %s' % item]) for i, (item, sp, _) in enumerate(FOSSILS)])


def fossil_revived(port, ret):
    """Fossil_BufferRevived: VAR_0x8005 (the fossil's item, or FireRed's 1-3) -> VAR_0x8004 its Pokemon, STR_VAR_1 its name"""
    v, out = port.var('VAR_0x8005'), port.var('VAR_0x8004')
    cases = [(item, sp) for item, sp, _ in FOSSILS] + [(str(k), sp) for k, sp in OLD_FOSSILS.items()]
    return ['SetVar %s, 0' % out] + chain(port, v, [(k, ['SetVar %s, %s' % (out, sp)]) for k, sp in cases]) + \
        ['BufferSpeciesName 0, %s, 0, 0' % out]


def hop_off(port, d):
    """the GBA's CreateStopSurfingTask: off the Pokemon and a hop onto the land ahead (`d`: North, South...)"""
    port.movements['_cv_hop_off_' + d] = [['JumpNearFast' + d, 1]]
    return ['SetAvatarBits 1', 'UpdateAvatarState', 'ApplyMovement obj_player, _cv_hop_off_' + d, 'WaitMovement']


def starter_species(port, ret):
    """GetStarterPokemon: the starter the player took - their type's (the GBA's sStarterMon[VAR_STARTER_MON] is
    FireRed's three, by where the player stood in the lab; theirs is by type)"""
    ret = ret or 'VAR_SPECIAL_RESULT'
    pt = port.var('VAR_PLAYER_TYPE')
    return chain(port, pt, [(_type(port, own), ['SetVar %s, %s' % (ret, sp)]) for sp, own, _ in STARTERS])


def pc_has_space(port, ret):
    """-> TRUE if a box has room"""
    ret, l = ret or 'VAR_SPECIAL_RESULT', port.new('pc')
    return ['CountPCEmptySpace %s' % ret, 'CompareVarToValue %s, 0' % ret, 'GoToIfEq %s' % l, 'SetVar %s, 1' % ret, l + ':']


def _mentors():
    """src/gym_candidate.c sMentors: the player's type -> (leader 0-7 / Elite Four 8-11, intro, first, approve)"""
    src = open(G.P('src/gym_candidate.c')).read()
    body = src[src.index('sMentors[NUMBER_OF_MON_TYPES] ='):]
    body = body[:body.index('\n};')]
    out = {}
    for chunk in body.split('[TYPE_')[1:]:
        m = re.match(r'(\w+)\] = \{(\w+),(.*)', chunk, re.S)
        if not m: continue
        t, who, strs = m.groups()
        texts = re.findall(r'COMPOUND_STRING\("((?:[^"\\]|\\.)*)"\)', strs)
        if len(texts) == 3: out[t] = (int(who, 0) if who[0].isdigit() else ELITE_FOUR.index(who) + 8, *texts)
    return out


MENTOR_TEXTS = _mentors()


def mentor_line(port, ret, which):
    """VAR_0x8009 = a Gym Leader; if they mentor the player's type, VAR_RESULT = 1 and gStringVar4 = their line"""
    pt, who = port.var('VAR_PLAYER_TYPE'), port.var('VAR_0x8009')
    out = ['SetVar VAR_SPECIAL_RESULT, 0']
    for t, (w, intro, first, approve) in MENTOR_TEXTS.items():
        if not isinstance(w, int): continue
        if which == 'prebattle':
            label = 'GymCandidate_Text_PreBattle' + t.capitalize()
            if label not in port.g.texts: continue
            raw = port.g.texts[label]
        else:
            raw = {'first': first, 'approve': approve, 'intro': intro}[which]
        k = port.str4('cv_mentor_%s_%s' % (which, t.lower()), raw)
        nxt = port.new('mentor')
        out += ['CompareVarToValue %s, %d' % (who, w), 'GoToIfNe %s' % nxt, 'CompareVarToValue %s, %s' % (pt, _type(port, t)),
                'GoToIfNe %s' % nxt, 'SetVar %s, %d' % (SCRATCH4, k), 'SetVar VAR_SPECIAL_RESULT, 1', nxt + ':']
    return out


SCRATCH4 = '0x401F'
KANTO_SAFARI_FLAG = 4090            # (our flag number; engine canvas_safari.c CANVAS_FLAG_KANTO_SAFARI)
SAFARI_GATE_DOOR = (1, 8, 4)        # the Fuchsia gate's door into the Safari Zone: its warp, x, z


def _pallet_mart():
    """src/stat_items.c: the Pallet Mart's stock, and the stat items each badge adds -> (base, [(flag, item)])"""
    src = open(G.P('src/stat_items.c')).read()
    base = re.findall(r'ITEM_\w+', src[src.index('sPalletMartBaseItems[] ='):].split('};')[0])
    unlocks = re.findall(r'\{(ITEM_\w+),\s*(FLAG_\w+)\}', src[src.index('sStatItemUnlocks[] ='):].split('};')[0])
    return base, unlocks


def pallet_mart(port, ret):
    """the Pallet Mart: its usual stock, plus the stat items unlocked so far (each badge in turn unlocks more)"""
    base, unlocks = _pallet_mart()
    flags = []
    for item, flag in unlocks:
        if flag not in flags: flags.append(flag)
    done, out = port.new('mart'), []
    stages = [port.new('mart') for _ in flags]
    for f, l in reversed(list(zip(flags, stages))):
        out.append('GoToIfSet %s, %s' % (port.flag(f), l))
    def mart(items):
        v = [port.val(i) for i in items]
        v = [x for x in v if x != '0']
        return ['CanvasMart %d' % len(v)] + ['.short %s' % x for x in v] + ['GoTo %s' % done]
    out += mart(base)
    for k, (f, l) in enumerate(zip(flags, stages)):
        out += [l + ':'] + mart(base + [i for i, fl in unlocks if fl in flags[:k + 1]])
    return out + [done + ':']


def _trades():
    try: return json.load(open(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'data', 'trades.json')))
    except FileNotFoundError: return {}


TRADES = _trades()          # the GBA's trade constant -> HeartGold's trade number (build_trades.py)


def by_trade(port, lines):
    """lines(HeartGold's trade number) for the trade VAR_0x8005 names (the GBA's shared trade scripts copy the
    trade there): HeartGold loads a trade by a number written in the script, so each trade has its own lines"""
    return chain(port, '0x8005', [(port.g.value(t), lines(n)) for t, n in TRADES.items() if port.g.value(t) is not None])


def trade_info(port, ret):
    """GetInGameTradeSpeciesInfo: -> the species asked for; STR_VAR_1 its name, STR_VAR_2 the one offered"""
    ret = ret or 'VAR_SPECIAL_RESULT'
    return by_trade(port, lambda n: ['LoadNPCTrade %d' % n, 'NPCTradeGetReqSpecies %s' % ret, 'GetOfferedSpecies 0x8006',
                                     'NPCTradeEnd', 'BufferSpeciesName 0, %s, 0, 0' % ret, 'BufferSpeciesName 1, 0x8006, 0, 0'])


# HeartGold's own way to choose a Pokemon for a trade (its Power Plant trade's): the party screen, the choice in
# VAR_0x8004 (255: none - past the GBA's PARTY_SIZE, as its scripts test)
CHOOSE_FOR_TRADE = ['CloseMsg', 'FadeScreen 6, 1, 0, RGB_BLACK', 'WaitFade', 'ScrCmd_566', 'GetPartySelection 0x8004', 'RestoreOverworld',
                    'FadeScreen 6, 1, 1, RGB_BLACK', 'WaitFade']


# ---------------------------------------------------------------- the Pokemon Tower's graves (src/tower_graves.c)
def _graves():
    """tools/gym_hack/build_tower_graves.py GRAVES -> [(species or None for DAD's ace, trainer, unevolved)]"""
    src = open(G.P('tools/gym_hack/build_tower_graves.py')).read()
    return [(sp or None, tr, bool(un)) for sp, tr, un in
            re.findall(r'\(\d, \d+, \d+, (?:DAD|"(\w+)"), "([^"]+)"\),[ \t]*(#\s*\(unevolved\))?', src)]


def _dad_aces():
    """src/dad_story.c sDadsAce: TYPE_ -> species"""
    src = open(G.P('src/dad_story.c')).read()
    body = src[src.index('sDadsAce[NUMBER_OF_MON_TYPES] ='):]
    return re.findall(r'\[TYPE_(\w+)\]\s*=\s*(SPECIES_\w+)', body[:body.index('};')])


GRAVES = _graves()
GHOST_FLAG = 'FLAG_TEMP_1F'         # (the girl's and her Scyther's, on 2F-4F)


def tower_graves_read(port, ret):
    # VAR_0x8004 = the grave -> VAR_0x8005 = its Pokemon, STR_VAR_1 its name, STR_VAR_2 its trainer; the unevolved ten
    # each have a flag of ours (the GBA's VAR_TOWER_GRAVES bits); VAR_RESULT = whether the girl comes now (all ten
    # read, and no Eviolate yet)
    sp = '0x8005'
    cases = []
    for i, (species, trainer, unevolved) in enumerate(GRAVES):
        if species is None:
            lines = chain(port, port.var('VAR_PLAYER_TYPE'), [(_type(port, t), ['SetVar %s, %s' % (sp, port.val(a))]) for t, a in _dad_aces()])
            lines = ['SetVar %s, %s' % (sp, port.val('SPECIES_CHARIZARD'))] + lines
        else:
            lines = ['SetVar %s, %s' % (sp, port.val('SPECIES_' + species))]
        name = trainer if trainer == '???' else trainer.capitalize()
        lines.append('CanvasBufferMsg 1, %s' % port.own_msg('cv_grave_trainer_%02d' % i, name))
        if unevolved: lines.append('SetFlag %s' % port.flag('CV_TOWER_GRAVE_%02d' % i))
        cases.append((i, lines))
    done = port.new('graves')
    out = chain(port, '0x8004', cases) + ['BufferSpeciesName 0, %s, 0, 0' % sp, 'SetVar VAR_SPECIAL_RESULT, 0',
                                          'GoToIfSet %s, %s' % (port.flag('FLAG_GOT_EVIOLATE'), done)]
    out += ['GoToIfUnset %s, %s' % (port.flag('CV_TOWER_GRAVE_%02d' % i), done) for i, g in enumerate(GRAVES) if g[2]]
    return out + ['SetVar VAR_SPECIAL_RESULT, 1', done + ':']


def dad_type_ball(port, ret):
    # (Mom's gift from Dad, after Nugget Bridge) VAR_RESULT = the Type Ball of the player's type (tools/canvas/build_items.py)
    ret = ret or 'VAR_SPECIAL_RESULT'
    return ['SetVar %s, %s' % (ret, port.val('ITEM_NORMAL_BALL'))] + chain(
        port, port.var('VAR_PLAYER_TYPE'), [(_type(port, t), ['SetVar %s, %s' % (ret, port.val('ITEM_%s_BALL' % t))]) for t in HG_TYPE_NAMES])


HG_TYPE_NAMES = ['NORMAL', 'FIGHTING', 'FLYING', 'POISON', 'GROUND', 'ROCK', 'BUG', 'GHOST', 'STEEL', 'FIRE', 'WATER', 'GRASS',
                 'ELECTRIC', 'PSYCHIC', 'ICE', 'DRAGON', 'DARK', 'FAIRY']


def gym_has_switched(port, ret):
    # VAR_RESULT = whether the gym has had the player's type before (the GBA's FLAG_GYM_TYPE_OWNED + type: set as the
    # gym changes type, row 28; flags of ours by type)
    ret = ret or 'VAR_SPECIAL_RESULT'
    done = port.new('owned')
    return ['SetVar %s, 0' % ret] + chain(port, port.var('VAR_PLAYER_TYPE'), [
        (_type(port, t), ['GoToIfUnset %s, %s' % (port.flag('FLAG_GYM_TYPE_OWNED_' + t), done), 'SetVar %s, 1' % ret])
        for t in HG_TYPE_NAMES], done)


def _ghosts(port):
    lids = getattr(port, 'people_lids', {})
    return lids.get('OBJ_EVENT_GFX_LITTLE_GIRL_FRLG'), lids.get('OBJ_EVENT_GFX_SPECIES(SCYTHER)')


def tower_ghosts(port, ret, come):
    # the girl and her Scyther flicker in near the player, half there, and later away (engine canvas_candidate.c:
    # CanvasCandidate 18 / 19)
    girl, scyther = _ghosts(port)
    if girl is None or scyther is None: return []
    f = port.flag(GHOST_FLAG)
    if come:
        return ['ClearFlag %s' % f, 'ShowPerson %s' % girl, 'ShowPerson %s' % scyther, 'CanvasCandidate 18, %s, %s' % (girl, scyther)]
    return ['CanvasCandidate 19, %s, %s' % (girl, scyther), 'HidePerson %s' % girl, 'HidePerson %s' % scyther, 'SetFlag %s' % f]


SPECIALS = {
    # the GBA's in-game trades on HeartGold's (build_trades.py; Nick: "In-game trades don't work anywhere yet")
    'GetInGameTradeSpeciesInfo': trade_info,
    'ChoosePartyMon': lambda p, r: list(CHOOSE_FOR_TRADE),
    'GetTradeSpecies': lambda p, r: ['GetPartyMonSpecies 0x8004, %s' % (r or 'VAR_SPECIAL_RESULT')],
    'CreateInGameTradePokemon': lambda p, r: [],
    'DoInGameTradeScene': lambda p, r: by_trade(p, lambda n: ['LoadNPCTrade %d' % n, 'NPCTradeExec 0x8004', 'NPCTradeEnd']),
    # elevators: the floor windows aren't drawn; the ride is HeartGold's elevator shake (ElevatorAnim: up or down
    # by VAR_0x8004, floors by VAR_0x8005 - set from the GBA's floor vars just before)
    'DrawElevatorCurrentFloorWindow': lambda p, r: [], 'CloseElevatorCurrentFloorWindow': lambda p, r: [],
    'GetElevatorFloor': lambda p, r: [],
    'InitElevatorFloorSelectMenuPos': lambda p, r: ['SetVar %s, 0' % r] if r else [],
    'AnimateElevator': lambda p, r: ['ElevatorAnim 1, 2'],
    # Bill's cell separator: the camera stays with the player, the machine's own animation isn't there yet
    'SpawnCameraObject': lambda p, r: [], 'RemoveCameraObject': lambda p, r: [],
    'AnimateTeleporterHousing': lambda p, r: ['PlaySE SEQ_SE_DP_KI_GASYAN', 'WaitSE SEQ_SE_DP_KI_GASYAN'],
    'AnimateTeleporterCable': lambda p, r: [],
    'SetSeenMon': lambda p, r: [],        # (Bill's Eeveelutions on his PC: seen marks come with our Pokedex)
    'GymHack_PalletMart': pallet_mart,
    'DisableMsgBoxWalkaway': lambda p, r: [],
    # (the fossils' pictures: HeartGold has no picture window for them; their text still shows)
    'OpenMuseumFossilPic': lambda p, r: [], 'CloseMuseumFossilPic': lambda p, r: [],
    'GymCandidate_BufferMentorPreBattle': lambda p, r: mentor_line(p, r, 'prebattle'),
    'GymCandidate_BufferMentorFirst': lambda p, r: mentor_line(p, r, 'first'),
    'ShouldTryRematchBattle': lambda p, r: ['SetVar %s, 0' % (r or 'VAR_SPECIAL_RESULT')],     # (rematches come later)
    # the old man's catching demo: HeartGold's own catching tutorial (a Weedle in the GBA game)
    'StartOldManTutorialBattle': lambda p, r: ['CatchingTutorial'],
    # (MissingNo.'s glitch encounter, armed by watching the demo: a flag until Cinnabar's coast is ported)
    'MissingNo_ArmEncounter': lambda p, r: ['SetFlag %s' % p.flag('CV_MISSINGNO_ARMED')],
    'SetUnlockedPokedexFlags': lambda p, r: [],      # (the Pokedex is given with FLAG_SYS_POKEDEX_GET)
    'GymRooms_OakReward': gym_rooms_oak_reward,
    'GymRooms_GiveReward': lambda p, r: chain(p, '0x8004', [(i + 1, ['SetFlag %s' % p.flag(f)]) for i, f in
                                                     enumerate(('FLAG_GYM_ROOM_BACK', 'FLAG_GYM_ROOM_LEFT', 'FLAG_GYM_ROOM_RIGHT'))]),
    'EventMons_PartnerReady': event_mons_partner_ready,
    'GymCandidate_BufferApprovals': candidate_approvals,
    'GymCandidate_BufferEliteFourApproval': elite_four_approval,
    # the Safari Zone: HeartGold's Safari game (its flag, 30 Safari Balls, its Safari battles), with our flag for
    # Kanto's (engine canvas_safari.c: the GBA's Pokemon and 600 steps; HeartGold's ending scripts take you back to
    # the Fuchsia gate - port_map.kanto_safari_std). A battle that runs out of balls ends at the gate's door.
    'EnterSafariMode': lambda p, r: ['SafariZoneAction 0, 0', 'SetFlag 0x%X' % (0x2000 + KANTO_SAFARI_FLAG),
                                     'SetDynamicWarp MAP_FUCHSIA_PAL_PARK_ENTRANCE, %d, %d, %d, 1' % SAFARI_GATE_DOOR],
    'ExitSafariMode': lambda p, r: ['SafariZoneAction 1, 0', 'ClearFlag 0x%X' % (0x2000 + KANTO_SAFARI_FLAG)],
    # Seafoam's falls into the current (currents.py): the player surfs, and on B4F gets off onto land to the north
    # (HeartGold sends a Pokemon to the first box with room: never "the box was full")
    'ShouldShowBoxWasFullMessage': lambda p, r: ['SetVar %s, 0' % (r or 'VAR_SPECIAL_RESULT')],
    'GetPCBoxToSendMon': lambda p, r: ['SetVar %s, 0' % (r or 'VAR_SPECIAL_RESULT')],
    'SetWalkingIntoSignVars': lambda p, r: [],      # (the GBA hack's does nothing: its body is commented out)
    'GetRandomSlotMachineId': lambda p, r: ['SetVar %s, 0' % (r or 'VAR_SPECIAL_RESULT')],   # (HeartGold's game: by machine)
    # the GBA's camera shake (VAR_0x8004 up and down, 0x8005 side to side, 0x8006 shakes, 0x8007 frames between):
    # HeartGold's ScreenShake (side to side, up and down, frames between, shakes)
    'ShakeCamera': lambda p, r: ['ScreenShake %s, %s, %s, %s' % (p.var('VAR_0x8005'), p.var('VAR_0x8004'), p.var('VAR_0x8007'), p.var('VAR_0x8006'))],
    'Fossil_PushList': fossil_list,
    'Fossil_Pick': fossil_pick,
    'Fossil_BufferRevived': fossil_revived,
    'ForcePlayerToStartSurfing': lambda p, r: ['SetAvatarBits 4', 'UpdateAvatarState'],
    'SeafoamIslandsB4F_CurrentDumpsPlayerOnLand': lambda p, r: hop_off(p, 'North'),
    'ScriptCheckFreePokemonStorageSpace': pc_has_space,
    # the League (HeartGold's rooms have their own lights; the trainer fan club is on Five Island, which isn't here)
    'DoPokemonLeagueLightingEffect': lambda p, r: [],
    'Script_TryGainNewFanFromCounterFrlg': lambda p, r: [], 'Script_UpdateTrainerFanClubGameClear': lambda p, r: [],
    'GetStarterPokemon': starter_species,
    'EnterHallOfFame': hall_of_fame,
    'CB2_StartCreditsSequence': lambda p, r: ['FadeScreen 6, 1, 0, RGB_BLACK', 'WaitFade', 'CanvasCredits'],
    # the GBA game's team rules (src/gym_hack.c: TEAM_RULES_GYM, all three), checked by our engine
    'GymHack_CheckTeamSpecial': lambda p, r: ['CanvasCheckTeam 7, %s' % p.var('VAR_PLAYER_TYPE')] + (['CopyVar %s, VAR_SPECIAL_RESULT' % r] if r else []),
    'GymCandidate_BufferMentorName': candidate_mentor_name,
    'GetBattleOutcome': battle_outcome,
    # The gym's decorations (and the practice trainers that come with them) aren't in yet: keep its people
    # who depend on them out of sight, and draw nothing extra.
    'GymDecor_SetupTrainers': lambda p, r: ['SetFlag %s' % p.flag('FLAG_HIDE_PALLET_GYM_TRAINER_%d' % i) for i in range(11)],
    'GymDecor_DrawRoom': lambda p, r: [],
    'Gauntlet_OnTransition': lambda p, r: ['SetFlag %s' % p.flag('FLAG_HIDE_GAUNTLET_FIGURE')],
    'Gauntlet_OnLoad': lambda p, r: [],
    'GymDecor_MarkUnlocksSeen': lambda p, r: [],      # (the gym decorations come later)
    'GymHack_PrepareStarterChoice': prepare_starter_choice,
    'GymHack_LockInPlayerType': lock_in_player_type,
    'GymHack_BufferRivalChoice': buffer_rival_choice,
    'GetFrlgPokedexCount': frlg_pokedex_count,
    'IsNationalPokedexEnabled': is_national_dex,
    'EnableNationalPokedex': lambda p, r: ['SetFlag %s' % p.flag('FLAG_SYS_NATIONAL_DEX')],
    'HealPlayerParty': lambda p, r: ['HealParty'],
    'ChangePokemonNickname': lambda p, r: ['NicknameInput 0x8004, VAR_SPECIAL_RESULT'],
    'DrawWholeMapView': lambda p, r: [],
    # (sets the flag whose number is in VAR_0x8004: the GBA's Silph Co. doors and hidden items)
    'SetHiddenItemFlag': lambda p, r: ['SetFlagVar 0x8004'],
    # outfits aren't in yet: nothing is unlocked
    'Outfit_CheckUnlocked': lambda p, r: ['SetVar VAR_SPECIAL_RESULT, 0'],
    'Outfit_CountUnlocked': lambda p, r: ['SetVar VAR_SPECIAL_RESULT, 1'],
    'Outfit_CatchUp': lambda p, r: [],
    'Outfit_GiveGymUniform': lambda p, r: [],
    'TowerGraves_Read': tower_graves_read,
    'DadStory_GetGymTypeBall': dad_type_ball,
    'GymSwitch_HasSwitched': gym_has_switched,
    'TowerGraves_SummonGhosts': lambda p, r: tower_ghosts(p, r, True),
    'TowerGraves_DismissGhosts': lambda p, r: tower_ghosts(p, r, False),
}

CALLNATIVE_NO_OPS = ('UpdateFollowingPokemon',)


def special(port, name, ret):
    f = SPECIALS.get(name)
    return None if f is None else f(port, ret)
