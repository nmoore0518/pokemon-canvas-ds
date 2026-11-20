#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_BATTLE_PARK_UNUSED_1.h"
#include "msgdata/msg/msg_0859_CV_BATTLE_PARK_UNUSED_1.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PalletTown_Gym_RightRoom by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef GymDecor_EventScript_GymPC
	ScrDef GymRooms_EventScript_OnLoad
	ScrDefEnd
	
GymDecor_EventScript_GymPC:
	LockAll
	PlaySE SEQ_SE_DP_SELECT
	BufferPlayersName 6
	NPCMsg msg_0859_CV_BATTLE_PARK_UNUSED_1_GymDecor_Text_BootedUpGymPC
	WaitButton
	GoTo GymDecor_EventScript_PCMenu
	
GymRooms_EventScript_OnLoad:
	End
	
GymDecor_EventScript_PCMenu:
	NPCMsg msg_0859_CV_BATTLE_PARK_UNUSED_1_GymDecor_Text_WhatToDo
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0859_CV_BATTLE_PARK_UNUSED_1_GymDecor_Text_Buy, 0
	ScrCmd_559 msg_0859_CV_BATTLE_PARK_UNUSED_1_GymDecor_Text_Sell, 1
	ScrCmd_559 msg_0859_CV_BATTLE_PARK_UNUSED_1_GymDecor_Text_Decorate, 2
	ScrCmd_559 msg_0859_CV_BATTLE_PARK_UNUSED_1_GymDecor_Text_PutAllAway, 3
	ScrCmd_559 msg_0859_CV_BATTLE_PARK_UNUSED_1_GymDecor_Text_LogOff, 4
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_2
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymDecor_EventScript_Buy
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymDecor_EventScript_Sell
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq GymDecor_EventScript_Decorate
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfEq GymDecor_EventScript_PutAllAway
	GoTo GymDecor_EventScript_LogOff
	CloseMsg
	End
	
GymDecor_EventScript_Buy:
	SetVar 0x8007, 0
	ShowMoneyBox 20, 2
	GoTo GymDecor_EventScript_BuyCategory
	
GymDecor_EventScript_Sell:
	SetVar 0x8007, 0
	ShowMoneyBox 20, 2
	GoTo GymDecor_EventScript_SellCategory
	
GymDecor_EventScript_Decorate:
	// TODO(gba) special GymDecor_PushOwnedCategories
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymDecor_EventScript_NothingOwned
	NPCMsg msg_0859_CV_BATTLE_PARK_UNUSED_1_GymDecor_Text_WhichKindToPlace
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_4
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq GymDecor_EventScript_PCMenu
	CopyVar 0x8006, VAR_SPECIAL_RESULT
	// TODO(gba) special GymDecor_PushOwnedList
	GoTo _cv_stop
	NPCMsg msg_0859_CV_BATTLE_PARK_UNUSED_1_GymDecor_Text_WhichToPlace
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_6
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_6:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq GymDecor_EventScript_Decorate
	CopyVar 0x8004, VAR_SPECIAL_RESULT
	// TODO(gba) special GymDecor_GetKind
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfEq GymDecor_EventScript_SetWallStyle
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfEq GymDecor_EventScript_HowToPaint
	NPCMsg msg_0859_CV_BATTLE_PARK_UNUSED_1_GymDecor_Text_HowToDecorate
	WaitButton
	GoTo GymDecor_EventScript_StartEditing
	
GymDecor_EventScript_PutAllAway:
	NPCMsg msg_0859_CV_BATTLE_PARK_UNUSED_1_GymDecor_Text_ConfirmPutAllAway
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_7
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_8
_cv_yes_7:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_8:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymDecor_EventScript_PCMenu
	// TODO(gba) special GymDecor_PutAllAway
	GoTo _cv_stop
	PlaySE SEQ_SE_DP_SELECT
	NPCMsg msg_0859_CV_BATTLE_PARK_UNUSED_1_GymDecor_Text_AllPutAway
	WaitButton
	GoTo GymDecor_EventScript_PCMenu
	CloseMsg
	End
	
GymDecor_EventScript_LogOff:
	PlaySE SEQ_SE_DP_SELECT
	CloseMsg
	ReleaseAll
	End
	
GymDecor_EventScript_BuyCategory:
	// TODO(gba) special GymDecor_PushShopCategories
	GoTo _cv_stop
	NPCMsg msg_0859_CV_BATTLE_PARK_UNUSED_1_GymDecor_Text_WhichKind
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_10
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_10:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq GymDecor_EventScript_BuyDone
	CopyVar 0x8006, VAR_SPECIAL_RESULT
	CopyVar 0x8007, VAR_SPECIAL_RESULT
	SetVar 0x8005, 0
	GoTo GymDecor_EventScript_BuyLoop
	
GymDecor_EventScript_SellCategory:
	// TODO(gba) special GymDecor_PushSellCategories
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymDecor_EventScript_NothingToSell
	NPCMsg msg_0859_CV_BATTLE_PARK_UNUSED_1_GymDecor_Text_WhichKindToSell
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_12
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_12:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq GymDecor_EventScript_SellDone
	CopyVar 0x8006, VAR_SPECIAL_RESULT
	CopyVar 0x8007, VAR_SPECIAL_RESULT
	SetVar 0x8005, 0
	GoTo GymDecor_EventScript_SellLoop
	
GymDecor_EventScript_NothingOwned:
	NPCMsg msg_0859_CV_BATTLE_PARK_UNUSED_1_GymDecor_Text_NothingOwned
	WaitButton
	GoTo GymDecor_EventScript_PCMenu
	CloseMsg
	End
	
GymDecor_EventScript_SetWallStyle:
	// TODO(gba) special GymDecor_ApplyWallStyle
	GoTo _cv_stop
	// TODO(gba) special GymDecor_BufferDecorInfo
	GoTo _cv_stop
	PlaySE SEQ_SE_DP_SELECT
	NPCMsg msg_0859_CV_BATTLE_PARK_UNUSED_1_GymDecor_Text_WallsChanged
	WaitButton
	GoTo GymDecor_EventScript_PCMenu
	CloseMsg
	End
	
GymDecor_EventScript_HowToPaint:
	NPCMsg msg_0859_CV_BATTLE_PARK_UNUSED_1_GymDecor_Text_HowToPaint
	WaitButton
	GoTo GymDecor_EventScript_StartEditing
	CloseMsg
	End
	
GymDecor_EventScript_StartEditing:
	CloseMsg
	ReleaseAll
	// TODO(gba) special GymDecor_StartEditing
	GoTo _cv_stop
	End
	
GymDecor_EventScript_BuyDone:
	HideMoneyBox
	GoTo GymDecor_EventScript_PCMenu
	End
	
GymDecor_EventScript_BuyLoop:
	// TODO(gba) special GymDecor_PushShopList
	GoTo _cv_stop
	NPCMsg msg_0859_CV_BATTLE_PARK_UNUSED_1_GymDecor_Text_WhichToBuy
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_14
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_14:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq GymDecor_EventScript_BuyCategory
	CopyVar 0x8004, VAR_SPECIAL_RESULT
	CopyVar 0x8005, VAR_SPECIAL_RESULT
	SetVar 0x8009, 1
	// TODO(gba) special GymDecor_GetKind
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfGe GymDecor_EventScript_ConfirmBuy
	// TODO(gba) special GymDecor_BufferDecorInfo
	GoTo _cv_stop
	NPCMsg msg_0859_CV_BATTLE_PARK_UNUSED_1_GymDecor_Text_HowMany
	// TODO(gba) special GymDecor_ChooseQuantity
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymDecor_EventScript_BuyLoop
	CopyVar 0x8009, VAR_SPECIAL_RESULT
	GoTo GymDecor_EventScript_ConfirmBuy
	
GymDecor_EventScript_NothingToSell:
	NPCMsg msg_0859_CV_BATTLE_PARK_UNUSED_1_GymDecor_Text_NothingToSell
	WaitButton
	GoTo GymDecor_EventScript_SellDone
	
GymDecor_EventScript_SellDone:
	HideMoneyBox
	GoTo GymDecor_EventScript_PCMenu
	End
	
GymDecor_EventScript_SellLoop:
	// TODO(gba) special GymDecor_PushSellList
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymDecor_EventScript_SellCategory
	NPCMsg msg_0859_CV_BATTLE_PARK_UNUSED_1_GymDecor_Text_WhichToSell
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_16
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_16:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq GymDecor_EventScript_SellCategory
	CopyVar 0x8004, VAR_SPECIAL_RESULT
	CopyVar 0x8005, VAR_SPECIAL_RESULT
	SetVar 0x8009, 1
	// TODO(gba) special GymDecor_BufferSellInfo
	GoTo _cv_stop
	NPCMsg msg_0859_CV_BATTLE_PARK_UNUSED_1_GymDecor_Text_HowManyToSell
	// TODO(gba) special GymDecor_ChooseSellQuantity
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymDecor_EventScript_SellLoop
	CopyVar 0x8009, VAR_SPECIAL_RESULT
	// TODO(gba) special GymDecor_BufferSellInfo
	GoTo _cv_stop
	NPCMsg msg_0859_CV_BATTLE_PARK_UNUSED_1_GymDecor_Text_ConfirmSell
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_17
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_18
_cv_yes_17:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_18:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymDecor_EventScript_SellLoop
	// TODO(gba) special GymDecor_Sell
	GoTo _cv_stop
	UpdateMoneyBox
	PlaySE SEQ_SE_DP_SELECT
	NPCMsg msg_0859_CV_BATTLE_PARK_UNUSED_1_GymDecor_Text_Sold
	WaitButton
	GoTo GymDecor_EventScript_SellLoop
	CloseMsg
	End
	
GymDecor_EventScript_ConfirmBuy:
	// TODO(gba) special GymDecor_BufferDecorInfo
	GoTo _cv_stop
	NPCMsg msg_0859_CV_BATTLE_PARK_UNUSED_1_GymDecor_Text_ConfirmBuy
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_19
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_20
_cv_yes_19:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_20:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymDecor_EventScript_BuyLoop
	// TODO(gba) special GymDecor_TryBuy
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymDecor_EventScript_NotEnoughMoney
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq GymDecor_EventScript_StorageFull
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfEq GymDecor_EventScript_AlreadyHave
	UpdateMoneyBox
	// TODO(gba) special GymDecor_BufferDecorInfo
	GoTo _cv_stop
	PlaySE SEQ_SE_DP_SELECT
	NPCMsg msg_0859_CV_BATTLE_PARK_UNUSED_1_GymDecor_Text_Bought
	WaitButton
	GoTo GymDecor_EventScript_BuyLoop
	CloseMsg
	End
	
GymDecor_EventScript_NotEnoughMoney:
	NPCMsg msg_0859_CV_BATTLE_PARK_UNUSED_1_GymDecor_Text_NotEnoughMoney
	WaitButton
	GoTo GymDecor_EventScript_BuyLoop
	CloseMsg
	End
	
GymDecor_EventScript_StorageFull:
	NPCMsg msg_0859_CV_BATTLE_PARK_UNUSED_1_GymDecor_Text_StorageFull
	WaitButton
	GoTo GymDecor_EventScript_BuyLoop
	CloseMsg
	End
	
GymDecor_EventScript_AlreadyHave:
	NPCMsg msg_0859_CV_BATTLE_PARK_UNUSED_1_GymDecor_Text_AlreadyHave
	WaitButton
	GoTo GymDecor_EventScript_BuyLoop
	CloseMsg
	End

_cv_stop:
	NPCMsg msg_0859_CV_BATTLE_PARK_UNUSED_1_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
