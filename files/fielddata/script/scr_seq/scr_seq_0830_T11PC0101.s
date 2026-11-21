#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T11PC0101.h"
#include "msgdata/msg/msg_0532_T11PC0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SaffronCity_PokemonCenter_1F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SaffronCity_PokemonCenter_1F_EventScript_Nurse
	ScrDef SaffronCity_PokemonCenter_1F_EventScript_Gentleman
	ScrDef SaffronCity_PokemonCenter_1F_EventScript_Woman
	ScrDef SaffronCity_PokemonCenter_1F_EventScript_Youngster
	ScrDef SaffronCity_PokemonCenter_1F_EventScript_PokemonJournalSabrina
	ScrDef SaffronCity_PokemonCenter_1F_OnTransition
	ScrDef CableClub_OnResume
	ScrDefEnd
	
SaffronCity_PokemonCenter_1F_EventScript_Nurse:
	LockAll
	FacePlayer
	SetVar VAR_SPECIAL_x8007, 0
	CallStd std_nurse_joy
	CanvasCloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonCenter_1F_EventScript_Gentleman:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0532_T11PC0101_SaffronCity_PokemonCenter_1F_Text_SilphCoVictimOfFame
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonCenter_1F_EventScript_Woman:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0532_T11PC0101_SaffronCity_PokemonCenter_1F_Text_GrowthRatesDifferBySpecies
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonCenter_1F_EventScript_Youngster:
	LockAll
	FacePlayer
	CompareVarToValue 0x5031, 1
	GoToIfEq SaffronCity_PokemonCenter_1F_EventScript_YoungsterRocketsGone
	NPCMsg msg_0532_T11PC0101_SaffronCity_PokemonCenter_1F_Text_GreatIfEliteFourCameBeatRockets
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonCenter_1F_EventScript_PokemonJournalSabrina:
	LockAll
	FacePlayer
	NPCMsg msg_0532_T11PC0101_PokemonJournal_Text_SpecialFeatureSabrina
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonCenter_1F_OnTransition:
	End
	
CableClub_OnResume:
	// TODO(gba) special InitUnionRoom
	End
	
SaffronCity_PokemonCenter_1F_EventScript_YoungsterRocketsGone:
	NPCMsg msg_0532_T11PC0101_SaffronCity_PokemonCenter_1F_Text_TeamRocketTookOff
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0532_T11PC0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
