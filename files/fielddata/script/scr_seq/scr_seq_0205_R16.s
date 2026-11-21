#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R16.h"
#include "msgdata/msg/msg_0354_R16.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route16_Frlg#world by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route16_EventScript_Snorlax
	ScrDef Route16_EventScript_RouteSign
	ScrDef Route16_EventScript_CyclingRoadSign
	ScrDef Route16_OnResume
	ScrDef Route16_OnTransition
	ScrDefEnd
	
Route16_EventScript_Snorlax:
	LockAll
	FacePlayer
	GoToIfUnset 0x2107, Route16_EventScript_SnorlaxNoPokeFlute
	NPCMsg msg_0354_R16_Text_WantToUsePokeFlute
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Route16_EventScript_DontUsePokeFlute
	Call EventScript_AwakenSnorlax
	WaitSE SEQ_SE_DP_SELECT
	PlayCry SPECIES_SNORLAX, 0
	Wait 40, VAR_SPECIAL_RESULT
	WaitCry
	SetFlag 0x2120
	SetFlag 0x2032
	CloseMsg
	WildBattle SPECIES_SNORLAX, 30, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_wild_3
	WhiteOut
	ReleaseAll
	End
_cv_wild_3:
	HidePerson VAR_SPECIAL_LAST_TALKED
	ClearFlag 0x2032
	GetStaticEncounterOutcome VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfNe _cv_outcome_4
	SetVar VAR_SPECIAL_RESULT, 7
	GoTo _cv_outcome_5
_cv_outcome_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfNe _cv_outcome_5
	SetVar VAR_SPECIAL_RESULT, 4
_cv_outcome_5:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Route16_EventScript_FoughtSnorlax
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfEq Route16_EventScript_FoughtSnorlax
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfEq Route16_EventScript_FoughtSnorlax
	CanvasCloseMsg
	ReleaseAll
	End
	
Route16_EventScript_RouteSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0354_R16_Route16_Text_RouteSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route16_EventScript_CyclingRoadSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0354_R16_Route16_Text_CyclingRoadSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route16_OnResume:
	CallIfSet 0x2032, Route16_EventScript_RemoveSnorlax
	End
	
Route16_OnTransition:
	CompareVarToValue 0x5030, 1
	CallIfEq Route16_OnTransitionCyclingRoad
	End
	
Route16_EventScript_SnorlaxNoPokeFlute:
	NPCMsg msg_0354_R16_Route16_Text_MonSprawledOutInSlumber
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route16_EventScript_DontUsePokeFlute:
	CanvasCloseMsg
	ReleaseAll
	End
	
EventScript_AwakenSnorlax:
	BufferPlayersName 6
	NPCMsg msg_0354_R16_Text_PlayedPokeFlute
	PlayFanfare SEQ_ME_ITEM
	WaitFanfare
	NPCMsg msg_0354_R16_Text_SnorlaxWokeUp
	WaitButton
	Return
	
Route16_EventScript_FoughtSnorlax:
	NPCMsg msg_0354_R16_Text_SnorlaxReturnedToMountains
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route16_EventScript_RemoveSnorlax:
	HidePerson 0x401D
	Return
	
Route16_OnTransitionCyclingRoad:
	SetFlag 0x210F
	Return

_cv_stop:
	NPCMsg msg_0354_R16_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
