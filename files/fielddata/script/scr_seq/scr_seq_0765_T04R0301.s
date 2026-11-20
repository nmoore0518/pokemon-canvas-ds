#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T04R0301.h"
#include "msgdata/msg/msg_0473_T04R0301.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's CeruleanCity_House3_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef CeruleanCity_House3_EventScript_Dontae
	ScrDef CeruleanCity_House3_EventScript_OldWoman
	ScrDef TrainingHouse_EventScript_Marina
	ScrDef PaintWorld_EventScript_Figure
	ScrDefEnd
	
CeruleanCity_House3_EventScript_Dontae:
	LockAll
	FacePlayer
	SetVar 0x8008, 5
	Call EventScript_GetInGameTradeSpeciesInfo
	GoToIfSet 0x20DF, CeruleanCity_House3_EventScript_AlreadyTraded
	NPCMsg msg_0473_T04R0301_Trade_Text_DoYouHaveMonWouldYouTradeForMon
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CeruleanCity_House3_EventScript_DeclineTrade
	Call EventScript_ChooseMonForInGameTrade
	CompareVarToValue 0x8004, 6
	GoToIfGe CeruleanCity_House3_EventScript_DeclineTrade
	Call EventScript_GetInGameTradeSpecies
	CompareVarToVar VAR_SPECIAL_RESULT, 0x8009
	GoToIfNe CeruleanCity_House3_EventScript_NotRequestedMon
	Call EventScript_DoInGameTrade
	NPCMsg msg_0473_T04R0301_Trade_Text_Thanks
	WaitButton
	SetFlag 0x20DF
	CloseMsg
	ReleaseAll
	End
	
CeruleanCity_House3_EventScript_OldWoman:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0473_T04R0301_CeruleanCity_House3_Text_PleaseTradeWithMyHusband
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TrainingHouse_EventScript_Marina:
	LockAll
	FacePlayer
	NPCMsg msg_0473_T04R0301_TrainingHouse_Text_MarinaIntro
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_3
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_4
_cv_yes_3:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TrainingHouse_EventScript_Declined
	ClearTrainerFlag 1447
	CanvasCloseMsg
	TrainerBattle 1447, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_6
	WhiteOut
	End
_cv_won_6:
	SetTrainerFlag 1447
	NPCMsg msg_0473_T04R0301_TrainingHouse_Text_After
	WaitButton
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
	NPCMsg msg_0473_T04R0301_PaintWorld_Text_FigureFirst
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
EventScript_GetInGameTradeSpeciesInfo:
	CopyVar 0x8005, 0x8008
	CompareVarToValue 0x8005, 4
	GoToIfNe _cv_next_8
	LoadNPCTrade 13
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_7
_cv_next_8:
	CompareVarToValue 0x8005, 5
	GoToIfNe _cv_next_9
	LoadNPCTrade 14
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_7
_cv_next_9:
	CompareVarToValue 0x8005, 6
	GoToIfNe _cv_next_10
	LoadNPCTrade 15
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_7
_cv_next_10:
	CompareVarToValue 0x8005, 7
	GoToIfNe _cv_next_11
	LoadNPCTrade 16
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_7
_cv_next_11:
	CompareVarToValue 0x8005, 8
	GoToIfNe _cv_next_12
	LoadNPCTrade 17
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_7
_cv_next_12:
	CompareVarToValue 0x8005, 9
	GoToIfNe _cv_next_13
	LoadNPCTrade 18
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_7
_cv_next_13:
	CompareVarToValue 0x8005, 10
	GoToIfNe _cv_next_14
	LoadNPCTrade 19
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_7
_cv_next_14:
	CompareVarToValue 0x8005, 11
	GoToIfNe _cv_next_15
	LoadNPCTrade 20
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_7
_cv_next_15:
	CompareVarToValue 0x8005, 12
	GoToIfNe _cv_next_16
	LoadNPCTrade 21
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_7
_cv_next_16:
_cv_done_7:
	Return
	
CeruleanCity_House3_EventScript_AlreadyTraded:
	NPCMsg msg_0473_T04R0301_Trade_Text_HasTradedMonGrownStronger
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeruleanCity_House3_EventScript_DeclineTrade:
	NPCMsg msg_0473_T04R0301_Trade_Text_WellIfYouDontWantTo
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
	
CeruleanCity_House3_EventScript_NotRequestedMon:
	BufferSpeciesName 0, 0x8009, 0, 0
	NPCMsg msg_0473_T04R0301_Trade_Text_ThisIsntMon
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_DoInGameTrade:
	CompareVarToValue 0x8005, 4
	GoToIfNe _cv_next_18
	LoadNPCTrade 13
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_17
_cv_next_18:
	CompareVarToValue 0x8005, 5
	GoToIfNe _cv_next_19
	LoadNPCTrade 14
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_17
_cv_next_19:
	CompareVarToValue 0x8005, 6
	GoToIfNe _cv_next_20
	LoadNPCTrade 15
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_17
_cv_next_20:
	CompareVarToValue 0x8005, 7
	GoToIfNe _cv_next_21
	LoadNPCTrade 16
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_17
_cv_next_21:
	CompareVarToValue 0x8005, 8
	GoToIfNe _cv_next_22
	LoadNPCTrade 17
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_17
_cv_next_22:
	CompareVarToValue 0x8005, 9
	GoToIfNe _cv_next_23
	LoadNPCTrade 18
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_17
_cv_next_23:
	CompareVarToValue 0x8005, 10
	GoToIfNe _cv_next_24
	LoadNPCTrade 19
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_17
_cv_next_24:
	CompareVarToValue 0x8005, 11
	GoToIfNe _cv_next_25
	LoadNPCTrade 20
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_17
_cv_next_25:
	CompareVarToValue 0x8005, 12
	GoToIfNe _cv_next_26
	LoadNPCTrade 21
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_17
_cv_next_26:
_cv_done_17:
	LockAll
	FacePlayer
	Return
	
TrainingHouse_EventScript_Declined:
	NPCMsg msg_0473_T04R0301_TrainingHouse_Text_Declined
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PaintWorld_EventScript_FigureSketch:
	NPCMsg msg_0473_T04R0301_PaintWorld_Text_FigureSketch
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
PaintWorld_EventScript_FigureMega:
	NPCMsg msg_0473_T04R0301_PaintWorld_Text_FigureMega
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
PaintWorld_EventScript_FigureBattle:
	CloseMsg
	// TODO(gba) special Painter_SetupFigure
	GoTo _cv_stop
	ClearTrainerFlag 1442
	SetFlag 0x2036
	CanvasCloseMsg
	TrainerBattle 1442, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_28
	WhiteOut
	End
_cv_won_28:
	SetTrainerFlag 1442
	ClearFlag 0x2036
	GetStaticEncounterOutcome VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfNe _cv_outcome_29
	SetVar VAR_SPECIAL_RESULT, 7
	GoTo _cv_outcome_30
_cv_outcome_29:
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfNe _cv_outcome_30
	SetVar VAR_SPECIAL_RESULT, 4
_cv_outcome_30:
	// TODO(gba) special Painter_RecordBattle
	GoTo _cv_stop
	NPCMsg msg_0473_T04R0301_PaintWorld_Text_Dissolve
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
	NPCMsg msg_0473_T04R0301_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
