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
	CompareVarToValue 0x8004, 0
	GoToIfNe _cv_next_22
	SetVar 0x8005, SPECIES_CHARMANDER
	CanvasBufferMsg 1, msg_0887_CV_CANVAS_POKEMON_TOWER_3F_cv_grave_trainer_00
	SetFlag 0x22E9
	GoTo _cv_done_21
_cv_next_22:
	CompareVarToValue 0x8004, 1
	GoToIfNe _cv_next_23
	SetVar 0x8005, SPECIES_KANGASKHAN
	CanvasBufferMsg 1, msg_0887_CV_CANVAS_POKEMON_TOWER_3F_cv_grave_trainer_01
	GoTo _cv_done_21
_cv_next_23:
	CompareVarToValue 0x8004, 2
	GoToIfNe _cv_next_24
	SetVar 0x8005, SPECIES_PERSIAN
	CanvasBufferMsg 1, msg_0887_CV_CANVAS_POKEMON_TOWER_3F_cv_grave_trainer_02
	GoTo _cv_done_21
_cv_next_24:
	CompareVarToValue 0x8004, 3
	GoToIfNe _cv_next_25
	SetVar 0x8005, SPECIES_PIDGEY
	CanvasBufferMsg 1, msg_0887_CV_CANVAS_POKEMON_TOWER_3F_cv_grave_trainer_03
	SetFlag 0x22EA
	GoTo _cv_done_21
_cv_next_25:
	CompareVarToValue 0x8004, 4
	GoToIfNe _cv_next_26
	SetVar 0x8005, SPECIES_TAUROS
	CanvasBufferMsg 1, msg_0887_CV_CANVAS_POKEMON_TOWER_3F_cv_grave_trainer_04
	GoTo _cv_done_21
_cv_next_26:
	CompareVarToValue 0x8004, 5
	GoToIfNe _cv_next_27
	SetVar 0x8005, SPECIES_BUTTERFREE
	CanvasBufferMsg 1, msg_0887_CV_CANVAS_POKEMON_TOWER_3F_cv_grave_trainer_05
	GoTo _cv_done_21
_cv_next_27:
	CompareVarToValue 0x8004, 6
	GoToIfNe _cv_next_28
	SetVar 0x8005, SPECIES_CATERPIE
	CanvasBufferMsg 1, msg_0887_CV_CANVAS_POKEMON_TOWER_3F_cv_grave_trainer_06
	SetFlag 0x22EB
	GoTo _cv_done_21
_cv_next_28:
	CompareVarToValue 0x8004, 7
	GoToIfNe _cv_next_29
	SetVar 0x8005, SPECIES_SNORLAX
	CanvasBufferMsg 1, msg_0887_CV_CANVAS_POKEMON_TOWER_3F_cv_grave_trainer_07
	GoTo _cv_done_21
_cv_next_29:
	CompareVarToValue 0x8004, 8
	GoToIfNe _cv_next_30
	SetVar 0x8005, SPECIES_LAPRAS
	CanvasBufferMsg 1, msg_0887_CV_CANVAS_POKEMON_TOWER_3F_cv_grave_trainer_08
	GoTo _cv_done_21
_cv_next_30:
	CompareVarToValue 0x8004, 9
	GoToIfNe _cv_next_31
	SetVar 0x8005, SPECIES_RATTATA
	CanvasBufferMsg 1, msg_0887_CV_CANVAS_POKEMON_TOWER_3F_cv_grave_trainer_09
	SetFlag 0x22EC
	GoTo _cv_done_21
_cv_next_31:
	CompareVarToValue 0x8004, 10
	GoToIfNe _cv_next_32
	SetVar 0x8005, SPECIES_ARCANINE
	CanvasBufferMsg 1, msg_0887_CV_CANVAS_POKEMON_TOWER_3F_cv_grave_trainer_10
	GoTo _cv_done_21
_cv_next_32:
	CompareVarToValue 0x8004, 11
	GoToIfNe _cv_next_33
	SetVar 0x8005, SPECIES_CLEFABLE
	CanvasBufferMsg 1, msg_0887_CV_CANVAS_POKEMON_TOWER_3F_cv_grave_trainer_11
	GoTo _cv_done_21
_cv_next_33:
	CompareVarToValue 0x8004, 12
	GoToIfNe _cv_next_34
	SetVar 0x8005, SPECIES_GROWLITHE
	CanvasBufferMsg 1, msg_0887_CV_CANVAS_POKEMON_TOWER_3F_cv_grave_trainer_12
	SetFlag 0x22ED
	GoTo _cv_done_21
_cv_next_34:
	CompareVarToValue 0x8004, 13
	GoToIfNe _cv_next_35
	SetVar 0x8005, SPECIES_NIDOKING
	CanvasBufferMsg 1, msg_0887_CV_CANVAS_POKEMON_TOWER_3F_cv_grave_trainer_13
	GoTo _cv_done_21
_cv_next_35:
	CompareVarToValue 0x8004, 14
	GoToIfNe _cv_next_36
	SetVar 0x8005, SPECIES_DODRIO
	CanvasBufferMsg 1, msg_0887_CV_CANVAS_POKEMON_TOWER_3F_cv_grave_trainer_14
	GoTo _cv_done_21
_cv_next_36:
	CompareVarToValue 0x8004, 15
	GoToIfNe _cv_next_37
	SetVar 0x8005, SPECIES_EEVEE
	CanvasBufferMsg 1, msg_0887_CV_CANVAS_POKEMON_TOWER_3F_cv_grave_trainer_15
	SetFlag 0x22EE
	GoTo _cv_done_21
_cv_next_37:
	CompareVarToValue 0x8004, 16
	GoToIfNe _cv_next_38
	SetVar 0x8005, SPECIES_GOLDUCK
	CanvasBufferMsg 1, msg_0887_CV_CANVAS_POKEMON_TOWER_3F_cv_grave_trainer_16
	GoTo _cv_done_21
_cv_next_38:
	CompareVarToValue 0x8004, 17
	GoToIfNe _cv_next_39
	SetVar 0x8005, SPECIES_DITTO
	CanvasBufferMsg 1, msg_0887_CV_CANVAS_POKEMON_TOWER_3F_cv_grave_trainer_17
	GoTo _cv_done_21
_cv_next_39:
	CompareVarToValue 0x8004, 18
	GoToIfNe _cv_next_40
	SetVar 0x8005, SPECIES_VENUSAUR
	CanvasBufferMsg 1, msg_0887_CV_CANVAS_POKEMON_TOWER_3F_cv_grave_trainer_18
	GoTo _cv_done_21
_cv_next_40:
	CompareVarToValue 0x8004, 19
	GoToIfNe _cv_next_41
	SetVar 0x8005, SPECIES_MAGIKARP
	CanvasBufferMsg 1, msg_0887_CV_CANVAS_POKEMON_TOWER_3F_cv_grave_trainer_19
	SetFlag 0x22EF
	GoTo _cv_done_21
_cv_next_41:
	CompareVarToValue 0x8004, 20
	GoToIfNe _cv_next_42
	SetVar 0x8005, SPECIES_DEWGONG
	CanvasBufferMsg 1, msg_0887_CV_CANVAS_POKEMON_TOWER_3F_cv_grave_trainer_20
	GoTo _cv_done_21
_cv_next_42:
	CompareVarToValue 0x8004, 21
	GoToIfNe _cv_next_43
	SetVar 0x8005, SPECIES_CHARIZARD
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_2
	SetVar 0x8005, 865
	GoTo _cv_done_1
_cv_next_2:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_3
	SetVar 0x8005, SPECIES_EMPOLEON
	GoTo _cv_done_1
_cv_next_3:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_4
	SetVar 0x8005, 702
	GoTo _cv_done_1
_cv_next_4:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_5
	SetVar 0x8005, 780
	GoTo _cv_done_1
_cv_next_5:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_6
	SetVar 0x8005, SPECIES_TYPHLOSION
	GoTo _cv_done_1
_cv_next_6:
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_7
	SetVar 0x8005, SPECIES_CHARIZARD
	GoTo _cv_done_1
_cv_next_7:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_8
	SetVar 0x8005, 958
	GoTo _cv_done_1
_cv_next_8:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_9
	SetVar 0x8005, 705
	GoTo _cv_done_1
_cv_next_9:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_10
	SetVar 0x8005, 780
	GoTo _cv_done_1
_cv_next_10:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_11
	SetVar 0x8005, SPECIES_VENUSAUR
	GoTo _cv_done_1
_cv_next_11:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_12
	SetVar 0x8005, SPECIES_CHARIZARD
	GoTo _cv_done_1
_cv_next_12:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_13
	SetVar 0x8005, SPECIES_BLASTOISE
	GoTo _cv_done_1
_cv_next_13:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_14
	SetVar 0x8005, SPECIES_BLASTOISE
	GoTo _cv_done_1
_cv_next_14:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_15
	SetVar 0x8005, SPECIES_BLAZIKEN
	GoTo _cv_done_1
_cv_next_15:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_16
	SetVar 0x8005, SPECIES_TORTERRA
	GoTo _cv_done_1
_cv_next_16:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_17
	SetVar 0x8005, SPECIES_SCEPTILE
	GoTo _cv_done_1
_cv_next_17:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_18
	SetVar 0x8005, 961
	GoTo _cv_done_1
_cv_next_18:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_19
	SetVar 0x8005, 708
	GoTo _cv_done_1
_cv_next_19:
_cv_done_1:
	CanvasBufferMsg 1, msg_0887_CV_CANVAS_POKEMON_TOWER_3F_cv_grave_trainer_21
	GoTo _cv_done_21
_cv_next_43:
	CompareVarToValue 0x8004, 22
	GoToIfNe _cv_next_44
	SetVar 0x8005, SPECIES_VULPIX
	CanvasBufferMsg 1, msg_0887_CV_CANVAS_POKEMON_TOWER_3F_cv_grave_trainer_22
	SetFlag 0x22F0
	GoTo _cv_done_21
_cv_next_44:
	CompareVarToValue 0x8004, 23
	GoToIfNe _cv_next_45
	SetVar 0x8005, SPECIES_NINETALES
	CanvasBufferMsg 1, msg_0887_CV_CANVAS_POKEMON_TOWER_3F_cv_grave_trainer_23
	GoTo _cv_done_21
_cv_next_45:
	CompareVarToValue 0x8004, 24
	GoToIfNe _cv_next_46
	SetVar 0x8005, SPECIES_MACHAMP
	CanvasBufferMsg 1, msg_0887_CV_CANVAS_POKEMON_TOWER_3F_cv_grave_trainer_24
	GoTo _cv_done_21
_cv_next_46:
	CompareVarToValue 0x8004, 25
	GoToIfNe _cv_next_47
	SetVar 0x8005, SPECIES_ABRA
	CanvasBufferMsg 1, msg_0887_CV_CANVAS_POKEMON_TOWER_3F_cv_grave_trainer_25
	SetFlag 0x22F1
	GoTo _cv_done_21
_cv_next_47:
	CompareVarToValue 0x8004, 26
	GoToIfNe _cv_next_48
	SetVar 0x8005, SPECIES_RAICHU
	CanvasBufferMsg 1, msg_0887_CV_CANVAS_POKEMON_TOWER_3F_cv_grave_trainer_26
	GoTo _cv_done_21
_cv_next_48:
	CompareVarToValue 0x8004, 27
	GoToIfNe _cv_next_49
	SetVar 0x8005, SPECIES_HITMONCHAN
	CanvasBufferMsg 1, msg_0887_CV_CANVAS_POKEMON_TOWER_3F_cv_grave_trainer_27
	GoTo _cv_done_21
_cv_next_49:
	CompareVarToValue 0x8004, 28
	GoToIfNe _cv_next_50
	SetVar 0x8005, SPECIES_ODDISH
	CanvasBufferMsg 1, msg_0887_CV_CANVAS_POKEMON_TOWER_3F_cv_grave_trainer_28
	SetFlag 0x22F2
	GoTo _cv_done_21
_cv_next_50:
	CompareVarToValue 0x8004, 29
	GoToIfNe _cv_next_51
	SetVar 0x8005, SPECIES_PIDGEOT
	CanvasBufferMsg 1, msg_0887_CV_CANVAS_POKEMON_TOWER_3F_cv_grave_trainer_29
	GoTo _cv_done_21
_cv_next_51:
_cv_done_21:
	BufferSpeciesName 0, 0x8005, 0, 0
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfSet 0x2184, _cv_graves_20
	GoToIfUnset 0x22E9, _cv_graves_20
	GoToIfUnset 0x22EA, _cv_graves_20
	GoToIfUnset 0x22EB, _cv_graves_20
	GoToIfUnset 0x22EC, _cv_graves_20
	GoToIfUnset 0x22ED, _cv_graves_20
	GoToIfUnset 0x22EE, _cv_graves_20
	GoToIfUnset 0x22EF, _cv_graves_20
	GoToIfUnset 0x22F0, _cv_graves_20
	GoToIfUnset 0x22F1, _cv_graves_20
	GoToIfUnset 0x22F2, _cv_graves_20
	SetVar VAR_SPECIAL_RESULT, 1
_cv_graves_20:
	CopyVar 0x8006, VAR_SPECIAL_RESULT
	ScrCmd_452 0x8005, 0
	SetVar 0x5065, 1
	NPCMsg msg_0887_CV_CANVAS_POKEMON_TOWER_3F_TowerGraves_Text_Grave
	WaitButton
	CompareVarToValue 0x5065, 1
	GoToIfNe _cv_nopic_52
	ScrCmd_453
	SetVar 0x5065, 0
_cv_nopic_52:
	CompareVarToValue 0x8006, 1
	GoToIfEq TowerGraves_EventScript_GhostGirl
	CloseMsg
	ReleaseAll
	End
	
TowerGraves_EventScript_GhostGirl:
	Wait 30, VAR_SPECIAL_RESULT
	PlaySE SEQ_SE_DP_HYUN2
	ClearFlag 31
	ShowPerson 5
	ShowPerson 6
	CanvasCandidate 18, 5, 6
	PlayCry SPECIES_SCYTHER, 0
	WaitCry
	NPCMsg msg_0887_CV_CANVAS_POKEMON_TOWER_3F_TowerGraves_Text_GirlLament
	WaitButton
	HasSpaceForItem 2685, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TowerGraves_EventScript_NoRoom
	SetOrCopyVar 0x8004, 2685
	SetOrCopyVar 0x8005, 1
	HasSpaceForItem 0x8004, 0x8005, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_full_53
	CallStd std_give_item_verbose
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_given_54
_cv_full_53:
	SetVar VAR_SPECIAL_RESULT, 0
_cv_given_54:
	SetFlag 0x2184
	NPCMsg msg_0887_CV_CANVAS_POKEMON_TOWER_3F_TowerGraves_Text_GirlKeepThemAsTheyAre
	WaitButton
	CanvasCloseMsg
	CanvasCandidate 19, 5, 6
	HidePerson 5
	HidePerson 6
	SetFlag 31
	NPCMsg msg_0887_CV_CANVAS_POKEMON_TOWER_3F_TowerGraves_Text_Gone
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TowerGraves_EventScript_NoRoom:
	NPCMsg msg_0887_CV_CANVAS_POKEMON_TOWER_3F_TowerGraves_Text_GirlNoRoom
	WaitButton
	CanvasCloseMsg
	CanvasCandidate 19, 5, 6
	HidePerson 5
	HidePerson 6
	SetFlag 31
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
