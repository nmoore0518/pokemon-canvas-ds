#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SAFARI_NORTH_REST.h"
#include "msgdata/msg/msg_0948_CV_CANVAS_SAFARI_NORTH_REST.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SafariZone_North_RestHouse_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SafariZone_North_RestHouse_EventScript_Gentleman
	ScrDef SafariZone_North_RestHouse_EventScript_Scientist
	ScrDef SafariZone_North_RestHouse_EventScript_Fisher
	ScrDef SafariZone_North_RestHouse_EventScript_BaldingMan
	ScrDefEnd
	
SafariZone_North_RestHouse_EventScript_Gentleman:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0948_CV_CANVAS_SAFARI_NORTH_REST_SafariZone_East_Text_MyEeveeEvolvedIntoFlareon
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SafariZone_North_RestHouse_EventScript_Scientist:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0948_CV_CANVAS_SAFARI_NORTH_REST_SafariZone_East_Text_KeepAnyItemFoundOnSafari
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SafariZone_North_RestHouse_EventScript_Fisher:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0948_CV_CANVAS_SAFARI_NORTH_REST_SafariZone_East_Text_PrizeInDeepestPartOfSafariZone
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SafariZone_North_RestHouse_EventScript_BaldingMan:
	LockAll
	FacePlayer
	NPCMsg msg_0948_CV_CANVAS_SAFARI_NORTH_REST_SafariZone_West_Text_KogaPatrolsSafariEverySoOften
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0948_CV_CANVAS_SAFARI_NORTH_REST_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
