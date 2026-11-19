#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T07R0201.h"
#include "msgdata/msg/msg_0501_T07R0201.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's CeladonCity_Condominiums_1F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef CeladonCity_Condominiums_1F_EventScript_Meowth
	ScrDef CeladonCity_Condominiums_1F_EventScript_Clefairy
	ScrDef CeladonCity_Condominiums_1F_EventScript_Nidoran
	ScrDef CeladonCity_Condominiums_1F_EventScript_TeaWoman
	ScrDef PaintWorld_EventScript_Figure
	ScrDef TypeTutor_EventScript_Fairy
	ScrDef CeladonCity_Condominiums_1F_EventScript_SuiteSign
	ScrDefEnd
	
CeladonCity_Condominiums_1F_EventScript_Meowth:
	LockAll
	FacePlayer
	WaitSE SEQ_SE_DP_SELECT
	PlayCry SPECIES_MEOWTH, 0
	NPCMsg msg_0501_T07R0201_CeladonCity_Condominiums_1F_Text_Meowth
	WaitButton
	WaitCry
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_Condominiums_1F_EventScript_Clefairy:
	LockAll
	FacePlayer
	WaitSE SEQ_SE_DP_SELECT
	PlayCry SPECIES_CLEFAIRY, 0
	NPCMsg msg_0501_T07R0201_CeladonCity_Condominiums_1F_Text_Clefairy
	WaitButton
	WaitCry
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_Condominiums_1F_EventScript_Nidoran:
	LockAll
	FacePlayer
	WaitSE SEQ_SE_DP_SELECT
	PlayCry SPECIES_NIDORAN_F, 0
	NPCMsg msg_0501_T07R0201_CeladonCity_Condominiums_1F_Text_Nidoran
	WaitButton
	WaitCry
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_Condominiums_1F_EventScript_TeaWoman:
	LockAll
	FacePlayer
	GoToIfSet 0x2130, CeladonCity_Condominiums_1F_EventScript_TeaWomanAfterTea
	GoToIfSet FLAG_GAME_CLEAR, CeladonCity_Condominiums_1F_EventScript_TeaWomanMentionDaisy
	GoToIfSet 0x2131, CeladonCity_Condominiums_1F_EventScript_TeaWomanAfterTea
	NPCMsg msg_0501_T07R0201_CeladonCity_Condominiums_1F_Text_TryThisDrinkInstead
	WaitButton
	SetFlag 0x2131
	GiveItem 113, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq EventScript_BagIsFull
	NPCMsg msg_0501_T07R0201_CeladonCity_Condominiums_1F_Text_NothingBeatsThirstLikeTea
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
	NPCMsg msg_0501_T07R0201_PaintWorld_Text_FigureFirst
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
TypeTutor_EventScript_Fairy:
	LockAll
	FacePlayer
	SetVar 0x8004, 12
	GoTo TypeTutor_EventScript_Talk
	
CeladonCity_Condominiums_1F_EventScript_SuiteSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0501_T07R0201_CeladonCity_Condominiums_1F_Text_ManagersSuite
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_Condominiums_1F_EventScript_TeaWomanAfterTea:
	NPCMsg msg_0501_T07R0201_CeladonCity_Condominiums_1F_Text_MyDearMonsKeepMeCompany
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_Condominiums_1F_EventScript_TeaWomanMentionDaisy:
	SetFlag 0x2130
	NPCMsg msg_0501_T07R0201_CeladonCity_Condominiums_1F_Text_DaisyComesToBuyTea
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_BagIsFull:
	NPCMsg msg_0501_T07R0201_gText_TooBadBagIsFull
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PaintWorld_EventScript_FigureSketch:
	NPCMsg msg_0501_T07R0201_PaintWorld_Text_FigureSketch
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
PaintWorld_EventScript_FigureMega:
	NPCMsg msg_0501_T07R0201_PaintWorld_Text_FigureMega
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
	GetStaticEncounterOutcome VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfNe _cv_outcome_3
	SetVar VAR_SPECIAL_RESULT, 7
	GoTo _cv_outcome_4
_cv_outcome_3:
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfNe _cv_outcome_4
	SetVar VAR_SPECIAL_RESULT, 4
_cv_outcome_4:
	// TODO(gba) special Painter_RecordBattle
	GoTo _cv_stop
	NPCMsg msg_0501_T07R0201_PaintWorld_Text_Dissolve
	WaitButton
	CloseMsg
	FadeScreen 6, 1, 0, RGB_WHITE
	WaitFade
	Warp MAP_CANVAS_PEWTER_PAINTER_LOFT, 0, 8, 4, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	ReleaseAll
	End
	
TypeTutor_EventScript_Talk:
	CopyVar 0x8008, 0x8004
	// TODO(gba) special TypeTutor_GetState
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TypeTutor_EventScript_Intro
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq TypeTutor_EventScript_Trial
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq TypeTutor_EventScript_JustDone
	GoTo TypeTutor_EventScript_Teach
	
TypeTutor_EventScript_Intro:
	// TODO(gba) special TypeTutor_BufferIntro
	GoTo _cv_stop
	Call _cv_str4
	WaitButton
	// TODO(gba) special TypeTutor_SetMet
	GoTo _cv_stop
	// TODO(gba) special TypeTutor_GetState
	GoTo _cv_stop
	End
	
TypeTutor_EventScript_Trial:
	// TODO(gba) special TypeTutor_BufferTrial
	GoTo _cv_stop
	Call _cv_str4
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TypeTutor_EventScript_JustDone:
	// TODO(gba) special TypeTutor_BufferDone
	GoTo _cv_stop
	Call _cv_str4
	WaitButton
	// TODO(gba) special TypeTutor_SetOpened
	GoTo _cv_stop
	End
	
TypeTutor_EventScript_Teach:
	CopyVar 0x8004, 0x8008
	NPCMsg msg_0501_T07R0201_TypeTutor_Text_WhichMove
	// TODO(gba) special TypeTutor_PushMoves
	GoTo _cv_stop
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_6
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_6:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq TypeTutor_EventScript_Bye
	CopyVar 0x8004, 0x8008
	// TODO(gba) special TypeTutor_SelectMove
	GoTo _cv_stop
	NPCMsg msg_0501_T07R0201_TypeTutor_Text_WhichMon
	WaitButton
	Call EventScript_ChooseMoveTutorMon
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TypeTutor_EventScript_Teach
	NPCMsg msg_0501_T07R0201_TypeTutor_Text_Taught
	WaitButton
	GoTo TypeTutor_EventScript_Teach
	
TypeTutor_EventScript_Bye:
	NPCMsg msg_0501_T07R0201_TypeTutor_Text_Bye
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_ChooseMoveTutorMon:
	// TODO(gba) special ChooseMonForMoveTutor
	GoTo _cv_stop
	LockAll
	FacePlayer
	Return

_cv_str4:
	BufferPlayersName 6
	BufferRivalsName 7
	Return

_cv_stop:
	NPCMsg msg_0501_T07R0201_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
