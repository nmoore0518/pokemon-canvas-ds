"""Decode a TEX0 texture to an image (for looking at HeartGold's textures): texview.py NARC INDEX OUTDIR [names...]"""
import os, struct, sys
from PIL import Image
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
from nitro import read_narc, read_tex0, tex0_of


def rgb(c):
    return ((c & 31) * 255 // 31, ((c >> 5) & 31) * 255 // 31, ((c >> 10) & 31) * 255 // 31)


def decode(prm, data, comp, pal):
    w, h, fmt = 8 << ((prm >> 20) & 7), 8 << ((prm >> 23) & 7), (prm >> 26) & 7
    c0 = (prm >> 29) & 1
    P = [rgb(struct.unpack_from('<H', pal, i)[0]) for i in range(0, len(pal) - 1, 2)] or [(255, 0, 255)]
    im = Image.new('RGBA', (w, h))
    px = im.load()
    def pc(i): return P[i] if i < len(P) else (255, 0, 255)
    if fmt in (2, 3, 4):
        bpp = {2: 2, 3: 4, 4: 8}[fmt]
        for i in range(w * h):
            b = i * bpp
            v = (data[b // 8] >> (b % 8)) & ((1 << bpp) - 1)
            px[i % w, i // w] = pc(v) + ((0 if c0 and v == 0 else 255),)
    elif fmt in (1, 6):
        for i in range(w * h):
            v = data[i]
            if fmt == 1: idx, a = v & 31, (v >> 5) * 255 // 7
            else: idx, a = v & 7, (v >> 3) * 255 // 31
            px[i % w, i // w] = pc(idx) + (a,)
    elif fmt == 7:
        for i in range(w * h):
            c = struct.unpack_from('<H', data, i * 2)[0]
            px[i % w, i // w] = rgb(c) + (255 if c & 0x8000 else 0,)
    elif fmt == 5:
        bw = w // 4
        for bi in range(len(data) // 4):
            bx, by = bi % bw, bi // bw
            bits = struct.unpack_from('<I', data, bi * 4)[0]
            inf = struct.unpack_from('<H', comp, bi * 2)[0]
            po, mode = (inf & 0x3FFF) * 2, inf >> 14
            c = [pc(po + k) for k in range(4)]
            cols = [c[0] + (255,), c[1] + (255,)]
            if mode == 0: cols += [c[2] + (255,), (0, 0, 0, 0)]
            elif mode == 1: cols += [tuple((a + b) // 2 for a, b in zip(c[0], c[1])) + (255,), (0, 0, 0, 0)]
            elif mode == 2: cols += [c[2] + (255,), c[3] + (255,)]
            else: cols += [tuple((5 * a + 3 * b) // 8 for a, b in zip(c[0], c[1])) + (255,), tuple((3 * a + 5 * b) // 8 for a, b in zip(c[0], c[1])) + (255,)]
            for k in range(16):
                px[bx * 4 + k % 4, by * 4 + k // 4] = cols[(bits >> (2 * k)) & 3]
    return im


def textures(blob):
    texs, pals = read_tex0(blob, tex0_of(blob))
    pd = {n.decode(): d for n, _, d in pals}
    out = {}
    for nm, prm, extra, data, comp in texs:
        n = nm.decode()
        pal = pd.get(n + '_pl') or pd.get(n) or next(iter(pd.values()), b'')
        # (4x4 compressed textures index the palette block from its start)
        if (prm >> 26) & 7 == 5:
            t0 = tex0_of(blob)
            pal = pals and blob  # placeholder
            texs2, pals2 = texs, pals
        out[n] = (prm, data, comp, pd.get(n + '_pl') or pd.get(n) or b'')
    return out


if __name__ == '__main__':
    narc, idx, outdir = sys.argv[1:4]
    blob = read_narc(open(narc, 'rb').read())[0][int(idx)]
    os.makedirs(outdir, exist_ok=True)
    for n, (prm, data, comp, pal) in textures(blob).items():
        if len(sys.argv) > 4 and n not in sys.argv[4:]: continue
        try:
            decode(prm, data, comp, pal).save(os.path.join(outdir, n + '.png'))
        except Exception as e:
            print(n, 'failed', e)
