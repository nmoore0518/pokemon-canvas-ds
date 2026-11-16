#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R09.h"
#include "msgdata/msg/msg_0340_R09.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route9_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route9_EventScript_Alicia
	ScrDef Route9_EventScript_Drew
	ScrDef Route9_EventScript_ItemTM40
	ScrDef Route9_EventScript_ItemBurnHeal
	ScrDef Route9_EventScript_RouteSign
	ScrDef EventMons_EventScript_Cap3
	ScrDefEnd
	
Route9_EventScript_Alicia:
	CheckTrainerFlag 908
	GoToIf TRUE, _cv_beaten_1
	NPCMsg msg_0340_R09_Route9_Text_AliciaIntro
	WaitButton
	CloseMsg
	TrainerBattle 908, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_2
	WhiteOut
	End
_cv_won_2:
	SetTrainerFlag 908
	GoTo GymCandidate_EventScript_RecruitGrass
_cv_beaten_1:
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Route9_EventScript_AliciaRematch
	SetVar 0x8004, 13
	Call GymCandidate_EventScript_RecruitOffer
	NPCMsg msg_0340_R09_Route9_Text_AliciaPostBattle
	WaitButton
	CloseMsg
	End
	
Route9_EventScript_Drew:
	CheckTrainerFlag 903
	GoToIf TRUE, _cv_beaten_3
	NPCMsg msg_0340_R09_Route9_Text_DrewIntro
	WaitButton
	CloseMsg
	TrainerBattle 903, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_4
	WhiteOut
	End
_cv_won_4:
	SetTrainerFlag 903
	GoTo GymCandidate_EventScript_RecruitGround
_cv_beaten_3:
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Route9_EventScript_DrewRematch
	SetVar 0x8004, 5
	Call GymCandidate_EventScript_RecruitOffer
	NPCMsg msg_0340_R09_Route9_Text_DrewPostBattle
	WaitButton
	CloseMsg
	End
	
Route9_EventScript_ItemTM40:
	SetVar 0x8004, ITEM_TM40
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
Route9_EventScript_ItemBurnHeal:
	SetVar 0x8004, ITEM_BURN_HEAL
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
Route9_EventScript_RouteSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0340_R09_Route9_Text_RouteSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventMons_EventScript_Cap3:
	SetVar 0x8004, 3
	GoTo EventMons_EventScript_Cap
	
GymCandidate_EventScript_RecruitGrass:
	SetVar 0x8004, 13
	GoTo GymCandidate_EventScript_RecruitAfterBattle
	End
	
Route9_EventScript_AliciaRematch:
	// (rematches come later)
	ReleaseAll
	End
	NPCMsg msg_0340_R09_Route9_Text_AliciaPostBattle
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
	NPCMsg msg_0340_R09_GymCandidate_Text_RecruitJoined
	WaitButton
	WaitFanfare
	NPCMsg msg_0340_R09_GymCandidate_Text_RecruitHowToPlace
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_RecruitGround:
	SetVar 0x8004, 5
	GoTo GymCandidate_EventScript_RecruitAfterBattle
	End
	
Route9_EventScript_DrewRematch:
	// (rematches come later)
	ReleaseAll
	End
	NPCMsg msg_0340_R09_Route9_Text_DrewPostBattle
	WaitButton
	CloseMsg
	End
	
EventMons_EventScript_Cap:
	LockAll
	// TODO(gba) special EventMons_CapFound
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq EventMons_EventScript_CapNoCase
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq EventMons_EventScript_ReleaseAllEnd
	PlayFanfare SEQ_ME_ITEM
	BufferPlayersName 6
	NPCMsg msg_0340_R09_EventMons_Text_CapFound
	WaitFanfare
	BufferPlayersName 6
	NPCMsg msg_0340_R09_EventMons_Text_CapInCase
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_RecruitAfterBattle:
	Call GymCandidate_EventScript_RecruitOffer
	ReleaseAll
	End
	
GymCandidate_EventScript_Return:
	Return
	
GymCandidate_EventScript_RecruitDeclined:
	NPCMsg msg_0340_R09_GymCandidate_Text_RecruitDeclined
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventMons_EventScript_CapNoCase:
	NPCMsg msg_0340_R09_EventMons_Text_CapNoCase
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventMons_EventScript_ReleaseAllEnd:
	ReleaseAll
	End

_cv_str4:
	BufferPlayersName 6
	BufferRivalsName 7
	Return

_cv_stop:
	NPCMsg msg_0340_R09_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
