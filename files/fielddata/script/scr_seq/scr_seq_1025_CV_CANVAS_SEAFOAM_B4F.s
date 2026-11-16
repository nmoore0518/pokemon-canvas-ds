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
	ScrDef SeafoamIslands_B4F_OnTransition
	ScrDef SeafoamIslands_B4F_OnResume
	ScrDef SeafoamIslands_B4F_OnLoad
	ScrDef SeafoamIslands_B4F_EventScript_EnterOnCurrent
	ScrDef _cv_unported_9
	ScrDefEnd
	
SeafoamIslands_B4F_EventScript_Articuno:
	LockAll
	FacePlayer
	// TODO(gba) setwildbattle SPECIES_ARTICUNO, 50
	GoTo _cv_stop
	WaitSE SEQ_SE_DP_SELECT
	PlayCry SPECIES_ARTICUNO, 0
	NPCMsg msg_0884_CV_CANVAS_SEAFOAM_B4F_Text_Gyaoo
	WaitCry
	Wait 10, VAR_SPECIAL_RESULT
	PlayBGM SEQ_GS_GYM
	WaitButton
	SetFlag 0x2032
	// TODO(gba) special BattleSetup_StartLegendaryBattle
	GoTo _cv_stop
	ClearFlag 0x2032
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq _cv_won_1
	SetVar VAR_SPECIAL_RESULT, 2
_cv_won_1:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq SeafoamIslands_B4F_EventScript_DefeatedArticuno
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfEq SeafoamIslands_B4F_EventScript_RanFromArticuno
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfEq SeafoamIslands_B4F_EventScript_RanFromArticuno
	SetFlag 0x217F
	CloseMsg
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
	ApplyMovement obj_player, SeafoamIslands_B4F_Movement_EnterOnCurrent
	WaitMovement
	SetVar 0x503C, 0
	ReleaseAll
	End
	
SeafoamIslands_B4F_EventScript_EnterByFalling:
	LockAll
	SetVar 0x4002, 0
	CallIfUnset 0x211E, SeafoamIslands_B4F_EventScript_AddBoulderPresent
	CallIfUnset 0x211F, SeafoamIslands_B4F_EventScript_AddBoulderPresent
	CompareVarToValue 0x4002, 2
	GoToIfEq SeafoamIslands_B4F_EventScript_CurrentBlocked
	GetPlayerCoords 0x8008, 0x8009
	CompareVarToValue 0x8008, 9
	CallIfLt SeafoamIslands_B4F_EventScript_RideCurrentFar
	CompareVarToValue 0x8008, 9
	CallIfGe SeafoamIslands_B4F_EventScript_RideCurrentClose
	// TODO(gba) special SeafoamIslandsB4F_CurrentDumpsPlayerOnLand
	GoTo _cv_stop
	SetVar 0x4001, 0
	ReleaseAll
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
	// TODO(gba) setmaplayoutindex LAYOUT_SEAFOAM_ISLANDS_B4F_CURRENT_STOPPED
	Return
	
SeafoamIslands_B4F_EventScript_TryRemoveArticuno:
	CheckBattleWon 0x401C
	CompareVarToValue 0x401C, 1
	GoToIfEq _cv_won_2
	SetVar 0x401C, 2
_cv_won_2:
	CompareVarToValue 0x401C, 7
	GoToIfNe Common_EventScript_NopReturn
	HidePerson 0x401D
	Return
	
SeafoamIslands_B4F_EventScript_AddBoulderPresent:
	AddVar 0x4002, 1
	Return
	
SeafoamIslands_B4F_EventScript_SetCalmWaterNearStairs:
	// TODO(gba) setmetatile 12, 14, METATILE_GeneralFrlg_CalmWater, 0
	// TODO(gba) setmetatile 13, 14, METATILE_GeneralFrlg_CalmWater, 0
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

_cv_unported_9:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0884_CV_CANVAS_SEAFOAM_B4F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0884_CV_CANVAS_SEAFOAM_B4F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

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
	WalkNormalNorth 3
	WalkNormalEast 4
	WalkNormalNorth
	EndMovement

	.balign 4, 0
SeafoamIslands_B4F_Movement_RideCurrentClose:
	WalkNormalNorth 3
	WalkNormalEast 3
	WalkNormalNorth
	EndMovement
	.balign 4, 0
