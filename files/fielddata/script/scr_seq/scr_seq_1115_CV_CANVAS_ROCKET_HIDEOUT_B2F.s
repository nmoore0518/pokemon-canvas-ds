#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_ROCKET_HIDEOUT_B2F.h"
#include "msgdata/msg/msg_0929_CV_CANVAS_ROCKET_HIDEOUT_B2F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's RocketHideout_B2F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef RocketHideout_B2F_EventScript_ItemXSpeed
	ScrDef RocketHideout_B2F_EventScript_ItemMoonStone
	ScrDef RocketHideout_B2F_EventScript_ItemTM12
	ScrDef RocketHideout_B2F_EventScript_ItemSuperPotion
	ScrDefEnd
	
RocketHideout_B2F_EventScript_ItemXSpeed:
	SetVar 0x8004, ITEM_X_SPEED
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
RocketHideout_B2F_EventScript_ItemMoonStone:
	SetVar 0x8004, ITEM_MOON_STONE
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
RocketHideout_B2F_EventScript_ItemTM12:
	SetVar 0x8004, ITEM_TM12
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
RocketHideout_B2F_EventScript_ItemSuperPotion:
	SetVar 0x8004, ITEM_SUPER_POTION
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End

_cv_stop:
	NPCMsg msg_0929_CV_CANVAS_ROCKET_HIDEOUT_B2F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
