#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T11FS0101.h"
#include "msgdata/msg/msg_0530_T11FS0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SaffronCity_Mart_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SaffronCity_Mart_EventScript_Clerk
	ScrDef SaffronCity_Mart_EventScript_Youngster
	ScrDef SaffronCity_Mart_EventScript_Lass
	ScrDefEnd
	
SaffronCity_Mart_EventScript_Clerk:
	LockAll
	FacePlayer
	NPCMsg msg_0530_T11FS0101_gText_HowMayIServeYou
	CanvasMart 6
	.short ITEM_GREAT_BALL
	.short ITEM_HYPER_POTION
	.short ITEM_REVIVE
	.short ITEM_FULL_HEAL
	.short ITEM_ESCAPE_ROPE
	.short ITEM_MAX_REPEL
	NPCMsg msg_0530_T11FS0101_gText_PleaseComeAgain
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_Mart_EventScript_Youngster:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0530_T11FS0101_SaffronCity_Mart_Text_MaxRepelMoreEffectiveThanSuper
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_Mart_EventScript_Lass:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0530_T11FS0101_SaffronCity_Mart_Text_ReviveIsCostly
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0530_T11FS0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
