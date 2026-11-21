#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_POKEMON_TOWER_7F.h"
#include "msgdata/msg/msg_0891_CV_CANVAS_POKEMON_TOWER_7F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PokemonTower_7F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef PokemonTower_7F_EventScript_MrFuji
	ScrDef PokemonTower_7F_EventScript_Grunt1
	ScrDef PokemonTower_7F_EventScript_Grunt2
	ScrDef PokemonTower_7F_EventScript_Grunt3
	ScrDef PaintWorld_EventScript_Figure
	ScrDefEnd
	
PokemonTower_7F_EventScript_MrFuji:
	LockAll
	FacePlayer
	SetFlag 0x2192
	ClearFlag 0x205C
	SetFlag 0x20FA
	NPCMsg msg_0891_CV_CANVAS_POKEMON_TOWER_7F_PokemonTower_7F_Text_MrFujiThankYouFollowMe
	WaitButton
	CanvasCloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	Warp MAP_LAVENDER_VOLUNTEER_POKEMON_HOUSE, 0, 5, 12, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	CanvasCloseMsg
	ReleaseAll
	End
	
PokemonTower_7F_EventScript_Grunt1:
	CheckTrainerFlag 1105
	GoToIf TRUE, _cv_beaten_1
	NPCMsg msg_0891_CV_CANVAS_POKEMON_TOWER_7F_PokemonTower_7F_Text_Grunt1Intro
	WaitButton
	CloseMsg
	TrainerBattle 1105, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_2
	WhiteOut
	End
_cv_won_2:
	SetTrainerFlag 1105
	GoTo PokemonTower_7F_EventScript_DefeatedGrunt1
_cv_beaten_1:
	NPCMsg msg_0891_CV_CANVAS_POKEMON_TOWER_7F_PokemonTower_7F_Text_Grunt1PostBattle
	WaitButton
	CloseMsg
	End
	
PokemonTower_7F_EventScript_Grunt2:
	CheckTrainerFlag 1106
	GoToIf TRUE, _cv_beaten_3
	NPCMsg msg_0891_CV_CANVAS_POKEMON_TOWER_7F_PokemonTower_7F_Text_Grunt2Intro
	WaitButton
	CloseMsg
	TrainerBattle 1106, 1106, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_4
	WhiteOut
	End
_cv_won_4:
	SetTrainerFlag 1106
	GoTo PokemonTower_7F_EventScript_DefeatedGrunt2
_cv_beaten_3:
	NPCMsg msg_0891_CV_CANVAS_POKEMON_TOWER_7F_PokemonTower_7F_Text_Grunt2PostBattle
	WaitButton
	CloseMsg
	End
	
PokemonTower_7F_EventScript_Grunt3:
	CheckTrainerFlag 1107
	GoToIf TRUE, _cv_beaten_5
	NPCMsg msg_0891_CV_CANVAS_POKEMON_TOWER_7F_PokemonTower_7F_Text_Grunt3Intro
	WaitButton
	CloseMsg
	TrainerBattle 1107, 1107, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_6
	WhiteOut
	End
_cv_won_6:
	SetTrainerFlag 1107
	GoTo PokemonTower_7F_EventScript_DefeatedGrunt3
_cv_beaten_5:
	NPCMsg msg_0891_CV_CANVAS_POKEMON_TOWER_7F_PokemonTower_7F_Text_Grunt3PostBattle
	WaitButton
	CloseMsg
	End
	
PaintWorld_EventScript_Figure:
	LockAll
	FacePlayer
	CompareVarToValue 0x5020, 2
	GoToIfEq PaintWorld_EventScript_FigureSketch
	CompareVarToValue 0x5020, 3
	GoToIfEq PaintWorld_EventScript_FigureMega
	NPCMsg msg_0891_CV_CANVAS_POKEMON_TOWER_7F_PaintWorld_Text_FigureFirst
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
PokemonTower_7F_EventScript_DefeatedGrunt1:
	NPCMsg msg_0891_CV_CANVAS_POKEMON_TOWER_7F_PokemonTower_7F_Text_Grunt1PostBattle
	WaitButton
	CanvasCloseMsg
	GetPlayerCoords 0x8004, 0x8005
	CompareVarToValue 0x8004, 19
	GoToIfLt _cv_unwiden_7
	CompareVarToValue 0x8004, 20
	GoToIfLt _cv_unwiden_8
	SubVar 0x8004, 1
	GoTo _cv_unwiden_7
_cv_unwiden_8:
	SetVar 0x8004, 19
_cv_unwiden_7:
	CompareVarToValue 0x8004, 16
	GoToIfLt _cv_unwiden_9
	CompareVarToValue 0x8004, 17
	GoToIfLt _cv_unwiden_10
	SubVar 0x8004, 1
	GoTo _cv_unwiden_9
_cv_unwiden_10:
	SetVar 0x8004, 16
_cv_unwiden_9:
	CompareVarToValue 0x8004, 8
	GoToIfLt _cv_unwiden_11
	CompareVarToValue 0x8004, 9
	GoToIfLt _cv_unwiden_12
	SubVar 0x8004, 1
	GoTo _cv_unwiden_11
_cv_unwiden_12:
	SetVar 0x8004, 8
_cv_unwiden_11:
	CompareVarToValue 0x8004, 5
	GoToIfLt _cv_unwiden_13
	CompareVarToValue 0x8004, 6
	GoToIfLt _cv_unwiden_14
	SubVar 0x8004, 1
	GoTo _cv_unwiden_13
_cv_unwiden_14:
	SetVar 0x8004, 5
_cv_unwiden_13:
	CompareVarToValue 0x8005, 16
	GoToIfLt _cv_unwiden_15
	CompareVarToValue 0x8005, 17
	GoToIfLt _cv_unwiden_16
	SubVar 0x8005, 1
	GoTo _cv_unwiden_15
_cv_unwiden_16:
	SetVar 0x8005, 16
_cv_unwiden_15:
	CompareVarToValue 0x8005, 14
	GoToIfLt _cv_unwiden_17
	CompareVarToValue 0x8005, 15
	GoToIfLt _cv_unwiden_18
	SubVar 0x8005, 1
	GoTo _cv_unwiden_17
_cv_unwiden_18:
	SetVar 0x8005, 14
_cv_unwiden_17:
	CompareVarToValue 0x8005, 5
	GoToIfLt _cv_unwiden_19
	CompareVarToValue 0x8005, 6
	GoToIfLt _cv_unwiden_20
	SubVar 0x8005, 1
	GoTo _cv_unwiden_19
_cv_unwiden_20:
	SetVar 0x8005, 5
_cv_unwiden_19:
	CompareVarToValue 0x8004, 10
	GoToIfEq PokemonTower_7F_EventScript_Grunt1ExitMid
	CompareVarToValue 0x8004, 11
	GoToIfEq PokemonTower_7F_EventScript_Grunt1ExitRight
	CompareVarToValue 0x8004, 9
	GoToIfEq PokemonTower_7F_EventScript_Grunt1ExitLeft
	ApplyMovement 2, PokemonTower_7F_Movement_Grunt1Exit
	WaitMovement
	GoTo PokemonTower_7F_EventScript_RemoveGrunt1
	End
	
PokemonTower_7F_EventScript_DefeatedGrunt2:
	NPCMsg msg_0891_CV_CANVAS_POKEMON_TOWER_7F_PokemonTower_7F_Text_Grunt2PostBattle
	WaitButton
	CanvasCloseMsg
	GetPlayerCoords 0x8004, 0x8005
	CompareVarToValue 0x8004, 19
	GoToIfLt _cv_unwiden_21
	CompareVarToValue 0x8004, 20
	GoToIfLt _cv_unwiden_22
	SubVar 0x8004, 1
	GoTo _cv_unwiden_21
_cv_unwiden_22:
	SetVar 0x8004, 19
_cv_unwiden_21:
	CompareVarToValue 0x8004, 16
	GoToIfLt _cv_unwiden_23
	CompareVarToValue 0x8004, 17
	GoToIfLt _cv_unwiden_24
	SubVar 0x8004, 1
	GoTo _cv_unwiden_23
_cv_unwiden_24:
	SetVar 0x8004, 16
_cv_unwiden_23:
	CompareVarToValue 0x8004, 8
	GoToIfLt _cv_unwiden_25
	CompareVarToValue 0x8004, 9
	GoToIfLt _cv_unwiden_26
	SubVar 0x8004, 1
	GoTo _cv_unwiden_25
_cv_unwiden_26:
	SetVar 0x8004, 8
_cv_unwiden_25:
	CompareVarToValue 0x8004, 5
	GoToIfLt _cv_unwiden_27
	CompareVarToValue 0x8004, 6
	GoToIfLt _cv_unwiden_28
	SubVar 0x8004, 1
	GoTo _cv_unwiden_27
_cv_unwiden_28:
	SetVar 0x8004, 5
_cv_unwiden_27:
	CompareVarToValue 0x8005, 16
	GoToIfLt _cv_unwiden_29
	CompareVarToValue 0x8005, 17
	GoToIfLt _cv_unwiden_30
	SubVar 0x8005, 1
	GoTo _cv_unwiden_29
_cv_unwiden_30:
	SetVar 0x8005, 16
_cv_unwiden_29:
	CompareVarToValue 0x8005, 14
	GoToIfLt _cv_unwiden_31
	CompareVarToValue 0x8005, 15
	GoToIfLt _cv_unwiden_32
	SubVar 0x8005, 1
	GoTo _cv_unwiden_31
_cv_unwiden_32:
	SetVar 0x8005, 14
_cv_unwiden_31:
	CompareVarToValue 0x8005, 5
	GoToIfLt _cv_unwiden_33
	CompareVarToValue 0x8005, 6
	GoToIfLt _cv_unwiden_34
	SubVar 0x8005, 1
	GoTo _cv_unwiden_33
_cv_unwiden_34:
	SetVar 0x8005, 5
_cv_unwiden_33:
	CompareVarToValue 0x8004, 12
	GoToIfEq PokemonTower_7F_EventScript_Grunt2ExitLeft
	CompareVarToValue 0x8004, 13
	GoToIfEq PokemonTower_7F_EventScript_Grunt2ExitRight
	ApplyMovement 3, PokemonTower_7F_Movement_Grunt2Exit
	WaitMovement
	GoTo PokemonTower_7F_EventScript_RemoveGrunt2
	End
	
PokemonTower_7F_EventScript_DefeatedGrunt3:
	NPCMsg msg_0891_CV_CANVAS_POKEMON_TOWER_7F_PokemonTower_7F_Text_Grunt3PostBattle
	WaitButton
	CanvasCloseMsg
	GetPlayerCoords 0x8004, 0x8005
	CompareVarToValue 0x8004, 19
	GoToIfLt _cv_unwiden_35
	CompareVarToValue 0x8004, 20
	GoToIfLt _cv_unwiden_36
	SubVar 0x8004, 1
	GoTo _cv_unwiden_35
_cv_unwiden_36:
	SetVar 0x8004, 19
_cv_unwiden_35:
	CompareVarToValue 0x8004, 16
	GoToIfLt _cv_unwiden_37
	CompareVarToValue 0x8004, 17
	GoToIfLt _cv_unwiden_38
	SubVar 0x8004, 1
	GoTo _cv_unwiden_37
_cv_unwiden_38:
	SetVar 0x8004, 16
_cv_unwiden_37:
	CompareVarToValue 0x8004, 8
	GoToIfLt _cv_unwiden_39
	CompareVarToValue 0x8004, 9
	GoToIfLt _cv_unwiden_40
	SubVar 0x8004, 1
	GoTo _cv_unwiden_39
_cv_unwiden_40:
	SetVar 0x8004, 8
_cv_unwiden_39:
	CompareVarToValue 0x8004, 5
	GoToIfLt _cv_unwiden_41
	CompareVarToValue 0x8004, 6
	GoToIfLt _cv_unwiden_42
	SubVar 0x8004, 1
	GoTo _cv_unwiden_41
_cv_unwiden_42:
	SetVar 0x8004, 5
_cv_unwiden_41:
	CompareVarToValue 0x8005, 16
	GoToIfLt _cv_unwiden_43
	CompareVarToValue 0x8005, 17
	GoToIfLt _cv_unwiden_44
	SubVar 0x8005, 1
	GoTo _cv_unwiden_43
_cv_unwiden_44:
	SetVar 0x8005, 16
_cv_unwiden_43:
	CompareVarToValue 0x8005, 14
	GoToIfLt _cv_unwiden_45
	CompareVarToValue 0x8005, 15
	GoToIfLt _cv_unwiden_46
	SubVar 0x8005, 1
	GoTo _cv_unwiden_45
_cv_unwiden_46:
	SetVar 0x8005, 14
_cv_unwiden_45:
	CompareVarToValue 0x8005, 5
	GoToIfLt _cv_unwiden_47
	CompareVarToValue 0x8005, 6
	GoToIfLt _cv_unwiden_48
	SubVar 0x8005, 1
	GoTo _cv_unwiden_47
_cv_unwiden_48:
	SetVar 0x8005, 5
_cv_unwiden_47:
	CompareVarToValue 0x8004, 10
	GoToIfEq PokemonTower_7F_EventScript_Grunt3ExitRight
	CompareVarToValue 0x8004, 9
	GoToIfEq PokemonTower_7F_EventScript_Grunt3ExitLeft
	ApplyMovement 4, PokemonTower_7F_Movement_Grunt3Exit
	WaitMovement
	GoTo PokemonTower_7F_EventScript_RemoveGrunt3
	End
	
PaintWorld_EventScript_FigureSketch:
	NPCMsg msg_0891_CV_CANVAS_POKEMON_TOWER_7F_PaintWorld_Text_FigureSketch
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
PaintWorld_EventScript_FigureMega:
	NPCMsg msg_0891_CV_CANVAS_POKEMON_TOWER_7F_PaintWorld_Text_FigureMega
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
PaintWorld_EventScript_FigureBattle:
	CanvasCloseMsg
	// TODO(gba) special Painter_SetupFigure
	GoTo _cv_stop
	ClearTrainerFlag 1442
	SetFlag 0x2036
	CanvasCloseMsg
	TrainerBattle 1442, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_50
	WhiteOut
	End
_cv_won_50:
	SetTrainerFlag 1442
	ClearFlag 0x2036
	GetStaticEncounterOutcome VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfNe _cv_outcome_51
	SetVar VAR_SPECIAL_RESULT, 7
	GoTo _cv_outcome_52
_cv_outcome_51:
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfNe _cv_outcome_52
	SetVar VAR_SPECIAL_RESULT, 4
_cv_outcome_52:
	// TODO(gba) special Painter_RecordBattle
	GoTo _cv_stop
	NPCMsg msg_0891_CV_CANVAS_POKEMON_TOWER_7F_PaintWorld_Text_Dissolve
	WaitButton
	CanvasCloseMsg
	FadeScreen 6, 1, 0, RGB_WHITE
	WaitFade
	Warp MAP_CANVAS_PEWTER_PAINTER_LOFT, 0, 8, 4, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	CanvasCloseMsg
	ReleaseAll
	End
	
PokemonTower_7F_EventScript_Grunt1ExitMid:
	ApplyMovement 2, PokemonTower_7F_Movement_Grunt1ExitMid
	WaitMovement
	GoTo PokemonTower_7F_EventScript_RemoveGrunt1
	End
	
PokemonTower_7F_EventScript_Grunt1ExitRight:
	ApplyMovement 2, PokemonTower_7F_Movement_Grunt1ExitRight
	WaitMovement
	GoTo PokemonTower_7F_EventScript_RemoveGrunt1
	End
	
PokemonTower_7F_EventScript_Grunt1ExitLeft:
	ApplyMovement 2, PokemonTower_7F_Movement_Grunt1ExitLeft
	WaitMovement
	PlaySE SEQ_SE_DP_KAIDAN2
	Wait 25, VAR_SPECIAL_RESULT
	GoTo PokemonTower_7F_EventScript_RemoveGrunt1
	End
	
PokemonTower_7F_EventScript_RemoveGrunt1:
	HidePerson 2
	SetFlag 0x2193
	CanvasCloseMsg
	ReleaseAll
	End
	
PokemonTower_7F_EventScript_Grunt2ExitLeft:
	ApplyMovement 3, PokemonTower_7F_Movement_Grunt2ExitLeft
	WaitMovement
	GoTo PokemonTower_7F_EventScript_RemoveGrunt2
	End
	
PokemonTower_7F_EventScript_Grunt2ExitRight:
	ApplyMovement 3, PokemonTower_7F_Movement_Grunt2ExitRight
	WaitMovement
	GoTo PokemonTower_7F_EventScript_RemoveGrunt2
	End
	
PokemonTower_7F_EventScript_RemoveGrunt2:
	HidePerson 3
	SetFlag 0x2194
	CanvasCloseMsg
	ReleaseAll
	End
	
PokemonTower_7F_EventScript_Grunt3ExitRight:
	ApplyMovement 4, PokemonTower_7F_Movement_Grunt3ExitRight
	WaitMovement
	GoTo PokemonTower_7F_EventScript_RemoveGrunt3
	End
	
PokemonTower_7F_EventScript_Grunt3ExitLeft:
	ApplyMovement 4, PokemonTower_7F_Movement_Grunt3ExitLeft
	WaitMovement
	GoTo PokemonTower_7F_EventScript_RemoveGrunt3
	End
	
PokemonTower_7F_EventScript_RemoveGrunt3:
	HidePerson 4
	SetFlag 0x2195
	CanvasCloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0891_CV_CANVAS_POKEMON_TOWER_7F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
PokemonTower_7F_Movement_Grunt1Exit:
	WalkNormalSouth 8
	EndMovement

	.balign 4, 0
PokemonTower_7F_Movement_Grunt2Exit:
	WalkNormalSouth 8
	EndMovement

	.balign 4, 0
PokemonTower_7F_Movement_Grunt3Exit:
	WalkNormalSouth 6
	EndMovement

	.balign 4, 0
PokemonTower_7F_Movement_Grunt1ExitMid:
	WalkNormalSouth
	WalkNormalEast
	WalkNormalSouth 5
	WalkNormalEast
	WalkNormalSouth 2
	EndMovement

	.balign 4, 0
PokemonTower_7F_Movement_Grunt1ExitRight:
	WalkNormalSouth 6
	WalkNormalEast
	WalkNormalSouth 2
	EndMovement

	.balign 4, 0
PokemonTower_7F_Movement_Grunt1ExitLeft:
	WalkNormalEast
	WalkNormalSouth 6
	WalkNormalEast
	WalkNormalSouth 2
	WalkOnSpotFasterWest
	EndMovement

	.balign 4, 0
PokemonTower_7F_Movement_Grunt2ExitLeft:
	WalkNormalSouth 3
	WalkNormalWest
	WalkNormalSouth 5
	EndMovement

	.balign 4, 0
PokemonTower_7F_Movement_Grunt2ExitRight:
	WalkNormalWest
	WalkNormalSouth 9
	EndMovement

	.balign 4, 0
PokemonTower_7F_Movement_Grunt3ExitRight:
	WalkNormalSouth 5
	WalkNormalEast
	WalkNormalSouth
	EndMovement

	.balign 4, 0
PokemonTower_7F_Movement_Grunt3ExitLeft:
	WalkNormalEast
	WalkNormalSouth 8
	EndMovement
	.balign 4, 0
