"""Canvas: the GBA game's specials (its C functions that scripts call), written as HeartGold script.

    special(port, name, retvar) -> list of script lines, or None if we don't have that special yet

Most of the GBA game's specials are small: a table lookup, setting a few vars, buffering names. Those are done
here in script, so they need no engine code. The ones that need the engine (party checks, the gym challenge...)
come later as hg-engine script commands.
"""
import os, re
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
    # GBA: B_OUTCOME_WON 1, B_OUTCOME_LOST 2
    ret = ret or 'VAR_SPECIAL_RESULT'
    l = port.new('won')
    return ['CheckBattleWon %s' % ret, 'CompareVarToValue %s, 1' % ret, 'GoToIfEq %s' % l, 'SetVar %s, 2' % ret, l + ':']


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
        if len(texts) == 3: out[t] = (int(who, 0) if who[0].isdigit() else who, *texts)
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


SPECIALS = {
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
    'GymCandidate_BufferMentorName': candidate_mentor_name,
    'GetBattleOutcome': battle_outcome,
    # The gym's decorations (and the practice trainers that come with them) aren't in yet: keep its people
    # who depend on them out of sight, and draw nothing extra.
    'GymDecor_SetupTrainers': lambda p, r: ['SetFlag %s' % p.flag('FLAG_HIDE_PALLET_GYM_TRAINER_%d' % i) for i in range(11)],
    'GymDecor_DrawRoom': lambda p, r: [],
    'Gauntlet_OnTransition': lambda p, r: ['SetFlag %s' % p.flag('FLAG_HIDE_GAUNTLET_FIGURE')],
    'Gauntlet_OnLoad': lambda p, r: [],
    'GymLegend_OnLoad': lambda p, r: [],
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
    # outfits aren't in yet: nothing is unlocked
    'Outfit_CheckUnlocked': lambda p, r: ['SetVar VAR_SPECIAL_RESULT, 0'],
    'Outfit_CountUnlocked': lambda p, r: ['SetVar VAR_SPECIAL_RESULT, 1'],
    'Outfit_CatchUp': lambda p, r: [],
    'Outfit_GiveGymUniform': lambda p, r: [],
}

CALLNATIVE_NO_OPS = ('UpdateFollowingPokemon',)


def special(port, name, ret):
    f = SPECIALS.get(name)
    return None if f is None else f(port, ret)
