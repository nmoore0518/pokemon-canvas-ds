#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SSANNE_1F_R7.h"
#include "msgdata/msg/msg_0916_CV_CANVAS_SSANNE_1F_R7.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SSAnne_1F_Room7_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SSAnne_1F_Room7_EventScript_Thomas
	ScrDefEnd
	
SSAnne_1F_Room7_EventScript_Thomas:
	CheckTrainerFlag 1157
	GoToIf TRUE, _cv_beaten_1
	NPCMsg msg_0916_CV_CANVAS_SSANNE_1F_R7_SSAnne_1F_Room7_Text_ThomasIntro
	WaitButton
	CloseMsg
	TrainerBattle 1157, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_2
	WhiteOut
	End
_cv_won_2:
	SetTrainerFlag 1157
	GoTo GymCandidate_EventScript_RecruitFire
_cv_beaten_1:
	SetVar 0x8004, 11
	Call GymCandidate_EventScript_RecruitOffer
	NPCMsg msg_0916_CV_CANVAS_SSANNE_1F_R7_SSAnne_1F_Room7_Text_ThomasPostBattle
	WaitButton
	CloseMsg
	End
	
GymCandidate_EventScript_RecruitFire:
	SetVar 0x8004, 11
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
	NPCMsg msg_0916_CV_CANVAS_SSANNE_1F_R7_GymCandidate_Text_RecruitJoined
	WaitButton
	WaitFanfare
	NPCMsg msg_0916_CV_CANVAS_SSANNE_1F_R7_GymCandidate_Text_RecruitHowToPlace
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
	NPCMsg msg_0916_CV_CANVAS_SSANNE_1F_R7_GymCandidate_Text_RecruitDeclined
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_str4:
	BufferPlayersName 6
	BufferRivalsName 7
	Return

_cv_stop:
	NPCMsg msg_0916_CV_CANVAS_SSANNE_1F_R7_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
