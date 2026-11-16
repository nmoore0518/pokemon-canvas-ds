#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R05R0301.h"
#include "msgdata/msg/msg_0332_R05R0301.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route5_SouthEntrance_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route5_SouthEntrance_EventScript_Guard
	ScrDef Route5_SouthEntrance_EventScript_GuardTriggerLeft
	ScrDef Route5_SouthEntrance_EventScript_GuardTriggerMid
	ScrDef Route5_SouthEntrance_EventScript_GuardTriggerRight
	ScrDefEnd
	
Route5_SouthEntrance_EventScript_Guard:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0332_R05R0301_Route5_SouthEntrance_Text_HiHowsItGoing
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route5_SouthEntrance_EventScript_GuardTriggerLeft:
	LockAll
	SetVar 0x4001, 0
	GoTo Route5_SouthEntrance_EventScript_GuardTrigger
	End
	
Route5_SouthEntrance_EventScript_GuardTriggerMid:
	LockAll
	SetVar 0x4001, 1
	GoTo Route5_SouthEntrance_EventScript_GuardTrigger
	End
	
Route5_SouthEntrance_EventScript_GuardTriggerRight:
	LockAll
	SetVar 0x4001, 2
	GoTo Route5_SouthEntrance_EventScript_GuardTrigger
	End
	
Route5_SouthEntrance_EventScript_GuardTrigger:
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterLeft
	WaitMovement
	GoToIfSet 0x2131, Route5_SouthEntrance_EventScript_GiveTea
	NPCMsg msg_0332_R05R0301_Route5_SouthEntrance_Text_ThirstyOnGuardDuty
	WaitButton
	CloseMsg
	ApplyMovement obj_player, Route5_SouthEntrance_Movement_BlockPlayerEntry
	WaitMovement
	ReleaseAll
	End
	
Route5_SouthEntrance_EventScript_GiveTea:
	TakeItem 113, 1, VAR_SPECIAL_RESULT
	GoTo Route5_SouthEntrance_EventScript_GuardDrinkTea
	End
	
Route5_SouthEntrance_EventScript_GuardDrinkTea:
	NPCMsg msg_0332_R05R0301_Route5_SouthEntrance_Text_ThatTeaLooksTasty
	WaitButton
	CloseMsg
	CompareVarToValue 0x4001, 0
	CallIfEq Route5_SouthEntrance_EventScript_WalkToGuardLeft
	CompareVarToValue 0x4001, 1
	CallIfEq Route5_SouthEntrance_EventScript_WalkToGuardMid
	CompareVarToValue 0x4001, 2
	CallIfEq Route5_SouthEntrance_EventScript_WalkToGuardRight
	NPCMsg msg_0332_R05R0301_Route5_SouthEntrance_Text_ThanksIllShareTeaWithGuards
	WaitButton
	SetVar 0x5035, 1
	CloseMsg
	ReleaseAll
	End
	
Route5_SouthEntrance_EventScript_WalkToGuardLeft:
	ApplyMovement obj_player, Route5_SouthEntrance_Movement_WalkToGuardLeft
	WaitMovement
	Return
	
Route5_SouthEntrance_EventScript_WalkToGuardMid:
	ApplyMovement obj_player, Route5_SouthEntrance_Movement_WalkToGuardMid
	WaitMovement
	Return
	
Route5_SouthEntrance_EventScript_WalkToGuardRight:
	ApplyMovement obj_player, Route5_SouthEntrance_Movement_WalkToGuardRight
	WaitMovement
	Return

_cv_stop:
	NPCMsg msg_0332_R05R0301_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
Common_Movement_WalkInPlaceFasterLeft:
	WalkOnSpotFasterWest
	EndMovement

	.balign 4, 0
Route5_SouthEntrance_Movement_BlockPlayerEntry:
	WalkNormalNorth
	EndMovement

	.balign 4, 0
Route5_SouthEntrance_Movement_WalkToGuardLeft:
	WalkOnSpotNormalWest
	EndMovement

	.balign 4, 0
Route5_SouthEntrance_Movement_WalkToGuardMid:
	WalkNormalWest
	EndMovement

	.balign 4, 0
Route5_SouthEntrance_Movement_WalkToGuardRight:
	WalkNormalWest 2
	EndMovement
	.balign 4, 0
