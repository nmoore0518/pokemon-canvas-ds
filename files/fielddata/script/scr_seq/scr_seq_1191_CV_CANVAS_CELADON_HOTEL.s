#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_CELADON_HOTEL.h"
#include "msgdata/msg/msg_0967_CV_CANVAS_CELADON_HOTEL.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's CeladonCity_Hotel_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef CeladonCity_Hotel_EventScript_Receptionist
	ScrDef CeladonCity_Hotel_EventScript_Beauty
	ScrDef CeladonCity_Hotel_EventScript_BeautyBoyfriend
	ScrDef CeladonCity_Hotel_EventScript_BeautyBrother
	ScrDef TrainingHouse_EventScript_Rosalind
	ScrDef TrainingHouse_EventScript_Percival
	ScrDef PaintWorld_EventScript_Figure
	ScrDefEnd
	
CeladonCity_Hotel_EventScript_Receptionist:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0967_CV_CANVAS_CELADON_HOTEL_CeladonCity_Hotel_Text_ThisHotelIsForPeople
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_Hotel_EventScript_Beauty:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0967_CV_CANVAS_CELADON_HOTEL_CeladonCity_Hotel_Text_OnVacationWithBrotherAndBoyfriend
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_Hotel_EventScript_BeautyBoyfriend:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0967_CV_CANVAS_CELADON_HOTEL_CeladonCity_Hotel_Text_WhyDidSheBringBrother
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_Hotel_EventScript_BeautyBrother:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0967_CV_CANVAS_CELADON_HOTEL_CeladonCity_Hotel_Text_SisBroughtMeOnVacation
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TrainingHouse_EventScript_Rosalind:
	LockAll
	FacePlayer
	NPCMsg msg_0967_CV_CANVAS_CELADON_HOTEL_TrainingHouse_Text_RosalindIntro
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TrainingHouse_EventScript_Declined
	ClearTrainerFlag 1453
	CheckTrainerFlag 1453
	GoToIf TRUE, _cv_beaten_3
	TrainerBattle 1453, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_4
	WhiteOut
	End
_cv_won_4:
	SetTrainerFlag 1453
	ReleaseAll
	End
_cv_beaten_3:
	NPCMsg msg_0967_CV_CANVAS_CELADON_HOTEL_TrainingHouse_Text_After
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TrainingHouse_EventScript_Percival:
	LockAll
	FacePlayer
	NPCMsg msg_0967_CV_CANVAS_CELADON_HOTEL_TrainingHouse_Text_PercivalIntro
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
	ClearTrainerFlag 1454
	CheckTrainerFlag 1454
	GoToIf TRUE, _cv_beaten_7
	TrainerBattle 1454, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_8
	WhiteOut
	End
_cv_won_8:
	SetTrainerFlag 1454
	ReleaseAll
	End
_cv_beaten_7:
	NPCMsg msg_0967_CV_CANVAS_CELADON_HOTEL_TrainingHouse_Text_After
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
	NPCMsg msg_0967_CV_CANVAS_CELADON_HOTEL_PaintWorld_Text_FigureFirst
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
TrainingHouse_EventScript_Declined:
	NPCMsg msg_0967_CV_CANVAS_CELADON_HOTEL_TrainingHouse_Text_Declined
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PaintWorld_EventScript_FigureSketch:
	NPCMsg msg_0967_CV_CANVAS_CELADON_HOTEL_PaintWorld_Text_FigureSketch
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
PaintWorld_EventScript_FigureMega:
	NPCMsg msg_0967_CV_CANVAS_CELADON_HOTEL_PaintWorld_Text_FigureMega
	WaitButton
	End
	
PaintWorld_EventScript_FigureBattle:
	CloseMsg
	// TODO(gba) special Painter_SetupFigure
	GoTo _cv_stop
	ClearTrainerFlag 1442
	SetFlag 0x2036
	CheckTrainerFlag 1442
	GoToIf TRUE, _cv_beaten_9
	TrainerBattle 1442, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_10
	WhiteOut
	End
_cv_won_10:
	SetTrainerFlag 1442
	ReleaseAll
	End
_cv_beaten_9:
	ClearFlag 0x2036
	GetStaticEncounterOutcome VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfNe _cv_outcome_11
	SetVar VAR_SPECIAL_RESULT, 7
	GoTo _cv_outcome_12
_cv_outcome_11:
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfNe _cv_outcome_12
	SetVar VAR_SPECIAL_RESULT, 4
_cv_outcome_12:
	// TODO(gba) special Painter_RecordBattle
	GoTo _cv_stop
	NPCMsg msg_0967_CV_CANVAS_CELADON_HOTEL_PaintWorld_Text_Dissolve
	WaitButton
	CloseMsg
	FadeScreen 6, 1, 0, RGB_WHITE
	WaitFade
	Warp MAP_CANVAS_PEWTER_PAINTER_LOFT, 0, 8, 4, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0967_CV_CANVAS_CELADON_HOTEL_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
