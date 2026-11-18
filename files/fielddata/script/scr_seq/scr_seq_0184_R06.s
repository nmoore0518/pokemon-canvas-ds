#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R06.h"
#include "msgdata/msg/msg_0334_R06.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route6_Frlg#world by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route6_EventScript_UndergroundPathSign
	ScrDefEnd
	
Route6_EventScript_UndergroundPathSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0334_R06_Route6_Text_UndergroundPathSign
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0334_R06_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
