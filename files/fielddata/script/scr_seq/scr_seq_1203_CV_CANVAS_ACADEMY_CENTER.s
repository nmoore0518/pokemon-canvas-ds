#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_ACADEMY_CENTER.h"
#include "msgdata/msg/msg_0973_CV_CANVAS_ACADEMY_CENTER.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's LeaderAcademy_PokemonCenter by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Academy_EventScript_Nurse
	ScrDef Academy_EventScript_Elias
	ScrDef LeaderAcademy_PokemonCenter_OnTransition
	ScrDefEnd
	
Academy_EventScript_Nurse:
	LockAll
	FacePlayer
	SetVar VAR_SPECIAL_x8007, 0
	CallStd std_nurse_joy
	CanvasCloseMsg
	ReleaseAll
	End
	
Academy_EventScript_Elias:
	LockAll
	FacePlayer
	NPCMsg msg_0973_CV_CANVAS_ACADEMY_CENTER_Academy_Text_EliasHello
	WaitButton
	SetVar 0x8004, 2
	GoTo Academy_EventScript_CandidateBattle
	
LeaderAcademy_PokemonCenter_OnTransition:
	End
	
Academy_EventScript_CandidateBattle:
	// TODO(gba) special Academy_SetupCandidate
	GoTo _cv_stop
	NPCMsg msg_0973_CV_CANVAS_ACADEMY_CENTER_Academy_Text_CandidateAsk
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
	NPCMsg msg_0973_CV_CANVAS_ACADEMY_CENTER_gGymChallengeIntroText
	WaitButton
	CanvasCloseMsg
	Call Academy_EventScript_Battle
	CopyVar 0x8009, VAR_SPECIAL_RESULT
	HealParty
	CompareVarToValue 0x8009, 1
	GoToIfNe Academy_EventScript_CandidateBeatPlayer
	CopyVar 0x8004, 0x8008
	Call Academy_EventScript_EarnBP
	NPCMsg msg_0973_CV_CANVAS_ACADEMY_CENTER_Academy_Text_CandidateHealed
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Academy_EventScript_CandidateLater:
	NPCMsg msg_0973_CV_CANVAS_ACADEMY_CENTER_Academy_Text_CandidateLater
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
	GoToIfNe _cv_won_4
	WhiteOut
	End
_cv_won_4:
	SetTrainerFlag 1442
	ClearFlag 0x2036
	CanvasCandidate 12
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
	NPCMsg msg_0973_CV_CANVAS_ACADEMY_CENTER_gGymChallengeWinText
	WaitButton
	NPCMsg msg_0973_CV_CANVAS_ACADEMY_CENTER_Academy_Text_CandidateHealed
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Academy_EventScript_EarnBP:
	// TODO(gba) special Academy_AddBP
	GoTo _cv_stop
	PlayFanfare SEQ_ME_LVUP
	BufferPlayersName 6
	NPCMsg msg_0973_CV_CANVAS_ACADEMY_CENTER_Academy_Text_EarnedBP
	WaitFanfare
	WaitButton
	Return

_cv_stop:
	NPCMsg msg_0973_CV_CANVAS_ACADEMY_CENTER_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
