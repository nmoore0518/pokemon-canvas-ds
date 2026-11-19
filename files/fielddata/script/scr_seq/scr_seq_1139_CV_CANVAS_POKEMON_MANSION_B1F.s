#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_POKEMON_MANSION_B1F.h"
#include "msgdata/msg/msg_0941_CV_CANVAS_POKEMON_MANSION_B1F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PokemonMansion_B1F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef PokemonMansion_B1F_EventScript_ItemTM22
	ScrDef PokemonMansion_B1F_EventScript_Lewis
	ScrDef PokemonMansion_B1F_EventScript_ItemTM14
	ScrDef PokemonMansion_B1F_EventScript_ItemFullRestore
	ScrDef PokemonMansion_B1F_EventScript_ItemSecretKey
	ScrDef PokemonMansion_B1F_EventScript_DiarySep1st
	ScrDef PokemonMansion_B1F_EventScript_Statue
	ScrDef PokemonMansion_B1F_OnLoad
	ScrDef PokemonMansion_B1F_Frlg_cv_Barriers
	ScrDefEnd
	
PokemonMansion_B1F_EventScript_ItemTM22:
	SetVar 0x8004, ITEM_TM22
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
PokemonMansion_B1F_EventScript_Lewis:
	CheckTrainerFlag 965
	GoToIf TRUE, _cv_beaten_1
	NPCMsg msg_0941_CV_CANVAS_POKEMON_MANSION_B1F_PokemonMansion_B1F_Text_LewisIntro
	WaitButton
	CloseMsg
	TrainerBattle 965, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_2
	WhiteOut
	End
_cv_won_2:
	SetTrainerFlag 965
	GoTo GymCandidate_EventScript_RecruitDark
_cv_beaten_1:
	SetVar 0x8004, 18
	Call GymCandidate_EventScript_RecruitOffer
	NPCMsg msg_0941_CV_CANVAS_POKEMON_MANSION_B1F_PokemonMansion_B1F_Text_LewisPostBattle
	WaitButton
	CloseMsg
	End
	
PokemonMansion_B1F_EventScript_ItemTM14:
	SetVar 0x8004, ITEM_TM14
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
PokemonMansion_B1F_EventScript_ItemFullRestore:
	SetVar 0x8004, ITEM_FULL_RESTORE
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
PokemonMansion_B1F_EventScript_ItemSecretKey:
	SetVar 0x8004, ITEM_SECRET_KEY
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
PokemonMansion_B1F_EventScript_DiarySep1st:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0941_CV_CANVAS_POKEMON_MANSION_B1F_PokemonMansion_B1F_Text_MewtwoIsFarTooPowerful
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PokemonMansion_B1F_EventScript_Statue:
	LockAll
	SetVar 0x8004, 3
	Call PokemonMansion_EventScript_SecretSwitch
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	ReleaseAll
	End
	
PokemonMansion_B1F_OnLoad:
	CallIfSet 0x21FE, PokemonMansion_EventScript_PressSwitch_B1F
	End
	
PokemonMansion_B1F_Frlg_cv_Barriers:
	SetVar 0x5044, 1
	ClearFlag 0x22D1
	ClearFlag 0x22D2
	ClearFlag 0x22D3
	SetFlag 0x22D4
	SetFlag 0x22D5
	SetFlag 0x22D6
	SetFlag 0x22D7
	SetFlag 0x22D8
	SetFlag 0x22D9
	ClearFlag 0x22DA
	ClearFlag 0x22DB
	ClearFlag 0x22DC
	ClearFlag 0x22DD
	ClearFlag 0x22DE
	ClearFlag 0x22DF
	SetFlag 0x22E0
	SetFlag 0x22E1
	SetFlag 0x22E2
	Call PokemonMansion_B1F_OnLoad_cv_init
	SetVar 0x5044, 0
	End
	
GymCandidate_EventScript_RecruitDark:
	SetVar 0x8004, 18
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
	NPCMsg msg_0941_CV_CANVAS_POKEMON_MANSION_B1F_GymCandidate_Text_RecruitJoined
	WaitButton
	WaitFanfare
	NPCMsg msg_0941_CV_CANVAS_POKEMON_MANSION_B1F_GymCandidate_Text_RecruitHowToPlace
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PokemonMansion_EventScript_SecretSwitch:
	NPCMsg msg_0941_CV_CANVAS_POKEMON_MANSION_B1F_PokemonMansion_Text_PressSecretSwitch
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_5
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_6
_cv_yes_5:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_6:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PokemonMansion_EventScript_DontPressSwitch
	NPCMsg msg_0941_CV_CANVAS_POKEMON_MANSION_B1F_PokemonMansion_Text_WhoWouldnt
	WaitButton
	GoToIfSet 0x21FE, PokemonMansion_EventScript_ResetSwitch
	SetFlag 0x21FE
	CompareVarToValue 0x8004, 0
	GoToIfEq PokemonMansion_EventScript_PressSwitch_1F
	CompareVarToValue 0x8004, 1
	GoToIfEq PokemonMansion_EventScript_PressSwitch_2F
	CompareVarToValue 0x8004, 2
	GoToIfEq PokemonMansion_EventScript_PressSwitch_3F
	CompareVarToValue 0x8004, 3
	GoToIfEq PokemonMansion_EventScript_PressSwitch_B1F
	CloseMsg
	End
	
PokemonMansion_EventScript_PressSwitch_B1F:
	GoToIfUnset 0x22D4, _cv_bar_7
	ClearFlag 0x22D4
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_7
	ShowPerson 203
_cv_bar_7:
	GoToIfUnset 0x22D5, _cv_bar_8
	ClearFlag 0x22D5
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_8
	ShowPerson 204
_cv_bar_8:
	GoToIfUnset 0x22D6, _cv_bar_9
	ClearFlag 0x22D6
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_9
	ShowPerson 205
_cv_bar_9:
	GoToIfUnset 0x22D7, _cv_bar_10
	ClearFlag 0x22D7
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_10
	ShowPerson 206
_cv_bar_10:
	GoToIfUnset 0x22D8, _cv_bar_11
	ClearFlag 0x22D8
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_11
	ShowPerson 207
_cv_bar_11:
	GoToIfUnset 0x22D9, _cv_bar_12
	ClearFlag 0x22D9
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_12
	ShowPerson 208
_cv_bar_12:
	// (the GBA redraws a square here: 16, 26, METATILE_PokemonMansion_Barrier_Vertical_TopWall, 1)
	// (the GBA redraws a square here: 16, 27, METATILE_PokemonMansion_Barrier_Vertical_TopBase, 1)
	GoToIfUnset 0x22E0, _cv_bar_13
	ClearFlag 0x22E0
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_13
	ShowPerson 215
_cv_bar_13:
	GoToIfUnset 0x22E1, _cv_bar_14
	ClearFlag 0x22E1
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_14
	ShowPerson 216
_cv_bar_14:
	GoToIfUnset 0x22E2, _cv_bar_15
	ClearFlag 0x22E2
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_15
	ShowPerson 217
_cv_bar_15:
	// (the GBA redraws a square here: 12, 8, METATILE_PokemonMansion_Wall_EndPost_Mid, 1)
	// (the GBA redraws a square here: 12, 9, METATILE_PokemonMansion_Wall_EndPost_Bottom, 1)
	GoToIfSet 0x22D1, _cv_bar_16
	SetFlag 0x22D1
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_16
	HidePerson 200
_cv_bar_16:
	GoToIfSet 0x22D2, _cv_bar_17
	SetFlag 0x22D2
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_17
	HidePerson 201
_cv_bar_17:
	GoToIfSet 0x22D3, _cv_bar_18
	SetFlag 0x22D3
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_18
	HidePerson 202
_cv_bar_18:
	GoToIfSet 0x22DA, _cv_bar_19
	SetFlag 0x22DA
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_19
	HidePerson 209
_cv_bar_19:
	GoToIfSet 0x22DB, _cv_bar_20
	SetFlag 0x22DB
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_20
	HidePerson 210
_cv_bar_20:
	GoToIfSet 0x22DC, _cv_bar_21
	SetFlag 0x22DC
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_21
	HidePerson 211
_cv_bar_21:
	GoToIfSet 0x22DD, _cv_bar_22
	SetFlag 0x22DD
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_22
	HidePerson 212
_cv_bar_22:
	GoToIfSet 0x22DE, _cv_bar_23
	SetFlag 0x22DE
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_23
	HidePerson 213
_cv_bar_23:
	GoToIfSet 0x22DF, _cv_bar_24
	SetFlag 0x22DF
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_24
	HidePerson 214
_cv_bar_24:
	// (the GBA redraws a square here: 24, 28, METATILE_PokemonMansion_Statue_RedEyes_Basement, 0)
	// (the GBA redraws a square here: 27, 4, METATILE_PokemonMansion_Statue_RedEyes_Basement, 0)
	Return
	
PokemonMansion_B1F_OnLoad_cv_init:
	CallIfSet 0x21FE, PokemonMansion_EventScript_PressSwitch_B1F
	Return
	
GymCandidate_EventScript_RecruitAfterBattle:
	Call GymCandidate_EventScript_RecruitOffer
	ReleaseAll
	End
	
GymCandidate_EventScript_Return:
	Return
	
GymCandidate_EventScript_RecruitDeclined:
	NPCMsg msg_0941_CV_CANVAS_POKEMON_MANSION_B1F_GymCandidate_Text_RecruitDeclined
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PokemonMansion_EventScript_DontPressSwitch:
	NPCMsg msg_0941_CV_CANVAS_POKEMON_MANSION_B1F_PokemonMansion_Text_NotQuiteYet
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PokemonMansion_EventScript_ResetSwitch:
	ClearFlag 0x21FE
	CompareVarToValue 0x8004, 0
	GoToIfEq PokemonMansion_EventScript_ResetSwitch_1F
	CompareVarToValue 0x8004, 1
	GoToIfEq PokemonMansion_EventScript_ResetSwitch_2F
	CompareVarToValue 0x8004, 2
	GoToIfEq PokemonMansion_EventScript_ResetSwitch_3F
	CompareVarToValue 0x8004, 3
	GoToIfEq PokemonMansion_EventScript_ResetSwitch_B1F
	End
	
PokemonMansion_EventScript_PressSwitch_1F:
	// (the GBA redraws a square here: 22, 10, METATILE_PokemonMansion_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 23, 10, METATILE_PokemonMansion_Floor, 0)
	// (the GBA redraws a square here: 24, 10, METATILE_PokemonMansion_Floor, 0)
	// (the GBA redraws a square here: 22, 11, METATILE_PokemonMansion_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 23, 11, METATILE_PokemonMansion_Floor, 0)
	// (the GBA redraws a square here: 24, 11, METATILE_PokemonMansion_Floor, 0)
	// (the GBA redraws a square here: 27, 25, METATILE_PokemonMansion_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 28, 25, METATILE_PokemonMansion_Floor, 0)
	// (the GBA redraws a square here: 29, 25, METATILE_PokemonMansion_Floor, 0)
	// (the GBA redraws a square here: 27, 26, METATILE_PokemonMansion_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 28, 26, METATILE_PokemonMansion_Floor, 0)
	// (the GBA redraws a square here: 29, 26, METATILE_PokemonMansion_Floor, 0)
	// (the GBA redraws a square here: 32, 25, METATILE_PokemonMansion_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 33, 25, METATILE_PokemonMansion_Floor, 0)
	// (the GBA redraws a square here: 34, 25, METATILE_PokemonMansion_Floor, 0)
	// (the GBA redraws a square here: 32, 26, METATILE_PokemonMansion_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 33, 26, METATILE_PokemonMansion_Floor, 0)
	// (the GBA redraws a square here: 34, 26, METATILE_PokemonMansion_Floor, 0)
	// (the GBA redraws a square here: 31, 18, METATILE_PokemonMansion_Barrier_Horizontal_TopLeft, 1)
	// (the GBA redraws a square here: 32, 18, METATILE_PokemonMansion_Barrier_Horizontal_TopMid, 1)
	// (the GBA redraws a square here: 33, 18, METATILE_PokemonMansion_Barrier_Horizontal_TopRight, 1)
	// (the GBA redraws a square here: 31, 19, METATILE_PokemonMansion_Barrier_Horizontal_BottomLeft, 1)
	// (the GBA redraws a square here: 32, 19, METATILE_PokemonMansion_Barrier_Horizontal_BottomMid, 1)
	// (the GBA redraws a square here: 33, 19, METATILE_PokemonMansion_Barrier_Horizontal_BottomRight, 1)
	// (the GBA redraws a square here: 5, 4, METATILE_PokemonMansion_Statue_RedEyes, 0)
	Return
	
PokemonMansion_EventScript_PressSwitch_2F:
	// (the GBA redraws a square here: 24, 14, METATILE_PokemonMansion_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 25, 14, METATILE_PokemonMansion_Floor, 0)
	// (the GBA redraws a square here: 26, 14, METATILE_PokemonMansion_Floor, 0)
	// (the GBA redraws a square here: 24, 15, METATILE_PokemonMansion_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 25, 15, METATILE_PokemonMansion_Floor, 0)
	// (the GBA redraws a square here: 26, 15, METATILE_PokemonMansion_Floor, 0)
	// (the GBA redraws a square here: 10, 28, METATILE_PokemonMansion_Wall_EndPost_Mid, 1)
	// (the GBA redraws a square here: 10, 29, METATILE_PokemonMansion_Wall_EndPost_Bottom, 1)
	// (the GBA redraws a square here: 10, 30, METATILE_PokemonMansion_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 10, 31, METATILE_PokemonMansion_Floor, 0)
	// (the GBA redraws a square here: 10, 32, METATILE_PokemonMansion_Wall_EndCap, 0)
	// (the GBA redraws a square here: 12, 4, METATILE_PokemonMansion_Barrier_Vertical_TopWall, 1)
	// (the GBA redraws a square here: 12, 5, METATILE_PokemonMansion_Barrier_Vertical_TopBase, 1)
	// (the GBA redraws a square here: 12, 6, METATILE_PokemonMansion_Barrier_Vertical_MidShadow, 1)
	// (the GBA redraws a square here: 12, 7, METATILE_PokemonMansion_Barrier_Vertical_Mid, 1)
	// (the GBA redraws a square here: 12, 8, METATILE_PokemonMansion_Barrier_Vertical_Bottom, 1)
	// (the GBA redraws a square here: 2, 15, METATILE_PokemonMansion_Statue_RedEyes, 0)
	Return
	
PokemonMansion_EventScript_PressSwitch_3F:
	// (the GBA redraws a square here: 17, 11, METATILE_PokemonMansion_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 18, 11, METATILE_PokemonMansion_Floor, 0)
	// (the GBA redraws a square here: 19, 11, METATILE_PokemonMansion_Floor, 0)
	// (the GBA redraws a square here: 17, 12, METATILE_PokemonMansion_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 18, 12, METATILE_PokemonMansion_Floor, 0)
	// (the GBA redraws a square here: 19, 12, METATILE_PokemonMansion_Floor, 0)
	// (the GBA redraws a square here: 21, 4, METATILE_PokemonMansion_Barrier_Vertical_TopWall, 1)
	// (the GBA redraws a square here: 21, 5, METATILE_PokemonMansion_Barrier_Vertical_TopBase, 1)
	// (the GBA redraws a square here: 21, 6, METATILE_PokemonMansion_Barrier_Vertical_MidShadow, 1)
	// (the GBA redraws a square here: 21, 7, METATILE_PokemonMansion_Barrier_Vertical_Mid, 1)
	// (the GBA redraws a square here: 21, 8, METATILE_PokemonMansion_Barrier_Vertical_Bottom, 1)
	// (the GBA redraws a square here: 12, 4, METATILE_PokemonMansion_Statue_RedEyes, 0)
	Return
	
PokemonMansion_EventScript_ResetSwitch_1F:
	// (the GBA redraws a square here: 22, 10, METATILE_PokemonMansion_Barrier_Horizontal_TopLeft, 1)
	// (the GBA redraws a square here: 23, 10, METATILE_PokemonMansion_Barrier_Horizontal_TopMid, 1)
	// (the GBA redraws a square here: 24, 10, METATILE_PokemonMansion_Barrier_Horizontal_TopRight, 1)
	// (the GBA redraws a square here: 22, 11, METATILE_PokemonMansion_Barrier_Horizontal_BottomLeft, 1)
	// (the GBA redraws a square here: 23, 11, METATILE_PokemonMansion_Barrier_Horizontal_BottomMid, 1)
	// (the GBA redraws a square here: 24, 11, METATILE_PokemonMansion_Barrier_Horizontal_BottomRight, 1)
	// (the GBA redraws a square here: 27, 25, METATILE_PokemonMansion_Barrier_Horizontal_TopLeft, 1)
	// (the GBA redraws a square here: 28, 25, METATILE_PokemonMansion_Barrier_Horizontal_TopMid, 1)
	// (the GBA redraws a square here: 29, 25, METATILE_PokemonMansion_Barrier_Horizontal_TopRight, 1)
	// (the GBA redraws a square here: 27, 26, METATILE_PokemonMansion_Barrier_Horizontal_BottomLeft, 1)
	// (the GBA redraws a square here: 28, 26, METATILE_PokemonMansion_Barrier_Horizontal_BottomMid, 1)
	// (the GBA redraws a square here: 29, 26, METATILE_PokemonMansion_Barrier_Horizontal_BottomRight, 1)
	// (the GBA redraws a square here: 32, 25, METATILE_PokemonMansion_Barrier_Horizontal_TopLeft, 1)
	// (the GBA redraws a square here: 33, 25, METATILE_PokemonMansion_Barrier_Horizontal_TopMid, 1)
	// (the GBA redraws a square here: 34, 25, METATILE_PokemonMansion_Barrier_Horizontal_TopRight, 1)
	// (the GBA redraws a square here: 32, 26, METATILE_PokemonMansion_Barrier_Horizontal_BottomLeft, 1)
	// (the GBA redraws a square here: 33, 26, METATILE_PokemonMansion_Barrier_Horizontal_BottomMid, 1)
	// (the GBA redraws a square here: 34, 26, METATILE_PokemonMansion_Barrier_Horizontal_BottomRight, 1)
	// (the GBA redraws a square here: 31, 18, METATILE_PokemonMansion_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 32, 18, METATILE_PokemonMansion_Floor, 0)
	// (the GBA redraws a square here: 33, 18, METATILE_PokemonMansion_Floor, 0)
	// (the GBA redraws a square here: 31, 19, METATILE_PokemonMansion_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 32, 19, METATILE_PokemonMansion_Floor, 0)
	// (the GBA redraws a square here: 33, 19, METATILE_PokemonMansion_Floor, 0)
	// (the GBA redraws a square here: 5, 4, METATILE_PokemonMansion_Statue_BlackEyes, 0)
	Return
	
PokemonMansion_EventScript_ResetSwitch_2F:
	// (the GBA redraws a square here: 24, 14, METATILE_PokemonMansion_Barrier_Horizontal_TopLeft, 1)
	// (the GBA redraws a square here: 25, 14, METATILE_PokemonMansion_Barrier_Horizontal_TopMid, 1)
	// (the GBA redraws a square here: 26, 14, METATILE_PokemonMansion_Barrier_Horizontal_TopRight, 1)
	// (the GBA redraws a square here: 24, 15, METATILE_PokemonMansion_Barrier_Horizontal_BottomLeft, 1)
	// (the GBA redraws a square here: 25, 15, METATILE_PokemonMansion_Barrier_Horizontal_BottomMid, 1)
	// (the GBA redraws a square here: 26, 15, METATILE_PokemonMansion_Barrier_Horizontal_BottomRight, 1)
	// (the GBA redraws a square here: 10, 28, METATILE_PokemonMansion_Barrier_Vertical_TopWall, 1)
	// (the GBA redraws a square here: 10, 29, METATILE_PokemonMansion_Barrier_Vertical_TopBase, 1)
	// (the GBA redraws a square here: 10, 30, METATILE_PokemonMansion_Barrier_Vertical_MidShadow, 1)
	// (the GBA redraws a square here: 10, 31, METATILE_PokemonMansion_Barrier_Vertical_Mid, 1)
	// (the GBA redraws a square here: 10, 32, METATILE_PokemonMansion_Barrier_Vertical_Bottom, 1)
	// (the GBA redraws a square here: 12, 4, METATILE_PokemonMansion_Wall_EndPost_Mid, 1)
	// (the GBA redraws a square here: 12, 5, METATILE_PokemonMansion_Wall_EndPost_Bottom, 1)
	// (the GBA redraws a square here: 12, 6, METATILE_PokemonMansion_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 12, 7, METATILE_PokemonMansion_Floor, 0)
	// (the GBA redraws a square here: 12, 8, METATILE_PokemonMansion_Wall_EndCap, 0)
	// (the GBA redraws a square here: 2, 15, METATILE_PokemonMansion_Statue_BlackEyes, 0)
	Return
	
PokemonMansion_EventScript_ResetSwitch_3F:
	// (the GBA redraws a square here: 17, 11, METATILE_PokemonMansion_Barrier_Horizontal_TopLeft, 1)
	// (the GBA redraws a square here: 18, 11, METATILE_PokemonMansion_Barrier_Horizontal_TopMid, 1)
	// (the GBA redraws a square here: 19, 11, METATILE_PokemonMansion_Barrier_Horizontal_TopRight, 1)
	// (the GBA redraws a square here: 17, 12, METATILE_PokemonMansion_Barrier_Horizontal_BottomLeft, 1)
	// (the GBA redraws a square here: 18, 12, METATILE_PokemonMansion_Barrier_Horizontal_BottomMid, 1)
	// (the GBA redraws a square here: 19, 12, METATILE_PokemonMansion_Barrier_Horizontal_BottomRight, 1)
	// (the GBA redraws a square here: 21, 4, METATILE_PokemonMansion_Wall_EndPost_Mid, 1)
	// (the GBA redraws a square here: 21, 5, METATILE_PokemonMansion_Wall_EndPost_Bottom, 1)
	// (the GBA redraws a square here: 21, 6, METATILE_PokemonMansion_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 21, 7, METATILE_PokemonMansion_Floor, 0)
	// (the GBA redraws a square here: 21, 8, METATILE_PokemonMansion_Wall_EndCap, 0)
	// (the GBA redraws a square here: 12, 4, METATILE_PokemonMansion_Statue_BlackEyes, 0)
	Return
	
PokemonMansion_EventScript_ResetSwitch_B1F:
	GoToIfSet 0x22D4, _cv_bar_25
	SetFlag 0x22D4
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_25
	HidePerson 203
_cv_bar_25:
	GoToIfSet 0x22D5, _cv_bar_26
	SetFlag 0x22D5
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_26
	HidePerson 204
_cv_bar_26:
	GoToIfSet 0x22D6, _cv_bar_27
	SetFlag 0x22D6
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_27
	HidePerson 205
_cv_bar_27:
	GoToIfSet 0x22D7, _cv_bar_28
	SetFlag 0x22D7
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_28
	HidePerson 206
_cv_bar_28:
	GoToIfSet 0x22D8, _cv_bar_29
	SetFlag 0x22D8
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_29
	HidePerson 207
_cv_bar_29:
	GoToIfSet 0x22D9, _cv_bar_30
	SetFlag 0x22D9
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_30
	HidePerson 208
_cv_bar_30:
	// (the GBA redraws a square here: 16, 26, METATILE_PokemonMansion_Wall_EndPost_Mid, 1)
	// (the GBA redraws a square here: 16, 27, METATILE_PokemonMansion_Wall_EndPost_Bottom, 1)
	GoToIfSet 0x22E0, _cv_bar_31
	SetFlag 0x22E0
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_31
	HidePerson 215
_cv_bar_31:
	GoToIfSet 0x22E1, _cv_bar_32
	SetFlag 0x22E1
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_32
	HidePerson 216
_cv_bar_32:
	GoToIfSet 0x22E2, _cv_bar_33
	SetFlag 0x22E2
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_33
	HidePerson 217
_cv_bar_33:
	// (the GBA redraws a square here: 12, 8, METATILE_PokemonMansion_Barrier_Vertical_TopWall, 1)
	// (the GBA redraws a square here: 12, 9, METATILE_PokemonMansion_Barrier_Vertical_TopBase, 1)
	GoToIfUnset 0x22D1, _cv_bar_34
	ClearFlag 0x22D1
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_34
	ShowPerson 200
_cv_bar_34:
	GoToIfUnset 0x22D2, _cv_bar_35
	ClearFlag 0x22D2
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_35
	ShowPerson 201
_cv_bar_35:
	GoToIfUnset 0x22D3, _cv_bar_36
	ClearFlag 0x22D3
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_36
	ShowPerson 202
_cv_bar_36:
	GoToIfUnset 0x22DA, _cv_bar_37
	ClearFlag 0x22DA
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_37
	ShowPerson 209
_cv_bar_37:
	GoToIfUnset 0x22DB, _cv_bar_38
	ClearFlag 0x22DB
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_38
	ShowPerson 210
_cv_bar_38:
	GoToIfUnset 0x22DC, _cv_bar_39
	ClearFlag 0x22DC
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_39
	ShowPerson 211
_cv_bar_39:
	GoToIfUnset 0x22DD, _cv_bar_40
	ClearFlag 0x22DD
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_40
	ShowPerson 212
_cv_bar_40:
	GoToIfUnset 0x22DE, _cv_bar_41
	ClearFlag 0x22DE
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_41
	ShowPerson 213
_cv_bar_41:
	GoToIfUnset 0x22DF, _cv_bar_42
	ClearFlag 0x22DF
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_42
	ShowPerson 214
_cv_bar_42:
	// (the GBA redraws a square here: 24, 28, METATILE_PokemonMansion_Statue_BlackEyes_Basement, 0)
	// (the GBA redraws a square here: 27, 4, METATILE_PokemonMansion_Statue_BlackEyes_Basement, 0)
	Return

_cv_str4:
	BufferPlayersName 6
	BufferRivalsName 7
	Return

_cv_stop:
	NPCMsg msg_0941_CV_CANVAS_POKEMON_MANSION_B1F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
