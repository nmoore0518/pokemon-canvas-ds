#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_UNDERGROUND_WEST.h"
#include "msgdata/msg/msg_0981_CV_CANVAS_UNDERGROUND_WEST.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's UndergroundPath_WestEntrance_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef UndergroundPath_WestEntrance_EventScript_BaldingMan
	ScrDefEnd
	
UndergroundPath_WestEntrance_EventScript_BaldingMan:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0981_CV_CANVAS_UNDERGROUND_WEST_UndergroundPath_WestEntrance_Text_SleepyMonNearCeladon
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0981_CV_CANVAS_UNDERGROUND_WEST_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
