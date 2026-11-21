#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T05PC0101.h"
#include "msgdata/msg/msg_0477_T05PC0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's LavenderTown_PokemonCenter_1F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef LavenderTown_PokemonCenter_1F_EventScript_Nurse
	ScrDef LavenderTown_PokemonCenter_1F_EventScript_Gentleman
	ScrDef LavenderTown_PokemonCenter_1F_EventScript_Lass
	ScrDef LavenderTown_PokemonCenter_1F_EventScript_Youngster
	ScrDef LavenderTown_PokemonCenter_1F_EventScript_BaldingMan
	ScrDef LavenderTown_PokemonCenter_1F_OnTransition
	ScrDef CableClub_OnResume
	ScrDefEnd
	
LavenderTown_PokemonCenter_1F_EventScript_Nurse:
	LockAll
	FacePlayer
	SetVar VAR_SPECIAL_x8007, 0
	CallStd std_nurse_joy
	CanvasCloseMsg
	ReleaseAll
	End
	
LavenderTown_PokemonCenter_1F_EventScript_Gentleman:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0477_T05PC0101_LavenderTown_PokemonCenter_1F_Text_RocketsDoAnythingForMoney
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
LavenderTown_PokemonCenter_1F_EventScript_Lass:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0477_T05PC0101_LavenderTown_PokemonCenter_1F_Text_CubonesMotherKilledByRockets
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
LavenderTown_PokemonCenter_1F_EventScript_Youngster:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0477_T05PC0101_LavenderTown_PokemonCenter_1F_Text_PeoplePayForCuboneSkulls
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
LavenderTown_PokemonCenter_1F_EventScript_BaldingMan:
	LockAll
	FacePlayer
	NPCMsg msg_0477_T05PC0101_LavenderTown_PokemonCenter_1F_Text_HearMrFujiNotFromAroundHere
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
LavenderTown_PokemonCenter_1F_OnTransition:
	End
	
CableClub_OnResume:
	// TODO(gba) special InitUnionRoom
	End

_cv_stop:
	NPCMsg msg_0477_T05PC0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
