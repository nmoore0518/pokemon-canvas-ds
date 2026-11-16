#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R04.h"
#include "msgdata/msg/msg_0328_R04.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route4_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route4_EventScript_ItemTM05
	ScrDef Route4_EventScript_MegaPunchTutor
	ScrDef Route4_EventScript_MegaKickTutor
	ScrDef BerryField_EventScript_FindPoison
	ScrDef Route4_EventScript_RouteSign
	ScrDefEnd
	
Route4_EventScript_ItemTM05:
	SetVar 0x8004, ITEM_TM05
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
Route4_EventScript_MegaPunchTutor:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0328_R04_Route4_Text_MegaPunchTutor_Retired
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route4_EventScript_MegaKickTutor:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0328_R04_Route4_Text_MegaKickTutor_Retired
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
BerryField_EventScript_FindPoison:
	SetVar 0x8004, ITEM_KEBIA_BERRY
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
Route4_EventScript_RouteSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0328_R04_Route4_Text_RouteSign
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0328_R04_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
