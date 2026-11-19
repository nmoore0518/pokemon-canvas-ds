"""The interior tile kit: pieces of HeartGold's own interiors, cut out of its lands a square at a time, to lay our
big interiors with (build_interiors.py, looks with a `kit`).

A piece is every polygon of a HeartGold land that falls in a box of squares, clipped to the box (Sutherland-Hodgman
on each side, texture coordinates carried along), with its material's settings (repeat, flip, alpha). Laid at
another square it keeps its texture coordinates, so a piece is cut where the texture's pattern lines up with the
square it is laid on: a piece set has a period (pick() takes the source square with the same remainder).
"""
import os, math, struct, functools
import bmdview, slots
from nitro import read_narc, read_dict, u16, u32

LAND_NARC = os.path.join(slots.ROOT, 'files/a/0/6/5')


@functools.lru_cache(None)
def _lands():
    return read_narc(open(LAND_NARC, 'rb').read())[0]


def _materials(blob):
    """material name -> (repeat, flip, alpha) of a land's model"""
    mdl0 = u32(blob, 0x10)
    (name, e), = read_dict(blob, mdl0 + 8)[:1]
    m = mdl0 + u32(e, 0)
    mats_o = m + u32(blob, m + 8)
    pal = {}
    for pn, pe in read_dict(blob, mats_o + u16(blob, mats_o + 2)):
        lo, n = u16(pe, 0), pe[2]
        for k in range(n): pal[blob[mats_o + lo + k]] = pn.decode()
    out = {}
    for i, (mn, me) in enumerate(read_dict(blob, mats_o + 4)):
        o = mats_o + u32(me, 0)
        poly, tip = u32(blob, o + 12), u32(blob, o + 20)
        out[mn.decode()] = ((tip >> 16) & 3, (tip >> 18) & 3, (poly >> 16) & 31, pal.get(i))
    return out


def _colours(blob):
    """material name -> the mean vertex colour (or diffuse) of its polygons, for the untextured ones"""
    from bmdview import PARAMS, u32 as U32
    mdl0 = u32(blob, 0x10)
    (name, e), = read_dict(blob, mdl0 + 8)[:1]
    m = mdl0 + u32(e, 0)
    off_sbc, off_mat, off_shp = u32(blob, m + 4), u32(blob, m + 8), u32(blob, m + 12)
    mats_o = m + off_mat
    mats = read_dict(blob, mats_o + 4)
    shps_o = m + off_shp
    shps = read_dict(blob, shps_o)
    sbc = blob[m + off_sbc:m + off_mat]
    pairs, cur, i = [], None, 0
    while i < len(sbc):
        c = sbc[i] & 0x1F
        if c == 0x04: cur = sbc[i + 1]; i += 2
        elif c == 0x05: pairs.append((cur, sbc[i + 1])); i += 2
        elif c == 0x01: break
        elif c == 0x02: i += 3
        elif c == 0x03: i += 2
        elif c == 0x06: i += 4
        elif c == 0x0B: i += 1
        elif c == 0x06 + 0x20: i += 5
        elif c == 0x09: i += 2 + 3 * sbc[i + 2]
        else: i += 1
    out = {}
    for mi, si in pairs:
        if mi is None or mi >= len(mats): continue
        h = shps_o + u32(shps[si][1], 0)
        dl = blob[h + u32(blob, h + 8):h + u32(blob, h + 8) + u32(blob, h + 12)]
        cols, j = [], 0
        while j + 4 <= len(dl):
            codes = dl[j:j + 4]; j += 4
            for cd in codes:
                n = PARAMS.get(cd, 0)
                if cd == 0x20:
                    v = u32(dl, j); cols.append(((v & 31) * 8, ((v >> 5) & 31) * 8, ((v >> 10) & 31) * 8))
                j += 4 * n
        if cols: out[mats[mi][0].decode()] = tuple(sum(c[k] for c in cols) // len(cols) for k in range(3))
    return out


@functools.lru_cache(None)
def land_colours(lid):
    l = _lands()[lid]
    ps, bs, ms, hs, mg, ss = struct.unpack_from('<4I2H', l, 0)
    if mg != 0x1234: ss = 0
    o = 0x14 + ss + ps + bs
    return _colours(l[o:o + ms])


@functools.lru_cache(None)
def land_polys(lid):
    """-> [(texture, (repeat, flip, alpha), [(x, y, z, s, t)])], x and z in squares from the land's corner, y in units"""
    l = _lands()[lid]
    ps, bs, ms, hs, mg, ss = struct.unpack_from('<4I2H', l, 0)
    if mg != 0x1234: ss = 0
    o = 0x14 + ss + ps + bs
    blob = l[o:o + ms]
    sc, shapes = bmdview.model(blob)
    mats = _materials(blob)
    out = []
    cols = _colours(blob)
    for mat, tex, prims in shapes:
        opt = mats.get(mat, (1, 0, 31, None))
        if tex == '?' and mat in cols: tex = '?%d,%d,%d' % cols[mat]
        for prim, vs in prims:
            V = [((v[0] * sc + 256) / 16, v[1] * sc, (v[2] * sc + 256) / 16, v[3], v[4]) for v in vs]
            if prim == 0: polys = [V[i:i + 3] for i in range(0, len(V) - 2, 3)]
            elif prim == 1: polys = [V[i:i + 4] for i in range(0, len(V) - 3, 4)]
            elif prim == 2: polys = [[V[i], V[i + 1], V[i + 2]] if i % 2 == 0 else [V[i + 1], V[i], V[i + 2]] for i in range(len(V) - 2)]
            else: polys = [[V[i], V[i + 1], V[i + 3], V[i + 2]] for i in range(0, len(V) - 3, 2)]
            out += [(tex, opt, p) for p in polys]
    return out


def _clip(poly, k, v, ge):
    """Sutherland-Hodgman: keep the part of poly with coordinate k >= v (ge) or <= v"""
    inside = (lambda p: p[k] >= v - 1e-6) if ge else (lambda p: p[k] <= v + 1e-6)
    out = []
    for i, a in enumerate(poly):
        b = poly[(i + 1) % len(poly)]
        if inside(a): out.append(a)
        if inside(a) != inside(b) and abs(b[k] - a[k]) > 1e-9:
            f = (v - a[k]) / (b[k] - a[k])
            out.append(tuple(a[j] + (b[j] - a[j]) * f for j in range(5)))
    return out


def area_of(poly):
    """twice the polygon's area seen from above and from the front (to drop slivers the clipping leaves)"""
    a = b = c = 0.0
    for i in range(len(poly)):
        p, q = poly[i], poly[(i + 1) % len(poly)]
        a += p[0] * q[2] - q[0] * p[2]
        b += p[0] * q[1] - q[0] * p[1]
        c += p[2] * q[1] - q[2] * p[1]
    return abs(a) + abs(b) / 16 + abs(c) / 16


def cut(lid, x0, z0, x1, z1, keep=None, drop=(), ymin=-1e9, ymax=1e9, whole=False):
    """the polygons of land lid in squares x0..x1, z0..z1, clipped to that box; keep/drop: textures. whole: a
    thing's polygons whole (those whose middle is in the box), not cut up"""
    out = []
    for tex, opt, p in land_polys(lid):
        if keep is not None and tex not in keep: continue
        if tex in drop or (tex.startswith('?') and '?' in drop): continue
        cy = sum(v[1] for v in p) / len(p)
        if not ymin <= cy <= ymax: continue
        if whole:
            cx_, cz_ = sum(v[0] for v in p) / len(p), sum(v[2] for v in p) / len(p)
            if x0 <= cx_ < x1 and z0 <= cz_ < z1: out.append((tex, opt, [(x - x0, y, z - z0, s, t) for x, y, z, s, t in p]))
            continue
        if max(v[0] for v in p) <= x0 or min(v[0] for v in p) >= x1 or max(v[2] for v in p) <= z0 or min(v[2] for v in p) >= z1: continue
        q = p
        for k, v, ge in ((0, x0, True), (0, x1, False), (2, z0, True), (2, z1, False)):
            q = _clip(q, k, v, ge)
            if len(q) < 3: break
        if len(q) >= 3 and area_of(q) > 1e-4:
            out.append((tex, opt, [(x - x0, y, z - z0, s, t) for x, y, z, s, t in q]))
    return out


class Piece:
    """polygons cut from a land, relative to the box's corner and to a height (the source's floor)"""
    def __init__(self, lid, x0, z0, w=1, h=1, base=0.0, **kw):
        self.polys = [(t, o, [(x, y - base, z, s, tt) for x, y, z, s, tt in p]) for t, o, p in cut(lid, x0, z0, x0 + w, z0 + h, **kw)]
        self.w, self.h = w, h

    def mirrored(self):
        """the piece turned over left to right (HeartGold's materials draw both sides)"""
        m = Piece.__new__(Piece)
        m.polys = [(t, o, [(self.w - x, y, z, s, tt) for x, y, z, s, tt in p][::-1]) for t, o, p in self.polys]
        m.w, m.h = self.w, self.h
        return m

    def lay(self, emit, x, z, y=0.0):
        """emit(texture, opts, [(x, y, z, s, t)] in squares and units) for each polygon, laid with its corner at x, z"""
        for t, o, p in self.polys:
            emit(t, o, [(px + x, py + y, pz + z, s, tt) for px, py, pz, s, tt in p])


class PieceSet:
    """pieces cut at every square of a source box, laid by remainder (the texture's pattern lines up)"""
    def __init__(self, lid, x0, z0, px=2, pz=1, base=0.0, **kw):
        self.p = {(i, j): Piece(lid, x0 + i, z0 + j, base=base, **kw) for i in range(px) for j in range(pz)}
        self.px, self.pz, self.x0, self.z0 = px, pz, x0, z0

    def lay(self, emit, x, z, y=0.0):
        self.p[((x - self.x0) % self.px, (z - self.z0) % self.pz)].lay(emit, x, z, y)


# ---------------------------------------------------------------- laying a floor of ours from a kit
def flat_uv(piece):
    """a flat piece's texture mapping: (texture, opts, height, s = a*x + b, t = c*z + d) from its first polygon"""
    t, o, p = piece.polys[0]
    (x0, y0, z0, s0, t0) = p[0]
    a = c = 16.0
    for v in p[1:]:
        if abs(v[0] - x0) > 1e-3: a = (v[3] - s0) / (v[0] - x0)
        if abs(v[2] - z0) > 1e-3: c = (v[4] - t0) / (v[2] - z0)
    return t, o, y0, a, s0 - a * x0, c, t0 - c * z0


def plain_texel(texset, rgb):
    """the texel of a texture set nearest a colour (for HeartGold's untextured polygons): (texture, s, t)"""
    from texview import textures, decode
    ts = read_narc(open(os.path.join(slots.ROOT, 'files/a/0/4/4'), 'rb').read())[0][texset]
    best = None
    for n, (prm, data, comp, pal) in textures(ts).items():
        try: im = decode(prm, data, comp, pal).convert('RGBA')
        except Exception: continue
        for y in range(0, im.height, 2):
            for x in range(0, im.width, 2):
                r, g, b, a = im.getpixel((x, y))
                if a < 200: continue
                d = (r - rgb[0]) ** 2 + (g - rgb[1]) ** 2 + (b - rgb[2]) ** 2
                if best is None or d < best[0]: best = (d, n, x + 0.5, y + 0.5)
    return best[1:]


def build_kit_floor(spec, depth_of):
    """A big interior from its look's kit (LOOKS[look]['kit']): the GBA's layout read as build_ship_floor reads it
    (ship_parts: floor is what can be reached, walls the closed squares with the dark beyond, things the little
    closed patches inside), laid from HeartGold's pieces. Ground first: floor under every square that is no wall
    (under furniture too); a wall square with floor south of it is HeartGold's wall face (its end piece where the
    wall stops beside floor; the GBA's wall art - a vent, a light - where the GBA has it, else at HeartGold's
    spacing); any other wall square HeartGold's wall top; furniture by the GBA's metatiles (`things`: a piece cut
    from HeartGold's room, or one of its models), anything else closed inside a room the kit's `block`."""
    import build_interiors as BI
    from g3d import Mesh, build_model
    from build_rooms import texdims
    import build_caves
    P = BI.ship_parts(spec)
    gm, lay, W, H, warps, band = P['gm'], P['lay'], P['W'], P['H'], P['warps'], P['band']
    walk, door, wallish, isvoid = P['walk'], P['door'], P['wallish'], P['isvoid']
    LOOK = BI.LOOKS[spec['look']]
    KIT = LOOK['kit']
    props, closed, under, hole_sq, holes, kind = BI._furnish(P, spec, depth_of, LOOK)
    texset = LOOK.get('texset', LOOK['area'])
    dims, pals = texdims(texset)
    pal_of = lambda t_, o=None: next(p for p in ((o[3] if o and len(o) > 3 else None), t_ + '_pl', t_, t_.split('.')[0] + '_pl') if p in pals)
    # furniture of the kit's, by the GBA's metatiles: each connected patch of a rule's metatiles gets its piece
    # tiled over it (or its model at the patch's middle)
    furn, laid_things = {}, []
    for ri, rule in enumerate(KIT.get('things', [])):
        mts = rule['mt']
        todo = {(x, y) for y in range(H) for x in range(W) if lay.metatile(x, y) in mts and (x, y) not in furn}
        while todo:
            s0 = todo.pop(); comp = [s0]; stack = [s0]
            while stack:
                c = stack.pop()
                for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                    n = (c[0] + dx, c[1] + dy)
                    if n in todo: todo.discard(n); comp.append(n); stack.append(n)
            for c in comp: furn[c] = ri
            xs, ys = [c[0] for c in comp], [c[1] for c in comp]
            laid_things.append((rule, min(xs), min(ys), max(xs) + 1, max(ys) + 1))
    # HeartGold's room models by the GBA's things (furnish.py KIT rules, by tileset): a patch's rows from `up` on are
    # floor (under the model); those above it stay the wall it stands against or hangs on
    kit_close = set()
    if KIT.get('furnish'):
        import furnish, gba_map
        L_ = gba_map.layouts()[gm['layout']]
        tsn = lambda m: L_['primary_tileset'] if m < lay.n_prim else L_['secondary_tileset']
        for rule_, comp in furnish.patches(lay, tsn, rules=furnish.KIT, full=True):
            up = rule_[4] if len(rule_) > 4 else 0
            first_ = min(c[1] for c in comp) + up
            pr, cl, rg, wn = furnish.place(rule_[2], comp, first_, lambda x_, y_: not walk(x_, y_))
            props.extend((m_, x_, z_, yo) for m_, x_, z_, yo in pr)
            kit_close |= set(cl)
            for c in comp:
                if c[1] >= first_ and not walk(*c): furn[c] = -1
    # (things: the little closed patches inside a room; one on the map's edge is a wall's end)
    inside = set()
    for c in P['things']:
        if c in inside: continue
        comp, stack = {c}, [c]
        while stack:
            q = stack.pop()
            for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                n = (q[0] + dx, q[1] + dy)
                if n in P['things'] and n not in comp: comp.add(n); stack.append(n)
        if not any(q[0] in (0, W - 1) or q[1] in (0, H - 1) for q in comp): inside |= comp
    # (the GBA's walls seen from above - a partition drawn as a dark strip - are walls wherever they stand)
    inside -= {q for q in inside if lay.metatile(*q) in KIT.get('wall_mt', ())}
    is_wall = lambda x, y: 0 <= x < W and 0 <= y < H and wallish(x, y) and not isvoid(x, y) and (x, y) not in furn and \
        (x, y) not in inside and (x, y) not in closed and (x, y) not in under and (x, y) not in hole_sq and not door(x, y)
    is_floor = lambda x, y: 0 <= x < W and 0 <= y < H and not isvoid(x, y) and not is_wall(x, y) and (x, y) not in hole_sq and \
        (walk(x, y) or (x, y) in furn or (x, y) in inside or (x, y) in closed or (x, y) in under or door(x, y))
    # (a wall a square thick with floor right behind it as well as in front is a partition: HeartGold's wall face is
    # three squares tall and would hide the floor behind it, so it is a low block - the GBA draws those low too)
    # (squares the kit names a thing for are things wherever they stand, beside a wall or not: the GBA's rubble and
    # coils lie against the Power Plant's walls)
    listed = set().union(*[r['mt'] for r in KIT.get('things', []) + KIT.get('each', [])]) if (KIT.get('things') or KIT.get('each')) else set()
    named = {(x, y) for y in range(H) for x in range(W) if lay.metatile(x, y) in listed and not walk(x, y) and not isvoid(x, y)}
    inside |= named
    wall1 = is_wall
    wall0 = lambda x, y: wall1(x, y) and (x, y) not in named
    thin = {(x, y) for y in range(H) for x in range(W) if wall0(x, y) and not wall0(x, y - 1) and not isvoid(x, y - 1) and 0 <= y - 1
            and (walk(x, y - 1) or (x, y - 1) in P['things']) and (walk(x, y + 1) or (x, y + 1) in P['things'])}
    thin |= {(x, y) for y in range(H) for x in range(W) if wall0(x, y) and lay.metatile(x, y) in KIT.get('low_mt', ())}
    # (and a wall with no dark beside it anywhere - a maze's walls out in a room - is low all over: its top would
    # stand over the floor north of it)
    seen_w = set()
    for y in range(H):
        for x in range(W):
            if (x, y) in seen_w or not wall0(x, y): continue
            comp, stack = [(x, y)], [(x, y)]; seen_w.add((x, y))
            while stack:
                q = stack.pop()
                for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                    n = (q[0] + dx, q[1] + dy)
                    if n not in seen_w and wall0(*n): seen_w.add(n); comp.append(n); stack.append(n)
            if KIT.get('low_inner') and not any(0 <= q[0] + dx < W and 0 <= q[1] + dy < H and isvoid(q[0] + dx, q[1] + dy) for q in comp for dx in (-1, 0, 1) for dy in (-1, 0, 1)):
                thin |= set(comp)
    inside |= thin
    # (a thick wall - a block of rooms the GBA has walkways all round, as the S.S. Anne's cabins - with walkable floor
    # along its north side: HeartGold's tall wall would stand over that walkway; it is a low wall, the kit's top
    # at a low height with its faces round it)
    lowwall = set()
    for x in range(W):
        y = 0
        while y < H:
            if not (wall0(x, y) and (x, y) not in thin): y += 1; continue
            y0 = y
            while y < H and wall0(x, y) and (x, y) not in thin: y += 1
            if y - y0 >= 3 and walk(x, y0 - 1) and not KIT.get("tall_walls"): lowwall |= {(x, k) for k in range(y0, y)}
    LOW_H = KIT.get('low_h', 10)
    is_wall = lambda x, y: wall0(x, y) and (x, y) not in thin and (x, y) not in lowwall
    block = {s for s in inside if s not in furn and s not in closed}      # (closed, inside a room, no furniture of ours: the kit's block)
    base = KIT['base']
    lid = KIT['src']
    floor_p = Piece(lid, *KIT['floor'], base=base, keep=KIT.get('floor_tex'))
    ftex, fopt, fy, fa, fb, fc, fd = flat_uv(floor_p)
    top_p = Piece(lid, *KIT['top'], base=base)
    top_flat = flat_uv(top_p) if len(top_p.polys) == 1 and len({round(v[1], 2) for v in top_p.polys[0][2]}) == 1 else None
    if top_flat and KIT.get('top_solid'):       # (a top HeartGold paints one colour - a texel or two of its texture - stays so however long the run)
        vs = top_p.polys[0][2]
        top_flat = top_flat[:3] + (0, sum(v[3] for v in vs) / len(vs), 0, sum(v[4] for v in vs) / len(vs))
    # plain, ends, art (one square each; a dict: from another land, {src, at, base})
    face = {k: Piece(v['src'], *v['at'], base=v['base'], drop=KIT.get('face_drop', ())) if isinstance(v, dict) else
            Piece(lid, *v, base=base, drop=KIT.get('face_drop', ())) for k, v in KIT['faces'].items()}
    things_p = {}
    for rule in KIT.get('things', []):
        if 'piece' in rule: things_p[id(rule)] = Piece(rule.get('src', lid), *rule['piece'], base=rule.get('base', base), drop=rule.get('drop', ()), whole=True)
    # stairs: HeartGold's own (a piece of its room) in place of the room models _furnish stands there; no floor of
    # ours under them (the piece has its own)
    stairs_p, stair_at = None, []
    if 'stairs' in KIT or 'stairs_src' in KIT:
        if 'stairs' in KIT:
            sx, sz, sw, sh = KIT['stairs']; stairs_p = Piece(lid, sx, sz, sw, sh, base=base)
        else:
            sl, sx, sz, sw, sh, sb = KIT['stairs_src']; stairs_p = Piece(sl, sx, sz, sw, sh, base=sb)
        keep = []
        for m, x, z, *_ in props:
            if m in LOOK.get('stairs', ()):
                y = round(z - BI.STAIR_BOX[m][4])
                left = m in (LOOK['stairs'][1], LOOK['stairs'][2])         # (the closed side is left of the warp)
                stair_at.append((x - 1, y, left))
                for i in (0, 1):
                    for j in (0, 1): hole_sq.add((x - 1 + i, y + j))
            else: keep.append((m, x, z, *_))
        props[:] = keep
    # the GBA's spin tiles: HeartGold's slide tiles (behaviour), its arrow (Viridian Gym's) on the floor
    slide = {}
    for y in range(H):
        for x in range(W):
            b = lay.behavior(lay.metatile(x, y))
            if b in KIT.get('slides', {}): slide[(x, y)] = KIT['slides'][b]
    block_p = Piece(KIT.get('block_src', lid), *KIT['block'], base=KIT.get('block_base', base), keep=KIT.get('block_keep')) if 'block' in KIT else None
    bdx, bdz = KIT.get('block_at', (0, 0))
    plain = {}
    anim = build_caves.anim_slots(LOOK['area'])
    nx_, nz_ = math.ceil(W / 32), math.ceil(H / 32)
    lands = []
    for lz in range(nz_):
        for lx in range(nx_):
            ox, oz = lx * 32, lz * 32
            X0, X1, Z0, Z1 = ox, min(ox + 32, W), oz, min(oz + 32, H)
            meshes = {}

            def emit(tex, opt, verts):
                if tex.startswith('?'):         # (HeartGold's untextured polygons: the texel nearest their colour)
                    rgb = tuple(int(v) for v in tex[1:].split(',')) if len(tex) > 1 else KIT.get('untextured')
                    if rgb is None: return
                    if rgb not in plain: plain[rgb] = plain_texel(texset, rgb)
                    tex, s_, t_ = plain[rgb]; verts = [(x, y, z, s_, t_) for x, y, z, _, _ in verts]; opt = (3, 0, 31, None)
                if tex not in dims: return
                key = (tex, opt)
                m = meshes.setdefault(key, Mesh())
                vs = [(((x - ox) * 16 - 256, y, (z - oz) * 16 - 256), (s, t)) for x, y, z, s, t in verts]
                if len(vs) == 4: m.quad(vs, (0, 1, 0))
                elif len(vs) == 3: m.tri(vs, (0, 1, 0))
                else:
                    for i in range(1, len(vs) - 1): m.tri([vs[0], vs[i], vs[i + 1]], (0, 1, 0))

            def run_quad(tex, opt, y, x0, x1, z0, z1, a, b, c, d):
                emit(tex, opt, [(x0, y, z1, a * x0 + b, c * z1 + d), (x1, y, z1, a * x1 + b, c * z1 + d), (x1, y, z0, a * x1 + b, c * z0 + d), (x0, y, z0, a * x0 + b, c * z0 + d)])

            perm = [0x8000] * 1024
            for y in range(Z0, Z1):
                for x in range(X0, X1):
                    if walk(x, y) and (x, y) not in closed and (x, y) not in furn and (x, y) not in block and (x, y) not in kit_close:
                        perm[(y - oz) * 32 + (x - ox)] = kind.get((x, y), slide[(x, y)][0] if (x, y) in slide else 0) | (0x0600 if slide else 0)
                    if (x, y) in slide:       # (the arrow, a unit over the floor, turned the way it sends you)
                        d = slide[(x, y)][1]
                        uv = {'right': ((0, 16), (16, 16), (16, 0), (0, 0)), 'left': ((16, 16), (0, 16), (0, 0), (16, 0)),
                              'up': ((0, 0), (0, 16), (16, 16), (16, 0)), 'down': ((16, 16), (16, 0), (0, 0), (0, 16)),
                              'stop': ((0, 32), (32, 32), (32, 0), (0, 0))}[d]
                        tex = KIT['arrow'] if d != 'stop' else KIT['stop']
                        q = [(x, 1, y + 1), (x + 1, 1, y + 1), (x + 1, 1, y), (x, 1, y)]
                        emit(tex, (3, 0, 31, None), [(a, b_, c, *st) for (a, b_, c), st in zip(q, uv)])
                # the floor, in runs (under everything that is no wall)
                xs = [x for x in range(X0, X1) if is_floor(x, y) and not (is_wall(x, y - 1) and False)]
                for x0_, n_ in _runs(xs):
                    run_quad(ftex, fopt, fy, x0_, x0_ + n_, y, y + 1, fa, fb, fc, fd)
                if top_flat:      # (a flat top: in runs)
                    tt, to, ty, ta, tb, tc, td = top_flat
                    for x0_, n_ in _runs([x for x in range(X0, X1) if is_wall(x, y) and not is_floor(x, y + 1)]):
                        run_quad(tt, to, ty, x0_, x0_ + n_, y, y + 1, ta, tb, tc, td)
                # walls: the face where floor lies south, else the top
                for x in range(X0, X1):
                    if door(x, y) and 'door' in face and is_wall(x - 1, y) | is_wall(x + 1, y):
                        face['door'].lay(emit, x, y); continue      # (a door in the wall: the kit's)
                    if not is_wall(x, y): continue
                    if is_floor(x, y + 1):
                        wl, wr = is_wall(x - 1, y), is_wall(x + 1, y)
                        art = next((KIT['art'][lay.metatile(x, y - k)] for k in range(0, 3) if 0 <= y - k and lay.metatile(x, y - k) in KIT.get('art', {})), None)
                        if not wr and is_floor(x + 1, y) and 'end_e' in face: f = 'end_e'
                        elif not wl and is_floor(x - 1, y) and 'end_w' in face: f = 'end_w'
                        elif art and art in face: f = art
                        elif "lit" in face and x % KIT.get("lit_every", 6) == KIT.get("lit_every", 6) // 2 and wl and wr: f = "lit"
                        else: f = 'plain'
                        face[f].lay(emit, x, y)
                    elif not top_flat:
                        top_p.lay(emit, x, y)
                # a way in through a low wall (the S.S. Anne's cabins, entered going south): a mat before it
                if KIT.get('mat'):
                    for x in range(X0, X1):
                        if (x, y) in warps and (x, y + 1) in lowwall:
                            mt_, mw, mh = KIT['mat']
                            emit(mt_, (0, 0, 31, None), [(x + 0.1, 0.5, y + 0.9, 0, mh), (x + 0.9, 0.5, y + 0.9, mw, mh), (x + 0.9, 0.5, y + 0.1, mw, 0), (x + 0.1, 0.5, y + 0.1, 0, 0)])
                # low walls: the kit's top at a low height, its plain face's texture down each side by floor
                if top_flat:
                    tt, to, ty, ta, tb, tc, td = top_flat
                    for x0_, n_ in _runs([x for x in range(X0, X1) if (x, y) in lowwall]):
                        run_quad(tt, to, LOW_H, x0_, x0_ + n_, y, y + 1, ta, tb, tc, td)
                    for x in range(X0, X1):
                        if (x, y) not in lowwall: continue
                        for dx, dy in ((0, 1), (0, -1), (1, 0), (-1, 0)):
                            if (x + dx, y + dy) in lowwall or not is_floor(x + dx, y + dy): continue
                            if dy: zz = y + (1 if dy > 0 else 0); a_, b_ = (x, zz), (x + 1, zz)
                            else: xx = x + (1 if dx > 0 else 0); a_, b_ = (xx, y), (xx, y + 1)
                            emit(tt, to, [(a_[0], 0, a_[1], 0, 16), (b_[0], 0, b_[1], 16, 16), (b_[0], LOW_H, b_[1], 16, 0), (a_[0], LOW_H, a_[1], 0, 0)])
                # closed squares inside a room with no furniture of the kit's: its block
                for x in range(X0, X1):
                    if (x, y) not in block: continue
                    mt_ = lay.metatile(x, y)
                    each = next((r for r in KIT.get('each', []) if mt_ in r['mt']), None) or KIT.get('each_default')
                    if each and 'card' in each:     # (a thing stood up as HeartGold stands its rocks and bushes: a card leaning back)
                        c_ = each['card']; s0, t0, s1, t1 = c_['uv']
                        a0, a1 = x + 0.5 - c_['w'] / 2, x + 0.5 + c_['w'] / 2
                        emit(c_['tex'], (0, 0, 31, None), [(a0, 0, y + c_['zf'], s0, t1), (a1, 0, y + c_['zf'], s1, t1), (a1, c_['h'], y + c_['zt'], s1, t0), (a0, c_['h'], y + c_['zt'], s0, t0)])
                        continue
                    if each and 'stone' in each or 'stone' in KIT:        # (a stone of the kit's texture: its picture on top, its edge colour round it)
                        st_ = each['stone'] if each and 'stone' in each else KIT['stone']
                        a0, a1 = x + 0.5 - st_['w'] / 2, x + 0.5 + st_['w'] / 2
                        b0, b1 = y + 0.5 - st_['d'] / 2, y + 0.5 + st_['d'] / 2
                        hh = st_['h']; s0, t0, s1, t1 = st_['top']; ss_, tt_ = st_['side']
                        emit(st_['tex'], (3, 0, 31, None), [(a0, hh, b1, s0, t1), (a1, hh, b1, s1, t1), (a1, hh, b0, s1, t0), (a0, hh, b0, s0, t0)])
                        for q in ([(a0, 0, b1), (a1, 0, b1), (a1, hh, b1), (a0, hh, b1)], [(a1, 0, b1), (a1, 0, b0), (a1, hh, b0), (a1, hh, b1)],
                                  [(a0, 0, b0), (a0, 0, b1), (a0, hh, b1), (a0, hh, b0)]):
                            emit(st_['tex'], (3, 0, 31, None), [(*v, ss_, tt_) for v in q])
                    elif block_p: block_p.lay(emit, x + bdx, y + bdz)
            # round a staircase going down, the floor up to its well (the model's footprint)
            for hx0, hz0, hx1, hz1, rx0, rz0, rx1, rz1 in holes:
                if not (X0 * 16 <= hx0 < X1 * 16 and Z0 * 16 <= hz0 < Z1 * 16) or stairs_p: continue
                for sx0, sz0, sx1, sz1 in ((hx0, hz0, hx1, rz0), (hx0, rz1, hx1, hz1), (hx0, rz0, rx0, rz1), (rx1, rz0, hx1, rz1)):
                    if sx1 - sx0 < 0.5 or sz1 - sz0 < 0.5: continue
                    run_quad(ftex, fopt, fy, sx0 / 16, sx1 / 16, sz0 / 16, sz1 / 16, fa, fb, fc, fd)
            for sx_, sy_, left in stair_at:
                if X0 <= sx_ < X1 and Z0 <= sy_ < Z1:
                    (stairs_p if left else stairs_p.mirrored()).lay(emit, sx_, sy_)
            for rule, a0, b0, a1, b1 in laid_things:
                if not (X0 <= a0 < X1 and Z0 <= b0 < Z1): continue
                if 'model' in rule:
                    props.append((rule['model'], (a0 + a1) / 2 + rule.get('dx', 0), (b0 + b1) / 2 + rule.get('dz', 0)))
                    continue
                pc = things_p[id(rule)]
                nx_p, nz_p = max(1, (a1 - a0) // pc.w), max(1, (b1 - b0) // pc.h)
                cx0 = a0 + ((a1 - a0) - nx_p * pc.w) / 2 if rule.get('center') else a0
                cz0 = b0 + ((b1 - b0) - nz_p * pc.h) / 2 if rule.get('center') else b0
                for j in range(nz_p):
                    for i in range(nx_p): pc.lay(emit, cx0 + i * pc.w, cz0 + j * pc.h)
            if not meshes:          # (a land with nothing on it still needs a model: a scrap of floor, out of sight)
                run_quad(ftex, fopt, -64, X0, X0 + 0.1, Z0, Z0 + 0.1, fa, fb, fc, fd)
            # (the area's animated materials hold their places)
            groups = []
            for i, t_ in enumerate(anim):
                groups.append(('hold%d' % i, ftex, pal_of(ftex), Mesh(), {'repeat': 3, 'size': dims[ftex]}))
            names = {}
            for (t_, o), m in meshes.items():
                nm = t_[:16] if t_ not in names else (t_[:13] + '_%d' % len(names))
                names[t_] = 1
                groups.append((nm, t_, pal_of(t_, o), m, {'repeat': o[0], 'flip': o[1], 'alpha': o[2], 'size': dims[t_]}))
            model = build_model('cv_kit_%d' % (len(lands) + 10 * (int(spec['depth']) + 20)), groups)
            model += b'\0' * (-len(model) % 4)
            f4 = lambda v: int(round(v * 4096))
            U = lambda v, o: (v - o) * 16 - 256
            bld = b''.join(struct.pack('<I3i3i3i8x', m, f4(U(x, ox)), f4(yo[0] if yo else 0), f4(U(z_, oz)), 0, 0, 0, 4096, 4096, 4096)
                           for m, x, z_, *yo in props if X0 <= x < X1 and Z0 <= z_ < Z1)
            bdhc = struct.pack('<4s6H', b'BDHC', 2, 1, 1, 1, 1, 1) + struct.pack('<2i2i', -256 * 4096, -256 * 4096, 256 * 4096, 256 * 4096) + \
                struct.pack('<3i', 0, 4096, 0) + struct.pack('<i', 0) + struct.pack('<4H', 0, 1, 0, 0) + struct.pack('<iHH', 256 * 4096, 1, 0) + struct.pack('<H', 0)
            p = struct.pack('<1024H', *perm)
            npoly = sum(len(m.quads) + len(m.tris) for m in meshes.values())
            print('  %s land %d: %d polygons, model %d bytes' % (spec['gba'], len(lands), npoly, len(model)))
            if len(model) >= 61400: print('  TOO BIG', {k[0]: len(m.quads) + len(m.tris) for k, m in meshes.items()})
            assert len(model) < 61400, ('model too big for a land', spec['gba'], len(lands), len(model))
            lands.append(struct.pack('<4I2H', len(p), len(bld), len(model), len(bdhc), 0x1234, 0) + p + bld + model + bdhc)
    BI.USED_MODELS.setdefault(LOOK['area'], set()).update(m for m, *_ in props)
    return gm, (nx_, nz_), lands


def _runs(xs):
    out = []
    for x in sorted(xs):
        if out and out[-1][0] + out[-1][1] == x: out[-1][1] += 1
        else: out.append([x, 1])
    return out
