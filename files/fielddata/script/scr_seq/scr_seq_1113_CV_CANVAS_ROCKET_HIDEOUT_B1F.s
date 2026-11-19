#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_ROCKET_HIDEOUT_B1F.h"
#include "msgdata/msg/msg_0928_CV_CANVAS_ROCKET_HIDEOUT_B1F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's RocketHideout_B1F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef RocketHideout_B1F_EventScript_Grunt5
	ScrDef RocketHideout_B1F_EventScript_ItemEscapeRope
	ScrDef RocketHideout_B1F_EventScript_ItemHyperPotion
	ScrDef BerryField_EventScript_FindDark
	ScrDef RocketHideout_B1F_OnLoad
	ScrDef RocketHideout_B1F_OnTransition
	ScrDef RocketHideout_B1F_Frlg_cv_Barriers
	ScrDefEnd
	
RocketHideout_B1F_EventScript_Grunt5:
	CheckTrainerFlag 1098
	GoToIf TRUE, _cv_beaten_1
	NPCMsg msg_0928_CV_CANVAS_ROCKET_HIDEOUT_B1F_RocketHideout_B1F_Text_Grunt5Intro
	WaitButton
	CloseMsg
	TrainerBattle 1098, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_2
	WhiteOut
	End
_cv_won_2:
	SetTrainerFlag 1098
	GoTo RocketHideout_B1F_EventScript_DefeatedGrunt5
_cv_beaten_1:
	NPCMsg msg_0928_CV_CANVAS_ROCKET_HIDEOUT_B1F_RocketHideout_B1F_Text_Grunt5PostBattle
	WaitButton
	CloseMsg
	End
	
RocketHideout_B1F_EventScript_ItemEscapeRope:
	SetVar 0x8004, ITEM_ESCAPE_ROPE
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
RocketHideout_B1F_EventScript_ItemHyperPotion:
	SetVar 0x8004, ITEM_HYPER_POTION
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
BerryField_EventScript_FindDark:
	SetVar 0x8004, ITEM_COLBUR_BERRY
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
RocketHideout_B1F_OnLoad:
	CheckTrainerFlag 1098
	CallIf FALSE, RocketHideout_B1F_EventScript_SetBarrier
	End
	
RocketHideout_B1F_OnTransition:
	End
	
RocketHideout_B1F_Frlg_cv_Barriers:
	SetVar 0x5044, 1
	SetFlag 0x2258
	SetFlag 0x2259
	SetFlag 0x225A
	SetFlag 0x225B
	Call RocketHideout_B1F_OnLoad_cv_init
	SetVar 0x5044, 0
	GoTo RocketHideout_B1F_OnTransition
	
RocketHideout_B1F_EventScript_DefeatedGrunt5:
	Call RocketHideout_B1F_EventScript_RemoveBarrier
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	ReleaseAll
	End
	
RocketHideout_B1F_EventScript_SetBarrier:
	GoToIfUnset 0x2258, _cv_bar_3
	ClearFlag 0x2258
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_3
	ShowPerson 200
_cv_bar_3:
	GoToIfUnset 0x2259, _cv_bar_4
	ClearFlag 0x2259
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_4
	ShowPerson 201
_cv_bar_4:
	GoToIfUnset 0x225A, _cv_bar_5
	ClearFlag 0x225A
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_5
	ShowPerson 202
_cv_bar_5:
	GoToIfUnset 0x225B, _cv_bar_6
	ClearFlag 0x225B
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_6
	ShowPerson 203
_cv_bar_6:
	// (the GBA redraws a square here: 20, 21, METATILE_SilphCo_HideoutFloor_ShadeFull, 0)
	// (the GBA redraws a square here: 21, 21, METATILE_SilphCo_HideoutFloor_ShadeFull, 0)
	Return
	
RocketHideout_B1F_OnLoad_cv_init:
	CheckTrainerFlag 1098
	CallIf FALSE, RocketHideout_B1F_EventScript_SetBarrier
	Return
	
RocketHideout_B1F_EventScript_RemoveBarrier:
	GoToIfSet 0x2258, _cv_bar_7
	SetFlag 0x2258
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_7
	HidePerson 200
_cv_bar_7:
	GoToIfSet 0x2259, _cv_bar_8
	SetFlag 0x2259
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_8
	HidePerson 201
_cv_bar_8:
	GoToIfSet 0x225A, _cv_bar_9
	SetFlag 0x225A
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_9
	HidePerson 202
_cv_bar_9:
	GoToIfSet 0x225B, _cv_bar_10
	SetFlag 0x225B
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_10
	HidePerson 203
_cv_bar_10:
	// (the GBA redraws a square here: 20, 21, METATILE_SilphCo_HideoutFloor_ShadeFull, 0)
	// (the GBA redraws a square here: 21, 21, METATILE_SilphCo_HideoutFloor, 0)
	Return

_cv_stop:
	NPCMsg msg_0928_CV_CANVAS_ROCKET_HIDEOUT_B1F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
