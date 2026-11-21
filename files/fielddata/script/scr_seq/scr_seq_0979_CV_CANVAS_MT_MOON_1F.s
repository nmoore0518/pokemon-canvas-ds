#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_MT_MOON_1F.h"
#include "msgdata/msg/msg_0861_CV_CANVAS_MT_MOON_1F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's MtMoon_1F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef MtMoon_1F_EventScript_Marcos
	ScrDef MtMoon_1F_EventScript_ItemParalyzeHeal
	ScrDef MtMoon_1F_EventScript_ItemTM09
	ScrDef MtMoon_1F_EventScript_ItemPotion
	ScrDef MtMoon_1F_EventScript_ItemRareCandy
	ScrDef MtMoon_1F_EventScript_ItemEscapeRope
	ScrDef MtMoon_1F_EventScript_ItemMoonStone
	ScrDef MtMoon_1F_EventScript_BaldingMan
	ScrDef BerryField_EventScript_FindRock
	ScrDef MtMoon_1F_EventScript_ZubatSign
	ScrDef MtMoon_1F_OnTransition
	ScrDefEnd
	
MtMoon_1F_EventScript_Marcos:
	CheckTrainerFlag 932
	GoToIf TRUE, _cv_beaten_1
	NPCMsg msg_0861_CV_CANVAS_MT_MOON_1F_MtMoon_1F_Text_MarcosIntro
	WaitButton
	CloseMsg
	TrainerBattle 932, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_2
	WhiteOut
	End
_cv_won_2:
	SetTrainerFlag 932
	GoTo GymCandidate_EventScript_RecruitRock
_cv_beaten_1:
	SetVar 0x8004, 6
	Call GymCandidate_EventScript_RecruitOffer
	NPCMsg msg_0861_CV_CANVAS_MT_MOON_1F_MtMoon_1F_Text_MarcosPostBattle
	WaitButton
	CloseMsg
	End
	
MtMoon_1F_EventScript_ItemParalyzeHeal:
	SetVar 0x8004, ITEM_PARLYZ_HEAL
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
MtMoon_1F_EventScript_ItemTM09:
	SetVar 0x8004, ITEM_TM09
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
MtMoon_1F_EventScript_ItemPotion:
	SetVar 0x8004, ITEM_POTION
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
MtMoon_1F_EventScript_ItemRareCandy:
	SetVar 0x8004, ITEM_RARE_CANDY
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
MtMoon_1F_EventScript_ItemEscapeRope:
	SetVar 0x8004, ITEM_ESCAPE_ROPE
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
MtMoon_1F_EventScript_ItemMoonStone:
	SetVar 0x8004, ITEM_MOON_STONE
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
MtMoon_1F_EventScript_BaldingMan:
	LockAll
	FacePlayer
	NPCMsg msg_0861_CV_CANVAS_MT_MOON_1F_MtMoon_1F_Text_BrockHelpsExcavateFossils
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
BerryField_EventScript_FindRock:
	SetVar 0x8004, ITEM_CHARTI_BERRY
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
MtMoon_1F_EventScript_ZubatSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0861_CV_CANVAS_MT_MOON_1F_MtMoon_1F_Text_ZubatIsABloodsucker
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
MtMoon_1F_OnTransition:
	End
	
GymCandidate_EventScript_RecruitRock:
	SetVar 0x8004, 6
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
	NPCMsg msg_0861_CV_CANVAS_MT_MOON_1F_GymCandidate_Text_RecruitJoined
	WaitButton
	WaitFanfare
	NPCMsg msg_0861_CV_CANVAS_MT_MOON_1F_GymCandidate_Text_RecruitHowToPlace
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_RecruitAfterBattle:
	Call GymCandidate_EventScript_RecruitOffer
	CanvasCloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_Return:
	Return
	
GymCandidate_EventScript_RecruitDeclined:
	NPCMsg msg_0861_CV_CANVAS_MT_MOON_1F_GymCandidate_Text_RecruitDeclined
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_str4:
	BufferPlayersName 6
	BufferRivalsName 7
	Return

_cv_stop:
	NPCMsg msg_0861_CV_CANVAS_MT_MOON_1F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
