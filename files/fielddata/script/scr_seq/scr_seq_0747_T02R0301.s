#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T02R0301.h"
#include "msgdata/msg/msg_0457_T02R0301.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's ViridianCity_School_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef ViridianCity_School_EventScript_Woman
	ScrDef ViridianCity_School_EventScript_Lass
	ScrDef PaintWorld_EventScript_Figure
	ScrDef ViridianCity_School_EventScript_Notebook
	ScrDef ViridianCity_School_EventScript_Blackboard
	ScrDef ViridianCity_School_EventScript_PokemonJournal
	ScrDefEnd
	
ViridianCity_School_EventScript_Woman:
	LockAll
	FacePlayer
	NPCMsg msg_0457_T02R0301_ViridianCity_School_Text_ReadBlackboardCarefully
	WaitButton
	CloseMsg
	ApplyMovement 1, Common_Movement_FaceOriginalDirection
	WaitMovement
	ReleaseAll
	End
	
ViridianCity_School_EventScript_Lass:
	LockAll
	FacePlayer
	NPCMsg msg_0457_T02R0301_ViridianCity_School_Text_TryingToMemorizeNotes
	WaitButton
	CloseMsg
	ApplyMovement 2, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	ReleaseAll
	End
	
PaintWorld_EventScript_Figure:
	LockAll
	FacePlayer
	CompareVarToValue 0x5020, 2
	GoToIfEq PaintWorld_EventScript_FigureSketch
	CompareVarToValue 0x5020, 3
	GoToIfEq PaintWorld_EventScript_FigureMega
	NPCMsg msg_0457_T02R0301_PaintWorld_Text_FigureFirst
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
ViridianCity_School_EventScript_Notebook:
	LockAll
	NPCMsg msg_0457_T02R0301_ViridianCity_School_Text_NotebookFirstPage
	WaitButton
	NPCMsg msg_0457_T02R0301_ViridianCity_School_Text_TurnThePage
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq ViridianCity_School_EventScript_StopReadingNotebook
	NPCMsg msg_0457_T02R0301_ViridianCity_School_Text_NotebookSecondPage
	WaitButton
	NPCMsg msg_0457_T02R0301_ViridianCity_School_Text_TurnThePage
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_3
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_4
_cv_yes_3:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq ViridianCity_School_EventScript_StopReadingNotebook
	NPCMsg msg_0457_T02R0301_ViridianCity_School_Text_NotebookThirdPage
	WaitButton
	NPCMsg msg_0457_T02R0301_ViridianCity_School_Text_TurnThePage
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_5
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_6
_cv_yes_5:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_6:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq ViridianCity_School_EventScript_StopReadingNotebook
	NPCMsg msg_0457_T02R0301_ViridianCity_School_Text_NotebookFourthPage
	WaitButton
	ApplyMovement 2, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	NPCMsg msg_0457_T02R0301_ViridianCity_School_Text_HeyDontLookAtMyNotes
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianCity_School_EventScript_Blackboard:
	LockAll
	NPCMsg msg_0457_T02R0301_ViridianCity_School_Text_BlackboardListsStatusProblems
	WaitButton
	GoTo ViridianCity_School_EventScript_ChooseBlackboardTopic
	CloseMsg
	End
	
ViridianCity_School_EventScript_PokemonJournal:
	LockAll
	FacePlayer
	BufferRivalsName 7
	NPCMsg msg_0457_T02R0301_PokemonJournal_Text_SpecialFeatureProfOak
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PaintWorld_EventScript_FigureSketch:
	NPCMsg msg_0457_T02R0301_PaintWorld_Text_FigureSketch
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
PaintWorld_EventScript_FigureMega:
	NPCMsg msg_0457_T02R0301_PaintWorld_Text_FigureMega
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
	NPCMsg msg_0457_T02R0301_PaintWorld_Text_Dissolve
	WaitButton
	CloseMsg
	FadeScreen 6, 1, 0, RGB_WHITE
	WaitFade
	// TODO(gba) warpsilent MAP_PEWTER_CITY_PAINTER_LOFT, 8, 4
	GoTo _cv_stop
	ReleaseAll
	End
	
ViridianCity_School_EventScript_StopReadingNotebook:
	ReleaseAll
	End
	
ViridianCity_School_EventScript_ChooseBlackboardTopic:
	NPCMsg msg_0457_T02R0301_ViridianCity_School_Text_ReadWhichTopic
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0457_T02R0301_cv_mc_status_info_0, 0
	ScrCmd_559 msg_0457_T02R0301_cv_mc_status_info_1, 1
	ScrCmd_559 msg_0457_T02R0301_cv_mc_status_info_2, 2
	ScrCmd_559 msg_0457_T02R0301_cv_mc_status_info_3, 3
	ScrCmd_559 msg_0457_T02R0301_cv_mc_status_info_4, 4
	ScrCmd_559 msg_0457_T02R0301_cv_mc_status_info_5, 5
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_11
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_11:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq ViridianCity_School_EventScript_ReadSleep
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq ViridianCity_School_EventScript_ReadPoison
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq ViridianCity_School_EventScript_ReadParalysis
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfEq ViridianCity_School_EventScript_ReadBurn
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfEq ViridianCity_School_EventScript_ReadFreeze
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfEq ViridianCity_School_EventScript_ExitBlackboard
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq ViridianCity_School_EventScript_ExitBlackboard
	CloseMsg
	End
	
ViridianCity_School_EventScript_ReadSleep:
	NPCMsg msg_0457_T02R0301_ViridianCity_School_Text_ExplainSleep
	WaitButton
	GoTo ViridianCity_School_EventScript_ChooseBlackboardTopic
	CloseMsg
	End
	
ViridianCity_School_EventScript_ReadPoison:
	NPCMsg msg_0457_T02R0301_ViridianCity_School_Text_ExplainPoison
	WaitButton
	GoTo ViridianCity_School_EventScript_ChooseBlackboardTopic
	CloseMsg
	End
	
ViridianCity_School_EventScript_ReadParalysis:
	NPCMsg msg_0457_T02R0301_ViridianCity_School_Text_ExplainParalysis
	WaitButton
	GoTo ViridianCity_School_EventScript_ChooseBlackboardTopic
	CloseMsg
	End
	
ViridianCity_School_EventScript_ReadBurn:
	NPCMsg msg_0457_T02R0301_ViridianCity_School_Text_ExplainBurn
	WaitButton
	GoTo ViridianCity_School_EventScript_ChooseBlackboardTopic
	CloseMsg
	End
	
ViridianCity_School_EventScript_ReadFreeze:
	NPCMsg msg_0457_T02R0301_ViridianCity_School_Text_ExplainFreeze
	WaitButton
	GoTo ViridianCity_School_EventScript_ChooseBlackboardTopic
	CloseMsg
	End
	
ViridianCity_School_EventScript_ExitBlackboard:
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0457_T02R0301_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
Common_Movement_FaceOriginalDirection:
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterUp:
	WalkOnSpotFasterNorth
	EndMovement
	.balign 4, 0
