"""test ROM: a new game starts at another map and square (start_at.py SRC DST MAP_ID X Y): skips the walk there.
Patches the new-game location (src/location_backup.c, sLocation_PlayerRoom) in the ARM9 binary."""
import sys, struct, ndspy.rom
src, dst, mid, x, y = sys.argv[1:]
rom = ndspy.rom.NintendoDSRom.fromFile(src)
a9 = bytearray(rom.arm9)
old = struct.pack('<5i', 49, -1, 31 * 32 + 27 + 6, 32 * 11 + 49, 1)
i = a9.find(old)
assert i >= 0, 'new-game location not found (is the ARM9 compressed?)'
a9[i:i + 20] = struct.pack('<5i', int(mid), -1, int(x), int(y), 1)
rom.arm9 = bytes(a9)
rom.saveToFile(dst)
print('start at', mid, x, y, 'offset', hex(i))
