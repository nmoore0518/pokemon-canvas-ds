#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R22.h"
#include "msgdata/msg/msg_0360_R22.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route22_Frlg#world by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef ViridianCity_EventScript_DreamEaterTutor
	ScrDef Route22_EventScript_LeagueGateSign
	ScrDef Route22_EventScript_EarlyRivalTriggerBottom
	ScrDef Route22_EventScript_LateRivalTriggerBottom
	ScrDefEnd
	
ViridianCity_EventScript_DreamEaterTutor:
	GoTo EventScript_DreamEaterTutor
	End
	
Route22_EventScript_LeagueGateSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0360_R22_Route22_Text_LeagueGateSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route22_EventScript_EarlyRivalTriggerBottom:
	LockAll
	SetVar 0x4001, 2
	MovePerson 15, 992, 287
	GoTo Route22_EventScript_EarlyRival
	End
	
Route22_EventScript_LateRivalTriggerBottom:
	LockAll
	SetVar 0x4001, 2
	MovePerson 15, 992, 287
	GoTo Route22_EventScript_LateRival
	End
	
EventScript_DreamEaterTutor:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0360_R22_Text_DreamEaterTutor_Retired
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route22_EventScript_EarlyRival:
	PlayBGM SEQ_GS_E_RIVAL1
	ShowPerson 15
	CompareVarToValue 0x4001, 0
	CallIfEq Route22_EventScript_EarlyRivalApproach
	CompareVarToValue 0x4001, 1
	CallIfEq Route22_EventScript_EarlyRivalApproach
	CompareVarToValue 0x4001, 2
	CallIfEq Route22_EventScript_EarlyRivalApproachBottom
	Wait 6, VAR_SPECIAL_RESULT
	BufferPlayersName 6
	BufferRivalsName 7
	NPCMsg msg_0360_R22_Route22_Text_EarlyRivalIntro
	WaitButton
	CompareVarToValue 0x5018, 2
	CallIfEq Route22_EventScript_EarlyRivalSquirtle
	CompareVarToValue 0x5018, 1
	CallIfEq Route22_EventScript_EarlyRivalBulbasaur
	CompareVarToValue 0x5018, 0
	CallIfEq Route22_EventScript_EarlyRivalCharmander
	NPCMsg msg_0360_R22_Route22_Text_EarlyRivalPostBattle
	WaitButton
	CanvasCloseMsg
	Wait 10, VAR_SPECIAL_RESULT
	PlayBGM SEQ_GS_E_RIVAL2
	CompareVarToValue 0x4001, 0
	CallIfEq Route22_EventScript_EarlyRivalExit
	CompareVarToValue 0x4001, 1
	CallIfEq Route22_EventScript_EarlyRivalExit
	CompareVarToValue 0x4001, 2
	CallIfEq Route22_EventScript_EarlyRivalExitBottom
	ResetBGM
	HidePerson 15
	SetVar 0x5013, 2
	CanvasCloseMsg
	ReleaseAll
	End
	
Route22_EventScript_LateRival:
	PlayBGM SEQ_GS_E_RIVAL1
	ShowPerson 15
	CompareVarToValue 0x4001, 0
	CallIfEq Route22_EventScript_LateRivalApproach
	CompareVarToValue 0x4001, 1
	CallIfEq Route22_EventScript_LateRivalApproach
	CompareVarToValue 0x4001, 2
	CallIfEq Route22_EventScript_LateRivalApproachBottom
	BufferPlayersName 6
	BufferRivalsName 7
	NPCMsg msg_0360_R22_Route22_Text_LateRivalIntro
	WaitButton
	SetVar VAR_SPECIAL_LAST_TALKED, 1
	CompareVarToValue 0x5018, 2
	CallIfEq Route22_EventScript_LateRivalSquirtle
	CompareVarToValue 0x5018, 1
	CallIfEq Route22_EventScript_LateRivalBulbasaur
	CompareVarToValue 0x5018, 0
	CallIfEq Route22_EventScript_LateRivalCharmander
	BufferPlayersName 6
	NPCMsg msg_0360_R22_Route22_Text_LateRivalPostBattle
	WaitButton
	CanvasCloseMsg
	Wait 10, VAR_SPECIAL_RESULT
	PlayBGM SEQ_GS_E_RIVAL2
	ApplyMovement 15, Route22_Movement_LateRivalExit
	WaitMovement
	ResetBGM
	HidePerson 15
	SetVar 0x5013, 4
	CanvasCloseMsg
	ReleaseAll
	End
	
Route22_EventScript_EarlyRivalApproach:
	ApplyMovement 15, Route22_Movement_RivalApproach
	WaitMovement
	Return
	
Route22_EventScript_EarlyRivalApproachBottom:
	ApplyMovement 15, Route22_Movement_RivalApproachBottom
	ApplyMovement obj_player, Route22_Movement_PlayerFaceRival
	WaitMovement
	Return
	
Route22_EventScript_EarlyRivalSquirtle:
	CanvasCheckTeam 7, 0x5019
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_team_not_allowed
	CanvasCloseMsg
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_2
	TrainerBattle 754, 0, 1, 0
	GoTo _cv_battle_1
_cv_next_2:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_3
	TrainerBattle 758, 0, 1, 0
	GoTo _cv_battle_1
_cv_next_3:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_4
	TrainerBattle 752, 0, 1, 0
	GoTo _cv_battle_1
_cv_next_4:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_5
	TrainerBattle 750, 0, 1, 0
	GoTo _cv_battle_1
_cv_next_5:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_6
	TrainerBattle 760, 0, 1, 0
	GoTo _cv_battle_1
_cv_next_6:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_7
	TrainerBattle 755, 0, 1, 0
	GoTo _cv_battle_1
_cv_next_7:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_8
	TrainerBattle 757, 0, 1, 0
	GoTo _cv_battle_1
_cv_next_8:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_9
	TrainerBattle 759, 0, 1, 0
	GoTo _cv_battle_1
_cv_next_9:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_10
	TrainerBattle 753, 0, 1, 0
	GoTo _cv_battle_1
_cv_next_10:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_11
	TrainerBattle 761, 0, 1, 0
	GoTo _cv_battle_1
_cv_next_11:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_12
	TrainerBattle 756, 0, 1, 0
	GoTo _cv_battle_1
_cv_next_12:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_13
	TrainerBattle 751, 0, 1, 0
	GoTo _cv_battle_1
_cv_next_13:
	TrainerBattle 750, 0, 1, 0
_cv_battle_1:
	SetFlag 0x20AD
	Return
	
Route22_EventScript_EarlyRivalBulbasaur:
	CanvasCheckTeam 7, 0x5019
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_team_not_allowed
	CanvasCloseMsg
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_15
	TrainerBattle 754, 0, 1, 0
	GoTo _cv_battle_14
_cv_next_15:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_16
	TrainerBattle 758, 0, 1, 0
	GoTo _cv_battle_14
_cv_next_16:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_17
	TrainerBattle 752, 0, 1, 0
	GoTo _cv_battle_14
_cv_next_17:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_18
	TrainerBattle 750, 0, 1, 0
	GoTo _cv_battle_14
_cv_next_18:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_19
	TrainerBattle 760, 0, 1, 0
	GoTo _cv_battle_14
_cv_next_19:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_20
	TrainerBattle 755, 0, 1, 0
	GoTo _cv_battle_14
_cv_next_20:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_21
	TrainerBattle 757, 0, 1, 0
	GoTo _cv_battle_14
_cv_next_21:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_22
	TrainerBattle 759, 0, 1, 0
	GoTo _cv_battle_14
_cv_next_22:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_23
	TrainerBattle 753, 0, 1, 0
	GoTo _cv_battle_14
_cv_next_23:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_24
	TrainerBattle 761, 0, 1, 0
	GoTo _cv_battle_14
_cv_next_24:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_25
	TrainerBattle 756, 0, 1, 0
	GoTo _cv_battle_14
_cv_next_25:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_26
	TrainerBattle 751, 0, 1, 0
	GoTo _cv_battle_14
_cv_next_26:
	TrainerBattle 750, 0, 1, 0
_cv_battle_14:
	SetFlag 0x20AE
	Return
	
Route22_EventScript_EarlyRivalCharmander:
	CanvasCheckTeam 7, 0x5019
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_team_not_allowed
	CanvasCloseMsg
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_28
	TrainerBattle 754, 0, 1, 0
	GoTo _cv_battle_27
_cv_next_28:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_29
	TrainerBattle 758, 0, 1, 0
	GoTo _cv_battle_27
_cv_next_29:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_30
	TrainerBattle 752, 0, 1, 0
	GoTo _cv_battle_27
_cv_next_30:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_31
	TrainerBattle 750, 0, 1, 0
	GoTo _cv_battle_27
_cv_next_31:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_32
	TrainerBattle 760, 0, 1, 0
	GoTo _cv_battle_27
_cv_next_32:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_33
	TrainerBattle 755, 0, 1, 0
	GoTo _cv_battle_27
_cv_next_33:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_34
	TrainerBattle 757, 0, 1, 0
	GoTo _cv_battle_27
_cv_next_34:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_35
	TrainerBattle 759, 0, 1, 0
	GoTo _cv_battle_27
_cv_next_35:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_36
	TrainerBattle 753, 0, 1, 0
	GoTo _cv_battle_27
_cv_next_36:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_37
	TrainerBattle 761, 0, 1, 0
	GoTo _cv_battle_27
_cv_next_37:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_38
	TrainerBattle 756, 0, 1, 0
	GoTo _cv_battle_27
_cv_next_38:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_39
	TrainerBattle 751, 0, 1, 0
	GoTo _cv_battle_27
_cv_next_39:
	TrainerBattle 750, 0, 1, 0
_cv_battle_27:
	SetFlag 0x20AF
	Return
	
Route22_EventScript_EarlyRivalExit:
	ApplyMovement 15, Route22_Movement_EarlyRivalExit
	WaitMovement
	Return
	
Route22_EventScript_EarlyRivalExitBottom:
	ApplyMovement 15, Route22_Movement_EarlyRivalExitBottom
	WaitMovement
	Return
	
Route22_EventScript_LateRivalApproach:
	ApplyMovement 15, Route22_Movement_RivalApproach
	WaitMovement
	Return
	
Route22_EventScript_LateRivalApproachBottom:
	ApplyMovement 15, Route22_Movement_RivalApproachBottom
	ApplyMovement obj_player, Route22_Movement_PlayerFaceRival
	WaitMovement
	Return
	
Route22_EventScript_LateRivalSquirtle:
	CanvasCheckTeam 7, 0x5019
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_team_not_allowed
	CanvasCloseMsg
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_41
	TrainerBattle 814, 814, 0, 0
	GoTo _cv_battle_40
_cv_next_41:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_42
	TrainerBattle 818, 818, 0, 0
	GoTo _cv_battle_40
_cv_next_42:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_43
	TrainerBattle 812, 812, 0, 0
	GoTo _cv_battle_40
_cv_next_43:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_44
	TrainerBattle 810, 810, 0, 0
	GoTo _cv_battle_40
_cv_next_44:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_45
	TrainerBattle 820, 820, 0, 0
	GoTo _cv_battle_40
_cv_next_45:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_46
	TrainerBattle 815, 815, 0, 0
	GoTo _cv_battle_40
_cv_next_46:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_47
	TrainerBattle 817, 817, 0, 0
	GoTo _cv_battle_40
_cv_next_47:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_48
	TrainerBattle 819, 819, 0, 0
	GoTo _cv_battle_40
_cv_next_48:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_49
	TrainerBattle 813, 813, 0, 0
	GoTo _cv_battle_40
_cv_next_49:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_50
	TrainerBattle 821, 821, 0, 0
	GoTo _cv_battle_40
_cv_next_50:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_51
	TrainerBattle 816, 816, 0, 0
	GoTo _cv_battle_40
_cv_next_51:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_52
	TrainerBattle 811, 811, 0, 0
	GoTo _cv_battle_40
_cv_next_52:
	TrainerBattle 810, 810, 0, 0
_cv_battle_40:
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_53
	WhiteOut
	End
_cv_won_53:
	SetFlag 0x20B0
	Return
	
Route22_EventScript_LateRivalBulbasaur:
	CanvasCheckTeam 7, 0x5019
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_team_not_allowed
	CanvasCloseMsg
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_55
	TrainerBattle 814, 814, 0, 0
	GoTo _cv_battle_54
_cv_next_55:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_56
	TrainerBattle 818, 818, 0, 0
	GoTo _cv_battle_54
_cv_next_56:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_57
	TrainerBattle 812, 812, 0, 0
	GoTo _cv_battle_54
_cv_next_57:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_58
	TrainerBattle 810, 810, 0, 0
	GoTo _cv_battle_54
_cv_next_58:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_59
	TrainerBattle 820, 820, 0, 0
	GoTo _cv_battle_54
_cv_next_59:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_60
	TrainerBattle 815, 815, 0, 0
	GoTo _cv_battle_54
_cv_next_60:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_61
	TrainerBattle 817, 817, 0, 0
	GoTo _cv_battle_54
_cv_next_61:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_62
	TrainerBattle 819, 819, 0, 0
	GoTo _cv_battle_54
_cv_next_62:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_63
	TrainerBattle 813, 813, 0, 0
	GoTo _cv_battle_54
_cv_next_63:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_64
	TrainerBattle 821, 821, 0, 0
	GoTo _cv_battle_54
_cv_next_64:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_65
	TrainerBattle 816, 816, 0, 0
	GoTo _cv_battle_54
_cv_next_65:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_66
	TrainerBattle 811, 811, 0, 0
	GoTo _cv_battle_54
_cv_next_66:
	TrainerBattle 810, 810, 0, 0
_cv_battle_54:
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_67
	WhiteOut
	End
_cv_won_67:
	SetFlag 0x20B1
	Return
	
Route22_EventScript_LateRivalCharmander:
	CanvasCheckTeam 7, 0x5019
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_team_not_allowed
	CanvasCloseMsg
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_69
	TrainerBattle 814, 814, 0, 0
	GoTo _cv_battle_68
_cv_next_69:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_70
	TrainerBattle 818, 818, 0, 0
	GoTo _cv_battle_68
_cv_next_70:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_71
	TrainerBattle 812, 812, 0, 0
	GoTo _cv_battle_68
_cv_next_71:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_72
	TrainerBattle 810, 810, 0, 0
	GoTo _cv_battle_68
_cv_next_72:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_73
	TrainerBattle 820, 820, 0, 0
	GoTo _cv_battle_68
_cv_next_73:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_74
	TrainerBattle 815, 815, 0, 0
	GoTo _cv_battle_68
_cv_next_74:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_75
	TrainerBattle 817, 817, 0, 0
	GoTo _cv_battle_68
_cv_next_75:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_76
	TrainerBattle 819, 819, 0, 0
	GoTo _cv_battle_68
_cv_next_76:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_77
	TrainerBattle 813, 813, 0, 0
	GoTo _cv_battle_68
_cv_next_77:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_78
	TrainerBattle 821, 821, 0, 0
	GoTo _cv_battle_68
_cv_next_78:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_79
	TrainerBattle 816, 816, 0, 0
	GoTo _cv_battle_68
_cv_next_79:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_80
	TrainerBattle 811, 811, 0, 0
	GoTo _cv_battle_68
_cv_next_80:
	TrainerBattle 810, 810, 0, 0
_cv_battle_68:
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_81
	WhiteOut
	End
_cv_won_81:
	SetFlag 0x20B2
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
	NPCMsg msg_0360_R22_Text_GymHack_WrongType
	WaitButton
	Return
	
EventScript_GymHack_MsgDuplicate:
	NPCMsg msg_0360_R22_Text_GymHack_Duplicate
	WaitButton
	Return
	
EventScript_GymHack_MsgDuplicateItem:
	NPCMsg msg_0360_R22_Text_GymHack_DuplicateItem
	WaitButton
	Return

_cv_stop:
	NPCMsg msg_0360_R22_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_team_not_allowed:
	Call EventScript_GymHack_ShowTeamRuleMessage
	CanvasCloseMsg
	GetPlayerCoords 0x8008, 0x8009
	GetPlayerFacing 0x800A
	Warp MAP_ROUTE_22, 0, 0x8008, 0x8009, 0x800A
	ReleaseAll
	End

	.balign 4, 0
Route22_Movement_LateRivalExit:
	WalkNormalWest 7
	EndMovement

	.balign 4, 0
Route22_Movement_RivalApproach:
	WalkNormalEast 7
	EndMovement

	.balign 4, 0
Route22_Movement_RivalApproachBottom:
	WalkNormalEast 8
	WalkOnSpotFasterSouth
	EndMovement

	.balign 4, 0
Route22_Movement_PlayerFaceRival:
	Delay16 7
	Delay8
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
Route22_Movement_EarlyRivalExit:
	WalkNormalSouth
	WalkNormalEast 5
	WalkNormalSouth 6
	EndMovement

	.balign 4, 0
Route22_Movement_EarlyRivalExitBottom:
	WalkNormalEast 4
	WalkNormalSouth 7
	EndMovement
	.balign 4, 0
