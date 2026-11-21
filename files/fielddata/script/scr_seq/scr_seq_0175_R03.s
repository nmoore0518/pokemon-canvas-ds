#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R03.h"
#include "msgdata/msg/msg_0326_R03.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route3_Frlg#world by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route3_EventScript_Youngster
	ScrDef BerryField_EventScript_FindFighting
	ScrDef PewterCity_EventScript_GymGuide
	ScrDef PewterCity_EventScript_RunningShoesAide
	ScrDef Route3_EventScript_RouteSign
	ScrDef PewterCity_EventScript_GymGuideTriggerTop
	ScrDef PewterCity_EventScript_GymGuideTriggerMid
	ScrDef PewterCity_EventScript_GymGuideTriggerBottom
	ScrDef PewterCity_EventScript_GymGuideTriggerRight
	ScrDef PewterCity_EventScript_RunningShoesAideTriggerTop
	ScrDef PewterCity_EventScript_RunningShoesAideTriggerMid
	ScrDef PewterCity_EventScript_RunningShoesAideTriggerBottom
	ScrDefEnd
	
Route3_EventScript_Youngster:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0326_R03_Route3_Text_TunnelFromCeruleanTiring
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
BerryField_EventScript_FindFighting:
	SetVar 0x8004, ITEM_CHOPLE_BERRY
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
PewterCity_EventScript_GymGuide:
	LockAll
	FacePlayer
	NPCMsg msg_0326_R03_PewterCity_Text_BrocksLookingForChallengersFollowMe
	WaitButton
	CanvasCloseMsg
	PlayBGM SEQ_GS_E_TSURETEKE1
	CompareVarToValue 0x5002, 3
	CallIfEq PewterCity_EventScript_WalkToGymEast
	NPCMsg msg_0326_R03_PewterCity_Text_GoTakeOnBrock
	WaitButton
	CanvasCloseMsg
	ApplyMovement 11, PewterCity_Movement_GymGuideExit
	WaitMovement
	ResetBGM
	HidePerson 11
	SetFlag 0x20B4
	ClearFlag 0x20B4
	ShowPerson 11
	CanvasCloseMsg
	ReleaseAll
	End
	
PewterCity_EventScript_RunningShoesAide:
	LockAll
	FacePlayer
	SetVar 0x4001, 0
	Call PewterCity_EventScript_AideGiveRunningShoes
	CanvasCloseMsg
	ReleaseAll
	End
	
Route3_EventScript_RouteSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0326_R03_Route3_Text_RouteSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_EventScript_GymGuideTriggerTop:
	LockAll
	SetVar 0x4001, 0
	GoTo PewterCity_EventScript_GymGuideTrigger
	End
	
PewterCity_EventScript_GymGuideTriggerMid:
	LockAll
	SetVar 0x4001, 1
	GoTo PewterCity_EventScript_GymGuideTrigger
	End
	
PewterCity_EventScript_GymGuideTriggerBottom:
	LockAll
	SetVar 0x4001, 2
	GoTo PewterCity_EventScript_GymGuideTrigger
	End
	
PewterCity_EventScript_GymGuideTriggerRight:
	LockAll
	SetVar 0x4001, 3
	GoTo PewterCity_EventScript_GymGuideTrigger
	End
	
PewterCity_EventScript_RunningShoesAideTriggerTop:
	LockAll
	SetVar 0x4001, 1
	Call PewterCity_EventScript_AideGiveRunningShoes
	CanvasCloseMsg
	ReleaseAll
	End
	
PewterCity_EventScript_RunningShoesAideTriggerMid:
	LockAll
	SetVar 0x4001, 2
	Call PewterCity_EventScript_AideGiveRunningShoes
	CanvasCloseMsg
	ReleaseAll
	End
	
PewterCity_EventScript_RunningShoesAideTriggerBottom:
	LockAll
	SetVar 0x4001, 3
	Call PewterCity_EventScript_AideGiveRunningShoes
	CanvasCloseMsg
	ReleaseAll
	End
	
PewterCity_EventScript_WalkToGymEast:
	ApplyMovement obj_player, PewterCity_Movement_PlayerWaitForGuideEast
	ApplyMovement 11, PewterCity_Movement_GuideMoveToLeadEast
	WaitMovement
	ApplyMovement obj_player, PewterCity_Movement_PlayerWalkToGymEast
	ApplyMovement 11, PewterCity_Movement_GuideWalkToGymEast
	WaitMovement
	Return
	
PewterCity_EventScript_AideGiveRunningShoes:
	CompareVarToValue 0x4001, 1
	CallIfEq PewterCity_EventScript_AideNoticePlayer
	CompareVarToValue 0x4001, 2
	CallIfEq PewterCity_EventScript_AideNoticePlayer
	CompareVarToValue 0x4001, 3
	CallIfEq PewterCity_EventScript_AideNoticePlayer
	WaitSE SEQ_SE_DP_SELECT
	PlaySE SEQ_SE_DP_SELECT
	ApplyMovement 12, Common_Movement_ExclamationMark
	WaitMovement
	ApplyMovement 12, Common_Movement_Delay48
	WaitMovement
	BufferPlayersName 6
	NPCMsg msg_0326_R03_PewterCity_Text_OhPlayer
	WaitButton
	CompareVarToValue 0x4001, 0
	CallIfEq PewterCity_EventScript_AideApproachPlayer0
	CompareVarToValue 0x4001, 1
	CallIfEq PewterCity_EventScript_AideApproachPlayer1
	CompareVarToValue 0x4001, 2
	CallIfEq PewterCity_EventScript_AideApproachPlayer2
	CompareVarToValue 0x4001, 3
	CallIfEq PewterCity_EventScript_AideApproachPlayer3
	NPCMsg msg_0326_R03_PewterCity_Text_AskedToDeliverThis
	WaitButton
	PlayFanfare SEQ_ME_ITEM
	BufferPlayersName 6
	NPCMsg msg_0326_R03_PewterCity_Text_ReceivedRunningShoesFromAide
	WaitFanfare
	BufferPlayersName 6
	NPCMsg msg_0326_R03_PewterCity_Text_SwitchedShoesWithRunningShoes
	WaitButton
	NPCMsg msg_0326_R03_PewterCity_Text_ExplainRunningShoes
	WaitButton
	Call EventScript_RestorePrevTextColor
	NPCMsg msg_0326_R03_PewterCity_Text_MustBeGoingBackToLab
	WaitButton
	CanvasCloseMsg
	CompareVarToValue 0x4001, 0
	CallIfEq PewterCity_EventScript_AideExit0
	CompareVarToValue 0x4001, 1
	CallIfEq PewterCity_EventScript_AideExit1
	CompareVarToValue 0x4001, 2
	CallIfEq PewterCity_EventScript_AideExit2
	CompareVarToValue 0x4001, 3
	CallIfEq PewterCity_EventScript_AideExit3
	Wait 30, VAR_SPECIAL_RESULT
	BufferPlayersName 6
	NPCMsg msg_0326_R03_PewterCity_Text_RunningShoesLetterFromMom
	WaitButton
	CanvasCloseMsg
	HidePerson 12
	SetFlag 0x205B
	SetFlag 0x20B5
	GiveRunningShoes
	SetVar 0x5022, 2
	Return
	
PewterCity_EventScript_GymGuideTrigger:
	NPCMsg msg_0326_R03_PewterCity_Text_BrocksLookingForChallengersFollowMe
	WaitButton
	CanvasCloseMsg
	PlayBGM SEQ_GS_E_TSURETEKE1
	CompareVarToValue 0x4001, 0
	CallIfEq PewterCity_EventScript_WalkToGymTop
	CompareVarToValue 0x4001, 1
	CallIfEq PewterCity_EventScript_WalkToGymMid
	CompareVarToValue 0x4001, 2
	CallIfEq PewterCity_EventScript_WalkToGymBottom
	NPCMsg msg_0326_R03_PewterCity_Text_GoTakeOnBrock
	WaitButton
	CanvasCloseMsg
	ApplyMovement 11, PewterCity_Movement_GymGuideExit
	WaitMovement
	ResetBGM
	HidePerson 11
	SetFlag 0x20B4
	ClearFlag 0x20B4
	ShowPerson 11
	CanvasCloseMsg
	ReleaseAll
	End
	
PewterCity_EventScript_AideNoticePlayer:
	ApplyMovement 12, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	Return
	
PewterCity_EventScript_AideApproachPlayer0:
	CanvasCloseMsg
	Wait 20, VAR_SPECIAL_RESULT
	Return
	
PewterCity_EventScript_AideApproachPlayer1:
	CanvasCloseMsg
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	Return
	
PewterCity_EventScript_AideApproachPlayer2:
	CanvasCloseMsg
	ApplyMovement 12, PewterCity_Movement_AideApproachPlayerMid
	WaitMovement
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	Return
	
PewterCity_EventScript_AideApproachPlayer3:
	CanvasCloseMsg
	ApplyMovement 12, PewterCity_Movement_AideApproachPlayerBottom
	WaitMovement
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	Return
	
EventScript_RestorePrevTextColor:
	CopyVar 0x5015, 0x5016
	Return
	
PewterCity_EventScript_AideExit0:
	ApplyMovement 12, PewterCity_Movement_AideExit0
	WaitMovement
	Return
	
PewterCity_EventScript_AideExit1:
	ApplyMovement 12, PewterCity_Movement_AideExit1
	WaitMovement
	Return
	
PewterCity_EventScript_AideExit2:
	ApplyMovement 12, PewterCity_Movement_AideExit2
	WaitMovement
	Return
	
PewterCity_EventScript_AideExit3:
	ApplyMovement 12, PewterCity_Movement_AideExit3
	WaitMovement
	Return
	
PewterCity_EventScript_WalkToGymTop:
	ApplyMovement 11, PewterCity_Movement_GuideMoveToLeadTop
	WaitMovement
	ApplyMovement obj_player, PewterCity_Movement_PlayerWalkToGymTop
	ApplyMovement 11, PewterCity_Movement_GuideWalkToGymTop
	WaitMovement
	Return
	
PewterCity_EventScript_WalkToGymMid:
	ApplyMovement 11, PewterCity_Movement_GuideMoveToLeadMid
	WaitMovement
	ApplyMovement obj_player, PewterCity_Movement_PlayerWalkToGymMid
	ApplyMovement 11, PewterCity_Movement_GuideWalkToGymMid
	WaitMovement
	Return
	
PewterCity_EventScript_WalkToGymBottom:
	ApplyMovement 11, PewterCity_Movement_GuideMoveToLeadBottom
	WaitMovement
	ApplyMovement obj_player, PewterCity_Movement_PlayerWalkToGymBottom
	ApplyMovement 11, PewterCity_Movement_GuideWalkToGymBottom
	WaitMovement
	Return

_cv_stop:
	NPCMsg msg_0326_R03_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
PewterCity_Movement_GymGuideExit:
	WalkNormalSouth
	WalkNormalWest 9
	EndMovement

	.balign 4, 0
PewterCity_Movement_PlayerWaitForGuideEast:
	Delay16 2
	Delay4
	WalkOnSpotFasterSouth
	EndMovement

	.balign 4, 0
PewterCity_Movement_GuideMoveToLeadEast:
	WalkNormalSouth
	WalkNormalWest
	WalkOnSpotFasterNorth
	WalkOnSpotNormalNorth
	EndMovement

	.balign 4, 0
PewterCity_Movement_PlayerWalkToGymEast:
	WalkNormalSouth
	WalkNormalWest 3
	WalkNormalNorth
	WalkNormalWest 15
	WalkNormalNorth 10
	WalkNormalWest 16
	WalkNormalSouth 8
	WalkNormalEast 8
	EndMovement

	.balign 4, 0
PewterCity_Movement_GuideWalkToGymEast:
	WalkNormalWest 3
	WalkNormalNorth
	WalkNormalWest 15
	WalkNormalNorth 10
	WalkNormalWest 16
	WalkNormalSouth 8
	WalkNormalEast 9
	WalkOnSpotFasterWest
	EndMovement

	.balign 4, 0
Common_Movement_ExclamationMark:
	EmoteExclamationMark
	EndMovement

	.balign 4, 0
Common_Movement_Delay48:
	Delay16 3
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterDown:
	WalkOnSpotFasterSouth
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterUp:
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
PewterCity_Movement_AideApproachPlayerMid:
	Delay4
	WalkNormalSouth
	EndMovement

	.balign 4, 0
PewterCity_Movement_AideApproachPlayerBottom:
	Delay4
	WalkNormalSouth 2
	EndMovement

	.balign 4, 0
PewterCity_Movement_AideExit0:
	WalkNormalSouth
	WalkNormalWest 9
	EndMovement

	.balign 4, 0
PewterCity_Movement_AideExit1:
	WalkNormalWest
	WalkNormalSouth
	WalkNormalWest 8
	EndMovement

	.balign 4, 0
PewterCity_Movement_AideExit2:
	WalkNormalWest 9
	EndMovement

	.balign 4, 0
PewterCity_Movement_AideExit3:
	WalkNormalWest 9
	EndMovement

	.balign 4, 0
PewterCity_Movement_GuideMoveToLeadTop:
	WalkNormalWest
	WalkNormalSouth
	WalkOnSpotFasterEast
	WalkOnSpotNormalEast
	EndMovement

	.balign 4, 0
PewterCity_Movement_PlayerWalkToGymTop:
	WalkNormalWest 4
	WalkNormalNorth
	WalkNormalWest 15
	WalkNormalNorth 10
	WalkNormalWest 16
	WalkNormalSouth 8
	WalkNormalEast 8
	EndMovement

	.balign 4, 0
PewterCity_Movement_GuideWalkToGymTop:
	WalkNormalWest 3
	WalkNormalNorth
	WalkNormalWest 15
	WalkNormalNorth 10
	WalkNormalWest 16
	WalkNormalSouth 8
	WalkNormalEast 9
	WalkOnSpotFasterWest
	EndMovement

	.balign 4, 0
PewterCity_Movement_GuideMoveToLeadMid:
	WalkNormalSouth
	WalkOnSpotNormalSouth
	EndMovement

	.balign 4, 0
PewterCity_Movement_PlayerWalkToGymMid:
	WalkNormalNorth
	WalkNormalWest 4
	WalkNormalNorth
	WalkNormalWest 15
	WalkNormalNorth 10
	WalkNormalWest 16
	WalkNormalSouth 8
	WalkNormalEast 8
	EndMovement

	.balign 4, 0
PewterCity_Movement_GuideWalkToGymMid:
	WalkNormalWest 4
	WalkNormalNorth
	WalkNormalWest 15
	WalkNormalNorth 10
	WalkNormalWest 16
	WalkNormalSouth 8
	WalkNormalEast 9
	WalkOnSpotFasterWest
	EndMovement

	.balign 4, 0
PewterCity_Movement_GuideMoveToLeadBottom:
	WalkNormalSouth 2
	WalkOnSpotNormalSouth
	EndMovement

	.balign 4, 0
PewterCity_Movement_PlayerWalkToGymBottom:
	WalkNormalNorth 2
	WalkNormalWest 4
	WalkNormalNorth
	WalkNormalWest 15
	WalkNormalNorth 10
	WalkNormalWest 16
	WalkNormalSouth 8
	WalkNormalEast 8
	EndMovement

	.balign 4, 0
PewterCity_Movement_GuideWalkToGymBottom:
	WalkNormalNorth
	WalkNormalWest 4
	WalkNormalNorth
	WalkNormalWest 15
	WalkNormalNorth 10
	WalkNormalWest 16
	WalkNormalSouth 8
	WalkNormalEast 9
	WalkOnSpotFasterWest
	EndMovement
	.balign 4, 0
