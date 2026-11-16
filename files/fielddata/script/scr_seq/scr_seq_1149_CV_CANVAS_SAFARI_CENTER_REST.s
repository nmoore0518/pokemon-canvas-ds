#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SAFARI_CENTER_REST.h"
#include "msgdata/msg/msg_0946_CV_CANVAS_SAFARI_CENTER_REST.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SafariZone_Center_RestHouse_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SafariZone_Center_RestHouse_EventScript_Scientist
	ScrDef SafariZone_Center_RestHouse_EventScript_Sara
	ScrDefEnd
	
SafariZone_Center_RestHouse_EventScript_Scientist:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0946_CV_CANVAS_SAFARI_CENTER_REST_SafariZone_Center_Text_CatchingMonsAsGifts
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SafariZone_Center_RestHouse_EventScript_Sara:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0946_CV_CANVAS_SAFARI_CENTER_REST_SafariZone_Center_Text_WhereDidErikGo
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0946_CV_CANVAS_SAFARI_CENTER_REST_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
