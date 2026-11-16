#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_CINNABAR_LAB_LOUNGE.h"
#include "msgdata/msg/msg_0935_CV_CANVAS_CINNABAR_LAB_LOUNGE.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's CinnabarIsland_PokemonLab_Lounge_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef CinnabarIsland_PokemonLab_Lounge_EventScript_Scientist
	ScrDef CinnabarIsland_PokemonLab_Lounge_EventScript_Clifton
	ScrDef CinnabarIsland_PokemonLab_Lounge_EventScript_Norma
	ScrDef TrainingHouse_EventScript_Beatrix
	ScrDef TrainingHouse_EventScript_Alistair
	ScrDefEnd
	
CinnabarIsland_PokemonLab_Lounge_EventScript_Scientist:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0935_CV_CANVAS_CINNABAR_LAB_LOUNGE_CinnabarIsland_PokemonLab_Lounge_Text_FoundFossilInMtMoon
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_PokemonLab_Lounge_EventScript_Clifton:
	LockAll
	FacePlayer
	SetVar 0x8008, 10
	Call EventScript_GetInGameTradeSpeciesInfo
	GoToIfSet 0x21F8, CinnabarIsland_PokemonLab_Lounge_EventScript_CliftonAlreadyTraded
	NPCMsg msg_0935_CV_CANVAS_CINNABAR_LAB_LOUNGE_Trade_Text_DoYouHaveMonWouldYouTradeForMon
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CinnabarIsland_PokemonLab_Lounge_EventScript_CliftonDeclineTrade
	Call EventScript_ChooseMonForInGameTrade
	CompareVarToValue 0x8004, 6
	GoToIfGe CinnabarIsland_PokemonLab_Lounge_EventScript_CliftonDeclineTrade
	Call EventScript_GetInGameTradeSpecies
	CompareVarToVar VAR_SPECIAL_RESULT, 0x8009
	GoToIfNe CinnabarIsland_PokemonLab_Lounge_EventScript_CliftonNotRequestedMon
	Call EventScript_DoInGameTrade
	NPCMsg msg_0935_CV_CANVAS_CINNABAR_LAB_LOUNGE_Trade_Text_Thanks
	WaitButton
	SetFlag 0x21F8
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_PokemonLab_Lounge_EventScript_Norma:
	LockAll
	FacePlayer
	SetVar 0x8008, 11
	CopyVar 0x8004, 0x8008
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar GetInGameTradeSpeciesInfo
	GoTo _cv_stop
	CopyVar 0x8009, VAR_SPECIAL_RESULT
	GoToIfSet 0x21F9, CinnabarIsland_PokemonLab_Lounge_EventScript_NormaAlreadyTraded
	NPCMsg msg_0935_CV_CANVAS_CINNABAR_LAB_LOUNGE_Trade_Text_DoYouHaveMonWantToTradeForMon
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_3
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_4
_cv_yes_3:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CinnabarIsland_PokemonLab_Lounge_EventScript_NormaDeclineTrade
	// TODO(gba) special ChoosePartyMon
	GoTo _cv_stop
	CopyVar 0x800A, 0x8004
	CompareVarToValue 0x8004, 6
	GoToIfGe CinnabarIsland_PokemonLab_Lounge_EventScript_NormaDeclineTrade
	CopyVar 0x8005, 0x800A
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar GetTradeSpecies
	GoTo _cv_stop
	CopyVar 0x800B, VAR_SPECIAL_RESULT
	CompareVarToVar VAR_SPECIAL_RESULT, 0x8009
	GoToIfNe CinnabarIsland_PokemonLab_Lounge_EventScript_NormaNotRequestedMon
	CopyVar 0x8004, 0x8008
	CopyVar 0x8005, 0x800A
	// TODO(gba) special CreateInGameTradePokemon
	GoTo _cv_stop
	// TODO(gba) special DoInGameTradeScene
	GoTo _cv_stop
	NPCMsg msg_0935_CV_CANVAS_CINNABAR_LAB_LOUNGE_Trade_Text_ThanksYoureAPal
	WaitButton
	SetFlag 0x21F9
	CloseMsg
	ReleaseAll
	End
	
TrainingHouse_EventScript_Beatrix:
	LockAll
	FacePlayer
	NPCMsg msg_0935_CV_CANVAS_CINNABAR_LAB_LOUNGE_TrainingHouse_Text_BeatrixIntro
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_5
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_6
_cv_yes_5:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_6:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TrainingHouse_EventScript_Declined
	ClearTrainerFlag 1459
	CheckTrainerFlag 1459
	GoToIf TRUE, _cv_beaten_7
	TrainerBattle 1459, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_8
	WhiteOut
	End
_cv_won_8:
	SetTrainerFlag 1459
	ReleaseAll
	End
_cv_beaten_7:
	NPCMsg msg_0935_CV_CANVAS_CINNABAR_LAB_LOUNGE_TrainingHouse_Text_After
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TrainingHouse_EventScript_Alistair:
	LockAll
	FacePlayer
	NPCMsg msg_0935_CV_CANVAS_CINNABAR_LAB_LOUNGE_TrainingHouse_Text_AlistairIntro
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_9
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_10
_cv_yes_9:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_10:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TrainingHouse_EventScript_Declined
	ClearTrainerFlag 1460
	CheckTrainerFlag 1460
	GoToIf TRUE, _cv_beaten_11
	TrainerBattle 1460, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_12
	WhiteOut
	End
_cv_won_12:
	SetTrainerFlag 1460
	ReleaseAll
	End
_cv_beaten_11:
	NPCMsg msg_0935_CV_CANVAS_CINNABAR_LAB_LOUNGE_TrainingHouse_Text_After
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_GetInGameTradeSpeciesInfo:
	CopyVar 0x8005, 0x8008
	SetVar 0x8009, 0  // TODO(gba) specialvar GetInGameTradeSpeciesInfo
	GoTo _cv_stop
	Return
	
CinnabarIsland_PokemonLab_Lounge_EventScript_CliftonAlreadyTraded:
	NPCMsg msg_0935_CV_CANVAS_CINNABAR_LAB_LOUNGE_Trade_Text_HasTradedMonGrownStronger
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_PokemonLab_Lounge_EventScript_CliftonDeclineTrade:
	NPCMsg msg_0935_CV_CANVAS_CINNABAR_LAB_LOUNGE_Trade_Text_WellIfYouDontWantTo
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
	
CinnabarIsland_PokemonLab_Lounge_EventScript_CliftonNotRequestedMon:
	BufferSpeciesName 0, 0x8009, 0, 0
	NPCMsg msg_0935_CV_CANVAS_CINNABAR_LAB_LOUNGE_Trade_Text_ThisIsntMon
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
	
CinnabarIsland_PokemonLab_Lounge_EventScript_NormaAlreadyTraded:
	NPCMsg msg_0935_CV_CANVAS_CINNABAR_LAB_LOUNGE_Trade_Text_HowIsMyOldMon
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_PokemonLab_Lounge_EventScript_NormaDeclineTrade:
	NPCMsg msg_0935_CV_CANVAS_CINNABAR_LAB_LOUNGE_Trade_Text_ThatsTooBad
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_PokemonLab_Lounge_EventScript_NormaNotRequestedMon:
	BufferSpeciesName 0, 0x8009, 0, 0
	NPCMsg msg_0935_CV_CANVAS_CINNABAR_LAB_LOUNGE_Trade_Text_ThisIsNoMon
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TrainingHouse_EventScript_Declined:
	NPCMsg msg_0935_CV_CANVAS_CINNABAR_LAB_LOUNGE_TrainingHouse_Text_Declined
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0935_CV_CANVAS_CINNABAR_LAB_LOUNGE_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
