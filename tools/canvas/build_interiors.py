"""Canvas: the GBA game's big interiors that HeartGold has no building for (the Pokemon Tower, Silph Co.'s upper
floors, the S.S. Anne, the Power Plant), built from their GBA layouts in a HeartGold building's look.

Each floor is modelled from its GBA layout the way build_caves.py models a cave, but as a building: the walkable
squares are a floor of HeartGold's (`floor`), every blocked square next to the floor is a wall a block and a half
high, faced with HeartGold's wall texture (`wall`) and topped with `top`; little blocked patches out on the floor
(the GBA's tables, machines, gravestones) are low blocks (`low`, faced with `wall`). Squares that take you
elsewhere are drawn in `mark` (stairs, pads), and carry HeartGold's behaviours: a way out at the foot of a wall is
an exit mat (0x65), any other a step-on warp (0x3C up / 0x3E down by floor, as caves' ladders).
Looks come from HeartGold's own texture sets (LOOKS): the Sprout Tower's for the Pokemon Tower, the Power Plant's
for Silph Co. and the Power Plant, the S.S. Aqua's for the S.S. Anne.
Floors bigger than a land (32x32) span a matrix of lands. Each floor is a map of our own (MAP_CANVAS_*), with the
header of a HeartGold map like it (TEMPLATE) and its own events from the GBA map; HeartGold doors that stood for the
place lead into ours (DOORS).

Run after build_caves.py (our lands follow the caves'), and before the porter.
"""
import json, math, os, struct, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from nitro import read_narc, write_narc
from g3d import Mesh, build_model
import gba_map
import slots
from slots import SLOTS, new_map, NO_SCRIPTS, header, set_header, new_events_file, events_file, gba_warps
from build_rooms import texdims
from build_caves import matrix_file

ROOT = slots.ROOT
LAND_NARC = os.path.join(ROOT, 'files/a/0/6/5')
LAND_BASE = 800                 # our interiors' lands (caves are 720 on)
WALL_H, LOW_H = 24, 12          # a wall a block and a half high; a table or a machine, three quarters of a block

LOOKS = {   # HeartGold texture set (and area), floor, wall face, wall top, low block top, warp squares
    # (buildings: build_ship_floor draws them. The Tower's area is our own, 120 (OWN_AREAS): the Sprout Tower's textures
    # (set 77) with room models, which its own area, a dungeon's, does not take. stretch: the texture spans two squares, as HeartGold lays these;
    # slab: a lone closed square is a stone standing up - a gravestone - not a low block)
    # the Pokemon Tower in HeartGold's own tower look (tower_kit.py: the Sprout Tower's boards and purple panelled walls,
    # the House of Memories' gravestones), in our area 120 (the Sprout Tower's textures, OWN_AREAS); its stairs the
    # Sprout Tower's own
    'tower': dict(area=120, texset=77, stairs=(66, 66, 67, 67), tower=True),
    # Silph Co.'s upper floors as HeartGold's offices (the Radio Tower's, land 462, its textures imported into the
    # Silph Co. set, area 39): its grey zigzag floor, its cream wall with a window now and then, its dark top, its
    # desks with monitors; the lobby's (land 303) door; HeartGold's room models for the rest (furnish.KIT: plants,
    # terminals, glass cabinets, meeting tables, pictures, crates, beds); Team Rocket HQ's crates for anything else
    'silph': dict(area=39, stairs=(7, 8, 9, 10), pad_model=157, kit=dict(
        src=462, base=-2, floor=(5, 8), floor_tex={'ryuka_b'}, top=(28, 2), top_solid=True,
        faces={'plain': (5, 4), 'lit': (3, 4, 2, 1), 'door': dict(src=303, at=(3, 2), base=29)}, lit_every=5,
        things=[dict(mt={0x36D, 0x36E, 0x36F, 0x391, 0x31C, 0x31D, 0x323, 0x324, 0x325, 0x388, 0x389, 0x3A8, 0x3EF, 0x374},
                     src=462, piece=(3, 7, 2, 3), center=True, base=-2, drop={'ryuka_b'})],
        # (its walls' sides, as the Radio Tower's: a column of its wall's texture, from the floor to the top)
        pad=('y_j_warp', 32),           # (warp pads: Saffron Gym's panel, laid on the floor)
        sides=dict(tex='rwall_a', opt=(3, 0, 31, 'rwall_a_pl'), s=-184, face_z=0.5, bands=[(0, 28, 32, 13), (28, 32, 13, 11), (32, 48, 11, 0)]),
        furnish=True, tall_walls=True, partition=24, partition_top=(25.5, 16.5), top_tex='rtop_a', stairs_src=(462, 1, 4, 2, 3, -2), wall_mt={0x288, 0x28C, 0x290, 0x294, 0x298, 0x29C, 0x331, 0x33E, 0x33F, 0x346, 0x347},
        block=(19, 9, 1, 2), block_src=499, block_keep={'aj_box01', 'h_kage'}, block_at=(0, -0.56), block_base=14)),
    # the Pokemon Mansion, burnt out, in HeartGold's Burned Tower (area 78, its 1F, land 449): charred plank walls,
    # their scorched pieces now and then, its wooden floor, its fallen rubble for the GBA's rubble and anything
    # else closed in a room, its wooden stairs (the Sprout Tower's, which its area stands)
    'mansion': dict(area=78, stairs=(66, 66, 67, 67), kit=dict(
        src=449, base=0, floor=(13, 23), floor_tex={'d18_yuka01'}, top=(10, 2),
        faces={'plain': (7, 5), 'lit': (8, 5)}, lit_every=5, face_drop={'d182f_wall01', 'd182f_wall02', 'd18_yuka02'},
        things=[dict(mt={0x324}, model=23)], furnish=True, tall_walls=True,
        stone=dict(tex='d181f_wall01', top=(0, 0, 16, 12), side=(8, 20), w=0.9, d=0.8, h=12))),
    # the Power Plant in HeartGold's own (Route 10's, area 44, land 367): its stone-tiled floor, its wall of machine
    # cabinets, its dark top; the GBA's rubble as HeartGold's cave boulder (Mt. Moon's set, imported) stood up as its
    # rocks stand, its coils as blocks of the generator's yellow
    'plant': dict(area=44, stairs=(168, 169, 171, 170), pad_model=157, kit=dict(
        src=367, base=46, floor=(8, 4), floor_tex={'mpwr_r02'}, top=(25, 5),
        faces={'plain': (8, 2)},
        each=[dict(mt={0x2B5, 0x2B6, 0x2E2}, card=dict(tex='d_rock01', uv=(0, 0, 32, 32), w=1.0, h=15, zf=0.92, zt=0.4)),
              dict(mt={0x2D8, 0x2D9}, stone=dict(tex='mpwr_ge3', top=(0, 0, 16, 16), side=(8, 8), w=0.8, d=0.8, h=14))],
        each_default=dict(stone=dict(tex='mpwr_r05', top=(0, 0, 16, 16), side=(8, 8), w=0.9, d=0.9, h=12)))),
    # (kit looks: interior_kit.build_kit_floor lays them from pieces of HeartGold's own rooms. src: the land cut
    # from; base: its floor's height; floor, top: a square of its floor, of its wall's top; faces: a square of its
    # wall face (plain, its ends, its art), (x, z[, w, h]); art: GBA wall metatile -> face; things: furniture by the
    # GBA's metatiles - a piece cut from a room (src, box) or a model; block: anything else closed inside a room)
    # the Rocket Hideout in HeartGold's Team Rocket HQ (area 64, its B1F land 498): grey panelled walls, their
    # lights and ducts, crates, desks with monitors, its potted plants
    'rocket': dict(area=64, stairs=(7, 8, 9, 10), pad_model=157, kit=dict(
        src=498, base=14, floor=(13, 5), floor_tex={'aj_fl01'}, top=(5, 5),
        faces={'plain': (13, 2), 'end_e': (22, 9), 'end_w': (25, 9), 'lit': (15, 2, 2, 1), 'duct': (19, 2, 2, 1)},
        art={0x28A: 'duct', 0x2A7: 'duct'}, lit_every=6,
        things=[dict(mt={0x2B8, 0x2B9, 0x2BA, 0x2BB, 0x2B7, 0x2C0, 0x2C1, 0x2C2, 0x2BC, 0x316, 0x317, 0x31E, 0x31F, 0x326, 0x327, 0x32E, 0x32F,
                         0x313, 0x314, 0x315, 0x31B, 0x31D, 0x323, 0x324, 0x325},
                     src=503, piece=(6, 13, 2, 2), center=True),
                dict(mt={0x300, 0x301, 0x302, 0x308, 0x309}, model=23),
                dict(mt={0x2BD, 0x2BE, 0x2BF, 0x2C3, 0x2C4}, model=77)],
        stairs=(8, 28, 2, 2),
        slides={0x54: (0x40, 'right'), 0x55: (0x41, 'left'), 0x56: (0x42, 'up'), 0x57: (0x43, 'down'), 0x58: (0x4D, 'stop')},
        arrow='to_j_i1', stop='to_j_mark', low_inner=True,
        block=(19, 9, 1, 2), block_src=499, block_keep={'aj_box01', 'h_kage'}, block_at=(0, -0.56), untextured=(64, 80, 104))),
    # the S.S. Anne inside (not its deck) in HeartGold's S.S. Aqua (area 42, its 1F, land 643): its patterned carpet,
    # cream walls with portholes, its cabin doors, the hull's top; HeartGold's ship furniture (SHIP_FURNITURE)
    'shipkit': dict(area=42, stairs=(7, 8, 9, 10), furniture=True, kit=dict(
        src=643, base=-2, floor=(14, 12), floor_tex={'maq_rm03'}, top=(10, 6),
        faces={'plain': (15, 8), 'door': (13, 8), 'lit': (4, 2)}, lit_every=3, face_drop={'h_kage'}, mat=('d_mat01', 32, 16), furnish=True)),
    'ship': dict(area=42, ship=True),         # the S.S. Anne: SHIP below
    # Celadon's Game Corner and its Prize Room, in the looks of HeartGold's own (whose rooms are laid out for other
    # games: its Game Corner is the Voltorb Flip hall, its prize room a third the size of the GBA's)
    'corner': dict(area=66, ship=True, plain=('mgc_or10',), floor='mgc_or19', wall='mgc_or08', cap='mgc_or10', side='mgc_or13', low='mgc_or12',
                   lowside='mgc_or15', mat='mgc_or02', stairs=(7, 8, 9, 10), wall_top=40),
    'prize': dict(area=40, ship=True, plain=('tmc_gc08', 'tmc_gc07'), floor='tmc_gc01', wall='tmc_gc12', cap='tmc_gc08', side='tmc_gc07', low='tmc_gc08',
                  lowside='tmc_gc07', mat='tmc_gc02', stairs=(7, 8, 9, 10), wall_top=40),
    'house': dict(area=42, ship=True, plain=('r39_kabe', 'fs_room8', 'maq_pt13'), floor='mo_yuka', wall='r39_kabe', cap='fs_room8', side='maq_pt13',
                  low='table01', lowside='re_ki', mat='d_mat01', stairs=(7, 8, 9, 10), wall_top=40),
    # the Safari Zone's rest houses (and the Secret House): the GBA's room in the ship set's house textures: a green
    # mat floor, its plants (HeartGold's) and its cabinets along the back wall, its cushions on the floor, its
    # counter and the boxes behind it as low blocks. furniture: as SHIP_FURNITURE; wall_art: a GBA wall metatile ->
    # (texture, s, t, w, h, from and to how high, squares wide) drawn on the wall from that column; cushions: a
    # floor metatile -> a texture laid on its square; low_mt: metatiles that are a low block wherever they stand
    # (the counter runs to the room's edge, which would make a wall of it; nobody stands behind it, so the floor
    # there is part of it); floor_mt: closed metatiles that are floor all the same (under a plant's pot)
    'resthouse': dict(area=42, ship=True, plain=('r39_kabe', 'fs_room8', 'maq_pt13', 'mo_baketu'), floor='r39_ragu', wall='r39_kabe', cap='fs_room8',
                      side='maq_pt13', low='mo_baketu', lowside='re_ki', mat='d_mat01', stairs=(7, 8, 9, 10), wall_top=40,
                      furniture={0x28E: (23, 1, 2, (0, 0.5))}, wall_art={0x2A8: ('maq_pt04', 0, 0, 32, 32, 6, 38, 2)},
                      cushions={0x291: 'week_hu02'},
                      floor_mt={0x296}, low_mt={0x2B6, 0x2A5, 0x2BB, 0x29C, 0x2A4, 0x2AF, 0x2BA, 0x29F, 0x2A6, 0x2A7, 0x2C4, 0x2C5, 0x2AD, 0x2AE, 0x2B5}),
    # rooms the GBA draws as a house's (a back wall in rows along the top, floor below): built as build_rooms.py
    # builds the houses - HeartGold's room walls with their windows, its furniture models by the GBA's metatiles
    # (build_rooms.FURNITURE) - in HeartGold's house textures, or its lab's. Each has an area of its own
    # (ROOM_AREA_BASE on), whose building set holds only its furniture
    'room': dict(area=43, room='house'),
    'labroom': dict(area=43, room='lab'),
    # outdoors (the Safari Zone): build_safari.py, from HeartGold's own Safari Zone (area 121: its textures, set 75,
    # with Fuchsia's buildings)
    'safari': dict(area=121, floor='grass02', wall='tree01_re', top='tree01_un', low='etc_a', mark='road01',
                   grass='egrass', water='pond_un'),
}
TALL_GRASS_MB = {2}
WATER_MB = {16, 17, 18, 19, 20, 21, 24, 26, 44, 45}


def _floors(name, n, look, template, first=1):
    return [dict(gba='%s_%dF_Frlg' % (name, i), map='MAP_CANVAS_%s_%dF' % (name.upper(), i), look=look, template=template,
                 depth=-i) for i in range(first, n + 1)]


SS = 'MAP_SS_AQUA_1F'
# plain columns (a list of the squares whose blocks make one: build_rooms.widen) and a plain row for the cabins
CABIN1 = dict(cols=[(2, 2, [(0, 0), (0, 1), (1, 2), (1, 3), (1, 3), (1, 3), (1, 3), (1, 3)])], rows=[(3, 1)])
CABIN2 = dict(cols=[(3, 2, [(0, 0), (0, 1), (1, 5), (1, 5), (1, 5), (1, 5), (1, 5), (1, 5), (0, 8)])], rows=[(5, 1)])
INTERIORS = (
    # the Pokemon Tower stands where HeartGold's Lavender has its Radio Tower: that door leads in
    [dict(gba='PokemonTower_1F_Frlg', map='MAP_CANVAS_POKEMON_TOWER_1F', look='tower', template='MAP_SPROUT_TOWER_1F', place='MAP_LAVENDER',
          depth=-1, exits={'MAP_LAVENDER_TOWN': ('MAP_LAVENDER', 6)})] +
    [dict(gba='PokemonTower_%dF_Frlg' % i, map='MAP_CANVAS_POKEMON_TOWER_%dF' % i, look='tower', template='MAP_SPROUT_TOWER_2F',
          place='MAP_LAVENDER', depth=-i) for i in range(2, 8)] +
    # Silph Co.: HeartGold's headquarters is the 1F (ported there); its elevator door leads to our 2F's stairs
    [dict(gba='SilphCo_%dF_Frlg' % i, map='MAP_CANVAS_SILPH_CO_%dF' % i, look='silph', template='MAP_SAFFRON_SILPH_CO_HQ',
          depth=-i, exits={('MAP_SILPH_CO_1F', '3'): ('MAP_SAFFRON_SILPH_CO_HQ', 1)}) for i in range(2, 12)] +
    [dict(gba='PowerPlant_Frlg', map='MAP_CANVAS_POWER_PLANT', look='plant', template='MAP_ROUTE_10_POWER_PLANT_REPAIRED',
          depth=0, exits={'MAP_ROUTE10': ('MAP_ROUTE_10', 1)})] +
    # the S.S. Anne: HeartGold's ferry building at Vermilion's dock leads aboard (the GBA's dock outside is left out)
    [dict(gba='SSAnne_1F_Corridor_Frlg', map='MAP_CANVAS_SSANNE_1F', look='shipkit', template=SS, depth=-1,
          exits={'MAP_SSANNE_EXTERIOR': ('MAP_VERMILION', 7)}),
     dict(gba='SSAnne_2F_Corridor_Frlg', map='MAP_CANVAS_SSANNE_2F', look='shipkit', template=SS, depth=-2),
     dict(gba='SSAnne_3F_Corridor_Frlg', map='MAP_CANVAS_SSANNE_3F', look='shipkit', template=SS, depth=-3),
     dict(gba='SSAnne_B1F_Corridor_Frlg', map='MAP_CANVAS_SSANNE_B1F', look='shipkit', template=SS, depth=0),
     # (the bow is small on the GBA: six columns and two rows of planks more)
     dict(gba='SSAnne_Deck_Frlg', map='MAP_CANVAS_SSANNE_DECK', look='ship', template=SS, depth=-4,
          widen=dict(cols=[(9, 3), (11, 3)], rows=[(10, 2)])),
     dict(gba='SSAnne_Kitchen_Frlg', map='MAP_CANVAS_SSANNE_KITCHEN', look='shipkit', template=SS, depth=-1),
     dict(gba='SSAnne_CaptainsOffice_Frlg', map='MAP_CANVAS_SSANNE_CAPTAIN', look='shipkit', template=SS, depth=-2.5)] +
    # (the cabins are 6 squares wide on the GBA, with up to four people in them: two plain columns and a row more)
    [dict(gba='SSAnne_%s_Room%d_Frlg' % (f, i), map='MAP_CANVAS_SSANNE_%s_R%d' % (f, i), look='shipkit', template=SS,
          widen=CABIN1 if f == '1F' else CABIN2,
          depth={'1F': -1, '2F': -2, 'B1F': 0}[f]) for f, n in (('1F', 7), ('2F', 6), ('B1F', 5)) for i in range(1, n + 1)] +
    # the Rocket Hideout, under the Game Corner (stairs added there: ADD_WARPS). Its spin-tile mazes are plain floor
    # for now (HeartGold's slide tiles need a gym's code running), and its elevator (a GBA dynamic warp) isn't built
    [dict(gba='RocketHideout_B%dF_Frlg' % i, map='MAP_CANVAS_ROCKET_HIDEOUT_B%dF' % i, look='rocket', template='MAP_TEAM_ROCKET_HEADQUARTERS_B1F', place='MAP_CELADON',
          depth=i) for i in range(1, 5)]
)
# Cinnabar (our town: build_cinnabar.py draws the GBA's in place of HeartGold's ruin)
CIN = {('MAP_CINNABAR_ISLAND', str(i)): ('MAP_CINNABAR_ISLAND', i) for i in range(5)}   # (build_cinnabar.py: the GBA's warps, in order)
INTERIORS += (
    [dict(gba='CinnabarIsland_Gym_Frlg', map='MAP_CANVAS_CINNABAR_GYM', look='plant', template='MAP_SEAFOAM_ISLANDS_CINNABAR_GYM', depth=0, exits=CIN,
          place='MAP_CINNABAR_ISLAND'),
     dict(gba='CinnabarIsland_Mart_Frlg', map='MAP_CANVAS_CINNABAR_MART', look='labroom', template='MAP_VIRIDIAN_POKEMART', depth=0, exits=CIN, place='MAP_CINNABAR_ISLAND'),
     dict(gba='CinnabarIsland_PokemonLab_Entrance_Frlg', map='MAP_CANVAS_CINNABAR_LAB', look='labroom', template='MAP_SAFFRON_SILPH_CO_HQ', depth=0, exits=CIN, place='MAP_CINNABAR_ISLAND')] +
    [dict(gba='CinnabarIsland_PokemonLab_%s_Frlg' % r, map='MAP_CANVAS_CINNABAR_LAB_%s' % r.upper(), look='labroom', template='MAP_SAFFRON_SILPH_CO_HQ',
          depth=0) for r in ('Lounge', 'ResearchRoom', 'ExperimentRoom')] +
    [dict(gba='PokemonMansion_%s_Frlg' % f, map='MAP_CANVAS_POKEMON_MANSION_%s' % f, look='mansion', template='MAP_BURNED_TOWER_1F',
          depth={'1F': -1, '2F': -2, '3F': -3, 'B1F': 0}[f], exits=CIN, place='MAP_CINNABAR_ISLAND') for f in ('1F', '2F', '3F', 'B1F')]
)
# the Safari Zone, through a door we add at the back of HeartGold's Pal Park entrance (where the GBA's is)
SZ = 'MAP_SAFARI_ZONE_01'
INTERIORS += (
    [dict(gba='SafariZone_Center_Frlg', map='MAP_CANVAS_SAFARI_CENTER', look='safari', template=SZ, depth=0,
          exits={'MAP_FUCHSIA_CITY_SAFARI_ZONE_ENTRANCE': ('MAP_FUCHSIA_PAL_PARK_ENTRANCE', 1)}),
     dict(gba='SafariZone_East_Frlg', map='MAP_CANVAS_SAFARI_EAST', look='safari', template=SZ, depth=0),
     dict(gba='SafariZone_North_Frlg', map='MAP_CANVAS_SAFARI_NORTH', look='safari', template=SZ, depth=0),
     dict(gba='SafariZone_West_Frlg', map='MAP_CANVAS_SAFARI_WEST', look='safari', template=SZ, depth=0)] +
    [dict(gba='SafariZone_%s_Frlg' % r, map='MAP_CANVAS_SAFARI_%s' % r.upper().replace('_RESTHOUSE', '_REST'), look='room',
          template='MAP_FUCHSIA_SOUTHWEST_HOUSE', depth=0)
     for r in ('Center_RestHouse', 'East_RestHouse', 'North_RestHouse', 'West_RestHouse', 'SecretHouse')]
)
# Celadon's Game Corner and Prize Room from the GBA's layouts (last, so the lands before them keep their numbers);
# the Prize Room two columns wider
INTERIORS += (
    [dict(gba='CeladonCity_GameCorner_Frlg', map='MAP_CANVAS_GAME_CORNER', look='corner', template='MAP_CELADON_GAME_CORNER', depth=0,
          place='MAP_CELADON', exits={'MAP_CELADON_CITY': ('MAP_CELADON', 3)}),
     dict(gba='CeladonCity_GameCorner_PrizeRoom_Frlg', map='MAP_CANVAS_PRIZE_ROOM', look='prize', template='MAP_CELADON_PRIZE_CORNER', depth=0,
          place='MAP_CELADON', exits={'MAP_CELADON_CITY': ('MAP_CELADON', 4)},
          widen=dict(cols=[(4, 2, [(0, 0), (0, 1), (1, 2), (0, 3), (0, 4), (0, 5), (3, 6), (0, 7), (0, 8), (0, 9)])]))]
)
# Silph Co.'s elevator (last: the lands before it keep their numbers). Its way out is HeartGold's dynamic warp
# (header 4095, anchor 256: where the floor chosen last put it, or back where you came in); HeartGold's 1F's
# elevator door leads in (DOORS)
INTERIORS += [dict(gba='SilphCo_Elevator_Frlg', map='MAP_CANVAS_SILPH_ELEVATOR', look='silph', template='MAP_SAFFRON_SILPH_CO_HQ',
                   depth=0, place='MAP_SAFFRON', exits={'MAP_DYNAMIC': (4095, 256)})]
# the GBA's other rooms HeartGold has no building for, behind the doors of the GBA-layout towns (build_overworld.py
# lays their houses): a plain house's look; their ways out to the towns are put in by build_overworld.py
_H = 'MAP_SAFFRON_MR_PSYCHIC_HOUSE'
ROOM_LOOK = {'VermilionCity_MedicalCenter_1F': 'labroom', 'LeaderAcademy_PokemonCenter': 'labroom', 'LeaderAcademy_LectureA': 'labroom',
             'LeaderAcademy_LectureB': 'labroom', 'LeaderAcademy_LectureC': 'labroom', 'LeaderAcademy_LectureD': 'labroom',
             'UndergroundPath_WestEntrance_Frlg': 'labroom', 'UndergroundPath_EastEntrance_Frlg': 'labroom',
             'CeladonCity_PitHall': 'house', 'UndergroundPath_EastWestTunnel_Frlg': 'house'}
INTERIORS += [dict(gba=g, map=m, look=ROOM_LOOK.get(g, 'room'), template=t, depth=0, place=pl) for g, m, t, pl in [
    ('CeladonCity_Hotel_Frlg', 'MAP_CANVAS_CELADON_HOTEL', _H, 'MAP_CELADON'),
    ('CeladonCity_PitHall', 'MAP_CANVAS_PIT_HALL', _H, 'MAP_CELADON'),
    ('FuchsiaCity_SafariZone_Office_Frlg', 'MAP_CANVAS_SAFARI_OFFICE', _H, 'MAP_FUCHSIA'),
    ('SaffronCity_PokemonTrainerFanClub_Frlg', 'MAP_CANVAS_SAFFRON_FAN_CLUB', _H, 'MAP_SAFFRON'),
    ('VermilionCity_MedicalCenter_1F', 'MAP_CANVAS_MEDICAL_CENTER_1F', _H, 'MAP_VERMILION'),
    ('LeaderAcademy_PokemonCenter', 'MAP_CANVAS_ACADEMY_CENTER', 'MAP_SAFFRON_POKECENTER_1F', 'MAP_SAFFRON'),
    ('LeaderAcademy_Hall', 'MAP_CANVAS_ACADEMY_HALL', _H, 'MAP_SAFFRON'),
    ('LeaderAcademy_BattleHall', 'MAP_CANVAS_ACADEMY_BATTLE_HALL', _H, 'MAP_SAFFRON'),
    ('LeaderAcademy_LectureA', 'MAP_CANVAS_ACADEMY_LECTURE_A', _H, 'MAP_SAFFRON'),
    ('LeaderAcademy_LectureB', 'MAP_CANVAS_ACADEMY_LECTURE_B', _H, 'MAP_SAFFRON'),
    ('LeaderAcademy_LectureC', 'MAP_CANVAS_ACADEMY_LECTURE_C', _H, 'MAP_SAFFRON'),
    ('LeaderAcademy_LectureD', 'MAP_CANVAS_ACADEMY_LECTURE_D', _H, 'MAP_SAFFRON'),
    ('LeaderAcademy_MegaRoom', 'MAP_CANVAS_ACADEMY_MEGA_ROOM', _H, 'MAP_SAFFRON'),
    ('UndergroundPath_WestEntrance_Frlg', 'MAP_CANVAS_UNDERGROUND_WEST', 'MAP_ROUTE_5_UNDERGROUND_PATH_GATE', 'MAP_ROUTE_7'),
    ('UndergroundPath_EastEntrance_Frlg', 'MAP_CANVAS_UNDERGROUND_EAST', 'MAP_ROUTE_5_UNDERGROUND_PATH_GATE', 'MAP_ROUTE_8'),
    ('UndergroundPath_EastWestTunnel_Frlg', 'MAP_CANVAS_UNDERGROUND_EW', 'MAP_ROUTE_5_UNDERGROUND_PATH', 'MAP_ROUTE_7')]]
# warps we add to HeartGold's rooms: (map, square, its behaviour, our map, GBA warp index there). Each goes last in
# the room's warp list, so no other warp's number moves.
ADD_WARPS = [('MAP_FUCHSIA_PAL_PARK_ENTRANCE', (8, 4), 0x3E, 'MAP_CANVAS_SAFARI_CENTER', 1)]
# HeartGold's doors that stood for these places -> ours: (map, its warp index) -> (our map, GBA warp index there)
DOORS = {('MAP_LAVENDER', 6): ('MAP_CANVAS_POKEMON_TOWER_1F', 1),
         ('MAP_SAFFRON_SILPH_CO_HQ', 1): ('MAP_CANVAS_SILPH_ELEVATOR', 0),
         ('MAP_ROUTE_10', 1): ('MAP_CANVAS_POWER_PLANT', 1),
         ('MAP_VERMILION', 7): ('MAP_CANVAS_SSANNE_1F', 2),
         ('MAP_CELADON', 3): ('MAP_CANVAS_GAME_CORNER', 1), ('MAP_CELADON', 4): ('MAP_CANVAS_PRIZE_ROOM', 1)}


def gba_ids():
    return {c['gba']: gba_map.map_json(c['gba'])['id'] for c in INTERIORS}


# ---------------------------------------------------------------- the S.S. Anne: the GBA's layout in HeartGold's ship look
# Textures of HeartGold's S.S. Aqua and the rooms that share its set (42): plank floors, cabin carpets, the cabins'
# wallpaper, its doors and portholes; furniture is HeartGold's room models (the set's own: bed, table, chair, plant).
WALL_TOP = 40             # a ship wall's height
SHIP = dict(area=42, ship=True, plain=('re_kabe', 'fs_room8', 'maq_pt13', 'maq_rs11', 'maq_pt07'), wall_top=WALL_TOP, floor='sn_h_yuka1', carpet={'1F': 'maq_rs03', '2F': 'maq_rs13', 'B1F': 'maq_rs07'}, wall='re_kabe', paper='maq_rs08',
            base='maq_pt13', line='maq_rs11', cap='fs_room8', side='maq_pt13', low='table01', lowside='re_ki', steel='maq_rm09',
            door=('maq_pt01', 16, 0, 16, 32), porthole=('maq_pt01', 0, 0, 16, 16), mat='d_mat01', sea='maq_pt07', stairs=(7, 8, 9, 10), rail='maq_pt02', furniture=True)
# GBA things -> HeartGold room models: top-left metatile -> (model, width, height in squares, squares the model is
# moved by). The squares are closed whatever the GBA says (a bed's walkable half), like the wall furniture of rooms.
SHIP_FURNITURE = {
    0x338: (94, 2, 3, (0, 0)), 0x342: (94, 3, 2, (0, 0)), 0x305: (94, 3, 2, (0, 0)),     # tables, the captain's desk
    0x329: (17, 2, 2, (0, 0)), 0x309: (17, 2, 2, (0, 0)),                                  # beds
    0x328: (53, 1, 2, (0, 0.5)), 0x308: (53, 1, 2, (0, 0.5)),                              # chairs
    0x32B: (23, 1, 2, (0, 0.5)), 0x30B: (23, 1, 2, (0, 0.5)),                              # plants
}
SHIP_PORTHOLES = {0x282, 0x33A, 0x33B}    # GBA wall metatiles with a porthole
# HeartGold's staircases, `stairs` in a look: (up rising right, up rising left, down to the left, down to the right);
# each one's box about where it is placed (x0, x1, z0, z1 in units), and how far down the square's row it stands
STAIR_BOX = {7: (-17, 16, -12, 18, 0.75), 8: (-16, 17, -12, 18, 0.75), 9: (-13, 15, -12, 18, 0.75), 10: (-15, 13, -12, 18, 0.75),
             168: (-16, 16, -16, 16, 1), 169: (-16, 16, -16, 16, 1), 170: (-16, 16, -16, 16, 1), 171: (-16, 16, -16, 16, 1),
             66: (-16, 16, -24, 8, 1.5), 67: (-8, 8, -24, 8, 1.5)}     # (the Sprout Tower's wooden stairs, as Lavender's houses stand them)
USED_MODELS = {}          # area -> the room models its maps place (ship_models lists them in the area's building set)
OWN_AREAS = {120: (77, 77), 121: (75, 16)}   # (120, the Pokemon Tower: the Sprout Tower's own - its stairs are its room models, textured by its set)   # an area of ours: (the area whose textures it has, the area whose room-model set it starts from)


def ship_parts(spec):
    """-> the GBA map (widened), its layout, and what each square is"""
    gm = gba_map.map_json(spec['gba'])
    lay = gba_map.Layout(gm['layout'])
    if spec.get('widen'):
        from build_rooms import widen
        gm = widen(gm, lay, **spec['widen'])
    W, H = lay.w, lay.h
    mids = set(lay.metatile(x, y) for y in range(H) for x in range(W))
    void = {m for m in mids if not any(px[:3] != (0, 0, 0) for px in lay.render_metatile(m).convert('RGB').getdata())}
    inb = lambda x, y: 0 <= x < W and 0 <= y < H
    warps = {(w['x'], w['y']): w for w in gm.get('warp_events', [])}
    isvoid = lambda x, y: not inb(x, y) or lay.metatile(x, y) in void
    floor_mt = LOOKS.get(spec['look'], {}).get('floor_mt', ())     # (closed in the GBA, but floor: a plant's pot stands on it)
    free = lambda x, y: inb(x, y) and not isvoid(x, y) and (lay.collision(x, y) == 0 or lay.metatile(x, y) in floor_mt)
    # (the GBA leaves squares open outside its rooms, in the borders: floor is what you can get to from a door)
    # (and from where people stand: a room behind a door that a script opens is floor too)
    people = {(o['x'], o['y']) for o in gm.get('object_events', [])}
    reach = set(warps) | {s for s in people if free(*s)}
    todo = list(reach)
    while todo:
        x, y = todo.pop()
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            n = (x + dx, y + dy)
            if n not in reach and free(*n): reach.add(n); todo.append(n)
    open_ = lambda x, y: (x, y) in reach and free(x, y) and (x, y) not in warps
    # a door in a wall: a warp square with wall either side of it and floor in front
    door = lambda x, y: (x, y) in warps and open_(x, y + 1) and not open_(x - 1, y) and not open_(x + 1, y) and not open_(x, y - 1)
    walk = lambda x, y: open_(x, y) or (x, y) in warps
    wallish = lambda x, y: inb(x, y) and ((not walk(x, y) and not isvoid(x, y)) or door(x, y))
    # the walls: above a floor square, a run of wall squares with nothing (black) beyond it; and the squares of
    # those rows either side (above a bed or a table that stands against the wall, and the wall's corners)
    band = {}                 # square -> (the floor row it stands behind, rows up from the floor)
    for y in range(H):
        for x in range(W):
            if not open_(x, y) or not wallish(x, y - 1): continue
            n_ = 1
            while wallish(x, y - n_ - 1): n_ += 1
            if not isvoid(x, y - n_ - 1): continue          # (a counter or a block between two floors: not a wall)
            if n_ > 3: continue                             # (something stands against the wall here: its wall comes from the columns beside it)
            for k in range(1, n_ + 1):
                band[(x, y - k)] = (y, k - 1)
    todo = list(band)
    while todo:
        x, y = todo.pop()
        for dx in (-1, 1):
            if (wallish(x + dx, y) or (x + dx, y) in warps) and (x + dx, y) not in band:
                band[(x + dx, y)] = band[(x, y)]; todo.append((x + dx, y))
    # things on the floor: small patches of closed squares that are no wall
    things, inner, seen = set(), set(), set()
    for y in range(H):
        for x in range(W):
            if (x, y) in seen or not wallish(x, y) or (x, y) in band: continue
            comp, stack = [], [(x, y)]
            seen.add((x, y))
            while stack:
                c = stack.pop(); comp.append(c)
                for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                    n = (c[0] + dx, c[1] + dy)
                    if n not in seen and wallish(*n) and n not in band: seen.add(n); stack.append(n)
            # (a wall has the dark beyond it somewhere; a thing stands clear of it)
            edge = any(inb(c[0] + dx, c[1] + dy) and isvoid(c[0] + dx, c[1] + dy) for c in comp for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)))
            if len(comp) <= 12 and not edge: things |= set(comp)
            if not edge: inner |= set(comp)                     # (anything closed that stands inside the room)
    low_mt = LOOKS.get(spec['look'], {}).get('low_mt', ())
    forced = {(x, y) for y in range(H) for x in range(W) if lay.metatile(x, y) in low_mt and (x, y) not in band and (x, y) not in reach and (x, y) not in warps}
    things |= forced; inner |= forced
    # (and everything closed that is no wall itself, joined to one or not: not in a wall's rows, and with no dark
    # beside it even cornerwise. The Tower's gravestones run in rows out from its walls.)
    deep = {(x, y) for y in range(H) for x in range(W) if wallish(x, y) and (x, y) not in band and (x, y) not in warps
            and not any(not inb(x + dx, y + dy) or isvoid(x + dx, y + dy) for dx in (-1, 0, 1) for dy in (-1, 0, 1))}
    return dict(gm=gm, lay=lay, W=W, H=H, warps=warps, people=people, isvoid=isvoid, open=open_, door=door, walk=walk, wallish=wallish,
                band=band, things=things, inner=inner, deep=deep)


def _furnish(P, spec, depth_of, SHIP):
    """HeartGold's furniture on the GBA's (SHIP_FURNITURE), its stairs between floors where the GBA has them, warp
    pads, and what each warp square is -> (props, closed squares, squares under stairs up, squares of stairs-down
    wells, the wells, warp square -> behaviour)"""
    gm, lay, W, H, warps = P['gm'], P['lay'], P['W'], P['H'], P['warps']
    walk, door = P['walk'], P['door']
    # furniture of HeartGold's
    props, closed = [], set()
    for y in range(H):
        for x in range(W):
            f = (SHIP_FURNITURE if SHIP.get('furniture') is True else SHIP.get('furniture') or {}).get(lay.metatile(x, y))
            if not f: continue
            model, w, h, (mx, mz) = f
            props.append((model, x + w / 2 + mx, y + h / 2 + mz))
            if model != 53:      # (a chair is sat on; and nobody the GBA stands somewhere is shut in)
                closed |= {(x + i, y + j) for i in range(w) for j in range(h)} - P['people']
    # stairs to another floor: HeartGold's staircase, where the GBA draws its own: on the two closed squares beside
    # the square that takes you there (and the two in front of those), climbing or going down away from it; stairs
    # down are a well in the floor
    under, hole_sq, holes = set(), set(), []
    for (x, y), w in warps.items():
        if all(walk(x + dx, y + dy) for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))):
            # (open floor all round: a warp pad, as in Silph Co.)
            if SHIP.get('pad_model'): props.append((SHIP['pad_model'], x + 0.5, y + 0.5))
            continue
        if not (w['dest_map'] in depth_of and w['dest_map'] != gm['id'] and not door(x, y) and depth_of[w['dest_map']] != spec['depth']): continue
        up_ = depth_of[w['dest_map']] < spec['depth']
        left = not walk(x - 1, y) and walk(x + 1, y)          # (the closed side: left, else right)
        ur, ul, dl, dr = SHIP['stairs']
        model = (ul if left else ur) if up_ else (dl if left else dr)
        cx = x - 1 if left else x + 2
        bx0, bx1, bz0, bz1, dz = STAIR_BOX[model]
        cz = y + dz
        props.append((model, cx, cz))
        block = {(cx - 1, y), (cx, y), (cx - 1, y + 1), (cx, y + 1)}
        closed |= {s for s in block if s not in warps}
        if up_: under |= block
        else:
            hole_sq |= block
            holes.append(((cx - 1) * 16, y * 16, (cx + 1) * 16, (y + 2) * 16, cx * 16 + bx0, cz * 16 + bz0, cx * 16 + bx1, cz * 16 + bz1))
    USED_MODELS.setdefault(SHIP['area'], set()).update(m for m, *_ in props)
    kind = {}
    for (x, y), w in warps.items():
        dest = w['dest_map']
        if dest in depth_of and dest != gm['id'] and not door(x, y) and depth_of[dest] != spec['depth']:
            kind[(x, y)] = 0x3C if depth_of[dest] < spec['depth'] else 0x3E      # (stairs to another deck)
        elif not walk(x, y + 1) and walk(x, y - 1):
            kind[(x, y)] = 0x65             # (a way out at the foot of the wall: walk on into it)
        else:
            kind[(x, y)] = 0x3E
    return props, closed, under, hole_sq, holes, kind


def build_ship_floor(spec, depth_of):
    """A floor of the S.S. Anne: the GBA's layout, square for square, in HeartGold's ship look. Walkable squares are
    floor (planks; carpet in the cabins); the wall above each stretch of floor stands at its far edge, white with
    a blue foot and a yellow line (the cabins' papered), with HeartGold's door where the GBA has one and its
    porthole where the GBA has one; the walls at the sides and the near edge are a low kerb, so they hide nothing;
    the GBA's furniture is HeartGold's (SHIP_FURNITURE), or a low block."""
    P = ship_parts(spec)
    gm, lay, W, H, warps, band, things = P['gm'], P['lay'], P['W'], P['H'], P['warps'], P['band'], P['things']
    walk, door, wallish, isvoid = P['walk'], P['door'], P['wallish'], P['isvoid']
    SHIP = globals()['SHIP'] if spec['look'] == 'ship' else LOOKS[spec['look']]      # (the look's textures)
    WALL_TOP = SHIP['wall_top']
    plain = set(SHIP.get('plain', ()))            # textures used for their colour: one texel of them
    dims, pals = texdims(SHIP.get('texset', SHIP['area']))
    pal_of = lambda t_: next(p for p in (t_ + '_pl', t_) if p in pals)
    room = spec['look'] == 'ship' and 'Room' in spec['gba']
    floor_tex = SHIP['carpet'][spec['gba'].split('_')[1]] if room else SHIP['floor']
    wall_tex = SHIP['paper'] if room else SHIP['wall']
    low_tex = SHIP['steel'] if 'Kitchen' in spec['gba'] else SHIP['low']
    stones = set(P['inner']) | set(P['deep']) if SHIP.get('slab') else set()      # (the Tower: every closed square inside a room is a gravestone)
    props, closed, under, hole_sq, holes, kind = _furnish(P, spec, depth_of, SHIP)
    floor = lambda x, y: ((walk(x, y) and (x, y) not in band) or (x, y) in things or (x, y) in stones or (x, y) in closed or (x, y) in under) and (x, y) not in hole_sq
    # out on deck, what is closed and not beside the planks is the sea
    deck = spec['look'] == 'ship' and 'Deck' in spec['gba']
    by_floor = lambda x, y: any(floor(x + dx, y + dy) for dx in (-1, 0, 1) for dy in (-1, 0, 1))
    nx, nz = math.ceil(W / 32), math.ceil(H / 32)
    lands = []
    U = lambda v, o: (v - o) * 16 - 256
    up, fwd = (0, 1, 0), (0, 0, 1)
    for lz in range(nz):
        for lx in range(nx):
            meshes = {}
            M = lambda t_: meshes.setdefault(t_, Mesh())
            ox, oz = lx * 32, lz * 32
            X0, X1, Z0, Z1 = ox, min(ox + 32, W), oz, min(oz + 32, H)
            perm = [0x8000] * 1024
            globals_plain = plain

            def top(tex, x, k, y, h, plain=False):
                """a flat face over squares x..x+k of row y at height h"""
                tw, th = dims[tex]
                f = tw / 32 if SHIP.get('stretch') else 1
                s0, s1, t0, t1 = (1, 2, 1, 2) if plain or tex in globals_plain else (x * 16 * f, (x + k) * 16 * f, y * 16 * f, (y + 1) * 16 * f)
                M(tex).quad([((U(x, ox), h, U(y + 1, oz)), (s0, t1)), ((U(x + k, ox), h, U(y + 1, oz)), (s1, t1)),
                             ((U(x + k, ox), h, U(y, oz)), (s1, t0)), ((U(x, ox), h, U(y, oz)), (s0, t0))], up)

            def face(tex, a, b, y0, y1, n, uv=None):
                """an upright face from point a to b (x, z in land units), y0 up to y1"""
                if uv is None and tex not in globals_plain:      # (a textured wall: along it by its length, its height over the face)
                    tw, th = dims[tex]
                    d0 = (a[0] + a[1]) * tw / 32; d1 = d0 + (abs(b[0] - a[0]) + abs(b[1] - a[1])) * tw / 32
                    uv = (d0, 0, d1, th * (y1 - y0) / WALL_TOP)
                s0, t0, s1, t1 = uv or (1, 1, 2, 2)
                M(tex).quad([((a[0], y0, a[1]), (s0, t1)), ((b[0], y0, b[1]), (s1, t1)), ((b[0], y1, b[1]), (s1, t0)), ((a[0], y1, a[1]), (s0, t0))], n)

            def runs(cells):
                """squares of a row -> (x, length) runs"""
                out = []
                for x in sorted(cells):
                    if out and out[-1][0] + out[-1][1] == x: out[-1][1] += 1
                    else: out.append([x, 1])
                return out
            height = lambda x, y: None if (x, y) in hole_sq else 0 if floor(x, y) and (x, y) not in things else 0 if (x, y) in stones else 10 if (x, y) in things and (x, y) not in closed else \
                0 if (x, y) in closed else None if (x, y) in band or isvoid(x, y) or not wallish(x, y) else \
                -4 if deck and not by_floor(x, y) else 1 if deck else 6
            for y in range(Z0, Z1):
                for x in range(X0, X1):
                    if walk(x, y) and (x, y) not in closed: perm[(y - oz) * 32 + (x - ox)] = kind.get((x, y), 0)
                row = lambda pred: runs([x for x in range(X0, X1) if pred(x, y)])
                for x, k in row(floor): top(floor_tex, x, k, y, 0)
                for x, k in row(lambda x, y: height(x, y) == 10): top(low_tex, x, k, y, 10)
                for x, k in row(lambda x, y: height(x, y) == 6): top(SHIP['cap'], x, k, y, 6)
                for x, k in row(lambda x, y: height(x, y) == -4): top(SHIP['sea'], x, k, y, -4, plain=True)
                for x, k in row(lambda x, y: kind.get((x, y)) == 0x65): top(SHIP['mat'], x, k, y, 1)
                for x in range(X0, X1):              # a cushion on its square
                    tex = SHIP.get('cushions', {}).get(lay.metatile(x, y)) if 0 <= x < W and 0 <= y < H else None
                    if not tex: continue
                    tw, th = dims[tex]
                    a0, a1, b0, b1 = U(x, ox) + 2, U(x + 1, ox) - 2, U(y, oz) + 2, U(y + 1, oz) - 2
                    M(tex).quad([((a0, 1, b1), (0, th)), ((a1, 1, b1), (tw, th)), ((a1, 1, b0), (tw, 0)), ((a0, 1, b0), (0, 0))], up)
                for x, k in row(lambda x, y: height(x, y) == 1): top(SHIP['cap'], x, k, y, 0)       # (the deck's edge, under its rail)
                if deck:        # a rail along every edge of the planks (HeartGold's ship ladder on its side: two bars and posts)
                    for x in range(X0, X1):
                        if not floor(x, y) or (x, y) in warps: continue
                        for n in ((0, 1), (0, -1), (1, 0), (-1, 0)):
                            if floor(x + n[0], y + n[1]) or (x + n[0], y + n[1]) in warps: continue
                            if n[0] == 0:
                                zz = U(y + (1 if n[1] > 0 else 0), oz); a, b = (U(x, ox), zz), (U(x + 1, ox), zz)
                            else:
                                xx = U(x + (1 if n[0] > 0 else 0), ox); a, b = (xx, U(y + 1, oz)), (xx, U(y, oz))
                            for p0, p1, nn in ((a, b, (n[0], 0, n[1])), (b, a, (-n[0], 0, -n[1]))):
                                M(SHIP['rail']).quad([((p0[0], 0, p0[1]), (0, 0)), ((p1[0], 0, p1[1]), (0, 32)), ((p1[0], 11, p1[1]), (22, 32)), ((p0[0], 11, p0[1]), (22, 0))], nn)
                for x in range(X0, X1):              # a stone standing on its square
                    if (x, y) not in stones or (x, y) in closed: continue
                    a0, a1, b0, b1 = U(x, ox) + 3, U(x + 1, ox) - 3, U(y, oz) + 6, U(y + 1, oz) - 4
                    M(SHIP['slab']).quad([((a0, 18, b1), (3, 6)), ((a1, 18, b1), (13, 6)), ((a1, 18, b0), (13, 0)), ((a0, 18, b0), (3, 0))], up)
                    for a, b, n in (((a0, b1), (a1, b1), (0, 0, 1)), ((a1, b1), (a1, b0), (1, 0, 0)), ((a0, b0), (a0, b1), (-1, 0, 0))):
                        M(SHIP['slab']).quad([((a[0], 0, a[1]), (3, 16)), ((b[0], 0, b[1]), (13, 16)), ((b[0], 18, b[1]), (13, 0)), ((a[0], 18, a[1]), (3, 0))], n)
                # the sides of blocks and kerbs
                for hh, tex in ((10, SHIP['lowside']), (6, SHIP['side'])):
                    for n in ((0, 1), (0, -1), (1, 0), (-1, 0)):
                        for x in range(X0, X1):
                            if height(x, y) != hh: continue
                            hn = height(x + n[0], y + n[1])
                            if hn is None or hn >= hh: continue
                            if n[0] == 0:
                                zz = U(y + (1 if n[1] > 0 else 0), oz); a, b = (U(x, ox), zz), (U(x + 1, ox), zz)
                                if n[1] < 0: a, b = b, a
                            else:
                                xx = U(x + (1 if n[0] > 0 else 0), ox); a, b = (xx, U(y + 1, oz)), (xx, U(y, oz))
                                if n[0] < 0: a, b = b, a
                            face(tex, a, b, hn, hh, (n[0], 0, n[1]))
                # the wall behind this row of floor
                cols = sorted(x for x in range(X0, X1) if any(band.get((x, y - k)) == (y, k - 1) for k in (1, 2, 3)))
                z = U(y, oz)
                for x, k in runs(cols):
                    a, b = (U(x, ox), z), (U(x + k, ox), z)
                    if 'base' in SHIP:
                        face(SHIP['base'], a, b, 0, 6, fwd)
                        face(SHIP['line'], a, b, 6, 8, fwd)
                        if wall_tex == SHIP['paper']: face(wall_tex, a, b, 8, WALL_TOP, fwd, (x * 16, 8 - (WALL_TOP - 8), (x + k) * 16, 8))
                        else: face(wall_tex, a, b, 8, WALL_TOP, fwd)
                    else: face(wall_tex, a, b, 0, WALL_TOP, fwd)
                    M(SHIP['cap']).quad([((a[0], WALL_TOP, z), (1, 2)), ((b[0], WALL_TOP, z), (1 + (k * 8 if SHIP['cap'] not in plain else 1), 2)), ((b[0], WALL_TOP, z - 8), (1 + (k * 8 if SHIP['cap'] not in plain else 1), 1)), ((a[0], WALL_TOP, z - 8), (1, 1))], up)
                for x in cols:
                    sq = [(x, y - k) for k in (1, 2, 3) if band.get((x, y - k)) == (y, k - 1)]
                    art = next((SHIP['wall_art'][lay.metatile(*s)] for s in sq if lay.metatile(*s) in SHIP.get('wall_art', {})), None)
                    if art:       # (a cabinet against the wall, from this column)
                        tex, s_, t_, w, h, y0, y1, wide = art
                        face(tex, (U(x, ox), z + 2), (U(x + wide, ox), z + 2), y0, y1, fwd, (s_, t_, s_ + w, t_ + h))
                    if 'door' not in SHIP: continue
                    if any(door(*s) for s in sq):
                        tex, s, t_, w, h = SHIP['door']
                        face(tex, (U(x, ox), z + 2), (U(x + 1, ox), z + 2), 0, 32, fwd, (s, t_, s + w, t_ + h))
                    elif any(lay.metatile(*s) in SHIP_PORTHOLES for s in sq):
                        tex, s, t_, w, h = SHIP['porthole']
                        face(tex, (U(x, ox), z + 2), (U(x + 1, ox), z + 2), 14, 30, fwd, (s, t_, s + w, t_ + h))
            # round a staircase going down, the floor up to its well
            for hx0, hz0, hx1, hz1, rx0, rz0, rx1, rz1 in holes:
                if not (X0 * 16 <= hx0 < X1 * 16 and Z0 * 16 <= hz0 < Z1 * 16): continue
                L = lambda ax, az: (ax - ox * 16 - 256, az - oz * 16 - 256)
                for sx0, sz0, sx1, sz1 in ((hx0, hz0, hx1, rz0), (hx0, rz1, hx1, hz1), (hx0, rz0, rx0, rz1), (rx1, rz0, hx1, rz1)):
                    if sx1 - sx0 < 0.5 or sz1 - sz0 < 0.5: continue
                    (a0, b0), (a1, b1) = L(sx0, sz0), L(sx1, sz1)
                    M(floor_tex).quad([((a0, 0, b1), (sx0, sz1)), ((a1, 0, b1), (sx1, sz1)), ((a1, 0, b0), (sx1, sz0)), ((a0, 0, b0), (sx0, sz0))], up)
            if not meshes:
                top(SHIP['cap'], X0, 1, Z0, -1)
            groups = [(t_, t_, pal_of(t_), mesh, {'repeat': 3, 'size': dims[t_]}) for t_, mesh in meshes.items()]
            model = build_model('cv_in_%d' % (len(lands) + 10 * (spec['depth'] + 20)), groups)
            model += b'\0' * (-len(model) % 4)
            f4 = lambda v: int(round(v * 4096))
            bld = b''.join(struct.pack('<I3i3i3i8x', m, f4(U(x, ox)), 0, f4(U(z_, oz)), 0, 0, 0, 4096, 4096, 4096)
                           for m, x, z_ in props if X0 <= x < X1 and Z0 <= z_ < Z1)
            bdhc = struct.pack('<4s6H', b'BDHC', 2, 1, 1, 1, 1, 1) + struct.pack('<2i2i', -256 * 4096, -256 * 4096, 256 * 4096, 256 * 4096) + \
                struct.pack('<3i', 0, 4096, 0) + struct.pack('<i', 0) + struct.pack('<4H', 0, 1, 0, 0) + struct.pack('<iHH', 256 * 4096, 1, 0) + struct.pack('<H', 0)
            p = struct.pack('<1024H', *perm)
            lands.append(struct.pack('<4I2H', len(p), len(bld), len(model), len(bdhc), 0x1234, 0) + p + bld + model + bdhc)
            assert len(model) < 60000, ('model too big for a land', spec['gba'], len(lands), len(model))
    return gm, (nx, nz), lands


# ---------------------------------------------------------------- the Safari Zone: build_safari.py (HeartGold's own
# Safari Zone pieces, a square at a time)
from build_safari import build_safari_floor, plan as safari_plan
for _s in INTERIORS:        # (a row more where a plateau's north face needs a square: the porter moves people with it)
    if _s['look'] == 'safari' and safari_plan(_s['gba']): _s['widen'] = safari_plan(_s['gba'])


# Silph Co.'s floors half as big again: HeartGold's offices are roomier than the GBA's (Nick: "cramped"; widths at
# HeartGold's, err bigger). A new row (or column) goes in every other line where it can: each square of it a copy of
# the floor beyond (a corridor longer) or of the wall (a wall deeper), plain floor between two things; never through
# a thing (a desk, a plant, a terminal, stairs), a card-key door or a scripted walk (SILPH_SCENES). Everything moves
# with its square (the porter: room_xy).
# (where a scripted walk ends beside the player, the squares between stay as the GBA's; the rest of each walk the
# porter redoes over the bigger floor: port_map.rescaled)
SILPH_SCENES = {'SilphCo_7F_Frlg': dict(rows=(4, 6)), 'SilphCo_11F_Frlg': dict(rows=(14, 15))}


def silph_widen(gba):
    """-> widen(rows=, cols=) for a floor: rows under its walls, columns beside its partitions"""
    import gba_map, furnish
    gm = gba_map.map_json(gba); lay = gba_map.Layout(gm['layout'])
    W, H = lay.w, lay.h
    warps = {(e['x'], e['y']) for e in gm.get('warp_events', [])}
    bars = {(b['x'], b['y']) for b in json.load(open(os.path.join(HERE, 'data', 'barriers.json'))).get(gba, {}).get('squares', [])}
    walk = lambda x, y: lay.collision(x, y) == 0
    # the things (one id each): HeartGold's furniture patches, the desks, the stairs (round each warp that isn't a pad)
    thing = {}
    L_ = gba_map.layouts()[gm['layout']]
    tsn = lambda m: L_['primary_tileset'] if m < lay.n_prim else L_['secondary_tileset']
    # (things that may grow a line, HeartGold's models being laid to fit: across, any; down, those standing on the
    # floor - one against the wall would stand out from it)
    stretch = {'rows': set(), 'cols': set()}
    for k, (rule, comp) in enumerate(furnish.patches(lay, tsn, rules=furnish.KIT, full=True)):
        for c in comp: thing[c] = k
        stretch['cols'].add(k)
        if not (len(rule) > 4 and rule[4]): stretch['rows'].add(k)
    desk = LOOKS['silph']['kit']['things'][0]['mt']
    for (x, y) in [(x, y) for y in range(H) for x in range(W) if lay.metatile(x, y) in desk]:
        thing[(x, y)] = 'desk%d' % x            # (a desk's squares in a column are one)
        stretch['rows'].add('desk%d' % x); stretch['cols'].add('desk%d' % x)
    for (x, y) in warps:
        if lay.metatile(x, y) != 0x390:
            for dx in (-2, -1, 0, 1, 2):
                for dy in (-2, -1, 0, 1, 2): thing[(x + dx, y + dy)] = 'stairs%d_%d' % (x, y)
    plain_floor = next((x, y) for y in range(H) for x in range(W) if walk(x, y) and lay.metatile(x, y) == 0x334)
    # (a card-key door: a block of barrier squares; one in a north-south partition - wall above it - closes an
    # east-west way, one in an east-west wall a north-south way)
    door_of, todo = {}, set(bars)
    while todo:
        c = todo.pop(); comp, st = {c}, [c]
        while st:
            q = st.pop()
            for d in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                n = (q[0] + d[0], q[1] + d[1])
                if n in todo: todo.discard(n); comp.add(n); st.append(n)
        x0_, y0_ = min(q[0] for q in comp), min(q[1] for q in comp)
        across = 'cols' if not walk(x0_, y0_ - 1) and walk(x0_ - 1, y0_) else 'rows'     # (the way it closes: a new line along it is wall)
        for q in comp: door_of[q] = (across, (x0_, y0_ - 1) if across == 'cols' else (x0_ - 1, y0_))
    free_floor = lambda q: walk(*q) and q not in warps and q not in thing and q not in bars
    wall = lambda q: not walk(*q) and q not in thing and q not in bars and q not in warps
    out = {}
    for axis in ('rows', 'cols'):
        # along rows: a line is a row (index v), its squares by x (u); along columns the other way
        N, M = (H, W) if axis == 'rows' else (W, H)
        sq = (lambda u, v: (u, v)) if axis == 'rows' else (lambda u, v: (v, u))
        lo, hi = SILPH_SCENES.get(gba, {}).get(axis, (-1, -1))

        def plan(r):
            """the new line's squares (one per square across) put in between lines r-1 and r, or None"""
            if lo < r <= hi or r < (3 if axis == 'rows' else 1): return None
            src = []
            for u in range(M):
                a, b = sq(u, r - 1), sq(u, r)
                if a in thing and thing.get(b) == thing[a]:
                    if thing[a] in stretch[axis]: src.append(b); continue     # (a table a line bigger)
                    return None                                               # (it would split a thing)
                if a in bars and b in bars:
                    # (through a card-key door: wall where a new line would make a way round it, else floor - shut in
                    # by the door's own squares either side)
                    across, wall_sq = door_of[a]
                    src.append(wall_sq if across == ('cols' if axis == 'rows' else 'rows') else plain_floor)
                    continue
                if wall(a) and wall(b): src.append(b)                         # (a wall: deeper)
                elif free_floor(b): src.append(b)                             # (a floor: longer)
                elif free_floor(a): src.append(a)
                elif walk(*a) or walk(*b): src.append(plain_floor)            # (between two things: floor)
                elif wall(b): src.append(b)
                elif wall(a): src.append(a)
                else: return None
            return src
        lines, last = [], -9
        for r in range(3 if axis == 'rows' else 1, N):
            # every line it can (up to twice as big), where it crosses floor
            if sum(walk(*sq(u, r)) for u in range(M)) < 3: continue
            src = plan(r)
            # (mostly floor: a line through the middle of a partition only makes it thicker)
            if src and sum(walk(*q) for q in src) >= sum(not walk(*q) and lay.metatile(*q) != 0x8 for q in src):
                # (two rows just before a wall across the floor: HeartGold's wall stands three squares tall and hides
                # the floor behind it, where the GBA's stands one)
                n = 2 if axis == 'rows' and sum(walk(*sq(u, r - 1)) and not walk(*sq(u, r)) for u in range(M)) >= 5 else 1
                lines.append((r, n, src)); last = r
        if lines: out[axis] = lines
    return out


for _s in INTERIORS:
    if _s['look'] == 'silph' and 'Elevator' not in _s['gba']:
        _w = silph_widen(_s['gba'])
        if _w: _s['widen'] = _w


ROOM_AREA_BASE = 200
ROOM_AREAS = {}           # area of ours -> the room models its room places
ROOM_OWN = {}             # area of ours -> its room's own textures (build_rooms.gba_art)


def build_room_floor(spec):
    """a room built as build_rooms.py builds the houses (a look with `room`) -> as build_floor"""
    import build_rooms as BR
    base = BR.HOUSE if LOOKS[spec['look']]['room'] == 'house' else BR.LAB
    SLOTS[spec['map']] = spec['map']
    rs = dict(base, **{k: v for k, v in spec.items() if k in ('gba', 'map', 'widen')})
    data, props, gm, own = BR.build_room(rs, spec.get('_lid', 0))
    area = spec.get('_area') or ROOM_AREA_BASE + len(ROOM_AREAS)
    ROOM_AREAS[area] = {m for m, *_ in props}
    ROOM_OWN[area] = own          # (the GBA's own art for what HeartGold has nothing for: a texture set of its own)
    spec['_area'] = area
    return gm, (1, 1), [data]


def build_floor(spec, depth_of):
    if spec['look'] == 'safari': return build_safari_floor(spec, depth_of)
    if LOOKS[spec['look']].get('room'): return build_room_floor(spec)
    if LOOKS[spec['look']].get('tower'):
        import tower_kit
        return tower_kit.build_tower_floor(spec, depth_of)
    if LOOKS[spec['look']].get('kit'):
        import interior_kit
        return interior_kit.build_kit_floor(spec, depth_of)
    if LOOKS[spec['look']].get('ship'): return build_ship_floor(spec, depth_of)
    gm = gba_map.map_json(spec['gba'])
    lay = gba_map.Layout(gm['layout'])
    W, H = lay.w, lay.h
    look = LOOKS[spec['look']]
    dims, pals = texdims(look['area'])
    pal_of = lambda t: next(p for p in (t + '_pl', t) if p in pals)
    warps = {(w['x'], w['y']): w for w in gm.get('warp_events', [])}
    blocked = lambda x, y: not (0 <= x < W and 0 <= y < H) or (lay.collision(x, y) != 0 and (x, y) not in warps)
    # little patches of blocked squares out on the floor: low blocks (tables, machines, gravestones)
    low, seen = set(), set()
    for y in range(H):
        for x in range(W):
            if not blocked(x, y) or (x, y) in seen: continue
            comp, stack, edge = [], [(x, y)], False
            seen.add((x, y))
            while stack:
                c = stack.pop(); comp.append(c)
                if c[0] in (0, W - 1) or c[1] in (0, H - 1): edge = True
                for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                    n = (c[0] + dx, c[1] + dy)
                    if 0 <= n[0] < W and 0 <= n[1] < H and blocked(*n) and n not in seen:
                        seen.add(n); stack.append(n)
            if len(comp) <= 6 and not edge: low |= set(comp)
    floor = lambda x, y: not blocked(x, y)
    near_floor = lambda x, y: any(floor(x + dx, y + dy) for dx in (-1, 0, 1) for dy in (-1, 0, 1))
    outdoors = 'grass' in look            # (outdoors every tree is drawn: no dark between the hedges)
    height = lambda x, y: 0 if floor(x, y) else LOW_H if (x, y) in low else WALL_H if outdoors or near_floor(x, y) else None
    nx, nz = math.ceil(W / 32), math.ceil(H / 32)
    mb = lambda x, y: lay.behavior(lay.metatile(x, y))
    water = {(x, y) for y in range(H) for x in range(W) if floor(x, y) and 'water' in look and mb(x, y) in WATER_MB}
    grass = {(x, y) for y in range(H) for x in range(W) if floor(x, y) and 'grass' in look and mb(x, y) in TALL_GRASS_MB}
    # how each warp square acts
    kind = {}
    for (x, y), w in warps.items():
        dest = w['dest_map']
        if dest in depth_of and dest != gm['id']:
            kind[(x, y)] = 0x3C if depth_of[dest] < spec['depth'] else 0x3E
        elif blocked(x, y + 1) and not blocked(x, y - 1):
            kind[(x, y)] = 0x65             # (a way out at the foot of the wall: walk on into it)
        else:
            kind[(x, y)] = 0x3E
    lands = []
    U = lambda v, o: (v - o) * 16 - 256
    up = (0, 1, 0)
    for lz in range(nz):
        for lx in range(nx):
            meshes = {}
            M = lambda t: meshes.setdefault(t, Mesh())
            ox, oz = lx * 32, lz * 32
            perm = [0x8000] * 1024
            tops = {}                         # (texture, height) -> squares, drawn in runs
            faces = {}                        # (height, side) -> edges, drawn in runs
            for y in range(oz - 1, oz + 33):
                for x in range(ox - 1, ox + 33):
                    inland = ox <= x < ox + 32 and oz <= y < oz + 32
                    h = height(x, y)
                    if inland and 0 <= x < W and 0 <= y < H:
                        i = (y - oz) * 32 + (x - ox)
                        if floor(x, y):
                            perm[i] = kind.get((x, y), 0x0010 if (x, y) in water else 0x0002 if (x, y) in grass else 0x0000)
                    if not inland or h is None: continue
                    tex = look['floor'] if h == 0 else look['low'] if h == LOW_H else look['top']
                    if (x, y) in warps and kind[(x, y)] != 0x65: tex = look['mark']
                    elif (x, y) in water: tex, h = look['water'], -2
                    elif (x, y) in grass: tex = look['grass']
                    tops.setdefault((tex, h), set()).add((x, y))
                    if h:
                        for n in ((0, 1), (0, -1), (1, 0), (-1, 0)):
                            hn = height(x + n[0], y + n[1])
                            if hn is not None and hn < h:
                                faces.setdefault((h, hn, n), set()).add((x, y))
            for (tex, h), cells in tops.items():
                tw, th = dims[tex]
                left = set(cells)
                for (x, y) in sorted(cells, key=lambda c: (c[1], c[0])):
                    if (x, y) not in left: continue
                    k = 1
                    while (x + k, y) in left and tex != look['mark']: k += 1
                    for j in range(k): left.discard((x + j, y))
                    x0, x1, z0, z1 = U(x, ox), U(x + k, ox), U(y, oz), U(y + 1, oz)
                    s0, s1, t0, t1 = x * 16 * tw / 32, (x + k) * 16 * tw / 32, y * 16 * th / 32, (y + 1) * 16 * th / 32
                    M(tex).quad([((x0, h, z1), (s0, t1)), ((x1, h, z1), (s1, t1)), ((x1, h, z0), (s1, t0)), ((x0, h, z0), (s0, t0))], up)
            wall = look['wall']
            tw, th = dims[wall]
            for (h, hn, n), cells in faces.items():
                along_x = n[0] == 0
                left = set(cells)
                for (x, y) in sorted(cells, key=(lambda c: (c[1], c[0])) if along_x else (lambda c: (c[0], c[1]))):
                    if (x, y) not in left: continue
                    k = 1
                    step = (1, 0) if along_x else (0, 1)
                    while (x + step[0] * k, y + step[1] * k) in left: k += 1
                    for j in range(k): left.discard((x + step[0] * j, y + step[1] * j))
                    # the edge on side n of squares x..x+k (or y..y+k)
                    if along_x:
                        zz = U(y + (1 if n[1] > 0 else 0), oz)
                        a, b = (U(x, ox), zz), (U(x + k, ox), zz)
                        if n[1] < 0: a, b = b, a
                        s0, s1 = x * 16 * tw / 32, (x + k) * 16 * tw / 32
                    else:
                        xx = U(x + (1 if n[0] > 0 else 0), ox)
                        a, b = (xx, U(y + k, oz)), (xx, U(y, oz))
                        if n[0] < 0: a, b = b, a
                        s0, s1 = y * 16 * tw / 32, (y + k) * 16 * tw / 32
                    v1 = th * (h - hn) / WALL_H
                    M(wall).quad([((a[0], hn, a[1]), (s0, v1)), ((b[0], hn, b[1]), (s1, v1)), ((b[0], h, b[1]), (s1, 0)), ((a[0], h, a[1]), (s0, 0))],
                                 (n[0], 0, n[1]))
            if not meshes:
                M(look['top']).quad([((-256, WALL_H, 256), (0, 8)), ((256, WALL_H, 256), (8, 8)), ((256, WALL_H, -256), (8, 0)), ((-256, WALL_H, -256), (0, 0))], up)
            groups = [(t, t, pal_of(t), mesh, {'repeat': 3, 'size': dims[t]}) for t, mesh in meshes.items()]
            model = build_model('cv_in_%d' % (len(lands) + 10 * (spec['depth'] + 20)), groups)
            model += b'\0' * (-len(model) % 4)
            bdhc = struct.pack('<4s6H', b'BDHC', 2, 1, 1, 1, 1, 1) + struct.pack('<2i2i', -256 * 4096, -256 * 4096, 256 * 4096, 256 * 4096) + \
                struct.pack('<3i', 0, 4096, 0) + struct.pack('<i', 0) + struct.pack('<4H', 0, 1, 0, 0) + struct.pack('<iHH', 256 * 4096, 1, 0) + struct.pack('<H', 0)
            p = struct.pack('<1024H', *perm)
            lands.append(struct.pack('<4I2H', len(p), 0, len(model), len(bdhc), 0x1234, 0) + p + model + bdhc)
            assert len(model) < 60000, ('model too big for a land', spec['gba'], len(lands), len(model))
    return gm, (nx, nz), lands


def ship_models():
    """each area's building set must list the room models its maps place, and its texture file hold theirs"""
    import build_rooms as R
    from nitro import read_tex0, tex0_of, write_btx0, u16
    sets, sets_btnf = read_narc(open(R.AREA_BUILD, 'rb').read())
    atex, atex_btnf = read_narc(open(R.AREA_BUILD_TEX, 'rb').read())
    areas, _ = read_narc(open(R.AREA_DATA, 'rb').read())
    areas_btnf = _
    bm, _ = read_narc(open(R.BM_ROOM, 'rb').read())
    for area, (tex_area, model_area) in OWN_AREAS.items():
        for lst in (areas, sets, atex): lst += [lst[model_area]] * max(0, area + 1 - len(lst))
        src = u16(areas[model_area], 0)
        sets[area], atex[area] = sets[src], atex[src]
        areas[area] = struct.pack('<HH', area, u16(areas[tex_area], 2)) + areas[model_area][4:]
    tpath = os.path.join(ROOT, 'files/a/0/4/4')
    texsets, tbtnf = read_narc(open(tpath, 'rb').read())
    for area, models in ROOM_AREAS.items():      # (a room of ours: an area of its own, its building set its furniture)
        for lst in (areas, sets, atex): lst += [lst[43]] * max(0, area + 1 - len(lst))
        ts_ = u16(areas[43], 2)
        if ROOM_OWN.get(area):      # (its texture set: HeartGold's house set and the room's own art, at the area's number)
            texsets += [min(texsets, key=len)] * max(0, area + 1 - len(texsets))
            bt, bp = read_tex0(texsets[ts_], tex0_of(texsets[ts_]))
            own = ROOM_OWN[area]
            texsets[area] = write_btx0(bt + [t for t, _ in own], bp + [q for _, q in own])
            ts_ = area
        areas[area] = struct.pack('<HH', area, ts_) + areas[43][4:]
        sets[area] = struct.pack('<H', 0)
        USED_MODELS.setdefault(area, set()).update(models)
        atex[area] = write_btx0([], [])
    open(R.AREA_DATA, 'wb').write(write_narc(areas, areas_btnf))
    open(tpath, 'wb').write(write_narc(texsets, tbtnf))
    for area, models in USED_MODELS.items():
        buildset = u16(areas[area], 0)
        ids = list(struct.unpack_from('<%dH' % u16(sets[buildset], 0), sets[buildset], 2))
        ids += sorted(m for m in models if m not in ids)
        sets[buildset] = struct.pack('<H%dH' % len(ids), len(ids), *ids)
        texs, pals = read_tex0(atex[buildset], tex0_of(atex[buildset]))
        have_t, have_p = {t[0] for t in texs}, {q[0] for q in pals}
        for mid in ids:
            t0 = tex0_of(bm[mid])
            if t0 is None: continue
            mt, mp = read_tex0(bm[mid], t0)
            texs += [t for t in mt if t[0] not in have_t]; have_t |= {t[0] for t in mt}
            pals += [q for q in mp if q[0] not in have_p]; have_p |= {q[0] for q in mp}
        atex[buildset] = write_btx0(texs, pals)
    open(R.AREA_BUILD, 'wb').write(write_narc(sets, sets_btnf))
    open(R.AREA_BUILD_TEX, 'wb').write(write_narc(atex, atex_btnf))


# textures a kit look needs from another of HeartGold's sets: texset -> [(from set, [names])] (the Hideout's spin
# tiles are the Viridian Gym's slide tiles)
PALS_EXTRA = {36: ('stair01', 'chair01')}       # (palettes named for something else: the Radio Tower's stairs' and chairs')
IMPORTS = {64: [(55, ['to_j_i1', 'to_j_mark'])],
           77: [(40, ['so_tomb02'])],          # (the Pokemon Tower: the House of Memories' gravestone)
           39: [(36, ['rtable_l02', 'rpc_moni.1', 'rchair03', 'r_stair', 'rwall_a', 'rwin_a', 'rtop_a', 'ryuka_b']), (64, ['aj_box01']),
                (('bm', 204), ['y_j_warp'])],          # (Saffron Gym's warp panel, from its model)
           44: [(70, ['d_rock01'])],
           18: [(75, ['pond_on', 'pond_edge', 'pond_un']),          # (Kanto's overworld: build_overworld.py;
                (11, ['ymb_fe01', 'ymb_fe01_r', 'ymb_fe02', 'ymb_fe02_r', 'kbc_rd01', 'kbc_rd02', 'kbc_rd03', 'kbc_rd07', 'kbc_rd10']),       # its towns' own grounds)
                (15, ['tama_yuka', 'tama_yuka2', 'tama_fuch']), (13, ['han_fe02', 'han_fe02_r']),
                (14, ['sio_fe02', 'sio_fe02_r', 'bridge_a', 'bridge_b', 'bridge_c', 'sio_board',     # (Route 12's boardwalk,
                      'road02', 'road02_r']),                                                       # Route 14's road)
                (13, ['a12_gbb1', 'a12_gbb2', 'a12_gbb3', 'river', 'river_r']),     # (the Nugget Bridge, HeartGold's rivers)
                (10, ['tok_fe01', 'tok_fe01_r']),                                      # (Viridian's paving)
                (16, ['f_dodai', 'f_dodai_a', 'flower_sp1', 'sek_teien', 'sek_flower', 'grass02_a'])]}  # (Fuchsia's pens)
DROP = {18: ['sek_fe03', 'sek_fe03_r',      # (no longer laid: Fuchsia's dark red ground; and what no land of set 18's
            'tree01_re', 'hit_r', 'a17_gt01', 'beach01_r2', 'road05_r', 'r_climb', 'a12_gbb4', 'road01_sub']}   # lays: its room)

# edges HeartGold has none of: its road's edge in the grass (road01_r's layout, which every edge we lay shares) with a
# paving's own texels in place of the road's (Viridian's tok_fe01 meets the grass at a curb in HeartGold's; Nick:
# a transition everywhere)
MADE_EDGES = {18: [('cv_tok_r', 'road01_r', 'tok_fe01')]}


def edge_texture(texs, pals, name, layout, base):
    """road01_r with `base`'s texels for its sand and a rim of `base`'s own shadow: (texture, palette) entries, 256
    colours (as build_pallet's cv_sand_r)"""
    from texview import decode
    tex = lambda n: next(t for t in texs if t[0] == n.encode())
    pal = lambda n: next((q for q in pals if q[0] in ((n + '_pl').encode(), n.encode())))[2]
    road = decode(tex(layout)[1], tex(layout)[3], tex(layout)[4], pal(layout)).convert('RGB')
    pave = decode(tex(base)[1], tex(base)[3], tex(base)[4], pal(base)).convert('RGB')
    lum = lambda c: 0.3 * c[0] + 0.59 * c[1] + 0.11 * c[2]
    sandy = lambda c: c[0] > c[2] + 30 and c[0] >= c[1] - 12 and lum(c) > 150
    green = lambda c: c[1] > c[0] + 10 and c[1] > c[2]
    dark = min((pave.getpixel((x, y)) for x in range(pave.width) for y in range(pave.height)), key=lum)
    rim = lambda c: tuple((a + 2 * b) // 3 for a, b in zip(c, dark))
    cols, idx = [], bytearray()
    for y in range(road.height):
        for x in range(road.width):
            c = road.getpixel((x, y))
            if sandy(c): c = pave.getpixel((x % pave.width, y % pave.height))
            elif not green(c): c = rim(c)
            v = (c[0] >> 3) | (c[1] >> 3) << 5 | (c[2] >> 3) << 10
            if v not in cols: cols.append(v)
            idx.append(cols.index(v))
    assert len(cols) <= 256
    prm = tex(layout)[1] & ~(7 << 26) & ~(1 << 29) | (4 << 26)
    return (name.encode(), prm, tex(layout)[2], bytes(idx), b''), \
        ((name + '_pl').encode(), 0, b''.join(struct.pack('<H', c) for c in cols) + b'\0' * (-2 * len(cols) % 16))


def import_textures():
    from nitro import read_tex0, tex0_of, write_btx0
    path = os.path.join(ROOT, 'files/a/0/4/4')
    ts, btnf = read_narc(open(path, 'rb').read())
    pals_extra = PALS_EXTRA
    for dst, srcs in IMPORTS.items():
        t, p = read_tex0(ts[dst], tex0_of(ts[dst]))
        gone = {n.encode() for n in DROP.get(dst, ())} | {(n + '_pl').encode() for n in DROP.get(dst, ())}
        t, p = [e for e in t if e[0] not in gone], [q for q in p if q[0] not in gone]
        for src, names in srcs:
            if isinstance(src, tuple):       # (('bm', n): a room model's own textures, files/a/1/4/8)
                bm_ = read_narc(open(os.path.join(ROOT, 'files/a/1/4/8'), 'rb').read())[0][src[1]]
                st, sp = read_tex0(bm_, tex0_of(bm_))
            else:
                st, sp = read_tex0(ts[src], tex0_of(ts[src]))
            nt = [e for e in st if e[0].decode() in names]
            np_ = [q for q in sp if q[0].decode() in names or q[0].decode()[:-3] in {n.split('.')[0] for n in names} | set(names) or q[0].decode() in pals_extra.get(src, ())]
            t = [e for e in t if e[0] not in {x[0] for x in nt}] + nt
            p = [q for q in p if q[0] not in {x[0] for x in np_}] + np_
        for name, layout, base in MADE_EDGES.get(dst, ()):
            e_, p_ = edge_texture(t, p, name, layout, base)
            t = [x for x in t if x[0] != e_[0]] + [e_]
            p = [x for x in p if x[0] != p_[0]] + [p_]
        ts[dst] = write_btx0(t, p)
        assert len(ts[dst]) < 56 * 1024, (dst, len(ts[dst]))
    open(path, 'wb').write(write_narc(ts, btnf))


def main():
    import_textures()
    ids = gba_ids()
    for g, m in ids.items():
        SLOTS[m] = next(c['map'] for c in INTERIORS if c['gba'] == g)
    depth_of = {ids[c['gba']]: c['depth'] for c in INTERIORS}
    land, btnf = read_narc(open(LAND_NARC, 'rb').read())
    lid = LAND_BASE
    for spec in INTERIORS:
        tmpl = header(spec['template'])
        spec['_lid'] = lid
        gm, (nx, nz), lands = build_floor(spec, depth_of)
        lids = list(range(lid, lid + len(lands)))
        land += [b''] * max(0, lids[-1] + 1 - len(land))
        for i, d in zip(lids, lands): land[i] = d
        lid += len(lands)
        new_map(spec['map'])
        tag = spec['map'].replace('MAP_CANVAS_', '')
        mat = matrix_file(tag, nx, nz, lids)
        ev = json.load(open(os.path.join(slots.EVENT_DIR, events_file(spec['template']))))
        ev['warps'] = [{k: v for k, v in w.items() if not k.startswith('_')} for w in gba_warps(gm)]
        for w, gw in zip(ev['warps'], gm['warp_events']):
            ex = spec.get('exits', {}).get((gw['dest_map'], str(gw['dest_warp_id'])), spec.get('exits', {}).get(gw['dest_map']))
            if ex:
                w.update(x=gw['x'], z=gw['y'], y=0, header=ex[0], anchor=ex[1])
        ev['objects'], ev['bgs'], ev['coords'] = [], [], []
        evn = new_events_file(tag, ev)
        fields = {k: v for k, v in tmpl.items() if k not in ('matrixId', 'eventsBank')}
        fields.update(matrixId=mat, eventsBank=evn, areaDataBank=str(spec.get('_area', LOOKS[spec['look']]['area'])), weather='0', **NO_SCRIPTS)
        if LOOKS[spec['look']].get('kit') or LOOKS[spec['look']].get('tower'): fields['cameraType'] = '4'      # (HeartGold's indoor camera, as its own rooms of these looks have)
        if spec.get('place'):       # (the name shown on entering: the town's, where the template is elsewhere)
            fields['mapsec'] = header(spec['place'])['mapsec']
        set_header(spec['map'], fields)
        print(spec['gba'], '->', spec['map'], '%dx%d lands' % (nx, nz), lids)
    land = [d if d else land[209] for d in land]
    open(LAND_NARC, 'wb').write(write_narc(land, btnf))
    import build_safari
    json.dump(build_safari.MOVED, open(build_safari.MOVED_FILE, 'w'), indent=1, sort_keys=True)
    import build_rooms as BR       # (where our rooms' wall furniture stands: the porter moves people off it)
    if BR.STANDS:
        sf = os.path.join(HERE, 'data', 'room_furniture.json')
        st = json.load(open(sf)) if os.path.exists(sf) else {}
        st.update(BR.STANDS)
        json.dump(st, open(sf, 'w'), indent=1, sort_keys=True)
    ship_models()
    import world
    for m, (x, z), beh, to, anchor in ADD_WARPS:
        w_, h_, ls = world.map_matrix(m)
        lid = ls[(z // 32) * w_ + x // 32]
        d = bytearray(land[lid])
        struct.pack_into('<H', d, 0x14 + ((z % 32) * 32 + x % 32) * 2, beh)
        land[lid] = bytes(d)
        path = os.path.join(slots.EVENT_DIR, events_file(m))
        ev = json.load(open(path))
        ev['warps'] = [w for w in ev['warps'] if not (w['x'] == x and w['z'] == z)]
        ev['warps'].append({'x': x, 'z': z, 'header': to, 'anchor': anchor, 'y': 0})
        json.dump(ev, open(path, 'w'), indent=4); open(path, 'a').write('\n')
    open(LAND_NARC, 'wb').write(write_narc(land, btnf))
    for (m, i), (to, anchor) in DOORS.items():
        if 'EVERYWHERE' in header(m)['matrixId']: continue     # (the towns' doors: build_overworld.py's, on the GBA's layouts)
        path = os.path.join(slots.EVENT_DIR, events_file(m))
        ev = json.load(open(path))
        ev['warps'][i].update(header=to, anchor=anchor)
        json.dump(ev, open(path, 'w'), indent=4); open(path, 'a').write('\n')


if __name__ == '__main__':
    main()
