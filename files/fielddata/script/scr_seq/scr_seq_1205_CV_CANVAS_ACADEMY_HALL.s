#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_ACADEMY_HALL.h"
#include "msgdata/msg/msg_0974_CV_CANVAS_ACADEMY_HALL.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's LeaderAcademy_Hall by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Academy_EventScript_Headmaster
	ScrDef Academy_EventScript_Nadia
	ScrDef Academy_EventScript_Reader1
	ScrDef Academy_EventScript_Reader2
	ScrDef Academy_EventScript_MegaDoorGuard
	ScrDef LeaderAcademy_Hall_OnTransition
	ScrDef Academy_EventScript_BraceletCall
	ScrDef Academy_EventScript_BraceletGive
	ScrDefEnd
	
Academy_EventScript_Headmaster:
	LockAll
	FacePlayer
	GoTo Academy_EventScript_HeadmasterMenu
	
Academy_EventScript_Nadia:
	LockAll
	FacePlayer
	NPCMsg msg_0974_CV_CANVAS_ACADEMY_HALL_Academy_Text_NadiaHello
	WaitButton
	SetVar 0x8004, 3
	GoTo Academy_EventScript_CandidateBattle
	
Academy_EventScript_Reader1:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0974_CV_CANVAS_ACADEMY_HALL_Academy_Text_Reader1
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Academy_EventScript_Reader2:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0974_CV_CANVAS_ACADEMY_HALL_Academy_Text_Reader2
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Academy_EventScript_MegaDoorGuard:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0974_CV_CANVAS_ACADEMY_HALL_Academy_Text_MegaDoorGuard
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
LeaderAcademy_Hall_OnTransition:
	Call Academy_EventScript_HallTransition
	End
	
Academy_EventScript_BraceletCall:
	LockAll
	PlaySE SEQ_SE_DP_SELECT
	ApplyMovement 1, Common_Movement_ExclamationMark
	WaitMovement
	BufferPlayersName 6
	NPCMsg msg_0974_CV_CANVAS_ACADEMY_HALL_Academy_Text_BraceletCall
	WaitButton
	CanvasCloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	SetVar 0x502F, 6
	Warp MAP_CANVAS_ACADEMY_HALL, 0, 12, 5, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	CanvasCloseMsg
	ReleaseAll
	End
	
Academy_EventScript_BraceletGive:
	LockAll
	ApplyMovement obj_player, Common_Movement_FaceUp
	WaitMovement
	NPCMsg msg_0974_CV_CANVAS_ACADEMY_HALL_Academy_Text_Bracelet1
	WaitButton
	NPCMsg msg_0974_CV_CANVAS_ACADEMY_HALL_Academy_Text_Bracelet2
	WaitButton
	SetOrCopyVar 0x8004, 696
	SetOrCopyVar 0x8005, 1
	HasSpaceForItem 0x8004, 0x8005, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_full_1
	CallStd std_give_item_verbose
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_given_2
_cv_full_1:
	SetVar VAR_SPECIAL_RESULT, 0
_cv_given_2:
	SetFlag 0x222F
	SetVar 0x502F, 4
	NPCMsg msg_0974_CV_CANVAS_ACADEMY_HALL_Academy_Text_Bracelet3
	WaitButton
	CanvasCloseMsg
	HidePerson 5
	SetFlag 0x222F
	CanvasCloseMsg
	ReleaseAll
	End
	
Academy_EventScript_HeadmasterMenu:
	// TODO(gba) special Academy_BufferBP
	GoTo _cv_stop
	BufferPlayersName 6
	NPCMsg msg_0974_CV_CANVAS_ACADEMY_HALL_Academy_Text_HeadmasterHello
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0974_CV_CANVAS_ACADEMY_HALL_Academy_Text_OptBP, 0
	ScrCmd_559 msg_0974_CV_CANVAS_ACADEMY_HALL_Academy_Text_OptHall, 1
	ScrCmd_559 msg_0974_CV_CANVAS_ACADEMY_HALL_Academy_Text_OptCandidates, 2
	ScrCmd_559 msg_0974_CV_CANVAS_ACADEMY_HALL_Academy_Text_OptTeachers, 3
	ScrCmd_559 msg_0974_CV_CANVAS_ACADEMY_HALL_Academy_Text_OptBye, 4
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_4
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Academy_EventScript_HeadmasterBP
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Academy_EventScript_HeadmasterHall
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq Academy_EventScript_HeadmasterCandidates
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfEq Academy_EventScript_HeadmasterTeachers
	NPCMsg msg_0974_CV_CANVAS_ACADEMY_HALL_Academy_Text_HeadmasterBye
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Academy_EventScript_CandidateBattle:
	// TODO(gba) special Academy_SetupCandidate
	GoTo _cv_stop
	NPCMsg msg_0974_CV_CANVAS_ACADEMY_HALL_Academy_Text_CandidateAsk
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_5
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_6
_cv_yes_5:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_6:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Academy_EventScript_CandidateLater
	CopyVar 0x8008, 0x8005
	HealParty
	NPCMsg msg_0974_CV_CANVAS_ACADEMY_HALL_gGymChallengeIntroText
	WaitButton
	CanvasCloseMsg
	Call Academy_EventScript_Battle
	CopyVar 0x8009, VAR_SPECIAL_RESULT
	HealParty
	CompareVarToValue 0x8009, 1
	GoToIfNe Academy_EventScript_CandidateBeatPlayer
	CopyVar 0x8004, 0x8008
	Call Academy_EventScript_EarnBP
	NPCMsg msg_0974_CV_CANVAS_ACADEMY_HALL_Academy_Text_CandidateHealed
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Academy_EventScript_HallTransition:
	CompareVarToValue 0x502F, 4
	GoToIfNe Common_EventScript_NopReturn
	GoToIfUnset 0x2151, Common_EventScript_NopReturn
	GoToIfSet 0x222F, Common_EventScript_NopReturn
	SetVar 0x502F, 5
	Return
	
Academy_EventScript_HeadmasterBP:
	NPCMsg msg_0974_CV_CANVAS_ACADEMY_HALL_Academy_Text_HeadmasterBP
	WaitButton
	GoTo Academy_EventScript_HeadmasterMenu
	
Academy_EventScript_HeadmasterHall:
	NPCMsg msg_0974_CV_CANVAS_ACADEMY_HALL_Academy_Text_HeadmasterHall
	WaitButton
	GoTo Academy_EventScript_HeadmasterMenu
	
Academy_EventScript_HeadmasterCandidates:
	NPCMsg msg_0974_CV_CANVAS_ACADEMY_HALL_Academy_Text_HeadmasterCandidates
	WaitButton
	GoTo Academy_EventScript_HeadmasterMenu
	
Academy_EventScript_HeadmasterTeachers:
	NPCMsg msg_0974_CV_CANVAS_ACADEMY_HALL_Academy_Text_HeadmasterTeachers
	WaitButton
	GoTo Academy_EventScript_HeadmasterMenu
	
Academy_EventScript_CandidateLater:
	NPCMsg msg_0974_CV_CANVAS_ACADEMY_HALL_Academy_Text_CandidateLater
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Academy_EventScript_Battle:
	ClearTrainerFlag 1442
	SetFlag 0x2036
	CanvasCloseMsg
	TrainerBattle 1442, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_8
	WhiteOut
	End
_cv_won_8:
	SetTrainerFlag 1442
	ClearFlag 0x2036
	CanvasCandidate 12
	GetStaticEncounterOutcome VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfNe _cv_outcome_9
	SetVar VAR_SPECIAL_RESULT, 7
	GoTo _cv_outcome_10
_cv_outcome_9:
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfNe _cv_outcome_10
	SetVar VAR_SPECIAL_RESULT, 4
_cv_outcome_10:
	Return
	
Academy_EventScript_CandidateBeatPlayer:
	NPCMsg msg_0974_CV_CANVAS_ACADEMY_HALL_gGymChallengeWinText
	WaitButton
	NPCMsg msg_0974_CV_CANVAS_ACADEMY_HALL_Academy_Text_CandidateHealed
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Academy_EventScript_EarnBP:
	// TODO(gba) special Academy_AddBP
	GoTo _cv_stop
	PlayFanfare SEQ_ME_LVUP
	BufferPlayersName 6
	NPCMsg msg_0974_CV_CANVAS_ACADEMY_HALL_Academy_Text_EarnedBP
	WaitFanfare
	WaitButton
	Return
	
Common_EventScript_NopReturn:
	Return

_cv_stop:
	NPCMsg msg_0974_CV_CANVAS_ACADEMY_HALL_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
Common_Movement_ExclamationMark:
	EmoteExclamationMark
	EndMovement

	.balign 4, 0
Common_Movement_FaceUp:
	FaceNorth
	EndMovement
	.balign 4, 0
