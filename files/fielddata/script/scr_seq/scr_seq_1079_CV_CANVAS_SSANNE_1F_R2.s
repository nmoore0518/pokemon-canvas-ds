#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SSANNE_1F_R2.h"
#include "msgdata/msg/msg_0911_CV_CANVAS_SSANNE_1F_R2.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SSAnne_1F_Room2_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SSAnne_1F_Room2_EventScript_Woman
	ScrDef SSAnne_1F_Room2_EventScript_ItemTM31
	ScrDefEnd
	
SSAnne_1F_Room2_EventScript_Woman:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0911_CV_CANVAS_SSANNE_1F_R2_SSAnne_1F_Room2_Text_CruisingAroundWorld
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SSAnne_1F_Room2_EventScript_ItemTM31:
	SetVar 0x8004, ITEM_TM31
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End

_cv_stop:
	NPCMsg msg_0911_CV_CANVAS_SSANNE_1F_R2_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
