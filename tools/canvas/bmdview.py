"""Read a map model's geometry (for learning how HeartGold builds its maps): shapes, their materials, vertices."""
import struct, sys, os
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
from nitro import read_dict, u16, u32

PARAMS = {0x10: 1, 0x11: 0, 0x12: 1, 0x13: 1, 0x14: 1, 0x15: 0, 0x16: 16, 0x17: 12, 0x18: 16, 0x19: 12, 0x1A: 9, 0x1B: 3, 0x1C: 3,
          0x20: 1, 0x21: 1, 0x22: 1, 0x23: 2, 0x24: 1, 0x25: 1, 0x26: 1, 0x27: 1, 0x28: 1, 0x29: 1, 0x2A: 1, 0x2B: 1,
          0x30: 1, 0x31: 1, 0x32: 1, 0x33: 1, 0x34: 32, 0x40: 1, 0x41: 0, 0x50: 1, 0x60: 1, 0x70: 3, 0x71: 2, 0x72: 1}


def s16(v): return v - 0x10000 if v & 0x8000 else v


def sx(v, bits): return v - (1 << bits) if v & (1 << (bits - 1)) else v


def dl_vertices(dl):
    """-> [(prim, [(x,y,z,s,t), ...])] in model units (before the model's position scale)"""
    out, cur, v, st = [], None, [0, 0, 0], (0, 0)
    i = 0
    while i + 4 <= len(dl):
        codes = dl[i:i + 4]; i += 4
        for c in codes:
            n = PARAMS.get(c, 0)
            p = [u32(dl, i + 4 * k) for k in range(n)]; i += 4 * n
            if c == 0x40: cur = (p[0], []); out.append(cur)
            elif c == 0x22: st = (sx(p[0] & 0xFFFF, 16) / 16, sx(p[0] >> 16, 16) / 16)
            elif c in (0x23, 0x24, 0x25, 0x26, 0x27, 0x28):
                if c == 0x23: v = [s16(p[0] & 0xFFFF) / 4096, s16(p[0] >> 16) / 4096, s16(p[1] & 0xFFFF) / 4096]
                elif c == 0x24: v = [sx(p[0] & 0x3FF, 10) / 64, sx((p[0] >> 10) & 0x3FF, 10) / 64, sx((p[0] >> 20) & 0x3FF, 10) / 64]
                elif c == 0x25: v = [s16(p[0] & 0xFFFF) / 4096, s16(p[0] >> 16) / 4096, v[2]]
                elif c == 0x26: v = [s16(p[0] & 0xFFFF) / 4096, v[1], s16(p[0] >> 16) / 4096]
                elif c == 0x27: v = [v[0], s16(p[0] & 0xFFFF) / 4096, s16(p[0] >> 16) / 4096]
                elif c == 0x28: v = [v[0] + sx(p[0] & 0x3FF, 10) / 4096, v[1] + sx((p[0] >> 10) & 0x3FF, 10) / 4096, v[2] + sx((p[0] >> 20) & 0x3FF, 10) / 4096]
                if cur: cur[1].append((*v, *st))
    return out


def model(blob):
    """BMD0 -> (scale, [(material name, texture name, [(prim, verts)])])"""
    mdl0 = u32(blob, 0x10)
    md = mdl0 + 8
    (name, e), = read_dict(blob, md)[:1]
    m = mdl0 + u32(e, 0)
    off_sbc, off_mat, off_shp = u32(blob, m + 4), u32(blob, m + 8), u32(blob, m + 12)
    info = m + 0x14
    pos_scale = struct.unpack_from('<i', blob, info + 8)[0] / 4096
    mats_o = m + off_mat
    mats = read_dict(blob, mats_o + 4)
    tex_dict = read_dict(blob, mats_o + u16(blob, mats_o))
    mat_tex = {}
    for tn, te in tex_dict:
        lo, n = u16(te, 0), te[2]
        for k in range(n): mat_tex[blob[mats_o + lo + k]] = tn.decode()
    shps_o = m + off_shp
    shps = read_dict(blob, shps_o)
    shape_dl = []
    for sn, se in shps:
        h = shps_o + u32(se, 0)
        dlo, dll = u32(blob, h + 8), u32(blob, h + 12)
        shape_dl.append(blob[h + dlo:h + dlo + dll])
    # sbc: MAT then SHP pairs
    sbc = blob[m + off_sbc:m + off_mat]
    pairs, cur_mat, i = [], None, 0
    while i < len(sbc):
        c = sbc[i] & 0x1F
        if c == 0x04: cur_mat = sbc[i + 1]; i += 2
        elif c == 0x05: pairs.append((cur_mat, sbc[i + 1])); i += 2
        elif c == 0x01: break
        elif c == 0x02: i += 3
        elif c == 0x03: i += 2
        elif c == 0x06: i += 4 + (4 if sbc[i] >> 5 else 0) if False else 4
        elif c == 0x0B: i += 1
        elif c == 0x26 & 0x1F: i += 5
        elif c == 0x09: i += 2 + 3 * sbc[i + 2]
        else: i += 1
    out = []
    for mi, si in pairs:
        out.append((mats[mi][0].decode() if mi is not None and mi < len(mats) else '?', mat_tex.get(mi, '?'), dl_vertices(shape_dl[si])))
    return pos_scale, out
