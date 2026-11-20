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
	CompareVarToValue 0x8005, 4
	GoToIfNe _cv_next_8
	LoadNPCTrade 13
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_7
_cv_next_8:
	CompareVarToValue 0x8005, 5
	GoToIfNe _cv_next_9
	LoadNPCTrade 14
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_7
_cv_next_9:
	CompareVarToValue 0x8005, 6
	GoToIfNe _cv_next_10
	LoadNPCTrade 15
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_7
_cv_next_10:
	CompareVarToValue 0x8005, 7
	GoToIfNe _cv_next_11
	LoadNPCTrade 16
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_7
_cv_next_11:
	CompareVarToValue 0x8005, 8
	GoToIfNe _cv_next_12
	LoadNPCTrade 17
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_7
_cv_next_12:
	CompareVarToValue 0x8005, 9
	GoToIfNe _cv_next_13
	LoadNPCTrade 18
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_7
_cv_next_13:
	CompareVarToValue 0x8005, 10
	GoToIfNe _cv_next_14
	LoadNPCTrade 19
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_7
_cv_next_14:
	CompareVarToValue 0x8005, 11
	GoToIfNe _cv_next_15
	LoadNPCTrade 20
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_7
_cv_next_15:
	CompareVarToValue 0x8005, 12
	GoToIfNe _cv_next_16
	LoadNPCTrade 21
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_7
_cv_next_16:
_cv_done_7:
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
	CloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	ScrCmd_566
	GetPartySelection 0x8004
	RestoreOverworld
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	LockAll
	FacePlayer
	Return
	
EventScript_GetInGameTradeSpecies:
	GetPartyMonSpecies 0x8004, VAR_SPECIAL_RESULT
	Return
	
VermilionCity_House2_EventScript_NotRequestedMon:
	BufferSpeciesName 0, 0x8009, 0, 0
	NPCMsg msg_0489_T06R0401_VermilionCity_House2_Text_ThisIsNoMon
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_DoInGameTrade:
	CompareVarToValue 0x8005, 4
	GoToIfNe _cv_next_18
	LoadNPCTrade 13
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_17
_cv_next_18:
	CompareVarToValue 0x8005, 5
	GoToIfNe _cv_next_19
	LoadNPCTrade 14
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_17
_cv_next_19:
	CompareVarToValue 0x8005, 6
	GoToIfNe _cv_next_20
	LoadNPCTrade 15
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_17
_cv_next_20:
	CompareVarToValue 0x8005, 7
	GoToIfNe _cv_next_21
	LoadNPCTrade 16
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_17
_cv_next_21:
	CompareVarToValue 0x8005, 8
	GoToIfNe _cv_next_22
	LoadNPCTrade 17
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_17
_cv_next_22:
	CompareVarToValue 0x8005, 9
	GoToIfNe _cv_next_23
	LoadNPCTrade 18
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_17
_cv_next_23:
	CompareVarToValue 0x8005, 10
	GoToIfNe _cv_next_24
	LoadNPCTrade 19
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_17
_cv_next_24:
	CompareVarToValue 0x8005, 11
	GoToIfNe _cv_next_25
	LoadNPCTrade 20
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_17
_cv_next_25:
	CompareVarToValue 0x8005, 12
	GoToIfNe _cv_next_26
	LoadNPCTrade 21
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_17
_cv_next_26:
_cv_done_17:
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
