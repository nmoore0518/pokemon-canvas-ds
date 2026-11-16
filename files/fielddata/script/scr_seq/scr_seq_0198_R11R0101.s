#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R11R0101.h"
#include "msgdata/msg/msg_0347_R11R0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route11_EastEntrance_1F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route11_EastEntrance_1F_EventScript_TopGuard
	ScrDef Route11_EastEntrance_1F_EventScript_BottomGuard
	ScrDefEnd
	
Route11_EastEntrance_1F_EventScript_TopGuard:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0347_R11R0101_Route11_EastEntrance_1F_Text_ManInLavenderRatesNames
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route11_EastEntrance_1F_EventScript_BottomGuard:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0347_R11R0101_Route11_EastEntrance_1F_Text_RockTunnelToReachLavender
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0347_R11R0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
