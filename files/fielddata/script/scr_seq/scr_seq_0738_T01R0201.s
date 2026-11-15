#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T01R0201.h"
#include "msgdata/msg/msg_0449_T01R0201.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PalletTown_RivalsHouse_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef _cv_unported_0
	ScrDef PalletTown_RivalsHouse_EventScript_TownMap
	ScrDef PalletTown_RivalsHouse_EventScript_Bookshelf
	ScrDef PalletTown_RivalsHouse_EventScript_Picture
	ScrDef PalletTown_RivalsHouse_OnTransition
	ScrDefEnd
	
PalletTown_RivalsHouse_EventScript_Daisy:
	LockAll
	FacePlayer
	Call PalletTown_RivalsHouse_EventScript_DaisyCoins
	GoToIfSet 0x2011, PalletTown_RivalsHouse_EventScript_GroomMon
	Call GymCandidate_EventScript_DaisyAside
	CompareVarToValue 0x4001, 1
	GoToIfEq PalletTown_RivalsHouse_EventScript_PleaseGiveMonsRest
	CompareVarToValue 0x500D, 2
	GoToIfEq PalletTown_RivalsHouse_EventScript_ExplainTownMap
	CompareVarToValue 0x500D, 1
	GoToIfEq PalletTown_RivalsHouse_EventScript_GiveTownMap
	CompareVarToValue 0x5006, 1
	GoToIfGe PalletTown_RivalsHouse_EventScript_HeardBattledRival
	BufferPlayersName 6
	BufferRivalsName 7
	NPCMsg msg_0449_T01R0201_PalletTown_RivalsHouse_Text_HiBrothersAtLab
	WaitButton
	CloseMsg
	ApplyMovement 1, Common_Movement_FaceOriginalDirection
	WaitMovement
	ReleaseAll
	End
	
PalletTown_RivalsHouse_EventScript_TownMap:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0449_T01R0201_PalletTown_RivalsHouse_Text_ItsBigMapOfKanto
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_RivalsHouse_EventScript_Bookshelf:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0449_T01R0201_PalletTown_RivalsHouse_Text_ShelvesCrammedFullOfBooks
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_RivalsHouse_EventScript_Picture:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0449_T01R0201_PalletTown_RivalsHouse_Text_LovelyAndSweetClefairy
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_RivalsHouse_OnTransition:
	CompareVarToValue 0x500D, 2
	CallIfLt PalletTown_RivalsHouse_EventScript_MoveDaisyToTable
	CompareVarToValue 0x500D, 2
	CallIfGe PalletTown_RivalsHouse_EventScript_AlreadyReceivedTownMap
	End
	
PalletTown_RivalsHouse_EventScript_DaisyCoins:
	SetVar 0x8004, ITEM_AMULET_COIN
	// TODO(gba) special ItemUpgrade_HasItem
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PalletTown_RivalsHouse_EventScript_DaisyCoinsReturn
	GoToIfSet 0x2012, PalletTown_RivalsHouse_EventScript_DaisyCoinsCheckBag
	NPCMsg msg_0449_T01R0201_PalletTown_RivalsHouse_Text_DaisyGrandpasCoins
	WaitButton
	SetFlag 0x2012
	GoTo PalletTown_RivalsHouse_EventScript_DaisyCoinsOffer
	
PalletTown_RivalsHouse_EventScript_GroomMon:
	CompareVarToValue 0x500E, 500
	GoToIfLt PalletTown_RivalsHouse_EventScript_RateMonFriendship
	BufferPlayersName 6
	NPCMsg msg_0449_T01R0201_PalletTown_RivalsHouse_Text_LikeMeToGroomMon
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PalletTown_RivalsHouse_EventScript_DeclineGrooming
	NPCMsg msg_0449_T01R0201_PalletTown_RivalsHouse_Text_GroomWhichOne
	WaitButton
	// TODO(gba) special ChoosePartyMon
	LockAll
	FacePlayer
	CompareVarToValue 0x8004, 6
	GoToIfGe PalletTown_RivalsHouse_EventScript_DeclineGrooming
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar ScriptGetPartyMonSpecies
	CompareVarToValue VAR_SPECIAL_RESULT, SPECIES_EGG
	GoToIfEq PalletTown_RivalsHouse_EventScript_CantGroomEgg
	NPCMsg msg_0449_T01R0201_PalletTown_RivalsHouse_Text_LookingNiceInNoTime
	WaitButton
	CloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	PlayFanfare SEQ_ME_ASA
	WaitFanfare
	// TODO(gba) special DaisyMassageServices
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	// TODO(gba) special BufferMonNickname
	NPCMsg msg_0449_T01R0201_PalletTown_RivalsHouse_Text_ThereYouGoAllDone
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_DaisyAside:
	GoToIfSet 0x2011, GymCandidate_EventScript_Return
	// TODO(gba) special GymCandidate_BufferApprovals
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfLt GymCandidate_EventScript_Return
	NPCMsg msg_0449_T01R0201_GymCandidate_Text_DaisyAside
	WaitButton
	Return
	
PalletTown_RivalsHouse_EventScript_PleaseGiveMonsRest:
	NPCMsg msg_0449_T01R0201_PalletTown_RivalsHouse_Text_PleaseGiveMonsRest
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_RivalsHouse_EventScript_ExplainTownMap:
	NPCMsg msg_0449_T01R0201_PalletTown_RivalsHouse_Text_ExplainTownMap
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_RivalsHouse_EventScript_GiveTownMap:
	NPCMsg msg_0449_T01R0201_PalletTown_RivalsHouse_Text_ErrandForGrandpaThisWillHelp
	WaitButton
	CloseMsg
	HasSpaceForItem ITEM_TOWN_MAP, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PalletTown_RivalsHouse_EventScript_NoRoomForTownMap
	ApplyMovement 1, Common_Movement_WalkInPlaceFasterRight
	WaitMovement
	HidePerson 2
	SetVar 0x500D, 2
	Wait 15, VAR_SPECIAL_RESULT
	FacePlayer
	WaitMovement
	Wait 12, VAR_SPECIAL_RESULT
	GiveItem ITEM_TOWN_MAP, 1, VAR_SPECIAL_RESULT
	BufferItemName 1, ITEM_TOWN_MAP
	BufferPlayersName 6
	NPCMsg msg_0449_T01R0201_PalletTown_RivalsHouse_Text_ReceivedTownMapFromDaisy
	PlayFanfare SEQ_ME_ITEM
	WaitFanfare
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_RivalsHouse_EventScript_HeardBattledRival:
	BufferPlayersName 6
	BufferRivalsName 7
	NPCMsg msg_0449_T01R0201_PalletTown_RivalsHouse_Text_HeardYouBattledRival
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_RivalsHouse_EventScript_MoveDaisyToTable:
	SetObjectMovementType 1, 17
	SetObjectFacing 1, 3
	MovePerson 1, 5, 4
	Return
	
PalletTown_RivalsHouse_EventScript_AlreadyReceivedTownMap:
	SetVar 0x4001, 1
	Return
	
PalletTown_RivalsHouse_EventScript_DaisyCoinsReturn:
	Return
	
PalletTown_RivalsHouse_EventScript_DaisyCoinsCheckBag:
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x2028, _cv_has_3
	SetVar VAR_SPECIAL_RESULT, 1
_cv_has_3:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq PalletTown_RivalsHouse_EventScript_DaisyCoinsOffer
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x2029, _cv_has_4
	SetVar VAR_SPECIAL_RESULT, 1
_cv_has_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq PalletTown_RivalsHouse_EventScript_DaisyCoinsOffer
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x202A, _cv_has_5
	SetVar VAR_SPECIAL_RESULT, 1
_cv_has_5:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq PalletTown_RivalsHouse_EventScript_DaisyCoinsOffer
	End
	
PalletTown_RivalsHouse_EventScript_DaisyCoinsOffer:
	SetVar 0x8004, ITEM_AMULET_COIN
	// TODO(gba) special ItemUpgrade_CheckCost
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PalletTown_RivalsHouse_EventScript_DaisyCoinsMaxed
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PalletTown_RivalsHouse_EventScript_DaisyCoinsShort
	NPCMsg msg_0449_T01R0201_PalletTown_RivalsHouse_Text_DaisySetCoins
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_6
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_7
_cv_yes_6:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_7:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PalletTown_RivalsHouse_EventScript_DaisyCoinsDecline
	// TODO(gba) special ItemUpgrade_PayAndUpgrade
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PalletTown_RivalsHouse_EventScript_DaisyCoinsEnd
	NPCMsg msg_0449_T01R0201_PalletTown_RivalsHouse_Text_DaisyLetMeSee
	WaitButton
	CloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	PlayFanfare SEQ_ME_LVUP
	WaitFanfare
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	// TODO(gba) special ItemUpgrade_BufferLevel
	NPCMsg msg_0449_T01R0201_PalletTown_RivalsHouse_Text_DaisyCoinLevel
	WaitButton
	GoTo PalletTown_RivalsHouse_EventScript_DaisyCoinsEnd
	
PalletTown_RivalsHouse_EventScript_RateMonFriendship:
	BufferPlayersName 6
	NPCMsg msg_0449_T01R0201_PalletTown_RivalsHouse_Text_MayISeeFirstMon
	WaitButton
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar GetLeadMonFriendship
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PalletTown_RivalsHouse_EventScript_MonFriendshipLowest
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq PalletTown_RivalsHouse_EventScript_MonFriendshipLower
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq PalletTown_RivalsHouse_EventScript_MonFriendshipLow
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfEq PalletTown_RivalsHouse_EventScript_MonFriendshipMid
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfEq PalletTown_RivalsHouse_EventScript_MonFriendshipHigh
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfEq PalletTown_RivalsHouse_EventScript_MonFriendshipHigher
	CompareVarToValue VAR_SPECIAL_RESULT, 6
	GoToIfEq PalletTown_RivalsHouse_EventScript_MonFriendshipHighest
	CloseMsg
	End
	
PalletTown_RivalsHouse_EventScript_DeclineGrooming:
	NPCMsg msg_0449_T01R0201_PalletTown_RivalsHouse_Text_DontNeedAnyGrooming
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_RivalsHouse_EventScript_CantGroomEgg:
	NPCMsg msg_0449_T01R0201_PalletTown_RivalsHouse_Text_CantGroomAnEgg
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_Return:
	Return
	
PalletTown_RivalsHouse_EventScript_NoRoomForTownMap:
	NPCMsg msg_0449_T01R0201_PalletTown_RivalsHouse_Text_DontHaveSpaceForThis
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_RivalsHouse_EventScript_DaisyCoinsMaxed:
	NPCMsg msg_0449_T01R0201_PalletTown_RivalsHouse_Text_DaisyCoinMaxed
	WaitButton
	GoTo PalletTown_RivalsHouse_EventScript_DaisyCoinsEnd
	
PalletTown_RivalsHouse_EventScript_DaisyCoinsShort:
	NPCMsg msg_0449_T01R0201_PalletTown_RivalsHouse_Text_DaisyNeedMoreCoins
	WaitButton
	GoTo PalletTown_RivalsHouse_EventScript_DaisyCoinsEnd
	
PalletTown_RivalsHouse_EventScript_DaisyCoinsDecline:
	NPCMsg msg_0449_T01R0201_PalletTown_RivalsHouse_Text_DaisyKeepThem
	WaitButton
	End
	
PalletTown_RivalsHouse_EventScript_DaisyCoinsEnd:
	ReleaseAll
	End
	
PalletTown_RivalsHouse_EventScript_MonFriendshipLowest:
	NPCMsg msg_0449_T01R0201_PalletTown_RivalsHouse_Text_WhyWouldMonHateYouSoMuch
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_RivalsHouse_EventScript_MonFriendshipLower:
	BufferPlayersName 6
	NPCMsg msg_0449_T01R0201_PalletTown_RivalsHouse_Text_DontLikeWayItGlaresAtYou
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_RivalsHouse_EventScript_MonFriendshipLow:
	NPCMsg msg_0449_T01R0201_PalletTown_RivalsHouse_Text_NotFamiliarWithYouYet
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_RivalsHouse_EventScript_MonFriendshipMid:
	NPCMsg msg_0449_T01R0201_PalletTown_RivalsHouse_Text_ItsWarmingUpToYou
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_RivalsHouse_EventScript_MonFriendshipHigh:
	NPCMsg msg_0449_T01R0201_PalletTown_RivalsHouse_Text_ItsQuiteFriendly
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_RivalsHouse_EventScript_MonFriendshipHigher:
	BufferRivalsName 7
	NPCMsg msg_0449_T01R0201_PalletTown_RivalsHouse_Text_ItLooksVeryHappy
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_RivalsHouse_EventScript_MonFriendshipHighest:
	NPCMsg msg_0449_T01R0201_PalletTown_RivalsHouse_Text_CouldntLoveYouMore
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_0:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0449_T01R0201_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
Common_Movement_FaceOriginalDirection:
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterRight:
	WalkOnSpotFasterEast
	EndMovement
	.balign 4, 0
