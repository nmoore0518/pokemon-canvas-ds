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
	SetVar 0x8009, 0  // TODO(gba) specialvar GetInGameTradeSpeciesInfo
	GoTo _cv_stop
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
	// TODO(gba) special ChoosePartyMon
	GoTo _cv_stop
	LockAll
	FacePlayer
	Return
	
EventScript_GetInGameTradeSpecies:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar GetTradeSpecies
	GoTo _cv_stop
	Return
	
CinnabarIsland_PokemonLab_ExperimentRoom_EventScript_NotRequestedMon:
	BufferSpeciesName 0, 0x8009, 0, 0
	NPCMsg msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_Trade_Text_WhatThatsNoMon
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_DoInGameTrade:
	// TODO(gba) special CreateInGameTradePokemon
	GoTo _cv_stop
	// TODO(gba) special DoInGameTradeScene
	GoTo _cv_stop
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
	GoToIf TRUE, _cv_beaten_7
	TrainerBattle 1442, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_8
	WhiteOut
	End
_cv_won_8:
	SetTrainerFlag 1442
	ReleaseAll
	End
_cv_beaten_7:
	ClearFlag 0x2036
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq _cv_won_9
	SetVar VAR_SPECIAL_RESULT, 2
_cv_won_9:
	// TODO(gba) special Painter_RecordBattle
	GoTo _cv_stop
	NPCMsg msg_0937_CV_CANVAS_CINNABAR_LAB_EXPERIMENTROOM_PaintWorld_Text_Dissolve
	WaitButton
	CloseMsg
	FadeScreen 6, 1, 0, RGB_WHITE
	WaitFade
	// TODO(gba) warpsilent MAP_PEWTER_CITY_PAINTER_LOFT, 8, 4
	GoTo _cv_stop
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
	GoToIfEq _cv_yes_10
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_11
_cv_yes_10:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_11:
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
	GoToIfEq _cv_yes_12
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_13
_cv_yes_12:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_13:
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
