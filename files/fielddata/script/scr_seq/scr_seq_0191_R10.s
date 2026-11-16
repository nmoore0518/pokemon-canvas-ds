#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R10.h"
#include "msgdata/msg/msg_0341_R10.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route10_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route10_EventScript_SouthRockTunnelSign
	ScrDef Route10_EventScript_PowerPlantSign
	ScrDef Route10_EventScript_NorthRockTunnelSign
	ScrDef EventMons_EventScript_Cap4
	ScrDefEnd
	
Route10_EventScript_SouthRockTunnelSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0341_R10_Route10_Text_RockTunnel
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route10_EventScript_PowerPlantSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0341_R10_Route10_Text_PowerPlant
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route10_EventScript_NorthRockTunnelSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0341_R10_Route10_Text_RockTunnelDetourToLavender
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventMons_EventScript_Cap4:
	SetVar 0x8004, 4
	GoTo EventMons_EventScript_Cap
	
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
	NPCMsg msg_0341_R10_EventMons_Text_CapFound
	WaitFanfare
	BufferPlayersName 6
	NPCMsg msg_0341_R10_EventMons_Text_CapInCase
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventMons_EventScript_CapNoCase:
	NPCMsg msg_0341_R10_EventMons_Text_CapNoCase
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventMons_EventScript_ReleaseAllEnd:
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0341_R10_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
