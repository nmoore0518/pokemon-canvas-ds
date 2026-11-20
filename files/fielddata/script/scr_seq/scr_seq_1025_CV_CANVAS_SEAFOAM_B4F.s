#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SEAFOAM_B4F.h"
#include "msgdata/msg/msg_0884_CV_CANVAS_SEAFOAM_B4F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SeafoamIslands_B4F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SeafoamIslands_B4F_EventScript_Articuno
	ScrDef SeafoamIslands_B4F_EventScript_ItemUltraBall
	ScrDef SeafoamIslands_B4F_EventScript_FastCurrentSign
	ScrDef SeafoamIslands_B4F_EventScript_BoulderHintSign
	ScrDef SeafoamIslands_B4F_EventScript_UpwardCurrent
	ScrDef SeafoamIslands_B4F_cv_Currents_0
	ScrDef SeafoamIslands_B4F_cv_Currents_1
	ScrDef SeafoamIslands_B4F_OnTransition
	ScrDef SeafoamIslands_B4F_OnResume
	ScrDef SeafoamIslands_B4F_OnLoad
	ScrDef SeafoamIslands_B4F_EventScript_EnterOnCurrent
	ScrDef SeafoamIslands_B4F_EventScript_EnterByFalling
	ScrDef SeafoamIslands_B4F_cv_Arrive
	ScrDefEnd
	
SeafoamIslands_B4F_EventScript_Articuno:
	LockAll
	FacePlayer
	WaitSE SEQ_SE_DP_SELECT
	PlayCry SPECIES_ARTICUNO, 0
	NPCMsg msg_0884_CV_CANVAS_SEAFOAM_B4F_Text_Gyaoo
	WaitCry
	Wait 10, VAR_SPECIAL_RESULT
	PlayBGM SEQ_GS_GYM
	WaitButton
	SetFlag 0x2032
	CloseMsg
	WildBattle SPECIES_ARTICUNO, 50, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_wild_1
	WhiteOut
	ReleaseAll
	End
_cv_wild_1:
	ClearFlag 0x2032
	GetStaticEncounterOutcome VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfNe _cv_outcome_2
	SetVar VAR_SPECIAL_RESULT, 7
	GoTo _cv_outcome_3
_cv_outcome_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfNe _cv_outcome_3
	SetVar VAR_SPECIAL_RESULT, 4
_cv_outcome_3:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq SeafoamIslands_B4F_EventScript_DefeatedArticuno
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfEq SeafoamIslands_B4F_EventScript_RanFromArticuno
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfEq SeafoamIslands_B4F_EventScript_RanFromArticuno
	SetFlag 0x217F
	ReleaseAll
	End
	
SeafoamIslands_B4F_EventScript_ItemUltraBall:
	SetVar 0x8004, ITEM_ULTRA_BALL
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
SeafoamIslands_B4F_EventScript_FastCurrentSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0884_CV_CANVAS_SEAFOAM_B4F_SeafoamIslands_B4F_Text_DangerFastCurrent
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SeafoamIslands_B4F_EventScript_BoulderHintSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0884_CV_CANVAS_SEAFOAM_B4F_SeafoamIslands_B4F_Text_BouldersMightChangeWaterFlow
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SeafoamIslands_B4F_EventScript_UpwardCurrent:
	LockAll
	ApplyMovement obj_player, SeafoamIslands_B4F_Movement_WalkUp
	WaitMovement
	ReleaseAll
	End
	
SeafoamIslands_B4F_cv_Currents_0:
	LockAll
	GetPlayerCoords 0x8008, 0x8009
	CompareVarToValue 0x8008, 3
	GoToIfEq SeafoamIslands_B4F_cv_Currents_0_x3
	CompareVarToValue 0x8008, 4
	GoToIfEq SeafoamIslands_B4F_cv_Currents_0_x4
	CompareVarToValue 0x8008, 5
	GoToIfEq SeafoamIslands_B4F_cv_Currents_0_x5
	CompareVarToValue 0x8008, 6
	GoToIfEq SeafoamIslands_B4F_cv_Currents_0_x6
	CompareVarToValue 0x8008, 7
	GoToIfEq SeafoamIslands_B4F_cv_Currents_0_x7
	CompareVarToValue 0x8008, 8
	GoToIfEq SeafoamIslands_B4F_cv_Currents_0_x8
	CompareVarToValue 0x8008, 9
	GoToIfEq SeafoamIslands_B4F_cv_Currents_0_x9
	CompareVarToValue 0x8008, 10
	GoToIfEq SeafoamIslands_B4F_cv_Currents_0_x10
	CompareVarToValue 0x8008, 11
	GoToIfEq SeafoamIslands_B4F_cv_Currents_0_x11
	CompareVarToValue 0x8008, 12
	GoToIfEq SeafoamIslands_B4F_cv_Currents_0_x12
	CompareVarToValue 0x8008, 13
	GoToIfEq SeafoamIslands_B4F_cv_Currents_0_x13
	CompareVarToValue 0x8008, 14
	GoToIfEq SeafoamIslands_B4F_cv_Currents_0_x14
	CompareVarToValue 0x8008, 15
	GoToIfEq SeafoamIslands_B4F_cv_Currents_0_x15
	CompareVarToValue 0x8008, 16
	GoToIfEq SeafoamIslands_B4F_cv_Currents_0_x16
	CompareVarToValue 0x8008, 17
	GoToIfEq SeafoamIslands_B4F_cv_Currents_0_x17
	CompareVarToValue 0x8008, 18
	GoToIfEq SeafoamIslands_B4F_cv_Currents_0_x18
	CompareVarToValue 0x8008, 19
	GoToIfEq SeafoamIslands_B4F_cv_Currents_0_x19
	CompareVarToValue 0x8008, 20
	GoToIfEq SeafoamIslands_B4F_cv_Currents_0_x20
	CompareVarToValue 0x8008, 21
	GoToIfEq SeafoamIslands_B4F_cv_Currents_0_x21
	CompareVarToValue 0x8008, 22
	GoToIfEq SeafoamIslands_B4F_cv_Currents_0_x22
	CompareVarToValue 0x8008, 23
	GoToIfEq SeafoamIslands_B4F_cv_Currents_0_x23
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Currents_0_x3:
	CompareVarToValue 0x8009, 2
	GoToIfEq SeafoamIslands_B4F_cv_Current_3_2
	CompareVarToValue 0x8009, 3
	GoToIfEq SeafoamIslands_B4F_cv_Current_3_3
	CompareVarToValue 0x8009, 4
	GoToIfEq SeafoamIslands_B4F_cv_Current_3_4
	CompareVarToValue 0x8009, 5
	GoToIfEq SeafoamIslands_B4F_cv_Current_3_5
	CompareVarToValue 0x8009, 6
	GoToIfEq SeafoamIslands_B4F_cv_Current_3_6
	CompareVarToValue 0x8009, 7
	GoToIfEq SeafoamIslands_B4F_cv_Current_3_7
	CompareVarToValue 0x8009, 8
	GoToIfEq SeafoamIslands_B4F_cv_Current_3_8
	CompareVarToValue 0x8009, 9
	GoToIfEq SeafoamIslands_B4F_cv_Current_3_9
	CompareVarToValue 0x8009, 10
	GoToIfEq SeafoamIslands_B4F_cv_Current_3_10
	CompareVarToValue 0x8009, 11
	GoToIfEq SeafoamIslands_B4F_cv_Current_3_11
	CompareVarToValue 0x8009, 12
	GoToIfEq SeafoamIslands_B4F_cv_Current_3_12
	CompareVarToValue 0x8009, 13
	GoToIfEq SeafoamIslands_B4F_cv_Current_3_13
	CompareVarToValue 0x8009, 14
	GoToIfEq SeafoamIslands_B4F_cv_Current_3_14
	CompareVarToValue 0x8009, 15
	GoToIfEq SeafoamIslands_B4F_cv_Current_3_15
	CompareVarToValue 0x8009, 16
	GoToIfEq SeafoamIslands_B4F_cv_Current_3_16
	CompareVarToValue 0x8009, 17
	GoToIfEq SeafoamIslands_B4F_cv_Current_3_17
	CompareVarToValue 0x8009, 18
	GoToIfEq SeafoamIslands_B4F_cv_Current_3_18
	CompareVarToValue 0x8009, 19
	GoToIfEq SeafoamIslands_B4F_cv_Current_3_19
	CompareVarToValue 0x8009, 20
	GoToIfEq SeafoamIslands_B4F_cv_Current_3_20
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Currents_0_x4:
	CompareVarToValue 0x8009, 2
	GoToIfEq SeafoamIslands_B4F_cv_Current_4_2
	CompareVarToValue 0x8009, 3
	GoToIfEq SeafoamIslands_B4F_cv_Current_4_3
	CompareVarToValue 0x8009, 4
	GoToIfEq SeafoamIslands_B4F_cv_Current_4_4
	CompareVarToValue 0x8009, 5
	GoToIfEq SeafoamIslands_B4F_cv_Current_4_5
	CompareVarToValue 0x8009, 6
	GoToIfEq SeafoamIslands_B4F_cv_Current_4_6
	CompareVarToValue 0x8009, 7
	GoToIfEq SeafoamIslands_B4F_cv_Current_4_7
	CompareVarToValue 0x8009, 8
	GoToIfEq SeafoamIslands_B4F_cv_Current_4_8
	CompareVarToValue 0x8009, 9
	GoToIfEq SeafoamIslands_B4F_cv_Current_4_9
	CompareVarToValue 0x8009, 10
	GoToIfEq SeafoamIslands_B4F_cv_Current_4_10
	CompareVarToValue 0x8009, 11
	GoToIfEq SeafoamIslands_B4F_cv_Current_4_11
	CompareVarToValue 0x8009, 12
	GoToIfEq SeafoamIslands_B4F_cv_Current_4_12
	CompareVarToValue 0x8009, 13
	GoToIfEq SeafoamIslands_B4F_cv_Current_4_13
	CompareVarToValue 0x8009, 14
	GoToIfEq SeafoamIslands_B4F_cv_Current_4_14
	CompareVarToValue 0x8009, 15
	GoToIfEq SeafoamIslands_B4F_cv_Current_4_15
	CompareVarToValue 0x8009, 16
	GoToIfEq SeafoamIslands_B4F_cv_Current_4_16
	CompareVarToValue 0x8009, 17
	GoToIfEq SeafoamIslands_B4F_cv_Current_4_17
	CompareVarToValue 0x8009, 18
	GoToIfEq SeafoamIslands_B4F_cv_Current_4_18
	CompareVarToValue 0x8009, 19
	GoToIfEq SeafoamIslands_B4F_cv_Current_4_19
	CompareVarToValue 0x8009, 20
	GoToIfEq SeafoamIslands_B4F_cv_Current_4_20
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Currents_0_x5:
	CompareVarToValue 0x8009, 2
	GoToIfEq SeafoamIslands_B4F_cv_Current_5_2
	CompareVarToValue 0x8009, 3
	GoToIfEq SeafoamIslands_B4F_cv_Current_5_3
	CompareVarToValue 0x8009, 4
	GoToIfEq SeafoamIslands_B4F_cv_Current_5_4
	CompareVarToValue 0x8009, 5
	GoToIfEq SeafoamIslands_B4F_cv_Current_5_5
	CompareVarToValue 0x8009, 6
	GoToIfEq SeafoamIslands_B4F_cv_Current_5_6
	CompareVarToValue 0x8009, 7
	GoToIfEq SeafoamIslands_B4F_cv_Current_5_7
	CompareVarToValue 0x8009, 8
	GoToIfEq SeafoamIslands_B4F_cv_Current_5_8
	CompareVarToValue 0x8009, 9
	GoToIfEq SeafoamIslands_B4F_cv_Current_5_9
	CompareVarToValue 0x8009, 10
	GoToIfEq SeafoamIslands_B4F_cv_Current_5_10
	CompareVarToValue 0x8009, 11
	GoToIfEq SeafoamIslands_B4F_cv_Current_5_11
	CompareVarToValue 0x8009, 12
	GoToIfEq SeafoamIslands_B4F_cv_Current_5_12
	CompareVarToValue 0x8009, 13
	GoToIfEq SeafoamIslands_B4F_cv_Current_5_13
	CompareVarToValue 0x8009, 14
	GoToIfEq SeafoamIslands_B4F_cv_Current_5_14
	CompareVarToValue 0x8009, 15
	GoToIfEq SeafoamIslands_B4F_cv_Current_5_15
	CompareVarToValue 0x8009, 16
	GoToIfEq SeafoamIslands_B4F_cv_Current_5_16
	CompareVarToValue 0x8009, 17
	GoToIfEq SeafoamIslands_B4F_cv_Current_5_17
	CompareVarToValue 0x8009, 18
	GoToIfEq SeafoamIslands_B4F_cv_Current_5_18
	CompareVarToValue 0x8009, 19
	GoToIfEq SeafoamIslands_B4F_cv_Current_5_19
	CompareVarToValue 0x8009, 20
	GoToIfEq SeafoamIslands_B4F_cv_Current_5_20
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Currents_0_x6:
	CompareVarToValue 0x8009, 7
	GoToIfEq SeafoamIslands_B4F_cv_Current_6_7
	CompareVarToValue 0x8009, 8
	GoToIfEq SeafoamIslands_B4F_cv_Current_6_8
	CompareVarToValue 0x8009, 9
	GoToIfEq SeafoamIslands_B4F_cv_Current_6_9
	CompareVarToValue 0x8009, 10
	GoToIfEq SeafoamIslands_B4F_cv_Current_6_10
	CompareVarToValue 0x8009, 11
	GoToIfEq SeafoamIslands_B4F_cv_Current_6_11
	CompareVarToValue 0x8009, 12
	GoToIfEq SeafoamIslands_B4F_cv_Current_6_12
	CompareVarToValue 0x8009, 13
	GoToIfEq SeafoamIslands_B4F_cv_Current_6_13
	CompareVarToValue 0x8009, 14
	GoToIfEq SeafoamIslands_B4F_cv_Current_6_14
	CompareVarToValue 0x8009, 15
	GoToIfEq SeafoamIslands_B4F_cv_Current_6_15
	CompareVarToValue 0x8009, 16
	GoToIfEq SeafoamIslands_B4F_cv_Current_6_16
	CompareVarToValue 0x8009, 17
	GoToIfEq SeafoamIslands_B4F_cv_Current_6_17
	CompareVarToValue 0x8009, 18
	GoToIfEq SeafoamIslands_B4F_cv_Current_6_18
	CompareVarToValue 0x8009, 19
	GoToIfEq SeafoamIslands_B4F_cv_Current_6_19
	CompareVarToValue 0x8009, 20
	GoToIfEq SeafoamIslands_B4F_cv_Current_6_20
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Currents_0_x7:
	CompareVarToValue 0x8009, 7
	GoToIfEq SeafoamIslands_B4F_cv_Current_7_7
	CompareVarToValue 0x8009, 8
	GoToIfEq SeafoamIslands_B4F_cv_Current_7_8
	CompareVarToValue 0x8009, 9
	GoToIfEq SeafoamIslands_B4F_cv_Current_7_9
	CompareVarToValue 0x8009, 10
	GoToIfEq SeafoamIslands_B4F_cv_Current_7_10
	CompareVarToValue 0x8009, 11
	GoToIfEq SeafoamIslands_B4F_cv_Current_7_11
	CompareVarToValue 0x8009, 12
	GoToIfEq SeafoamIslands_B4F_cv_Current_7_12
	CompareVarToValue 0x8009, 13
	GoToIfEq SeafoamIslands_B4F_cv_Current_7_13
	CompareVarToValue 0x8009, 14
	GoToIfEq SeafoamIslands_B4F_cv_Current_7_14
	CompareVarToValue 0x8009, 15
	GoToIfEq SeafoamIslands_B4F_cv_Current_7_15
	CompareVarToValue 0x8009, 16
	GoToIfEq SeafoamIslands_B4F_cv_Current_7_16
	CompareVarToValue 0x8009, 17
	GoToIfEq SeafoamIslands_B4F_cv_Current_7_17
	CompareVarToValue 0x8009, 18
	GoToIfEq SeafoamIslands_B4F_cv_Current_7_18
	CompareVarToValue 0x8009, 19
	GoToIfEq SeafoamIslands_B4F_cv_Current_7_19
	CompareVarToValue 0x8009, 20
	GoToIfEq SeafoamIslands_B4F_cv_Current_7_20
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Currents_0_x8:
	CompareVarToValue 0x8009, 6
	GoToIfEq SeafoamIslands_B4F_cv_Current_8_6
	CompareVarToValue 0x8009, 7
	GoToIfEq SeafoamIslands_B4F_cv_Current_8_7
	CompareVarToValue 0x8009, 8
	GoToIfEq SeafoamIslands_B4F_cv_Current_8_8
	CompareVarToValue 0x8009, 9
	GoToIfEq SeafoamIslands_B4F_cv_Current_8_9
	CompareVarToValue 0x8009, 10
	GoToIfEq SeafoamIslands_B4F_cv_Current_8_10
	CompareVarToValue 0x8009, 11
	GoToIfEq SeafoamIslands_B4F_cv_Current_8_11
	CompareVarToValue 0x8009, 12
	GoToIfEq SeafoamIslands_B4F_cv_Current_8_12
	CompareVarToValue 0x8009, 13
	GoToIfEq SeafoamIslands_B4F_cv_Current_8_13
	CompareVarToValue 0x8009, 14
	GoToIfEq SeafoamIslands_B4F_cv_Current_8_14
	CompareVarToValue 0x8009, 15
	GoToIfEq SeafoamIslands_B4F_cv_Current_8_15
	CompareVarToValue 0x8009, 16
	GoToIfEq SeafoamIslands_B4F_cv_Current_8_16
	CompareVarToValue 0x8009, 17
	GoToIfEq SeafoamIslands_B4F_cv_Current_8_17
	CompareVarToValue 0x8009, 18
	GoToIfEq SeafoamIslands_B4F_cv_Current_8_18
	CompareVarToValue 0x8009, 19
	GoToIfEq SeafoamIslands_B4F_cv_Current_8_19
	CompareVarToValue 0x8009, 20
	GoToIfEq SeafoamIslands_B4F_cv_Current_8_20
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Currents_0_x9:
	CompareVarToValue 0x8009, 6
	GoToIfEq SeafoamIslands_B4F_cv_Current_9_6
	CompareVarToValue 0x8009, 7
	GoToIfEq SeafoamIslands_B4F_cv_Current_9_7
	CompareVarToValue 0x8009, 8
	GoToIfEq SeafoamIslands_B4F_cv_Current_9_8
	CompareVarToValue 0x8009, 9
	GoToIfEq SeafoamIslands_B4F_cv_Current_9_9
	CompareVarToValue 0x8009, 10
	GoToIfEq SeafoamIslands_B4F_cv_Current_9_10
	CompareVarToValue 0x8009, 11
	GoToIfEq SeafoamIslands_B4F_cv_Current_9_11
	CompareVarToValue 0x8009, 12
	GoToIfEq SeafoamIslands_B4F_cv_Current_9_12
	CompareVarToValue 0x8009, 13
	GoToIfEq SeafoamIslands_B4F_cv_Current_9_13
	CompareVarToValue 0x8009, 14
	GoToIfEq SeafoamIslands_B4F_cv_Current_9_14
	CompareVarToValue 0x8009, 15
	GoToIfEq SeafoamIslands_B4F_cv_Current_9_15
	CompareVarToValue 0x8009, 16
	GoToIfEq SeafoamIslands_B4F_cv_Current_9_16
	CompareVarToValue 0x8009, 17
	GoToIfEq SeafoamIslands_B4F_cv_Current_9_17
	CompareVarToValue 0x8009, 18
	GoToIfEq SeafoamIslands_B4F_cv_Current_9_18
	CompareVarToValue 0x8009, 19
	GoToIfEq SeafoamIslands_B4F_cv_Current_9_19
	CompareVarToValue 0x8009, 20
	GoToIfEq SeafoamIslands_B4F_cv_Current_9_20
	CompareVarToValue 0x8009, 21
	GoToIfEq SeafoamIslands_B4F_cv_Current_9_21
	CompareVarToValue 0x8009, 22
	GoToIfEq SeafoamIslands_B4F_cv_Current_9_22
	CompareVarToValue 0x8009, 23
	GoToIfEq SeafoamIslands_B4F_cv_Current_9_23
	CompareVarToValue 0x8009, 26
	GoToIfEq SeafoamIslands_B4F_cv_Current_9_26
	CompareVarToValue 0x8009, 27
	GoToIfEq SeafoamIslands_B4F_cv_Current_9_27
	CompareVarToValue 0x8009, 28
	GoToIfEq SeafoamIslands_B4F_cv_Current_9_28
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Currents_0_x10:
	CompareVarToValue 0x8009, 6
	GoToIfEq SeafoamIslands_B4F_cv_Current_10_6
	CompareVarToValue 0x8009, 7
	GoToIfEq SeafoamIslands_B4F_cv_Current_10_7
	CompareVarToValue 0x8009, 8
	GoToIfEq SeafoamIslands_B4F_cv_Current_10_8
	CompareVarToValue 0x8009, 9
	GoToIfEq SeafoamIslands_B4F_cv_Current_10_9
	CompareVarToValue 0x8009, 10
	GoToIfEq SeafoamIslands_B4F_cv_Current_10_10
	CompareVarToValue 0x8009, 11
	GoToIfEq SeafoamIslands_B4F_cv_Current_10_11
	CompareVarToValue 0x8009, 12
	GoToIfEq SeafoamIslands_B4F_cv_Current_10_12
	CompareVarToValue 0x8009, 13
	GoToIfEq SeafoamIslands_B4F_cv_Current_10_13
	CompareVarToValue 0x8009, 14
	GoToIfEq SeafoamIslands_B4F_cv_Current_10_14
	CompareVarToValue 0x8009, 15
	GoToIfEq SeafoamIslands_B4F_cv_Current_10_15
	CompareVarToValue 0x8009, 16
	GoToIfEq SeafoamIslands_B4F_cv_Current_10_16
	CompareVarToValue 0x8009, 18
	GoToIfEq SeafoamIslands_B4F_cv_Current_10_18
	CompareVarToValue 0x8009, 19
	GoToIfEq SeafoamIslands_B4F_cv_Current_10_19
	CompareVarToValue 0x8009, 20
	GoToIfEq SeafoamIslands_B4F_cv_Current_10_20
	CompareVarToValue 0x8009, 21
	GoToIfEq SeafoamIslands_B4F_cv_Current_10_21
	CompareVarToValue 0x8009, 22
	GoToIfEq SeafoamIslands_B4F_cv_Current_10_22
	CompareVarToValue 0x8009, 23
	GoToIfEq SeafoamIslands_B4F_cv_Current_10_23
	CompareVarToValue 0x8009, 26
	GoToIfEq SeafoamIslands_B4F_cv_Current_10_26
	CompareVarToValue 0x8009, 27
	GoToIfEq SeafoamIslands_B4F_cv_Current_10_27
	CompareVarToValue 0x8009, 28
	GoToIfEq SeafoamIslands_B4F_cv_Current_10_28
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Currents_0_x11:
	CompareVarToValue 0x8009, 6
	GoToIfEq SeafoamIslands_B4F_cv_Current_11_6
	CompareVarToValue 0x8009, 7
	GoToIfEq SeafoamIslands_B4F_cv_Current_11_7
	CompareVarToValue 0x8009, 17
	GoToIfEq SeafoamIslands_B4F_cv_Current_11_17
	CompareVarToValue 0x8009, 18
	GoToIfEq SeafoamIslands_B4F_cv_Current_11_18
	CompareVarToValue 0x8009, 19
	GoToIfEq SeafoamIslands_B4F_cv_Current_11_19
	CompareVarToValue 0x8009, 20
	GoToIfEq SeafoamIslands_B4F_cv_Current_11_20
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Currents_0_x12:
	CompareVarToValue 0x8009, 6
	GoToIfEq SeafoamIslands_B4F_cv_Current_12_6
	CompareVarToValue 0x8009, 7
	GoToIfEq SeafoamIslands_B4F_cv_Current_12_7
	CompareVarToValue 0x8009, 17
	GoToIfEq SeafoamIslands_B4F_cv_Current_12_17
	CompareVarToValue 0x8009, 18
	GoToIfEq SeafoamIslands_B4F_cv_Current_12_18
	CompareVarToValue 0x8009, 19
	GoToIfEq SeafoamIslands_B4F_cv_Current_12_19
	CompareVarToValue 0x8009, 20
	GoToIfEq SeafoamIslands_B4F_cv_Current_12_20
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Currents_0_x13:
	CompareVarToValue 0x8009, 6
	GoToIfEq SeafoamIslands_B4F_cv_Current_13_6
	CompareVarToValue 0x8009, 7
	GoToIfEq SeafoamIslands_B4F_cv_Current_13_7
	CompareVarToValue 0x8009, 18
	GoToIfEq SeafoamIslands_B4F_cv_Current_13_18
	CompareVarToValue 0x8009, 19
	GoToIfEq SeafoamIslands_B4F_cv_Current_13_19
	CompareVarToValue 0x8009, 20
	GoToIfEq SeafoamIslands_B4F_cv_Current_13_20
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Currents_0_x14:
	CompareVarToValue 0x8009, 6
	GoToIfEq SeafoamIslands_B4F_cv_Current_14_6
	CompareVarToValue 0x8009, 7
	GoToIfEq SeafoamIslands_B4F_cv_Current_14_7
	CompareVarToValue 0x8009, 18
	GoToIfEq SeafoamIslands_B4F_cv_Current_14_18
	CompareVarToValue 0x8009, 19
	GoToIfEq SeafoamIslands_B4F_cv_Current_14_19
	CompareVarToValue 0x8009, 20
	GoToIfEq SeafoamIslands_B4F_cv_Current_14_20
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Currents_0_x15:
	CompareVarToValue 0x8009, 6
	GoToIfEq SeafoamIslands_B4F_cv_Current_15_6
	CompareVarToValue 0x8009, 7
	GoToIfEq SeafoamIslands_B4F_cv_Current_15_7
	CompareVarToValue 0x8009, 18
	GoToIfEq SeafoamIslands_B4F_cv_Current_15_18
	CompareVarToValue 0x8009, 19
	GoToIfEq SeafoamIslands_B4F_cv_Current_15_19
	CompareVarToValue 0x8009, 20
	GoToIfEq SeafoamIslands_B4F_cv_Current_15_20
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Currents_0_x16:
	CompareVarToValue 0x8009, 6
	GoToIfEq SeafoamIslands_B4F_cv_Current_16_6
	CompareVarToValue 0x8009, 7
	GoToIfEq SeafoamIslands_B4F_cv_Current_16_7
	CompareVarToValue 0x8009, 18
	GoToIfEq SeafoamIslands_B4F_cv_Current_16_18
	CompareVarToValue 0x8009, 19
	GoToIfEq SeafoamIslands_B4F_cv_Current_16_19
	CompareVarToValue 0x8009, 20
	GoToIfEq SeafoamIslands_B4F_cv_Current_16_20
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Currents_0_x17:
	CompareVarToValue 0x8009, 6
	GoToIfEq SeafoamIslands_B4F_cv_Current_17_6
	CompareVarToValue 0x8009, 7
	GoToIfEq SeafoamIslands_B4F_cv_Current_17_7
	CompareVarToValue 0x8009, 18
	GoToIfEq SeafoamIslands_B4F_cv_Current_17_18
	CompareVarToValue 0x8009, 19
	GoToIfEq SeafoamIslands_B4F_cv_Current_17_19
	CompareVarToValue 0x8009, 20
	GoToIfEq SeafoamIslands_B4F_cv_Current_17_20
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Currents_0_x18:
	CompareVarToValue 0x8009, 6
	GoToIfEq SeafoamIslands_B4F_cv_Current_18_6
	CompareVarToValue 0x8009, 7
	GoToIfEq SeafoamIslands_B4F_cv_Current_18_7
	CompareVarToValue 0x8009, 18
	GoToIfEq SeafoamIslands_B4F_cv_Current_18_18
	CompareVarToValue 0x8009, 19
	GoToIfEq SeafoamIslands_B4F_cv_Current_18_19
	CompareVarToValue 0x8009, 20
	GoToIfEq SeafoamIslands_B4F_cv_Current_18_20
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Currents_0_x19:
	CompareVarToValue 0x8009, 2
	GoToIfEq SeafoamIslands_B4F_cv_Current_19_2
	CompareVarToValue 0x8009, 3
	GoToIfEq SeafoamIslands_B4F_cv_Current_19_3
	CompareVarToValue 0x8009, 4
	GoToIfEq SeafoamIslands_B4F_cv_Current_19_4
	CompareVarToValue 0x8009, 5
	GoToIfEq SeafoamIslands_B4F_cv_Current_19_5
	CompareVarToValue 0x8009, 6
	GoToIfEq SeafoamIslands_B4F_cv_Current_19_6
	CompareVarToValue 0x8009, 7
	GoToIfEq SeafoamIslands_B4F_cv_Current_19_7
	CompareVarToValue 0x8009, 18
	GoToIfEq SeafoamIslands_B4F_cv_Current_19_18
	CompareVarToValue 0x8009, 19
	GoToIfEq SeafoamIslands_B4F_cv_Current_19_19
	CompareVarToValue 0x8009, 20
	GoToIfEq SeafoamIslands_B4F_cv_Current_19_20
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Currents_0_x20:
	CompareVarToValue 0x8009, 2
	GoToIfEq SeafoamIslands_B4F_cv_Current_20_2
	CompareVarToValue 0x8009, 3
	GoToIfEq SeafoamIslands_B4F_cv_Current_20_3
	CompareVarToValue 0x8009, 4
	GoToIfEq SeafoamIslands_B4F_cv_Current_20_4
	CompareVarToValue 0x8009, 5
	GoToIfEq SeafoamIslands_B4F_cv_Current_20_5
	CompareVarToValue 0x8009, 6
	GoToIfEq SeafoamIslands_B4F_cv_Current_20_6
	CompareVarToValue 0x8009, 7
	GoToIfEq SeafoamIslands_B4F_cv_Current_20_7
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Currents_0_x21:
	CompareVarToValue 0x8009, 2
	GoToIfEq SeafoamIslands_B4F_cv_Current_21_2
	CompareVarToValue 0x8009, 3
	GoToIfEq SeafoamIslands_B4F_cv_Current_21_3
	CompareVarToValue 0x8009, 4
	GoToIfEq SeafoamIslands_B4F_cv_Current_21_4
	CompareVarToValue 0x8009, 5
	GoToIfEq SeafoamIslands_B4F_cv_Current_21_5
	CompareVarToValue 0x8009, 6
	GoToIfEq SeafoamIslands_B4F_cv_Current_21_6
	CompareVarToValue 0x8009, 7
	GoToIfEq SeafoamIslands_B4F_cv_Current_21_7
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Currents_0_x22:
	CompareVarToValue 0x8009, 2
	GoToIfEq SeafoamIslands_B4F_cv_Current_22_2
	CompareVarToValue 0x8009, 3
	GoToIfEq SeafoamIslands_B4F_cv_Current_22_3
	CompareVarToValue 0x8009, 4
	GoToIfEq SeafoamIslands_B4F_cv_Current_22_4
	CompareVarToValue 0x8009, 5
	GoToIfEq SeafoamIslands_B4F_cv_Current_22_5
	CompareVarToValue 0x8009, 6
	GoToIfEq SeafoamIslands_B4F_cv_Current_22_6
	CompareVarToValue 0x8009, 7
	GoToIfEq SeafoamIslands_B4F_cv_Current_22_7
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Currents_0_x23:
	CompareVarToValue 0x8009, 2
	GoToIfEq SeafoamIslands_B4F_cv_Current_23_2
	CompareVarToValue 0x8009, 3
	GoToIfEq SeafoamIslands_B4F_cv_Current_23_3
	CompareVarToValue 0x8009, 4
	GoToIfEq SeafoamIslands_B4F_cv_Current_23_4
	CompareVarToValue 0x8009, 5
	GoToIfEq SeafoamIslands_B4F_cv_Current_23_5
	CompareVarToValue 0x8009, 6
	GoToIfEq SeafoamIslands_B4F_cv_Current_23_6
	CompareVarToValue 0x8009, 7
	GoToIfEq SeafoamIslands_B4F_cv_Current_23_7
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_3_2:
	ApplyMovement obj_player, _cv_current_0
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_3_3:
	ApplyMovement obj_player, _cv_current_1
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_3_4:
	ApplyMovement obj_player, _cv_current_2
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_3_5:
	ApplyMovement obj_player, _cv_current_3
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_3_6:
	ApplyMovement obj_player, _cv_current_4
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_3_7:
	ApplyMovement obj_player, _cv_current_16
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_3_8:
	ApplyMovement obj_player, _cv_current_29
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_3_9:
	ApplyMovement obj_player, _cv_current_33
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_3_10:
	ApplyMovement obj_player, _cv_current_37
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_3_11:
	ApplyMovement obj_player, _cv_current_41
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_3_12:
	ApplyMovement obj_player, _cv_current_45
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_3_13:
	ApplyMovement obj_player, _cv_current_49
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_3_14:
	ApplyMovement obj_player, _cv_current_53
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_3_15:
	ApplyMovement obj_player, _cv_current_57
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_3_16:
	ApplyMovement obj_player, _cv_current_61
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_3_17:
	ApplyMovement obj_player, _cv_current_65
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_3_18:
	ApplyMovement obj_player, _cv_current_68
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_3_19:
	ApplyMovement obj_player, _cv_current_75
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_3_20:
	ApplyMovement obj_player, _cv_current_83
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_4_2:
	ApplyMovement obj_player, _cv_current_0
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_4_3:
	ApplyMovement obj_player, _cv_current_1
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_4_4:
	ApplyMovement obj_player, _cv_current_2
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_4_5:
	ApplyMovement obj_player, _cv_current_3
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_4_6:
	ApplyMovement obj_player, _cv_current_4
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_4_7:
	ApplyMovement obj_player, _cv_current_16
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_4_8:
	ApplyMovement obj_player, _cv_current_29
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_4_9:
	ApplyMovement obj_player, _cv_current_33
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_4_10:
	ApplyMovement obj_player, _cv_current_37
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_4_11:
	ApplyMovement obj_player, _cv_current_41
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_4_12:
	ApplyMovement obj_player, _cv_current_45
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_4_13:
	ApplyMovement obj_player, _cv_current_49
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_4_14:
	ApplyMovement obj_player, _cv_current_53
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_4_15:
	ApplyMovement obj_player, _cv_current_57
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_4_16:
	ApplyMovement obj_player, _cv_current_61
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_4_17:
	ApplyMovement obj_player, _cv_current_65
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_4_18:
	ApplyMovement obj_player, _cv_current_68
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_4_19:
	ApplyMovement obj_player, _cv_current_75
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_4_20:
	ApplyMovement obj_player, _cv_current_83
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_5_2:
	ApplyMovement obj_player, _cv_current_0
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_5_3:
	ApplyMovement obj_player, _cv_current_1
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_5_4:
	ApplyMovement obj_player, _cv_current_2
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_5_5:
	ApplyMovement obj_player, _cv_current_3
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_5_6:
	ApplyMovement obj_player, _cv_current_4
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_5_7:
	ApplyMovement obj_player, _cv_current_16
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_5_8:
	ApplyMovement obj_player, _cv_current_29
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_5_9:
	ApplyMovement obj_player, _cv_current_33
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_5_10:
	ApplyMovement obj_player, _cv_current_37
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_5_11:
	ApplyMovement obj_player, _cv_current_41
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_5_12:
	ApplyMovement obj_player, _cv_current_45
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_5_13:
	ApplyMovement obj_player, _cv_current_49
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_5_14:
	ApplyMovement obj_player, _cv_current_53
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_5_15:
	ApplyMovement obj_player, _cv_current_57
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_5_16:
	ApplyMovement obj_player, _cv_current_61
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_5_17:
	ApplyMovement obj_player, _cv_current_65
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_5_18:
	ApplyMovement obj_player, _cv_current_68
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_5_19:
	ApplyMovement obj_player, _cv_current_75
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_5_20:
	ApplyMovement obj_player, _cv_current_83
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_6_7:
	ApplyMovement obj_player, _cv_current_0
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_6_8:
	ApplyMovement obj_player, _cv_current_1
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_6_9:
	ApplyMovement obj_player, _cv_current_2
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_6_10:
	ApplyMovement obj_player, _cv_current_3
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_6_11:
	ApplyMovement obj_player, _cv_current_4
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_6_12:
	ApplyMovement obj_player, _cv_current_16
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_6_13:
	ApplyMovement obj_player, _cv_current_29
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_6_14:
	ApplyMovement obj_player, _cv_current_33
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_6_15:
	ApplyMovement obj_player, _cv_current_37
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_6_16:
	ApplyMovement obj_player, _cv_current_41
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_6_17:
	ApplyMovement obj_player, _cv_current_45
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_6_18:
	ApplyMovement obj_player, _cv_current_49
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_6_19:
	ApplyMovement obj_player, _cv_current_53
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_6_20:
	ApplyMovement obj_player, _cv_current_57
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_7_7:
	ApplyMovement obj_player, _cv_current_0
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_7_8:
	ApplyMovement obj_player, _cv_current_1
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_7_9:
	ApplyMovement obj_player, _cv_current_2
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_7_10:
	ApplyMovement obj_player, _cv_current_3
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_7_11:
	ApplyMovement obj_player, _cv_current_4
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_7_12:
	ApplyMovement obj_player, _cv_current_16
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_7_13:
	ApplyMovement obj_player, _cv_current_29
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_7_14:
	ApplyMovement obj_player, _cv_current_33
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_7_15:
	ApplyMovement obj_player, _cv_current_37
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_7_16:
	ApplyMovement obj_player, _cv_current_41
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_7_17:
	ApplyMovement obj_player, _cv_current_45
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_7_18:
	ApplyMovement obj_player, _cv_current_49
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_7_19:
	ApplyMovement obj_player, _cv_current_53
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_7_20:
	ApplyMovement obj_player, _cv_current_57
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_8_6:
	ApplyMovement obj_player, _cv_current_5
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_8_7:
	ApplyMovement obj_player, _cv_current_17
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_8_8:
	ApplyMovement obj_player, _cv_current_30
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_8_9:
	ApplyMovement obj_player, _cv_current_34
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_8_10:
	ApplyMovement obj_player, _cv_current_38
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_8_11:
	ApplyMovement obj_player, _cv_current_42
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_8_12:
	ApplyMovement obj_player, _cv_current_46
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_8_13:
	ApplyMovement obj_player, _cv_current_50
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_8_14:
	ApplyMovement obj_player, _cv_current_54
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_8_15:
	ApplyMovement obj_player, _cv_current_58
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_8_16:
	ApplyMovement obj_player, _cv_current_62
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_8_17:
	ApplyMovement obj_player, _cv_current_66
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_8_18:
	ApplyMovement obj_player, _cv_current_69
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_8_19:
	ApplyMovement obj_player, _cv_current_76
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_8_20:
	ApplyMovement obj_player, _cv_current_84
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_9_6:
	ApplyMovement obj_player, _cv_current_6
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_9_7:
	ApplyMovement obj_player, _cv_current_18
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_9_8:
	ApplyMovement obj_player, _cv_current_31
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_9_9:
	ApplyMovement obj_player, _cv_current_35
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_9_10:
	ApplyMovement obj_player, _cv_current_39
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_9_11:
	ApplyMovement obj_player, _cv_current_43
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_9_12:
	ApplyMovement obj_player, _cv_current_47
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_9_13:
	ApplyMovement obj_player, _cv_current_51
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_9_14:
	ApplyMovement obj_player, _cv_current_55
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_9_15:
	ApplyMovement obj_player, _cv_current_59
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_9_16:
	ApplyMovement obj_player, _cv_current_63
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_9_17:
	ApplyMovement obj_player, _cv_current_67
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_9_18:
	ApplyMovement obj_player, _cv_current_70
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_9_19:
	ApplyMovement obj_player, _cv_current_77
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_9_20:
	ApplyMovement obj_player, _cv_current_85
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_9_21:
	ApplyMovement obj_player, _cv_current_92
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_9_22:
	ApplyMovement obj_player, _cv_current_94
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_9_23:
	ApplyMovement obj_player, _cv_current_96
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_9_26:
	GoToIfUnset 0x211E, SeafoamIslands_B4F_cv_Current_9_26_current_b0
	SetAvatarBits 1
	UpdateAvatarState
	ApplyMovement obj_player, _cv_hop_off_North
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_9_26_current_b0:
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_9_27:
	GoToIfUnset 0x211E, SeafoamIslands_B4F_cv_Current_9_27_current_b0
	ApplyMovement obj_player, _cv_current_0
	WaitMovement
	SetAvatarBits 1
	UpdateAvatarState
	ApplyMovement obj_player, _cv_hop_off_North
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_9_27_current_b0:
	ApplyMovement obj_player, _cv_current_0
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_9_28:
	GoToIfUnset 0x211E, SeafoamIslands_B4F_cv_Current_9_28_current_b0
	ApplyMovement obj_player, _cv_current_1
	WaitMovement
	SetAvatarBits 1
	UpdateAvatarState
	ApplyMovement obj_player, _cv_hop_off_North
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_9_28_current_b0:
	ApplyMovement obj_player, _cv_current_1
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_10_6:
	ApplyMovement obj_player, _cv_current_7
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_10_7:
	ApplyMovement obj_player, _cv_current_19
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_10_8:
	ApplyMovement obj_player, _cv_current_32
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_10_9:
	ApplyMovement obj_player, _cv_current_36
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_10_10:
	ApplyMovement obj_player, _cv_current_40
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_10_11:
	ApplyMovement obj_player, _cv_current_44
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_10_12:
	ApplyMovement obj_player, _cv_current_48
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_10_13:
	ApplyMovement obj_player, _cv_current_52
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_10_14:
	ApplyMovement obj_player, _cv_current_56
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_10_15:
	ApplyMovement obj_player, _cv_current_60
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_10_16:
	ApplyMovement obj_player, _cv_current_64
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_10_18:
	ApplyMovement obj_player, _cv_current_71
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_10_19:
	ApplyMovement obj_player, _cv_current_78
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_10_20:
	ApplyMovement obj_player, _cv_current_86
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_10_21:
	ApplyMovement obj_player, _cv_current_93
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_10_22:
	ApplyMovement obj_player, _cv_current_95
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_10_23:
	ApplyMovement obj_player, _cv_current_97
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_10_26:
	GoToIfUnset 0x211F, SeafoamIslands_B4F_cv_Current_10_26_current_b1
	SetAvatarBits 1
	UpdateAvatarState
	ApplyMovement obj_player, _cv_hop_off_North
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_10_26_current_b1:
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_10_27:
	GoToIfUnset 0x211F, SeafoamIslands_B4F_cv_Current_10_27_current_b1
	ApplyMovement obj_player, _cv_current_0
	WaitMovement
	SetAvatarBits 1
	UpdateAvatarState
	ApplyMovement obj_player, _cv_hop_off_North
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_10_27_current_b1:
	ApplyMovement obj_player, _cv_current_0
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_10_28:
	GoToIfUnset 0x211F, SeafoamIslands_B4F_cv_Current_10_28_current_b1
	ApplyMovement obj_player, _cv_current_1
	WaitMovement
	SetAvatarBits 1
	UpdateAvatarState
	ApplyMovement obj_player, _cv_hop_off_North
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_10_28_current_b1:
	ApplyMovement obj_player, _cv_current_1
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_11_6:
	ApplyMovement obj_player, _cv_current_8
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_11_7:
	ApplyMovement obj_player, _cv_current_20
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_11_17:
	ApplyMovement obj_player, _cv_current_66
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_11_18:
	ApplyMovement obj_player, _cv_current_72
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_11_19:
	ApplyMovement obj_player, _cv_current_79
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_11_20:
	ApplyMovement obj_player, _cv_current_87
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_12_6:
	ApplyMovement obj_player, _cv_current_9
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_12_7:
	ApplyMovement obj_player, _cv_current_21
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_12_17:
	ApplyMovement obj_player, _cv_current_67
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_12_18:
	ApplyMovement obj_player, _cv_current_73
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_12_19:
	ApplyMovement obj_player, _cv_current_80
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_12_20:
	ApplyMovement obj_player, _cv_current_88
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_13_6:
	ApplyMovement obj_player, _cv_current_10
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_13_7:
	ApplyMovement obj_player, _cv_current_22
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_13_18:
	ApplyMovement obj_player, _cv_current_74
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_13_19:
	ApplyMovement obj_player, _cv_current_81
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_13_20:
	ApplyMovement obj_player, _cv_current_89
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_14_6:
	ApplyMovement obj_player, _cv_current_11
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_14_7:
	ApplyMovement obj_player, _cv_current_23
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_14_18:
	ApplyMovement obj_player, _cv_current_0
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_14_19:
	ApplyMovement obj_player, _cv_current_82
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_14_20:
	ApplyMovement obj_player, _cv_current_90
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_15_6:
	ApplyMovement obj_player, _cv_current_12
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_15_7:
	ApplyMovement obj_player, _cv_current_24
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_15_18:
	ApplyMovement obj_player, _cv_current_0
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_15_19:
	ApplyMovement obj_player, _cv_current_1
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_15_20:
	ApplyMovement obj_player, _cv_current_91
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_16_6:
	ApplyMovement obj_player, _cv_current_13
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_16_7:
	ApplyMovement obj_player, _cv_current_25
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_16_18:
	ApplyMovement obj_player, _cv_current_0
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_16_19:
	ApplyMovement obj_player, _cv_current_1
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_16_20:
	ApplyMovement obj_player, _cv_current_2
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_17_6:
	ApplyMovement obj_player, _cv_current_14
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_17_7:
	ApplyMovement obj_player, _cv_current_26
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_17_18:
	ApplyMovement obj_player, _cv_current_0
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_17_19:
	ApplyMovement obj_player, _cv_current_1
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_17_20:
	ApplyMovement obj_player, _cv_current_2
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_18_6:
	ApplyMovement obj_player, _cv_current_15
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_18_7:
	ApplyMovement obj_player, _cv_current_27
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_18_18:
	ApplyMovement obj_player, _cv_current_0
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_18_19:
	ApplyMovement obj_player, _cv_current_1
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_18_20:
	ApplyMovement obj_player, _cv_current_2
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_19_2:
	ApplyMovement obj_player, _cv_current_0
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_19_3:
	ApplyMovement obj_player, _cv_current_1
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_19_4:
	ApplyMovement obj_player, _cv_current_2
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_19_5:
	ApplyMovement obj_player, _cv_current_3
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_19_6:
	ApplyMovement obj_player, _cv_current_4
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_19_7:
	ApplyMovement obj_player, _cv_current_28
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_19_18:
	ApplyMovement obj_player, _cv_current_0
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_19_19:
	ApplyMovement obj_player, _cv_current_1
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_19_20:
	ApplyMovement obj_player, _cv_current_2
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_20_2:
	ApplyMovement obj_player, _cv_current_0
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_20_3:
	ApplyMovement obj_player, _cv_current_1
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_20_4:
	ApplyMovement obj_player, _cv_current_2
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_20_5:
	ApplyMovement obj_player, _cv_current_3
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_20_6:
	ApplyMovement obj_player, _cv_current_4
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_20_7:
	ApplyMovement obj_player, _cv_current_16
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_21_2:
	ApplyMovement obj_player, _cv_current_0
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_21_3:
	ApplyMovement obj_player, _cv_current_1
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_21_4:
	ApplyMovement obj_player, _cv_current_2
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_21_5:
	ApplyMovement obj_player, _cv_current_3
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_21_6:
	ApplyMovement obj_player, _cv_current_4
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_21_7:
	ApplyMovement obj_player, _cv_current_16
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_22_2:
	ApplyMovement obj_player, _cv_current_0
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_22_3:
	ApplyMovement obj_player, _cv_current_1
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_22_4:
	ApplyMovement obj_player, _cv_current_2
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_22_5:
	ApplyMovement obj_player, _cv_current_3
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_22_6:
	ApplyMovement obj_player, _cv_current_4
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_22_7:
	ApplyMovement obj_player, _cv_current_16
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_23_2:
	ApplyMovement obj_player, _cv_current_0
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_23_3:
	ApplyMovement obj_player, _cv_current_1
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_23_4:
	ApplyMovement obj_player, _cv_current_2
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_23_5:
	ApplyMovement obj_player, _cv_current_3
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_23_6:
	ApplyMovement obj_player, _cv_current_4
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_23_7:
	ApplyMovement obj_player, _cv_current_16
	WaitMovement
	ReleaseAll
	End
	End
	
SeafoamIslands_B4F_cv_Currents_1:
	LockAll
	GetPlayerCoords 0x8008, 0x8009
	CompareVarToValue 0x8008, 32
	GoToIfEq SeafoamIslands_B4F_cv_Currents_1_x32
	CompareVarToValue 0x8008, 33
	GoToIfEq SeafoamIslands_B4F_cv_Currents_1_x33
	CompareVarToValue 0x8008, 34
	GoToIfEq SeafoamIslands_B4F_cv_Currents_1_x34
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Currents_1_x32:
	CompareVarToValue 0x8009, 27
	GoToIfEq SeafoamIslands_B4F_cv_Current_32_27
	CompareVarToValue 0x8009, 28
	GoToIfEq SeafoamIslands_B4F_cv_Current_32_28
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Currents_1_x33:
	CompareVarToValue 0x8009, 27
	GoToIfEq SeafoamIslands_B4F_cv_Current_33_27
	CompareVarToValue 0x8009, 28
	GoToIfEq SeafoamIslands_B4F_cv_Current_33_28
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Currents_1_x34:
	CompareVarToValue 0x8009, 27
	GoToIfEq SeafoamIslands_B4F_cv_Current_34_27
	CompareVarToValue 0x8009, 28
	GoToIfEq SeafoamIslands_B4F_cv_Current_34_28
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_32_27:
	CompareVarToValue 0x5046, 1
	GoToIfEq SeafoamIslands_B4F_cv_Current_32_27_calm
	ApplyMovement obj_player, _cv_current_1
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_32_27_calm:
	ApplyMovement obj_player, _cv_current_1
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_32_28:
	CompareVarToValue 0x5046, 1
	GoToIfEq SeafoamIslands_B4F_cv_Current_32_28_calm
	ApplyMovement obj_player, _cv_current_2
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_32_28_calm:
	ApplyMovement obj_player, _cv_current_2
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_33_27:
	CompareVarToValue 0x5046, 1
	GoToIfEq SeafoamIslands_B4F_cv_Current_33_27_calm
	ApplyMovement obj_player, _cv_current_1
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_33_27_calm:
	ApplyMovement obj_player, _cv_current_1
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_33_28:
	CompareVarToValue 0x5046, 1
	GoToIfEq SeafoamIslands_B4F_cv_Current_33_28_calm
	ApplyMovement obj_player, _cv_current_2
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_33_28_calm:
	ApplyMovement obj_player, _cv_current_2
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_34_27:
	CompareVarToValue 0x5046, 1
	GoToIfEq SeafoamIslands_B4F_cv_Current_34_27_calm
	ApplyMovement obj_player, _cv_current_1
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_34_27_calm:
	ApplyMovement obj_player, _cv_current_1
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_34_28:
	CompareVarToValue 0x5046, 1
	GoToIfEq SeafoamIslands_B4F_cv_Current_34_28_calm
	ApplyMovement obj_player, _cv_current_2
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B4F_cv_Current_34_28_calm:
	ApplyMovement obj_player, _cv_current_2
	WaitMovement
	ReleaseAll
	End
	End
	
SeafoamIslands_B4F_OnTransition:
	CallIfUnset 0x217F, SeafoamIslands_B4F_EventScript_ShowArticuno
	CallIfUnset 0x2111, SeafoamIslands_B4F_EventScript_CheckStoppedCurrent
	CallIfSet 0x2111, SeafoamIslands_B4F_EventScript_SetNoCurrentLayout
	End
	
SeafoamIslands_B4F_OnResume:
	CallIfSet 0x2032, SeafoamIslands_B4F_EventScript_TryRemoveArticuno
	End
	
SeafoamIslands_B4F_OnLoad:
	SetVar 0x4002, 0
	CallIfUnset 0x211E, SeafoamIslands_B4F_EventScript_AddBoulderPresent
	CallIfUnset 0x211F, SeafoamIslands_B4F_EventScript_AddBoulderPresent
	CompareVarToValue 0x4002, 2
	GoToIfEq SeafoamIslands_B4F_EventScript_SetCalmWaterNearStairs
	End
	
SeafoamIslands_B4F_EventScript_EnterOnCurrent:
	LockAll
	SetAvatarBits 4
	UpdateAvatarState
	ApplyMovement obj_player, SeafoamIslands_B4F_Movement_EnterOnCurrent
	WaitMovement
	SetVar 0x503C, 0
	ReleaseAll
	End
	
SeafoamIslands_B4F_EventScript_EnterByFalling:
	LockAll
	SetAvatarBits 4
	UpdateAvatarState
	SetVar 0x4002, 0
	CallIfUnset 0x211E, SeafoamIslands_B4F_EventScript_AddBoulderPresent
	CallIfUnset 0x211F, SeafoamIslands_B4F_EventScript_AddBoulderPresent
	CompareVarToValue 0x4002, 2
	GoToIfEq SeafoamIslands_B4F_EventScript_CurrentBlocked
	GetPlayerCoords 0x8008, 0x8009
	CompareVarToValue 0x8008, 28
	GoToIfLt _cv_unwiden_4
	CompareVarToValue 0x8008, 29
	GoToIfLt _cv_unwiden_5
	SubVar 0x8008, 1
	GoTo _cv_unwiden_4
_cv_unwiden_5:
	SetVar 0x8008, 28
_cv_unwiden_4:
	CompareVarToValue 0x8008, 24
	GoToIfLt _cv_unwiden_6
	CompareVarToValue 0x8008, 25
	GoToIfLt _cv_unwiden_7
	SubVar 0x8008, 1
	GoTo _cv_unwiden_6
_cv_unwiden_7:
	SetVar 0x8008, 24
_cv_unwiden_6:
	CompareVarToValue 0x8008, 20
	GoToIfLt _cv_unwiden_8
	CompareVarToValue 0x8008, 21
	GoToIfLt _cv_unwiden_9
	SubVar 0x8008, 1
	GoTo _cv_unwiden_8
_cv_unwiden_9:
	SetVar 0x8008, 20
_cv_unwiden_8:
	CompareVarToValue 0x8008, 17
	GoToIfLt _cv_unwiden_10
	CompareVarToValue 0x8008, 18
	GoToIfLt _cv_unwiden_11
	SubVar 0x8008, 1
	GoTo _cv_unwiden_10
_cv_unwiden_11:
	SetVar 0x8008, 17
_cv_unwiden_10:
	CompareVarToValue 0x8008, 11
	GoToIfLt _cv_unwiden_12
	CompareVarToValue 0x8008, 12
	GoToIfLt _cv_unwiden_13
	SubVar 0x8008, 1
	GoTo _cv_unwiden_12
_cv_unwiden_13:
	SetVar 0x8008, 11
_cv_unwiden_12:
	CompareVarToValue 0x8008, 6
	GoToIfLt _cv_unwiden_14
	CompareVarToValue 0x8008, 7
	GoToIfLt _cv_unwiden_15
	SubVar 0x8008, 1
	GoTo _cv_unwiden_14
_cv_unwiden_15:
	SetVar 0x8008, 6
_cv_unwiden_14:
	CompareVarToValue 0x8009, 24
	GoToIfLt _cv_unwiden_16
	CompareVarToValue 0x8009, 25
	GoToIfLt _cv_unwiden_17
	SubVar 0x8009, 1
	GoTo _cv_unwiden_16
_cv_unwiden_17:
	SetVar 0x8009, 24
_cv_unwiden_16:
	CompareVarToValue 0x8009, 21
	GoToIfLt _cv_unwiden_18
	CompareVarToValue 0x8009, 23
	GoToIfLt _cv_unwiden_19
	SubVar 0x8009, 2
	GoTo _cv_unwiden_18
_cv_unwiden_19:
	SetVar 0x8009, 21
_cv_unwiden_18:
	CompareVarToValue 0x8009, 15
	GoToIfLt _cv_unwiden_20
	CompareVarToValue 0x8009, 16
	GoToIfLt _cv_unwiden_21
	SubVar 0x8009, 1
	GoTo _cv_unwiden_20
_cv_unwiden_21:
	SetVar 0x8009, 15
_cv_unwiden_20:
	CompareVarToValue 0x8009, 8
	GoToIfLt _cv_unwiden_22
	CompareVarToValue 0x8009, 10
	GoToIfLt _cv_unwiden_23
	SubVar 0x8009, 2
	GoTo _cv_unwiden_22
_cv_unwiden_23:
	SetVar 0x8009, 8
_cv_unwiden_22:
	CompareVarToValue 0x8009, 4
	GoToIfLt _cv_unwiden_24
	CompareVarToValue 0x8009, 5
	GoToIfLt _cv_unwiden_25
	SubVar 0x8009, 1
	GoTo _cv_unwiden_24
_cv_unwiden_25:
	SetVar 0x8009, 4
_cv_unwiden_24:
	CompareVarToValue 0x8008, 9
	CallIfLt SeafoamIslands_B4F_EventScript_RideCurrentFar
	CompareVarToValue 0x8008, 9
	CallIfGe SeafoamIslands_B4F_EventScript_RideCurrentClose
	SetAvatarBits 1
	UpdateAvatarState
	ApplyMovement obj_player, _cv_hop_off_North
	WaitMovement
	SetVar 0x4001, 0
	ReleaseAll
	End
	
SeafoamIslands_B4F_cv_Arrive:
	SetVar 0x400E, 1
	GetPlayerCoords 0x8008, 0x8009
	CompareVarToValue 0x8008, 9
	GoToIfNe SeafoamIslands_B4F_cv_Arrive_0
	CompareVarToValue 0x8009, 23
	GoToIfNe SeafoamIslands_B4F_cv_Arrive_0
	SetVar 0x4001, 1
	End
SeafoamIslands_B4F_cv_Arrive_0:
	CompareVarToValue 0x8008, 10
	GoToIfNe SeafoamIslands_B4F_cv_Arrive_1
	CompareVarToValue 0x8009, 23
	GoToIfNe SeafoamIslands_B4F_cv_Arrive_1
	SetVar 0x4001, 1
	End
SeafoamIslands_B4F_cv_Arrive_1:
	End
	End
	
SeafoamIslands_B4F_EventScript_DefeatedArticuno:
	SetFlag 0x217F
	GoTo EventScript_RemoveStaticMon
	End
	
SeafoamIslands_B4F_EventScript_RanFromArticuno:
	SetVar 0x8004, SPECIES_ARTICUNO
	GoTo EventScript_MonFlewAway
	End
	
SeafoamIslands_B4F_EventScript_ShowArticuno:
	ClearFlag 0x2180
	Return
	
SeafoamIslands_B4F_EventScript_CheckStoppedCurrent:
	SetVar 0x4002, 0
	CallIfUnset 0x211E, SeafoamIslands_B4F_EventScript_AddBoulderPresent
	CallIfUnset 0x211F, SeafoamIslands_B4F_EventScript_AddBoulderPresent
	CompareVarToValue 0x4002, 2
	CallIfEq SeafoamIslands_B4F_EventScript_StoppedCurrent
	Return
	
SeafoamIslands_B4F_EventScript_SetNoCurrentLayout:
	SetVar 0x5046, 1
	Return
	
SeafoamIslands_B4F_EventScript_TryRemoveArticuno:
	GetStaticEncounterOutcome 0x401C
	CompareVarToValue 0x401C, 4
	GoToIfNe _cv_outcome_26
	SetVar 0x401C, 7
	GoTo _cv_outcome_27
_cv_outcome_26:
	CompareVarToValue 0x401C, 5
	GoToIfNe _cv_outcome_27
	SetVar 0x401C, 4
_cv_outcome_27:
	CompareVarToValue 0x401C, 7
	GoToIfNe Common_EventScript_NopReturn
	HidePerson 0x401D
	Return
	
SeafoamIslands_B4F_EventScript_AddBoulderPresent:
	AddVar 0x4002, 1
	Return
	
SeafoamIslands_B4F_EventScript_SetCalmWaterNearStairs:
	// (the GBA redraws a square here: 12, 14, METATILE_GeneralFrlg_CalmWater, 0)
	// (the GBA redraws a square here: 13, 14, METATILE_GeneralFrlg_CalmWater, 0)
	End
	
SeafoamIslands_B4F_EventScript_CurrentBlocked:
	SetVar 0x4001, 0
	ReleaseAll
	End
	
SeafoamIslands_B4F_EventScript_RideCurrentFar:
	ApplyMovement obj_player, SeafoamIslands_B4F_Movement_RideCurrentFar
	WaitMovement
	Return
	
SeafoamIslands_B4F_EventScript_RideCurrentClose:
	ApplyMovement obj_player, SeafoamIslands_B4F_Movement_RideCurrentClose
	WaitMovement
	Return
	
EventScript_RemoveStaticMon:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	HidePerson VAR_SPECIAL_LAST_TALKED
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	ReleaseAll
	End
	
EventScript_MonFlewAway:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	HidePerson VAR_SPECIAL_LAST_TALKED
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	BufferSpeciesName 0, 0x8004, 0, 0
	NPCMsg msg_0884_CV_CANVAS_SEAFOAM_B4F_Text_MonFlewAway
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SeafoamIslands_B4F_EventScript_StoppedCurrent:
	SetFlag 0x2111
	Return
	
Common_EventScript_NopReturn:
	Return

_cv_stop:
	NPCMsg msg_0884_CV_CANVAS_SEAFOAM_B4F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
_cv_current_0:
	WalkFastNorth
	EndMovement

	.balign 4, 0
_cv_current_1:
	WalkFastNorth 2
	EndMovement

	.balign 4, 0
_cv_current_2:
	WalkFastNorth 3
	EndMovement

	.balign 4, 0
_cv_current_3:
	WalkFastNorth 4
	EndMovement

	.balign 4, 0
_cv_current_4:
	WalkFastNorth 5
	EndMovement

	.balign 4, 0
_cv_current_5:
	WalkFastEast 11
	WalkFastNorth 5
	EndMovement

	.balign 4, 0
_cv_current_6:
	WalkFastEast 10
	WalkFastNorth 5
	EndMovement

	.balign 4, 0
_cv_current_7:
	WalkFastEast 9
	WalkFastNorth 5
	EndMovement

	.balign 4, 0
_cv_current_8:
	WalkFastEast 8
	WalkFastNorth 5
	EndMovement

	.balign 4, 0
_cv_current_9:
	WalkFastEast 7
	WalkFastNorth 5
	EndMovement

	.balign 4, 0
_cv_current_10:
	WalkFastEast 6
	WalkFastNorth 5
	EndMovement

	.balign 4, 0
_cv_current_11:
	WalkFastEast 5
	WalkFastNorth 5
	EndMovement

	.balign 4, 0
_cv_current_12:
	WalkFastEast 4
	WalkFastNorth 5
	EndMovement

	.balign 4, 0
_cv_current_13:
	WalkFastEast 3
	WalkFastNorth 5
	EndMovement

	.balign 4, 0
_cv_current_14:
	WalkFastEast 2
	WalkFastNorth 5
	EndMovement

	.balign 4, 0
_cv_current_15:
	WalkFastEast
	WalkFastNorth 5
	EndMovement

	.balign 4, 0
_cv_current_16:
	WalkFastNorth 6
	EndMovement

	.balign 4, 0
_cv_current_17:
	WalkFastNorth
	WalkFastEast 11
	WalkFastNorth 5
	EndMovement

	.balign 4, 0
_cv_current_18:
	WalkFastEast 11
	WalkFastNorth 6
	EndMovement

	.balign 4, 0
_cv_current_19:
	WalkFastEast 10
	WalkFastNorth 6
	EndMovement

	.balign 4, 0
_cv_current_20:
	WalkFastEast 9
	WalkFastNorth 6
	EndMovement

	.balign 4, 0
_cv_current_21:
	WalkFastEast 8
	WalkFastNorth 6
	EndMovement

	.balign 4, 0
_cv_current_22:
	WalkFastEast 7
	WalkFastNorth 6
	EndMovement

	.balign 4, 0
_cv_current_23:
	WalkFastEast 6
	WalkFastNorth 6
	EndMovement

	.balign 4, 0
_cv_current_24:
	WalkFastEast 5
	WalkFastNorth 6
	EndMovement

	.balign 4, 0
_cv_current_25:
	WalkFastEast 4
	WalkFastNorth 6
	EndMovement

	.balign 4, 0
_cv_current_26:
	WalkFastEast 3
	WalkFastNorth 6
	EndMovement

	.balign 4, 0
_cv_current_27:
	WalkFastEast 2
	WalkFastNorth 6
	EndMovement

	.balign 4, 0
_cv_current_28:
	WalkFastEast
	WalkFastNorth 6
	EndMovement

	.balign 4, 0
_cv_current_29:
	WalkFastNorth 7
	EndMovement

	.balign 4, 0
_cv_current_30:
	WalkFastNorth 2
	WalkFastEast 11
	WalkFastNorth 5
	EndMovement

	.balign 4, 0
_cv_current_31:
	WalkFastNorth
	WalkFastEast 11
	WalkFastNorth 6
	EndMovement

	.balign 4, 0
_cv_current_32:
	WalkFastNorth
	WalkFastEast 10
	WalkFastNorth 6
	EndMovement

	.balign 4, 0
_cv_current_33:
	WalkFastNorth 8
	EndMovement

	.balign 4, 0
_cv_current_34:
	WalkFastNorth 3
	WalkFastEast 11
	WalkFastNorth 5
	EndMovement

	.balign 4, 0
_cv_current_35:
	WalkFastNorth 2
	WalkFastEast 11
	WalkFastNorth 6
	EndMovement

	.balign 4, 0
_cv_current_36:
	WalkFastNorth 2
	WalkFastEast 10
	WalkFastNorth 6
	EndMovement

	.balign 4, 0
_cv_current_37:
	WalkFastNorth 9
	EndMovement

	.balign 4, 0
_cv_current_38:
	WalkFastNorth 4
	WalkFastEast 11
	WalkFastNorth 5
	EndMovement

	.balign 4, 0
_cv_current_39:
	WalkFastNorth 3
	WalkFastEast 11
	WalkFastNorth 6
	EndMovement

	.balign 4, 0
_cv_current_40:
	WalkFastNorth 3
	WalkFastEast 10
	WalkFastNorth 6
	EndMovement

	.balign 4, 0
_cv_current_41:
	WalkFastNorth 10
	EndMovement

	.balign 4, 0
_cv_current_42:
	WalkFastNorth 5
	WalkFastEast 11
	WalkFastNorth 5
	EndMovement

	.balign 4, 0
_cv_current_43:
	WalkFastNorth 4
	WalkFastEast 11
	WalkFastNorth 6
	EndMovement

	.balign 4, 0
_cv_current_44:
	WalkFastNorth 4
	WalkFastEast 10
	WalkFastNorth 6
	EndMovement

	.balign 4, 0
_cv_current_45:
	WalkFastNorth 11
	EndMovement

	.balign 4, 0
_cv_current_46:
	WalkFastNorth 6
	WalkFastEast 11
	WalkFastNorth 5
	EndMovement

	.balign 4, 0
_cv_current_47:
	WalkFastNorth 5
	WalkFastEast 11
	WalkFastNorth 6
	EndMovement

	.balign 4, 0
_cv_current_48:
	WalkFastNorth 5
	WalkFastEast 10
	WalkFastNorth 6
	EndMovement

	.balign 4, 0
_cv_current_49:
	WalkFastNorth 12
	EndMovement

	.balign 4, 0
_cv_current_50:
	WalkFastNorth 7
	WalkFastEast 11
	WalkFastNorth 5
	EndMovement

	.balign 4, 0
_cv_current_51:
	WalkFastNorth 6
	WalkFastEast 11
	WalkFastNorth 6
	EndMovement

	.balign 4, 0
_cv_current_52:
	WalkFastNorth 6
	WalkFastEast 10
	WalkFastNorth 6
	EndMovement

	.balign 4, 0
_cv_current_53:
	WalkFastNorth 13
	EndMovement

	.balign 4, 0
_cv_current_54:
	WalkFastNorth 8
	WalkFastEast 11
	WalkFastNorth 5
	EndMovement

	.balign 4, 0
_cv_current_55:
	WalkFastNorth 7
	WalkFastEast 11
	WalkFastNorth 6
	EndMovement

	.balign 4, 0
_cv_current_56:
	WalkFastNorth 7
	WalkFastEast 10
	WalkFastNorth 6
	EndMovement

	.balign 4, 0
_cv_current_57:
	WalkFastNorth 14
	EndMovement

	.balign 4, 0
_cv_current_58:
	WalkFastNorth 9
	WalkFastEast 11
	WalkFastNorth 5
	EndMovement

	.balign 4, 0
_cv_current_59:
	WalkFastNorth 8
	WalkFastEast 11
	WalkFastNorth 6
	EndMovement

	.balign 4, 0
_cv_current_60:
	WalkFastNorth 8
	WalkFastEast 10
	WalkFastNorth 6
	EndMovement

	.balign 4, 0
_cv_current_61:
	WalkFastNorth 15
	EndMovement

	.balign 4, 0
_cv_current_62:
	WalkFastNorth 10
	WalkFastEast 11
	WalkFastNorth 5
	EndMovement

	.balign 4, 0
_cv_current_63:
	WalkFastNorth 9
	WalkFastEast 11
	WalkFastNorth 6
	EndMovement

	.balign 4, 0
_cv_current_64:
	WalkFastNorth 9
	WalkFastEast 10
	WalkFastNorth 6
	EndMovement

	.balign 4, 0
_cv_current_65:
	WalkFastNorth 16
	EndMovement

	.balign 4, 0
_cv_current_66:
	WalkFastEast 2
	EndMovement

	.balign 4, 0
_cv_current_67:
	WalkFastEast
	EndMovement

	.balign 4, 0
_cv_current_68:
	WalkFastNorth 17
	EndMovement

	.balign 4, 0
_cv_current_69:
	WalkFastNorth
	WalkFastEast 2
	EndMovement

	.balign 4, 0
_cv_current_70:
	WalkFastEast 5
	WalkFastNorth
	EndMovement

	.balign 4, 0
_cv_current_71:
	WalkFastEast 4
	WalkFastNorth
	EndMovement

	.balign 4, 0
_cv_current_72:
	WalkFastEast 3
	WalkFastNorth
	EndMovement

	.balign 4, 0
_cv_current_73:
	WalkFastEast 2
	WalkFastNorth
	EndMovement

	.balign 4, 0
_cv_current_74:
	WalkFastEast
	WalkFastNorth
	EndMovement

	.balign 4, 0
_cv_current_75:
	WalkFastNorth 18
	EndMovement

	.balign 4, 0
_cv_current_76:
	WalkFastNorth 2
	WalkFastEast 2
	EndMovement

	.balign 4, 0
_cv_current_77:
	WalkFastNorth
	WalkFastEast 5
	WalkFastNorth
	EndMovement

	.balign 4, 0
_cv_current_78:
	WalkFastNorth
	WalkFastEast 4
	WalkFastNorth
	EndMovement

	.balign 4, 0
_cv_current_79:
	WalkFastEast 4
	WalkFastNorth 2
	EndMovement

	.balign 4, 0
_cv_current_80:
	WalkFastEast 3
	WalkFastNorth 2
	EndMovement

	.balign 4, 0
_cv_current_81:
	WalkFastEast 2
	WalkFastNorth 2
	EndMovement

	.balign 4, 0
_cv_current_82:
	WalkFastEast
	WalkFastNorth 2
	EndMovement

	.balign 4, 0
_cv_current_83:
	WalkFastNorth 19
	EndMovement

	.balign 4, 0
_cv_current_84:
	WalkFastNorth 3
	WalkFastEast 2
	EndMovement

	.balign 4, 0
_cv_current_85:
	WalkFastNorth 2
	WalkFastEast 5
	WalkFastNorth
	EndMovement

	.balign 4, 0
_cv_current_86:
	WalkFastNorth 2
	WalkFastEast 4
	WalkFastNorth
	EndMovement

	.balign 4, 0
_cv_current_87:
	WalkFastNorth
	WalkFastEast 4
	WalkFastNorth 2
	EndMovement

	.balign 4, 0
_cv_current_88:
	WalkFastNorth
	WalkFastEast 3
	WalkFastNorth 2
	EndMovement

	.balign 4, 0
_cv_current_89:
	WalkFastEast 3
	WalkFastNorth 3
	EndMovement

	.balign 4, 0
_cv_current_90:
	WalkFastEast 2
	WalkFastNorth 3
	EndMovement

	.balign 4, 0
_cv_current_91:
	WalkFastEast
	WalkFastNorth 3
	EndMovement

	.balign 4, 0
_cv_current_92:
	WalkFastNorth 3
	WalkFastEast 5
	WalkFastNorth
	EndMovement

	.balign 4, 0
_cv_current_93:
	WalkFastNorth 3
	WalkFastEast 4
	WalkFastNorth
	EndMovement

	.balign 4, 0
_cv_current_94:
	WalkFastNorth 4
	WalkFastEast 5
	WalkFastNorth
	EndMovement

	.balign 4, 0
_cv_current_95:
	WalkFastNorth 4
	WalkFastEast 4
	WalkFastNorth
	EndMovement

	.balign 4, 0
_cv_current_96:
	WalkFastNorth 5
	WalkFastEast 5
	WalkFastNorth
	EndMovement

	.balign 4, 0
_cv_current_97:
	WalkFastNorth 5
	WalkFastEast 4
	WalkFastNorth
	EndMovement

	.balign 4, 0
_cv_hop_off_North:
	JumpNearFastNorth
	EndMovement

	.balign 4, 0
SeafoamIslands_B4F_Movement_WalkUp:
	WalkNormalNorth
	EndMovement

	.balign 4, 0
SeafoamIslands_B4F_Movement_EnterOnCurrent:
	WalkFastNorth 3
	EndMovement

	.balign 4, 0
SeafoamIslands_B4F_Movement_RideCurrentFar:
	WalkFastNorth 5
	WalkFastEast 5
	WalkFastNorth
	EndMovement

	.balign 4, 0
SeafoamIslands_B4F_Movement_RideCurrentClose:
	WalkFastNorth 5
	WalkFastEast 4
	WalkFastNorth
	EndMovement
	.balign 4, 0
