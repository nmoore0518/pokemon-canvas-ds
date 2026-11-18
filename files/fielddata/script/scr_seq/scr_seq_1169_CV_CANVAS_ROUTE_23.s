#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_ROUTE_23.h"
#include "msgdata/msg/msg_0956_CV_CANVAS_ROUTE_23.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route23_Frlg#world by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route23_EventScript_CascadeBadgeGuard
	ScrDef Route23_EventScript_ThunderBadgeGuard
	ScrDef Route23_EventScript_RainbowBadgeGuard
	ScrDef Route23_EventScript_SoulBadgeGuard
	ScrDef Route23_EventScript_MarshBadgeGuard
	ScrDef Route23_EventScript_VolcanoBadgeGuard
	ScrDef Route23_EventScript_EarthBadgeGuard
	ScrDef Route23_EventScript_VictoryRoadGateSign
	ScrDef _cv_unported_8
	ScrDef _cv_unported_9
	ScrDef _cv_unported_10
	ScrDef _cv_unported_11
	ScrDef _cv_unported_12
	ScrDef _cv_unported_13
	ScrDef _cv_unported_14
	ScrDef Route23_OnTransition
	ScrDefEnd
	
Route23_EventScript_CascadeBadgeGuard:
	LockAll
	FacePlayer
	SetVar 0x4001, 2
	// TODO(gba) bufferstdstring STR_VAR_1, STDSTRING_CASCADE_BADGE
	GoTo _cv_stop
	GoTo Route23_EventScript_BadgeGuard
	End
	
Route23_EventScript_ThunderBadgeGuard:
	LockAll
	FacePlayer
	SetVar 0x4001, 3
	// TODO(gba) bufferstdstring STR_VAR_1, STDSTRING_THUNDER_BADGE
	GoTo _cv_stop
	GoTo Route23_EventScript_BadgeGuard
	End
	
Route23_EventScript_RainbowBadgeGuard:
	LockAll
	FacePlayer
	SetVar 0x4001, 4
	// TODO(gba) bufferstdstring STR_VAR_1, STDSTRING_RAINBOW_BADGE
	GoTo _cv_stop
	GoTo Route23_EventScript_BadgeGuard
	End
	
Route23_EventScript_SoulBadgeGuard:
	LockAll
	FacePlayer
	SetVar 0x4001, 5
	// TODO(gba) bufferstdstring STR_VAR_1, STDSTRING_SOUL_BADGE
	GoTo _cv_stop
	GoTo Route23_EventScript_BadgeGuard
	End
	
Route23_EventScript_MarshBadgeGuard:
	LockAll
	FacePlayer
	SetVar 0x4001, 6
	// TODO(gba) bufferstdstring STR_VAR_1, STDSTRING_MARSH_BADGE
	GoTo _cv_stop
	GoTo Route23_EventScript_BadgeGuard
	End
	
Route23_EventScript_VolcanoBadgeGuard:
	LockAll
	FacePlayer
	SetVar 0x4001, 7
	// TODO(gba) bufferstdstring STR_VAR_1, STDSTRING_VOLCANO_BADGE
	GoTo _cv_stop
	GoTo Route23_EventScript_BadgeGuard
	End
	
Route23_EventScript_EarthBadgeGuard:
	LockAll
	FacePlayer
	SetVar 0x4001, 8
	// TODO(gba) bufferstdstring STR_VAR_1, STDSTRING_EARTH_BADGE
	GoTo _cv_stop
	GoTo Route23_EventScript_BadgeGuard
	End
	
Route23_EventScript_VictoryRoadGateSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0956_CV_CANVAS_ROUTE_23_Route23_Text_VictoryRoadGateSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route23_EventScript_CascadeBadgeGuardTrigger:
	LockAll
	SetVar 0x4001, 2
	SetVar 0x8009, 1
	// TODO(gba) bufferstdstring STR_VAR_1, STDSTRING_CASCADE_BADGE
	GoTo _cv_stop
	GoTo Route23_EventScript_BadgeGuardTrigger
	End
	
Route23_EventScript_ThunderBadgeGuardTrigger:
	LockAll
	SetVar 0x4001, 3
	SetVar 0x8009, 2
	// TODO(gba) bufferstdstring STR_VAR_1, STDSTRING_THUNDER_BADGE
	GoTo _cv_stop
	GoTo Route23_EventScript_BadgeGuardTrigger
	End
	
Route23_EventScript_RainbowBadgeGuardTrigger:
	LockAll
	SetVar 0x4001, 4
	SetVar 0x8009, 3
	// TODO(gba) bufferstdstring STR_VAR_1, STDSTRING_RAINBOW_BADGE
	GoTo _cv_stop
	GoTo Route23_EventScript_BadgeGuardTrigger
	End
	
Route23_EventScript_SoulBadgeGuardTrigger:
	LockAll
	SetVar 0x4001, 5
	SetVar 0x8009, 4
	// TODO(gba) bufferstdstring STR_VAR_1, STDSTRING_SOUL_BADGE
	GoTo _cv_stop
	GoTo Route23_EventScript_BadgeGuardTrigger
	End
	
Route23_EventScript_MarshBadgeGuardTrigger:
	LockAll
	SetVar 0x4001, 6
	SetVar 0x8009, 5
	// TODO(gba) bufferstdstring STR_VAR_1, STDSTRING_MARSH_BADGE
	GoTo _cv_stop
	GoTo Route23_EventScript_BadgeGuardTrigger
	End
	
Route23_EventScript_VolcanoBadgeGuardTrigger:
	LockAll
	SetVar 0x4001, 7
	SetVar 0x8009, 6
	// TODO(gba) bufferstdstring STR_VAR_1, STDSTRING_VOLCANO_BADGE
	GoTo _cv_stop
	GoTo Route23_EventScript_BadgeGuardTrigger
	End
	
Route23_EventScript_EarthBadgeGuardTrigger:
	LockAll
	SetVar 0x4001, 8
	SetVar 0x8009, 7
	// TODO(gba) bufferstdstring STR_VAR_1, STDSTRING_EARTH_BADGE
	GoTo _cv_stop
	GoTo Route23_EventScript_BadgeGuardTrigger
	End
	
Route23_OnTransition:
	ClearFlag 0x216F
	SetFlag 0x216B
	SetVar 0x5038, 0
	SetVar 0x5039, 0
	SetVar 0x503A, 0
	SetVar 0x503B, 0
	End
	
Route23_EventScript_BadgeGuard:
	CompareVarToVar 0x5036, 0x4001
	GoToIfGe Route23_EventScript_AlreadyRecognizedBadge
	CompareVarToValue 0x4001, 1
	GoToIfEq Route23_EventScript_CheckBoulderBadge
	CompareVarToValue 0x4001, 2
	GoToIfEq Route23_EventScript_CheckCascadeBadge
	CompareVarToValue 0x4001, 3
	GoToIfEq Route23_EventScript_CheckThunderBadge
	CompareVarToValue 0x4001, 4
	GoToIfEq Route23_EventScript_CheckRainbowBadge
	CompareVarToValue 0x4001, 5
	GoToIfEq Route23_EventScript_CheckSoulBadge
	CompareVarToValue 0x4001, 6
	GoToIfEq Route23_EventScript_CheckMarshBadge
	CompareVarToValue 0x4001, 7
	GoToIfEq Route23_EventScript_CheckVolcanoBadge
	CompareVarToValue 0x4001, 8
	GoToIfEq Route23_EventScript_CheckEarthBadge
	End
	
Route23_EventScript_BadgeGuardTrigger:
	ApplyMovement 0x8009, Common_Movement_WalkInPlaceFasterLeft
	WaitMovement
	CompareVarToValue 0x4001, 1
	GoToIfEq Route23_EventScript_CheckBoulderBadgeTrigger
	CompareVarToValue 0x4001, 2
	GoToIfEq Route23_EventScript_CheckCascadeBadgeTrigger
	CompareVarToValue 0x4001, 3
	GoToIfEq Route23_EventScript_CheckThunderBadgeTrigger
	CompareVarToValue 0x4001, 4
	GoToIfEq Route23_EventScript_CheckRainbowBadgeTrigger
	CompareVarToValue 0x4001, 5
	GoToIfEq Route23_EventScript_CheckSoulBadgeTrigger
	CompareVarToValue 0x4001, 6
	GoToIfEq Route23_EventScript_CheckMarshBadgeTrigger
	CompareVarToValue 0x4001, 7
	GoToIfEq Route23_EventScript_CheckVolcanoBadgeTrigger
	CompareVarToValue 0x4001, 8
	GoToIfEq Route23_EventScript_CheckEarthBadgeTrigger
	End
	
Route23_EventScript_AlreadyRecognizedBadge:
	NPCMsg msg_0956_CV_CANVAS_ROUTE_23_Text_OnlyPassWithBadgeOhGoAhead
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route23_EventScript_CheckBoulderBadge:
	GoToIfSet 0x2088, Route23_EventScript_RecognizeBoulderBadge
	GoTo Route23_EventScript_MissingBoulderBadge
	End
	
Route23_EventScript_CheckCascadeBadge:
	GoToIfSet 0x208B, Route23_EventScript_RecognizeBadge
	GoTo Route23_EventScript_MissingBadge
	End
	
Route23_EventScript_CheckThunderBadge:
	GoToIfSet 0x208C, Route23_EventScript_RecognizeBadge
	GoTo Route23_EventScript_MissingBadge
	End
	
Route23_EventScript_CheckRainbowBadge:
	GoToIfSet 0x208D, Route23_EventScript_RecognizeBadge
	GoTo Route23_EventScript_MissingBadge
	End
	
Route23_EventScript_CheckSoulBadge:
	GoToIfSet 0x208E, Route23_EventScript_RecognizeBadge
	GoTo Route23_EventScript_MissingBadge
	End
	
Route23_EventScript_CheckMarshBadge:
	GoToIfSet 0x208F, Route23_EventScript_RecognizeBadge
	GoTo Route23_EventScript_MissingBadge
	End
	
Route23_EventScript_CheckVolcanoBadge:
	GoToIfSet 0x2090, Route23_EventScript_RecognizeBadge
	GoTo Route23_EventScript_MissingBadge
	End
	
Route23_EventScript_CheckEarthBadge:
	GoToIfSet 0x2151, Route23_EventScript_RecognizeBadge
	GoTo Route23_EventScript_MissingBadge
	End
	
Route23_EventScript_CheckBoulderBadgeTrigger:
	GoToIfSet 0x2088, Route23_EventScript_RecognizeBoulderBadgeTrigger
	GoTo Route23_EventScript_MissingBoulderBadgeTrigger
	End
	
Route23_EventScript_CheckCascadeBadgeTrigger:
	GoToIfSet 0x208B, Route23_EventScript_RecognizeBadgeTrigger
	GoTo Route23_EventScript_MissingBadgeTrigger
	End
	
Route23_EventScript_CheckThunderBadgeTrigger:
	GoToIfSet 0x208C, Route23_EventScript_RecognizeBadgeTrigger
	GoTo Route23_EventScript_MissingBadgeTrigger
	End
	
Route23_EventScript_CheckRainbowBadgeTrigger:
	GoToIfSet 0x208D, Route23_EventScript_RecognizeBadgeTrigger
	GoTo Route23_EventScript_MissingBadgeTrigger
	End
	
Route23_EventScript_CheckSoulBadgeTrigger:
	GoToIfSet 0x208E, Route23_EventScript_RecognizeBadgeTrigger
	GoTo Route23_EventScript_MissingBadgeTrigger
	End
	
Route23_EventScript_CheckMarshBadgeTrigger:
	GoToIfSet 0x208F, Route23_EventScript_RecognizeBadgeTrigger
	GoTo Route23_EventScript_MissingBadgeTrigger
	End
	
Route23_EventScript_CheckVolcanoBadgeTrigger:
	GoToIfSet 0x2090, Route23_EventScript_RecognizeBadgeTrigger
	GoTo Route23_EventScript_MissingBadgeTrigger
	End
	
Route23_EventScript_CheckEarthBadgeTrigger:
	GoToIfSet 0x2151, Route23_EventScript_RecognizeBadgeTrigger
	GoTo Route23_EventScript_MissingBadgeTrigger
	End
	
Route23_EventScript_RecognizeBoulderBadge:
	NPCMsg msg_0956_CV_CANVAS_ROUTE_23_Text_OhThatsBadgeGoRightAhead
	PlayFanfare SEQ_ME_LVUP
	WaitFanfare
	WaitButton
	CopyVar 0x5036, 0x4001
	CloseMsg
	ReleaseAll
	End
	
Route23_EventScript_MissingBoulderBadge:
	NPCMsg msg_0956_CV_CANVAS_ROUTE_23_Text_OnlySkilledTrainersAllowedThrough
	WaitButton
	PlaySE SEQ_SE_DP_SELECT
	NPCMsg msg_0956_CV_CANVAS_ROUTE_23_Text_CantLetYouPass
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route23_EventScript_RecognizeBadge:
	NPCMsg msg_0956_CV_CANVAS_ROUTE_23_Text_OnlyPassWithBadgeOhGoAhead
	WaitButton
	CopyVar 0x5036, 0x4001
	CloseMsg
	ReleaseAll
	End
	
Route23_EventScript_MissingBadge:
	NPCMsg msg_0956_CV_CANVAS_ROUTE_23_Text_OnlyPassWithBadgeDontHaveYet
	PlaySE SEQ_SE_DP_SELECT
	WaitButton
	CloseMsg
	WaitSE SEQ_SE_DP_SELECT
	ReleaseAll
	End
	
Route23_EventScript_RecognizeBoulderBadgeTrigger:
	NPCMsg msg_0956_CV_CANVAS_ROUTE_23_Text_OhThatsBadgeGoRightAhead
	PlayFanfare SEQ_ME_LVUP
	WaitFanfare
	WaitButton
	CopyVar 0x5036, 0x4001
	CloseMsg
	ReleaseAll
	End
	
Route23_EventScript_MissingBoulderBadgeTrigger:
	NPCMsg msg_0956_CV_CANVAS_ROUTE_23_Text_OnlySkilledTrainersAllowedThrough
	WaitButton
	PlaySE SEQ_SE_DP_SELECT
	NPCMsg msg_0956_CV_CANVAS_ROUTE_23_Text_CantLetYouPass
	WaitButton
	CloseMsg
	ApplyMovement obj_player, Route23_Movement_WalkDown
	ApplyMovement 0x8009, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	ReleaseAll
	End
	
Route23_EventScript_RecognizeBadgeTrigger:
	NPCMsg msg_0956_CV_CANVAS_ROUTE_23_Text_OnlyPassWithBadgeOhGoAhead
	WaitButton
	CopyVar 0x5036, 0x4001
	CloseMsg
	ReleaseAll
	End
	
Route23_EventScript_MissingBadgeTrigger:
	NPCMsg msg_0956_CV_CANVAS_ROUTE_23_Text_OnlyPassWithBadgeDontHaveYet
	PlaySE SEQ_SE_DP_SELECT
	WaitButton
	CloseMsg
	WaitSE SEQ_SE_DP_SELECT
	ApplyMovement obj_player, Route23_Movement_WalkDown
	ApplyMovement 0x8009, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	ReleaseAll
	End

_cv_unported_8:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0956_CV_CANVAS_ROUTE_23_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_9:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0956_CV_CANVAS_ROUTE_23_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_10:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0956_CV_CANVAS_ROUTE_23_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_11:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0956_CV_CANVAS_ROUTE_23_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_12:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0956_CV_CANVAS_ROUTE_23_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_13:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0956_CV_CANVAS_ROUTE_23_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_14:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0956_CV_CANVAS_ROUTE_23_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0956_CV_CANVAS_ROUTE_23_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
Common_Movement_WalkInPlaceFasterLeft:
	WalkOnSpotFasterWest
	EndMovement

	.balign 4, 0
Route23_Movement_WalkDown:
	WalkNormalSouth
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterDown:
	WalkOnSpotFasterSouth
	EndMovement
	.balign 4, 0
