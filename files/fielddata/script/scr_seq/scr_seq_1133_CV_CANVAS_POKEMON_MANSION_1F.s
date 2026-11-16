#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_POKEMON_MANSION_1F.h"
#include "msgdata/msg/msg_0938_CV_CANVAS_POKEMON_MANSION_1F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PokemonMansion_1F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef PokemonMansion_1F_EventScript_ItemCarbos
	ScrDef PokemonMansion_1F_EventScript_ItemEscapeRope
	ScrDef PokemonMansion_1F_EventScript_ItemProtein
	ScrDef BerryField_EventScript_FindFire
	ScrDef PokemonMansion_1F_EventScript_Statue
	ScrDef PokemonMansion_1F_OnLoad
	ScrDef PokemonMansion_1F_OnTransition
	ScrDefEnd
	
PokemonMansion_1F_EventScript_ItemCarbos:
	SetVar 0x8004, ITEM_CARBOS
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
PokemonMansion_1F_EventScript_ItemEscapeRope:
	SetVar 0x8004, ITEM_ESCAPE_ROPE
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
PokemonMansion_1F_EventScript_ItemProtein:
	SetVar 0x8004, ITEM_PROTEIN
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
BerryField_EventScript_FindFire:
	SetVar 0x8004, ITEM_OCCA_BERRY
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
PokemonMansion_1F_EventScript_Statue:
	LockAll
	SetVar 0x8004, 0
	Call PokemonMansion_EventScript_SecretSwitch
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	ReleaseAll
	End
	
PokemonMansion_1F_OnLoad:
	CallIfSet 0x21FE, PokemonMansion_EventScript_PressSwitch_1F
	End
	
PokemonMansion_1F_OnTransition:
	End
	
PokemonMansion_EventScript_SecretSwitch:
	NPCMsg msg_0938_CV_CANVAS_POKEMON_MANSION_1F_PokemonMansion_Text_PressSecretSwitch
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
	NPCMsg msg_0938_CV_CANVAS_POKEMON_MANSION_1F_PokemonMansion_Text_WhoWouldnt
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
	
PokemonMansion_EventScript_PressSwitch_1F:
	// TODO(gba) setmetatile 22, 10, METATILE_PokemonMansion_Floor_ShadeFull, 0
	// TODO(gba) setmetatile 23, 10, METATILE_PokemonMansion_Floor, 0
	// TODO(gba) setmetatile 24, 10, METATILE_PokemonMansion_Floor, 0
	// TODO(gba) setmetatile 22, 11, METATILE_PokemonMansion_Floor_ShadeFull, 0
	// TODO(gba) setmetatile 23, 11, METATILE_PokemonMansion_Floor, 0
	// TODO(gba) setmetatile 24, 11, METATILE_PokemonMansion_Floor, 0
	// TODO(gba) setmetatile 27, 25, METATILE_PokemonMansion_Floor_ShadeFull, 0
	// TODO(gba) setmetatile 28, 25, METATILE_PokemonMansion_Floor, 0
	// TODO(gba) setmetatile 29, 25, METATILE_PokemonMansion_Floor, 0
	// TODO(gba) setmetatile 27, 26, METATILE_PokemonMansion_Floor_ShadeFull, 0
	// TODO(gba) setmetatile 28, 26, METATILE_PokemonMansion_Floor, 0
	// TODO(gba) setmetatile 29, 26, METATILE_PokemonMansion_Floor, 0
	// TODO(gba) setmetatile 32, 25, METATILE_PokemonMansion_Floor_ShadeFull, 0
	// TODO(gba) setmetatile 33, 25, METATILE_PokemonMansion_Floor, 0
	// TODO(gba) setmetatile 34, 25, METATILE_PokemonMansion_Floor, 0
	// TODO(gba) setmetatile 32, 26, METATILE_PokemonMansion_Floor_ShadeFull, 0
	// TODO(gba) setmetatile 33, 26, METATILE_PokemonMansion_Floor, 0
	// TODO(gba) setmetatile 34, 26, METATILE_PokemonMansion_Floor, 0
	// TODO(gba) setmetatile 31, 18, METATILE_PokemonMansion_Barrier_Horizontal_TopLeft, 1
	// TODO(gba) setmetatile 32, 18, METATILE_PokemonMansion_Barrier_Horizontal_TopMid, 1
	// TODO(gba) setmetatile 33, 18, METATILE_PokemonMansion_Barrier_Horizontal_TopRight, 1
	// TODO(gba) setmetatile 31, 19, METATILE_PokemonMansion_Barrier_Horizontal_BottomLeft, 1
	// TODO(gba) setmetatile 32, 19, METATILE_PokemonMansion_Barrier_Horizontal_BottomMid, 1
	// TODO(gba) setmetatile 33, 19, METATILE_PokemonMansion_Barrier_Horizontal_BottomRight, 1
	// TODO(gba) setmetatile 5, 4, METATILE_PokemonMansion_Statue_RedEyes, 0
	Return
	
PokemonMansion_EventScript_DontPressSwitch:
	NPCMsg msg_0938_CV_CANVAS_POKEMON_MANSION_1F_PokemonMansion_Text_NotQuiteYet
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
	
PokemonMansion_EventScript_PressSwitch_2F:
	// TODO(gba) setmetatile 24, 14, METATILE_PokemonMansion_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 25, 14, METATILE_PokemonMansion_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 26, 14, METATILE_PokemonMansion_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 24, 15, METATILE_PokemonMansion_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 25, 15, METATILE_PokemonMansion_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 26, 15, METATILE_PokemonMansion_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 10, 28, METATILE_PokemonMansion_Wall_EndPost_Mid, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 10, 29, METATILE_PokemonMansion_Wall_EndPost_Bottom, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 10, 30, METATILE_PokemonMansion_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 10, 31, METATILE_PokemonMansion_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 10, 32, METATILE_PokemonMansion_Wall_EndCap, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 12, 4, METATILE_PokemonMansion_Barrier_Vertical_TopWall, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 12, 5, METATILE_PokemonMansion_Barrier_Vertical_TopBase, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 12, 6, METATILE_PokemonMansion_Barrier_Vertical_MidShadow, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 12, 7, METATILE_PokemonMansion_Barrier_Vertical_Mid, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 12, 8, METATILE_PokemonMansion_Barrier_Vertical_Bottom, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 2, 15, METATILE_PokemonMansion_Statue_RedEyes, 0
	GoTo _cv_stop
	Return
	
PokemonMansion_EventScript_PressSwitch_3F:
	// TODO(gba) setmetatile 17, 11, METATILE_PokemonMansion_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 18, 11, METATILE_PokemonMansion_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 19, 11, METATILE_PokemonMansion_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 17, 12, METATILE_PokemonMansion_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 18, 12, METATILE_PokemonMansion_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 19, 12, METATILE_PokemonMansion_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 21, 4, METATILE_PokemonMansion_Barrier_Vertical_TopWall, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 21, 5, METATILE_PokemonMansion_Barrier_Vertical_TopBase, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 21, 6, METATILE_PokemonMansion_Barrier_Vertical_MidShadow, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 21, 7, METATILE_PokemonMansion_Barrier_Vertical_Mid, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 21, 8, METATILE_PokemonMansion_Barrier_Vertical_Bottom, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 12, 4, METATILE_PokemonMansion_Statue_RedEyes, 0
	GoTo _cv_stop
	Return
	
PokemonMansion_EventScript_PressSwitch_B1F:
	// TODO(gba) setmetatile 33, 20, METATILE_PokemonMansion_Barrier_Horizontal_TopLeft, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 34, 20, METATILE_PokemonMansion_Barrier_Horizontal_TopMid, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 35, 20, METATILE_PokemonMansion_Barrier_Horizontal_TopRight, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 33, 21, METATILE_PokemonMansion_Barrier_Horizontal_BottomLeft_Basement, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 34, 21, METATILE_PokemonMansion_Barrier_Horizontal_BottomMid_Basement, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 35, 21, METATILE_PokemonMansion_Barrier_Horizontal_BottomRight_Basement, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 16, 26, METATILE_PokemonMansion_Barrier_Vertical_TopWall, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 16, 27, METATILE_PokemonMansion_Barrier_Vertical_TopBase, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 16, 28, METATILE_PokemonMansion_Barrier_Vertical_MidShadow_Basement, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 16, 29, METATILE_PokemonMansion_Barrier_Vertical_Mid_Basement, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 16, 30, METATILE_PokemonMansion_Barrier_Vertical_Bottom_Basement, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 12, 8, METATILE_PokemonMansion_Wall_EndPost_Mid, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 12, 9, METATILE_PokemonMansion_Wall_EndPost_Bottom, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 12, 10, METATILE_PokemonMansion_BasementFloor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 12, 11, METATILE_PokemonMansion_BasementFloor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 12, 12, METATILE_PokemonMansion_Wall_EndCap_Basement, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 20, 22, METATILE_PokemonMansion_BasementFloor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 21, 22, METATILE_PokemonMansion_BasementFloor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 22, 22, METATILE_PokemonMansion_BasementFloor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 20, 23, METATILE_PokemonMansion_BasementFloor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 21, 23, METATILE_PokemonMansion_BasementFloor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 22, 23, METATILE_PokemonMansion_BasementFloor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 24, 28, METATILE_PokemonMansion_Statue_RedEyes_Basement, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 27, 4, METATILE_PokemonMansion_Statue_RedEyes_Basement, 0
	GoTo _cv_stop
	Return
	
PokemonMansion_EventScript_ResetSwitch_1F:
	// TODO(gba) setmetatile 22, 10, METATILE_PokemonMansion_Barrier_Horizontal_TopLeft, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 23, 10, METATILE_PokemonMansion_Barrier_Horizontal_TopMid, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 24, 10, METATILE_PokemonMansion_Barrier_Horizontal_TopRight, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 22, 11, METATILE_PokemonMansion_Barrier_Horizontal_BottomLeft, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 23, 11, METATILE_PokemonMansion_Barrier_Horizontal_BottomMid, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 24, 11, METATILE_PokemonMansion_Barrier_Horizontal_BottomRight, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 27, 25, METATILE_PokemonMansion_Barrier_Horizontal_TopLeft, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 28, 25, METATILE_PokemonMansion_Barrier_Horizontal_TopMid, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 29, 25, METATILE_PokemonMansion_Barrier_Horizontal_TopRight, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 27, 26, METATILE_PokemonMansion_Barrier_Horizontal_BottomLeft, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 28, 26, METATILE_PokemonMansion_Barrier_Horizontal_BottomMid, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 29, 26, METATILE_PokemonMansion_Barrier_Horizontal_BottomRight, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 32, 25, METATILE_PokemonMansion_Barrier_Horizontal_TopLeft, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 33, 25, METATILE_PokemonMansion_Barrier_Horizontal_TopMid, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 34, 25, METATILE_PokemonMansion_Barrier_Horizontal_TopRight, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 32, 26, METATILE_PokemonMansion_Barrier_Horizontal_BottomLeft, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 33, 26, METATILE_PokemonMansion_Barrier_Horizontal_BottomMid, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 34, 26, METATILE_PokemonMansion_Barrier_Horizontal_BottomRight, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 31, 18, METATILE_PokemonMansion_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 32, 18, METATILE_PokemonMansion_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 33, 18, METATILE_PokemonMansion_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 31, 19, METATILE_PokemonMansion_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 32, 19, METATILE_PokemonMansion_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 33, 19, METATILE_PokemonMansion_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 5, 4, METATILE_PokemonMansion_Statue_BlackEyes, 0
	GoTo _cv_stop
	Return
	
PokemonMansion_EventScript_ResetSwitch_2F:
	// TODO(gba) setmetatile 24, 14, METATILE_PokemonMansion_Barrier_Horizontal_TopLeft, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 25, 14, METATILE_PokemonMansion_Barrier_Horizontal_TopMid, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 26, 14, METATILE_PokemonMansion_Barrier_Horizontal_TopRight, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 24, 15, METATILE_PokemonMansion_Barrier_Horizontal_BottomLeft, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 25, 15, METATILE_PokemonMansion_Barrier_Horizontal_BottomMid, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 26, 15, METATILE_PokemonMansion_Barrier_Horizontal_BottomRight, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 10, 28, METATILE_PokemonMansion_Barrier_Vertical_TopWall, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 10, 29, METATILE_PokemonMansion_Barrier_Vertical_TopBase, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 10, 30, METATILE_PokemonMansion_Barrier_Vertical_MidShadow, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 10, 31, METATILE_PokemonMansion_Barrier_Vertical_Mid, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 10, 32, METATILE_PokemonMansion_Barrier_Vertical_Bottom, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 12, 4, METATILE_PokemonMansion_Wall_EndPost_Mid, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 12, 5, METATILE_PokemonMansion_Wall_EndPost_Bottom, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 12, 6, METATILE_PokemonMansion_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 12, 7, METATILE_PokemonMansion_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 12, 8, METATILE_PokemonMansion_Wall_EndCap, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 2, 15, METATILE_PokemonMansion_Statue_BlackEyes, 0
	GoTo _cv_stop
	Return
	
PokemonMansion_EventScript_ResetSwitch_3F:
	// TODO(gba) setmetatile 17, 11, METATILE_PokemonMansion_Barrier_Horizontal_TopLeft, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 18, 11, METATILE_PokemonMansion_Barrier_Horizontal_TopMid, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 19, 11, METATILE_PokemonMansion_Barrier_Horizontal_TopRight, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 17, 12, METATILE_PokemonMansion_Barrier_Horizontal_BottomLeft, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 18, 12, METATILE_PokemonMansion_Barrier_Horizontal_BottomMid, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 19, 12, METATILE_PokemonMansion_Barrier_Horizontal_BottomRight, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 21, 4, METATILE_PokemonMansion_Wall_EndPost_Mid, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 21, 5, METATILE_PokemonMansion_Wall_EndPost_Bottom, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 21, 6, METATILE_PokemonMansion_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 21, 7, METATILE_PokemonMansion_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 21, 8, METATILE_PokemonMansion_Wall_EndCap, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 12, 4, METATILE_PokemonMansion_Statue_BlackEyes, 0
	GoTo _cv_stop
	Return
	
PokemonMansion_EventScript_ResetSwitch_B1F:
	// TODO(gba) setmetatile 33, 20, METATILE_PokemonMansion_BasementFloor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 34, 20, METATILE_PokemonMansion_BasementFloor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 35, 20, METATILE_PokemonMansion_BasementFloor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 33, 21, METATILE_PokemonMansion_BasementFloor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 34, 21, METATILE_PokemonMansion_BasementFloor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 35, 21, METATILE_PokemonMansion_BasementFloor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 16, 26, METATILE_PokemonMansion_Wall_EndPost_Mid, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 16, 27, METATILE_PokemonMansion_Wall_EndPost_Bottom, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 16, 28, METATILE_PokemonMansion_BasementFloor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 16, 29, METATILE_PokemonMansion_BasementFloor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 16, 30, METATILE_PokemonMansion_Wall_EndCap_Basement, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 12, 8, METATILE_PokemonMansion_Barrier_Vertical_TopWall, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 12, 9, METATILE_PokemonMansion_Barrier_Vertical_TopBase, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 12, 10, METATILE_PokemonMansion_Barrier_Vertical_MidShadow_Basement, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 12, 11, METATILE_PokemonMansion_Barrier_Vertical_Mid_Basement, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 12, 12, METATILE_PokemonMansion_Barrier_Vertical_Bottom_Basement, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 20, 22, METATILE_PokemonMansion_Barrier_Horizontal_TopLeft, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 21, 22, METATILE_PokemonMansion_Barrier_Horizontal_TopMid, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 22, 22, METATILE_PokemonMansion_Barrier_Horizontal_TopRight, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 20, 23, METATILE_PokemonMansion_Barrier_Horizontal_BottomLeft_Basement, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 21, 23, METATILE_PokemonMansion_Barrier_Horizontal_BottomMid_Basement, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 22, 23, METATILE_PokemonMansion_Barrier_Horizontal_BottomRight_Basement, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 24, 28, METATILE_PokemonMansion_Statue_BlackEyes_Basement, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 27, 4, METATILE_PokemonMansion_Statue_BlackEyes_Basement, 0
	GoTo _cv_stop
	Return

_cv_stop:
	NPCMsg msg_0938_CV_CANVAS_POKEMON_MANSION_1F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
