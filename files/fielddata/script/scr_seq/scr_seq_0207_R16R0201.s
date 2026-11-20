#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R16R0201.h"
#include "msgdata/msg/msg_0356_R16R0201.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route16_NorthEntrance_1F_Frlg+Route16_NorthEntrance_2F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route16_NorthEntrance_1F_EventScript_Guard
	ScrDef Route16_NorthEntrance_1F_EventScript_OldMan
	ScrDef Route16_NorthEntrance_2F_EventScript_LittleBoy
	ScrDef Route16_NorthEntrance_2F_EventScript_LittleGirl
	ScrDef Route16_NorthEntrance_2F_EventScript_Aide
	ScrDef Route16_NorthEntrance_2F_EventScript_LeftBinoculars
	ScrDef Route16_NorthEntrance_2F_EventScript_RightBinoculars
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
	
Route16_NorthEntrance_2F_EventScript_LittleBoy:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0356_R16R0201_Route16_NorthEntrance_2F_Text_OnBikeRideWithGirlfriend
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route16_NorthEntrance_2F_EventScript_LittleGirl:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0356_R16R0201_Route16_NorthEntrance_2F_Text_RidingTogetherOnNewBikes
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route16_NorthEntrance_2F_EventScript_Aide:
	LockAll
	FacePlayer
	Call Route16_NorthEntrance_2F_EventScript_GetAideRequestInfo
	GoToIfSet 0x22E5, Route16_NorthEntrance_2F_EventScript_AlreadyGotAmuletCoin
	BufferPlayersName 6
	NPCMsg msg_0356_R16R0201_Route16_NorthEntrance_2F_Text_GiveAmuletCoinIfCaught40
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Aide_EventScript_DeclineCheckMons
	SetVar 0x8004, 0
	CountNationalDexSeen 0x8005
	CountNationalDexOwned 0x8006
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x2026, _cv_dex_3
	SetVar VAR_SPECIAL_RESULT, 1
_cv_dex_3:
	BufferInt 2, 0x8006
	Call Route16_NorthEntrance_2F_EventScript_GetAideRequestInfo
	CompareVarToValue 0x8006, 40
	GoToIfLt Aide_EventScript_HaventCaughtEnough
	NPCMsg msg_0356_R16R0201_Route16_NorthEntrance_2F_Text_GreatHereYouGo
	WaitButton
	HasSpaceForItem ITEM_AMULET_COIN, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Aide_EventScript_NoRoomForItem
	GiveItem ITEM_AMULET_COIN, 1, VAR_SPECIAL_RESULT
	BufferItemName 1, ITEM_AMULET_COIN
	BufferPlayersName 6
	NPCMsg msg_0356_R16R0201_Route16_NorthEntrance_2F_Text_ReceivedAmuletCoinFromAide
	PlayFanfare SEQ_ME_LVUP
	WaitFanfare
	WaitButton
	SetFlag 0x22E5
	NPCMsg msg_0356_R16R0201_Route16_NorthEntrance_2F_Text_ExplainAmuletCoin
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route16_NorthEntrance_2F_EventScript_LeftBinoculars:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0356_R16R0201_Route16_NorthEntrance_2F_Text_ItsCeladonDeptStore
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route16_NorthEntrance_2F_EventScript_RightBinoculars:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0356_R16R0201_Route16_NorthEntrance_2F_Text_LongPathOverWater
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
	
Route16_NorthEntrance_2F_EventScript_GetAideRequestInfo:
	BufferInt 0, 40
	BufferItemName 1, ITEM_AMULET_COIN
	Return
	
Route16_NorthEntrance_2F_EventScript_AlreadyGotAmuletCoin:
	NPCMsg msg_0356_R16R0201_Route16_NorthEntrance_2F_Text_ExplainAmuletCoin
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Aide_EventScript_DeclineCheckMons:
	NPCMsg msg_0356_R16R0201_Aide_Text_GetEnoughMonsComeBackForItem
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Aide_EventScript_HaventCaughtEnough:
	NPCMsg msg_0356_R16R0201_Aide_Text_HaventCaughtEnoughMonsForItem
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Aide_EventScript_NoRoomForItem:
	NPCMsg msg_0356_R16R0201_Aide_Text_DontHaveAnyRoomForItem
	WaitButton
	CloseMsg
	ReleaseAll
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
