#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T04R0401.h"
#include "msgdata/msg/msg_0474_T04R0401.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's CeruleanCity_BikeShop_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef CeruleanCity_BikeShop_EventScript_Clerk
	ScrDef CeruleanCity_BikeShop_EventScript_Youngster
	ScrDef CeruleanCity_BikeShop_EventScript_Woman
	ScrDef CeruleanCity_BikeShop_EventScript_Bicycle
	ScrDefEnd
	
CeruleanCity_BikeShop_EventScript_Clerk:
	LockAll
	FacePlayer
	GoToIfSet 0x20E0, CeruleanCity_BikeShop_EventScript_AlreadyGotBicycle
	GoToIfSet 0x20E1, CeruleanCity_BikeShop_EventScript_ExchangeBikeVoucher
	ShowMoneyBox 20, 2
	NPCMsg msg_0474_T04R0401_CeruleanCity_BikeShop_Text_WelcomeToBikeShop
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0474_T04R0401_cv_mc_bike_shop_0, 0
	ScrCmd_559 msg_0474_T04R0401_cv_mc_bike_shop_1, 1
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_2
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_2:
	HideMoneyBox
	ShowMoneyBox 20, 2
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CeruleanCity_BikeShop_EventScript_TryPurchaseBicycle
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq CeruleanCity_BikeShop_EventScript_ClerkGoodbye
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq CeruleanCity_BikeShop_EventScript_ClerkGoodbye
	CloseMsg
	End
	
CeruleanCity_BikeShop_EventScript_Youngster:
	LockAll
	FacePlayer
	GoToIfSet 0x20E0, CeruleanCity_BikeShop_EventScript_YoungsterHaveBike
	NPCMsg msg_0474_T04R0401_CeruleanCity_BikeShop_Text_BikesCoolButExpensive
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeruleanCity_BikeShop_EventScript_Woman:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0474_T04R0401_CeruleanCity_BikeShop_Text_CityBikeGoodEnoughForMe
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeruleanCity_BikeShop_EventScript_Bicycle:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0474_T04R0401_CeruleanCity_BikeShop_Text_ShinyNewBicycle
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeruleanCity_BikeShop_EventScript_AlreadyGotBicycle:
	NPCMsg msg_0474_T04R0401_CeruleanCity_BikeShop_Text_HowDoYouLikeNewBicycle
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeruleanCity_BikeShop_EventScript_ExchangeBikeVoucher:
	NPCMsg msg_0474_T04R0401_CeruleanCity_BikeShop_Text_OhBikeVoucherHereYouGo
	WaitButton
	PlayFanfare SEQ_ME_ITEM
	BufferPlayersName 6
	NPCMsg msg_0474_T04R0401_CeruleanCity_BikeShop_Text_ExchangedVoucherForBicycle
	WaitFanfare
	WaitButton
	SetFlag 0x20E0
	GiveItem ITEM_BICYCLE, 1, VAR_SPECIAL_RESULT
	ClearFlag 0x20E2
	SetVar VAR_SPECIAL_RESULT, 1
	NPCMsg msg_0474_T04R0401_CeruleanCity_BikeShop_Text_ThankYouComeAgain
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeruleanCity_BikeShop_EventScript_TryPurchaseBicycle:
	NPCMsg msg_0474_T04R0401_CeruleanCity_BikeShop_Text_SorryYouCantAffordIt
	WaitButton
	GoTo CeruleanCity_BikeShop_EventScript_ClerkGoodbye
	CloseMsg
	End
	
CeruleanCity_BikeShop_EventScript_ClerkGoodbye:
	NPCMsg msg_0474_T04R0401_CeruleanCity_BikeShop_Text_ThankYouComeAgain
	WaitButton
	HideMoneyBox
	CloseMsg
	ReleaseAll
	End
	
CeruleanCity_BikeShop_EventScript_YoungsterHaveBike:
	NPCMsg msg_0474_T04R0401_CeruleanCity_BikeShop_Text_WowYourBikeIsCool
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0474_T04R0401_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
