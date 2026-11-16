#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_ROCKET_HIDEOUT_B3F.h"
#include "msgdata/msg/msg_0930_CV_CANVAS_ROCKET_HIDEOUT_B3F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's RocketHideout_B3F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef RocketHideout_B3F_EventScript_ItemRareCandy
	ScrDef RocketHideout_B3F_EventScript_ItemTM21
	ScrDef RocketHideout_B3F_EventScript_ItemBlackGlasses
	ScrDefEnd
	
RocketHideout_B3F_EventScript_ItemRareCandy:
	SetVar 0x8004, ITEM_RARE_CANDY
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
RocketHideout_B3F_EventScript_ItemTM21:
	SetVar 0x8004, ITEM_TM21
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
RocketHideout_B3F_EventScript_ItemBlackGlasses:
	SetVar 0x8004, ITEM_BLACKGLASSES
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End

_cv_stop:
	NPCMsg msg_0930_CV_CANVAS_ROCKET_HIDEOUT_B3F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
