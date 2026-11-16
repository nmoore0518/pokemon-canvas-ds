#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_VICTORY_ROAD_2F.h"
#include "msgdata/msg/msg_0875_CV_CANVAS_VICTORY_ROAD_2F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's VictoryRoad_2F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef VictoryRoad_2F_EventScript_Nelson
	ScrDef VictoryRoad_2F_EventScript_ItemGuardSpec
	ScrDef VictoryRoad_2F_EventScript_ItemTM07
	ScrDef VictoryRoad_2F_EventScript_ItemFullHeal
	ScrDef VictoryRoad_2F_EventScript_ItemTM37
	ScrDef VictoryRoad_2F_EventScript_DoubleEdgeTutor
	ScrDef VictoryRoad_2F_EventScript_Moltres
	ScrDef BerryField_EventScript_FindDragon
	ScrDef _cv_unported_8
	ScrDef _cv_unported_9
	ScrDef VictoryRoad_2F_OnLoad
	ScrDef VictoryRoad_2F_OnTransition
	ScrDef VictoryRoad_2F_OnResume
	ScrDefEnd
	
VictoryRoad_2F_EventScript_Nelson:
	CheckTrainerFlag 1032
	GoToIf TRUE, _cv_beaten_1
	NPCMsg msg_0875_CV_CANVAS_VICTORY_ROAD_2F_VictoryRoad_2F_Text_NelsonIntro
	WaitButton
	CloseMsg
	TrainerBattle 1032, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_2
	WhiteOut
	End
_cv_won_2:
	SetTrainerFlag 1032
	GoTo GymCandidate_EventScript_RecruitPsychic
_cv_beaten_1:
	SetVar 0x8004, 15
	Call GymCandidate_EventScript_RecruitOffer
	BufferRivalsName 7
	NPCMsg msg_0875_CV_CANVAS_VICTORY_ROAD_2F_VictoryRoad_2F_Text_NelsonPostBattle
	WaitButton
	CloseMsg
	End
	
VictoryRoad_2F_EventScript_ItemGuardSpec:
	SetVar 0x8004, 55
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
VictoryRoad_2F_EventScript_ItemTM07:
	SetVar 0x8004, ITEM_TM07
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
VictoryRoad_2F_EventScript_ItemFullHeal:
	SetVar 0x8004, ITEM_FULL_HEAL
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
VictoryRoad_2F_EventScript_ItemTM37:
	SetVar 0x8004, ITEM_TM37
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
VictoryRoad_2F_EventScript_DoubleEdgeTutor:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0875_CV_CANVAS_VICTORY_ROAD_2F_VictoryRoad_2F_Text_DoubleEdgeTutor_Retired
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VictoryRoad_2F_EventScript_Moltres:
	GoTo MtEmber_Summit_EventScript_Moltres
	
BerryField_EventScript_FindDragon:
	SetVar 0x8004, ITEM_HABAN_BERRY
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
VictoryRoad_2F_EventScript_FloorSwitch1:
	LockAll
	CompareVarToValue 0x5039, 100
	GoToIfEq VictoryRoad_2F_EventScript_FloorSwitch1AlreadyPressed
	// TODO(gba) setmetatile 13, 10, METATILE_Cave_Floor_Ledge_Top, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 13, 11, METATILE_Cave_Floor_Ledge_Bottom, 0
	GoTo _cv_stop
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	GetPersonCoords 11, 0x401E, 0x401F
	MovePerson 11, 0x401E, 0x401F
	SetVar 0x5039, 100
	ReleaseAll
	End
	
VictoryRoad_2F_EventScript_FloorSwitch2:
	LockAll
	CompareVarToValue 0x503A, 100
	GoToIfEq VictoryRoad_2F_EventScript_FloorSwitch2AlreadyPressed
	// TODO(gba) setmetatile 33, 16, METATILE_Cave_Floor_Ledge_Top, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 33, 17, METATILE_Cave_Floor_Ledge_Bottom, 0
	GoTo _cv_stop
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	GetPersonCoords 12, 0x401E, 0x401F
	MovePerson 12, 0x401E, 0x401F
	SetVar 0x503A, 100
	ReleaseAll
	End
	
VictoryRoad_2F_OnLoad:
	CompareVarToValue 0x5039, 100
	CallIfNe VictoryRoad_2F_EventScript_SetRockBarrier1
	CompareVarToValue 0x503A, 100
	CallIfNe VictoryRoad_2F_EventScript_SetRockBarrier2
	End
	
VictoryRoad_2F_OnTransition:
	CallIfUnset 0x2165, MtEmber_Summit_EventScript_ShowMoltres
	End
	
VictoryRoad_2F_OnResume:
	CallIfSet 0x2032, MtEmber_Summit_EventScript_TryRemoveMoltres
	End
	
GymCandidate_EventScript_RecruitPsychic:
	SetVar 0x8004, 15
	GoTo GymCandidate_EventScript_RecruitAfterBattle
	End
	
GymCandidate_EventScript_RecruitOffer:
	// TODO(gba) special GymCandidate_BufferRecruit
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymCandidate_EventScript_Return
	LockAll
	FacePlayer
	Call _cv_str4
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_3
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_4
_cv_yes_3:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_RecruitDeclined
	// TODO(gba) special GymCandidate_Recruit
	GoTo _cv_stop
	PlayFanfare SEQ_ME_ITEM
	NPCMsg msg_0875_CV_CANVAS_VICTORY_ROAD_2F_GymCandidate_Text_RecruitJoined
	WaitButton
	WaitFanfare
	NPCMsg msg_0875_CV_CANVAS_VICTORY_ROAD_2F_GymCandidate_Text_RecruitHowToPlace
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
MtEmber_Summit_EventScript_Moltres:
	LockAll
	FacePlayer
	// TODO(gba) setwildbattle SPECIES_MOLTRES, 50
	GoTo _cv_stop
	WaitSE SEQ_SE_DP_SELECT
	PlayCry SPECIES_MOLTRES, 0
	NPCMsg msg_0875_CV_CANVAS_VICTORY_ROAD_2F_Text_Gyaoo
	WaitCry
	Wait 10, VAR_SPECIAL_RESULT
	PlayBGM SEQ_GS_GYM
	WaitButton
	SetFlag 0x2032
	// TODO(gba) special BattleSetup_StartLegendaryBattle
	GoTo _cv_stop
	ClearFlag 0x2032
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq _cv_won_5
	SetVar VAR_SPECIAL_RESULT, 2
_cv_won_5:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq MtEmber_Summit_EventScript_DefeatedMoltres
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfEq MtEmber_Summit_EventScript_RanFromMoltres
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfEq MtEmber_Summit_EventScript_RanFromMoltres
	SetFlag 0x2165
	CloseMsg
	ReleaseAll
	End
	
VictoryRoad_2F_EventScript_FloorSwitch1AlreadyPressed:
	ReleaseAll
	End
	
VictoryRoad_2F_EventScript_FloorSwitch2AlreadyPressed:
	ReleaseAll
	End
	
VictoryRoad_2F_EventScript_SetRockBarrier1:
	// TODO(gba) setmetatile 13, 10, METATILE_Cave_RockBarrier_Top, 1
	// TODO(gba) setmetatile 13, 11, METATILE_Cave_RockBarrier_Bottom, 1
	Return
	
VictoryRoad_2F_EventScript_SetRockBarrier2:
	// TODO(gba) setmetatile 33, 16, METATILE_Cave_RockBarrier_Top, 1
	// TODO(gba) setmetatile 33, 17, METATILE_Cave_RockBarrier_Bottom, 1
	Return
	
MtEmber_Summit_EventScript_ShowMoltres:
	ClearFlag 0x2166
	Return
	
MtEmber_Summit_EventScript_TryRemoveMoltres:
	CheckBattleWon 0x401C
	CompareVarToValue 0x401C, 1
	GoToIfEq _cv_won_6
	SetVar 0x401C, 2
_cv_won_6:
	CompareVarToValue 0x401C, 7
	GoToIfNe Common_EventScript_NopReturn
	HidePerson 0x401D
	Return
	
GymCandidate_EventScript_RecruitAfterBattle:
	Call GymCandidate_EventScript_RecruitOffer
	ReleaseAll
	End
	
GymCandidate_EventScript_Return:
	Return
	
GymCandidate_EventScript_RecruitDeclined:
	NPCMsg msg_0875_CV_CANVAS_VICTORY_ROAD_2F_GymCandidate_Text_RecruitDeclined
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
MtEmber_Summit_EventScript_DefeatedMoltres:
	SetFlag 0x2165
	GoTo EventScript_RemoveStaticMon
	End
	
MtEmber_Summit_EventScript_RanFromMoltres:
	SetVar 0x8004, SPECIES_MOLTRES
	GoTo EventScript_MonFlewAway
	End
	
Common_EventScript_NopReturn:
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
	NPCMsg msg_0875_CV_CANVAS_VICTORY_ROAD_2F_Text_MonFlewAway
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_8:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0875_CV_CANVAS_VICTORY_ROAD_2F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_9:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0875_CV_CANVAS_VICTORY_ROAD_2F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_str4:
	BufferPlayersName 6
	BufferRivalsName 7
	Return

_cv_stop:
	NPCMsg msg_0875_CV_CANVAS_VICTORY_ROAD_2F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
