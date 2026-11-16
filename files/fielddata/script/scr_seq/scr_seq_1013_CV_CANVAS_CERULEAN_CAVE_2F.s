#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_CERULEAN_CAVE_2F.h"
#include "msgdata/msg/msg_0878_CV_CANVAS_CERULEAN_CAVE_2F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's CeruleanCave_2F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef CeruleanCave_2F_EventScript_ItemPPUp
	ScrDef CeruleanCave_2F_EventScript_ItemUltraBall
	ScrDef CeruleanCave_2F_EventScript_ItemFullRestore
	ScrDefEnd
	
CeruleanCave_2F_EventScript_ItemPPUp:
	SetVar 0x8004, ITEM_PP_UP
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
CeruleanCave_2F_EventScript_ItemUltraBall:
	SetVar 0x8004, ITEM_ULTRA_BALL
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
CeruleanCave_2F_EventScript_ItemFullRestore:
	SetVar 0x8004, ITEM_FULL_RESTORE
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End

_cv_stop:
	NPCMsg msg_0878_CV_CANVAS_CERULEAN_CAVE_2F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
