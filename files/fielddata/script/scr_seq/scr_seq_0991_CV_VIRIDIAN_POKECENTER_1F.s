#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_VIRIDIAN_POKECENTER_1F.h"
#include "msgdata/msg/msg_0867_CV_VIRIDIAN_POKECENTER_1F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's ViridianCity_PokemonCenter_1F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef ViridianCity_PokemonCenter_1F_EventScript_Nurse
	ScrDef ViridianCity_PokemonCenter_1F_EventScript_Gentleman
	ScrDef ViridianCity_PokemonCenter_1F_EventScript_Boy
	ScrDef ViridianCity_PokemonCenter_1F_EventScript_Youngster
	ScrDef ViridianCity_PokemonCenter_1F_EventScript_HealPadScientist
	ScrDef ViridianCity_PokemonCenter_1F_OnTransition
	ScrDef CableClub_OnResume
	ScrDefEnd
	
ViridianCity_PokemonCenter_1F_EventScript_Nurse:
	LockAll
	FacePlayer
	SetVar VAR_SPECIAL_x8007, 0
	CallStd std_nurse_joy
	ReleaseAll
	End
	
ViridianCity_PokemonCenter_1F_EventScript_Gentleman:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0867_CV_VIRIDIAN_POKECENTER_1F_ViridianCity_PokemonCenter_1F_Text_FeelFreeToUsePC
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianCity_PokemonCenter_1F_EventScript_Boy:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0867_CV_VIRIDIAN_POKECENTER_1F_ViridianCity_PokemonCenter_1F_Text_PokeCenterInEveryTown
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianCity_PokemonCenter_1F_EventScript_Youngster:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0867_CV_VIRIDIAN_POKECENTER_1F_ViridianCity_PokemonCenter_1F_Text_PokeCentersHealMons
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianCity_PokemonCenter_1F_EventScript_HealPadScientist:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0867_CV_VIRIDIAN_POKECENTER_1F_Text_HealPadInnovator
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianCity_PokemonCenter_1F_OnTransition:
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
	NPCMsg msg_0867_CV_VIRIDIAN_POKECENTER_1F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
