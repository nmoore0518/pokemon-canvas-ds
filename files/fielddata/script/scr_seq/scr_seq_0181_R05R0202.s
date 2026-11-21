#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R05R0202.h"
#include "msgdata/msg/msg_0331_R05R0202.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's UndergroundPath_NorthSouthTunnel_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef EventMons_EventScript_Cap5
	ScrDef UndergroundPath_NorthSouthTunnel_OnTransition
	ScrDefEnd
	
EventMons_EventScript_Cap5:
	SetVar 0x8004, 5
	GoTo EventMons_EventScript_Cap
	
UndergroundPath_NorthSouthTunnel_OnTransition:
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
	NPCMsg msg_0331_R05R0202_EventMons_Text_CapFound
	WaitFanfare
	BufferPlayersName 6
	NPCMsg msg_0331_R05R0202_EventMons_Text_CapInCase
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventMons_EventScript_CapNoCase:
	NPCMsg msg_0331_R05R0202_EventMons_Text_CapNoCase
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventMons_EventScript_ReleaseAllEnd:
	CanvasCloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0331_R05R0202_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
