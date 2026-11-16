#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_ROCK_TUNNEL_1F.h"
#include "msgdata/msg/msg_0869_CV_CANVAS_ROCK_TUNNEL_1F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's RockTunnel_1F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef RockTunnel_1F_EventScript_ItemRepel
	ScrDef RockTunnel_1F_EventScript_ItemPearl
	ScrDef RockTunnel_1F_EventScript_ItemEscapeRope
	ScrDef RockTunnel_1F_EventScript_RouteSign
	ScrDef RockTunnel_1F_OnTransition
	ScrDefEnd
	
RockTunnel_1F_EventScript_ItemRepel:
	SetVar 0x8004, ITEM_REPEL
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
RockTunnel_1F_EventScript_ItemPearl:
	SetVar 0x8004, ITEM_PEARL
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
RockTunnel_1F_EventScript_ItemEscapeRope:
	SetVar 0x8004, ITEM_ESCAPE_ROPE
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
RockTunnel_1F_EventScript_RouteSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0869_CV_CANVAS_ROCK_TUNNEL_1F_RockTunnel_1F_Text_RouteSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
RockTunnel_1F_OnTransition:
	End

_cv_stop:
	NPCMsg msg_0869_CV_CANVAS_ROCK_TUNNEL_1F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
