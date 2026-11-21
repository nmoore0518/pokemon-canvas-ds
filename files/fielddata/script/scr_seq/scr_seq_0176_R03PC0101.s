#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R03PC0101.h"
#include "msgdata/msg/msg_0327_R03PC0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route4_PokemonCenter_1F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route4_PokemonCenter_1F_EventScript_Nurse
	ScrDef Route4_PokemonCenter_1F_EventScript_MagikarpSalesman
	ScrDef Route4_PokemonCenter_1F_EventScript_Gentleman
	ScrDef Route4_PokemonCenter_1F_EventScript_Boy
	ScrDef Route4_PokemonCenter_1F_EventScript_Youngster
	ScrDef Route4_PokemonCenter_1F_EventScript_Newspaper
	ScrDef Route4_PokemonCenter_1F_OnTransition
	ScrDef CableClub_OnResume
	ScrDefEnd
	
Route4_PokemonCenter_1F_EventScript_Nurse:
	LockAll
	FacePlayer
	SetVar VAR_SPECIAL_x8007, 0
	CallStd std_nurse_joy
	CanvasCloseMsg
	ReleaseAll
	End
	
Route4_PokemonCenter_1F_EventScript_MagikarpSalesman:
	LockAll
	FacePlayer
	GoToIfSet 0x20CF, Route4_PokemonCenter_1F_EventScript_AlreadyBoughtMagikarp
	ShowMoneyBox 20, 2
	GetPlayerGender VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Route4_PokemonCenter_1F_EventScript_AskBuyMagikarpMale
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Route4_PokemonCenter_1F_EventScript_AskBuyMagikarpFemale
	End
	
Route4_PokemonCenter_1F_EventScript_Gentleman:
	LockAll
	NPCMsg msg_0327_R03PC0101_Route4_PokemonCenter_1F_Text_TeamRocketAttacksCerulean
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route4_PokemonCenter_1F_EventScript_Boy:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0327_R03PC0101_Route4_PokemonCenter_1F_Text_CanHaveSixMonsWithYou
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route4_PokemonCenter_1F_EventScript_Youngster:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0327_R03PC0101_Route4_PokemonCenter_1F_Text_ShouldStoreMonsUsingPC
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route4_PokemonCenter_1F_EventScript_Newspaper:
	LockAll
	NPCMsg msg_0327_R03PC0101_Route4_PokemonCenter_1F_Text_ItsANewspaper
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route4_PokemonCenter_1F_OnTransition:
	End
	
CableClub_OnResume:
	// TODO(gba) special InitUnionRoom
	End
	
Route4_PokemonCenter_1F_EventScript_AlreadyBoughtMagikarp:
	NPCMsg msg_0327_R03PC0101_Route4_PokemonCenter_1F_Text_IDontGiveRefunds
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route4_PokemonCenter_1F_EventScript_AskBuyMagikarpMale:
	NPCMsg msg_0327_R03PC0101_Route4_PokemonCenter_1F_Text_LaddieBuyMagikarpForJust500
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	GoTo Route4_PokemonCenter_1F_EventScript_TryBuyMagikarp
	CloseMsg
	End
	
Route4_PokemonCenter_1F_EventScript_AskBuyMagikarpFemale:
	NPCMsg msg_0327_R03PC0101_Route4_PokemonCenter_1F_Text_SweetieBuyMagikarpForJust500
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_3
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_4
_cv_yes_3:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_4:
	GoTo Route4_PokemonCenter_1F_EventScript_TryBuyMagikarp
	CloseMsg
	End
	
Route4_PokemonCenter_1F_EventScript_TryBuyMagikarp:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Route4_PokemonCenter_1F_EventScript_DeclineMagikarp
	HasEnoughMoneyImmediate VAR_SPECIAL_RESULT, 500
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Route4_PokemonCenter_1F_EventScript_NotEnoughMoney
	SetVar 0x4001, SPECIES_MAGIKARP
	GiveMon SPECIES_MAGIKARP, 5, 0, 0, 0, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Route4_PokemonCenter_1F_EventScript_BuyMagikarpParty
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Route4_PokemonCenter_1F_EventScript_BuyMagikarpPC
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq Route4_PokemonCenter_1F_EventScript_NoRoomForMagikarp
	End
	
Route4_PokemonCenter_1F_EventScript_DeclineMagikarp:
	NPCMsg msg_0327_R03PC0101_Route4_PokemonCenter_1F_Text_OnlyDoingThisAsFavorToYou
	WaitButton
	HideMoneyBox
	CloseMsg
	ReleaseAll
	End
	
Route4_PokemonCenter_1F_EventScript_NotEnoughMoney:
	NPCMsg msg_0327_R03PC0101_Route4_PokemonCenter_1F_Text_YoullNeedMoreMoney
	WaitButton
	HideMoneyBox
	CloseMsg
	ReleaseAll
	End
	
Route4_PokemonCenter_1F_EventScript_BuyMagikarpParty:
	Call Route4_PokemonCenter_1F_EventScript_PayForMagikarp
	NPCMsg msg_0327_R03PC0101_gText_NicknameThisPokemon
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_5
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_6
_cv_yes_5:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_6:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Route4_PokemonCenter_1F_EventScript_EndPurchaseMagikarp
	Call Common_EventScript_GetGiftMonPartySlot
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	HideMoneyBox
	NicknameInput 0x8004, VAR_SPECIAL_RESULT
	GoTo Route4_PokemonCenter_1F_EventScript_BoughtMagikarp
	CloseMsg
	End
	
Route4_PokemonCenter_1F_EventScript_BuyMagikarpPC:
	Call Route4_PokemonCenter_1F_EventScript_PayForMagikarp
	NPCMsg msg_0327_R03PC0101_gText_NicknameThisPokemon
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_7
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_8
_cv_yes_7:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_8:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Route4_PokemonCenter_1F_EventScript_TransferMagikarpCloseMoneyBox
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	HideMoneyBox
	NicknameInput 0x8004, VAR_SPECIAL_RESULT
	LockAll
	FacePlayer
	GoTo Route4_PokemonCenter_1F_EventScript_TransferMagikarp
	CloseMsg
	End
	
Route4_PokemonCenter_1F_EventScript_NoRoomForMagikarp:
	NPCMsg msg_0327_R03PC0101_Route4_PokemonCenter_1F_Text_NoRoomForMorePokemon
	WaitButton
	HideMoneyBox
	CloseMsg
	ReleaseAll
	End
	
Route4_PokemonCenter_1F_EventScript_PayForMagikarp:
	SubMoneyImmediate 500
	UpdateMoneyBox
	PlayFanfare SEQ_ME_LVUP
	BufferPlayersName 6
	NPCMsg msg_0327_R03PC0101_Route4_PokemonCenter_1F_Text_PaidOutrageouslyForMagikarp
	WaitFanfare
	BufferSpeciesName 0, SPECIES_MAGIKARP, 0, 0
	Return
	
Route4_PokemonCenter_1F_EventScript_EndPurchaseMagikarp:
	HideMoneyBox
	GoTo Route4_PokemonCenter_1F_EventScript_BoughtMagikarp
	End
	
Common_EventScript_GetGiftMonPartySlot:
	GetPartyCount VAR_SPECIAL_RESULT
	SubVar VAR_SPECIAL_RESULT, 1
	CopyVar 0x8004, VAR_SPECIAL_RESULT
	Return
	
Route4_PokemonCenter_1F_EventScript_BoughtMagikarp:
	SetFlag 0x20CF
	CanvasCloseMsg
	ReleaseAll
	End
	
Route4_PokemonCenter_1F_EventScript_TransferMagikarpCloseMoneyBox:
	Call Common_EventScript_TransferredToPC
	GoTo Route4_PokemonCenter_1F_EventScript_EndPurchaseMagikarp
	End
	
Route4_PokemonCenter_1F_EventScript_TransferMagikarp:
	Call Common_EventScript_TransferredToPC
	GoTo Route4_PokemonCenter_1F_EventScript_BoughtMagikarp
	End
	
Common_EventScript_TransferredToPC:
	// (a box name: HeartGold sends a Pokemon to the first box with room)
	BufferSpeciesName 1, 0x5024, 0, 0
	CallIfUnset 0x20D0, EventScript_TransferredSomeonesPC
	CallIfSet 0x20D0, EventScript_TransferredLanettesPC
	Return
	
EventScript_TransferredSomeonesPC:
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq EventScript_SomeonesPCBoxFull
	NPCMsg msg_0327_R03PC0101_gText_PkmnTransferredSomeonesPC
	WaitButton
	Return
	
EventScript_TransferredLanettesPC:
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq EventScript_LanettesPCBoxFull
	NPCMsg msg_0327_R03PC0101_gText_PkmnTransferredLanettesPC
	WaitButton
	Return
	
EventScript_SomeonesPCBoxFull:
	SetVar VAR_SPECIAL_RESULT, 0
	// (a box name: HeartGold sends a Pokemon to the first box with room)
	NPCMsg msg_0327_R03PC0101_gText_PkmnTransferredSomeonesPCBoxFull
	WaitButton
	Return
	
EventScript_LanettesPCBoxFull:
	SetVar VAR_SPECIAL_RESULT, 0
	// (a box name: HeartGold sends a Pokemon to the first box with room)
	NPCMsg msg_0327_R03PC0101_gText_PkmnTransferredLanettesPCBoxFull
	WaitButton
	Return

_cv_stop:
	NPCMsg msg_0327_R03PC0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
