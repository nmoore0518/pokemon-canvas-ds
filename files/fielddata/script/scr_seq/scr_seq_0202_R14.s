#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R14.h"
#include "msgdata/msg/msg_0351_R14.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route14_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route14_EventScript_RouteSign
	ScrDefEnd
	
Route14_EventScript_RouteSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0351_R14_Route14_Text_RouteSign
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0351_R14_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
