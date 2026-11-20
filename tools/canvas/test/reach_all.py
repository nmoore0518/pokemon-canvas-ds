"""reach_all.py: can every place be got to from Pallet Town, and back? A walk over every map's squares (the world's
and every room's and cave's), through their warps, with every HM (water is walkable, ledges are one way).

    python3 tools/canvas/test/reach_all.py [--objects]

Reports
  - warps that can't be got to (doors, stairs, holes) and maps never reached,
  - traps: squares you can get to but not back to Pallet from (a ledge or a hole into a closed pocket),
  - with --objects: people and things standing in the way - each one whose square, made free, would let you reach
    a warp or square you otherwise couldn't (a person in a doorway, a sign or a tree on the only path). Things meant
    to be moved are left out: cut trees, smashable rocks, boulders, barriers (barriers.py), sleeping Snorlax, items.
"""
import sys, os, json, re, struct, collections
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, '..'))
import world, slots

LEDGE = {0x38: (1, 0), 0x39: (-1, 0), 0x3A: (0, -1), 0x3B: (0, 1)}
MOVABLE = {'SPRITE_TREE', 'SPRITE_BREAKROCK', 'SPRITE_ROCK', 'SPRITE_KABIGON', 'SPRITE_MONSTARBALL',
           'SPRITE_LEAG_DOOR2', 'SPRITE_STOP'}     # (the League's doors and HeartGold's posts: scripts open them)
START = ('WORLD', 1039, 380)          # Pallet Town, outside the player's house


def map_ids():
    out = {}
    for n, v in re.findall(r'#define (MAP_\w+)\s+(\d+)', open(slots.MAPS_H).read()):
        out[n] = int(v)
    return out


IDS = map_ids()
NAME = {v: k for k, v in IDS.items()}
_hdr = {}


def header(m):
    if m not in _hdr:
        try: _hdr[m] = slots.header(m)
        except Exception: _hdr[m] = None
    return _hdr[m]


def is_world(m):
    h = header(m)
    return bool(h) and 'EVERYWHERE' in h.get('matrixId', '')


_ev = {}


def events(m):
    if m not in _ev:
        try: _ev[m] = json.load(open(os.path.join(slots.EVENT_DIR, slots.events_file(m))))
        except Exception: _ev[m] = {}
    return _ev[m]


def space(m):
    return 'WORLD' if is_world(m) else m


def perm(sp, x, z):
    try:
        return world.perm(x, z) if sp == 'WORLD' else world.perm_in(sp, x, z)
    except Exception:
        return None


def world_maps():
    """the maps of the world matrix (their events are in world squares)"""
    w, h, hdr, alt, ls = world.matrix()
    return sorted({NAME.get(i) for i in hdr if NAME.get(i)} - {None})


def main():
    use_objects = '--objects' in sys.argv
    # ---- warps, by the space they're in: (space, x, z) -> [(dest space, x, z, dest map)]
    maps = [m for m in IDS if header(m)]
    wmaps = set(world_maps())
    warps = collections.defaultdict(list)
    warp_list = []
    objects = {}          # (space, x, z) -> (map, object)
    dyn = []
    for m in maps:
        ev = events(m)
        sp = space(m)
        if sp == 'WORLD' and m not in wmaps: continue
        for i, w in enumerate(ev.get('warps', [])):
            dest = w.get('header')
            if dest in (4095, '4095'):     # (an elevator's way out: to any of the doors that lead into it)
                dyn.append((m, sp, w['x'], w['z'])); continue
            if not isinstance(dest, str) or dest not in IDS or not header(dest): continue
            if (w['x'], w['z']) == (0, 0) and dest == 'MAP_PALLET': continue      # (a dead warp)
            dw = events(dest).get('warps', [])
            a = w.get('anchor', 0)
            if not isinstance(a, int) or a >= len(dw): continue
            to = (space(dest), dw[a]['x'], dw[a]['z'])
            warps[(sp, w['x'], w['z'])].append(to + (dest,))
            warp_list.append((m, i, sp, w['x'], w['z'], dest))
        for o in ev.get('objects', []):
            objects[(sp, o['x'], o['z'])] = (m, o)

    def blocked_obj(k):
        if not use_objects or k not in objects: return False
        m, o = objects[k]
        spr = str(o['spriteId'])
        if spr in MOVABLE or spr.startswith('70'): return False     # (moved by the player, or our barriers)
        return k not in freed

    def step(k, back=False):
        """squares one move from k (forward, or which can move to k when back)"""
        sp, x, z = k
        out = []
        for dx, dz in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            if back: dx, dz = -dx, -dz
            n = (sp, x + dx, z + dz)
            v = perm(*n)
            if v is None: continue
            b = v & 0xFF
            if b in LEDGE:
                d = LEDGE[b] if not back else (-LEDGE[b][0], -LEDGE[b][1])
                if d != (dx, dz): continue
                n2 = (sp, n[1] + dx, n[2] + dz)
                v2 = perm(*n2)
                if v2 is not None and not v2 & 0x8000 and not blocked_obj(n2): out.append(n2)
                continue
            if v & 0x8000 and n not in warps: continue
            if blocked_obj(n): continue
            out.append(n)
        return out

    for m, sp, x, z in dyn:
        for m2, i2, sp2, x2, z2, d2 in warp_list:
            if d2 == m: warps[(sp, x, z)].append((sp2, x2, z2, m2))
    rev_warps = collections.defaultdict(list)
    for k, ts in warps.items():
        for t in ts: rev_warps[t[:3]].append(k)

    def walk(start, back=False, known=()):
        seen = {start}; q = collections.deque([start])
        while q:
            k = q.popleft()
            if k in known: continue             # (already reached: no need to go on from it)
            nxt = step(k, back)
            if not back:
                for t in warps.get(k, []): nxt.append(t[:3])
            else:
                nxt += rev_warps.get(k, [])
            for n in nxt:
                if n not in seen: seen.add(n); q.append(n)
        return seen

    freed = set()
    fwd = walk(START)
    bwd = walk(START, back=True)
    if '--return' in sys.argv: return fwd, bwd, warps, walk
    reached_maps = set()
    for m in maps:
        sp = space(m)
        if sp != 'WORLD' and any(k[0] == sp for k in warps if k[0] == sp and k in fwd): reached_maps.add(m)
    print('squares reached:', len(fwd))
    unreached = [(m, i, x, z, d) for m, i, sp, x, z, d in warp_list if (sp, x, z) not in fwd
                 and not any((sp, x + dx, z + dz) in fwd for dx, dz in ((1, 0), (-1, 0), (0, 1), (0, -1)))]
    # (only the maps that are ours or that a reached map leads to)
    ours = {k[0] for k in fwd} - {'WORLD'}
    import build_overworld as O        # (the world's squares that are ours: Kanto, not HeartGold's Johto)
    x0, z0 = O.ORIGIN[0] * 32, O.ORIGIN[1] * 32
    kanto = lambda x, z: x0 <= x < x0 + O.CELLS[0] * 32 and z0 <= z < z0 + O.CELLS[1] * 32
    unreached = [u for u in unreached if space(u[0]) in ours or (space(u[0]) == 'WORLD' and kanto(u[2], u[3]))]
    print('warps that cannot be got to: %d' % len(unreached))
    for u in unreached: print('  ', u)
    traps = [k for k in fwd if k not in bwd]
    by = collections.defaultdict(list)
    for k in traps: by[k[0]].append(k[1:])
    print('trap squares (in, and no way back): %d' % len(traps))
    for sp, ks in sorted(by.items(), key=lambda kv: -len(kv[1]))[:40]:
        xs = sorted(ks)
        print('   %s: %d, e.g. %s' % (sp, len(ks), xs[:6]))
    if use_objects:
        base_fwd = fwd
        open_fwd = None
        # what would be reached with every (non-movable) object gone
        freed = set(objects)
        open_fwd = walk(START)
        lost = open_fwd - base_fwd
        print('squares only reachable without the people/things in the way: %d' % len(lost))
        culprits = collections.Counter()
        near = lambda k: any((k[0], k[1] + dx, k[2] + dz) in base_fwd for dx, dz in ((1, 0), (-1, 0), (0, 1), (0, -1)))
        for k, (m, o) in objects.items():
            spr = str(o['spriteId'])
            if spr in MOVABLE or spr.startswith('70') or k not in lost or not near(k): continue
            # does freeing just this one reach anything new? (from it, not going on past what was reached already)
            freed = {k}
            f = walk(k, known=base_fwd)
            gain = len(f - base_fwd)
            if gain > 1: culprits[(m, o['id'], spr, k[1], k[2])] = gain
        for c, n in culprits.most_common(): print('   in the way:', c, 'frees', n)


if __name__ == '__main__':
    main()
