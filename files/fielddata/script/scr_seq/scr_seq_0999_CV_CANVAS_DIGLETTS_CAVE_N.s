#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_DIGLETTS_CAVE_N.h"
#include "msgdata/msg/msg_0871_CV_CANVAS_DIGLETTS_CAVE_N.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's DiglettsCave_NorthEntrance_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef DiglettsCave_NorthEntrance_EventScript_Hiker
	ScrDef PaintWorld_EventScript_Figure
	ScrDefEnd
	
DiglettsCave_NorthEntrance_EventScript_Hiker:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0871_CV_CANVAS_DIGLETTS_CAVE_N_DiglettsCave_NorthEntrance_RockTunnelPitchBlack
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
	NPCMsg msg_0871_CV_CANVAS_DIGLETTS_CAVE_N_PaintWorld_Text_FigureFirst
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
PaintWorld_EventScript_FigureSketch:
	NPCMsg msg_0871_CV_CANVAS_DIGLETTS_CAVE_N_PaintWorld_Text_FigureSketch
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
PaintWorld_EventScript_FigureMega:
	NPCMsg msg_0871_CV_CANVAS_DIGLETTS_CAVE_N_PaintWorld_Text_FigureMega
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
	NPCMsg msg_0871_CV_CANVAS_DIGLETTS_CAVE_N_PaintWorld_Text_Dissolve
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
	NPCMsg msg_0871_CV_CANVAS_DIGLETTS_CAVE_N_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
