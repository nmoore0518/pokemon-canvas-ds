#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_CERULEAN_CAVE_1F.h"
#include "msgdata/msg/msg_0877_CV_CANVAS_CERULEAN_CAVE_1F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's CeruleanCave_1F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef CeruleanCave_1F_EventScript_ItemNugget
	ScrDef CeruleanCave_1F_EventScript_ItemFullRestore
	ScrDef CeruleanCave_1F_EventScript_ItemMaxElixir
	ScrDef PaintWorld_EventScript_Figure
	ScrDef CeruleanCave_1F_OnTransition
	ScrDefEnd
	
CeruleanCave_1F_EventScript_ItemNugget:
	SetVar 0x8004, ITEM_NUGGET
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
CeruleanCave_1F_EventScript_ItemFullRestore:
	SetVar 0x8004, ITEM_FULL_RESTORE
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
CeruleanCave_1F_EventScript_ItemMaxElixir:
	SetVar 0x8004, ITEM_MAX_ELIXIR
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
PaintWorld_EventScript_Figure:
	LockAll
	FacePlayer
	CompareVarToValue 0x5020, 2
	GoToIfEq PaintWorld_EventScript_FigureSketch
	CompareVarToValue 0x5020, 3
	GoToIfEq PaintWorld_EventScript_FigureMega
	NPCMsg msg_0877_CV_CANVAS_CERULEAN_CAVE_1F_PaintWorld_Text_FigureFirst
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
CeruleanCave_1F_OnTransition:
	End
	
PaintWorld_EventScript_FigureSketch:
	NPCMsg msg_0877_CV_CANVAS_CERULEAN_CAVE_1F_PaintWorld_Text_FigureSketch
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
PaintWorld_EventScript_FigureMega:
	NPCMsg msg_0877_CV_CANVAS_CERULEAN_CAVE_1F_PaintWorld_Text_FigureMega
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
	NPCMsg msg_0877_CV_CANVAS_CERULEAN_CAVE_1F_PaintWorld_Text_Dissolve
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
	NPCMsg msg_0877_CV_CANVAS_CERULEAN_CAVE_1F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
