"""hg-engine patches HeartGold's code at fixed addresses, so the decomp's ARM9 and overlays must keep the retail
sizes (change data in them in place; add code in the engine instead). Run on the decomp ROM before patching."""
import json, os, subprocess, sys, tempfile
HERE = os.path.dirname(os.path.abspath(__file__))
rom = sys.argv[1]
with tempfile.TemporaryDirectory() as T:
    subprocess.run([os.path.join(HERE, '..', '..', 'engine', 'tools', 'ndstool'), '-x', rom, '-9', T + '/arm9.bin', '-y', T + '/ov'],
                   check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    now = {'arm9': os.path.getsize(T + '/arm9.bin')}
    now.update({f: os.path.getsize(os.path.join(T, 'ov', f)) for f in os.listdir(T + '/ov')})
want = json.load(open(os.path.join(HERE, 'data', 'retail_code_sizes.json')))
bad = [k for k in want if now.get(k) != want[k]]
if bad:
    sys.exit('code layout changed (hg-engine would patch the wrong places): ' + ', '.join('%s %s->%s' % (k, want[k], now.get(k)) for k in bad))
print('code layout matches retail')
