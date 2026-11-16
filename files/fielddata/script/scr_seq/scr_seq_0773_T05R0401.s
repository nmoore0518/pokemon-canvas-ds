#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T05R0401.h"
#include "msgdata/msg/msg_0480_T05R0401.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's LavenderTown_House2_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef LavenderTown_House2_EventScript_NameRater
	ScrDef TrainingHouse_EventScript_Winston
	ScrDef TrainingHouse_EventScript_Edith
	ScrDef PaintWorld_EventScript_Figure
	ScrDefEnd
	
LavenderTown_House2_EventScript_NameRater:
	LockAll
	FacePlayer
	GoToIfUnset 0x212B, LavenderTown_House2_EventScript_Tip
	NPCMsg msg_0480_T05R0401_LavenderTown_House2_Text_WantMeToRateNicknames
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	End
	
TrainingHouse_EventScript_Winston:
	LockAll
	FacePlayer
	NPCMsg msg_0480_T05R0401_TrainingHouse_Text_WinstonIntro
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_3
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_4
_cv_yes_3:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TrainingHouse_EventScript_Declined
	ClearTrainerFlag 1451
	CheckTrainerFlag 1451
	GoToIf TRUE, _cv_beaten_5
	TrainerBattle 1451, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_6
	WhiteOut
	End
_cv_won_6:
	SetTrainerFlag 1451
	ReleaseAll
	End
_cv_beaten_5:
	NPCMsg msg_0480_T05R0401_TrainingHouse_Text_After
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TrainingHouse_EventScript_Edith:
	LockAll
	FacePlayer
	NPCMsg msg_0480_T05R0401_TrainingHouse_Text_EdithIntro
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_7
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_8
_cv_yes_7:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_8:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TrainingHouse_EventScript_Declined
	ClearTrainerFlag 1452
	CheckTrainerFlag 1452
	GoToIf TRUE, _cv_beaten_9
	TrainerBattle 1452, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_10
	WhiteOut
	End
_cv_won_10:
	SetTrainerFlag 1452
	ReleaseAll
	End
_cv_beaten_9:
	NPCMsg msg_0480_T05R0401_TrainingHouse_Text_After
	WaitButton
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
	NPCMsg msg_0480_T05R0401_PaintWorld_Text_FigureFirst
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
LavenderTown_House2_EventScript_Tip:
	NPCMsg msg_0480_T05R0401_LavenderTown_House2_Text_Tip
	WaitButton
	SetFlag 0x212B
	NPCMsg msg_0480_T05R0401_LavenderTown_House2_Text_StillWantRating
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_11
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_12
_cv_yes_11:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_12:
	GoTo LavenderTown_House2_EventScript_Answer
	
TrainingHouse_EventScript_Declined:
	NPCMsg msg_0480_T05R0401_TrainingHouse_Text_Declined
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PaintWorld_EventScript_FigureSketch:
	NPCMsg msg_0480_T05R0401_PaintWorld_Text_FigureSketch
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
PaintWorld_EventScript_FigureMega:
	NPCMsg msg_0480_T05R0401_PaintWorld_Text_FigureMega
	WaitButton
	End
	
PaintWorld_EventScript_FigureBattle:
	CloseMsg
	// TODO(gba) special Painter_SetupFigure
	GoTo _cv_stop
	ClearTrainerFlag 1442
	SetFlag 0x2036
	CheckTrainerFlag 1442
	GoToIf TRUE, _cv_beaten_13
	TrainerBattle 1442, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_14
	WhiteOut
	End
_cv_won_14:
	SetTrainerFlag 1442
	ReleaseAll
	End
_cv_beaten_13:
	ClearFlag 0x2036
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq _cv_won_15
	SetVar VAR_SPECIAL_RESULT, 2
_cv_won_15:
	// TODO(gba) special Painter_RecordBattle
	GoTo _cv_stop
	NPCMsg msg_0480_T05R0401_PaintWorld_Text_Dissolve
	WaitButton
	CloseMsg
	FadeScreen 6, 1, 0, RGB_WHITE
	WaitFade
	// TODO(gba) warpsilent MAP_PEWTER_CITY_PAINTER_LOFT, 8, 4
	GoTo _cv_stop
	ReleaseAll
	End
	
LavenderTown_House2_EventScript_Answer:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq LavenderTown_House2_EventScript_ChooseMon
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq LavenderTown_House2_EventScript_DontRateNickname
	End
	
LavenderTown_House2_EventScript_ChooseMon:
	NPCMsg msg_0480_T05R0401_LavenderTown_House2_Text_CritiqueWhichMonsNickname
	WaitButton
	// TODO(gba) special ChoosePartyMon
	GoTo _cv_stop
	CompareVarToValue 0x8004, 6
	GoToIfLt LavenderTown_House2_EventScript_CheckCanRateMon
	CompareVarToValue 0x8004, 6
	GoToIfGe LavenderTown_House2_EventScript_DontRateNickname
	CloseMsg
	End
	
LavenderTown_House2_EventScript_DontRateNickname:
	NPCMsg msg_0480_T05R0401_LavenderTown_House2_Text_ISeeComeVisitAgain
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
LavenderTown_House2_EventScript_CheckCanRateMon:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar ScriptGetPartyMonSpecies
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, SPECIES_EGG
	GoToIfEq LavenderTown_House2_EventScript_CantNicknameEgg
	// TODO(gba) special BufferMonNickname
	GoTo _cv_stop
	// TODO(gba) special IsMonOTIDNotPlayers
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq LavenderTown_House2_EventScript_CantNicknameTradeMon
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar MonOTNameNotPlayer
	GoTo _cv_stop
	// TODO(gba) special BufferMonNickname
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq LavenderTown_House2_EventScript_CantNicknameTradeMon
	NPCMsg msg_0480_T05R0401_LavenderTown_House2_Text_GiveItANicerName
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_16
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_17
_cv_yes_16:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_17:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq LavenderTown_House2_EventScript_ChooseNewNickname
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq LavenderTown_House2_EventScript_DontRateNickname
	CloseMsg
	End
	
LavenderTown_House2_EventScript_CantNicknameEgg:
	NPCMsg msg_0480_T05R0401_LavenderTown_House2_Text_ThatIsMerelyAnEgg
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
LavenderTown_House2_EventScript_CantNicknameTradeMon:
	NPCMsg msg_0480_T05R0401_LavenderTown_House2_Text_TrulyImpeccableName
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
LavenderTown_House2_EventScript_ChooseNewNickname:
	NPCMsg msg_0480_T05R0401_LavenderTown_House2_Text_WhatShallNewNicknameBe
	WaitButton
	Call Common_EventScript_NameReceivedPartyMon
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar TryPutNameRaterShowOnTheAir
	GoTo _cv_stop
	// TODO(gba) special BufferMonNickname
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq LavenderTown_House2_EventScript_ChoseNewNickname
	NPCMsg msg_0480_T05R0401_LavenderTown_House2_Text_FromNowOnShallBeKnownAsSameName
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Common_EventScript_NameReceivedPartyMon:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	NicknameInput 0x8004, VAR_SPECIAL_RESULT
	Return
	
LavenderTown_House2_EventScript_ChoseNewNickname:
	NPCMsg msg_0480_T05R0401_LavenderTown_House2_Text_FromNowOnShallBeKnownAsName
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0480_T05R0401_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
