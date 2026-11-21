#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SSANNE_1F_R6.h"
#include "msgdata/msg/msg_0915_CV_CANVAS_SSANNE_1F_R6.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SSAnne_1F_Room6_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SSAnne_1F_Room6_EventScript_Woman
	ScrDefEnd
	
SSAnne_1F_Room6_EventScript_Woman:
	LockAll
	FacePlayer
	NPCMsg msg_0915_CV_CANVAS_SSANNE_1F_R6_SSAnne_1F_Room6_Text_TakeAShortRest
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq SSAnne_1F_Room6_EventScript_DeclineHeal
	CanvasCloseMsg
	Call Common_EventScript_OutOfCenterPartyHeal
	NPCMsg msg_0915_CV_CANVAS_SSANNE_1F_R6_SSAnne_1F_Room6_Text_GladEveryoneIsRefreshed
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SSAnne_1F_Room6_EventScript_DeclineHeal:
	GetPlayerGender VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq SSAnne_1F_Room6_EventScript_DeclineHealMale
	NPCMsg msg_0915_CV_CANVAS_SSANNE_1F_R6_SSAnne_1F_Room6_Text_SorryYouLookLikeMySister
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Common_EventScript_OutOfCenterPartyHeal:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	PlayFanfare SEQ_ME_ASA
	WaitFanfare
	HealParty
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	Return
	
SSAnne_1F_Room6_EventScript_DeclineHealMale:
	NPCMsg msg_0915_CV_CANVAS_SSANNE_1F_R6_SSAnne_1F_Room6_Text_SorryYouLookLikeMyBrother
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0915_CV_CANVAS_SSANNE_1F_R6_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
