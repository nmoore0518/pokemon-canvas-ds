#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T06R0601.h"
#include "msgdata/msg/msg_0490_T06R0601.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's VermilionCity_House3_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef VermilionCity_House3_EventScript_Boy
	ScrDef VermilionCity_House3_EventScript_Pidgey
	ScrDef VermilionCity_House3_EventScript_Lass
	ScrDef PaintWorld_EventScript_Figure
	ScrDef VermilionCity_House3_EventScript_Letter
	ScrDefEnd
	
VermilionCity_House3_EventScript_Boy:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0490_T06R0601_VermilionCity_House3_Text_PidgeyFlyLetterToSaffron
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_House3_EventScript_Pidgey:
	LockAll
	FacePlayer
	WaitSE SEQ_SE_DP_SELECT
	PlayCry SPECIES_PIDGEY, 0
	NPCMsg msg_0490_T06R0601_VermilionCity_House3_Text_Pidgey
	WaitButton
	WaitCry
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_House3_EventScript_Lass:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0490_T06R0601_VermilionCity_House3_Text_SendMyPidgeyToUnionRoom
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
	NPCMsg msg_0490_T06R0601_PaintWorld_Text_FigureFirst
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
VermilionCity_House3_EventScript_Letter:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0490_T06R0601_VermilionCity_House3_Text_DearPippiLetter
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PaintWorld_EventScript_FigureSketch:
	NPCMsg msg_0490_T06R0601_PaintWorld_Text_FigureSketch
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
PaintWorld_EventScript_FigureMega:
	NPCMsg msg_0490_T06R0601_PaintWorld_Text_FigureMega
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
	NPCMsg msg_0490_T06R0601_PaintWorld_Text_Dissolve
	WaitButton
	CloseMsg
	FadeScreen 6, 1, 0, RGB_WHITE
	WaitFade
	// TODO(gba) warpsilent MAP_PEWTER_CITY_PAINTER_LOFT, 8, 4
	GoTo _cv_stop
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0490_T06R0601_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
