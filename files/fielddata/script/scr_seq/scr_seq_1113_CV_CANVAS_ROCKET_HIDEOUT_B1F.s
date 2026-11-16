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
	// TODO(gba) call_if_not_defeated TRAINER_TEAM_ROCKET_GRUNT_12 RocketHideout_B1F_EventScript_SetBarrier
	End
	
RocketHideout_B1F_OnTransition:
	End
	
RocketHideout_B1F_EventScript_DefeatedGrunt5:
	Call RocketHideout_B1F_EventScript_RemoveBarrier
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	ReleaseAll
	End
	
RocketHideout_B1F_EventScript_RemoveBarrier:
	// TODO(gba) setmetatile 20, 19, METATILE_SilphCo_HideoutFloor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 21, 19, METATILE_SilphCo_HideoutFloor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 20, 20, METATILE_SilphCo_HideoutFloor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 21, 20, METATILE_SilphCo_HideoutFloor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 20, 21, METATILE_SilphCo_HideoutFloor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 21, 21, METATILE_SilphCo_HideoutFloor, 0
	GoTo _cv_stop
	Return

_cv_stop:
	NPCMsg msg_0928_CV_CANVAS_ROCKET_HIDEOUT_B1F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
