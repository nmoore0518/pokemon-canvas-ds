#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SSANNE_DECK.h"
#include "msgdata/msg/msg_0907_CV_CANVAS_SSANNE_DECK.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SSAnne_Deck_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SSAnne_Deck_EventScript_BaldingMan
	ScrDef SSAnne_Deck_EventScript_Sailor
	ScrDef SSAnne_Deck_EventScript_Youngster
	ScrDefEnd
	
SSAnne_Deck_EventScript_BaldingMan:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0907_CV_CANVAS_SSANNE_DECK_SSAnne_Deck_Text_FeelSeasick
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SSAnne_Deck_EventScript_Sailor:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0907_CV_CANVAS_SSANNE_DECK_SSAnne_Deck_Text_ScrubbingDecksHardWork
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SSAnne_Deck_EventScript_Youngster:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0907_CV_CANVAS_SSANNE_DECK_SSAnne_Deck_Text_ShipDepartingSoon
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0907_CV_CANVAS_SSANNE_DECK_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
