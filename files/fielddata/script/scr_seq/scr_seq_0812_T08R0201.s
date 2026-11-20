#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T08R0201.h"
#include "msgdata/msg/msg_0516_T08R0201.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's FuchsiaCity_SafariZone_Entrance_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef FuchsiaCity_SafariZone_Entrance_EventScript_InfoAttendant
	ScrDef FuchsiaCity_SafariZone_Entrance_EventScript_EntryTriggerMid
	ScrDef FuchsiaCity_SafariZone_Entrance_EventScript_EntryTriggerRight
	ScrDef FuchsiaCity_SafariZone_Entrance_EventScript_EntryTriggerLeft
	ScrDef FuchsiaCity_SafariZone_Entrance_EventScript_ExitWarpIn
	ScrDef FuchsiaCity_SafariZone_Entrance_EventScript_ExitEarly
	ScrDef FuchsiaCity_SafariZone_Entrance_EventScript_ExitWalkIn
	ScrDefEnd
	
FuchsiaCity_SafariZone_Entrance_EventScript_InfoAttendant:
	LockAll
	FacePlayer
	NPCMsg msg_0516_T08R0201_FuchsiaCity_SafariZone_Entrance_Text_FirstTimeAtSafariZone
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq FuchsiaCity_SafariZone_Entrance_EventScript_ExplainSafariZone
	NPCMsg msg_0516_T08R0201_FuchsiaCity_SafariZone_Entrance_Text_SorryYoureARegularHere
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_SafariZone_Entrance_EventScript_EntryTriggerMid:
	LockAll
	SetVar 0x4002, 0
	GoTo FuchsiaCity_SafariZone_Entrance_EventScript_AskEnterSafariZone
	End
	
FuchsiaCity_SafariZone_Entrance_EventScript_EntryTriggerRight:
	LockAll
	SetVar 0x4002, 1
	GoTo FuchsiaCity_SafariZone_Entrance_EventScript_AskEnterSafariZone
	End
	
FuchsiaCity_SafariZone_Entrance_EventScript_EntryTriggerLeft:
	LockAll
	SetVar 0x4002, 2
	GoTo FuchsiaCity_SafariZone_Entrance_EventScript_AskEnterSafariZone
	End
	
FuchsiaCity_SafariZone_Entrance_EventScript_ExitWarpIn:
	LockAll
	NPCMsg msg_0516_T08R0201_FuchsiaCity_SafariZone_Entrance_Text_CatchFairShareComeAgain
	WaitButton
	CloseMsg
	ApplyMovement obj_player, FuchsiaCity_SafariZone_Entrance_Movement_Exit
	WaitMovement
	SafariZoneAction 1, 0
	ClearFlag 0x2FFA
	SetVar 0x5034, 0
	ReleaseAll
	End
	
FuchsiaCity_SafariZone_Entrance_EventScript_ExitEarly:
	LockAll
	NPCMsg msg_0516_T08R0201_FuchsiaCity_SafariZone_Entrance_Text_GoingToLeaveSafariZoneEarly
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_3
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_4
_cv_yes_3:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq FuchsiaCity_SafariZone_Entrance_EventScript_ReturnToSafariZone
	NPCMsg msg_0516_T08R0201_FuchsiaCity_SafariZone_Entrance_Text_PleaseReturnSafariBalls
	WaitButton
	CloseMsg
	ApplyMovement obj_player, FuchsiaCity_SafariZone_Entrance_Movement_Exit
	WaitMovement
	SafariZoneAction 1, 0
	ClearFlag 0x2FFA
	SetVar 0x5034, 0
	ReleaseAll
	End
	
FuchsiaCity_SafariZone_Entrance_EventScript_ExitWalkIn:
	LockAll
	ApplyMovement obj_player, FuchsiaCity_SafariZone_Entrance_Movement_ApproachCounter
	WaitMovement
	NPCMsg msg_0516_T08R0201_FuchsiaCity_SafariZone_Entrance_Text_CatchFairShareComeAgain
	WaitButton
	CloseMsg
	ApplyMovement obj_player, FuchsiaCity_SafariZone_Entrance_Movement_Exit2
	WaitMovement
	SafariZoneAction 1, 0
	ClearFlag 0x2FFA
	SetVar 0x5034, 0
	ReleaseAll
	End
	
FuchsiaCity_SafariZone_Entrance_EventScript_ExplainSafariZone:
	NPCMsg msg_0516_T08R0201_FuchsiaCity_SafariZone_Entrance_Text_ExplainSafariZone
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_SafariZone_Entrance_EventScript_AskEnterSafariZone:
	NPCMsg msg_0516_T08R0201_FuchsiaCity_SafariZone_Entrance_Text_WelcomeToSafariZone
	WaitButton
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterRight
	WaitMovement
	ShowMoneyBox 20, 2
	NPCMsg msg_0516_T08R0201_FuchsiaCity_SafariZone_Entrance_Text_PlaySafariGameFor500
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_5
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_6
_cv_yes_5:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_6:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq FuchsiaCity_SafariZone_Entrance_EventScript_TryEnterSafariZone
	NPCMsg msg_0516_T08R0201_FuchsiaCity_SafariZone_Entrance_Text_OkayPleaseComeAgain
	WaitButton
	GoTo FuchsiaCity_SafariZone_Entrance_EventScript_ForcePlayerBack
	CloseMsg
	End
	
FuchsiaCity_SafariZone_Entrance_EventScript_ReturnToSafariZone:
	NPCMsg msg_0516_T08R0201_FuchsiaCity_SafariZone_Entrance_Text_GoodLuck
	WaitButton
	CloseMsg
	ApplyMovement obj_player, FuchsiaCity_SafariZone_Entrance_Movement_ReEnter
	WaitMovement
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	Warp MAP_CANVAS_SAFARI_CENTER, 0, 26, 30, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	End
	
FuchsiaCity_SafariZone_Entrance_EventScript_TryEnterSafariZone:
	Call FuchsiaCity_SafariZone_Entrance_EventScript_CheckSpaceForMons
	HasEnoughMoneyImmediate VAR_SPECIAL_RESULT, 500
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq FuchsiaCity_SafariZone_Entrance_EventScript_NotEnoughMoney
	SubMoneyImmediate 500
	UpdateMoneyBox
	NPCMsg msg_0516_T08R0201_FuchsiaCity_SafariZone_Entrance_Text_ThatllBe500WeOnlyUseSpecialBalls
	WaitButton
	PlayFanfare SEQ_ME_LVUP
	BufferPlayersName 6
	NPCMsg msg_0516_T08R0201_FuchsiaCity_SafariZone_Entrance_Text_PlayerReceived30SafariBalls
	WaitFanfare
	Call EventScript_RestorePrevTextColor
	NPCMsg msg_0516_T08R0201_FuchsiaCity_SafariZone_Entrance_Text_CallYouOnPAWhenYouRunOut
	WaitButton
	CloseMsg
	HideMoneyBox
	CompareVarToValue 0x4002, 0
	CallIfEq FuchsiaCity_SafariZone_Entrance_EventScript_EnterSafariZoneMid
	CompareVarToValue 0x4002, 1
	CallIfEq FuchsiaCity_SafariZone_Entrance_EventScript_EnterSafariZoneRight
	CompareVarToValue 0x4002, 2
	CallIfEq FuchsiaCity_SafariZone_Entrance_EventScript_EnterSafariZoneLeft
	SafariZoneAction 0, 0
	SetFlag 0x2FFA
	SetDynamicWarp MAP_FUCHSIA_PAL_PARK_ENTRANCE, 1, 8, 4, 1
	SetVar 0x5034, 2
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	Warp MAP_CANVAS_SAFARI_CENTER, 0, 26, 30, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	End
	
FuchsiaCity_SafariZone_Entrance_EventScript_ForcePlayerBack:
	CloseMsg
	HideMoneyBox
	ApplyMovement obj_player, FuchsiaCity_SafariZone_Entrance_Movement_ForceBack
	WaitMovement
	ReleaseAll
	End
	
FuchsiaCity_SafariZone_Entrance_EventScript_CheckSpaceForMons:
	GetPartyCount VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 6
	GoToIfNe Common_EventScript_NopReturn
	CountPCEmptySpace VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_pc_7
	SetVar VAR_SPECIAL_RESULT, 1
_cv_pc_7:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Common_EventScript_NopReturn
	NPCMsg msg_0516_T08R0201_Route121_SafariZoneEntrance_Text_PCIsFull
	WaitButton
	GoTo FuchsiaCity_SafariZone_Entrance_EventScript_ForcePlayerBack
	CloseMsg
	End
	
FuchsiaCity_SafariZone_Entrance_EventScript_NotEnoughMoney:
	NPCMsg msg_0516_T08R0201_FuchsiaCity_SafariZone_Entrance_Text_OopsNotEnoughMoney
	WaitButton
	GoTo FuchsiaCity_SafariZone_Entrance_EventScript_ForcePlayerBack
	CloseMsg
	End
	
EventScript_RestorePrevTextColor:
	CopyVar 0x5015, 0x5016
	Return
	
FuchsiaCity_SafariZone_Entrance_EventScript_EnterSafariZoneMid:
	ApplyMovement obj_player, FuchsiaCity_SafariZone_Entrance_Movement_EnterSafariZoneMid
	WaitMovement
	Return
	
FuchsiaCity_SafariZone_Entrance_EventScript_EnterSafariZoneRight:
	ApplyMovement obj_player, FuchsiaCity_SafariZone_Entrance_Movement_EnterSafariZoneRight
	WaitMovement
	Return
	
FuchsiaCity_SafariZone_Entrance_EventScript_EnterSafariZoneLeft:
	ApplyMovement obj_player, FuchsiaCity_SafariZone_Entrance_Movement_EnterSafariZoneLeft
	WaitMovement
	Return
	
Common_EventScript_NopReturn:
	Return

_cv_stop:
	NPCMsg msg_0516_T08R0201_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
FuchsiaCity_SafariZone_Entrance_Movement_Exit:
	WalkNormalSouth 2
	EndMovement

	.balign 4, 0
FuchsiaCity_SafariZone_Entrance_Movement_ApproachCounter:
	WalkNormalSouth
	Delay8
	EndMovement

	.balign 4, 0
FuchsiaCity_SafariZone_Entrance_Movement_Exit2:
	WalkNormalSouth 2
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterRight:
	WalkOnSpotFasterEast
	EndMovement

	.balign 4, 0
FuchsiaCity_SafariZone_Entrance_Movement_ReEnter:
	WalkNormalNorth
	EndMovement

	.balign 4, 0
FuchsiaCity_SafariZone_Entrance_Movement_ForceBack:
	WalkNormalSouth
	EndMovement

	.balign 4, 0
FuchsiaCity_SafariZone_Entrance_Movement_EnterSafariZoneMid:
	WalkNormalNorth 2
	EndMovement

	.balign 4, 0
FuchsiaCity_SafariZone_Entrance_Movement_EnterSafariZoneRight:
	WalkNormalNorth
	WalkNormalWest
	WalkNormalNorth
	EndMovement

	.balign 4, 0
FuchsiaCity_SafariZone_Entrance_Movement_EnterSafariZoneLeft:
	WalkNormalNorth
	WalkNormalEast
	WalkNormalNorth
	EndMovement
	.balign 4, 0
