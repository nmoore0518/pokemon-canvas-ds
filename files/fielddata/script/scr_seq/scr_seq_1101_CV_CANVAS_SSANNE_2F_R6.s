#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SSANNE_2F_R6.h"
#include "msgdata/msg/msg_0922_CV_CANVAS_SSANNE_2F_R6.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SSAnne_2F_Room6_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SSAnne_2F_Room6_EventScript_Woman2
	ScrDef SSAnne_2F_Room6_EventScript_Woman1
	ScrDefEnd
	
SSAnne_2F_Room6_EventScript_Woman2:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0922_CV_CANVAS_SSANNE_2F_R6_SSAnne_2F_Room6_Text_ManyPeopleGetSeasick
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SSAnne_2F_Room6_EventScript_Woman1:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0922_CV_CANVAS_SSANNE_2F_R6_SSAnne_2F_Room6_Text_CaptainIsAwfullySick
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0922_CV_CANVAS_SSANNE_2F_R6_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
