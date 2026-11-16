#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_ROCKET_HIDEOUT_B4F.h"
#include "msgdata/msg/msg_0931_CV_CANVAS_ROCKET_HIDEOUT_B4F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's RocketHideout_B4F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef RocketHideout_B4F_EventScript_Giovanni
	ScrDef RocketHideout_B4F_EventScript_SilphScope
	ScrDef RocketHideout_B4F_EventScript_Grunt1
	ScrDef RocketHideout_B4F_EventScript_LiftKey
	ScrDef RocketHideout_B4F_EventScript_Grunt3
	ScrDef RocketHideout_B4F_EventScript_Grunt2
	ScrDef RocketHideout_B4F_EventScript_ItemTM49
	ScrDef RocketHideout_B4F_EventScript_ItemMaxEther
	ScrDef RocketHideout_B4F_EventScript_ItemCalcium
	ScrDef RocketHideout_B4F_EventScript_ItemTM36
	ScrDef RocketHideout_B4F_OnLoad
	ScrDefEnd
	
RocketHideout_B4F_EventScript_Giovanni:
	LockAll
	FacePlayer
	NPCMsg msg_0931_CV_CANVAS_ROCKET_HIDEOUT_B4F_RocketHideout_B4F_Text_GiovanniIntro
	PlayBGM SEQ_GS_EYE_ROCKET
	WaitButton
	CheckTrainerFlag 1084
	GoToIf TRUE, _cv_beaten_1
	TrainerBattle 1084, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_2
	WhiteOut
	End
_cv_won_2:
	SetTrainerFlag 1084
	ReleaseAll
	End
_cv_beaten_1:
	NPCMsg msg_0931_CV_CANVAS_ROCKET_HIDEOUT_B4F_RocketHideout_B4F_Text_GiovanniPostBattle
	WaitButton
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	CloseMsg
	HidePerson 1
	SetFlag 0x21E9
	GoToIfUnset 0x205E, _cv_show_3
	ClearFlag 0x205E
	ShowPerson 2
	SetFlag 0x205E
	GoTo _cv_shown_4
_cv_show_3:
	ShowPerson 2
_cv_shown_4:
	ClearFlag 0x205E
	SetFlag 0x20F7
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	ReleaseAll
	End
	
RocketHideout_B4F_EventScript_SilphScope:
	LockAll
	FacePlayer
	HidePerson 2
	SetFlag 0x205E
	GiveItem 874, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq EventScript_BagIsFull
	ReleaseAll
	End
	
RocketHideout_B4F_EventScript_Grunt1:
	CheckTrainerFlag 1104
	GoToIf TRUE, _cv_beaten_5
	NPCMsg msg_0931_CV_CANVAS_ROCKET_HIDEOUT_B4F_RocketHideout_B4F_Text_Grunt1Intro
	WaitButton
	CloseMsg
	TrainerBattle 1104, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_6
	WhiteOut
	End
_cv_won_6:
	SetTrainerFlag 1104
	GoTo RocketHideout_B4F_EventScript_DefeatedGrunt1
_cv_beaten_5:
	NPCMsg msg_0931_CV_CANVAS_ROCKET_HIDEOUT_B4F_RocketHideout_B4F_Text_Grunt1PostBattle
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
RocketHideout_B4F_EventScript_LiftKey:
	LockAll
	FacePlayer
	SetFlag 0x21EA
	HidePerson 4
	SetFlag 0x205D
	GiveItem 878, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq EventScript_BagIsFull
	ReleaseAll
	End
	
RocketHideout_B4F_EventScript_Grunt3:
	CheckTrainerFlag 1103
	GoToIf TRUE, _cv_beaten_7
	NPCMsg msg_0931_CV_CANVAS_ROCKET_HIDEOUT_B4F_RocketHideout_B4F_Text_Grunt3Intro
	WaitButton
	CloseMsg
	TrainerBattle 1103, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_8
	WhiteOut
	End
_cv_won_8:
	SetTrainerFlag 1103
	GoTo RocketHideout_B4F_EventScript_DefeatedGrunt3
_cv_beaten_7:
	NPCMsg msg_0931_CV_CANVAS_ROCKET_HIDEOUT_B4F_RocketHideout_B4F_Text_Grunt3PostBattle
	WaitButton
	CloseMsg
	End
	
RocketHideout_B4F_EventScript_Grunt2:
	CheckTrainerFlag 1102
	GoToIf TRUE, _cv_beaten_9
	NPCMsg msg_0931_CV_CANVAS_ROCKET_HIDEOUT_B4F_RocketHideout_B4F_Text_Grunt2Intro
	WaitButton
	CloseMsg
	TrainerBattle 1102, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_10
	WhiteOut
	End
_cv_won_10:
	SetTrainerFlag 1102
	GoTo RocketHideout_B4F_EventScript_DefeatedGrunt2
_cv_beaten_9:
	NPCMsg msg_0931_CV_CANVAS_ROCKET_HIDEOUT_B4F_RocketHideout_B4F_Text_Grunt2PostBattle
	WaitButton
	CloseMsg
	End
	
RocketHideout_B4F_EventScript_ItemTM49:
	SetVar 0x8004, ITEM_TM49
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
RocketHideout_B4F_EventScript_ItemMaxEther:
	SetVar 0x8004, ITEM_MAX_ETHER
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
RocketHideout_B4F_EventScript_ItemCalcium:
	SetVar 0x8004, ITEM_CALCIUM
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
RocketHideout_B4F_EventScript_ItemTM36:
	SetVar 0x8004, ITEM_TM36
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
RocketHideout_B4F_OnLoad:
	SetVar 0x4001, 0
	// TODO(gba) call_if_defeated TRAINER_TEAM_ROCKET_GRUNT_16, RocketHideout_B4F_EventScript_CountGruntDefeated
	// TODO(gba) call_if_defeated TRAINER_TEAM_ROCKET_GRUNT_17, RocketHideout_B4F_EventScript_CountGruntDefeated
	CompareVarToValue 0x4001, 2
	CallIfNe RocketHideout_B4F_EventScript_SetBarrier
	End
	
EventScript_BagIsFull:
	NPCMsg msg_0931_CV_CANVAS_ROCKET_HIDEOUT_B4F_gText_TooBadBagIsFull
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
RocketHideout_B4F_EventScript_DefeatedGrunt1:
	NPCMsg msg_0931_CV_CANVAS_ROCKET_HIDEOUT_B4F_RocketHideout_B4F_Text_Grunt1PostBattle
	WaitButton
	GoToIfUnset 0x205D, _cv_show_11
	ClearFlag 0x205D
	ShowPerson 4
	SetFlag 0x205D
	GoTo _cv_shown_12
_cv_show_11:
	ShowPerson 4
_cv_shown_12:
	ClearFlag 0x205D
	CloseMsg
	ReleaseAll
	End
	
RocketHideout_B4F_EventScript_DefeatedGrunt3:
	SetVar 0x4001, 0
	// TODO(gba) call_if_defeated TRAINER_TEAM_ROCKET_GRUNT_16, RocketHideout_B4F_EventScript_CountGruntDefeated
	GoTo _cv_stop
	// TODO(gba) call_if_defeated TRAINER_TEAM_ROCKET_GRUNT_17, RocketHideout_B4F_EventScript_CountGruntDefeated
	GoTo _cv_stop
	CompareVarToValue 0x4001, 2
	CallIfEq RocketHideout_B4F_EventScript_RemoveBarrier
	CompareVarToValue 0x4001, 2
	CallIfEq RocketHideout_B4F_EventScript_DrawMapForBarrierRemoval
	ReleaseAll
	End
	
RocketHideout_B4F_EventScript_DefeatedGrunt2:
	SetVar 0x4001, 0
	// TODO(gba) call_if_defeated TRAINER_TEAM_ROCKET_GRUNT_16, RocketHideout_B4F_EventScript_CountGruntDefeated
	GoTo _cv_stop
	// TODO(gba) call_if_defeated TRAINER_TEAM_ROCKET_GRUNT_17, RocketHideout_B4F_EventScript_CountGruntDefeated
	GoTo _cv_stop
	CompareVarToValue 0x4001, 2
	CallIfEq RocketHideout_B4F_EventScript_RemoveBarrier
	CompareVarToValue 0x4001, 2
	CallIfEq RocketHideout_B4F_EventScript_DrawMapForBarrierRemoval
	ReleaseAll
	End
	
RocketHideout_B4F_EventScript_SetBarrier:
	// TODO(gba) setmetatile 17, 12, METATILE_SilphCo_HideoutBarrier_TopLeft_Floor, 1
	// TODO(gba) setmetatile 18, 12, METATILE_SilphCo_HideoutBarrier_TopRight_Floor, 1
	// TODO(gba) setmetatile 17, 13, METATILE_SilphCo_HideoutBarrier_BottomLeft, 1
	// TODO(gba) setmetatile 18, 13, METATILE_SilphCo_HideoutBarrier_BottomRight, 1
	// TODO(gba) setmetatile 17, 14, METATILE_SilphCo_HideoutFloor_ShadeFull, 0
	// TODO(gba) setmetatile 18, 14, METATILE_SilphCo_HideoutFloor_ShadeFull, 0
	Return
	
RocketHideout_B4F_EventScript_RemoveBarrier:
	// TODO(gba) setmetatile 17, 12, METATILE_SilphCo_HideoutFloor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 18, 12, METATILE_SilphCo_HideoutFloor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 17, 13, METATILE_SilphCo_HideoutFloor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 18, 13, METATILE_SilphCo_HideoutFloor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 17, 14, METATILE_SilphCo_HideoutFloor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 18, 14, METATILE_SilphCo_HideoutFloor, 0
	GoTo _cv_stop
	Return
	
RocketHideout_B4F_EventScript_DrawMapForBarrierRemoval:
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	Return

_cv_stop:
	NPCMsg msg_0931_CV_CANVAS_ROCKET_HIDEOUT_B4F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
