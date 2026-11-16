#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R10PC0101.h"
#include "msgdata/msg/msg_0342_R10PC0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route10_PokemonCenter_1F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route10_PokemonCenter_1F_EventScript_Nurse
	ScrDef Route10_PokemonCenter_1F_EventScript_Gentleman
	ScrDef Route10_PokemonCenter_1F_EventScript_FatMan
	ScrDef Route10_PokemonCenter_1F_EventScript_Youngster
	ScrDef Route10_PokemonCenter_1F_EventScript_Aide
	ScrDef Route10_PokemonCenter_1F_OnTransition
	ScrDef CableClub_OnResume
	ScrDefEnd
	
Route10_PokemonCenter_1F_EventScript_Nurse:
	LockAll
	FacePlayer
	SetVar VAR_SPECIAL_x8007, 0
	CallStd std_nurse_joy
	ReleaseAll
	End
	
Route10_PokemonCenter_1F_EventScript_Gentleman:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0342_R10PC0101_Route10_PokemonCenter_1F_Text_EveryTypeStrongerThanOthers
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route10_PokemonCenter_1F_EventScript_FatMan:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0342_R10PC0101_Route10_PokemonCenter_1F_Text_NuggetUselessSoldFor5000
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route10_PokemonCenter_1F_EventScript_Youngster:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0342_R10PC0101_Route10_PokemonCenter_1F_Text_HeardGhostsHauntLavender
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route10_PokemonCenter_1F_EventScript_Aide:
	LockAll
	FacePlayer
	Call Route10_PokemonCenter_1F_EventScript_GetAideRequestInfo
	GoToIfSet 0x2122, Route10_PokemonCenter_1F_EventScript_AlreadyGotEverstone
	BufferPlayersName 6
	NPCMsg msg_0342_R10PC0101_Route10_PokemonCenter_1F_Text_GiveEverstoneIfCaught20Mons
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Aide_EventScript_DeclineCheckMons
	SetVar 0x8004, 0
	CountNationalDexSeen 0x8005
	CountNationalDexOwned 0x8006
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x2026, _cv_dex_3
	SetVar VAR_SPECIAL_RESULT, 1
_cv_dex_3:
	BufferInt 2, 0x8006
	Call Route10_PokemonCenter_1F_EventScript_GetAideRequestInfo
	CompareVarToValue 0x8006, 20
	GoToIfLt Aide_EventScript_HaventCaughtEnough
	NPCMsg msg_0342_R10PC0101_Route10_PokemonCenter_1F_Text_GreatHereYouGo
	WaitButton
	HasSpaceForItem ITEM_EVERSTONE, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Aide_EventScript_NoRoomForItem
	GiveItem ITEM_EVERSTONE, 1, VAR_SPECIAL_RESULT
	BufferItemName 1, ITEM_EVERSTONE
	BufferPlayersName 6
	NPCMsg msg_0342_R10PC0101_Route10_PokemonCenter_1F_Text_ReceivedEverstoneFromAide
	PlayFanfare SEQ_ME_LVUP
	WaitFanfare
	WaitButton
	SetFlag 0x2122
	NPCMsg msg_0342_R10PC0101_Route10_PokemonCenter_1F_Text_ExplainEverstone
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route10_PokemonCenter_1F_OnTransition:
	End
	
CableClub_OnResume:
	// TODO(gba) special InitUnionRoom
	// TODO(gba) .if OW_FLAG_MOVE_UNION_ROOM_CHECK != 0
	Return
	// TODO(gba) .else 
	End
	// TODO(gba) .endif 
	End
	
Route10_PokemonCenter_1F_EventScript_GetAideRequestInfo:
	BufferInt 0, 20
	BufferItemName 1, ITEM_EVERSTONE
	Return
	
Route10_PokemonCenter_1F_EventScript_AlreadyGotEverstone:
	NPCMsg msg_0342_R10PC0101_Route10_PokemonCenter_1F_Text_ExplainEverstone
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Aide_EventScript_DeclineCheckMons:
	NPCMsg msg_0342_R10PC0101_Aide_Text_GetEnoughMonsComeBackForItem
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Aide_EventScript_HaventCaughtEnough:
	NPCMsg msg_0342_R10PC0101_Aide_Text_HaventCaughtEnoughMonsForItem
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Aide_EventScript_NoRoomForItem:
	NPCMsg msg_0342_R10PC0101_Aide_Text_DontHaveAnyRoomForItem
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0342_R10PC0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
