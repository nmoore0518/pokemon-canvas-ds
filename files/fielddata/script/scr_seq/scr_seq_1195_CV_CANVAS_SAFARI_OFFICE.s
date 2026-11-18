#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SAFARI_OFFICE.h"
#include "msgdata/msg/msg_0969_CV_CANVAS_SAFARI_OFFICE.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's FuchsiaCity_SafariZone_Office_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef FuchsiaCity_SafariZone_Office_EventScript_Worker2
	ScrDef FuchsiaCity_SafariZone_Office_EventScript_Worker3
	ScrDef FuchsiaCity_SafariZone_Office_EventScript_Worker1
	ScrDef FuchsiaCity_SafariZone_Office_EventScript_Worker4
	ScrDefEnd
	
FuchsiaCity_SafariZone_Office_EventScript_Worker2:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0969_CV_CANVAS_SAFARI_OFFICE_FuchsiaCity_SafariZone_Office_Text_WardenIsVeryKnowledgeable
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_SafariZone_Office_EventScript_Worker3:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0969_CV_CANVAS_SAFARI_OFFICE_FuchsiaCity_SafariZone_Office_Text_CouldntUnderstandWarden
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_SafariZone_Office_EventScript_Worker1:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0969_CV_CANVAS_SAFARI_OFFICE_FuchsiaCity_SafariZone_Office_Text_NicknamedWardenSlowpoke
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_SafariZone_Office_EventScript_Worker4:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0969_CV_CANVAS_SAFARI_OFFICE_FuchsiaCity_SafariZone_Office_Text_PrizeInSafariZone
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0969_CV_CANVAS_SAFARI_OFFICE_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
