"""Canvas: changes to HeartGold's own Kanto maps, where our GBA game has something HeartGold doesn't.
Run after build_rooms.py. Each change is idempotent (it checks before adding).

HeartGold's land squares: perm u16 per square (bit 15 = blocked, low byte = behaviour; 0x69 = door).
"""
import json, os, struct, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from nitro import read_narc, write_narc
import slots, world

LAND_NARC = os.path.join(slots.ROOT, 'files/a/0/6/5')

# a house of HeartGold's (model, its door model) added where the GBA map has one HeartGold's doesn't.
# Footprints measured from HeartGold's own (to_h01 in Viridian: 4 wide, 5 deep, door second from the left).
HOUSE_MODELS = {
    'to_h01': dict(model=315, door=94, footprint=(-1, -4, 3, 1), origin=(1.0, -0.5), door_at=(1.0625, 0.125), door_y=-1),
}
NEW_HOUSES = [   # town, door square (global), house, the room's slot (via slots.SLOTS), arrival warp there
    dict(map='MAP_VIRIDIAN', door=(1041, 262), house='to_h01', ground=48, room='MAP_VIRIDIAN_CITY_PENNYS_HOUSE', anchor=1,
         why="Penny's house (the Eevee side quest), in the flower garden east of the Pokemon Center as on the GBA"),
]


def main():
    lands, btnf = read_narc(open(LAND_NARC, 'rb').read())
    for h in NEW_HOUSES:
        hm = HOUSE_MODELS[h['house']]
        dx, dz = h['door']
        lid, _ = world.land_at(dx, dz)
        d = bytearray(lands[lid])
        perm_sz, bld_sz, mdl_sz, bdhc_sz = struct.unpack_from('<4I', d, 0)
        # collision: the footprint blocked, the door square a door
        x0, z0, x1, z1 = hm['footprint']
        for z in range(dz + z0, dz + z1):
            for x in range(dx + x0, dx + x1):
                assert world.land_at(x, z)[0] == lid, 'footprint crosses into another land'
                v = 0x8069 if (x, z) == (dx, dz) else 0x8000
                struct.pack_into('<H', d, 0x14 + ((z % 32) * 32 + x % 32) * 2, v)
        # the house and its door, unless already there
        cx, cz = (dx % 32) + hm['origin'][0], (dz % 32) + hm['origin'][1]
        f = lambda v: int(round(v * 4096))
        U = lambda b: (b - 16) * 16
        props = [d[0x14 + perm_sz + i * 48:0x14 + perm_sz + (i + 1) * 48] for i in range(bld_sz // 48)]
        mine = [struct.pack('<I3i3i3i8x', hm['model'], f(U(cx)), f(h['ground']), f(U(cz)), 0, 0, 0, 4096, 4096, 4096),
                struct.pack('<I3i3i3i8x', hm['door'], f(U((dx % 32) + hm['door_at'][0])), f(h['ground'] + hm['door_y']),
                            f(U((dz % 32) + hm['door_at'][1])), 0, 0, 0, 4096, 4096, 4096)]
        props = [p for p in props if p not in mine] + mine
        bld = b''.join(props)
        d = d[:0x14 + perm_sz] + bld + d[0x14 + perm_sz + bld_sz:]
        struct.pack_into('<I', d, 4, len(bld))
        lands[lid] = bytes(d)
        # the warp into the room, last in the town's list (so no other warp's number moves)
        path = os.path.join(slots.EVENT_DIR, slots.events_file(h['map']))
        ev = json.load(open(path))
        target = slots.SLOTS[h['room']]
        ev['warps'] = [w for w in ev['warps'] if not (w['x'] == dx and w['z'] == dz)]
        ev['warps'].append({'x': dx, 'z': dz, 'header': target, 'anchor': h['anchor'], 'y': 0})
        json.dump(ev, open(path, 'w'), indent=4); open(path, 'a').write('\n')
        print(h['map'], 'house at', h['door'], '-> warp', len(ev['warps']) - 1, 'to', target)
    open(LAND_NARC, 'wb').write(write_narc(lands, btnf))


if __name__ == '__main__':
    main()
