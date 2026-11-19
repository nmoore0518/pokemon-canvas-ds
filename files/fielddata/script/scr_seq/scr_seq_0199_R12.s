#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R12.h"
#include "msgdata/msg/msg_0348_R12.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route12_Frlg#world by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route12_EventScript_Ned
	ScrDef Route12_EventScript_Snorlax
	ScrDef Route12_EventScript_Luca
	ScrDef Route12_EventScript_ItemTM48
	ScrDef Route12_EventScript_ItemIron
	ScrDef Route12_EventScript_FishingSign
	ScrDef Route12_OnResume
	ScrDefEnd
	
Route12_EventScript_Ned:
	CheckTrainerFlag 971
	GoToIf TRUE, _cv_beaten_1
	NPCMsg msg_0348_R12_Route12_Text_NedIntro
	WaitButton
	CloseMsg
	TrainerBattle 971, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_2
	WhiteOut
	End
_cv_won_2:
	SetTrainerFlag 971
	GoTo GymCandidate_EventScript_RecruitWater
_cv_beaten_1:
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Route12_EventScript_NedRematch
	SetVar 0x8004, 12
	Call GymCandidate_EventScript_RecruitOffer
	NPCMsg msg_0348_R12_Route12_Text_NedPostBattle
	WaitButton
	CloseMsg
	End
	
Route12_EventScript_Snorlax:
	LockAll
	FacePlayer
	GoToIfUnset 0x2107, Route12_EventScript_SnorlaxNoPokeFlute
	NPCMsg msg_0348_R12_Text_WantToUsePokeFlute
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_3
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_4
_cv_yes_3:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Route12_EventScript_DontUsePokeFlute
	Call EventScript_AwakenSnorlax
	WaitSE SEQ_SE_DP_SELECT
	PlayCry SPECIES_SNORLAX, 0
	Wait 40, VAR_SPECIAL_RESULT
	WaitCry
	SetFlag 0x2108
	SetFlag 0x2032
	SetFlag 0x2109
	CloseMsg
	WildBattle SPECIES_SNORLAX, 30, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_wild_5
	WhiteOut
	ReleaseAll
	End
_cv_wild_5:
	HidePerson VAR_SPECIAL_LAST_TALKED
	ClearFlag 0x2032
	GetStaticEncounterOutcome VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfNe _cv_outcome_6
	SetVar VAR_SPECIAL_RESULT, 7
	GoTo _cv_outcome_7
_cv_outcome_6:
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfNe _cv_outcome_7
	SetVar VAR_SPECIAL_RESULT, 4
_cv_outcome_7:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Route12_EventScript_FoughtSnorlax
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfEq Route12_EventScript_FoughtSnorlax
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfEq Route12_EventScript_FoughtSnorlax
	ReleaseAll
	End
	
Route12_EventScript_Luca:
	CheckTrainerFlag 1030
	GoToIf TRUE, _cv_beaten_8
	NPCMsg msg_0348_R12_Route12_Text_LucaIntro
	WaitButton
	CloseMsg
	TrainerBattle 1030, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_9
	WhiteOut
	End
_cv_won_9:
	SetTrainerFlag 1030
	GoTo GymCandidate_EventScript_RecruitElectric
_cv_beaten_8:
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Route12_EventScript_LucaRematch
	SetVar 0x8004, 14
	Call GymCandidate_EventScript_RecruitOffer
	NPCMsg msg_0348_R12_Route12_Text_LucaPostBattle
	WaitButton
	CloseMsg
	End
	
Route12_EventScript_ItemTM48:
	SetVar 0x8004, ITEM_TM48
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
Route12_EventScript_ItemIron:
	SetVar 0x8004, ITEM_IRON
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
Route12_EventScript_FishingSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0348_R12_Route12_Text_SportfishingArea
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route12_OnResume:
	CallIfSet 0x2032, Route12_EventScript_TryRemoveSnorlax
	End
	
GymCandidate_EventScript_RecruitWater:
	SetVar 0x8004, 12
	GoTo GymCandidate_EventScript_RecruitAfterBattle
	End
	
Route12_EventScript_NedRematch:
	// (rematches come later)
	ReleaseAll
	End
	NPCMsg msg_0348_R12_Route12_Text_NedPostBattle
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
	GoToIfEq _cv_yes_10
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_11
_cv_yes_10:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_11:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_RecruitDeclined
	// TODO(gba) special GymCandidate_Recruit
	GoTo _cv_stop
	PlayFanfare SEQ_ME_ITEM
	NPCMsg msg_0348_R12_GymCandidate_Text_RecruitJoined
	WaitButton
	WaitFanfare
	NPCMsg msg_0348_R12_GymCandidate_Text_RecruitHowToPlace
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route12_EventScript_SnorlaxNoPokeFlute:
	NPCMsg msg_0348_R12_Route12_Text_MonSprawledOutInSlumber
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route12_EventScript_DontUsePokeFlute:
	ReleaseAll
	End
	
EventScript_AwakenSnorlax:
	BufferPlayersName 6
	NPCMsg msg_0348_R12_Text_PlayedPokeFlute
	PlayFanfare SEQ_ME_ITEM
	WaitFanfare
	NPCMsg msg_0348_R12_Text_SnorlaxWokeUp
	WaitButton
	Return
	
Route12_EventScript_FoughtSnorlax:
	NPCMsg msg_0348_R12_Text_SnorlaxReturnedToMountains
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_RecruitElectric:
	SetVar 0x8004, 14
	GoTo GymCandidate_EventScript_RecruitAfterBattle
	End
	
Route12_EventScript_LucaRematch:
	// (rematches come later)
	ReleaseAll
	End
	NPCMsg msg_0348_R12_Route12_Text_LucaPostBattle
	WaitButton
	CloseMsg
	End
	
Route12_EventScript_TryRemoveSnorlax:
	HidePerson 0x401D
	Return
	
GymCandidate_EventScript_RecruitAfterBattle:
	Call GymCandidate_EventScript_RecruitOffer
	ReleaseAll
	End
	
GymCandidate_EventScript_Return:
	Return
	
GymCandidate_EventScript_RecruitDeclined:
	NPCMsg msg_0348_R12_GymCandidate_Text_RecruitDeclined
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_str4:
	BufferPlayersName 6
	BufferRivalsName 7
	Return

_cv_stop:
	NPCMsg msg_0348_R12_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
