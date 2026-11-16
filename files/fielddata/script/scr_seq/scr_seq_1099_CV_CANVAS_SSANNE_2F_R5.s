#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SSANNE_2F_R5.h"
#include "msgdata/msg/msg_0921_CV_CANVAS_SSANNE_2F_R5.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SSAnne_2F_Room5_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SSAnne_2F_Room5_EventScript_Gentleman
	ScrDef SSAnne_2F_Room5_EventScript_LittleBoy
	ScrDefEnd
	
SSAnne_2F_Room5_EventScript_Gentleman:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0921_CV_CANVAS_SSANNE_2F_R5_SSAnne_2F_Room5_Text_HaveYouGoneToSafariZone
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SSAnne_2F_Room5_EventScript_LittleBoy:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0921_CV_CANVAS_SSANNE_2F_R5_SSAnne_2F_Room5_Text_WeThinkSafariZoneIsAwesome
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0921_CV_CANVAS_SSANNE_2F_R5_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
