#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SEAFOAM_B2F.h"
#include "msgdata/msg/msg_0882_CV_CANVAS_SEAFOAM_B2F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SeafoamIslands_B2F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SeafoamIslands_B2F_EventScript_ItemBigPearl
	ScrDefEnd
	
SeafoamIslands_B2F_EventScript_ItemBigPearl:
	SetVar 0x8004, ITEM_BIG_PEARL
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End

_cv_stop:
	NPCMsg msg_0882_CV_CANVAS_SEAFOAM_B2F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
