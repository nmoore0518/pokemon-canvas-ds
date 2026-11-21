#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SSANNE_2F.h"
#include "msgdata/msg/msg_0904_CV_CANVAS_SSANNE_2F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SSAnne_2F_Corridor_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SSAnne_2F_Corridor_EventScript_Sailor
	ScrDef SSAnne_2F_Corridor_EventScript_RivalTriggerLeft
	ScrDef SSAnne_2F_Corridor_EventScript_RivalTriggerMid
	ScrDef SSAnne_2F_Corridor_EventScript_RivalTriggerRight
	ScrDefEnd
	
SSAnne_2F_Corridor_EventScript_Sailor:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0904_CV_CANVAS_SSANNE_2F_SSAnne_2F_Corridor_Text_ThisShipIsLuxuryLiner
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SSAnne_2F_Corridor_EventScript_RivalTriggerLeft:
	LockAll
	SetVar 0x4001, 0
	GoTo SSAnne_2F_Corridor_EventScript_RivalTrigger
	End
	
SSAnne_2F_Corridor_EventScript_RivalTriggerMid:
	LockAll
	SetVar 0x4001, 1
	GoTo SSAnne_2F_Corridor_EventScript_RivalTrigger
	End
	
SSAnne_2F_Corridor_EventScript_RivalTriggerRight:
	LockAll
	SetVar 0x4001, 2
	GoTo SSAnne_2F_Corridor_EventScript_RivalTrigger
	End
	
SSAnne_2F_Corridor_EventScript_RivalTrigger:
	PlaySE SEQ_SE_DP_KAIDAN2
	Wait 5, VAR_SPECIAL_RESULT
	PlayBGM SEQ_GS_E_RIVAL1
	GoToIfUnset 0x2060, _cv_show_1
	ClearFlag 0x2060
	ShowPerson 1
	SetFlag 0x2060
	GoTo _cv_shown_2
_cv_show_1:
	ShowPerson 1
_cv_shown_2:
	Wait 10, VAR_SPECIAL_RESULT
	ApplyMovement 1, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	Wait 20, VAR_SPECIAL_RESULT
	CompareVarToValue 0x4001, 0
	CallIfEq SSAnne_2F_Corridor_EventScript_RivalApproachLeft
	CompareVarToValue 0x4001, 1
	CallIfEq SSAnne_2F_Corridor_EventScript_RivalApproachMid
	CompareVarToValue 0x4001, 2
	CallIfEq SSAnne_2F_Corridor_EventScript_RivalApproachRight
	BufferPlayersName 6
	BufferRivalsName 7
	NPCMsg msg_0904_CV_CANVAS_SSANNE_2F_SSAnne_2F_Corridor_Text_RivalIntro
	WaitButton
	SetVar VAR_SPECIAL_LAST_TALKED, 1
	CompareVarToValue 0x5018, 2
	CallIfEq SSAnne_2F_Corridor_EventScript_RivalSquirtle
	CompareVarToValue 0x5018, 1
	CallIfEq SSAnne_2F_Corridor_EventScript_RivalBulbasaur
	CompareVarToValue 0x5018, 0
	CallIfEq SSAnne_2F_Corridor_EventScript_RivalCharmander
	BufferRivalsName 7
	NPCMsg msg_0904_CV_CANVAS_SSANNE_2F_SSAnne_2F_Corridor_Text_RivalPostBattle
	WaitButton
	CanvasCloseMsg
	Wait 10, VAR_SPECIAL_RESULT
	PlayBGM SEQ_GS_E_RIVAL2
	CompareVarToValue 0x4001, 0
	CallIfEq SSAnne_2F_Corridor_EventScript_RivalExitLeft
	CompareVarToValue 0x4001, 1
	CallIfEq SSAnne_2F_Corridor_EventScript_RivalExitMid
	CompareVarToValue 0x4001, 2
	CallIfEq SSAnne_2F_Corridor_EventScript_RivalExitRight
	ResetBGM
	HidePerson 1
	SetFlag 0x2060
	SetVar 0x502A, 1
	CanvasCloseMsg
	ReleaseAll
	End
	
SSAnne_2F_Corridor_EventScript_RivalApproachLeft:
	ApplyMovement 1, SSAnne_2F_Corridor_Movement_RivalApproachLeft
	WaitMovement
	Return
	
SSAnne_2F_Corridor_EventScript_RivalApproachMid:
	ApplyMovement 1, SSAnne_2F_Corridor_Movement_RivalApproachMid
	ApplyMovement obj_player, SSAnne_2F_Corridor_Movement_PlayerFaceRivalMid
	WaitMovement
	Return
	
SSAnne_2F_Corridor_EventScript_RivalApproachRight:
	ApplyMovement obj_player, SSAnne_2F_Corridor_Movement_PlayerFaceRivalRight
	ApplyMovement 1, SSAnne_2F_Corridor_Movement_RivalApproachRight
	WaitMovement
	Return
	
SSAnne_2F_Corridor_EventScript_RivalSquirtle:
	CanvasCheckTeam 7, 0x5019
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_team_not_allowed
	CanvasCloseMsg
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_4
	TrainerBattle 778, 0, 0, 0
	GoTo _cv_battle_3
_cv_next_4:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_5
	TrainerBattle 782, 0, 0, 0
	GoTo _cv_battle_3
_cv_next_5:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_6
	TrainerBattle 776, 0, 0, 0
	GoTo _cv_battle_3
_cv_next_6:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_7
	TrainerBattle 774, 0, 0, 0
	GoTo _cv_battle_3
_cv_next_7:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_8
	TrainerBattle 784, 0, 0, 0
	GoTo _cv_battle_3
_cv_next_8:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_9
	TrainerBattle 779, 0, 0, 0
	GoTo _cv_battle_3
_cv_next_9:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_10
	TrainerBattle 781, 0, 0, 0
	GoTo _cv_battle_3
_cv_next_10:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_11
	TrainerBattle 783, 0, 0, 0
	GoTo _cv_battle_3
_cv_next_11:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_12
	TrainerBattle 777, 0, 0, 0
	GoTo _cv_battle_3
_cv_next_12:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_13
	TrainerBattle 785, 0, 0, 0
	GoTo _cv_battle_3
_cv_next_13:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_14
	TrainerBattle 780, 0, 0, 0
	GoTo _cv_battle_3
_cv_next_14:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_15
	TrainerBattle 775, 0, 0, 0
	GoTo _cv_battle_3
_cv_next_15:
	TrainerBattle 774, 0, 0, 0
_cv_battle_3:
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_16
	WhiteOut
	End
_cv_won_16:
	SetFlag 0x21D3
	Return
	
SSAnne_2F_Corridor_EventScript_RivalBulbasaur:
	CanvasCheckTeam 7, 0x5019
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_team_not_allowed
	CanvasCloseMsg
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_18
	TrainerBattle 778, 0, 0, 0
	GoTo _cv_battle_17
_cv_next_18:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_19
	TrainerBattle 782, 0, 0, 0
	GoTo _cv_battle_17
_cv_next_19:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_20
	TrainerBattle 776, 0, 0, 0
	GoTo _cv_battle_17
_cv_next_20:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_21
	TrainerBattle 774, 0, 0, 0
	GoTo _cv_battle_17
_cv_next_21:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_22
	TrainerBattle 784, 0, 0, 0
	GoTo _cv_battle_17
_cv_next_22:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_23
	TrainerBattle 779, 0, 0, 0
	GoTo _cv_battle_17
_cv_next_23:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_24
	TrainerBattle 781, 0, 0, 0
	GoTo _cv_battle_17
_cv_next_24:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_25
	TrainerBattle 783, 0, 0, 0
	GoTo _cv_battle_17
_cv_next_25:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_26
	TrainerBattle 777, 0, 0, 0
	GoTo _cv_battle_17
_cv_next_26:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_27
	TrainerBattle 785, 0, 0, 0
	GoTo _cv_battle_17
_cv_next_27:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_28
	TrainerBattle 780, 0, 0, 0
	GoTo _cv_battle_17
_cv_next_28:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_29
	TrainerBattle 775, 0, 0, 0
	GoTo _cv_battle_17
_cv_next_29:
	TrainerBattle 774, 0, 0, 0
_cv_battle_17:
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_30
	WhiteOut
	End
_cv_won_30:
	SetFlag 0x21D4
	Return
	
SSAnne_2F_Corridor_EventScript_RivalCharmander:
	CanvasCheckTeam 7, 0x5019
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_team_not_allowed
	CanvasCloseMsg
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_32
	TrainerBattle 778, 0, 0, 0
	GoTo _cv_battle_31
_cv_next_32:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_33
	TrainerBattle 782, 0, 0, 0
	GoTo _cv_battle_31
_cv_next_33:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_34
	TrainerBattle 776, 0, 0, 0
	GoTo _cv_battle_31
_cv_next_34:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_35
	TrainerBattle 774, 0, 0, 0
	GoTo _cv_battle_31
_cv_next_35:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_36
	TrainerBattle 784, 0, 0, 0
	GoTo _cv_battle_31
_cv_next_36:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_37
	TrainerBattle 779, 0, 0, 0
	GoTo _cv_battle_31
_cv_next_37:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_38
	TrainerBattle 781, 0, 0, 0
	GoTo _cv_battle_31
_cv_next_38:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_39
	TrainerBattle 783, 0, 0, 0
	GoTo _cv_battle_31
_cv_next_39:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_40
	TrainerBattle 777, 0, 0, 0
	GoTo _cv_battle_31
_cv_next_40:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_41
	TrainerBattle 785, 0, 0, 0
	GoTo _cv_battle_31
_cv_next_41:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_42
	TrainerBattle 780, 0, 0, 0
	GoTo _cv_battle_31
_cv_next_42:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_43
	TrainerBattle 775, 0, 0, 0
	GoTo _cv_battle_31
_cv_next_43:
	TrainerBattle 774, 0, 0, 0
_cv_battle_31:
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_44
	WhiteOut
	End
_cv_won_44:
	SetFlag 0x21D5
	Return
	
SSAnne_2F_Corridor_EventScript_RivalExitLeft:
	ApplyMovement 1, SSAnne_2F_Corridor_Movement_RivalExitLeft
	WaitMovement
	Return
	
SSAnne_2F_Corridor_EventScript_RivalExitMid:
	ApplyMovement 1, SSAnne_2F_Corridor_Movement_RivalExitMid
	WaitMovement
	Return
	
SSAnne_2F_Corridor_EventScript_RivalExitRight:
	ApplyMovement 1, SSAnne_2F_Corridor_Movement_RivalExitRight
	WaitMovement
	Return
	
EventScript_GymHack_ShowTeamRuleMessage:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq EventScript_GymHack_MsgWrongType
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	CallIfEq EventScript_GymHack_MsgDuplicate
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	CallIfEq EventScript_GymHack_MsgDuplicateItem
	Return
	
EventScript_GymHack_MsgWrongType:
	NPCMsg msg_0904_CV_CANVAS_SSANNE_2F_Text_GymHack_WrongType
	WaitButton
	Return
	
EventScript_GymHack_MsgDuplicate:
	NPCMsg msg_0904_CV_CANVAS_SSANNE_2F_Text_GymHack_Duplicate
	WaitButton
	Return
	
EventScript_GymHack_MsgDuplicateItem:
	NPCMsg msg_0904_CV_CANVAS_SSANNE_2F_Text_GymHack_DuplicateItem
	WaitButton
	Return

_cv_stop:
	NPCMsg msg_0904_CV_CANVAS_SSANNE_2F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_team_not_allowed:
	Call EventScript_GymHack_ShowTeamRuleMessage
	CanvasCloseMsg
	GetPlayerCoords 0x8008, 0x8009
	GetPlayerFacing 0x800A
	Warp MAP_CANVAS_SSANNE_2F, 0, 0x8008, 0x8009, 0x800A
	ReleaseAll
	End

	.balign 4, 0
Common_Movement_WalkInPlaceFasterDown:
	WalkOnSpotFasterSouth
	EndMovement

	.balign 4, 0
SSAnne_2F_Corridor_Movement_RivalApproachLeft:
	WalkNormalSouth 3
	EndMovement

	.balign 4, 0
SSAnne_2F_Corridor_Movement_RivalApproachMid:
	WalkNormalSouth 4
	WalkOnSpotFasterEast
	EndMovement

	.balign 4, 0
SSAnne_2F_Corridor_Movement_PlayerFaceRivalMid:
	Delay16 4
	WalkOnSpotFasterWest
	EndMovement

	.balign 4, 0
SSAnne_2F_Corridor_Movement_PlayerFaceRivalRight:
	Delay16 4
	WalkOnSpotFasterWest
	EndMovement

	.balign 4, 0
SSAnne_2F_Corridor_Movement_RivalApproachRight:
	WalkNormalSouth 4
	WalkNormalEast
	Delay4
	EndMovement

	.balign 4, 0
SSAnne_2F_Corridor_Movement_RivalExitLeft:
	WalkNormalEast
	WalkNormalSouth 7
	EndMovement

	.balign 4, 0
SSAnne_2F_Corridor_Movement_RivalExitMid:
	WalkNormalSouth 7
	EndMovement

	.balign 4, 0
SSAnne_2F_Corridor_Movement_RivalExitRight:
	WalkNormalSouth 7
	EndMovement
	.balign 4, 0
