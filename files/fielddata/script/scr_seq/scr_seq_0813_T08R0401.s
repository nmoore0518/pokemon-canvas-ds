#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T08R0401.h"
#include "msgdata/msg/msg_0517_T08R0401.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's FuchsiaCity_House1_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef FuchsiaCity_House1_EventScript_OldMan
	ScrDef FuchsiaCity_House1_EventScript_Woman
	ScrDef FuchsiaCity_House1_EventScript_LittleBoy
	ScrDef TrainingHouse_EventScript_Ophelia
	ScrDefEnd
	
FuchsiaCity_House1_EventScript_OldMan:
	LockAll
	FacePlayer
	NPCMsg msg_0517_T08R0401_FuchsiaCity_House1_Text_BillIsMyGrandson
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_House1_EventScript_Woman:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0517_T08R0401_FuchsiaCity_House1_Text_WardenIsOldHasFalseTeeth
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_House1_EventScript_LittleBoy:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0517_T08R0401_FuchsiaCity_House1_Text_BillFilesHisOwnMonData
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TrainingHouse_EventScript_Ophelia:
	LockAll
	FacePlayer
	NPCMsg msg_0517_T08R0401_TrainingHouse_Text_OpheliaIntro
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
	ClearTrainerFlag 1457
	CanvasCloseMsg
	TrainerBattle 1457, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_4
	WhiteOut
	End
_cv_won_4:
	SetTrainerFlag 1457
	NPCMsg msg_0517_T08R0401_TrainingHouse_Text_After
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TrainingHouse_EventScript_Declined:
	NPCMsg msg_0517_T08R0401_TrainingHouse_Text_Declined
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0517_T08R0401_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
