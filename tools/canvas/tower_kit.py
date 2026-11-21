"""The Pokemon Tower's floors (Nick: remake it - the walls were off, the floor no native tile, the gravestones cubes),
built square by square from the GBA's layouts in HeartGold's own tower look:

  - the floor: the Sprout Tower's boards (`d15_yuka01`, its texture as the Sprout Tower lays it, 16 texels a square);
  - the walls: the Sprout Tower's purple panelled wall (`d15_wall01`: a panel to three squares, 64 units high as
    HeartGold's), standing where the GBA's floor meets its wall band or the dark - along the north, and down the
    sides of the octagon, a face on each side of a square that has wall or dark beyond it; nothing along the south
    (HeartGold's rooms are open to the camera there). Its dark top (`d15_wall01a`) over every wall square and over the
    dark just behind a face; its shadow (`h_kage`) along the foot of the north wall, as the Sprout Tower's;
  - the gravestones: upright arched stones with the House of Memories' tombstone picture on their faces (`_stone`:
    HeartGold's own lie flat, a slab with the picture on top), a square each, and the 7F's statues the same stone,
    twice as tall, over their two squares;
  - the 1F's counter: a low box, the Sprout Tower's boards on top and its wall's foot round it;
  - the Sprout Tower's lamps (model 68) on the north wall every six squares, as it hangs them;
  - the stairs: the Sprout Tower's own ladders (field models 66, 67), placed by build_interiors._furnish;
  - every floor a third roomier than the GBA's (`tower_widen`).
Area 120 (build_interiors.OWN_AREAS): the Sprout Tower's texture set (77) with the House of Memories' tombstone and
wood brought in (build_interiors.IMPORTS)."""
import math, os, struct, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import interior_kit as IK

WALL_MT = {0x288, 0x290, 0x298, 0x2A0, 0x28A, 0x28B, 0x28C, 0x28D}
GRAVE_MT = {0x291, 0x293, 0x289, 0x2A5, 0x2A6, 0x2B1, 0x2B2, 0x2B3, 0x2BE, 0x2BF, 0x2D6, 0x2D8, 0x2D9, 0x2DA, 0x2DC, 0x2DD, 0x2E3, 0x2E4}
STATUE_MT = {0x2CF, 0x2D7}      # (the 7F's two statues, a square wide and two deep)
COUNTER_MT = {0x2C8, 0x2C9, 0x2CA, 0x2D0, 0x2D1, 0x2D2, 0x2D3, 0x2D4}
# (Nick: the walls were almost blurry - the Sprout Tower stretches its panel, 32 texels, over 64 units up and three
# squares along, and so did we. Now a texel to a unit, as HeartGold's sharp rooms lay theirs: the panel two squares
# wide and the wall 32 units high, the GBA's own wall height - two squares)
WALL_H = 32
KERB_H = 8
PANEL = 16                      # (texels to a square: the 32-texel panel over two)
# (HeartGold's shading, baked into vertex colours with the lights off as it draws its lands: a wall darker at its
# foot; a gravestone's face lit, lighter at the top, its edges and base in shadow)
WALL_TOP_C, WALL_FOOT_C = 0x6739, 0x3DEF
STONE_FACE_TOP, STONE_FACE_FOOT, STONE_EDGE, STONE_SIDE, STONE_BASE = 0x7FFF, 0x5AD6, 0x6739, 0x3DEF, 0x4A52
TOP_ST = (3.9, 0.4)             # (its wall top: one dark texel)
COUNTER_H = 12
# (Nick: the rooms looked much smaller than they should): every floor a third roomier - plain columns before the
# GBA's 5, 7, 14 and 16, plain rows before 5, 13 and 14 (clear of the stairs, the 5F's purifying ground, the 2F rival's
# triggers and the 7F statues; the porter moves everyone with the squares, and redoes the walks: port_map MOVES)
WIDEN_COLS = (5, 7, 14, 16)
WIDEN_ROWS = (5, 13, 14)
LAMP, LAMP_EVERY = 68, 6        # (the Sprout Tower's wall lamp, on the north wall now and then)


def tower_widen(gba):
    """-> build_rooms.widen(cols=, rows=) for a Tower floor: each new line a copy of the GBA's line after it, but
    plain floor where it would cut through a grave or anything closed on one side of it only (the graves' rows get
    an aisle; the counter carries on across it), so nothing is doubled"""
    import gba_map
    gm = gba_map.map_json(gba); lay = gba_map.Layout(gm['layout'])
    W, H = lay.w, lay.h
    thing = lambda x, y: 0 <= x < W and 0 <= y < H and lay.collision(x, y) and lay.metatile(x, y) not in WALL_MT | {0x281}
    floor = next((x, y) for y in range(H) for x in range(W) if lay.metatile(x, y) == 0x282 and not lay.collision(x, y))
    grave = lambda x, y: 0 <= x < W and 0 <= y < H and lay.metatile(x, y) in GRAVE_MT
    pick = lambda a, b: b if thing(*a) and thing(*b) and not grave(*a) and not grave(*b) else floor if thing(*a) or thing(*b) else b
    return dict(cols=[(c, 1, [pick((c - 1, y), (c, y)) for y in range(H)]) for c in WIDEN_COLS],
                rows=[(r, 1, [pick((x, r - 1), (x, r)) for x in range(W)]) for r in WIDEN_ROWS])


_grave = {}

# a gravestone (Nick: gravestone shaped, not cubes - HeartGold's own lie flat, a slab with the stone's picture on top,
# so ours stands up): an arched slab facing the camera, leaning back a little, the House of Memories' tombstone
# picture (so_tomb02: its engraved outline, s 2..22, t 0..25) on its face, the stone's plain texel round its edge,
# on a flat stone a little wider. 10 polygons (a land holds 1,500: the 7F has 104 graves)
STONE = dict(w=0.78, h=15.0, thick=4.5, lean=0.12, base=(0.92, 0.55, 2.0))     # (thicker than it was: Nick, more depth)
ARCH = [(-0.5, 0.0), (0.5, 0.0), (0.5, 0.74), (0.24, 1.0), (-0.24, 1.0), (-0.5, 0.74)]     # (its outline, x by width, y by height)
PLAIN = (28.2, 19.0)


def _stone(emit, cx, cz, k=1.0):
    """a gravestone standing on the square whose middle is cx, cz (k: taller, for a statue)"""
    o = (3, 0, 31, 'so_tomb02_pl')
    w, h, th, lean = STONE['w'], STONE['h'] * k, STONE['thick'] / 16, STONE['lean']
    zf = cz + 0.12                       # (its face, a little south of the square's middle)
    P = lambda u, v, d=0.0: (cx + u * w, v * h, zf - d - lean * v * h / 16)
    IK_mix = IK.mix
    F = lambda u, v: (*P(u, v), 2 + (u + 0.5) * 20, 25 - v * 25, STONE_FACE_TOP)
    # (its face, two quads - the body and the arch's top - rather than a fan of four triangles: fewer vertices, and
    # the 7F's 104 graves fit a land)
    emit('so_tomb02', o, [F(-0.5, 0.0), F(0.5, 0.0), F(0.5, 0.74), F(-0.5, 0.74)])
    emit('so_tomb02', o, [F(-0.5, 0.74), F(0.5, 0.74), F(0.24, 1.0), F(-0.24, 1.0)])
    for (u0, v0), (u1, v1) in zip(ARCH[1:], ARCH[2:] + ARCH[:1]):        # (its edge, round from the right foot)
        c_ = STONE_EDGE if v0 > 0.7 and v1 > 0.7 else STONE_SIDE      # (the top of the arch catches the light)
        emit('so_tomb02', o, [(*P(u0, v0), *PLAIN, c_), (*P(u1, v1), *PLAIN, c_), (*P(u1, v1, th), *PLAIN, c_), (*P(u0, v0, th), *PLAIN, c_)])
    bw, bd, bh = STONE['base']        # (its plinth: a low block, its top and front)
    x0_, x1_ = cx - bw / 2 * w / 0.78, cx + bw / 2 * w / 0.78
    emit('so_tomb02', o, [(x0_, bh, zf + 0.12, *PLAIN, STONE_EDGE), (x1_, bh, zf + 0.12, *PLAIN, STONE_EDGE),
                          (x1_, bh, zf - bd, *PLAIN, STONE_EDGE), (x0_, bh, zf - bd, *PLAIN, STONE_EDGE)])



def build_tower_floor(spec, depth_of):
    import build_interiors as BI
    from g3d import Mesh, build_model
    from build_rooms import texdims
    import build_caves
    P = BI.ship_parts(spec)
    gm, lay, W, H, warps = P['gm'], P['lay'], P['W'], P['H'], P['warps']
    walk, isvoid = P['walk'], P['isvoid']
    LOOK = BI.LOOKS[spec['look']]
    props, closed, under, hole_sq, holes, kind = BI._furnish(P, spec, depth_of, LOOK)
    dims, pals = texdims(LOOK['texset'])
    pal_of = lambda t_, o=None: next(p for p in ((o[3] if o and len(o) > 3 else None), t_ + '_pl', t_, t_.split('.')[0] + '_pl') if p in pals)
    inb = lambda x, y: 0 <= x < W and 0 <= y < H
    mt = lambda x, y: lay.metatile(x, y) if inb(x, y) else None
    stair_sq = under | hole_sq | {q for q in closed}
    wall = lambda x, y: inb(x, y) and mt(x, y) in WALL_MT
    dark = lambda x, y: not inb(x, y) or (isvoid(x, y) and not walk(x, y))
    beyond = lambda x, y: wall(x, y) or dark(x, y)            # (what a wall stands against)
    # (a wall stands its full height only where nothing of the room lies north of it, within three squares: the
    # octagon's sides stepping in toward the south are a low kerb, or they would stand in front of the floor)
    hgt = lambda x, y: WALL_H if not any((x, y - k) in room for k in (1, 2, 3)) else KERB_H
    # the floor: every square inside the walls (graves, stairs, the counter stand on it)
    room = {(x, y) for y in range(H) for x in range(W) if not beyond(x, y)}
    grave = {q for q in room if mt(*q) in GRAVE_MT and q not in stair_sq and not walk(*q)}
    statue = {q for q in room if mt(*q) in STATUE_MT}
    counter = {q for q in room if mt(*q) in COUNTER_MT}
    nx_, nz_ = math.ceil(W / 32), math.ceil(H / 32)
    anim = build_caves.anim_slots(LOOK['area'])
    lands = []
    for lz in range(nz_):
        for lx in range(nx_):
            ox, oz = lx * 32, lz * 32
            X0, X1, Z0, Z1 = ox, min(ox + 32, W), oz, min(oz + 32, H)
            meshes = {}

            def emit(tex, opt, verts):
                if tex not in dims: return
                m = meshes.setdefault((tex, opt), Mesh(vcolour=IK.DEFAULT_COLOUR))
                vs = [(((x - ox) * 16 - 256, y, (z - oz) * 16 - 256), (s, t), *c) for x, y, z, s, t, *c in verts]
                if len(vs) == 4: m.quad(vs, (0, 1, 0))
                elif len(vs) == 3: m.tri(vs, (0, 1, 0))
                else:
                    for i in range(1, len(vs) - 1): m.tri([vs[0], vs[i], vs[i + 1]], (0, 1, 0))
            OPT = lambda t_, a=31: (3, 0, a, t_ + '_pl')
            perm = [0x8000] * 1024
            for y in range(Z0, Z1):
                for x in range(X0, X1):
                    if walk(x, y) and (x, y) not in closed:
                        perm[(y - oz) * 32 + (x - ox)] = kind.get((x, y), 0)
                # the floor, in runs (not in a staircase's well)
                xs = [x for x in range(X0, X1) if (x, y) in room and (x, y) not in hole_sq]
                for a, n in IK._runs(xs):
                    b = a + n
                    emit('d15_yuka01', OPT('d15_yuka01'), [(a, 0, y + 1, a * 16, (y + 1) * 16), (b, 0, y + 1, b * 16, (y + 1) * 16),
                                                           (b, 0, y, b * 16, y * 16), (a, 0, y, a * 16, y * 16)])
                # the wall's top over every square of it, and over the dark just behind a face
                tops = [x for x in range(X0, X1) if (x, y) not in room and (
                    wall(x, y) or any((x + a, y + b) in room for a, b in ((0, 1), (1, 0), (-1, 0), (1, 1), (-1, 1))))]
                for hh in (WALL_H, KERB_H):
                    for a, n in IK._runs([x for x in tops if hgt(x, y) == hh]):
                        b = a + n
                        emit('d15_wall01a', OPT('d15_wall01a'), [(a, hh, y + 1, *TOP_ST), (b, hh, y + 1, *TOP_ST), (b, hh, y, *TOP_ST), (a, hh, y, *TOP_ST)])
                # the faces: north of the floor, and either side of it; none along the south
                for x in range(X0, X1):
                    if (x, y) not in room: continue
                    if beyond(x, y - 1):
                        s0, s1 = x * PANEL, (x + 1) * PANEL
                        hh = hgt(x, y - 1)
                        if hh == WALL_H and x % LAMP_EVERY == 3 and beyond(x - 1, y - 1) and beyond(x + 1, y - 1) and (x, y) not in grave:
                            props.append((LAMP, x + 0.5, y + 0.02, 1))      # (as the Sprout Tower hangs them: on the face, a unit up)
                        emit('d15_wall01', OPT('d15_wall01'), [(x, 0, y, s0, 32, WALL_FOOT_C), (x + 1, 0, y, s1, 32, WALL_FOOT_C), (x + 1, hh, y, s1, 32 - hh, WALL_TOP_C), (x, hh, y, s0, 32 - hh, WALL_TOP_C)])
                        emit('h_kage', (3, 0, 12, 'h_kage_pl'), [(x, 0.3, y + 0.5, 8, x * 10.67), (x + 1, 0.3, y + 0.5, 8, (x + 1) * 10.67),
                                                                  (x + 1, 0.3, y, 16, (x + 1) * 10.67), (x, 0.3, y, 16, x * 10.67)])
                    for dx in (-1, 1):
                        if not beyond(x + dx, y): continue
                        xx = x + (0 if dx < 0 else 1)
                        s0, s1 = y * PANEL, (y + 1) * PANEL
                        hh = hgt(x + dx, y)
                        emit('d15_wall01', OPT('d15_wall01'), [(xx, 0, y, s0, 32, WALL_FOOT_C), (xx, 0, y + 1, s1, 32, WALL_FOOT_C), (xx, hh, y + 1, s1, 32 - hh, WALL_TOP_C), (xx, hh, y, s0, 32 - hh, WALL_TOP_C)])
                        if hh < WALL_H and beyond(x + dx, y - 1) and hgt(x + dx, y - 1) == WALL_H:     # (where a full wall steps down to a kerb: its end)
                            emit('d15_wall01', OPT('d15_wall01'), [(x + dx, hh, y, 0, 32 - hh), (x + dx + 1, hh, y, PANEL, 32 - hh), (x + dx + 1, WALL_H, y, PANEL, 32 - WALL_H), (x + dx, WALL_H, y, 0, 32 - WALL_H)])
                # the gravestones, the statues, the counter
                for x in range(X0, X1):
                    q = (x, y)
                    if q in grave: _stone(emit, x + 0.5, y + 0.5)
                    elif q in statue and (x, y - 1) not in statue: _stone(emit, x + 0.5, y + 1.3, 2.0)
                    elif q in counter: _box(emit, x, y, counter)
            # round a staircase going down, the floor up to its well
            for hx0, hz0, hx1, hz1, rx0, rz0, rx1, rz1 in holes:
                if not (X0 * 16 <= hx0 < X1 * 16 and Z0 * 16 <= hz0 < Z1 * 16): continue
                for sx0, sz0, sx1, sz1 in ((hx0, hz0, hx1, rz0), (hx0, rz1, hx1, hz1), (hx0, rz0, rx0, rz1), (rx1, rz0, hx1, rz1)):
                    if sx1 - sx0 < 0.5 or sz1 - sz0 < 0.5: continue
                    a, b, c, d = sx0 / 16, sx1 / 16, sz0 / 16, sz1 / 16
                    emit('d15_yuka01', OPT('d15_yuka01'), [(a, 0, d, a * 16, d * 16), (b, 0, d, b * 16, d * 16), (b, 0, c, b * 16, c * 16), (a, 0, c, a * 16, c * 16)])
            groups = [('hold%d' % i, 'd15_yuka01', pal_of('d15_yuka01'), Mesh(), {'repeat': 3, 'size': dims['d15_yuka01'], 'lit': False}) for i, _ in enumerate(anim)]
            for (t_, o), m in meshes.items():
                groups.append((t_[:16], t_, pal_of(t_, o), m, {'repeat': o[0], 'flip': o[1], 'alpha': o[2], 'size': dims[t_], 'lit': False}))
            model = build_model('cv_tower_%d' % (len(lands) + 10 * (int(spec['depth']) + 20)), groups)
            model += b'\0' * (-len(model) % 4)
            f4 = lambda v: int(round(v * 4096))
            U = lambda v, o: (v - o) * 16 - 256
            bld = b''.join(struct.pack('<I3i3i3i8x', m, f4(U(x, ox)), f4(yo[0] if yo else 0), f4(U(z_, oz)), 0, 0, 0, 4096, 4096, 4096)
                           for m, x, z_, *yo in props if X0 <= x < X1 and Z0 <= z_ < Z1)
            bdhc = struct.pack('<4s6H', b'BDHC', 2, 1, 1, 1, 1, 1) + struct.pack('<2i2i', -256 * 4096, -256 * 4096, 256 * 4096, 256 * 4096) + \
                struct.pack('<3i', 0, 4096, 0) + struct.pack('<i', 0) + struct.pack('<4H', 0, 1, 0, 0) + struct.pack('<iHH', 256 * 4096, 1, 0) + struct.pack('<H', 0)
            pm = struct.pack('<1024H', *perm)
            npoly = sum(len(m.quads) + len(m.tris) for m in meshes.values())
            print('  %s land %d: %d polygons, model %d bytes' % (spec['gba'], len(lands), npoly, len(model)))
            assert len(model) < 61400, ('model too big for a land', spec['gba'], len(model))
            lands.append(struct.pack('<4I2H', len(pm), len(bld), len(model), len(bdhc), 0x1234, 0) + pm + bld + model + bdhc)
    BI.USED_MODELS.setdefault(LOOK['area'], set()).update(m for m, *_ in props)
    return gm, (nx_, nz_), lands


def _box(emit, x, y, part):
    """a square of the counter: the Sprout Tower's boards on top, its wall's foot (the panelled wall's lowest band)
    down each side that is no counter"""
    T = 'd15_yuka01'; o = (3, 0, 31, 'd15_yuka01_pl')
    emit(T, o, [(x, COUNTER_H, y + 1, x * 16, y * 16 + 16), (x + 1, COUNTER_H, y + 1, x * 16 + 16, y * 16 + 16), (x + 1, COUNTER_H, y, x * 16 + 16, y * 16), (x, COUNTER_H, y, x * 16, y * 16)])
    o = (3, 0, 31, 'd15_wall01_pl')
    for dx, dz in ((0, 1), (0, -1), (1, 0), (-1, 0)):
        if (x + dx, y + dz) in part: continue
        if dz: zz = y + (1 if dz > 0 else 0); a, b = (x, zz), (x + 1, zz); s0 = x * PANEL
        else: xx = x + (1 if dx > 0 else 0); a, b = (xx, y), (xx, y + 1); s0 = y * PANEL
        emit('d15_wall01', o, [(a[0], 0, a[1], s0, 32), (b[0], 0, b[1], s0 + PANEL, 32), (b[0], COUNTER_H, b[1], s0 + PANEL, 32 - COUNTER_H), (a[0], COUNTER_H, a[1], s0, 32 - COUNTER_H)])
