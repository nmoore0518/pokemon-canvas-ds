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
	CheckTrainerFlag 1447
	GoToIf TRUE, _cv_beaten_5
	TrainerBattle 1447, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_6
	WhiteOut
	End
_cv_won_6:
	SetTrainerFlag 1447
	ReleaseAll
	End
_cv_beaten_5:
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
	SetVar 0x8009, 0  // TODO(gba) specialvar GetInGameTradeSpeciesInfo
	GoTo _cv_stop
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
	// TODO(gba) special ChoosePartyMon
	GoTo _cv_stop
	LockAll
	FacePlayer
	Return
	
EventScript_GetInGameTradeSpecies:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar GetTradeSpecies
	GoTo _cv_stop
	Return
	
CeruleanCity_House3_EventScript_NotRequestedMon:
	BufferSpeciesName 0, 0x8009, 0, 0
	NPCMsg msg_0473_T04R0301_Trade_Text_ThisIsntMon
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
	End
	
PaintWorld_EventScript_FigureBattle:
	CloseMsg
	// TODO(gba) special Painter_SetupFigure
	GoTo _cv_stop
	ClearTrainerFlag 1442
	SetFlag 0x2036
	CheckTrainerFlag 1442
	GoToIf TRUE, _cv_beaten_7
	TrainerBattle 1442, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_8
	WhiteOut
	End
_cv_won_8:
	SetTrainerFlag 1442
	ReleaseAll
	End
_cv_beaten_7:
	ClearFlag 0x2036
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq _cv_won_9
	SetVar VAR_SPECIAL_RESULT, 2
_cv_won_9:
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
