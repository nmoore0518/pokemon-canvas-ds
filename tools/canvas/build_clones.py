"""Canvas: rooms that are copies of HeartGold's (the Pokemon Center, the Mart, the Training Hall).
Each goes in an unused map slot: the slot takes the HeartGold room's header (land, scripts, music...), with
an events file of its own whose doors lead back to our town (see slots.CLONES)."""
import json, os, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from slots import SLOTS, CLONES, header, set_header, events_file, new_events_file, EVENT_DIR

KEEP_FROM_TEMPLATE = ['wildEncounterBank', 'areaDataBank', 'moveModelBank', 'matrixId', 'scriptsBank', 'scriptHeaderBank',
                      'msgBank', 'dayMusicId', 'nightMusicId', 'areaIcon', 'momCallIntroParam', 'regionNo', 'weather',
                      'mapType', 'cameraType', 'followMode', 'battleBg', 'bikeAllowed', 'runningAllowed_Unused',
                      'escapeRopeAllowed', 'flyAllowed', 'outgoingCalls', 'incomingCalls', 'radioSignal']


def main():
    town = header('MAP_PALLET')
    for gba, tmpl, keep in CLONES:
        slot = SLOTS[gba]
        t = header(tmpl)
        ev = json.load(open(os.path.join(EVENT_DIR, events_file(tmpl))))
        town_map = ev['warps'][0]['header']
        # our town's door into this room (the GBA town's warp list order)
        sys.path.insert(0, HERE)
        import gba_map
        gw = gba_map.map_json('PalletTown_Frlg')['warp_events']
        back = next(i for i, w in enumerate(gw) if w['dest_map'] == gba)
        ev['warps'] = [dict(w, header='MAP_PALLET', anchor=back) for w in ev['warps'] if w['header'] == town_map][:1]
        ev['objects'] = [o for o in ev.get('objects', []) if keep is None or o['id'].split('_', 2)[2] in keep]
        name = new_events_file(slot.replace('MAP_', ''), ev)
        fields = {k: t[k] for k in KEEP_FROM_TEMPLATE if k in t}
        fields.update(eventsBank=name, mapsec=town['mapsec'], worldMapX='32', worldMapY='11')
        set_header(slot, fields)
        print(gba, '->', slot, 'copy of', tmpl, len(ev['objects']), 'people')


if __name__ == '__main__':
    main()
