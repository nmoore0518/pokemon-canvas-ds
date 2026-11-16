#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SSANNE_1F_R1.h"
#include "msgdata/msg/msg_0910_CV_CANVAS_SSANNE_1F_R1.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SSAnne_1F_Room1_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SSAnne_1F_Room1_EventScript_Gentleman
	ScrDefEnd
	
SSAnne_1F_Room1_EventScript_Gentleman:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0910_CV_CANVAS_SSANNE_1F_R1_SSAnne_1F_Room1_Text_ImAGlobalPoliceAgent
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0910_CV_CANVAS_SSANNE_1F_R1_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
