#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_PIT_HALL.h"
#include "msgdata/msg/msg_0968_CV_CANVAS_PIT_HALL.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's CeladonCity_PitHall by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Pit_EventScript_Doorman
	ScrDef Pit_EventScript_HallTransition
	ScrDefEnd
	
Pit_EventScript_Doorman:
	LockAll
	FacePlayer
	GoToIfSet 0x2224, Pit_EventScript_DoormanLetIn
	NPCMsg msg_0968_CV_CANVAS_PIT_HALL_Pit_Text_DoormanStop
	WaitButton
	CloseMsg
	// TODO(gba) special Pit_AskPassword
	GoTo _cv_stop
	// TODO(gba) special Pit_CheckPassword
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Pit_EventScript_DoormanWrong
	NPCMsg msg_0968_CV_CANVAS_PIT_HALL_Pit_Text_DoormanRight
	WaitButton
	CloseMsg
	GetPlayerCoords 0x8004, 0x8005
	CompareVarToValue 0x8004, 5
	CallIfEq Pit_EventScript_DoormanStepBack
	CompareVarToValue 0x8004, 5
	CallIfNe Pit_EventScript_DoormanStepRight
	SetFlag 0x2224
	Call Pit_EventScript_DoormanAside
	ReleaseAll
	End
	
Pit_EventScript_HallTransition:
	CallIfSet 0x2224, Pit_EventScript_DoormanAside
	End
	
Pit_EventScript_DoormanLetIn:
	NPCMsg msg_0968_CV_CANVAS_PIT_HALL_Pit_Text_DoormanLetIn
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Pit_EventScript_DoormanWrong:
	NPCMsg msg_0968_CV_CANVAS_PIT_HALL_Pit_Text_DoormanWrong
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Pit_EventScript_DoormanStepBack:
	ApplyMovement 1, Pit_Movement_StepBack
	WaitMovement
	Return
	
Pit_EventScript_DoormanStepRight:
	ApplyMovement 1, Pit_Movement_StepAside
	WaitMovement
	Return
	
Pit_EventScript_DoormanAside:
	MovePerson 1, 5, 2
	SetObjectMovementType 1, 16
	SetObjectFacing 1, 2
	Return

_cv_stop:
	NPCMsg msg_0968_CV_CANVAS_PIT_HALL_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
Pit_Movement_StepBack:
	WalkNormalSouth
	FaceEast
	EndMovement

	.balign 4, 0
Pit_Movement_StepAside:
	WalkNormalEast
	FaceWest
	EndMovement
	.balign 4, 0
