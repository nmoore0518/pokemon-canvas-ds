#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T04PC0101.h"
#include "msgdata/msg/msg_0470_T04PC0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's CeruleanCity_PokemonCenter_1F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef CeruleanCity_PokemonCenter_1F_EventScript_Nurse
	ScrDef CeruleanCity_PokemonCenter_1F_EventScript_Gentleman
	ScrDef CeruleanCity_PokemonCenter_1F_EventScript_Rocker
	ScrDef CeruleanCity_PokemonCenter_1F_EventScript_Youngster
	ScrDef CeruleanCity_PokemonCenter_1F_EventScript_Lass
	ScrDef CeruleanCity_PokemonCenter_1F_EventScript_PokemonJournalMisty
	ScrDef CeruleanCity_PokemonCenter_1F_OnTransition
	ScrDef CableClub_OnResume
	ScrDefEnd
	
CeruleanCity_PokemonCenter_1F_EventScript_Nurse:
	LockAll
	FacePlayer
	SetVar VAR_SPECIAL_x8007, 0
	CallStd std_nurse_joy
	CanvasCloseMsg
	ReleaseAll
	End
	
CeruleanCity_PokemonCenter_1F_EventScript_Gentleman:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0470_T04PC0101_CeruleanCity_PokemonCenter_1F_Text_EveryoneCallsBillPokemaniac
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeruleanCity_PokemonCenter_1F_EventScript_Rocker:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0470_T04PC0101_CeruleanCity_PokemonCenter_1F_Text_BillDoesWhateverForRareMons
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeruleanCity_PokemonCenter_1F_EventScript_Youngster:
	LockAll
	FacePlayer
	NPCMsg msg_0470_T04PC0101_CeruleanCity_PokemonCenter_1F_Text_BillCollectsRareMons
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeruleanCity_PokemonCenter_1F_EventScript_Lass:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0470_T04PC0101_CeruleanCity_PokemonCenter_1F_Text_TryTradingUpstairs
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeruleanCity_PokemonCenter_1F_EventScript_PokemonJournalMisty:
	LockAll
	FacePlayer
	NPCMsg msg_0470_T04PC0101_PokemonJournal_Text_SpecialFeatureMisty
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeruleanCity_PokemonCenter_1F_OnTransition:
	End
	
CableClub_OnResume:
	// TODO(gba) special InitUnionRoom
	End

_cv_stop:
	NPCMsg msg_0470_T04PC0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
