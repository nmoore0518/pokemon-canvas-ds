#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T01R0102.h"
#include "msgdata/msg/msg_0448_T01R0102.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PalletTown_PlayersHouse_2F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef PalletTown_PlayersHouse_2F_EventScript_NES
	ScrDef EventScript_PalletTown_PlayersHouse_2F_TurnOnPC
	ScrDef PalletTown_PlayersHouse_2F_EventScript_Sign
	ScrDef Outfits_EventScript_Wardrobe
	ScrDef PalletTown_PlayersHouse_2F_OnTransition
	ScrDefEnd
	
PalletTown_PlayersHouse_2F_EventScript_NES:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	BufferPlayersName 6
	NPCMsg msg_0448_T01R0102_PalletTown_PlayersHouse_2F_Text_PlayedWithNES
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_PalletTown_PlayersHouse_2F_TurnOnPC:
	LockAll
	SetVar 0x8004, 3
	// TODO(gba) special DoPCTurnOnEffect
	GoTo _cv_stop
	PlaySE SEQ_SE_DP_SELECT
	BufferPlayersName 6
	NPCMsg msg_0448_T01R0102_gText_PlayerHouseBootPC
	WaitButton
	// TODO(gba) special BedroomPC
	GoTo _cv_stop
	CloseMsg
	ReleaseAll
	End
	
PalletTown_PlayersHouse_2F_EventScript_Sign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0448_T01R0102_PalletTown_PlayersHouse_2F_Text_PressLRForHelp
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Outfits_EventScript_Wardrobe:
	LockAll
	SetVar VAR_SPECIAL_RESULT, 1
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfLe Outfits_EventScript_OnlyOne
	NPCMsg msg_0448_T01R0102_Outfits_Text_WhichOutfit
	Call Outfits_EventScript_PushList
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_2
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq Outfits_EventScript_Done
	CompareVarToVar VAR_SPECIAL_RESULT, 0x500A
	GoToIfEq Outfits_EventScript_Done
	CopyVar 0x8004, VAR_SPECIAL_RESULT
	CanvasCloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special Outfit_Wear
	GoTo _cv_stop
	PlaySE SEQ_SE_DP_KAIDAN2
	Wait 20, VAR_SPECIAL_RESULT
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	BufferPlayersName 6
	NPCMsg msg_0448_T01R0102_Outfits_Text_ChangedInto
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_PlayersHouse_2F_OnTransition:
	CompareVarToValue 0x500B, 0
	CallIfEq PalletTown_PlayersHouse_2F_EventScript_SetRespawn
	End
	
Outfits_EventScript_OnlyOne:
	NPCMsg msg_0448_T01R0102_Outfits_Text_OnlyOne
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Outfits_EventScript_PushList:
	SetVar 0x8004, 0
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Outfits_EventScript_Skip_CASUAL
	GoTo Outfits_EventScript_Skip_CASUAL
	
Outfits_EventScript_Done:
	CanvasCloseMsg
	CanvasCloseMsg
	ReleaseAll
	End
	
PalletTown_PlayersHouse_2F_EventScript_SetRespawn:
	Return
	
Outfits_EventScript_Skip_CASUAL:
	SetVar 0x8004, 1
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Outfits_EventScript_Skip_ROCKET
	GoTo Outfits_EventScript_Skip_ROCKET
	
Outfits_EventScript_Skip_ROCKET:
	SetVar 0x8004, 2
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Outfits_EventScript_Skip_NORMAL
	GoTo Outfits_EventScript_Skip_NORMAL
	
Outfits_EventScript_Skip_NORMAL:
	SetVar 0x8004, 3
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Outfits_EventScript_Skip_FIGHTING
	GoTo Outfits_EventScript_Skip_FIGHTING
	
Outfits_EventScript_Skip_FIGHTING:
	SetVar 0x8004, 4
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Outfits_EventScript_Skip_FLYING
	GoTo Outfits_EventScript_Skip_FLYING
	
Outfits_EventScript_Skip_FLYING:
	SetVar 0x8004, 5
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Outfits_EventScript_Skip_POISON
	GoTo Outfits_EventScript_Skip_POISON
	
Outfits_EventScript_Skip_POISON:
	SetVar 0x8004, 6
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Outfits_EventScript_Skip_GROUND
	GoTo Outfits_EventScript_Skip_GROUND
	
Outfits_EventScript_Skip_GROUND:
	SetVar 0x8004, 7
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Outfits_EventScript_Skip_ROCK
	GoTo Outfits_EventScript_Skip_ROCK
	
Outfits_EventScript_Skip_ROCK:
	SetVar 0x8004, 8
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Outfits_EventScript_Skip_BUG
	GoTo Outfits_EventScript_Skip_BUG
	
Outfits_EventScript_Skip_BUG:
	SetVar 0x8004, 9
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Outfits_EventScript_Skip_GHOST
	GoTo Outfits_EventScript_Skip_GHOST
	
Outfits_EventScript_Skip_GHOST:
	SetVar 0x8004, 10
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Outfits_EventScript_Skip_STEEL
	GoTo Outfits_EventScript_Skip_STEEL
	
Outfits_EventScript_Skip_STEEL:
	SetVar 0x8004, 11
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Outfits_EventScript_Skip_FIRE
	GoTo Outfits_EventScript_Skip_FIRE
	
Outfits_EventScript_Skip_FIRE:
	SetVar 0x8004, 12
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Outfits_EventScript_Skip_WATER
	GoTo Outfits_EventScript_Skip_WATER
	
Outfits_EventScript_Skip_WATER:
	SetVar 0x8004, 13
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Outfits_EventScript_Skip_GRASS
	GoTo Outfits_EventScript_Skip_GRASS
	
Outfits_EventScript_Skip_GRASS:
	SetVar 0x8004, 14
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Outfits_EventScript_Skip_ELECTRIC
	GoTo Outfits_EventScript_Skip_ELECTRIC
	
Outfits_EventScript_Skip_ELECTRIC:
	SetVar 0x8004, 15
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Outfits_EventScript_Skip_PSYCHIC
	GoTo Outfits_EventScript_Skip_PSYCHIC
	
Outfits_EventScript_Skip_PSYCHIC:
	SetVar 0x8004, 16
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Outfits_EventScript_Skip_ICE
	GoTo Outfits_EventScript_Skip_ICE
	
Outfits_EventScript_Skip_ICE:
	SetVar 0x8004, 17
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Outfits_EventScript_Skip_DRAGON
	GoTo Outfits_EventScript_Skip_DRAGON
	
Outfits_EventScript_Skip_DRAGON:
	SetVar 0x8004, 18
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Outfits_EventScript_Skip_DARK
	GoTo Outfits_EventScript_Skip_DARK
	
Outfits_EventScript_Skip_DARK:
	SetVar 0x8004, 19
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Outfits_EventScript_Skip_FAIRY
	GoTo Outfits_EventScript_Skip_FAIRY
	
Outfits_EventScript_Skip_FAIRY:
	Return

_cv_stop:
	NPCMsg msg_0448_T01R0102_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
