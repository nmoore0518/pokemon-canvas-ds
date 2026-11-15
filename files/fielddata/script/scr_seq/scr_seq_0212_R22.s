#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R22.h"
#include "msgdata/msg/msg_0360_R22.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route22_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route22_EventScript_LeagueGateSign
	ScrDef Route22_EventScript_EarlyRivalTriggerTop
	ScrDef Route22_EventScript_EarlyRivalTriggerMid
	ScrDef Route22_EventScript_EarlyRivalTriggerBottom
	ScrDef Route22_EventScript_LateRivalTriggerTop
	ScrDef Route22_EventScript_LateRivalTriggerMid
	ScrDef Route22_EventScript_LateRivalTriggerBottom
	ScrDefEnd
	
Route22_EventScript_LeagueGateSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0360_R22_Route22_Text_LeagueGateSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route22_EventScript_EarlyRivalTriggerTop:
	LockAll
	SetVar 0x4001, 0
	GoTo Route22_EventScript_EarlyRival
	End
	
Route22_EventScript_EarlyRivalTriggerMid:
	LockAll
	SetVar 0x4001, 1
	MovePerson 1, 960, 263
	GoTo Route22_EventScript_EarlyRival
	End
	
Route22_EventScript_EarlyRivalTriggerBottom:
	LockAll
	SetVar 0x4001, 2
	MovePerson 1, 960, 263
	GoTo Route22_EventScript_EarlyRival
	End
	
Route22_EventScript_LateRivalTriggerTop:
	LockAll
	SetVar 0x4001, 0
	GoTo Route22_EventScript_LateRival
	End
	
Route22_EventScript_LateRivalTriggerMid:
	LockAll
	SetVar 0x4001, 1
	MovePerson 1, 960, 263
	GoTo Route22_EventScript_LateRival
	End
	
Route22_EventScript_LateRivalTriggerBottom:
	LockAll
	SetVar 0x4001, 2
	MovePerson 1, 960, 263
	GoTo Route22_EventScript_LateRival
	End
	
Route22_EventScript_EarlyRival:
	PlayBGM SEQ_GS_E_RIVAL1
	GoToIfUnset 0x2063, _cv_show_1
	ClearFlag 0x2063
	ShowPerson 1
	SetFlag 0x2063
	GoTo _cv_shown_2
_cv_show_1:
	ShowPerson 1
_cv_shown_2:
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
	CloseMsg
	Wait 10, VAR_SPECIAL_RESULT
	PlayBGM SEQ_GS_E_RIVAL2
	CompareVarToValue 0x4001, 0
	CallIfEq Route22_EventScript_EarlyRivalExit
	CompareVarToValue 0x4001, 1
	CallIfEq Route22_EventScript_EarlyRivalExit
	CompareVarToValue 0x4001, 2
	CallIfEq Route22_EventScript_EarlyRivalExitBottom
	ResetBGM
	HidePerson 1
	SetFlag 0x2063
	SetVar 0x5013, 2
	ReleaseAll
	End
	
Route22_EventScript_LateRival:
	PlayBGM SEQ_GS_E_RIVAL1
	GoToIfUnset 0x2063, _cv_show_3
	ClearFlag 0x2063
	ShowPerson 1
	SetFlag 0x2063
	GoTo _cv_shown_4
_cv_show_3:
	ShowPerson 1
_cv_shown_4:
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
	CloseMsg
	Wait 10, VAR_SPECIAL_RESULT
	PlayBGM SEQ_GS_E_RIVAL2
	ApplyMovement 1, Route22_Movement_LateRivalExit
	WaitMovement
	ResetBGM
	HidePerson 1
	SetFlag 0x2063
	SetVar 0x5013, 4
	ReleaseAll
	End
	
Route22_EventScript_EarlyRivalApproach:
	ApplyMovement 1, Route22_Movement_RivalApproach
	WaitMovement
	Return
	
Route22_EventScript_EarlyRivalApproachBottom:
	ApplyMovement 1, Route22_Movement_RivalApproachBottom
	ApplyMovement obj_player, Route22_Movement_PlayerFaceRival
	WaitMovement
	Return
	
Route22_EventScript_EarlyRivalSquirtle:
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_6
	TrainerBattle 754, 0, 1, 0
	GoTo _cv_battle_5
_cv_next_6:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_7
	TrainerBattle 758, 0, 1, 0
	GoTo _cv_battle_5
_cv_next_7:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_8
	TrainerBattle 752, 0, 1, 0
	GoTo _cv_battle_5
_cv_next_8:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_9
	TrainerBattle 750, 0, 1, 0
	GoTo _cv_battle_5
_cv_next_9:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_10
	TrainerBattle 760, 0, 1, 0
	GoTo _cv_battle_5
_cv_next_10:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_11
	TrainerBattle 755, 0, 1, 0
	GoTo _cv_battle_5
_cv_next_11:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_12
	TrainerBattle 757, 0, 1, 0
	GoTo _cv_battle_5
_cv_next_12:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_13
	TrainerBattle 759, 0, 1, 0
	GoTo _cv_battle_5
_cv_next_13:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_14
	TrainerBattle 753, 0, 1, 0
	GoTo _cv_battle_5
_cv_next_14:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_15
	TrainerBattle 761, 0, 1, 0
	GoTo _cv_battle_5
_cv_next_15:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_16
	TrainerBattle 756, 0, 1, 0
	GoTo _cv_battle_5
_cv_next_16:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_17
	TrainerBattle 751, 0, 1, 0
	GoTo _cv_battle_5
_cv_next_17:
	TrainerBattle 750, 0, 1, 0
_cv_battle_5:
	SetFlag 0x20AD
	Return
	
Route22_EventScript_EarlyRivalBulbasaur:
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_19
	TrainerBattle 754, 0, 1, 0
	GoTo _cv_battle_18
_cv_next_19:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_20
	TrainerBattle 758, 0, 1, 0
	GoTo _cv_battle_18
_cv_next_20:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_21
	TrainerBattle 752, 0, 1, 0
	GoTo _cv_battle_18
_cv_next_21:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_22
	TrainerBattle 750, 0, 1, 0
	GoTo _cv_battle_18
_cv_next_22:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_23
	TrainerBattle 760, 0, 1, 0
	GoTo _cv_battle_18
_cv_next_23:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_24
	TrainerBattle 755, 0, 1, 0
	GoTo _cv_battle_18
_cv_next_24:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_25
	TrainerBattle 757, 0, 1, 0
	GoTo _cv_battle_18
_cv_next_25:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_26
	TrainerBattle 759, 0, 1, 0
	GoTo _cv_battle_18
_cv_next_26:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_27
	TrainerBattle 753, 0, 1, 0
	GoTo _cv_battle_18
_cv_next_27:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_28
	TrainerBattle 761, 0, 1, 0
	GoTo _cv_battle_18
_cv_next_28:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_29
	TrainerBattle 756, 0, 1, 0
	GoTo _cv_battle_18
_cv_next_29:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_30
	TrainerBattle 751, 0, 1, 0
	GoTo _cv_battle_18
_cv_next_30:
	TrainerBattle 750, 0, 1, 0
_cv_battle_18:
	SetFlag 0x20AE
	Return
	
Route22_EventScript_EarlyRivalCharmander:
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_32
	TrainerBattle 754, 0, 1, 0
	GoTo _cv_battle_31
_cv_next_32:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_33
	TrainerBattle 758, 0, 1, 0
	GoTo _cv_battle_31
_cv_next_33:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_34
	TrainerBattle 752, 0, 1, 0
	GoTo _cv_battle_31
_cv_next_34:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_35
	TrainerBattle 750, 0, 1, 0
	GoTo _cv_battle_31
_cv_next_35:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_36
	TrainerBattle 760, 0, 1, 0
	GoTo _cv_battle_31
_cv_next_36:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_37
	TrainerBattle 755, 0, 1, 0
	GoTo _cv_battle_31
_cv_next_37:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_38
	TrainerBattle 757, 0, 1, 0
	GoTo _cv_battle_31
_cv_next_38:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_39
	TrainerBattle 759, 0, 1, 0
	GoTo _cv_battle_31
_cv_next_39:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_40
	TrainerBattle 753, 0, 1, 0
	GoTo _cv_battle_31
_cv_next_40:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_41
	TrainerBattle 761, 0, 1, 0
	GoTo _cv_battle_31
_cv_next_41:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_42
	TrainerBattle 756, 0, 1, 0
	GoTo _cv_battle_31
_cv_next_42:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_43
	TrainerBattle 751, 0, 1, 0
	GoTo _cv_battle_31
_cv_next_43:
	TrainerBattle 750, 0, 1, 0
_cv_battle_31:
	SetFlag 0x20AF
	Return
	
Route22_EventScript_EarlyRivalExit:
	ApplyMovement 1, Route22_Movement_EarlyRivalExit
	WaitMovement
	Return
	
Route22_EventScript_EarlyRivalExitBottom:
	ApplyMovement 1, Route22_Movement_EarlyRivalExitBottom
	WaitMovement
	Return
	
Route22_EventScript_LateRivalApproach:
	ApplyMovement 1, Route22_Movement_RivalApproach
	WaitMovement
	Return
	
Route22_EventScript_LateRivalApproachBottom:
	ApplyMovement 1, Route22_Movement_RivalApproachBottom
	ApplyMovement obj_player, Route22_Movement_PlayerFaceRival
	WaitMovement
	Return
	
Route22_EventScript_LateRivalSquirtle:
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_45
	TrainerBattle 814, 0, 0, 0
	GoTo _cv_battle_44
_cv_next_45:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_46
	TrainerBattle 818, 0, 0, 0
	GoTo _cv_battle_44
_cv_next_46:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_47
	TrainerBattle 812, 0, 0, 0
	GoTo _cv_battle_44
_cv_next_47:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_48
	TrainerBattle 810, 0, 0, 0
	GoTo _cv_battle_44
_cv_next_48:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_49
	TrainerBattle 820, 0, 0, 0
	GoTo _cv_battle_44
_cv_next_49:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_50
	TrainerBattle 815, 0, 0, 0
	GoTo _cv_battle_44
_cv_next_50:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_51
	TrainerBattle 817, 0, 0, 0
	GoTo _cv_battle_44
_cv_next_51:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_52
	TrainerBattle 819, 0, 0, 0
	GoTo _cv_battle_44
_cv_next_52:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_53
	TrainerBattle 813, 0, 0, 0
	GoTo _cv_battle_44
_cv_next_53:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_54
	TrainerBattle 821, 0, 0, 0
	GoTo _cv_battle_44
_cv_next_54:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_55
	TrainerBattle 816, 0, 0, 0
	GoTo _cv_battle_44
_cv_next_55:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_56
	TrainerBattle 811, 0, 0, 0
	GoTo _cv_battle_44
_cv_next_56:
	TrainerBattle 810, 0, 0, 0
_cv_battle_44:
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_57
	WhiteOut
	End
_cv_won_57:
	SetFlag 0x20B0
	Return
	
Route22_EventScript_LateRivalBulbasaur:
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_59
	TrainerBattle 814, 0, 0, 0
	GoTo _cv_battle_58
_cv_next_59:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_60
	TrainerBattle 818, 0, 0, 0
	GoTo _cv_battle_58
_cv_next_60:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_61
	TrainerBattle 812, 0, 0, 0
	GoTo _cv_battle_58
_cv_next_61:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_62
	TrainerBattle 810, 0, 0, 0
	GoTo _cv_battle_58
_cv_next_62:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_63
	TrainerBattle 820, 0, 0, 0
	GoTo _cv_battle_58
_cv_next_63:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_64
	TrainerBattle 815, 0, 0, 0
	GoTo _cv_battle_58
_cv_next_64:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_65
	TrainerBattle 817, 0, 0, 0
	GoTo _cv_battle_58
_cv_next_65:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_66
	TrainerBattle 819, 0, 0, 0
	GoTo _cv_battle_58
_cv_next_66:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_67
	TrainerBattle 813, 0, 0, 0
	GoTo _cv_battle_58
_cv_next_67:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_68
	TrainerBattle 821, 0, 0, 0
	GoTo _cv_battle_58
_cv_next_68:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_69
	TrainerBattle 816, 0, 0, 0
	GoTo _cv_battle_58
_cv_next_69:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_70
	TrainerBattle 811, 0, 0, 0
	GoTo _cv_battle_58
_cv_next_70:
	TrainerBattle 810, 0, 0, 0
_cv_battle_58:
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_71
	WhiteOut
	End
_cv_won_71:
	SetFlag 0x20B1
	Return
	
Route22_EventScript_LateRivalCharmander:
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_73
	TrainerBattle 814, 0, 0, 0
	GoTo _cv_battle_72
_cv_next_73:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_74
	TrainerBattle 818, 0, 0, 0
	GoTo _cv_battle_72
_cv_next_74:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_75
	TrainerBattle 812, 0, 0, 0
	GoTo _cv_battle_72
_cv_next_75:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_76
	TrainerBattle 810, 0, 0, 0
	GoTo _cv_battle_72
_cv_next_76:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_77
	TrainerBattle 820, 0, 0, 0
	GoTo _cv_battle_72
_cv_next_77:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_78
	TrainerBattle 815, 0, 0, 0
	GoTo _cv_battle_72
_cv_next_78:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_79
	TrainerBattle 817, 0, 0, 0
	GoTo _cv_battle_72
_cv_next_79:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_80
	TrainerBattle 819, 0, 0, 0
	GoTo _cv_battle_72
_cv_next_80:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_81
	TrainerBattle 813, 0, 0, 0
	GoTo _cv_battle_72
_cv_next_81:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_82
	TrainerBattle 821, 0, 0, 0
	GoTo _cv_battle_72
_cv_next_82:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_83
	TrainerBattle 816, 0, 0, 0
	GoTo _cv_battle_72
_cv_next_83:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_84
	TrainerBattle 811, 0, 0, 0
	GoTo _cv_battle_72
_cv_next_84:
	TrainerBattle 810, 0, 0, 0
_cv_battle_72:
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_85
	WhiteOut
	End
_cv_won_85:
	SetFlag 0x20B2
	Return

_cv_stop:
	NPCMsg msg_0360_R22_cv_unported
	WaitButton
	CloseMsg
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
