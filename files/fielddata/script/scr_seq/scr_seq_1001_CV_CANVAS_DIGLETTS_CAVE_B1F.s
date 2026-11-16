#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_DIGLETTS_CAVE_B1F.h"
#include "msgdata/msg/msg_0872_CV_CANVAS_DIGLETTS_CAVE_B1F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's DiglettsCave_B1F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef BerryField_EventScript_FindGround
	ScrDef DiglettsCave_B1F_OnTransition
	ScrDefEnd
	
BerryField_EventScript_FindGround:
	SetVar 0x8004, ITEM_SHUCA_BERRY
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
DiglettsCave_B1F_OnTransition:
	End

_cv_stop:
	NPCMsg msg_0872_CV_CANVAS_DIGLETTS_CAVE_B1F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
