#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T05FS0101.h"
#include "msgdata/msg/msg_0476_T05FS0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's LavenderTown_Mart_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef LavenderTown_Mart_EventScript_Clerk
	ScrDef LavenderTown_Mart_EventScript_BaldingMan
	ScrDef LavenderTown_Mart_EventScript_Rocker
	ScrDef LavenderTown_Mart_EventScript_Youngster
	ScrDefEnd
	
LavenderTown_Mart_EventScript_Clerk:
	LockAll
	FacePlayer
	NPCMsg msg_0476_T05FS0101_gText_HowMayIServeYou
	CanvasMart 9
	.short ITEM_GREAT_BALL
	.short ITEM_SUPER_POTION
	.short ITEM_REVIVE
	.short ITEM_ANTIDOTE
	.short ITEM_PARLYZ_HEAL
	.short ITEM_BURN_HEAL
	.short ITEM_ICE_HEAL
	.short ITEM_ESCAPE_ROPE
	.short ITEM_SUPER_REPEL
	NPCMsg msg_0476_T05FS0101_gText_PleaseComeAgain
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
LavenderTown_Mart_EventScript_BaldingMan:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0476_T05FS0101_LavenderTown_Mart_Text_SearchingForStatRaiseItems
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
LavenderTown_Mart_EventScript_Rocker:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0476_T05FS0101_LavenderTown_Mart_Text_DidYouBuyRevives
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
LavenderTown_Mart_EventScript_Youngster:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0476_T05FS0101_LavenderTown_Mart_Text_TrainerDuosCanChallengeYou
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0476_T05FS0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
