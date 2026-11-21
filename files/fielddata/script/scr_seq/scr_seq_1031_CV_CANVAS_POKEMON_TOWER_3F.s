#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_POKEMON_TOWER_3F.h"
#include "msgdata/msg/msg_0887_CV_CANVAS_POKEMON_TOWER_3F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PokemonTower_3F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef PokemonTower_3F_EventScript_ItemEscapeRope
	ScrDef TowerGraves_EventScript_Ghost
	ScrDef PokemonTower_EventScript_Grave12
	ScrDef PokemonTower_EventScript_Grave13
	ScrDef PokemonTower_EventScript_Grave14
	ScrDef PokemonTower_EventScript_Grave15
	ScrDef PokemonTower_EventScript_Grave16
	ScrDef PokemonTower_EventScript_Grave17
	ScrDef PokemonTower_EventScript_Grave18
	ScrDef PokemonTower_EventScript_Grave19
	ScrDef PokemonTower_EventScript_Grave20
	ScrDef PokemonTower_EventScript_Grave21
	ScrDef TowerGraves_EventScript_HideGhosts
	ScrDefEnd
	
PokemonTower_3F_EventScript_ItemEscapeRope:
	SetVar 0x8004, ITEM_ESCAPE_ROPE
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
TowerGraves_EventScript_Ghost:
	End
	
PokemonTower_EventScript_Grave12:
	SetVar 0x8004, 12
	GoTo TowerGraves_EventScript_Read
	
PokemonTower_EventScript_Grave13:
	SetVar 0x8004, 13
	GoTo TowerGraves_EventScript_Read
	
PokemonTower_EventScript_Grave14:
	SetVar 0x8004, 14
	GoTo TowerGraves_EventScript_Read
	
PokemonTower_EventScript_Grave15:
	SetVar 0x8004, 15
	GoTo TowerGraves_EventScript_Read
	
PokemonTower_EventScript_Grave16:
	SetVar 0x8004, 16
	GoTo TowerGraves_EventScript_Read
	
PokemonTower_EventScript_Grave17:
	SetVar 0x8004, 17
	GoTo TowerGraves_EventScript_Read
	
PokemonTower_EventScript_Grave18:
	SetVar 0x8004, 18
	GoTo TowerGraves_EventScript_Read
	
PokemonTower_EventScript_Grave19:
	SetVar 0x8004, 19
	GoTo TowerGraves_EventScript_Read
	
PokemonTower_EventScript_Grave20:
	SetVar 0x8004, 20
	GoTo TowerGraves_EventScript_Read
	
PokemonTower_EventScript_Grave21:
	SetVar 0x8004, 21
	GoTo TowerGraves_EventScript_Read
	
TowerGraves_EventScript_HideGhosts:
	SetFlag 31
	End
	
TowerGraves_EventScript_Read:
	LockAll
	// TODO(gba) special TowerGraves_Read
	GoTo _cv_stop
	CopyVar 0x8006, VAR_SPECIAL_RESULT
	NPCMsg msg_0887_CV_CANVAS_POKEMON_TOWER_3F_TowerGraves_Text_Grave
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
	NPCMsg msg_0887_CV_CANVAS_POKEMON_TOWER_3F_TowerGraves_Text_GirlLament
	WaitButton
	SetVar VAR_SPECIAL_RESULT, 1
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TowerGraves_EventScript_NoRoom
	SetFlag 0x2183
	SetVar VAR_SPECIAL_RESULT, 1
	SetFlag 0x2184
	NPCMsg msg_0887_CV_CANVAS_POKEMON_TOWER_3F_TowerGraves_Text_GirlKeepThemAsTheyAre
	WaitButton
	CanvasCloseMsg
	// TODO(gba) special TowerGraves_DismissGhosts
	GoTo _cv_stop
	NPCMsg msg_0887_CV_CANVAS_POKEMON_TOWER_3F_TowerGraves_Text_Gone
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TowerGraves_EventScript_NoRoom:
	NPCMsg msg_0887_CV_CANVAS_POKEMON_TOWER_3F_TowerGraves_Text_GirlNoRoom
	WaitButton
	CanvasCloseMsg
	// TODO(gba) special TowerGraves_DismissGhosts
	GoTo _cv_stop
	CanvasCloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0887_CV_CANVAS_POKEMON_TOWER_3F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
