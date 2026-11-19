#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R18.h"
#include "msgdata/msg/msg_0358_R18.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route18_Frlg#world by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route18_EventScript_CyclingRoadSign
	ScrDef Route18_EventScript_RouteSign
	ScrDef Route18_OnTransition
	ScrDefEnd
	
Route18_EventScript_CyclingRoadSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0358_R18_Route18_Text_CyclingRoadSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route18_EventScript_RouteSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0358_R18_Route18_Text_RouteSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route18_OnTransition:
	CompareVarToValue 0x5030, 1
	CallIfEq Route18_OnTransitionCyclingRoad
	End
	
Route18_OnTransitionCyclingRoad:
	SetFlag 0x210F
	Return

_cv_stop:
	NPCMsg msg_0358_R18_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
