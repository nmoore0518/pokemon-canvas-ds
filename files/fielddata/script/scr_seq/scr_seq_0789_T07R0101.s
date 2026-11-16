#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T07R0101.h"
#include "msgdata/msg/msg_0494_T07R0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's CeladonCity_DepartmentStore_1F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef CeladonCity_DepartmentStore_1F_EventScript_Receptionist
	ScrDef CeladonCity_DepartmentStore_1F_EventScript_LayoutSign
	ScrDef CeladonCity_DepartmentStore_1F_EventScript_FloorSign
	ScrDefEnd
	
CeladonCity_DepartmentStore_1F_EventScript_Receptionist:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0494_T07R0101_CeladonCity_DepartmentStore_1F_Text_WelcomeToDeptStore
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_DepartmentStore_1F_EventScript_LayoutSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0494_T07R0101_CeladonCity_DepartmentStore_1F_Text_FloorDescriptions
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_DepartmentStore_1F_EventScript_FloorSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0494_T07R0101_CeladonCity_DepartmentStore_1F_Text_ServiceCounter
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0494_T07R0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
