#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T10R0501.h"
#include "msgdata/msg/msg_0526_T10R0501.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PokemonLeague_LancesRoom_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef PokemonLeague_LancesRoom_EventScript_Lance
	ScrDef PokemonLeague_LancesRoom_OnResume
	ScrDef PokemonLeague_LancesRoom_OnLoad
	ScrDef PokemonLeague_LancesRoom_EventScript_EnterRoom
	ScrDefEnd
	
PokemonLeague_LancesRoom_EventScript_Lance:
	LockAll
	FacePlayer
	GoToIfSet 0x2040, PokemonLeague_LancesRoom_EventScript_PostBattle
	CallIfUnset FLAG_GAME_CLEAR, PokemonLeague_LancesRoom_EventScript_Intro
	CallIfSet FLAG_GAME_CLEAR, PokemonLeague_LancesRoom_EventScript_RematchIntro
	SetFlag 3
	SetFlag 5
	CallIfUnset 0x215C, PokemonLeague_LancesRoom_EventScript_Battle
	CallIfSet 0x215C, PokemonLeague_LancesRoom_EventScript_Rematch
	ClearFlag 5
	GoTo PokemonLeague_LancesRoom_EventScript_DefeatedLance
	End
	
PokemonLeague_LancesRoom_OnResume:
	SetVar 0x4014, 3
	Call PokemonLeague_EventScript_DoLightingEffect
	End
	
PokemonLeague_LancesRoom_OnLoad:
	CompareVarToValue 0x501D, 4
	CallIfEq PokemonLeague_LancesRoom_EventScript_CloseEntry
	CallIfSet 0x2040, PokemonLeague_LancesRoom_EventScript_SetDoorOpen
	End
	
PokemonLeague_LancesRoom_EventScript_EnterRoom:
	LockAll
	ApplyMovement obj_player, PokemonLeague_LancesRoom_Movement_WalkThroughCorridor
	WaitMovement
	SetFlag 2
	Call PokemonLeague_LancesRoom_EventScript_SetEntryClosed
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	SetVar 0x501D, 4
	CanvasCloseMsg
	ReleaseAll
	End
	
PokemonLeague_LancesRoom_EventScript_PostBattle:
	BufferPlayersName 6
	BufferRivalsName 7
	NPCMsg msg_0526_T10R0501_PokemonLeague_LancesRoom_Text_PostBattle
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PokemonLeague_LancesRoom_EventScript_Intro:
	SetVar 0x8009, 11
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_mentor_1
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_mentor_1
	SetVar 0x401F, 1
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_1:
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_mentor_2
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_mentor_2
	SetVar 0x401F, 2
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_2:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_mentor_3
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_mentor_3
	SetVar 0x401F, 3
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_3:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_mentor_4
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_mentor_4
	SetVar 0x401F, 4
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_4:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_mentor_5
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_mentor_5
	SetVar 0x401F, 5
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_5:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_mentor_6
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_mentor_6
	SetVar 0x401F, 6
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_6:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_mentor_7
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_mentor_7
	SetVar 0x401F, 7
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_7:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_mentor_8
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_mentor_8
	SetVar 0x401F, 8
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_8:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_mentor_9
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_mentor_9
	SetVar 0x401F, 9
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_9:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_mentor_10
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_mentor_10
	SetVar 0x401F, 10
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_10:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_mentor_11
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_mentor_11
	SetVar 0x401F, 11
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_11:
	CompareVarToValue 0x8009, 9
	GoToIfNe _cv_mentor_12
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_mentor_12
	SetVar 0x401F, 12
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_12:
	CompareVarToValue 0x8009, 10
	GoToIfNe _cv_mentor_13
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_mentor_13
	SetVar 0x401F, 13
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_13:
	CompareVarToValue 0x8009, 8
	GoToIfNe _cv_mentor_14
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_mentor_14
	SetVar 0x401F, 14
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_14:
	CompareVarToValue 0x8009, 9
	GoToIfNe _cv_mentor_15
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_mentor_15
	SetVar 0x401F, 15
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_15:
	CompareVarToValue 0x8009, 10
	GoToIfNe _cv_mentor_16
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_mentor_16
	SetVar 0x401F, 16
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_16:
	CompareVarToValue 0x8009, 11
	GoToIfNe _cv_mentor_17
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_mentor_17
	SetVar 0x401F, 17
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_17:
	CompareVarToValue 0x8009, 11
	GoToIfNe _cv_mentor_18
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_mentor_18
	SetVar 0x401F, 18
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_18:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymCandidate_EventScript_ShowText4
	BufferPlayersName 6
	NPCMsg msg_0526_T10R0501_PokemonLeague_LancesRoom_Text_Intro
	WaitButton
	Return
	
PokemonLeague_LancesRoom_EventScript_RematchIntro:
	BufferPlayersName 6
	NPCMsg msg_0526_T10R0501_PokemonLeague_LancesRoom_Text_RematchIntro
	WaitButton
	Return
	
PokemonLeague_LancesRoom_EventScript_Battle:
	CanvasCloseMsg
	TrainerBattle 1149, 1149, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_20
	WhiteOut
	End
_cv_won_20:
	SetTrainerFlag 1149
	Return
	
PokemonLeague_LancesRoom_EventScript_Rematch:
	CanvasCloseMsg
	TrainerBattle 1440, 1440, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_22
	WhiteOut
	End
_cv_won_22:
	SetTrainerFlag 1440
	Return
	
PokemonLeague_LancesRoom_EventScript_DefeatedLance:
	SetVar 0x8004, 0
	SetFlag 0x2040
	Call PokemonLeague_EventScript_OpenDoorLance
	BufferPlayersName 6
	BufferRivalsName 7
	NPCMsg msg_0526_T10R0501_PokemonLeague_LancesRoom_Text_PostBattle
	WaitButton
	SetVar 0x8009, 11
	Call GymCandidate_EventScript_EliteFourApprove
	CanvasCloseMsg
	CanvasCloseMsg
	ReleaseAll
	End
	
PokemonLeague_EventScript_DoLightingEffect:
	Return
	
PokemonLeague_LancesRoom_EventScript_CloseEntry:
	ClearFlag FLAG_HIDE_KARENS_ROOM_RETREAT
	Return
	
PokemonLeague_LancesRoom_EventScript_SetDoorOpen:
	SetFlag FLAG_HIDE_KARENS_ROOM_EXIT
	Return
	
PokemonLeague_LancesRoom_EventScript_SetEntryClosed:
	ClearFlag FLAG_HIDE_KARENS_ROOM_RETREAT
	ShowPerson obj_T10R0501_babyboy1_11
	// (the GBA redraws a square here: 5, 14, METATILE_PokemonLeague_Entry_TopLeft_Closed, 1)
	// (the GBA redraws a square here: 6, 14, METATILE_PokemonLeague_Entry_TopMid_Closed, 1)
	// (the GBA redraws a square here: 7, 14, METATILE_PokemonLeague_Entry_TopRight_Closed, 1)
	// (the GBA redraws a square here: 5, 15, METATILE_PokemonLeague_Entry_BottomLeft_Closed, 1)
	// (the GBA redraws a square here: 6, 15, METATILE_PokemonLeague_Entry_BottomMid_Closed, 1)
	// (the GBA redraws a square here: 7, 15, METATILE_PokemonLeague_Entry_BottomRight_Closed, 1)
	// (the GBA redraws a square here: 6, 16, METATILE_PokemonLeague_Floor_ShadeFull_Lance, 0)
	// (the GBA redraws a square here: 7, 16, METATILE_PokemonLeague_Floor_ShadeFull_Lance, 0)
	Return
	
GymCandidate_EventScript_ShowText4:
	Call _cv_str4
	WaitButton
	Return
	
PokemonLeague_EventScript_OpenDoorLance:
	ApplyMovement obj_player, Common_Movement_Delay32
	WaitMovement
	PlaySE SEQ_SE_DP_DOOR
	SetFlag FLAG_HIDE_KARENS_ROOM_EXIT
	HidePerson obj_T10R0501_leag_door2
	HidePerson obj_T10R0501_leag_door2_2
	HidePerson obj_T10R0501_leag_door2_3
	// (the GBA redraws a square here: 6, 4, METATILE_PokemonLeague_Door_Top_Open, 1)
	// (the GBA redraws a square here: 6, 5, METATILE_PokemonLeague_Door_Mid_Open, 0)
	SetFlag 4
	Return
	
GymCandidate_EventScript_EliteFourApprove:
	GoToIfSet 0x215C, GymCandidate_EventScript_Return
	CompareVarToValue 0x8009, 8
	GoToIfNe _cv_next_35
	SetVar 0x401F, 19
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_24
	SetVar 0x401F, 20
	GoTo _cv_done_23
_cv_next_24:
_cv_done_23:
	GoTo _cv_done_34
_cv_next_35:
	CompareVarToValue 0x8009, 9
	GoToIfNe _cv_next_36
	SetVar 0x401F, 21
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_26
	SetVar 0x401F, 22
	GoTo _cv_done_25
_cv_next_26:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_27
	SetVar 0x401F, 23
	GoTo _cv_done_25
_cv_next_27:
_cv_done_25:
	GoTo _cv_done_34
_cv_next_36:
	CompareVarToValue 0x8009, 10
	GoToIfNe _cv_next_37
	SetVar 0x401F, 24
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_29
	SetVar 0x401F, 25
	GoTo _cv_done_28
_cv_next_29:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_30
	SetVar 0x401F, 26
	GoTo _cv_done_28
_cv_next_30:
_cv_done_28:
	GoTo _cv_done_34
_cv_next_37:
	CompareVarToValue 0x8009, 11
	GoToIfNe _cv_next_38
	SetVar 0x401F, 27
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_32
	SetVar 0x401F, 28
	GoTo _cv_done_31
_cv_next_32:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_33
	SetVar 0x401F, 29
	GoTo _cv_done_31
_cv_next_33:
_cv_done_31:
	GoTo _cv_done_34
_cv_next_38:
_cv_done_34:
	Call _cv_str4
	WaitButton
	GoTo GymCandidate_EventScript_Return
	
GymCandidate_EventScript_Return:
	Return

_cv_str4:
	BufferPlayersName 6
	BufferRivalsName 7
	CompareVarToValue 0x401F, 1
	GoToIfNe _cv_str4_0
	NPCMsg msg_0526_T10R0501_cv_mentor_first_rock
	Return
_cv_str4_0:
	CompareVarToValue 0x401F, 2
	GoToIfNe _cv_str4_1
	NPCMsg msg_0526_T10R0501_cv_mentor_first_normal
	Return
_cv_str4_1:
	CompareVarToValue 0x401F, 3
	GoToIfNe _cv_str4_2
	NPCMsg msg_0526_T10R0501_cv_mentor_first_water
	Return
_cv_str4_2:
	CompareVarToValue 0x401F, 4
	GoToIfNe _cv_str4_3
	NPCMsg msg_0526_T10R0501_cv_mentor_first_electric
	Return
_cv_str4_3:
	CompareVarToValue 0x401F, 5
	GoToIfNe _cv_str4_4
	NPCMsg msg_0526_T10R0501_cv_mentor_first_steel
	Return
_cv_str4_4:
	CompareVarToValue 0x401F, 6
	GoToIfNe _cv_str4_5
	NPCMsg msg_0526_T10R0501_cv_mentor_first_grass
	Return
_cv_str4_5:
	CompareVarToValue 0x401F, 7
	GoToIfNe _cv_str4_6
	NPCMsg msg_0526_T10R0501_cv_mentor_first_poison
	Return
_cv_str4_6:
	CompareVarToValue 0x401F, 8
	GoToIfNe _cv_str4_7
	NPCMsg msg_0526_T10R0501_cv_mentor_first_bug
	Return
_cv_str4_7:
	CompareVarToValue 0x401F, 9
	GoToIfNe _cv_str4_8
	NPCMsg msg_0526_T10R0501_cv_mentor_first_psychic
	Return
_cv_str4_8:
	CompareVarToValue 0x401F, 10
	GoToIfNe _cv_str4_9
	NPCMsg msg_0526_T10R0501_cv_mentor_first_fairy
	Return
_cv_str4_9:
	CompareVarToValue 0x401F, 11
	GoToIfNe _cv_str4_10
	NPCMsg msg_0526_T10R0501_cv_mentor_first_fire
	Return
_cv_str4_10:
	CompareVarToValue 0x401F, 12
	GoToIfNe _cv_str4_11
	NPCMsg msg_0526_T10R0501_cv_mentor_first_ground
	Return
_cv_str4_11:
	CompareVarToValue 0x401F, 13
	GoToIfNe _cv_str4_12
	NPCMsg msg_0526_T10R0501_cv_mentor_first_dark
	Return
_cv_str4_12:
	CompareVarToValue 0x401F, 14
	GoToIfNe _cv_str4_13
	NPCMsg msg_0526_T10R0501_cv_mentor_first_ice
	Return
_cv_str4_13:
	CompareVarToValue 0x401F, 15
	GoToIfNe _cv_str4_14
	NPCMsg msg_0526_T10R0501_cv_mentor_first_fighting
	Return
_cv_str4_14:
	CompareVarToValue 0x401F, 16
	GoToIfNe _cv_str4_15
	NPCMsg msg_0526_T10R0501_cv_mentor_first_ghost
	Return
_cv_str4_15:
	CompareVarToValue 0x401F, 17
	GoToIfNe _cv_str4_16
	NPCMsg msg_0526_T10R0501_cv_mentor_first_dragon
	Return
_cv_str4_16:
	CompareVarToValue 0x401F, 18
	GoToIfNe _cv_str4_17
	NPCMsg msg_0526_T10R0501_cv_mentor_first_flying
	Return
_cv_str4_17:
	CompareVarToValue 0x401F, 19
	GoToIfNe _cv_str4_18
	NPCMsg msg_0526_T10R0501_cv_e4_approve_lorelei
	Return
_cv_str4_18:
	CompareVarToValue 0x401F, 20
	GoToIfNe _cv_str4_19
	NPCMsg msg_0526_T10R0501_cv_mentor_approve_ice
	Return
_cv_str4_19:
	CompareVarToValue 0x401F, 21
	GoToIfNe _cv_str4_20
	NPCMsg msg_0526_T10R0501_cv_e4_approve_bruno
	Return
_cv_str4_20:
	CompareVarToValue 0x401F, 22
	GoToIfNe _cv_str4_21
	NPCMsg msg_0526_T10R0501_cv_mentor_approve_ground
	Return
_cv_str4_21:
	CompareVarToValue 0x401F, 23
	GoToIfNe _cv_str4_22
	NPCMsg msg_0526_T10R0501_cv_mentor_approve_fighting
	Return
_cv_str4_22:
	CompareVarToValue 0x401F, 24
	GoToIfNe _cv_str4_23
	NPCMsg msg_0526_T10R0501_cv_e4_approve_agatha
	Return
_cv_str4_23:
	CompareVarToValue 0x401F, 25
	GoToIfNe _cv_str4_24
	NPCMsg msg_0526_T10R0501_cv_mentor_approve_dark
	Return
_cv_str4_24:
	CompareVarToValue 0x401F, 26
	GoToIfNe _cv_str4_25
	NPCMsg msg_0526_T10R0501_cv_mentor_approve_ghost
	Return
_cv_str4_25:
	CompareVarToValue 0x401F, 27
	GoToIfNe _cv_str4_26
	NPCMsg msg_0526_T10R0501_cv_e4_approve_lance
	Return
_cv_str4_26:
	CompareVarToValue 0x401F, 28
	GoToIfNe _cv_str4_27
	NPCMsg msg_0526_T10R0501_cv_mentor_approve_dragon
	Return
_cv_str4_27:
	CompareVarToValue 0x401F, 29
	GoToIfNe _cv_str4_28
	NPCMsg msg_0526_T10R0501_cv_mentor_approve_flying
	Return
_cv_str4_28:
	Return

_cv_stop:
	NPCMsg msg_0526_T10R0501_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
PokemonLeague_LancesRoom_Movement_WalkThroughCorridor:
	WalkNormalNorth 5
	EndMovement

	.balign 4, 0
Common_Movement_Delay32:
	Delay16 2
	EndMovement
	.balign 4, 0
