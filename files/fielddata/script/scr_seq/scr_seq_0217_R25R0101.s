#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R25R0101.h"
#include "msgdata/msg/msg_0364_R25R0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route25_SeaCottage_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route25_SeaCottage_EventScript_Bill
	ScrDef Route25_SeaCottage_EventScript_Computer
	ScrDef Route25_SeaCottage_OnTransition
	ScrDefEnd
	
Route25_SeaCottage_EventScript_Bill:
	LockAll
	FacePlayer
	GoToIfSet 3, Route25_SeaCottage_EventScript_BillGoLookAtPC
	GoToIfSet 0x20D3, Route25_SeaCottage_EventScript_BillGoToSSAnne
	GoToIfSet 0x20EA, Route25_SeaCottage_EventScript_BillGiveSSTicket
	GetPlayerGender VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Route25_SeaCottage_EventScript_BillAskForHelpMale
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Route25_SeaCottage_EventScript_BillAskForHelpFemale
	End
	
Route25_SeaCottage_EventScript_Computer:
	LockAll
	GoToIfSet 3, Route25_SeaCottage_EventScript_OpenBillsMonList
	GoToIfSet 2, Route25_SeaCottage_EventScript_RunCellSeparator
	NPCMsg msg_0364_R25R0101_Route25_SeaCottage_Text_TeleporterIsDisplayed
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route25_SeaCottage_OnTransition:
	CallIfUnset 0x20EA, Route25_SeaCottage_EventScript_HideClefairyBill
	CallIfSet 0x20D3, Route25_SeaCottage_EventScript_SetReturnedAfterSSTicket
	End
	
Route25_SeaCottage_EventScript_BillGoLookAtPC:
	NPCMsg msg_0364_R25R0101_Route25_SeaCottage_Text_CheckOutRareMonsOnPC
	WaitButton
	Call EventScript_BillGivesPalmPilot
	CloseMsg
	ReleaseAll
	End
	
Route25_SeaCottage_EventScript_BillGoToSSAnne:
	NPCMsg msg_0364_R25R0101_Route25_SeaCottage_Text_SSAnnePartyYouGoInstead
	WaitButton
	Call EventScript_BillGivesPalmPilot
	CloseMsg
	ReleaseAll
	End
	
Route25_SeaCottage_EventScript_BillGiveSSTicket:
	GetPlayerGender VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	CallIfEq Route25_SeaCottage_EventScript_BillThanksMale
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq Route25_SeaCottage_EventScript_BillThanksFemale
	HasSpaceForItem 456, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Route25_SeaCottage_EventScript_NoRoomForSSTicket
	GiveItem 456, 1, VAR_SPECIAL_RESULT
	BufferItemName 1, 456
	BufferPlayersName 6
	NPCMsg msg_0364_R25R0101_Route25_SeaCottage_Text_ReceivedSSTicketFromBill
	PlayFanfare SEQ_ME_ITEM
	WaitFanfare
	WaitButton
	SetFlag 0x20EC
	SetFlag 0x20E4
	SetFlag 0x20D3
	SetFlag 0x20D0
	GoTo Route25_SeaCottage_EventScript_BillGoToSSAnne
	CloseMsg
	End
	
Route25_SeaCottage_EventScript_BillAskForHelpMale:
	NPCMsg msg_0364_R25R0101_Route25_SeaCottage_Text_ImBillHelpMeOutPal
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	GoTo Route25_SeaCottage_EventScript_BillAskForHelp
	CloseMsg
	End
	
Route25_SeaCottage_EventScript_BillAskForHelpFemale:
	NPCMsg msg_0364_R25R0101_Route25_SeaCottage_Text_ImBillHelpMeOutLady
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_3
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_4
_cv_yes_3:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_4:
	GoTo Route25_SeaCottage_EventScript_BillAskForHelp
	CloseMsg
	End
	
Route25_SeaCottage_EventScript_OpenBillsMonList:
	NPCMsg msg_0364_R25R0101_Route25_SeaCottage_Text_BillsFavoriteMonList
	WaitButton
	GoTo Route25_SeaCottage_EventScript_BillsMonList
	CloseMsg
	End
	
Route25_SeaCottage_EventScript_RunCellSeparator:
	BufferPlayersName 6
	NPCMsg msg_0364_R25R0101_Route25_SeaCottage_Text_InitiatedTeleportersCellSeparator
	WaitButton
	CloseMsg
	ClearFlag 2
	SetFlag 0x20EA
	ApplyMovement 127, Route25_SeaCottage_Movement_CameraPanToTeleporters
	WaitMovement
	Wait 35, VAR_SPECIAL_RESULT
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	SetVar 0x8004, 0
	PlaySE SEQ_SE_DP_KI_GASYAN
	WaitSE SEQ_SE_DP_KI_GASYAN
	Wait 10, VAR_SPECIAL_RESULT
	Call Route25_SeaCottage_EventScript_PlayTeleporterBeepSE
	Call Route25_SeaCottage_EventScript_PlayTeleporterBeepSE
	Call Route25_SeaCottage_EventScript_PlayTeleporterBeepSE
	Call Route25_SeaCottage_EventScript_PlayTeleporterBeepSE
	Call Route25_SeaCottage_EventScript_PlayTeleporterBeepSE
	Call Route25_SeaCottage_EventScript_PlayTeleporterBeepSE
	Call Route25_SeaCottage_EventScript_PlayTeleporterBeepSE
	SetVar 0x8004, 1
	PlaySE SEQ_SE_DP_KI_GASYAN
	WaitSE SEQ_SE_DP_KI_GASYAN
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	Call Route25_SeaCottage_EventScript_PlayTeleporterBeepSE
	Call Route25_SeaCottage_EventScript_PlayTeleporterBeepSE
	Call Route25_SeaCottage_EventScript_PlayTeleporterBeepSE
	Call Route25_SeaCottage_EventScript_PlayTeleporterBeepSE
	Call Route25_SeaCottage_EventScript_PlayTeleporterBeepSE
	GoToIfUnset 0x205A, _cv_show_5
	ClearFlag 0x205A
	ShowPerson 1
	SetFlag 0x205A
	GoTo _cv_shown_6
_cv_show_5:
	ShowPerson 1
_cv_shown_6:
	ClearFlag 0x205A
	Wait 50, VAR_SPECIAL_RESULT
	PlayFanfare SEQ_ME_LVUP
	ApplyMovement 1, Route25_SeaCottage_Movement_BillExitTeleporter
	WaitMovement
	WaitFanfare
	ApplyMovement 127, Route25_SeaCottage_Movement_CameraPanBackFromTeleporters
	WaitMovement
	PlaySE SEQ_SE_DP_SELECT
	ApplyMovement 1, Route25_SeaCottage_Movement_BillWalkToMiddleOfRoom
	WaitMovement
	ReleaseAll
	End
	
Route25_SeaCottage_EventScript_HideClefairyBill:
	ClearFlag 0x20ED
	MovePerson 1, 3, 5
	Return
	
Route25_SeaCottage_EventScript_SetReturnedAfterSSTicket:
	SetFlag 3
	Return
	
EventScript_BillGivesPalmPilot:
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x20EE, _cv_has_7
	SetVar VAR_SPECIAL_RESULT, 1
_cv_has_7:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq EventScript_PalmPilotReturn
	NPCMsg msg_0364_R25R0101_Text_BillPalmPilot
	WaitButton
	SetFlag 0x20EE
	SetVar VAR_SPECIAL_RESULT, 1
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq EventScript_PalmPilotReturn
	NPCMsg msg_0364_R25R0101_Text_BillPalmPilotHowTo
	WaitButton
	NPCMsg msg_0364_R25R0101_Text_BillPalmPilotSecret
	WaitButton
	GoTo EventScript_PalmPilotReturn
	
Route25_SeaCottage_EventScript_BillThanksMale:
	NPCMsg msg_0364_R25R0101_Route25_SeaCottage_Text_ThanksBudTakeThis
	WaitButton
	Return
	
Route25_SeaCottage_EventScript_BillThanksFemale:
	NPCMsg msg_0364_R25R0101_Route25_SeaCottage_Text_ThanksLadyTakeThis
	WaitButton
	Return
	
Route25_SeaCottage_EventScript_NoRoomForSSTicket:
	NPCMsg msg_0364_R25R0101_Route25_SeaCottage_Text_YouveGotTooMuchStuff
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route25_SeaCottage_EventScript_BillAskForHelp:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	CallIfEq Route25_SeaCottage_EventScript_DeclineHelpBill
	NPCMsg msg_0364_R25R0101_Route25_SeaCottage_Text_RunCellSeparationOnPC
	WaitButton
	CloseMsg
	Wait 10, VAR_SPECIAL_RESULT
	CompareVarToValue 0x5002, 1
	CallIfEq Route25_SeaCottage_EventScript_BillWalkToTeleporterSouth
	CompareVarToValue 0x5002, 0
	CallIfEq Route25_SeaCottage_EventScript_BillWalkToTeleporter
	CompareVarToValue 0x5002, 2
	CallIfEq Route25_SeaCottage_EventScript_BillWalkToTeleporter
	CompareVarToValue 0x5002, 3
	CallIfEq Route25_SeaCottage_EventScript_BillWalkToTeleporter
	ApplyMovement 2, Route25_SeaCottage_Movement_BillEnterTeleporter
	WaitMovement
	HidePerson 2
	SetFlag 0x20ED
	PlaySE SEQ_SE_DP_SELECT
	SetFlag 2
	ReleaseAll
	End
	
Route25_SeaCottage_EventScript_BillsMonList:
	NPCMsg msg_0364_R25R0101_Route25_SeaCottage_Text_SeeWhichMon
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0364_R25R0101_cv_mc_eeveelutions_0, 0
	ScrCmd_559 msg_0364_R25R0101_cv_mc_eeveelutions_1, 1
	ScrCmd_559 msg_0364_R25R0101_cv_mc_eeveelutions_2, 2
	ScrCmd_559 msg_0364_R25R0101_cv_mc_eeveelutions_3, 3
	ScrCmd_559 msg_0364_R25R0101_cv_mc_eeveelutions_4, 4
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_9
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_9:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Route25_SeaCottage_EventScript_ViewEevee
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Route25_SeaCottage_EventScript_ViewFlareon
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq Route25_SeaCottage_EventScript_ViewJolteon
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfEq Route25_SeaCottage_EventScript_ViewVaporeon
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfEq Route25_SeaCottage_EventScript_ExitBillsMonList
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq Route25_SeaCottage_EventScript_ExitBillsMonList
	CloseMsg
	End
	
Route25_SeaCottage_EventScript_PlayTeleporterBeepSE:
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	Wait 20, VAR_SPECIAL_RESULT
	Return
	
EventScript_PalmPilotReturn:
	Return
	
Route25_SeaCottage_EventScript_DeclineHelpBill:
	GetPlayerGender VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	CallIfEq Route25_SeaCottage_EventScript_DeclineHelpBillMale
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq Route25_SeaCottage_EventScript_DeclineHelpBillFemale
	Return
	
Route25_SeaCottage_EventScript_BillWalkToTeleporterSouth:
	ApplyMovement 2, Route25_SeaCottage_Movement_BillWalkToTeleporterSouth
	WaitMovement
	Return
	
Route25_SeaCottage_EventScript_BillWalkToTeleporter:
	ApplyMovement 2, Route25_SeaCottage_Movement_BillWalkToTeleporter
	WaitMovement
	Return
	
Route25_SeaCottage_EventScript_ViewEevee:
	WaitButton
	SetVar 0x8004, SPECIES_EEVEE
	GoTo Route25_SeaCottage_EventScript_BillsMonList
	End
	
Route25_SeaCottage_EventScript_ViewFlareon:
	WaitButton
	SetVar 0x8004, SPECIES_FLAREON
	GoTo Route25_SeaCottage_EventScript_BillsMonList
	End
	
Route25_SeaCottage_EventScript_ViewJolteon:
	WaitButton
	SetVar 0x8004, SPECIES_JOLTEON
	GoTo Route25_SeaCottage_EventScript_BillsMonList
	End
	
Route25_SeaCottage_EventScript_ViewVaporeon:
	WaitButton
	SetVar 0x8004, SPECIES_VAPOREON
	GoTo Route25_SeaCottage_EventScript_BillsMonList
	End
	
Route25_SeaCottage_EventScript_ExitBillsMonList:
	ReleaseAll
	End
	
Route25_SeaCottage_EventScript_DeclineHelpBillMale:
	NPCMsg msg_0364_R25R0101_Route25_SeaCottage_Text_NoPleaseChief
	WaitButton
	Return
	
Route25_SeaCottage_EventScript_DeclineHelpBillFemale:
	NPCMsg msg_0364_R25R0101_Route25_SeaCottage_Text_NoPleaseBeautiful
	WaitButton
	Return

_cv_stop:
	NPCMsg msg_0364_R25R0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
Route25_SeaCottage_Movement_CameraPanToTeleporters:
	WalkNormalNorth 2
	WalkNormalEast 2
	EndMovement

	.balign 4, 0
Route25_SeaCottage_Movement_BillExitTeleporter:
	WalkNormalSouth
	EndMovement

	.balign 4, 0
Route25_SeaCottage_Movement_CameraPanBackFromTeleporters:
	Delay16 2
	WalkNormalSouth 2
	WalkNormalWest 2
	EndMovement

	.balign 4, 0
Route25_SeaCottage_Movement_BillWalkToMiddleOfRoom:
	WalkNormalEast 4
	WalkNormalSouth 2
	EndMovement

	.balign 4, 0
Route25_SeaCottage_Movement_BillEnterTeleporter:
	WalkNormalNorth
	EndMovement

	.balign 4, 0
Route25_SeaCottage_Movement_BillWalkToTeleporterSouth:
	WalkNormalEast
	WalkNormalNorth 2
	WalkNormalWest
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
Route25_SeaCottage_Movement_BillWalkToTeleporter:
	WalkNormalNorth 2
	EndMovement
	.balign 4, 0
