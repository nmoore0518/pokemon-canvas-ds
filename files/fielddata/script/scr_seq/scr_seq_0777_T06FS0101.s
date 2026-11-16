#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T06FS0101.h"
#include "msgdata/msg/msg_0484_T06FS0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's VermilionCity_Mart_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef VermilionCity_Mart_EventScript_Clerk
	ScrDef VermilionCity_Mart_EventScript_CooltrainerF
	ScrDef VermilionCity_Mart_EventScript_BaldingMan
	ScrDefEnd
	
VermilionCity_Mart_EventScript_Clerk:
	LockAll
	FacePlayer
	NPCMsg msg_0484_T06FS0101_gText_HowMayIServeYou
	CanvasMart 7
	.short ITEM_POKE_BALL
	.short ITEM_SUPER_POTION
	.short ITEM_ANTIDOTE
	.short ITEM_PARLYZ_HEAL
	.short ITEM_AWAKENING
	.short ITEM_ICE_HEAL
	.short ITEM_REPEL
	NPCMsg msg_0484_T06FS0101_gText_PleaseComeAgain
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_Mart_EventScript_CooltrainerF:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0484_T06FS0101_VermilionCity_Mart_Text_MonsGoodOrBadDependingOnTrainer
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_Mart_EventScript_BaldingMan:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0484_T06FS0101_VermilionCity_Mart_Text_TeamRocketAreWickedPeople
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0484_T06FS0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
