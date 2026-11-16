#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R13.h"
#include "msgdata/msg/msg_0350_R13.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route13_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route13_EventScript_Perry
	ScrDef Route13_EventScript_Jared
	ScrDef BerryField_EventScript_FindFlying
	ScrDef Route13_EventScript_RouteSign
	ScrDef Route13_EventScript_TrainerTips2
	ScrDef Route13_EventScript_TrainerTips1
	ScrDefEnd
	
Route13_EventScript_Perry:
	CheckTrainerFlag 1046
	GoToIf TRUE, _cv_beaten_1
	NPCMsg msg_0350_R13_Route13_Text_PerryIntro
	WaitButton
	CloseMsg
	TrainerBattle 1046, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_2
	WhiteOut
	End
_cv_won_2:
	SetTrainerFlag 1046
	GoTo GymCandidate_EventScript_RecruitFlying
_cv_beaten_1:
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Route13_EventScript_PerryRematch
	SetVar 0x8004, 3
	Call GymCandidate_EventScript_RecruitOffer
	NPCMsg msg_0350_R13_Route13_Text_PerryPostBattle
	WaitButton
	CloseMsg
	End
	
Route13_EventScript_Jared:
	CheckTrainerFlag 946
	GoToIf TRUE, _cv_beaten_3
	NPCMsg msg_0350_R13_Route13_Text_JaredIntro
	WaitButton
	CloseMsg
	TrainerBattle 946, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_4
	WhiteOut
	End
_cv_won_4:
	SetTrainerFlag 946
	GoTo GymCandidate_EventScript_RecruitPoison
_cv_beaten_3:
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Route13_EventScript_JaredRematch
	SetVar 0x8004, 4
	Call GymCandidate_EventScript_RecruitOffer
	NPCMsg msg_0350_R13_Route13_Text_JaredPostBattle
	WaitButton
	CloseMsg
	End
	
BerryField_EventScript_FindFlying:
	SetVar 0x8004, ITEM_COBA_BERRY
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
Route13_EventScript_RouteSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0350_R13_Route13_Text_RouteSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route13_EventScript_TrainerTips2:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0350_R13_Route13_Text_SelectToSwitchItems
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route13_EventScript_TrainerTips1:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0350_R13_Route13_Text_LookToLeftOfThatPost
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_RecruitFlying:
	SetVar 0x8004, 3
	GoTo GymCandidate_EventScript_RecruitAfterBattle
	End
	
Route13_EventScript_PerryRematch:
	// (rematches come later)
	ReleaseAll
	End
	NPCMsg msg_0350_R13_Route13_Text_PerryPostBattle
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
	GoToIfEq _cv_yes_5
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_6
_cv_yes_5:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_6:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_RecruitDeclined
	// TODO(gba) special GymCandidate_Recruit
	GoTo _cv_stop
	PlayFanfare SEQ_ME_ITEM
	NPCMsg msg_0350_R13_GymCandidate_Text_RecruitJoined
	WaitButton
	WaitFanfare
	NPCMsg msg_0350_R13_GymCandidate_Text_RecruitHowToPlace
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_RecruitPoison:
	SetVar 0x8004, 4
	GoTo GymCandidate_EventScript_RecruitAfterBattle
	End
	
Route13_EventScript_JaredRematch:
	// (rematches come later)
	ReleaseAll
	End
	NPCMsg msg_0350_R13_Route13_Text_JaredPostBattle
	WaitButton
	CloseMsg
	End
	
GymCandidate_EventScript_RecruitAfterBattle:
	Call GymCandidate_EventScript_RecruitOffer
	ReleaseAll
	End
	
GymCandidate_EventScript_Return:
	Return
	
GymCandidate_EventScript_RecruitDeclined:
	NPCMsg msg_0350_R13_GymCandidate_Text_RecruitDeclined
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_str4:
	BufferPlayersName 6
	BufferRivalsName 7
	Return

_cv_stop:
	NPCMsg msg_0350_R13_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
