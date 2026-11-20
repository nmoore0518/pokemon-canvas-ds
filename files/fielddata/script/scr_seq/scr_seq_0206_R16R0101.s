#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R16R0101.h"
#include "msgdata/msg/msg_0355_R16R0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route16_House_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route16_House_EventScript_Woman
	ScrDef Route16_House_EventScript_Fearow
	ScrDef PaintWorld_EventScript_Figure
	ScrDefEnd
	
Route16_House_EventScript_Woman:
	LockAll
	FacePlayer
	GoToIfSet 0x215A, Route16_House_EventScript_AlreadyGotHM02
	NPCMsg msg_0355_R16R0101_Route16_House_Text_FoundMySecretRetreat
	WaitButton
	HasSpaceForItem ITEM_HM02, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Route16_House_EventScript_NoRoomForHM02
	GiveItem ITEM_HM02, 1, VAR_SPECIAL_RESULT
	BufferItemName 1, ITEM_HM02
	BufferPlayersName 6
	NPCMsg msg_0355_R16R0101_Route16_House_Text_ReceivedHM02FromGirl
	PlayFanfare SEQ_ME_LVUP
	WaitFanfare
	WaitButton
	Call Route16_House_EventScript_GiveBalloonIfMissing
	NPCMsg msg_0355_R16R0101_Route16_House_Text_ExplainHM02
	WaitButton
	SetFlag 0x215A
	CloseMsg
	ReleaseAll
	End
	
Route16_House_EventScript_Fearow:
	LockAll
	FacePlayer
	WaitSE SEQ_SE_DP_SELECT
	PlayCry SPECIES_FEAROW, 0
	NPCMsg msg_0355_R16R0101_Route16_House_Text_Fearow
	WaitButton
	WaitCry
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
	NPCMsg msg_0355_R16R0101_PaintWorld_Text_FigureFirst
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
Route16_House_EventScript_AlreadyGotHM02:
	NPCMsg msg_0355_R16R0101_Route16_House_Text_ExplainHM02
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route16_House_EventScript_NoRoomForHM02:
	NPCMsg msg_0355_R16R0101_Route16_House_Text_DontHaveAnyRoomForThis
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route16_House_EventScript_GiveBalloonIfMissing:
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x202C, _cv_has_1
	SetVar VAR_SPECIAL_RESULT, 1
_cv_has_1:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Route16_House_EventScript_HaveBalloon
	NPCMsg msg_0355_R16R0101_Text_GymHack_AndTakeThisToo
	WaitButton
	SetFlag 0x202C
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo Route16_House_EventScript_HaveBalloon
	
PaintWorld_EventScript_FigureSketch:
	NPCMsg msg_0355_R16R0101_PaintWorld_Text_FigureSketch
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
PaintWorld_EventScript_FigureMega:
	NPCMsg msg_0355_R16R0101_PaintWorld_Text_FigureMega
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
	GoToIfNe _cv_won_3
	WhiteOut
	End
_cv_won_3:
	SetTrainerFlag 1442
	ClearFlag 0x2036
	GetStaticEncounterOutcome VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfNe _cv_outcome_4
	SetVar VAR_SPECIAL_RESULT, 7
	GoTo _cv_outcome_5
_cv_outcome_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfNe _cv_outcome_5
	SetVar VAR_SPECIAL_RESULT, 4
_cv_outcome_5:
	// TODO(gba) special Painter_RecordBattle
	GoTo _cv_stop
	NPCMsg msg_0355_R16R0101_PaintWorld_Text_Dissolve
	WaitButton
	CloseMsg
	FadeScreen 6, 1, 0, RGB_WHITE
	WaitFade
	Warp MAP_CANVAS_PEWTER_PAINTER_LOFT, 0, 8, 4, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	ReleaseAll
	End
	
Route16_House_EventScript_HaveBalloon:
	Return

_cv_stop:
	NPCMsg msg_0355_R16R0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
