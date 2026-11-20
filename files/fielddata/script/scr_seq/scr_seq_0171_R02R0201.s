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
	
Route2_House_EventScript_NotRequestedMon:
	BufferSpeciesName 0, 0x8009, 0, 0
	NPCMsg msg_0322_R02R0201_Trade_Text_WhatThatsNoMon
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

_cv_stop:
	NPCMsg msg_0322_R02R0201_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
