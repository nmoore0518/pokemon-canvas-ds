"""Canvas: the map headers for maps past HeartGold's 540 (src/data/map_headers_canvas.h), compiled with the
decomp's own compiler and written for the engine (engine/data/canvas_map_headers.bin: u32 count, u32 first map
id, then 24 bytes a map). Also checks that compiling HeartGold's own table this way gives the bytes in the ARM9,
so the layout of the fields is surely the game's.

    python3 tools/canvas/build_map_headers.py        (after `make rom`, which this reads the build of)"""
import json, os, re, struct, subprocess, sys
ROOT = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..'))
B = os.path.join(ROOT, 'build/heartgold.us')
OUT = os.path.join(ROOT, 'engine/data/canvas_map_headers.bin')
RETAIL = 540


def symbol_bytes(obj, name):
    syms = subprocess.run(['arm-none-eabi-readelf', '-sW', obj], capture_output=True, text=True).stdout
    secs = subprocess.run(['arm-none-eabi-readelf', '-SW', obj], capture_output=True, text=True).stdout
    m = re.search(r'\s(\w+)\s+(\d+)\s+OBJECT\s+\w+\s+\w+\s+(\d+)\s+%s\s*$' % re.escape(name), syms, re.M)
    val, size, shndx = int(m.group(1), 16), int(m.group(2)), int(m.group(3))
    sec = re.search(r'\[\s*%d\]\s+(\S+)\s+\S+\s+\S+\s+(\w+)\s+(\w+)' % shndx, secs)
    off = int(sec.group(2), 16)
    data = open(obj, 'rb').read()
    return data[off + val:off + val + size]


def main():
    cmd = next(c for c in json.load(open(os.path.join(B, 'compile_commands.json'))) if c['file'].endswith('src/map_header.c'))['command']
    src = os.path.join(B, 'canvas_map_headers.c')
    open(src, 'w').write(open(os.path.join(ROOT, 'src/map_header.c')).read().split('static u32 MapNumberBoundsCheck')[0] +
                         '#include "data/map_headers_canvas.h"\n'
                         'const void *const canvas_keep[] = {sMapHeaders, sCanvasMapHeaders};\n')
    obj = os.path.join(B, 'canvas_map_headers.o')
    cmd = cmd.replace('-o main.nef.p/src_map_header.c.o -c ../../src/map_header.c', '-o %s -c %s' % (obj, src))
    cmd = cmd.replace(' -gccdep -MD', '')
    subprocess.run(cmd, shell=True, cwd=B, check=True)
    retail = symbol_bytes(obj, 'sMapHeaders')
    ours = symbol_bytes(obj, 'sCanvasMapHeaders') if b'sCanvasMapHeaders' in open(obj, 'rb').read() else b''
    # the check: the table in the ARM9 (decompressed main.sbin, at sMapHeaders in the link map)
    xmap = open(os.path.join(B, 'main.nef.xMAP')).read()
    addr = int(re.search(r'^\s+(\w{8}) \w{8} \.\w+\s+sMapHeaders\s', xmap, re.M).group(1), 16)
    arm9 = open(os.path.join(B, 'main.sbin'), 'rb').read()
    assert len(retail) == RETAIL * 24, len(retail)
    assert arm9[addr - 0x02000000:addr - 0x02000000 + len(retail)] == retail, 'header layout differs from the ARM9'
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    open(OUT, 'wb').write(struct.pack('<II', len(ours) // 24, RETAIL) + ours)
    print('map headers: %d of ours (from %d), retail table checked at %08X' % (len(ours) // 24, RETAIL, addr))


if __name__ == '__main__':
    main()
