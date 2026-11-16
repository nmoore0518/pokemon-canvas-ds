#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R03.h"
#include "msgdata/msg/msg_0326_R03.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route3_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route3_EventScript_Youngster
	ScrDef BerryField_EventScript_FindFighting
	ScrDef Route3_EventScript_RouteSign
	ScrDefEnd
	
Route3_EventScript_Youngster:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0326_R03_Route3_Text_TunnelFromCeruleanTiring
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
BerryField_EventScript_FindFighting:
	SetVar 0x8004, ITEM_CHOPLE_BERRY
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
Route3_EventScript_RouteSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0326_R03_Route3_Text_RouteSign
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0326_R03_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
