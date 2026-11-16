"""places.py OUT.txt [GBA map dir...] : a shots.py list of the ported maps (default: all of port_map's MAPS),
each with a square to stand on: outdoors the open square nearest the middle of the map's part of the world,
indoors the square inside its first door."""
import os, sys, json, re
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, '..')); sys.path.insert(0, os.path.join(HERE, '..', 'port'))
import slots, world
import port_map as P
import auto_anchor as AA

ids = AA.map_ids()
BAD = (0x10, 0x11, 0x13, 0x15, 0x62, 0x63, 0x64, 0x65, 0x69, 0x6E, 0x6F, 0x6C, 0x6D)


def ok(v): return v is not None and not v & 0x8000 and (v & 0xFF) not in BAD


def spot(slot):
    if AA.outdoor(slot):
        # (in front of a door, the Pokemon Center's first: the town around it is in view)
        ws = sorted(AA.hg_warps(slot), key=lambda w: 'POKECENTER' not in w['header'])
        for wv in ws:
            if AA.header_at(wv['x'], wv['z'] + 1) == ids[slot] and ok(world.perm(wv['x'], wv['z'] + 1)):
                return wv['x'], wv['z'] + 1
        w, h, hdr, alt, lands = world.matrix()
        cs = [(i % w, i // w) for i in range(w * h) if hdr[i] == ids[slot]]
        if not cs: return None
        cx = sum(c[0] for c in cs) / len(cs) * 32 + 16; cz = sum(c[1] for c in cs) / len(cs) * 32 + 16
        sq = [(x, z) for c in cs for x in range(c[0] * 32, c[0] * 32 + 32) for z in range(c[1] * 32, c[1] * 32 + 32)]
        sq = [s for s in sq if ok(world.perm(*s))]
        return min(sq, key=lambda s: (s[0] - cx) ** 2 + (s[1] - cz) ** 2) if sq else None
    ws = AA.hg_warps(slot)
    for wv in ws:
        for dz in (-1, -2, 1):
            v = world.perm_in(slot, wv['x'], wv['z'] + dz)
            if ok(v): return wv['x'], wv['z'] + dz
    w, h, ls = world.map_matrix(slot)
    sq = [(x, z) for x in range(w * 32) for z in range(h * 32) if ok(world.perm_in(slot, x, z))]
    return min(sq, key=lambda s: (s[0] - w * 16) ** 2 + (s[1] - h * 16) ** 2) if sq else None


out = sys.argv[1]
names = sys.argv[2:] or list(P.MAPS)
lines = []
for d in names:
    slot = P.MAPS[d][0]
    s = spot(slot)
    if s is None: print('no spot', d, slot); continue
    lines.append('%s %d %d %d' % (re.sub(r'\W', '_', d.replace('_Frlg', '')), ids[slot], s[0], s[1]))
open(out, 'w').write('\n'.join(lines) + '\n')
print(len(lines), 'places')
