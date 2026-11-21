#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_POKEMON_TOWER_2F.h"
#include "msgdata/msg/msg_0886_CV_CANVAS_POKEMON_TOWER_2F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PokemonTower_2F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef PokemonTower_2F_EventScript_Channeler
	ScrDef TowerGraves_EventScript_Ghost
	ScrDef PokemonTower_EventScript_Grave00
	ScrDef PokemonTower_EventScript_Grave01
	ScrDef PokemonTower_EventScript_Grave02
	ScrDef PokemonTower_EventScript_Grave03
	ScrDef PokemonTower_EventScript_Grave04
	ScrDef PokemonTower_EventScript_Grave05
	ScrDef PokemonTower_EventScript_Grave06
	ScrDef PokemonTower_EventScript_Grave07
	ScrDef PokemonTower_EventScript_Grave08
	ScrDef PokemonTower_EventScript_Grave09
	ScrDef PokemonTower_EventScript_Grave10
	ScrDef PokemonTower_EventScript_Grave11
	ScrDef PokemonTower_2F_EventScript_RivalTriggerRight
	ScrDef PokemonTower_2F_EventScript_RivalTriggerDown
	ScrDef TowerGraves_EventScript_HideGhosts
	ScrDefEnd
	
PokemonTower_2F_EventScript_Channeler:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0886_CV_CANVAS_POKEMON_TOWER_2F_PokemonTower_2F_Text_SilphScopeCouldUnmaskGhosts
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TowerGraves_EventScript_Ghost:
	End
	
PokemonTower_EventScript_Grave00:
	SetVar 0x8004, 0
	GoTo TowerGraves_EventScript_Read
	
PokemonTower_EventScript_Grave01:
	SetVar 0x8004, 1
	GoTo TowerGraves_EventScript_Read
	
PokemonTower_EventScript_Grave02:
	SetVar 0x8004, 2
	GoTo TowerGraves_EventScript_Read
	
PokemonTower_EventScript_Grave03:
	SetVar 0x8004, 3
	GoTo TowerGraves_EventScript_Read
	
PokemonTower_EventScript_Grave04:
	SetVar 0x8004, 4
	GoTo TowerGraves_EventScript_Read
	
PokemonTower_EventScript_Grave05:
	SetVar 0x8004, 5
	GoTo TowerGraves_EventScript_Read
	
PokemonTower_EventScript_Grave06:
	SetVar 0x8004, 6
	GoTo TowerGraves_EventScript_Read
	
PokemonTower_EventScript_Grave07:
	SetVar 0x8004, 7
	GoTo TowerGraves_EventScript_Read
	
PokemonTower_EventScript_Grave08:
	SetVar 0x8004, 8
	GoTo TowerGraves_EventScript_Read
	
PokemonTower_EventScript_Grave09:
	SetVar 0x8004, 9
	GoTo TowerGraves_EventScript_Read
	
PokemonTower_EventScript_Grave10:
	SetVar 0x8004, 10
	GoTo TowerGraves_EventScript_Read
	
PokemonTower_EventScript_Grave11:
	SetVar 0x8004, 11
	GoTo TowerGraves_EventScript_Read
	
PokemonTower_2F_EventScript_RivalTriggerRight:
	LockAll
	SetVar 0x4001, 0
	GoTo PokemonTower_2F_EventScript_Rival
	End
	
PokemonTower_2F_EventScript_RivalTriggerDown:
	LockAll
	SetVar 0x4001, 1
	GoTo PokemonTower_2F_EventScript_Rival
	End
	
TowerGraves_EventScript_HideGhosts:
	SetFlag 31
	End
	
TowerGraves_EventScript_Read:
	LockAll
	// TODO(gba) special TowerGraves_Read
	GoTo _cv_stop
	CopyVar 0x8006, VAR_SPECIAL_RESULT
	NPCMsg msg_0886_CV_CANVAS_POKEMON_TOWER_2F_TowerGraves_Text_Grave
	WaitButton
	CompareVarToValue 0x8006, 1
	GoToIfEq TowerGraves_EventScript_GhostGirl
	CloseMsg
	ReleaseAll
	End
	
PokemonTower_2F_EventScript_Rival:
	PlayBGM SEQ_GS_E_RIVAL1
	CompareVarToValue 0x4001, 0
	CallIfEq PokemonTower_2F_EventScript_RivalFacePlayerRight
	CompareVarToValue 0x4001, 1
	CallIfEq PokemonTower_2F_EventScript_RivalFacePlayerDown
	ApplyMovement 1, Common_Movement_ExclamationMark
	WaitMovement
	ApplyMovement 1, Common_Movement_Delay48
	WaitMovement
	BufferPlayersName 6
	BufferRivalsName 7
	NPCMsg msg_0886_CV_CANVAS_POKEMON_TOWER_2F_PokemonTower_2F_Text_RivalIntro
	WaitButton
	SetVar VAR_SPECIAL_LAST_TALKED, 1
	CompareVarToValue 0x5018, 2
	CallIfEq PokemonTower_2F_EventScript_RivalSquirtle
	CompareVarToValue 0x5018, 1
	CallIfEq PokemonTower_2F_EventScript_RivalBulbasaur
	CompareVarToValue 0x5018, 0
	CallIfEq PokemonTower_2F_EventScript_RivalCharmander
	NPCMsg msg_0886_CV_CANVAS_POKEMON_TOWER_2F_PokemonTower_2F_Text_RivalPostBattle
	WaitButton
	Call GymHack_EventScript_RivalTowerGift
	CanvasCloseMsg
	PlayBGM SEQ_GS_E_RIVAL2
	CompareVarToValue 0x4001, 0
	CallIfEq PokemonTower_2F_EventScript_RivalExitRight
	CompareVarToValue 0x4001, 1
	CallIfEq PokemonTower_2F_EventScript_RivalExitDown
	PlaySE SEQ_SE_DP_KAIDAN2
	Wait 25, VAR_SPECIAL_RESULT
	ResetBGM
	HidePerson 1
	SetFlag 0x2182
	SetVar 0x503D, 1
	CanvasCloseMsg
	ReleaseAll
	End
	
TowerGraves_EventScript_GhostGirl:
	Wait 30, VAR_SPECIAL_RESULT
	PlaySE SEQ_SE_DP_SELECT
	// TODO(gba) special TowerGraves_SummonGhosts
	GoTo _cv_stop
	PlayCry SPECIES_SCYTHER, 0
	WaitCry
	NPCMsg msg_0886_CV_CANVAS_POKEMON_TOWER_2F_TowerGraves_Text_GirlLament
	WaitButton
	SetVar VAR_SPECIAL_RESULT, 1
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TowerGraves_EventScript_NoRoom
	SetFlag 0x2183
	SetVar VAR_SPECIAL_RESULT, 1
	SetFlag 0x2184
	NPCMsg msg_0886_CV_CANVAS_POKEMON_TOWER_2F_TowerGraves_Text_GirlKeepThemAsTheyAre
	WaitButton
	CanvasCloseMsg
	// TODO(gba) special TowerGraves_DismissGhosts
	GoTo _cv_stop
	NPCMsg msg_0886_CV_CANVAS_POKEMON_TOWER_2F_TowerGraves_Text_Gone
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PokemonTower_2F_EventScript_RivalFacePlayerRight:
	ApplyMovement 1, Common_Movement_WalkInPlaceFasterRight
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterLeft
	WaitMovement
	Return
	
PokemonTower_2F_EventScript_RivalFacePlayerDown:
	ApplyMovement 1, Common_Movement_WalkInPlaceFasterDown
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	Return
	
PokemonTower_2F_EventScript_RivalSquirtle:
	CanvasCheckTeam 7, 0x5019
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_team_not_allowed
	CanvasCloseMsg
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_2
	TrainerBattle 790, 0, 0, 0
	GoTo _cv_battle_1
_cv_next_2:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_3
	TrainerBattle 794, 0, 0, 0
	GoTo _cv_battle_1
_cv_next_3:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_4
	TrainerBattle 788, 0, 0, 0
	GoTo _cv_battle_1
_cv_next_4:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_5
	TrainerBattle 786, 0, 0, 0
	GoTo _cv_battle_1
_cv_next_5:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_6
	TrainerBattle 796, 0, 0, 0
	GoTo _cv_battle_1
_cv_next_6:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_7
	TrainerBattle 791, 0, 0, 0
	GoTo _cv_battle_1
_cv_next_7:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_8
	TrainerBattle 793, 0, 0, 0
	GoTo _cv_battle_1
_cv_next_8:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_9
	TrainerBattle 795, 0, 0, 0
	GoTo _cv_battle_1
_cv_next_9:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_10
	TrainerBattle 789, 0, 0, 0
	GoTo _cv_battle_1
_cv_next_10:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_11
	TrainerBattle 797, 0, 0, 0
	GoTo _cv_battle_1
_cv_next_11:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_12
	TrainerBattle 792, 0, 0, 0
	GoTo _cv_battle_1
_cv_next_12:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_13
	TrainerBattle 787, 0, 0, 0
	GoTo _cv_battle_1
_cv_next_13:
	TrainerBattle 786, 0, 0, 0
_cv_battle_1:
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_14
	WhiteOut
	End
_cv_won_14:
	SetFlag 0x2185
	Return
	
PokemonTower_2F_EventScript_RivalBulbasaur:
	CanvasCheckTeam 7, 0x5019
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_team_not_allowed
	CanvasCloseMsg
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_16
	TrainerBattle 790, 0, 0, 0
	GoTo _cv_battle_15
_cv_next_16:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_17
	TrainerBattle 794, 0, 0, 0
	GoTo _cv_battle_15
_cv_next_17:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_18
	TrainerBattle 788, 0, 0, 0
	GoTo _cv_battle_15
_cv_next_18:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_19
	TrainerBattle 786, 0, 0, 0
	GoTo _cv_battle_15
_cv_next_19:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_20
	TrainerBattle 796, 0, 0, 0
	GoTo _cv_battle_15
_cv_next_20:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_21
	TrainerBattle 791, 0, 0, 0
	GoTo _cv_battle_15
_cv_next_21:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_22
	TrainerBattle 793, 0, 0, 0
	GoTo _cv_battle_15
_cv_next_22:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_23
	TrainerBattle 795, 0, 0, 0
	GoTo _cv_battle_15
_cv_next_23:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_24
	TrainerBattle 789, 0, 0, 0
	GoTo _cv_battle_15
_cv_next_24:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_25
	TrainerBattle 797, 0, 0, 0
	GoTo _cv_battle_15
_cv_next_25:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_26
	TrainerBattle 792, 0, 0, 0
	GoTo _cv_battle_15
_cv_next_26:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_27
	TrainerBattle 787, 0, 0, 0
	GoTo _cv_battle_15
_cv_next_27:
	TrainerBattle 786, 0, 0, 0
_cv_battle_15:
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_28
	WhiteOut
	End
_cv_won_28:
	SetFlag 0x2186
	Return
	
PokemonTower_2F_EventScript_RivalCharmander:
	CanvasCheckTeam 7, 0x5019
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_team_not_allowed
	CanvasCloseMsg
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_30
	TrainerBattle 790, 0, 0, 0
	GoTo _cv_battle_29
_cv_next_30:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_31
	TrainerBattle 794, 0, 0, 0
	GoTo _cv_battle_29
_cv_next_31:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_32
	TrainerBattle 788, 0, 0, 0
	GoTo _cv_battle_29
_cv_next_32:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_33
	TrainerBattle 786, 0, 0, 0
	GoTo _cv_battle_29
_cv_next_33:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_34
	TrainerBattle 796, 0, 0, 0
	GoTo _cv_battle_29
_cv_next_34:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_35
	TrainerBattle 791, 0, 0, 0
	GoTo _cv_battle_29
_cv_next_35:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_36
	TrainerBattle 793, 0, 0, 0
	GoTo _cv_battle_29
_cv_next_36:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_37
	TrainerBattle 795, 0, 0, 0
	GoTo _cv_battle_29
_cv_next_37:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_38
	TrainerBattle 789, 0, 0, 0
	GoTo _cv_battle_29
_cv_next_38:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_39
	TrainerBattle 797, 0, 0, 0
	GoTo _cv_battle_29
_cv_next_39:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_40
	TrainerBattle 792, 0, 0, 0
	GoTo _cv_battle_29
_cv_next_40:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_41
	TrainerBattle 787, 0, 0, 0
	GoTo _cv_battle_29
_cv_next_41:
	TrainerBattle 786, 0, 0, 0
_cv_battle_29:
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_42
	WhiteOut
	End
_cv_won_42:
	SetFlag 0x2187
	Return
	
GymHack_EventScript_RivalTowerGift:
	GoToIfSet 0x2188, GymHack_EventScript_GiftsDone
	NPCMsg msg_0886_CV_CANVAS_POKEMON_TOWER_2F_GymHack_Text_RivalGoldCap
	WaitButton
	SetVar 0x8009, 796
	Call GymHack_EventScript_GiveStatItem
	SetFlag 0x2188
	NPCMsg msg_0886_CV_CANVAS_POKEMON_TOWER_2F_GymHack_Text_RivalGoldCapAfter
	WaitButton
	Return
	
PokemonTower_2F_EventScript_RivalExitRight:
	ApplyMovement 1, PokemonTower_2F_Movement_RivalExitRight
	WaitMovement
	Return
	
PokemonTower_2F_EventScript_RivalExitDown:
	ApplyMovement 1, PokemonTower_2F_Movement_RivalExitDown
	WaitMovement
	Return
	
TowerGraves_EventScript_NoRoom:
	NPCMsg msg_0886_CV_CANVAS_POKEMON_TOWER_2F_TowerGraves_Text_GirlNoRoom
	WaitButton
	CanvasCloseMsg
	// TODO(gba) special TowerGraves_DismissGhosts
	GoTo _cv_stop
	CanvasCloseMsg
	ReleaseAll
	End
	
EventScript_GymHack_ShowTeamRuleMessage:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq EventScript_GymHack_MsgWrongType
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	CallIfEq EventScript_GymHack_MsgDuplicate
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	CallIfEq EventScript_GymHack_MsgDuplicateItem
	Return
	
GymHack_EventScript_GiftsDone:
	Return
	
GymHack_EventScript_GiveStatItem:
	GiveItem 0x8009, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymHack_EventScript_GiveStatItemDone
	BufferItemName 1, 0x8009
	NPCMsg msg_0886_CV_CANVAS_POKEMON_TOWER_2F_GymHack_Text_GiftSentToPC
	WaitButton
	GoTo GymHack_EventScript_GiveStatItemDone
	
EventScript_GymHack_MsgWrongType:
	NPCMsg msg_0886_CV_CANVAS_POKEMON_TOWER_2F_Text_GymHack_WrongType
	WaitButton
	Return
	
EventScript_GymHack_MsgDuplicate:
	NPCMsg msg_0886_CV_CANVAS_POKEMON_TOWER_2F_Text_GymHack_Duplicate
	WaitButton
	Return
	
EventScript_GymHack_MsgDuplicateItem:
	NPCMsg msg_0886_CV_CANVAS_POKEMON_TOWER_2F_Text_GymHack_DuplicateItem
	WaitButton
	Return
	
GymHack_EventScript_GiveStatItemDone:
	Return

_cv_stop:
	NPCMsg msg_0886_CV_CANVAS_POKEMON_TOWER_2F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_team_not_allowed:
	Call EventScript_GymHack_ShowTeamRuleMessage
	CanvasCloseMsg
	GetPlayerCoords 0x8008, 0x8009
	GetPlayerFacing 0x800A
	Warp MAP_CANVAS_POKEMON_TOWER_2F, 0, 0x8008, 0x8009, 0x800A
	ReleaseAll
	End

	.balign 4, 0
Common_Movement_ExclamationMark:
	EmoteExclamationMark
	EndMovement

	.balign 4, 0
Common_Movement_Delay48:
	Delay16 3
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterRight:
	WalkOnSpotFasterEast
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterLeft:
	WalkOnSpotFasterWest
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterDown:
	WalkOnSpotFasterSouth
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterUp:
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
PokemonTower_2F_Movement_RivalExitRight:
	WalkNormalSouth
	WalkNormalEast 2
	WalkNormalSouth 4
	WalkOnSpotFasterEast
	EndMovement

	.balign 4, 0
PokemonTower_2F_Movement_RivalExitDown:
	WalkNormalEast 2
	WalkNormalSouth 5
	WalkOnSpotFasterEast
	EndMovement
	.balign 4, 0
