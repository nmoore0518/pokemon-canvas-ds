#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM.h"
#include "msgdata/msg/msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's CinnabarIsland_PokemonLab_ExperimentRoom_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_Garett
	ScrDef CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_FossilScientist
	ScrDef PaintWorld_EventScript_Figure
	ScrDefEnd
	
CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_Garett:
	LockAll
	FacePlayer
	SetVar 0x8008, 12
	Call EventScript_GetInGameTradeSpeciesInfo
	GoToIfSet 0x21FA, CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_AlreadyTraded
	NPCMsg msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_Trade_Text_LookingForMonWannaTradeForMon
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_DeclineTrade
	Call EventScript_ChooseMonForInGameTrade
	CompareVarToValue 0x8004, 6
	GoToIfGe CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_DeclineTrade
	Call EventScript_GetInGameTradeSpecies
	CompareVarToVar VAR_SPECIAL_RESULT, 0x8009
	GoToIfNe CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_NotRequestedMon
	Call EventScript_DoInGameTrade
	NPCMsg msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_Trade_Text_HeyThanks
	WaitButton
	SetFlag 0x21FA
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_FossilScientist:
	LockAll
	FacePlayer
	CompareVarToValue 0x5040, 2
	GoToIfEq CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_GiveRevivedMon
	CompareVarToValue 0x5040, 1
	GoToIfEq CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_FossilStillReviving
	SetVar VAR_SPECIAL_RESULT, 0
	HasItem ITEM_HELIX_FOSSIL, 1, 0x401E
	CompareVarToValue 0x401E, 0
	GoToIfEq _cv_fossil_3
	AddVar VAR_SPECIAL_RESULT, 1
_cv_fossil_3:
	HasItem ITEM_DOME_FOSSIL, 1, 0x401E
	CompareVarToValue 0x401E, 0
	GoToIfEq _cv_fossil_4
	AddVar VAR_SPECIAL_RESULT, 1
_cv_fossil_4:
	HasItem ITEM_OLD_AMBER, 1, 0x401E
	CompareVarToValue 0x401E, 0
	GoToIfEq _cv_fossil_5
	AddVar VAR_SPECIAL_RESULT, 1
_cv_fossil_5:
	HasItem ITEM_ROOT_FOSSIL, 1, 0x401E
	CompareVarToValue 0x401E, 0
	GoToIfEq _cv_fossil_6
	AddVar VAR_SPECIAL_RESULT, 1
_cv_fossil_6:
	HasItem ITEM_CLAW_FOSSIL, 1, 0x401E
	CompareVarToValue 0x401E, 0
	GoToIfEq _cv_fossil_7
	AddVar VAR_SPECIAL_RESULT, 1
_cv_fossil_7:
	HasItem ITEM_SKULL_FOSSIL, 1, 0x401E
	CompareVarToValue 0x401E, 0
	GoToIfEq _cv_fossil_8
	AddVar VAR_SPECIAL_RESULT, 1
_cv_fossil_8:
	HasItem ITEM_ARMOR_FOSSIL, 1, 0x401E
	CompareVarToValue 0x401E, 0
	GoToIfEq _cv_fossil_9
	AddVar VAR_SPECIAL_RESULT, 1
_cv_fossil_9:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_NoFossil
	NPCMsg msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_CinnabarIsland_PokemonLab_ExperimentRoom_Text_HaveYouAFossilForMe
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	HasItem ITEM_HELIX_FOSSIL, 1, 0x401E
	CompareVarToValue 0x401E, 0
	GoToIfEq _cv_item_11
	ScrCmd_559 msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_cv_fossil_0, 0
_cv_item_11:
	HasItem ITEM_DOME_FOSSIL, 1, 0x401E
	CompareVarToValue 0x401E, 0
	GoToIfEq _cv_item_12
	ScrCmd_559 msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_cv_fossil_1, 1
_cv_item_12:
	HasItem ITEM_OLD_AMBER, 1, 0x401E
	CompareVarToValue 0x401E, 0
	GoToIfEq _cv_item_13
	ScrCmd_559 msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_cv_fossil_2, 2
_cv_item_13:
	HasItem ITEM_ROOT_FOSSIL, 1, 0x401E
	CompareVarToValue 0x401E, 0
	GoToIfEq _cv_item_14
	ScrCmd_559 msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_cv_fossil_3, 3
_cv_item_14:
	HasItem ITEM_CLAW_FOSSIL, 1, 0x401E
	CompareVarToValue 0x401E, 0
	GoToIfEq _cv_item_15
	ScrCmd_559 msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_cv_fossil_4, 4
_cv_item_15:
	HasItem ITEM_SKULL_FOSSIL, 1, 0x401E
	CompareVarToValue 0x401E, 0
	GoToIfEq _cv_item_16
	ScrCmd_559 msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_cv_fossil_5, 5
_cv_item_16:
	HasItem ITEM_ARMOR_FOSSIL, 1, 0x401E
	CompareVarToValue 0x401E, 0
	GoToIfEq _cv_item_17
	ScrCmd_559 msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_cv_fossil_6, 6
_cv_item_17:
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_18
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_18:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_DontShowFossil
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_next_20
	SetVar 0x8005, ITEM_HELIX_FOSSIL
	BufferSpeciesName 0, SPECIES_OMANYTE, 0, 0
	BufferItemName 1, ITEM_HELIX_FOSSIL
	GoTo _cv_done_19
_cv_next_20:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfNe _cv_next_21
	SetVar 0x8005, ITEM_DOME_FOSSIL
	BufferSpeciesName 0, SPECIES_KABUTO, 0, 0
	BufferItemName 1, ITEM_DOME_FOSSIL
	GoTo _cv_done_19
_cv_next_21:
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfNe _cv_next_22
	SetVar 0x8005, ITEM_OLD_AMBER
	BufferSpeciesName 0, SPECIES_AERODACTYL, 0, 0
	BufferItemName 1, ITEM_OLD_AMBER
	GoTo _cv_done_19
_cv_next_22:
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfNe _cv_next_23
	SetVar 0x8005, ITEM_ROOT_FOSSIL
	BufferSpeciesName 0, SPECIES_LILEEP, 0, 0
	BufferItemName 1, ITEM_ROOT_FOSSIL
	GoTo _cv_done_19
_cv_next_23:
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfNe _cv_next_24
	SetVar 0x8005, ITEM_CLAW_FOSSIL
	BufferSpeciesName 0, SPECIES_ANORITH, 0, 0
	BufferItemName 1, ITEM_CLAW_FOSSIL
	GoTo _cv_done_19
_cv_next_24:
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfNe _cv_next_25
	SetVar 0x8005, ITEM_SKULL_FOSSIL
	BufferSpeciesName 0, SPECIES_CRANIDOS, 0, 0
	BufferItemName 1, ITEM_SKULL_FOSSIL
	GoTo _cv_done_19
_cv_next_25:
	CompareVarToValue VAR_SPECIAL_RESULT, 6
	GoToIfNe _cv_next_26
	SetVar 0x8005, ITEM_ARMOR_FOSSIL
	BufferSpeciesName 0, SPECIES_SHIELDON, 0, 0
	BufferItemName 1, ITEM_ARMOR_FOSSIL
	GoTo _cv_done_19
_cv_next_26:
_cv_done_19:
	NPCMsg msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_CinnabarIsland_PokemonLab_ExperimentRoom_Text_ThatFossilIsOfMonMakeItLiveAgain
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_27
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_28
_cv_yes_27:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_28:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_DeclineReviveFossil
	BufferPlayersName 6
	NPCMsg msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_CinnabarIsland_PokemonLab_ExperimentRoom_Text_HandedFossilToWeirdDoctor
	WaitButton
	TakeItem 0x8005, 1, VAR_SPECIAL_RESULT
	NPCMsg msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_CinnabarIsland_PokemonLab_ExperimentRoom_Text_TakesTimeGoForWalk
	WaitButton
	SetVar 0x5040, 1
	CopyVar 0x5041, 0x8005
	CloseMsg
	ReleaseAll
	End
	
PaintWorld_EventScript_Figure:
	LockAll
	FacePlayer
	CompareVarToValue 0x5020, 2
	GoToIfEq PaintWorld_EventScript_FigureSketch
	CompareVarToValue 0x5020, 3
	GoToIfEq PaintWorld_EventScript_FigureMega
	NPCMsg msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_PaintWorld_Text_FigureFirst
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
EventScript_GetInGameTradeSpeciesInfo:
	CopyVar 0x8005, 0x8008
	CompareVarToValue 0x8005, 4
	GoToIfNe _cv_next_30
	LoadNPCTrade 13
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_29
_cv_next_30:
	CompareVarToValue 0x8005, 5
	GoToIfNe _cv_next_31
	LoadNPCTrade 14
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_29
_cv_next_31:
	CompareVarToValue 0x8005, 6
	GoToIfNe _cv_next_32
	LoadNPCTrade 15
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_29
_cv_next_32:
	CompareVarToValue 0x8005, 7
	GoToIfNe _cv_next_33
	LoadNPCTrade 16
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_29
_cv_next_33:
	CompareVarToValue 0x8005, 8
	GoToIfNe _cv_next_34
	LoadNPCTrade 17
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_29
_cv_next_34:
	CompareVarToValue 0x8005, 9
	GoToIfNe _cv_next_35
	LoadNPCTrade 18
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_29
_cv_next_35:
	CompareVarToValue 0x8005, 10
	GoToIfNe _cv_next_36
	LoadNPCTrade 19
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_29
_cv_next_36:
	CompareVarToValue 0x8005, 11
	GoToIfNe _cv_next_37
	LoadNPCTrade 20
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_29
_cv_next_37:
	CompareVarToValue 0x8005, 12
	GoToIfNe _cv_next_38
	LoadNPCTrade 21
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_29
_cv_next_38:
_cv_done_29:
	Return
	
CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_AlreadyTraded:
	NPCMsg msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_Trade_Text_IsntMyOldMonGreat
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_DeclineTrade:
	NPCMsg msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_Trade_Text_AwwOhWell
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_ChooseMonForInGameTrade:
	CloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	ScrCmd_566
	GetPartySelection 0x8004
	RestoreOverworld
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	LockAll
	FacePlayer
	Return
	
EventScript_GetInGameTradeSpecies:
	GetPartyMonSpecies 0x8004, VAR_SPECIAL_RESULT
	Return
	
CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_NotRequestedMon:
	BufferSpeciesName 0, 0x8009, 0, 0
	NPCMsg msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_Trade_Text_WhatThatsNoMon
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_DoInGameTrade:
	CompareVarToValue 0x8005, 4
	GoToIfNe _cv_next_40
	LoadNPCTrade 13
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_39
_cv_next_40:
	CompareVarToValue 0x8005, 5
	GoToIfNe _cv_next_41
	LoadNPCTrade 14
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_39
_cv_next_41:
	CompareVarToValue 0x8005, 6
	GoToIfNe _cv_next_42
	LoadNPCTrade 15
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_39
_cv_next_42:
	CompareVarToValue 0x8005, 7
	GoToIfNe _cv_next_43
	LoadNPCTrade 16
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_39
_cv_next_43:
	CompareVarToValue 0x8005, 8
	GoToIfNe _cv_next_44
	LoadNPCTrade 17
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_39
_cv_next_44:
	CompareVarToValue 0x8005, 9
	GoToIfNe _cv_next_45
	LoadNPCTrade 18
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_39
_cv_next_45:
	CompareVarToValue 0x8005, 10
	GoToIfNe _cv_next_46
	LoadNPCTrade 19
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_39
_cv_next_46:
	CompareVarToValue 0x8005, 11
	GoToIfNe _cv_next_47
	LoadNPCTrade 20
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_39
_cv_next_47:
	CompareVarToValue 0x8005, 12
	GoToIfNe _cv_next_48
	LoadNPCTrade 21
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_39
_cv_next_48:
_cv_done_39:
	LockAll
	FacePlayer
	Return
	
CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_GiveRevivedMon:
	CopyVar 0x8005, 0x5041
	SetVar 0x8004, 0
	CompareVarToValue 0x8005, ITEM_HELIX_FOSSIL
	GoToIfNe _cv_next_50
	SetVar 0x8004, SPECIES_OMANYTE
	GoTo _cv_done_49
_cv_next_50:
	CompareVarToValue 0x8005, ITEM_DOME_FOSSIL
	GoToIfNe _cv_next_51
	SetVar 0x8004, SPECIES_KABUTO
	GoTo _cv_done_49
_cv_next_51:
	CompareVarToValue 0x8005, ITEM_OLD_AMBER
	GoToIfNe _cv_next_52
	SetVar 0x8004, SPECIES_AERODACTYL
	GoTo _cv_done_49
_cv_next_52:
	CompareVarToValue 0x8005, ITEM_ROOT_FOSSIL
	GoToIfNe _cv_next_53
	SetVar 0x8004, SPECIES_LILEEP
	GoTo _cv_done_49
_cv_next_53:
	CompareVarToValue 0x8005, ITEM_CLAW_FOSSIL
	GoToIfNe _cv_next_54
	SetVar 0x8004, SPECIES_ANORITH
	GoTo _cv_done_49
_cv_next_54:
	CompareVarToValue 0x8005, ITEM_SKULL_FOSSIL
	GoToIfNe _cv_next_55
	SetVar 0x8004, SPECIES_CRANIDOS
	GoTo _cv_done_49
_cv_next_55:
	CompareVarToValue 0x8005, ITEM_ARMOR_FOSSIL
	GoToIfNe _cv_next_56
	SetVar 0x8004, SPECIES_SHIELDON
	GoTo _cv_done_49
_cv_next_56:
	CompareVarToValue 0x8005, 1
	GoToIfNe _cv_next_57
	SetVar 0x8004, SPECIES_OMANYTE
	GoTo _cv_done_49
_cv_next_57:
	CompareVarToValue 0x8005, 2
	GoToIfNe _cv_next_58
	SetVar 0x8004, SPECIES_KABUTO
	GoTo _cv_done_49
_cv_next_58:
	CompareVarToValue 0x8005, 3
	GoToIfNe _cv_next_59
	SetVar 0x8004, SPECIES_AERODACTYL
	GoTo _cv_done_49
_cv_next_59:
_cv_done_49:
	BufferSpeciesName 0, 0x8004, 0, 0
	CopyVar 0x4001, 0x8004
	NPCMsg msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_CinnabarIsland_PokemonLab_ExperimentRoom_Text_FossilMonBackToLife
	WaitButton
	GiveMon 0x8004, 5, 0, 0, 0, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq Common_EventScript_NoMoreRoomForPokemon
	CompareVarToValue 0x8004, SPECIES_OMANYTE
	CallIfEq CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_SetRevivedHelix
	CompareVarToValue 0x8004, SPECIES_KABUTO
	CallIfEq CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_SetRevivedDome
	CompareVarToValue 0x8004, SPECIES_AERODACTYL
	CallIfEq CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_SetRevivedAmber
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_NicknameMonParty
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_NicknameMonPC
	CloseMsg
	End
	
CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_FossilStillReviving:
	NPCMsg msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_CinnabarIsland_PokemonLab_ExperimentRoom_Text_TakesTimeGoForWalk
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_NoFossil:
	NPCMsg msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_CinnabarIsland_PokemonLab_ExperimentRoom_Text_HaveYouAFossilForMe
	WaitButton
	GoTo CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_DontShowFossil
	CloseMsg
	End
	
CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_DontShowFossil:
	NPCMsg msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_CinnabarIsland_PokemonLab_ExperimentRoom_Text_NoIsTooBad
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_DeclineReviveFossil:
	NPCMsg msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_CinnabarIsland_PokemonLab_ExperimentRoom_Text_YouComeAgain
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PaintWorld_EventScript_FigureSketch:
	NPCMsg msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_PaintWorld_Text_FigureSketch
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
PaintWorld_EventScript_FigureMega:
	NPCMsg msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_PaintWorld_Text_FigureMega
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
PaintWorld_EventScript_FigureBattle:
	CanvasCloseMsg
	// TODO(gba) special Painter_SetupFigure
	GoTo _cv_stop
	ClearTrainerFlag 1442
	SetFlag 0x2036
	CanvasCloseMsg
	TrainerBattle 1442, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_61
	WhiteOut
	End
_cv_won_61:
	SetTrainerFlag 1442
	ClearFlag 0x2036
	GetStaticEncounterOutcome VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfNe _cv_outcome_62
	SetVar VAR_SPECIAL_RESULT, 7
	GoTo _cv_outcome_63
_cv_outcome_62:
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfNe _cv_outcome_63
	SetVar VAR_SPECIAL_RESULT, 4
_cv_outcome_63:
	// TODO(gba) special Painter_RecordBattle
	GoTo _cv_stop
	NPCMsg msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_PaintWorld_Text_Dissolve
	WaitButton
	CanvasCloseMsg
	FadeScreen 6, 1, 0, RGB_WHITE
	WaitFade
	Warp MAP_CANVAS_PEWTER_PAINTER_LOFT, 0, 8, 4, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	CanvasCloseMsg
	ReleaseAll
	End
	
Common_EventScript_NoMoreRoomForPokemon:
	NPCMsg msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_gText_NoMoreRoomForPokemon
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_SetRevivedHelix:
	SetFlag 0x21FB
	Return
	
CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_SetRevivedDome:
	SetFlag 0x21FC
	Return
	
CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_SetRevivedAmber:
	SetFlag 0x21FD
	Return
	
CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_NicknameMonParty:
	PlayFanfare SEQ_ME_LVUP
	BufferPlayersName 6
	NPCMsg msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_CinnabarIsland_PokemonLab_ExperimentRoom_Text_ReceivedMonFromDoctor
	WaitFanfare
	SetVar 0x5040, 0
	NPCMsg msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_gText_NicknameThisPokemon
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_64
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_65
_cv_yes_64:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_65:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_EndGiveMon
	Call Common_EventScript_GetGiftMonPartySlot
	Call Common_EventScript_NameReceivedPartyMon
	GoTo CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_EndGiveMon
	CloseMsg
	End
	
CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_NicknameMonPC:
	PlayFanfare SEQ_ME_LVUP
	BufferPlayersName 6
	NPCMsg msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_CinnabarIsland_PokemonLab_ExperimentRoom_Text_ReceivedMonFromDoctor
	WaitFanfare
	SetVar 0x5040, 0
	NPCMsg msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_gText_NicknameThisPokemon
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_66
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_67
_cv_yes_66:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_67:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_MonSentToPC
	Call Common_EventScript_NameReceivedBoxMon
	GoTo CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_MonSentToPC
	CloseMsg
	End
	
CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_EndGiveMon:
	CanvasCloseMsg
	ReleaseAll
	End
	
Common_EventScript_GetGiftMonPartySlot:
	GetPartyCount VAR_SPECIAL_RESULT
	SubVar VAR_SPECIAL_RESULT, 1
	CopyVar 0x8004, VAR_SPECIAL_RESULT
	Return
	
Common_EventScript_NameReceivedPartyMon:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	NicknameInput 0x8004, VAR_SPECIAL_RESULT
	Return
	
CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_MonSentToPC:
	Call Common_EventScript_TransferredToPC
	GoTo CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_EndGiveMon
	End
	
Common_EventScript_NameReceivedBoxMon:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	SetVar 0x8004, 254
	NicknameInput 0x8004, VAR_SPECIAL_RESULT
	LockAll
	FacePlayer
	Return
	
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
	NPCMsg msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_gText_PkmnTransferredSomeonesPC
	WaitButton
	Return
	
EventScript_TransferredLanettesPC:
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq EventScript_LanettesPCBoxFull
	NPCMsg msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_gText_PkmnTransferredLanettesPC
	WaitButton
	Return
	
EventScript_SomeonesPCBoxFull:
	SetVar VAR_SPECIAL_RESULT, 0
	// (a box name: HeartGold sends a Pokemon to the first box with room)
	NPCMsg msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_gText_PkmnTransferredSomeonesPCBoxFull
	WaitButton
	Return
	
EventScript_LanettesPCBoxFull:
	SetVar VAR_SPECIAL_RESULT, 0
	// (a box name: HeartGold sends a Pokemon to the first box with room)
	NPCMsg msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_gText_PkmnTransferredLanettesPCBoxFull
	WaitButton
	Return

_cv_stop:
	NPCMsg msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
