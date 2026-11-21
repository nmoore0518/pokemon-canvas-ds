#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R08.h"
#include "msgdata/msg/msg_0338_R08.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route8_Frlg#world by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route8_EventScript_Julia
	ScrDef Route8_EventScript_Andrea
	ScrDef Route8_EventScript_UndergroundPathSign
	ScrDefEnd
	
Route8_EventScript_Julia:
	CheckTrainerFlag 886
	GoToIf TRUE, _cv_beaten_1
	NPCMsg msg_0338_R08_Route8_Text_JuliaIntro
	WaitButton
	CloseMsg
	TrainerBattle 886, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_2
	WhiteOut
	End
_cv_won_2:
	SetTrainerFlag 886
	GoTo GymCandidate_EventScript_RecruitFairy
_cv_beaten_1:
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Route8_EventScript_JuliaRematch
	SetVar 0x8004, 19
	Call GymCandidate_EventScript_RecruitOffer
	NPCMsg msg_0338_R08_Route8_Text_JuliaPostBattle
	WaitButton
	CloseMsg
	End
	
Route8_EventScript_Andrea:
	CheckTrainerFlag 884
	GoToIf TRUE, _cv_beaten_3
	NPCMsg msg_0338_R08_Route8_Text_AndreaIntro
	WaitButton
	CloseMsg
	TrainerBattle 884, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_4
	WhiteOut
	End
_cv_won_4:
	SetTrainerFlag 884
	GoTo GymCandidate_EventScript_RecruitNormal
_cv_beaten_3:
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Route8_EventScript_AndreaRematch
	SetVar 0x8004, 1
	Call GymCandidate_EventScript_RecruitOffer
	NPCMsg msg_0338_R08_Route8_Text_AndreaPostBattle
	WaitButton
	CloseMsg
	End
	
Route8_EventScript_UndergroundPathSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0338_R08_Route8_Text_UndergroundPathSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_RecruitFairy:
	SetVar 0x8004, 19
	GoTo GymCandidate_EventScript_RecruitAfterBattle
	End
	
Route8_EventScript_JuliaRematch:
	// (rematches come later)
	ReleaseAll
	End
	NPCMsg msg_0338_R08_Route8_Text_JuliaPostBattle
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
	NPCMsg msg_0338_R08_GymCandidate_Text_RecruitJoined
	WaitButton
	WaitFanfare
	NPCMsg msg_0338_R08_GymCandidate_Text_RecruitHowToPlace
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_RecruitNormal:
	SetVar 0x8004, 1
	GoTo GymCandidate_EventScript_RecruitAfterBattle
	End
	
Route8_EventScript_AndreaRematch:
	// (rematches come later)
	ReleaseAll
	End
	NPCMsg msg_0338_R08_Route8_Text_AndreaPostBattle
	WaitButton
	CloseMsg
	End
	
GymCandidate_EventScript_RecruitAfterBattle:
	Call GymCandidate_EventScript_RecruitOffer
	CanvasCloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_Return:
	Return
	
GymCandidate_EventScript_RecruitDeclined:
	NPCMsg msg_0338_R08_GymCandidate_Text_RecruitDeclined
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_str4:
	BufferPlayersName 6
	BufferRivalsName 7
	Return

_cv_stop:
	NPCMsg msg_0338_R08_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
