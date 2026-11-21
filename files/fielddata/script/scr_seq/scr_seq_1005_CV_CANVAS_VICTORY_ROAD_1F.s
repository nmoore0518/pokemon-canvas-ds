#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_VICTORY_ROAD_1F.h"
#include "msgdata/msg/msg_0874_CV_CANVAS_VICTORY_ROAD_1F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's VictoryRoad_1F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef VictoryRoad_1F_EventScript_ItemRareCandy
	ScrDef VictoryRoad_1F_EventScript_ItemTM02
	ScrDef VictoryRoad_1F_EventScript_FloorSwitch
	ScrDef VictoryRoad_1F_Frlg_OnLoad
	ScrDef VictoryRoad_1F_Frlg_OnTransition
	ScrDef VictoryRoad_1F_Frlg_cv_Barriers
	ScrDefEnd
	
VictoryRoad_1F_EventScript_ItemRareCandy:
	SetVar 0x8004, ITEM_RARE_CANDY
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
VictoryRoad_1F_EventScript_ItemTM02:
	SetVar 0x8004, ITEM_TM02
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
VictoryRoad_1F_EventScript_FloorSwitch:
	LockAll
	CompareVarToValue 0x5038, 100
	GoToIfEq VictoryRoad_1F_EventScript_FloorSwitchAlreadyPressed
	GoToIfSet 0x2268, _cv_bar_1
	SetFlag 0x2268
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_1
	HidePerson 200
_cv_bar_1:
	GoToIfSet 0x2269, _cv_bar_2
	SetFlag 0x2269
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_2
	HidePerson 201
_cv_bar_2:
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	GetPersonCoords 5, 0x401E, 0x401F
	MovePerson 5, 0x401E, 0x401F
	SetVar 0x5038, 100
	CanvasCloseMsg
	ReleaseAll
	End
	
VictoryRoad_1F_Frlg_OnLoad:
	CompareVarToValue 0x5038, 100
	CallIfNe VictoryRoad_1F_EventScript_SetRockBarrier
	End
	
VictoryRoad_1F_Frlg_OnTransition:
	End
	
VictoryRoad_1F_Frlg_cv_Barriers:
	SetVar 0x5044, 1
	SetFlag 0x2268
	SetFlag 0x2269
	Call VictoryRoad_1F_Frlg_OnLoad_cv_init
	SetVar 0x5044, 0
	GoTo VictoryRoad_1F_Frlg_OnTransition
	
VictoryRoad_1F_EventScript_FloorSwitchAlreadyPressed:
	CanvasCloseMsg
	ReleaseAll
	End
	
VictoryRoad_1F_EventScript_SetRockBarrier:
	GoToIfUnset 0x2268, _cv_bar_3
	ClearFlag 0x2268
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_3
	ShowPerson 200
_cv_bar_3:
	GoToIfUnset 0x2269, _cv_bar_4
	ClearFlag 0x2269
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_4
	ShowPerson 201
_cv_bar_4:
	Return
	
VictoryRoad_1F_Frlg_OnLoad_cv_init:
	CompareVarToValue 0x5038, 100
	CallIfNe VictoryRoad_1F_EventScript_SetRockBarrier
	Return

_cv_stop:
	NPCMsg msg_0874_CV_CANVAS_VICTORY_ROAD_1F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
