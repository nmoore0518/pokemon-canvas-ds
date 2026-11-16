#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T07R0104.h"
#include "msgdata/msg/msg_0497_T07R0104.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's CeladonCity_DepartmentStore_4F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef CeladonCity_DepartmentStore_4F_EventScript_Man
	ScrDef CeladonCity_DepartmentStore_4F_EventScript_Youngster
	ScrDef CeladonCity_DepartmentStore_4F_EventScript_Clerk
	ScrDef CeladonCity_DepartmentStore_4F_EventScript_FloorSign
	ScrDefEnd
	
CeladonCity_DepartmentStore_4F_EventScript_Man:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0497_T07R0104_CeladonCity_DepartmentStore_4F_Text_GettingPokeDollAsPresent
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_DepartmentStore_4F_EventScript_Youngster:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0497_T07R0104_CeladonCity_DepartmentStore_4F_Text_CanRunAwayWithPokeDoll
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_DepartmentStore_4F_EventScript_Clerk:
	LockAll
	FacePlayer
	NPCMsg msg_0497_T07R0104_gText_HowMayIServeYou
	CanvasMart 15
	.short ITEM_POKE_DOLL
	.short ITEM_FIRE_STONE
	.short ITEM_THUNDERSTONE
	.short ITEM_WATER_STONE
	.short ITEM_LEAF_STONE
	.short ITEM_MOON_STONE
	.short ITEM_SUN_STONE
	.short ITEM_KINGS_ROCK
	.short ITEM_METAL_COAT
	.short ITEM_DRAGON_SCALE
	.short ITEM_UPGRADE
	.short ITEM_DEEPSEATOOTH
	.short ITEM_DEEPSEASCALE
	.short 537
	.short 1611
	NPCMsg msg_0497_T07R0104_gText_PleaseComeAgain
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_DepartmentStore_4F_EventScript_FloorSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0497_T07R0104_CeladonCity_DepartmentStore_4F_Text_FloorSign
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0497_T07R0104_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
