#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T10.h"
#include "msgdata/msg/msg_0521_T10.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's IndigoPlateau_Exterior_Frlg#world by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef IndigoPlateau_Exterior_OnTransition
	ScrDef IndigoPlateau_Exterior_EventScript_Credits
	ScrDefEnd
	
IndigoPlateau_Exterior_OnTransition:
	SetFlag FLAG_SYS_FLYPOINT_INDIGO
	CompareVarToValue 0x502E, 1
	CallIfEq IndigoPlateau_Exterior_EventScript_PlayCreditsMusic
	End
	
IndigoPlateau_Exterior_EventScript_Credits:
	LockAll
	Wait 105, VAR_SPECIAL_RESULT
	GoToIfUnset 0x2065, _cv_show_1
	ClearFlag 0x2065
	ShowPerson 1
	SetFlag 0x2065
	GoTo _cv_shown_2
_cv_show_1:
	ShowPerson 1
_cv_shown_2:
	ApplyMovement 1, IndigoPlateau_Exterior_Movement_RivalExitBuilding
	ApplyMovement obj_player, IndigoPlateau_Exterior_Movement_PushPlayerOutOfWay
	WaitMovement
	ApplyMovement obj_player, IndigoPlateau_Exterior_Movement_PlayerWatchRivalLeave
	ApplyMovement 1, IndigoPlateau_Exterior_Movement_RivalLeave
	WaitMovement
	Wait 100, VAR_SPECIAL_RESULT
	GoToIfUnset 0x2066, _cv_show_3
	ClearFlag 0x2066
	ShowPerson 2
	SetFlag 0x2066
	GoTo _cv_shown_4
_cv_show_3:
	ShowPerson 2
_cv_shown_4:
	ApplyMovement 2, IndigoPlateau_Exterior_Movement_OakExitBuilding
	WaitMovement
	Wait 160, VAR_SPECIAL_RESULT
	ApplyMovement obj_player, IndigoPlateau_Exterior_Movement_PlayerWatchOakLeave
	ApplyMovement 2, IndigoPlateau_Exterior_Movement_OakLeave
	WaitMovement
	Wait 100, VAR_SPECIAL_RESULT
	ApplyMovement obj_player, IndigoPlateau_Exterior_Movement_PlayerBeginLeave
	WaitMovement
	Wait 155, VAR_SPECIAL_RESULT
	ApplyMovement obj_player, IndigoPlateau_Exterior_Movement_PlayerFaceLeague
	WaitMovement
	Wait 90, VAR_SPECIAL_RESULT
	ApplyMovement obj_player, IndigoPlateau_Exterior_Movement_PlayerTurnAround
	WaitMovement
	ApplyMovement obj_player, IndigoPlateau_Exterior_Movement_PlayerLeave
	WaitMovement
	SetVar 0x502E, 0
	HidePerson 1
	SetFlag 0x2065
	HidePerson 2
	SetFlag 0x2066
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	CanvasCredits
	CanvasCloseMsg
	ReleaseAll
	End
	
IndigoPlateau_Exterior_EventScript_PlayCreditsMusic:
	// (music MUS_CREDITS: no HeartGold match yet)
	Return

_cv_stop:
	NPCMsg msg_0521_T10_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
IndigoPlateau_Exterior_Movement_RivalExitBuilding:
	WalkFastSouth
	EndMovement

	.balign 4, 0
IndigoPlateau_Exterior_Movement_PushPlayerOutOfWay:
	FaceEast
	LockDir
	WalkNormalWest
	UnlockDir
	EndMovement

	.balign 4, 0
IndigoPlateau_Exterior_Movement_PlayerWatchRivalLeave:
	Delay16
	Delay4
	WalkOnSpotFasterSouth
	EndMovement

	.balign 4, 0
IndigoPlateau_Exterior_Movement_RivalLeave:
	WalkFastSouth 7
	EndMovement

	.balign 4, 0
IndigoPlateau_Exterior_Movement_OakExitBuilding:
	WalkNormalSouth
	EndMovement

	.balign 4, 0
IndigoPlateau_Exterior_Movement_PlayerWatchOakLeave:
	Delay8
	WalkOnSpotFasterEast
	Delay16 11
	WalkOnSpotFasterSouth
	EndMovement

	.balign 4, 0
IndigoPlateau_Exterior_Movement_OakLeave:
	WalkOnSpotFasterWest
	Delay16 10
	WalkOnSpotFasterSouth
	Delay16
	WalkNormalSouth 7
	EndMovement

	.balign 4, 0
IndigoPlateau_Exterior_Movement_PlayerBeginLeave:
	WalkNormalEast
	Delay16
	WalkNormalSouth 2
	Delay16 2
	EndMovement

	.balign 4, 0
IndigoPlateau_Exterior_Movement_PlayerFaceLeague:
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
IndigoPlateau_Exterior_Movement_PlayerTurnAround:
	WalkOnSpotFasterSouth
	EndMovement

	.balign 4, 0
IndigoPlateau_Exterior_Movement_PlayerLeave:
	RunSouth 6
	EndMovement
	.balign 4, 0
