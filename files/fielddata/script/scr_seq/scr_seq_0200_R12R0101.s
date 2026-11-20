#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R12R0101.h"
#include "msgdata/msg/msg_0349_R12R0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route12_FishingHouse_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route12_FishingHouse_EventScript_FishingGuruBrother
	ScrDef PaintWorld_EventScript_Figure
	ScrDef Route12_FishingHouse_EventScript_MagikarpRecordSign
	ScrDefEnd
	
Route12_FishingHouse_EventScript_FishingGuruBrother:
	LockAll
	FacePlayer
	GoToIfSet 0x2158, Route12_FishingHouse_EventScript_CheckMagikarpRecord
	NPCMsg msg_0349_R12R0101_Route12_FishingHouse_Text_DoYouLikeToFish
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Route12_FishingHouse_EventScript_GiveSuperRod
	NPCMsg msg_0349_R12R0101_Route12_FishingHouse_Text_OhThatsDisappointing
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PaintWorld_EventScript_Figure:
	LockAll
	FacePlayer
	CompareVarToValue 0x5020, 2
	GoToIfEq PaintWorld_EventScript_FigureSketch
	CompareVarToValue 0x5020, 3
	GoToIfEq PaintWorld_EventScript_FigureMega
	NPCMsg msg_0349_R12R0101_PaintWorld_Text_FigureFirst
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
Route12_FishingHouse_EventScript_MagikarpRecordSign:
	LockAll
	GoToIfSet 0x2159, Route12_FishingHouse_EventScript_MagikarpRecordSignRecordSet
	NPCMsg msg_0349_R12R0101_Route12_FishingHouse_Text_BlankChartOfSomeSort
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route12_FishingHouse_EventScript_CheckMagikarpRecord:
	SetVar 0x8004, SPECIES_MAGIKARP
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar DoesPlayerPartyContainSpecies
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Route12_FishingHouse_EventScript_NoMagikarpInParty
	// TODO(gba) special GetMagikarpSizeRecordInfo
	GoTo _cv_stop
	BufferPlayersName 6
	NPCMsg msg_0349_R12R0101_Route12_FishingHouse_Text_OhMagikarpAllowMeToSee
	WaitButton
	CloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	ScrCmd_566
	GetPartySelection 0x8004
	RestoreOverworld
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	CopyVar VAR_SPECIAL_RESULT, 0x8004
	CompareVarToValue VAR_SPECIAL_RESULT, 6
	GoToIfGe Route12_FishingHouse_EventScript_CancelShowMon
	// TODO(gba) special CompareMagikarpSize
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Route12_FishingHouse_EventScript_NotMagikarp
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq Route12_FishingHouse_EventScript_NotRecordMagikarp
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfEq Route12_FishingHouse_EventScript_NewRecordMagikarp
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfEq Route12_FishingHouse_EventScript_TieRecordMagikarp
	CloseMsg
	ReleaseAll
	End
	
Route12_FishingHouse_EventScript_GiveSuperRod:
	HasSpaceForItem ITEM_SUPER_ROD, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Route12_FishingHouse_EventScript_NoRoomForSuperRod
	GiveItem ITEM_SUPER_ROD, 1, VAR_SPECIAL_RESULT
	NPCMsg msg_0349_R12R0101_Route12_FishingHouse_Text_TakeThisAndFish
	WaitButton
	PlayFanfare SEQ_ME_ITEM
	BufferPlayersName 6
	NPCMsg msg_0349_R12R0101_Route12_FishingHouse_Text_ReceivedSuperRod
	WaitFanfare
	WaitButton
	SetFlag 0x2158
	NPCMsg msg_0349_R12R0101_Route12_FishingHouse_Text_IfYouCatchBigMagikarpShowMe
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PaintWorld_EventScript_FigureSketch:
	NPCMsg msg_0349_R12R0101_PaintWorld_Text_FigureSketch
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
PaintWorld_EventScript_FigureMega:
	NPCMsg msg_0349_R12R0101_PaintWorld_Text_FigureMega
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
PaintWorld_EventScript_FigureBattle:
	CloseMsg
	// TODO(gba) special Painter_SetupFigure
	GoTo _cv_stop
	ClearTrainerFlag 1442
	SetFlag 0x2036
	CanvasCloseMsg
	TrainerBattle 1442, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_4
	WhiteOut
	End
_cv_won_4:
	SetTrainerFlag 1442
	ClearFlag 0x2036
	GetStaticEncounterOutcome VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfNe _cv_outcome_5
	SetVar VAR_SPECIAL_RESULT, 7
	GoTo _cv_outcome_6
_cv_outcome_5:
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfNe _cv_outcome_6
	SetVar VAR_SPECIAL_RESULT, 4
_cv_outcome_6:
	// TODO(gba) special Painter_RecordBattle
	GoTo _cv_stop
	NPCMsg msg_0349_R12R0101_PaintWorld_Text_Dissolve
	WaitButton
	CloseMsg
	FadeScreen 6, 1, 0, RGB_WHITE
	WaitFade
	Warp MAP_CANVAS_PEWTER_PAINTER_LOFT, 0, 8, 4, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	ReleaseAll
	End
	
Route12_FishingHouse_EventScript_MagikarpRecordSignRecordSet:
	// TODO(gba) special GetMagikarpSizeRecordInfo
	GoTo _cv_stop
	NPCMsg msg_0349_R12R0101_Route12_FishingHouse_Text_MostGiganticMagikarpXSize
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route12_FishingHouse_EventScript_NoMagikarpInParty:
	BufferPlayersName 6
	NPCMsg msg_0349_R12R0101_Route12_FishingHouse_Text_TryFishingBringMeMagikarp
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route12_FishingHouse_EventScript_CancelShowMon:
	ReleaseAll
	End
	
Route12_FishingHouse_EventScript_NotMagikarp:
	NPCMsg msg_0349_R12R0101_Route12_FishingHouse_Text_DoesntLookLikeMagikarp
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route12_FishingHouse_EventScript_NotRecordMagikarp:
	GoToIfUnset 0x2159, Route12_FishingHouse_EventScript_NewRecordMagikarp
	NPCMsg msg_0349_R12R0101_Route12_FishingHouse_Text_HmmXSizeDoesntMeasureUp
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route12_FishingHouse_EventScript_NewRecordMagikarp:
	SetFlag 0x2159
	NPCMsg msg_0349_R12R0101_Route12_FishingHouse_Text_WhoaXSizeTakeThis
	WaitButton
	GiveItem ITEM_NET_BALL, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Route12_FishingHouse_EventScript_NoRoomForNetBall
	NPCMsg msg_0349_R12R0101_Route12_FishingHouse_Text_LookForwardToGreaterRecords
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route12_FishingHouse_EventScript_TieRecordMagikarp:
	GoToIfUnset 0x2159, Route12_FishingHouse_EventScript_NewRecordMagikarp
	NPCMsg msg_0349_R12R0101_Route12_FishingHouse_Text_HuhXSizeSameSizeAsLast
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route12_FishingHouse_EventScript_NoRoomForSuperRod:
	NPCMsg msg_0349_R12R0101_Route12_FishingHouse_Text_NoRoomForGift
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route12_FishingHouse_EventScript_NoRoomForNetBall:
	NPCMsg msg_0349_R12R0101_Route12_FishingHouse_Text_NoRoomForGift
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0349_R12R0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
