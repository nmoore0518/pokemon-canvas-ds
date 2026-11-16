"""Landmarks for Anchored maps, worked out instead of picked by hand.

A GBA map that keeps HeartGold's layout gets its people by the offsets of landmarks seen in both games:
  - doors: a GBA warp to room R pairs with HeartGold's warp (on the same map) to R's HeartGold room;
  - exits: a GBA connection to map M pairs the middle of the GBA's open edge on that side with the middle of
    HeartGold's open border to M's HeartGold map (outdoor maps only).
DEST maps GBA map constants to HeartGold maps (port_map builds it from MAPS, slots.SLOTS and DEST_EXTRA)."""
import json, os, re, sys
from collections import defaultdict
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.dirname(HERE))
import slots, world, gba_map

_ids = {}


def map_ids():
    if not _ids:
        for name, num in re.findall(r'#define (MAP_\w+)\s+(\d+)', open(slots.MAPS_H).read()):
            _ids[name] = int(num)
    return _ids


def hg_warps(slot):
    ev = json.load(open(os.path.join(slots.EVENT_DIR, slots.events_file(slot))))
    return ev.get('warps', [])


def outdoor(slot):
    return 'EVERYWHERE' in slots.header(slot)['matrixId']


def header_at(x, z):
    la = world.land_at(x, z)
    return la[1] if la else None


def _open(x, z):
    v = world.perm(x, z)
    return v is not None and not v & 0x8000


def _pair_lists(g, h):
    """two lists of squares for the same place: in step if the counts match, else their middles"""
    g, h = sorted(g), sorted(h)
    if len(g) == len(h): return list(zip(g, h))
    mid = lambda s: (round(sum(p[0] for p in s) / len(s)), round(sum(p[1] for p in s) / len(s)))
    return [(mid(g), mid(h))]


def door_pairs(slot, gm, dest):
    out = []
    gw = defaultdict(list)
    for w in gm.get('warp_events', []):
        d = dest.get(w['dest_map'])
        if d: gw[d].append((w['x'], w['y']))
    hw = defaultdict(list)
    for w in hg_warps(slot):
        hw[w['header']].append((w['x'], w['z']))
    for d, gs in gw.items():
        if d in hw: out += _pair_lists(gs, hw[d])
    return out


STEP = {'up': (0, -1), 'down': (0, 1), 'left': (-1, 0), 'right': (1, 0)}


def _edge_runs(squares, along):
    """the longest run of neighbouring squares (sorted along x or z)"""
    if not squares: return []
    s = sorted(squares, key=lambda p: p[along])
    runs, cur = [], [s[0]]
    for p in s[1:]:
        if p[along] - cur[-1][along] <= 1: cur.append(p)
        else: runs.append(cur); cur = [p]
    runs.append(cur)
    return max(runs, key=len)


def exit_pairs(slot, gm, dest, primaries):
    """the middle of the open GBA edge towards each connection <-> the middle of HeartGold's open border there"""
    if not outdoor(slot): return []
    ids, out = map_ids(), []
    lay = gba_map.Layout(gm['layout'])
    w, h, hdr, alt, lands = world.matrix()
    own = ids[slot]
    for c in gm.get('connections') or []:
        hm = dest.get(c['map'])
        if hm is None or hm not in ids: continue
        dx, dz = STEP[c['direction']]
        # the GBA edge: open squares in the edge row/column that face the other map
        try:
            other = gba_map.Layout(gba_map.map_json(_dir_of(c['map']))['layout'])
            ow, oh = other.w, other.h
        except Exception:
            ow = oh = 10 ** 6
        off = int(c['offset'])
        if c['direction'] in ('up', 'down'):
            y = 0 if c['direction'] == 'up' else lay.h - 1
            gs = [(x, y) for x in range(max(0, off), min(lay.w, off + ow)) if lay.collision(x, y) == 0]
            along = 0
        else:
            x = 0 if c['direction'] == 'left' else lay.w - 1
            gs = [(x, y) for y in range(max(0, off), min(lay.h, off + oh)) if lay.collision(x, y) == 0]
            along = 1
        # HeartGold's border: our open squares whose neighbour that way is the other map (or a map between that
        # nobody ports to, such as half of a route HeartGold splits in two)
        target = ids[hm]
        hs = []
        for cz in range(h):
            for cx in range(w):
                if hdr[cz * w + cx] != own: continue
                for zz in range(cz * 32, cz * 32 + 32):
                    for xx in range(cx * 32, cx * 32 + 32):
                        n = header_at(xx + dx, zz + dz)
                        if n == target and _open(xx, zz) and _open(xx + dx, zz + dz): hs.append((xx, zz))
        if not hs:
            # through a map in between: walk on that way up to 48 squares over headers nobody ports
            prim = set(ids[p] for p in primaries if p in ids)
            for cz in range(h):
                for cx in range(w):
                    if hdr[cz * w + cx] != own: continue
                    for zz in range(cz * 32, cz * 32 + 32):
                        for xx in range(cx * 32, cx * 32 + 32):
                            n = header_at(xx + dx, zz + dz)
                            if n is None or n == own or n in prim or not _open(xx, zz): continue
                            X, Z = xx, zz
                            for _ in range(48):
                                X, Z = X + dx, Z + dz
                                n2 = header_at(X, Z)
                                if n2 == target: hs.append((xx, zz)); break
                                if n2 is None or n2 in prim or n2 == own: break
        gr, hr = _edge_runs(gs, along), _edge_runs(hs, along)
        if gr and hr:
            mid = lambda s: (round(sum(p[0] for p in s) / len(s)), round(sum(p[1] for p in s) / len(s)))
            out.append((mid(gr), mid(hr)))
    return out


_dirs = {}


def _dir_of(const):
    if not _dirs:
        root = os.path.join(gba_map.P('data/maps'))
        for d in os.listdir(root):
            p = os.path.join(root, d, 'map.json')
            if os.path.exists(p):
                try: _dirs[json.load(open(p))['id']] = d
                except Exception: pass
    return _dirs[const]


def pairs(slot, gba_dir, dest, primaries):
    gm = gba_map.map_json(gba_dir.split('#')[0])
    out = door_pairs(slot, gm, dest) + exit_pairs(slot, gm, dest, primaries)
    if not out and not outdoor(slot):
        # (a room whose doors lead to places we don't pair: the middles of all its doors)
        g = [(w['x'], w['y']) for w in gm.get('warp_events', [])]
        h = [(w['x'], w['z']) for w in hg_warps(slot)]
        if g and h: out = _pair_lists(g, h)
    return out
