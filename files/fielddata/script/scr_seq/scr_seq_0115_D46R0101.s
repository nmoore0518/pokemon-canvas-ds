#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_D46R0101.h"
#include "msgdata/msg/msg_0132_D46R0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's ViridianForest_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef ViridianForest_EventScript_Youngster
	ScrDef ViridianForest_EventScript_Boy
	ScrDef ViridianForest_EventScript_Rick
	ScrDef ViridianForest_EventScript_ItemPokeBall
	ScrDef ViridianForest_EventScript_ItemAntidote
	ScrDef ViridianForest_EventScript_ItemPotion
	ScrDef ViridianForest_EventScript_ItemPotion2
	ScrDef ViridianForest_EventScript_ItemShockDrive
	ScrDef BerryField_EventScript_FindBug
	ScrDef ViridianForest_EventScript_TrainerTips1
	ScrDef ViridianForest_EventScript_TrainerTips3
	ScrDef ViridianForest_EventScript_TrainerTips4
	ScrDef ViridianForest_EventScript_ExitSign
	ScrDef ViridianForest_EventScript_TrainerTips2
	ScrDef ViridianForest_EventScript_TrainerTips5
	ScrDef EventMons_EventScript_Cap0
	ScrDef ViridianForest_OnTransition
	ScrDefEnd
	
ViridianForest_EventScript_Youngster:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0132_D46R0101_ViridianForest_Text_FriendsItchingToBattle
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianForest_EventScript_Boy:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0132_D46R0101_ViridianForest_Text_RanOutOfPokeBalls
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianForest_EventScript_Rick:
	CheckTrainerFlag 859
	GoToIf TRUE, _cv_beaten_1
	NPCMsg msg_0132_D46R0101_ViridianForest_Text_RickIntro
	WaitButton
	CloseMsg
	TrainerBattle 859, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_2
	WhiteOut
	End
_cv_won_2:
	SetTrainerFlag 859
	GoTo GymCandidate_EventScript_RecruitBug
_cv_beaten_1:
	SetVar 0x8004, 7
	Call GymCandidate_EventScript_RecruitOffer
	NPCMsg msg_0132_D46R0101_ViridianForest_Text_RickPostBattle
	WaitButton
	CloseMsg
	End
	
ViridianForest_EventScript_ItemPokeBall:
	SetVar 0x8004, ITEM_POKE_BALL
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
ViridianForest_EventScript_ItemAntidote:
	SetVar 0x8004, ITEM_ANTIDOTE
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
ViridianForest_EventScript_ItemPotion:
	SetVar 0x8004, ITEM_POTION
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
ViridianForest_EventScript_ItemPotion2:
	SetVar 0x8004, ITEM_POTION
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
ViridianForest_EventScript_ItemShockDrive:
	SetVar 0x8004, 117
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
BerryField_EventScript_FindBug:
	SetVar 0x8004, ITEM_TANGA_BERRY
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
ViridianForest_EventScript_TrainerTips1:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0132_D46R0101_ViridianForest_Text_AvoidGrassyAreasWhenWeak
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianForest_EventScript_TrainerTips3:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0132_D46R0101_ViridianForest_Text_ContactOakViaPCToRatePokedex
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianForest_EventScript_TrainerTips4:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0132_D46R0101_ViridianForest_Text_CantCatchOwnedMons
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianForest_EventScript_ExitSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0132_D46R0101_ViridianForest_Text_LeavingViridianForest
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianForest_EventScript_TrainerTips2:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0132_D46R0101_ViridianForest_Text_UseAntidoteForPoison
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianForest_EventScript_TrainerTips5:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0132_D46R0101_ViridianForest_Text_WeakenMonsBeforeCapture
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventMons_EventScript_Cap0:
	SetVar 0x8004, 0
	GoTo EventMons_EventScript_Cap
	
ViridianForest_OnTransition:
	End
	
GymCandidate_EventScript_RecruitBug:
	SetVar 0x8004, 7
	GoTo GymCandidate_EventScript_RecruitAfterBattle
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
	NPCMsg msg_0132_D46R0101_GymCandidate_Text_RecruitJoined
	WaitButton
	WaitFanfare
	NPCMsg msg_0132_D46R0101_GymCandidate_Text_RecruitHowToPlace
	WaitButton
	CloseMsg
	ReleaseAll
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
	NPCMsg msg_0132_D46R0101_EventMons_Text_CapFound
	WaitFanfare
	BufferPlayersName 6
	NPCMsg msg_0132_D46R0101_EventMons_Text_CapInCase
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
	NPCMsg msg_0132_D46R0101_GymCandidate_Text_RecruitDeclined
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventMons_EventScript_CapNoCase:
	NPCMsg msg_0132_D46R0101_EventMons_Text_CapNoCase
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
	NPCMsg msg_0132_D46R0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
