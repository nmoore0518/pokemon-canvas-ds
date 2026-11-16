#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R16.h"
#include "msgdata/msg/msg_0354_R16.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route16_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route16_EventScript_RouteSign
	ScrDef Route16_OnResume
	ScrDef Route16_OnTransition
	ScrDefEnd
	
Route16_EventScript_RouteSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0354_R16_Route16_Text_RouteSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route16_OnResume:
	CallIfSet 0x2032, Route16_EventScript_RemoveSnorlax
	End
	
Route16_OnTransition:
	CompareVarToValue 0x5030, 1
	CallIfEq Route16_OnTransitionCyclingRoad
	End
	
Route16_EventScript_RemoveSnorlax:
	HidePerson 0x401D
	Return
	
Route16_OnTransitionCyclingRoad:
	SetFlag 0x210F
	Return

_cv_stop:
	NPCMsg msg_0354_R16_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
