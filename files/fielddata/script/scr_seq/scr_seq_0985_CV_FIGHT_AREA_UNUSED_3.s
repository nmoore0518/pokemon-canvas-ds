#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_FIGHT_AREA_UNUSED_3.h"
#include "msgdata/msg/msg_0864_CV_FIGHT_AREA_UNUSED_3.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PalletTown_Mart_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef PalletTown_Mart_EventScript_Youngster
	ScrDef PalletTown_Mart_EventScript_Boy
	ScrDef PalletTown_Mart_EventScript_Clerk
	ScrDefEnd
	
PalletTown_Mart_EventScript_Youngster:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0864_CV_FIGHT_AREA_UNUSED_3_PalletTown_Mart_Text_BoughtWeirdFishFromShadyGuy
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_Mart_EventScript_Boy:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0864_CV_FIGHT_AREA_UNUSED_3_PalletTown_Mart_Text_GoodThingsIfRaiseMonsDiligently
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_Mart_EventScript_Clerk:
	GoTo GymHack_EventScript_PalletMartClerk
	End
	
GymHack_EventScript_PalletMartClerk:
	LockAll
	FacePlayer
	NPCMsg msg_0864_CV_FIGHT_AREA_UNUSED_3_gText_HowMayIServeYou
	GoToIfSet FLAG_GAME_CLEAR, _cv_mart_5
	GoToIfSet 0x2090, _cv_mart_4
	GoToIfSet 0x208F, _cv_mart_3
	GoToIfSet 0x208D, _cv_mart_2
	CanvasMart 8
	.short ITEM_POKE_BALL
	.short ITEM_POTION
	.short ITEM_ANTIDOTE
	.short ITEM_PARLYZ_HEAL
	.short ITEM_AWAKENING
	.short ITEM_BURN_HEAL
	.short ITEM_ICE_HEAL
	.short ITEM_REPEL
	GoTo _cv_mart_1
_cv_mart_2:
	CanvasMart 9
	.short ITEM_POKE_BALL
	.short ITEM_POTION
	.short ITEM_ANTIDOTE
	.short ITEM_PARLYZ_HEAL
	.short ITEM_AWAKENING
	.short ITEM_BURN_HEAL
	.short ITEM_ICE_HEAL
	.short ITEM_REPEL
	.short 795
	GoTo _cv_mart_1
_cv_mart_3:
	CanvasMart 11
	.short ITEM_POKE_BALL
	.short ITEM_POTION
	.short ITEM_ANTIDOTE
	.short ITEM_PARLYZ_HEAL
	.short ITEM_AWAKENING
	.short ITEM_BURN_HEAL
	.short ITEM_ICE_HEAL
	.short ITEM_REPEL
	.short 795
	.short 645
	.short 1606
	GoTo _cv_mart_1
_cv_mart_4:
	CanvasMart 11
	.short ITEM_POKE_BALL
	.short ITEM_POTION
	.short ITEM_ANTIDOTE
	.short ITEM_PARLYZ_HEAL
	.short ITEM_AWAKENING
	.short ITEM_BURN_HEAL
	.short ITEM_ICE_HEAL
	.short ITEM_REPEL
	.short 795
	.short 645
	.short 1606
	GoTo _cv_mart_1
_cv_mart_5:
	CanvasMart 12
	.short ITEM_POKE_BALL
	.short ITEM_POTION
	.short ITEM_ANTIDOTE
	.short ITEM_PARLYZ_HEAL
	.short ITEM_AWAKENING
	.short ITEM_BURN_HEAL
	.short ITEM_ICE_HEAL
	.short ITEM_REPEL
	.short 795
	.short 645
	.short 1606
	.short 796
	GoTo _cv_mart_1
_cv_mart_1:
	NPCMsg msg_0864_CV_FIGHT_AREA_UNUSED_3_gText_PleaseComeAgain
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0864_CV_FIGHT_AREA_UNUSED_3_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
