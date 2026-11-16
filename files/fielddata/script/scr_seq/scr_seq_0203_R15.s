#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R15.h"
#include "msgdata/msg/msg_0352_R15.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route15_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route15_EventScript_ItemTM18
	ScrDef Route15_EventScript_RouteSign
	ScrDefEnd
	
Route15_EventScript_ItemTM18:
	SetVar 0x8004, ITEM_TM18
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
Route15_EventScript_RouteSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0352_R15_Route15_Text_RouteSign
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0352_R15_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
