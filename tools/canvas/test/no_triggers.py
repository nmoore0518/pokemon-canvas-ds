"""test ROM: also drop the trigger squares of the given zone event members (e.g. Pallet's Oak)"""
import sys, struct, ndspy.rom, ndspy.narc
src, dst, *members = sys.argv[1:]
rom = ndspy.rom.NintendoDSRom.fromFile(src)
ev = ndspy.narc.NARC(rom.getFileByName('a/0/3/2'))
for m in map(int, members):
    f = bytearray(ev.files[m])
    nbg = struct.unpack_from('<I', f, 0)[0]; o = 4 + 20 * nbg
    nobj = struct.unpack_from('<I', f, o)[0]; o += 4 + 32 * nobj
    nw = struct.unpack_from('<I', f, o)[0]; o += 4 + 12 * nw
    struct.pack_into('<I', f, o, 0)
    ev.files[m] = bytes(f)
rom.setFileByName('a/0/3/2', ev.save())
rom.saveToFile(dst)
