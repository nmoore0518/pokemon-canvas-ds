#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SEAFOAM_B3F.h"
#include "msgdata/msg/msg_0883_CV_CANVAS_SEAFOAM_B3F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SeafoamIslands_B3F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SeafoamIslands_B3F_Frlg_cv_BoulderFalls
	ScrDef SeafoamIslands_B3F_cv_Currents_0
	ScrDef SeafoamIslands_B3F_OnTransition
	ScrDef SeafoamIslands_B3F_EventScript_EnterByFalling
	ScrDef SeafoamIslands_B3F_cv_Arrive
	ScrDefEnd
	
SeafoamIslands_B3F_Frlg_cv_BoulderFalls:
	PlaySE SEQ_SE_GS_IWAOTOSHI
	CompareVarToValue VAR_SPECIAL_LAST_TALKED, 1
	GoToIfNe _cv_fall_1
	SetFlag 0x2118
	HidePerson VAR_SPECIAL_LAST_TALKED
	WaitSE SEQ_SE_GS_IWAOTOSHI
	End
_cv_fall_1:
	CompareVarToValue VAR_SPECIAL_LAST_TALKED, 2
	GoToIfNe _cv_fall_2
	SetFlag 0x2119
	HidePerson VAR_SPECIAL_LAST_TALKED
	WaitSE SEQ_SE_GS_IWAOTOSHI
	End
_cv_fall_2:
	CompareVarToValue VAR_SPECIAL_LAST_TALKED, 3
	GoToIfNe _cv_fall_3
	SetFlag 0x211C
	ClearFlag 0x211F
	HidePerson VAR_SPECIAL_LAST_TALKED
	WaitSE SEQ_SE_GS_IWAOTOSHI
	End
_cv_fall_3:
	CompareVarToValue VAR_SPECIAL_LAST_TALKED, 4
	GoToIfNe _cv_fall_4
	SetFlag 0x211D
	HidePerson VAR_SPECIAL_LAST_TALKED
	WaitSE SEQ_SE_GS_IWAOTOSHI
	End
_cv_fall_4:
	CompareVarToValue VAR_SPECIAL_LAST_TALKED, 5
	GoToIfNe _cv_fall_5
	SetFlag 0x211B
	HidePerson VAR_SPECIAL_LAST_TALKED
	WaitSE SEQ_SE_GS_IWAOTOSHI
	End
_cv_fall_5:
	CompareVarToValue VAR_SPECIAL_LAST_TALKED, 6
	GoToIfNe _cv_fall_6
	SetFlag 0x211A
	ClearFlag 0x211E
	HidePerson VAR_SPECIAL_LAST_TALKED
	WaitSE SEQ_SE_GS_IWAOTOSHI
	End
_cv_fall_6:
	End
	
SeafoamIslands_B3F_cv_Currents_0:
	LockAll
	GetPlayerCoords 0x8008, 0x8009
	CompareVarToValue 0x8008, 18
	GoToIfEq SeafoamIslands_B3F_cv_Currents_0_x18
	CompareVarToValue 0x8008, 19
	GoToIfEq SeafoamIslands_B3F_cv_Currents_0_x19
	CompareVarToValue 0x8008, 20
	GoToIfEq SeafoamIslands_B3F_cv_Currents_0_x20
	CompareVarToValue 0x8008, 21
	GoToIfEq SeafoamIslands_B3F_cv_Currents_0_x21
	CompareVarToValue 0x8008, 22
	GoToIfEq SeafoamIslands_B3F_cv_Currents_0_x22
	CompareVarToValue 0x8008, 23
	GoToIfEq SeafoamIslands_B3F_cv_Currents_0_x23
	CompareVarToValue 0x8008, 24
	GoToIfEq SeafoamIslands_B3F_cv_Currents_0_x24
	CompareVarToValue 0x8008, 25
	GoToIfEq SeafoamIslands_B3F_cv_Currents_0_x25
	CompareVarToValue 0x8008, 26
	GoToIfEq SeafoamIslands_B3F_cv_Currents_0_x26
	CompareVarToValue 0x8008, 27
	GoToIfEq SeafoamIslands_B3F_cv_Currents_0_x27
	CompareVarToValue 0x8008, 28
	GoToIfEq SeafoamIslands_B3F_cv_Currents_0_x28
	CompareVarToValue 0x8008, 29
	GoToIfEq SeafoamIslands_B3F_cv_Currents_0_x29
	CompareVarToValue 0x8008, 30
	GoToIfEq SeafoamIslands_B3F_cv_Currents_0_x30
	CompareVarToValue 0x8008, 31
	GoToIfEq SeafoamIslands_B3F_cv_Currents_0_x31
	CompareVarToValue 0x8008, 32
	GoToIfEq SeafoamIslands_B3F_cv_Currents_0_x32
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Currents_0_x18:
	CompareVarToValue 0x8009, 5
	GoToIfEq SeafoamIslands_B3F_cv_Current_18_5
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Currents_0_x19:
	CompareVarToValue 0x8009, 5
	GoToIfEq SeafoamIslands_B3F_cv_Current_19_5
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Currents_0_x20:
	CompareVarToValue 0x8009, 5
	GoToIfEq SeafoamIslands_B3F_cv_Current_20_5
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Currents_0_x21:
	CompareVarToValue 0x8009, 5
	GoToIfEq SeafoamIslands_B3F_cv_Current_21_5
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Currents_0_x22:
	CompareVarToValue 0x8009, 5
	GoToIfEq SeafoamIslands_B3F_cv_Current_22_5
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Currents_0_x23:
	CompareVarToValue 0x8009, 5
	GoToIfEq SeafoamIslands_B3F_cv_Current_23_5
	CompareVarToValue 0x8009, 14
	GoToIfEq SeafoamIslands_B3F_cv_Current_23_14
	CompareVarToValue 0x8009, 15
	GoToIfEq SeafoamIslands_B3F_cv_Current_23_15
	CompareVarToValue 0x8009, 16
	GoToIfEq SeafoamIslands_B3F_cv_Current_23_16
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Currents_0_x24:
	CompareVarToValue 0x8009, 5
	GoToIfEq SeafoamIslands_B3F_cv_Current_24_5
	CompareVarToValue 0x8009, 6
	GoToIfEq SeafoamIslands_B3F_cv_Current_24_6
	CompareVarToValue 0x8009, 16
	GoToIfEq SeafoamIslands_B3F_cv_Current_24_16
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Currents_0_x25:
	CompareVarToValue 0x8009, 5
	GoToIfEq SeafoamIslands_B3F_cv_Current_25_5
	CompareVarToValue 0x8009, 6
	GoToIfEq SeafoamIslands_B3F_cv_Current_25_6
	CompareVarToValue 0x8009, 16
	GoToIfEq SeafoamIslands_B3F_cv_Current_25_16
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Currents_0_x26:
	CompareVarToValue 0x8009, 5
	GoToIfEq SeafoamIslands_B3F_cv_Current_26_5
	CompareVarToValue 0x8009, 6
	GoToIfEq SeafoamIslands_B3F_cv_Current_26_6
	CompareVarToValue 0x8009, 14
	GoToIfEq SeafoamIslands_B3F_cv_Current_26_14
	CompareVarToValue 0x8009, 15
	GoToIfEq SeafoamIslands_B3F_cv_Current_26_15
	CompareVarToValue 0x8009, 16
	GoToIfEq SeafoamIslands_B3F_cv_Current_26_16
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Currents_0_x27:
	CompareVarToValue 0x8009, 5
	GoToIfEq SeafoamIslands_B3F_cv_Current_27_5
	CompareVarToValue 0x8009, 6
	GoToIfEq SeafoamIslands_B3F_cv_Current_27_6
	CompareVarToValue 0x8009, 7
	GoToIfEq SeafoamIslands_B3F_cv_Current_27_7
	CompareVarToValue 0x8009, 8
	GoToIfEq SeafoamIslands_B3F_cv_Current_27_8
	CompareVarToValue 0x8009, 10
	GoToIfEq SeafoamIslands_B3F_cv_Current_27_10
	CompareVarToValue 0x8009, 11
	GoToIfEq SeafoamIslands_B3F_cv_Current_27_11
	CompareVarToValue 0x8009, 12
	GoToIfEq SeafoamIslands_B3F_cv_Current_27_12
	CompareVarToValue 0x8009, 13
	GoToIfEq SeafoamIslands_B3F_cv_Current_27_13
	CompareVarToValue 0x8009, 14
	GoToIfEq SeafoamIslands_B3F_cv_Current_27_14
	CompareVarToValue 0x8009, 15
	GoToIfEq SeafoamIslands_B3F_cv_Current_27_15
	CompareVarToValue 0x8009, 16
	GoToIfEq SeafoamIslands_B3F_cv_Current_27_16
	CompareVarToValue 0x8009, 17
	GoToIfEq SeafoamIslands_B3F_cv_Current_27_17
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Currents_0_x28:
	CompareVarToValue 0x8009, 5
	GoToIfEq SeafoamIslands_B3F_cv_Current_28_5
	CompareVarToValue 0x8009, 6
	GoToIfEq SeafoamIslands_B3F_cv_Current_28_6
	CompareVarToValue 0x8009, 7
	GoToIfEq SeafoamIslands_B3F_cv_Current_28_7
	CompareVarToValue 0x8009, 8
	GoToIfEq SeafoamIslands_B3F_cv_Current_28_8
	CompareVarToValue 0x8009, 10
	GoToIfEq SeafoamIslands_B3F_cv_Current_28_10
	CompareVarToValue 0x8009, 11
	GoToIfEq SeafoamIslands_B3F_cv_Current_28_11
	CompareVarToValue 0x8009, 12
	GoToIfEq SeafoamIslands_B3F_cv_Current_28_12
	CompareVarToValue 0x8009, 13
	GoToIfEq SeafoamIslands_B3F_cv_Current_28_13
	CompareVarToValue 0x8009, 14
	GoToIfEq SeafoamIslands_B3F_cv_Current_28_14
	CompareVarToValue 0x8009, 15
	GoToIfEq SeafoamIslands_B3F_cv_Current_28_15
	CompareVarToValue 0x8009, 16
	GoToIfEq SeafoamIslands_B3F_cv_Current_28_16
	CompareVarToValue 0x8009, 17
	GoToIfEq SeafoamIslands_B3F_cv_Current_28_17
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Currents_0_x29:
	CompareVarToValue 0x8009, 5
	GoToIfEq SeafoamIslands_B3F_cv_Current_29_5
	CompareVarToValue 0x8009, 6
	GoToIfEq SeafoamIslands_B3F_cv_Current_29_6
	CompareVarToValue 0x8009, 7
	GoToIfEq SeafoamIslands_B3F_cv_Current_29_7
	CompareVarToValue 0x8009, 8
	GoToIfEq SeafoamIslands_B3F_cv_Current_29_8
	CompareVarToValue 0x8009, 10
	GoToIfEq SeafoamIslands_B3F_cv_Current_29_10
	CompareVarToValue 0x8009, 11
	GoToIfEq SeafoamIslands_B3F_cv_Current_29_11
	CompareVarToValue 0x8009, 12
	GoToIfEq SeafoamIslands_B3F_cv_Current_29_12
	CompareVarToValue 0x8009, 13
	GoToIfEq SeafoamIslands_B3F_cv_Current_29_13
	CompareVarToValue 0x8009, 14
	GoToIfEq SeafoamIslands_B3F_cv_Current_29_14
	CompareVarToValue 0x8009, 15
	GoToIfEq SeafoamIslands_B3F_cv_Current_29_15
	CompareVarToValue 0x8009, 16
	GoToIfEq SeafoamIslands_B3F_cv_Current_29_16
	CompareVarToValue 0x8009, 17
	GoToIfEq SeafoamIslands_B3F_cv_Current_29_17
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Currents_0_x30:
	CompareVarToValue 0x8009, 16
	GoToIfEq SeafoamIslands_B3F_cv_Current_30_16
	CompareVarToValue 0x8009, 17
	GoToIfEq SeafoamIslands_B3F_cv_Current_30_17
	CompareVarToValue 0x8009, 18
	GoToIfEq SeafoamIslands_B3F_cv_Current_30_18
	CompareVarToValue 0x8009, 19
	GoToIfEq SeafoamIslands_B3F_cv_Current_30_19
	CompareVarToValue 0x8009, 20
	GoToIfEq SeafoamIslands_B3F_cv_Current_30_20
	CompareVarToValue 0x8009, 21
	GoToIfEq SeafoamIslands_B3F_cv_Current_30_21
	CompareVarToValue 0x8009, 22
	GoToIfEq SeafoamIslands_B3F_cv_Current_30_22
	CompareVarToValue 0x8009, 23
	GoToIfEq SeafoamIslands_B3F_cv_Current_30_23
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Currents_0_x31:
	CompareVarToValue 0x8009, 16
	GoToIfEq SeafoamIslands_B3F_cv_Current_31_16
	CompareVarToValue 0x8009, 17
	GoToIfEq SeafoamIslands_B3F_cv_Current_31_17
	CompareVarToValue 0x8009, 18
	GoToIfEq SeafoamIslands_B3F_cv_Current_31_18
	CompareVarToValue 0x8009, 19
	GoToIfEq SeafoamIslands_B3F_cv_Current_31_19
	CompareVarToValue 0x8009, 20
	GoToIfEq SeafoamIslands_B3F_cv_Current_31_20
	CompareVarToValue 0x8009, 21
	GoToIfEq SeafoamIslands_B3F_cv_Current_31_21
	CompareVarToValue 0x8009, 22
	GoToIfEq SeafoamIslands_B3F_cv_Current_31_22
	CompareVarToValue 0x8009, 23
	GoToIfEq SeafoamIslands_B3F_cv_Current_31_23
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Currents_0_x32:
	CompareVarToValue 0x8009, 16
	GoToIfEq SeafoamIslands_B3F_cv_Current_32_16
	CompareVarToValue 0x8009, 17
	GoToIfEq SeafoamIslands_B3F_cv_Current_32_17
	CompareVarToValue 0x8009, 18
	GoToIfEq SeafoamIslands_B3F_cv_Current_32_18
	CompareVarToValue 0x8009, 19
	GoToIfEq SeafoamIslands_B3F_cv_Current_32_19
	CompareVarToValue 0x8009, 20
	GoToIfEq SeafoamIslands_B3F_cv_Current_32_20
	CompareVarToValue 0x8009, 21
	GoToIfEq SeafoamIslands_B3F_cv_Current_32_21
	CompareVarToValue 0x8009, 22
	GoToIfEq SeafoamIslands_B3F_cv_Current_32_22
	CompareVarToValue 0x8009, 23
	GoToIfEq SeafoamIslands_B3F_cv_Current_32_23
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_18_5:
	ApplyMovement obj_player, _cv_current_0
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_19_5:
	ApplyMovement obj_player, _cv_current_0
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_20_5:
	ApplyMovement obj_player, _cv_current_0
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_21_5:
	ApplyMovement obj_player, _cv_current_0
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_22_5:
	ApplyMovement obj_player, _cv_current_0
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_23_5:
	ApplyMovement obj_player, _cv_current_0
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_23_14:
	ApplyMovement obj_player, _cv_current_5
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_23_15:
	ApplyMovement obj_player, _cv_current_9
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_23_16:
	ApplyMovement obj_player, _cv_current_0
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_24_5:
	GoToIfUnset 0x2118, SeafoamIslands_B3F_cv_Current_24_5_current_b0
	ApplyMovement obj_player, _cv_current_1
	WaitMovement
	SetAvatarBits 1
	UpdateAvatarState
	ApplyMovement obj_player, _cv_hop_off_South
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_24_5_current_b0:
	ApplyMovement obj_player, _cv_current_1
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_24_6:
	GoToIfUnset 0x2118, SeafoamIslands_B3F_cv_Current_24_6_current_b0
	ApplyMovement obj_player, _cv_current_6
	WaitMovement
	SetAvatarBits 1
	UpdateAvatarState
	ApplyMovement obj_player, _cv_hop_off_South
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_24_6_current_b0:
	ApplyMovement obj_player, _cv_current_6
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_24_16:
	ApplyMovement obj_player, _cv_current_0
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_25_5:
	ApplyMovement obj_player, _cv_current_2
	WaitMovement
	SetAvatarBits 1
	UpdateAvatarState
	ApplyMovement obj_player, _cv_hop_off_South
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_25_6:
	GoToIfUnset 0x2118, SeafoamIslands_B3F_cv_Current_25_6_current_b0
	ApplyMovement obj_player, _cv_current_7
	WaitMovement
	SetAvatarBits 1
	UpdateAvatarState
	ApplyMovement obj_player, _cv_hop_off_South
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_25_6_current_b0:
	ApplyMovement obj_player, _cv_current_7
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_25_16:
	ApplyMovement obj_player, _cv_current_0
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_26_5:
	ApplyMovement obj_player, _cv_current_3
	WaitMovement
	SetAvatarBits 1
	UpdateAvatarState
	ApplyMovement obj_player, _cv_hop_off_South
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_26_6:
	GoToIfUnset 0x2118, SeafoamIslands_B3F_cv_Current_26_6_current_b0
	ApplyMovement obj_player, _cv_current_8
	WaitMovement
	SetAvatarBits 1
	UpdateAvatarState
	ApplyMovement obj_player, _cv_hop_off_South
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_26_6_current_b0:
	ApplyMovement obj_player, _cv_current_8
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_26_14:
	ApplyMovement obj_player, _cv_current_5
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_26_15:
	ApplyMovement obj_player, _cv_current_9
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_26_16:
	ApplyMovement obj_player, _cv_current_0
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_27_5:
	ApplyMovement obj_player, _cv_current_4
	WaitMovement
	SetAvatarBits 1
	UpdateAvatarState
	ApplyMovement obj_player, _cv_hop_off_South
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_27_6:
	GoToIfUnset 0x2118, SeafoamIslands_B3F_cv_Current_27_6_current_b0
	ApplyMovement obj_player, _cv_current_9
	WaitMovement
	SetAvatarBits 1
	UpdateAvatarState
	ApplyMovement obj_player, _cv_hop_off_South
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_27_6_current_b0:
	ApplyMovement obj_player, _cv_current_9
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_27_7:
	GoToIfUnset 0x2118, SeafoamIslands_B3F_cv_Current_27_7_current_b0
	ApplyMovement obj_player, _cv_current_0
	WaitMovement
	SetAvatarBits 1
	UpdateAvatarState
	ApplyMovement obj_player, _cv_hop_off_South
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_27_7_current_b0:
	ApplyMovement obj_player, _cv_current_0
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_27_8:
	GoToIfUnset 0x2118, SeafoamIslands_B3F_cv_Current_27_8_current_b0
	SetAvatarBits 1
	UpdateAvatarState
	ApplyMovement obj_player, _cv_hop_off_South
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_27_8_current_b0:
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_27_10:
	ApplyMovement obj_player, _cv_current_10
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_27_11:
	ApplyMovement obj_player, _cv_current_13
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_27_12:
	ApplyMovement obj_player, _cv_current_16
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_27_13:
	ApplyMovement obj_player, _cv_current_19
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_27_14:
	ApplyMovement obj_player, _cv_current_22
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_27_15:
	ApplyMovement obj_player, _cv_current_25
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_27_16:
	ApplyMovement obj_player, _cv_current_28
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_27_17:
	ApplyMovement obj_player, _cv_current_34
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_28_5:
	ApplyMovement obj_player, _cv_current_5
	WaitMovement
	SetAvatarBits 1
	UpdateAvatarState
	ApplyMovement obj_player, _cv_hop_off_South
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_28_6:
	ApplyMovement obj_player, _cv_current_9
	WaitMovement
	SetAvatarBits 1
	UpdateAvatarState
	ApplyMovement obj_player, _cv_hop_off_South
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_28_7:
	ApplyMovement obj_player, _cv_current_0
	WaitMovement
	SetAvatarBits 1
	UpdateAvatarState
	ApplyMovement obj_player, _cv_hop_off_South
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_28_8:
	SetAvatarBits 1
	UpdateAvatarState
	ApplyMovement obj_player, _cv_hop_off_South
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_28_10:
	ApplyMovement obj_player, _cv_current_11
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_28_11:
	ApplyMovement obj_player, _cv_current_14
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_28_12:
	ApplyMovement obj_player, _cv_current_17
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_28_13:
	ApplyMovement obj_player, _cv_current_20
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_28_14:
	ApplyMovement obj_player, _cv_current_23
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_28_15:
	ApplyMovement obj_player, _cv_current_26
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_28_16:
	ApplyMovement obj_player, _cv_current_29
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_28_17:
	ApplyMovement obj_player, _cv_current_35
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_29_5:
	GoToIfUnset 0x2119, SeafoamIslands_B3F_cv_Current_29_5_current_b1
	ApplyMovement obj_player, _cv_current_5
	WaitMovement
	SetAvatarBits 1
	UpdateAvatarState
	ApplyMovement obj_player, _cv_hop_off_South
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_29_5_current_b1:
	ApplyMovement obj_player, _cv_current_5
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_29_6:
	GoToIfUnset 0x2119, SeafoamIslands_B3F_cv_Current_29_6_current_b1
	ApplyMovement obj_player, _cv_current_9
	WaitMovement
	SetAvatarBits 1
	UpdateAvatarState
	ApplyMovement obj_player, _cv_hop_off_South
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_29_6_current_b1:
	ApplyMovement obj_player, _cv_current_9
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_29_7:
	GoToIfUnset 0x2119, SeafoamIslands_B3F_cv_Current_29_7_current_b1
	ApplyMovement obj_player, _cv_current_0
	WaitMovement
	SetAvatarBits 1
	UpdateAvatarState
	ApplyMovement obj_player, _cv_hop_off_South
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_29_7_current_b1:
	ApplyMovement obj_player, _cv_current_0
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_29_8:
	GoToIfUnset 0x2119, SeafoamIslands_B3F_cv_Current_29_8_current_b1
	SetAvatarBits 1
	UpdateAvatarState
	ApplyMovement obj_player, _cv_hop_off_South
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_29_8_current_b1:
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_29_10:
	ApplyMovement obj_player, _cv_current_12
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_29_11:
	ApplyMovement obj_player, _cv_current_15
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_29_12:
	ApplyMovement obj_player, _cv_current_18
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_29_13:
	ApplyMovement obj_player, _cv_current_21
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_29_14:
	ApplyMovement obj_player, _cv_current_24
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_29_15:
	ApplyMovement obj_player, _cv_current_27
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_29_16:
	ApplyMovement obj_player, _cv_current_30
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_29_17:
	ApplyMovement obj_player, _cv_current_36
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_30_16:
	ApplyMovement obj_player, _cv_current_31
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_30_17:
	ApplyMovement obj_player, _cv_current_37
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_30_18:
	ApplyMovement obj_player, _cv_current_40
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_30_19:
	ApplyMovement obj_player, _cv_current_41
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_30_20:
	ApplyMovement obj_player, _cv_current_42
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_30_21:
	ApplyMovement obj_player, _cv_current_5
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_30_22:
	ApplyMovement obj_player, _cv_current_9
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_30_23:
	ApplyMovement obj_player, _cv_current_0
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_31_16:
	ApplyMovement obj_player, _cv_current_32
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_31_17:
	ApplyMovement obj_player, _cv_current_38
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_31_18:
	ApplyMovement obj_player, _cv_current_40
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_31_19:
	ApplyMovement obj_player, _cv_current_41
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_31_20:
	ApplyMovement obj_player, _cv_current_42
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_31_21:
	ApplyMovement obj_player, _cv_current_5
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_31_22:
	ApplyMovement obj_player, _cv_current_9
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_31_23:
	ApplyMovement obj_player, _cv_current_0
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_32_16:
	ApplyMovement obj_player, _cv_current_33
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_32_17:
	ApplyMovement obj_player, _cv_current_39
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_32_18:
	ApplyMovement obj_player, _cv_current_40
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_32_19:
	ApplyMovement obj_player, _cv_current_41
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_32_20:
	ApplyMovement obj_player, _cv_current_42
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_32_21:
	ApplyMovement obj_player, _cv_current_5
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_32_22:
	ApplyMovement obj_player, _cv_current_9
	WaitMovement
	ReleaseAll
	End
SeafoamIslands_B3F_cv_Current_32_23:
	ApplyMovement obj_player, _cv_current_0
	WaitMovement
	ReleaseAll
	End
	End
	
SeafoamIslands_B3F_OnTransition:
	CallIfUnset 0x2110, SeafoamIslands_B3F_EventScript_CheckStoppedCurrent
	CallIfSet 0x2110, SeafoamIslands_B3F_EventScript_SetNoCurrentLayout
	End
	
SeafoamIslands_B3F_EventScript_EnterByFalling:
	LockAll
	SetAvatarBits 4
	UpdateAvatarState
	SetVar 0x4002, 0
	CallIfUnset 0x2118, SeafoamIslands_B3F_EventScript_AddBoulderPresent
	CallIfUnset 0x2119, SeafoamIslands_B3F_EventScript_AddBoulderPresent
	CompareVarToValue 0x4002, 2
	GoToIfEq SeafoamIslands_B3F_EventScript_CurrentBlocked
	GetPlayerCoords 0x8008, 0x8009
	CompareVarToValue 0x8008, 38
	GoToIfLt _cv_unwiden_1
	CompareVarToValue 0x8008, 39
	GoToIfLt _cv_unwiden_2
	SubVar 0x8008, 1
	GoTo _cv_unwiden_1
_cv_unwiden_2:
	SetVar 0x8008, 38
_cv_unwiden_1:
	CompareVarToValue 0x8008, 35
	GoToIfLt _cv_unwiden_3
	CompareVarToValue 0x8008, 36
	GoToIfLt _cv_unwiden_4
	SubVar 0x8008, 1
	GoTo _cv_unwiden_3
_cv_unwiden_4:
	SetVar 0x8008, 35
_cv_unwiden_3:
	CompareVarToValue 0x8008, 30
	GoToIfLt _cv_unwiden_5
	CompareVarToValue 0x8008, 31
	GoToIfLt _cv_unwiden_6
	SubVar 0x8008, 1
	GoTo _cv_unwiden_5
_cv_unwiden_6:
	SetVar 0x8008, 30
_cv_unwiden_5:
	CompareVarToValue 0x8008, 28
	GoToIfLt _cv_unwiden_7
	CompareVarToValue 0x8008, 29
	GoToIfLt _cv_unwiden_8
	SubVar 0x8008, 1
	GoTo _cv_unwiden_7
_cv_unwiden_8:
	SetVar 0x8008, 28
_cv_unwiden_7:
	CompareVarToValue 0x8008, 21
	GoToIfLt _cv_unwiden_9
	CompareVarToValue 0x8008, 22
	GoToIfLt _cv_unwiden_10
	SubVar 0x8008, 1
	GoTo _cv_unwiden_9
_cv_unwiden_10:
	SetVar 0x8008, 21
_cv_unwiden_9:
	CompareVarToValue 0x8008, 13
	GoToIfLt _cv_unwiden_11
	CompareVarToValue 0x8008, 14
	GoToIfLt _cv_unwiden_12
	SubVar 0x8008, 1
	GoTo _cv_unwiden_11
_cv_unwiden_12:
	SetVar 0x8008, 13
_cv_unwiden_11:
	CompareVarToValue 0x8008, 10
	GoToIfLt _cv_unwiden_13
	CompareVarToValue 0x8008, 11
	GoToIfLt _cv_unwiden_14
	SubVar 0x8008, 1
	GoTo _cv_unwiden_13
_cv_unwiden_14:
	SetVar 0x8008, 10
_cv_unwiden_13:
	CompareVarToValue 0x8008, 7
	GoToIfLt _cv_unwiden_15
	CompareVarToValue 0x8008, 8
	GoToIfLt _cv_unwiden_16
	SubVar 0x8008, 1
	GoTo _cv_unwiden_15
_cv_unwiden_16:
	SetVar 0x8008, 7
_cv_unwiden_15:
	CompareVarToValue 0x8009, 18
	GoToIfLt _cv_unwiden_17
	CompareVarToValue 0x8009, 20
	GoToIfLt _cv_unwiden_18
	SubVar 0x8009, 2
	GoTo _cv_unwiden_17
_cv_unwiden_18:
	SetVar 0x8009, 18
_cv_unwiden_17:
	CompareVarToValue 0x8009, 14
	GoToIfLt _cv_unwiden_19
	CompareVarToValue 0x8009, 15
	GoToIfLt _cv_unwiden_20
	SubVar 0x8009, 1
	GoTo _cv_unwiden_19
_cv_unwiden_20:
	SetVar 0x8009, 14
_cv_unwiden_19:
	CompareVarToValue 0x8009, 12
	GoToIfLt _cv_unwiden_21
	CompareVarToValue 0x8009, 13
	GoToIfLt _cv_unwiden_22
	SubVar 0x8009, 1
	GoTo _cv_unwiden_21
_cv_unwiden_22:
	SetVar 0x8009, 12
_cv_unwiden_21:
	CompareVarToValue 0x8009, 10
	GoToIfLt _cv_unwiden_23
	CompareVarToValue 0x8009, 11
	GoToIfLt _cv_unwiden_24
	SubVar 0x8009, 1
	GoTo _cv_unwiden_23
_cv_unwiden_24:
	SetVar 0x8009, 10
_cv_unwiden_23:
	CompareVarToValue 0x8009, 7
	GoToIfLt _cv_unwiden_25
	CompareVarToValue 0x8009, 8
	GoToIfLt _cv_unwiden_26
	SubVar 0x8009, 1
	GoTo _cv_unwiden_25
_cv_unwiden_26:
	SetVar 0x8009, 7
_cv_unwiden_25:
	CompareVarToValue 0x8008, 24
	CallIfLt SeafoamIslands_B3F_EventScript_RideCurrentFar
	CompareVarToValue 0x8008, 24
	CallIfGe SeafoamIslands_B3F_EventScript_RideCurrentClose
	SetVar 0x503C, 1
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	Warp MAP_CANVAS_SEAFOAM_B4F, 0, 33, 28, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	CanvasCloseMsg
	ReleaseAll
	End
	
SeafoamIslands_B3F_cv_Arrive:
	SetVar 0x400E, 1
	GetPlayerCoords 0x8008, 0x8009
	CompareVarToValue 0x8008, 27
	GoToIfNe SeafoamIslands_B3F_cv_Arrive_0
	CompareVarToValue 0x8009, 11
	GoToIfNe SeafoamIslands_B3F_cv_Arrive_0
	SetVar 0x4001, 1
	End
SeafoamIslands_B3F_cv_Arrive_0:
	CompareVarToValue 0x8008, 29
	GoToIfNe SeafoamIslands_B3F_cv_Arrive_1
	CompareVarToValue 0x8009, 11
	GoToIfNe SeafoamIslands_B3F_cv_Arrive_1
	SetVar 0x4001, 1
	End
SeafoamIslands_B3F_cv_Arrive_1:
	End
	End
	
SeafoamIslands_B3F_EventScript_CheckStoppedCurrent:
	SetVar 0x4002, 0
	CallIfUnset 0x2118, SeafoamIslands_B3F_EventScript_AddBoulderPresent
	CallIfUnset 0x2119, SeafoamIslands_B3F_EventScript_AddBoulderPresent
	CompareVarToValue 0x4002, 2
	CallIfEq SeafoamIslands_B3F_EventScript_StoppedCurrent
	Return
	
SeafoamIslands_B3F_EventScript_SetNoCurrentLayout:
	SetVar 0x5045, 1
	Return
	
SeafoamIslands_B3F_EventScript_AddBoulderPresent:
	AddVar 0x4002, 1
	Return
	
SeafoamIslands_B3F_EventScript_CurrentBlocked:
	SetVar 0x4001, 0
	CanvasCloseMsg
	ReleaseAll
	End
	
SeafoamIslands_B3F_EventScript_RideCurrentFar:
	ApplyMovement obj_player, SeafoamIslands_B3F_Movement_RideCurrentFar
	WaitMovement
	Return
	
SeafoamIslands_B3F_EventScript_RideCurrentClose:
	ApplyMovement obj_player, SeafoamIslands_B3F_Movement_RideCurrentClose
	WaitMovement
	Return
	
SeafoamIslands_B3F_EventScript_StoppedCurrent:
	SetFlag 0x2110
	Return

_cv_stop:
	NPCMsg msg_0883_CV_CANVAS_SEAFOAM_B3F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
_cv_current_0:
	WalkFastSouth
	EndMovement

	.balign 4, 0
_cv_current_1:
	WalkFastSouth
	WalkFastEast 3
	WalkFastSouth 2
	EndMovement

	.balign 4, 0
_cv_hop_off_South:
	JumpNearFastSouth
	EndMovement

	.balign 4, 0
_cv_current_2:
	WalkFastEast 3
	WalkFastSouth 3
	EndMovement

	.balign 4, 0
_cv_current_3:
	WalkFastEast 2
	WalkFastSouth 3
	EndMovement

	.balign 4, 0
_cv_current_4:
	WalkFastEast
	WalkFastSouth 3
	EndMovement

	.balign 4, 0
_cv_current_5:
	WalkFastSouth 3
	EndMovement

	.balign 4, 0
_cv_current_6:
	WalkFastEast 3
	WalkFastSouth 2
	EndMovement

	.balign 4, 0
_cv_current_7:
	WalkFastEast 2
	WalkFastSouth 2
	EndMovement

	.balign 4, 0
_cv_current_8:
	WalkFastEast
	WalkFastSouth 2
	EndMovement

	.balign 4, 0
_cv_current_9:
	WalkFastSouth 2
	EndMovement

	.balign 4, 0
_cv_current_10:
	WalkFastSouth 7
	WalkFastEast 5
	WalkFastSouth 7
	EndMovement

	.balign 4, 0
_cv_current_11:
	WalkFastSouth 7
	WalkFastEast 4
	WalkFastSouth 7
	EndMovement

	.balign 4, 0
_cv_current_12:
	WalkFastSouth 7
	WalkFastEast 3
	WalkFastSouth 7
	EndMovement

	.balign 4, 0
_cv_current_13:
	WalkFastSouth 6
	WalkFastEast 5
	WalkFastSouth 7
	EndMovement

	.balign 4, 0
_cv_current_14:
	WalkFastSouth 6
	WalkFastEast 4
	WalkFastSouth 7
	EndMovement

	.balign 4, 0
_cv_current_15:
	WalkFastSouth 6
	WalkFastEast 3
	WalkFastSouth 7
	EndMovement

	.balign 4, 0
_cv_current_16:
	WalkFastSouth 5
	WalkFastEast 5
	WalkFastSouth 7
	EndMovement

	.balign 4, 0
_cv_current_17:
	WalkFastSouth 5
	WalkFastEast 4
	WalkFastSouth 7
	EndMovement

	.balign 4, 0
_cv_current_18:
	WalkFastSouth 5
	WalkFastEast 3
	WalkFastSouth 7
	EndMovement

	.balign 4, 0
_cv_current_19:
	WalkFastSouth 4
	WalkFastEast 5
	WalkFastSouth 7
	EndMovement

	.balign 4, 0
_cv_current_20:
	WalkFastSouth 4
	WalkFastEast 4
	WalkFastSouth 7
	EndMovement

	.balign 4, 0
_cv_current_21:
	WalkFastSouth 4
	WalkFastEast 3
	WalkFastSouth 7
	EndMovement

	.balign 4, 0
_cv_current_22:
	WalkFastSouth 3
	WalkFastEast 5
	WalkFastSouth 7
	EndMovement

	.balign 4, 0
_cv_current_23:
	WalkFastSouth 3
	WalkFastEast 4
	WalkFastSouth 7
	EndMovement

	.balign 4, 0
_cv_current_24:
	WalkFastSouth 3
	WalkFastEast 3
	WalkFastSouth 7
	EndMovement

	.balign 4, 0
_cv_current_25:
	WalkFastSouth 2
	WalkFastEast 5
	WalkFastSouth 7
	EndMovement

	.balign 4, 0
_cv_current_26:
	WalkFastSouth 2
	WalkFastEast 4
	WalkFastSouth 7
	EndMovement

	.balign 4, 0
_cv_current_27:
	WalkFastSouth 2
	WalkFastEast 3
	WalkFastSouth 7
	EndMovement

	.balign 4, 0
_cv_current_28:
	WalkFastSouth
	WalkFastEast 5
	WalkFastSouth 7
	EndMovement

	.balign 4, 0
_cv_current_29:
	WalkFastSouth
	WalkFastEast 4
	WalkFastSouth 7
	EndMovement

	.balign 4, 0
_cv_current_30:
	WalkFastSouth
	WalkFastEast 3
	WalkFastSouth 7
	EndMovement

	.balign 4, 0
_cv_current_31:
	WalkFastEast 3
	EndMovement

	.balign 4, 0
_cv_current_32:
	WalkFastEast 2
	EndMovement

	.balign 4, 0
_cv_current_33:
	WalkFastEast
	EndMovement

	.balign 4, 0
_cv_current_34:
	WalkFastEast 5
	WalkFastSouth 7
	EndMovement

	.balign 4, 0
_cv_current_35:
	WalkFastEast 4
	WalkFastSouth 7
	EndMovement

	.balign 4, 0
_cv_current_36:
	WalkFastEast 3
	WalkFastSouth 7
	EndMovement

	.balign 4, 0
_cv_current_37:
	WalkFastEast 2
	WalkFastSouth 7
	EndMovement

	.balign 4, 0
_cv_current_38:
	WalkFastEast
	WalkFastSouth 7
	EndMovement

	.balign 4, 0
_cv_current_39:
	WalkFastSouth 7
	EndMovement

	.balign 4, 0
_cv_current_40:
	WalkFastSouth 6
	EndMovement

	.balign 4, 0
_cv_current_41:
	WalkFastSouth 5
	EndMovement

	.balign 4, 0
_cv_current_42:
	WalkFastSouth 4
	EndMovement

	.balign 4, 0
SeafoamIslands_B3F_Movement_RideCurrentFar:
	WalkFastSouth 6
	WalkFastEast 5
	WalkFastSouth 7
	EndMovement

	.balign 4, 0
SeafoamIslands_B3F_Movement_RideCurrentClose:
	WalkFastSouth 6
	WalkFastEast 3
	WalkFastSouth 7
	EndMovement
	.balign 4, 0
