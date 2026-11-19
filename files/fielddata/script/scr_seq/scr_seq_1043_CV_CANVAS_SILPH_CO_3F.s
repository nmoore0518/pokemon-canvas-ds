#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SILPH_CO_3F.h"
#include "msgdata/msg/msg_0893_CV_CANVAS_SILPH_CO_3F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SilphCo_3F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SilphCo_3F_EventScript_WorkerM
	ScrDef SilphCo_3F_EventScript_ItemHyperPotion
	ScrDef SilphCo_3F_EventScript_Door1
	ScrDef SilphCo_3F_EventScript_Door2
	ScrDef SilphCo_3F_EventScript_FloorSign
	ScrDef SilphCo_3F_OnLoad
	ScrDef SilphCo_3F_Frlg_cv_Barriers
	ScrDefEnd
	
SilphCo_3F_EventScript_WorkerM:
	LockAll
	FacePlayer
	CompareVarToValue 0x5031, 1
	GoToIfGe SilphCo_3F_EventScript_WorkerMRocketsGone
	NPCMsg msg_0893_CV_CANVAS_SILPH_CO_3F_SilphCo_3F_Text_WhatAmIToDo
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SilphCo_3F_EventScript_ItemHyperPotion:
	SetVar 0x8004, ITEM_HYPER_POTION
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
SilphCo_3F_EventScript_Door1:
	LockAll
	SetVar 0x4001, 3
	SetVar 0x8004, 0x219A
	GoToIfSet 0x219A, EventScript_DoorUnlocked
	GoTo EventScript_TryUnlockDoor
	End
	
SilphCo_3F_EventScript_Door2:
	LockAll
	SetVar 0x4001, 4
	SetVar 0x8004, 0x219B
	GoToIfSet 0x219B, EventScript_DoorUnlocked
	GoTo EventScript_TryUnlockDoor
	End
	
SilphCo_3F_EventScript_FloorSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0893_CV_CANVAS_SILPH_CO_3F_SilphCo_3F_Text_FloorSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SilphCo_3F_OnLoad:
	CallIfUnset 0x219A, EventScript_Close3FDoor1
	CallIfUnset 0x219B, EventScript_Close3FDoor2
	End
	
SilphCo_3F_Frlg_cv_Barriers:
	SetVar 0x5044, 1
	SetFlag 0x2270
	SetFlag 0x2271
	SetFlag 0x2272
	SetFlag 0x2273
	SetFlag 0x2274
	SetFlag 0x2275
	SetFlag 0x2276
	SetFlag 0x2277
	Call SilphCo_3F_OnLoad_cv_init
	SetVar 0x5044, 0
	End
	
SilphCo_3F_EventScript_WorkerMRocketsGone:
	BufferPlayersName 6
	NPCMsg msg_0893_CV_CANVAS_SILPH_CO_3F_SilphCo_3F_Text_YouAndYourMonsSavedUs
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_DoorUnlocked:
	NPCMsg msg_0893_CV_CANVAS_SILPH_CO_3F_Text_TheDoorIsOpen
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_TryUnlockDoor:
	GoToIfSet 0x2198, EventScript_OpenDoor
	GoTo EventScript_NeedCardKey
	End
	
EventScript_Close3FDoor1:
	// (the GBA redraws a square here: 9, 11, METATILE_SilphCo_VerticalBarrier_TopLeft, 1)
	// (the GBA redraws a square here: 10, 11, METATILE_SilphCo_VerticalBarrier_TopRight, 1)
	GoToIfUnset 0x2270, _cv_bar_1
	ClearFlag 0x2270
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_1
	ShowPerson 200
_cv_bar_1:
	GoToIfUnset 0x2271, _cv_bar_2
	ClearFlag 0x2271
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_2
	ShowPerson 201
_cv_bar_2:
	GoToIfUnset 0x2274, _cv_bar_3
	ClearFlag 0x2274
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_3
	ShowPerson 204
_cv_bar_3:
	GoToIfUnset 0x2275, _cv_bar_4
	ClearFlag 0x2275
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_4
	ShowPerson 205
_cv_bar_4:
	Return
	
EventScript_Close3FDoor2:
	// (the GBA redraws a square here: 20, 11, METATILE_SilphCo_VerticalBarrier_TopLeft, 1)
	// (the GBA redraws a square here: 21, 11, METATILE_SilphCo_VerticalBarrier_TopRight, 1)
	GoToIfUnset 0x2272, _cv_bar_5
	ClearFlag 0x2272
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_5
	ShowPerson 202
_cv_bar_5:
	GoToIfUnset 0x2273, _cv_bar_6
	ClearFlag 0x2273
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_6
	ShowPerson 203
_cv_bar_6:
	GoToIfUnset 0x2276, _cv_bar_7
	ClearFlag 0x2276
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_7
	ShowPerson 206
_cv_bar_7:
	GoToIfUnset 0x2277, _cv_bar_8
	ClearFlag 0x2277
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_8
	ShowPerson 207
_cv_bar_8:
	Return
	
SilphCo_3F_OnLoad_cv_init:
	CallIfUnset 0x219A, EventScript_Close3FDoor1
	CallIfUnset 0x219B, EventScript_Close3FDoor2
	Return
	
EventScript_OpenDoor:
	PlayFanfare SEQ_ME_LVUP
	NPCMsg msg_0893_CV_CANVAS_SILPH_CO_3F_Text_CardKeyOpenedDoor
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
	SetFlagVar 0x8004
	CloseMsg
	ReleaseAll
	End
	
EventScript_NeedCardKey:
	NPCMsg msg_0893_CV_CANVAS_SILPH_CO_3F_Text_ItNeedsCardKey
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_Open2FDoor1:
	// (the GBA redraws a square here: 5, 8, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 6, 8, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 5, 9, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 6, 9, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 6, 10, METATILE_SilphCo_Floor, 0)
	Return
	
EventScript_Open2FDoor2:
	// (the GBA redraws a square here: 5, 15, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 6, 15, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 5, 16, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 6, 16, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 6, 17, METATILE_SilphCo_Floor, 0)
	Return
	
EventScript_Open3FDoor1:
	// (the GBA redraws a square here: 9, 11, METATILE_SilphCo_Wall_LeftEdge, 1)
	// (the GBA redraws a square here: 10, 11, METATILE_SilphCo_Wall_RightEdge, 1)
	GoToIfSet 0x2270, _cv_bar_9
	SetFlag 0x2270
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_9
	HidePerson 200
_cv_bar_9:
	GoToIfSet 0x2271, _cv_bar_10
	SetFlag 0x2271
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_10
	HidePerson 201
_cv_bar_10:
	GoToIfSet 0x2274, _cv_bar_11
	SetFlag 0x2274
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_11
	HidePerson 204
_cv_bar_11:
	GoToIfSet 0x2275, _cv_bar_12
	SetFlag 0x2275
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_12
	HidePerson 205
_cv_bar_12:
	Return
	
EventScript_Open3FDoor2:
	// (the GBA redraws a square here: 20, 11, METATILE_SilphCo_Wall_LeftEdge, 1)
	// (the GBA redraws a square here: 21, 11, METATILE_SilphCo_Wall_RightEdge, 1)
	GoToIfSet 0x2272, _cv_bar_13
	SetFlag 0x2272
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_13
	HidePerson 202
_cv_bar_13:
	GoToIfSet 0x2273, _cv_bar_14
	SetFlag 0x2273
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_14
	HidePerson 203
_cv_bar_14:
	GoToIfSet 0x2276, _cv_bar_15
	SetFlag 0x2276
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_15
	HidePerson 206
_cv_bar_15:
	GoToIfSet 0x2277, _cv_bar_16
	SetFlag 0x2277
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_16
	HidePerson 207
_cv_bar_16:
	Return
	
EventScript_Open4FDoor1:
	// (the GBA redraws a square here: 3, 16, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 4, 16, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 3, 17, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 4, 17, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 4, 18, METATILE_SilphCo_Floor, 0)
	Return
	
EventScript_Open4FDoor2:
	// (the GBA redraws a square here: 14, 11, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 15, 11, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 14, 12, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 15, 12, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 15, 13, METATILE_SilphCo_Floor, 0)
	Return
	
EventScript_Open5FDoor1:
	// (the GBA redraws a square here: 7, 8, METATILE_SilphCo_Wall_LeftEdge, 1)
	// (the GBA redraws a square here: 8, 8, METATILE_SilphCo_Wall_RightEdge, 1)
	// (the GBA redraws a square here: 7, 9, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 8, 9, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 7, 10, METATILE_SilphCo_Floor_WallLeftCorner, 0)
	// (the GBA redraws a square here: 8, 10, METATILE_SilphCo_Floor_WallRightCorner, 0)
	Return
	
EventScript_Open5FDoor2:
	// (the GBA redraws a square here: 7, 17, METATILE_SilphCo_Wall_LeftEdge, 1)
	// (the GBA redraws a square here: 8, 17, METATILE_SilphCo_Wall_RightEdge, 1)
	// (the GBA redraws a square here: 7, 18, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 8, 18, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 7, 19, METATILE_SilphCo_Floor_WallLeftCorner, 0)
	// (the GBA redraws a square here: 8, 19, METATILE_SilphCo_Floor_WallRightCorner, 0)
	Return
	
EventScript_Open5FDoor3:
	// (the GBA redraws a square here: 18, 12, METATILE_SilphCo_Wall_LeftEdge, 1)
	// (the GBA redraws a square here: 19, 12, METATILE_SilphCo_Wall_RightEdge, 1)
	// (the GBA redraws a square here: 18, 13, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 19, 13, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 18, 14, METATILE_SilphCo_Floor_WallLeftCorner, 0)
	// (the GBA redraws a square here: 19, 14, METATILE_SilphCo_Floor_WallRightCorner, 0)
	Return
	
EventScript_Open6FDoor:
	// (the GBA redraws a square here: 5, 14, METATILE_SilphCo_Wall_LeftEdge, 1)
	// (the GBA redraws a square here: 6, 14, METATILE_SilphCo_Wall_RightEdge, 1)
	// (the GBA redraws a square here: 5, 15, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 6, 15, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 5, 16, METATILE_SilphCo_Floor_WallLeftCorner, 0)
	// (the GBA redraws a square here: 6, 16, METATILE_SilphCo_Floor_WallRightCorner, 0)
	Return
	
EventScript_Open7FDoor1:
	// (the GBA redraws a square here: 11, 8, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 12, 8, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 11, 9, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 12, 9, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 12, 10, METATILE_SilphCo_Floor, 0)
	Return
	
EventScript_Open7FDoor2:
	// (the GBA redraws a square here: 24, 7, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 25, 7, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 24, 8, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 25, 8, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 25, 9, METATILE_SilphCo_Floor, 0)
	Return
	
EventScript_Open7FDoor3:
	// (the GBA redraws a square here: 25, 13, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 26, 13, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 25, 14, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 26, 14, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 26, 15, METATILE_SilphCo_Floor, 0)
	Return
	
EventScript_Open8FDoor:
	// (the GBA redraws a square here: 5, 9, METATILE_SilphCo_Wall_LeftEdge, 1)
	// (the GBA redraws a square here: 6, 9, METATILE_SilphCo_Wall_RightEdge, 1)
	// (the GBA redraws a square here: 5, 10, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 6, 10, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 5, 11, METATILE_SilphCo_Floor_WallLeftCorner, 0)
	// (the GBA redraws a square here: 6, 11, METATILE_SilphCo_Floor_WallRightCorner, 0)
	Return
	
EventScript_Open9FDoor1:
	// (the GBA redraws a square here: 2, 9, METATILE_SilphCo_Wall_LeftEdge, 1)
	// (the GBA redraws a square here: 3, 9, METATILE_SilphCo_Wall_RightEdge, 1)
	// (the GBA redraws a square here: 2, 10, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 3, 10, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 2, 11, METATILE_SilphCo_Floor_WallLeftCorner, 0)
	// (the GBA redraws a square here: 3, 11, METATILE_SilphCo_Floor_WallRightCorner, 0)
	Return
	
EventScript_Open9FDoor2:
	// (the GBA redraws a square here: 12, 15, METATILE_SilphCo_Wall_LeftEdge, 1)
	// (the GBA redraws a square here: 13, 15, METATILE_SilphCo_Wall_RightEdge, 1)
	// (the GBA redraws a square here: 12, 16, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 13, 16, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 12, 17, METATILE_SilphCo_Floor_WallLeftCorner, 0)
	// (the GBA redraws a square here: 13, 17, METATILE_SilphCo_Floor_WallRightCorner, 0)
	Return
	
EventScript_Open9FDoor3:
	// (the GBA redraws a square here: 21, 6, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 22, 6, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 21, 7, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 22, 7, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 22, 8, METATILE_SilphCo_Floor, 0)
	Return
	
EventScript_Open9FDoor4:
	GoToIfSet 0x2273, _cv_bar_17
	SetFlag 0x2273
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_17
	HidePerson 203
_cv_bar_17:
	// (the GBA redraws a square here: 22, 12, METATILE_SilphCo_Floor, 0)
	GoToIfSet 0x2277, _cv_bar_18
	SetFlag 0x2277
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_18
	HidePerson 207
_cv_bar_18:
	// (the GBA redraws a square here: 22, 13, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 22, 14, METATILE_SilphCo_Floor, 0)
	Return
	
EventScript_Open10FDoor:
	// (the GBA redraws a square here: 12, 11, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 13, 11, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 12, 12, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 13, 12, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 13, 13, METATILE_SilphCo_Floor, 0)
	Return
	
EventScript_Open11FDoor:
	// (the GBA redraws a square here: 5, 16, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 6, 16, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 5, 17, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 6, 17, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 6, 18, METATILE_SilphCo_Floor, 0)
	Return

_cv_stop:
	NPCMsg msg_0893_CV_CANVAS_SILPH_CO_3F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
