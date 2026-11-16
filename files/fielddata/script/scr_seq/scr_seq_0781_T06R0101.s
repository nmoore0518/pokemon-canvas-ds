#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T06R0101.h"
#include "msgdata/msg/msg_0487_T06R0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's VermilionCity_House1_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef VermilionCity_House1_EventScript_FishingGuru
	ScrDef TrainingHouse_EventScript_Vivian
	ScrDefEnd
	
VermilionCity_House1_EventScript_FishingGuru:
	LockAll
	FacePlayer
	GoToIfSet 0x2123, VermilionCity_House1_EventScript_AlreadyGotOldRod
	NPCMsg msg_0487_T06R0101_VermilionCity_House1_Text_ImFishingGuruDoYouLikeToFish
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq VermilionCity_House1_EventScript_GiveOldRod
	NPCMsg msg_0487_T06R0101_VermilionCity_House1_Text_OhThatsSoDisappointing
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TrainingHouse_EventScript_Vivian:
	LockAll
	FacePlayer
	NPCMsg msg_0487_T06R0101_TrainingHouse_Text_VivianIntro
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_3
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_4
_cv_yes_3:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TrainingHouse_EventScript_Declined
	ClearTrainerFlag 1449
	CheckTrainerFlag 1449
	GoToIf TRUE, _cv_beaten_5
	TrainerBattle 1449, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_6
	WhiteOut
	End
_cv_won_6:
	SetTrainerFlag 1449
	ReleaseAll
	End
_cv_beaten_5:
	NPCMsg msg_0487_T06R0101_TrainingHouse_Text_After
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_House1_EventScript_AlreadyGotOldRod:
	BufferPlayersName 6
	NPCMsg msg_0487_T06R0101_VermilionCity_House1_Text_HowAreTheFishBiting
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_House1_EventScript_GiveOldRod:
	HasSpaceForItem ITEM_OLD_ROD, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq VermilionCity_House1_EventScript_NoRoomForOldRod
	GiveItem ITEM_OLD_ROD, 1, VAR_SPECIAL_RESULT
	NPCMsg msg_0487_T06R0101_VermilionCity_House1_Text_TakeThisAndFish
	WaitButton
	PlayFanfare SEQ_ME_ITEM
	BufferPlayersName 6
	NPCMsg msg_0487_T06R0101_VermilionCity_House1_Text_ReceivedOldRodFromFishingGuru
	WaitFanfare
	WaitButton
	SetFlag 0x2123
	NPCMsg msg_0487_T06R0101_VermilionCity_House1_Text_FishingIsAWayOfLife
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TrainingHouse_EventScript_Declined:
	NPCMsg msg_0487_T06R0101_TrainingHouse_Text_Declined
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_House1_EventScript_NoRoomForOldRod:
	NPCMsg msg_0487_T06R0101_VermilionCity_House1_Text_NoRoomForNiceGift
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0487_T06R0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
