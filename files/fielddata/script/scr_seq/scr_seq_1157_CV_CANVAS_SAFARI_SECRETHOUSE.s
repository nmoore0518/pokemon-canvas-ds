#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SAFARI_SECRETHOUSE.h"
#include "msgdata/msg/msg_0950_CV_CANVAS_SAFARI_SECRETHOUSE.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SafariZone_SecretHouse_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SafariZone_SecretHouse_EventScript_Attendant
	ScrDefEnd
	
SafariZone_SecretHouse_EventScript_Attendant:
	LockAll
	FacePlayer
	GoToIfSet 0x2218, SafariZone_SecretHouse_EventScript_ExplainSurf
	NPCMsg msg_0950_CV_CANVAS_SAFARI_SECRETHOUSE_SafariZone_SecretHouse_Text_CongratsYouveWon
	WaitButton
	HasSpaceForItem ITEM_HM03, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq SafariZone_SecretHouse_EventScript_NoRoomForHM03
	GiveItem ITEM_HM03, 1, VAR_SPECIAL_RESULT
	BufferItemName 1, ITEM_HM03
	BufferPlayersName 6
	NPCMsg msg_0950_CV_CANVAS_SAFARI_SECRETHOUSE_SafariZone_SecretHouse_Text_ReceivedHM03FromAttendant
	PlayFanfare SEQ_ME_LVUP
	WaitFanfare
	WaitButton
	NPCMsg msg_0950_CV_CANVAS_SAFARI_SECRETHOUSE_Text_GymHack_AndTakeThisToo
	WaitButton
	SetFlag 0x2219
	SetVar VAR_SPECIAL_RESULT, 1
	NPCMsg msg_0950_CV_CANVAS_SAFARI_SECRETHOUSE_SafariZone_SecretHouse_Text_ExplainSurf
	WaitButton
	SetFlag 0x2218
	CloseMsg
	ReleaseAll
	End
	
SafariZone_SecretHouse_EventScript_ExplainSurf:
	NPCMsg msg_0950_CV_CANVAS_SAFARI_SECRETHOUSE_SafariZone_SecretHouse_Text_ExplainSurf
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SafariZone_SecretHouse_EventScript_NoRoomForHM03:
	NPCMsg msg_0950_CV_CANVAS_SAFARI_SECRETHOUSE_SafariZone_SecretHouse_Text_DontHaveRoomForPrize
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0950_CV_CANVAS_SAFARI_SECRETHOUSE_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
