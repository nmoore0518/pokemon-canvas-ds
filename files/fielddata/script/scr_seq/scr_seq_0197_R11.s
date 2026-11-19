#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R11.h"
#include "msgdata/msg/msg_0346_R11.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route11_Frlg#world by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route11_EventScript_Bernie
	ScrDef Route11_EventScript_ItemXDefend
	ScrDef Route11_EventScript_ItemGreatBall
	ScrDef Route11_EventScript_ItemAwakening
	ScrDef Academy_EventScript_GateGuard
	ScrDef Academy_EventScript_Nothing
	ScrDef Academy_EventScript_Keola
	ScrDef Academy_EventScript_Student2
	ScrDef Market_EventScript_Cashier
	ScrDef Route11_EventScript_DiglettsCaveSign
	ScrDef Academy_EventScript_CenterSign
	ScrDef Academy_EventScript_MarketSign
	ScrDef Academy_EventScript_GateSign
	ScrDef Route11_OnTransition
	ScrDef _cv_unported_14
	ScrDef _cv_unported_15
	ScrDefEnd
	
Route11_EventScript_Bernie:
	CheckTrainerFlag 968
	GoToIf TRUE, _cv_beaten_1
	NPCMsg msg_0346_R11_Route11_Text_BernieIntro
	WaitButton
	CloseMsg
	TrainerBattle 968, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_2
	WhiteOut
	End
_cv_won_2:
	SetTrainerFlag 968
	GoTo GymCandidate_EventScript_RecruitSteel
_cv_beaten_1:
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Route11_EventScript_BernieRematch
	SetVar 0x8004, 9
	Call GymCandidate_EventScript_RecruitOffer
	NPCMsg msg_0346_R11_Route11_Text_BerniePostBattle
	WaitButton
	CloseMsg
	End
	
Route11_EventScript_ItemXDefend:
	SetFlag 0x2101
	SetVar VAR_SPECIAL_RESULT, 1
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
Route11_EventScript_ItemGreatBall:
	SetVar 0x8004, ITEM_GREAT_BALL
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
Route11_EventScript_ItemAwakening:
	SetVar 0x8004, ITEM_AWAKENING
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
Academy_EventScript_GateGuard:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0346_R11_Academy_Text_GateGuard
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Academy_EventScript_Nothing:
	End
	
Academy_EventScript_Keola:
	LockAll
	FacePlayer
	NPCMsg msg_0346_R11_Academy_Text_KeolaHello
	WaitButton
	SetVar 0x8004, 5
	GoTo Academy_EventScript_CandidateBattle
	// TODO(gba) .global Academy_EventScript_Briony
	GoTo _cv_stop
	End
	
Academy_EventScript_Student2:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0346_R11_Academy_Text_Student2
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Market_EventScript_Cashier:
	LockAll
	FacePlayer
	// TODO(gba) special Market_GetPayMode
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Market_EventScript_CashierAskBP
	NPCMsg msg_0346_R11_Academy_Text_MarketAskMoney
	GoTo Market_EventScript_CashierChoose
	
Route11_EventScript_DiglettsCaveSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0346_R11_Route11_Text_DiglettsCave
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Academy_EventScript_CenterSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0346_R11_Academy_Text_CenterSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Academy_EventScript_MarketSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0346_R11_Academy_Text_MarketSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Academy_EventScript_GateSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0346_R11_Academy_Text_GateSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route11_OnTransition:
	Call Academy_EventScript_Route11Transition
	End
	
Academy_EventScript_Invite:
	LockAll
	// TODO(gba) special Academy_PrepareMentor
	GoTo _cv_stop
	PlaySE SEQ_SE_DP_SELECT
	ApplyMovement obj_player, Common_Movement_ExclamationMark
	WaitMovement
	BufferPlayersName 6
	NPCMsg msg_0346_R11_Academy_Text_InviteCall
	WaitButton
	CloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	SetVar 0x502F, 2
	// TODO(gba) warpsilent MAP_ROUTE11, 38, 4
	GoTo _cv_stop
	ReleaseAll
	End
	
Academy_EventScript_Escort:
	LockAll
	// TODO(gba) special Academy_PrepareMentor
	GoTo _cv_stop
	ApplyMovement obj_player, Common_Movement_FaceRight
	ApplyMovement 16, Common_Movement_FaceLeft
	WaitMovement
	NPCMsg msg_0346_R11_Academy_Text_Escort1
	WaitButton
	CloseMsg
	ApplyMovement 16, Academy_Movement_WalkUp2
	ApplyMovement obj_player, Academy_Movement_WalkUp2
	WaitMovement
	NPCMsg msg_0346_R11_Academy_Text_Guard1
	WaitButton
	CloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	SetFlag 0x2102
	SetVar 0x502F, 3
	// TODO(gba) warpsilent MAP_LEADER_ACADEMY_CAMPUS, 21, 37
	GoTo _cv_stop
	ReleaseAll
	End
	
GymCandidate_EventScript_RecruitSteel:
	SetVar 0x8004, 9
	GoTo GymCandidate_EventScript_RecruitAfterBattle
	End
	
Route11_EventScript_BernieRematch:
	// (rematches come later)
	ReleaseAll
	End
	NPCMsg msg_0346_R11_Route11_Text_BerniePostBattle
	WaitButton
	CloseMsg
	End
	
GymCandidate_EventScript_RecruitOffer:
	// TODO(gba) special GymCandidate_BufferRecruit
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymCandidate_EventScript_Return
	LockAll
	FacePlayer
	Call _cv_str4
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_3
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_4
_cv_yes_3:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_RecruitDeclined
	// TODO(gba) special GymCandidate_Recruit
	GoTo _cv_stop
	PlayFanfare SEQ_ME_ITEM
	NPCMsg msg_0346_R11_GymCandidate_Text_RecruitJoined
	WaitButton
	WaitFanfare
	NPCMsg msg_0346_R11_GymCandidate_Text_RecruitHowToPlace
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Academy_EventScript_CandidateBattle:
	// TODO(gba) special Academy_SetupCandidate
	GoTo _cv_stop
	NPCMsg msg_0346_R11_Academy_Text_CandidateAsk
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
	NPCMsg msg_0346_R11_gGymChallengeIntroText
	WaitButton
	CloseMsg
	Call Academy_EventScript_Battle
	CopyVar 0x8009, VAR_SPECIAL_RESULT
	HealParty
	CompareVarToValue 0x8009, 1
	GoToIfNe Academy_EventScript_CandidateBeatPlayer
	CopyVar 0x8004, 0x8008
	Call Academy_EventScript_EarnBP
	NPCMsg msg_0346_R11_Academy_Text_CandidateHealed
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Market_EventScript_CashierAskBP:
	NPCMsg msg_0346_R11_Academy_Text_MarketAskBP
	End
	
Market_EventScript_CashierChoose:
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 0, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0346_R11_Academy_Text_OptMoney, 0
	ScrCmd_559 msg_0346_R11_Academy_Text_OptPayBP, 1
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_8
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_8:
	CopyVar 0x8004, VAR_SPECIAL_RESULT
	// TODO(gba) special Market_SetPayMode
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Market_EventScript_CashierBP
	NPCMsg msg_0346_R11_Academy_Text_MarketPayMoney
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Academy_EventScript_Route11Transition:
	SetFlag 0x2103
	CompareVarToValue 0x502F, 2
	GoToIfEq Academy_EventScript_Route11ShowMentor
	SetVar 0x401C, 0  // TODO(gba) specialvar Academy_InvitationDue
	CompareVarToValue 0x401C, 1
	CallIfEq Academy_EventScript_SetInvite
	Return
	
GymCandidate_EventScript_RecruitAfterBattle:
	Call GymCandidate_EventScript_RecruitOffer
	ReleaseAll
	End
	
GymCandidate_EventScript_Return:
	Return
	
GymCandidate_EventScript_RecruitDeclined:
	NPCMsg msg_0346_R11_GymCandidate_Text_RecruitDeclined
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Academy_EventScript_CandidateLater:
	NPCMsg msg_0346_R11_Academy_Text_CandidateLater
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Academy_EventScript_Battle:
	ClearTrainerFlag 1442
	SetFlag 0x2036
	CheckTrainerFlag 1442
	GoToIf TRUE, _cv_beaten_9
	TrainerBattle 1442, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_10
	WhiteOut
	End
_cv_won_10:
	SetTrainerFlag 1442
	ReleaseAll
	End
_cv_beaten_9:
	ClearFlag 0x2036
	// TODO(gba) special GymChallenge_EndPractice
	GoTo _cv_stop
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
	Return
	
Academy_EventScript_CandidateBeatPlayer:
	NPCMsg msg_0346_R11_gGymChallengeWinText
	WaitButton
	NPCMsg msg_0346_R11_Academy_Text_CandidateHealed
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Academy_EventScript_EarnBP:
	// TODO(gba) special Academy_AddBP
	GoTo _cv_stop
	PlayFanfare SEQ_ME_LVUP
	BufferPlayersName 6
	NPCMsg msg_0346_R11_Academy_Text_EarnedBP
	WaitFanfare
	WaitButton
	Return
	// TODO(gba) .global Academy_EventScript_Koji
	GoTo _cv_stop
	End
	
Market_EventScript_CashierBP:
	NPCMsg msg_0346_R11_Academy_Text_MarketPayBP
	WaitButton
	CloseMsg
	ReleaseAll
	End
	// TODO(gba) .global Market_EventScript_TMsA
	GoTo _cv_stop
	End
	
Academy_EventScript_Route11ShowMentor:
	// TODO(gba) special Academy_PrepareMentor
	ClearFlag 0x2103
	Return
	
Academy_EventScript_SetInvite:
	SetVar 0x502F, 1
	Return

_cv_unported_14:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0346_R11_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_15:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0346_R11_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_str4:
	BufferPlayersName 6
	BufferRivalsName 7
	Return

_cv_stop:
	NPCMsg msg_0346_R11_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
Common_Movement_ExclamationMark:
	EmoteExclamationMark
	EndMovement

	.balign 4, 0
Common_Movement_FaceRight:
	FaceEast
	EndMovement

	.balign 4, 0
Common_Movement_FaceLeft:
	FaceWest
	EndMovement

	.balign 4, 0
Academy_Movement_WalkUp2:
	WalkNormalNorth 2
	EndMovement
	.balign 4, 0
