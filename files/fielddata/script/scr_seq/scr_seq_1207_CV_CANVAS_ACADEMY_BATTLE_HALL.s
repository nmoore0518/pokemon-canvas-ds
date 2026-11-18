#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_ACADEMY_BATTLE_HALL.h"
#include "msgdata/msg/msg_0975_CV_CANVAS_ACADEMY_BATTLE_HALL.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's LeaderAcademy_BattleHall by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Academy_EventScript_RentalClerk
	ScrDef Academy_EventScript_Briony
	ScrDef Academy_EventScript_Teo
	ScrDefEnd
	
Academy_EventScript_RentalClerk:
	LockAll
	FacePlayer
	NPCMsg msg_0975_CV_CANVAS_ACADEMY_BATTLE_HALL_Academy_Text_RentalClerk
	WaitButton
	NPCMsg msg_0975_CV_CANVAS_ACADEMY_BATTLE_HALL_Academy_Text_RentalAsk
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Academy_EventScript_HallBye
	Call Academy_EventScript_PickRentals
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq Academy_EventScript_HallBye
	End
	
Academy_EventScript_Briony:
	LockAll
	FacePlayer
	NPCMsg msg_0975_CV_CANVAS_ACADEMY_BATTLE_HALL_Academy_Text_BrionyHello
	WaitButton
	SetVar 0x8004, 6
	GoTo Academy_EventScript_CandidateBattle
	// TODO(gba) .global Academy_EventScript_Teo
	GoTo _cv_stop
	End
	
Academy_EventScript_Teo:
	LockAll
	FacePlayer
	NPCMsg msg_0975_CV_CANVAS_ACADEMY_BATTLE_HALL_Academy_Text_TeoHello
	WaitButton
	SetVar 0x8004, 7
	GoTo Academy_EventScript_CandidateBattle
	
Academy_EventScript_HallBye:
	NPCMsg msg_0975_CV_CANVAS_ACADEMY_BATTLE_HALL_Academy_Text_HallBye
	WaitButton
	CloseMsg
	ReleaseAll
	End
	// TODO(gba) .global Academy_EventScript_Larkspur
	GoTo _cv_stop
	End
	
Academy_EventScript_PickRentals:
	// TODO(gba) special Academy_RentalBegin
	GoTo _cv_stop
	SetVar 0x8007, 1
	End
	
Academy_EventScript_CandidateBattle:
	// TODO(gba) special Academy_SetupCandidate
	GoTo _cv_stop
	NPCMsg msg_0975_CV_CANVAS_ACADEMY_BATTLE_HALL_Academy_Text_CandidateAsk
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_3
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_4
_cv_yes_3:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Academy_EventScript_CandidateLater
	CopyVar 0x8008, 0x8005
	HealParty
	NPCMsg msg_0975_CV_CANVAS_ACADEMY_BATTLE_HALL_gGymChallengeIntroText
	WaitButton
	CloseMsg
	Call Academy_EventScript_Battle
	CopyVar 0x8009, VAR_SPECIAL_RESULT
	HealParty
	CompareVarToValue 0x8009, 1
	GoToIfNe Academy_EventScript_CandidateBeatPlayer
	CopyVar 0x8004, 0x8008
	Call Academy_EventScript_EarnBP
	NPCMsg msg_0975_CV_CANVAS_ACADEMY_BATTLE_HALL_Academy_Text_CandidateHealed
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Academy_EventScript_CandidateLater:
	NPCMsg msg_0975_CV_CANVAS_ACADEMY_BATTLE_HALL_Academy_Text_CandidateLater
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Academy_EventScript_Battle:
	ClearTrainerFlag 1442
	SetFlag 0x2036
	CheckTrainerFlag 1442
	GoToIf TRUE, _cv_beaten_5
	TrainerBattle 1442, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_6
	WhiteOut
	End
_cv_won_6:
	SetTrainerFlag 1442
	ReleaseAll
	End
_cv_beaten_5:
	ClearFlag 0x2036
	// TODO(gba) special GymChallenge_EndPractice
	GoTo _cv_stop
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq _cv_won_7
	SetVar VAR_SPECIAL_RESULT, 2
_cv_won_7:
	Return
	
Academy_EventScript_CandidateBeatPlayer:
	NPCMsg msg_0975_CV_CANVAS_ACADEMY_BATTLE_HALL_gGymChallengeWinText
	WaitButton
	NPCMsg msg_0975_CV_CANVAS_ACADEMY_BATTLE_HALL_Academy_Text_CandidateHealed
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Academy_EventScript_EarnBP:
	// TODO(gba) special Academy_AddBP
	GoTo _cv_stop
	PlayFanfare SEQ_ME_LVUP
	BufferPlayersName 6
	NPCMsg msg_0975_CV_CANVAS_ACADEMY_BATTLE_HALL_Academy_Text_EarnedBP
	WaitFanfare
	WaitButton
	Return
	// TODO(gba) .global Academy_EventScript_Koji
	GoTo _cv_stop
	End

_cv_stop:
	NPCMsg msg_0975_CV_CANVAS_ACADEMY_BATTLE_HALL_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
