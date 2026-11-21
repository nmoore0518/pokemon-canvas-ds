#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T03.h"
#include "msgdata/msg/msg_0460_T03.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PewterCity_Frlg#world by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef PewterCity_EventScript_Lass
	ScrDef PewterCity_EventScript_MuseumGuide
	ScrDef PewterCity_EventScript_FatMan
	ScrDef PewterCity_EventScript_BugCatcher
	ScrDef TypeTutor_EventScript_Rock
	ScrDef PewterCity_EventScript_MuseumSign
	ScrDef PewterCity_EventScript_PoliceNotice
	ScrDef PewterCity_EventScript_GymSign
	ScrDef PewterCity_EventScript_TrainerTips
	ScrDef PewterCity_EventScript_CitySign
	ScrDef PewterCity_OnTransition
	ScrDefEnd
	
PewterCity_EventScript_Lass:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0460_T03_PewterCity_Text_ClefairyCameFromMoon
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_EventScript_MuseumGuide:
	LockAll
	FacePlayer
	NPCMsg msg_0460_T03_PewterCity_Text_DidYouCheckOutMuseum
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq PewterCity_EventScript_CheckedOutMuseum
	NPCMsg msg_0460_T03_PewterCity_Text_ReallyYouHaveToGo
	WaitButton
	CanvasCloseMsg
	Wait 10, VAR_SPECIAL_RESULT
	PlayBGM SEQ_GS_E_TSURETEKE1
	CompareVarToValue 0x5002, 0
	CallIfEq PewterCity_EventScript_LeadToMuseumNorth
	CompareVarToValue 0x5002, 1
	CallIfEq PewterCity_EventScript_LeadToMuseumSouth
	CompareVarToValue 0x5002, 2
	CallIfEq PewterCity_EventScript_LeadToMuseumWest
	CompareVarToValue 0x5002, 3
	CallIfEq PewterCity_EventScript_LeadToMuseumEast
	NPCMsg msg_0460_T03_PewterCity_Text_ThisIsTheMuseum
	WaitButton
	CanvasCloseMsg
	Wait 10, VAR_SPECIAL_RESULT
	ApplyMovement 2, PewterCity_Movement_MuseumGuideExit
	WaitMovement
	ResetBGM
	HidePerson 2
	SetFlag 0x20B3
	ClearFlag 0x20B3
	ShowPerson 2
	CanvasCloseMsg
	ReleaseAll
	End
	
PewterCity_EventScript_FatMan:
	LockAll
	FacePlayer
	NPCMsg msg_0460_T03_PewterCity_Text_BrockOnlySeriousTrainerHere
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_EventScript_BugCatcher:
	LockAll
	FacePlayer
	NPCMsg msg_0460_T03_PewterCity_Text_DoYouKnowWhatImDoing
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_3
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_4
_cv_yes_3:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq PewterCity_EventScript_KnowWhatTheyreDoing
	NPCMsg msg_0460_T03_PewterCity_Text_SprayingRepelToKeepWildMonsOut
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TypeTutor_EventScript_Rock:
	LockAll
	FacePlayer
	SetVar 0x8004, 4
	GoTo TypeTutor_EventScript_Talk
	
PewterCity_EventScript_MuseumSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0460_T03_PewterCity_Text_MuseumOfScience
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_EventScript_PoliceNotice:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0460_T03_PewterCity_Text_CallPoliceIfInfoOnThieves
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_EventScript_GymSign:
	LockAll
	NPCMsg msg_0460_T03_PewterCity_Text_GymSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_EventScript_TrainerTips:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0460_T03_PewterCity_Text_TrainerTipsEarningEXP
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_EventScript_CitySign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0460_T03_PewterCity_Text_CitySign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_OnTransition:
	SetFlag FLAG_SYS_FLYPOINT_PEWTER
	SetVar 0x5021, 0
	End
	
PewterCity_EventScript_CheckedOutMuseum:
	NPCMsg msg_0460_T03_PewterCity_Text_WerentThoseFossilsAmazing
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_EventScript_LeadToMuseumNorth:
	ApplyMovement 2, PewterCity_Movement_GuideWalkToMuseumNorth
	ApplyMovement obj_player, PewterCity_Movement_PlayerWalkToMuseumNorth
	WaitMovement
	Return
	
PewterCity_EventScript_LeadToMuseumSouth:
	ApplyMovement 2, PewterCity_Movement_GuideWalkToMuseumSouth
	ApplyMovement obj_player, PewterCity_Movement_PlayerWalkToMuseumSouth
	WaitMovement
	Return
	
PewterCity_EventScript_LeadToMuseumWest:
	ApplyMovement 2, PewterCity_Movement_GuideWalkToMuseumWest
	ApplyMovement obj_player, PewterCity_Movement_PlayerWalkToMuseumWest
	WaitMovement
	Return
	
PewterCity_EventScript_LeadToMuseumEast:
	ApplyMovement 2, PewterCity_Movement_GuideWalkToMuseumEast
	ApplyMovement obj_player, PewterCity_Movement_PlayerWalkToMuseumEast
	WaitMovement
	Return
	
PewterCity_EventScript_KnowWhatTheyreDoing:
	NPCMsg msg_0460_T03_PewterCity_Text_ThatsRightItsHardWork
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TypeTutor_EventScript_Talk:
	CopyVar 0x8008, 0x8004
	// TODO(gba) special TypeTutor_GetState
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TypeTutor_EventScript_Intro
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq TypeTutor_EventScript_Trial
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq TypeTutor_EventScript_JustDone
	GoTo TypeTutor_EventScript_Teach
	
TypeTutor_EventScript_Intro:
	// TODO(gba) special TypeTutor_BufferIntro
	GoTo _cv_stop
	Call _cv_str4
	WaitButton
	// TODO(gba) special TypeTutor_SetMet
	GoTo _cv_stop
	// TODO(gba) special TypeTutor_GetState
	GoTo _cv_stop
	GoTo TypeTutor_EventScript_Trial
	
TypeTutor_EventScript_Trial:
	// TODO(gba) special TypeTutor_BufferTrial
	GoTo _cv_stop
	Call _cv_str4
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TypeTutor_EventScript_JustDone:
	// TODO(gba) special TypeTutor_BufferDone
	GoTo _cv_stop
	Call _cv_str4
	WaitButton
	// TODO(gba) special TypeTutor_SetOpened
	GoTo _cv_stop
	GoTo TypeTutor_EventScript_Teach
	
TypeTutor_EventScript_Teach:
	CopyVar 0x8004, 0x8008
	NPCMsg msg_0460_T03_TypeTutor_Text_WhichMove
	// TODO(gba) special TypeTutor_PushMoves
	GoTo _cv_stop
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_6
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_6:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq TypeTutor_EventScript_Bye
	CopyVar 0x8004, 0x8008
	// TODO(gba) special TypeTutor_SelectMove
	GoTo _cv_stop
	NPCMsg msg_0460_T03_TypeTutor_Text_WhichMon
	WaitButton
	Call EventScript_ChooseMoveTutorMon
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TypeTutor_EventScript_Teach
	NPCMsg msg_0460_T03_TypeTutor_Text_Taught
	WaitButton
	GoTo TypeTutor_EventScript_Teach
	
TypeTutor_EventScript_Bye:
	NPCMsg msg_0460_T03_TypeTutor_Text_Bye
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_ChooseMoveTutorMon:
	// TODO(gba) special ChooseMonForMoveTutor
	GoTo _cv_stop
	LockAll
	FacePlayer
	Return

_cv_str4:
	BufferPlayersName 6
	BufferRivalsName 7
	Return

_cv_stop:
	NPCMsg msg_0460_T03_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
PewterCity_Movement_MuseumGuideExit:
	WalkNormalSouth
	WalkNormalEast 7
	WalkNormalSouth 3
	WalkNormalEast 3
	EndMovement

	.balign 4, 0
PewterCity_Movement_GuideWalkToMuseumNorth:
	WalkNormalNorth 4
	WalkNormalWest 10
	WalkNormalNorth 4
	WalkNormalWest 7
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
PewterCity_Movement_PlayerWalkToMuseumNorth:
	WalkNormalNorth 5
	WalkNormalWest 10
	WalkNormalNorth 4
	WalkNormalWest 6
	Delay8
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
PewterCity_Movement_GuideWalkToMuseumSouth:
	WalkNormalWest
	WalkNormalNorth 4
	WalkNormalWest 9
	WalkNormalNorth 4
	WalkNormalWest 7
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
PewterCity_Movement_PlayerWalkToMuseumSouth:
	Delay16 2
	WalkNormalWest
	WalkNormalNorth 3
	WalkNormalWest 9
	WalkNormalNorth 4
	WalkNormalWest 6
	Delay8
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
PewterCity_Movement_GuideWalkToMuseumWest:
	WalkNormalNorth 4
	WalkNormalWest 10
	WalkNormalNorth 4
	WalkNormalWest 7
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
PewterCity_Movement_PlayerWalkToMuseumWest:
	WalkNormalWest
	WalkNormalNorth 4
	WalkNormalWest 10
	WalkNormalNorth 4
	WalkNormalWest 6
	Delay8
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
PewterCity_Movement_GuideWalkToMuseumEast:
	WalkNormalNorth 4
	WalkNormalWest 10
	WalkNormalNorth 4
	WalkNormalWest 7
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
PewterCity_Movement_PlayerWalkToMuseumEast:
	WalkNormalEast
	WalkNormalNorth 4
	WalkNormalWest 10
	WalkNormalNorth 4
	WalkNormalWest 6
	Delay8
	WalkOnSpotFasterNorth
	EndMovement
	.balign 4, 0
