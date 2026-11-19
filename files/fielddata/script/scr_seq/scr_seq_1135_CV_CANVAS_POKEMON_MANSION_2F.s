#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_POKEMON_MANSION_2F.h"
#include "msgdata/msg/msg_0939_CV_CANVAS_POKEMON_MANSION_2F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PokemonMansion_2F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef PokemonMansion_2F_EventScript_ItemCalcium
	ScrDef PokemonMansion_2F_EventScript_ItemZinc
	ScrDef PokemonMansion_2F_EventScript_ItemHPUp
	ScrDef PokemonMansion_2F_EventScript_Statue
	ScrDef PokemonMansion_2F_EventScript_DiaryJuly10th
	ScrDef PokemonMansion_2F_EventScript_DiaryJuly5th
	ScrDef PokemonMansion_2F_OnLoad
	ScrDef PokemonMansion_2F_Frlg_cv_Barriers
	ScrDefEnd
	
PokemonMansion_2F_EventScript_ItemCalcium:
	SetVar 0x8004, ITEM_CALCIUM
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
PokemonMansion_2F_EventScript_ItemZinc:
	SetVar 0x8004, ITEM_ZINC
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
PokemonMansion_2F_EventScript_ItemHPUp:
	SetVar 0x8004, ITEM_HP_UP
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
PokemonMansion_2F_EventScript_Statue:
	LockAll
	SetVar 0x8004, 1
	Call PokemonMansion_EventScript_SecretSwitch
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	ReleaseAll
	End
	
PokemonMansion_2F_EventScript_DiaryJuly10th:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0939_CV_CANVAS_POKEMON_MANSION_2F_PokemonMansion_1F_Text_ChristenedDiscoveredMonMew
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PokemonMansion_2F_EventScript_DiaryJuly5th:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0939_CV_CANVAS_POKEMON_MANSION_2F_PokemonMansion_1F_Text_NewMonDiscoveredInGuyanaJungle
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PokemonMansion_2F_OnLoad:
	CallIfSet 0x21FE, PokemonMansion_EventScript_PressSwitch_2F
	End
	
PokemonMansion_2F_Frlg_cv_Barriers:
	SetVar 0x5044, 1
	SetFlag 0x22BC
	SetFlag 0x22BD
	SetFlag 0x22BE
	ClearFlag 0x22BF
	ClearFlag 0x22C0
	ClearFlag 0x22C1
	ClearFlag 0x22C2
	ClearFlag 0x22C3
	ClearFlag 0x22C4
	ClearFlag 0x22C5
	ClearFlag 0x22C6
	ClearFlag 0x22C7
	Call PokemonMansion_2F_OnLoad_cv_init
	SetVar 0x5044, 0
	End
	
PokemonMansion_EventScript_SecretSwitch:
	NPCMsg msg_0939_CV_CANVAS_POKEMON_MANSION_2F_PokemonMansion_Text_PressSecretSwitch
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PokemonMansion_EventScript_DontPressSwitch
	NPCMsg msg_0939_CV_CANVAS_POKEMON_MANSION_2F_PokemonMansion_Text_WhoWouldnt
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
	
PokemonMansion_EventScript_PressSwitch_2F:
	GoToIfSet 0x22BF, _cv_bar_3
	SetFlag 0x22BF
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_3
	HidePerson 203
_cv_bar_3:
	GoToIfSet 0x22C0, _cv_bar_4
	SetFlag 0x22C0
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_4
	HidePerson 204
_cv_bar_4:
	GoToIfSet 0x22C1, _cv_bar_5
	SetFlag 0x22C1
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_5
	HidePerson 205
_cv_bar_5:
	GoToIfSet 0x22C2, _cv_bar_6
	SetFlag 0x22C2
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_6
	HidePerson 206
_cv_bar_6:
	GoToIfSet 0x22C3, _cv_bar_7
	SetFlag 0x22C3
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_7
	HidePerson 207
_cv_bar_7:
	GoToIfSet 0x22C4, _cv_bar_8
	SetFlag 0x22C4
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_8
	HidePerson 208
_cv_bar_8:
	// (the GBA redraws a square here: 10, 28, METATILE_PokemonMansion_Wall_EndPost_Mid, 1)
	// (the GBA redraws a square here: 10, 29, METATILE_PokemonMansion_Wall_EndPost_Bottom, 1)
	GoToIfSet 0x22C5, _cv_bar_9
	SetFlag 0x22C5
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_9
	HidePerson 209
_cv_bar_9:
	GoToIfSet 0x22C6, _cv_bar_10
	SetFlag 0x22C6
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_10
	HidePerson 210
_cv_bar_10:
	GoToIfSet 0x22C7, _cv_bar_11
	SetFlag 0x22C7
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_11
	HidePerson 211
_cv_bar_11:
	// (the GBA redraws a square here: 12, 4, METATILE_PokemonMansion_Barrier_Vertical_TopWall, 1)
	// (the GBA redraws a square here: 12, 5, METATILE_PokemonMansion_Barrier_Vertical_TopBase, 1)
	GoToIfUnset 0x22BC, _cv_bar_12
	ClearFlag 0x22BC
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_12
	ShowPerson 200
_cv_bar_12:
	GoToIfUnset 0x22BD, _cv_bar_13
	ClearFlag 0x22BD
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_13
	ShowPerson 201
_cv_bar_13:
	GoToIfUnset 0x22BE, _cv_bar_14
	ClearFlag 0x22BE
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_14
	ShowPerson 202
_cv_bar_14:
	// (the GBA redraws a square here: 2, 15, METATILE_PokemonMansion_Statue_RedEyes, 0)
	Return
	
PokemonMansion_2F_OnLoad_cv_init:
	CallIfSet 0x21FE, PokemonMansion_EventScript_PressSwitch_2F
	Return
	
PokemonMansion_EventScript_DontPressSwitch:
	NPCMsg msg_0939_CV_CANVAS_POKEMON_MANSION_2F_PokemonMansion_Text_NotQuiteYet
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
	
PokemonMansion_EventScript_PressSwitch_B1F:
	// (the GBA redraws a square here: 33, 20, METATILE_PokemonMansion_Barrier_Horizontal_TopLeft, 1)
	// (the GBA redraws a square here: 34, 20, METATILE_PokemonMansion_Barrier_Horizontal_TopMid, 1)
	// (the GBA redraws a square here: 35, 20, METATILE_PokemonMansion_Barrier_Horizontal_TopRight, 1)
	// (the GBA redraws a square here: 33, 21, METATILE_PokemonMansion_Barrier_Horizontal_BottomLeft_Basement, 1)
	// (the GBA redraws a square here: 34, 21, METATILE_PokemonMansion_Barrier_Horizontal_BottomMid_Basement, 1)
	// (the GBA redraws a square here: 35, 21, METATILE_PokemonMansion_Barrier_Horizontal_BottomRight_Basement, 1)
	// (the GBA redraws a square here: 16, 26, METATILE_PokemonMansion_Barrier_Vertical_TopWall, 1)
	// (the GBA redraws a square here: 16, 27, METATILE_PokemonMansion_Barrier_Vertical_TopBase, 1)
	// (the GBA redraws a square here: 16, 28, METATILE_PokemonMansion_Barrier_Vertical_MidShadow_Basement, 1)
	// (the GBA redraws a square here: 16, 29, METATILE_PokemonMansion_Barrier_Vertical_Mid_Basement, 1)
	// (the GBA redraws a square here: 16, 30, METATILE_PokemonMansion_Barrier_Vertical_Bottom_Basement, 1)
	GoToIfUnset 0x22BE, _cv_bar_15
	ClearFlag 0x22BE
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_15
	ShowPerson 202
_cv_bar_15:
	// (the GBA redraws a square here: 12, 9, METATILE_PokemonMansion_Wall_EndPost_Bottom, 1)
	// (the GBA redraws a square here: 12, 10, METATILE_PokemonMansion_BasementFloor_ShadeFull, 0)
	// (the GBA redraws a square here: 12, 11, METATILE_PokemonMansion_BasementFloor, 0)
	// (the GBA redraws a square here: 12, 12, METATILE_PokemonMansion_Wall_EndCap_Basement, 0)
	// (the GBA redraws a square here: 20, 22, METATILE_PokemonMansion_BasementFloor_ShadeFull, 0)
	// (the GBA redraws a square here: 21, 22, METATILE_PokemonMansion_BasementFloor, 0)
	// (the GBA redraws a square here: 22, 22, METATILE_PokemonMansion_BasementFloor, 0)
	// (the GBA redraws a square here: 20, 23, METATILE_PokemonMansion_BasementFloor_ShadeFull, 0)
	// (the GBA redraws a square here: 21, 23, METATILE_PokemonMansion_BasementFloor, 0)
	// (the GBA redraws a square here: 22, 23, METATILE_PokemonMansion_BasementFloor, 0)
	// (the GBA redraws a square here: 24, 28, METATILE_PokemonMansion_Statue_RedEyes_Basement, 0)
	// (the GBA redraws a square here: 27, 4, METATILE_PokemonMansion_Statue_RedEyes_Basement, 0)
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
	GoToIfUnset 0x22BF, _cv_bar_16
	ClearFlag 0x22BF
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_16
	ShowPerson 203
_cv_bar_16:
	GoToIfUnset 0x22C0, _cv_bar_17
	ClearFlag 0x22C0
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_17
	ShowPerson 204
_cv_bar_17:
	GoToIfUnset 0x22C1, _cv_bar_18
	ClearFlag 0x22C1
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_18
	ShowPerson 205
_cv_bar_18:
	GoToIfUnset 0x22C2, _cv_bar_19
	ClearFlag 0x22C2
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_19
	ShowPerson 206
_cv_bar_19:
	GoToIfUnset 0x22C3, _cv_bar_20
	ClearFlag 0x22C3
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_20
	ShowPerson 207
_cv_bar_20:
	GoToIfUnset 0x22C4, _cv_bar_21
	ClearFlag 0x22C4
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_21
	ShowPerson 208
_cv_bar_21:
	// (the GBA redraws a square here: 10, 28, METATILE_PokemonMansion_Barrier_Vertical_TopWall, 1)
	// (the GBA redraws a square here: 10, 29, METATILE_PokemonMansion_Barrier_Vertical_TopBase, 1)
	GoToIfUnset 0x22C5, _cv_bar_22
	ClearFlag 0x22C5
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_22
	ShowPerson 209
_cv_bar_22:
	GoToIfUnset 0x22C6, _cv_bar_23
	ClearFlag 0x22C6
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_23
	ShowPerson 210
_cv_bar_23:
	GoToIfUnset 0x22C7, _cv_bar_24
	ClearFlag 0x22C7
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_24
	ShowPerson 211
_cv_bar_24:
	// (the GBA redraws a square here: 12, 4, METATILE_PokemonMansion_Wall_EndPost_Mid, 1)
	// (the GBA redraws a square here: 12, 5, METATILE_PokemonMansion_Wall_EndPost_Bottom, 1)
	GoToIfSet 0x22BC, _cv_bar_25
	SetFlag 0x22BC
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_25
	HidePerson 200
_cv_bar_25:
	GoToIfSet 0x22BD, _cv_bar_26
	SetFlag 0x22BD
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_26
	HidePerson 201
_cv_bar_26:
	GoToIfSet 0x22BE, _cv_bar_27
	SetFlag 0x22BE
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_27
	HidePerson 202
_cv_bar_27:
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
	// (the GBA redraws a square here: 33, 20, METATILE_PokemonMansion_BasementFloor_ShadeFull, 0)
	// (the GBA redraws a square here: 34, 20, METATILE_PokemonMansion_BasementFloor, 0)
	// (the GBA redraws a square here: 35, 20, METATILE_PokemonMansion_BasementFloor, 0)
	// (the GBA redraws a square here: 33, 21, METATILE_PokemonMansion_BasementFloor_ShadeFull, 0)
	// (the GBA redraws a square here: 34, 21, METATILE_PokemonMansion_BasementFloor, 0)
	// (the GBA redraws a square here: 35, 21, METATILE_PokemonMansion_BasementFloor, 0)
	// (the GBA redraws a square here: 16, 26, METATILE_PokemonMansion_Wall_EndPost_Mid, 1)
	// (the GBA redraws a square here: 16, 27, METATILE_PokemonMansion_Wall_EndPost_Bottom, 1)
	// (the GBA redraws a square here: 16, 28, METATILE_PokemonMansion_BasementFloor_ShadeFull, 0)
	// (the GBA redraws a square here: 16, 29, METATILE_PokemonMansion_BasementFloor, 0)
	// (the GBA redraws a square here: 16, 30, METATILE_PokemonMansion_Wall_EndCap_Basement, 0)
	GoToIfUnset 0x22BE, _cv_bar_28
	ClearFlag 0x22BE
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_28
	ShowPerson 202
_cv_bar_28:
	// (the GBA redraws a square here: 12, 9, METATILE_PokemonMansion_Barrier_Vertical_TopBase, 1)
	// (the GBA redraws a square here: 12, 10, METATILE_PokemonMansion_Barrier_Vertical_MidShadow_Basement, 1)
	// (the GBA redraws a square here: 12, 11, METATILE_PokemonMansion_Barrier_Vertical_Mid_Basement, 1)
	// (the GBA redraws a square here: 12, 12, METATILE_PokemonMansion_Barrier_Vertical_Bottom_Basement, 1)
	// (the GBA redraws a square here: 20, 22, METATILE_PokemonMansion_Barrier_Horizontal_TopLeft, 1)
	// (the GBA redraws a square here: 21, 22, METATILE_PokemonMansion_Barrier_Horizontal_TopMid, 1)
	// (the GBA redraws a square here: 22, 22, METATILE_PokemonMansion_Barrier_Horizontal_TopRight, 1)
	// (the GBA redraws a square here: 20, 23, METATILE_PokemonMansion_Barrier_Horizontal_BottomLeft_Basement, 1)
	// (the GBA redraws a square here: 21, 23, METATILE_PokemonMansion_Barrier_Horizontal_BottomMid_Basement, 1)
	// (the GBA redraws a square here: 22, 23, METATILE_PokemonMansion_Barrier_Horizontal_BottomRight_Basement, 1)
	// (the GBA redraws a square here: 24, 28, METATILE_PokemonMansion_Statue_BlackEyes_Basement, 0)
	// (the GBA redraws a square here: 27, 4, METATILE_PokemonMansion_Statue_BlackEyes_Basement, 0)
	Return

_cv_stop:
	NPCMsg msg_0939_CV_CANVAS_POKEMON_MANSION_2F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
