#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_UNDERGROUND_EW.h"
#include "msgdata/msg/msg_0983_CV_CANVAS_UNDERGROUND_EW.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's UndergroundPath_EastWestTunnel_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef EventMons_EventScript_Cap6
	ScrDef UndergroundPath_EastWestTunnel_OnTransition
	ScrDefEnd
	
EventMons_EventScript_Cap6:
	SetVar 0x8004, 6
	GoTo EventMons_EventScript_Cap
	
UndergroundPath_EastWestTunnel_OnTransition:
	End
	
EventMons_EventScript_Cap:
	LockAll
	// TODO(gba) special EventMons_CapFound
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq EventMons_EventScript_CapNoCase
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq EventMons_EventScript_ReleaseAllEnd
	PlayFanfare SEQ_ME_ITEM
	BufferPlayersName 6
	NPCMsg msg_0983_CV_CANVAS_UNDERGROUND_EW_EventMons_Text_CapFound
	WaitFanfare
	BufferPlayersName 6
	NPCMsg msg_0983_CV_CANVAS_UNDERGROUND_EW_EventMons_Text_CapInCase
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventMons_EventScript_CapNoCase:
	NPCMsg msg_0983_CV_CANVAS_UNDERGROUND_EW_EventMons_Text_CapNoCase
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventMons_EventScript_ReleaseAllEnd:
	CanvasCloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0983_CV_CANVAS_UNDERGROUND_EW_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
