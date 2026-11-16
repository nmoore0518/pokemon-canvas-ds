#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T07R0205.h"
#include "msgdata/msg/msg_0505_T07R0205.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's CeladonCity_Condominiums_RoofRoom_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef CeladonCity_Condominiums_RoofRoom_EventScript_BlackBelt
	ScrDef CeladonCity_Condominiums_RoofRoom_EventScript_EeveeBall
	ScrDef CeladonCity_Condominiums_RoofRoom_EventScript_Blackboard
	ScrDef CeladonCity_Condominiums_RoofRoom_EventScript_TMsPamphlet
	ScrDefEnd
	
CeladonCity_Condominiums_RoofRoom_EventScript_BlackBelt:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0505_T07R0205_CeladonCity_Condominiums_RoofRoom_Text_TheresNothingIDontKnow
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_Condominiums_RoofRoom_EventScript_EeveeBall:
	LockAll
	FacePlayer
	SetVar 0x4001, SPECIES_EEVEE
	GiveMon SPECIES_EEVEE, 25, 0, 0, 0, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CeladonCity_Condominiums_RoofRoom_EventScript_GetEeveeParty
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq CeladonCity_Condominiums_RoofRoom_EventScript_GetEeveePC
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq Common_EventScript_NoMoreRoomForPokemon
	ReleaseAll
	End
	
CeladonCity_Condominiums_RoofRoom_EventScript_Blackboard:
	LockAll
	NPCMsg msg_0505_T07R0205_CeladonCity_Condominiums_RoofRoom_Text_WirelessAdapterLecture
	WaitButton
	NPCMsg msg_0505_T07R0205_CeladonCity_Condominiums_RoofRoom_Text_ReadWhichHeading
	SetVar 0x8004, 4
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0505_T07R0205_cv_mc_linked_direct_union_0, 0
	ScrCmd_559 msg_0505_T07R0205_cv_mc_linked_direct_union_1, 1
	ScrCmd_559 msg_0505_T07R0205_cv_mc_linked_direct_union_2, 2
	ScrCmd_559 msg_0505_T07R0205_cv_mc_linked_direct_union_3, 3
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_2
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CeladonCity_Condominiums_RoofRoom_EventScript_WirelessClub
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq CeladonCity_Condominiums_RoofRoom_EventScript_DirectCorner
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq CeladonCity_Condominiums_RoofRoom_EventScript_UnionRoom
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfEq CeladonCity_Condominiums_RoofRoom_EventScript_ExitBlackboard
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq CeladonCity_Condominiums_RoofRoom_EventScript_ExitBlackboard
	CloseMsg
	End
	
CeladonCity_Condominiums_RoofRoom_EventScript_TMsPamphlet:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0505_T07R0205_CeladonCity_Condominiums_RoofRoom_Text_PamphletOnTMs
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_Condominiums_RoofRoom_EventScript_GetEeveeParty:
	HidePerson 2
	SetFlag 0x2133
	PlayFanfare SEQ_ME_LVUP
	BufferPlayersName 6
	NPCMsg msg_0505_T07R0205_CeladonCity_Condominiums_RoofRoom_Text_ObtainedAnEevee
	WaitFanfare
	BufferSpeciesName 0, SPECIES_EEVEE, 0, 0
	NPCMsg msg_0505_T07R0205_gText_NicknameThisPokemon
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_3
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_4
_cv_yes_3:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CeladonCity_Condominiums_RoofRoom_EventScript_SetGotEevee
	Call Common_EventScript_GetGiftMonPartySlot
	Call Common_EventScript_NameReceivedPartyMon
	GoTo CeladonCity_Condominiums_RoofRoom_EventScript_SetGotEevee
	CloseMsg
	End
	
CeladonCity_Condominiums_RoofRoom_EventScript_GetEeveePC:
	HidePerson 2
	SetFlag 0x2133
	PlayFanfare SEQ_ME_LVUP
	BufferPlayersName 6
	NPCMsg msg_0505_T07R0205_CeladonCity_Condominiums_RoofRoom_Text_ObtainedAnEevee
	WaitFanfare
	BufferSpeciesName 0, SPECIES_EEVEE, 0, 0
	NPCMsg msg_0505_T07R0205_gText_NicknameThisPokemon
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_5
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_6
_cv_yes_5:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_6:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CeladonCity_Condominiums_RoofRoom_EventScript_TransferEeveeToPC
	Call Common_EventScript_NameReceivedBoxMon
	GoTo CeladonCity_Condominiums_RoofRoom_EventScript_TransferEeveeToPC
	CloseMsg
	End
	
Common_EventScript_NoMoreRoomForPokemon:
	NPCMsg msg_0505_T07R0205_gText_NoMoreRoomForPokemon
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_Condominiums_RoofRoom_EventScript_WirelessClub:
	NPCMsg msg_0505_T07R0205_CeladonCity_Condominiums_RoofRoom_Text_ExplainWirelessClub
	WaitButton
	GoTo CeladonCity_Condominiums_RoofRoom_EventScript_ReadAnotherHeading
	CloseMsg
	End
	
CeladonCity_Condominiums_RoofRoom_EventScript_DirectCorner:
	NPCMsg msg_0505_T07R0205_CeladonCity_Condominiums_RoofRoom_Text_ExplainDirectCorner
	WaitButton
	GoTo CeladonCity_Condominiums_RoofRoom_EventScript_ReadAnotherHeading
	CloseMsg
	End
	
CeladonCity_Condominiums_RoofRoom_EventScript_UnionRoom:
	NPCMsg msg_0505_T07R0205_CeladonCity_Condominiums_RoofRoom_Text_ExplainUnionRoom
	WaitButton
	GoTo CeladonCity_Condominiums_RoofRoom_EventScript_ReadAnotherHeading
	CloseMsg
	End
	
CeladonCity_Condominiums_RoofRoom_EventScript_ExitBlackboard:
	ReleaseAll
	End
	
CeladonCity_Condominiums_RoofRoom_EventScript_SetGotEevee:
	SetFlag 0x2134
	ReleaseAll
	End
	
Common_EventScript_GetGiftMonPartySlot:
	// TODO(gba) getpartysize 
	GoTo _cv_stop
	SubVar VAR_SPECIAL_RESULT, 1
	CopyVar 0x8004, VAR_SPECIAL_RESULT
	Return
	
Common_EventScript_NameReceivedPartyMon:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	NicknameInput 0x8004, VAR_SPECIAL_RESULT
	Return
	
CeladonCity_Condominiums_RoofRoom_EventScript_TransferEeveeToPC:
	Call Common_EventScript_TransferredToPC
	GoTo CeladonCity_Condominiums_RoofRoom_EventScript_SetGotEevee
	End
	
Common_EventScript_NameReceivedBoxMon:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	SetVar 0x8004, 0
	NicknameInput 0x8004, VAR_SPECIAL_RESULT
	LockAll
	FacePlayer
	Return
	
CeladonCity_Condominiums_RoofRoom_EventScript_ReadAnotherHeading:
	NPCMsg msg_0505_T07R0205_CeladonCity_Condominiums_RoofRoom_Text_ReadWhichHeading
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0505_T07R0205_cv_mc_linked_direct_union_0, 0
	ScrCmd_559 msg_0505_T07R0205_cv_mc_linked_direct_union_1, 1
	ScrCmd_559 msg_0505_T07R0205_cv_mc_linked_direct_union_2, 2
	ScrCmd_559 msg_0505_T07R0205_cv_mc_linked_direct_union_3, 3
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_8
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_8:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CeladonCity_Condominiums_RoofRoom_EventScript_WirelessClub
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq CeladonCity_Condominiums_RoofRoom_EventScript_DirectCorner
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq CeladonCity_Condominiums_RoofRoom_EventScript_UnionRoom
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfEq CeladonCity_Condominiums_RoofRoom_EventScript_ExitBlackboard
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq CeladonCity_Condominiums_RoofRoom_EventScript_ExitBlackboard
	CloseMsg
	End
	
Common_EventScript_TransferredToPC:
	// TODO(gba) bufferboxname STR_VAR_1, VAR_PC_BOX_TO_SEND_MON
	GoTo _cv_stop
	BufferSpeciesName 1, 0x5024, 0, 0
	CallIfUnset 0x20D0, EventScript_TransferredSomeonesPC
	CallIfSet 0x20D0, EventScript_TransferredLanettesPC
	Return
	
EventScript_TransferredSomeonesPC:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar ShouldShowBoxWasFullMessage
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq EventScript_SomeonesPCBoxFull
	NPCMsg msg_0505_T07R0205_gText_PkmnTransferredSomeonesPC
	WaitButton
	Return
	
EventScript_TransferredLanettesPC:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar ShouldShowBoxWasFullMessage
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq EventScript_LanettesPCBoxFull
	NPCMsg msg_0505_T07R0205_gText_PkmnTransferredLanettesPC
	WaitButton
	Return
	
EventScript_SomeonesPCBoxFull:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar GetPCBoxToSendMon
	GoTo _cv_stop
	// TODO(gba) bufferboxname STR_VAR_3, VAR_RESULT
	GoTo _cv_stop
	NPCMsg msg_0505_T07R0205_gText_PkmnTransferredSomeonesPCBoxFull
	WaitButton
	Return
	
EventScript_LanettesPCBoxFull:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar GetPCBoxToSendMon
	GoTo _cv_stop
	// TODO(gba) bufferboxname STR_VAR_3, VAR_RESULT
	GoTo _cv_stop
	NPCMsg msg_0505_T07R0205_gText_PkmnTransferredLanettesPCBoxFull
	WaitButton
	Return

_cv_stop:
	NPCMsg msg_0505_T07R0205_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
