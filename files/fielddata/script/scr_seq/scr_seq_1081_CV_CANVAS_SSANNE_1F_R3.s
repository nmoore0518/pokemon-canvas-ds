#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SSANNE_1F_R3.h"
#include "msgdata/msg/msg_0912_CV_CANVAS_SSANNE_1F_R3.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SSAnne_1F_Room3_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SSAnne_1F_Room3_EventScript_LittleGirl
	ScrDef SSAnne_1F_Room3_EventScript_Wigglytuff
	ScrDef SSAnne_1F_Room3_EventScript_BaldingMan
	ScrDefEnd
	
SSAnne_1F_Room3_EventScript_LittleGirl:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0912_CV_CANVAS_SSANNE_1F_R3_SSAnne_1F_Room3_Text_AlwaysTravelWithWigglytuff
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SSAnne_1F_Room3_EventScript_Wigglytuff:
	LockAll
	FacePlayer
	WaitSE SEQ_SE_DP_SELECT
	PlayCry SPECIES_WIGGLYTUFF, 0
	NPCMsg msg_0912_CV_CANVAS_SSANNE_1F_R3_SSAnne_1F_Room3_Text_Wigglytuff
	WaitButton
	WaitCry
	CloseMsg
	ReleaseAll
	End
	
SSAnne_1F_Room3_EventScript_BaldingMan:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0912_CV_CANVAS_SSANNE_1F_R3_SSAnne_1F_Room3_Text_CruiseIsElegantAndCozy
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0912_CV_CANVAS_SSANNE_1F_R3_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
