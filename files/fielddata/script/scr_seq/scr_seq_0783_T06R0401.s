#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T06R0401.h"
#include "msgdata/msg/msg_0489_T06R0401.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's VermilionCity_House2_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef VermilionCity_House2_EventScript_Elyssa
	ScrDef TrainingHouse_EventScript_Serena
	ScrDefEnd
	
VermilionCity_House2_EventScript_Elyssa:
	LockAll
	FacePlayer
	SetVar 0x8008, 7
	Call EventScript_GetInGameTradeSpeciesInfo
	GoToIfSet 0x2124, VermilionCity_House2_EventScript_AlreadyTraded
	NPCMsg msg_0489_T06R0401_VermilionCity_House2_Text_DoYouHaveMonWantToTradeForMyMon
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq VermilionCity_House2_EventScript_DeclineTrade
	Call EventScript_ChooseMonForInGameTrade
	CompareVarToValue 0x8004, 6
	GoToIfGe VermilionCity_House2_EventScript_DeclineTrade
	Call EventScript_GetInGameTradeSpecies
	CompareVarToVar VAR_SPECIAL_RESULT, 0x8009
	GoToIfNe VermilionCity_House2_EventScript_NotRequestedMon
	Call EventScript_DoInGameTrade
	NPCMsg msg_0489_T06R0401_VermilionCity_House2_Text_ThankYou
	WaitButton
	SetFlag 0x2124
	CloseMsg
	ReleaseAll
	End
	
TrainingHouse_EventScript_Serena:
	LockAll
	FacePlayer
	NPCMsg msg_0489_T06R0401_TrainingHouse_Text_SerenaIntro
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_3
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_4
_cv_yes_3:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TrainingHouse_EventScript_Declined
	ClearTrainerFlag 1450
	CheckTrainerFlag 1450
	GoToIf TRUE, _cv_beaten_5
	TrainerBattle 1450, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_6
	WhiteOut
	End
_cv_won_6:
	SetTrainerFlag 1450
	ReleaseAll
	End
_cv_beaten_5:
	NPCMsg msg_0489_T06R0401_TrainingHouse_Text_After
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_GetInGameTradeSpeciesInfo:
	CopyVar 0x8005, 0x8008
	SetVar 0x8009, 0  // TODO(gba) specialvar GetInGameTradeSpeciesInfo
	GoTo _cv_stop
	Return
	
VermilionCity_House2_EventScript_AlreadyTraded:
	NPCMsg msg_0489_T06R0401_VermilionCity_House2_Text_HowIsMyOldMon
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_House2_EventScript_DeclineTrade:
	NPCMsg msg_0489_T06R0401_VermilionCity_House2_Text_ThatsTooBad
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_ChooseMonForInGameTrade:
	// TODO(gba) special ChoosePartyMon
	GoTo _cv_stop
	LockAll
	FacePlayer
	Return
	
EventScript_GetInGameTradeSpecies:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar GetTradeSpecies
	GoTo _cv_stop
	Return
	
VermilionCity_House2_EventScript_NotRequestedMon:
	BufferSpeciesName 0, 0x8009, 0, 0
	NPCMsg msg_0489_T06R0401_VermilionCity_House2_Text_ThisIsNoMon
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_DoInGameTrade:
	// TODO(gba) special CreateInGameTradePokemon
	GoTo _cv_stop
	// TODO(gba) special DoInGameTradeScene
	GoTo _cv_stop
	LockAll
	FacePlayer
	Return
	
TrainingHouse_EventScript_Declined:
	NPCMsg msg_0489_T06R0401_TrainingHouse_Text_Declined
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0489_T06R0401_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
