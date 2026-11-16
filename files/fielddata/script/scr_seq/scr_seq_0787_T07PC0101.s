#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T07PC0101.h"
#include "msgdata/msg/msg_0493_T07PC0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's CeladonCity_PokemonCenter_1F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef CeladonCity_PokemonCenter_1F_EventScript_Nurse
	ScrDef CeladonCity_PokemonCenter_1F_EventScript_Gentleman
	ScrDef CeladonCity_PokemonCenter_1F_EventScript_CooltrainerF
	ScrDef CeladonCity_PokemonCenter_1F_EventScript_Youngster
	ScrDef CeladonCity_PokemonCenter_1F_OnTransition
	ScrDef CableClub_OnResume
	ScrDefEnd
	
CeladonCity_PokemonCenter_1F_EventScript_Nurse:
	LockAll
	FacePlayer
	SetVar VAR_SPECIAL_x8007, 0
	CallStd std_nurse_joy
	ReleaseAll
	End
	
CeladonCity_PokemonCenter_1F_EventScript_Gentleman:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0493_T07PC0101_CeladonCity_PokemonCenter_1F_Text_PokeFluteAwakensSleepingMons
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_PokemonCenter_1F_EventScript_CooltrainerF:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0493_T07PC0101_CeladonCity_PokemonCenter_1F_Text_RodeHereFromFuchsia
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_PokemonCenter_1F_EventScript_Youngster:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0493_T07PC0101_CeladonCity_PokemonCenter_1F_Text_GoToCyclingRoadIfIHadBike
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_PokemonCenter_1F_OnTransition:
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
	NPCMsg msg_0493_T07PC0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
