#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R18R0101.h"
#include "msgdata/msg/msg_0359_R18R0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route18_EastEntrance_1F_Frlg+Route18_EastEntrance_2F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route18_EastEntrance_1F_EventScript_Guard
	ScrDef Route18_EastEntrance_2F_EventScript_Haden
	ScrDef Route18_EastEntrance_2F_EventScript_LeftBinoculars
	ScrDef Route18_EastEntrance_2F_EventScript_RightBinoculars
	ScrDef EventScript_SetEnteringCyclingRoad
	ScrDef Route18_EastEntrance_1F_EventScript_NeedBikeTriggerTop
	ScrDef Route18_EastEntrance_1F_EventScript_NeedBikeTriggerMidTop
	ScrDef Route18_EastEntrance_1F_EventScript_NeedBikeTriggerMid
	ScrDef Route18_EastEntrance_1F_EventScript_NeedBikeTriggerMidBottom
	ScrDef Route18_EastEntrance_1F_EventScript_NeedBikeTriggerBottom
	ScrDef EventScript_SetExitingCyclingRoad
	ScrDef Route18_EastEntrance_1F_OnTransition
	ScrDefEnd
	
Route18_EastEntrance_1F_EventScript_Guard:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0359_R18R0101_Route18_EastEntrance_1F_Text_CyclingRoadAllUphillFromHere
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route18_EastEntrance_2F_EventScript_Haden:
	LockAll
	FacePlayer
	SetVar 0x8008, 9
	Call EventScript_GetInGameTradeSpeciesInfo
	GoToIfSet 0x22E6, Route18_EastEntrance_2F_EventScript_AlreadyTraded
	NPCMsg msg_0359_R18R0101_Trade_Text_LookingForMonWannaTradeForMon
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Route18_EastEntrance_2F_EventScript_DeclineTrade
	Call EventScript_ChooseMonForInGameTrade
	CompareVarToValue 0x8004, 6
	GoToIfGe Route18_EastEntrance_2F_EventScript_DeclineTrade
	Call EventScript_GetInGameTradeSpecies
	CompareVarToVar VAR_SPECIAL_RESULT, 0x8009
	GoToIfNe Route18_EastEntrance_2F_EventScript_NotRequestedMon
	Call EventScript_DoInGameTrade
	NPCMsg msg_0359_R18R0101_Trade_Text_HeyThanks
	WaitButton
	SetFlag 0x22E6
	CloseMsg
	ReleaseAll
	End
	
Route18_EastEntrance_2F_EventScript_LeftBinoculars:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0359_R18R0101_Route18_EastEntrance_2F_Text_PalletTownInWest
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route18_EastEntrance_2F_EventScript_RightBinoculars:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0359_R18R0101_Route18_EastEntrance_2F_Text_PeopleSwimming
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_SetEnteringCyclingRoad:
	LockAll
	SetVar 0x5030, 1
	ReleaseAll
	End
	
Route18_EastEntrance_1F_EventScript_NeedBikeTriggerTop:
	LockAll
	SetVar 0x8008, 0
	GoTo Route18_EastEntrance_1F_EventScript_NeedBikeTrigger
	End
	
Route18_EastEntrance_1F_EventScript_NeedBikeTriggerMidTop:
	LockAll
	SetVar 0x8008, 1
	GoTo Route18_EastEntrance_1F_EventScript_NeedBikeTrigger
	End
	
Route18_EastEntrance_1F_EventScript_NeedBikeTriggerMid:
	LockAll
	SetVar 0x8008, 2
	GoTo Route18_EastEntrance_1F_EventScript_NeedBikeTrigger
	End
	
Route18_EastEntrance_1F_EventScript_NeedBikeTriggerMidBottom:
	LockAll
	SetVar 0x8008, 3
	GoTo Route18_EastEntrance_1F_EventScript_NeedBikeTrigger
	End
	
Route18_EastEntrance_1F_EventScript_NeedBikeTriggerBottom:
	LockAll
	SetVar 0x8008, 4
	GoTo Route18_EastEntrance_1F_EventScript_NeedBikeTrigger
	End
	
EventScript_SetExitingCyclingRoad:
	LockAll
	ClearFlag 0x210F
	SetVar 0x5030, 0
	ReleaseAll
	End
	
Route18_EastEntrance_1F_OnTransition:
	ClearFlag 0x210F
	CallIfSet 0x20E0, Route18_EastEntrance_1F_EventScript_DisableNeedBikeTrigger
	End
	
EventScript_GetInGameTradeSpeciesInfo:
	CopyVar 0x8005, 0x8008
	CompareVarToValue 0x8005, 4
	GoToIfNe _cv_next_4
	LoadNPCTrade 13
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_3
_cv_next_4:
	CompareVarToValue 0x8005, 5
	GoToIfNe _cv_next_5
	LoadNPCTrade 14
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_3
_cv_next_5:
	CompareVarToValue 0x8005, 6
	GoToIfNe _cv_next_6
	LoadNPCTrade 15
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_3
_cv_next_6:
	CompareVarToValue 0x8005, 7
	GoToIfNe _cv_next_7
	LoadNPCTrade 16
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_3
_cv_next_7:
	CompareVarToValue 0x8005, 8
	GoToIfNe _cv_next_8
	LoadNPCTrade 17
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_3
_cv_next_8:
	CompareVarToValue 0x8005, 9
	GoToIfNe _cv_next_9
	LoadNPCTrade 18
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_3
_cv_next_9:
	CompareVarToValue 0x8005, 10
	GoToIfNe _cv_next_10
	LoadNPCTrade 19
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_3
_cv_next_10:
	CompareVarToValue 0x8005, 11
	GoToIfNe _cv_next_11
	LoadNPCTrade 20
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_3
_cv_next_11:
	CompareVarToValue 0x8005, 12
	GoToIfNe _cv_next_12
	LoadNPCTrade 21
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_3
_cv_next_12:
_cv_done_3:
	Return
	
Route18_EastEntrance_2F_EventScript_AlreadyTraded:
	NPCMsg msg_0359_R18R0101_Trade_Text_IsntMyOldMonGreat
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route18_EastEntrance_2F_EventScript_DeclineTrade:
	NPCMsg msg_0359_R18R0101_Trade_Text_AwwOhWell
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_ChooseMonForInGameTrade:
	CloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	ScrCmd_566
	GetPartySelection 0x8004
	RestoreOverworld
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	LockAll
	FacePlayer
	Return
	
EventScript_GetInGameTradeSpecies:
	GetPartyMonSpecies 0x8004, VAR_SPECIAL_RESULT
	Return
	
Route18_EastEntrance_2F_EventScript_NotRequestedMon:
	BufferSpeciesName 0, 0x8009, 0, 0
	NPCMsg msg_0359_R18R0101_Trade_Text_WhatThatsNoMon
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_DoInGameTrade:
	CompareVarToValue 0x8005, 4
	GoToIfNe _cv_next_14
	LoadNPCTrade 13
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_13
_cv_next_14:
	CompareVarToValue 0x8005, 5
	GoToIfNe _cv_next_15
	LoadNPCTrade 14
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_13
_cv_next_15:
	CompareVarToValue 0x8005, 6
	GoToIfNe _cv_next_16
	LoadNPCTrade 15
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_13
_cv_next_16:
	CompareVarToValue 0x8005, 7
	GoToIfNe _cv_next_17
	LoadNPCTrade 16
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_13
_cv_next_17:
	CompareVarToValue 0x8005, 8
	GoToIfNe _cv_next_18
	LoadNPCTrade 17
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_13
_cv_next_18:
	CompareVarToValue 0x8005, 9
	GoToIfNe _cv_next_19
	LoadNPCTrade 18
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_13
_cv_next_19:
	CompareVarToValue 0x8005, 10
	GoToIfNe _cv_next_20
	LoadNPCTrade 19
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_13
_cv_next_20:
	CompareVarToValue 0x8005, 11
	GoToIfNe _cv_next_21
	LoadNPCTrade 20
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_13
_cv_next_21:
	CompareVarToValue 0x8005, 12
	GoToIfNe _cv_next_22
	LoadNPCTrade 21
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_13
_cv_next_22:
_cv_done_13:
	LockAll
	FacePlayer
	Return
	
Route18_EastEntrance_1F_EventScript_NeedBikeTrigger:
	NPCMsg msg_0359_R18R0101_Route18_EastEntrance_1F_Text_ExcuseMe
	WaitButton
	CloseMsg
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	Wait 20, VAR_SPECIAL_RESULT
	CompareVarToValue 0x8008, 1
	CallIfEq Route18_EastEntrance_1F_EventScript_PlayerWalkToCounterMidTop
	CompareVarToValue 0x8008, 2
	CallIfEq Route18_EastEntrance_1F_EventScript_PlayerWalkToCounterMid
	CompareVarToValue 0x8008, 3
	CallIfEq Route18_EastEntrance_1F_EventScript_PlayerWalkToCounterMidBottom
	CompareVarToValue 0x8008, 4
	CallIfEq Route18_EastEntrance_1F_EventScript_PlayerWalkToCounterBottom
	NPCMsg msg_0359_R18R0101_Route18_EastEntrance_1F_Text_NeedBicycleForCyclingRoad
	WaitButton
	CloseMsg
	ApplyMovement obj_player, Route18_EastEntrance_1F_Movement_WalkRight
	WaitMovement
	ReleaseAll
	End
	
Route18_EastEntrance_1F_EventScript_DisableNeedBikeTrigger:
	SetVar 0x4001, 1
	Return
	
Route18_EastEntrance_1F_EventScript_PlayerWalkToCounterMidTop:
	ApplyMovement obj_player, Route18_EastEntrance_1F_Movement_WalkUp
	WaitMovement
	Return
	
Route18_EastEntrance_1F_EventScript_PlayerWalkToCounterMid:
	ApplyMovement obj_player, Route18_EastEntrance_1F_Movement_WalkUp2
	WaitMovement
	Return
	
Route18_EastEntrance_1F_EventScript_PlayerWalkToCounterMidBottom:
	ApplyMovement obj_player, Route18_EastEntrance_1F_Movement_WalkUp3
	WaitMovement
	Return
	
Route18_EastEntrance_1F_EventScript_PlayerWalkToCounterBottom:
	ApplyMovement obj_player, Route18_EastEntrance_1F_Movement_WalkUp4
	WaitMovement
	Return

_cv_stop:
	NPCMsg msg_0359_R18R0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
Common_Movement_WalkInPlaceFasterUp:
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
Route18_EastEntrance_1F_Movement_WalkRight:
	WalkNormalEast
	EndMovement

	.balign 4, 0
Route18_EastEntrance_1F_Movement_WalkUp:
	WalkNormalNorth
	EndMovement

	.balign 4, 0
Route18_EastEntrance_1F_Movement_WalkUp2:
	WalkNormalNorth 2
	EndMovement

	.balign 4, 0
Route18_EastEntrance_1F_Movement_WalkUp3:
	WalkNormalNorth 3
	EndMovement

	.balign 4, 0
Route18_EastEntrance_1F_Movement_WalkUp4:
	WalkNormalNorth 4
	EndMovement
	.balign 4, 0
