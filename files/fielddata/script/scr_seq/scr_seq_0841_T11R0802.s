#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T11R0802.h"
#include "msgdata/msg/msg_0541_T11R0802.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SaffronCity_CopycatsHouse_2F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SaffronCity_CopycatsHouse_2F_EventScript_Doduo
	ScrDef SaffronCity_CopycatsHouse_2F_EventScript_Doll
	ScrDef SaffronCity_CopycatsHouse_2F_EventScript_Copycat
	ScrDef SaffronCity_CopycatsHouse_2F_EventScript_Computer
	ScrDef SaffronCity_CopycatsHouse_2F_EventScript_Game
	ScrDefEnd
	
SaffronCity_CopycatsHouse_2F_EventScript_Doduo:
	LockAll
	FacePlayer
	WaitSE SEQ_SE_DP_SELECT
	PlayCry SPECIES_DODUO, 0
	NPCMsg msg_0541_T11R0802_SaffronCity_CopycatsHouse_2F_Text_Doduo
	WaitButton
	WaitCry
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_CopycatsHouse_2F_EventScript_Doll:
	LockAll
	NPCMsg msg_0541_T11R0802_SaffronCity_CopycatsHouse_2F_Text_RareMonOnlyDoll
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_CopycatsHouse_2F_EventScript_Copycat:
	LockAll
	FacePlayer
	HasItem ITEM_POKE_DOLL, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq EventScript_MimicTutor
	GetPlayerGender VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	CallIfEq SaffronCity_CopycatsHouse_2F_EventScript_MimicPlayerMale
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq SaffronCity_CopycatsHouse_2F_EventScript_MimicPlayerFemale
	ReleaseAll
	End
	
SaffronCity_CopycatsHouse_2F_EventScript_Computer:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0541_T11R0802_SaffronCity_CopycatsHouse_2F_Text_MySecrets
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_CopycatsHouse_2F_EventScript_Game:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0541_T11R0802_SaffronCity_CopycatsHouse_2F_Text_MarioWearingABucket
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_MimicTutor:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0541_T11R0802_Text_MimicTutor_Retired
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_CopycatsHouse_2F_EventScript_MimicPlayerMale:
	BufferPlayersName 6
	NPCMsg msg_0541_T11R0802_SaffronCity_CopycatsHouse_2F_Text_MimickingFavoriteHobbyMale
	WaitButton
	Return
	
SaffronCity_CopycatsHouse_2F_EventScript_MimicPlayerFemale:
	BufferPlayersName 6
	NPCMsg msg_0541_T11R0802_SaffronCity_CopycatsHouse_2F_Text_MimickingFavoriteHobbyFemale
	WaitButton
	Return

_cv_stop:
	NPCMsg msg_0541_T11R0802_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
