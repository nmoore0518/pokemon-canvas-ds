#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_VICTORY_ROAD_3F.h"
#include "msgdata/msg/msg_0876_CV_CANVAS_VICTORY_ROAD_3F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's VictoryRoad_3F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef VictoryRoad_3F_EventScript_ItemMaxRevive
	ScrDef VictoryRoad_3F_EventScript_ItemTM50
	ScrDef VictoryRoad_3F_EventScript_FloorSwitch
	ScrDef VictoryRoad_3F_Frlg_cv_BoulderFalls
	ScrDef VictoryRoad_3F_OnLoad
	ScrDef VictoryRoad_3F_Frlg_cv_Barriers
	ScrDefEnd
	
VictoryRoad_3F_EventScript_ItemMaxRevive:
	SetVar 0x8004, ITEM_MAX_REVIVE
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
VictoryRoad_3F_EventScript_ItemTM50:
	SetVar 0x8004, ITEM_TM50
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
VictoryRoad_3F_EventScript_FloorSwitch:
	LockAll
	CompareVarToValue 0x503B, 100
	GoToIfEq VictoryRoad_3F_EventScript_FloorSwitchAlreadyPressed
	GoToIfSet 0x226E, _cv_bar_1
	SetFlag 0x226E
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_1
	HidePerson 200
_cv_bar_1:
	GoToIfSet 0x226F, _cv_bar_2
	SetFlag 0x226F
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_2
	HidePerson 201
_cv_bar_2:
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	GetPersonCoords 7, 0x401E, 0x401F
	MovePerson 7, 0x401E, 0x401F
	GetPersonCoords 10, 0x401E, 0x401F
	MovePerson 10, 0x401E, 0x401F
	SetVar 0x503B, 100
	ReleaseAll
	End
	
VictoryRoad_3F_Frlg_cv_BoulderFalls:
	PlaySE SEQ_SE_GS_IWAOTOSHI
	CompareVarToValue VAR_SPECIAL_LAST_TALKED, 7
	GoToIfNe _cv_fall_7
	HidePerson VAR_SPECIAL_LAST_TALKED
	WaitSE SEQ_SE_GS_IWAOTOSHI
	End
_cv_fall_7:
	CompareVarToValue VAR_SPECIAL_LAST_TALKED, 8
	GoToIfNe _cv_fall_8
	SetFlag 0x216F
	ClearFlag 0x216B
	HidePerson VAR_SPECIAL_LAST_TALKED
	WaitSE SEQ_SE_GS_IWAOTOSHI
	End
_cv_fall_8:
	CompareVarToValue VAR_SPECIAL_LAST_TALKED, 9
	GoToIfNe _cv_fall_9
	HidePerson VAR_SPECIAL_LAST_TALKED
	WaitSE SEQ_SE_GS_IWAOTOSHI
	End
_cv_fall_9:
	CompareVarToValue VAR_SPECIAL_LAST_TALKED, 10
	GoToIfNe _cv_fall_10
	HidePerson VAR_SPECIAL_LAST_TALKED
	WaitSE SEQ_SE_GS_IWAOTOSHI
	End
_cv_fall_10:
	End
	
VictoryRoad_3F_OnLoad:
	CompareVarToValue 0x503B, 100
	CallIfNe VictoryRoad_3F_EventScript_SetRockBarrier
	End
	
VictoryRoad_3F_Frlg_cv_Barriers:
	SetVar 0x5044, 1
	SetFlag 0x226E
	SetFlag 0x226F
	Call VictoryRoad_3F_OnLoad_cv_init
	SetVar 0x5044, 0
	End
	
VictoryRoad_3F_EventScript_FloorSwitchAlreadyPressed:
	ReleaseAll
	End
	
VictoryRoad_3F_EventScript_SetRockBarrier:
	GoToIfUnset 0x226E, _cv_bar_3
	ClearFlag 0x226E
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_3
	ShowPerson 200
_cv_bar_3:
	GoToIfUnset 0x226F, _cv_bar_4
	ClearFlag 0x226F
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_4
	ShowPerson 201
_cv_bar_4:
	Return
	
VictoryRoad_3F_OnLoad_cv_init:
	CompareVarToValue 0x503B, 100
	CallIfNe VictoryRoad_3F_EventScript_SetRockBarrier
	Return

_cv_stop:
	NPCMsg msg_0876_CV_CANVAS_VICTORY_ROAD_3F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
