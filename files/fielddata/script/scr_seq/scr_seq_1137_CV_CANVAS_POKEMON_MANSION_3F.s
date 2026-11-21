#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_POKEMON_MANSION_3F.h"
#include "msgdata/msg/msg_0940_CV_CANVAS_POKEMON_MANSION_3F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PokemonMansion_3F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef PokemonMansion_3F_EventScript_ItemMaxPotion
	ScrDef PokemonMansion_3F_EventScript_ItemIron
	ScrDef PokemonMansion_3F_EventScript_ItemAmuletCoin
	ScrDef PokemonMansion_3F_EventScript_DiaryFeb6th
	ScrDef PokemonMansion_3F_EventScript_Statue
	ScrDef PokemonMansion_3F_OnLoad
	ScrDef PokemonMansion_3F_Frlg_cv_Barriers
	ScrDefEnd
	
PokemonMansion_3F_EventScript_ItemMaxPotion:
	SetVar 0x8004, ITEM_MAX_POTION
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
PokemonMansion_3F_EventScript_ItemIron:
	SetVar 0x8004, ITEM_IRON
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
PokemonMansion_3F_EventScript_ItemAmuletCoin:
	SetVar 0x8004, ITEM_AMULET_COIN
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
PokemonMansion_3F_EventScript_DiaryFeb6th:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0940_CV_CANVAS_POKEMON_MANSION_3F_PokemonMansion_1F_Text_MewGaveBirthToMewtwo
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PokemonMansion_3F_EventScript_Statue:
	LockAll
	SetVar 0x8004, 2
	Call PokemonMansion_EventScript_SecretSwitch
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	CanvasCloseMsg
	ReleaseAll
	End
	
PokemonMansion_3F_OnLoad:
	CallIfSet 0x21FE, PokemonMansion_EventScript_PressSwitch_3F
	End
	
PokemonMansion_3F_Frlg_cv_Barriers:
	SetVar 0x5044, 1
	SetFlag 0x22C8
	SetFlag 0x22C9
	SetFlag 0x22CA
	ClearFlag 0x22CB
	ClearFlag 0x22CC
	ClearFlag 0x22CD
	ClearFlag 0x22CE
	ClearFlag 0x22CF
	ClearFlag 0x22D0
	Call PokemonMansion_3F_OnLoad_cv_init
	SetVar 0x5044, 0
	End
	
PokemonMansion_EventScript_SecretSwitch:
	NPCMsg msg_0940_CV_CANVAS_POKEMON_MANSION_3F_PokemonMansion_Text_PressSecretSwitch
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
	NPCMsg msg_0940_CV_CANVAS_POKEMON_MANSION_3F_PokemonMansion_Text_WhoWouldnt
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
	
PokemonMansion_EventScript_PressSwitch_3F:
	GoToIfSet 0x22CB, _cv_bar_3
	SetFlag 0x22CB
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_3
	HidePerson 203
_cv_bar_3:
	GoToIfSet 0x22CC, _cv_bar_4
	SetFlag 0x22CC
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_4
	HidePerson 204
_cv_bar_4:
	GoToIfSet 0x22CD, _cv_bar_5
	SetFlag 0x22CD
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_5
	HidePerson 205
_cv_bar_5:
	GoToIfSet 0x22CE, _cv_bar_6
	SetFlag 0x22CE
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_6
	HidePerson 206
_cv_bar_6:
	GoToIfSet 0x22CF, _cv_bar_7
	SetFlag 0x22CF
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_7
	HidePerson 207
_cv_bar_7:
	GoToIfSet 0x22D0, _cv_bar_8
	SetFlag 0x22D0
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_8
	HidePerson 208
_cv_bar_8:
	// (the GBA redraws a square here: 21, 4, METATILE_PokemonMansion_Barrier_Vertical_TopWall, 1)
	// (the GBA redraws a square here: 21, 5, METATILE_PokemonMansion_Barrier_Vertical_TopBase, 1)
	GoToIfUnset 0x22C8, _cv_bar_9
	ClearFlag 0x22C8
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_9
	ShowPerson 200
_cv_bar_9:
	GoToIfUnset 0x22C9, _cv_bar_10
	ClearFlag 0x22C9
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_10
	ShowPerson 201
_cv_bar_10:
	GoToIfUnset 0x22CA, _cv_bar_11
	ClearFlag 0x22CA
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_11
	ShowPerson 202
_cv_bar_11:
	// (the GBA redraws a square here: 12, 4, METATILE_PokemonMansion_Statue_RedEyes, 0)
	Return
	
PokemonMansion_3F_OnLoad_cv_init:
	CallIfSet 0x21FE, PokemonMansion_EventScript_PressSwitch_3F
	Return
	
PokemonMansion_EventScript_DontPressSwitch:
	NPCMsg msg_0940_CV_CANVAS_POKEMON_MANSION_3F_PokemonMansion_Text_NotQuiteYet
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
	// (the GBA redraws a square here: 12, 8, METATILE_PokemonMansion_Wall_EndPost_Mid, 1)
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
	GoToIfUnset 0x22CB, _cv_bar_12
	ClearFlag 0x22CB
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_12
	ShowPerson 203
_cv_bar_12:
	GoToIfUnset 0x22CC, _cv_bar_13
	ClearFlag 0x22CC
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_13
	ShowPerson 204
_cv_bar_13:
	GoToIfUnset 0x22CD, _cv_bar_14
	ClearFlag 0x22CD
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_14
	ShowPerson 205
_cv_bar_14:
	GoToIfUnset 0x22CE, _cv_bar_15
	ClearFlag 0x22CE
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_15
	ShowPerson 206
_cv_bar_15:
	GoToIfUnset 0x22CF, _cv_bar_16
	ClearFlag 0x22CF
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_16
	ShowPerson 207
_cv_bar_16:
	GoToIfUnset 0x22D0, _cv_bar_17
	ClearFlag 0x22D0
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_17
	ShowPerson 208
_cv_bar_17:
	// (the GBA redraws a square here: 21, 4, METATILE_PokemonMansion_Wall_EndPost_Mid, 1)
	// (the GBA redraws a square here: 21, 5, METATILE_PokemonMansion_Wall_EndPost_Bottom, 1)
	GoToIfSet 0x22C8, _cv_bar_18
	SetFlag 0x22C8
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_18
	HidePerson 200
_cv_bar_18:
	GoToIfSet 0x22C9, _cv_bar_19
	SetFlag 0x22C9
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_19
	HidePerson 201
_cv_bar_19:
	GoToIfSet 0x22CA, _cv_bar_20
	SetFlag 0x22CA
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_20
	HidePerson 202
_cv_bar_20:
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
	// (the GBA redraws a square here: 12, 8, METATILE_PokemonMansion_Barrier_Vertical_TopWall, 1)
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
	NPCMsg msg_0940_CV_CANVAS_POKEMON_MANSION_3F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
