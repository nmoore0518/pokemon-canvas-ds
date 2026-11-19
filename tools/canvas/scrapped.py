"""What of the GBA game the DS port leaves out for good (STORY.md: the Exotic Pokemon Safari, removed). The GBA maps
are read through here (gba_map.map_json, port/gba.map_json): a way into a scrapped place, and the sign for it, are
dropped. Nick: no further work goes into the GBA hack, so the port is where it is cut."""
SCRAPPED_MAPS = ('MAP_EXOTIC_SAFARI',)              # (map constants starting so)
SCRAPPED_SCRIPTS = ('ExoticSafari',)                # (scripts whose label has this in it)


# squares of the GBA's layouts redrawn: (x, y, metatile, collision). Fuchsia: the Safari's sign, beside its door
# (the door itself stands in the Safari Zone building's wall, HeartGold's building, whose one door is the Zone's)
LAYOUT_EDITS = {'LAYOUT_FUCHSIA_CITY': [(27, 6, 0x001, 0)]}


def is_scrapped_map(dest):
    return isinstance(dest, str) and dest.startswith(SCRAPPED_MAPS)


def clean(mj):
    """a GBA map.json without its ways into scrapped places. They must be its last warps: the warps after them would
    move down, and other maps' warps into this one count them"""
    ws = mj.get('warp_events', [])
    keep = [w for w in ws if not is_scrapped_map(w.get('dest_map'))]
    if len(keep) != len(ws):
        assert ws[:len(keep)] == keep, ('a scrapped warp before others', mj.get('id'))
        mj['warp_events'] = keep
    if 'bg_events' in mj:
        mj['bg_events'] = [b for b in mj['bg_events'] if not any(s in str(b.get('script', '')) for s in SCRAPPED_SCRIPTS)]
    if 'object_events' in mj:
        mj['object_events'] = [o for o in mj['object_events'] if not any(s in str(o.get('script', '')) for s in SCRAPPED_SCRIPTS)]
    return mj


# the GBA's scripts, as the porter reads them (port/gba.py), with what points at the Safari cut: (file under the GBA
# repo, text, its replacement). The words left are the GBA's own, less the Safari's; Nick writes the final dialogue.
SOURCE_EDITS = [
    # Oak's AIDE: no EXOTIC SAFARI topic (the options after it move up one)
    ('data/scripts/leader_aide.inc', 'LeaderAide_Text_OptConvention, LeaderAide_Text_OptSafari, ', 'LeaderAide_Text_OptConvention, '),
    ('data/scripts/leader_aide.inc',
     '\tcase 2, LeaderAide_EventScript_Safari\n\tcase 3, LeaderAide_EventScript_NewPokemon\n\tcase 4, LeaderAide_EventScript_Mastery\n'
     '\tcase 5, LeaderAide_EventScript_Rooms\n\tcase 6, LeaderAide_EventScript_Legends\n\tcase 7, LeaderAide_EventScript_Penny\n'
     '\tcase 8, LeaderAide_EventScript_Costumes\n\tcase 9, LeaderAide_EventScript_Tutors\n',
     '\tcase 2, LeaderAide_EventScript_NewPokemon\n\tcase 3, LeaderAide_EventScript_Mastery\n'
     '\tcase 4, LeaderAide_EventScript_Rooms\n\tcase 5, LeaderAide_EventScript_Legends\n\tcase 6, LeaderAide_EventScript_Penny\n'
     '\tcase 7, LeaderAide_EventScript_Costumes\n\tcase 8, LeaderAide_EventScript_Tutors\n'),
    ('data/scripts/leader_aide.inc',
     '\t.string "JOHTO\'s live on the routes around\\n"\n\t.string "the CONVENTION, and every region\'s\\l"\n'
     '\t.string "live in the EXOTIC SAFARI in\\l"\n\t.string "FUCHSIA CITY.\\p"\n', ''),
    # the Johto letter and its note
    ('data/scripts/johto.inc',
     '\t.string "GYM LEADERS can get a pass to the\\n"\n\t.string "EXOTIC POKéMON SAFARI in FUCHSIA.\\p"\n'
     '\t.string "POKéMON from every region live\\n"\n\t.string "there. HOENN, SINNOH, all the way\\l"\n\t.string "to PALDEA!\\p"\n', ''),
    ('data/scripts/johto.inc',
     '\t.string "“GYM LEADERS may now buy a pass to\\n"\n\t.string "the EXOTIC POKéMON SAFARI in\\l"\n'
     '\t.string "FUCHSIA CITY, home to POKéMON from\\l"\n\t.string "every region.\\p"\n\t.string "For everything else a LEADER can\\n"\n',
     '\t.string "“For everything a LEADER can\\n"\n'),
    # Oak, once every type is mastered: no story of the Safari's crater
    ('data/scripts/gym_switch.inc',
     '\t.string "I never thought I\'d see the day…\\p"\n\t.string "Oh! That reminds me. The EXOTIC\\n"\n'
     '\t.string "SAFARI\'s staff told me a story.\\p"\n\t.string "Deep in its PALDEA CRATER, they\\n"\n'
     '\t.string "say, sleeps a POKéMON that holds\\l"\n\t.string "the power of every type.\\p"\n'
     '\t.string "It only shows itself to a trainer\\n"\n\t.string "who has mastered them all.\\p"\n\t.string "Sounds like someone I know!$"\n',
     '\t.string "I never thought I\'d see the day…$"\n'),
]


def edit_source(path, text):
    """a GBA source file's text with SOURCE_EDITS made (each must be there: the GBA game is fixed now)"""
    for f, old, new in SOURCE_EDITS:
        if path.replace('\\', '/').endswith(f):
            assert old in text, ('scrapped.py: not found in', f, old[:60])
            text = text.replace(old, new)
    return text
