#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SSANNE_B1F_R3.h"
#include "msgdata/msg/msg_0925_CV_CANVAS_SSANNE_B1F_R3.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SSAnne_B1F_Room3_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SSAnne_B1F_Room3_EventScript_ItemEther
	ScrDefEnd
	
SSAnne_B1F_Room3_EventScript_ItemEther:
	SetVar 0x8004, ITEM_ETHER
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End

_cv_stop:
	NPCMsg msg_0925_CV_CANVAS_SSANNE_B1F_R3_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
