#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_POWER_PLANT.h"
#include "msgdata/msg/msg_0902_CV_CANVAS_POWER_PLANT.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PowerPlant_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef PowerPlant_EventScript_ItemMaxPotion
	ScrDef PowerPlant_EventScript_ItemTM17
	ScrDef PowerPlant_EventScript_ItemTM25
	ScrDef PowerPlant_EventScript_ItemThunderStone
	ScrDef PowerPlant_EventScript_ItemElixir
	ScrDef PowerPlant_EventScript_Zapdos
	ScrDef PowerPlant_EventScript_Electrode2
	ScrDef PowerPlant_EventScript_Electrode1
	ScrDef PaintWorld_EventScript_Figure
	ScrDef PowerPlant_OnResume
	ScrDef PowerPlant_OnTransition
	ScrDefEnd
	
PowerPlant_EventScript_ItemMaxPotion:
	SetVar 0x8004, ITEM_MAX_POTION
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
PowerPlant_EventScript_ItemTM17:
	SetVar 0x8004, ITEM_TM17
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
PowerPlant_EventScript_ItemTM25:
	SetVar 0x8004, ITEM_TM25
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
PowerPlant_EventScript_ItemThunderStone:
	SetVar 0x8004, ITEM_THUNDERSTONE
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
PowerPlant_EventScript_ItemElixir:
	SetVar 0x8004, ITEM_ELIXIR
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
PowerPlant_EventScript_Zapdos:
	LockAll
	FacePlayer
	// TODO(gba) setwildbattle SPECIES_ZAPDOS, 50
	GoTo _cv_stop
	WaitSE SEQ_SE_DP_SELECT
	PlayCry SPECIES_ZAPDOS, 0
	NPCMsg msg_0902_CV_CANVAS_POWER_PLANT_Text_Gyaoo
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
	GoToIfEq _cv_won_1
	SetVar VAR_SPECIAL_RESULT, 2
_cv_won_1:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq PowerPlant_EventScript_DefeatedZapdos
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfEq PowerPlant_EventScript_RanFromZapdos
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfEq PowerPlant_EventScript_RanFromZapdos
	SetFlag 0x21C8
	CloseMsg
	ReleaseAll
	End
	
PowerPlant_EventScript_Electrode2:
	LockAll
	FacePlayer
	// TODO(gba) setwildbattle SPECIES_ELECTRODE, 34
	GoTo _cv_stop
	WaitSE SEQ_SE_DP_SELECT
	PlayCry SPECIES_ELECTRODE, 0
	Wait 40, VAR_SPECIAL_RESULT
	WaitCry
	SetFlag 0x2032
	// TODO(gba) dowildbattle 
	GoTo _cv_stop
	ClearFlag 0x2032
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq _cv_won_2
	SetVar VAR_SPECIAL_RESULT, 2
_cv_won_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq PowerPlant_EventScript_FoughtElectrode2
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfEq PowerPlant_EventScript_FoughtElectrode2
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfEq PowerPlant_EventScript_FoughtElectrode2
	SetFlag 0x21C9
	ReleaseAll
	End
	
PowerPlant_EventScript_Electrode1:
	LockAll
	FacePlayer
	// TODO(gba) setwildbattle SPECIES_ELECTRODE, 34
	GoTo _cv_stop
	WaitSE SEQ_SE_DP_SELECT
	PlayCry SPECIES_ELECTRODE, 0
	Wait 40, VAR_SPECIAL_RESULT
	WaitCry
	SetFlag 0x2032
	// TODO(gba) dowildbattle 
	GoTo _cv_stop
	ClearFlag 0x2032
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq _cv_won_3
	SetVar VAR_SPECIAL_RESULT, 2
_cv_won_3:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq PowerPlant_EventScript_FoughtElectrode1
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfEq PowerPlant_EventScript_FoughtElectrode1
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfEq PowerPlant_EventScript_FoughtElectrode1
	SetFlag 0x21CA
	ReleaseAll
	End
	
PaintWorld_EventScript_Figure:
	LockAll
	FacePlayer
	CompareVarToValue 0x5020, 2
	GoToIfEq PaintWorld_EventScript_FigureSketch
	CompareVarToValue 0x5020, 3
	GoToIfEq PaintWorld_EventScript_FigureMega
	NPCMsg msg_0902_CV_CANVAS_POWER_PLANT_PaintWorld_Text_FigureFirst
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
PowerPlant_OnResume:
	CallIfSet 0x2032, PowerPlant_EventScript_TryRemoveStaticMon
	End
	
PowerPlant_OnTransition:
	CallIfUnset 0x21C8, PowerPlant_EventScript_ShowZapdos
	CallIfUnset 0x21CA, PowerPlant_EventScript_ShowElectrode1
	CallIfUnset 0x21C9, PowerPlant_EventScript_ShowElectrode2
	End
	
PowerPlant_EventScript_DefeatedZapdos:
	SetFlag 0x21C8
	GoTo EventScript_RemoveStaticMon
	End
	
PowerPlant_EventScript_RanFromZapdos:
	SetVar 0x8004, SPECIES_ZAPDOS
	GoTo EventScript_MonFlewAway
	End
	
PowerPlant_EventScript_FoughtElectrode2:
	SetFlag 0x21C9
	GoTo EventScript_RemoveStaticMon
	End
	
PowerPlant_EventScript_FoughtElectrode1:
	SetFlag 0x21CA
	GoTo EventScript_RemoveStaticMon
	End
	
PaintWorld_EventScript_FigureSketch:
	NPCMsg msg_0902_CV_CANVAS_POWER_PLANT_PaintWorld_Text_FigureSketch
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
PaintWorld_EventScript_FigureMega:
	NPCMsg msg_0902_CV_CANVAS_POWER_PLANT_PaintWorld_Text_FigureMega
	WaitButton
	End
	
PaintWorld_EventScript_FigureBattle:
	CloseMsg
	// TODO(gba) special Painter_SetupFigure
	GoTo _cv_stop
	ClearTrainerFlag 1442
	SetFlag 0x2036
	CheckTrainerFlag 1442
	GoToIf TRUE, _cv_beaten_4
	TrainerBattle 1442, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_5
	WhiteOut
	End
_cv_won_5:
	SetTrainerFlag 1442
	ReleaseAll
	End
_cv_beaten_4:
	ClearFlag 0x2036
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq _cv_won_6
	SetVar VAR_SPECIAL_RESULT, 2
_cv_won_6:
	// TODO(gba) special Painter_RecordBattle
	GoTo _cv_stop
	NPCMsg msg_0902_CV_CANVAS_POWER_PLANT_PaintWorld_Text_Dissolve
	WaitButton
	CloseMsg
	FadeScreen 6, 1, 0, RGB_WHITE
	WaitFade
	Warp MAP_CANVAS_PEWTER_PAINTER_LOFT, 0, 8, 4, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	ReleaseAll
	End
	
PowerPlant_EventScript_TryRemoveStaticMon:
	CheckBattleWon 0x401C
	CompareVarToValue 0x401C, 1
	GoToIfEq _cv_won_7
	SetVar 0x401C, 2
_cv_won_7:
	CompareVarToValue 0x401C, 7
	GoToIfNe Common_EventScript_NopReturn
	HidePerson 0x401D
	Return
	
PowerPlant_EventScript_ShowZapdos:
	ClearFlag 0x21CB
	Return
	
PowerPlant_EventScript_ShowElectrode1:
	ClearFlag 0x21CC
	Return
	
PowerPlant_EventScript_ShowElectrode2:
	ClearFlag 0x21CD
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
	NPCMsg msg_0902_CV_CANVAS_POWER_PLANT_Text_MonFlewAway
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Common_EventScript_NopReturn:
	Return

_cv_stop:
	NPCMsg msg_0902_CV_CANVAS_POWER_PLANT_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
