"""shots.py LIST OUTDIR : screenshots of many places, one new game each, without a ROM per place.
LIST lines: TAG MAP_ID X Y [frames]. Plays the intro once (st/shots_base.dst, made if missing or older than the
ROM), then for each place loads it, points the new-game location (in RAM) at the place, lets the field load
and saves OUTDIR/TAG.png (both screens) plus OUTDIR/TAG.dst."""
import sys, os, struct, subprocess
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, '..', 'emu', 'py-desmume'))
os.environ['SDL_AUDIODRIVER'] = 'dummy'
from desmume.emulator import DeSmuME
from desmume.controls import Keys, keymask

ROM = os.environ.get('ROM', 'build/canvas.nds')
BASE = 'st/shots_base_%s.dst' % os.path.basename(ROM).replace('.nds', '')
OLD = struct.pack('<5i', 49, -1, 31 * 32 + 27 + 6, 32 * 11 + 49, 1)

# (a game saved in an earlier test makes the title menu start on Continue: set it aside)
DSV = os.path.expanduser('~/.config/desmume/%s.dsv' % os.path.basename(ROM)[:-4])
try:
    os.replace(DSV, DSV + '.old')
except FileNotFoundError:
    pass
if not os.path.exists(BASE) or os.path.getmtime(BASE) < os.path.getmtime(ROM):
    # the intro up to the last touch before the field (newgame.sh's steps)
    os.makedirs('st', exist_ok=True)
    env = dict(os.environ, ROM=ROM)
    run_ = lambda *a: subprocess.run(['python3'] + list(a), env=env, check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    # (made under a name of its own, then moved into place: two runs at once mustn't write one file together)
    tmp = BASE + '.%d' % os.getpid()
    run_(os.path.join(HERE, 'step.py'), '-', tmp, *(['A', 'w100'] * 8), 'START', 'w200')
    os.replace(tmp, BASE)

emu = DeSmuME(); emu.open(ROM); emu.volume_set(0)
run = lambda n: [emu.cycle(with_joystick=False) for _ in range(n)]


def A():
    m = keymask(Keys.KEY_A); emu.input.keypad_add_key(m); run(6); emu.input.keypad_rm_key(m); run(40)


def find_loc():
    mem = bytes(emu.memory.unsigned[0x02000000:0x02400000])
    return [0x02000000 + i for i in range(len(mem) - 20) if mem.startswith(OLD, i)]


hits = []
if os.environ.get('ASSERTS'):      # (report GF_AssertFail calls: where the game gave up)
    last = [0]
    def _entry(a, s):
        r = emu.memory.register_arm9; last[0] = (hex(r.lr), hex(r.r0), hex(r.r1))
    for adr in os.environ['ASSERTS'].split(','):
        if adr != '1': emu.memory.register_exec(int(adr, 16), _entry)
    emu.memory.register_exec(0x0202551C, lambda a, s: hits.append('%s<-%s' % (hex(emu.memory.register_arm9.lr), last[0])))

SAVE_PTR = 0x021D2228            # sSaveDataPtr
MISC_HEADER = 0x2F014 + 9 * 16 + 8   # SaveData.arrayHeaders[SAVE_MISC].offset (hg-engine's bigger save)
CANVAS_FLAGS = 0x6A4             # SAVE_MISC_DATA.canvasFlags (engine/include/save.h)


def set_canvas_flag(n):
    save = emu.memory.unsigned.read_long(SAVE_PTR)
    misc = save + 0x10 + emu.memory.unsigned.read_long(save + MISC_HEADER)
    a = misc + CANVAS_FLAGS + n // 8
    emu.memory.write_byte(a, emu.memory.unsigned.read_byte(a) | (1 << (n % 8)))


lst, out = sys.argv[1], sys.argv[2]
os.makedirs(out, exist_ok=True)
addr = None
for line in open(lst):
    p = line.split()
    if not p or p[0].startswith('#'): continue
    tag, mid, x, y = p[0], int(p[1]), int(p[2]), int(p[3])
    frames = int(p[4]) if len(p) > 4 else 700
    emu.savestate.load_file(BASE)
    if addr is None: addr = find_loc()
    assert addr, 'new-game location not in RAM'
    for a in addr:
        for k, v in enumerate(struct.pack('<5i', mid, -1, x, y, 1)):
            emu.memory.write_byte(a + k, v)
    # (newgame.sh's steps: A through the intro, Yes when asked, the touch, A through the last lines)
    for i in range(250):
        if i == 120: emu.input.touch_set_pos(128, 152); run(6); emu.input.touch_release(); run(100)
        im = emu.screenshot()
        r, g, b = im.getpixel((128, 192 + 51))[:3]
        if r > 180 and g < 90 and b < 90:
            emu.input.touch_set_pos(128, 73); run(6); emu.input.touch_release(); run(40)
        else:
            A()
    run(frames)
    for a in p[5:]:          # (then: step.py's actions, such as hUP:20 to walk through a door)
        if a.startswith('flag:'):    # one of our flags set in the save (the n of flag 0x2000 + n): see set_canvas_flag
            set_canvas_flag(int(a[5:]))
        elif a[0] == 'w': run(int(a[1:]))
        elif a[0] == 'h':
            k, nf = a[1:].split(':'); m = keymask(getattr(Keys, 'KEY_' + k)); emu.input.keypad_add_key(m); run(int(nf)); emu.input.keypad_rm_key(m); run(4)
        else:
            m = keymask(getattr(Keys, 'KEY_' + a)); emu.input.keypad_add_key(m); run(6); emu.input.keypad_rm_key(m); run(40)
    if len(p) > 5: run(240)
    emu.screenshot().save(os.path.join(out, tag + '.png'))
    emu.savestate.save_file(os.path.join(out, tag + '.dst'))
    print(tag, ('asserts ' + ' '.join(hits[:4])) if hits else '', flush=True)
    hits.clear()
