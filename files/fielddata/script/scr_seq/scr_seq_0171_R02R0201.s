#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R02R0201.h"
#include "msgdata/msg/msg_0322_R02R0201.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route2_House_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route2_House_EventScript_Scientist
	ScrDef Route2_House_EventScript_Reyley
	ScrDefEnd
	
Route2_House_EventScript_Scientist:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0322_R02R0201_Route2_House_Text_FaintedMonsCanUseFieldMoves
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route2_House_EventScript_Reyley:
	LockAll
	FacePlayer
	SetVar 0x8008, 4
	Call EventScript_GetInGameTradeSpeciesInfo
	GoToIfSet 0x20BC, Route2_House_EventScript_AlreadyTraded
	NPCMsg msg_0322_R02R0201_Trade_Text_LookingForMonWannaTradeForMon
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Route2_House_EventScript_DeclineTrade
	Call EventScript_ChooseMonForInGameTrade
	CompareVarToValue 0x8004, 6
	GoToIfGe Route2_House_EventScript_DeclineTrade
	Call EventScript_GetInGameTradeSpecies
	CompareVarToVar VAR_SPECIAL_RESULT, 0x8009
	GoToIfNe Route2_House_EventScript_NotRequestedMon
	Call EventScript_DoInGameTrade
	NPCMsg msg_0322_R02R0201_Trade_Text_HeyThanks
	WaitButton
	SetFlag 0x20BC
	CloseMsg
	ReleaseAll
	End
	
EventScript_GetInGameTradeSpeciesInfo:
	CopyVar 0x8005, 0x8008
	SetVar 0x8009, 0  // TODO(gba) specialvar GetInGameTradeSpeciesInfo
	GoTo _cv_stop
	Return
	
Route2_House_EventScript_AlreadyTraded:
	NPCMsg msg_0322_R02R0201_Trade_Text_IsntMyOldMonGreat
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route2_House_EventScript_DeclineTrade:
	NPCMsg msg_0322_R02R0201_Trade_Text_AwwOhWell
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
	
Route2_House_EventScript_NotRequestedMon:
	BufferSpeciesName 0, 0x8009, 0, 0
	NPCMsg msg_0322_R02R0201_Trade_Text_WhatThatsNoMon
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

_cv_stop:
	NPCMsg msg_0322_R02R0201_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
