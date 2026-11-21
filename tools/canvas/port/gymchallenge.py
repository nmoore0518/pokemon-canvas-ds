"""The GBA game's challenges at the player's own gym (data/scripts/gym_challenge.inc, src/gym_challenge.c) on
HeartGold: Oak's aide sends challengers in one at a time until one beats the player; the streak, the record, the
prize and a gift per win, the badge for whoever ends the streak, the names on the gym statue.

The challengers: a random strong team (our engine builds it: CanvasCandidate 14), or now and then a famous trainer
(the Kanto leaders and the Elite Four) with their own team at the player's level (CanvasCandidate 15, the levels
moved after HeartGold builds the team). The story has changed since the GBA game: in Kanto the player masters only
their starter's type, so the streak's mastery battle (their mentor, at full strength) is for that type alone, and
Oak's type switches wait for the new areas. Still to come: the townsfolk challengers, the battle stage and the
practice trainers (both are gym decorations), the Move Extractor gift, Oak as a famous challenger.

Our records are vars of ours (GymChallengeSave's): the streak, the best, wins, losses; the statue keeps the last
VICTORS who beat the player (a class or a famous trainer, and a name)."""
import re
import gba as G
import challengers as CH

GYM_TRAINERS = 'TRAINER_CANVAS_GYM_%d'           # (one a defeat line: trainers.py)
GYM_DOUBLES = 'TRAINER_CANVAS_GYM_DOUBLE_%d'
KIND = {'TRAINER': 0, 'FAMOUS': 1, 'TOWNSFOLK': 2, 'BOSS': 3}      # (GYM_CHALLENGER_*)
MASTERY_STREAK = 15                               # (GYM_SWITCH_FIRST_STREAK)
FAMOUS_EVERY = 7
VICTORS = 4
LOCALID = 'LOCALID_PALLET_GYM_CHALLENGER'
REWARD_ITEMS = ['ITEM_RARE_CANDY', 'ITEM_RARE_CANDY', 'ITEM_NUGGET', 'ITEM_NUGGET', 'ITEM_PP_UP', 'ITEM_FULL_RESTORE',
                'ITEM_MAX_REVIVE', 'ITEM_MAX_ELIXIR', 'ITEM_HP_UP', 'ITEM_PROTEIN', 'ITEM_IRON', 'ITEM_CALCIUM',
                'ITEM_ZINC', 'ITEM_CARBOS']
RARE_ITEMS = ['ITEM_GOLD_BOTTLE_CAP', 'ITEM_ABILITY_CAPSULE', 'ITEM_MASTER_BALL']
V = lambda port, n: port.var('CV_GYM_' + n)


def _src():
    return open(G.P('src/gym_challenge.c')).read()


def famous():
    """sFamous, the ones who still battle in Kanto after the story (no Giovanni: he's gone; the rival and Oak need
    teams of their own here) -> [(index, trainer, look, {intro, defeat, after, win})]"""
    body = _src()
    body = body[body.index('sFamous[] ='):]
    body = body[:body.index('\n};')]
    out = []
    for k, chunk in enumerate(re.split(r'\n    \{', body)[1:]):
        m = re.match(r'(TRAINER_\w+|0), OBJ_EVENT_GFX_(\w+),', chunk)
        texts = re.findall(r'COMPOUND_STRING\("((?:[^"\\]|\\.)*)"\)', chunk)
        if m.group(1) in ('0', 'TRAINER_LEADER_GIOVANNI', 'TRAINER_CHAMPION_FIRST_SQUIRTLE'): continue
        out.append((k, m.group(1), m.group(2), dict(zip(('intro', 'defeat', 'after', 'win'), texts))))
    return out


def team_average(tid):
    import trainers as TR
    t = next(t for t in TR.read_party(G.P('src/data/trainers_frlg.party')) if t['id'] == tid)
    lv = [int(m['Level']) for m in t['mons']]
    return (sum(lv) + len(lv) // 2) // len(lv)


def boss_texts():
    """GenerateBoss's lines (STR_VAR_1 the mentor, STR_VAR_2 the type, STR_VAR_3 the streak so far)"""
    body = _src()
    body = body[body.index('static void GenerateBoss'):]
    body = body[body.index('SetTexts('):body.index('sKind = GYM_CHALLENGER_BOSS')]
    texts = [''.join(re.findall(r'"((?:[^"\\]|\\.)*)"', s)) for s in re.split(r'\),\s*\n\s*COMPOUND_STRING\(', body)]
    return dict(zip(('intro', 'defeat', 'after', 'win'), texts))


def _lines(kind):
    return CH.strings({'intro': 'sTrainerIntros', 'defeat': 'sTrainerDefeats', 'after': 'sTrainerAfters', 'win': 'sTrainerWins'}[kind])


def _say(port, key, gba_text):
    import port_map as PM
    if key not in port.msgs: port.msgs[key] = PM.text(gba_text); port.msg_order.append(key)
    out = []
    if 'player' in port.msgs[key][1]: out.append('BufferPlayersName 6')
    return out + ['NPCMsg %s_%s' % (port.bank, key), 'WaitButton']


def _mentor_famous(port, lines_for):
    """a chain on the player's type: lines_for(sFamous index of their mentor)"""
    import candidacy as CA
    return CA._by_mentor(port, lambda w, t: lines_for(w))


def _famous_name(port, slot, k):
    return 'CanvasBufferMsg %d, %s' % (slot, port.own_msg('cv_famous_%d' % k, next(f[2] for f in famous() if f[0] == k).replace('LT_SURGE', 'Lt. Surge').title()))


# ---------------------------------------------------------------- the specials
def is_open(port, ret):
    ret = ret or 'VAR_SPECIAL_RESULT'
    yes = port.new('open')
    return ['SetVar %s, 0' % ret, 'GoToIfUnset %s, %s' % (port.flag('FLAG_PALLET_GYM_AWARDED'), yes), 'SetVar %s, 1' % ret, yes + ':']


def buffer_record(port, ret):
    """STR_VAR_1 the streak, _2 the best, _3 and _4 wins and losses (the GBA's "wins-losses" in one)"""
    return ['BufferInt 0, %s' % V(port, 'STREAK'), 'BufferInt 1, %s' % V(port, 'BEST'), 'BufferInt 2, %s' % V(port, 'WINS'),
            'BufferInt 3, %s' % V(port, 'LOSSES')]


def buffer_goal(port, ret):
    """the aide: VAR_RESULT = the mastery battle's still ahead in this streak (the starter's type, once); STR_VAR_1 the
    streak it takes"""
    ret = ret or 'VAR_SPECIAL_RESULT'
    no = port.new('goal')
    return ['SetVar 0x401E, %d' % MASTERY_STREAK, 'BufferInt 0, 0x401E', 'SetVar %s, 0' % ret,
            'GoToIfSet %s, %s' % (port.flag('CV_GYM_MASTERED'), no),
            'CompareVarToValue %s, %d' % (V(port, 'STREAK'), MASTERY_STREAK), 'GoToIfGe %s' % no, 'SetVar %s, 1' % ret, no + ':']


def next_challenger(port, ret):
    """GymChallenge_NextChallenger -> VAR_RESULT the kind. The mastery battle at MASTERY_STREAK (the starter's type,
    once); a famous trainer every 7th of a streak and 1 in 6 otherwise; else a random trainer"""
    import specials as SP
    import port_map as PM
    ret = ret or 'VAR_SPECIAL_RESULT'
    F = famous()
    boss, fam, trainer, done = port.new('boss'), port.new('famous'), port.new('trainer'), port.new('next')
    out = ['GoToIfUnset %s, %s' % (port.flag('FLAG_PALLET_GYM_AWARDED'), trainer), 'GoToIfSet %s, %s' % (port.flag('CV_GYM_MASTERED'), fam + '_roll'),
           'CompareVarToValue %s, %d' % (V(port, 'STREAK'), MASTERY_STREAK - 1), 'GoToIfEq %s' % boss,
           fam + '_roll:', 'CompareVarToValue %s, %d' % (V(port, 'SEVEN'), FAMOUS_EVERY - 1), 'GoToIfEq %s' % fam,
           'Random 0x401E, 12', 'CompareVarToValue 0x401E, 2', 'GoToIfLt %s' % fam, 'GoTo %s' % trainer]
    # the mentor at full strength
    out += [boss + ':', 'SetVar %s, %d' % (V(port, 'KIND'), KIND['BOSS'])]
    out += _mentor_famous(port, lambda k: ['SetVar %s, %d' % (V(port, 'FAMOUS'), k)])
    out += SP.candidate_mentor_name(port, None) + ['GoTo %s' % (fam + '_set')]
    # a famous trainer
    out += [fam + ':', 'SetVar %s, %d' % (V(port, 'KIND'), KIND['FAMOUS']), 'Random 0x401E, %d' % len(F)]
    out += SP.chain(port, '0x401E', [(i, ['SetVar %s, %d' % (V(port, 'FAMOUS'), f[0])]) for i, f in enumerate(F)])
    out += [fam + '_set:']
    plus = port.new('plus')
    out += SP.chain(port, V(port, 'FAMOUS'), [
        (k, ['SetVar %s, %s' % (port.var('VAR_OBJ_GFX_ID_0'), port.val('OBJ_EVENT_GFX_' + gfx)),
             'SetVar 0x401E, 0', 'CompareVarToValue %s, %d' % (V(port, 'KIND'), KIND['BOSS']), 'GoToIfNe %s_%d' % (plus, k),
             'SetVar 0x401E, 3', '%s_%d:' % (plus, k),
             'CanvasCandidate 15, %d, %d, 0x401E' % (PM.TRAINER_IDS[tid], team_average(tid))]) for k, tid, gfx, _ in F])
    out += ['CopyVar %s, %s' % (ret, V(port, 'KIND')), 'GoTo %s' % done]
    # a random trainer: their look, name and lines
    out += [trainer + ':', 'SetVar %s, %d' % (V(port, 'KIND'), KIND['TRAINER']), 'CanvasCandidate 14',
            'CopyVar %s, VAR_SPECIAL_RESULT' % V(port, 'CLASS'), 'CopyVar %s, 0x8005' % V(port, 'NAME')]
    out += SP.chain(port, V(port, 'CLASS'), [(k, ['SetVar %s, %s' % (port.var('VAR_OBJ_GFX_ID_0'), port.val('OBJ_EVENT_GFX_' + gfx))])
                                            for k, (cls, female, gfx) in enumerate(CH.classes())])
    for k in ('intro', 'defeat', 'after', 'win'):
        out.append('Random %s, %d' % (V(port, k.upper()), len(_lines(k))))
    out += ['SetVar %s, 0' % V(port, 'DOUBLE'), 'Random 0x401E, 3', 'CompareVarToValue 0x401E, 0', 'GoToIfEq %s_single' % trainer,
            'SetVar %s, 1' % V(port, 'DOUBLE'), '%s_single:' % trainer, 'SetVar %s, %d' % (ret, KIND['TRAINER'])]
    return out + [done + ':']


def walk(port, ret):
    """GymChallenge_PlanChallengerWalk (VAR_0x8004: 0 in, 1 out): in, from the door to the player (our engine's
    search), the challenger put at the door; out: VAR_RESULT = whether they walked in"""
    lid = port.localid(LOCALID)
    out_, done = port.new('cwalk'), port.new('cwalk')
    # (the player turns to the door first, as after every later win: the GBA's player has walked to the stage facing
    # it; ours stays by the aide, and the walk ends in front of them - facing the aide, that square's taken)
    return ['CompareVarToValue 0x8004, 1', 'GoToIfEq %s' % out_,
            'ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterDown', 'WaitMovement',
            'CanvasCandidate 4, 1', 'CompareVarToValue VAR_SPECIAL_RESULT, 0',
            'GoToIfEq %s' % done, 'CanvasCandidate 17, %s, 0x8005, 0x8006' % lid, 'GoTo %s' % done,
            out_ + ':', 'CanvasCandidate 6', done + ':']


def walk_apply(port, ret):
    """applymovement LOCALID_PALLET_GYM_CHALLENGER, gGymChallengeChallengerPath (in or out, VAR_0x8004)"""
    lid = port.localid(LOCALID)
    out_, done = port.new('capply'), port.new('capply')
    return ['CompareVarToValue 0x8004, 1', 'GoToIfEq %s' % out_, 'CanvasCandidate 5, %s, 0' % lid, 'WaitMovement',
            'CanvasCandidate 2, %s' % lid, 'GoTo %s' % done, out_ + ':', 'CanvasCandidate 5, %s, 1' % lid, 'WaitMovement', done + ':']


def say_line(kind):
    """msgbox gGymChallenge<kind>Text: the challenger's own line"""
    def special(port, ret):
        import specials as SP
        B = boss_texts()
        out, done = [], port.new('gline')
        trainer, boss = port.new('gline'), port.new('gline')
        out += ['CompareVarToValue %s, %d' % (V(port, 'KIND'), KIND['TRAINER']), 'GoToIfEq %s' % trainer,
                'CompareVarToValue %s, %d' % (V(port, 'KIND'), KIND['BOSS']), 'GoToIfEq %s' % boss]
        out += SP.chain(port, V(port, 'FAMOUS'), [(k, _say(port, 'cv_famous_%s_%d' % (kind, k), t[kind])) for k, _, _, t in famous()])
        out += ['GoTo %s' % done, boss + ':', 'BufferTypeName 1, %s' % port.var('VAR_PLAYER_TYPE'), 'CopyVar 0x401E, %s' % V(port, 'STREAK'),
                'BufferInt 2, 0x401E'] + _say(port, 'cv_boss_%s' % kind, B[kind]) + ['GoTo %s' % done]
        out += [trainer + ':'] + SP.chain(port, V(port, kind.upper()), [(i, _say(port, 'cv_gym_%s_%d' % (kind, i), t))
                                                                        for i, t in enumerate(_lines(kind))], done)
        return out
    return special


def battle(port, ret):
    """the challenger's battle: a random trainer's (one of ours, by their defeat line), or the famous trainer's own;
    losing ends the streak (no black out); VAR_RESULT = 1 won"""
    import specials as SP
    import port_map as PM
    out, done, fam = ['CanvasCloseMsg'], port.new('gbattle'), port.new('gbattle')
    out += ['CompareVarToValue %s, %d' % (V(port, 'KIND'), KIND['TRAINER']), 'GoToIfNe %s' % fam]
    for double in (0, 1):
        for k in range(len(_lines('defeat'))):
            n = PM.TRAINER_IDS[(GYM_DOUBLES if double else GYM_TRAINERS) % k]
            nxt = port.new('gbattle')
            out += ['CompareVarToValue %s, %d' % (V(port, 'DOUBLE'), double), 'GoToIfNe %s' % nxt,
                    'CompareVarToValue %s, %d' % (V(port, 'DEFEAT'), k), 'GoToIfNe %s' % nxt,
                    'ClearTrainerFlag %d' % n, 'TrainerBattle %d, %d, 1, 0' % (n, n if double else 0), 'GoTo %s' % done, nxt + ':']
    out += ['GoTo %s' % done, fam + ':']
    out += SP.chain(port, V(port, 'FAMOUS'), [
        (k, ['ClearTrainerFlag %d' % PM.TRAINER_IDS[tid],
             'TrainerBattle %d, %d, 1, 0' % (PM.TRAINER_IDS[tid], PM.TRAINER_IDS[tid] if PM.TRAINER_IDS[tid] in PM.DOUBLES else 0)])
        for k, tid, _, _ in famous()], done)
    return out + ['CheckBattleWon VAR_SPECIAL_RESULT', 'CanvasCandidate 12']


def _challenger_name(port, slot):
    """the challenger's name into a slot: a famous trainer's, or ours"""
    import specials as SP
    trainer, done = port.new('gname'), port.new('gname')
    return (['CompareVarToValue %s, %d' % (V(port, 'KIND'), KIND['TRAINER']), 'GoToIfEq %s' % trainer]
            + SP.chain(port, V(port, 'FAMOUS'), [(k, [_famous_name(port, slot, k)]) for k, _, _, _ in famous()])
            + ['GoTo %s' % done, trainer + ':', 'CanvasCandidate 16, %d, %s' % (slot, V(port, 'NAME')), done + ':'])


def record_win(port, ret):
    """the streak, the best (VAR_RESULT = a new best), the prize (2000 and 200 a win up to 40, twice that for anyone
    but a random trainer), the gift (VAR_0x8009); STR_VAR_1 the prize, _2 the streak, _3 the challenger"""
    import specials as SP
    ret = ret or 'VAR_SPECIAL_RESULT'
    s, best, wins, seven = V(port, 'STREAK'), V(port, 'BEST'), V(port, 'WINS'), V(port, 'SEVEN')
    capped, notbest = port.new('win'), port.new('win')
    out = ['AddVar %s, 1' % s, 'AddVar %s, 1' % wins, 'AddVar %s, 1' % seven, 'CompareVarToValue %s, %d' % (seven, FAMOUS_EVERY),
           'GoToIfLt %s' % capped, 'SetVar %s, 0' % seven, capped + ':',
           'SetVar %s, 0' % ret, 'CompareVarToVar %s, %s' % (s, best), 'GoToIfLe %s' % notbest, 'SetVar %s, 1' % ret,
           'CopyVar %s, %s' % (best, s), notbest + ':']
    # (the prize: by the streak, capped at 40)
    cases = []
    for w in range(1, 41):
        m = 2000 + 200 * w
        two = port.new('prize')
        cases.append((w, ['CompareVarToValue %s, %d' % (V(port, 'KIND'), KIND['TRAINER']), 'GoToIfNe %s' % two,
                          'AddMoney %d' % m, 'SetVar 0x401E, %d' % m, 'GoTo %s_d' % two, two + ':', 'AddMoney %d' % (2 * m),
                          'SetVar 0x401E, %d' % (2 * m), two + '_d:']))
    top, mid, done = port.new('prize'), port.new('prize'), port.new('prize')
    out += ['CompareVarToValue %s, 40' % s, 'GoToIfGt %s' % top] + SP.chain(port, s, cases, mid) + ['GoTo %s' % done]
    out += [top + ':', 'CompareVarToValue %s, %d' % (V(port, 'KIND'), KIND['TRAINER']), 'GoToIfNe %s_2' % top,
            'AddMoney 10000', 'SetVar 0x401E, 10000', 'GoTo %s' % done, top + '_2:', 'AddMoney 20000', 'SetVar 0x401E, 20000',
            done + ':']
    out += ['BufferInt 0, 0x401E', 'BufferInt 1, %s' % s] + _challenger_name(port, 2)
    # (the gift: something rare from anyone but a random trainer, on every 10th win and 1 in 16 otherwise)
    rare, common, gdone = port.new('gift'), port.new('gift'), port.new('gift')
    known = [i for i in REWARD_ITEMS if port.val(i) != '0']
    rares = [i for i in RARE_ITEMS if port.val(i) != '0']
    out += ['CompareVarToValue %s, %d' % (V(port, 'KIND'), KIND['TRAINER']), 'GoToIfNe %s' % rare,
            'Random 0x401E, 16', 'CompareVarToValue 0x401E, 0', 'GoToIfEq %s' % rare, 'GoTo %s' % common, rare + ':',
            'Random 0x401E, %d' % len(rares)] + SP.chain(port, '0x401E', [(i, ['SetVar 0x8009, %s' % port.val(it)]) for i, it in enumerate(rares)])
    out += ['GoTo %s' % gdone, common + ':', 'Random 0x401E, %d' % len(known)]
    out += SP.chain(port, '0x401E', [(i, ['SetVar 0x8009, %s' % port.val(it)]) for i, it in enumerate(known)]) + [gdone + ':']
    return out


def record_loss(port, ret):
    """the loss counted; the challenger onto the statue (the newest first); STR_VAR_1 the streak, _2 the best, _3
    who ended it; the streak starts over"""
    s = V(port, 'STREAK')
    out = ['AddVar %s, 1' % V(port, 'LOSSES')]
    for i in range(VICTORS - 1, 0, -1):
        out += ['CopyVar %s, %s' % (V(port, 'VCLASS_%d' % i), V(port, 'VCLASS_%d' % (i - 1))),
                'CopyVar %s, %s' % (V(port, 'VNAME_%d' % i), V(port, 'VNAME_%d' % (i - 1)))]
    fam, done = port.new('loss'), port.new('loss')
    out += ['CompareVarToValue %s, %d' % (V(port, 'KIND'), KIND['TRAINER']), 'GoToIfNe %s' % fam,
            'CopyVar %s, %s' % (V(port, 'VCLASS_0'), V(port, 'CLASS')), 'CopyVar %s, %s' % (V(port, 'VNAME_0'), V(port, 'NAME')),
            'GoTo %s' % done, fam + ':', 'CopyVar %s, %s' % (V(port, 'VCLASS_0'), V(port, 'FAMOUS')),
            'AddVar %s, 100' % V(port, 'VCLASS_0'), done + ':',
            'CompareVarToValue %s, %d' % (V(port, 'VICTORS'), VICTORS), 'GoToIfGe %s_full' % done, 'AddVar %s, 1' % V(port, 'VICTORS'),
            done + '_full:', 'BufferInt 0, %s' % s, 'BufferInt 1, %s' % V(port, 'BEST')]
    out += _challenger_name(port, 2)
    return out + ['CopyVar %s, %s' % (V(port, 'LAST'), s), 'SetVar %s, 0' % s, 'SetVar %s, 0' % V(port, 'SEVEN')]


def after_win(port, ret):
    """GymSwitch_AfterWin: the mentor beaten -> the starter's type is mastered (VAR_RESULT; STR_VAR_1 the type)"""
    ret = ret or 'VAR_SPECIAL_RESULT'
    no = port.new('mastered')
    return ['SetVar %s, 0' % ret, 'CompareVarToValue %s, %d' % (V(port, 'KIND'), KIND['BOSS']), 'GoToIfNe %s' % no,
            'SetFlag %s' % port.flag('CV_GYM_MASTERED'), 'BufferTypeName 0, %s' % port.var('VAR_PLAYER_TYPE'),
            'SetVar %s, 1' % ret, no + ':']


def victor_list(port, ret):
    """the statue: VAR_RESULT = how many names it has (the list itself: _cv_StatueVictors)"""
    ret = ret or 'VAR_SPECIAL_RESULT'
    return ['CopyVar %s, %s' % (ret, V(port, 'VICTORS'))]


def statue_victors(port, ret):
    """msgbox gStringVar4 on the statue: each name on it in turn (the class, then the name: or the famous trainer)"""
    import specials as SP
    line = port.own_msg('cv_statue_victor', '{STRVAR_1 3, 0, 0} {STRVAR_1 3, 1, 0}')
    fline = port.own_msg('cv_statue_famous', '{STRVAR_1 3, 0, 0}')
    out, end = [], port.new('victors')
    for i in range(VICTORS):
        fam, shown = port.new('victor'), port.new('victor')
        out += ['CompareVarToValue %s, %d' % (V(port, 'VICTORS'), i + 1), 'GoToIfLt %s' % end,
                'CompareVarToValue %s, 100' % V(port, 'VCLASS_%d' % i), 'GoToIfGe %s' % fam]
        out += SP.chain(port, V(port, 'VCLASS_%d' % i), [
            (k, ['CanvasBufferMsg 0, %s' % port.own_msg('cv_class_%d' % k, cls)]) for k, (cls, female, gfx) in enumerate(CH.classes())])
        out += ['CanvasCandidate 16, 1, %s' % V(port, 'VNAME_%d' % i), 'NPCMsg %s' % line, 'WaitButton', 'GoTo %s' % shown, fam + ':']
        out += SP.chain(port, V(port, 'VCLASS_%d' % i), [(100 + k, [_famous_name(port, 0, k)]) for k, _, _, _ in famous()])
        out += ['NPCMsg %s' % fline, 'WaitButton', shown + ':']
    return out + [end + ':']


SPECIALS = {
    'GymChallenge_IsOpen': is_open,
    'GymChallenge_BufferRecord': buffer_record,
    'GymSwitch_BufferGoal': buffer_goal,
    # (no battle stage yet - it's a gym decoration: the player battles where they stand)
    'GymChallenge_PlanPlayerWalk': lambda p, r: ['SetVar %s, 1' % (r or 'VAR_SPECIAL_RESULT')],
    'GymChallenge_NextChallenger': next_challenger,
    'GymChallenge_PlanChallengerWalk': walk,
    'GymChallenge_RecordWin': record_win,
    'GymChallenge_RecordLoss': record_loss,
    'GymChallenge_BufferLastResult': lambda p, r: ['BufferInt 0, %s' % V(p, 'LAST'), 'BufferInt 1, %s' % V(p, 'BEST')],
    'GymChallenge_BufferVictorList': victor_list,
    'GymSwitch_AfterWin': after_win,
    '_cv_GymWalk': walk_apply,
    '_cv_GymIntro': say_line('intro'),
    '_cv_GymAfter': say_line('after'),
    '_cv_GymWin': say_line('win'),
    '_cv_GymBattle': battle,
    '_cv_StatueVictors': statue_victors,
    '_cv_GymPlace': lambda p, r: ['CanvasCandidate 17, %s, 0x8005, 0x8006' % p.localid(LOCALID)],
}


def rewrite(g):
    L = g.labels
    for lbl, cmds in list(L.items()):
        if not lbl.startswith(('GymChallenge_EventScript_', 'GymSwitch_EventScript_')): continue
        out, skip = [], 0
        for i, (c, a) in enumerate(cmds):
            if skip: skip -= 1; continue
            if c == 'applymovement' and a[:2] == ['LOCALID_PLAYER', 'gGymChallengePlayerPath']:
                skip = 1 if i + 1 < len(cmds) and cmds[i + 1][0] == 'waitmovement' else 0
                continue                       # (no battle stage yet: the player stays where they are)
            if c == 'applymovement' and a[:2] == [LOCALID, 'gGymChallengeChallengerPath']:
                out.append(('special', ['_cv_GymWalk']))
                skip = 1 if i + 1 < len(cmds) and cmds[i + 1][0] == 'waitmovement' else 0
            elif c == 'setobjectxy' and a == [LOCALID, 'VAR_0x8005', 'VAR_0x8006']:
                out.append(('special', ['_cv_GymPlace']))
            elif c == 'msgbox' and a and a[0] in ('gGymChallengeIntroText', 'gGymChallengeAfterText', 'gGymChallengeWinText'):
                out.append(('special', ['_cv_Gym' + a[0][len('gGymChallenge'):-len('Text')]]))
            elif c == 'msgbox' and a and a[0] == 'gStringVar4' and lbl == 'GymChallenge_EventScript_Statue':
                out.append(('special', ['_cv_StatueVictors']))
            elif c == 'cleartrainerflag' and a == ['TRAINER_GYM_CHALLENGER']:
                k = next(j for j in range(i, len(cmds)) if cmds[j][0] == 'specialvar' and cmds[j][1][1] == 'GetBattleOutcome')
                out.append(('special', ['_cv_GymBattle']))
                skip = k - i
            elif c == 'goto_if_set' and a and a[0] == 'FLAG_GYM_RUN_MASTERED':
                continue                       # (after the mastery: Oak's switches, for the new areas)
            elif c == 'msgbox' and a and a[0] == 'GymSwitch_Text_OakWillCome':
                continue                       # (Oak's type switches wait for the new areas: nothing to promise)
            else:
                out.append((c, a))
        L[lbl] = out
    # (the goal: only the starter's type is mastered here - the rest in the new areas - so Oak's plans aren't promised)
    g.texts['GymSwitch_Text_AideGoal'] = "Your goal: {STR_VAR_1} wins in a row!\\nDo that, and you'll have mastered\\lyour type!$"
    # (the record "wins-losses" in one placeholder on the GBA: two here)
    for t in ('GymChallenge_Text_AideWelcome', 'GymChallenge_Text_StatueLeader'):
        g.texts[t] = g.texts[t].replace('{STR_VAR_3}', '{STR_VAR_3}-{STR_VAR_4}').replace('\\n(wins-losses).', ' (wins-losses).')
