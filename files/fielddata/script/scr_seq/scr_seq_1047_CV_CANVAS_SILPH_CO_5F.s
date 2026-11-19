#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SILPH_CO_5F.h"
#include "msgdata/msg/msg_0895_CV_CANVAS_SILPH_CO_5F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SilphCo_5F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SilphCo_5F_EventScript_WorkerM
	ScrDef SilphCo_5F_EventScript_ItemProtein
	ScrDef SilphCo_5F_EventScript_ItemTM01
	ScrDef SilphCo_5F_EventScript_ItemCardKey
	ScrDef SilphCo_5F_EventScript_Scientist
	ScrDef SilphCo_5F_EventScript_Door1
	ScrDef SilphCo_5F_EventScript_Door2
	ScrDef SilphCo_5F_EventScript_Door3
	ScrDef SilphCo_5F_EventScript_PokemonReport3
	ScrDef SilphCo_5F_EventScript_PokemonReport2
	ScrDef SilphCo_5F_EventScript_PokemonReport1
	ScrDef SilphCo_5F_EventScript_FloorSign
	ScrDef SilphCo_5F_OnLoad
	ScrDef SilphCo_5F_Frlg_cv_Barriers
	ScrDefEnd
	
SilphCo_5F_EventScript_WorkerM:
	LockAll
	FacePlayer
	CompareVarToValue 0x5031, 1
	GoToIfGe SilphCo_5F_EventScript_WorkerMRocketsGone
	NPCMsg msg_0895_CV_CANVAS_SILPH_CO_5F_SilphCo_5F_Text_RocketsInUproarAboutIntruder
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SilphCo_5F_EventScript_ItemProtein:
	SetVar 0x8004, ITEM_PROTEIN
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
SilphCo_5F_EventScript_ItemTM01:
	SetVar 0x8004, ITEM_TM01
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
SilphCo_5F_EventScript_ItemCardKey:
	SetVar 0x8004, ITEM_CARD_KEY
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
SilphCo_5F_EventScript_Scientist:
	LockAll
	FacePlayer
	NPCMsg msg_0895_CV_CANVAS_SILPH_CO_5F_SilphCo_5F_Text_RocketBossLookingForStrongMons
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SilphCo_5F_EventScript_Door1:
	LockAll
	SetVar 0x4001, 7
	SetVar 0x8004, 0x21A3
	GoToIfSet 0x21A3, EventScript_DoorUnlocked
	GoTo EventScript_TryUnlockDoor
	End
	
SilphCo_5F_EventScript_Door2:
	LockAll
	SetVar 0x4001, 8
	SetVar 0x8004, 0x21A4
	GoToIfSet 0x21A4, EventScript_DoorUnlocked
	GoTo EventScript_TryUnlockDoor
	End
	
SilphCo_5F_EventScript_Door3:
	LockAll
	SetVar 0x4001, 9
	SetVar 0x8004, 0x21A5
	GoToIfSet 0x21A5, EventScript_DoorUnlocked
	GoTo EventScript_TryUnlockDoor
	End
	
SilphCo_5F_EventScript_PokemonReport3:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0895_CV_CANVAS_SILPH_CO_5F_SilphCo_5F_Text_SomeMonsEvolveWhenTraded
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SilphCo_5F_EventScript_PokemonReport2:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0895_CV_CANVAS_SILPH_CO_5F_SilphCo_5F_Text_Over350TechniquesConfirmed
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SilphCo_5F_EventScript_PokemonReport1:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0895_CV_CANVAS_SILPH_CO_5F_SilphCo_5F_Text_PorygonFirstVRMon
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SilphCo_5F_EventScript_FloorSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0895_CV_CANVAS_SILPH_CO_5F_SilphCo_5F_Text_FloorSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SilphCo_5F_OnLoad:
	CallIfUnset 0x21A3, EventScript_Close5FDoor1
	CallIfUnset 0x21A4, EventScript_Close5FDoor2
	CallIfUnset 0x21A5, EventScript_Close5FDoor3
	End
	
SilphCo_5F_Frlg_cv_Barriers:
	SetVar 0x5044, 1
	SetFlag 0x2280
	SetFlag 0x2281
	SetFlag 0x2282
	SetFlag 0x2283
	SetFlag 0x2284
	SetFlag 0x2285
	SetFlag 0x2286
	SetFlag 0x2287
	SetFlag 0x2288
	SetFlag 0x2289
	SetFlag 0x228A
	SetFlag 0x228B
	Call SilphCo_5F_OnLoad_cv_init
	SetVar 0x5044, 0
	End
	
SilphCo_5F_EventScript_WorkerMRocketsGone:
	NPCMsg msg_0895_CV_CANVAS_SILPH_CO_5F_SilphCo_5F_Text_YoureOurHeroThankYou
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_DoorUnlocked:
	NPCMsg msg_0895_CV_CANVAS_SILPH_CO_5F_Text_TheDoorIsOpen
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_TryUnlockDoor:
	GoToIfSet 0x2198, EventScript_OpenDoor
	GoTo EventScript_NeedCardKey
	End
	
EventScript_Close5FDoor1:
	// (the GBA redraws a square here: 7, 8, METATILE_SilphCo_VerticalBarrier_TopLeft, 1)
	// (the GBA redraws a square here: 8, 8, METATILE_SilphCo_VerticalBarrier_TopRight, 1)
	GoToIfUnset 0x2280, _cv_bar_1
	ClearFlag 0x2280
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_1
	ShowPerson 200
_cv_bar_1:
	GoToIfUnset 0x2281, _cv_bar_2
	ClearFlag 0x2281
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_2
	ShowPerson 201
_cv_bar_2:
	GoToIfUnset 0x2282, _cv_bar_3
	ClearFlag 0x2282
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_3
	ShowPerson 202
_cv_bar_3:
	GoToIfUnset 0x2283, _cv_bar_4
	ClearFlag 0x2283
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_4
	ShowPerson 203
_cv_bar_4:
	Return
	
EventScript_Close5FDoor2:
	// (the GBA redraws a square here: 7, 17, METATILE_SilphCo_VerticalBarrier_TopLeft, 1)
	// (the GBA redraws a square here: 8, 17, METATILE_SilphCo_VerticalBarrier_TopRight, 1)
	GoToIfUnset 0x2288, _cv_bar_5
	ClearFlag 0x2288
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_5
	ShowPerson 208
_cv_bar_5:
	GoToIfUnset 0x2289, _cv_bar_6
	ClearFlag 0x2289
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_6
	ShowPerson 209
_cv_bar_6:
	GoToIfUnset 0x228A, _cv_bar_7
	ClearFlag 0x228A
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_7
	ShowPerson 210
_cv_bar_7:
	GoToIfUnset 0x228B, _cv_bar_8
	ClearFlag 0x228B
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_8
	ShowPerson 211
_cv_bar_8:
	Return
	
EventScript_Close5FDoor3:
	// (the GBA redraws a square here: 18, 12, METATILE_SilphCo_VerticalBarrier_TopLeft, 1)
	// (the GBA redraws a square here: 19, 12, METATILE_SilphCo_VerticalBarrier_TopRight, 1)
	GoToIfUnset 0x2284, _cv_bar_9
	ClearFlag 0x2284
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_9
	ShowPerson 204
_cv_bar_9:
	GoToIfUnset 0x2285, _cv_bar_10
	ClearFlag 0x2285
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_10
	ShowPerson 205
_cv_bar_10:
	GoToIfUnset 0x2286, _cv_bar_11
	ClearFlag 0x2286
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_11
	ShowPerson 206
_cv_bar_11:
	GoToIfUnset 0x2287, _cv_bar_12
	ClearFlag 0x2287
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_12
	ShowPerson 207
_cv_bar_12:
	Return
	
SilphCo_5F_OnLoad_cv_init:
	CallIfUnset 0x21A3, EventScript_Close5FDoor1
	CallIfUnset 0x21A4, EventScript_Close5FDoor2
	CallIfUnset 0x21A5, EventScript_Close5FDoor3
	Return
	
EventScript_OpenDoor:
	PlayFanfare SEQ_ME_LVUP
	NPCMsg msg_0895_CV_CANVAS_SILPH_CO_5F_Text_CardKeyOpenedDoor
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
	NPCMsg msg_0895_CV_CANVAS_SILPH_CO_5F_Text_ItNeedsCardKey
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
	GoToIfSet 0x2280, _cv_bar_13
	SetFlag 0x2280
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_13
	HidePerson 200
_cv_bar_13:
	GoToIfSet 0x2281, _cv_bar_14
	SetFlag 0x2281
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_14
	HidePerson 201
_cv_bar_14:
	GoToIfSet 0x2282, _cv_bar_15
	SetFlag 0x2282
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_15
	HidePerson 202
_cv_bar_15:
	GoToIfSet 0x2283, _cv_bar_16
	SetFlag 0x2283
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_16
	HidePerson 203
_cv_bar_16:
	Return
	
EventScript_Open5FDoor2:
	// (the GBA redraws a square here: 7, 17, METATILE_SilphCo_Wall_LeftEdge, 1)
	// (the GBA redraws a square here: 8, 17, METATILE_SilphCo_Wall_RightEdge, 1)
	GoToIfSet 0x2288, _cv_bar_17
	SetFlag 0x2288
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_17
	HidePerson 208
_cv_bar_17:
	GoToIfSet 0x2289, _cv_bar_18
	SetFlag 0x2289
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_18
	HidePerson 209
_cv_bar_18:
	GoToIfSet 0x228A, _cv_bar_19
	SetFlag 0x228A
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_19
	HidePerson 210
_cv_bar_19:
	GoToIfSet 0x228B, _cv_bar_20
	SetFlag 0x228B
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_20
	HidePerson 211
_cv_bar_20:
	Return
	
EventScript_Open5FDoor3:
	// (the GBA redraws a square here: 18, 12, METATILE_SilphCo_Wall_LeftEdge, 1)
	// (the GBA redraws a square here: 19, 12, METATILE_SilphCo_Wall_RightEdge, 1)
	GoToIfSet 0x2284, _cv_bar_21
	SetFlag 0x2284
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_21
	HidePerson 204
_cv_bar_21:
	GoToIfSet 0x2285, _cv_bar_22
	SetFlag 0x2285
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_22
	HidePerson 205
_cv_bar_22:
	GoToIfSet 0x2286, _cv_bar_23
	SetFlag 0x2286
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_23
	HidePerson 206
_cv_bar_23:
	GoToIfSet 0x2287, _cv_bar_24
	SetFlag 0x2287
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_24
	HidePerson 207
_cv_bar_24:
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
	// (the GBA redraws a square here: 5, 16, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 6, 16, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 5, 17, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 6, 17, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 6, 18, METATILE_SilphCo_Floor, 0)
	Return

_cv_stop:
	NPCMsg msg_0895_CV_CANVAS_SILPH_CO_5F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
