"""GBA art as HeartGold textures: for the things a GBA map has that HeartGold has no model for (our own machines,
papers on the floor...). A picture becomes a 256-colour texture (colour 0 see-through) to put on a card."""
import struct
from PIL import Image


def pow2(n):
    p = 8
    while p < n: p *= 2
    return p


def texture(name, im, colours=255):
    """RGBA image -> (texture entry, palette entry, (texture w, h)) for nitro.write_btx0.
    Up to 15 colours makes a 16-colour texture (32-byte palette); more, a 256-colour one (512 bytes):
    palette memory is the scarcer, so small pictures should ask for 15."""
    im = im.convert('RGBA')
    w, h = pow2(im.width), pow2(im.height)
    assert w <= 1024 and h <= 1024 and len(name) <= 15, (name, w, h)
    rgb = Image.new('RGB', im.size)
    rgb.paste(im.convert('RGB'))
    q = rgb.quantize(colours, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
    qp = q.getpalette()[:colours * 3]
    a = im.getchannel('A').load()
    qq = q.load()
    small = colours <= 15
    idx = bytearray(w * h)
    for y in range(im.height):
        for x in range(im.width):
            if a[x, y] >= 128:
                idx[y * w + x] = qq[x, y] + 1
    cols = [(0, 0, 0)] + [tuple(qp[i:i + 3]) for i in range(0, len(qp), 3)]
    cols += [(0, 0, 0)] * ((16 if small else 256) - len(cols))
    pal = b''.join(struct.pack('<H', (r >> 3) | ((g >> 3) << 5) | ((b >> 3) << 10)) for r, g, b in cols)
    if small:
        idx = bytes(idx[i] | (idx[i + 1] << 4) for i in range(0, len(idx), 2))
    sw, sh = w.bit_length() - 4, h.bit_length() - 4
    prm = (sw << 20) | (sh << 23) | ((3 if small else 4) << 26) | (1 << 29)
    return (name.encode(), prm, w | (h << 11) | 0x80000000, bytes(idx), b''), ((name + '_pl').encode(), 0, pal), (w, h)


def cut_out(im, background, at=(0, 0)):
    """Make see-through every pixel of `im` (cut from a GBA map at pixel `at`) that matches the tiling `background`"""
    im = im.convert('RGBA').copy()
    bg = background.convert('RGBA')
    p, b = im.load(), bg.load()
    for y in range(im.height):
        for x in range(im.width):
            if p[x, y][:3] == b[(x + at[0]) % bg.width, (y + at[1]) % bg.height][:3]:
                p[x, y] = (0, 0, 0, 0)
    return im


def shadow_texture(name):
    """A soft dark blot (A3I5: one black colour, 8 levels of see-through) for under things standing on the floor"""
    w, h = 32, 16
    data = bytearray()
    for y in range(h):
        for x in range(w):
            # distance outside an inner rectangle, as a fraction of the soft edge
            dx = max(0.0, abs(x + 0.5 - w / 2) - (w / 2 - 5)) / 5
            dy = max(0.0, abs(y + 0.5 - h / 2) - (h / 2 - 5)) / 5
            d = min(1.0, (dx * dx + dy * dy) ** 0.5)
            data.append(int(round((1 - d) * 4)) << 5)      # at most half dark
    pal = b'\0' * 64
    prm = (2 << 20) | (1 << 23) | (1 << 26)
    return (name.encode(), prm, w | (h << 11) | 0x80000000, bytes(data), b''), ((name + '_pl').encode(), 0, pal), (w, h)
