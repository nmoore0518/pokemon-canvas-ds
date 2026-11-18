#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R02R0301.h"
#include "msgdata/msg/msg_0323_R02R0301.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route2_EastBuilding_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route2_EastBuilding_EventScript_Aide
	ScrDef Route2_EastBuilding_EventScript_Rocker
	ScrDef PaintWorld_EventScript_Figure
	ScrDefEnd
	
Route2_EastBuilding_EventScript_Aide:
	LockAll
	FacePlayer
	Call Route2_EastBuilding_EventScript_GetAideRequestInfo
	GoToIfSet 0x2127, Route2_EastBuilding_EventScript_AlreadyGotHM05
	BufferPlayersName 6
	NPCMsg msg_0323_R02R0301_Route2_EastBuilding_Text_GiveHM05IfSeen10Mons
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Aide_EventScript_DeclineCheckMons
	SetVar 0x8004, 0
	CountNationalDexSeen 0x8005
	CountNationalDexOwned 0x8006
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x2026, _cv_dex_3
	SetVar VAR_SPECIAL_RESULT, 1
_cv_dex_3:
	BufferInt 2, 0x8006
	Call Route2_EastBuilding_EventScript_GetAideRequestInfo
	CompareVarToValue 0x8006, 10
	GoToIfLt Aide_EventScript_HaventCaughtEnough
	NPCMsg msg_0323_R02R0301_Route2_EastBuilding_Text_GreatHereYouGo
	WaitButton
	HasSpaceForItem ITEM_HM05, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Aide_EventScript_NoRoomForItem
	GiveItem ITEM_HM05, 1, VAR_SPECIAL_RESULT
	BufferItemName 1, ITEM_HM05
	BufferPlayersName 6
	NPCMsg msg_0323_R02R0301_Route2_EastBuilding_Text_ReceivedHM05FromAide
	PlayFanfare SEQ_ME_LVUP
	WaitFanfare
	WaitButton
	NPCMsg msg_0323_R02R0301_Text_GymHack_AndTakeThisToo
	WaitButton
	SetFlag 0x215B
	SetVar VAR_SPECIAL_RESULT, 1
	SetFlag 0x2127
	NPCMsg msg_0323_R02R0301_Route2_EastBuilding_Text_ExplainHM05
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route2_EastBuilding_EventScript_Rocker:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0323_R02R0301_Route2_EastBuilding_Text_CanGetThroughRockTunnel
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
	NPCMsg msg_0323_R02R0301_PaintWorld_Text_FigureFirst
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
Route2_EastBuilding_EventScript_GetAideRequestInfo:
	BufferInt 0, 10
	BufferItemName 1, ITEM_HM05
	Return
	
Route2_EastBuilding_EventScript_AlreadyGotHM05:
	NPCMsg msg_0323_R02R0301_Route2_EastBuilding_Text_ExplainHM05
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Aide_EventScript_DeclineCheckMons:
	NPCMsg msg_0323_R02R0301_Aide_Text_GetEnoughMonsComeBackForItem
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Aide_EventScript_HaventCaughtEnough:
	NPCMsg msg_0323_R02R0301_Aide_Text_HaventCaughtEnoughMonsForItem
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Aide_EventScript_NoRoomForItem:
	NPCMsg msg_0323_R02R0301_Aide_Text_DontHaveAnyRoomForItem
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PaintWorld_EventScript_FigureSketch:
	NPCMsg msg_0323_R02R0301_PaintWorld_Text_FigureSketch
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
PaintWorld_EventScript_FigureMega:
	NPCMsg msg_0323_R02R0301_PaintWorld_Text_FigureMega
	WaitButton
	End
	
PaintWorld_EventScript_FigureBattle:
	CloseMsg
	// TODO(gba) special Painter_SetupFigure
	GoTo _cv_stop
	ClearTrainerFlag 1442
	SetFlag 0x2036
	CheckTrainerFlag 1442
	GoToIf TRUE, _cv_beaten_4
	TrainerBattle 1442, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_5
	WhiteOut
	End
_cv_won_5:
	SetTrainerFlag 1442
	ReleaseAll
	End
_cv_beaten_4:
	ClearFlag 0x2036
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq _cv_won_6
	SetVar VAR_SPECIAL_RESULT, 2
_cv_won_6:
	// TODO(gba) special Painter_RecordBattle
	GoTo _cv_stop
	NPCMsg msg_0323_R02R0301_PaintWorld_Text_Dissolve
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
	NPCMsg msg_0323_R02R0301_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
