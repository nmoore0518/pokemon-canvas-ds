"""walk.py STATE OUT TAG moves...   move: R6 U12 L3 D2 (tiles, stops early if blocked), s (shot), A/B/X (press), wN"""
import sys, os, struct
os.environ.update(SDL_AUDIODRIVER='dummy')
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'emu', 'py-desmume'))
from desmume.emulator import DeSmuME
from desmume.controls import Keys, keymask
from PIL import Image
st, out, tag, *moves = sys.argv[1:]
emu = DeSmuME(); emu.open(os.environ.get('ROM', 'build/canvas.nds')); emu.volume_set(0)
emu.savestate.load_file(st)
run = lambda n: [emu.cycle(with_joystick=False) for _ in range(n)]
POS = int(os.environ.get('POSADDR', '0x022ae08c'), 16)
pos = lambda: (struct.unpack('<i', bytes(emu.memory.unsigned[POS:POS + 4]))[0], struct.unpack('<i', bytes(emu.memory.unsigned[POS + 8:POS + 12]))[0])
shots = []
for m in moves:
    if m == 's':
        im = emu.screenshot().crop((0, 0, 256, 192)); shots.append(im); print(tag, len(shots) - 1, 'at', pos()[0] - 1019, pos()[1] - 352)
    elif m[0] in 'RULD' and m[1:].isdigit():
        d = {'R': 'RIGHT', 'U': 'UP', 'L': 'LEFT', 'D': 'DOWN'}[m[0]]
        dx, dz = {'R': (1, 0), 'L': (-1, 0), 'U': (0, -1), 'D': (0, 1)}[m[0]]
        k = keymask(getattr(Keys, 'KEY_' + d))
        for _ in range(int(m[1:])):
            p0 = pos(); emu.input.keypad_add_key(k); n = 0
            while pos() == p0 and n < 40: run(1); n += 1
            emu.input.keypad_rm_key(k)
            if pos() == p0: break                      # blocked
            run(10)
        run(10)
    elif m[0] == 'w': run(int(m[1:]))
    else:
        k = keymask(getattr(Keys, 'KEY_' + m)); emu.input.keypad_add_key(k); run(6); emu.input.keypad_rm_key(k); run(40)
if out != '-': emu.savestate.save_file(out)
cols = min(4, len(shots)); rows = (len(shots) + cols - 1) // cols
S = Image.new('RGB', (256 * cols, 192 * rows)); [S.paste(im, ((i % cols) * 256, (i // cols) * 192)) for i, im in enumerate(shots)]; S.save(f'st_{tag}.png')
