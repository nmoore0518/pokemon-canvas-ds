#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SAFARI_WEST.h"
#include "msgdata/msg/msg_0945_CV_CANVAS_SAFARI_WEST.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SafariZone_West_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SafariZone_West_EventScript_ItemGoldTeeth
	ScrDef SafariZone_West_EventScript_ItemTM32
	ScrDef SafariZone_West_EventScript_ItemMaxPotion
	ScrDef SafariZone_West_EventScript_ItemMaxRevive
	ScrDef SafariZone_West_EventScript_LostTeethNotice
	ScrDef SafariZone_West_EventScript_TrainerTips
	ScrDef SafariZone_West_EventScript_AreaSign
	ScrDef SafariZone_West_EventScript_RestHouseSign
	ScrDefEnd
	
SafariZone_West_EventScript_ItemGoldTeeth:
	SetVar 0x8004, 877
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
SafariZone_West_EventScript_ItemTM32:
	SetVar 0x8004, ITEM_TM32
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
SafariZone_West_EventScript_ItemMaxPotion:
	SetVar 0x8004, ITEM_MAX_POTION
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
SafariZone_West_EventScript_ItemMaxRevive:
	SetVar 0x8004, ITEM_MAX_REVIVE
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
SafariZone_West_EventScript_LostTeethNotice:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0945_CV_CANVAS_SAFARI_WEST_SafariZone_West_Text_PleaseFindWardensLostTeeth
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SafariZone_West_EventScript_TrainerTips:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0945_CV_CANVAS_SAFARI_WEST_SafariZone_West_Text_SearchForSecretHouse
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SafariZone_West_EventScript_AreaSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0945_CV_CANVAS_SAFARI_WEST_SafariZone_West_Text_AreaSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SafariZone_West_EventScript_RestHouseSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0945_CV_CANVAS_SAFARI_WEST_SafariZone_West_Text_RestHouse
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0945_CV_CANVAS_SAFARI_WEST_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
