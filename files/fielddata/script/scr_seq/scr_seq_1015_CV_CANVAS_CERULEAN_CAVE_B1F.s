#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_CERULEAN_CAVE_B1F.h"
#include "msgdata/msg/msg_0879_CV_CANVAS_CERULEAN_CAVE_B1F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's CeruleanCave_B1F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef CeruleanCave_B1F_EventScript_ItemUltraBall
	ScrDef CeruleanCave_B1F_EventScript_ItemMaxRevive
	ScrDef CeruleanCave_B1F_EventScript_Mewtwo
	ScrDef CeruleanCave_B1F_OnResume
	ScrDef CeruleanCave_B1F_OnTransition
	ScrDefEnd
	
CeruleanCave_B1F_EventScript_ItemUltraBall:
	SetVar 0x8004, ITEM_ULTRA_BALL
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
CeruleanCave_B1F_EventScript_ItemMaxRevive:
	SetVar 0x8004, ITEM_MAX_REVIVE
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
CeruleanCave_B1F_EventScript_Mewtwo:
	LockAll
	FacePlayer
	WaitSE SEQ_SE_DP_SELECT
	PlayCry SPECIES_MEWTWO, 0
	NPCMsg msg_0879_CV_CANVAS_CERULEAN_CAVE_B1F_CeruleanCave_B1F_Text_Mew
	WaitCry
	Wait 20, VAR_SPECIAL_RESULT
	PlayBGM SEQ_GS_GYM
	WaitButton
	SetFlag 0x2032
	CloseMsg
	WildBattle SPECIES_MEWTWO, 70, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_wild_1
	WhiteOut
	ReleaseAll
	End
_cv_wild_1:
	ClearFlag 0x2032
	GetStaticEncounterOutcome VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfNe _cv_outcome_2
	SetVar VAR_SPECIAL_RESULT, 7
	GoTo _cv_outcome_3
_cv_outcome_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfNe _cv_outcome_3
	SetVar VAR_SPECIAL_RESULT, 4
_cv_outcome_3:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq CeruleanCave_B1F_EventScript_DefeatedMewtwo
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfEq CeruleanCave_B1F_EventScript_RanFromMewtwo
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfEq CeruleanCave_B1F_EventScript_RanFromMewtwo
	SetFlag 0x2176
	ReleaseAll
	End
	
CeruleanCave_B1F_OnResume:
	CallIfSet 0x2032, CeruleanCave_B1F_EventScript_TryRemoveMewtwo
	End
	
CeruleanCave_B1F_OnTransition:
	CallIfUnset 0x2176, CeruleanCave_B1F_EventScript_ShowMewtwo
	End
	
CeruleanCave_B1F_EventScript_DefeatedMewtwo:
	SetFlag 0x2176
	GoTo EventScript_RemoveStaticMon
	End
	
CeruleanCave_B1F_EventScript_RanFromMewtwo:
	SetVar 0x8004, SPECIES_MEWTWO
	GoTo EventScript_MonFlewAway
	End
	
CeruleanCave_B1F_EventScript_TryRemoveMewtwo:
	GetStaticEncounterOutcome 0x401C
	CompareVarToValue 0x401C, 4
	GoToIfNe _cv_outcome_4
	SetVar 0x401C, 7
	GoTo _cv_outcome_5
_cv_outcome_4:
	CompareVarToValue 0x401C, 5
	GoToIfNe _cv_outcome_5
	SetVar 0x401C, 4
_cv_outcome_5:
	CompareVarToValue 0x401C, 7
	GoToIfNe Common_EventScript_NopReturn
	HidePerson 0x401D
	Return
	
CeruleanCave_B1F_EventScript_ShowMewtwo:
	ClearFlag 0x2177
	Return
	
EventScript_RemoveStaticMon:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	HidePerson VAR_SPECIAL_LAST_TALKED
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	ReleaseAll
	End
	
EventScript_MonFlewAway:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	HidePerson VAR_SPECIAL_LAST_TALKED
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	BufferSpeciesName 0, 0x8004, 0, 0
	NPCMsg msg_0879_CV_CANVAS_CERULEAN_CAVE_B1F_Text_MonFlewAway
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Common_EventScript_NopReturn:
	Return

_cv_stop:
	NPCMsg msg_0879_CV_CANVAS_CERULEAN_CAVE_B1F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
