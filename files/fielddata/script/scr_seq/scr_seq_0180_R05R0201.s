#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R05R0201.h"
#include "msgdata/msg/msg_0330_R05R0201.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's UndergroundPath_NorthEntrance_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef UndergroundPath_NorthEntrance_EventScript_Saige
	ScrDef PaintWorld_EventScript_Figure
	ScrDefEnd
	
UndergroundPath_NorthEntrance_EventScript_Saige:
	LockAll
	FacePlayer
	SetVar 0x8008, 6
	Call EventScript_GetInGameTradeSpeciesInfo
	GoToIfSet 0x2157, UndergroundPath_NorthEntrance_EventScript_AlreadyTraded
	NPCMsg msg_0330_R05R0201_Trade_Text_DoYouHaveMonWantToTradeForMon
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq UndergroundPath_NorthEntrance_EventScript_DeclineTrade
	Call EventScript_ChooseMonForInGameTrade
	CompareVarToValue 0x8004, 6
	GoToIfGe UndergroundPath_NorthEntrance_EventScript_DeclineTrade
	Call EventScript_GetInGameTradeSpecies
	CompareVarToVar VAR_SPECIAL_RESULT, 0x8009
	GoToIfNe UndergroundPath_NorthEntrance_EventScript_NotRequestedMon
	Call EventScript_DoInGameTrade
	NPCMsg msg_0330_R05R0201_Trade_Text_ThanksYoureAPal
	WaitButton
	SetFlag 0x2157
	CloseMsg
	ReleaseAll
	End
	
PaintWorld_EventScript_Figure:
	LockAll
	FacePlayer
	CompareVarToValue 0x5020, 2
	GoToIfEq PaintWorld_EventScript_FigureSketch
	CompareVarToValue 0x5020, 3
	GoToIfEq PaintWorld_EventScript_FigureMega
	NPCMsg msg_0330_R05R0201_PaintWorld_Text_FigureFirst
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
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
	
UndergroundPath_NorthEntrance_EventScript_AlreadyTraded:
	NPCMsg msg_0330_R05R0201_Trade_Text_HowIsMyOldMon
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
UndergroundPath_NorthEntrance_EventScript_DeclineTrade:
	NPCMsg msg_0330_R05R0201_Trade_Text_ThatsTooBad
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
	
UndergroundPath_NorthEntrance_EventScript_NotRequestedMon:
	BufferSpeciesName 0, 0x8009, 0, 0
	NPCMsg msg_0330_R05R0201_Trade_Text_ThisIsNoMon
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
	
PaintWorld_EventScript_FigureSketch:
	NPCMsg msg_0330_R05R0201_PaintWorld_Text_FigureSketch
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
PaintWorld_EventScript_FigureMega:
	NPCMsg msg_0330_R05R0201_PaintWorld_Text_FigureMega
	WaitButton
	End
	
PaintWorld_EventScript_FigureBattle:
	CloseMsg
	// TODO(gba) special Painter_SetupFigure
	GoTo _cv_stop
	ClearTrainerFlag 1442
	SetFlag 0x2036
	CheckTrainerFlag 1442
	GoToIf TRUE, _cv_beaten_23
	TrainerBattle 1442, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_24
	WhiteOut
	End
_cv_won_24:
	SetTrainerFlag 1442
	ReleaseAll
	End
_cv_beaten_23:
	ClearFlag 0x2036
	GetStaticEncounterOutcome VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfNe _cv_outcome_25
	SetVar VAR_SPECIAL_RESULT, 7
	GoTo _cv_outcome_26
_cv_outcome_25:
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfNe _cv_outcome_26
	SetVar VAR_SPECIAL_RESULT, 4
_cv_outcome_26:
	// TODO(gba) special Painter_RecordBattle
	GoTo _cv_stop
	NPCMsg msg_0330_R05R0201_PaintWorld_Text_Dissolve
	WaitButton
	CloseMsg
	FadeScreen 6, 1, 0, RGB_WHITE
	WaitFade
	Warp MAP_CANVAS_PEWTER_PAINTER_LOFT, 0, 8, 4, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0330_R05R0201_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
