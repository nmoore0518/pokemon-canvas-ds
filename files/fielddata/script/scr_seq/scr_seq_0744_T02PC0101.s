#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T02PC0101.h"
#include "msgdata/msg/msg_0455_T02PC0101.h"
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
	NPCMsg msg_0455_T02PC0101_PalletTown_PokemonCenter_1F_Text_FeelFreeToUsePC
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_PokemonCenter_1F_EventScript_Boy:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0455_T02PC0101_PalletTown_PokemonCenter_1F_Text_PokeCenterInEveryTown
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_PokemonCenter_1F_EventScript_Youngster:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0455_T02PC0101_PalletTown_PokemonCenter_1F_Text_PokeCentersHealMons
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
	End

_cv_stop:
	NPCMsg msg_0455_T02PC0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
