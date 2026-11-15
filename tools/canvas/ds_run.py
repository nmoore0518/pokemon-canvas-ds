"""Boot a DS ROM headless in DeSmuME and save screenshots (both screens stacked, 256x384).
usage: ds_run.py ROM OUT_PREFIX [script]   script: comma list of  wait:N | A | B | START | SELECT | UP.. | X | Y | L | R | touch:X:Y | shot:TAG
default script boots to the first new-game screen."""
import os, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, 'emu', 'py-desmume'))
os.environ.setdefault('SDL_AUDIODRIVER', 'dummy')
from desmume.emulator import DeSmuME
from desmume.controls import Keys, keymask

DEFAULT = 'wait:600,shot:intro,A,wait:120,A,wait:120,A,wait:120,A,wait:120,A,wait:120,A,wait:120,shot:title,START,wait:300,shot:start'

def main(rom, out, script=DEFAULT):
    emu = DeSmuME(); emu.open(rom); emu.volume_set(0)
    run = lambda n: [emu.cycle(with_joystick=False) for _ in range(n)]
    n = 0
    os.makedirs(os.path.dirname(out) or '.', exist_ok=True)
    for step in script.split(','):
        op, *a = step.split(':')
        if op == 'wait': run(int(a[0]))
        elif op == 'shot': emu.screenshot().save(f'{out}_{n}_{a[0]}.png'); n += 1
        elif op == 'touch':
            emu.input.touch_set_pos(int(a[0]), int(a[1])); run(6); emu.input.touch_release(); run(30)
        else:
            k = keymask(getattr(Keys, 'KEY_' + op)); emu.input.keypad_add_key(k); run(6); emu.input.keypad_rm_key(k); run(30)

if __name__ == '__main__':
    main(*sys.argv[1:])
