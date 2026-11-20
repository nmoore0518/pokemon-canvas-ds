#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R11R0101.h"
#include "msgdata/msg/msg_0347_R11R0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route11_EastEntrance_1F_Frlg+Route11_EastEntrance_2F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route11_EastEntrance_1F_EventScript_TopGuard
	ScrDef Route11_EastEntrance_1F_EventScript_BottomGuard
	ScrDef Route11_EastEntrance_2F_EventScript_Turner
	ScrDef Route11_EastEntrance_2F_EventScript_Aide
	ScrDef Route11_EastEntrance_2F_EventScript_LeftBinoculars
	ScrDef Route11_EastEntrance_2F_EventScript_RightBinoculars
	ScrDefEnd
	
Route11_EastEntrance_1F_EventScript_TopGuard:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0347_R11R0101_Route11_EastEntrance_1F_Text_ManInLavenderRatesNames
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route11_EastEntrance_1F_EventScript_BottomGuard:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0347_R11R0101_Route11_EastEntrance_1F_Text_RockTunnelToReachLavender
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route11_EastEntrance_2F_EventScript_Turner:
	LockAll
	FacePlayer
	SetVar 0x8008, 8
	Call EventScript_GetInGameTradeSpeciesInfo
	GoToIfSet 0x22E0, Route11_EastEntrance_2F_EventScript_AlreadyTraded
	NPCMsg msg_0347_R11R0101_Trade_Text_LookingForMonWannaTradeForMon
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Route11_EastEntrance_2F_EventScript_DeclineTrade
	Call EventScript_ChooseMonForInGameTrade
	CompareVarToValue 0x8004, 6
	GoToIfGe Route11_EastEntrance_2F_EventScript_DeclineTrade
	Call EventScript_GetInGameTradeSpecies
	CompareVarToVar VAR_SPECIAL_RESULT, 0x8009
	GoToIfNe Route11_EastEntrance_2F_EventScript_NotRequestedMon
	Call EventScript_DoInGameTrade
	NPCMsg msg_0347_R11R0101_Trade_Text_HeyThanks
	WaitButton
	SetFlag 0x22E0
	CloseMsg
	ReleaseAll
	End
	
Route11_EastEntrance_2F_EventScript_Aide:
	LockAll
	FacePlayer
	Call Route11_EastEntrance_2F_EventScript_GetAideRequestInfo
	GoToIfSet 0x22E1, Route11_EastEntrance_2F_EventScript_AlreadyGotItemfinder
	BufferPlayersName 6
	NPCMsg msg_0347_R11R0101_Route11_EastEntrance_2F_Text_GiveItemfinderIfCaught30
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_3
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_4
_cv_yes_3:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Aide_EventScript_DeclineCheckMons
	SetVar 0x8004, 0
	CountNationalDexSeen 0x8005
	CountNationalDexOwned 0x8006
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x2026, _cv_dex_5
	SetVar VAR_SPECIAL_RESULT, 1
_cv_dex_5:
	BufferInt 2, 0x8006
	Call Route11_EastEntrance_2F_EventScript_GetAideRequestInfo
	CompareVarToValue 0x8006, 30
	GoToIfLt Aide_EventScript_HaventCaughtEnough
	NPCMsg msg_0347_R11R0101_Route11_EastEntrance_2F_Text_GreatHereYouGo
	WaitButton
	HasSpaceForItem ITEM_DOWSING_MCHN, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Aide_EventScript_NoRoomForItem
	GiveItem ITEM_DOWSING_MCHN, 1, VAR_SPECIAL_RESULT
	BufferItemName 1, ITEM_DOWSING_MCHN
	BufferPlayersName 6
	NPCMsg msg_0347_R11R0101_Route11_EastEntrance_2F_Text_ReceivedItemfinderFromAide
	PlayFanfare SEQ_ME_LVUP
	WaitFanfare
	WaitButton
	SetFlag 0x22E1
	NPCMsg msg_0347_R11R0101_Route11_EastEntrance_2F_Text_ExplainItemfinder
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route11_EastEntrance_2F_EventScript_LeftBinoculars:
	LockAll
	GoToIfSet 0x2109, Route11_EastEntrance_2F_EventScript_LeftBinocularsSnorlaxGone
	NPCMsg msg_0347_R11R0101_Route11_EastEntrance_2F_Text_BigMonAsleepOnRoad
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route11_EastEntrance_2F_EventScript_RightBinoculars:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0347_R11R0101_Route11_EastEntrance_2F_Text_RockTunnelGoodRouteToLavender
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_GetInGameTradeSpeciesInfo:
	CopyVar 0x8005, 0x8008
	CompareVarToValue 0x8005, 4
	GoToIfNe _cv_next_7
	LoadNPCTrade 13
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_6
_cv_next_7:
	CompareVarToValue 0x8005, 5
	GoToIfNe _cv_next_8
	LoadNPCTrade 14
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_6
_cv_next_8:
	CompareVarToValue 0x8005, 6
	GoToIfNe _cv_next_9
	LoadNPCTrade 15
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_6
_cv_next_9:
	CompareVarToValue 0x8005, 7
	GoToIfNe _cv_next_10
	LoadNPCTrade 16
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_6
_cv_next_10:
	CompareVarToValue 0x8005, 8
	GoToIfNe _cv_next_11
	LoadNPCTrade 17
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_6
_cv_next_11:
	CompareVarToValue 0x8005, 9
	GoToIfNe _cv_next_12
	LoadNPCTrade 18
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_6
_cv_next_12:
	CompareVarToValue 0x8005, 10
	GoToIfNe _cv_next_13
	LoadNPCTrade 19
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_6
_cv_next_13:
	CompareVarToValue 0x8005, 11
	GoToIfNe _cv_next_14
	LoadNPCTrade 20
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_6
_cv_next_14:
	CompareVarToValue 0x8005, 12
	GoToIfNe _cv_next_15
	LoadNPCTrade 21
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_6
_cv_next_15:
_cv_done_6:
	Return
	
Route11_EastEntrance_2F_EventScript_AlreadyTraded:
	NPCMsg msg_0347_R11R0101_Trade_Text_IsntMyOldMonGreat
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route11_EastEntrance_2F_EventScript_DeclineTrade:
	NPCMsg msg_0347_R11R0101_Trade_Text_AwwOhWell
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
	
Route11_EastEntrance_2F_EventScript_NotRequestedMon:
	BufferSpeciesName 0, 0x8009, 0, 0
	NPCMsg msg_0347_R11R0101_Trade_Text_WhatThatsNoMon
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_DoInGameTrade:
	CompareVarToValue 0x8005, 4
	GoToIfNe _cv_next_17
	LoadNPCTrade 13
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_16
_cv_next_17:
	CompareVarToValue 0x8005, 5
	GoToIfNe _cv_next_18
	LoadNPCTrade 14
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_16
_cv_next_18:
	CompareVarToValue 0x8005, 6
	GoToIfNe _cv_next_19
	LoadNPCTrade 15
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_16
_cv_next_19:
	CompareVarToValue 0x8005, 7
	GoToIfNe _cv_next_20
	LoadNPCTrade 16
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_16
_cv_next_20:
	CompareVarToValue 0x8005, 8
	GoToIfNe _cv_next_21
	LoadNPCTrade 17
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_16
_cv_next_21:
	CompareVarToValue 0x8005, 9
	GoToIfNe _cv_next_22
	LoadNPCTrade 18
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_16
_cv_next_22:
	CompareVarToValue 0x8005, 10
	GoToIfNe _cv_next_23
	LoadNPCTrade 19
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_16
_cv_next_23:
	CompareVarToValue 0x8005, 11
	GoToIfNe _cv_next_24
	LoadNPCTrade 20
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_16
_cv_next_24:
	CompareVarToValue 0x8005, 12
	GoToIfNe _cv_next_25
	LoadNPCTrade 21
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_16
_cv_next_25:
_cv_done_16:
	LockAll
	FacePlayer
	Return
	
Route11_EastEntrance_2F_EventScript_GetAideRequestInfo:
	BufferInt 0, 30
	BufferItemName 1, ITEM_DOWSING_MCHN
	Return
	
Route11_EastEntrance_2F_EventScript_AlreadyGotItemfinder:
	NPCMsg msg_0347_R11R0101_Route11_EastEntrance_2F_Text_ExplainItemfinder
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Aide_EventScript_DeclineCheckMons:
	NPCMsg msg_0347_R11R0101_Aide_Text_GetEnoughMonsComeBackForItem
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Aide_EventScript_HaventCaughtEnough:
	NPCMsg msg_0347_R11R0101_Aide_Text_HaventCaughtEnoughMonsForItem
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Aide_EventScript_NoRoomForItem:
	NPCMsg msg_0347_R11R0101_Aide_Text_DontHaveAnyRoomForItem
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route11_EastEntrance_2F_EventScript_LeftBinocularsSnorlaxGone:
	NPCMsg msg_0347_R11R0101_Route11_EastEntrance_2F_Text_WhatABreathtakingView
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0347_R11R0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
