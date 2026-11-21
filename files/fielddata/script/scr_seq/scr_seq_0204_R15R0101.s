#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R15R0101.h"
#include "msgdata/msg/msg_0353_R15R0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route15_WestEntrance_1F_Frlg+Route15_WestEntrance_2F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route15_WestEntrance_1F_EventScript_Guard
	ScrDef Route15_WestEntrance_2F_EventScript_Aide
	ScrDef Route15_WestEntrance_2F_EventScript_LeftBinoculars
	ScrDef Route15_WestEntrance_2F_EventScript_RightBinoculars
	ScrDefEnd
	
Route15_WestEntrance_1F_EventScript_Guard:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0353_R15R0101_Route15_WestEntrance_1F_Text_OaksAideCameByHere
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route15_WestEntrance_2F_EventScript_Aide:
	LockAll
	FacePlayer
	Call Route15_WestEntrance_2F_EventScript_GetAideRequestInfo
	GoToIfSet 0x22E4, Route15_WestEntrance_2F_EventScript_AlreadyGotExpShare
	BufferPlayersName 6
	NPCMsg msg_0353_R15R0101_Route15_WestEntrance_2F_Text_GiveItemIfCaughtEnough
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Aide_EventScript_DeclineCheckMons
	SetVar 0x8004, 0
	CountNationalDexSeen 0x8005
	CountNationalDexOwned 0x8006
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x2026, _cv_dex_3
	SetVar VAR_SPECIAL_RESULT, 1
_cv_dex_3:
	BufferInt 2, 0x8006
	Call Route15_WestEntrance_2F_EventScript_GetAideRequestInfo
	CompareVarToValue 0x8006, 50
	GoToIfLt Aide_EventScript_HaventCaughtEnough
	NPCMsg msg_0353_R15R0101_Route15_WestEntrance_2F_Text_GreatHereYouGo
	WaitButton
	HasSpaceForItem 216, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Aide_EventScript_NoRoomForItem
	GiveItem 216, 1, VAR_SPECIAL_RESULT
	BufferItemName 1, 216
	BufferPlayersName 6
	NPCMsg msg_0353_R15R0101_Route15_WestEntrance_2F_Text_ReceivedItemFromAide
	PlayFanfare SEQ_ME_LVUP
	WaitFanfare
	WaitButton
	SetFlag 0x22E4
	NPCMsg msg_0353_R15R0101_Route15_WestEntrance_2F_Text_ExplainExpShare
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route15_WestEntrance_2F_EventScript_LeftBinoculars:
	LockAll
	NPCMsg msg_0353_R15R0101_Route15_WestEntrance_2F_Text_LargeShiningBird
	WaitButton
	ScrCmd_452 SPECIES_ARTICUNO, 0
	SetVar 0x5065, 1
	Wait 20, VAR_SPECIAL_RESULT
	WaitButton
	CompareVarToValue 0x5065, 1
	GoToIfNe _cv_nopic_4
	ScrCmd_453
	SetVar 0x5065, 0
_cv_nopic_4:
	SetVar 0x8004, SPECIES_ARTICUNO
	CloseMsg
	ReleaseAll
	End
	
Route15_WestEntrance_2F_EventScript_RightBinoculars:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0353_R15R0101_Route15_WestEntrance_2F_Text_SmallIslandOnHorizon
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route15_WestEntrance_2F_EventScript_GetAideRequestInfo:
	BufferInt 0, 50
	BufferItemName 1, 216
	Return
	
Route15_WestEntrance_2F_EventScript_AlreadyGotExpShare:
	NPCMsg msg_0353_R15R0101_Route15_WestEntrance_2F_Text_ExplainExpShare
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Aide_EventScript_DeclineCheckMons:
	NPCMsg msg_0353_R15R0101_Aide_Text_GetEnoughMonsComeBackForItem
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Aide_EventScript_HaventCaughtEnough:
	NPCMsg msg_0353_R15R0101_Aide_Text_HaventCaughtEnoughMonsForItem
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Aide_EventScript_NoRoomForItem:
	NPCMsg msg_0353_R15R0101_Aide_Text_DontHaveAnyRoomForItem
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0353_R15R0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
