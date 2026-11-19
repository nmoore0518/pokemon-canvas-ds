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
	End
	
Academy_EventScript_Nadia:
	LockAll
	FacePlayer
	NPCMsg msg_0974_CV_CANVAS_ACADEMY_HALL_Academy_Text_NadiaHello
	WaitButton
	SetVar 0x8004, 3
	GoTo Academy_EventScript_CandidateBattle
	// TODO(gba) .global Academy_EventScript_Rene
	GoTo _cv_stop
	End
	
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
	CloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	SetVar 0x502F, 6
	Warp MAP_CANVAS_ACADEMY_HALL, 0, 12, 5, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
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
	GiveItem 696, 1, VAR_SPECIAL_RESULT
	SetFlag 0x222F
	SetVar 0x502F, 4
	NPCMsg msg_0974_CV_CANVAS_ACADEMY_HALL_Academy_Text_Bracelet3
	WaitButton
	CloseMsg
	HidePerson 5
	SetFlag 0x222F
	ReleaseAll
	End
	
Academy_EventScript_CandidateBattle:
	// TODO(gba) special Academy_SetupCandidate
	GoTo _cv_stop
	NPCMsg msg_0974_CV_CANVAS_ACADEMY_HALL_Academy_Text_CandidateAsk
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Academy_EventScript_CandidateLater
	CopyVar 0x8008, 0x8005
	HealParty
	NPCMsg msg_0974_CV_CANVAS_ACADEMY_HALL_gGymChallengeIntroText
	WaitButton
	CloseMsg
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
	
Academy_EventScript_CandidateLater:
	NPCMsg msg_0974_CV_CANVAS_ACADEMY_HALL_Academy_Text_CandidateLater
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Academy_EventScript_Battle:
	ClearTrainerFlag 1442
	SetFlag 0x2036
	CheckTrainerFlag 1442
	GoToIf TRUE, _cv_beaten_3
	TrainerBattle 1442, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_4
	WhiteOut
	End
_cv_won_4:
	SetTrainerFlag 1442
	ReleaseAll
	End
_cv_beaten_3:
	ClearFlag 0x2036
	// TODO(gba) special GymChallenge_EndPractice
	GoTo _cv_stop
	GetStaticEncounterOutcome VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfNe _cv_outcome_5
	SetVar VAR_SPECIAL_RESULT, 7
	GoTo _cv_outcome_6
_cv_outcome_5:
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfNe _cv_outcome_6
	SetVar VAR_SPECIAL_RESULT, 4
_cv_outcome_6:
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
	// TODO(gba) .global Academy_EventScript_Koji
	GoTo _cv_stop
	End
	
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
