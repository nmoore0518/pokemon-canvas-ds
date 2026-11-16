#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_W19.h"
#include "msgdata/msg/msg_0740_W19.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route19_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route19_EventScript_RouteSign
	ScrDefEnd
	
Route19_EventScript_RouteSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0740_W19_Route19_Text_RouteSign
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0740_W19_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
