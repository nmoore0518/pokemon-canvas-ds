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
rom.saveToFile(dst)
