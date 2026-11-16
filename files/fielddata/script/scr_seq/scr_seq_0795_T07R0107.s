#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T07R0107.h"
#include "msgdata/msg/msg_0500_T07R0107.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's CeladonCity_DepartmentStore_Elevator_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef CeladonCity_DepartmentStore_Elevator_EventScript_FloorSelect
	ScrDefEnd
	
CeladonCity_DepartmentStore_Elevator_EventScript_FloorSelect:
	LockAll
	SetVar 0x8004, 3
	CallIfUnset 2, EventScript_GetElevatorFloor
	CopyVar 0x8005, 0x5032
	// TODO(gba) special DrawElevatorCurrentFloorWindow
	GoTo _cv_stop
	NPCMsg msg_0500_T07R0107_gText_WantWhichFloor
	SetVar 0x8004, 3
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar InitElevatorFloorSelectMenuPos
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CeladonCity_DepartmentStore_Elevator_EventScript_FloorSelectFrom5F
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq CeladonCity_DepartmentStore_Elevator_EventScript_FloorSelectFrom4F
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq CeladonCity_DepartmentStore_Elevator_EventScript_FloorSelectFrom3F
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfEq CeladonCity_DepartmentStore_Elevator_EventScript_FloorSelectFrom2F
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfEq CeladonCity_DepartmentStore_Elevator_EventScript_FloorSelectFrom1F
	CloseMsg
	End
	
EventScript_GetElevatorFloor:
	// TODO(gba) special GetElevatorFloor
	GoTo _cv_stop
	Return
	
CeladonCity_DepartmentStore_Elevator_EventScript_FloorSelectFrom5F:
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0500_T07R0107_cv_mc_dept_store_elevator_0, 0
	ScrCmd_559 msg_0500_T07R0107_cv_mc_dept_store_elevator_1, 1
	ScrCmd_559 msg_0500_T07R0107_cv_mc_dept_store_elevator_2, 2
	ScrCmd_559 msg_0500_T07R0107_cv_mc_dept_store_elevator_3, 3
	ScrCmd_559 msg_0500_T07R0107_cv_mc_dept_store_elevator_4, 4
	ScrCmd_559 msg_0500_T07R0107_cv_mc_dept_store_elevator_5, 5
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_2
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_2:
	GoTo CeladonCity_DepartmentStore_Elevator_EventScript_ChooseFloor
	End
	
CeladonCity_DepartmentStore_Elevator_EventScript_FloorSelectFrom4F:
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 1, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0500_T07R0107_cv_mc_dept_store_elevator_0, 0
	ScrCmd_559 msg_0500_T07R0107_cv_mc_dept_store_elevator_1, 1
	ScrCmd_559 msg_0500_T07R0107_cv_mc_dept_store_elevator_2, 2
	ScrCmd_559 msg_0500_T07R0107_cv_mc_dept_store_elevator_3, 3
	ScrCmd_559 msg_0500_T07R0107_cv_mc_dept_store_elevator_4, 4
	ScrCmd_559 msg_0500_T07R0107_cv_mc_dept_store_elevator_5, 5
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_4
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_4:
	GoTo CeladonCity_DepartmentStore_Elevator_EventScript_ChooseFloor
	End
	
CeladonCity_DepartmentStore_Elevator_EventScript_FloorSelectFrom3F:
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 2, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0500_T07R0107_cv_mc_dept_store_elevator_0, 0
	ScrCmd_559 msg_0500_T07R0107_cv_mc_dept_store_elevator_1, 1
	ScrCmd_559 msg_0500_T07R0107_cv_mc_dept_store_elevator_2, 2
	ScrCmd_559 msg_0500_T07R0107_cv_mc_dept_store_elevator_3, 3
	ScrCmd_559 msg_0500_T07R0107_cv_mc_dept_store_elevator_4, 4
	ScrCmd_559 msg_0500_T07R0107_cv_mc_dept_store_elevator_5, 5
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_6
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_6:
	GoTo CeladonCity_DepartmentStore_Elevator_EventScript_ChooseFloor
	End
	
CeladonCity_DepartmentStore_Elevator_EventScript_FloorSelectFrom2F:
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 3, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0500_T07R0107_cv_mc_dept_store_elevator_0, 0
	ScrCmd_559 msg_0500_T07R0107_cv_mc_dept_store_elevator_1, 1
	ScrCmd_559 msg_0500_T07R0107_cv_mc_dept_store_elevator_2, 2
	ScrCmd_559 msg_0500_T07R0107_cv_mc_dept_store_elevator_3, 3
	ScrCmd_559 msg_0500_T07R0107_cv_mc_dept_store_elevator_4, 4
	ScrCmd_559 msg_0500_T07R0107_cv_mc_dept_store_elevator_5, 5
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_8
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_8:
	GoTo CeladonCity_DepartmentStore_Elevator_EventScript_ChooseFloor
	End
	
CeladonCity_DepartmentStore_Elevator_EventScript_FloorSelectFrom1F:
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 4, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0500_T07R0107_cv_mc_dept_store_elevator_0, 0
	ScrCmd_559 msg_0500_T07R0107_cv_mc_dept_store_elevator_1, 1
	ScrCmd_559 msg_0500_T07R0107_cv_mc_dept_store_elevator_2, 2
	ScrCmd_559 msg_0500_T07R0107_cv_mc_dept_store_elevator_3, 3
	ScrCmd_559 msg_0500_T07R0107_cv_mc_dept_store_elevator_4, 4
	ScrCmd_559 msg_0500_T07R0107_cv_mc_dept_store_elevator_5, 5
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_10
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_10:
	GoTo CeladonCity_DepartmentStore_Elevator_EventScript_ChooseFloor
	End
	
CeladonCity_DepartmentStore_Elevator_EventScript_ChooseFloor:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CeladonCity_DepartmentStore_Elevator_EventScript_To5F
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq CeladonCity_DepartmentStore_Elevator_EventScript_To4F
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq CeladonCity_DepartmentStore_Elevator_EventScript_To3F
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfEq CeladonCity_DepartmentStore_Elevator_EventScript_To2F
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfEq CeladonCity_DepartmentStore_Elevator_EventScript_To1F
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfEq CeladonCity_DepartmentStore_Elevator_EventScript_ExitFloorSelect
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq CeladonCity_DepartmentStore_Elevator_EventScript_ExitFloorSelect
	End
	
CeladonCity_DepartmentStore_Elevator_EventScript_To5F:
	SetVar 0x8006, 8
	// TODO(gba) setdynamicwarp MAP_CELADON_CITY_DEPARTMENT_STORE_5F, 255, 6, 1
	GoTo _cv_stop
	CompareVarToValue 0x5032, 8
	GoToIfEq CeladonCity_DepartmentStore_Elevator_EventScript_ExitFloorSelect
	Call CeladonCity_DepartmentStore_Elevator_EventScript_MoveElevator
	SetVar 0x5032, 8
	GoTo CeladonCity_DepartmentStore_Elevator_EventScript_ExitFloorSelect
	End
	
CeladonCity_DepartmentStore_Elevator_EventScript_To4F:
	SetVar 0x8006, 7
	// TODO(gba) setdynamicwarp MAP_CELADON_CITY_DEPARTMENT_STORE_4F, 255, 6, 1
	GoTo _cv_stop
	CompareVarToValue 0x5032, 7
	GoToIfEq CeladonCity_DepartmentStore_Elevator_EventScript_ExitFloorSelect
	Call CeladonCity_DepartmentStore_Elevator_EventScript_MoveElevator
	SetVar 0x5032, 7
	GoTo CeladonCity_DepartmentStore_Elevator_EventScript_ExitFloorSelect
	End
	
CeladonCity_DepartmentStore_Elevator_EventScript_To3F:
	SetVar 0x8006, 6
	// TODO(gba) setdynamicwarp MAP_CELADON_CITY_DEPARTMENT_STORE_3F, 255, 6, 1
	GoTo _cv_stop
	CompareVarToValue 0x5032, 6
	GoToIfEq CeladonCity_DepartmentStore_Elevator_EventScript_ExitFloorSelect
	Call CeladonCity_DepartmentStore_Elevator_EventScript_MoveElevator
	SetVar 0x5032, 6
	GoTo CeladonCity_DepartmentStore_Elevator_EventScript_ExitFloorSelect
	End
	
CeladonCity_DepartmentStore_Elevator_EventScript_To2F:
	SetVar 0x8006, 5
	// TODO(gba) setdynamicwarp MAP_CELADON_CITY_DEPARTMENT_STORE_2F, 255, 6, 1
	GoTo _cv_stop
	CompareVarToValue 0x5032, 5
	GoToIfEq CeladonCity_DepartmentStore_Elevator_EventScript_ExitFloorSelect
	Call CeladonCity_DepartmentStore_Elevator_EventScript_MoveElevator
	SetVar 0x5032, 5
	GoTo CeladonCity_DepartmentStore_Elevator_EventScript_ExitFloorSelect
	End
	
CeladonCity_DepartmentStore_Elevator_EventScript_To1F:
	SetVar 0x8006, 4
	// TODO(gba) setdynamicwarp MAP_CELADON_CITY_DEPARTMENT_STORE_1F, 255, 6, 1
	GoTo _cv_stop
	CompareVarToValue 0x5032, 4
	GoToIfEq CeladonCity_DepartmentStore_Elevator_EventScript_ExitFloorSelect
	Call CeladonCity_DepartmentStore_Elevator_EventScript_MoveElevator
	SetVar 0x5032, 4
	GoTo CeladonCity_DepartmentStore_Elevator_EventScript_ExitFloorSelect
	End
	
CeladonCity_DepartmentStore_Elevator_EventScript_ExitFloorSelect:
	// TODO(gba) special CloseElevatorCurrentFloorWindow
	GoTo _cv_stop
	ReleaseAll
	End
	
CeladonCity_DepartmentStore_Elevator_EventScript_MoveElevator:
	// TODO(gba) special CloseElevatorCurrentFloorWindow
	GoTo _cv_stop
	CloseMsg
	WaitSE SEQ_SE_DP_SELECT
	// TODO(gba) special AnimateElevator
	GoTo _cv_stop
	SetFlag 2
	Return

_cv_stop:
	NPCMsg msg_0500_T07R0107_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
