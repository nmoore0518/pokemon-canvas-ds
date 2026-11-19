"""Canvas map viewer: export what the ROM builds - every map you can get to from Pallet, as its lands, the buildings
and furniture standing on them, and its people, signs and warps - for viewer/index.html to fly round in a browser.

    python3 tools/canvas/viewer/export.py OUT_DIR

Writes OUT_DIR/maps.json (the list) and OUT_DIR/m/<map>.txt (base64), one file a map (Kanto's overworld in strips):

    'CVM1', u32 header length, header (JSON), padding to 4, then the blobs the header points into:
    header = {name, title, group, origin: [x, z], size: [w, h],
              textures: [{w, h, at, len}]              (PNG files),
              materials: [{tex, color, wrap: [s, t], alpha, test, at, count}]   (vertices: 5 int16 each:
                                                         x, y, z in 1/32 squares from origin, s, t in 1/8 texels),
              people: [{x, z, sprite, tex, id, script}], signs: [{x, z}], warps: [{x, z, to}], triggers: [{x, z, w, h}]}

Coordinates are the map's own squares (the overworld's: HeartGold's world squares), so a square in the viewer is the
square in the game's event files and in what Claude's tools print."""
import base64, collections, hashlib, io, json, os, re, struct, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, '..'))
import bmdview, slots, world
from nitro import read_narc, read_dict, tex0_of, u16, u32
from texview import decode
from interior_kit import _materials, _colours
from PIL import Image

ROOT = slots.ROOT
F = lambda p: os.path.join(ROOT, p)
Q = 32                  # positions: 1/32 square
QT = 8                  # texture coordinates: 1/8 texel


def narc(p):
    return read_narc(open(F(p), 'rb').read())[0]


AREAS, SETS, ATEX, TEXSETS = narc('files/a/0/4/2'), narc('files/a/0/4/3'), narc('files/a/0/7/0'), narc('files/a/0/4/4')
BM_OUT, BM_ROOM = narc('files/a/0/4/0'), narc('files/a/1/4/8')
LANDS = world.lands()


def area_of(m):
    a = AREAS[int(slots.header(m)['areaDataBank'])]
    return u16(a, 0), u16(a, 2), a[7] == 1          # building set, texture set, outdoors


def tex_table(blob):
    """name -> (prm, data, comp, palette by name -> bytes, and the palette block from each entry on (4x4 textures))"""
    t = tex0_of(blob)
    if t is None: return {}, {}
    tex_data = t + u32(blob, t + 0x14)
    comp_data, comp_info = t + u32(blob, t + 0x24), t + u32(blob, t + 0x28)
    pal_data = t + u32(blob, t + 0x38)
    pal_size = (u32(blob, t + 0x30) & 0xFFFF) << 3
    texs = {}
    for nm, e in read_dict(blob, t + u16(blob, t + 0xE)):
        prm = struct.unpack_from('<I', e, 0)[0]
        w, h, fmt = 8 << ((prm >> 20) & 7), 8 << ((prm >> 23) & 7), (prm >> 26) & 7
        off = (prm & 0xFFFF) << 3
        size = w * h * {0: 0, 1: 8, 2: 2, 3: 4, 4: 8, 5: 2, 6: 8, 7: 16}[fmt] // 8
        if fmt == 5: texs[nm.decode()] = (prm, blob[comp_data + off:comp_data + off + size], blob[comp_info + off // 2:comp_info + off // 2 + size // 2])
        else: texs[nm.decode()] = (prm, blob[tex_data + off:tex_data + off + size], b'')
    pals = {}
    ents = [(nm.decode(), u16(e, 0) << 3) for nm, e in read_dict(blob, t + u32(blob, t + 0x34))]
    offs = sorted({o for _, o in ents} | {pal_size})
    for nm, o in ents:
        pals[nm] = (blob[pal_data + o:pal_data + offs[offs.index(o) + 1]], blob[pal_data + o:pal_data + pal_size])
    return texs, pals


_tt = {}


def tex_of(key, blob):
    if key not in _tt: _tt[key] = tex_table(blob)
    return _tt[key]


_png = {}


def texture_png(texs, pals, name, pal):
    """PNG bytes of a texture (with the palette its material names), or None"""
    if name not in texs: return None
    prm, data, comp = texs[name]
    p = pals.get(pal) or pals.get(name + '_pl') or pals.get(name) or next(iter(pals.values()), (b'', b''))
    key = (hashlib.md5(data + comp).hexdigest(), hashlib.md5(p[1]).hexdigest(), prm)
    if key not in _png:
        try:
            im = decode(prm, data, comp, p[1] if (prm >> 26) & 7 == 5 else p[0])
        except Exception:
            im = None
        if im is None: _png[key] = None
        else:
            b = io.BytesIO(); im.save(b, 'PNG', optimize=True); _png[key] = (b.getvalue(), im.size, (prm >> 26) & 7, (prm >> 29) & 1)
    return _png[key]


class Mesh:
    """materials -> vertex lists, and the textures they use"""
    def __init__(self, origin):
        self.ox, self.oz = origin
        self.mats = collections.OrderedDict()       # key -> {tex, color, wrap, alpha, test, verts}
        self.textures, self.tex_index = [], {}

    def texture(self, png):
        k = hashlib.md5(png[0]).hexdigest()
        if k not in self.tex_index:
            self.tex_index[k] = len(self.textures); self.textures.append(png)
        return self.tex_index[k]

    def add_model(self, blob, texs, pals, place, colour_key):
        """a model's triangles; place(x, y, z) -> squares (x, y, z)"""
        try:
            sc, shapes = bmdview.model(blob)
            mats = _materials(blob)
        except Exception:
            return
        cols = None
        for mat, tex, prims in shapes:
            rep, flip, alpha, pal = mats.get(mat, (3, 0, 31, None))
            if alpha == 0: continue
            png = texture_png(texs, pals, tex, pal) if tex != '?' else None
            if png is None:
                if cols is None:
                    try: cols = _colours(blob)
                    except Exception: cols = {}
                key = ('c', cols.get(mat, (200, 200, 200)), alpha)
                m = self.mats.setdefault(key, dict(tex=-1, color=cols.get(mat, (200, 200, 200)), wrap=[0, 0], alpha=alpha, test=0, verts=[], size=(8, 8)))
            else:
                ti = self.texture(png)
                wrap = [(1 if rep & 1 else 0) + (1 if flip & 1 and rep & 1 else 0), (1 if rep & 2 else 0) + (1 if flip & 2 and rep & 2 else 0)]
                test = 1 if png[2] in (1, 6) or png[3] else 0
                key = ('t', ti, tuple(wrap), alpha)
                m = self.mats.setdefault(key, dict(tex=ti, color=None, wrap=wrap, alpha=alpha, test=test, verts=[], size=png[1]))
            for prim, vs in prims:
                P = [place(v[0] * sc, v[1] * sc, v[2] * sc) + (v[3], v[4]) for v in vs]
                if prim == 0: tris = [P[i:i + 3] for i in range(0, len(P) - 2, 3)]
                elif prim == 1: tris = [t for i in range(0, len(P) - 3, 4) for t in ([P[i], P[i + 1], P[i + 2]], [P[i], P[i + 2], P[i + 3]])]
                elif prim == 2: tris = [[P[i], P[i + 1], P[i + 2]] if i % 2 == 0 else [P[i + 1], P[i], P[i + 2]] for i in range(len(P) - 2)]
                else: tris = [t for i in range(0, len(P) - 3, 2) for t in ([P[i], P[i + 1], P[i + 3]], [P[i], P[i + 3], P[i + 2]])]
                for t in tris: m['verts'] += t

    def blobs(self):
        """(header materials, textures, vertex bytes)"""
        out, buf = [], bytearray()
        clamp = lambda v: max(-32768, min(32767, int(round(v))))
        for m in self.mats.values():
            at = len(buf) // 10
            for x, y, z, s, t in m['verts']:
                buf += struct.pack('<5h', clamp((x - self.ox) * Q), clamp(y * Q), clamp((z - self.oz) * Q), clamp(s * QT), clamp(t * QT))
            out.append(dict(tex=m['tex'], color=m['color'], wrap=m['wrap'], alpha=m['alpha'], test=m['test'], at=at, count=len(m['verts'])))
        return out, buf


def place_land(lx, lz, alt=0):
    """land model units -> squares, for the land at matrix cell (lx, lz)"""
    return lambda x, y, z: ((x + 256) / 16 + lx * 32, (y + alt) / 16, (z + 256) / 16 + lz * 32)


def add_land(mesh, lid, lx, lz, area, alt=0):
    bset, tset, outdoors = area
    land = LANDS[lid]
    ps, bs, ms, hs, mg, ss = struct.unpack_from('<4I2H', land, 0)
    if mg != 0x1234: ss = 0
    o = 0x14 + ss + ps + bs
    texs, pals = tex_of(('set', tset), TEXSETS[tset])
    mesh.add_model(land[o:o + ms], texs, pals, place_land(lx, lz, alt), None)
    # the buildings and furniture standing on it
    bm = BM_OUT if outdoors else BM_ROOM
    atex = tex_of(('atex', bset), ATEX[bset]) if bset < len(ATEX) else ({}, {})
    for i in range(bs // 48):
        mid, px, py, pz, rx, ry, rz, sx, sy, sz = struct.unpack_from('<I3i3i3i', land, 0x14 + ss + ps + i * 48)
        if mid >= len(bm) or not bm[mid]: continue
        own = tex_of(('bm', outdoors, mid), bm[mid])
        texs = dict(atex[0]); texs.update(own[0])
        pals = dict(atex[1]); pals.update(own[1])
        X, Y, Z = px / 4096, py / 4096, pz / 4096
        k = (sx / 4096 or 1, sy / 4096 or 1, sz / 4096 or 1)
        ang = ry / 65536 * 6.283185307179586 if abs(ry) > 16 else 0.0
        import math
        ca, sa = math.cos(ang), math.sin(ang)

        def place(x, y, z, X=X, Y=Y, Z=Z, k=k, ca=ca, sa=sa):
            x, y, z = x * k[0], y * k[1], z * k[2]
            x, z = x * ca + z * sa, -x * sa + z * ca
            return place_land(lx, lz, alt)(x + X, y + Y, z + Z)
        mesh.add_model(bm[mid], texs, pals, place, None)


# ---------------------------------------------------------------- people
SPRITES = {n: int(v) for n, v in re.findall(r'#define (SPRITE_\w+)\s+(\d+)', open(F('include/constants/sprites.h')).read())}
_table = open(F('engine/src/field/overworld_table.c')).read()
TAG_GFX = {int(t): int(g) for t, g in re.findall(r'\{ \.tag = (\d+), \.gfx = (\d+),', _table)}
for n, g in re.findall(r'\{ \.tag = NEW_NPC_TAG_START \+ (\d+), \.gfx = NEW_NPC_GFX_START \+ (\d+)', _table):
    TAG_GFX[7000 + int(n)] = 297 + int(g)
for t, sp in re.findall(r'\{ \.tag = (\d+), \.gfx = MON_OVERWORLD_GFX_START \+ SPECIES_(\w+)', _table):
    TAG_GFX[int(t)] = 'mon:' + sp.lower()
SPECIES = {int(v): n.lower() for n, v in re.findall(r'#define SPECIES_(\w+)\s+(\d+)\b', open(F('engine/include/constants/species.h')).read())}
OW = F('engine/data/graphics/overworlds')
_sprite = {}


def mon_path(tag):
    """a Pokemon's overworld picture: HeartGold's own standing ones by their tags, hg-engine's (2500 + species)"""
    g = TAG_GFX.get(tag)
    name = g[4:] if isinstance(g, str) else SPECIES.get(tag - 2500) if tag and tag >= 2500 else None
    if not name: return None
    p = F('engine/data/graphics/sprites/%s/overworld.png' % name)
    return p if os.path.exists(p) else None


def sprite_png(sprite):
    """a person's picture facing you (HeartGold's overworld frame 9 of 12+, else its first), 32x32 PNG, or None"""
    tag = SPRITES.get(sprite) if not str(sprite).lstrip('-').isdigit() else int(sprite)
    gfx = TAG_GFX.get(tag)
    mon = mon_path(tag)
    if mon: path = mon
    elif not isinstance(gfx, int): return None
    else: path = os.path.join(OW, '%04d.png' % gfx) if gfx < 297 else os.path.join(OW, 'custom', '%04d.png' % (gfx - 297))
    if not os.path.exists(path): return None
    if path not in _sprite:
        im = Image.open(path); im.info['transparency'] = 0; im = im.convert('RGBA')
        fw = 32 if im.width >= 32 else im.width
        n = im.height // fw
        f = 2 if mon else 9 if n >= 12 else 0       # (facing you: a person's tenth picture, a Pokemon's third)
        im = im.crop((0, f * fw, fw, f * fw + fw))
        b = io.BytesIO(); im.save(b, 'PNG'); _sprite[path] = (b.getvalue(), im.size, 1, 1)
    return _sprite[path]


def add_events(mesh, m, head, origin=(0, 0), only=None):
    try: ev = json.load(open(os.path.join(slots.EVENT_DIR, slots.events_file(m))))
    except Exception: return
    keep = (lambda x, z: True) if only is None else only
    for o in ev.get('objects', []):
        if not keep(o['x'], o['z']): continue
        png = sprite_png(o['spriteId'])
        head['people'].append(dict(x=o['x'], z=o['z'], sprite=str(o['spriteId']).replace('SPRITE_', ''), id=str(o['id']),
                                   script=str(o.get('scriptId', '')).replace('_EV_', '').replace(' + 1', ''),
                                   tex=mesh.texture(png) if png else -1, map=m))
    for b in ev.get('bgs', []):
        if keep(b['x'], b['z']): head['signs'].append(dict(x=b['x'], z=b['z'], map=m))
    for w in ev.get('warps', []):
        if keep(w['x'], w['z']): head['warps'].append(dict(x=w['x'], z=w['z'], to=str(w.get('header')), map=m))
    for c in ev.get('coords', []):
        if keep(c['x'], c['z']): head['triggers'].append(dict(x=c['x'], z=c['z'], w=c.get('w', 1), h=c.get('h', 1), map=m))


_gba_of = {}


def gba_names():
    """HeartGold map -> the GBA map built in it (the porter's table)"""
    if not _gba_of:
        sys.path.insert(0, os.path.join(HERE, '..', 'port'))
        import contextlib
        with contextlib.redirect_stdout(io.StringIO()):
            import port_map as PM
        for d, v in PM.MAPS.items():
            if isinstance(v[0], str) and v[0].startswith('MAP_') and 'EVERYWHERE' not in slots.header(v[0]).get('matrixId', ''):
                _gba_of.setdefault(v[0], d)
    return _gba_of


def title_of(m):
    g = gba_names().get(m)
    if g:
        t = re.sub(r'_Frlg$', '', g)
        t = re.sub(r'(?<=[a-z0-9])(?=[A-Z])', ' ', t).replace('_', ' ')
        t = re.sub(r'(\d) F\b', r'\1F', t)
        t = re.sub(r'(?<=[a-z])(?=\d)', ' ', t)
        return t.replace('S S Anne', 'S.S. Anne').replace('SSAnne', 'S.S. Anne').replace('Pokemon', 'Pokémon')
    t = m.replace('MAP_CANVAS_', '').replace('MAP_', '').replace('_', ' ').title()
    return re.sub(r'\b(\d+)F\b', r'\1F', t.replace('Ssanne', 'S.S. Anne').replace(' Pokecenter', ' Pokémon Center'))


def write(out, name, head, mesh):
    mats, verts = mesh.blobs()
    blob = bytearray()
    texs = []
    for png, (w, h), *_ in mesh.textures:
        texs.append(dict(w=w, h=h, at=len(blob), len=len(png))); blob += png
        blob += b'\0' * (-len(blob) % 4)
    vat = len(blob); blob += verts
    head.update(textures=texs, materials=mats, vertices=vat)
    hj = json.dumps(head, separators=(',', ':')).encode()
    hj += b' ' * (-len(hj) % 4)
    # (base64 text: published pages serve no plain binary files)
    with open(os.path.join(out, 'm', name + '.txt'), 'wb') as f:
        f.write(base64.b64encode(b'CVM1' + struct.pack('<I', len(hj)) + hj + blob))
    return os.path.getsize(os.path.join(out, 'm', name + '.txt'))


# HeartGold's own maps to look at beside ours (its ledges, towns, routes)
HG_REFERENCE = [('MAP_ROUTE_29', 'Route 29'), ('MAP_ROUTE_45', 'Route 45'), ('MAP_ROUTE_46', 'Route 46')]


HG_KANTO = [('MAP_PALLET', 'Pallet Town'), ('MAP_ROUTE_1', 'Route 1'), ('MAP_VIRIDIAN', 'Viridian City'),
            ('MAP_ROUTE_22', 'Route 22'), ('MAP_ROUTE_2', 'Route 2'), ('MAP_PEWTER', 'Pewter City'),
            ('MAP_ROUTE_3', 'Route 3'), ('MAP_ROUTE_4', 'Route 4'), ('MAP_CERULEAN', 'Cerulean City'),
            ('MAP_ROUTE_24', 'Route 24'), ('MAP_ROUTE_25', 'Route 25'), ('MAP_ROUTE_9', 'Route 9'),
            ('MAP_ROUTE_10', 'Route 10'), ('MAP_LAVENDER', 'Lavender Town'), ('MAP_ROUTE_12', 'Route 12'),
            ('MAP_VERMILION', 'Vermilion City'), ('MAP_SAFFRON', 'Saffron City'), ('MAP_CELADON', 'Celadon City'),
            ('MAP_FUCHSIA', 'Fuchsia City'), ('MAP_ROUTE_15', 'Route 15')]


def export_hg_kanto(out, listing):
    """HeartGold's own Kanto maps, read out of the commit that still had them"""
    global AREAS, ATEX, TEXSETS, BM_OUT, LANDS
    import build_overworld as O
    G = lambda p: read_narc(O._git(F(p)))[0]
    keep = AREAS, ATEX, TEXSETS, BM_OUT, LANDS
    AREAS, ATEX, TEXSETS, BM_OUT, LANDS = G('files/a/0/4/2'), G('files/a/0/7/0'), G('files/a/0/4/4'), G('files/a/0/4/0'), G('files/a/0/6/5')
    _tt.clear()
    d = O._git(os.path.join(slots.MATRIX_DIR, 'map_matrix_0000_EVERYWHERE.bin'))
    w0, h0, hh, ha, nl = d[:5]
    p = 5 + nl
    hdr = struct.unpack_from('<%dH' % (w0 * h0), d, p); p += 2 * w0 * h0
    alt = d[p:p + w0 * h0]; p += w0 * h0
    ls = struct.unpack_from('<%dH' % (w0 * h0), d, p)
    heads = O._git(F('src/data/map_headers.h')).decode()
    ids = {n: int(v) for n, v in re.findall(r'#define (MAP_\w+)\s+(\d+)', open(slots.MAPS_H).read())}
    try:
        for m, title in HG_KANTO:
            cells = [(i % w0, i // w0) for i in range(w0 * h0) if hdr[i] == ids[m] and ls[i] != 0xFFFF]
            if not cells: continue
            ad = int(re.search(r'\[%s\] = \{.*?\.areaDataBank = (\d+)' % m, heads, re.S).group(1))
            a = AREAS[ad]; area = (u16(a, 0), u16(a, 2), a[7] == 1)
            cx0, cz0 = min(c[0] for c in cells), min(c[1] for c in cells)
            cx1, cz1 = max(c[0] for c in cells) + 1, max(c[1] for c in cells) + 1
            mesh = Mesh((cx0 * 32, cz0 * 32))
            head = dict(people=[], signs=[], warps=[], triggers=[])
            for cx, cz in cells:
                i = cz * w0 + cx
                add_land(mesh, ls[i], cx, cz, area, alt[i] * 8 if alt[i] < 128 else (alt[i] - 256) * 8)
            name = 'hgk_' + m.replace('MAP_', '').lower()
            head.update(name=name, origin=[cx0 * 32, cz0 * 32], size=[(cx1 - cx0) * 32, (cz1 - cz0) * 32])
            size = write(out, name, head, mesh)
            listing.append(dict(name=name, title="HeartGold's own " + title, group="HeartGold's own Kanto (to compare)", file=name, size=head['size'], bytes=size, map=m))
    finally:
        AREAS, ATEX, TEXSETS, BM_OUT, LANDS = keep
        _tt.clear()


def reachable():
    sys.argv = [sys.argv[0], '--return']
    sys.path.insert(0, os.path.join(HERE, '..', 'test'))
    import reach_all as R
    fwd = R.main()[0]
    return sorted({k[0] for k in fwd} - {'WORLD'})


def group_of(m):
    if 'SILPH' in m: return 'Silph Co.'
    if 'SSANNE' in m: return 'S.S. Anne'
    if any(k in m for k in ('CAVE', 'MT_MOON', 'ROCK_TUNNEL', 'SEAFOAM', 'VICTORY', 'DIGLETT')): return 'Caves'
    if 'SAFARI' in m: return 'Safari Zone'
    if any(k in m for k in ('MANSION', 'TOWER', 'HIDEOUT', 'POWER_PLANT', 'GAME_CORNER', 'PRIZE')): return 'Dungeons and big buildings'
    if 'ACADEMY' in m: return 'Leader Academy'
    if any(k in m for k in ('POKECENTER', 'POKEMART', 'GYM', 'GATEHOUSE', 'MART')): return 'Centers, Marts, Gyms, gates'
    return 'Houses and rooms'


def main():
    out = sys.argv[1]
    os.makedirs(os.path.join(out, 'm'), exist_ok=True)
    listing = []
    # Kanto's overworld, in strips of cells (each its own file, loaded as the camera nears it)
    import build_overworld as O
    w0, h0, hdr, alt, ls = world.matrix()
    names = {v: k for k, v in ((n, int(v)) for n, v in re.findall(r'#define (MAP_\w+)\s+(\d+)', open(slots.MAPS_H).read()))}
    x0, z0 = O.ORIGIN
    strips = []
    for sz in range(0, O.CELLS[1], 3):
        rows = range(z0 + sz, z0 + min(O.CELLS[1], sz + 3))
        mesh = Mesh((x0 * 32, rows[0] * 32))
        head = dict(people=[], signs=[], warps=[], triggers=[])
        maps_here = set()
        for cz in rows:
            for cx in range(x0, x0 + O.CELLS[0]):
                i = cz * w0 + cx
                if ls[i] == 0xFFFF: continue
                m = names.get(hdr[i])
                if not m: continue
                maps_here.add(m)
                add_land(mesh, ls[i], cx, cz, area_of(m), alt[i] * 8 if alt[i] < 128 else (alt[i] - 256) * 8)
        zlo, zhi = rows[0] * 32, (rows[-1] + 1) * 32
        for m in sorted(maps_here):
            add_events(mesh, m, head, only=lambda x, z: zlo <= z < zhi)
        name = 'kanto_%02d' % sz
        head.update(name=name, origin=[x0 * 32, rows[0] * 32], size=[O.CELLS[0] * 32, len(rows) * 32])
        size = write(out, name, head, mesh)
        strips.append(dict(file=name, origin=head['origin'], size=head['size'], bytes=size))
        print(name, size, 'bytes', sum(len(m['verts']) for m in mesh.mats.values()) // 3, 'triangles')
    # HeartGold's own (Johto's lands are untouched): to compare ours with
    ids = {v: k for k, v in names.items()}
    for m, title in HG_REFERENCE:
        cells = [(i % w0, i // w0) for i in range(w0 * h0) if hdr[i] == ids[m] and ls[i] != 0xFFFF]
        if not cells: continue
        cx0, cz0 = min(c[0] for c in cells), min(c[1] for c in cells)
        cx1, cz1 = max(c[0] for c in cells) + 1, max(c[1] for c in cells) + 1
        mesh = Mesh((cx0 * 32, cz0 * 32))
        head = dict(people=[], signs=[], warps=[], triggers=[])
        for cx, cz in cells:
            i = cz * w0 + cx
            add_land(mesh, ls[i], cx, cz, area_of(m), alt[i] * 8 if alt[i] < 128 else (alt[i] - 256) * 8)
        add_events(mesh, m, head)
        name = 'hg_' + m.replace('MAP_', '').lower()
        head.update(name=name, origin=[cx0 * 32, cz0 * 32], size=[(cx1 - cx0) * 32, (cz1 - cz0) * 32])
        size = write(out, name, head, mesh)
        listing.append(dict(name=name, title='HeartGold: ' + title, group='HeartGold\'s Johto (to compare)', file=name, size=head['size'], bytes=size, map=m))
    # HeartGold's own Kanto, as it was before ours (O.HG_REV): its towns and routes beside ours
    export_hg_kanto(out, listing)
    gmaps = {d: v for d, v in json.load(open(O.WORLD_JSON))['maps'].items()}
    listing.append(dict(name='kanto', title='Kanto (overworld)', group='Overworld', strips=strips, world=True,
                        start=[1039, 380], gba={d: v[:4] for d, v in gmaps.items()}))
    # every room, cave and building you can get into
    for m in reachable():
        try: w, h, lands = world.map_matrix(m)
        except Exception: continue
        mesh = Mesh((0, 0))
        head = dict(people=[], signs=[], warps=[], triggers=[])
        area = area_of(m)
        for k, lid in enumerate(lands):
            if lid == 0xFFFF or lid >= len(LANDS): continue
            add_land(mesh, lid, k % w, k // w, area)
        add_events(mesh, m, head)
        name = m.replace('MAP_', '').lower()
        head.update(name=name, origin=[0, 0], size=[w * 32, h * 32])
        size = write(out, name, head, mesh)
        listing.append(dict(name=name, title=title_of(m), group=group_of(gba_names().get(m, m).upper()), file=name, size=[w * 32, h * 32], bytes=size, map=m))
    json.dump(listing, open(os.path.join(out, 'maps.json'), 'w'), indent=0)
    print(len(listing), 'maps,', sum(l.get('bytes', 0) + sum(s['bytes'] for s in l.get('strips', [])) for l in listing), 'bytes')


if __name__ == '__main__':
    main()
