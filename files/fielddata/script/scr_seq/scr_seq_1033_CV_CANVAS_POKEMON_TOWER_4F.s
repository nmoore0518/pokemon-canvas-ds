#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_POKEMON_TOWER_4F.h"
#include "msgdata/msg/msg_0888_CV_CANVAS_POKEMON_TOWER_4F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PokemonTower_4F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef PokemonTower_4F_EventScript_ItemElixir
	ScrDef PokemonTower_4F_EventScript_ItemAwakening
	ScrDef PokemonTower_4F_EventScript_ItemGreatBall
	ScrDef TowerGraves_EventScript_Ghost
	ScrDef PokemonTower_EventScript_Grave22
	ScrDef PokemonTower_EventScript_Grave23
	ScrDef PokemonTower_EventScript_Grave24
	ScrDef PokemonTower_EventScript_Grave25
	ScrDef PokemonTower_EventScript_Grave26
	ScrDef PokemonTower_EventScript_Grave27
	ScrDef PokemonTower_EventScript_Grave28
	ScrDef PokemonTower_EventScript_Grave29
	ScrDef TowerGraves_EventScript_HideGhosts
	ScrDefEnd
	
PokemonTower_4F_EventScript_ItemElixir:
	SetVar 0x8004, ITEM_ELIXIR
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
PokemonTower_4F_EventScript_ItemAwakening:
	SetVar 0x8004, ITEM_AWAKENING
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
PokemonTower_4F_EventScript_ItemGreatBall:
	SetVar 0x8004, ITEM_GREAT_BALL
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
TowerGraves_EventScript_Ghost:
	End
	
PokemonTower_EventScript_Grave22:
	SetVar 0x8004, 22
	GoTo TowerGraves_EventScript_Read
	
PokemonTower_EventScript_Grave23:
	SetVar 0x8004, 23
	GoTo TowerGraves_EventScript_Read
	
PokemonTower_EventScript_Grave24:
	SetVar 0x8004, 24
	GoTo TowerGraves_EventScript_Read
	
PokemonTower_EventScript_Grave25:
	SetVar 0x8004, 25
	GoTo TowerGraves_EventScript_Read
	
PokemonTower_EventScript_Grave26:
	SetVar 0x8004, 26
	GoTo TowerGraves_EventScript_Read
	
PokemonTower_EventScript_Grave27:
	SetVar 0x8004, 27
	GoTo TowerGraves_EventScript_Read
	
PokemonTower_EventScript_Grave28:
	SetVar 0x8004, 28
	GoTo TowerGraves_EventScript_Read
	
PokemonTower_EventScript_Grave29:
	SetVar 0x8004, 29
	GoTo TowerGraves_EventScript_Read
	
TowerGraves_EventScript_HideGhosts:
	SetFlag 31
	End
	
TowerGraves_EventScript_Read:
	LockAll
	// TODO(gba) special TowerGraves_Read
	GoTo _cv_stop
	CopyVar 0x8006, VAR_SPECIAL_RESULT
	NPCMsg msg_0888_CV_CANVAS_POKEMON_TOWER_4F_TowerGraves_Text_Grave
	WaitButton
	CompareVarToValue 0x8006, 1
	GoToIfEq TowerGraves_EventScript_GhostGirl
	CloseMsg
	ReleaseAll
	End
	
TowerGraves_EventScript_GhostGirl:
	Wait 30, VAR_SPECIAL_RESULT
	PlaySE SEQ_SE_DP_SELECT
	// TODO(gba) special TowerGraves_SummonGhosts
	GoTo _cv_stop
	PlayCry SPECIES_SCYTHER, 0
	WaitCry
	NPCMsg msg_0888_CV_CANVAS_POKEMON_TOWER_4F_TowerGraves_Text_GirlLament
	WaitButton
	SetVar VAR_SPECIAL_RESULT, 1
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TowerGraves_EventScript_NoRoom
	SetFlag 0x2183
	SetVar VAR_SPECIAL_RESULT, 1
	SetFlag 0x2184
	NPCMsg msg_0888_CV_CANVAS_POKEMON_TOWER_4F_TowerGraves_Text_GirlKeepThemAsTheyAre
	WaitButton
	CloseMsg
	// TODO(gba) special TowerGraves_DismissGhosts
	GoTo _cv_stop
	NPCMsg msg_0888_CV_CANVAS_POKEMON_TOWER_4F_TowerGraves_Text_Gone
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TowerGraves_EventScript_NoRoom:
	NPCMsg msg_0888_CV_CANVAS_POKEMON_TOWER_4F_TowerGraves_Text_GirlNoRoom
	WaitButton
	CloseMsg
	// TODO(gba) special TowerGraves_DismissGhosts
	GoTo _cv_stop
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0888_CV_CANVAS_POKEMON_TOWER_4F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
