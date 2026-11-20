"""The Leader Academy's main hall (Nick: "a bigger version of this" - Pewter's Museum of Science, field model 293 -
"with brick facade and a blue roof"): a copy of HeartGold's museum with its textures of its own (`cv_ac..`:
building textures share VRAM by name), its pink roof turned blue, its cream plaster laid in brick (a running bond,
bricks 8 texels by 4, as the museum's own walls take 16 texels to a square), every other colour as HeartGold's.
build_pallet.py appends it to the field models (ACADEMY_MODEL); build_overworld.py stands it on the campus."""
import colorsys, struct
from nitro import tex0_of, read_dict, u16, u32

SRC = 293                       # (Pewter's Museum of Science)
ROOF = {'nbc_mm03', 'nbc_mm08'}         # (its pink roof and the purple strip along it)
KEEP = {'h_kage', 'nbc_mm04', 'nbc_mm10'}   # (the shadow, the glass, the emblem)
BLUE = 0.60                     # (the roof's hue)
BRICK = (178, 74, 58)           # a brick, its shadowed lower course, the mortar
BRICK_DARK = (132, 52, 44)
MORTAR = (206, 192, 170)


def _cream(c):
    h, s, v = colorsys.rgb_to_hsv(*(x / 255 for x in c))
    return 0.04 <= h <= 0.2 and s < 0.4 and v > 0.55


def _rgb(c16):
    return ((c16 & 31) * 255 // 31, ((c16 >> 5) & 31) * 255 // 31, ((c16 >> 10) & 31) * 255 // 31)


def _c16(rgb):
    return round(rgb[0] * 31 / 255) | round(rgb[1] * 31 / 255) << 5 | round(rgb[2] * 31 / 255) << 10


def make(model):
    import build_pallet as BP
    d = bytearray(model)
    t = tex0_of(d)
    names = [nm.decode() for nm, _ in read_dict(d, t + u16(d, t + 0xE))]
    mapping = {}
    for n in names:
        if n.startswith('nbc_mm'):
            mapping[n.encode()] = ('cv_ac' + n[6:]).encode(); mapping[(n + '_pl').encode()] = ('cv_ac' + n[6:] + '_pl').encode()
    BP.rename_textures(d, mapping)
    t = tex0_of(d)
    tex_data, pal_data = t + u32(d, t + 0x14), t + u32(d, t + 0x38)
    pal_size = (u32(d, t + 0x30) & 0xFFFF) << 3
    pents = {nm.decode(): u16(e, 0) << 3 for nm, e in read_dict(d, t + u32(d, t + 0x34))}
    offs = sorted(set(pents.values()) | {pal_size})
    inv = {v: k for k, v in mapping.items()}
    for nm, e in read_dict(d, t + u16(d, t + 0xE)):
        nm = bytes(nm); name = inv.get(nm, nm).decode()
        prm = struct.unpack_from('<I', e, 0)[0]
        w, h, fmt = 8 << ((prm >> 20) & 7), 8 << ((prm >> 23) & 7), (prm >> 26) & 7
        if fmt not in (2, 3) or name in KEEP: continue
        bpp = 2 if fmt == 2 else 4
        po = pents[nm.decode() + '_pl']
        npal = min(1 << bpp, (offs[offs.index(po) + 1] - po) // 2)
        pal = [_rgb(u16(d, pal_data + po + 2 * i)) for i in range(npal)]
        if name in ROOF:
            for i, c in enumerate(pal):
                hh, s, v = colorsys.rgb_to_hsv(*(x / 255 for x in c))
                if s > 0.15: pal[i] = tuple(round(x * 255) for x in colorsys.hsv_to_rgb(BLUE, s, v))
        else:
            off = tex_data + ((prm & 0xFFFF) << 3)
            per = 8 // bpp
            idx = [(d[off + k // per] >> (bpp * (k % per))) & ((1 << bpp) - 1) for k in range(w * h)]
            cream = {i for i, c in enumerate(pal) if _cream(c)}
            if not any(i in cream for i in idx): continue
            used = {i for i in idx if i not in cream}
            free = [i for i in range(npal) if i not in used and not (i == 0 and prm >> 29 & 1)]
            if len(free) < 3: continue          # (no room in its palette: left as HeartGold's)
            b_, dk, mo = free[:3]
            pal[b_], pal[dk], pal[mo] = BRICK, BRICK_DARK, MORTAR
            for k in range(w * h):
                if idx[k] not in cream: continue
                x, y = k % w, k // w
                row = y // 4
                if y % 4 == 3 or (x + (row % 2) * 4) % 8 == 7: idx[k] = mo
                elif y % 4 == 2: idx[k] = dk
                else: idx[k] = b_
            for k in range(0, w * h, per):
                v = 0
                for j in range(per): v |= idx[k + j] << (bpp * j)
                d[off + k // per] = v
        for i, c in enumerate(pal):
            old = u16(d, pal_data + po + 2 * i)
            struct.pack_into('<H', d, pal_data + po + 2 * i, (old & 0x8000) | _c16(c))
    return bytes(d)
