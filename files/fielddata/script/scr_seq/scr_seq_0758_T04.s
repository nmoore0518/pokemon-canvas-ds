#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T04.h"
#include "msgdata/msg/msg_0467_T04.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's CeruleanCity_Frlg#world by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef CeruleanCity_EventScript_Policeman
	ScrDef CeruleanCity_EventScript_Grunt
	ScrDef CeruleanCity_EventScript_LittleBoy
	ScrDef CeruleanCity_EventScript_BaldingMan
	ScrDef CeruleanCity_EventScript_Youngster
	ScrDef CeruleanCity_EventScript_CeruleanCaveGuard
	ScrDef TypeTutor_EventScript_Water
	ScrDef TypeTutor_EventScript_Ice
	ScrDef CeruleanCity_EventScript_CitySign
	ScrDef CeruleanCity_EventScript_GymSign
	ScrDef CeruleanCity_BikeShop_EventScript_Bicycle
	ScrDef CeruleanCity_EventScript_RivalTriggerLeft
	ScrDef CeruleanCity_EventScript_RivalTriggerMid
	ScrDef CeruleanCity_EventScript_RivalTriggerRight
	ScrDef CeruleanCity_EventScript_GruntTriggerTop
	ScrDef CeruleanCity_EventScript_GruntTriggerBottom
	ScrDef CeruleanCity_OnTransition
	ScrDefEnd
	
CeruleanCity_EventScript_Policeman:
	LockAll
	FacePlayer
	NPCMsg msg_0467_T04_CeruleanCity_Text_PeopleHereWereRobbed
	WaitButton
	CanvasCloseMsg
	ApplyMovement 1, Common_Movement_FaceOriginalDirection
	WaitMovement
	CanvasCloseMsg
	ReleaseAll
	End
	
CeruleanCity_EventScript_Grunt:
	LockAll
	FacePlayer
	CheckTrainerFlag 1091
	GoToIf TRUE, CeruleanCity_EventScript_GruntDefeated
	NPCMsg msg_0467_T04_CeruleanCity_Text_GruntIntro
	PlayBGM SEQ_GS_EYE_ROCKET
	WaitButton
	CanvasCloseMsg
	TrainerBattle 1091, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_2
	WhiteOut
	End
_cv_won_2:
	SetTrainerFlag 1091
	SetVar 0x5025, 1
	GoTo CeruleanCity_EventScript_GruntDefeated
	CloseMsg
	End
	
CeruleanCity_EventScript_LittleBoy:
	LockAll
	FacePlayer
	GoToIfSet 0x20D3, CeruleanCity_EventScript_LittleBoySlowbroMoved
	NPCMsg msg_0467_T04_CeruleanCity_Text_IfSlowbroWasntThereCouldCutTree
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeruleanCity_EventScript_BaldingMan:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0467_T04_CeruleanCity_Text_PokemonEncyclopediaAmusing
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeruleanCity_EventScript_Youngster:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0467_T04_CeruleanCity_Text_TrainerLifeIsToughIsntIt
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeruleanCity_EventScript_CeruleanCaveGuard:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0467_T04_CeruleanCity_Text_ThisIsCeruleanCave
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TypeTutor_EventScript_Water:
	LockAll
	FacePlayer
	SetVar 0x8004, 5
	GoTo TypeTutor_EventScript_Talk
	
TypeTutor_EventScript_Ice:
	LockAll
	FacePlayer
	SetVar 0x8004, 6
	GoTo TypeTutor_EventScript_Talk
	
CeruleanCity_EventScript_CitySign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0467_T04_CeruleanCity_Text_CitySign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeruleanCity_EventScript_GymSign:
	LockAll
	NPCMsg msg_0467_T04_CeruleanCity_Text_GymSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeruleanCity_BikeShop_EventScript_Bicycle:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0467_T04_CeruleanCity_BikeShop_Text_ShinyNewBicycle
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeruleanCity_EventScript_RivalTriggerLeft:
	LockAll
	SetVar 0x4001, 0
	GoTo CeruleanCity_EventScript_Rival
	End
	
CeruleanCity_EventScript_RivalTriggerMid:
	LockAll
	SetVar 0x4001, 1
	MovePerson 8, 1254, 132
	GoTo CeruleanCity_EventScript_Rival
	End
	
CeruleanCity_EventScript_RivalTriggerRight:
	LockAll
	SetVar 0x4001, 2
	MovePerson 8, 1255, 132
	GoTo CeruleanCity_EventScript_Rival
	End
	
CeruleanCity_EventScript_GruntTriggerTop:
	LockAll
	SetVar 0x4001, 0
	ApplyMovement 2, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	GoTo CeruleanCity_EventScript_GruntTrigger
	End
	
CeruleanCity_EventScript_GruntTriggerBottom:
	LockAll
	SetVar 0x4001, 1
	ApplyMovement 2, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	GoTo CeruleanCity_EventScript_GruntTrigger
	End
	
CeruleanCity_OnTransition:
	SetFlag FLAG_SYS_FLYPOINT_CERULEAN
	CallIfUnset 0x20D3, CeruleanCity_EventScript_BlockExits
	CallIfSet FLAG_GAME_CLEAR, CeruleanCity_EventScript_OpenCave
	End
	
CeruleanCity_EventScript_GruntDefeated:
	NPCMsg msg_0467_T04_CeruleanCity_Text_OkayIllReturnStolenTM
	WaitButton
	HasSpaceForItem ITEM_TM28, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CeruleanCity_EventScript_NoRoomForTM28
	GiveItem ITEM_TM28, 1, VAR_SPECIAL_RESULT
	BufferItemName 1, ITEM_TM28
	BufferPlayersName 6
	NPCMsg msg_0467_T04_CeruleanCity_Text_RecoveredTM28FromGrunt
	PlayFanfare SEQ_ME_LVUP
	WaitFanfare
	WaitButton
	NPCMsg msg_0467_T04_CeruleanCity_Text_BetterGetMovingBye
	WaitButton
	CanvasCloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	HidePerson 2
	SetFlag 0x20D4
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	SetFlag 0x20D5
	CanvasCloseMsg
	ReleaseAll
	End
	
CeruleanCity_EventScript_LittleBoySlowbroMoved:
	NPCMsg msg_0467_T04_CeruleanCity_Text_YouCanCutDownSmallTrees
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TypeTutor_EventScript_Talk:
	CopyVar 0x8008, 0x8004
	// TODO(gba) special TypeTutor_GetState
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TypeTutor_EventScript_Intro
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq TypeTutor_EventScript_Trial
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq TypeTutor_EventScript_JustDone
	GoTo TypeTutor_EventScript_Teach
	
CeruleanCity_EventScript_Rival:
	SetVar 0x5013, 2
	PlayBGM SEQ_GS_E_RIVAL1
	GoToIfUnset 0x205F, _cv_show_3
	ClearFlag 0x205F
	ShowPerson 8
	SetFlag 0x205F
	GoTo _cv_shown_4
_cv_show_3:
	ShowPerson 8
_cv_shown_4:
	ApplyMovement 8, CeruleanCity_Movement_RivalEnter
	WaitMovement
	BufferPlayersName 6
	BufferRivalsName 7
	NPCMsg msg_0467_T04_CeruleanCity_Text_RivalIntro
	WaitButton
	SetVar VAR_SPECIAL_LAST_TALKED, 8
	CompareVarToValue 0x5018, 2
	CallIfEq CeruleanCity_EventScript_RivalSquirtle
	CompareVarToValue 0x5018, 1
	CallIfEq CeruleanCity_EventScript_RivalBulbasaur
	CompareVarToValue 0x5018, 0
	CallIfEq CeruleanCity_EventScript_RivalCharmander
	BufferRivalsName 7
	NPCMsg msg_0467_T04_CeruleanCity_Text_RivalPostBattle
	WaitButton
	CanvasCloseMsg
	PlayBGM SEQ_GS_E_RIVAL2
	CompareVarToValue 0x4001, 0
	CallIfEq CeruleanCity_EventScript_RivalStartExit
	CompareVarToValue 0x4001, 1
	CallIfEq CeruleanCity_EventScript_RivalStartExit
	CompareVarToValue 0x4001, 2
	CallIfEq CeruleanCity_EventScript_RivalStartExitRight
	NPCMsg msg_0467_T04_CeruleanCity_Text_OhRightLittlePresentAsFavor
	WaitButton
	SetVar 0x500F, 1
	SetFlag 0x20D6
	SetFlag 0x20D7
	SetVar VAR_SPECIAL_RESULT, 1
	NPCMsg msg_0467_T04_CeruleanCity_Text_ExplainFameCheckerSmellYa
	WaitButton
	CanvasCloseMsg
	ApplyMovement 8, CeruleanCity_Movement_RivalExit
	WaitMovement
	ResetBGM
	HidePerson 8
	SetFlag 0x205F
	CanvasCloseMsg
	ReleaseAll
	End
	
CeruleanCity_EventScript_GruntTrigger:
	NPCMsg msg_0467_T04_CeruleanCity_Text_GruntIntro
	WaitButton
	SetVar VAR_SPECIAL_LAST_TALKED, 2
	CanvasCloseMsg
	TrainerBattle 1091, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_6
	WhiteOut
	End
_cv_won_6:
	SetTrainerFlag 1091
	SetVar 0x5025, 1
	GoTo CeruleanCity_EventScript_GruntDefeated
	CloseMsg
	End
	
CeruleanCity_EventScript_BlockExits:
	MovePerson 1, 1261, 144
	MovePerson 3, 1257, 163
	MovePerson 4, 1258, 163
	Return
	
CeruleanCity_EventScript_OpenCave:
	SetFlag 0x20D8
	Return
	
CeruleanCity_EventScript_NoRoomForTM28:
	NPCMsg msg_0467_T04_CeruleanCity_Text_MakeRoomForThisCantRun
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TypeTutor_EventScript_Intro:
	// TODO(gba) special TypeTutor_BufferIntro
	GoTo _cv_stop
	Call _cv_str4
	WaitButton
	// TODO(gba) special TypeTutor_SetMet
	GoTo _cv_stop
	// TODO(gba) special TypeTutor_GetState
	GoTo _cv_stop
	GoTo TypeTutor_EventScript_Trial
	
TypeTutor_EventScript_Trial:
	// TODO(gba) special TypeTutor_BufferTrial
	GoTo _cv_stop
	Call _cv_str4
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TypeTutor_EventScript_JustDone:
	// TODO(gba) special TypeTutor_BufferDone
	GoTo _cv_stop
	Call _cv_str4
	WaitButton
	// TODO(gba) special TypeTutor_SetOpened
	GoTo _cv_stop
	GoTo TypeTutor_EventScript_Teach
	
TypeTutor_EventScript_Teach:
	CopyVar 0x8004, 0x8008
	NPCMsg msg_0467_T04_TypeTutor_Text_WhichMove
	// TODO(gba) special TypeTutor_PushMoves
	GoTo _cv_stop
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_8
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_8:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq TypeTutor_EventScript_Bye
	CopyVar 0x8004, 0x8008
	// TODO(gba) special TypeTutor_SelectMove
	GoTo _cv_stop
	NPCMsg msg_0467_T04_TypeTutor_Text_WhichMon
	WaitButton
	Call EventScript_ChooseMoveTutorMon
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TypeTutor_EventScript_Teach
	NPCMsg msg_0467_T04_TypeTutor_Text_Taught
	WaitButton
	GoTo TypeTutor_EventScript_Teach
	
CeruleanCity_EventScript_RivalSquirtle:
	CanvasCheckTeam 7, 0x5019
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_team_not_allowed
	CanvasCloseMsg
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_10
	TrainerBattle 766, 0, 0, 0
	GoTo _cv_battle_9
_cv_next_10:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_11
	TrainerBattle 770, 0, 0, 0
	GoTo _cv_battle_9
_cv_next_11:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_12
	TrainerBattle 764, 0, 0, 0
	GoTo _cv_battle_9
_cv_next_12:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_13
	TrainerBattle 762, 0, 0, 0
	GoTo _cv_battle_9
_cv_next_13:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_14
	TrainerBattle 772, 0, 0, 0
	GoTo _cv_battle_9
_cv_next_14:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_15
	TrainerBattle 767, 0, 0, 0
	GoTo _cv_battle_9
_cv_next_15:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_16
	TrainerBattle 769, 0, 0, 0
	GoTo _cv_battle_9
_cv_next_16:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_17
	TrainerBattle 771, 0, 0, 0
	GoTo _cv_battle_9
_cv_next_17:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_18
	TrainerBattle 765, 0, 0, 0
	GoTo _cv_battle_9
_cv_next_18:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_19
	TrainerBattle 773, 0, 0, 0
	GoTo _cv_battle_9
_cv_next_19:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_20
	TrainerBattle 768, 0, 0, 0
	GoTo _cv_battle_9
_cv_next_20:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_21
	TrainerBattle 763, 0, 0, 0
	GoTo _cv_battle_9
_cv_next_21:
	TrainerBattle 762, 0, 0, 0
_cv_battle_9:
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_22
	WhiteOut
	End
_cv_won_22:
	SetFlag 0x20D9
	Return
	
CeruleanCity_EventScript_RivalBulbasaur:
	CanvasCheckTeam 7, 0x5019
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_team_not_allowed
	CanvasCloseMsg
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_24
	TrainerBattle 766, 0, 0, 0
	GoTo _cv_battle_23
_cv_next_24:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_25
	TrainerBattle 770, 0, 0, 0
	GoTo _cv_battle_23
_cv_next_25:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_26
	TrainerBattle 764, 0, 0, 0
	GoTo _cv_battle_23
_cv_next_26:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_27
	TrainerBattle 762, 0, 0, 0
	GoTo _cv_battle_23
_cv_next_27:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_28
	TrainerBattle 772, 0, 0, 0
	GoTo _cv_battle_23
_cv_next_28:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_29
	TrainerBattle 767, 0, 0, 0
	GoTo _cv_battle_23
_cv_next_29:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_30
	TrainerBattle 769, 0, 0, 0
	GoTo _cv_battle_23
_cv_next_30:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_31
	TrainerBattle 771, 0, 0, 0
	GoTo _cv_battle_23
_cv_next_31:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_32
	TrainerBattle 765, 0, 0, 0
	GoTo _cv_battle_23
_cv_next_32:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_33
	TrainerBattle 773, 0, 0, 0
	GoTo _cv_battle_23
_cv_next_33:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_34
	TrainerBattle 768, 0, 0, 0
	GoTo _cv_battle_23
_cv_next_34:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_35
	TrainerBattle 763, 0, 0, 0
	GoTo _cv_battle_23
_cv_next_35:
	TrainerBattle 762, 0, 0, 0
_cv_battle_23:
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_36
	WhiteOut
	End
_cv_won_36:
	SetFlag 0x20DA
	Return
	
CeruleanCity_EventScript_RivalCharmander:
	CanvasCheckTeam 7, 0x5019
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_team_not_allowed
	CanvasCloseMsg
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_38
	TrainerBattle 766, 0, 0, 0
	GoTo _cv_battle_37
_cv_next_38:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_39
	TrainerBattle 770, 0, 0, 0
	GoTo _cv_battle_37
_cv_next_39:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_40
	TrainerBattle 764, 0, 0, 0
	GoTo _cv_battle_37
_cv_next_40:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_41
	TrainerBattle 762, 0, 0, 0
	GoTo _cv_battle_37
_cv_next_41:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_42
	TrainerBattle 772, 0, 0, 0
	GoTo _cv_battle_37
_cv_next_42:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_43
	TrainerBattle 767, 0, 0, 0
	GoTo _cv_battle_37
_cv_next_43:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_44
	TrainerBattle 769, 0, 0, 0
	GoTo _cv_battle_37
_cv_next_44:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_45
	TrainerBattle 771, 0, 0, 0
	GoTo _cv_battle_37
_cv_next_45:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_46
	TrainerBattle 765, 0, 0, 0
	GoTo _cv_battle_37
_cv_next_46:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_47
	TrainerBattle 773, 0, 0, 0
	GoTo _cv_battle_37
_cv_next_47:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_48
	TrainerBattle 768, 0, 0, 0
	GoTo _cv_battle_37
_cv_next_48:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_49
	TrainerBattle 763, 0, 0, 0
	GoTo _cv_battle_37
_cv_next_49:
	TrainerBattle 762, 0, 0, 0
_cv_battle_37:
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_50
	WhiteOut
	End
_cv_won_50:
	SetFlag 0x20DB
	Return
	
CeruleanCity_EventScript_RivalStartExit:
	ApplyMovement obj_player, CeruleanCity_Movement_PlayerWatchRivalExit
	ApplyMovement 8, CeruleanCity_Movement_RivalStartExit
	WaitMovement
	Return
	
CeruleanCity_EventScript_RivalStartExitRight:
	ApplyMovement obj_player, CeruleanCity_Movement_PlayerWatchRivalExitRight
	ApplyMovement 8, CeruleanCity_Movement_RivalStartExitRight
	WaitMovement
	Return
	
TypeTutor_EventScript_Bye:
	NPCMsg msg_0467_T04_TypeTutor_Text_Bye
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_ChooseMoveTutorMon:
	// TODO(gba) special ChooseMonForMoveTutor
	GoTo _cv_stop
	LockAll
	FacePlayer
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
	NPCMsg msg_0467_T04_Text_GymHack_WrongType
	WaitButton
	Return
	
EventScript_GymHack_MsgDuplicate:
	NPCMsg msg_0467_T04_Text_GymHack_Duplicate
	WaitButton
	Return
	
EventScript_GymHack_MsgDuplicateItem:
	NPCMsg msg_0467_T04_Text_GymHack_DuplicateItem
	WaitButton
	Return

_cv_str4:
	BufferPlayersName 6
	BufferRivalsName 7
	Return

_cv_stop:
	NPCMsg msg_0467_T04_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_team_not_allowed:
	Call EventScript_GymHack_ShowTeamRuleMessage
	CanvasCloseMsg
	GetPlayerCoords 0x8008, 0x8009
	GetPlayerFacing 0x800A
	Warp MAP_CERULEAN, 0, 0x8008, 0x8009, 0x800A
	ReleaseAll
	End

	.balign 4, 0
Common_Movement_FaceOriginalDirection:
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterUp:
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterDown:
	WalkOnSpotFasterSouth
	EndMovement

	.balign 4, 0
CeruleanCity_Movement_RivalEnter:
	WalkNormalSouth 5
	EndMovement

	.balign 4, 0
CeruleanCity_Movement_RivalExit:
	WalkNormalSouth 7
	EndMovement

	.balign 4, 0
CeruleanCity_Movement_PlayerWatchRivalExit:
	Delay16
	Delay8
	WalkOnSpotFasterEast
	Delay16
	WalkOnSpotFasterSouth
	EndMovement

	.balign 4, 0
CeruleanCity_Movement_RivalStartExit:
	WalkNormalEast
	WalkNormalSouth 7
	Delay16 2
	WalkNormalWest
	WalkNormalNorth 5
	EndMovement

	.balign 4, 0
CeruleanCity_Movement_PlayerWatchRivalExitRight:
	Delay16
	Delay8
	WalkOnSpotFasterWest
	Delay16
	WalkOnSpotFasterSouth
	EndMovement

	.balign 4, 0
CeruleanCity_Movement_RivalStartExitRight:
	WalkNormalWest
	WalkNormalSouth 7
	Delay16 2
	WalkNormalEast
	WalkNormalNorth 5
	EndMovement
	.balign 4, 0
