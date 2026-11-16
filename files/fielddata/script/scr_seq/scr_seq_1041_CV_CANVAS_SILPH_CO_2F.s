#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SILPH_CO_2F.h"
#include "msgdata/msg/msg_0892_CV_CANVAS_SILPH_CO_2F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SilphCo_2F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SilphCo_2F_EventScript_ThunderWaveTutor
	ScrDef SilphCo_2F_EventScript_Door1
	ScrDef SilphCo_2F_EventScript_Door2
	ScrDef SilphCo_2F_EventScript_FloorSign
	ScrDef SilphCo_2F_OnLoad
	ScrDefEnd
	
SilphCo_2F_EventScript_ThunderWaveTutor:
	GoTo EventScript_ThunderWaveTutor
	End
	
SilphCo_2F_EventScript_Door1:
	LockAll
	SetVar 0x4001, 1
	SetVar 0x8004, 0
	GoToIfSet 0x2196, EventScript_DoorUnlocked
	GoTo EventScript_TryUnlockDoor
	End
	
SilphCo_2F_EventScript_Door2:
	LockAll
	SetVar 0x4001, 2
	SetVar 0x8004, 0
	GoToIfSet 0x2197, EventScript_DoorUnlocked
	GoTo EventScript_TryUnlockDoor
	End
	
SilphCo_2F_EventScript_FloorSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0892_CV_CANVAS_SILPH_CO_2F_SilphCo_2F_Text_FloorSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SilphCo_2F_OnLoad:
	CallIfUnset 0x2196, EventScript_Close2FDoor1
	CallIfUnset 0x2197, EventScript_Close2FDoor2
	End
	
EventScript_ThunderWaveTutor:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0892_CV_CANVAS_SILPH_CO_2F_Text_ThunderWaveTutor_Retired
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_DoorUnlocked:
	NPCMsg msg_0892_CV_CANVAS_SILPH_CO_2F_Text_TheDoorIsOpen
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_TryUnlockDoor:
	GoToIfSet 0x2198, EventScript_OpenDoor
	GoTo EventScript_NeedCardKey
	End
	
EventScript_Close2FDoor1:
	// TODO(gba) setmetatile 5, 8, METATILE_SilphCo_HorizontalBarrier_TopLeft, 1
	// TODO(gba) setmetatile 6, 8, METATILE_SilphCo_HorizontalBarrier_TopRight, 1
	// TODO(gba) setmetatile 5, 9, METATILE_SilphCo_HorizontalBarrier_BottomLeft, 1
	// TODO(gba) setmetatile 6, 9, METATILE_SilphCo_HorizontalBarrier_BottomRight, 1
	// TODO(gba) setmetatile 6, 10, METATILE_SilphCo_Floor_ShadeFull, 0
	Return
	
EventScript_Close2FDoor2:
	// TODO(gba) setmetatile 5, 15, METATILE_SilphCo_HorizontalBarrier_TopLeft, 1
	// TODO(gba) setmetatile 6, 15, METATILE_SilphCo_HorizontalBarrier_TopRight, 1
	// TODO(gba) setmetatile 5, 16, METATILE_SilphCo_HorizontalBarrier_BottomLeft, 1
	// TODO(gba) setmetatile 6, 16, METATILE_SilphCo_HorizontalBarrier_BottomRight, 1
	// TODO(gba) setmetatile 6, 17, METATILE_SilphCo_Floor_ShadeFull, 0
	Return
	
EventScript_OpenDoor:
	PlayFanfare SEQ_ME_LVUP
	NPCMsg msg_0892_CV_CANVAS_SILPH_CO_2F_Text_CardKeyOpenedDoor
	WaitButton
	WaitFanfare
	CompareVarToValue 0x4001, 1
	CallIfEq EventScript_Open2FDoor1
	CompareVarToValue 0x4001, 2
	CallIfEq EventScript_Open2FDoor2
	CompareVarToValue 0x4001, 3
	CallIfEq EventScript_Open3FDoor1
	CompareVarToValue 0x4001, 4
	CallIfEq EventScript_Open3FDoor2
	CompareVarToValue 0x4001, 5
	CallIfEq EventScript_Open4FDoor1
	CompareVarToValue 0x4001, 6
	CallIfEq EventScript_Open4FDoor2
	CompareVarToValue 0x4001, 7
	CallIfEq EventScript_Open5FDoor1
	CompareVarToValue 0x4001, 8
	CallIfEq EventScript_Open5FDoor2
	CompareVarToValue 0x4001, 9
	CallIfEq EventScript_Open5FDoor3
	CompareVarToValue 0x4001, 10
	CallIfEq EventScript_Open6FDoor
	CompareVarToValue 0x4001, 11
	CallIfEq EventScript_Open7FDoor1
	CompareVarToValue 0x4001, 12
	CallIfEq EventScript_Open7FDoor2
	CompareVarToValue 0x4001, 13
	CallIfEq EventScript_Open7FDoor3
	CompareVarToValue 0x4001, 14
	CallIfEq EventScript_Open8FDoor
	CompareVarToValue 0x4001, 15
	CallIfEq EventScript_Open9FDoor1
	CompareVarToValue 0x4001, 16
	CallIfEq EventScript_Open9FDoor2
	CompareVarToValue 0x4001, 17
	CallIfEq EventScript_Open9FDoor3
	CompareVarToValue 0x4001, 18
	CallIfEq EventScript_Open9FDoor4
	CompareVarToValue 0x4001, 19
	CallIfEq EventScript_Open10FDoor
	CompareVarToValue 0x4001, 20
	CallIfEq EventScript_Open11FDoor
	WaitSE SEQ_SE_DP_SELECT
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	// TODO(gba) special SetHiddenItemFlag
	GoTo _cv_stop
	CloseMsg
	ReleaseAll
	End
	
EventScript_NeedCardKey:
	NPCMsg msg_0892_CV_CANVAS_SILPH_CO_2F_Text_ItNeedsCardKey
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_Open2FDoor1:
	// TODO(gba) setmetatile 5, 8, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 6, 8, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 5, 9, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 6, 9, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 6, 10, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	Return
	
EventScript_Open2FDoor2:
	// TODO(gba) setmetatile 5, 15, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 6, 15, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 5, 16, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 6, 16, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 6, 17, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	Return
	
EventScript_Open3FDoor1:
	// TODO(gba) setmetatile 9, 11, METATILE_SilphCo_Wall_LeftEdge, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 10, 11, METATILE_SilphCo_Wall_RightEdge, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 9, 12, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 10, 12, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 9, 13, METATILE_SilphCo_Floor_WallLeftCorner, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 10, 13, METATILE_SilphCo_Floor_WallRightCorner, 0
	GoTo _cv_stop
	Return
	
EventScript_Open3FDoor2:
	// TODO(gba) setmetatile 20, 11, METATILE_SilphCo_Wall_LeftEdge, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 21, 11, METATILE_SilphCo_Wall_RightEdge, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 20, 12, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 21, 12, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 20, 13, METATILE_SilphCo_Floor_WallLeftCorner, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 21, 13, METATILE_SilphCo_Floor_WallRightCorner, 0
	GoTo _cv_stop
	Return
	
EventScript_Open4FDoor1:
	// TODO(gba) setmetatile 3, 16, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 4, 16, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 3, 17, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 4, 17, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 4, 18, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	Return
	
EventScript_Open4FDoor2:
	// TODO(gba) setmetatile 14, 11, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 15, 11, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 14, 12, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 15, 12, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 15, 13, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	Return
	
EventScript_Open5FDoor1:
	// TODO(gba) setmetatile 7, 8, METATILE_SilphCo_Wall_LeftEdge, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 8, 8, METATILE_SilphCo_Wall_RightEdge, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 7, 9, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 8, 9, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 7, 10, METATILE_SilphCo_Floor_WallLeftCorner, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 8, 10, METATILE_SilphCo_Floor_WallRightCorner, 0
	GoTo _cv_stop
	Return
	
EventScript_Open5FDoor2:
	// TODO(gba) setmetatile 7, 17, METATILE_SilphCo_Wall_LeftEdge, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 8, 17, METATILE_SilphCo_Wall_RightEdge, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 7, 18, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 8, 18, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 7, 19, METATILE_SilphCo_Floor_WallLeftCorner, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 8, 19, METATILE_SilphCo_Floor_WallRightCorner, 0
	GoTo _cv_stop
	Return
	
EventScript_Open5FDoor3:
	// TODO(gba) setmetatile 18, 12, METATILE_SilphCo_Wall_LeftEdge, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 19, 12, METATILE_SilphCo_Wall_RightEdge, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 18, 13, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 19, 13, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 18, 14, METATILE_SilphCo_Floor_WallLeftCorner, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 19, 14, METATILE_SilphCo_Floor_WallRightCorner, 0
	GoTo _cv_stop
	Return
	
EventScript_Open6FDoor:
	// TODO(gba) setmetatile 5, 14, METATILE_SilphCo_Wall_LeftEdge, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 6, 14, METATILE_SilphCo_Wall_RightEdge, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 5, 15, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 6, 15, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 5, 16, METATILE_SilphCo_Floor_WallLeftCorner, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 6, 16, METATILE_SilphCo_Floor_WallRightCorner, 0
	GoTo _cv_stop
	Return
	
EventScript_Open7FDoor1:
	// TODO(gba) setmetatile 11, 8, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 12, 8, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 11, 9, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 12, 9, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 12, 10, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	Return
	
EventScript_Open7FDoor2:
	// TODO(gba) setmetatile 24, 7, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 25, 7, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 24, 8, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 25, 8, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 25, 9, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	Return
	
EventScript_Open7FDoor3:
	// TODO(gba) setmetatile 25, 13, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 26, 13, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 25, 14, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 26, 14, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 26, 15, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	Return
	
EventScript_Open8FDoor:
	// TODO(gba) setmetatile 5, 9, METATILE_SilphCo_Wall_LeftEdge, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 6, 9, METATILE_SilphCo_Wall_RightEdge, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 5, 10, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 6, 10, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 5, 11, METATILE_SilphCo_Floor_WallLeftCorner, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 6, 11, METATILE_SilphCo_Floor_WallRightCorner, 0
	GoTo _cv_stop
	Return
	
EventScript_Open9FDoor1:
	// TODO(gba) setmetatile 2, 9, METATILE_SilphCo_Wall_LeftEdge, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 3, 9, METATILE_SilphCo_Wall_RightEdge, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 2, 10, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 3, 10, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 2, 11, METATILE_SilphCo_Floor_WallLeftCorner, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 3, 11, METATILE_SilphCo_Floor_WallRightCorner, 0
	GoTo _cv_stop
	Return
	
EventScript_Open9FDoor2:
	// TODO(gba) setmetatile 12, 15, METATILE_SilphCo_Wall_LeftEdge, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 13, 15, METATILE_SilphCo_Wall_RightEdge, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 12, 16, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 13, 16, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 12, 17, METATILE_SilphCo_Floor_WallLeftCorner, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 13, 17, METATILE_SilphCo_Floor_WallRightCorner, 0
	GoTo _cv_stop
	Return
	
EventScript_Open9FDoor3:
	// TODO(gba) setmetatile 21, 6, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 22, 6, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 21, 7, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 22, 7, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 22, 8, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	Return
	
EventScript_Open9FDoor4:
	// TODO(gba) setmetatile 21, 12, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 22, 12, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 21, 13, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 22, 13, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 22, 14, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	Return
	
EventScript_Open10FDoor:
	// TODO(gba) setmetatile 12, 11, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 13, 11, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 12, 12, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 13, 12, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 13, 13, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	Return
	
EventScript_Open11FDoor:
	// TODO(gba) setmetatile 5, 16, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 6, 16, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 5, 17, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 6, 17, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 6, 18, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	Return

_cv_stop:
	NPCMsg msg_0892_CV_CANVAS_SILPH_CO_2F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
