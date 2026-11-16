#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T08FS0101.h"
#include "msgdata/msg/msg_0513_T08FS0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's FuchsiaCity_Mart_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef FuchsiaCity_Mart_EventScript_Clerk
	ScrDef FuchsiaCity_Mart_EventScript_Gentleman
	ScrDef FuchsiaCity_Mart_EventScript_CooltrainerF
	ScrDefEnd
	
FuchsiaCity_Mart_EventScript_Clerk:
	LockAll
	FacePlayer
	NPCMsg msg_0513_T08FS0101_gText_HowMayIServeYou
	CanvasMart 6
	.short ITEM_ULTRA_BALL
	.short ITEM_GREAT_BALL
	.short ITEM_SUPER_POTION
	.short ITEM_REVIVE
	.short ITEM_FULL_HEAL
	.short ITEM_MAX_REPEL
	NPCMsg msg_0513_T08FS0101_gText_PleaseComeAgain
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_Mart_EventScript_Gentleman:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0513_T08FS0101_FuchsiaCity_Mart_Text_DontTheyHaveSafariZonePennants
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_Mart_EventScript_CooltrainerF:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0513_T08FS0101_FuchsiaCity_Mart_Text_DidYouTryXSpeed
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0513_T08FS0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
