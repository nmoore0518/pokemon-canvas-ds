#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SSANNE_CAPTAIN.h"
#include "msgdata/msg/msg_0909_CV_CANVAS_SSANNE_CAPTAIN.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SSAnne_CaptainsOffice_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SSAnne_CaptainsOffice_EventScript_Captain
	ScrDef SSAnne_CaptainsOffice_EventScript_Book
	ScrDef SSAnne_CaptainsOffice_EventScript_TrashCan
	ScrDefEnd
	
SSAnne_CaptainsOffice_EventScript_Captain:
	LockAll
	GoToIfSet 0x21D7, SSAnne_CaptainsOffice_EventScript_AlreadyGotCut
	NPCMsg msg_0909_CV_CANVAS_SSANNE_CAPTAIN_SSAnne_CaptainsOffice_Text_CaptainIFeelSeasick
	WaitButton
	BufferPlayersName 6
	NPCMsg msg_0909_CV_CANVAS_SSANNE_CAPTAIN_SSAnne_CaptainsOffice_Text_RubbedCaptainsBack
	PlayFanfare SEQ_ME_ASA
	WaitFanfare
	Call EventScript_RestorePrevTextColor
	Wait 50, VAR_SPECIAL_RESULT
	FacePlayer
	WaitMovement
	NPCMsg msg_0909_CV_CANVAS_SSANNE_CAPTAIN_SSAnne_CaptainsOffice_Text_ThankYouHaveHMForCut
	WaitButton
	GiveItem ITEM_HM01, 1, VAR_SPECIAL_RESULT
	BufferItemName 1, ITEM_HM01
	BufferPlayersName 6
	NPCMsg msg_0909_CV_CANVAS_SSANNE_CAPTAIN_SSAnne_CaptainsOffice_Text_ObtainedHM01FromCaptain
	PlayFanfare SEQ_ME_ITEM
	WaitFanfare
	WaitButton
	NPCMsg msg_0909_CV_CANVAS_SSANNE_CAPTAIN_Text_GymHack_AndTakeThisToo
	WaitButton
	SetFlag 0x21D8
	SetVar VAR_SPECIAL_RESULT, 1
	NPCMsg msg_0909_CV_CANVAS_SSANNE_CAPTAIN_SSAnne_CaptainsOffice_Text_ExplainCut
	WaitButton
	SetFlag 0x21D7
	SetVar 0x5027, 1
	CloseMsg
	ReleaseAll
	End
	
SSAnne_CaptainsOffice_EventScript_Book:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0909_CV_CANVAS_SSANNE_CAPTAIN_SSAnne_CaptainsOffice_Text_HowToConquerSeasickness
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SSAnne_CaptainsOffice_EventScript_TrashCan:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0909_CV_CANVAS_SSANNE_CAPTAIN_SSAnne_CaptainsOffice_Text_YuckShouldntHaveLooked
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SSAnne_CaptainsOffice_EventScript_AlreadyGotCut:
	FacePlayer
	WaitMovement
	NPCMsg msg_0909_CV_CANVAS_SSANNE_CAPTAIN_SSAnne_CaptainsOffice_Text_SSAnneWillSetSailSoon
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_RestorePrevTextColor:
	CopyVar 0x5015, 0x5016
	Return

_cv_stop:
	NPCMsg msg_0909_CV_CANVAS_SSANNE_CAPTAIN_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
