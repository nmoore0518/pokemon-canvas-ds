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
	ScrDef SilphCo_2F_Frlg_cv_Barriers
	ScrDefEnd
	
SilphCo_2F_EventScript_ThunderWaveTutor:
	GoTo EventScript_ThunderWaveTutor
	End
	
SilphCo_2F_EventScript_Door1:
	LockAll
	SetVar 0x4001, 1
	SetVar 0x8004, 0x2196
	GoToIfSet 0x2196, EventScript_DoorUnlocked
	GoTo EventScript_TryUnlockDoor
	End
	
SilphCo_2F_EventScript_Door2:
	LockAll
	SetVar 0x4001, 2
	SetVar 0x8004, 0x2197
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
	
SilphCo_2F_Frlg_cv_Barriers:
	SetVar 0x5044, 1
	SetFlag 0x2238
	SetFlag 0x2239
	SetFlag 0x223A
	SetFlag 0x223B
	SetFlag 0x223C
	SetFlag 0x223D
	SetFlag 0x223E
	SetFlag 0x223F
	Call SilphCo_2F_OnLoad_cv_init
	SetVar 0x5044, 0
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
	GoToIfUnset 0x2238, _cv_bar_1
	ClearFlag 0x2238
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_1
	ShowPerson 200
_cv_bar_1:
	GoToIfUnset 0x2239, _cv_bar_2
	ClearFlag 0x2239
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_2
	ShowPerson 201
_cv_bar_2:
	GoToIfUnset 0x223A, _cv_bar_3
	ClearFlag 0x223A
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_3
	ShowPerson 202
_cv_bar_3:
	GoToIfUnset 0x223B, _cv_bar_4
	ClearFlag 0x223B
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_4
	ShowPerson 203
_cv_bar_4:
	// (the GBA redraws a square here: 6, 10, METATILE_SilphCo_Floor_ShadeFull, 0)
	Return
	
EventScript_Close2FDoor2:
	GoToIfUnset 0x223C, _cv_bar_5
	ClearFlag 0x223C
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_5
	ShowPerson 204
_cv_bar_5:
	GoToIfUnset 0x223D, _cv_bar_6
	ClearFlag 0x223D
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_6
	ShowPerson 205
_cv_bar_6:
	GoToIfUnset 0x223E, _cv_bar_7
	ClearFlag 0x223E
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_7
	ShowPerson 206
_cv_bar_7:
	GoToIfUnset 0x223F, _cv_bar_8
	ClearFlag 0x223F
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_8
	ShowPerson 207
_cv_bar_8:
	// (the GBA redraws a square here: 6, 17, METATILE_SilphCo_Floor_ShadeFull, 0)
	Return
	
SilphCo_2F_OnLoad_cv_init:
	CallIfUnset 0x2196, EventScript_Close2FDoor1
	CallIfUnset 0x2197, EventScript_Close2FDoor2
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
	SetFlagVar 0x8004
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
	GoToIfSet 0x2238, _cv_bar_9
	SetFlag 0x2238
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_9
	HidePerson 200
_cv_bar_9:
	GoToIfSet 0x2239, _cv_bar_10
	SetFlag 0x2239
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_10
	HidePerson 201
_cv_bar_10:
	GoToIfSet 0x223A, _cv_bar_11
	SetFlag 0x223A
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_11
	HidePerson 202
_cv_bar_11:
	GoToIfSet 0x223B, _cv_bar_12
	SetFlag 0x223B
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_12
	HidePerson 203
_cv_bar_12:
	// (the GBA redraws a square here: 6, 10, METATILE_SilphCo_Floor, 0)
	Return
	
EventScript_Open2FDoor2:
	GoToIfSet 0x223C, _cv_bar_13
	SetFlag 0x223C
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_13
	HidePerson 204
_cv_bar_13:
	GoToIfSet 0x223D, _cv_bar_14
	SetFlag 0x223D
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_14
	HidePerson 205
_cv_bar_14:
	GoToIfSet 0x223E, _cv_bar_15
	SetFlag 0x223E
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_15
	HidePerson 206
_cv_bar_15:
	GoToIfSet 0x223F, _cv_bar_16
	SetFlag 0x223F
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_16
	HidePerson 207
_cv_bar_16:
	// (the GBA redraws a square here: 6, 17, METATILE_SilphCo_Floor, 0)
	Return
	
EventScript_Open3FDoor1:
	// (the GBA redraws a square here: 9, 11, METATILE_SilphCo_Wall_LeftEdge, 1)
	// (the GBA redraws a square here: 10, 11, METATILE_SilphCo_Wall_RightEdge, 1)
	// (the GBA redraws a square here: 9, 12, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 10, 12, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 9, 13, METATILE_SilphCo_Floor_WallLeftCorner, 0)
	// (the GBA redraws a square here: 10, 13, METATILE_SilphCo_Floor_WallRightCorner, 0)
	Return
	
EventScript_Open3FDoor2:
	// (the GBA redraws a square here: 20, 11, METATILE_SilphCo_Wall_LeftEdge, 1)
	// (the GBA redraws a square here: 21, 11, METATILE_SilphCo_Wall_RightEdge, 1)
	// (the GBA redraws a square here: 20, 12, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 21, 12, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 20, 13, METATILE_SilphCo_Floor_WallLeftCorner, 0)
	// (the GBA redraws a square here: 21, 13, METATILE_SilphCo_Floor_WallRightCorner, 0)
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
	GoToIfSet 0x223C, _cv_bar_17
	SetFlag 0x223C
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_17
	HidePerson 204
_cv_bar_17:
	GoToIfSet 0x223D, _cv_bar_18
	SetFlag 0x223D
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_18
	HidePerson 205
_cv_bar_18:
	GoToIfSet 0x223E, _cv_bar_19
	SetFlag 0x223E
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_19
	HidePerson 206
_cv_bar_19:
	GoToIfSet 0x223F, _cv_bar_20
	SetFlag 0x223F
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_20
	HidePerson 207
_cv_bar_20:
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
	GoToIfUnset 0x223A, _cv_bar_21
	ClearFlag 0x223A
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_21
	ShowPerson 202
_cv_bar_21:
	GoToIfUnset 0x223B, _cv_bar_22
	ClearFlag 0x223B
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_22
	ShowPerson 203
_cv_bar_22:
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
	// (the GBA redraws a square here: 21, 12, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 22, 12, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 21, 13, METATILE_SilphCo_Floor_ShadeFull, 0)
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
	GoToIfSet 0x223E, _cv_bar_23
	SetFlag 0x223E
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_23
	HidePerson 206
_cv_bar_23:
	GoToIfSet 0x223F, _cv_bar_24
	SetFlag 0x223F
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_24
	HidePerson 207
_cv_bar_24:
	// (the GBA redraws a square here: 5, 17, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 6, 17, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 6, 18, METATILE_SilphCo_Floor, 0)
	Return

_cv_stop:
	NPCMsg msg_0892_CV_CANVAS_SILPH_CO_2F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
