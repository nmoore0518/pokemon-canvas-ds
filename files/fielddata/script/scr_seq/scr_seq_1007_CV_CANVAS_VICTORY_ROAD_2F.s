#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_VICTORY_ROAD_2F.h"
#include "msgdata/msg/msg_0875_CV_CANVAS_VICTORY_ROAD_2F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's VictoryRoad_2F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef VictoryRoad_2F_EventScript_Nelson
	ScrDef VictoryRoad_2F_EventScript_ItemGuardSpec
	ScrDef VictoryRoad_2F_EventScript_ItemTM07
	ScrDef VictoryRoad_2F_EventScript_ItemFullHeal
	ScrDef VictoryRoad_2F_EventScript_ItemTM37
	ScrDef VictoryRoad_2F_EventScript_DoubleEdgeTutor
	ScrDef VictoryRoad_2F_EventScript_Moltres
	ScrDef BerryField_EventScript_FindDragon
	ScrDef VictoryRoad_2F_EventScript_FloorSwitch1
	ScrDef VictoryRoad_2F_EventScript_FloorSwitch2
	ScrDef VictoryRoad_2F_OnLoad
	ScrDef VictoryRoad_2F_OnTransition
	ScrDef VictoryRoad_2F_OnResume
	ScrDef VictoryRoad_2F_Frlg_cv_Barriers
	ScrDefEnd
	
VictoryRoad_2F_EventScript_Nelson:
	CheckTrainerFlag 1032
	GoToIf TRUE, _cv_beaten_1
	NPCMsg msg_0875_CV_CANVAS_VICTORY_ROAD_2F_VictoryRoad_2F_Text_NelsonIntro
	WaitButton
	CloseMsg
	TrainerBattle 1032, 1032, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_2
	WhiteOut
	End
_cv_won_2:
	SetTrainerFlag 1032
	GoTo GymCandidate_EventScript_RecruitPsychic
_cv_beaten_1:
	SetVar 0x8004, 15
	Call GymCandidate_EventScript_RecruitOffer
	BufferRivalsName 7
	NPCMsg msg_0875_CV_CANVAS_VICTORY_ROAD_2F_VictoryRoad_2F_Text_NelsonPostBattle
	WaitButton
	CloseMsg
	End
	
VictoryRoad_2F_EventScript_ItemGuardSpec:
	SetVar 0x8004, 55
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
VictoryRoad_2F_EventScript_ItemTM07:
	SetVar 0x8004, ITEM_TM07
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
VictoryRoad_2F_EventScript_ItemFullHeal:
	SetVar 0x8004, ITEM_FULL_HEAL
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
VictoryRoad_2F_EventScript_ItemTM37:
	SetVar 0x8004, ITEM_TM37
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
VictoryRoad_2F_EventScript_DoubleEdgeTutor:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0875_CV_CANVAS_VICTORY_ROAD_2F_VictoryRoad_2F_Text_DoubleEdgeTutor_Retired
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VictoryRoad_2F_EventScript_Moltres:
	GoTo MtEmber_Summit_EventScript_Moltres
	
BerryField_EventScript_FindDragon:
	SetVar 0x8004, ITEM_HABAN_BERRY
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
VictoryRoad_2F_EventScript_FloorSwitch1:
	LockAll
	CompareVarToValue 0x5039, 100
	GoToIfEq VictoryRoad_2F_EventScript_FloorSwitch1AlreadyPressed
	GoToIfSet 0x226A, _cv_bar_3
	SetFlag 0x226A
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_3
	HidePerson 200
_cv_bar_3:
	GoToIfSet 0x226B, _cv_bar_4
	SetFlag 0x226B
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_4
	HidePerson 201
_cv_bar_4:
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	GetPersonCoords 11, 0x401E, 0x401F
	MovePerson 11, 0x401E, 0x401F
	SetVar 0x5039, 100
	CanvasCloseMsg
	ReleaseAll
	End
	
VictoryRoad_2F_EventScript_FloorSwitch2:
	LockAll
	CompareVarToValue 0x503A, 100
	GoToIfEq VictoryRoad_2F_EventScript_FloorSwitch2AlreadyPressed
	GoToIfSet 0x226C, _cv_bar_5
	SetFlag 0x226C
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_5
	HidePerson 202
_cv_bar_5:
	GoToIfSet 0x226D, _cv_bar_6
	SetFlag 0x226D
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_6
	HidePerson 203
_cv_bar_6:
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	GetPersonCoords 12, 0x401E, 0x401F
	MovePerson 12, 0x401E, 0x401F
	SetVar 0x503A, 100
	CanvasCloseMsg
	ReleaseAll
	End
	
VictoryRoad_2F_OnLoad:
	CompareVarToValue 0x5039, 100
	CallIfNe VictoryRoad_2F_EventScript_SetRockBarrier1
	CompareVarToValue 0x503A, 100
	CallIfNe VictoryRoad_2F_EventScript_SetRockBarrier2
	End
	
VictoryRoad_2F_OnTransition:
	CallIfUnset 0x2165, MtEmber_Summit_EventScript_ShowMoltres
	End
	
VictoryRoad_2F_OnResume:
	CallIfSet 0x2032, MtEmber_Summit_EventScript_TryRemoveMoltres
	End
	
VictoryRoad_2F_Frlg_cv_Barriers:
	SetVar 0x5044, 1
	SetFlag 0x226A
	SetFlag 0x226B
	SetFlag 0x226C
	SetFlag 0x226D
	Call VictoryRoad_2F_OnLoad_cv_init
	SetVar 0x5044, 0
	GoTo VictoryRoad_2F_OnTransition
	
GymCandidate_EventScript_RecruitPsychic:
	SetVar 0x8004, 15
	GoTo GymCandidate_EventScript_RecruitAfterBattle
	End
	
GymCandidate_EventScript_RecruitOffer:
	// TODO(gba) special GymCandidate_BufferRecruit
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymCandidate_EventScript_Return
	LockAll
	FacePlayer
	Call _cv_str4
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_7
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_8
_cv_yes_7:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_8:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_RecruitDeclined
	// TODO(gba) special GymCandidate_Recruit
	GoTo _cv_stop
	PlayFanfare SEQ_ME_ITEM
	NPCMsg msg_0875_CV_CANVAS_VICTORY_ROAD_2F_GymCandidate_Text_RecruitJoined
	WaitButton
	WaitFanfare
	NPCMsg msg_0875_CV_CANVAS_VICTORY_ROAD_2F_GymCandidate_Text_RecruitHowToPlace
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
MtEmber_Summit_EventScript_Moltres:
	LockAll
	FacePlayer
	WaitSE SEQ_SE_DP_SELECT
	PlayCry SPECIES_MOLTRES, 0
	NPCMsg msg_0875_CV_CANVAS_VICTORY_ROAD_2F_Text_Gyaoo
	WaitCry
	Wait 10, VAR_SPECIAL_RESULT
	PlayBGM SEQ_GS_GYM
	WaitButton
	SetFlag 0x2032
	CloseMsg
	WildBattle SPECIES_MOLTRES, 50, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_wild_9
	WhiteOut
	ReleaseAll
	End
_cv_wild_9:
	ClearFlag 0x2032
	GetStaticEncounterOutcome VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfNe _cv_outcome_10
	SetVar VAR_SPECIAL_RESULT, 7
	GoTo _cv_outcome_11
_cv_outcome_10:
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfNe _cv_outcome_11
	SetVar VAR_SPECIAL_RESULT, 4
_cv_outcome_11:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq MtEmber_Summit_EventScript_DefeatedMoltres
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfEq MtEmber_Summit_EventScript_RanFromMoltres
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfEq MtEmber_Summit_EventScript_RanFromMoltres
	SetFlag 0x2165
	CanvasCloseMsg
	ReleaseAll
	End
	
VictoryRoad_2F_EventScript_FloorSwitch1AlreadyPressed:
	CanvasCloseMsg
	ReleaseAll
	End
	
VictoryRoad_2F_EventScript_FloorSwitch2AlreadyPressed:
	CanvasCloseMsg
	ReleaseAll
	End
	
VictoryRoad_2F_EventScript_SetRockBarrier1:
	GoToIfUnset 0x226A, _cv_bar_12
	ClearFlag 0x226A
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_12
	ShowPerson 200
_cv_bar_12:
	GoToIfUnset 0x226B, _cv_bar_13
	ClearFlag 0x226B
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_13
	ShowPerson 201
_cv_bar_13:
	Return
	
VictoryRoad_2F_EventScript_SetRockBarrier2:
	GoToIfUnset 0x226C, _cv_bar_14
	ClearFlag 0x226C
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_14
	ShowPerson 202
_cv_bar_14:
	GoToIfUnset 0x226D, _cv_bar_15
	ClearFlag 0x226D
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_15
	ShowPerson 203
_cv_bar_15:
	Return
	
MtEmber_Summit_EventScript_ShowMoltres:
	ClearFlag 0x2166
	Return
	
MtEmber_Summit_EventScript_TryRemoveMoltres:
	GetStaticEncounterOutcome 0x401C
	CompareVarToValue 0x401C, 4
	GoToIfNe _cv_outcome_16
	SetVar 0x401C, 7
	GoTo _cv_outcome_17
_cv_outcome_16:
	CompareVarToValue 0x401C, 5
	GoToIfNe _cv_outcome_17
	SetVar 0x401C, 4
_cv_outcome_17:
	CompareVarToValue 0x401C, 7
	GoToIfNe Common_EventScript_NopReturn
	HidePerson 0x401D
	Return
	
VictoryRoad_2F_OnLoad_cv_init:
	CompareVarToValue 0x5039, 100
	CallIfNe VictoryRoad_2F_EventScript_SetRockBarrier1
	CompareVarToValue 0x503A, 100
	CallIfNe VictoryRoad_2F_EventScript_SetRockBarrier2
	Return
	
GymCandidate_EventScript_RecruitAfterBattle:
	Call GymCandidate_EventScript_RecruitOffer
	CanvasCloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_Return:
	Return
	
GymCandidate_EventScript_RecruitDeclined:
	NPCMsg msg_0875_CV_CANVAS_VICTORY_ROAD_2F_GymCandidate_Text_RecruitDeclined
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
MtEmber_Summit_EventScript_DefeatedMoltres:
	SetFlag 0x2165
	GoTo EventScript_RemoveStaticMon
	End
	
MtEmber_Summit_EventScript_RanFromMoltres:
	SetVar 0x8004, SPECIES_MOLTRES
	GoTo EventScript_MonFlewAway
	End
	
Common_EventScript_NopReturn:
	Return
	
EventScript_RemoveStaticMon:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	HidePerson VAR_SPECIAL_LAST_TALKED
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	CanvasCloseMsg
	ReleaseAll
	End
	
EventScript_MonFlewAway:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	HidePerson VAR_SPECIAL_LAST_TALKED
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	BufferSpeciesName 0, 0x8004, 0, 0
	NPCMsg msg_0875_CV_CANVAS_VICTORY_ROAD_2F_Text_MonFlewAway
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_str4:
	BufferPlayersName 6
	BufferRivalsName 7
	Return

_cv_stop:
	NPCMsg msg_0875_CV_CANVAS_VICTORY_ROAD_2F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
