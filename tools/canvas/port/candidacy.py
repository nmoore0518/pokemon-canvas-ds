"""The GBA game's candidacy (data/scripts/gym_candidate.inc, src/gym_candidate.c) on HeartGold: after each badge the
leader asks the player to hold their gym against one or two challengers ("Guest Leader" battles) for their approval;
the League's door wants all eight.

The leaders' lines and numbers are read from src/gym_candidate.c (gGymCandidateLeaders); the challengers come from
our engine (engine/src/canvas_candidate.c, CanvasCandidate: built at the time, and the walks in and out, worked out
over the map), their lines from src/gym_challenge.c (challengers.py), picked here at random as the GBA's are.

rewrite(g): the shared scripts' commands that hand the engine's work to the GBA's C (its walks in RAM, its
challenger's lines in RAM, its trainer slot) become ours. SPECIALS: the GymCandidate_* specials they call."""
import re
import gba as G
import challengers as CH

LEADER_FLAGS = ['BROCK', 'MISTY', 'SURGE', 'ERIKA', 'KOGA', 'SABRINA', 'BLAINE', 'GIOVANNI']
MENTOR_GIFT_NONE = 0
# vars of ours for the challenger's lines (picked as it's built; shown later in the same scene)
VARS = {k: 'CV_CHALLENGER_' + k.upper() for k in ('intro', 'defeat', 'after', 'win', 'double')}


def leaders():
    """gGymCandidateLeaders -> [{name, guests, level, partySize, tier, offer, approve, repeatOffer, ...}] (0-7)"""
    src = open(G.P('src/gym_candidate.c')).read()
    body = src[src.index('gGymCandidateLeaders[GYM_CANDIDATE_LEADERS] ='):]
    body = body[:body.index('\n};')]
    out = []
    for chunk in re.split(r'\n    \[\d\] = \{', body)[1:]:
        d = {k: v for k, v in re.findall(r'\.(\w+) = COMPOUND_STRING\("((?:[^"\\]|\\.)*)"\)', chunk)}
        d.update({k: int(v) for k, v in re.findall(r'\.(guests|level|partySize|tier) = (\d+)', chunk)})
        out.append(d)
    assert len(out) == 8
    return out


def _name_msg(port, i, L):
    return port.own_msg('cv_leader_%d' % i, L[i]['name'].title())


def leader_line(field):
    """VAR_0x8009 = the leader -> gStringVar4 = their `field` line"""
    def special(port, ret):
        import specials as SP
        L = leaders()
        return SP.chain(port, port.var('VAR_0x8009'), [(i, ['SetVar %s, %d' % (SP.SCRATCH4, port.str4('cv_leader_%s_%d' % (field, i), L[i][field]))])
                                                       for i in range(8)])
    return special


def is_approved(port, ret):
    import specials as SP
    ret = ret or 'VAR_SPECIAL_RESULT'
    out = ['SetVar %s, 0' % ret]
    for i, f in enumerate(LEADER_FLAGS):
        nxt = port.new('appr')
        out += ['CompareVarToValue %s, %d' % (port.var('VAR_0x8009'), i), 'GoToIfNe %s' % nxt,
                'GoToIfUnset %s, %s' % (port.flag('FLAG_GYM_APPROVAL_' + f), nxt), 'SetVar %s, 1' % ret, nxt + ':']
    return out


def more_guests(port, ret):
    """VAR_RESULT = another challenger to come (VAR_0x800B beaten so far; one on a later shift, VAR_0x8007)"""
    import specials as SP
    ret = ret or 'VAR_SPECIAL_RESULT'
    n, l = port.var('VAR_0x800B'), port.new('guests')
    out = ['SetVar %s, 0' % ret, 'SetVar 0x401E, 1', 'CompareVarToValue %s, 0' % port.var('VAR_0x8007'), 'GoToIfNe %s' % l]
    out += SP.chain(port, port.var('VAR_0x8009'), [(i, ['SetVar 0x401E, %d' % L['guests']]) for i, L in enumerate(leaders())])
    yes = port.new('guests')
    return out + [l + ':', 'CompareVarToVar %s, 0x401E' % n, 'GoToIfGe %s' % yes, 'SetVar %s, 1' % ret, yes + ':']


def approve(port, ret):
    """the leader approves (their flag); gStringVar4 = what they say (their mentor's line, if they mentor the
    player's type); STR_VAR_1 = the approvals so far"""
    import specials as SP
    L, pt = leaders(), port.var('VAR_PLAYER_TYPE')
    cases = []
    for i, f in enumerate(LEADER_FLAGS):
        lines = ['SetFlag %s' % port.flag('FLAG_GYM_APPROVAL_' + f), 'SetVar %s, %d' % (SP.SCRATCH4, port.str4('cv_leader_approve_%d' % i, L[i]['approve']))]
        mine = [(SP._type(port, t), ['SetVar %s, %d' % (SP.SCRATCH4, port.str4('cv_mentor_approve_%s' % t.lower(), appr))])
                for t, (w, intro, first, appr) in SP.MENTOR_TEXTS.items() if w == i]
        cases.append((i, lines + (SP.chain(port, pt, mine) if mine else [])))
    return SP.chain(port, port.var('VAR_0x8009'), cases) + SP.candidate_approvals(port, None)


def hold_text(port, ret):
    """gStringVar4: the leader watching from aside, or (a shift, VAR_0x8007) gone and the player in charge"""
    import specials as SP
    L, l = leaders(), port.new('hold')
    shift = port.str4('cv_hold_shift', '{STR_VAR_3} left you in charge of\\nthe GYM.')
    out = ['CompareVarToValue %s, 0' % port.var('VAR_0x8007'), 'GoToIfEq %s' % l]
    out += SP.chain(port, port.var('VAR_0x8009'), [(i, ['CanvasBufferMsg 2, %s' % _name_msg(port, i, L)]) for i in range(8)])
    out += ['SetVar %s, %d' % (SP.SCRATCH4, shift)]
    done = port.new('hold')
    out += ['GoTo %s' % done, l + ':'] + SP.chain(port, port.var('VAR_0x8009'), [
        (i, ['SetVar %s, %d' % (SP.SCRATCH4, port.str4('cv_leader_observe_%d' % i, L[i]['observe']))]) for i in range(8)])
    return out + [done + ':']


def generate_guest(port, ret):
    """GymCandidate_GenerateGuest: the next challenger, at the leader's level, party size and tier (a later shift,
    VAR_0x8007: one at the player's own level); STR_VAR_3 = the leader; their look and lines picked here"""
    import specials as SP
    import port_map as PM
    L = leaders()
    out = []
    for i in range(8):
        nxt = port.new('guest')
        out += ['CompareVarToValue %s, %d' % (port.var('VAR_0x8009'), i), 'GoToIfNe %s' % nxt,
                'CanvasBufferMsg 2, %s' % _name_msg(port, i, L),
                'CanvasCandidate 0, %d, %d, %d, %s' % (L[i]['level'], L[i]['partySize'], L[i]['tier'], port.var('VAR_0x8007')),
                nxt + ':']
    # (its look: the class the engine picked, as the GBA's sClasses has it)
    looks = []
    for k, (cls, female, gfx) in enumerate(CH.classes()):
        looks.append((k, ['SetVar %s, %s' % (port.var('VAR_OBJ_GFX_ID_0'), port.val('OBJ_EVENT_GFX_' + gfx))]))
    out += SP.chain(port, 'VAR_SPECIAL_RESULT', looks)
    T = CH.guest_texts()
    for k in ('intro', 'defeat', 'after', 'win'):
        out.append('Random %s, %d' % (port.var(VARS[k]), len(T[k])))
    # (singles, or from the fourth badge on two in three doubles: the GBA's DecideFormat)
    single = port.new('single')
    out += ['SetVar %s, 0' % port.var(VARS['double']), 'GoToIfUnset %s, %s' % (port.flag('FLAG_BADGE04_GET'), single),
            'Random 0x401E, 3', 'CompareVarToValue 0x401E, 0', 'GoToIfEq %s' % single, 'SetVar %s, 1' % port.var(VARS['double']), single + ':']
    return out


def say_line(kind):
    """msgbox gGymChallenge<kind>Text: the line picked for this challenger"""
    def special(port, ret):
        import port_map as PM
        T = CH.guest_texts()[kind]
        out, done = [], port.new('line')
        for i, t in enumerate(T):
            key = 'cv_guest_%s_%d' % (kind, i)
            if key not in port.msgs: port.msgs[key] = PM.text(t); port.msg_order.append(key)
            nxt = port.new('line')
            out += ['CompareVarToValue %s, %d' % (port.var(VARS[kind]), i), 'GoToIfNe %s' % nxt]
            bufs = port.msgs[key][1]
            if 'player' in bufs: out.append('BufferPlayersName 6')
            out += ['NPCMsg %s_%s' % (port.bank, key), 'WaitButton', 'GoTo %s' % done, nxt + ':']
        return out + [done + ':']
    return special


def battle(port, ret):
    """the challenger's battle (trainerbattle_no_intro TRAINER_GYM_CHALLENGER): the trainer of the defeat line picked,
    single or double; losing doesn't black out (the leader comes back); VAR_RESULT = 1 won (B_OUTCOME_WON)"""
    import port_map as PM
    out, done = ['CanvasCloseMsg'], port.new('battle')
    for double in (0, 1):
        for k in range(len(CH.guest_texts()['defeat'])):
            n = PM.TRAINER_IDS[(CH.GUEST_DOUBLES if double else CH.GUEST_TRAINERS) % k]
            nxt = port.new('battle')
            out += ['CompareVarToValue %s, %d' % (port.var(VARS['double']), double), 'GoToIfNe %s' % nxt,
                    'CompareVarToValue %s, %d' % (port.var(VARS['defeat']), k), 'GoToIfNe %s' % nxt,
                    'ClearTrainerFlag %d' % n, 'TrainerBattle %d, %d, 1, 0' % (n, n if double else 0), 'GoTo %s' % done, nxt + ':']
    return out + [done + ':', 'CheckBattleWon VAR_SPECIAL_RESULT', 'CanvasCandidate 12']


def cmd(op, *args):
    return lambda port, ret: ['CanvasCandidate %d%s' % (op, ''.join(', %s' % (port.var(a) if a.startswith('VAR_') else a) for a in args))]


SPECIALS = {
    'GymCandidate_IsApproved': is_approved,
    'GymCandidate_BufferOffer': leader_line('offer'),
    'GymCandidate_BufferRepeatOffer': leader_line('repeatOffer'),
    'GymCandidate_BufferRepeatThanks': leader_line('repeatThanks'),
    'GymCandidate_BufferOwnGym': leader_line('ownGym'),
    'GymCandidate_MoreGuests': more_guests,
    'GymCandidate_Approve': approve,
    'GymCandidate_BufferHoldText': hold_text,
    'GymCandidate_GenerateGuest': generate_guest,
    'GymCandidate_PlaceGuest': cmd(1),
    'GymCandidate_FaceGuest': cmd(2, 'VAR_0x800A'),
    'GymCandidate_FaceBack': cmd(3),
    'GymCandidate_PlanChallengerWalk': cmd(4, '1'),
    'GymCandidate_PlanVisitorWalk': cmd(4, '0'),
    'GymCandidate_VisitorWalked': cmd(6),
    'GymCandidate_PlanHold': cmd(7),
    'GymCandidate_HoldLeaderAside': cmd(8, 'VAR_0x8007'),
    'GymCandidate_IsHolding': cmd(9),
    'GymCandidate_HoldLeaderBack': cmd(10),
    'GymChallenge_EndPractice': cmd(12),
    '_cv_GuestIntro': say_line('intro'),
    '_cv_GuestAfter': say_line('after'),
    '_cv_GuestWin': say_line('win'),
    '_cv_GuestBattle': battle,
}


# ---------------------------------------------------------------- the mentor (Oak's lab, then the gyms' gifts)
MENTOR_FIELDS = ('guardGift', 'edgeGift', 'story', 'question', 'yes', 'no', 'farewell')


def mentor_people():
    """sMentorPeople: who (0-11) -> {gfx, guardGift, edgeGift, story, question, yes, no, farewell}"""
    src = open(G.P('src/gym_candidate.c')).read()
    body = src[src.index('} sMentorPeople['):]
    body = body[:body.index('\n};')]
    out = []
    for chunk in re.split(r'\n    \{OBJ_EVENT_GFX_', body)[1:]:
        gfx = re.match(r'(\w+),', chunk).group(1)
        texts = re.findall(r'COMPOUND_STRING\("((?:[^"\\]|\\.)*)"\)', chunk)
        out.append(dict(gfx=gfx, **dict(zip(MENTOR_FIELDS, texts))))
    assert len(out) == 12, len(out)
    return out


def _by_mentor(port, lines_for):
    """a chain on the player's type: lines_for(who, type) for the type's mentor"""
    import specials as SP
    return SP.chain(port, port.var('VAR_PLAYER_TYPE'), [(SP._type(port, t), lines_for(w, t)) for t, (w, *_) in SP.MENTOR_TEXTS.items()])


def mentor_line_of(field):
    """gStringVar4 = the player's mentor's `field` line (their story, question, farewell...)"""
    def special(port, ret):
        import specials as SP
        P = mentor_people()
        return _by_mentor(port, lambda w, t: ['SetVar %s, %d' % (SP.SCRATCH4, port.str4('cv_mentor_%s_%d' % (field, w), P[w][field]))])
    return special


def mentor_answer(port, ret):
    """gStringVar4 = the mentor's reply to the player's yes (VAR_RESULT 1) or no"""
    import specials as SP
    P = mentor_people()
    yes, done = port.new('answer'), port.new('answer')
    return (['CompareVarToValue VAR_SPECIAL_RESULT, 1', 'GoToIfEq %s' % yes]
            + _by_mentor(port, lambda w, t: ['SetVar %s, %d' % (SP.SCRATCH4, port.str4('cv_mentor_no_%d' % w, P[w]['no']))])
            + ['GoTo %s' % done, yes + ':']
            + _by_mentor(port, lambda w, t: ['SetVar %s, %d' % (SP.SCRATCH4, port.str4('cv_mentor_yes_%d' % w, P[w]['yes']))])
            + [done + ':'])


def mentor_intro_prepare(port, ret):
    """the meeting in Oak's lab, once: VAR_RESULT = it happens now; the mentor's look (VAR_OBJ_GFX_ID_0), STR_VAR_1
    their name (the GBA's VAR_MENTOR_STAGE bits are flags of ours)"""
    import specials as SP
    P = mentor_people()
    met, done = port.flag('CV_MENTOR_MET'), port.new('mentor')
    out = ['SetVar VAR_SPECIAL_RESULT, 0', 'GoToIfSet %s, %s' % (met, done), 'SetFlag %s' % met]
    out += _by_mentor(port, lambda w, t: ['SetVar %s, %s' % (port.var('VAR_OBJ_GFX_ID_0'), port.val('OBJ_EVENT_GFX_' + P[w]['gfx']))])
    out += SP.candidate_mentor_name(port, None)      # (STR_VAR_1, and VAR_RESULT = 1)
    return out + [done + ':']


SPECIALS.update({
    'GymCandidate_PrepareMentorIntro': mentor_intro_prepare,
    'GymCandidate_BufferMentorStory': mentor_line_of('story'),
    'GymCandidate_BufferMentorQuestion': mentor_line_of('question'),
    'GymCandidate_BufferMentorFarewell': mentor_line_of('farewell'),
    'GymCandidate_BufferMentorAnswer': mentor_answer,
    'GymCandidate_BufferMentorIntro': lambda p, r: _mentor_intro(p, r),
    # (the housewarming decoration waits on the gym's decorations: none for now)
    'GymCandidate_GiveMentorDecor': lambda p, r: ['SetVar %s, 0' % (r or 'VAR_SPECIAL_RESULT')],
})


def _mentor_intro(port, ret):
    """gStringVar4 = the mentor's introduction (sMentors' intro: by the player's type)"""
    import specials as SP
    return SP.chain(port, port.var('VAR_PLAYER_TYPE'), [
        (SP._type(port, t), ['SetVar %s, %d' % (SP.SCRATCH4, port.str4('cv_mentor_intro_%s' % t.lower(), intro))])
        for t, (w, intro, first, approve) in SP.MENTOR_TEXTS.items()])


def rewrite(g):
    """the shared candidacy scripts' C-side pieces as ours (idempotent)"""
    L = g.labels
    for lbl, cmds in list(L.items()):
        # (the walks and places are the engine's for every visitor: the candidacy's, the Gym Legend's rival, Oak at
        # the gym switch, the Move Extractor's grunt; the challenger's lines and battle are the candidacy's own)
        if not lbl.startswith(('GymCandidate_EventScript_', 'GymLegend_EventScript_', 'GymSwitch_EventScript_',
                               'MoveExtractor_EventScript_')): continue
        guest = lbl.startswith('GymCandidate_EventScript_')
        out, skip = [], 0
        for i, (c, a) in enumerate(cmds):
            if skip: skip -= 1; continue
            if c == 'applymovement' and len(a) > 1 and a[1] in ('gHoldPlayerIn', 'gHoldPlayerOut'):
                out.append(('cv_raw', ['CanvasCandidate 11, %d' % (a[1] == 'gHoldPlayerOut')]))
            elif c == 'applymovement' and len(a) > 1 and a[1] in ('gMentorWalkIn', 'gMentorWalkOut'):
                out.append(('cv_raw', ['CanvasCandidate 5, 0x800A, %d' % (a[1] == 'gMentorWalkOut')]))
            elif c == 'setobjectxyperm' and a == ['VAR_0x800A', 'VAR_0x8005', 'VAR_0x8006']:
                out.append(('cv_raw', ['MovePerson 0x800A, 0x8005, 0x8006']))      # (the engine's squares are ours)
            elif guest and c == 'msgbox' and a and a[0] in ('gGymChallengeIntroText', 'gGymChallengeAfterText', 'gGymChallengeWinText'):
                out.append(('special', ['_cv_Guest' + a[0][len('gGymChallenge'):-len('Text')]]))
            elif guest and c == 'cleartrainerflag' and a == ['TRAINER_GYM_CHALLENGER']:
                # (cleartrainerflag, setflag FLAG_GYM_CHALLENGE_BATTLE, trainerbattle_no_intro, clearflag, EndPractice,
                # specialvar VAR_RESULT, GetBattleOutcome: the battle, VAR_RESULT = won)
                k = next(j for j in range(i, len(cmds)) if cmds[j][0] == 'specialvar' and cmds[j][1][1] == 'GetBattleOutcome')
                out.append(('special', ['_cv_GuestBattle']))
                skip = k - i
            else:
                out.append((c, a))
        L[lbl] = out


# ---------------------------------------------------------------- the mentor's gifts (after the Cerulean and Cinnabar badges)
MENTOR_GIFT_LEADER, MENTOR_GIFT_VISIT = 1, 2
GIFT_GYMS = {1: ('GUARD', 0), 6: ('EDGE', 1)}       # the gym -> (which, sTypeItems' column)


def type_items():
    """src/gym_candidate.c sTypeItems: TYPE -> (the Guard item, the Edge item) (tools/canvas/build_items.py's)"""
    src = open(G.P('src/gym_candidate.c')).read()
    body = src[src.index('sTypeItems[NUMBER_OF_MON_TYPES][2] ='):]
    return {t: (a, b) for t, a, b in re.findall(r'\[TYPE_(\w+)\] = \{(ITEM_\w+), (ITEM_\w+)\}', body[:body.index('};')])}


def mentor_gift_prepare(port, ret):
    """VAR_0x8009 = the gym whose badge was just won: at the Cerulean Gym (1) the mentor gives the Type Guard of the
    player's type, at the Cinnabar Gym (6) the Type Edge, once each (flags of ours for the GBA's VAR_MENTOR_STAGE bits).
    VAR_RESULT = MENTOR_GIFT_*; VAR_0x8004 = the item, VAR_OBJ_GFX_ID_0 = the mentor's look"""
    import specials as SP
    P, items = mentor_people(), type_items()
    ret = ret or 'VAR_SPECIAL_RESULT'
    done = port.new('gift')
    out = ['SetVar %s, %d' % (ret, MENTOR_GIFT_NONE)]
    for gym, (which, col) in GIFT_GYMS.items():
        nxt, gave = port.new('gift'), port.flag('CV_MENTOR_GAVE_' + which)
        out += ['CompareVarToValue %s, %d' % (port.var('VAR_0x8009'), gym), 'GoToIfNe %s' % nxt, 'GoToIfSet %s, %s' % (gave, done)]
        out += _by_mentor(port, lambda w, t: ['SetFlag %s' % gave, 'SetVar 0x8004, %s' % port.val(items[t][col]),
                                              'SetVar %s, %s' % (port.var('VAR_OBJ_GFX_ID_0'), port.val('OBJ_EVENT_GFX_' + P[w]['gfx'])),
                                              'SetVar %s, %d' % (ret, MENTOR_GIFT_LEADER if w == gym else MENTOR_GIFT_VISIT)])
        out += ['GoTo %s' % done, nxt + ':']
    return out + [done + ':']


def mentor_gift_text(port, ret):
    """gStringVar4 = what the mentor says with the gift (VAR_0x8009: 1 the Guard, 6 the Edge)"""
    import specials as SP
    P = mentor_people()
    edge, done = port.new('gift'), port.new('gift')
    line = lambda field: _by_mentor(port, lambda w, t: ['SetVar %s, %d' % (SP.SCRATCH4, port.str4('cv_mentor_%s_%d' % (field, w), P[w][field]))])
    return (['CompareVarToValue %s, 6' % port.var('VAR_0x8009'), 'GoToIfEq %s' % edge] + line('guardGift')
            + ['GoTo %s' % done, edge + ':'] + line('edgeGift') + [done + ':'])


SPECIALS.update({
    'GymCandidate_PrepareMentorGift': mentor_gift_prepare,
    'GymCandidate_BufferMentorGift': mentor_gift_text,
})
