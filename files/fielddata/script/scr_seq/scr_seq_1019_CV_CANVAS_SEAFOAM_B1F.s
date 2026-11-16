#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SEAFOAM_B1F.h"
#include "msgdata/msg/msg_0881_CV_CANVAS_SEAFOAM_B1F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SeafoamIslands_B1F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SeafoamIslands_B1F_EventScript_ItemWaterStone
	ScrDef SeafoamIslands_B1F_EventScript_ItemRevive
	ScrDefEnd
	
SeafoamIslands_B1F_EventScript_ItemWaterStone:
	SetVar 0x8004, ITEM_WATER_STONE
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
SeafoamIslands_B1F_EventScript_ItemRevive:
	SetVar 0x8004, ITEM_REVIVE
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End

_cv_stop:
	NPCMsg msg_0881_CV_CANVAS_SEAFOAM_B1F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
