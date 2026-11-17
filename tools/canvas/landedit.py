"""Take pieces out of one of HeartGold's own land models, in place (the model keeps its size): for a land of
theirs that stands beside one we rebuilt and still draws what used to be next to it (a shoreline's foam along a
beach that is gone, say).

    strip(land_bytes, drop) -> (land_bytes, how many faces went)

drop(texture, [(x, y, z), ...]) is asked about every triangle and quad (and every strip, whole), in the land's
units; True takes it out."""
import struct, sys, os
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
from nitro import read_dict, u16, u32
from bmdview import PARAMS, s16, sx

VTX = (0x23, 0x24, 0x25, 0x26, 0x27, 0x28)
PER = {0: 3, 1: 4}                     # vertices a face of independent triangles / quads


def _parse(dl):
    """-> [(command, [params])], stopping at the list's trailing padding"""
    out, i = [], 0
    while i + 4 <= len(dl):
        codes = dl[i:i + 4]; i += 4
        for c in codes:
            n = PARAMS.get(c, 0)
            out.append((c, [u32(dl, i + 4 * k) for k in range(n)])); i += 4 * n
    while out and out[-1][0] == 0: out.pop()
    return out


def _pack(cmds, size):
    b = bytearray()
    for i in range(0, len(cmds), 4):
        four = cmds[i:i + 4]
        b += bytes([c for c, _ in four] + [0] * (4 - len(four)))
        for _, p in four: b += struct.pack('<%dI' % len(p), *p)
    assert len(b) <= size, (len(b), size)
    return bytes(b) + b'\0' * (size - len(b))


def _move(c, p, v):
    """the vertex a command gives, from the one before (4.12 fixed)"""
    if c == 0x23: return [s16(p[0] & 0xFFFF), s16(p[0] >> 16), s16(p[1] & 0xFFFF)]
    if c == 0x24: return [sx(p[0] & 0x3FF, 10) << 6, sx((p[0] >> 10) & 0x3FF, 10) << 6, sx((p[0] >> 20) & 0x3FF, 10) << 6]
    if c == 0x25: return [s16(p[0] & 0xFFFF), s16(p[0] >> 16), v[2]]
    if c == 0x26: return [s16(p[0] & 0xFFFF), v[1], s16(p[0] >> 16)]
    if c == 0x27: return [v[0], s16(p[0] & 0xFFFF), s16(p[0] >> 16)]
    return [v[0] + sx(p[0] & 0x3FF, 10), v[1] + sx((p[0] >> 10) & 0x3FF, 10), v[2] + sx((p[0] >> 20) & 0x3FF, 10)]


def _strip_dl(dl, scale, tex, drop):
    cmds = _parse(dl)
    out, gone = [], 0
    was = [0, 0, 0]            # the vertex the original list has reached
    now = [0, 0, 0]            # the one ours has
    i = 0

    def emit(c, p, before, after):
        nonlocal now
        if c in VTX:
            if c in (0x25, 0x26, 0x27, 0x28) and before != now:
                c, p = 0x23, [(after[0] & 0xFFFF) | ((after[1] & 0xFFFF) << 16), after[2] & 0xFFFF]
            now = list(after)
        out.append((c, p))

    while i < len(cmds):
        c, p = cmds[i]
        if c != 0x40:
            if c in VTX:
                after = _move(c, p, was); emit(c, p, was, after); was = after
            else: out.append((c, p))
            i += 1; continue
        prim = p[0] & 3
        j = i + 1
        verts, pre = [], []        # verts: [(commands before it, command, params, before, after)]
        while j < len(cmds) and cmds[j][0] not in (0x40, 0x41):
            cc, pp = cmds[j]
            if cc in VTX:
                after = _move(cc, pp, was); verts.append((pre, cc, pp, was, after)); was = after; pre = []
            else: pre.append((cc, pp))
            j += 1
        tail = pre
        end = j < len(cmds) and cmds[j][0] == 0x41
        n = PER.get(prim, len(verts)) or 1
        faces = [verts[k:k + n] for k in range(0, len(verts), n)]
        keep = [f for f in faces if not (len(f) >= 3 and drop(tex, [tuple(a * scale / 4096.0 for a in v[4]) for v in f]))]
        gone += len(faces) - len(keep)
        if len(keep) == len(faces):
            out.append((c, p))
            for f in faces:
                for pr, cc, pp, b, a in f:
                    out.extend(pr); emit(cc, pp, b, a)
            out.extend(tail)
            if end: out.append(cmds[j])
        else:
            # what the faces taken out set (colour, normal, texture coordinate) holds for those after them
            if keep: out.append((c, p))
            held = {}
            for f in faces:
                if f in keep:
                    out.extend(held.values()); held = {}
                    for pr, cc, pp, b, a in f:
                        out.extend(pr); emit(cc, pp, b, a)
                else:
                    for pr, cc, pp, b, a in f:
                        for q in pr:
                            if q[0] in (0x20, 0x21, 0x22): held[q[0]] = q
                            else: out.append(q)
            if keep and end: out.extend(tail); out.append(cmds[j])
            else: out.extend(q for q in tail if q[0] not in (0x20, 0x21, 0x22))
            out.extend(held.values())
        i = j + (1 if end else 0)
    return (_pack(out, len(dl)), gone) if gone else (dl, 0)


def strip(land, drop):
    ps, bs, ms, hs, magic, ss = struct.unpack_from('<4I2H', land, 0)
    o = 0x14 + ss + ps + bs
    blob = bytearray(land[o:o + ms])
    mdl0 = u32(blob, 0x10)
    (name, e), = read_dict(blob, mdl0 + 8)[:1]
    m = mdl0 + u32(e, 0)
    off_sbc, off_mat, off_shp = u32(blob, m + 4), u32(blob, m + 8), u32(blob, m + 12)
    scale = struct.unpack_from('<i', blob, m + 0x14 + 8)[0] / 4096
    mats_o = m + off_mat
    mat_tex = {}
    for tn, te in read_dict(blob, mats_o + u16(blob, mats_o)):
        lo, n = u16(te, 0), te[2]
        for k in range(n): mat_tex[blob[mats_o + lo + k]] = tn.decode()
    sbc = blob[m + off_sbc:m + off_mat]
    shape_tex, cur, i = {}, None, 0
    while i < len(sbc):
        c = sbc[i] & 0x1F
        if c == 0x04: cur = sbc[i + 1]; i += 2
        elif c == 0x05: shape_tex[sbc[i + 1]] = mat_tex.get(cur, '?'); i += 2
        elif c == 0x01: break
        elif c == 0x02: i += 3
        elif c == 0x03: i += 2
        elif c == 0x06: i += 4
        elif c == 0x09: i += 2 + 3 * sbc[i + 2]
        else: i += 1
    shps_o = m + off_shp
    total = 0
    for si, (sn, se) in enumerate(read_dict(blob, shps_o)):
        h = shps_o + u32(se, 0)
        dlo, dll = u32(blob, h + 8), u32(blob, h + 12)
        new, gone = _strip_dl(bytes(blob[h + dlo:h + dlo + dll]), scale, shape_tex.get(si, '?'), drop)
        blob[h + dlo:h + dlo + dll] = new; total += gone
    return land[:o] + bytes(blob) + land[o + ms:], total
