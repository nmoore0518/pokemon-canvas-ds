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


SPECIALS = {
    'GymCandidate_SetupCeremony': setup_ceremony,
    'GymChallenge_GenerateOakFinale': lambda p, r: ['CanvasCandidate 13'],
    'GymBadge_BufferName': badge_name,
    # (the badge's picture comes with the player's badges, row 26: its name for now)
    'GymBadge_ShowIcon': lambda p, r: [], 'GymBadge_HideIcon': lambda p, r: [],
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
    # (the legendary of the player's type arrives on the first day: that's row 27, still to come)
    L['GymLegend_EventScript_Arrives'] = [('return', [])]
