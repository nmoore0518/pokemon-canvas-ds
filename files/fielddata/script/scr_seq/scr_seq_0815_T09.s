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
	ScrDef _cv_unported_8
	ScrDef _cv_unported_9
	ScrDef CinnabarIsland_EventScript_ReturnFromSeviiIslands
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
	CloseMsg
	ApplyMovement obj_player, CinnabarIsland_Movement_ForcePlayerFromDoor
	WaitMovement
	ReleaseAll
	End
	
CinnabarIsland_OnTransition:
	SetFlag FLAG_SYS_FLYPOINT_CINNABAR
	Call CinnabarIsland_EventScript_CheckUnlockGym
	CompareVarToValue 0x502B, 1
	CallIfEq CinnabarIsland_EventScript_NoSeviiTrip
	CompareVarToValue 0x502C, 1
	CallIfEq CinnabarIsland_EventScript_NoSeviiTrip
	CompareVarToValue 0x502B, 1
	CallIfEq CinnabarIsland_EventScript_ReadyObjectsSailToOneIsland
	CompareVarToValue 0x502B, 3
	CallIfEq CinnabarIsland_EventScript_ReadyObjectsReturnFromSeviiIslands
	CompareVarToValue 0x502C, 1
	CallIfEq CinnabarIsland_EventScript_ReadyObjectsSailToOneIslandFromPokeCenter
	End
	
CinnabarIsland_EventScript_ExitPokeCenterForOneIsland:
	LockAll
	ClearFlag 0x201A
	SetVar 0x502C, 2
	Wait 20, VAR_SPECIAL_RESULT
	Call CinnabarIsland_EventScript_SailToOneIsland
	ReleaseAll
	End
	
CinnabarIsland_EventScript_BillScene:
	LockAll
	CallIfUnset 2, CinnabarIsland_EventScript_BillFacePlayer1
	CallIfSet 2, CinnabarIsland_EventScript_BillFacePlayer2
	PlaySE SEQ_SE_DP_SELECT
	ApplyMovement 3, Common_Movement_ExclamationMark
	WaitMovement
	ApplyMovement 3, Common_Movement_Delay48
	WaitMovement
	CallIfUnset 2, CinnabarIsland_EventScript_BillApproachPlayer1
	CallIfSet 2, CinnabarIsland_EventScript_BillApproachPlayer2
	BufferPlayersName 6
	NPCMsg msg_0519_T09_CinnabarIsland_Text_HeyIfItIsntPlayer
	WaitButton
	NPCMsg msg_0519_T09_CinnabarIsland_Text_ComeWithMeToOneIsland
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq CinnabarIsland_EventScript_AgreeSailToOneIsland
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CinnabarIsland_EventScript_DeclineSailToOneIsland
	CloseMsg
	End
	
CinnabarIsland_EventScript_ReturnFromSeviiIslands:
	LockAll
	NPCMsg msg_0519_T09_CinnabarIsland_Text_IfYouHaveTriPassYouCanGoAgain
	WaitButton
	CloseMsg
	ApplyMovement 3, CinnabarIsland_Movement_BillExit
	WaitMovement
	HidePerson 3
	SetFlag 0x2067
	SetVar 0x502B, 4
	SetFlag 0x206F
	ClearFlag 0x2074
	ReleaseAll
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
	
CinnabarIsland_EventScript_ReadyObjectsSailToOneIsland:
	GetPlayerCoords 0x4014, 0x4015
	SubVar 0x4014, 1028
	SubVar 0x4015, 483
	CompareVarToValue 0x4014, 26
	GoToIfLt _cv_unwiden_3
	CompareVarToValue 0x4014, 27
	GoToIfLt _cv_unwiden_4
	SubVar 0x4014, 1
	GoTo _cv_unwiden_3
_cv_unwiden_4:
	SetVar 0x4014, 26
_cv_unwiden_3:
	CompareVarToValue 0x4014, 13
	GoToIfLt _cv_unwiden_5
	CompareVarToValue 0x4014, 15
	GoToIfLt _cv_unwiden_6
	SubVar 0x4014, 2
	GoTo _cv_unwiden_5
_cv_unwiden_6:
	SetVar 0x4014, 13
_cv_unwiden_5:
	CompareVarToValue 0x4014, 4
	GoToIfLt _cv_unwiden_7
	CompareVarToValue 0x4014, 6
	GoToIfLt _cv_unwiden_8
	SubVar 0x4014, 2
	GoTo _cv_unwiden_7
_cv_unwiden_8:
	SetVar 0x4014, 4
_cv_unwiden_7:
	CompareVarToValue 0x4015, 6
	GoToIfLt _cv_unwiden_9
	CompareVarToValue 0x4015, 9
	GoToIfLt _cv_unwiden_10
	SubVar 0x4015, 3
	GoTo _cv_unwiden_9
_cv_unwiden_10:
	SetVar 0x4015, 6
_cv_unwiden_9:
	CompareVarToValue 0x4014, 18
	GoToIfGe CinnabarIsland_EventScript_MoveSeagallopDown
	SetFlag 2
	MovePerson 3, 1049, 498
	SetObjectMovementType 3, 14
	SetObjectFacing 3, 0
	MovePerson 4, 1062, 498
	Return
	
CinnabarIsland_EventScript_ReadyObjectsReturnFromSeviiIslands:
	MovePerson 3, 1052, 494
	SetObjectMovementType 3, 14
	SetObjectFacing 3, 0
	Return
	
CinnabarIsland_EventScript_ReadyObjectsSailToOneIslandFromPokeCenter:
	SetFlag 2
	MovePerson 3, 1046, 498
	SetObjectMovementType 3, 16
	SetObjectFacing 3, 2
	MovePerson 4, 1062, 498
	Return
	
CinnabarIsland_EventScript_SailToOneIsland:
	CallIfSet 2, CinnabarIsland_EventScript_ApproachShore
	GoToIfUnset 0x2068, _cv_show_11
	ClearFlag 0x2068
	ShowPerson 4
	SetFlag 0x2068
	GoTo _cv_shown_12
_cv_show_11:
	ShowPerson 4
_cv_shown_12:
	CallIfUnset 2, CinnabarIsland_EventScript_BoatArrive
	CallIfSet 2, CinnabarIsland_EventScript_BoatArriveExitedPokeCenter
	NPCMsg msg_0519_T09_CinnabarIsland_Text_MyPalsBoatArrived
	WaitButton
	CloseMsg
	CallIfUnset 2, CinnabarIsland_EventScript_BoardBoat
	CallIfSet 2, CinnabarIsland_EventScript_BoardBoatExitedPokeCenter
	SetVar 0x502B, 2
	HidePerson 3
	SetFlag 0x2067
	Wait 40, VAR_SPECIAL_RESULT
	SetFlag 0x2068
	SetVar 0x502D, 1
	SetVar 0x8004, 8
	SetVar 0x8006, 1
	GoTo EventScript_SetSail
	End
	
CinnabarIsland_EventScript_BillFacePlayer1:
	ApplyMovement 3, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	Return
	
CinnabarIsland_EventScript_BillFacePlayer2:
	ApplyMovement 3, Common_Movement_WalkInPlaceFasterLeft
	WaitMovement
	Return
	
CinnabarIsland_EventScript_BillApproachPlayer1:
	ApplyMovement 3, CinnabarIsland_Movement_BillApproachPlayer1
	WaitMovement
	Return
	
CinnabarIsland_EventScript_BillApproachPlayer2:
	ApplyMovement 3, CinnabarIsland_Movement_BillApproachPlayer2
	WaitMovement
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterRight
	WaitMovement
	Return
	
CinnabarIsland_EventScript_AgreeSailToOneIsland:
	NPCMsg msg_0519_T09_CinnabarIsland_Text_AllRightLetsGo
	WaitButton
	CloseMsg
	Call CinnabarIsland_EventScript_SailToOneIsland
	ReleaseAll
	End
	
CinnabarIsland_EventScript_DeclineSailToOneIsland:
	NPCMsg msg_0519_T09_CinnabarIsland_Text_IllBeWaitingInPokeCenter
	WaitButton
	CloseMsg
	CallIfUnset 2, CinnabarIsland_EventScript_BillExitToPokeCenter
	CallIfSet 2, CinnabarIsland_EventScript_BillReturnToPokeCenter
	HidePerson 3
	SetFlag 0x2067
	SetVar 0x502B, 2
	ClearFlag 0x2069
	ReleaseAll
	End
	
TypeTutor_EventScript_Intro:
	// TODO(gba) special TypeTutor_BufferIntro
	GoTo _cv_stop
	Call _cv_str4
	WaitButton
	// TODO(gba) special TypeTutor_SetMet
	GoTo _cv_stop
	// TODO(gba) special TypeTutor_GetState
	GoTo _cv_stop
	End
	
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
	End
	
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
	GoToIfLt _cv_menu_14
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_14:
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
	
CinnabarIsland_EventScript_MoveSeagallopDown:
	MovePerson 4, 1062, 494
	Return
	
CinnabarIsland_EventScript_ApproachShore:
	ApplyMovement 3, CinnabarIsland_Movement_ApproachShore
	ApplyMovement obj_player, CinnabarIsland_Movement_ApproachShore
	WaitMovement
	Return
	
CinnabarIsland_EventScript_BoatArrive:
	ApplyMovement 3, CinnabarIsland_Movement_BillFaceBoat
	ApplyMovement 4, CinnabarIsland_Movement_BoatArrive
	WaitMovement
	Return
	
CinnabarIsland_EventScript_BoatArriveExitedPokeCenter:
	ApplyMovement 4, CinnabarIsland_Movement_BoatArrive
	WaitMovement
	Return
	
CinnabarIsland_EventScript_BoardBoat:
	ApplyMovement 3, CinnabarIsland_Movement_BillBoardBoat
	ApplyMovement obj_player, CinnabarIsland_Movement_PlayerBoardBoat
	WaitMovement
	Return
	
CinnabarIsland_EventScript_BoardBoatExitedPokeCenter:
	ApplyMovement 3, CinnabarIsland_Movement_BillBoardBoatFromShore
	ApplyMovement obj_player, CinnabarIsland_Movement_PlayerBoardBoatFromShore
	WaitMovement
	Return
	
EventScript_SetSail:
	CloseMsg
	Wait 20, VAR_SPECIAL_RESULT
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special DoSeagallopFerryScene
	GoTo _cv_stop
	End
	
CinnabarIsland_EventScript_BillExitToPokeCenter:
	ApplyMovement 3, CinnabarIsland_Movement_BillExitToPokeCenter
	WaitMovement
	Return
	
CinnabarIsland_EventScript_BillReturnToPokeCenter:
	ApplyMovement obj_player, CinnabarIsland_Movement_PlayerWatchBillExit
	ApplyMovement 3, CinnabarIsland_Movement_BillApproachDoor
	WaitMovement
	ApplyMovement 3, CinnabarIsland_Movement_BillReEnterPokeCenter
	WaitMovement
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

_cv_unported_8:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0519_T09_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_9:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0519_T09_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

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
Common_Movement_ExclamationMark:
	EmoteExclamationMark
	EndMovement

	.balign 4, 0
Common_Movement_Delay48:
	Delay16 3
	EndMovement

	.balign 4, 0
CinnabarIsland_Movement_BillExit:
	WalkNormalSouth 6
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterLeft:
	WalkOnSpotFasterWest
	EndMovement

	.balign 4, 0
CinnabarIsland_Movement_BillApproachPlayer1:
	WalkNormalNorth
	EndMovement

	.balign 4, 0
CinnabarIsland_Movement_BillApproachPlayer2:
	WalkNormalWest 3
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterRight:
	WalkOnSpotFasterEast
	EndMovement

	.balign 4, 0
CinnabarIsland_Movement_ApproachShore:
	WalkNormalEast 6
	EndMovement

	.balign 4, 0
CinnabarIsland_Movement_BillFaceBoat:
	Delay16 2
	Delay8
	WalkOnSpotFasterEast
	EndMovement

	.balign 4, 0
CinnabarIsland_Movement_BoatArrive:
	Delay16 2
	WalkFastWest 2
	WalkNormalWest
	WalkSlowWest 2
	EndMovement

	.balign 4, 0
CinnabarIsland_Movement_BillBoardBoat:
	WalkNormalEast
	WalkNormalSouth 2
	WalkNormalEast
	Delay4
	SetInvisible
	EndMovement

	.balign 4, 0
CinnabarIsland_Movement_PlayerBoardBoat:
	WalkNormalSouth
	WalkNormalEast
	WalkNormalSouth 2
	WalkOnSpotFasterEast
	Delay4
	WalkNormalEast
	Delay4
	SetInvisible
	EndMovement

	.balign 4, 0
CinnabarIsland_Movement_BillBoardBoatFromShore:
	WalkNormalEast
	Delay4
	SetInvisible
	EndMovement

	.balign 4, 0
CinnabarIsland_Movement_PlayerBoardBoatFromShore:
	WalkNormalEast
	Delay4
	WalkNormalEast
	Delay4
	SetInvisible
	EndMovement

	.balign 4, 0
CinnabarIsland_Movement_BillExitToPokeCenter:
	WalkNormalEast
	WalkNormalSouth 6
	EndMovement

	.balign 4, 0
CinnabarIsland_Movement_PlayerWatchBillExit:
	WalkNormalWest
	WalkOnSpotFasterEast
	EndMovement

	.balign 4, 0
CinnabarIsland_Movement_BillApproachDoor:
	Delay16
	WalkNormalWest
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
CinnabarIsland_Movement_BillReEnterPokeCenter:
	WalkNormalNorth
	Delay4
	SetInvisible
	EndMovement
	.balign 4, 0
