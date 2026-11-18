"""world_reach.py: every door of the GBA-layout world (build_overworld.py) can be walked up to (its open side joins
the rest of its part of the world), and the parts of the world from Pallet. python3 tools/canvas/test/world_reach.py"""
import sys, json, os, collections
sys.path.insert(0, '/home/claude/pokemon-canvas-ds/tools/canvas')
import world, slots, build_overworld as O
J = json.load(open(O.WORLD_JSON))
cells = {tuple(map(int, k.split(','))): v for k, v in J['cells'].items()}
x0, z0 = O.ORIGIN[0] * 32, O.ORIGIN[1] * 32
X1, Z1 = x0 + O.CELLS[0] * 32, z0 + O.CELLS[1] * 32
LEDGE = {0x38: (1, 0), 0x39: (-1, 0), 0x3A: (0, -1), 0x3B: (0, 1)}
def ok(x, z, dx, dz):
    v = world.perm(x, z)
    if v is None: return False
    b = v & 0xFF
    if b in LEDGE: return LEDGE[b] == (dx, dz)
    if v & 0x8000: return False
    return True
start = (1039, 380)    # Pallet
seen = {start}; q = collections.deque([start])
while q:
    x, z = q.popleft()
    for dx, dz in ((1, 0), (-1, 0), (0, 1), (0, -1)):
        n = (x + dx, z + dz)
        if n in seen or not (x0 <= n[0] < X1 and z0 <= n[1] < Z1): continue
        v = world.perm(*n)
        if v is None: continue
        b = v & 0xFF
        if b in LEDGE:
            if LEDGE[b] != (dx, dz): continue
            n2 = (n[0] + dx, n[1] + dz)       # (jump over)
            if n2 not in seen: seen.add(n2); q.append(n2)
            continue
        if v & 0x8000: continue
        seen.add(n); q.append(n)
print('reached', len(seen))
bad = []
for X in sorted(set(cells.values())):
    try: ev = json.load(open(os.path.join(slots.EVENT_DIR, slots.events_file(X))))
    except Exception: continue
    for w in ev['warps']:
        x, z = w['x'], w['z']
        adj = [(x, z + 1), (x, z - 1), (x + 1, z), (x - 1, z), (x, z)]
        if not any(a in seen for a in adj): bad.append((X, w['header'], x, z))
print(len(bad)); [print(b) for b in bad]
# components of walkable squares (ledges either way, water counted: surfing)
comp = {}
cid = 0
for z in range(z0, Z1):
    for x in range(x0, X1):
        if (x, z) in comp: continue
        v = world.perm(x, z)
        if v is None or (v & 0x8000 and (v & 0xFF) not in LEDGE): continue
        cid += 1; comp[(x, z)] = cid; q = collections.deque([(x, z)]); n = 0
        while q:
            a = q.popleft(); n += 1
            for dx, dz in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                b = (a[0] + dx, a[1] + dz)
                if b in comp or not (x0 <= b[0] < X1 and z0 <= b[1] < Z1): continue
                vv = world.perm(*b)
                if vv is None or (vv & 0x8000 and (vv & 0xFF) not in LEDGE): continue
                comp[b] = cid; q.append(b)
size = collections.Counter(comp.values())
print('components', len(size), size.most_common(8))
bad2 = []
for X in sorted(set(cells.values())):
    try: ev = json.load(open(os.path.join(slots.EVENT_DIR, slots.events_file(X))))
    except Exception: continue
    for w in ev['warps']:
        x, z = w['x'], w['z']
        adj = [(x, z + 1), (x, z - 1), (x + 1, z), (x - 1, z), (x, z)]
        best = max((size[comp[a]] for a in adj if a in comp), default=0)
        if best < 40: bad2.append((X, w['header'], x, z, best))
print('doors with no way to them:', len(bad2)); [print(b) for b in bad2]
