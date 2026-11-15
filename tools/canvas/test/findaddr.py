import struct
def find_pos_addr(emu):
    """The player's map position moves with the heap: it is the middle of three copies 12 bytes apart"""
    base = 0x022a0000
    ram = bytes(emu.memory.unsigned[base:base + 0x20000])
    rd = lambda o: struct.unpack_from('<i', ram, o)[0]
    for o in range(0, len(ram) - 40, 4) if False else range(0, len(ram) - 40, 2):
        x, z = rd(o), rd(o + 8)
        if 0 < x < 4096 and 0 < z < 4096 and rd(o + 12) == x and rd(o + 20) == z and rd(o + 24) == x and rd(o + 32) == z:
            return base + o + 12
    raise SystemExit('no player position found')
