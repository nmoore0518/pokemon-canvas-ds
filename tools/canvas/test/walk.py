"""walk.py STATE OUT TAG moves...   move: R6 U12 L3 D2 (tiles, stops early if blocked), s (shot), A/B/X (press), wN"""
import sys, os, struct
os.environ.update(SDL_AUDIODRIVER='dummy')
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'emu', 'py-desmume'))
from desmume.emulator import DeSmuME
from desmume.controls import Keys, keymask
from PIL import Image
st, out, tag, *moves = sys.argv[1:]
emu = DeSmuME(); emu.open(os.environ.get('ROM', 'build/heartgold.us/pokeheartgold.us.nds')); emu.volume_set(0)
emu.savestate.load_file(st)
run = lambda n: [emu.cycle(with_joystick=False) for _ in range(n)]
POS = 0x022a208c
pos = lambda: (struct.unpack('<i', bytes(emu.memory.unsigned[POS:POS + 4]))[0], struct.unpack('<i', bytes(emu.memory.unsigned[POS + 8:POS + 12]))[0])
shots = []
for m in moves:
    if m == 's':
        im = emu.screenshot().crop((0, 0, 256, 192)); shots.append(im); print(tag, len(shots) - 1, 'at', pos()[0] - 1024, pos()[1] - 352)
    elif m[0] in 'RULD' and m[1:].isdigit():
        d = {'R': 'RIGHT', 'U': 'UP', 'L': 'LEFT', 'D': 'DOWN'}[m[0]]
        dx, dz = {'R': (1, 0), 'L': (-1, 0), 'U': (0, -1), 'D': (0, 1)}[m[0]]
        x0, z0 = pos(); tx, tz = x0 + dx * int(m[1:]), z0 + dz * int(m[1:])
        k = keymask(getattr(Keys, 'KEY_' + d)); emu.input.keypad_add_key(k)
        last, still = pos(), 0
        while pos() != (tx, tz) and still < 60:
            run(2); p = pos(); still = still + 2 if p == last else 0; last = p
        emu.input.keypad_rm_key(k); run(20)
    elif m[0] == 'w': run(int(m[1:]))
    else:
        k = keymask(getattr(Keys, 'KEY_' + m)); emu.input.keypad_add_key(k); run(6); emu.input.keypad_rm_key(k); run(40)
if out != '-': emu.savestate.save_file(out)
cols = min(4, len(shots)); rows = (len(shots) + cols - 1) // cols
S = Image.new('RGB', (256 * cols, 192 * rows)); [S.paste(im, ((i % cols) * 256, (i // cols) * 192)) for i, im in enumerate(shots)]; S.save(f'st_{tag}.png')
