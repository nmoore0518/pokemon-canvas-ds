#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_FIGHT_AREA_UNUSED_9.h"
#include "msgdata/msg/msg_0858_CV_FIGHT_AREA_UNUSED_9.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PalletTown_Gym_LeftRoom by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef GymDecor_EventScript_GymPC
	ScrDef GymRooms_EventScript_OnLoad
	ScrDefEnd
	
GymDecor_EventScript_GymPC:
	LockAll
	PlaySE SEQ_SE_DP_SELECT
	BufferPlayersName 6
	NPCMsg msg_0858_CV_FIGHT_AREA_UNUSED_9_GymDecor_Text_BootedUpGymPC
	WaitButton
	End
	
GymRooms_EventScript_OnLoad:
	End
	.balign 4, 0
