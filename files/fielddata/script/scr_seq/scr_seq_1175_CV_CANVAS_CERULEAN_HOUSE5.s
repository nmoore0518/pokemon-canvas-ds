#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_CERULEAN_HOUSE5.h"
#include "msgdata/msg/msg_0959_CV_CANVAS_CERULEAN_HOUSE5.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's CeruleanCity_House5_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef CeruleanCity_House5_EventScript_BerryPowderMan
	ScrDef CeruleanCity_House5_EventScript_BerryCrushRankings
	ScrDefEnd
	
CeruleanCity_House5_EventScript_BerryPowderMan:
	LockAll
	FacePlayer
	GoToIfSet 0x221C, CeruleanCity_House5_EventScript_AskToExchangePowder
	NPCMsg msg_0959_CV_CANVAS_CERULEAN_HOUSE5_CeruleanCity_House1_Text_AnyInterestInBerries
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CeruleanCity_House5_EventScript_NoInterestInBerries
	GoToIfUnset 0x221D, CeruleanCity_House5_EventScript_NoBerries
	NPCMsg msg_0959_CV_CANVAS_CERULEAN_HOUSE5_CeruleanCity_House1_Text_HaveJustTheThing
	WaitButton
	SetFlag 0x221C
	SetFlag 0x221E
	SetVar VAR_SPECIAL_RESULT, 1
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq EventScript_BagIsFull
	NPCMsg msg_0959_CV_CANVAS_CERULEAN_HOUSE5_CeruleanCity_House1_Text_GoCrushBerriesAtDirectCorner
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeruleanCity_House5_EventScript_BerryCrushRankings:
	LockAll
	// TODO(gba) special ShowBerryCrushRankings
	GoTo _cv_stop
	CanvasCloseMsg
	ReleaseAll
	End
	
CeruleanCity_House5_EventScript_AskToExchangePowder:
	// TODO(gba) special DisplayBerryPowderVendorMenu
	GoTo _cv_stop
	NPCMsg msg_0959_CV_CANVAS_CERULEAN_HOUSE5_CeruleanCity_House1_Text_HaveYouBroughtBerryPowder
	WaitButton
	GoTo CeruleanCity_House5_EventScript_ChooseExchangeItem
	CloseMsg
	End
	
CeruleanCity_House5_EventScript_NoInterestInBerries:
	NPCMsg msg_0959_CV_CANVAS_CERULEAN_HOUSE5_CeruleanCity_House1_Text_TakeInterestInAllSortsOfThings
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeruleanCity_House5_EventScript_NoBerries:
	NPCMsg msg_0959_CV_CANVAS_CERULEAN_HOUSE5_CeruleanCity_House1_Text_WhyMustYouLieNoBerries
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_BagIsFull:
	NPCMsg msg_0959_CV_CANVAS_CERULEAN_HOUSE5_gText_TooBadBagIsFull
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeruleanCity_House5_EventScript_ChooseExchangeItem:
	NPCMsg msg_0959_CV_CANVAS_CERULEAN_HOUSE5_CeruleanCity_House5_Text_ExchangeWithWhat
	SetVar 0x8004, 7
	// TODO(gba) special ShowScrollableMultichoice
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CeruleanCity_House5_EventScript_EnergyPowder
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq CeruleanCity_House5_EventScript_EnergyRoot
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq CeruleanCity_House5_EventScript_HealPowder
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfEq CeruleanCity_House5_EventScript_RevivalHerb
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfEq CeruleanCity_House5_EventScript_Protein
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfEq CeruleanCity_House5_EventScript_Iron
	CompareVarToValue VAR_SPECIAL_RESULT, 6
	GoToIfEq CeruleanCity_House5_EventScript_Carbos
	CompareVarToValue VAR_SPECIAL_RESULT, 7
	GoToIfEq CeruleanCity_House5_EventScript_Calcium
	CompareVarToValue VAR_SPECIAL_RESULT, 8
	GoToIfEq CeruleanCity_House5_EventScript_Zinc
	CompareVarToValue VAR_SPECIAL_RESULT, 9
	GoToIfEq CeruleanCity_House5_EventScript_HPUp
	CompareVarToValue VAR_SPECIAL_RESULT, 10
	GoToIfEq CeruleanCity_House5_EventScript_PPUp
	CompareVarToValue VAR_SPECIAL_RESULT, 11
	GoToIfEq CeruleanCity_House5_EventScript_ExitMenu
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq CeruleanCity_House5_EventScript_ExitMenu
	CloseMsg
	End
	
CeruleanCity_House5_EventScript_EnergyPowder:
	BufferItemName 0, ITEM_ENERGYPOWDER
	SetVar 0x8008, ITEM_ENERGYPOWDER
	SetVar 0x8009, 50
	GoTo CeruleanCity_House5_EventScript_ExchangePowderForItem
	End
	
CeruleanCity_House5_EventScript_EnergyRoot:
	BufferItemName 0, ITEM_ENERGY_ROOT
	SetVar 0x8008, ITEM_ENERGY_ROOT
	SetVar 0x8009, 80
	GoTo CeruleanCity_House5_EventScript_ExchangePowderForItem
	End
	
CeruleanCity_House5_EventScript_HealPowder:
	BufferItemName 0, ITEM_HEAL_POWDER
	SetVar 0x8008, ITEM_HEAL_POWDER
	SetVar 0x8009, 50
	GoTo CeruleanCity_House5_EventScript_ExchangePowderForItem
	End
	
CeruleanCity_House5_EventScript_RevivalHerb:
	BufferItemName 0, ITEM_REVIVAL_HERB
	SetVar 0x8008, ITEM_REVIVAL_HERB
	SetVar 0x8009, 300
	GoTo CeruleanCity_House5_EventScript_ExchangePowderForItem
	End
	
CeruleanCity_House5_EventScript_Protein:
	BufferItemName 0, ITEM_PROTEIN
	SetVar 0x8008, ITEM_PROTEIN
	SetVar 0x8009, 1000
	GoTo CeruleanCity_House5_EventScript_ExchangePowderForItem
	End
	
CeruleanCity_House5_EventScript_Iron:
	BufferItemName 0, ITEM_IRON
	SetVar 0x8008, ITEM_IRON
	SetVar 0x8009, 1000
	GoTo CeruleanCity_House5_EventScript_ExchangePowderForItem
	End
	
CeruleanCity_House5_EventScript_Carbos:
	BufferItemName 0, ITEM_CARBOS
	SetVar 0x8008, ITEM_CARBOS
	SetVar 0x8009, 1000
	GoTo CeruleanCity_House5_EventScript_ExchangePowderForItem
	End
	
CeruleanCity_House5_EventScript_Calcium:
	BufferItemName 0, ITEM_CALCIUM
	SetVar 0x8008, ITEM_CALCIUM
	SetVar 0x8009, 1000
	GoTo CeruleanCity_House5_EventScript_ExchangePowderForItem
	End
	
CeruleanCity_House5_EventScript_Zinc:
	BufferItemName 0, ITEM_ZINC
	SetVar 0x8008, ITEM_ZINC
	SetVar 0x8009, 1000
	GoTo CeruleanCity_House5_EventScript_ExchangePowderForItem
	End
	
CeruleanCity_House5_EventScript_HPUp:
	BufferItemName 0, ITEM_HP_UP
	SetVar 0x8008, ITEM_HP_UP
	SetVar 0x8009, 1000
	GoTo CeruleanCity_House5_EventScript_ExchangePowderForItem
	End
	
CeruleanCity_House5_EventScript_PPUp:
	BufferItemName 0, ITEM_PP_UP
	SetVar 0x8008, ITEM_PP_UP
	SetVar 0x8009, 3000
	GoTo CeruleanCity_House5_EventScript_ExchangePowderForItem
	End
	
CeruleanCity_House5_EventScript_ExitMenu:
	NPCMsg msg_0959_CV_CANVAS_CERULEAN_HOUSE5_CeruleanCity_House1_Text_SeeMeIfYoudLikeToTradePowder
	WaitButton
	// TODO(gba) special RemoveBerryPowderVendorMenu
	GoTo _cv_stop
	CloseMsg
	ReleaseAll
	End
	
CeruleanCity_House5_EventScript_ExchangePowderForItem:
	NPCMsg msg_0959_CV_CANVAS_CERULEAN_HOUSE5_CeruleanCity_House1_Text_YoullExchangeBerryPowderForItem
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_3
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_4
_cv_yes_3:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CeruleanCity_House5_EventScript_ChooseExchangeItem
	CopyVar 0x8004, 0x8009
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar HasEnoughBerryPowder
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CeruleanCity_House5_EventScript_NotEnoughBerryPowder
	SetOrCopyVar 0x8004, 0x8008
	SetOrCopyVar 0x8005, 1
	HasSpaceForItem 0x8004, 0x8005, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_full_5
	CallStd std_give_item_verbose
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_given_6
_cv_full_5:
	SetVar VAR_SPECIAL_RESULT, 0
_cv_given_6:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CeruleanCity_House5_EventScript_BagIsFull
	CopyVar 0x8004, 0x8009
	// TODO(gba) special TakeBerryPowder
	GoTo _cv_stop
	// TODO(gba) special PrintPlayerBerryPowderAmount
	GoTo _cv_stop
	NPCMsg msg_0959_CV_CANVAS_CERULEAN_HOUSE5_CeruleanCity_House1_Text_TradeMoreBerryPowder
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_7
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_8
_cv_yes_7:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_8:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq CeruleanCity_House5_EventScript_ChooseExchangeItem
	NPCMsg msg_0959_CV_CANVAS_CERULEAN_HOUSE5_CeruleanCity_House1_Text_HopeToSeeYouAgain
	WaitButton
	// TODO(gba) special RemoveBerryPowderVendorMenu
	GoTo _cv_stop
	CloseMsg
	ReleaseAll
	End
	
CeruleanCity_House5_EventScript_NotEnoughBerryPowder:
	NPCMsg msg_0959_CV_CANVAS_CERULEAN_HOUSE5_CeruleanCity_House1_Text_DontHaveEnoughBerryPowder
	WaitButton
	GoTo CeruleanCity_House5_EventScript_ChooseExchangeItem
	CloseMsg
	End
	
CeruleanCity_House5_EventScript_BagIsFull:
	NPCMsg msg_0959_CV_CANVAS_CERULEAN_HOUSE5_gText_TheBagIsFull
	WaitButton
	// TODO(gba) special RemoveBerryPowderVendorMenu
	GoTo _cv_stop
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0959_CV_CANVAS_CERULEAN_HOUSE5_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
