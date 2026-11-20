#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T09PC0101.h"
#include "msgdata/msg/msg_0520_T09PC0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's CinnabarIsland_PokemonCenter_1F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef CinnabarIsland_PokemonCenter_1F_EventScript_Nurse
	ScrDef CinnabarIsland_PokemonCenter_1F_EventScript_CooltrainerF
	ScrDef CinnabarIsland_PokemonCenter_1F_EventScript_Gentleman
	ScrDef CinnabarIsland_PokemonCenter_1F_EventScript_Youngster
	ScrDef CinnabarIsland_PokemonCenter_1F_EventScript_Bill
	ScrDef CinnabarIsland_PokemonCenter_1F_EventScript_PokemonJournalMrFuji
	ScrDef CinnabarIsland_PokemonCenter_1F_OnTransition
	ScrDef CableClub_OnResume
	ScrDefEnd
	
CinnabarIsland_PokemonCenter_1F_EventScript_Nurse:
	LockAll
	FacePlayer
	SetVar VAR_SPECIAL_x8007, 0
	CallStd std_nurse_joy
	ReleaseAll
	End
	
CinnabarIsland_PokemonCenter_1F_EventScript_CooltrainerF:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0520_T09PC0101_CinnabarIsland_PokemonCenter_1F_Text_CinnabarGymLocked
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_PokemonCenter_1F_EventScript_Gentleman:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0520_T09PC0101_CinnabarIsland_PokemonCenter_1F_Text_VisitUnionRoom
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_PokemonCenter_1F_EventScript_Youngster:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0520_T09PC0101_CinnabarIsland_PokemonCenter_1F_Text_EvolutionCanWaitForNewMoves
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_PokemonCenter_1F_EventScript_Bill:
	LockAll
	FacePlayer
	NPCMsg msg_0520_T09PC0101_CinnabarIsland_PokemonCenter_1F_Text_ReadyToSailToOneIsland
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CinnabarIsland_PokemonCenter_1F_EventScript_NotReadyToSail
	NPCMsg msg_0520_T09PC0101_CinnabarIsland_PokemonCenter_1F_Text_LetsGo
	WaitButton
	CloseMsg
	PlayBGM SEQ_GS_E_TSURETEKE1
	SetFlag 0x201A
	SetFlag 0x2069
	Wait 20, VAR_SPECIAL_RESULT
	CompareVarToValue 0x5002, 1
	CallIfEq CinnabarIsland_PokemonCenter_1F_EventScript_ExitWithBillSouth
	CompareVarToValue 0x5002, 3
	CallIfEq CinnabarIsland_PokemonCenter_1F_EventScript_ExitWithBillEast
	CompareVarToValue 0x5002, 2
	CallIfEq CinnabarIsland_PokemonCenter_1F_EventScript_ExitWithBillWest
	HidePerson 7
	SetFlag 0x2069
	SetVar 0x502C, 1
	ClearFlag 0x2067
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	Warp MAP_CINNABAR_ISLAND, 0, 1045, 497, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	ReleaseAll
	End
	
CinnabarIsland_PokemonCenter_1F_EventScript_PokemonJournalMrFuji:
	LockAll
	FacePlayer
	NPCMsg msg_0520_T09PC0101_PokemonJournal_Text_SpecialFeatureMrFuji
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_PokemonCenter_1F_OnTransition:
	End
	
CableClub_OnResume:
	// TODO(gba) special InitUnionRoom
	// TODO(gba) .if OW_FLAG_MOVE_UNION_ROOM_CHECK != 0
	Return
	// TODO(gba) .else 
	End
	// TODO(gba) .endif 
	GoTo MossdeepCity_GameCorner_1F_EventScript_InfoMan2
	
CinnabarIsland_PokemonCenter_1F_EventScript_NotReadyToSail:
	NPCMsg msg_0520_T09PC0101_CinnabarIsland_PokemonCenter_1F_Text_OhNotDoneYet
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_PokemonCenter_1F_EventScript_ExitWithBillSouth:
	ApplyMovement 7, CinnabarIsland_PokemonCenter_1F_Movement_BillExit
	ApplyMovement obj_player, CinnabarIsland_PokemonCenter_1F_Movement_PlayerExitSouth
	WaitMovement
	Return
	
CinnabarIsland_PokemonCenter_1F_EventScript_ExitWithBillEast:
	ApplyMovement 7, CinnabarIsland_PokemonCenter_1F_Movement_BillExitEast
	ApplyMovement obj_player, CinnabarIsland_PokemonCenter_1F_Movement_PlayerExitEast
	WaitMovement
	Return
	
CinnabarIsland_PokemonCenter_1F_EventScript_ExitWithBillWest:
	ApplyMovement 7, CinnabarIsland_PokemonCenter_1F_Movement_BillExit
	ApplyMovement obj_player, CinnabarIsland_PokemonCenter_1F_Movement_PlayerExitWest
	WaitMovement
	Return
	
MossdeepCity_GameCorner_1F_EventScript_InfoMan2:
	LockAll
	FacePlayer
	NPCMsg msg_0520_T09PC0101_MossdeepCity_GameCorner_1F_Text_DescribeWhichGame
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0520_T09PC0101_cv_mc_wireless_minigame_0, 0
	ScrCmd_559 msg_0520_T09PC0101_cv_mc_wireless_minigame_1, 1
	ScrCmd_559 msg_0520_T09PC0101_cv_mc_wireless_minigame_2, 2
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_4
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq MossdeepCity_GameCorner_1F_EventScript_PokemonJumpInfo
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq MossdeepCity_GameCorner_1F_EventScript_DodrioBerryPickingInfo
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq MossdeepCity_GameCorner_1F_EventScript_MinigameInfoExit
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq MossdeepCity_GameCorner_1F_EventScript_MinigameInfoExit
	CloseMsg
	End
	
MossdeepCity_GameCorner_1F_EventScript_PokemonJumpInfo:
	NPCMsg msg_0520_T09PC0101_MossdeepCity_GameCorner_1F_Text_PokemonJumpInfo
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
MossdeepCity_GameCorner_1F_EventScript_DodrioBerryPickingInfo:
	NPCMsg msg_0520_T09PC0101_MossdeepCity_GameCorner_1F_Text_DodrioBerryPickingInfo
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
MossdeepCity_GameCorner_1F_EventScript_MinigameInfoExit:
	NPCMsg msg_0520_T09PC0101_MossdeepCity_GameCorner_1F_Text_TalkToOldManToPlay
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0520_T09PC0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
CinnabarIsland_PokemonCenter_1F_Movement_BillExit:
	WalkNormalWest 4
	WalkNormalSouth 3
	Delay8
	SetInvisible
	EndMovement

	.balign 4, 0
CinnabarIsland_PokemonCenter_1F_Movement_PlayerExitSouth:
	WalkNormalSouth
	WalkNormalWest 4
	WalkNormalSouth 2
	Delay16
	WalkNormalSouth
	EndMovement

	.balign 4, 0
CinnabarIsland_PokemonCenter_1F_Movement_BillExitEast:
	WalkNormalNorth
	WalkNormalWest 2
	WalkNormalSouth
	WalkNormalWest 2
	WalkNormalSouth 3
	Delay8
	SetInvisible
	EndMovement

	.balign 4, 0
CinnabarIsland_PokemonCenter_1F_Movement_PlayerExitEast:
	Delay16 3
	FaceWest
	Delay16
	WalkNormalWest 3
	WalkNormalSouth 2
	Delay8
	WalkNormalSouth
	Delay8
	SetInvisible
	EndMovement

	.balign 4, 0
CinnabarIsland_PokemonCenter_1F_Movement_PlayerExitWest:
	WalkNormalWest 5
	WalkNormalSouth 2
	Delay16
	WalkNormalSouth
	EndMovement
	.balign 4, 0
