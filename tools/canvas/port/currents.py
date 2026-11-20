"""The GBA's water currents (Seafoam Islands B3F and B4F) on HeartGold, which has none (Nick: the B4F currents).

The GBA moves a surfing player along its current squares itself (field_player_avatar.c, DoForcedMovement): from a
current square, on to the square it points to while that is water, each step a fast walk; onto land at the
ground's height the player gets off and stands there (CanStopSurfing); into a wall, a higher floor or a boulder
the ride stops where it is. Each current square is a trigger square of ours here, whose script is the ride the
GBA's current gives from it, worked out square by square over our map (the cave is widened: build_caves'
cave_widen; a copied line is the GBA line after it).

A floor's currents stop once both its boulders are down in the water (the GBA swaps in a calm layout:
setmaplayoutindex ..._CURRENT_STOPPED); here a var of ours says so, and the squares calm in that layout are
triggers only while it is 0. Squares that are currents in both layouts ride by whichever is in force.

Falling through a hole into the water (B2F to B3F, B3F to B4F): the GBA starts the player surfing as they land
(field_effect.c, FallWarpEffect_End) and sets VAR_TEMP_1 for the map's frame script. Here a frame script of ours
looks, once on each arrival, whether the player stands on a square of water a warp arrives at (only falls do)."""
import gba_map as GM
import build_caves as BC
import specials as SP

STOPPED = {'SeafoamIslands_B3F_Frlg': 'LAYOUT_SEAFOAM_ISLANDS_B3F_CURRENT_STOPPED',
           'SeafoamIslands_B4F_Frlg': 'LAYOUT_SEAFOAM_ISLANDS_B4F_CURRENT_STOPPED'}
CURRENT = {80: 'right', 81: 'left', 82: 'up', 83: 'down'}  # MB_EASTWARD/WESTWARD/NORTHWARD/SOUTHWARD_CURRENT
WATER = BC.WATER_MB
DELTA = {'up': (0, -1), 'down': (0, 1), 'left': (-1, 0), 'right': (1, 0)}
HG_DIR = {'up': 'North', 'down': 'South', 'left': 'West', 'right': 'East'}
ELEVATION_DEFAULT = 3
ARRIVED = 'VAR_TEMP_E'          # (a temp var: HeartGold clears them on entering a map)


def calm_var(gba):
    return 'CV_' + STOPPED[gba].replace('LAYOUT_', '')


class Floor:
    """one of our floors with currents: its squares and the GBA's they copy"""

    def __init__(self, gba):
        self.gba = gba
        self.xy = BC.cave_xy(gba)
        self.gm = GM.map_json(gba)
        self.lays = {'current': GM.Layout(self.gm['layout']), 'calm': GM.Layout(STOPPED[gba])}
        lay = self.lays['current']
        self.cols = [self.xy(x, 0)[0] for x in range(lay.w)]      # (our squares are the GBA's, moved on by the copies)
        self.rows = [self.xy(0, y)[1] for y in range(lay.h)]
        self.W, self.H = self.cols[-1] + 1, self.rows[-1] + 1
        # the boulders (those that fall in from the floor above stand in the shallows the currents run into)
        self.boulders = [(self.xy(o['x'], o['y']), o['flag']) for o in self.gm['object_events']
                         if 'PUSHABLE_BOULDER' in o['graphics_id']]

    def src(self, x, z):
        """our square -> the GBA's it copies (None: off the map)"""
        if not (0 <= x < self.W and 0 <= z < self.H): return None
        return next(i for i, c in enumerate(self.cols) if c >= x), next(i for i, r in enumerate(self.rows) if r >= z)

    def current(self, layout, x, z):
        s = self.src(x, z)
        if s is None: return None
        L = self.lays[layout]
        return None if L.collision(*s) else CURRENT.get(L.behavior(L.metatile(*s)))     # (the calm layouts wall some off)

    def ride(self, layout, x, z, present=()):
        """the GBA's ride from our square (x, z) -> (the steps, the squares passed, 'calm' | 'stop' | 'land')"""
        L = self.lays[layout]
        steps, path = [], []
        elev = L.elevation(*self.src(x, z))
        while True:
            d = self.current(layout, x, z)
            if d is None: return steps, path, 'calm'
            nx, nz = x + DELTA[d][0], z + DELTA[d][1]
            s = self.src(nx, nz)
            if s is None or (nx, nz) in present or L.collision(*s): return steps, path, 'stop'
            e = L.elevation(*s)
            if e in (0, 15) or e == elev:                     # (no elevation mismatch: on it goes)
                steps.append(d); path.append((nx, nz)); x, z = nx, nz
                if e not in (0, 15): elev = e
                if len(steps) > 200: raise ValueError('%s: a current going round in a ring at %d, %d' % (self.gba, x, z))
                if L.behavior(L.metatile(*s)) in WATER: continue
                # (water you walk in - the shallows the boulders fall into - is floor here: off onto it)
                return steps, path, 'land'
            if e == ELEVATION_DEFAULT:                        # (CanStopSurfing: off onto the land)
                steps.append(d); path.append((nx, nz))
                return steps, path, 'land'
            return steps, path, 'stop'                        # (a higher floor: the GBA's elevation mismatch)

    def squares(self):
        """our squares of current, in either layout"""
        return [(x, z) for z in range(self.H) for x in range(self.W)
                if self.current('current', x, z) or self.current('calm', x, z)]

    def landings(self):
        """our squares of water a warp arrives at (the GBA's are where you land, falling from the floor above)"""
        return [xz for _, xz in self.landing_warps()]

    def landing_warps(self):
        """-> [(the warp's number, our square)] for those"""
        lay = self.lays['current']
        return [(i, self.xy(w['x'], w['y'])) for i, w in enumerate(self.gm['warp_events'])
                if lay.behavior(lay.metatile(w['x'], w['y'])) in WATER]


def fall_in(gba, warps):
    """HeartGold's way down a hole is its ladder's: the player arrives and takes a step south. A warp the player
    falls in by stands a square north of where the GBA's lands them, so that the step ends there"""
    for i, (x, z) in Floor(gba).landing_warps():
        warps[i].update(x=x, z=z - 1)


def rectangles(squares):
    """squares -> rectangles (x, z, w, h) that cover them and nothing else: each the widest run from the first
    square left, as far down as the run goes"""
    left, out = set(squares), []
    while left:
        x, z = min(left, key=lambda q: (q[1], q[0]))
        w = 1
        while (x + w, z) in left: w += 1
        h = 1
        while all((x + i, z + h) in left for i in range(w)): h += 1
        out.append((x, z, w, h))
        left -= {(x + i, z + j) for i in range(w) for j in range(h)}
    return out


def walk(steps):
    """the GBA's movement commands for a ride (the porter's names)"""
    return [('walk_fast_' + d, []) for d in steps]


def build(gba, p, taken):
    """-> (trigger squares {x, z, script, var}, the arrival label) for our floor; the scripts go into the port's
    labels and movements. `taken`: our squares that already have a trigger of the GBA's (theirs stand)"""
    F = Floor(gba)
    g = p.g
    calm = p.var(calm_var(gba))
    triggers = []
    mv_names = {}

    def movement(steps):
        """a ride's movement (a fast walk a square): shared between squares"""
        key = tuple(steps)
        if key not in mv_names:
            name = '_cv_current_%d' % len(mv_names)
            out = []
            for d in steps:
                s = 'WalkFast' + HG_DIR[d]
                if out and out[-1][0] == s: out[-1][1] += 1
                else: out.append([s, 1])
            p.movements[name] = out
            mv_names[key] = name
        return mv_names[key]

    def do_ride(steps, end):
        """the ride; onto land, the last step is off the Pokemon and a hop (the GBA's CreateStopSurfingTask)"""
        out = []
        on_water = steps[:-1] if end == 'land' else steps
        if on_water: out += ['ApplyMovement obj_player, %s' % movement(on_water), 'WaitMovement']
        if end == 'land': out += SP.hop_off(p, HG_DIR[steps[-1]])
        return out + ['ReleaseAll', 'End']

    def ride_block(lbl, layout, x, z):
        """the ride from (x, z) by `layout`, a boulder in the way (its flag unset: it's there) stopping it short"""
        steps, path, end = F.ride(layout, x, z)
        out, after = [], []
        for k, (b, flag) in enumerate(F.boulders):
            if b in path:
                l = '%s_%s_b%d' % (lbl, layout, k)
                out.append('GoToIfUnset %s, %s' % (p.flag(flag), l))
                s2, _, e2 = F.ride(layout, x, z, present=(b,))
                after += [l + ':'] + do_ride(s2, e2)
        return out + do_ride(steps, end) + after

    # each square's ride, under a label of its own; the squares a var turns on are one trigger script, which finds
    # the player's square (HeartGold keeps a map's events in 0x800 bytes: a trigger of 16 a square won't fit, so
    # the trigger squares are rectangles)
    name = gba.replace('_Frlg', '')
    groups = {}             # trigger var -> {square: its ride's lines}
    for x, z in F.squares():
        if (x, z) in taken: continue
        rides = {lay: F.ride(lay, x, z) for lay in ('current', 'calm') if F.current(lay, x, z)}
        if not any(r[0] for r in rides.values()): continue      # (nowhere to go: the GBA's ride stops at once)
        lbl = '%s_cv_Current_%d_%d' % (name, x, z)
        if 'current' in rides and 'calm' in rides:
            lines = ['CompareVarToValue %s, 1' % calm, 'GoToIfEq %s_calm' % lbl]
            lines += ride_block(lbl, 'current', x, z) + [lbl + '_calm:'] + ride_block(lbl, 'calm', x, z)
            var = p.var('CV_ALWAYS_ZERO')                 # (a var of ours nothing sets: always a trigger)
        elif 'current' in rides:
            lines = ride_block(lbl, 'current', x, z)
            var = calm                                     # (a trigger while the currents run)
        else:
            lines = ['CompareVarToValue %s, 1' % calm, 'GoToIfEq %s_calm' % lbl, 'ReleaseAll', 'End', lbl + '_calm:']
            lines += ride_block(lbl, 'calm', x, z)
            var = p.var('CV_ALWAYS_ZERO')
        groups.setdefault(var, {})[(x, z)] = [lbl + ':'] + lines
    for k, (var, rides_) in enumerate(sorted(groups.items())):
        lbl = '%s_cv_Currents_%d' % (name, k)
        lines = ['LockAll', 'GetPlayerCoords 0x8008, 0x8009']
        cols = sorted({x for x, _ in rides_})
        lines += sum((['CompareVarToValue 0x8008, %d' % x, 'GoToIfEq %s_x%d' % (lbl, x)] for x in cols), []) + ['ReleaseAll', 'End']
        for x in cols:
            lines.append('%s_x%d:' % (lbl, x))
            for x_, z in sorted(q for q in rides_ if q[0] == x):
                lines += ['CompareVarToValue 0x8009, %d' % z, 'GoToIfEq %s_cv_Current_%d_%d' % (name, x, z)]
            lines += ['ReleaseAll', 'End']
        for q in sorted(rides_): lines += rides_[q]
        g.labels[lbl] = [('cv_raw', lines)]
        for x, z, w, h in rectangles(set(rides_)):
            triggers.append(dict(_ds=(x, z), _wh=(w, h), script=lbl, var=var, var_value='0', _val=0))
    # falling in: once on each arrival, is the player on a square of water a warp brings them to?
    arrive = None
    if F.landings():
        arrive = '%s_cv_Arrive' % gba.replace('_Frlg', '')
        lines = ['SetVar %s, 1' % p.var(ARRIVED), 'GetPlayerCoords 0x8008, 0x8009']
        for k, (x, z) in enumerate(F.landings()):
            nxt = '%s_%d' % (arrive, k)
            lines += ['CompareVarToValue 0x8008, %d' % x, 'GoToIfNe %s' % nxt,
                      'CompareVarToValue 0x8009, %d' % z, 'GoToIfNe %s' % nxt,
                      'SetVar %s, 1' % p.var('VAR_TEMP_1'), 'End', nxt + ':']
        g.labels[arrive] = [('cv_raw', lines + ['End'])]
    return triggers, arrive


def rides(gba, starts):
    """the GBA's scripted rides (EnterByFalling's RideCurrentFar / Close), redone as the current goes from our
    square of each: {movement label: GBA square it starts from}"""
    F = Floor(gba)
    out = {}
    for label, (gx, gy) in starts.items():
        x, z = F.xy(gx, gy)
        steps, _, end = F.ride('current', x, z)
        assert end != 'land', (gba, label)
        out[label] = walk(steps) + [('step_end', [])]
    return out
