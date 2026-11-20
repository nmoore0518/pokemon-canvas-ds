#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SEAFOAM_B3F.h"
#include "msgdata/msg/msg_0883_CV_CANVAS_SEAFOAM_B3F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SeafoamIslands_B3F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SeafoamIslands_B3F_Frlg_cv_BoulderFalls
	ScrDef SeafoamIslands_B3F_OnTransition
	ScrDef SeafoamIslands_B3F_EventScript_EnterByFalling
	ScrDefEnd
	
SeafoamIslands_B3F_Frlg_cv_BoulderFalls:
	PlaySE SEQ_SE_GS_IWAOTOSHI
	CompareVarToValue VAR_SPECIAL_LAST_TALKED, 1
	GoToIfNe _cv_fall_1
	SetFlag 0x2118
	HidePerson VAR_SPECIAL_LAST_TALKED
	WaitSE SEQ_SE_GS_IWAOTOSHI
	End
_cv_fall_1:
	CompareVarToValue VAR_SPECIAL_LAST_TALKED, 2
	GoToIfNe _cv_fall_2
	SetFlag 0x2119
	HidePerson VAR_SPECIAL_LAST_TALKED
	WaitSE SEQ_SE_GS_IWAOTOSHI
	End
_cv_fall_2:
	CompareVarToValue VAR_SPECIAL_LAST_TALKED, 3
	GoToIfNe _cv_fall_3
	SetFlag 0x211C
	ClearFlag 0x211F
	HidePerson VAR_SPECIAL_LAST_TALKED
	WaitSE SEQ_SE_GS_IWAOTOSHI
	End
_cv_fall_3:
	CompareVarToValue VAR_SPECIAL_LAST_TALKED, 4
	GoToIfNe _cv_fall_4
	SetFlag 0x211D
	HidePerson VAR_SPECIAL_LAST_TALKED
	WaitSE SEQ_SE_GS_IWAOTOSHI
	End
_cv_fall_4:
	CompareVarToValue VAR_SPECIAL_LAST_TALKED, 5
	GoToIfNe _cv_fall_5
	SetFlag 0x211B
	HidePerson VAR_SPECIAL_LAST_TALKED
	WaitSE SEQ_SE_GS_IWAOTOSHI
	End
_cv_fall_5:
	CompareVarToValue VAR_SPECIAL_LAST_TALKED, 6
	GoToIfNe _cv_fall_6
	SetFlag 0x211A
	ClearFlag 0x211E
	HidePerson VAR_SPECIAL_LAST_TALKED
	WaitSE SEQ_SE_GS_IWAOTOSHI
	End
_cv_fall_6:
	End
	
SeafoamIslands_B3F_OnTransition:
	CallIfUnset 0x2110, SeafoamIslands_B3F_EventScript_CheckStoppedCurrent
	CallIfSet 0x2110, SeafoamIslands_B3F_EventScript_SetNoCurrentLayout
	End
	
SeafoamIslands_B3F_EventScript_EnterByFalling:
	LockAll
	SetVar 0x4002, 0
	CallIfUnset 0x2118, SeafoamIslands_B3F_EventScript_AddBoulderPresent
	CallIfUnset 0x2119, SeafoamIslands_B3F_EventScript_AddBoulderPresent
	CompareVarToValue 0x4002, 2
	GoToIfEq SeafoamIslands_B3F_EventScript_CurrentBlocked
	GetPlayerCoords 0x8008, 0x8009
	CompareVarToValue 0x8008, 38
	GoToIfLt _cv_unwiden_1
	CompareVarToValue 0x8008, 39
	GoToIfLt _cv_unwiden_2
	SubVar 0x8008, 1
	GoTo _cv_unwiden_1
_cv_unwiden_2:
	SetVar 0x8008, 38
_cv_unwiden_1:
	CompareVarToValue 0x8008, 35
	GoToIfLt _cv_unwiden_3
	CompareVarToValue 0x8008, 36
	GoToIfLt _cv_unwiden_4
	SubVar 0x8008, 1
	GoTo _cv_unwiden_3
_cv_unwiden_4:
	SetVar 0x8008, 35
_cv_unwiden_3:
	CompareVarToValue 0x8008, 30
	GoToIfLt _cv_unwiden_5
	CompareVarToValue 0x8008, 31
	GoToIfLt _cv_unwiden_6
	SubVar 0x8008, 1
	GoTo _cv_unwiden_5
_cv_unwiden_6:
	SetVar 0x8008, 30
_cv_unwiden_5:
	CompareVarToValue 0x8008, 28
	GoToIfLt _cv_unwiden_7
	CompareVarToValue 0x8008, 29
	GoToIfLt _cv_unwiden_8
	SubVar 0x8008, 1
	GoTo _cv_unwiden_7
_cv_unwiden_8:
	SetVar 0x8008, 28
_cv_unwiden_7:
	CompareVarToValue 0x8008, 21
	GoToIfLt _cv_unwiden_9
	CompareVarToValue 0x8008, 22
	GoToIfLt _cv_unwiden_10
	SubVar 0x8008, 1
	GoTo _cv_unwiden_9
_cv_unwiden_10:
	SetVar 0x8008, 21
_cv_unwiden_9:
	CompareVarToValue 0x8008, 13
	GoToIfLt _cv_unwiden_11
	CompareVarToValue 0x8008, 14
	GoToIfLt _cv_unwiden_12
	SubVar 0x8008, 1
	GoTo _cv_unwiden_11
_cv_unwiden_12:
	SetVar 0x8008, 13
_cv_unwiden_11:
	CompareVarToValue 0x8008, 10
	GoToIfLt _cv_unwiden_13
	CompareVarToValue 0x8008, 11
	GoToIfLt _cv_unwiden_14
	SubVar 0x8008, 1
	GoTo _cv_unwiden_13
_cv_unwiden_14:
	SetVar 0x8008, 10
_cv_unwiden_13:
	CompareVarToValue 0x8008, 7
	GoToIfLt _cv_unwiden_15
	CompareVarToValue 0x8008, 8
	GoToIfLt _cv_unwiden_16
	SubVar 0x8008, 1
	GoTo _cv_unwiden_15
_cv_unwiden_16:
	SetVar 0x8008, 7
_cv_unwiden_15:
	CompareVarToValue 0x8009, 18
	GoToIfLt _cv_unwiden_17
	CompareVarToValue 0x8009, 20
	GoToIfLt _cv_unwiden_18
	SubVar 0x8009, 2
	GoTo _cv_unwiden_17
_cv_unwiden_18:
	SetVar 0x8009, 18
_cv_unwiden_17:
	CompareVarToValue 0x8009, 14
	GoToIfLt _cv_unwiden_19
	CompareVarToValue 0x8009, 15
	GoToIfLt _cv_unwiden_20
	SubVar 0x8009, 1
	GoTo _cv_unwiden_19
_cv_unwiden_20:
	SetVar 0x8009, 14
_cv_unwiden_19:
	CompareVarToValue 0x8009, 12
	GoToIfLt _cv_unwiden_21
	CompareVarToValue 0x8009, 13
	GoToIfLt _cv_unwiden_22
	SubVar 0x8009, 1
	GoTo _cv_unwiden_21
_cv_unwiden_22:
	SetVar 0x8009, 12
_cv_unwiden_21:
	CompareVarToValue 0x8009, 10
	GoToIfLt _cv_unwiden_23
	CompareVarToValue 0x8009, 11
	GoToIfLt _cv_unwiden_24
	SubVar 0x8009, 1
	GoTo _cv_unwiden_23
_cv_unwiden_24:
	SetVar 0x8009, 10
_cv_unwiden_23:
	CompareVarToValue 0x8009, 7
	GoToIfLt _cv_unwiden_25
	CompareVarToValue 0x8009, 8
	GoToIfLt _cv_unwiden_26
	SubVar 0x8009, 1
	GoTo _cv_unwiden_25
_cv_unwiden_26:
	SetVar 0x8009, 7
_cv_unwiden_25:
	CompareVarToValue 0x8008, 24
	CallIfLt SeafoamIslands_B3F_EventScript_RideCurrentFar
	CompareVarToValue 0x8008, 24
	CallIfGe SeafoamIslands_B3F_EventScript_RideCurrentClose
	SetVar 0x503C, 1
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	Warp MAP_CANVAS_SEAFOAM_B4F, 0, 33, 28, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	ReleaseAll
	End
	
SeafoamIslands_B3F_EventScript_CheckStoppedCurrent:
	SetVar 0x4002, 0
	CallIfUnset 0x2118, SeafoamIslands_B3F_EventScript_AddBoulderPresent
	CallIfUnset 0x2119, SeafoamIslands_B3F_EventScript_AddBoulderPresent
	CompareVarToValue 0x4002, 2
	CallIfEq SeafoamIslands_B3F_EventScript_StoppedCurrent
	Return
	
SeafoamIslands_B3F_EventScript_SetNoCurrentLayout:
	// TODO(gba) setmaplayoutindex LAYOUT_SEAFOAM_ISLANDS_B3F_CURRENT_STOPPED
	Return
	
SeafoamIslands_B3F_EventScript_AddBoulderPresent:
	AddVar 0x4002, 1
	Return
	
SeafoamIslands_B3F_EventScript_CurrentBlocked:
	SetVar 0x4001, 0
	ReleaseAll
	End
	
SeafoamIslands_B3F_EventScript_RideCurrentFar:
	ApplyMovement obj_player, SeafoamIslands_B3F_Movement_RideCurrentFar
	WaitMovement
	Return
	
SeafoamIslands_B3F_EventScript_RideCurrentClose:
	ApplyMovement obj_player, SeafoamIslands_B3F_Movement_RideCurrentClose
	WaitMovement
	Return
	
SeafoamIslands_B3F_EventScript_StoppedCurrent:
	SetFlag 0x2110
	Return

_cv_stop:
	NPCMsg msg_0883_CV_CANVAS_SEAFOAM_B3F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
SeafoamIslands_B3F_Movement_RideCurrentFar:
	WalkFastSouth 4
	WalkFastEast 3
	WalkFastSouth 6
	EndMovement

	.balign 4, 0
SeafoamIslands_B3F_Movement_RideCurrentClose:
	WalkFastSouth 4
	WalkFastEast 2
	WalkFastSouth 6
	EndMovement
	.balign 4, 0
