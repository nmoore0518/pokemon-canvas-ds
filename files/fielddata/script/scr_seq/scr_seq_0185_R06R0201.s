#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R06R0201.h"
#include "msgdata/msg/msg_0335_R06R0201.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route6_NorthEntrance_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route6_NorthEntrance_EventScript_Guard
	ScrDef Route6_NorthEntrance_EventScript_GuardTriggerLeft
	ScrDef Route6_NorthEntrance_EventScript_GuardTriggerMid
	ScrDef Route6_NorthEntrance_EventScript_GuardTriggerRight
	ScrDefEnd
	
Route6_NorthEntrance_EventScript_Guard:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0335_R06R0201_Route6_NorthEntrance_Text_HiHowsItGoing
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route6_NorthEntrance_EventScript_GuardTriggerLeft:
	LockAll
	SetVar 0x4001, 0
	GoTo Route6_NorthEntrance_EventScript_GuardTrigger
	End
	
Route6_NorthEntrance_EventScript_GuardTriggerMid:
	LockAll
	SetVar 0x4001, 1
	GoTo Route6_NorthEntrance_EventScript_GuardTrigger
	End
	
Route6_NorthEntrance_EventScript_GuardTriggerRight:
	LockAll
	SetVar 0x4001, 2
	GoTo Route6_NorthEntrance_EventScript_GuardTrigger
	End
	
Route6_NorthEntrance_EventScript_GuardTrigger:
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterRight
	WaitMovement
	GoToIfSet 0x2131, Route6_NorthEntrance_EventScript_GiveTea
	NPCMsg msg_0335_R06R0201_Route6_NorthEntrance_Text_ThirstyOnGuardDuty
	WaitButton
	CanvasCloseMsg
	ApplyMovement obj_player, Route6_NorthEntrance_Movement_BlockPlayerEntry
	WaitMovement
	CanvasCloseMsg
	ReleaseAll
	End
	
Route6_NorthEntrance_EventScript_GiveTea:
	TakeItem 113, 1, VAR_SPECIAL_RESULT
	GoTo Route6_NorthEntrance_EventScript_GuardDrinkTea
	End
	
Route6_NorthEntrance_EventScript_GuardDrinkTea:
	NPCMsg msg_0335_R06R0201_Route6_NorthEntrance_Text_ThatTeaLooksTasty
	WaitButton
	CanvasCloseMsg
	CompareVarToValue 0x4001, 0
	CallIfEq Route6_NorthEntrance_EventScript_WalkToGuardLeft
	CompareVarToValue 0x4001, 1
	CallIfEq Route6_NorthEntrance_EventScript_WalkToGuardMid
	CompareVarToValue 0x4001, 2
	CallIfEq Route6_NorthEntrance_EventScript_WalkToGuardRight
	NPCMsg msg_0335_R06R0201_Route6_NorthEntrance_Text_ThanksIllShareTeaWithGuards
	WaitButton
	SetVar 0x5035, 1
	CloseMsg
	ReleaseAll
	End
	
Route6_NorthEntrance_EventScript_WalkToGuardLeft:
	ApplyMovement obj_player, Route6_NorthEntrance_Movement_WalkToGuardLeft
	WaitMovement
	Return
	
Route6_NorthEntrance_EventScript_WalkToGuardMid:
	ApplyMovement obj_player, Route6_NorthEntrance_Movement_WalkToGuardMid
	WaitMovement
	Return
	
Route6_NorthEntrance_EventScript_WalkToGuardRight:
	ApplyMovement obj_player, Route6_NorthEntrance_Movement_WalkToGuardRight
	WaitMovement
	Return

_cv_stop:
	NPCMsg msg_0335_R06R0201_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
Common_Movement_WalkInPlaceFasterRight:
	WalkOnSpotFasterEast
	EndMovement

	.balign 4, 0
Route6_NorthEntrance_Movement_BlockPlayerEntry:
	WalkNormalSouth
	EndMovement

	.balign 4, 0
Route6_NorthEntrance_Movement_WalkToGuardLeft:
	WalkNormalEast 2
	EndMovement

	.balign 4, 0
Route6_NorthEntrance_Movement_WalkToGuardMid:
	WalkNormalEast
	EndMovement

	.balign 4, 0
Route6_NorthEntrance_Movement_WalkToGuardRight:
	WalkOnSpotNormalEast
	EndMovement
	.balign 4, 0
