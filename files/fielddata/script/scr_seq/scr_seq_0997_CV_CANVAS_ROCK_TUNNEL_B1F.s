#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_ROCK_TUNNEL_B1F.h"
#include "msgdata/msg/msg_0870_CV_CANVAS_ROCK_TUNNEL_B1F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's RockTunnel_B1F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef RockTunnel_B1F_EventScript_RockSlideTutor
	ScrDef RockTunnel_B1F_EventScript_ItemRevive
	ScrDef RockTunnel_B1F_EventScript_ItemMaxEther
	ScrDefEnd
	
RockTunnel_B1F_EventScript_RockSlideTutor:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0870_CV_CANVAS_ROCK_TUNNEL_B1F_RockTunnel_B1F_Text_RockSlideTutor_Retired
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
RockTunnel_B1F_EventScript_ItemRevive:
	SetVar 0x8004, ITEM_REVIVE
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
RockTunnel_B1F_EventScript_ItemMaxEther:
	SetVar 0x8004, ITEM_MAX_ETHER
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End

_cv_stop:
	NPCMsg msg_0870_CV_CANVAS_ROCK_TUNNEL_B1F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
