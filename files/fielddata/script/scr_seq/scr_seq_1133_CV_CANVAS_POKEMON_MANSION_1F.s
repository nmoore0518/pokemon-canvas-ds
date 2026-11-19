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
	ScrDef PokemonMansion_1F_Frlg_cv_Barriers
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
	
PokemonMansion_1F_Frlg_cv_Barriers:
	SetVar 0x5044, 1
	ClearFlag 0x2240
	ClearFlag 0x2241
	ClearFlag 0x2242
	ClearFlag 0x2243
	ClearFlag 0x2244
	ClearFlag 0x2245
	SetFlag 0x2246
	SetFlag 0x2247
	SetFlag 0x2248
	SetFlag 0x2249
	SetFlag 0x224A
	SetFlag 0x224B
	ClearFlag 0x224C
	ClearFlag 0x224D
	ClearFlag 0x224E
	ClearFlag 0x224F
	ClearFlag 0x2250
	ClearFlag 0x2251
	ClearFlag 0x2252
	ClearFlag 0x2253
	ClearFlag 0x2254
	ClearFlag 0x2255
	ClearFlag 0x2256
	ClearFlag 0x2257
	Call PokemonMansion_1F_OnLoad_cv_init
	SetVar 0x5044, 0
	GoTo PokemonMansion_1F_OnTransition
	
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
	GoToIfSet 0x2240, _cv_bar_3
	SetFlag 0x2240
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_3
	HidePerson 200
_cv_bar_3:
	GoToIfSet 0x2241, _cv_bar_4
	SetFlag 0x2241
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_4
	HidePerson 201
_cv_bar_4:
	GoToIfSet 0x2242, _cv_bar_5
	SetFlag 0x2242
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_5
	HidePerson 202
_cv_bar_5:
	GoToIfSet 0x2243, _cv_bar_6
	SetFlag 0x2243
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_6
	HidePerson 203
_cv_bar_6:
	GoToIfSet 0x2244, _cv_bar_7
	SetFlag 0x2244
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_7
	HidePerson 204
_cv_bar_7:
	GoToIfSet 0x2245, _cv_bar_8
	SetFlag 0x2245
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_8
	HidePerson 205
_cv_bar_8:
	GoToIfSet 0x224C, _cv_bar_9
	SetFlag 0x224C
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_9
	HidePerson 212
_cv_bar_9:
	GoToIfSet 0x224D, _cv_bar_10
	SetFlag 0x224D
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_10
	HidePerson 213
_cv_bar_10:
	GoToIfSet 0x224E, _cv_bar_11
	SetFlag 0x224E
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_11
	HidePerson 214
_cv_bar_11:
	GoToIfSet 0x2252, _cv_bar_12
	SetFlag 0x2252
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_12
	HidePerson 218
_cv_bar_12:
	GoToIfSet 0x2253, _cv_bar_13
	SetFlag 0x2253
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_13
	HidePerson 219
_cv_bar_13:
	GoToIfSet 0x2254, _cv_bar_14
	SetFlag 0x2254
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_14
	HidePerson 220
_cv_bar_14:
	GoToIfSet 0x224F, _cv_bar_15
	SetFlag 0x224F
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_15
	HidePerson 215
_cv_bar_15:
	GoToIfSet 0x2250, _cv_bar_16
	SetFlag 0x2250
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_16
	HidePerson 216
_cv_bar_16:
	GoToIfSet 0x2251, _cv_bar_17
	SetFlag 0x2251
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_17
	HidePerson 217
_cv_bar_17:
	GoToIfSet 0x2255, _cv_bar_18
	SetFlag 0x2255
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_18
	HidePerson 221
_cv_bar_18:
	GoToIfSet 0x2256, _cv_bar_19
	SetFlag 0x2256
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_19
	HidePerson 222
_cv_bar_19:
	GoToIfSet 0x2257, _cv_bar_20
	SetFlag 0x2257
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_20
	HidePerson 223
_cv_bar_20:
	GoToIfUnset 0x2246, _cv_bar_21
	ClearFlag 0x2246
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_21
	ShowPerson 206
_cv_bar_21:
	GoToIfUnset 0x2247, _cv_bar_22
	ClearFlag 0x2247
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_22
	ShowPerson 207
_cv_bar_22:
	GoToIfUnset 0x2248, _cv_bar_23
	ClearFlag 0x2248
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_23
	ShowPerson 208
_cv_bar_23:
	GoToIfUnset 0x2249, _cv_bar_24
	ClearFlag 0x2249
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_24
	ShowPerson 209
_cv_bar_24:
	GoToIfUnset 0x224A, _cv_bar_25
	ClearFlag 0x224A
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_25
	ShowPerson 210
_cv_bar_25:
	GoToIfUnset 0x224B, _cv_bar_26
	ClearFlag 0x224B
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_26
	ShowPerson 211
_cv_bar_26:
	// (the GBA redraws a square here: 5, 4, METATILE_PokemonMansion_Statue_RedEyes, 0)
	Return
	
PokemonMansion_1F_OnLoad_cv_init:
	CallIfSet 0x21FE, PokemonMansion_EventScript_PressSwitch_1F
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
	GoToIfUnset 0x2240, _cv_bar_27
	ClearFlag 0x2240
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_27
	ShowPerson 200
_cv_bar_27:
	GoToIfUnset 0x2241, _cv_bar_28
	ClearFlag 0x2241
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_28
	ShowPerson 201
_cv_bar_28:
	GoToIfUnset 0x2242, _cv_bar_29
	ClearFlag 0x2242
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_29
	ShowPerson 202
_cv_bar_29:
	GoToIfUnset 0x2243, _cv_bar_30
	ClearFlag 0x2243
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_30
	ShowPerson 203
_cv_bar_30:
	GoToIfUnset 0x2244, _cv_bar_31
	ClearFlag 0x2244
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_31
	ShowPerson 204
_cv_bar_31:
	GoToIfUnset 0x2245, _cv_bar_32
	ClearFlag 0x2245
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_32
	ShowPerson 205
_cv_bar_32:
	GoToIfUnset 0x224C, _cv_bar_33
	ClearFlag 0x224C
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_33
	ShowPerson 212
_cv_bar_33:
	GoToIfUnset 0x224D, _cv_bar_34
	ClearFlag 0x224D
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_34
	ShowPerson 213
_cv_bar_34:
	GoToIfUnset 0x224E, _cv_bar_35
	ClearFlag 0x224E
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_35
	ShowPerson 214
_cv_bar_35:
	GoToIfUnset 0x2252, _cv_bar_36
	ClearFlag 0x2252
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_36
	ShowPerson 218
_cv_bar_36:
	GoToIfUnset 0x2253, _cv_bar_37
	ClearFlag 0x2253
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_37
	ShowPerson 219
_cv_bar_37:
	GoToIfUnset 0x2254, _cv_bar_38
	ClearFlag 0x2254
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_38
	ShowPerson 220
_cv_bar_38:
	GoToIfUnset 0x224F, _cv_bar_39
	ClearFlag 0x224F
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_39
	ShowPerson 215
_cv_bar_39:
	GoToIfUnset 0x2250, _cv_bar_40
	ClearFlag 0x2250
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_40
	ShowPerson 216
_cv_bar_40:
	GoToIfUnset 0x2251, _cv_bar_41
	ClearFlag 0x2251
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_41
	ShowPerson 217
_cv_bar_41:
	GoToIfUnset 0x2255, _cv_bar_42
	ClearFlag 0x2255
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_42
	ShowPerson 221
_cv_bar_42:
	GoToIfUnset 0x2256, _cv_bar_43
	ClearFlag 0x2256
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_43
	ShowPerson 222
_cv_bar_43:
	GoToIfUnset 0x2257, _cv_bar_44
	ClearFlag 0x2257
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_44
	ShowPerson 223
_cv_bar_44:
	GoToIfSet 0x2246, _cv_bar_45
	SetFlag 0x2246
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_45
	HidePerson 206
_cv_bar_45:
	GoToIfSet 0x2247, _cv_bar_46
	SetFlag 0x2247
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_46
	HidePerson 207
_cv_bar_46:
	GoToIfSet 0x2248, _cv_bar_47
	SetFlag 0x2248
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_47
	HidePerson 208
_cv_bar_47:
	GoToIfSet 0x2249, _cv_bar_48
	SetFlag 0x2249
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_48
	HidePerson 209
_cv_bar_48:
	GoToIfSet 0x224A, _cv_bar_49
	SetFlag 0x224A
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_49
	HidePerson 210
_cv_bar_49:
	GoToIfSet 0x224B, _cv_bar_50
	SetFlag 0x224B
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_50
	HidePerson 211
_cv_bar_50:
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
	NPCMsg msg_0938_CV_CANVAS_POKEMON_MANSION_1F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
