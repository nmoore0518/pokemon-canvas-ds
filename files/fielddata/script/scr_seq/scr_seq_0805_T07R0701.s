#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T07R0701.h"
#include "msgdata/msg/msg_0510_T07R0701.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's CeladonCity_Restaurant_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef CeladonCity_Restaurant_EventScript_Chef
	ScrDef CeladonCity_Restaurant_EventScript_Woman
	ScrDef CeladonCity_Restaurant_EventScript_FatMan
	ScrDef CeladonCity_Restaurant_EventScript_CoinCaseMan
	ScrDef CeladonCity_Restaurant_EventScript_WorkerM
	ScrDef PaintWorld_EventScript_Figure
	ScrDefEnd
	
CeladonCity_Restaurant_EventScript_Chef:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0510_T07R0701_CeladonCity_Restaurant_Text_TakingBreakRightNow
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_Restaurant_EventScript_Woman:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0510_T07R0701_CeladonCity_Restaurant_Text_OftenGoToDrugstore
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_Restaurant_EventScript_FatMan:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0510_T07R0701_CeladonCity_Restaurant_Text_ManLostItAllAtSlots
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_Restaurant_EventScript_CoinCaseMan:
	LockAll
	FacePlayer
	GoToIfSet 0x2136, CeladonCity_Restaurant_EventScript_AlreadyGotCoinCase
	NPCMsg msg_0510_T07R0701_CeladonCity_Restaurant_Text_TakeThisImBusted
	WaitButton
	HasSpaceForItem ITEM_COIN_CASE, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CeladonCity_Restaurant_EventScript_NoRoomForCoinCase
	GiveItem ITEM_COIN_CASE, 1, VAR_SPECIAL_RESULT
	BufferItemName 1, ITEM_COIN_CASE
	BufferPlayersName 6
	NPCMsg msg_0510_T07R0701_CeladonCity_Restaurant_Text_ReceivedCoinCaseFromMan
	PlayFanfare SEQ_ME_LVUP
	WaitFanfare
	WaitButton
	SetFlag 0x2136
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_Restaurant_EventScript_WorkerM:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0510_T07R0701_CeladonCity_Restaurant_Text_PsstBasementUnderGameCorner
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
	NPCMsg msg_0510_T07R0701_PaintWorld_Text_FigureFirst
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
CeladonCity_Restaurant_EventScript_AlreadyGotCoinCase:
	NPCMsg msg_0510_T07R0701_CeladonCity_Restaurant_Text_ThoughtIdWinItBack
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_Restaurant_EventScript_NoRoomForCoinCase:
	NPCMsg msg_0510_T07R0701_CeladonCity_Restaurant_Text_MakeRoomForThis
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PaintWorld_EventScript_FigureSketch:
	NPCMsg msg_0510_T07R0701_PaintWorld_Text_FigureSketch
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
PaintWorld_EventScript_FigureMega:
	NPCMsg msg_0510_T07R0701_PaintWorld_Text_FigureMega
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
PaintWorld_EventScript_FigureBattle:
	CanvasCloseMsg
	// TODO(gba) special Painter_SetupFigure
	GoTo _cv_stop
	ClearTrainerFlag 1442
	SetFlag 0x2036
	CanvasCloseMsg
	TrainerBattle 1442, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_2
	WhiteOut
	End
_cv_won_2:
	SetTrainerFlag 1442
	ClearFlag 0x2036
	GetStaticEncounterOutcome VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfNe _cv_outcome_3
	SetVar VAR_SPECIAL_RESULT, 7
	GoTo _cv_outcome_4
_cv_outcome_3:
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfNe _cv_outcome_4
	SetVar VAR_SPECIAL_RESULT, 4
_cv_outcome_4:
	// TODO(gba) special Painter_RecordBattle
	GoTo _cv_stop
	NPCMsg msg_0510_T07R0701_PaintWorld_Text_Dissolve
	WaitButton
	CanvasCloseMsg
	FadeScreen 6, 1, 0, RGB_WHITE
	WaitFade
	Warp MAP_CANVAS_PEWTER_PAINTER_LOFT, 0, 8, 4, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	CanvasCloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0510_T07R0701_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
