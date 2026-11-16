#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SAFARI_EAST.h"
#include "msgdata/msg/msg_0943_CV_CANVAS_SAFARI_EAST.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SafariZone_East_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SafariZone_East_EventScript_ItemMaxPotion
	ScrDef SafariZone_East_EventScript_ItemFullRestore
	ScrDef SafariZone_East_EventScript_ItemTM11
	ScrDef SafariZone_East_EventScript_ItemLeafStone
	ScrDef SafariZone_East_EventScript_ItemBurnDrive
	ScrDef SafariZone_East_EventScript_AreaSign
	ScrDef SafariZone_East_EventScript_RestHouseSign
	ScrDef SafariZone_East_EventScript_TrainerTips
	ScrDefEnd
	
SafariZone_East_EventScript_ItemMaxPotion:
	SetVar 0x8004, ITEM_MAX_POTION
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
SafariZone_East_EventScript_ItemFullRestore:
	SetVar 0x8004, ITEM_FULL_RESTORE
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
SafariZone_East_EventScript_ItemTM11:
	SetVar 0x8004, ITEM_TM11
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
SafariZone_East_EventScript_ItemLeafStone:
	SetVar 0x8004, ITEM_LEAF_STONE
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
SafariZone_East_EventScript_ItemBurnDrive:
	SetVar 0x8004, 118
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
SafariZone_East_EventScript_AreaSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0943_CV_CANVAS_SAFARI_EAST_SafariZone_East_Text_AreaSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SafariZone_East_EventScript_RestHouseSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0943_CV_CANVAS_SAFARI_EAST_SafariZone_East_Text_RestHouse
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SafariZone_East_EventScript_TrainerTips:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0943_CV_CANVAS_SAFARI_EAST_SafariZone_East_Text_TimeDeclinesOnlyWhileYouWalk
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0943_CV_CANVAS_SAFARI_EAST_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
