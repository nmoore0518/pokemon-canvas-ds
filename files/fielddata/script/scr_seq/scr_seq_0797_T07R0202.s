#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T07R0202.h"
#include "msgdata/msg/msg_0502_T07R0202.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's CeladonCity_Condominiums_2F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef EventMons_EventScript_CostumeMaker
	ScrDef CeladonCity_Condominiums_2F_EventScript_MeetingRoomSign
	ScrDef CeladonCity_Condominiums_2F_EventScript_PokemonJournalErika
	ScrDefEnd
	
EventMons_EventScript_CostumeMaker:
	LockAll
	FacePlayer
	GoToIfUnset 0x2008, EventMons_EventScript_CostumeNotYet
	GoToIfSet 0x2132, EventMons_EventScript_CostumeMenu
	NPCMsg msg_0502_T07R0202_EventMons_Text_CostumeIntro
	WaitButton
	SetVar 0x8004, 0
	SetVar 0x8005, 50
	SetVar 0x8006, 0
	Call EventMons_EventScript_Gift
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq EventMons_EventScript_ReleaseEnd
	SetFlag 0x2132
	NPCMsg msg_0502_T07R0202_EventMons_Text_CostumeExplain
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_Condominiums_2F_EventScript_MeetingRoomSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0502_T07R0202_CeladonCity_Condominiums_2F_Text_GameFreakMeetingRoom
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_Condominiums_2F_EventScript_PokemonJournalErika:
	LockAll
	FacePlayer
	NPCMsg msg_0502_T07R0202_PokemonJournal_Text_SpecialFeatureErika
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventMons_EventScript_CostumeNotYet:
	NPCMsg msg_0502_T07R0202_EventMons_Text_CostumeNotYet
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventMons_EventScript_CostumeMenu:
	// TODO(gba) special EventMons_CostumeCount
	GoTo _cv_stop
	NPCMsg msg_0502_T07R0202_EventMons_Text_CostumeAsk
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq EventMons_EventScript_CostumeHints
	NPCMsg msg_0502_T07R0202_EventMons_Text_CostumeWhich
	WaitButton
	// TODO(gba) special ChoosePartyMon
	GoTo _cv_stop
	CompareVarToValue 0x8004, 6
	GoToIfGe EventMons_EventScript_CostumeLater
	// TODO(gba) special EventMons_CostumeCheckMon
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq EventMons_EventScript_CostumeNotPikachu
	NPCMsg msg_0502_T07R0202_EventMons_Text_CostumePick
	SetVar 0x8005, 1
	// TODO(gba) special EventMons_CostumeUnlocked
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq EventMons_EventScript_PushRockStar
	SetVar 0x8005, 2
	// TODO(gba) special EventMons_CostumeUnlocked
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq EventMons_EventScript_PushBelle
	SetVar 0x8005, 3
	// TODO(gba) special EventMons_CostumeUnlocked
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq EventMons_EventScript_PushPopStar
	SetVar 0x8005, 4
	// TODO(gba) special EventMons_CostumeUnlocked
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq EventMons_EventScript_PushPhd
	SetVar 0x8005, 5
	// TODO(gba) special EventMons_CostumeUnlocked
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq EventMons_EventScript_PushLibre
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0502_T07R0202_EventMons_Text_CostumeCosplay, 0
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_4
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq EventMons_EventScript_CostumeLater
	CopyVar 0x8005, VAR_SPECIAL_RESULT
	// TODO(gba) special EventMons_SetCostume
	GoTo _cv_stop
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	NPCMsg msg_0502_T07R0202_EventMons_Text_CostumeDone
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventMons_EventScript_Gift:
	// TODO(gba) special EventMons_GiveMon
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq EventMons_EventScript_GiftFull
	PlayFanfare SEQ_ME_LVUP
	BufferPlayersName 6
	NPCMsg msg_0502_T07R0202_EventMons_Text_Received
	WaitFanfare
	SetVar VAR_SPECIAL_RESULT, 1
	Return
	
EventMons_EventScript_ReleaseEnd:
	ReleaseAll
	End
	
EventMons_EventScript_CostumeHints:
	NPCMsg msg_0502_T07R0202_EventMons_Text_CostumeExplain
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventMons_EventScript_CostumeLater:
	NPCMsg msg_0502_T07R0202_EventMons_Text_CostumeLater
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventMons_EventScript_CostumeNotPikachu:
	NPCMsg msg_0502_T07R0202_EventMons_Text_CostumeNotPikachu
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventMons_EventScript_PushRockStar:
	Return
	
EventMons_EventScript_PushBelle:
	Return
	
EventMons_EventScript_PushPopStar:
	Return
	
EventMons_EventScript_PushPhd:
	Return
	
EventMons_EventScript_PushLibre:
	Return
	
EventMons_EventScript_GiftFull:
	NPCMsg msg_0502_T07R0202_EventMons_Text_NoRoom
	WaitButton
	SetVar VAR_SPECIAL_RESULT, 0
	Return

_cv_stop:
	NPCMsg msg_0502_T07R0202_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
