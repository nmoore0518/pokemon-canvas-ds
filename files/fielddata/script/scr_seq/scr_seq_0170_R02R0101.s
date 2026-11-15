#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R02R0101.h"
#include "msgdata/msg/msg_0321_R02R0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route2_Frlg#north by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route2_EventScript_DiglettsCaveSign
	ScrDefEnd
	
Route2_EventScript_DiglettsCaveSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0321_R02R0101_Route2_Text_DiglettsCave
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0321_R02R0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
