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
	SetVar 0x8009, 0  // TODO(gba) specialvar GetInGameTradeSpeciesInfo
	GoTo _cv_stop
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
	// TODO(gba) special ChoosePartyMon
	GoTo _cv_stop
	LockAll
	FacePlayer
	Return
	
EventScript_GetInGameTradeSpecies:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar GetTradeSpecies
	GoTo _cv_stop
	Return
	
UndergroundPath_NorthEntrance_EventScript_NotRequestedMon:
	BufferSpeciesName 0, 0x8009, 0, 0
	NPCMsg msg_0330_R05R0201_Trade_Text_ThisIsNoMon
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
	GoToIf TRUE, _cv_beaten_3
	TrainerBattle 1442, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_4
	WhiteOut
	End
_cv_won_4:
	SetTrainerFlag 1442
	ReleaseAll
	End
_cv_beaten_3:
	ClearFlag 0x2036
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq _cv_won_5
	SetVar VAR_SPECIAL_RESULT, 2
_cv_won_5:
	// TODO(gba) special Painter_RecordBattle
	GoTo _cv_stop
	NPCMsg msg_0330_R05R0201_PaintWorld_Text_Dissolve
	WaitButton
	CloseMsg
	FadeScreen 6, 1, 0, RGB_WHITE
	WaitFade
	// TODO(gba) warpsilent MAP_PEWTER_CITY_PAINTER_LOFT, 8, 4
	GoTo _cv_stop
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0330_R05R0201_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
