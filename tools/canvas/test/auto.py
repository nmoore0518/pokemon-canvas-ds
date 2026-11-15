"""Advance the intro: press A, touch Yes when a Yes/No box is up; screenshot every K steps."""
import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'emu', 'py-desmume'))
os.environ['SDL_AUDIODRIVER'] = 'dummy'
from desmume.emulator import DeSmuME
from desmume.controls import Keys, keymask
emu = DeSmuME(); emu.open(os.environ.get('ROM', 'build/canvas.nds')); emu.volume_set(0)
run = lambda n: [emu.cycle(with_joystick=False) for _ in range(n)]
src, dst, steps, every, tag = sys.argv[1], sys.argv[2], int(sys.argv[3]), int(sys.argv[4]), sys.argv[5]
emu.savestate.load_file(src)
def A():
    m = keymask(Keys.KEY_A); emu.input.keypad_add_key(m); run(6); emu.input.keypad_rm_key(m); run(40)
for i in range(steps):
    im = emu.screenshot()
    r, g, b = im.getpixel((128, 192 + 51))[:3]
    if r > 180 and g < 90 and b < 90:      # the red-bordered Yes button
        emu.input.touch_set_pos(128, 73); run(6); emu.input.touch_release(); run(40)
    else:
        A()
    if i % every == every - 1: emu.screenshot().save(f'st/{tag}_{i:03d}.png')
emu.savestate.save_file(dst)
