#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T07R0102.h"
#include "msgdata/msg/msg_0495_T07R0102.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's CeladonCity_DepartmentStore_2F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef CeladonCity_DepartmentStore_2F_EventScript_Lass
	ScrDef CeladonCity_DepartmentStore_2F_EventScript_ClerkItems
	ScrDef CeladonCity_DepartmentStore_2F_EventScript_ClerkTMs
	ScrDef CeladonCity_DepartmentStore_2F_EventScript_Woman
	ScrDef PaintWorld_EventScript_Figure
	ScrDef CeladonCity_DepartmentStore_2F_EventScript_FloorSign
	ScrDefEnd
	
CeladonCity_DepartmentStore_2F_EventScript_Lass:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0495_T07R0102_CeladonCity_DepartmentStore_2F_Text_BuyReviveForLongOutings
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_DepartmentStore_2F_EventScript_ClerkItems:
	LockAll
	FacePlayer
	NPCMsg msg_0495_T07R0102_gText_HowMayIServeYou
	CanvasMart 9
	.short ITEM_GREAT_BALL
	.short ITEM_SUPER_POTION
	.short ITEM_REVIVE
	.short ITEM_ANTIDOTE
	.short ITEM_PARLYZ_HEAL
	.short ITEM_AWAKENING
	.short ITEM_BURN_HEAL
	.short ITEM_ICE_HEAL
	.short ITEM_SUPER_REPEL
	NPCMsg msg_0495_T07R0102_gText_PleaseComeAgain
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_DepartmentStore_2F_EventScript_ClerkTMs:
	LockAll
	FacePlayer
	NPCMsg msg_0495_T07R0102_gText_HowMayIServeYou
	CanvasMart 7
	.short ITEM_TM05
	.short ITEM_TM10
	.short ITEM_TM15
	.short ITEM_TM28
	.short ITEM_TM31
	.short ITEM_TM43
	.short ITEM_TM45
	NPCMsg msg_0495_T07R0102_gText_PleaseComeAgain
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_DepartmentStore_2F_EventScript_Woman:
	LockAll
	FacePlayer
	NPCMsg msg_0495_T07R0102_CeladonCity_DepartmentStore_2F_Text_LanceComesToBuyCapes
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
	NPCMsg msg_0495_T07R0102_PaintWorld_Text_FigureFirst
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
CeladonCity_DepartmentStore_2F_EventScript_FloorSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0495_T07R0102_CeladonCity_DepartmentStore_2F_Text_FloorSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PaintWorld_EventScript_FigureSketch:
	NPCMsg msg_0495_T07R0102_PaintWorld_Text_FigureSketch
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
PaintWorld_EventScript_FigureMega:
	NPCMsg msg_0495_T07R0102_PaintWorld_Text_FigureMega
	WaitButton
	End
	
PaintWorld_EventScript_FigureBattle:
	CloseMsg
	// TODO(gba) special Painter_SetupFigure
	GoTo _cv_stop
	ClearTrainerFlag 1442
	SetFlag 0x2036
	CheckTrainerFlag 1442
	GoToIf TRUE, _cv_beaten_1
	TrainerBattle 1442, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_2
	WhiteOut
	End
_cv_won_2:
	SetTrainerFlag 1442
	ReleaseAll
	End
_cv_beaten_1:
	ClearFlag 0x2036
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq _cv_won_3
	SetVar VAR_SPECIAL_RESULT, 2
_cv_won_3:
	// TODO(gba) special Painter_RecordBattle
	GoTo _cv_stop
	NPCMsg msg_0495_T07R0102_PaintWorld_Text_Dissolve
	WaitButton
	CloseMsg
	FadeScreen 6, 1, 0, RGB_WHITE
	WaitFade
	// TODO(gba) warpsilent MAP_PEWTER_CITY_PAINTER_LOFT, 8, 4
	GoTo _cv_stop
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0495_T07R0102_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
