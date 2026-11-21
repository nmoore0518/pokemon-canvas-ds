#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SILPH_ELEVATOR.h"
#include "msgdata/msg/msg_0957_CV_CANVAS_SILPH_ELEVATOR.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SilphCo_Elevator_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SilphCo_Elevator_EventScript_FloorSelect
	ScrDefEnd
	
SilphCo_Elevator_EventScript_FloorSelect:
	LockAll
	SetVar 0x8004, 1
	CallIfUnset 2, EventScript_GetElevatorFloor
	CopyVar 0x8005, 0x5032
	NPCMsg msg_0957_CV_CANVAS_SILPH_ELEVATOR_gText_WantWhichFloor
	SetVar 0x8004, 14
	SetVar VAR_SPECIAL_RESULT, 0
	TouchscreenMenuHide
_cv_page_1:
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0957_CV_CANVAS_SILPH_ELEVATOR_cv_sm_silphco_floors_0, 0
	ScrCmd_559 msg_0957_CV_CANVAS_SILPH_ELEVATOR_cv_sm_silphco_floors_1, 1
	ScrCmd_559 msg_0957_CV_CANVAS_SILPH_ELEVATOR_cv_sm_silphco_floors_2, 2
	ScrCmd_559 msg_0957_CV_CANVAS_SILPH_ELEVATOR_cv_sm_silphco_floors_3, 3
	ScrCmd_559 msg_0957_CV_CANVAS_SILPH_ELEVATOR_cv_sm_silphco_floors_4, 4
	ScrCmd_559 msg_0957_CV_CANVAS_SILPH_ELEVATOR_cv_sm_silphco_floors_5, 5
	ScrCmd_559 msg_0957_CV_CANVAS_SILPH_ELEVATOR_cv_more, 254
	ScrCmd_067
	CompareVarToValue VAR_SPECIAL_RESULT, 254
	GoToIfEq _cv_page_2
	GoTo _cv_page_2_end
_cv_page_2:
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0957_CV_CANVAS_SILPH_ELEVATOR_cv_sm_silphco_floors_6, 6
	ScrCmd_559 msg_0957_CV_CANVAS_SILPH_ELEVATOR_cv_sm_silphco_floors_7, 7
	ScrCmd_559 msg_0957_CV_CANVAS_SILPH_ELEVATOR_cv_sm_silphco_floors_8, 8
	ScrCmd_559 msg_0957_CV_CANVAS_SILPH_ELEVATOR_cv_sm_silphco_floors_9, 9
	ScrCmd_559 msg_0957_CV_CANVAS_SILPH_ELEVATOR_cv_sm_silphco_floors_10, 10
	ScrCmd_559 msg_0957_CV_CANVAS_SILPH_ELEVATOR_cv_sm_silphco_floors_11, 11
	ScrCmd_559 msg_0957_CV_CANVAS_SILPH_ELEVATOR_cv_more, 254
	ScrCmd_067
	CompareVarToValue VAR_SPECIAL_RESULT, 254
	GoToIfEq _cv_page_1
_cv_page_2_end:
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_3
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_3:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq SilphCo_Elevator_EventScript_To11F
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq SilphCo_Elevator_EventScript_To10F
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq SilphCo_Elevator_EventScript_To9F
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfEq SilphCo_Elevator_EventScript_To8F
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfEq SilphCo_Elevator_EventScript_To7F
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfEq SilphCo_Elevator_EventScript_To6F
	CompareVarToValue VAR_SPECIAL_RESULT, 6
	GoToIfEq SilphCo_Elevator_EventScript_To5F
	CompareVarToValue VAR_SPECIAL_RESULT, 7
	GoToIfEq SilphCo_Elevator_EventScript_To4F
	CompareVarToValue VAR_SPECIAL_RESULT, 8
	GoToIfEq SilphCo_Elevator_EventScript_To3F
	CompareVarToValue VAR_SPECIAL_RESULT, 9
	GoToIfEq SilphCo_Elevator_EventScript_To2F
	CompareVarToValue VAR_SPECIAL_RESULT, 10
	GoToIfEq SilphCo_Elevator_EventScript_To1F
	CompareVarToValue VAR_SPECIAL_RESULT, 11
	GoToIfEq SilphCo_Elevator_EventScript_ExitFloorSelect
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq SilphCo_Elevator_EventScript_ExitFloorSelect
	CloseMsg
	End
	
EventScript_GetElevatorFloor:
	Return
	
SilphCo_Elevator_EventScript_To11F:
	SetVar 0x8006, 14
	SetDynamicWarp MAP_CANVAS_SILPH_CO_11F, 2, 16, 3, 1
	CompareVarToValue 0x5032, 14
	GoToIfEq SilphCo_Elevator_EventScript_ExitFloorSelect
	Call SilphCo_Elevator_EventScript_MoveElevator
	SetVar 0x5032, 14
	GoTo SilphCo_Elevator_EventScript_ExitFloorSelect
	End
	
SilphCo_Elevator_EventScript_To10F:
	SetVar 0x8006, 13
	SetDynamicWarp MAP_CANVAS_SILPH_CO_10F, 5, 17, 3, 1
	CompareVarToValue 0x5032, 13
	GoToIfEq SilphCo_Elevator_EventScript_ExitFloorSelect
	Call SilphCo_Elevator_EventScript_MoveElevator
	SetVar 0x5032, 13
	GoTo SilphCo_Elevator_EventScript_ExitFloorSelect
	End
	
SilphCo_Elevator_EventScript_To9F:
	SetVar 0x8006, 12
	SetDynamicWarp MAP_CANVAS_SILPH_CO_9F, 4, 35, 3, 1
	CompareVarToValue 0x5032, 12
	GoToIfEq SilphCo_Elevator_EventScript_ExitFloorSelect
	Call SilphCo_Elevator_EventScript_MoveElevator
	SetVar 0x5032, 12
	GoTo SilphCo_Elevator_EventScript_ExitFloorSelect
	End
	
SilphCo_Elevator_EventScript_To8F:
	SetVar 0x8006, 11
	SetDynamicWarp MAP_CANVAS_SILPH_CO_8F, 6, 34, 3, 1
	CompareVarToValue 0x5032, 11
	GoToIfEq SilphCo_Elevator_EventScript_ExitFloorSelect
	Call SilphCo_Elevator_EventScript_MoveElevator
	SetVar 0x5032, 11
	GoTo SilphCo_Elevator_EventScript_ExitFloorSelect
	End
	
SilphCo_Elevator_EventScript_To7F:
	SetVar 0x8006, 10
	SetDynamicWarp MAP_CANVAS_SILPH_CO_7F, 5, 34, 3, 1
	CompareVarToValue 0x5032, 10
	GoToIfEq SilphCo_Elevator_EventScript_ExitFloorSelect
	Call SilphCo_Elevator_EventScript_MoveElevator
	SetVar 0x5032, 10
	GoTo SilphCo_Elevator_EventScript_ExitFloorSelect
	End
	
SilphCo_Elevator_EventScript_To6F:
	SetVar 0x8006, 9
	SetDynamicWarp MAP_CANVAS_SILPH_CO_6F, 4, 32, 3, 1
	CompareVarToValue 0x5032, 9
	GoToIfEq SilphCo_Elevator_EventScript_ExitFloorSelect
	Call SilphCo_Elevator_EventScript_MoveElevator
	SetVar 0x5032, 9
	GoTo SilphCo_Elevator_EventScript_ExitFloorSelect
	End
	
SilphCo_Elevator_EventScript_To5F:
	SetVar 0x8006, 8
	SetDynamicWarp MAP_CANVAS_SILPH_CO_5F, 6, 39, 3, 1
	CompareVarToValue 0x5032, 8
	GoToIfEq SilphCo_Elevator_EventScript_ExitFloorSelect
	Call SilphCo_Elevator_EventScript_MoveElevator
	SetVar 0x5032, 8
	GoTo SilphCo_Elevator_EventScript_ExitFloorSelect
	End
	
SilphCo_Elevator_EventScript_To4F:
	SetVar 0x8006, 7
	SetDynamicWarp MAP_CANVAS_SILPH_CO_4F, 6, 34, 3, 1
	CompareVarToValue 0x5032, 7
	GoToIfEq SilphCo_Elevator_EventScript_ExitFloorSelect
	Call SilphCo_Elevator_EventScript_MoveElevator
	SetVar 0x5032, 7
	GoTo SilphCo_Elevator_EventScript_ExitFloorSelect
	End
	
SilphCo_Elevator_EventScript_To3F:
	SetVar 0x8006, 6
	SetDynamicWarp MAP_CANVAS_SILPH_CO_3F, 9, 37, 3, 1
	CompareVarToValue 0x5032, 6
	GoToIfEq SilphCo_Elevator_EventScript_ExitFloorSelect
	Call SilphCo_Elevator_EventScript_MoveElevator
	SetVar 0x5032, 6
	GoTo SilphCo_Elevator_EventScript_ExitFloorSelect
	End
	
SilphCo_Elevator_EventScript_To2F:
	SetVar 0x8006, 5
	SetDynamicWarp MAP_CANVAS_SILPH_CO_2F, 6, 37, 3, 1
	CompareVarToValue 0x5032, 5
	GoToIfEq SilphCo_Elevator_EventScript_ExitFloorSelect
	Call SilphCo_Elevator_EventScript_MoveElevator
	SetVar 0x5032, 5
	GoTo SilphCo_Elevator_EventScript_ExitFloorSelect
	End
	
SilphCo_Elevator_EventScript_To1F:
	SetVar 0x8006, 4
	SetDynamicWarp MAP_SAFFRON_SILPH_CO_HQ, 1, 3, 2, 1
	CompareVarToValue 0x5032, 4
	GoToIfEq SilphCo_Elevator_EventScript_ExitFloorSelect
	Call SilphCo_Elevator_EventScript_MoveElevator
	SetVar 0x5032, 4
	GoTo SilphCo_Elevator_EventScript_ExitFloorSelect
	End
	
SilphCo_Elevator_EventScript_ExitFloorSelect:
	CanvasCloseMsg
	ReleaseAll
	End
	
SilphCo_Elevator_EventScript_MoveElevator:
	CanvasCloseMsg
	WaitSE SEQ_SE_DP_SELECT
	ElevatorAnim 1, 2
	SetFlag 2
	Return

_cv_stop:
	NPCMsg msg_0957_CV_CANVAS_SILPH_ELEVATOR_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
