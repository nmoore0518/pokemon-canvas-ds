#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T06PC0101.h"
#include "msgdata/msg/msg_0486_T06PC0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's VermilionCity_PokemonCenter_1F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef VermilionCity_PokemonCenter_1F_EventScript_Nurse
	ScrDef VermilionCity_PokemonCenter_1F_EventScript_Man
	ScrDef VermilionCity_PokemonCenter_1F_EventScript_Hiker
	ScrDef VermilionCity_PokemonCenter_1F_EventScript_Youngster
	ScrDef VermilionCity_PokemonCenter_1F_EventScript_VSSeekerWoman
	ScrDef VermilionCity_PokemonCenter_1F_EventScript_PokemonJournalLtSurge
	ScrDef VermilionCity_PokemonCenter_1F_OnTransition
	ScrDef CableClub_OnResume
	ScrDefEnd
	
VermilionCity_PokemonCenter_1F_EventScript_Nurse:
	LockAll
	FacePlayer
	SetVar VAR_SPECIAL_x8007, 0
	CallStd std_nurse_joy
	CanvasCloseMsg
	ReleaseAll
	End
	
VermilionCity_PokemonCenter_1F_EventScript_Man:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0486_T06PC0101_VermilionCity_PokemonCenter_1F_Text_PoisonedMonFaintedWhileWalking
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_PokemonCenter_1F_EventScript_Hiker:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0486_T06PC0101_VermilionCity_PokemonCenter_1F_Text_TrainerMonsStrongerThanWild
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_PokemonCenter_1F_EventScript_Youngster:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0486_T06PC0101_VermilionCity_PokemonCenter_1F_Text_AllMonWeakToSpecificTypes
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_PokemonCenter_1F_EventScript_VSSeekerWoman:
	LockAll
	FacePlayer
	GoToIfSet 0x2121, VermilionCity_PokemonCenter_1F_EventScript_ExplainVSSeeker
	NPCMsg msg_0486_T06PC0101_VermilionCity_PokemonCenter_1F_Text_UrgeToBattleSomeoneAgain
	WaitButton
	SetFlag 0x2121
	GiveItem 443, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq EventScript_BagIsFull
	NPCMsg msg_0486_T06PC0101_VermilionCity_PokemonCenter_1F_Text_UseDeviceForRematches
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_PokemonCenter_1F_EventScript_PokemonJournalLtSurge:
	LockAll
	NPCMsg msg_0486_T06PC0101_PokemonJournal_Text_SpecialFeatureLtSurge
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_PokemonCenter_1F_OnTransition:
	End
	
CableClub_OnResume:
	// TODO(gba) special InitUnionRoom
	End
	
VermilionCity_PokemonCenter_1F_EventScript_ExplainVSSeeker:
	NPCMsg msg_0486_T06PC0101_VermilionCity_PokemonCenter_1F_Text_ExplainVSSeeker
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_BagIsFull:
	NPCMsg msg_0486_T06PC0101_gText_TooBadBagIsFull
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0486_T06PC0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
