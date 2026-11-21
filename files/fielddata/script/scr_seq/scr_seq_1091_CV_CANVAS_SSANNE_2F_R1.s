#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SSANNE_2F_R1.h"
#include "msgdata/msg/msg_0917_CV_CANVAS_SSANNE_2F_R1.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SSAnne_2F_Room1_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SSAnne_2F_Room1_EventScript_Gentleman
	ScrDefEnd
	
SSAnne_2F_Room1_EventScript_Gentleman:
	LockAll
	FacePlayer
	NPCMsg msg_0917_CV_CANVAS_SSANNE_2F_R1_SSAnne_2F_Room1_Text_SleepingMonLookedLikeThis
	SetVar 0x8004, SPECIES_SNORLAX
	ScrCmd_452 SPECIES_SNORLAX, 0
	SetVar 0x5065, 1
	WaitButton
	CompareVarToValue 0x5065, 1
	GoToIfNe _cv_nopic_1
	ScrCmd_453
	SetVar 0x5065, 0
_cv_nopic_1:
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0917_CV_CANVAS_SSANNE_2F_R1_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
