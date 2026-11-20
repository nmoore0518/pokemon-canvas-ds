#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_FIGHT_AREA_UNUSED_2.h"
#include "msgdata/msg/msg_0951_CV_FIGHT_AREA_UNUSED_2.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PalletTown_PokemonCenter_1F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef PalletTown_PokemonCenter_1F_EventScript_Nurse
	ScrDef PalletTown_PokemonCenter_1F_EventScript_Gentleman
	ScrDef PalletTown_PokemonCenter_1F_EventScript_Boy
	ScrDef PalletTown_PokemonCenter_1F_EventScript_Youngster
	ScrDef PalletTown_PokemonCenter_1F_OnTransition
	ScrDef CableClub_OnResume
	ScrDefEnd
	
PalletTown_PokemonCenter_1F_EventScript_Nurse:
	LockAll
	FacePlayer
	SetVar VAR_SPECIAL_x8007, 0
	CallStd std_nurse_joy
	ReleaseAll
	End
	
PalletTown_PokemonCenter_1F_EventScript_Gentleman:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0951_CV_FIGHT_AREA_UNUSED_2_PalletTown_PokemonCenter_1F_Text_FeelFreeToUsePC
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_PokemonCenter_1F_EventScript_Boy:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0951_CV_FIGHT_AREA_UNUSED_2_PalletTown_PokemonCenter_1F_Text_PokeCenterInEveryTown
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_PokemonCenter_1F_EventScript_Youngster:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0951_CV_FIGHT_AREA_UNUSED_2_PalletTown_PokemonCenter_1F_Text_PokeCentersHealMons
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_PokemonCenter_1F_OnTransition:
	End
	
CableClub_OnResume:
	// TODO(gba) special InitUnionRoom
	// TODO(gba) .if OW_FLAG_MOVE_UNION_ROOM_CHECK != 0
	Return
	// TODO(gba) .else 
	End
	// TODO(gba) .endif 
	GoTo MossdeepCity_GameCorner_1F_EventScript_InfoMan2
	
MossdeepCity_GameCorner_1F_EventScript_InfoMan2:
	LockAll
	FacePlayer
	NPCMsg msg_0951_CV_FIGHT_AREA_UNUSED_2_MossdeepCity_GameCorner_1F_Text_DescribeWhichGame
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0951_CV_FIGHT_AREA_UNUSED_2_cv_mc_wireless_minigame_0, 0
	ScrCmd_559 msg_0951_CV_FIGHT_AREA_UNUSED_2_cv_mc_wireless_minigame_1, 1
	ScrCmd_559 msg_0951_CV_FIGHT_AREA_UNUSED_2_cv_mc_wireless_minigame_2, 2
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_2
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_2:
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
	NPCMsg msg_0951_CV_FIGHT_AREA_UNUSED_2_MossdeepCity_GameCorner_1F_Text_PokemonJumpInfo
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
MossdeepCity_GameCorner_1F_EventScript_DodrioBerryPickingInfo:
	NPCMsg msg_0951_CV_FIGHT_AREA_UNUSED_2_MossdeepCity_GameCorner_1F_Text_DodrioBerryPickingInfo
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
MossdeepCity_GameCorner_1F_EventScript_MinigameInfoExit:
	NPCMsg msg_0951_CV_FIGHT_AREA_UNUSED_2_MossdeepCity_GameCorner_1F_Text_TalkToOldManToPlay
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0951_CV_FIGHT_AREA_UNUSED_2_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
