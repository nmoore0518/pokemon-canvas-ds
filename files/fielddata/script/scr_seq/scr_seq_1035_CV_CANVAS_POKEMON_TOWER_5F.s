#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_POKEMON_TOWER_5F.h"
#include "msgdata/msg/msg_0889_CV_CANVAS_POKEMON_TOWER_5F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PokemonTower_5F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef PokemonTower_5F_EventScript_Channeler
	ScrDef PokemonTower_5F_EventScript_ItemNugget
	ScrDef PokemonTower_5F_EventScript_ItemCleanseTag
	ScrDef PokemonTower_5F_EventScript_PurifiedZone
	ScrDef PokemonTower_5F_EventScript_ExitPurifiedZone
	ScrDefEnd
	
PokemonTower_5F_EventScript_Channeler:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0889_CV_CANVAS_POKEMON_TOWER_5F_PokemonTower_5F_Text_RestHereInPurifiedSpace
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PokemonTower_5F_EventScript_ItemNugget:
	SetVar 0x8004, ITEM_NUGGET
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
PokemonTower_5F_EventScript_ItemCleanseTag:
	SetVar 0x8004, ITEM_CLEANSE_TAG
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
PokemonTower_5F_EventScript_PurifiedZone:
	LockAll
	FadeScreen 6, 1, 0, RGB_WHITE
	WaitFade
	HealParty
	FadeScreen 6, 1, 1, RGB_WHITE
	WaitFade
	BufferPlayersName 6
	NPCMsg msg_0889_CV_CANVAS_POKEMON_TOWER_5F_PokemonTower_5F_Text_PurifiedZoneMonsFullyHealed
	WaitButton
	SetVar 0x4001, 1
	CloseMsg
	ReleaseAll
	End
	
PokemonTower_5F_EventScript_ExitPurifiedZone:
	LockAll
	SetVar 0x4001, 0
	CanvasCloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0889_CV_CANVAS_POKEMON_TOWER_5F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
