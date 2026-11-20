"""The GBA game's in-game trades as HeartGold's (Nick: "In-game trades don't work anywhere yet"): HeartGold trades
through its own NPC trade data (a/1/1/2: one 0x54-byte entry a trade) and names (msg_0200: every trade's nickname,
then every trade's trainer's name), run by its LoadNPCTrade / NPCTradeExec script commands. HeartGold's own 13 stay
as they are (Johto will want them); the GBA's Kanto trades go after them, NPC_TRADE_CANVAS_* in
include/constants/npc_trade.h and engine/include/npc_trade.h (both must list them, in this order: NPC_TRADE_MAX
moves the trainers' names along). The porter turns the GBA's trade scripts into HeartGold's commands
(port/specials.py: the trade number from data/trades.json). Idempotent; run before the porter."""
import json, os, re, struct, sys
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
from nitro import read_narc, write_narc
import slots

GBA = '/home/claude/gym-trainer-hack'
NARC = os.path.join(slots.ROOT, 'files/a/1/1/2')
MSG = os.path.join(slots.ROOT, 'files/msgdata/msg/msg_0200.json')
OUT = os.path.join(HERE, 'data', 'trades.json')
HG_TRADES = 13
# the GBA's trades in Kanto, in the order they are added (their HeartGold numbers 13 on)
TRADES = ['INGAME_TRADE_MR_MIME', 'INGAME_TRADE_JYNX', 'INGAME_TRADE_NIDORAN', 'INGAME_TRADE_FARFETCHD',
          'INGAME_TRADE_NIDORINOA', 'INGAME_TRADE_LICKITUNG', 'INGAME_TRADE_ELECTRODE', 'INGAME_TRADE_TANGELA',
          'INGAME_TRADE_SEEL']
ITEMS = {'ITEM_TINY_MUSHROOM': 'ITEM_TINYMUSHROOM'}
MAIL = {'ITEM_FAB_MAIL'}            # (HeartGold's mail is made with its own words: the trade's mon comes without it)


def _define(path, name):
    m = re.search(r'#define\s+%s\s+(\w+)' % re.escape(name), open(os.path.join(slots.ROOT, path)).read())
    return int(m.group(1), 0)


def gba_trades():
    """the GBA's trade table (FireRed's side of each #if) -> {constant: {field: value}}"""
    src = open(os.path.join(GBA, 'src/data/trade.h')).read()
    src = re.sub(r'#if defined\(FIRERED\)(.*?)#else.*?#endif', r'\1', src, flags=re.S)
    out = {}
    for name, body in re.findall(r'\[(INGAME_TRADE_\w+)\]\s*=\s*\{(.*?)\n    \}', src, re.S):
        f = dict(re.findall(r'\.(\w+)\s*=\s*([^\n]*?),?\s*$', body, re.M))
        out[name] = f
    return out


def title(s):
    """the GBA's capitals as HeartGold writes names (its apostrophe the curly one)"""
    return ' '.join(w[:1] + w[1:].lower() for w in s.split(' ')).replace("'", '\u2019')


def entry(f):
    ivs = [int(v) for v in re.findall(r'\d+', f['ivs'])]                 # (HP, Atk, Def, Speed, SpAtk, SpDef: as HeartGold's)
    cond = [int(v) for v in re.findall(r'\d+', f['conditions'])]          # (cool, beauty, cute, smart, tough: as HeartGold's)
    item = f['heldItem']
    item = 0 if item in MAIL or item == 'ITEM_NONE' else _define('include/constants/items.h', ITEMS.get(item, item))
    sp = lambda s: _define('include/constants/species.h', s)
    return struct.pack('<21i', sp(f['species']), *ivs, 0, int(f['otId']), *cond, (lambda v: v - (1 << 32) if v >= 1 << 31 else v)(int(f['personality'], 0)),
                       item, 1 if f['otGender'] == 'FEMALE' else 0, int(f['sheen']), 2, sp(f['requestedSpecies']), 0)


def main():
    g = gba_trades()
    files, btnf = read_narc(open(NARC, 'rb').read())
    files = files[:HG_TRADES] + [entry(g[t]) for t in TRADES]
    open(NARC, 'wb').write(write_narc(files, btnf))
    msg = json.load(open(MSG))
    old = [m['en_US'] for m in msg['messages']]
    nicks = old[:HG_TRADES] + [title(re.match(r'_\("(.*)"\)', g[t]['nickname']).group(1)) for t in TRADES]
    n = len(old) // 2              # (the names: every nickname, then every trainer - ours already in, on a second run)
    ots = old[n:n + HG_TRADES] + [title(re.match(r'_\("(.*)"\)', g[t]['otName']).group(1)) for t in TRADES]
    msg['messages'] = [{'id': 'msg_0200_%05d' % i, 'en_US': s} for i, s in enumerate(nicks + ots)]
    json.dump(msg, open(MSG, 'w'), indent=2, ensure_ascii=False); open(MSG, 'a').write('\n')
    # the enums both builds use must have them all
    for h in ('include/constants/npc_trade.h', 'engine/include/npc_trade.h'):
        src = open(os.path.join(slots.ROOT, h)).read()
        n = len(re.findall(r'^\s+NPC_TRADE_\w+,', src.split('typedef enum NpcTradeNum')[1].split('}')[0], re.M)) - 1
        assert n == HG_TRADES + len(TRADES), (h, n, 'list NPC_TRADE_CANVAS_* there')
    json.dump({t: HG_TRADES + i for i, t in enumerate(TRADES)}, open(OUT, 'w'), indent=1)
    print('trades: %d of HeartGold\'s, %d of ours' % (HG_TRADES, len(TRADES)))


if __name__ == '__main__':
    main()
