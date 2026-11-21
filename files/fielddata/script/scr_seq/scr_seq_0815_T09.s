#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T09.h"
#include "msgdata/msg/msg_0519_T09.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's CinnabarIsland_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef CinnabarIsland_EventScript_Woman
	ScrDef CinnabarIsland_EventScript_OldMan
	ScrDef TypeTutor_EventScript_Fire
	ScrDef CinnabarIsland_EventScript_IslandSign
	ScrDef CinnabarIsland_EventScript_PokemonLabSign
	ScrDef CinnabarIsland_EventScript_GymSign
	ScrDef CinnabarIsland_EventScript_GymDoorLocked
	ScrDef CinnabarIsland_OnTransition
	ScrDefEnd
	
CinnabarIsland_EventScript_Woman:
	LockAll
	FacePlayer
	NPCMsg msg_0519_T09_CinnabarIsland_Text_BlaineLivedHereSinceBeforeLab
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_EventScript_OldMan:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0519_T09_CinnabarIsland_Text_ScientistsExperimentInMansion
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TypeTutor_EventScript_Fire:
	LockAll
	FacePlayer
	SetVar 0x8004, 17
	GoTo TypeTutor_EventScript_Talk
	
CinnabarIsland_EventScript_IslandSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0519_T09_CinnabarIsland_Text_IslandSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_EventScript_PokemonLabSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0519_T09_CinnabarIsland_Text_PokemonLab
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_EventScript_GymSign:
	LockAll
	NPCMsg msg_0519_T09_CinnabarIsland_Text_GymSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_EventScript_GymDoorLocked:
	LockAll
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	Wait 20, VAR_SPECIAL_RESULT
	NPCMsg msg_0519_T09_CinnabarIsland_Text_DoorIsLocked
	WaitButton
	CanvasCloseMsg
	ApplyMovement obj_player, CinnabarIsland_Movement_ForcePlayerFromDoor
	WaitMovement
	CanvasCloseMsg
	ReleaseAll
	End
	
CinnabarIsland_OnTransition:
	SetFlag FLAG_SYS_FLYPOINT_CINNABAR
	Call CinnabarIsland_EventScript_CheckUnlockGym
	CompareVarToValue 0x502B, 1
	CallIfEq CinnabarIsland_EventScript_NoSeviiTrip
	CompareVarToValue 0x502C, 1
	CallIfEq CinnabarIsland_EventScript_NoSeviiTrip
	End
	
TypeTutor_EventScript_Talk:
	CopyVar 0x8008, 0x8004
	// TODO(gba) special TypeTutor_GetState
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TypeTutor_EventScript_Intro
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq TypeTutor_EventScript_Trial
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq TypeTutor_EventScript_JustDone
	GoTo TypeTutor_EventScript_Teach
	
CinnabarIsland_EventScript_CheckUnlockGym:
	GoToIfSet 0x20FC, CinnabarIsland_EventScript_UnlockGym
	Return
	
CinnabarIsland_EventScript_NoSeviiTrip:
	SetVar 0x502B, 0
	SetVar 0x502C, 0
	SetFlag 0x2067
	SetFlag 0x2069
	Return
	
TypeTutor_EventScript_Intro:
	// TODO(gba) special TypeTutor_BufferIntro
	GoTo _cv_stop
	Call _cv_str4
	WaitButton
	// TODO(gba) special TypeTutor_SetMet
	GoTo _cv_stop
	// TODO(gba) special TypeTutor_GetState
	GoTo _cv_stop
	GoTo TypeTutor_EventScript_Trial
	
TypeTutor_EventScript_Trial:
	// TODO(gba) special TypeTutor_BufferTrial
	GoTo _cv_stop
	Call _cv_str4
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TypeTutor_EventScript_JustDone:
	// TODO(gba) special TypeTutor_BufferDone
	GoTo _cv_stop
	Call _cv_str4
	WaitButton
	// TODO(gba) special TypeTutor_SetOpened
	GoTo _cv_stop
	GoTo TypeTutor_EventScript_Teach
	
TypeTutor_EventScript_Teach:
	CopyVar 0x8004, 0x8008
	NPCMsg msg_0519_T09_TypeTutor_Text_WhichMove
	// TODO(gba) special TypeTutor_PushMoves
	GoTo _cv_stop
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_2
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq TypeTutor_EventScript_Bye
	CopyVar 0x8004, 0x8008
	// TODO(gba) special TypeTutor_SelectMove
	GoTo _cv_stop
	NPCMsg msg_0519_T09_TypeTutor_Text_WhichMon
	WaitButton
	Call EventScript_ChooseMoveTutorMon
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TypeTutor_EventScript_Teach
	NPCMsg msg_0519_T09_TypeTutor_Text_Taught
	WaitButton
	GoTo TypeTutor_EventScript_Teach
	
CinnabarIsland_EventScript_UnlockGym:
	SetVar 0x4001, 1
	Return
	
TypeTutor_EventScript_Bye:
	NPCMsg msg_0519_T09_TypeTutor_Text_Bye
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_ChooseMoveTutorMon:
	// TODO(gba) special ChooseMonForMoveTutor
	GoTo _cv_stop
	LockAll
	FacePlayer
	Return

_cv_str4:
	BufferPlayersName 6
	BufferRivalsName 7
	Return

_cv_stop:
	NPCMsg msg_0519_T09_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
Common_Movement_WalkInPlaceFasterUp:
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
CinnabarIsland_Movement_ForcePlayerFromDoor:
	WalkNormalSouth
	EndMovement
	.balign 4, 0
