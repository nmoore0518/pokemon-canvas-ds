#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SAFARI_WEST_REST.h"
#include "msgdata/msg/msg_0949_CV_CANVAS_SAFARI_WEST_REST.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SafariZone_West_RestHouse_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SafariZone_West_RestHouse_EventScript_Scientist
	ScrDef SafariZone_West_RestHouse_EventScript_Man
	ScrDef SafariZone_West_RestHouse_EventScript_CooltrainerF
	ScrDefEnd
	
SafariZone_West_RestHouse_EventScript_Scientist:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0949_CV_CANVAS_SAFARI_WEST_REST_SafariZone_West_Text_RocksMakeMonRunButEasierCatch
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SafariZone_West_RestHouse_EventScript_Man:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0949_CV_CANVAS_SAFARI_WEST_REST_SafariZone_West_Text_BaitMakesMonStickAround
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SafariZone_West_RestHouse_EventScript_CooltrainerF:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0949_CV_CANVAS_SAFARI_WEST_REST_SafariZone_West_Text_HikedLotsDidntSeeMonIWanted
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0949_CV_CANVAS_SAFARI_WEST_REST_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
