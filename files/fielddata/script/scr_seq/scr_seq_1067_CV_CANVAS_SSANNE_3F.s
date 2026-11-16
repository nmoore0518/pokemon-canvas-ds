#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SSANNE_3F.h"
#include "msgdata/msg/msg_0905_CV_CANVAS_SSANNE_3F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SSAnne_3F_Corridor_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SSAnne_3F_Corridor_EventScript_Sailor
	ScrDefEnd
	
SSAnne_3F_Corridor_EventScript_Sailor:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0905_CV_CANVAS_SSANNE_3F_SSAnne_3F_Corridor_Text_CaptainTeachesCutToMons
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0905_CV_CANVAS_SSANNE_3F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
