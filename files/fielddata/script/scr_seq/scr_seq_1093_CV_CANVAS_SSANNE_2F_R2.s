#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SSANNE_2F_R2.h"
#include "msgdata/msg/msg_0918_CV_CANVAS_SSANNE_2F_R2.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SSAnne_2F_Room2_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SSAnne_2F_Room2_EventScript_ItemStardust
	ScrDefEnd
	
SSAnne_2F_Room2_EventScript_ItemStardust:
	SetVar 0x8004, ITEM_STARDUST
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End

_cv_stop:
	NPCMsg msg_0918_CV_CANVAS_SSANNE_2F_R2_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
