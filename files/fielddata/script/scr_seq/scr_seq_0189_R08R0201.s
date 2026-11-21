#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R08R0201.h"
#include "msgdata/msg/msg_0339_R08R0201.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route8_WestEntrance_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route8_WestEntrance_EventScript_Guard
	ScrDef Route8_WestEntrance_EventScript_GuardTriggerTop
	ScrDef Route8_WestEntrance_EventScript_GuardTriggerMid
	ScrDef Route8_WestEntrance_EventScript_GuardTriggerBottom
	ScrDefEnd
	
Route8_WestEntrance_EventScript_Guard:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0339_R08R0201_Route8_WestEntrance_Text_HiHowsItGoing
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route8_WestEntrance_EventScript_GuardTriggerTop:
	LockAll
	SetVar 0x4001, 0
	GoTo Route8_WestEntrance_EventScript_GuardTrigger
	End
	
Route8_WestEntrance_EventScript_GuardTriggerMid:
	LockAll
	SetVar 0x4001, 1
	GoTo Route8_WestEntrance_EventScript_GuardTrigger
	End
	
Route8_WestEntrance_EventScript_GuardTriggerBottom:
	LockAll
	SetVar 0x4001, 2
	GoTo Route8_WestEntrance_EventScript_GuardTrigger
	End
	
Route8_WestEntrance_EventScript_GuardTrigger:
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	GoToIfSet 0x2131, Route8_WestEntrance_EventScript_GiveTea
	NPCMsg msg_0339_R08R0201_Route8_WestEntrance_Text_ThirstyOnGuardDuty
	WaitButton
	CanvasCloseMsg
	ApplyMovement obj_player, Route8_WestEntrance_Movement_BlockPlayerEntry
	WaitMovement
	CanvasCloseMsg
	ReleaseAll
	End
	
Route8_WestEntrance_EventScript_GiveTea:
	TakeItem 113, 1, VAR_SPECIAL_RESULT
	GoTo Route8_WestEntrance_EventScript_GuardDrinkTea
	End
	
Route8_WestEntrance_EventScript_GuardDrinkTea:
	NPCMsg msg_0339_R08R0201_Route8_WestEntrance_Text_ThatTeaLooksTasty
	WaitButton
	CanvasCloseMsg
	CompareVarToValue 0x4001, 0
	CallIfEq Route8_WestEntrance_EventScript_WalkToGuardTop
	CompareVarToValue 0x4001, 1
	CallIfEq Route8_WestEntrance_EventScript_WalkToGuardMid
	CompareVarToValue 0x4001, 2
	CallIfEq Route8_WestEntrance_EventScript_WalkToGuardBottom
	NPCMsg msg_0339_R08R0201_Route8_WestEntrance_Text_ThanksIllShareTeaWithGuards
	WaitButton
	SetVar 0x5035, 1
	CloseMsg
	ReleaseAll
	End
	
Route8_WestEntrance_EventScript_WalkToGuardTop:
	ApplyMovement obj_player, Route8_WestEntrance_Movement_WalkToGuardTop
	WaitMovement
	Return
	
Route8_WestEntrance_EventScript_WalkToGuardMid:
	ApplyMovement obj_player, Route8_WestEntrance_Movement_WalkToGuardMid
	WaitMovement
	Return
	
Route8_WestEntrance_EventScript_WalkToGuardBottom:
	ApplyMovement obj_player, Route8_WestEntrance_Movement_WalkToGuardBottom
	WaitMovement
	Return

_cv_stop:
	NPCMsg msg_0339_R08R0201_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
Common_Movement_WalkInPlaceFasterUp:
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
Route8_WestEntrance_Movement_BlockPlayerEntry:
	WalkNormalEast
	EndMovement

	.balign 4, 0
Route8_WestEntrance_Movement_WalkToGuardTop:
	WalkOnSpotNormalNorth
	EndMovement

	.balign 4, 0
Route8_WestEntrance_Movement_WalkToGuardMid:
	WalkNormalNorth
	EndMovement

	.balign 4, 0
Route8_WestEntrance_Movement_WalkToGuardBottom:
	WalkNormalNorth 2
	EndMovement
	.balign 4, 0
