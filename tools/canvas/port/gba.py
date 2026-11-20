"""Read the GBA game's scripts: every label in data/maps/*/scripts.inc and data/scripts/*.inc (and the other .inc
files they keep text and movements in), as commands, strings or movement steps.

    from port import gba; g = gba.Gba(); g.labels['PalletTown_EventScript_FatMan']   -> [('msgbox', [...]), ...]
"""
import glob, json, os, re, sys

GBA = os.environ.get('GBA_REPO', '/home/claude/gym-trainer-hack')
P = lambda *a: os.path.join(GBA, *a)


def split_args(s):
    out, depth, cur = [], 0, ''
    for ch in s:
        if ch == ',' and depth == 0:
            out.append(cur.strip()); cur = ''
            continue
        if ch in '([': depth += 1
        if ch in ')]': depth -= 1
        cur += ch
    if cur.strip(): out.append(cur.strip())
    return out


class Gba:
    def __init__(self):
        self.labels = {}       # label -> list of (cmd, args)          (scripts and movements)
        self.texts = {}        # label -> string                        (.string lines joined)
        self.equ = {}          # .equ / .set constants
        self.where = {}        # label -> file
        files = sorted(glob.glob(P('data/maps/*/scripts.inc')) + glob.glob(P('data/maps/*/movements.inc')) +
                       glob.glob(P('data/maps/*/text.inc')) + glob.glob(P('data/scripts/*.inc')) +
                       glob.glob(P('data/text/*.inc')) + [P('data/event_scripts.s')])
        for f in files:
            self._read(f)
        self.defines = {}
        for h in sorted(glob.glob(P('include/constants/*.h'))) + [P('include/global.h')]:
            if not os.path.exists(h): continue
            src = open(h, errors='ignore').read()
            for n, v in re.findall(r'#define\s+(\w+)\s+([^\s/]+)', src):
                self.defines.setdefault(n, v)
            src = re.sub(r'//[^\n]*|/\*.*?\*/', '', src, flags=re.S)
            for body in re.findall(r'\benum\s*\w*\s*\{([^}]*)\}', src):     # enum members count up
                i = 0
                for item in body.split(','):
                    item = item.strip()
                    if not item or item.startswith('#'): continue
                    n, _, v = item.partition('=')
                    n = n.strip()
                    if not re.match(r'^[A-Za-z_]\w*$', n): continue
                    if v.strip():
                        self.defines.setdefault(n, v.strip())
                        i = None
                        try: i = int(v.strip(), 0)
                        except ValueError: pass
                    else:
                        if i is not None: self.defines.setdefault(n, str(i))
                    if i is not None: i += 1

    def _read(self, f):
        cur = None
        macro = None               # (a .macro in a map's scripts: its lines, expanded where it's used; no arguments)
        local_macros = {}
        local_equ = {}             # (a file's own .equ: three of the aides' files each set REQUIRED_CAUGHT_MONS their own way)
        pmacro, pmacros = None, {}   # (a .macro with arguments: its lines as text, the arguments put in where used)
        sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
        import scrapped        # (less what the port leaves out: scrapped.py)
        queue = scrapped.edit_source(f, open(f, errors='ignore').read()).splitlines(True)
        while queue:
            raw = queue.pop(0)
            if pmacro is not None:
                if raw.strip() == '.endm': pmacro = None
                else: pmacro[1].append(raw)
                continue
            mm = re.match(r'^\s*\.macro\s+(\w+)\s+(.+)$', raw.split('@')[0])
            if mm:
                pmacro = pmacros[mm.group(1)] = ([a.split(':')[0].strip() for a in mm.group(2).split(',')], []); continue
            mm = re.match(r'^\s*(\w+)\s+(.*)$', raw.split('@')[0])
            if mm and mm.group(1) in pmacros:
                names, body = pmacros[mm.group(1)]
                vals = [v.strip() for v in mm.group(2).split(',')]
                out = []
                for b in body:
                    for n_, v_ in zip(names, vals): b = b.replace('\\' + n_, v_)
                    out.append(b.replace('\\()', ''))
                queue[0:0] = out
                continue
            line = raw.split('@')[0].rstrip() if '"' not in raw else raw.rstrip('\n')
            if '"' in line:
                # keep strings intact; drop a trailing @ comment after the closing quote
                q = line.rfind('"')
                line = line[:q + 1] + line[q + 1:].split('@')[0]
            s = line.strip()
            if not s:
                continue
            m = re.match(r'^\.macro\s+(\w+)\s*$', s)
            if m:
                macro = local_macros.setdefault(m.group(1), []); continue
            if s == '.endm':
                macro = None; continue
            if macro is not None:
                parts = s.split(None, 1)
                macro.append((parts[0], split_args(parts[1]) if len(parts) > 1 else [])); continue
            m = re.match(r'^(\w+)::?$', s)
            if m:
                cur = m.group(1)
                self.labels.setdefault(cur, [])
                self.where[cur] = f
                continue
            m = re.match(r'^\.(equ|set)\s+(\w+)\s*,\s*(.+)$', s)
            if m:
                local_equ[m.group(2)] = m.group(3).strip(); self.equ.setdefault(m.group(2), m.group(3).strip()); continue
            if s.startswith('.include') or s.startswith('.align') or s.startswith('.section'):
                continue
            if cur is None:
                continue
            m = re.match(r'^\.string\s+"(.*)"$', s)
            if m:
                self.texts[cur] = self.texts.get(cur, '') + m.group(1)
                continue
            parts = s.split(None, 1)
            cmd = parts[0]
            args = split_args(parts[1]) if len(parts) > 1 else []
            if local_equ: args = [local_equ.get(a, a) for a in args]
            if cmd in local_macros and not args:
                self.labels[cur].extend(local_macros[cmd]); continue
            self.labels[cur].append((cmd, args))

    def value(self, name):
        """resolve a constant to an int where we can (equ, defines, numbers)"""
        seen = 0
        while isinstance(name, str) and seen < 10:
            name = name.strip()
            if re.match(r'^-?(0x[0-9a-fA-F]+|\d+)$', name):
                return int(name, 0)
            if re.search(r'[-+*/()<>|&]', name):         # a small expression: X + 1, (A << 2)...
                parts = re.split(r'(\W)', name)
                vals = []
                for t in parts:
                    if re.match(r'^[A-Za-z_]\w*$', t):
                        v = self.value(t)
                        if v is None: return None
                        vals.append(str(v))
                    else: vals.append(t)
                try: return int(eval(''.join(vals), {'__builtins__': {}}))
                except Exception: return None
            name = self.equ.get(name, self.defines.get(name, None))
            seen += 1
        return None


def map_json(name):
    sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
    import scrapped        # (without what the port leaves out: scrapped.py)
    return scrapped.clean(json.load(open(P('data/maps', name, 'map.json'))))


_MAP_DIRS = None


def map_dir(map_id):
    """MAP_PALLET_TOWN -> PalletTown_Frlg (the map's folder in data/maps)"""
    global _MAP_DIRS
    if _MAP_DIRS is None:
        _MAP_DIRS = {}
        for d in sorted(os.listdir(P('data/maps'))):
            f = P('data/maps', d, 'map.json')
            if os.path.exists(f):
                i = json.load(open(f)).get('id')
                if i and (i not in _MAP_DIRS or d.endswith('_Frlg')): _MAP_DIRS[i] = d
    return _MAP_DIRS.get(map_id)
