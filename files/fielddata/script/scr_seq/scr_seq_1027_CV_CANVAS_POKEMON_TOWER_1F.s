#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_POKEMON_TOWER_1F.h"
#include "msgdata/msg/msg_0885_CV_CANVAS_POKEMON_TOWER_1F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PokemonTower_1F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef PokemonTower_1F_EventScript_WorkerF
	ScrDef PokemonTower_1F_EventScript_Channeler
	ScrDef PokemonTower_1F_EventScript_Woman1
	ScrDef PokemonTower_1F_EventScript_Woman2
	ScrDef PokemonTower_1F_EventScript_BaldingMan
	ScrDef TypeTutor_EventScript_Ghost
	ScrDef PokemonTower_1F_OnTransition
	ScrDefEnd
	
PokemonTower_1F_EventScript_WorkerF:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0885_CV_CANVAS_POKEMON_TOWER_1F_PokemonTower_1F_Text_ErectedInMemoryOfDeadMons
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PokemonTower_1F_EventScript_Channeler:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0885_CV_CANVAS_POKEMON_TOWER_1F_PokemonTower_1F_Text_SenseSpiritsUpToMischief
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PokemonTower_1F_EventScript_Woman1:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0885_CV_CANVAS_POKEMON_TOWER_1F_PokemonTower_1F_Text_GrowlitheWhyDidYouDie
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PokemonTower_1F_EventScript_Woman2:
	LockAll
	FacePlayer
	GetPlayerGender VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PokemonTower_1F_EventScript_Woman2MalePlayer
	NPCMsg msg_0885_CV_CANVAS_POKEMON_TOWER_1F_PokemonTower_1F_Text_ComeToPayRespectsGirl
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PokemonTower_1F_EventScript_BaldingMan:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0885_CV_CANVAS_POKEMON_TOWER_1F_PokemonTower_1F_Text_CameToPrayForDepartedClefairy
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TypeTutor_EventScript_Ghost:
	LockAll
	FacePlayer
	SetVar 0x8004, 9
	GoTo TypeTutor_EventScript_Talk
	
PokemonTower_1F_OnTransition:
	End
	
PokemonTower_1F_EventScript_Woman2MalePlayer:
	NPCMsg msg_0885_CV_CANVAS_POKEMON_TOWER_1F_PokemonTower_1F_Text_ComeToPayRespectsSon
	WaitButton
	CloseMsg
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
	NPCMsg msg_0885_CV_CANVAS_POKEMON_TOWER_1F_TypeTutor_Text_WhichMove
	// TODO(gba) special TypeTutor_PushMoves
	GoTo _cv_stop
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_2
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq TypeTutor_EventScript_Bye
	CopyVar 0x8004, 0x8008
	// TODO(gba) special TypeTutor_SelectMove
	GoTo _cv_stop
	NPCMsg msg_0885_CV_CANVAS_POKEMON_TOWER_1F_TypeTutor_Text_WhichMon
	WaitButton
	Call EventScript_ChooseMoveTutorMon
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TypeTutor_EventScript_Teach
	NPCMsg msg_0885_CV_CANVAS_POKEMON_TOWER_1F_TypeTutor_Text_Taught
	WaitButton
	GoTo TypeTutor_EventScript_Teach
	
TypeTutor_EventScript_Bye:
	NPCMsg msg_0885_CV_CANVAS_POKEMON_TOWER_1F_TypeTutor_Text_Bye
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
	NPCMsg msg_0885_CV_CANVAS_POKEMON_TOWER_1F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
