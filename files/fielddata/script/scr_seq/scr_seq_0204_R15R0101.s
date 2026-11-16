#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R15R0101.h"
#include "msgdata/msg/msg_0353_R15R0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route15_WestEntrance_1F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route15_WestEntrance_1F_EventScript_Guard
	ScrDefEnd
	
Route15_WestEntrance_1F_EventScript_Guard:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0353_R15R0101_Route15_WestEntrance_1F_Text_OaksAideCameByHere
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0353_R15R0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
