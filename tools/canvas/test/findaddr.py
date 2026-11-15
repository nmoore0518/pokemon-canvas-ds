import struct
from desmume.controls import Keys, keymask

LO, HI = 0x02200000, 0x02400000


class Tracker:
    """The player's map position (x, z): found by stepping and seeing which number moved one square."""
    def __init__(self, emu):
        self.emu = emu
        self.addr, self.zoff = None, 4
        self.calibrate()

    def run(self, n):
        for _ in range(n): self.emu.cycle(with_joystick=False)

    def ram(self):
        b = bytes(self.emu.memory.unsigned[LO:HI])
        return struct.unpack('<%di' % (len(b) // 4), b)

    def read(self, a):
        m = self.emu.memory.unsigned
        return (struct.unpack('<i', bytes(m[a:a + 4]))[0], struct.unpack('<i', bytes(m[a + self.zoff:a + self.zoff + 4]))[0])

    def key(self, d, n=24):
        k = keymask(getattr(Keys, 'KEY_' + d)); self.emu.input.keypad_add_key(k); self.run(n); self.emu.input.keypad_rm_key(k); self.run(30)

    def calibrate(self):
        for d, (dx, dz), back in (('DOWN', (0, 1), 'UP'), ('UP', (0, -1), 'DOWN'), ('LEFT', (-1, 0), 'RIGHT'), ('RIGHT', (1, 0), 'LEFT')):
            for _ in range(2):
                A = self.ram(); self.key(d, 8); B = self.ram()
                cands = [(i, zo) for i in range(len(A) - 2) for zo in (1, 2)
                         if 2 < A[i] < 4096 and 2 < A[i + zo] < 4096 and B[i] - A[i] == dx and B[i + zo] - A[i + zo] == dz]
                if not cands: continue
                self.key(back, 8); C = self.ram()
                cands = [(i, zo) for i, zo in cands if C[i] == A[i] and C[i + zo] == A[i + zo]]
                if cands:
                    import os
                    if os.environ.get('DBG'): print('candidates', [(hex(LO + i * 4), zo, A[i], A[i + zo]) for i, zo in cands])
                    # several copies (local and global): the biggest is the global map position
                    # (the field's own copy lives in the heap at 0x22a0000+, x then z; the saved location lags)
                    i, zo = max(cands, key=lambda c: (LO + c[0] * 4 >= 0x22a0000, A[c[0]] > 32 or A[c[0] + c[1]] < 32, A[c[0]]))
                    self.addr, self.zoff = LO + i * 4, zo * 4
                    return
        raise SystemExit('could not find the player')

    def __call__(self):
        return self.read(self.addr)

    def snapshot(self):
        return None

    def moved_from(self, before):
        pass
