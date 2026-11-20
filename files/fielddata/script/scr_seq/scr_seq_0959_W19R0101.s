#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_W19R0101.h"
#include "msgdata/msg/msg_0741_W19R0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route12_NorthEntrance_1F_Frlg+Route12_NorthEntrance_2F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route12_NorthEntrance_1F_EventScript_Guard
	ScrDef Route12_NorthEntrance_2F_EventScript_Lass
	ScrDef Route12_NorthEntrance_2F_EventScript_LeftBinoculars
	ScrDef Route12_NorthEntrance_2F_EventScript_RightBinoculars
	ScrDefEnd
	
Route12_NorthEntrance_1F_EventScript_Guard:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0741_W19R0101_Route12_NorthEntrance_1F_Text_LookoutSpotUpstairs
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route12_NorthEntrance_2F_EventScript_Lass:
	LockAll
	FacePlayer
	GoToIfSet 0x22E3, Route12_NorthEntrance_2F_EventScript_ExplainTM27
	GetPlayerGender VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	CallIfEq Route12_NorthEntrance_2F_EventScript_TakeTMMale
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq Route12_NorthEntrance_2F_EventScript_TakeTMFemale
	HasSpaceForItem ITEM_TM27, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Route12_NorthEntrance_2F_EventScript_NoRoomForTM27
	GiveItem ITEM_TM27, 1, VAR_SPECIAL_RESULT
	BufferItemName 1, ITEM_TM27
	BufferPlayersName 6
	NPCMsg msg_0741_W19R0101_Route12_NorthEntrance_2F_Text_ReceivedTM27FromLittleGirl
	PlayFanfare SEQ_ME_LVUP
	WaitFanfare
	WaitButton
	NPCMsg msg_0741_W19R0101_Route12_NorthEntrance_2F_Text_ExplainTM27
	WaitButton
	SetFlag 0x22E3
	CloseMsg
	ReleaseAll
	End
	
Route12_NorthEntrance_2F_EventScript_LeftBinoculars:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0741_W19R0101_Route12_NorthEntrance_2F_Text_TheresManFishing
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route12_NorthEntrance_2F_EventScript_RightBinoculars:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0741_W19R0101_Route12_NorthEntrance_2F_Text_ItsPokemonTower
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route12_NorthEntrance_2F_EventScript_ExplainTM27:
	NPCMsg msg_0741_W19R0101_Route12_NorthEntrance_2F_Text_ExplainTM27
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route12_NorthEntrance_2F_EventScript_TakeTMMale:
	NPCMsg msg_0741_W19R0101_Route12_NorthEntrance_2F_Text_TakeTMDontNeedAnymoreMale
	WaitButton
	Return
	
Route12_NorthEntrance_2F_EventScript_TakeTMFemale:
	NPCMsg msg_0741_W19R0101_Route12_NorthEntrance_2F_Text_TakeTMDontNeedAnymoreFemale
	WaitButton
	Return
	
Route12_NorthEntrance_2F_EventScript_NoRoomForTM27:
	NPCMsg msg_0741_W19R0101_Route12_NorthEntrance_2F_Text_DontHaveRoomForThis
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0741_W19R0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
