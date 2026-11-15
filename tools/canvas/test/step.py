"""step.py IN_STATE OUT_STATE actions...   actions: A B START UP DOWN LEFT RIGHT X Y SELECT, wN (frames), t:x:y (touch bottom screen), s:tag (shot), hK:N (hold key N frames)"""
import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'emu', 'py-desmume'))
os.environ['SDL_AUDIODRIVER'] = 'dummy'
from desmume.emulator import DeSmuME
from desmume.controls import Keys, keymask
emu = DeSmuME(); emu.open(os.environ.get('ROM', 'build/canvas.nds')); emu.volume_set(0)
run = lambda n: [emu.cycle(with_joystick=False) for _ in range(n)]
src, dst, *acts = sys.argv[1:]
if src != '-': emu.savestate.load_file(src)
else: run(600)
for a in acts:
    if a[0] == 'w' and a[1:].isdigit(): run(int(a[1:]))
    elif a.startswith('t:'): _, x, y = a.split(':'); emu.input.touch_set_pos(int(x), int(y)); run(6); emu.input.touch_release(); run(40)
    elif a.startswith('s:'): emu.screenshot().save(f'st/{a[2:]}.png')
    elif a.startswith('h'):
        k, nf = a[1:].split(':'); m = keymask(getattr(Keys, 'KEY_' + k)); emu.input.keypad_add_key(m); run(int(nf)); emu.input.keypad_rm_key(m); run(4)
    else:
        m = keymask(getattr(Keys, 'KEY_' + a)); emu.input.keypad_add_key(m); run(6); emu.input.keypad_rm_key(m); run(40)
if dst != '-': emu.savestate.save_file(dst)
