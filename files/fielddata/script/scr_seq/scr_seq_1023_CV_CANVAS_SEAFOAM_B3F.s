#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SEAFOAM_B3F.h"
#include "msgdata/msg/msg_0883_CV_CANVAS_SEAFOAM_B3F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SeafoamIslands_B3F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SeafoamIslands_B3F_OnTransition
	ScrDef SeafoamIslands_B3F_EventScript_EnterByFalling
	ScrDefEnd
	
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
	CompareVarToValue 0x8008, 24
	CallIfLt SeafoamIslands_B3F_EventScript_RideCurrentFar
	CompareVarToValue 0x8008, 24
	CallIfGe SeafoamIslands_B3F_EventScript_RideCurrentClose
	SetVar 0x503C, 1
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	Warp MAP_CANVAS_SEAFOAM_B4F, 0, 28, 24, DIR_SOUTH
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
