#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T05R0301.h"
#include "msgdata/msg/msg_0479_T05R0301.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's LavenderTown_House1_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef LavenderTown_House1_EventScript_CooltrainerF
	ScrDef LavenderTown_House1_EventScript_Cubone
	ScrDefEnd
	
LavenderTown_House1_EventScript_CooltrainerF:
	LockAll
	FacePlayer
	GoToIfSet 0x20FA, LavenderTown_House1_EventScript_CooltrainerFGhostGone
	NPCMsg msg_0479_T05R0301_LavenderTown_House1_Text_RocketsKilledCubonesMother
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
LavenderTown_House1_EventScript_Cubone:
	LockAll
	FacePlayer
	WaitSE SEQ_SE_DP_SELECT
	PlayCry SPECIES_CUBONE, 0
	NPCMsg msg_0479_T05R0301_LavenderTown_House1_Text_Cubone
	WaitButton
	WaitCry
	CloseMsg
	ReleaseAll
	End
	
LavenderTown_House1_EventScript_CooltrainerFGhostGone:
	NPCMsg msg_0479_T05R0301_LavenderTown_House1_Text_GhostOfPokemonTowerIsGone
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0479_T05R0301_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
