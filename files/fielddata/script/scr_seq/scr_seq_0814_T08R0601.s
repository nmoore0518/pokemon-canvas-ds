#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T08R0601.h"
#include "msgdata/msg/msg_0518_T08R0601.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's FuchsiaCity_WardensHouse_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef FuchsiaCity_WardensHouse_EventScript_Warden
	ScrDef FuchsiaCity_WardensHouse_EventScript_ItemRareCandy
	ScrDef PaintWorld_EventScript_Figure
	ScrDef FuchsiaCity_WardensHouse_EventScript_DisplaySign2
	ScrDef FuchsiaCity_WardensHouse_EventScript_DisplaySign1
	ScrDef FuchsiaCity_WardensHouse_EventScript_PokemonJournalKoga
	ScrDefEnd
	
FuchsiaCity_WardensHouse_EventScript_Warden:
	LockAll
	FacePlayer
	GoToIfSet 0x214A, FuchsiaCity_WardensHouse_EventScript_ExplainStrength
	GoToIfSet 0x214B, FuchsiaCity_WardensHouse_EventScript_GiveGoldTeeth
	NPCMsg msg_0518_T08R0601_FuchsiaCity_WardensHouse_Text_HifFuffHefifoo
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq FuchsiaCity_WardensHouse_EventScript_WardenYes
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	CallIfEq FuchsiaCity_WardensHouse_EventScript_WardenNo
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_WardensHouse_EventScript_ItemRareCandy:
	SetVar 0x8004, ITEM_RARE_CANDY
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
PaintWorld_EventScript_Figure:
	LockAll
	FacePlayer
	CompareVarToValue 0x5020, 2
	GoToIfEq PaintWorld_EventScript_FigureSketch
	CompareVarToValue 0x5020, 3
	GoToIfEq PaintWorld_EventScript_FigureMega
	NPCMsg msg_0518_T08R0601_PaintWorld_Text_FigureFirst
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
FuchsiaCity_WardensHouse_EventScript_DisplaySign2:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0518_T08R0601_FuchsiaCity_WardensHouse_Text_OldMonMerchandiseOnDisplay
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_WardensHouse_EventScript_DisplaySign1:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0518_T08R0601_FuchsiaCity_WardensHouse_Text_MonPhotosFossilsOnDisplay
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_WardensHouse_EventScript_PokemonJournalKoga:
	LockAll
	FacePlayer
	NPCMsg msg_0518_T08R0601_PokemonJournal_Text_SpecialFeatureKoga
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_WardensHouse_EventScript_ExplainStrength:
	NPCMsg msg_0518_T08R0601_FuchsiaCity_WardensHouse_Text_ExplainStrength
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_WardensHouse_EventScript_GiveGoldTeeth:
	PlayFanfare SEQ_ME_WAZA
	BufferPlayersName 6
	NPCMsg msg_0518_T08R0601_FuchsiaCity_WardensHouse_Text_GaveGoldTeethToWarden
	WaitFanfare
	NPCMsg msg_0518_T08R0601_FuchsiaCity_WardensHouse_Text_WardenPoppedInHisTeeth
	WaitButton
	Call EventScript_RestorePrevTextColor
	GetPlayerGender VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	CallIfEq FuchsiaCity_WardensHouse_EventScript_WardenThanksMale
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq FuchsiaCity_WardensHouse_EventScript_WardenThanksFemale
	GiveItem ITEM_HM04, 1, VAR_SPECIAL_RESULT
	BufferItemName 1, ITEM_HM04
	BufferPlayersName 6
	NPCMsg msg_0518_T08R0601_FuchsiaCity_WardensHouse_Text_ReceivedHM04FromWarden
	PlayFanfare SEQ_ME_LVUP
	WaitFanfare
	WaitButton
	NPCMsg msg_0518_T08R0601_Text_GymHack_AndTakeThisToo
	WaitButton
	SetFlag 0x214C
	SetVar VAR_SPECIAL_RESULT, 1
	SetFlag 0x214A
	TakeItem 877, 1, VAR_SPECIAL_RESULT
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_WardensHouse_EventScript_WardenYes:
	NPCMsg msg_0518_T08R0601_FuchsiaCity_WardensHouse_Text_AhHowheeHoHoo
	WaitButton
	Return
	
FuchsiaCity_WardensHouse_EventScript_WardenNo:
	NPCMsg msg_0518_T08R0601_FuchsiaCity_WardensHouse_Text_HeOhayHeHaHoo
	WaitButton
	Return
	
PaintWorld_EventScript_FigureSketch:
	NPCMsg msg_0518_T08R0601_PaintWorld_Text_FigureSketch
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
PaintWorld_EventScript_FigureMega:
	NPCMsg msg_0518_T08R0601_PaintWorld_Text_FigureMega
	WaitButton
	End
	
PaintWorld_EventScript_FigureBattle:
	CloseMsg
	// TODO(gba) special Painter_SetupFigure
	GoTo _cv_stop
	ClearTrainerFlag 1442
	SetFlag 0x2036
	CheckTrainerFlag 1442
	GoToIf TRUE, _cv_beaten_3
	TrainerBattle 1442, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_4
	WhiteOut
	End
_cv_won_4:
	SetTrainerFlag 1442
	ReleaseAll
	End
_cv_beaten_3:
	ClearFlag 0x2036
	GetStaticEncounterOutcome VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfNe _cv_outcome_5
	SetVar VAR_SPECIAL_RESULT, 7
	GoTo _cv_outcome_6
_cv_outcome_5:
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfNe _cv_outcome_6
	SetVar VAR_SPECIAL_RESULT, 4
_cv_outcome_6:
	// TODO(gba) special Painter_RecordBattle
	GoTo _cv_stop
	NPCMsg msg_0518_T08R0601_PaintWorld_Text_Dissolve
	WaitButton
	CloseMsg
	FadeScreen 6, 1, 0, RGB_WHITE
	WaitFade
	Warp MAP_CANVAS_PEWTER_PAINTER_LOFT, 0, 8, 4, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	ReleaseAll
	End
	
EventScript_RestorePrevTextColor:
	CopyVar 0x5015, 0x5016
	Return
	
FuchsiaCity_WardensHouse_EventScript_WardenThanksMale:
	NPCMsg msg_0518_T08R0601_FuchsiaCity_WardensHouse_Text_ThanksSonGiveYouSomething
	WaitButton
	Return
	
FuchsiaCity_WardensHouse_EventScript_WardenThanksFemale:
	NPCMsg msg_0518_T08R0601_FuchsiaCity_WardensHouse_Text_ThanksLassieGiveYouSomething
	WaitButton
	Return

_cv_stop:
	NPCMsg msg_0518_T08R0601_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
