#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R01.h"
#include "msgdata/msg/msg_0319_R01.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route1_Frlg#world by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route1_EventScript_MartClerk
	ScrDef Route1_EventScript_Boy
	ScrDef BerryField_EventScript_FindNormal
	ScrDef PaintWorld_EventScript_Figure
	ScrDef Route1_EventScript_RouteSign
	ScrDefEnd
	
Route1_EventScript_MartClerk:
	LockAll
	FacePlayer
	GoToIfSet 0x209F, Route1_EventScript_AlreadyGotPotion
	NPCMsg msg_0319_R01_Route1_Text_WorkAtPokeMartTakeSample
	WaitButton
	HasSpaceForItem ITEM_POTION, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq EventScript_BagIsFull
	BufferItemName 1, ITEM_POTION
	PlayFanfare SEQ_ME_LVUP
	NPCMsg msg_0319_R01_gText_ObtainedTheItem
	WaitFanfare
	GiveItem ITEM_POTION, 1, VAR_SPECIAL_RESULT
	BufferPlayersName 6
	NPCMsg msg_0319_R01_Route1_Text_PutPotionAway
	WaitButton
	Call EventScript_RestorePrevTextColor
	SetFlag 0x209F
	CloseMsg
	ReleaseAll
	End
	
Route1_EventScript_Boy:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0319_R01_Route1_Text_CanJumpFromLedges
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
BerryField_EventScript_FindNormal:
	SetVar 0x8004, ITEM_CHILAN_BERRY
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
PaintWorld_EventScript_Figure:
	LockAll
	FacePlayer
	CompareVarToValue 0x5020, 2
	GoToIfEq PaintWorld_EventScript_FigureSketch
	CompareVarToValue 0x5020, 3
	GoToIfEq PaintWorld_EventScript_FigureMega
	NPCMsg msg_0319_R01_PaintWorld_Text_FigureFirst
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
Route1_EventScript_RouteSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0319_R01_Route1_Text_RouteSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route1_EventScript_AlreadyGotPotion:
	NPCMsg msg_0319_R01_Route1_Text_ComeSeeUsIfYouNeedPokeBalls
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_BagIsFull:
	NPCMsg msg_0319_R01_gText_TooBadBagIsFull
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_RestorePrevTextColor:
	CopyVar 0x5015, 0x5016
	Return
	
PaintWorld_EventScript_FigureSketch:
	NPCMsg msg_0319_R01_PaintWorld_Text_FigureSketch
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
PaintWorld_EventScript_FigureMega:
	NPCMsg msg_0319_R01_PaintWorld_Text_FigureMega
	WaitButton
	End
	
PaintWorld_EventScript_FigureBattle:
	CloseMsg
	// TODO(gba) special Painter_SetupFigure
	GoTo _cv_stop
	ClearTrainerFlag 1442
	SetFlag 0x2036
	CheckTrainerFlag 1442
	GoToIf TRUE, _cv_beaten_1
	TrainerBattle 1442, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_2
	WhiteOut
	End
_cv_won_2:
	SetTrainerFlag 1442
	ReleaseAll
	End
_cv_beaten_1:
	ClearFlag 0x2036
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq _cv_won_3
	SetVar VAR_SPECIAL_RESULT, 2
_cv_won_3:
	// TODO(gba) special Painter_RecordBattle
	GoTo _cv_stop
	NPCMsg msg_0319_R01_PaintWorld_Text_Dissolve
	WaitButton
	CloseMsg
	FadeScreen 6, 1, 0, RGB_WHITE
	WaitFade
	Warp MAP_CANVAS_PEWTER_PAINTER_LOFT, 0, 8, 4, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0319_R01_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
