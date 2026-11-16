#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_VICTORY_ROAD_1F.h"
#include "msgdata/msg/msg_0874_CV_CANVAS_VICTORY_ROAD_1F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's VictoryRoad_1F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef VictoryRoad_1F_EventScript_ItemRareCandy
	ScrDef VictoryRoad_1F_EventScript_ItemTM02
	ScrDef _cv_unported_2
	ScrDef VictoryRoad_1F_Frlg_OnLoad
	ScrDef VictoryRoad_1F_Frlg_OnTransition
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
	// TODO(gba) setmetatile 12, 14, METATILE_Cave_Floor_Ledge_Top, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 12, 15, METATILE_Cave_Floor_Ledge_Bottom, 0
	GoTo _cv_stop
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	GetPersonCoords 5, 0x401E, 0x401F
	MovePerson 5, 0x401E, 0x401F
	SetVar 0x5038, 100
	ReleaseAll
	End
	
VictoryRoad_1F_Frlg_OnLoad:
	CompareVarToValue 0x5038, 100
	CallIfNe VictoryRoad_1F_EventScript_SetRockBarrier
	End
	
VictoryRoad_1F_Frlg_OnTransition:
	End
	
VictoryRoad_1F_EventScript_FloorSwitchAlreadyPressed:
	ReleaseAll
	End
	
VictoryRoad_1F_EventScript_SetRockBarrier:
	// TODO(gba) setmetatile 12, 14, METATILE_Cave_RockBarrier_Top, 1
	// TODO(gba) setmetatile 12, 15, METATILE_Cave_RockBarrier_Bottom, 1
	Return

_cv_unported_2:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0874_CV_CANVAS_VICTORY_ROAD_1F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0874_CV_CANVAS_VICTORY_ROAD_1F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
