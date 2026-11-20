#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_FIGHT_AREA_UNUSED_4.h"
#include "msgdata/msg/msg_0952_CV_FIGHT_AREA_UNUSED_4.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PalletTown_TrainingHall_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef TrainingHouse_EventScript_Harold
	ScrDef TrainingHouse_EventScript_Penelope
	ScrDef TrainingHouse_EventScript_Isabella
	ScrDef TrainingHouse_EventScript_Reginald
	ScrDef TrainingHouse_EventScript_Arabella
	ScrDef TrainingHouse_EventScript_Matilda
	ScrDef TrainingHouse_EventScript_HallAttendant
	ScrDef TrainingHouse_EventScript_HallStatue
	ScrDef TrainingHouse_EventScript_HallScrollLeft
	ScrDef TrainingHouse_EventScript_HallScrollRight
	ScrDefEnd
	
TrainingHouse_EventScript_Harold:
	LockAll
	FacePlayer
	NPCMsg msg_0952_CV_FIGHT_AREA_UNUSED_4_TrainingHouse_Text_HaroldIntro
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
	ClearTrainerFlag 1461
	CanvasCloseMsg
	TrainerBattle 1461, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_4
	WhiteOut
	End
_cv_won_4:
	SetTrainerFlag 1461
	NPCMsg msg_0952_CV_FIGHT_AREA_UNUSED_4_TrainingHouse_Text_After
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TrainingHouse_EventScript_Penelope:
	LockAll
	FacePlayer
	NPCMsg msg_0952_CV_FIGHT_AREA_UNUSED_4_TrainingHouse_Text_PenelopeIntro
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
	ClearTrainerFlag 1462
	CanvasCloseMsg
	TrainerBattle 1462, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_8
	WhiteOut
	End
_cv_won_8:
	SetTrainerFlag 1462
	NPCMsg msg_0952_CV_FIGHT_AREA_UNUSED_4_TrainingHouse_Text_After
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TrainingHouse_EventScript_Isabella:
	LockAll
	FacePlayer
	NPCMsg msg_0952_CV_FIGHT_AREA_UNUSED_4_TrainingHouse_Text_IsabellaIntro
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
	ClearTrainerFlag 1463
	CanvasCloseMsg
	TrainerBattle 1463, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_12
	WhiteOut
	End
_cv_won_12:
	SetTrainerFlag 1463
	NPCMsg msg_0952_CV_FIGHT_AREA_UNUSED_4_TrainingHouse_Text_After
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TrainingHouse_EventScript_Reginald:
	LockAll
	FacePlayer
	NPCMsg msg_0952_CV_FIGHT_AREA_UNUSED_4_TrainingHouse_Text_ReginaldIntro
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_13
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_14
_cv_yes_13:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_14:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TrainingHouse_EventScript_Declined
	ClearTrainerFlag 1464
	CanvasCloseMsg
	TrainerBattle 1464, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_16
	WhiteOut
	End
_cv_won_16:
	SetTrainerFlag 1464
	NPCMsg msg_0952_CV_FIGHT_AREA_UNUSED_4_TrainingHouse_Text_After
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TrainingHouse_EventScript_Arabella:
	LockAll
	FacePlayer
	NPCMsg msg_0952_CV_FIGHT_AREA_UNUSED_4_TrainingHouse_Text_ArabellaIntro
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_17
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_18
_cv_yes_17:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_18:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TrainingHouse_EventScript_Declined
	ClearTrainerFlag 1465
	CanvasCloseMsg
	TrainerBattle 1465, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_20
	WhiteOut
	End
_cv_won_20:
	SetTrainerFlag 1465
	NPCMsg msg_0952_CV_FIGHT_AREA_UNUSED_4_TrainingHouse_Text_After
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TrainingHouse_EventScript_Matilda:
	LockAll
	FacePlayer
	NPCMsg msg_0952_CV_FIGHT_AREA_UNUSED_4_TrainingHouse_Text_MatildaIntro
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_21
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_22
_cv_yes_21:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_22:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TrainingHouse_EventScript_Declined
	ClearTrainerFlag 1466
	CanvasCloseMsg
	TrainerBattle 1466, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_24
	WhiteOut
	End
_cv_won_24:
	SetTrainerFlag 1466
	NPCMsg msg_0952_CV_FIGHT_AREA_UNUSED_4_TrainingHouse_Text_After
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TrainingHouse_EventScript_HallAttendant:
	LockAll
	FacePlayer
	NPCMsg msg_0952_CV_FIGHT_AREA_UNUSED_4_TrainingHouse_Text_RestTeam
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_25
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_26
_cv_yes_25:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_26:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TrainingHouse_EventScript_AttendantBye
	CloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	PlayFanfare SEQ_ME_ITEM
	HealParty
	WaitFanfare
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	NPCMsg msg_0952_CV_FIGHT_AREA_UNUSED_4_TrainingHouse_Text_TeamRested
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TrainingHouse_EventScript_HallStatue:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0952_CV_FIGHT_AREA_UNUSED_4_TrainingHouse_Text_HallStatue
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TrainingHouse_EventScript_HallScrollLeft:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0952_CV_FIGHT_AREA_UNUSED_4_TrainingHouse_Text_HallScrollLeft
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TrainingHouse_EventScript_HallScrollRight:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0952_CV_FIGHT_AREA_UNUSED_4_TrainingHouse_Text_HallScrollRight
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TrainingHouse_EventScript_Declined:
	NPCMsg msg_0952_CV_FIGHT_AREA_UNUSED_4_TrainingHouse_Text_Declined
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TrainingHouse_EventScript_AttendantBye:
	NPCMsg msg_0952_CV_FIGHT_AREA_UNUSED_4_TrainingHouse_Text_AttendantBye
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0952_CV_FIGHT_AREA_UNUSED_4_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
