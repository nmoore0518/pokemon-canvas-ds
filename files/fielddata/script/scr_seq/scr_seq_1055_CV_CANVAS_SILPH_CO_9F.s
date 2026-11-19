#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SILPH_CO_9F.h"
#include "msgdata/msg/msg_0899_CV_CANVAS_SILPH_CO_9F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SilphCo_9F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SilphCo_9F_EventScript_HealWoman
	ScrDef SilphCo_9F_EventScript_ItemTM42
	ScrDef SilphCo_9F_EventScript_Door1
	ScrDef SilphCo_9F_EventScript_Door2
	ScrDef SilphCo_9F_EventScript_Door3
	ScrDef SilphCo_9F_EventScript_Door4
	ScrDef SilphCo_9F_EventScript_FloorSign
	ScrDef SilphCo_9F_OnLoad
	ScrDef SilphCo_9F_Frlg_cv_Barriers
	ScrDefEnd
	
SilphCo_9F_EventScript_HealWoman:
	LockAll
	FacePlayer
	CompareVarToValue 0x5031, 1
	GoToIfGe SilphCo_9F_EventScript_HealWomanRocketsGone
	NPCMsg msg_0899_CV_CANVAS_SILPH_CO_9F_SilphCo_9F_Text_YouShouldTakeQuickNap
	WaitButton
	CloseMsg
	Call Common_EventScript_OutOfCenterPartyHeal
	NPCMsg msg_0899_CV_CANVAS_SILPH_CO_9F_SilphCo_9F_Text_DontGiveUp
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SilphCo_9F_EventScript_ItemTM42:
	SetVar 0x8004, ITEM_TM42
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
SilphCo_9F_EventScript_Door1:
	LockAll
	SetVar 0x4001, 15
	SetVar 0x8004, 0x21B8
	GoToIfSet 0x21B8, EventScript_DoorUnlocked
	GoTo EventScript_TryUnlockDoor
	End
	
SilphCo_9F_EventScript_Door2:
	LockAll
	SetVar 0x4001, 16
	SetVar 0x8004, 0x21B9
	GoToIfSet 0x21B9, EventScript_DoorUnlocked
	GoTo EventScript_TryUnlockDoor
	End
	
SilphCo_9F_EventScript_Door3:
	LockAll
	SetVar 0x4001, 17
	SetVar 0x8004, 0x21BA
	GoToIfSet 0x21BA, EventScript_DoorUnlocked
	GoTo EventScript_TryUnlockDoor
	End
	
SilphCo_9F_EventScript_Door4:
	LockAll
	SetVar 0x4001, 18
	SetVar 0x8004, 0x21BB
	GoToIfSet 0x21BB, EventScript_DoorUnlocked
	GoTo EventScript_TryUnlockDoor
	End
	
SilphCo_9F_EventScript_FloorSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0899_CV_CANVAS_SILPH_CO_9F_SilphCo_9F_Text_FloorSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SilphCo_9F_OnLoad:
	CallIfUnset 0x21B8, EventScript_Close9FDoor1
	CallIfUnset 0x21B9, EventScript_Close9FDoor2
	CallIfUnset 0x21BA, EventScript_Close9FDoor3
	CallIfUnset 0x21BB, EventScript_Close9FDoor4
	End
	
SilphCo_9F_Frlg_cv_Barriers:
	SetVar 0x5044, 1
	SetFlag 0x22A0
	SetFlag 0x22A1
	SetFlag 0x22A2
	SetFlag 0x22A3
	SetFlag 0x22A4
	SetFlag 0x22A5
	SetFlag 0x22A6
	SetFlag 0x22A7
	SetFlag 0x22A8
	SetFlag 0x22A9
	SetFlag 0x22AA
	SetFlag 0x22AB
	SetFlag 0x22AC
	SetFlag 0x22AD
	SetFlag 0x22AE
	SetFlag 0x22AF
	Call SilphCo_9F_OnLoad_cv_init
	SetVar 0x5044, 0
	End
	
SilphCo_9F_EventScript_HealWomanRocketsGone:
	NPCMsg msg_0899_CV_CANVAS_SILPH_CO_9F_SilphCo_9F_Text_ThankYouSoMuch
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Common_EventScript_OutOfCenterPartyHeal:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	PlayFanfare SEQ_ME_ASA
	WaitFanfare
	HealParty
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	Return
	
EventScript_DoorUnlocked:
	NPCMsg msg_0899_CV_CANVAS_SILPH_CO_9F_Text_TheDoorIsOpen
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_TryUnlockDoor:
	GoToIfSet 0x2198, EventScript_OpenDoor
	GoTo EventScript_NeedCardKey
	End
	
EventScript_Close9FDoor1:
	// (the GBA redraws a square here: 2, 9, METATILE_SilphCo_VerticalBarrier_TopLeft, 1)
	// (the GBA redraws a square here: 3, 9, METATILE_SilphCo_VerticalBarrier_TopRight, 1)
	GoToIfUnset 0x22A4, _cv_bar_1
	ClearFlag 0x22A4
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_1
	ShowPerson 204
_cv_bar_1:
	GoToIfUnset 0x22A5, _cv_bar_2
	ClearFlag 0x22A5
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_2
	ShowPerson 205
_cv_bar_2:
	GoToIfUnset 0x22A6, _cv_bar_3
	ClearFlag 0x22A6
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_3
	ShowPerson 206
_cv_bar_3:
	GoToIfUnset 0x22A7, _cv_bar_4
	ClearFlag 0x22A7
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_4
	ShowPerson 207
_cv_bar_4:
	Return
	
EventScript_Close9FDoor2:
	// (the GBA redraws a square here: 12, 15, METATILE_SilphCo_VerticalBarrier_TopLeft, 1)
	// (the GBA redraws a square here: 13, 15, METATILE_SilphCo_VerticalBarrier_TopRight, 1)
	GoToIfUnset 0x22AC, _cv_bar_5
	ClearFlag 0x22AC
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_5
	ShowPerson 212
_cv_bar_5:
	GoToIfUnset 0x22AD, _cv_bar_6
	ClearFlag 0x22AD
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_6
	ShowPerson 213
_cv_bar_6:
	GoToIfUnset 0x22AE, _cv_bar_7
	ClearFlag 0x22AE
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_7
	ShowPerson 214
_cv_bar_7:
	GoToIfUnset 0x22AF, _cv_bar_8
	ClearFlag 0x22AF
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_8
	ShowPerson 215
_cv_bar_8:
	Return
	
EventScript_Close9FDoor3:
	GoToIfUnset 0x22A0, _cv_bar_9
	ClearFlag 0x22A0
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_9
	ShowPerson 200
_cv_bar_9:
	GoToIfUnset 0x22A1, _cv_bar_10
	ClearFlag 0x22A1
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_10
	ShowPerson 201
_cv_bar_10:
	GoToIfUnset 0x22A2, _cv_bar_11
	ClearFlag 0x22A2
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_11
	ShowPerson 202
_cv_bar_11:
	GoToIfUnset 0x22A3, _cv_bar_12
	ClearFlag 0x22A3
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_12
	ShowPerson 203
_cv_bar_12:
	// (the GBA redraws a square here: 22, 8, METATILE_SilphCo_Floor_ShadeFull, 0)
	Return
	
EventScript_Close9FDoor4:
	GoToIfUnset 0x22A8, _cv_bar_13
	ClearFlag 0x22A8
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_13
	ShowPerson 208
_cv_bar_13:
	GoToIfUnset 0x22A9, _cv_bar_14
	ClearFlag 0x22A9
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_14
	ShowPerson 209
_cv_bar_14:
	GoToIfUnset 0x22AA, _cv_bar_15
	ClearFlag 0x22AA
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_15
	ShowPerson 210
_cv_bar_15:
	GoToIfUnset 0x22AB, _cv_bar_16
	ClearFlag 0x22AB
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_16
	ShowPerson 211
_cv_bar_16:
	// (the GBA redraws a square here: 22, 14, METATILE_SilphCo_Floor_ShadeFull, 0)
	Return
	
SilphCo_9F_OnLoad_cv_init:
	CallIfUnset 0x21B8, EventScript_Close9FDoor1
	CallIfUnset 0x21B9, EventScript_Close9FDoor2
	CallIfUnset 0x21BA, EventScript_Close9FDoor3
	CallIfUnset 0x21BB, EventScript_Close9FDoor4
	Return
	
EventScript_OpenDoor:
	PlayFanfare SEQ_ME_LVUP
	NPCMsg msg_0899_CV_CANVAS_SILPH_CO_9F_Text_CardKeyOpenedDoor
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
	NPCMsg msg_0899_CV_CANVAS_SILPH_CO_9F_Text_ItNeedsCardKey
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
	// (the GBA redraws a square here: 9, 12, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 10, 12, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 9, 13, METATILE_SilphCo_Floor_WallLeftCorner, 0)
	// (the GBA redraws a square here: 10, 13, METATILE_SilphCo_Floor_WallRightCorner, 0)
	Return
	
EventScript_Open3FDoor2:
	// (the GBA redraws a square here: 20, 11, METATILE_SilphCo_Wall_LeftEdge, 1)
	// (the GBA redraws a square here: 21, 11, METATILE_SilphCo_Wall_RightEdge, 1)
	// (the GBA redraws a square here: 20, 12, METATILE_SilphCo_Floor_ShadeFull, 0)
	GoToIfSet 0x22A8, _cv_bar_17
	SetFlag 0x22A8
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_17
	HidePerson 208
_cv_bar_17:
	// (the GBA redraws a square here: 20, 13, METATILE_SilphCo_Floor_WallLeftCorner, 0)
	GoToIfSet 0x22AA, _cv_bar_18
	SetFlag 0x22AA
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_18
	HidePerson 210
_cv_bar_18:
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
	GoToIfSet 0x22A4, _cv_bar_19
	SetFlag 0x22A4
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_19
	HidePerson 204
_cv_bar_19:
	GoToIfSet 0x22A5, _cv_bar_20
	SetFlag 0x22A5
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_20
	HidePerson 205
_cv_bar_20:
	GoToIfSet 0x22A6, _cv_bar_21
	SetFlag 0x22A6
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_21
	HidePerson 206
_cv_bar_21:
	GoToIfSet 0x22A7, _cv_bar_22
	SetFlag 0x22A7
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_22
	HidePerson 207
_cv_bar_22:
	Return
	
EventScript_Open9FDoor2:
	// (the GBA redraws a square here: 12, 15, METATILE_SilphCo_Wall_LeftEdge, 1)
	// (the GBA redraws a square here: 13, 15, METATILE_SilphCo_Wall_RightEdge, 1)
	GoToIfSet 0x22AC, _cv_bar_23
	SetFlag 0x22AC
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_23
	HidePerson 212
_cv_bar_23:
	GoToIfSet 0x22AD, _cv_bar_24
	SetFlag 0x22AD
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_24
	HidePerson 213
_cv_bar_24:
	GoToIfSet 0x22AE, _cv_bar_25
	SetFlag 0x22AE
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_25
	HidePerson 214
_cv_bar_25:
	GoToIfSet 0x22AF, _cv_bar_26
	SetFlag 0x22AF
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_26
	HidePerson 215
_cv_bar_26:
	Return
	
EventScript_Open9FDoor3:
	GoToIfSet 0x22A0, _cv_bar_27
	SetFlag 0x22A0
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_27
	HidePerson 200
_cv_bar_27:
	GoToIfSet 0x22A1, _cv_bar_28
	SetFlag 0x22A1
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_28
	HidePerson 201
_cv_bar_28:
	GoToIfSet 0x22A2, _cv_bar_29
	SetFlag 0x22A2
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_29
	HidePerson 202
_cv_bar_29:
	GoToIfSet 0x22A3, _cv_bar_30
	SetFlag 0x22A3
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_30
	HidePerson 203
_cv_bar_30:
	// (the GBA redraws a square here: 22, 8, METATILE_SilphCo_Floor, 0)
	Return
	
EventScript_Open9FDoor4:
	GoToIfSet 0x22A8, _cv_bar_31
	SetFlag 0x22A8
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_31
	HidePerson 208
_cv_bar_31:
	GoToIfSet 0x22A9, _cv_bar_32
	SetFlag 0x22A9
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_32
	HidePerson 209
_cv_bar_32:
	GoToIfSet 0x22AA, _cv_bar_33
	SetFlag 0x22AA
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_33
	HidePerson 210
_cv_bar_33:
	GoToIfSet 0x22AB, _cv_bar_34
	SetFlag 0x22AB
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_34
	HidePerson 211
_cv_bar_34:
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
	NPCMsg msg_0899_CV_CANVAS_SILPH_CO_9F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
