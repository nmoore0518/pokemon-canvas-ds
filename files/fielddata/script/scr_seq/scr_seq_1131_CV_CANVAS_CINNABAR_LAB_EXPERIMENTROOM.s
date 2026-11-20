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
	// TODO(gba) special Fossil_PushList
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_NoFossil
	NPCMsg msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_CinnabarIsland_PokemonLab_ExperimentRoom_Text_HaveYouAFossilForMe
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_4
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_DontShowFossil
	// TODO(gba) special Fossil_Pick
	GoTo _cv_stop
	NPCMsg msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_CinnabarIsland_PokemonLab_ExperimentRoom_Text_ThatFossilIsOfMonMakeItLiveAgain
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_5
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_6
_cv_yes_5:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_6:
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
	GoToIfNe _cv_next_8
	LoadNPCTrade 13
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_7
_cv_next_8:
	CompareVarToValue 0x8005, 5
	GoToIfNe _cv_next_9
	LoadNPCTrade 14
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_7
_cv_next_9:
	CompareVarToValue 0x8005, 6
	GoToIfNe _cv_next_10
	LoadNPCTrade 15
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_7
_cv_next_10:
	CompareVarToValue 0x8005, 7
	GoToIfNe _cv_next_11
	LoadNPCTrade 16
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_7
_cv_next_11:
	CompareVarToValue 0x8005, 8
	GoToIfNe _cv_next_12
	LoadNPCTrade 17
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_7
_cv_next_12:
	CompareVarToValue 0x8005, 9
	GoToIfNe _cv_next_13
	LoadNPCTrade 18
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_7
_cv_next_13:
	CompareVarToValue 0x8005, 10
	GoToIfNe _cv_next_14
	LoadNPCTrade 19
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_7
_cv_next_14:
	CompareVarToValue 0x8005, 11
	GoToIfNe _cv_next_15
	LoadNPCTrade 20
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_7
_cv_next_15:
	CompareVarToValue 0x8005, 12
	GoToIfNe _cv_next_16
	LoadNPCTrade 21
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_7
_cv_next_16:
_cv_done_7:
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
	GoToIfNe _cv_next_18
	LoadNPCTrade 13
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_17
_cv_next_18:
	CompareVarToValue 0x8005, 5
	GoToIfNe _cv_next_19
	LoadNPCTrade 14
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_17
_cv_next_19:
	CompareVarToValue 0x8005, 6
	GoToIfNe _cv_next_20
	LoadNPCTrade 15
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_17
_cv_next_20:
	CompareVarToValue 0x8005, 7
	GoToIfNe _cv_next_21
	LoadNPCTrade 16
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_17
_cv_next_21:
	CompareVarToValue 0x8005, 8
	GoToIfNe _cv_next_22
	LoadNPCTrade 17
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_17
_cv_next_22:
	CompareVarToValue 0x8005, 9
	GoToIfNe _cv_next_23
	LoadNPCTrade 18
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_17
_cv_next_23:
	CompareVarToValue 0x8005, 10
	GoToIfNe _cv_next_24
	LoadNPCTrade 19
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_17
_cv_next_24:
	CompareVarToValue 0x8005, 11
	GoToIfNe _cv_next_25
	LoadNPCTrade 20
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_17
_cv_next_25:
	CompareVarToValue 0x8005, 12
	GoToIfNe _cv_next_26
	LoadNPCTrade 21
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_17
_cv_next_26:
_cv_done_17:
	LockAll
	FacePlayer
	Return
	
CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_GiveRevivedMon:
	CopyVar 0x8005, 0x5041
	// TODO(gba) special Fossil_BufferRevived
	GoTo _cv_stop
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
	End
	
PaintWorld_EventScript_FigureBattle:
	CloseMsg
	// TODO(gba) special Painter_SetupFigure
	GoTo _cv_stop
	ClearTrainerFlag 1442
	SetFlag 0x2036
	CheckTrainerFlag 1442
	GoToIf TRUE, _cv_beaten_27
	TrainerBattle 1442, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_28
	WhiteOut
	End
_cv_won_28:
	SetTrainerFlag 1442
	ReleaseAll
	End
_cv_beaten_27:
	ClearFlag 0x2036
	GetStaticEncounterOutcome VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfNe _cv_outcome_29
	SetVar VAR_SPECIAL_RESULT, 7
	GoTo _cv_outcome_30
_cv_outcome_29:
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfNe _cv_outcome_30
	SetVar VAR_SPECIAL_RESULT, 4
_cv_outcome_30:
	// TODO(gba) special Painter_RecordBattle
	GoTo _cv_stop
	NPCMsg msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_PaintWorld_Text_Dissolve
	WaitButton
	CloseMsg
	FadeScreen 6, 1, 0, RGB_WHITE
	WaitFade
	Warp MAP_CANVAS_PEWTER_PAINTER_LOFT, 0, 8, 4, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
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
	GoToIfEq _cv_yes_31
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_32
_cv_yes_31:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_32:
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
	GoToIfEq _cv_yes_33
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_34
_cv_yes_33:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_34:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_MonSentToPC
	Call Common_EventScript_NameReceivedBoxMon
	GoTo CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_MonSentToPC
	CloseMsg
	End
	
CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_EndGiveMon:
	ReleaseAll
	End
	
Common_EventScript_GetGiftMonPartySlot:
	// TODO(gba) getpartysize 
	GoTo _cv_stop
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
	SetVar 0x8004, 0
	NicknameInput 0x8004, VAR_SPECIAL_RESULT
	LockAll
	FacePlayer
	Return
	
Common_EventScript_TransferredToPC:
	// TODO(gba) bufferboxname STR_VAR_1, VAR_PC_BOX_TO_SEND_MON
	GoTo _cv_stop
	BufferSpeciesName 1, 0x5024, 0, 0
	CallIfUnset 0x20D0, EventScript_TransferredSomeonesPC
	CallIfSet 0x20D0, EventScript_TransferredLanettesPC
	Return
	
EventScript_TransferredSomeonesPC:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar ShouldShowBoxWasFullMessage
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq EventScript_SomeonesPCBoxFull
	NPCMsg msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_gText_PkmnTransferredSomeonesPC
	WaitButton
	Return
	
EventScript_TransferredLanettesPC:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar ShouldShowBoxWasFullMessage
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq EventScript_LanettesPCBoxFull
	NPCMsg msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_gText_PkmnTransferredLanettesPC
	WaitButton
	Return
	
EventScript_SomeonesPCBoxFull:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar GetPCBoxToSendMon
	GoTo _cv_stop
	// TODO(gba) bufferboxname STR_VAR_3, VAR_RESULT
	GoTo _cv_stop
	NPCMsg msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_gText_PkmnTransferredSomeonesPCBoxFull
	WaitButton
	Return
	
EventScript_LanettesPCBoxFull:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar GetPCBoxToSendMon
	GoTo _cv_stop
	// TODO(gba) bufferboxname STR_VAR_3, VAR_RESULT
	GoTo _cv_stop
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
