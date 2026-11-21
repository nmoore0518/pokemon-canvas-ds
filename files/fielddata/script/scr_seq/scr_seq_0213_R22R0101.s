#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R22R0101.h"
#include "msgdata/msg/msg_0361_R22R0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route22_NorthEntrance_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route22_NorthEntrance_EventScript_BoulderBadgeGuard
	ScrDef Route22_NorthEntrance_EventScript_BoulderBadgeGuardTrigger
	ScrDefEnd
	
Route22_NorthEntrance_EventScript_BoulderBadgeGuard:
	LockAll
	FacePlayer
	SetVar 0x4001, 1
	CanvasBufferMsg 0, msg_0361_R22R0101_cv_std_boulder_badge
	GoTo Route22_NorthEntrance_EventScript_BadgeGuard
	End
	
Route22_NorthEntrance_EventScript_BoulderBadgeGuardTrigger:
	LockAll
	SetVar 0x4001, 1
	SetVar 0x8009, 1
	CanvasBufferMsg 0, msg_0361_R22R0101_cv_std_boulder_badge
	GoTo Route23_EventScript_BadgeGuardTrigger
	End
	
Route22_NorthEntrance_EventScript_BadgeGuard:
	CompareVarToVar 0x5036, 0x4001
	GoToIfGe Route23_EventScript_AlreadyRecognizedBoulderBadge
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
	
Route23_EventScript_AlreadyRecognizedBoulderBadge:
	NPCMsg msg_0361_R22R0101_Text_OhThatsBadgeGoRightAhead
	PlayFanfare SEQ_ME_LVUP
	WaitFanfare
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
	NPCMsg msg_0361_R22R0101_Text_OhThatsBadgeGoRightAhead
	PlayFanfare SEQ_ME_LVUP
	WaitFanfare
	WaitButton
	CopyVar 0x5036, 0x4001
	CloseMsg
	ReleaseAll
	End
	
Route23_EventScript_MissingBoulderBadge:
	NPCMsg msg_0361_R22R0101_Text_OnlySkilledTrainersAllowedThrough
	WaitButton
	PlaySE SEQ_SE_DP_SELECT
	NPCMsg msg_0361_R22R0101_Text_CantLetYouPass
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route23_EventScript_RecognizeBadge:
	NPCMsg msg_0361_R22R0101_Text_OnlyPassWithBadgeOhGoAhead
	WaitButton
	CopyVar 0x5036, 0x4001
	CloseMsg
	ReleaseAll
	End
	
Route23_EventScript_MissingBadge:
	NPCMsg msg_0361_R22R0101_Text_OnlyPassWithBadgeDontHaveYet
	PlaySE SEQ_SE_DP_SELECT
	WaitButton
	CanvasCloseMsg
	WaitSE SEQ_SE_DP_SELECT
	CanvasCloseMsg
	ReleaseAll
	End
	
Route23_EventScript_RecognizeBoulderBadgeTrigger:
	NPCMsg msg_0361_R22R0101_Text_OhThatsBadgeGoRightAhead
	PlayFanfare SEQ_ME_LVUP
	WaitFanfare
	WaitButton
	CopyVar 0x5036, 0x4001
	CloseMsg
	ReleaseAll
	End
	
Route23_EventScript_MissingBoulderBadgeTrigger:
	NPCMsg msg_0361_R22R0101_Text_OnlySkilledTrainersAllowedThrough
	WaitButton
	PlaySE SEQ_SE_DP_SELECT
	NPCMsg msg_0361_R22R0101_Text_CantLetYouPass
	WaitButton
	CanvasCloseMsg
	ApplyMovement obj_player, Route23_Movement_WalkDown
	ApplyMovement 0x8009, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	CanvasCloseMsg
	ReleaseAll
	End
	
Route23_EventScript_RecognizeBadgeTrigger:
	NPCMsg msg_0361_R22R0101_Text_OnlyPassWithBadgeOhGoAhead
	WaitButton
	CopyVar 0x5036, 0x4001
	CloseMsg
	ReleaseAll
	End
	
Route23_EventScript_MissingBadgeTrigger:
	NPCMsg msg_0361_R22R0101_Text_OnlyPassWithBadgeDontHaveYet
	PlaySE SEQ_SE_DP_SELECT
	WaitButton
	CanvasCloseMsg
	WaitSE SEQ_SE_DP_SELECT
	ApplyMovement obj_player, Route23_Movement_WalkDown
	ApplyMovement 0x8009, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	CanvasCloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0361_R22R0101_cv_unported
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
