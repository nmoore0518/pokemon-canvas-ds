#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SSANNE_1F.h"
#include "msgdata/msg/msg_0903_CV_CANVAS_SSANNE_1F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SSAnne_1F_Corridor_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SSAnne_1F_Corridor_EventScript_Sailor
	ScrDef SSAnne_1F_Corridor_EventScript_WorkerM
	ScrDefEnd
	
SSAnne_1F_Corridor_EventScript_Sailor:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0903_CV_CANVAS_SSANNE_1F_SSAnne_1F_Corridor_Text_PassengersAreRestless
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SSAnne_1F_Corridor_EventScript_WorkerM:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0903_CV_CANVAS_SSANNE_1F_SSAnne_1F_Corridor_Text_LeStrongSilentType
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0903_CV_CANVAS_SSANNE_1F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
