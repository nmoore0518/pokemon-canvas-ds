#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T03FS0101.h"
#include "msgdata/msg/msg_0461_T03FS0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PewterCity_Mart_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef PewterCity_Mart_EventScript_Youngster
	ScrDef PewterCity_Mart_EventScript_Boy
	ScrDef PewterCity_Mart_EventScript_Clerk
	ScrDefEnd
	
PewterCity_Mart_EventScript_Youngster:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0461_T03FS0101_PewterCity_Mart_Text_BoughtWeirdFishFromShadyGuy
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_Mart_EventScript_Boy:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0461_T03FS0101_PewterCity_Mart_Text_GoodThingsIfRaiseMonsDiligently
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_Mart_EventScript_Clerk:
	LockAll
	FacePlayer
	NPCMsg msg_0461_T03FS0101_gText_HowMayIServeYou
	CanvasMart 8
	.short ITEM_POKE_BALL
	.short ITEM_POTION
	.short ITEM_ANTIDOTE
	.short ITEM_PARLYZ_HEAL
	.short ITEM_AWAKENING
	.short ITEM_BURN_HEAL
	.short ITEM_ESCAPE_ROPE
	.short ITEM_REPEL
	NPCMsg msg_0461_T03FS0101_gText_PleaseComeAgain
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0461_T03FS0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
