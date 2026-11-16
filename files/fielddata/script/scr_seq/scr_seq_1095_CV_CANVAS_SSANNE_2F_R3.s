#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SSANNE_2F_R3.h"
#include "msgdata/msg/msg_0919_CV_CANVAS_SSANNE_2F_R3.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SSAnne_2F_Room3_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SSAnne_2F_Room3_EventScript_Gentleman
	ScrDef SSAnne_2F_Room3_EventScript_OldMan
	ScrDefEnd
	
SSAnne_2F_Room3_EventScript_Gentleman:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0919_CV_CANVAS_SSANNE_2F_R3_SSAnne_2F_Room3_Text_SeenMonsFerryPeople
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SSAnne_2F_Room3_EventScript_OldMan:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0919_CV_CANVAS_SSANNE_2F_R3_SSAnne_2F_Room3_Text_SomeTreesCanBeCutDown
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0919_CV_CANVAS_SSANNE_2F_R3_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
