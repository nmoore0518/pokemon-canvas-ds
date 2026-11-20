#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T03R0601.h"
#include "msgdata/msg/msg_0466_T03R0601.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PewterCity_House2_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef PewterCity_House2_EventScript_OldMan
	ScrDef PewterCity_House2_EventScript_LittleBoy
	ScrDef TrainingHouse_EventScript_Claire
	ScrDef TrainingHouse_EventScript_Bernard
	ScrDefEnd
	
PewterCity_House2_EventScript_OldMan:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0466_T03R0601_PewterCity_House2_Text_MonsLearnTechniquesAsTheyGrow
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_House2_EventScript_LittleBoy:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0466_T03R0601_PewterCity_House2_Text_MonsEasierCatchIfStatused
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TrainingHouse_EventScript_Claire:
	LockAll
	FacePlayer
	NPCMsg msg_0466_T03R0601_TrainingHouse_Text_ClaireIntro
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
	ClearTrainerFlag 1445
	CanvasCloseMsg
	TrainerBattle 1445, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_4
	WhiteOut
	End
_cv_won_4:
	SetTrainerFlag 1445
	NPCMsg msg_0466_T03R0601_TrainingHouse_Text_After
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TrainingHouse_EventScript_Bernard:
	LockAll
	FacePlayer
	NPCMsg msg_0466_T03R0601_TrainingHouse_Text_BernardIntro
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
	ClearTrainerFlag 1446
	CanvasCloseMsg
	TrainerBattle 1446, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_8
	WhiteOut
	End
_cv_won_8:
	SetTrainerFlag 1446
	NPCMsg msg_0466_T03R0601_TrainingHouse_Text_After
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TrainingHouse_EventScript_Declined:
	NPCMsg msg_0466_T03R0601_TrainingHouse_Text_Declined
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0466_T03R0601_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
