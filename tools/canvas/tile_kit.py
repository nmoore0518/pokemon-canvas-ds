"""The tile table: a big interior laid square for square from HeartGold's own rooms, one piece of a HeartGold land
for each GBA square, chosen by what the GBA draws there (build_interiors.py, looks with `tiles`).

Where interior_kit.py works out walls, tops and partitions from the GBA's layout, a tile table names them: each
role (a rail, a post, the back wall...) is one square of a HeartGold land, cut out with its polygons and laid
unchanged on every GBA square of that role. A room of one kind of wall (a gym) reads best this way: HeartGold's
pieces fit each other as they do in its own room, and nothing is drawn that HeartGold doesn't draw.

A look's texture set can be a recoloured copy of HeartGold's (`RECOLOURS`, build_interiors.import_textures): the
same pieces in another colour (Saffron Gym's, warm, for Cinnabar's).

    tiles = dict(src=LAND, base=FLOOR_Y, floor=(x, z), floor_tex={...},
                 pieces={role: (x, z) | dict(at=(x, z), src=, ymax=, drop=, mirror=)},
                 role=f(lay, x, y, gba) -> role name, 'floor', 'void', or a piece name,
                 models={role: (model, dx, dz)})
"""
import math, struct, colorsys
import interior_kit as K


def recolour_palette(data, hue=0.0, sat=1.0, val=1.0, keep_grey=0.08):
    """a BGR555 palette with each colour's hue turned (0..1 of a turn), saturation and value scaled; greys stay
    greys (a colour whose saturation is under keep_grey keeps its hue - it has none to speak of)"""
    out = bytearray(data)
    for i in range(0, len(data) - 1, 2):
        v = data[i] | (data[i + 1] << 8)
        r, g, b = (v & 31) / 31, ((v >> 5) & 31) / 31, ((v >> 10) & 31) / 31
        h, s, vv = colorsys.rgb_to_hsv(r, g, b)
        if s >= keep_grey: h = (h + hue) % 1.0; s = min(1.0, s * sat)
        vv = min(1.0, vv * val)
        r, g, b = colorsys.hsv_to_rgb(h, s, vv)
        q = (round(r * 31)) | (round(g * 31) << 5) | (round(b * 31) << 10) | (v & 0x8000)
        out[i], out[i + 1] = q & 0xFF, q >> 8
    return bytes(out)


def recoloured_set(blob, **kw):
    """a texture set (BTX0) with every palette recoloured"""
    from nitro import read_tex0, tex0_of, write_btx0
    t, p = read_tex0(blob, tex0_of(blob))
    return write_btx0(t, [(nm, fl, recolour_palette(d, **kw)) for nm, fl, d in p])


def build_tile_floor(spec, depth_of):
    import build_interiors as BI
    from g3d import Mesh, build_model
    from build_rooms import texdims
    import build_caves
    P = BI.ship_parts(spec)
    gm, lay, W, H, warps = P['gm'], P['lay'], P['W'], P['H'], P['warps']
    walk = P['walk']
    LOOK = BI.LOOKS[spec['look']]
    T = LOOK['tiles']
    props, closed, under, hole_sq, holes, kind = BI._furnish(P, spec, depth_of, LOOK)
    texset = LOOK.get('texset', LOOK['area'])
    dims, pals = texdims(texset)
    pal_of = lambda t_, o=None: next(p for p in ((o[3] if o and len(o) > 3 else None), t_ + '_pl', t_, t_.split('.')[0] + '_pl') if p in pals)
    lid, base = T['src'], T['base']
    floor_p = K.Piece(lid, *T['floor'], base=base, keep=T.get('floor_tex'))
    ftex, fopt, fy, fa, fb, fc, fd = K.flat_uv(floor_p)
    pieces = {}
    for name, v in T['pieces'].items():
        v = v if isinstance(v, dict) else dict(at=v)
        p = K.Piece(v.get('src', lid), *v['at'], *v.get('size', (1, 1)), base=v.get('base', base), drop=set(v.get('drop', ())) | set(T.get('floor_tex', ())),
                    ymax=v.get('ymax', 1e9) + v.get('base', base))
        pieces[name] = p.mirrored() if v.get('mirror') else p
    roles = {(x, y): T['role'](lay, x, y, P) for y in range(H) for x in range(W)}
    for (x, y), r in roles.items():
        if r in T.get('models', {}):
            m, dx, dz = T['models'][r]
            props.append((m, x + 0.5 + dx, y + 0.5 + dz))
    nx_, nz_ = math.ceil(W / 32), math.ceil(H / 32)
    lands = []
    for lz in range(nz_):
        for lx in range(nx_):
            ox, oz = lx * 32, lz * 32
            X0, X1, Z0, Z1 = ox, min(ox + 32, W), oz, min(oz + 32, H)
            meshes = {}

            def emit(tex, opt, verts):
                if tex not in dims: return
                m = meshes.setdefault((tex, opt), Mesh(vcolour=opt[4] if len(opt) > 4 else K.DEFAULT_COLOUR))
                vs = [(((x - ox) * 16 - 256, y, (z - oz) * 16 - 256), (s, t), *c) for x, y, z, s, t, *c in verts]
                if len(vs) == 4: m.quad(vs, (0, 1, 0))
                elif len(vs) == 3: m.tri(vs, (0, 1, 0))
                else:
                    for i in range(1, len(vs) - 1): m.tri([vs[0], vs[i], vs[i + 1]], (0, 1, 0))

            def run_quad(x0, x1, z0, z1):
                emit(ftex, fopt, [(x0, fy, z1, fa * x0 + fb, fc * z1 + fd), (x1, fy, z1, fa * x1 + fb, fc * z1 + fd),
                                  (x1, fy, z0, fa * x1 + fb, fc * z0 + fd), (x0, fy, z0, fa * x0 + fb, fc * z0 + fd)])

            perm = [0x8000] * 1024
            for y in range(Z0, Z1):
                for x in range(X0, X1):
                    if walk(x, y) and (x, y) not in closed:
                        perm[(y - oz) * 32 + (x - ox)] = kind.get((x, y), 0)
                # the floor, in runs, under every square that has floor (its texture running on, as HeartGold lays it)
                xs = [x for x in range(X0, X1) if roles[(x, y)] not in T.get('no_floor', ()) and roles[(x, y)] != 'void']
                for x0_, n_ in K._runs(xs):
                    run_quad(x0_, x0_ + n_, y, y + 1)
                for x in range(X0, X1):
                    r = roles[(x, y)]
                    if r in pieces: pieces[r].lay(emit, x, y)
            if not meshes:
                run_quad(X0, X0 + 0.1, Z0, Z0 + 0.1)
            groups = []
            for i, t_ in enumerate(build_caves.anim_slots(LOOK['area'])):
                groups.append(('hold%d' % i, ftex, pal_of(ftex), Mesh(), {'repeat': 3, 'size': dims[ftex], 'lit': False}))
            names = {}
            for (t_, o), m in meshes.items():
                nm = t_[:16] if t_ not in names else (t_[:13] + '_%d' % len(names))
                names[t_] = 1
                groups.append((nm, t_, pal_of(t_, o), m, {'repeat': o[0], 'flip': o[1], 'alpha': o[2], 'size': dims[t_], 'lit': False}))
            model = build_model('cv_tile_%d' % (len(lands) + 10 * (int(spec['depth']) + 20)), groups)
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
            assert len(model) < 61400, ('model too big for a land', spec['gba'], len(lands), len(model))
            lands.append(struct.pack('<4I2H', len(p), len(bld), len(model), len(bdhc), 0x1234, 0) + p + bld + model + bdhc)
    BI.USED_MODELS.setdefault(LOOK['area'], set()).update(m for m, *_ in props)
    return gm, (nx_, nz_), lands


# ---------------------------------------------------------------- the Cinnabar Gym: Saffron Gym's, warm
# The GBA's gym is rooms of orange floor parted by thin walls: a strip seen from above (its top row) with a face
# below it, and walls a square wide down the room. Saffron Gym's (land 314) are the same: glass rails a square deep
# across its floor and posts a square wide down it, painted and raised a little, never tall - so they hide nobody
# (HeartGold stands its own trainers right behind them). Its pieces: the floor; the rail (cables over it left off:
# ymax); a post; a post's foot; the back wall; the rail with a post through it and the orb on top
_WALL_V = {0x294, 0x2B0, 0x2BD, 0x285, 0x286, 0x287, 0x2BE, 0x29C, 0x2DC, 0x2DD, 0x2D6, 0x2D7, 0x28D, 0x28E, 0x28F, 0x2DE,
           0x2DF, 0x296, 0x2CC, 0x2D3, 0x2D4, 0x2D5, 0x28C}
_RAIL = {0x290, 0x2A0, 0x2A1, 0x2A2, 0x2A3}          # (a partition's face row: the rail stands there, before the floor south)
_TOP = {0x29A, 0x29B, 0x299}                          # (its top row: floor, closed, behind the rail)
_FOOT = {0x2A4, 0x297}                                # (the foot of a wall down the room)
_MACHINE = {0x2C8, 0x2C9, 0x298, 0x2A8}               # (the quiz machines, two by two: HeartGold's terminal)


def cinnabar_role(lay, x, y, P):
    mt = lambda x_, y_: lay.metatile(x_, y_) if 0 <= x_ < lay.w and 0 <= y_ < lay.h else 0
    m = mt(x, y)
    if y == lay.h - 1:          # (the front: Saffron's front rail, a gap at the way out)
        if P['walk'](x, y - 1) and (x, y - 1) in P['warps']: return 'floor'
        return 'frontl' if x == 0 else 'frontr' if x == lay.w - 1 else 'front'
    if P['isvoid'](x, y) or y == 0: return 'void'
    if y == 1:
        if m in _MACHINE: return 'back'
        return 'corner' if m in (0x28C, 0x2CB, 0x2CC, 0x2CD) else 'back'
    if m in _MACHINE:
        if m == 0x298 and mt(x + 1, y) == 0x2A8: return 'machine'
        return 'floor'
    if m == 0x2B7: return 'statue'
    if m in _RAIL: return 'rail'
    if m in _TOP: return 'floor'
    if m in _FOOT: return 'foot'
    if m in _WALL_V:
        if mt(x - 1, y) in _RAIL or mt(x + 1, y) in _RAIL: return 'junction'
        if y == lay.h - 2 or mt(x, y + 1) in (0x8,): return 'foot'
        return 'post'
    return 'floor'


CINNABAR_TILES = dict(
    src=314, base=14, floor=(3, 6), floor_tex={'y_j_yuka1'},
    pieces={'back': dict(at=(5, 2)), 'corner': dict(at=(0, 2)), 'post': dict(at=(10, 5)), 'foot': dict(at=(10, 27)),
            'rail': dict(at=(5, 11), ymax=38), 'junction': dict(at=(10, 11), ymax=46),
            'front': dict(at=(5, 28)), 'frontl': dict(at=(0, 28)), 'frontr': dict(at=(30, 28))},
    no_floor=('back', 'corner'),
    role=cinnabar_role,
    models={'machine': (136, 0.5, 0.0), 'statue': (78, 0, 0)})
