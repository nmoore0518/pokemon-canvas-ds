"""tour.py STATE TAG idx... : for each Pallet warp index, walk (BFS on perm data) to the door, enter, shoot, step out, shoot"""
import sys, os, struct, json
from collections import deque
os.environ.update(SDL_AUDIODRIVER='dummy')
sys.path.insert(0, '/home/claude/pokemon-canvas-ds/tools/canvas'); sys.path.insert(0, '/home/claude/pokemon-canvas-ds/tools/canvas/emu/py-desmume')
from nitro import read_narc
from desmume.emulator import DeSmuME
from desmume.controls import Keys, keymask
from PIL import Image
R = '/home/claude/pokemon-canvas-ds/'
st, tag, *idx = sys.argv[1:]
lands, _ = read_narc(open(R + 'files/a/0/6/5', 'rb').read()) if os.path.isfile(R + 'files/a/0/6/5') else (None, None)
blocked = {}
for (cx, cz), lid in {(0, 0): 676, (1, 0): 677, (2, 0): 678, (0, 1): 679, (1, 1): 680, (2, 1): 681}.items():
    d = lands[lid]; perm = d[0x14 + struct.unpack_from('<H', d, 0x12)[0]:][:0x800] if False else None
    ex = struct.unpack_from('<H', d, 0x12)[0]; perm = d[0x14 + ex:0x14 + ex + 0x800]
    pass
import world
CUR = [None]      # None: the overworld; else the map (with a matrix of its own) we're walking in
P = lambda k: world.perm(*k) if CUR[0] is None else world.perm_in(CUR[0], *k)
class _B(dict):
    def __contains__(self, k): return P(k) is not None
    def __getitem__(self, k):
        v = P(k); b = v & 0xFF
        return 1 if (v & 0x8000) or b in (0x69, 0x65, 0x62, 0x63, 0x64, 0x6C, 0x6D, 0x6E, 0x6F, 0x5E, 0x5F) else 0
blocked = _B()
# people stand in the way, and trainers see along their lines (avoid all four, they may turn)
import glob
avoid, avoid_facing = set(), set()
for f in glob.glob(R + 'files/fielddata/eventdata/zone_event/*.json'):
    for o in json.load(open(f)).get('objects', []):
        if o['x'] < 300: continue                      # (indoor maps use small coordinates)
        avoid.add((o['x'], o['z'])); avoid_facing.add((o['x'], o['z']))
        if o.get('type') == 1:
            dirs = ((0, -1), (0, 1), (-1, 0), (1, 0))
            for i_, (dx, dz) in enumerate(dirs):
                for k in range(1, int(o.get('param0', 0)) + 1):
                    avoid.add((o['x'] + dx * k, o['z'] + dz * k))
                    if i_ == o.get('facingDirection'): avoid_facing.add((o['x'] + dx * k, o['z'] + dz * k))
W = json.load(open(R + 'files/fielddata/eventdata/zone_event/046_T01.json'))['warps']
warp_tiles = {(w['x'], w['z']) for w in W}
emu = DeSmuME(); emu.open(os.environ.get('ROM', R + 'build/canvas.nds')); emu.volume_set(0); emu.savestate.load_file(st)
run = lambda n: [emu.cycle(with_joystick=False) for _ in range(n)]
from findaddr import Tracker
run(5); pos = Tracker(emu)
D = {'R': (1, 0), 'L': (-1, 0), 'U': (0, -1), 'D': (0, 1)}
def step(m, wait=40):
    k = keymask(getattr(Keys, 'KEY_' + {'R': 'RIGHT', 'L': 'LEFT', 'U': 'UP', 'D': 'DOWN'}[m]))
    snap = pos.snapshot(); p0 = pos(); emu.input.keypad_add_key(k); n = 0
    while pos() == p0 and n < wait: run(1); n += 1
    emu.input.keypad_rm_key(k); run(10)
    if pos() == p0: pos.moved_from(snap)
    return pos() != p0
def press(name, n=6, after=60):
    k = keymask(getattr(Keys, 'KEY_' + name)); emu.input.keypad_add_key(k); run(n); emu.input.keypad_rm_key(k); run(after)
def touch(x, y):
    emu.input.touch_set_pos(x, y); run(8); emu.input.touch_release(); run(60)
def flee():
    """a wild battle: run from it"""
    run(400)
    if os.environ.get('DBG'): emu.screenshot().save('flee_%d.png' % len(shots)); print('flee at', pos())
    for _ in range(4): press('B', after=90)
    for _ in range(3):
        touch(128, 178); run(200)
        for _ in range(4): press('B', after=90)
    run(300)
def avoid_for(m):
    """people and trainers' sight lines in a map of its own"""
    import slots
    full, facing = set(), set()
    for o in json.load(open(os.path.join(slots.EVENT_DIR, slots.events_file(m)))).get('objects', []):
        full.add((o['x'], o['z'])); facing.add((o['x'], o['z']))
        if o.get('type') == 1:
            for i_, (dx, dz) in enumerate(((0, -1), (0, 1), (-1, 0), (1, 0))):
                for k in range(1, int(o.get('param0', 0)) + 1):
                    full.add((o['x'] + dx * k, o['z'] + dz * k))
                    if i_ == o.get('facingDirection'): facing.add((o['x'] + dx * k, o['z'] + dz * k))
    return full, facing


def path(a, b):
    sets = (avoid, avoid_facing, set()) if CUR[0] is None else avoid_for(CUR[0]) + (set(),)
    for av in sets:
        r = path1(a, b, av)
        if r is not None: return r


def path1(a, b, avoid):
    q, prev = deque([a]), {a: None}
    while q:
        c = q.popleft()
        if c == b: break
        for m, (dx, dz) in D.items():
            n = (c[0] + dx, c[1] + dz)
            if n in prev or n not in blocked: continue
            if (blocked[n] or n in avoid) and n != b: continue
            if n in warp_tiles and n != b: continue
            prev[n] = (c, m); q.append(n)
    if b not in prev: return None
    out = []; c = b
    while prev[c]: c, m = prev[c]; out.append(m)
    return out[::-1]
shots = []
def shot(label): shots.append((emu.screenshot().crop((0, 0, 256, 192)), label)); print(tag, label, pos())
home = pos()
for i in idx:
    if i.startswith('m'):                 # m<MAP>: from here on we're in that map (its own coordinates)
        CUR[0] = None if i[1:] in ('', 'WORLD') else i[1:]; continue
    if i.startswith('g'):
        tgt = tuple(map(int, i[1:].split(',')))
        p = path(pos(), tgt)
        for attempt in range(4):      # someone in the way: go round them
            p = path(pos(), tgt)
            if os.environ.get('DBG'): print('path', pos(), tgt, ''.join(p or ['NONE']))
            ok = True
            for m in (p or []):
                if not step(m):
                    flee()
                    if not step(m):
                        dx, dz = D[m]; here = pos()
                        avoid.add((here[0] + dx, here[1] + dz)); avoid_facing.add((here[0] + dx, here[1] + dz))
                        if os.environ.get('DBG'): print('stuck', here, m)
                        ok = False
                        break
            if ok: break
        run(60); shot('at%s' % i); continue
    i = int(i)
    w = W[i]; tgt = (w['x'], w['z'])
    p = path(pos(), tgt)
    if p is None: print('no path to', i, tgt); continue
    for m in p[:-1]:
        if not step(m):
            flee()
            if not step(m): print('blocked at', pos(), 'heading', m); break
    k = keymask(getattr(Keys, 'KEY_' + {'R': 'RIGHT', 'L': 'LEFT', 'U': 'UP', 'D': 'DOWN'}[p[-1]]))
    emu.input.keypad_add_key(k); run(30); emu.input.keypad_rm_key(k); run(200)
    shot('in%d_%s' % (i, w['header'][-12:]))
    if os.environ.get('NOEXIT'): continue
    for _ in range(3):
        k = keymask(Keys.KEY_DOWN); emu.input.keypad_add_key(k); run(30); emu.input.keypad_rm_key(k); run(20)
    run(400)
if os.environ.get('OUT'): emu.savestate.save_file(os.environ['OUT'])
cols = 4; rows = (len(shots) + 3) // 4
S = Image.new('RGB', (256 * cols, 192 * rows)); [S.paste(im, ((n % 4) * 256, (n // 4) * 192)) for n, (im, _) in enumerate(shots)]; S.save('tour_%s.png' % tag)
