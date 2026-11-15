"""Small readers/writers for the Nitro formats Canvas generates: NARC archives, G3D dictionaries."""
import struct

u16 = lambda d, o: struct.unpack_from('<H', d, o)[0]
u32 = lambda d, o: struct.unpack_from('<I', d, o)[0]


def pad4(b, fill=b'\0'):
    return b + fill * (-len(b) % 4)


# ---------------------------------------------------------------- NARC
def read_narc(data):
    assert data[:4] == b'NARC', data[:4]
    off = u16(data, 0xC)
    assert data[off:off + 4] == b'BTAF'
    size, n = struct.unpack_from('<IH', data, off + 4)
    fat = [struct.unpack_from('<II', data, off + 12 + 8 * i) for i in range(n)]
    off += size
    assert data[off:off + 4] == b'BTNF'
    btnf = data[off:off + u32(data, off + 4)]
    off += len(btnf)
    assert data[off:off + 4] == b'GMIF'
    base = off + 8
    return [data[base + s:base + e] for s, e in fat], btnf


def write_narc(files, btnf=None):
    if btnf is None:
        btnf = b'BTNF' + struct.pack('<IIHH', 16, 4, 0, 1)
    fat, gmif = [], bytearray()
    for f in files:
        fat.append((len(gmif), len(gmif) + len(f)))
        gmif += f
        gmif += b'\xff' * (-len(gmif) % 4)
    btaf = b'BTAF' + struct.pack('<IHH', 12 + 8 * len(files), len(files), 0) + b''.join(struct.pack('<II', *e) for e in fat)
    gm = b'GMIF' + struct.pack('<I', 8 + len(gmif)) + bytes(gmif)
    body = btaf + btnf + gm
    return b'NARC' + struct.pack('<HHIHH', 0xFFFE, 0x0100, 16 + len(body), 16, 3) + body


# ---------------------------------------------------------------- G3D dictionaries (Patricia trees over 16-byte names)
def _bit(name, b):
    return (name[b >> 3] >> (b & 7)) & 1 if (b >> 3) < len(name) else 0


def _top_diff(a, b):
    for i in range(127, -1, -1):
        if _bit(a, i) != _bit(b, i):
            return i
    raise ValueError('duplicate dictionary name')


def patricia(names):
    """Nodes (refBit, left, right, entryIndex) as NitroSystem builds them: node 0 is the root."""
    nodes = [[127, 0, 0, 0]]
    keys = [b'\0' * 16]
    for idx, nm in enumerate(names):
        nm = nm.ljust(16, b'\0')
        # find the closest key
        p, t = 0, nodes[0][1]
        while nodes[p][0] > nodes[t][0]:
            p, t = t, (nodes[t][2] if _bit(nm, nodes[t][0]) else nodes[t][1])
        i = _top_diff(nm, keys[t])
        p, t = 0, nodes[0][1]
        while nodes[p][0] > nodes[t][0] and nodes[t][0] > i:
            p, t = t, (nodes[t][2] if _bit(nm, nodes[t][0]) else nodes[t][1])
        z = len(nodes)
        nodes.append([i, z, z, idx] if False else [i, 0, 0, idx])
        keys.append(nm)
        if _bit(nm, i):
            nodes[z][1], nodes[z][2] = t, z
        else:
            nodes[z][1], nodes[z][2] = z, t
        if p == 0:
            nodes[0][1] = z
        elif _bit(nm, nodes[p][0]):
            nodes[p][2] = z
        else:
            nodes[p][1] = z
    return nodes


def build_dict(entries, unit):
    """entries: [(name bytes, entry bytes of `unit` length)] -> dictionary bytes"""
    n = len(entries)
    nodes = patricia([e[0] for e in entries])
    tree = b''.join(struct.pack('<4B', *nd) for nd in nodes)
    ent = struct.pack('<HH', unit, 4 + unit * n) + b''.join(e[1] for e in entries)
    names = b''.join(e[0].ljust(16, b'\0') for e in entries)
    size = 8 + len(tree) + len(ent) + len(names)
    return struct.pack('<BBHHH', 0, n, size, 8, 8 + len(tree)) + tree + ent + names


def read_dict(d, o):
    n = d[o + 1]
    p = o + u16(d, o + 6)
    esize = u16(d, p)
    p += 4
    entries = [d[p + i * esize:p + (i + 1) * esize] for i in range(n)]
    names = [d[p + n * esize + 16 * i:p + n * esize + 16 * (i + 1)].rstrip(b'\0') for i in range(n)]
    return list(zip(names, entries))


# ---------------------------------------------------------------- TEX0 textures: read them out, write a merged BTX0
BPP = {1: 8, 2: 2, 3: 4, 4: 8, 5: 2, 6: 8, 7: 16}


def read_tex0(d, t):
    """-> ([(name, param, extra, data, compinfo)], [(name, flag, data)])"""
    tex_data = t + u32(d, t + 0x14)
    comp_data = t + u32(d, t + 0x24)
    comp_info = t + u32(d, t + 0x28)
    pal_data = t + u32(d, t + 0x38)
    pal_size = (u32(d, t + 0x30) & 0xFFFF) << 3
    texs = []
    for nm, e in read_dict(d, t + u16(d, t + 0xE)):
        prm, extra = struct.unpack_from('<II', e, 0)
        w, h, fmt = 8 << ((prm >> 20) & 7), 8 << ((prm >> 23) & 7), (prm >> 26) & 7
        off = (prm & 0xFFFF) << 3
        size = w * h * BPP[fmt] // 8
        if fmt == 5:
            texs.append((nm, prm, extra, d[comp_data + off:comp_data + off + size], d[comp_info + off // 2:comp_info + off // 2 + size // 2]))
        else:
            texs.append((nm, prm, extra, d[tex_data + off:tex_data + off + size], b''))
    pents = [(nm, u16(e, 0) << 3, u16(e, 2)) for nm, e in read_dict(d, t + u32(d, t + 0x34))]
    offs = sorted({o for _, o, _ in pents} | {pal_size})
    pals = [(nm, fl, d[pal_data + o:pal_data + offs[offs.index(o) + 1]]) for nm, o, fl in pents]
    return texs, pals


def tex0_of(d):
    n = u16(d, 0xE)
    for i in range(n):
        o = u32(d, 0x10 + 4 * i)
        if d[o:o + 4] == b'TEX0':
            return o
    return None


def write_btx0(texs, pals):
    tex_blk, comp_blk, info_blk, tex_ent = bytearray(), bytearray(), bytearray(), []
    for nm, prm, extra, data, info in texs:
        fmt = (prm >> 26) & 7
        if fmt == 5:
            off = len(comp_blk); comp_blk += data; info_blk += info
        else:
            off = len(tex_blk); tex_blk += data; tex_blk += b'\0' * (-len(tex_blk) % 8)
        assert off % 8 == 0
        tex_ent.append((nm, struct.pack('<II', (prm & ~0xFFFF) | (off >> 3), extra)))
    pal_blk, pal_ent = bytearray(), []
    for nm, fl, data in pals:
        pal_ent.append((nm, struct.pack('<HH', len(pal_blk) >> 3, fl)))
        pal_blk += data; pal_blk += b"\0" * (-len(pal_blk) % 16)   # (16- and 256-colour palettes sit on 16 bytes)
    tdict = build_dict(tex_ent, 8)
    pdict = build_dict(pal_ent, 4)
    o_tdict = 0x3C
    o_pdict = pad4(b'\0' * (o_tdict + len(tdict))).__len__()
    o_tex = (o_pdict + len(pdict) + 7) & ~7
    o_comp = o_tex + len(tex_blk)
    o_info = o_comp + len(comp_blk)
    o_pal = (o_info + len(info_blk) + 7) & ~7
    size = o_pal + len(pal_blk)
    hdr = b'TEX0' + struct.pack('<IIHHIIIHHIIIIIII', size, 0, len(tex_blk) >> 3, o_tdict, 0, o_tex, 0,
                                len(comp_blk) >> 3, o_tdict, 0, o_comp, o_info, 0, (len(pal_blk) >> 3) | 0x80000000, o_pdict, o_pal)
    assert len(hdr) == 0x3C, len(hdr)
    body = bytearray(hdr + tdict)
    body += b'\0' * (o_pdict - len(body)); body += pdict
    body += b'\0' * (o_tex - len(body)); body += tex_blk + comp_blk + info_blk
    body += b'\0' * (o_pal - len(body)); body += pal_blk
    return b'BTX0' + struct.pack('<HHIHHI', 0xFFFE, 0x0001, 0x14 + len(body), 0x10, 1, 0x14) + bytes(body)
