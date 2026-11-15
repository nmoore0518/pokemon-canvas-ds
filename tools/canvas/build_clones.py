"""Canvas: rooms that are copies of HeartGold's (the Pokemon Center, the Mart, the Training Hall).
Each goes in an unused map slot: the slot takes the HeartGold room's header (land, scripts, music...), with
an events file of its own whose doors lead back to our town (see slots.CLONES)."""
import json, os, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from slots import SLOTS, CLONES, CLONE_OF, header, set_header, events_file, new_events_file, EVENT_DIR

KEEP_FROM_TEMPLATE = ['wildEncounterBank', 'areaDataBank', 'moveModelBank', 'matrixId', 'scriptsBank', 'scriptHeaderBank',
                      'msgBank', 'dayMusicId', 'nightMusicId', 'areaIcon', 'momCallIntroParam', 'regionNo', 'weather',
                      'mapType', 'cameraType', 'followMode', 'battleBg', 'bikeAllowed', 'runningAllowed_Unused',
                      'escapeRopeAllowed', 'flyAllowed', 'outgoingCalls', 'incomingCalls', 'radioSignal']


def main():
    town = header('MAP_PALLET')
    import gba_map
    gba_name = {}
    for d in os.listdir(os.path.join(gba_map.GBA, 'data/maps')):
        try:
            gba_name[gba_map.map_json(d)['id']] = d
        except Exception:
            pass
    for gba, tmpl, keep, slot in CLONES:
        t = header(tmpl)
        ev = json.load(open(os.path.join(EVENT_DIR, events_file(tmpl))))
        # the GBA room we're standing in for: who leads into it, and through which of their warps
        parents = {}
        for pid, pd in gba_name.items():
            if pid == gba or pid not in SLOTS: continue
            for i, w in enumerate(gba_map.map_json(pd).get('warp_events', [])):
                if w['dest_map'] == gba: parents.setdefault(pid, i)
        outside = [p for p in parents if SLOTS[p] not in CLONE_OF.values()]
        warps = []
        for w in ev['warps']:
            if w['header'] in CLONE_OF:                                  # another copied room: our copy of it
                warps.append(dict(w, header=CLONE_OF[w['header']]))
            elif outside:                                                # the first other warp: our way out
                pid = outside.pop(0)
                warps.append(dict(w, header=SLOTS[pid], anchor=parents[pid]))
            else:                                                        # somewhere we haven't built: shut
                warps.append(dict(w, x=0, z=0, header=slot, anchor=0))
        ev['warps'] = warps
        ev['objects'] = [o for o in ev.get('objects', []) if keep is None or o['id'].split('_', 2)[2] in keep]
        name = new_events_file(slot.replace('MAP_', ''), ev)
        fields = {k: t[k] for k in KEEP_FROM_TEMPLATE if k in t}
        fields.update(eventsBank=name, mapsec=town['mapsec'], worldMapX='32', worldMapY='11')
        set_header(slot, fields)
        print(gba, '->', slot, 'copy of', tmpl, len(ev['objects']), 'people')


if __name__ == '__main__':
    main()
