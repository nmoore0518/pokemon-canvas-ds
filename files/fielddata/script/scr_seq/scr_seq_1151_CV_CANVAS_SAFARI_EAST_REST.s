#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SAFARI_EAST_REST.h"
#include "msgdata/msg/msg_0947_CV_CANVAS_SAFARI_EAST_REST.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SafariZone_East_RestHouse_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SafariZone_East_RestHouse_EventScript_Scientist
	ScrDef SafariZone_East_RestHouse_EventScript_Rocker
	ScrDef SafariZone_East_RestHouse_EventScript_BaldingMan
	ScrDefEnd
	
SafariZone_East_RestHouse_EventScript_Scientist:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0947_CV_CANVAS_SAFARI_EAST_REST_SafariZone_East_Text_HowManyDidYouCatch
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SafariZone_East_RestHouse_EventScript_Rocker:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0947_CV_CANVAS_SAFARI_EAST_REST_SafariZone_East_Text_CaughtChanseyAllWorthwhile
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SafariZone_East_RestHouse_EventScript_BaldingMan:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0947_CV_CANVAS_SAFARI_EAST_REST_SafariZone_East_Text_TiredFromAllTheFun
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0947_CV_CANVAS_SAFARI_EAST_REST_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
