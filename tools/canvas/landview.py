"""Render land models to a PNG, looking down as HeartGold's field camera does (for checking map geometry without
the game): landview.py OUT.png LAND_ID[,LAND_ID...] [--grid WxH] [--tex TEXSET] [--center X,Z] [--span BLOCKS]
Lands in a grid are laid out left to right, top to bottom (as a map's matrix). Textures come from the texture set
(default: the area's set for the lands' map, or --tex)."""
import argparse, math, os, struct, sys
import numpy as np
from PIL import Image
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import world, bmdview
from nitro import read_narc
from texview import textures, decode


def tris(land, ox, oz):
    ps, bs, ms, hs = struct.unpack_from('<4I', land, 0)
    sc, shapes = bmdview.model(land[0x14 + ps + bs:0x14 + ps + bs + ms])
    out = []
    for mat, tex, prims in shapes:
        for prim, vs in prims:
            P = [(v[0] * sc + ox, v[1] * sc, v[2] * sc + oz, v[3], v[4]) for v in vs]
            if prim == 0:
                out += [(tex, P[i:i + 3]) for i in range(0, len(P) - 2, 3)]
            elif prim == 1:
                for i in range(0, len(P) - 3, 4):
                    q = P[i:i + 4]; out += [(tex, [q[0], q[1], q[2]]), (tex, [q[0], q[2], q[3]])]
            elif prim == 2:
                out += [(tex, [P[i], P[i + 1], P[i + 2]] if i % 2 == 0 else [P[i + 1], P[i], P[i + 2]]) for i in range(len(P) - 2)]
            elif prim == 3:
                for i in range(0, len(P) - 3, 2):
                    out += [(tex, [P[i], P[i + 1], P[i + 3]]), (tex, [P[i], P[i + 3], P[i + 2]])]
    return out


def render(T, texs, center, span, W=512, pitch=40):
    H = int(W * 0.75)
    cx, cz = center
    a = math.radians(pitch)
    img = np.zeros((H, W, 3), np.uint8); zb = np.full((H, W), 1e9)
    scale = W / (span * 16)
    for tex, tri in T:
        im = texs.get(tex)
        pts = []
        for x, y, z, s, t in tri:
            X = (x - cx) * scale + W / 2
            # look down from the south: screen y from z (towards the camera) and height
            Y = ((z - cz) * math.cos(a) - y * math.sin(a)) * scale + H / 2
            D = -(z - cz) * math.sin(a) - y * math.cos(a)
            pts.append((X, Y, D, s, t))
        xs = [p[0] for p in pts]; ys = [p[1] for p in pts]
        x0, x1 = max(0, int(min(xs))), min(W - 1, int(max(xs)) + 1)
        y0, y1 = max(0, int(min(ys))), min(H - 1, int(max(ys)) + 1)
        if x0 > x1 or y0 > y1: continue
        (ax, ay, ad, as_, at), (bx, by, bd, bs, bt), (qx, qy, qd, qs, qt) = pts
        den = (by - qy) * (ax - qx) + (qx - bx) * (ay - qy)
        if abs(den) < 1e-9: continue
        gx, gy = np.meshgrid(np.arange(x0, x1 + 1) + 0.5, np.arange(y0, y1 + 1) + 0.5)
        l1 = ((by - qy) * (gx - qx) + (qx - bx) * (gy - qy)) / den
        l2 = ((qy - ay) * (gx - qx) + (ax - qx) * (gy - qy)) / den
        l3 = 1 - l1 - l2
        m = (l1 >= 0) & (l2 >= 0) & (l3 >= 0)
        if not m.any(): continue
        d = l1 * ad + l2 * bd + l3 * qd
        zs = zb[y0:y1 + 1, x0:x1 + 1]
        m &= d < zs
        if im is None:
            col = np.array([255, 0, 255])
            c = np.broadcast_to(col, m.shape + (3,))
            alpha = m
        else:
            tw, th = im.shape[1], im.shape[0]
            s = (l1 * as_ + l2 * bs + l3 * qs) % tw
            t = (l1 * at + l2 * bt + l3 * qt) % th
            c4 = im[t.astype(int) % th, s.astype(int) % tw]
            c = c4[..., :3]; alpha = m & (c4[..., 3] > 128)
        sub = img[y0:y1 + 1, x0:x1 + 1]
        sub[alpha] = c[alpha]
        zs[alpha] = d[alpha]
    return Image.fromarray(img)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('out'); ap.add_argument('lands')
    ap.add_argument('--grid', default='1x1'); ap.add_argument('--tex', type=int, required=True)
    ap.add_argument('--center', default=None); ap.add_argument('--span', type=float, default=24)
    ap.add_argument('--pitch', type=float, default=40)
    a = ap.parse_args()
    ids = [int(v) for v in a.lands.split(',')]
    gw, gh = map(int, a.grid.split('x'))
    L = world.lands()
    T = []
    for k, lid in enumerate(ids):
        T += tris(L[lid], (k % gw) * 512, (k // gw) * 512)
    ts, _ = read_narc(open(os.path.join(world.slots.ROOT if hasattr(world, 'slots') else os.path.join(HERE, '..', '..'), 'files/a/0/4/4'), 'rb').read())
    texs = {}
    for n, (prm, data, comp, pal) in textures(ts[a.tex]).items():
        try: texs[n] = np.array(decode(prm, data, comp, pal).convert('RGBA'))
        except Exception: pass
    center = tuple(map(float, a.center.split(','))) if a.center else (gw * 256 - 256, gh * 256 - 256)
    render(T, texs, ((center[0]) * 1.0, center[1]), a.span, pitch=a.pitch).save(a.out)


if __name__ == '__main__':
    main()
