"""GBA towns laid out anew inside their own maps (Nick: Saffron "doesn't look like the same layout from the GBA
version ... the whole map might need to be expanded"): lines of squares taken out where the map has room to spare
(the woods round the town, the paths between its fence and its gatehouses) and as many put in inside the town (its
streets), so the map stays the size the routes round it meet, and its gatehouses stay where they are.

    RESHAPE[layout] = dict(cut_cols=[x...], cols=[x...], cut_rows=[y...], rows=[y...], replace_rows={y: fn})
      cols / rows: a new line before each GBA line named (twice named, two lines); its squares are the GBA line's
      own, but plain ground wherever it would cut through a building, a fence or a thing on one side of it only (so a
      block of buildings or a fence carries on across it, and nothing is doubled)
      replace_rows: a GBA row drawn anew, block by block (fn(x, blocks) -> block)

gba_map.Layout draws the layout reshaped and gba_map.map_json moves the map's events with it (`xy`), so everything
reads the town as if the GBA had it so; the porter moves the squares a script names itself the same way."""

SAFFRON = 'LAYOUT_SAFFRON_CITY'


def _saffron_walk(x, B):
    """Saffron's row 45 (the path from the town down to its south gatehouse) made a street along the front of the
    bottom row of houses (Nick: a walkway in front of them; they stay without doors): paving from fence to fence,
    joining the gatehouse's path; the woods either side as they were"""
    if 14 <= x <= 53: return B[41][20]          # (the town's paving: a street square of its own)
    return B[45][x]


def _saffron_walk2(y, gate):
    """Saffron's rows 46 and 47: the street three squares wide (HeartGold's trees lean a square and more over the
    rows in front of them, seen from the player's camera); the south gatehouse (its path, its walls) as it was"""
    return lambda x, B: B[41][20] if 14 <= x <= 54 and not gate[0] <= x <= gate[1] else B[y][x]


def _saffron_fence(x, B):
    """Saffron's row 48 (the woods south of that street): the town's fence, the trees behind it, so they stand back
    from the street and don't hide it; the south gatehouse as it was"""
    if 14 <= x <= 54 and not 32 <= x <= 37: return B[43][16]    # (the town's fence, as along its west side's foot)
    return B[48][x]


RESHAPE = {
    SAFFRON: dict(cut_cols=[9, 10, 11, 12, 55, 56, 57], cols=[16, 22, 28, 28, 39, 39, 52],
                  cut_rows=[6, 7], rows=[16, 16], replace_rows={45: _saffron_walk, 46: _saffron_walk2(46, (33, 36)),
                                                47: _saffron_walk2(47, (32, 37)), 48: _saffron_fence}),
}


def _maps(spec, w, h):
    """-> (new column of each old one, new row of each old one), each a list (a cut line maps to the line after it)"""
    out = []
    for n, cut, ins in ((w, spec.get('cut_cols', ()), spec.get('cols', ())), (h, spec.get('cut_rows', ()), spec.get('rows', ()))):
        m, k = [], 0
        for i in range(n):
            k += ins.count(i)
            m.append(k)
            if i not in cut: k += 1
        out.append(m)
    return out


def xy(layout_id, x, y, w, h):
    """a GBA square of a reshaped layout -> its square now (a square outside the map: as it is)"""
    spec = RESHAPE.get(layout_id)
    if not spec or not (0 <= x < w and 0 <= y < h): return x, y
    mx, my = _maps(spec, w, h)
    return mx[x], my[y]


def blocks(layout_id, B):
    """the layout's blocks reshaped (the same size as before)"""
    spec = RESHAPE.get(layout_id)
    if not spec: return B
    h, w = len(B), len(B[0])
    B = [row[:] for row in B]
    for y, fn in spec.get('replace_rows', {}).items():
        B[y] = [fn(x, B) for x in range(w)]
    closed = lambda b: (b >> 10) & 3
    thing = lambda b: closed(b)

    def pick(a, b, plain):
        if thing(a) and thing(b): return b              # (inside a block or a fence: it carries on)
        if not thing(b): return b
        if not thing(a): return a
        return plain
    cut_c, cut_r = set(spec.get('cut_cols', ())), set(spec.get('cut_rows', ()))
    # columns
    rows = []
    for y in range(h):
        row = []
        for x in range(w):
            for _ in range(spec.get('cols', []).count(x)):
                row.append(pick(B[y][x - 1], B[y][x], B[y][x - 1]))
            if x not in cut_c: row.append(B[y][x])
        rows.append(row)
    # rows
    out = []
    for y in range(h):
        for _ in range(spec.get('rows', []).count(y)):
            out.append([pick(rows[y - 1][x], rows[y][x], rows[y - 1][x]) for x in range(len(rows[y]))])
        if y not in cut_r: out.append(rows[y])
    assert len(out) == h and all(len(r) == w for r in out), ('a reshape must keep the map its size', layout_id)
    return out


def events(mj, w, h):
    """a map.json's events moved with its reshaped layout"""
    spec = RESHAPE.get(mj.get('layout'))
    if not spec: return mj
    for k in ('warp_events', 'bg_events', 'object_events', 'coord_events'):
        for e in mj.get(k, []):
            e['x'], e['y'] = xy(mj['layout'], e['x'], e['y'], w, h)
    return mj
