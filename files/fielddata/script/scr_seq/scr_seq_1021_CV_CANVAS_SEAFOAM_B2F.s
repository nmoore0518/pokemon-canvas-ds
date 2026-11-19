#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SEAFOAM_B2F.h"
#include "msgdata/msg/msg_0882_CV_CANVAS_SEAFOAM_B2F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SeafoamIslands_B2F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SeafoamIslands_B2F_EventScript_ItemBigPearl
	ScrDef SeafoamIslands_B2F_Frlg_cv_BoulderFalls
	ScrDefEnd
	
SeafoamIslands_B2F_EventScript_ItemBigPearl:
	SetVar 0x8004, ITEM_BIG_PEARL
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
SeafoamIslands_B2F_Frlg_cv_BoulderFalls:
	PlaySE SEQ_SE_GS_IWAOTOSHI
	CompareVarToValue VAR_SPECIAL_LAST_TALKED, 1
	GoToIfNe _cv_fall_1
	SetFlag 0x2116
	ClearFlag 0x2118
	HidePerson VAR_SPECIAL_LAST_TALKED
	WaitSE SEQ_SE_GS_IWAOTOSHI
	End
_cv_fall_1:
	CompareVarToValue VAR_SPECIAL_LAST_TALKED, 2
	GoToIfNe _cv_fall_2
	SetFlag 0x2117
	ClearFlag 0x2119
	HidePerson VAR_SPECIAL_LAST_TALKED
	WaitSE SEQ_SE_GS_IWAOTOSHI
	End
_cv_fall_2:
	End

_cv_stop:
	NPCMsg msg_0882_CV_CANVAS_SEAFOAM_B2F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
