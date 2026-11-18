#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_EXOTIC_SAFARI_HALL.h"
#include "msgdata/msg/msg_0970_CV_CANVAS_EXOTIC_SAFARI_HALL.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's ExoticSafari_Hall by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef ExoticSafari_Hall_EventScript_Attendant
	ScrDef ExoticSafari_Hall_EventScript_AttendantDesk
	ScrDef ExoticSafari_Hall_EventScript_Kiosk
	ScrDef ExoticSafari_Hall_EventScript_EvoKiosk
	ScrDef ExoticSafari_Hall_EventScript_DoorJohto
	ScrDef ExoticSafari_Hall_EventScript_DoorHoenn
	ScrDef ExoticSafari_Hall_EventScript_DoorSinnoh
	ScrDef ExoticSafari_Hall_EventScript_DoorUnova
	ScrDef ExoticSafari_Hall_EventScript_DoorKalos
	ScrDef ExoticSafari_Hall_EventScript_DoorAlola
	ScrDef ExoticSafari_Hall_EventScript_DoorGalar
	ScrDef ExoticSafari_Hall_EventScript_DoorPaldea
	ScrDef ExoticSafari_Hall_OnLoad
	ScrDef ExoticSafari_Hall_OnTransition
	ScrDefEnd
	
ExoticSafari_Hall_EventScript_Attendant:
	LockAll
	FacePlayer
	GoToIfUnset 0x2008, ExoticSafari_Hall_EventScript_NotOpenYet
	BufferPlayersName 6
	NPCMsg msg_0970_CV_CANVAS_EXOTIC_SAFARI_HALL_ExoticSafari_Hall_Text_Pitch
	WaitButton
	ShowMoneyBox 20, 2
	NPCMsg msg_0970_CV_CANVAS_EXOTIC_SAFARI_HALL_ExoticSafari_Hall_Text_Offer
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq ExoticSafari_Hall_EventScript_NoThanks
	HasEnoughMoneyImmediate VAR_SPECIAL_RESULT, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq ExoticSafari_Hall_EventScript_NoMoney
	SubMoneyImmediate 0
	UpdateMoneyBox
	PlaySE SEQ_SE_DP_SELECT
	NPCMsg msg_0970_CV_CANVAS_EXOTIC_SAFARI_HALL_ExoticSafari_Hall_Text_Thanks
	WaitButton
	HideMoneyBox
	SetFlag 0x2225
	SetVar VAR_SPECIAL_RESULT, 1
	SetFlag 0x2226
	NPCMsg msg_0970_CV_CANVAS_EXOTIC_SAFARI_HALL_ExoticSafari_Hall_Text_TakeALook
	WaitButton
	CloseMsg
	ApplyMovement 127, ExoticSafari_Hall_Movement_CameraUp
	WaitMovement
	Wait 60, VAR_SPECIAL_RESULT
	ApplyMovement 127, ExoticSafari_Hall_Movement_CameraDown
	WaitMovement
	NPCMsg msg_0970_CV_CANVAS_EXOTIC_SAFARI_HALL_ExoticSafari_Hall_Text_GoOnThrough
	WaitButton
	CloseMsg
	ApplyMovement 1, ExoticSafari_Hall_Movement_StepAside
	WaitMovement
	HidePerson 1
	ClearFlag 0x2227
	ShowPerson 2
	ReleaseAll
	End
	
ExoticSafari_Hall_EventScript_AttendantDesk:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	BufferPlayersName 6
	NPCMsg msg_0970_CV_CANVAS_EXOTIC_SAFARI_HALL_ExoticSafari_Hall_Text_Enjoy
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ExoticSafari_Hall_EventScript_Kiosk:
	LockAll
	FacePlayer
	NPCMsg msg_0970_CV_CANVAS_EXOTIC_SAFARI_HALL_ExoticSafari_Hall_Text_Kiosk
	// TODO(gba) special ExoticSafari_Kiosk
	GoTo _cv_stop
	NPCMsg msg_0970_CV_CANVAS_EXOTIC_SAFARI_HALL_gText_PleaseComeAgain
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ExoticSafari_Hall_EventScript_EvoKiosk:
	LockAll
	FacePlayer
	NPCMsg msg_0970_CV_CANVAS_EXOTIC_SAFARI_HALL_ExoticSafari_Hall_Text_EvoKiosk
	// TODO(gba) special ExoticSafari_EvoKiosk
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq ExoticSafari_Hall_EventScript_EvoKioskEmpty
	NPCMsg msg_0970_CV_CANVAS_EXOTIC_SAFARI_HALL_gText_PleaseComeAgain
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ExoticSafari_Hall_EventScript_DoorJohto:
	// TODO(gba) bufferstring STR_VAR_1, ExoticSafari_Hall_Text_Johto
	GoTo _cv_stop
	GoTo ExoticSafari_Hall_EventScript_ShutSign
	
ExoticSafari_Hall_EventScript_DoorHoenn:
	// TODO(gba) bufferstring STR_VAR_1, ExoticSafari_Hall_Text_Hoenn
	GoTo _cv_stop
	GoTo ExoticSafari_Hall_EventScript_ShutSign
	
ExoticSafari_Hall_EventScript_DoorSinnoh:
	// TODO(gba) bufferstring STR_VAR_1, ExoticSafari_Hall_Text_Sinnoh
	GoTo _cv_stop
	GoTo ExoticSafari_Hall_EventScript_ShutSign
	
ExoticSafari_Hall_EventScript_DoorUnova:
	End
	
ExoticSafari_Hall_EventScript_DoorKalos:
	End
	
ExoticSafari_Hall_EventScript_DoorAlola:
	End
	
ExoticSafari_Hall_EventScript_DoorGalar:
	End
	
ExoticSafari_Hall_EventScript_DoorPaldea:
	End
	
ExoticSafari_Hall_OnLoad:
	// TODO(gba) special ExoticSafari_OnLoad
	End
	
ExoticSafari_Hall_OnTransition:
	SetFlag 0x2227
	GoToIfUnset 0x2226, ExoticSafari_Hall_OnTransitionEnd
	ClearFlag 0x2227
	End
	
ExoticSafari_Hall_EventScript_NotOpenYet:
	NPCMsg msg_0970_CV_CANVAS_EXOTIC_SAFARI_HALL_ExoticSafari_Hall_Text_NotOpenYet
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ExoticSafari_Hall_EventScript_NoThanks:
	HideMoneyBox
	NPCMsg msg_0970_CV_CANVAS_EXOTIC_SAFARI_HALL_ExoticSafari_Hall_Text_NoThanks
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ExoticSafari_Hall_EventScript_NoMoney:
	HideMoneyBox
	NPCMsg msg_0970_CV_CANVAS_EXOTIC_SAFARI_HALL_ExoticSafari_Hall_Text_NoMoney
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ExoticSafari_Hall_EventScript_EvoKioskEmpty:
	NPCMsg msg_0970_CV_CANVAS_EXOTIC_SAFARI_HALL_ExoticSafari_Hall_Text_EvoKioskEmpty
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ExoticSafari_Hall_EventScript_ShutSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0970_CV_CANVAS_EXOTIC_SAFARI_HALL_ExoticSafari_Hall_Text_Shut
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ExoticSafari_Hall_OnTransitionEnd:
	End

_cv_stop:
	NPCMsg msg_0970_CV_CANVAS_EXOTIC_SAFARI_HALL_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
ExoticSafari_Hall_Movement_CameraUp:
	WalkNormalNorth 5
	EndMovement

	.balign 4, 0
ExoticSafari_Hall_Movement_CameraDown:
	WalkNormalSouth 5
	EndMovement

	.balign 4, 0
ExoticSafari_Hall_Movement_StepAside:
	WalkNormalNorth
	WalkNormalWest
	FaceSouth
	EndMovement
	.balign 4, 0
