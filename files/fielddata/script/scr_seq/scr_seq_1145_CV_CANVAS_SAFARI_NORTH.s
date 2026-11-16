#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SAFARI_NORTH.h"
#include "msgdata/msg/msg_0944_CV_CANVAS_SAFARI_NORTH.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SafariZone_North_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SafariZone_North_EventScript_ItemProtein
	ScrDef SafariZone_North_EventScript_ItemTM47
	ScrDef SafariZone_North_EventScript_ItemQuickClaw
	ScrDef SafariZone_North_EventScript_TrainerTips1
	ScrDef SafariZone_North_EventScript_AreaSign
	ScrDef SafariZone_North_EventScript_TrainerTips2
	ScrDef SafariZone_North_EventScript_TrainerTips3
	ScrDef SafariZone_North_EventScript_RestHouseSign
	ScrDefEnd
	
SafariZone_North_EventScript_ItemProtein:
	SetVar 0x8004, ITEM_PROTEIN
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
SafariZone_North_EventScript_ItemTM47:
	SetVar 0x8004, ITEM_TM47
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
SafariZone_North_EventScript_ItemQuickClaw:
	SetVar 0x8004, ITEM_QUICK_CLAW
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
SafariZone_North_EventScript_TrainerTips1:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0944_CV_CANVAS_SAFARI_NORTH_SafariZone_North_Text_SecretHouseStillAhead
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SafariZone_North_EventScript_AreaSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0944_CV_CANVAS_SAFARI_NORTH_SafariZone_North_Text_Area2
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SafariZone_North_EventScript_TrainerTips2:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0944_CV_CANVAS_SAFARI_NORTH_SafariZone_North_Text_ZigzagThroughTallGrass
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SafariZone_North_EventScript_TrainerTips3:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0944_CV_CANVAS_SAFARI_NORTH_SafariZone_North_Text_WinFreeHMFindSecretHouse
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SafariZone_North_EventScript_RestHouseSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0944_CV_CANVAS_SAFARI_NORTH_SafariZone_North_Text_RestHouse
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0944_CV_CANVAS_SAFARI_NORTH_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
