#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SAFFRON_HOUSE.h"
#include "msgdata/msg/msg_0964_CV_CANVAS_SAFFRON_HOUSE.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SaffronCity_House_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SaffronCity_House_EventScript_Pidgey
	ScrDef SaffronCity_House_EventScript_Lass
	ScrDef SaffronCity_House_EventScript_Youngster
	ScrDef TrainingHouse_EventScript_Celeste
	ScrDef TrainingHouse_EventScript_Genevieve
	ScrDef PaintWorld_EventScript_Figure
	ScrDef SaffronCity_House_EventScript_Letter
	ScrDefEnd
	
SaffronCity_House_EventScript_Pidgey:
	LockAll
	FacePlayer
	WaitSE SEQ_SE_DP_SELECT
	PlayCry SPECIES_PIDGEY, 0
	NPCMsg msg_0964_CV_CANVAS_SAFFRON_HOUSE_SaffronCity_House_Text_Pidgey
	WaitButton
	WaitCry
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_House_EventScript_Lass:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0964_CV_CANVAS_SAFFRON_HOUSE_SaffronCity_House_Text_DontLookAtMyLetter
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_House_EventScript_Youngster:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0964_CV_CANVAS_SAFFRON_HOUSE_SaffronCity_House_Text_GettingCopycatPokeDoll
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TrainingHouse_EventScript_Celeste:
	LockAll
	FacePlayer
	NPCMsg msg_0964_CV_CANVAS_SAFFRON_HOUSE_TrainingHouse_Text_CelesteIntro
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TrainingHouse_EventScript_Declined
	ClearTrainerFlag 1455
	CanvasCloseMsg
	TrainerBattle 1455, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_4
	WhiteOut
	End
_cv_won_4:
	SetTrainerFlag 1455
	NPCMsg msg_0964_CV_CANVAS_SAFFRON_HOUSE_TrainingHouse_Text_After
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TrainingHouse_EventScript_Genevieve:
	LockAll
	FacePlayer
	NPCMsg msg_0964_CV_CANVAS_SAFFRON_HOUSE_TrainingHouse_Text_GenevieveIntro
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_5
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_6
_cv_yes_5:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_6:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TrainingHouse_EventScript_Declined
	ClearTrainerFlag 1456
	CanvasCloseMsg
	TrainerBattle 1456, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_8
	WhiteOut
	End
_cv_won_8:
	SetTrainerFlag 1456
	NPCMsg msg_0964_CV_CANVAS_SAFFRON_HOUSE_TrainingHouse_Text_After
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
	NPCMsg msg_0964_CV_CANVAS_SAFFRON_HOUSE_PaintWorld_Text_FigureFirst
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
SaffronCity_House_EventScript_Letter:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0964_CV_CANVAS_SAFFRON_HOUSE_SaffronCity_House_Text_ExplainPPUp
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TrainingHouse_EventScript_Declined:
	NPCMsg msg_0964_CV_CANVAS_SAFFRON_HOUSE_TrainingHouse_Text_Declined
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PaintWorld_EventScript_FigureSketch:
	NPCMsg msg_0964_CV_CANVAS_SAFFRON_HOUSE_PaintWorld_Text_FigureSketch
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
PaintWorld_EventScript_FigureMega:
	NPCMsg msg_0964_CV_CANVAS_SAFFRON_HOUSE_PaintWorld_Text_FigureMega
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
	GoToIfNe _cv_won_10
	WhiteOut
	End
_cv_won_10:
	SetTrainerFlag 1442
	ClearFlag 0x2036
	GetStaticEncounterOutcome VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfNe _cv_outcome_11
	SetVar VAR_SPECIAL_RESULT, 7
	GoTo _cv_outcome_12
_cv_outcome_11:
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfNe _cv_outcome_12
	SetVar VAR_SPECIAL_RESULT, 4
_cv_outcome_12:
	// TODO(gba) special Painter_RecordBattle
	GoTo _cv_stop
	NPCMsg msg_0964_CV_CANVAS_SAFFRON_HOUSE_PaintWorld_Text_Dissolve
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
	NPCMsg msg_0964_CV_CANVAS_SAFFRON_HOUSE_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
