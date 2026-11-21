#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R07R0101.h"
#include "msgdata/msg/msg_0337_R07R0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route7_EastEntrance_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route7_EastEntrance_EventScript_Guard
	ScrDef Route7_EastEntrance_EventScript_GuardTriggerTop
	ScrDef Route7_EastEntrance_EventScript_GuardTriggerMid
	ScrDef Route7_EastEntrance_EventScript_GuardTriggerBottom
	ScrDefEnd
	
Route7_EastEntrance_EventScript_Guard:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0337_R07R0101_Route7_EastEntrance_Text_HiHowsItGoing
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route7_EastEntrance_EventScript_GuardTriggerTop:
	LockAll
	SetVar 0x4001, 0
	GoTo Route7_EastEntrance_EventScript_GuardTrigger
	End
	
Route7_EastEntrance_EventScript_GuardTriggerMid:
	LockAll
	SetVar 0x4001, 1
	GoTo Route7_EastEntrance_EventScript_GuardTrigger
	End
	
Route7_EastEntrance_EventScript_GuardTriggerBottom:
	LockAll
	SetVar 0x4001, 2
	GoTo Route7_EastEntrance_EventScript_GuardTrigger
	End
	
Route7_EastEntrance_EventScript_GuardTrigger:
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	GoToIfSet 0x2131, Route7_EastEntrance_EventScript_GiveTea
	NPCMsg msg_0337_R07R0101_Route7_EastEntrance_Text_ThirstyOnGuardDuty
	WaitButton
	CanvasCloseMsg
	ApplyMovement obj_player, Route7_EastEntrance_Movement_BlockPlayerEntry
	WaitMovement
	CanvasCloseMsg
	ReleaseAll
	End
	
Route7_EastEntrance_EventScript_GiveTea:
	TakeItem 113, 1, VAR_SPECIAL_RESULT
	GoTo Route7_EastEntrance_EventScript_GuardDrinkTea
	End
	
Route7_EastEntrance_EventScript_GuardDrinkTea:
	NPCMsg msg_0337_R07R0101_Route7_EastEntrance_Text_ThatTeaLooksTasty
	WaitButton
	CanvasCloseMsg
	CompareVarToValue 0x4001, 0
	CallIfEq Route7_EastEntrance_WalkToGuardTop
	CompareVarToValue 0x4001, 1
	CallIfEq Route7_EastEntrance_WalkToGuardMid
	CompareVarToValue 0x4001, 2
	CallIfEq Route7_EastEntrance_WalkToGuardBottom
	NPCMsg msg_0337_R07R0101_Route7_EastEntrance_Text_ThanksIllShareTeaWithGuards
	WaitButton
	SetVar 0x5035, 1
	CloseMsg
	ReleaseAll
	End
	
Route7_EastEntrance_WalkToGuardTop:
	ApplyMovement obj_player, Route7_EastEntrance_Movement_WalkToGuardTop
	WaitMovement
	Return
	
Route7_EastEntrance_WalkToGuardMid:
	ApplyMovement obj_player, Route7_EastEntrance_Movement_WalkToGuardMid
	WaitMovement
	Return
	
Route7_EastEntrance_WalkToGuardBottom:
	ApplyMovement obj_player, Route7_EastEntrance_Movement_WalkToGuardBottom
	WaitMovement
	Return

_cv_stop:
	NPCMsg msg_0337_R07R0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
Common_Movement_WalkInPlaceFasterUp:
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
Route7_EastEntrance_Movement_BlockPlayerEntry:
	WalkNormalWest
	EndMovement

	.balign 4, 0
Route7_EastEntrance_Movement_WalkToGuardTop:
	WalkOnSpotNormalNorth
	EndMovement

	.balign 4, 0
Route7_EastEntrance_Movement_WalkToGuardMid:
	WalkNormalNorth
	EndMovement

	.balign 4, 0
Route7_EastEntrance_Movement_WalkToGuardBottom:
	WalkNormalNorth 2
	EndMovement
	.balign 4, 0
