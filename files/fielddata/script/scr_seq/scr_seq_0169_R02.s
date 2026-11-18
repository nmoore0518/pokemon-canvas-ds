#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R02.h"
#include "msgdata/msg/msg_0320_R02.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route2_Frlg#world by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route2_EventScript_ItemEther
	ScrDef Route2_EventScript_DiglettsCaveSign
	ScrDefEnd
	
Route2_EventScript_ItemEther:
	SetVar 0x8004, ITEM_ETHER
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
Route2_EventScript_DiglettsCaveSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0320_R02_Route2_Text_DiglettsCave
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0320_R02_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
