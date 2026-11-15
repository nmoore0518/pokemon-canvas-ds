"""A minimal NSBMD (BMD0) writer for static map models: one node, one material per texture, one shape per material.

Positions are in world units (16 to a block). The model is drawn with a 64x position scale, as HeartGold's map
models are, so a 32-block land (+-256 units) fits the DS's 16-bit vertex range."""
import struct
from nitro import build_dict, pad4

FX = 4096
POS_SCALE = 64
BOX_SCALE = 128


def fx16(v):
    return max(-32768, min(32767, int(round(v * FX))))


def normal10(n):
    def c(v):
        return int(round(max(-1, min(0.998, v)) * 512)) & 0x3FF
    return c(n[0]) | (c(n[1]) << 10) | (c(n[2]) << 20)


class Mesh:
    """Quads and triangles for one material: each vertex (pos units xyz, uv in texels, normal)"""
    def __init__(self):
        self.quads, self.tris = [], []

    def quad(self, verts, normal):
        self.quads.append((verts, normal))

    def tri(self, verts, normal):
        self.tris.append((verts, normal))


def display_list(mesh):
    ops = []
    for prim, items in ((1, mesh.quads), (0, mesh.tris)):
        if not items:
            continue
        ops.append((0x40, [prim]))
        last_n = None
        for verts, n in items:
            nn = normal10(n)
            if nn != last_n:
                ops.append((0x21, [nn])); last_n = nn
            for (x, y, z), (s, t) in verts:
                ss, tt = int(round(s * 16)), int(round(t * 16))
                assert -32768 <= ss < 32768 and -32768 <= tt < 32768, (s, t)
                ops.append((0x22, [(ss & 0xFFFF) | ((tt & 0xFFFF) << 16)]))
                # VTX_10 (6 fraction bits: one world unit at our scale) when it fits, else VTX_16
                q = [int(round(c / POS_SCALE * 64)) for c in (x, y, z)]
                if all(-512 <= c < 512 for c in q):
                    ops.append((0x24, [(q[0] & 0x3FF) | ((q[1] & 0x3FF) << 10) | ((q[2] & 0x3FF) << 20)]))
                else:
                    vx, vy, vz = fx16(x / POS_SCALE), fx16(y / POS_SCALE), fx16(z / POS_SCALE)
                    ops.append((0x23, [(vx & 0xFFFF) | ((vy & 0xFFFF) << 16), vz & 0xFFFF]))
        ops.append((0x41, []))
    out = bytearray()
    for i in range(0, len(ops), 4):
        chunk = ops[i:i + 4]
        codes = [c for c, _ in chunk] + [0] * (4 - len(chunk))
        out += bytes(codes)
        for _, prm in chunk:
            for p in prm:
                out += struct.pack('<I', p & 0xFFFFFFFF)
    return bytes(out)


def material_data(repeat=3, flip=0, alpha=31, both_faces=True, size=(0, 0)):
    poly = 0x01 | (0xC0 if both_faces else 0x80) | (alpha << 16)
    teximg = (1 << 30) | (repeat << 16) | (flip << 18)
    return struct.pack('<HHIIIIIIHHHHii', 0, 0x2C, 0x7FFFE739, 0, poly, 0x3F1FF8FF, teximg, 0xFFFFFFFF,
                       0, 0x1FCF | (0x10 if size[0] else 0), size[0], size[1], FX, FX)


def build_model(name, groups):
    """groups: [(material name, texture name, palette name, Mesh, opts dict)] -> BMD0 bytes.
    Every group becomes a material, in order (HeartGold animates map materials by index, so an empty
    group can hold a place); only groups with geometry get a shape."""
    nmat = len(groups)
    drawn = [i for i, g in enumerate(groups) if g[3].quads or g[3].tris]
    nshp = len(drawn)
    # ---- render commands
    sbc = bytearray(b'\x26\x00\x00\x00\x00' + b'\x02\x00\x01' + b'\x0b')
    for k, i in enumerate(drawn):
        sbc += bytes([0x04, i, 0x05, k])
    sbc += b'\x2b\x01'
    sbc = pad4(bytes(sbc))
    # ---- nodes
    node_dict = build_dict([(b'canvas_root', struct.pack('<I', 0))], 4)
    nodes = bytearray(node_dict)
    nodes[len(node_dict) - 16 - 4:len(node_dict) - 16] = struct.pack('<I', len(node_dict))   # entry -> node data
    nodes = bytes(nodes) + bytes.fromhex('07f80010')
    nodes = pad4(nodes)
    # ---- materials: header, dicts, index lists, data
    mat_names = [g[0].encode() for g in groups]

    def tex_pairs(which):
        order, seen = [], {}
        for i, g in enumerate(groups):
            k = g[which].encode()
            if k not in seen:
                seen[k] = []; order.append(k)
            seen[k].append(i)
        return order, seen
    tex_order, tex_map = tex_pairs(1)
    pal_order, pal_map = tex_pairs(2)
    # sizes first (the dict entries hold offsets)
    mdict_len = len(build_dict([(n, b'\0' * 4) for n in mat_names], 4))
    tdict_len = len(build_dict([(n, b'\0' * 4) for n in tex_order], 4))
    pdict_len = len(build_dict([(n, b'\0' * 4) for n in pal_order], 4))
    p = 4 + mdict_len + tdict_len + pdict_len
    lists = bytearray()
    tex_ent, pal_ent = [], []
    for order, mp, ent in ((tex_order, tex_map, tex_ent), (pal_order, pal_map, pal_ent)):
        for k in order:
            ent.append((k, struct.pack('<HBB', p + len(lists), len(mp[k]), 0)))
            lists += bytes(mp[k])
    lists = bytes(lists) + b'\0' * (-(p + len(lists)) % 4)
    data_start = p + len(lists)
    mdata = b''
    mat_ent = []
    for i, g in enumerate(groups):
        mat_ent.append((mat_names[i], struct.pack('<I', data_start + len(mdata))))
        mdata += material_data(**g[4])
    mats = struct.pack('<HH', 4 + mdict_len, 4 + mdict_len + tdict_len) + build_dict(mat_ent, 4) + \
        build_dict(tex_ent, 4) + build_dict(pal_ent, 4) + lists + mdata
    mats = pad4(mats)
    # ---- shapes
    dls = [display_list(groups[i][3]) for i in drawn]
    sdict_len = len(build_dict([(b'p%d' % i, b'\0' * 4) for i in range(nshp)], 4))
    hdr_start = sdict_len
    shp_ent, heads = [], b''
    dl_start = hdr_start + 16 * nshp
    dl_off = 0
    for i, dl in enumerate(dls):
        h = hdr_start + 16 * i
        shp_ent.append((b'p%d' % i, struct.pack('<I', h)))
        heads += struct.pack('<HHIII', 0, 0x10, 0x05, dl_start + dl_off - h, len(dl))
        dl_off += len(dl)
    shps = build_dict(shp_ent, 4) + heads + b''.join(dls)
    # ---- info
    allv = [v[0] for g in groups for items in (g[3].quads, g[3].tris) for verts, _ in items for v in verts]
    nq = sum(len(g[3].quads) for g in groups)
    nt = sum(len(g[3].tris) for g in groups)
    mn = [min(v[k] for v in allv) for k in range(3)]
    mx = [max(v[k] for v in allv) for k in range(3)]
    box = [fx16(mn[k] / BOX_SCALE) for k in range(3)] + [fx16((mx[k] - mn[k]) / BOX_SCALE) for k in range(3)]
    info = struct.pack('<8B2i4H6h2i', 0, 0, 0, 1, nmat, nshp, 1, 0, POS_SCALE * FX, FX // POS_SCALE,
                       min(65535, 4 * nq + 3 * nt), nq + nt, nt, nq, *box, BOX_SCALE * FX, FX // BOX_SCALE)
    off_sbc = 0x40 + len(nodes)
    off_mat = off_sbc + len(sbc)
    off_shp = off_mat + len(mats)
    size = off_shp + len(shps)
    model = struct.pack('<5I', size, off_sbc, off_mat, off_shp, size) + info + nodes + sbc + mats + shps
    assert len(struct.pack('<5I', 0, 0, 0, 0, 0) + info) == 0x40
    # ---- MDL0 and BMD0
    md = build_dict([(name.encode(), struct.pack('<I', 0))], 4)
    md = bytearray(md)
    md[len(md) - 16 - 4:len(md) - 16] = struct.pack('<I', 8 + len(md))
    mdl0 = b'MDL0' + struct.pack('<I', 8 + len(md) + len(model)) + bytes(md) + model
    return b'BMD0' + struct.pack('<HHIHHI', 0xFFFE, 0x0002, 0x14 + len(mdl0), 0x10, 1, 0x14) + mdl0
