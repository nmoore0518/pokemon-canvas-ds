#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_VICTORY_ROAD_3F.h"
#include "msgdata/msg/msg_0876_CV_CANVAS_VICTORY_ROAD_3F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's VictoryRoad_3F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef VictoryRoad_3F_EventScript_ItemMaxRevive
	ScrDef VictoryRoad_3F_EventScript_ItemTM50
	ScrDef _cv_unported_2
	ScrDef VictoryRoad_3F_OnLoad
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
	// TODO(gba) setmetatile 12, 12, METATILE_Cave_Floor_Ledge_Top, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 12, 13, METATILE_Cave_Floor_Ledge_Bottom, 0
	GoTo _cv_stop
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	GetPersonCoords 7, 0x401E, 0x401F
	MovePerson 7, 0x401E, 0x401F
	GetPersonCoords 10, 0x401E, 0x401F
	MovePerson 10, 0x401E, 0x401F
	SetVar 0x503B, 100
	ReleaseAll
	End
	
VictoryRoad_3F_OnLoad:
	CompareVarToValue 0x503B, 100
	CallIfNe VictoryRoad_3F_EventScript_SetRockBarrier
	End
	
VictoryRoad_3F_EventScript_FloorSwitchAlreadyPressed:
	ReleaseAll
	End
	
VictoryRoad_3F_EventScript_SetRockBarrier:
	// TODO(gba) setmetatile 12, 12, METATILE_Cave_RockBarrier_Top, 1
	// TODO(gba) setmetatile 12, 13, METATILE_Cave_RockBarrier_Bottom, 1
	Return

_cv_unported_2:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0876_CV_CANVAS_VICTORY_ROAD_3F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0876_CV_CANVAS_VICTORY_ROAD_3F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
