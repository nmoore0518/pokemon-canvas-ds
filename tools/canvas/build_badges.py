"""Canvas: the player's own gym badge, one per type (the GBA game's graphics/gym_badges, src/gym_badge.c).

    python3 tools/canvas/build_badges.py          (then regenerate the engine patch: engine/make_patch.sh)

Writes engine/data/canvas_badges.h: each badge's 32x32 picture as 4bpp tiles (16, row by row) and its palette
(BGR555), by HeartGold's type number. The engine shows it doubled in a framed window when it's awarded
(engine/src/field/canvas_badge.c: CanvasCandidate 20 / 21). The picture's clear pixels become colour 15, white: a
window has no see-through.
"""
import os, sys
from PIL import Image
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import gba_map, slots

HG_TYPES = ['NORMAL', 'FIGHTING', 'FLYING', 'POISON', 'GROUND', 'ROCK', 'BUG', 'GHOST', 'STEEL', 'FAIRY', 'FIRE', 'WATER',
            'GRASS', 'ELECTRIC', 'PSYCHIC', 'ICE', 'DRAGON', 'DARK']
BACK = 15


def badge(t):
    im = Image.open(gba_map.P('graphics/gym_badges/%s.png' % t.lower()))
    assert im.mode == 'P' and im.size == (32, 32)
    px = [BACK if v == 0 else v for v in im.get_flattened_data()] if hasattr(im, 'get_flattened_data') else \
         [BACK if v == 0 else v for v in im.getdata()]
    assert max(v for v in px if v != BACK) < BACK
    tiles = []
    for ty in range(4):
        for tx in range(4):
            for y in range(8):
                for x in range(0, 8, 2):
                    a, b = px[(ty * 8 + y) * 32 + tx * 8 + x], px[(ty * 8 + y) * 32 + tx * 8 + x + 1]
                    tiles.append(a | (b << 4))
    pal = im.getpalette()[:48] + [0] * 48
    cols = [(pal[i * 3] >> 3) | ((pal[i * 3 + 1] >> 3) << 5) | ((pal[i * 3 + 2] >> 3) << 10) for i in range(16)]
    cols[BACK] = 0x7FFF
    return tiles, cols


def main():
    out = ['// Pokemon Canvas: the player\'s gym badges (tools/canvas/build_badges.py; do not edit)', '',
           'static const u8 sCanvasBadgeTiles[18][16 * 32] = {']
    pals = ['static const u16 sCanvasBadgePals[18][16] = {']
    for t in HG_TYPES:
        tiles, cols = badge(t)
        out.append('    {' + ', '.join('0x%02X' % b for b in tiles) + '},   // ' + t)
        pals.append('    {' + ', '.join('0x%04X' % c for c in cols) + '},   // ' + t)
    out += ['};', ''] + pals + ['};', '']
    open(os.path.join(slots.ROOT, 'engine/data/canvas_badges.h'), 'w').write('\n'.join(out))
    print('18 badges')


if __name__ == '__main__':
    main()
