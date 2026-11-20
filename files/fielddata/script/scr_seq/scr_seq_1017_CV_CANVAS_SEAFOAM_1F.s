#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SEAFOAM_1F.h"
#include "msgdata/msg/msg_0880_CV_CANVAS_SEAFOAM_1F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SeafoamIslands_1F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SeafoamIslands_1F_EventScript_ItemIceHeal
	ScrDef BerryField_EventScript_FindIce
	ScrDef PaintWorld_EventScript_Figure
	ScrDef SeafoamIslands_1F_Frlg_cv_BoulderFalls
	ScrDef SeafoamIslands_1F_OnTransition
	ScrDefEnd
	
SeafoamIslands_1F_EventScript_ItemIceHeal:
	SetVar 0x8004, ITEM_ICE_HEAL
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
BerryField_EventScript_FindIce:
	SetVar 0x8004, ITEM_YACHE_BERRY
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
	NPCMsg msg_0880_CV_CANVAS_SEAFOAM_1F_PaintWorld_Text_FigureFirst
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
SeafoamIslands_1F_Frlg_cv_BoulderFalls:
	PlaySE SEQ_SE_GS_IWAOTOSHI
	CompareVarToValue VAR_SPECIAL_LAST_TALKED, 1
	GoToIfNe _cv_fall_1
	SetFlag 0x2112
	ClearFlag 0x2114
	HidePerson VAR_SPECIAL_LAST_TALKED
	WaitSE SEQ_SE_GS_IWAOTOSHI
	End
_cv_fall_1:
	CompareVarToValue VAR_SPECIAL_LAST_TALKED, 2
	GoToIfNe _cv_fall_2
	SetFlag 0x2113
	ClearFlag 0x2115
	HidePerson VAR_SPECIAL_LAST_TALKED
	WaitSE SEQ_SE_GS_IWAOTOSHI
	End
_cv_fall_2:
	End
	
SeafoamIslands_1F_OnTransition:
	End
	
PaintWorld_EventScript_FigureSketch:
	NPCMsg msg_0880_CV_CANVAS_SEAFOAM_1F_PaintWorld_Text_FigureSketch
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
PaintWorld_EventScript_FigureMega:
	NPCMsg msg_0880_CV_CANVAS_SEAFOAM_1F_PaintWorld_Text_FigureMega
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
	NPCMsg msg_0880_CV_CANVAS_SEAFOAM_1F_PaintWorld_Text_Dissolve
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
	NPCMsg msg_0880_CV_CANVAS_SEAFOAM_1F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
