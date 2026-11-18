#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_UNDERGROUND_EAST.h"
#include "msgdata/msg/msg_0982_CV_CANVAS_UNDERGROUND_EAST.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's UndergroundPath_EastEntrance_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef UndergroundPath_EastEntrance_EventScript_Woman
	ScrDefEnd
	
UndergroundPath_EastEntrance_EventScript_Woman:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0982_CV_CANVAS_UNDERGROUND_EAST_UndergroundPath_EastEntrance_Text_DoYouGoToCeladonDeptStore
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0982_CV_CANVAS_UNDERGROUND_EAST_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
