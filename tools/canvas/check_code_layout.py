"""hg-engine patches HeartGold's code at fixed addresses, so the decomp's ARM9 and overlays must keep the retail
sizes (change data in them in place; add code in the engine instead). Run on the decomp ROM before patching.
Sizes are compared decompressed: the compressed size moves whenever data changes, the layout does not.
Needs ndspy (run with engine/.venv/bin/python). `--save` rewrites the reference from a ROM known to match retail."""
import json, os, subprocess, sys, tempfile
import ndspy.codeCompression as cc
HERE = os.path.dirname(os.path.abspath(__file__))
rom = sys.argv[1]
with tempfile.TemporaryDirectory() as T:
    subprocess.run([os.path.join(HERE, '..', '..', 'engine', 'tools', 'ndstool'), '-x', rom, '-9', T + '/arm9.bin', '-y', T + '/ov'],
                   check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    def size(path):
        b = open(path, 'rb').read()
        try:
            return len(cc.decompress(b))
        except Exception:
            return len(b)
    now = {'arm9': size(T + '/arm9.bin')}
    now.update({f: size(os.path.join(T, 'ov', f)) for f in os.listdir(T + '/ov')})
if '--save' in sys.argv:
    json.dump(now, open(os.path.join(HERE, 'data', 'retail_code_sizes.json'), 'w'), indent=0, sort_keys=True)
    sys.exit('saved')
want = json.load(open(os.path.join(HERE, 'data', 'retail_code_sizes.json')))
bad = [k for k in want if now.get(k) != want[k]]
if bad:
    sys.exit('code layout changed (hg-engine would patch the wrong places): ' + ', '.join('%s %s->%s' % (k, want[k], now.get(k)) for k in bad))
print('code layout matches retail')
