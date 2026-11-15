"""mv.py STATE OUT TAG moves: U5 R3 (held for 16 frames a square, no feedback), s = shot, wN"""
import sys, os
os.environ.update(SDL_AUDIODRIVER='dummy')
sys.path.insert(0, '/home/claude/pokemon-canvas-ds/tools/canvas/emu/py-desmume')
from desmume.emulator import DeSmuME
from desmume.controls import Keys, keymask
from PIL import Image
st, out, tag, *moves = sys.argv[1:]
emu = DeSmuME(); emu.open(os.environ['ROM']); emu.volume_set(0); emu.savestate.load_file(st)
run = lambda n: [emu.cycle(with_joystick=False) for _ in range(n)]
shots = []
for m in moves:
    if m == 's': shots.append(emu.screenshot().crop((0, 0, 256, 192)))
    elif m[0] == 'w': run(int(m[1:]))
    elif m[0] in 'RULD':
        k = keymask(getattr(Keys, 'KEY_' + {'R': 'RIGHT', 'U': 'UP', 'L': 'LEFT', 'D': 'DOWN'}[m[0]]))
        emu.input.keypad_add_key(k); run(16 * int(m[1:]) + 2); emu.input.keypad_rm_key(k); run(12)
if out != '-': emu.savestate.save_file(out)
cols = min(4, len(shots)); rows = (len(shots) + cols - 1) // cols
S = Image.new('RGB', (256 * cols, 192 * rows)); [S.paste(im, ((i % cols) * 256, (i // cols) * 192)) for i, im in enumerate(shots)]; S.save('mv_%s.png' % tag)
