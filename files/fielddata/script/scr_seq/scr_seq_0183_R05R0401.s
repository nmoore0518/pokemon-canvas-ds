#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R05R0401.h"
#include "msgdata/msg/msg_0333_R05R0401.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route5_PokemonDayCare_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route5_PokemonDayCare_EventScript_DaycareMan
	ScrDefEnd
	
Route5_PokemonDayCare_EventScript_DaycareMan:
	LockAll
	FacePlayer
	ShowMoneyBox 20, 2
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar IsThereMonInRoute5Daycare
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Route5_PokemonDayCare_EventScript_CheckOnMon
	NPCMsg msg_0333_R05R0401_Route5_PokemonDayCare_Text_WantMeToRaiseMon
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Route5_PokemonDayCare_EventScript_TryGiveMon
	NPCMsg msg_0333_R05R0401_Route5_PokemonDayCare_Text_ComeAgain
	WaitButton
	GoTo Route5_PokemonDayCare_EventScript_CloseMoneyBox
	CloseMsg
	End
	
Route5_PokemonDayCare_EventScript_CheckOnMon:
	SetVar 0x8004, 0
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar GetNumLevelsGainedForRoute5DaycareMon
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	CallIfNe Route5_PokemonDayCare_EventScript_MonHasGrownByXLevels
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	CallIfEq Route5_PokemonDayCare_EventScript_NotEnoughTime
	// TODO(gba) special GetCostToWithdrawRoute5DaycareMon
	GoTo _cv_stop
	NPCMsg msg_0333_R05R0401_Route5_PokemonDayCare_Text_OweMeXForMonsReturn
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_3
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_4
_cv_yes_3:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Route5_PokemonDayCare_EventScript_TryRetrieveMon
	GoTo Route5_PokemonDayCare_EventScript_ComeAgain
	CloseMsg
	End
	
Route5_PokemonDayCare_EventScript_TryGiveMon:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar CountPartyNonEggMons
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Route5_PokemonDayCare_EventScript_OnlyOneMonInParty
	NPCMsg msg_0333_R05R0401_Route5_PokemonDayCare_Text_WhichMonShouldIRaise
	WaitButton
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	HideMoneyBox
	// TODO(gba) special ChooseSendDaycareMon
	GoTo _cv_stop
	ShowMoneyBox 20, 2
	CompareVarToValue 0x8004, 6
	GoToIfGe Route5_PokemonDayCare_EventScript_ComeAgain
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar CountPartyAliveNonEggMons_IgnoreVar0x8004Slot
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Route5_PokemonDayCare_EventScript_OnlyOneAliveMonInParty
	SetVar 0x8005, 0  // TODO(gba) specialvar GetSelectedMonNicknameAndSpecies
	GoTo _cv_stop
	NPCMsg msg_0333_R05R0401_Route5_PokemonDayCare_Text_LookAfterMonForAWhile
	WaitButton
	WaitSE SEQ_SE_DP_SELECT
	PlayCry 0x8005, 0
	NPCMsg msg_0333_R05R0401_Route5_PokemonDayCare_Text_ComeSeeMeInAWhile
	WaitButton
	WaitCry
	// TODO(gba) special PutMonInRoute5Daycare
	GoTo _cv_stop
	// TODO(gba) incrementgamestat GAME_STAT_USED_DAYCARE
	GoTo _cv_stop
	GoTo Route5_PokemonDayCare_EventScript_CloseMoneyBox
	CloseMsg
	End
	
Route5_PokemonDayCare_EventScript_CloseMoneyBox:
	HideMoneyBox
	ReleaseAll
	End
	
Route5_PokemonDayCare_EventScript_MonHasGrownByXLevels:
	NPCMsg msg_0333_R05R0401_Route5_PokemonDayCare_Text_MonHasGrownByXLevels
	WaitButton
	Return
	
Route5_PokemonDayCare_EventScript_NotEnoughTime:
	NPCMsg msg_0333_R05R0401_Route5_PokemonDayCare_Text_MonNeedsToSpendMoreTime
	WaitButton
	Return
	
Route5_PokemonDayCare_EventScript_TryRetrieveMon:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar CalculatePlayerPartyCount
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 6
	GoToIfEq Route5_PokemonDayCare_EventScript_NoRoomInParty
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar IsEnoughForCostInVar0x8005
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Route5_PokemonDayCare_EventScript_RetrieveMon
	NPCMsg msg_0333_R05R0401_Route5_PokemonDayCare_Text_DontHaveEnoughMoney
	WaitButton
	GoTo Route5_PokemonDayCare_EventScript_CloseMoneyBox
	CloseMsg
	End
	
Route5_PokemonDayCare_EventScript_ComeAgain:
	NPCMsg msg_0333_R05R0401_Route5_PokemonDayCare_Text_ComeAnytimeYouLike
	WaitButton
	GoTo Route5_PokemonDayCare_EventScript_CloseMoneyBox
	CloseMsg
	End
	
Route5_PokemonDayCare_EventScript_OnlyOneMonInParty:
	NPCMsg msg_0333_R05R0401_Route5_PokemonDayCare_Text_OnlyHaveOneMonWithYou
	WaitButton
	GoTo Route5_PokemonDayCare_EventScript_CloseMoneyBox
	CloseMsg
	End
	
Route5_PokemonDayCare_EventScript_OnlyOneAliveMonInParty:
	NPCMsg msg_0333_R05R0401_Route5_PokemonDayCare_Text_WhatWillYouBattleWith
	WaitButton
	GoTo Route5_PokemonDayCare_EventScript_CloseMoneyBox
	CloseMsg
	End
	
Route5_PokemonDayCare_EventScript_NoRoomInParty:
	NPCMsg msg_0333_R05R0401_Route5_PokemonDayCare_Text_YouveGotNoRoomForIt
	WaitButton
	GoTo Route5_PokemonDayCare_EventScript_CloseMoneyBox
	CloseMsg
	End
	
Route5_PokemonDayCare_EventScript_RetrieveMon:
	SetVar 0x8004, 0
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar TakePokemonFromRoute5Daycare
	GoTo _cv_stop
	// TODO(gba) special SubtractMoneyFromVar0x8005
	GoTo _cv_stop
	UpdateMoneyBox
	CopyVar 0x8008, VAR_SPECIAL_RESULT
	// TODO(gba) getpartysize 
	GoTo _cv_stop
	SubVar VAR_SPECIAL_RESULT, 1
	// TODO(gba) bufferpartymonnick STR_VAR_1, VAR_RESULT
	GoTo _cv_stop
	CopyVar VAR_SPECIAL_RESULT, 0x8008
	NPCMsg msg_0333_R05R0401_Route5_PokemonDayCare_Text_ThankYouHeresMon
	WaitButton
	WaitSE SEQ_SE_DP_SELECT
	PlayCry VAR_SPECIAL_RESULT, 0
	BufferPlayersName 6
	NPCMsg msg_0333_R05R0401_Route5_PokemonDayCare_Text_PlayerGotMonBack
	WaitButton
	Call EventScript_RestorePrevTextColor
	WaitCry
	GoTo Route5_PokemonDayCare_EventScript_CloseMoneyBox
	CloseMsg
	End
	
EventScript_RestorePrevTextColor:
	CopyVar 0x5015, 0x5016
	Return

_cv_stop:
	NPCMsg msg_0333_R05R0401_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
