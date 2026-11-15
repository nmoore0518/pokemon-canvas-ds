"""The overworld as data: which land is at each square of the EVERYWHERE matrix, its collision/behaviour, its
buildings. For planning edits and for walking the test emulator around.

    python3 tools/canvas/world.py X0 Z0 X1 Z1 out.png     (a map of squares, coloured by collision/behaviour)"""
import os, struct, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from nitro import read_narc
import slots

_cache = {}


def matrix():
    if 'm' not in _cache:
        d = open(os.path.join(slots.MATRIX_DIR, 'map_matrix_0000_EVERYWHERE.bin'), 'rb').read()
        w, h, hh, ha, nl = d[:5]
        p = 5 + nl
        hdr = struct.unpack_from('<%dH' % (w * h), d, p); p += 2 * w * h
        alt = d[p:p + w * h]; p += w * h
        lands = struct.unpack_from('<%dH' % (w * h), d, p)
        _cache['m'] = (w, h, hdr, alt, lands)
    return _cache['m']


def lands():
    if 'l' not in _cache:
        _cache['l'] = read_narc(open(os.path.join(slots.ROOT, 'files/a/0/6/5'), 'rb').read())[0]
    return _cache['l']


def land_at(gx, gz):
    w, h, hdr, alt, ls = matrix()
    cx, cz = gx // 32, gz // 32
    if not (0 <= cx < w and 0 <= cz < h): return None
    return ls[cz * w + cx], hdr[cz * w + cx]


def map_matrix(ds_map):
    """(w, h, land ids) of a map's own matrix"""
    key = ('mm', ds_map)
    if key not in _cache:
        d = open(os.path.join(slots.MATRIX_DIR, slots.matrix_file(ds_map)), 'rb').read()
        w, h, hh, ha, nl = d[:5]
        p = 5 + nl + (2 * w * h if hh else 0) + (w * h if ha else 0)
        _cache[key] = (w, h, struct.unpack_from('<%dH' % (w * h), d, p))
    return _cache[key]


def perm_in(ds_map, x, z):
    """perm of a square of a map with a matrix of its own (rooms, caves, forests); None off it"""
    w, h, ls = map_matrix(ds_map)
    cx, cz = x // 32, z // 32
    if not (0 <= x and 0 <= z and cx < w and cz < h) or ls[cz * w + cx] == 0xFFFF: return None
    d = lands()[ls[cz * w + cx]]
    return struct.unpack_from('<H', d, 0x14 + ((z % 32) * 32 + x % 32) * 2)[0]


def perm(gx, gz):
    """-> u16 (bit 15 = blocked, low byte = behaviour) or None off the map"""
    la = land_at(gx, gz)
    if la is None or la[0] == 0xFFFF: return None
    d = lands()[la[0]]
    if len(d) < 0x14 + 0x800: return None
    return struct.unpack_from('<H', d, 0x14 + ((gz % 32) * 32 + gx % 32) * 2)[0]


def buildings(lid):
    d = lands()[lid]
    perm_sz, bld = struct.unpack_from('<2I', d, 0)
    return [struct.unpack_from('<I3i', d, 0x14 + perm_sz + i * 48) for i in range(bld // 48)]


COLOURS = {0x00: (214, 196, 150), 0x02: (90, 170, 80), 0x03: (60, 140, 60), 0x15: (70, 110, 220), 0x10: (70, 110, 220),
           0x69: (230, 40, 40), 0x65: (240, 120, 120)}


def render(x0, z0, x1, z1, out, scale=6):
    from PIL import Image, ImageDraw
    im = Image.new('RGB', ((x1 - x0) * scale, (z1 - z0) * scale), (0, 0, 0))
    d = ImageDraw.Draw(im)
    for gz in range(z0, z1):
        for gx in range(x0, x1):
            v = perm(gx, gz)
            if v is None: continue
            b = v & 0xFF
            c = COLOURS.get(b, (200, 120, 200) if b else (214, 196, 150))
            if v & 0x8000: c = tuple(x // 3 for x in c) if b else (70, 70, 70)
            d.rectangle([(gx - x0) * scale, (gz - z0) * scale, (gx - x0 + 1) * scale - 1, (gz - z0 + 1) * scale - 1], fill=c)
    for gx in range(x0, x1, 8):
        d.text(((gx - x0) * scale + 1, 1), str(gx), fill=(255, 255, 0))
    for gz in range(z0, z1, 8):
        d.text((1, (gz - z0) * scale + 1), str(gz), fill=(0, 255, 255))
    im.save(out)


if __name__ == '__main__':
    a = list(map(int, sys.argv[1:5]))
    render(*a, sys.argv[5])
