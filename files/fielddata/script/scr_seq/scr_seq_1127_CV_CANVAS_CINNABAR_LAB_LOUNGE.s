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
	CompareVarToValue 0x8005, 4
	GoToIfNe _cv_next_4
	LoadNPCTrade 13
	NPCTradeGetReqSpecies VAR_SPECIAL_RESULT
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, VAR_SPECIAL_RESULT, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_3
_cv_next_4:
	CompareVarToValue 0x8005, 5
	GoToIfNe _cv_next_5
	LoadNPCTrade 14
	NPCTradeGetReqSpecies VAR_SPECIAL_RESULT
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, VAR_SPECIAL_RESULT, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_3
_cv_next_5:
	CompareVarToValue 0x8005, 6
	GoToIfNe _cv_next_6
	LoadNPCTrade 15
	NPCTradeGetReqSpecies VAR_SPECIAL_RESULT
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, VAR_SPECIAL_RESULT, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_3
_cv_next_6:
	CompareVarToValue 0x8005, 7
	GoToIfNe _cv_next_7
	LoadNPCTrade 16
	NPCTradeGetReqSpecies VAR_SPECIAL_RESULT
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, VAR_SPECIAL_RESULT, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_3
_cv_next_7:
	CompareVarToValue 0x8005, 8
	GoToIfNe _cv_next_8
	LoadNPCTrade 17
	NPCTradeGetReqSpecies VAR_SPECIAL_RESULT
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, VAR_SPECIAL_RESULT, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_3
_cv_next_8:
	CompareVarToValue 0x8005, 9
	GoToIfNe _cv_next_9
	LoadNPCTrade 18
	NPCTradeGetReqSpecies VAR_SPECIAL_RESULT
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, VAR_SPECIAL_RESULT, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_3
_cv_next_9:
	CompareVarToValue 0x8005, 10
	GoToIfNe _cv_next_10
	LoadNPCTrade 19
	NPCTradeGetReqSpecies VAR_SPECIAL_RESULT
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, VAR_SPECIAL_RESULT, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_3
_cv_next_10:
	CompareVarToValue 0x8005, 11
	GoToIfNe _cv_next_11
	LoadNPCTrade 20
	NPCTradeGetReqSpecies VAR_SPECIAL_RESULT
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, VAR_SPECIAL_RESULT, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_3
_cv_next_11:
	CompareVarToValue 0x8005, 12
	GoToIfNe _cv_next_12
	LoadNPCTrade 21
	NPCTradeGetReqSpecies VAR_SPECIAL_RESULT
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, VAR_SPECIAL_RESULT, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_3
_cv_next_12:
_cv_done_3:
	CopyVar 0x8009, VAR_SPECIAL_RESULT
	GoToIfSet 0x21F9, CinnabarIsland_PokemonLab_Lounge_EventScript_NormaAlreadyTraded
	NPCMsg msg_0935_CV_CANVAS_CINNABAR_LAB_LOUNGE_Trade_Text_DoYouHaveMonWantToTradeForMon
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_13
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_14
_cv_yes_13:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_14:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CinnabarIsland_PokemonLab_Lounge_EventScript_NormaDeclineTrade
	CloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	ScrCmd_566
	GetPartySelection 0x8004
	RestoreOverworld
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	CopyVar 0x800A, 0x8004
	CompareVarToValue 0x8004, 6
	GoToIfGe CinnabarIsland_PokemonLab_Lounge_EventScript_NormaDeclineTrade
	CopyVar 0x8005, 0x800A
	GetPartyMonSpecies 0x8004, VAR_SPECIAL_RESULT
	CopyVar 0x800B, VAR_SPECIAL_RESULT
	CompareVarToVar VAR_SPECIAL_RESULT, 0x8009
	GoToIfNe CinnabarIsland_PokemonLab_Lounge_EventScript_NormaNotRequestedMon
	CopyVar 0x8004, 0x8008
	CopyVar 0x8005, 0x800A
	CompareVarToValue 0x8005, 4
	GoToIfNe _cv_next_16
	LoadNPCTrade 13
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_15
_cv_next_16:
	CompareVarToValue 0x8005, 5
	GoToIfNe _cv_next_17
	LoadNPCTrade 14
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_15
_cv_next_17:
	CompareVarToValue 0x8005, 6
	GoToIfNe _cv_next_18
	LoadNPCTrade 15
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_15
_cv_next_18:
	CompareVarToValue 0x8005, 7
	GoToIfNe _cv_next_19
	LoadNPCTrade 16
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_15
_cv_next_19:
	CompareVarToValue 0x8005, 8
	GoToIfNe _cv_next_20
	LoadNPCTrade 17
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_15
_cv_next_20:
	CompareVarToValue 0x8005, 9
	GoToIfNe _cv_next_21
	LoadNPCTrade 18
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_15
_cv_next_21:
	CompareVarToValue 0x8005, 10
	GoToIfNe _cv_next_22
	LoadNPCTrade 19
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_15
_cv_next_22:
	CompareVarToValue 0x8005, 11
	GoToIfNe _cv_next_23
	LoadNPCTrade 20
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_15
_cv_next_23:
	CompareVarToValue 0x8005, 12
	GoToIfNe _cv_next_24
	LoadNPCTrade 21
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_15
_cv_next_24:
_cv_done_15:
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
	GoToIfEq _cv_yes_25
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_26
_cv_yes_25:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_26:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TrainingHouse_EventScript_Declined
	ClearTrainerFlag 1459
	CanvasCloseMsg
	TrainerBattle 1459, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_28
	WhiteOut
	End
_cv_won_28:
	SetTrainerFlag 1459
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
	GoToIfEq _cv_yes_29
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_30
_cv_yes_29:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_30:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TrainingHouse_EventScript_Declined
	ClearTrainerFlag 1460
	CanvasCloseMsg
	TrainerBattle 1460, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_32
	WhiteOut
	End
_cv_won_32:
	SetTrainerFlag 1460
	NPCMsg msg_0935_CV_CANVAS_CINNABAR_LAB_LOUNGE_TrainingHouse_Text_After
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_GetInGameTradeSpeciesInfo:
	CopyVar 0x8005, 0x8008
	CompareVarToValue 0x8005, 4
	GoToIfNe _cv_next_34
	LoadNPCTrade 13
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_33
_cv_next_34:
	CompareVarToValue 0x8005, 5
	GoToIfNe _cv_next_35
	LoadNPCTrade 14
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_33
_cv_next_35:
	CompareVarToValue 0x8005, 6
	GoToIfNe _cv_next_36
	LoadNPCTrade 15
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_33
_cv_next_36:
	CompareVarToValue 0x8005, 7
	GoToIfNe _cv_next_37
	LoadNPCTrade 16
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_33
_cv_next_37:
	CompareVarToValue 0x8005, 8
	GoToIfNe _cv_next_38
	LoadNPCTrade 17
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_33
_cv_next_38:
	CompareVarToValue 0x8005, 9
	GoToIfNe _cv_next_39
	LoadNPCTrade 18
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_33
_cv_next_39:
	CompareVarToValue 0x8005, 10
	GoToIfNe _cv_next_40
	LoadNPCTrade 19
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_33
_cv_next_40:
	CompareVarToValue 0x8005, 11
	GoToIfNe _cv_next_41
	LoadNPCTrade 20
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_33
_cv_next_41:
	CompareVarToValue 0x8005, 12
	GoToIfNe _cv_next_42
	LoadNPCTrade 21
	NPCTradeGetReqSpecies 0x8009
	GetOfferedSpecies 0x8006
	NPCTradeEnd
	BufferSpeciesName 0, 0x8009, 0, 0
	BufferSpeciesName 1, 0x8006, 0, 0
	GoTo _cv_done_33
_cv_next_42:
_cv_done_33:
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
	
CinnabarIsland_PokemonLab_Lounge_EventScript_CliftonNotRequestedMon:
	BufferSpeciesName 0, 0x8009, 0, 0
	NPCMsg msg_0935_CV_CANVAS_CINNABAR_LAB_LOUNGE_Trade_Text_ThisIsntMon
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_DoInGameTrade:
	CompareVarToValue 0x8005, 4
	GoToIfNe _cv_next_44
	LoadNPCTrade 13
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_43
_cv_next_44:
	CompareVarToValue 0x8005, 5
	GoToIfNe _cv_next_45
	LoadNPCTrade 14
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_43
_cv_next_45:
	CompareVarToValue 0x8005, 6
	GoToIfNe _cv_next_46
	LoadNPCTrade 15
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_43
_cv_next_46:
	CompareVarToValue 0x8005, 7
	GoToIfNe _cv_next_47
	LoadNPCTrade 16
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_43
_cv_next_47:
	CompareVarToValue 0x8005, 8
	GoToIfNe _cv_next_48
	LoadNPCTrade 17
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_43
_cv_next_48:
	CompareVarToValue 0x8005, 9
	GoToIfNe _cv_next_49
	LoadNPCTrade 18
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_43
_cv_next_49:
	CompareVarToValue 0x8005, 10
	GoToIfNe _cv_next_50
	LoadNPCTrade 19
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_43
_cv_next_50:
	CompareVarToValue 0x8005, 11
	GoToIfNe _cv_next_51
	LoadNPCTrade 20
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_43
_cv_next_51:
	CompareVarToValue 0x8005, 12
	GoToIfNe _cv_next_52
	LoadNPCTrade 21
	NPCTradeExec 0x8004
	NPCTradeEnd
	GoTo _cv_done_43
_cv_next_52:
_cv_done_43:
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
