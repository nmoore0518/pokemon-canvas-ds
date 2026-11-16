#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T11R0801.h"
#include "msgdata/msg/msg_0540_T11R0801.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SaffronCity_CopycatsHouse_1F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SaffronCity_CopycatsHouse_1F_EventScript_CopycatsDad
	ScrDef SaffronCity_CopycatsHouse_1F_EventScript_CopycatsMom
	ScrDef SaffronCity_CopycatsHouse_1F_EventScript_Chansey
	ScrDefEnd
	
SaffronCity_CopycatsHouse_1F_EventScript_CopycatsDad:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0540_T11R0801_SaffronCity_CopycatsHouse_1F_Text_DaughterLikesToMimicPeople
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_CopycatsHouse_1F_EventScript_CopycatsMom:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0540_T11R0801_SaffronCity_CopycatsHouse_1F_Text_DaughterIsSelfCentered
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_CopycatsHouse_1F_EventScript_Chansey:
	LockAll
	FacePlayer
	WaitSE SEQ_SE_DP_SELECT
	PlayCry SPECIES_CHANSEY, 0
	NPCMsg msg_0540_T11R0801_SaffronCity_CopycatsHouse_1F_Text_Chansey
	WaitButton
	WaitCry
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0540_T11R0801_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
