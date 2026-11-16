#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_ROUTE_6_UNDERGROUND_PATH_GATE.h"
#include "msgdata/msg/msg_0865_CV_ROUTE_6_UNDERGROUND_PATH_GATE.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's UndergroundPath_SouthEntrance_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef UndergroundPath_SouthEntrance_EventScript_Woman
	ScrDefEnd
	
UndergroundPath_SouthEntrance_EventScript_Woman:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0865_CV_ROUTE_6_UNDERGROUND_PATH_GATE_UndergroundPath_SouthEntrance_Text_PeopleLoseThingsInTheDarkness
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0865_CV_ROUTE_6_UNDERGROUND_PATH_GATE_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
