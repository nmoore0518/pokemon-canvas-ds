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
	SetVar 0x8009, 0  // TODO(gba) specialvar GetInGameTradeSpeciesInfo
	GoTo _cv_stop
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
	// TODO(gba) special ChoosePartyMon
	GoTo _cv_stop
	LockAll
	FacePlayer
	Return
	
EventScript_GetInGameTradeSpecies:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar GetTradeSpecies
	GoTo _cv_stop
	Return
	
Route11_EastEntrance_2F_EventScript_NotRequestedMon:
	BufferSpeciesName 0, 0x8009, 0, 0
	NPCMsg msg_0347_R11R0101_Trade_Text_WhatThatsNoMon
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_DoInGameTrade:
	// TODO(gba) special CreateInGameTradePokemon
	GoTo _cv_stop
	// TODO(gba) special DoInGameTradeScene
	GoTo _cv_stop
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
