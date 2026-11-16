#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R16R0201.h"
#include "msgdata/msg/msg_0356_R16R0201.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route16_NorthEntrance_1F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route16_NorthEntrance_1F_EventScript_Guard
	ScrDef Route16_NorthEntrance_1F_EventScript_OldMan
	ScrDef EventScript_SetExitingCyclingRoad
	ScrDef EventScript_SetEnteringCyclingRoad
	ScrDef Route16_NorthEntrance_1F_EventScript_NeedBikeTriggerTop
	ScrDef Route16_NorthEntrance_1F_EventScript_NeedBikeTriggerMidTop
	ScrDef Route16_NorthEntrance_1F_EventScript_NeedBikeTriggerMid
	ScrDef Route16_NorthEntrance_1F_EventScript_NeedBikeTriggerMidBottom
	ScrDef Route16_NorthEntrance_1F_EventScript_NeedBikeTriggerBottom
	ScrDef Route16_NorthEntrance_1F_OnTransition
	ScrDefEnd
	
Route16_NorthEntrance_1F_EventScript_Guard:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0356_R16R0201_Route16_NorthEntrance_1F_Text_CyclingRoadIsDownhillCourse
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route16_NorthEntrance_1F_EventScript_OldMan:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0356_R16R0201_Route16_NorthEntrance_1F_Text_HowdYouGetInGoodEffort
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_SetExitingCyclingRoad:
	LockAll
	ClearFlag 0x210F
	SetVar 0x5030, 0
	ReleaseAll
	End
	
EventScript_SetEnteringCyclingRoad:
	LockAll
	SetVar 0x5030, 1
	ReleaseAll
	End
	
Route16_NorthEntrance_1F_EventScript_NeedBikeTriggerTop:
	LockAll
	SetVar 0x8008, 0
	GoTo Route16_NorthEntrance_1F_EventScript_NeedBikeTrigger
	End
	
Route16_NorthEntrance_1F_EventScript_NeedBikeTriggerMidTop:
	LockAll
	SetVar 0x8008, 1
	GoTo Route16_NorthEntrance_1F_EventScript_NeedBikeTrigger
	End
	
Route16_NorthEntrance_1F_EventScript_NeedBikeTriggerMid:
	LockAll
	SetVar 0x8008, 2
	GoTo Route16_NorthEntrance_1F_EventScript_NeedBikeTrigger
	End
	
Route16_NorthEntrance_1F_EventScript_NeedBikeTriggerMidBottom:
	LockAll
	SetVar 0x8008, 3
	GoTo Route16_NorthEntrance_1F_EventScript_NeedBikeTrigger
	End
	
Route16_NorthEntrance_1F_EventScript_NeedBikeTriggerBottom:
	LockAll
	SetVar 0x8008, 4
	GoTo Route16_NorthEntrance_1F_EventScript_NeedBikeTrigger
	End
	
Route16_NorthEntrance_1F_OnTransition:
	ClearFlag 0x210F
	CallIfSet 0x20E0, Route16_NorthEntrance_1F_EventScript_DisableNeedBikeTrigger
	End
	
Route16_NorthEntrance_1F_EventScript_NeedBikeTrigger:
	NPCMsg msg_0356_R16R0201_Route16_NorthEntrance_1F_Text_ExcuseMeWaitUp
	WaitButton
	CloseMsg
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	Wait 20, VAR_SPECIAL_RESULT
	CompareVarToValue 0x8008, 1
	CallIfEq Route16_NorthEntrance_1F_EventScript_PlayerWalkToCounterMidTop
	CompareVarToValue 0x8008, 2
	CallIfEq Route16_NorthEntrance_1F_EventScript_PlayerWalkToCounterMid
	CompareVarToValue 0x8008, 3
	CallIfEq Route16_NorthEntrance_1F_EventScript_PlayerWalkToCounterMidBottom
	CompareVarToValue 0x8008, 4
	CallIfEq Route16_NorthEntrance_1F_EventScript_PlayerWalkToCounterBottom
	NPCMsg msg_0356_R16R0201_Route16_NorthEntrance_1F_Text_NoPedestriansOnCyclingRoad
	WaitButton
	CloseMsg
	ApplyMovement obj_player, Route16_NorthEntrance_1F_Movement_WalkRight
	WaitMovement
	ReleaseAll
	End
	
Route16_NorthEntrance_1F_EventScript_DisableNeedBikeTrigger:
	SetVar 0x4001, 1
	Return
	
Route16_NorthEntrance_1F_EventScript_PlayerWalkToCounterMidTop:
	ApplyMovement obj_player, Route16_NorthEntrance_1F_Movement_WalkUp
	WaitMovement
	Return
	
Route16_NorthEntrance_1F_EventScript_PlayerWalkToCounterMid:
	ApplyMovement obj_player, Route16_NorthEntrance_1F_Movement_WalkUp2
	WaitMovement
	Return
	
Route16_NorthEntrance_1F_EventScript_PlayerWalkToCounterMidBottom:
	ApplyMovement obj_player, Route16_NorthEntrance_1F_Movement_WalkUp3
	WaitMovement
	Return
	
Route16_NorthEntrance_1F_EventScript_PlayerWalkToCounterBottom:
	ApplyMovement obj_player, Route16_NorthEntrance_1F_Movement_WalkUp4
	WaitMovement
	Return

_cv_stop:
	NPCMsg msg_0356_R16R0201_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
Common_Movement_WalkInPlaceFasterUp:
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
Route16_NorthEntrance_1F_Movement_WalkRight:
	WalkNormalEast
	EndMovement

	.balign 4, 0
Route16_NorthEntrance_1F_Movement_WalkUp:
	WalkNormalNorth
	EndMovement

	.balign 4, 0
Route16_NorthEntrance_1F_Movement_WalkUp2:
	WalkNormalNorth 2
	EndMovement

	.balign 4, 0
Route16_NorthEntrance_1F_Movement_WalkUp3:
	WalkNormalNorth 3
	EndMovement

	.balign 4, 0
Route16_NorthEntrance_1F_Movement_WalkUp4:
	WalkNormalNorth 4
	EndMovement
	.balign 4, 0
