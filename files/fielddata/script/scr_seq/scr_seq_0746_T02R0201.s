#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T02R0201.h"
#include "msgdata/msg/msg_0456_T02R0201.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's ViridianCity_House_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef ViridianCity_House_EventScript_BaldingMan
	ScrDef ViridianCity_House_EventScript_LittleGirl
	ScrDef ViridianCity_House_EventScript_Speary
	ScrDef TrainingHouse_EventScript_Morris
	ScrDef TrainingHouse_EventScript_Lydia
	ScrDef ViridianCity_House_EventScript_NicknameSign
	ScrDefEnd
	
ViridianCity_House_EventScript_BaldingMan:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0456_T02R0201_ViridianCity_House_Text_NicknamingIsFun
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianCity_House_EventScript_LittleGirl:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0456_T02R0201_ViridianCity_House_Text_MyDaddyLovesMonsToo
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianCity_House_EventScript_Speary:
	LockAll
	FacePlayer
	WaitSE SEQ_SE_DP_SELECT
	PlayCry SPECIES_SPEAROW, 0
	NPCMsg msg_0456_T02R0201_ViridianCity_House_Text_Speary
	WaitButton
	WaitCry
	CloseMsg
	ReleaseAll
	End
	
TrainingHouse_EventScript_Morris:
	LockAll
	FacePlayer
	NPCMsg msg_0456_T02R0201_TrainingHouse_Text_MorrisIntro
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
	ClearTrainerFlag 1443
	CanvasCloseMsg
	TrainerBattle 1443, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_4
	WhiteOut
	End
_cv_won_4:
	SetTrainerFlag 1443
	NPCMsg msg_0456_T02R0201_TrainingHouse_Text_After
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TrainingHouse_EventScript_Lydia:
	LockAll
	FacePlayer
	NPCMsg msg_0456_T02R0201_TrainingHouse_Text_LydiaIntro
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
	ClearTrainerFlag 1444
	CanvasCloseMsg
	TrainerBattle 1444, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_8
	WhiteOut
	End
_cv_won_8:
	SetTrainerFlag 1444
	NPCMsg msg_0456_T02R0201_TrainingHouse_Text_After
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianCity_House_EventScript_NicknameSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0456_T02R0201_ViridianCity_House_Text_SpearowNameSpeary
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TrainingHouse_EventScript_Declined:
	NPCMsg msg_0456_T02R0201_TrainingHouse_Text_Declined
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0456_T02R0201_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
