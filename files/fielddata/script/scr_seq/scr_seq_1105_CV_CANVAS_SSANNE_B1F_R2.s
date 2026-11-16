#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SSANNE_B1F_R2.h"
#include "msgdata/msg/msg_0924_CV_CANVAS_SSANNE_B1F_R2.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SSAnne_B1F_Room2_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SSAnne_B1F_Room2_EventScript_ItemTM44
	ScrDefEnd
	
SSAnne_B1F_Room2_EventScript_ItemTM44:
	SetVar 0x8004, ITEM_TM44
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End

_cv_stop:
	NPCMsg msg_0924_CV_CANVAS_SSANNE_B1F_R2_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
