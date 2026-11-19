"""furniture_atlas.py OUT.png: every distinct thing the GBA draws in the rooms we build (a run of squares that are
neither the room's floor nor its plain wall), with its tileset and top-left metatile - for matching them to
HeartGold's room models (furnish.py)."""
import sys, io, contextlib, collections, json
sys.path.insert(0, 'port')
import gba_map
from PIL import Image, ImageDraw
with contextlib.redirect_stdout(io.StringIO()):
    import build_rooms as BR, build_interiors as BI


def rooms():
    out = [r['gba'] for r in BR.ROOMS if not r.get('gba_look')] + [c['gba'] for c in BI.INTERIORS if c['look'] not in ('safari',)]
    return list(dict.fromkeys(out))


def objects(g):
    gm = gba_map.map_json(g); lay = gba_map.Layout(gm['layout'], raw=True)
    L = gba_map.layouts()[gm['layout']]
    W, H = lay.w, lay.h
    cnt = collections.Counter(lay.metatile(x, y) for y in range(H) for x in range(W))
    # background: the commonest metatiles, walkable (floor) or blocked (wall, black)
    tot = W * H
    bg = {m for m, n in cnt.items() if n >= max(6, tot * 0.03)}
    seen, out = set(), []
    for y in range(H):
        for x in range(W):
            if (x, y) in seen or lay.metatile(x, y) in bg: continue
            comp, st = [], [(x, y)]; seen.add((x, y))
            while st:
                c = st.pop(); comp.append(c)
                for d in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                    n = (c[0] + d[0], c[1] + d[1])
                    if 0 <= n[0] < W and 0 <= n[1] < H and n not in seen and lay.metatile(*n) not in bg:
                        seen.add(n); st.append(n)
            xs = [c[0] for c in comp]; ys = [c[1] for c in comp]
            x0, y0, x1, y1 = min(xs), min(ys), max(xs), max(ys)
            if (x1 - x0 + 1) * (y1 - y0 + 1) > 40: continue
            grid = tuple(tuple(lay.metatile(a, b) if (a, b) in comp else -1 for a in range(x0, x1 + 1)) for b in range(y0, y1 + 1))
            out.append(dict(map=g, ts=L['secondary_tileset'], at=(x0, y0), grid=grid, lay=lay,
                            blocked=sum(lay.collision(*c) != 0 for c in comp), n=len(comp)))
    return out


if __name__ == '__main__':
    uniq = {}
    for g in rooms():
        for o in objects(g):
            k = (o['ts'], o['grid'])
            if k not in uniq: uniq[k] = dict(o, maps=set())
            uniq[k]['maps'].add(g)
    items = sorted(uniq.values(), key=lambda o: (o['ts'], o['grid'][0][0]))
    print(len(items))
    # sheet: per item its picture (x2) and label
    cells = []
    for i, o in enumerate(items):
        h = len(o['grid']); w = len(o['grid'][0])
        im = Image.new('RGBA', (w * 16, h * 16), (40, 0, 40, 255))
        for b in range(h):
            for a in range(w):
                if o['grid'][b][a] >= 0: im.alpha_composite(o['lay'].render_metatile(o['grid'][b][a]), (a * 16, b * 16))
        cells.append((i, o, im.resize((w * 32, h * 32), Image.NEAREST)))
    W = 1600; x = y = rowh = 0; pos = []
    for i, o, im in cells:
        cw = max(im.width, 120) + 6
        if x + cw > W: x = 0; y += rowh + 18; rowh = 0
        pos.append((x, y)); x += cw; rowh = max(rowh, im.height)
    sheet = Image.new('RGB', (W, y + rowh + 20), (0, 0, 0)); d = ImageDraw.Draw(sheet)
    for (i, o, im), (px, py) in zip(cells, pos):
        sheet.paste(im, (px, py + 14)); d.text((px, py), '%d %s %x' % (i, o['ts'][9:15], o['grid'][0][[c >= 0 for c in o['grid'][0]].index(True)]), fill=(255, 255, 0))
    sheet.save(sys.argv[1])
    json.dump([dict(i=i, ts=o['ts'], grid=o['grid'], maps=sorted(o['maps']), blocked=o['blocked'], n=o['n']) for i, o in enumerate(items)],
              open(sys.argv[1] + '.json', 'w'))
