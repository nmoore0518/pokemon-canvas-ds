"""The GBA game's finale (data/scripts/gym_finale.inc) on HeartGold: Oak in the Champion's room, the gym's opening
ceremony in Pallet Town, Oak's challenge for the gym (his set team, built by our engine: CanvasCandidate 13), the
Hall of Fame and the credits, and the gym's first day.

HeartGold's rise in front of our Pallet gym is smaller than the GBA's, so the ceremony's crowd carries on down onto
the ground below it (CROWD: people of ours, there only for the ceremony)."""
import re
import gba as G

CEREMONY_LEADERS = ['BROCK', 'MISTY', 'ERIKA', 'KOGA']     # (sLeaders: two of them stand with the mentor)
OAK_FINALE = 'TRAINER_CANVAS_OAK_FINALE'


def badge_names():
    """src/gym_badge.c: the player's badge by type -> its name"""
    src = open(G.P('src/gym_badge.c')).read()
    return {t: n.title() for t, n in re.findall(r'\[TYPE_(\w+)\]\s*=\s*\{COMPOUND_STRING\("([^"]+)"\)', src)}


def setup_ceremony(port, ret):
    """the crowd's looks: VAR_OBJ_GFX_ID_0 the player's mentor (STR_VAR_1 their name), _1 and _2 two more Kanto
    leaders; VAR_RESULT = whether there's a mentor (always, by now: every type has one)"""
    import specials as SP
    import candidacy as CA
    P = CA.mentor_people()

    def lines(w, t):
        g = P[w]['gfx']
        others = [l for l in CEREMONY_LEADERS if l != g][:2]
        return (['SetVar %s, %s' % (port.var('VAR_OBJ_GFX_ID_0'), port.val('OBJ_EVENT_GFX_' + g))]
                + ['SetVar %s, %s' % (port.var('VAR_OBJ_GFX_ID_%d' % (k + 1)), port.val('OBJ_EVENT_GFX_' + o)) for k, o in enumerate(others)])
    out = CA._by_mentor(port, lines)
    if getattr(port, 'cur', None) in port.mapscript_labels:
        return out          # (on the map's transition: no messages loaded yet to buffer a name from, nor needed)
    return out + SP.candidate_mentor_name(port, None) + (['CopyVar %s, VAR_SPECIAL_RESULT' % ret] if ret else [])


def badge_name(port, ret):
    """STR_VAR_1 = the player's badge, by their type"""
    import specials as SP
    B = badge_names()
    return SP.chain(port, port.var('VAR_PLAYER_TYPE'), [
        (SP._type(port, t), ['CanvasBufferMsg 0, %s' % port.own_msg('cv_badge_%s' % t.lower(), n.replace('Espn', 'ESPN'))])
        for t, n in B.items()])


def oak_battle(port, ret):
    """Oak's battle (trainerbattle_no_intro TRAINER_GYM_CHALLENGER with his set team): a double battle; losing
    doesn't black out (the script sends the player home); VAR_RESULT = 1 won"""
    import port_map as PM
    n = PM.TRAINER_IDS[OAK_FINALE]
    return ['CanvasCloseMsg', 'ClearTrainerFlag %d' % n, 'TrainerBattle %d, %d, 1, 0' % (n, n),
            'CheckBattleWon VAR_SPECIAL_RESULT', 'CanvasCandidate 12']


# ---------------------------------------------------------------- the Gym Legend (src/gym_legend.c)
LEGEND_LEVEL = 70
LEGEND_SPOT = (12, 18)      # (the GBA's FindSpot with no battle stage: the middle of the room, 18 down)


def legends():
    """gGymLegends: TYPE -> SPECIES_"""
    src = open(G.P('src/gym_legend.c')).read()
    body = src[src.index('gGymLegends[NUMBER_OF_MON_TYPES] ='):]
    return re.findall(r'\[TYPE_(\w+)\]\s*=\s*(SPECIES_\w+)', body[:body.index('};')])


def legend_setup(port, ret):
    """VAR_RESULT = whether the player's type's legendary is still to be caught; VAR_0x8004 = it, VAR_OBJ_GFX_ID_C
    how it looks, STR_VAR_1 its name, STR_VAR_2 the type"""
    import specials as SP
    ret = ret or 'VAR_SPECIAL_RESULT'
    sp = port.var('VAR_0x8004')
    cases = [(SP._type(port, t), ['SetVar %s, %s' % (sp, port.val(s)),
                                  'SetVar %s, %s' % (port.var('VAR_OBJ_GFX_ID_C'), port.val('OBJ_EVENT_GFX_' + s[8:]))]) for t, s in legends()]
    caught = port.new('legend')
    return SP.chain(port, port.var('VAR_PLAYER_TYPE'), cases) + [
        'BufferSpeciesName 0, %s, 0, 0' % sp, 'BufferTypeName 1, %s' % port.var('VAR_PLAYER_TYPE'),
        'SetVar %s, 0' % ret, 'GoToIfSet %s, %s' % (port.flag('FLAG_GYM_LEGEND_CAUGHT'), caught), 'SetVar %s, 1' % ret, caught + ':']


def legend_on_load(port, ret):
    """(the gym's map script) after its arrival and until it's caught, it waits on the stage"""
    import specials as SP
    hide, lid = port.flag('FLAG_HIDE_PALLET_GYM_LEGEND'), port.localid('LOCALID_PALLET_GYM_LEGEND')
    done = port.new('legend')
    x, z = port.place(*map(str, LEGEND_SPOT))
    out = ['SetFlag %s' % hide, 'GoToIfUnset %s, %s' % (port.flag('FLAG_GYM_LEGEND_APPEARED'), done),
           'GoToIfSet %s, %s' % (port.flag('FLAG_GYM_LEGEND_CAUGHT'), done),
           'CompareVarToValue %s, %s' % (port.var('VAR_GYM_LEGEND_STATE'), port.val('GYM_LEGEND_ON_STAGE')), 'GoToIfNe %s' % done]
    out += SP.chain(port, port.var('VAR_PLAYER_TYPE'), [(SP._type(port, t), ['SetVar %s, %s' % (port.var('VAR_OBJ_GFX_ID_C'), port.val('OBJ_EVENT_GFX_' + s[8:]))])
                                                          for t, s in legends()])
    return out + ['MovePerson %s, %s, %s' % (lid, x, z), 'ClearFlag %s' % hide, done + ':']


def legend_camera(port, which):
    s0, s1 = '0x401E', '0x401F'
    if which == 'spawn': return ['GetPlayerCoords %s, %s' % (s0, s1), 'ScrCmd_102 %s, %s' % (s0, s1)]
    if which == 'remove': return ['ScrCmd_103']
    if which == 'out': return ['CanvasCandidate 23']
    x, z = port.place(str(LEGEND_SPOT[0]), str(LEGEND_SPOT[1] + 1))     # (a little below it: it's in the middle)
    return ['CanvasCandidate 22, %s, %s' % (x, z)]


SPECIALS = {
    'GymLegend_Setup': legend_setup,
    'GymLegend_FindSpot': lambda p, r: ['SetVar %s, %d' % (p.var('VAR_0x8005'), LEGEND_SPOT[0]), 'SetVar %s, %d' % (p.var('VAR_0x8006'), LEGEND_SPOT[1])],
    'GymLegend_PlanCamera': lambda p, r: [],
    'GymLegend_OnLoad': legend_on_load,
    '_cv_LegendCamSpawn': lambda p, r: legend_camera(p, 'spawn'),
    '_cv_LegendCamRemove': lambda p, r: legend_camera(p, 'remove'),
    '_cv_LegendCamIn': lambda p, r: legend_camera(p, 'in'),
    '_cv_LegendCamOut': lambda p, r: legend_camera(p, 'out'),
    'GymCandidate_SetupCeremony': setup_ceremony,
    'GymChallenge_GenerateOakFinale': lambda p, r: ['CanvasCandidate 13'],
    'GymBadge_BufferName': badge_name,
    # the badge's picture, above the message box (engine canvas_badge.c; tools/canvas/build_badges.py)
    'GymBadge_ShowIcon': lambda p, r: ['CanvasCandidate 20, %s' % p.var('VAR_PLAYER_TYPE')],
    'GymBadge_HideIcon': lambda p, r: ['CanvasCandidate 21'],
    '_cv_OakBattle': oak_battle,
}

# The crowd below the rise, facing the podium (HeartGold squares; the aisle up the middle stays clear for the
# player): townspeople of ours with a word each for the new leader (Claude's lines: Nick may rewrite them)
CROWD = [  # (x, z, GBA look, line)
    (1035, 378, 'WOMAN_1', 0), (1037, 378, 'LITTLE_BOY', 1), (1041, 378, 'FAT_MAN', 2), (1043, 378, 'LASS', 3),
    (1045, 378, 'OLD_MAN_1', 4), (1035, 380, 'YOUNGSTER', 5), (1037, 380, 'WOMAN_3', 1), (1041, 380, 'BEAUTY', 6),
    (1043, 380, 'SCIENTIST', 7), (1046, 380, 'MAN_2', 2), (1036, 381, 'OLD_WOMAN', 4), (1038, 382, 'BUG_CATCHER', 5),
    (1040, 382, 'LITTLE_GIRL', 0), (1044, 381, 'GENTLEMAN', 3),
]
CROWD_LINES = [
    "A GYM right here in PALLET TOWN!\\nWho'd have thought it?$",
    "When I grow up, I'm going to be\\nyour first challenger!$",
    "I came all the way from VIRIDIAN\\nCITY to see this!$",
    "Congratulations, LEADER!\\nPALLET TOWN is so proud of you!$",
    "I've lived in PALLET TOWN all my\\nlife. Never thought I'd see a GYM\\lopen here!$",
    "My POKéMON and I are training\\nhard. We'll challenge you soon!$",
    "The whole town turned out for\\nthis. What a day!$",
    "PROF. OAK must be so proud…\\nI wonder where he is?$",
]


def crowd(people):
    """PEOPLE['PalletTown_Frlg']: the GBA's people and the crowd of ours, there only for the ceremony"""
    off = next(o for o in people if o.get('local_id') == 'LOCALID_PALLET_CEREMONY_OFFICIAL')
    # (the GBA's balloons have no HeartGold look: left out rather than stand there as four of the same man)
    out = [o for o in people if o['graphics_id'] != 'OBJ_EVENT_GFX_CEREMONY_BALLOONS']
    for x, z, gfx, k in CROWD:
        o = dict(off, graphics_id='OBJ_EVENT_GFX_' + gfx, movement_type='MOVEMENT_TYPE_FACE_UP',
                 script='GymFinale_EventScript_Crowd%d' % k, _at=(x, z))
        o.pop('local_id', None)
        out.append(o)
    return out


def rewrite(g):
    L = g.labels
    for k, line in enumerate(CROWD_LINES):
        lbl = 'GymFinale_EventScript_Crowd%d' % k
        g.texts[lbl + '_Text'] = line
        L[lbl] = [('lock', []), ('faceplayer', []), ('msgbox', [lbl + '_Text']), ('release', []), ('end', [])]
    # Oak's battle
    cmds = L['GymFinale_EventScript_OakAsksToBattle']
    i = next(j for j, (c, a) in enumerate(cmds) if c == 'cleartrainerflag')
    k = next(j for j, (c, a) in enumerate(cmds) if c == 'specialvar' and a[1] == 'GetBattleOutcome')
    L['GymFinale_EventScript_OakAsksToBattle'] = cmds[:i] + [('special', ['_cv_OakBattle'])] + cmds[k + 1:]
    # the Gym Legend (gym_legend.inc): HeartGold's camera object for the GBA's, a HeartGold wild battle for its
    # CreateMon + StartLegendaryBattle
    swap = {('special', 'SpawnCameraObject'): ('special', ['_cv_LegendCamSpawn']),
            ('special', 'RemoveCameraObject'): ('special', ['_cv_LegendCamRemove']),
            ('applymovement', 'gGymLegendCameraIn'): ('special', ['_cv_LegendCamIn']),
            ('applymovement', 'gGymLegendCameraOut'): ('special', ['_cv_LegendCamOut']),
            ('special', 'GymLegend_CreateMon'): ('setwildbattle', ['VAR_0x8008', str(LEGEND_LEVEL)])}
    for lbl in ('GymLegend_EventScript_Appears', 'GymLegend_EventScript_Legend'):
        L[lbl] = [swap.get((c, a[-1] if c == 'applymovement' else (a[0] if a else None)), (c, a)) for c, a in L[lbl]]
    # (HeartGold makes a map's people before its OnLoad script, so the legendary's flag and place are set on the
    # map's transition too: else it stands at its own square looking like the player)
    if 'PalletTown_Gym_OnTransition' in L:
        L['PalletTown_Gym_OnTransition'].insert(0, ('special', ['GymLegend_OnLoad']))
    # (HeartGold's fade darkens the message box too: "Huh!? The lights!" comes just before the dark, not in it)
    c = L['GymLegend_EventScript_Appears']
    i = c.index(('fadescreen', ['FADE_TO_BLACK']))
    assert c[i + 1] == ('msgbox', ['GymLegend_Text_LightsOut']) and c[i + 2][0] == 'closemessage'
    c[i:i + 3] = [c[i + 1], c[i + 2], c[i]]
