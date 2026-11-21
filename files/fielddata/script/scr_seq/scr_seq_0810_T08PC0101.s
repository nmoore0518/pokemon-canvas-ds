#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T08PC0101.h"
#include "msgdata/msg/msg_0515_T08PC0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's FuchsiaCity_PokemonCenter_1F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef FuchsiaCity_PokemonCenter_1F_EventScript_Nurse
	ScrDef FuchsiaCity_PokemonCenter_1F_EventScript_Man
	ScrDef FuchsiaCity_PokemonCenter_1F_EventScript_CooltrainerF
	ScrDef FuchsiaCity_PokemonCenter_1F_EventScript_Youngster
	ScrDef FuchsiaCity_PokemonCenter_1F_OnTransition
	ScrDef CableClub_OnResume
	ScrDefEnd
	
FuchsiaCity_PokemonCenter_1F_EventScript_Nurse:
	LockAll
	FacePlayer
	SetVar VAR_SPECIAL_x8007, 0
	CallStd std_nurse_joy
	CanvasCloseMsg
	ReleaseAll
	End
	
FuchsiaCity_PokemonCenter_1F_EventScript_Man:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0515_T08PC0101_FuchsiaCity_PokemonCenter_1F_Text_CantBecomeGoodTrainerWithOneMon
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_PokemonCenter_1F_EventScript_CooltrainerF:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0515_T08PC0101_FuchsiaCity_PokemonCenter_1F_Text_PokemonLeagueWestOfViridian
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_PokemonCenter_1F_EventScript_Youngster:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0515_T08PC0101_FuchsiaCity_PokemonCenter_1F_Text_VisitSafariZoneForPokedex
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_PokemonCenter_1F_OnTransition:
	End
	
CableClub_OnResume:
	// TODO(gba) special InitUnionRoom
	End

_cv_stop:
	NPCMsg msg_0515_T08PC0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
