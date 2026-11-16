#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T07R0204.h"
#include "msgdata/msg/msg_0504_T07R0204.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's CeladonCity_Condominiums_Roof_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef CeladonCity_Condominiums_Roof_EventScript_Sign
	ScrDefEnd
	
CeladonCity_Condominiums_Roof_EventScript_Sign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0504_T07R0204_CeladonCity_Condominiums_Roof_Text_IKnowEverything
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0504_T07R0204_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
