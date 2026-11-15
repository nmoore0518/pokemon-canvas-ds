"""Test copy of the ROM with no wild encounters (so the walking tests don't end up in battles):
    engine/.venv/bin/python tools/canvas/test/no_encounters.py build/canvas.nds build/canvas_test.nds"""
import sys, os
import ndspy.rom, ndspy.narc
src, dst = sys.argv[1:3]
rom = ndspy.rom.NintendoDSRom.fromFile(src)
names = [n for n in ('fielddata/encountdata/gs_enc_data.narc', 'a/0/3/7') if rom.filenames.idOf(n) is not None]
for n in names:
    narc = ndspy.narc.NARC(rom.getFileByName(n))
    narc.files = [bytes(6) + f[6:] if len(f) >= 6 else f for f in narc.files]
    rom.setFileByName(n, narc.save())
    print('no encounters in', n, len(narc.files))
# and no trainers spotting us: every trainer's sight range set to 0 (zone events, a/0/3/2)
import struct
ev = ndspy.narc.NARC(rom.getFileByName('a/0/3/2'))
out = []
for f in ev.files:
    f = bytearray(f)
    if len(f) >= 8:
        nbg = struct.unpack_from('<I', f, 0)[0]
        o = 4 + 20 * nbg
        nobj = struct.unpack_from('<I', f, o)[0]
        for i in range(nobj):
            b = o + 4 + 32 * i
            if struct.unpack_from('<H', f, b + 6)[0] == 1:
                struct.pack_into('<H', f, b + 14, 0)       # param0: sight range
                struct.pack_into('<HH', f, b + 24, 0, 0)   # and out of the way (they stand on paths)
    out.append(bytes(f))
ev.files = out
rom.setFileByName('a/0/3/2', ev.save())
print('no trainers in a/0/3/2')
rom.saveToFile(dst)
