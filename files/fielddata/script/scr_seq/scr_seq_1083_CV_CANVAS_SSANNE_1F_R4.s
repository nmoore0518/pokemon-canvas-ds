#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SSANNE_1F_R4.h"
#include "msgdata/msg/msg_0913_CV_CANVAS_SSANNE_1F_R4.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SSAnne_1F_Room4_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SSAnne_1F_Room4_EventScript_Woman
	ScrDefEnd
	
SSAnne_1F_Room4_EventScript_Woman:
	LockAll
	FacePlayer
	GetPlayerGender VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq SSAnne_1F_Room4_EventScript_WomanPlayerMale
	NPCMsg msg_0913_CV_CANVAS_SSANNE_1F_R4_SSAnne_1F_Room4_Text_WaitressCherryPiePlease
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SSAnne_1F_Room4_EventScript_WomanPlayerMale:
	NPCMsg msg_0913_CV_CANVAS_SSANNE_1F_R4_SSAnne_1F_Room4_Text_WaiterCherryPiePlease
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0913_CV_CANVAS_SSANNE_1F_R4_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
