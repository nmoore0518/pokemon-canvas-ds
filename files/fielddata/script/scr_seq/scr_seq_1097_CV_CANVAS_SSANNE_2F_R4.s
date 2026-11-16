#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SSANNE_2F_R4.h"
#include "msgdata/msg/msg_0920_CV_CANVAS_SSANNE_2F_R4.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SSAnne_2F_Room4_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SSAnne_2F_Room4_EventScript_ItemXAttack
	ScrDefEnd
	
SSAnne_2F_Room4_EventScript_ItemXAttack:
	SetVar 0x8004, ITEM_X_ATTACK
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End

_cv_stop:
	NPCMsg msg_0920_CV_CANVAS_SSANNE_2F_R4_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
