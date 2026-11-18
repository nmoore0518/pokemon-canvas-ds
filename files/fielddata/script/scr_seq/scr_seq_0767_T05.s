#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T05.h"
#include "msgdata/msg/msg_0475_T05.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's LavenderTown_Frlg#world by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef LavenderTown_EventScript_LittleGirl
	ScrDef LavenderTown_EventScript_WorkerM
	ScrDef LavenderTown_EventScript_Boy
	ScrDef TypeTutor_EventScript_Dark
	ScrDef LavenderTown_EventScript_SilphScopeNotice
	ScrDef LavenderTown_EventScript_TownSign
	ScrDef LavenderTown_EventScript_PokemonTowerSign
	ScrDef LavenderTown_EventScript_VolunteerHouseSign
	ScrDef LavenderTown_OnTransition
	ScrDefEnd
	
LavenderTown_EventScript_LittleGirl:
	LockAll
	FacePlayer
	NPCMsg msg_0475_T05_LavenderTown_Text_DoYouBelieveInGhosts
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq LavenderTown_EventScript_LittleGirlBelieve
	NPCMsg msg_0475_T05_LavenderTown_Text_JustImaginingWhiteHand
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
LavenderTown_EventScript_WorkerM:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0475_T05_LavenderTown_Text_TownKnownAsMonGraveSite
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
LavenderTown_EventScript_Boy:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0475_T05_LavenderTown_Text_GhostsAppearedInTower
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TypeTutor_EventScript_Dark:
	LockAll
	FacePlayer
	SetVar 0x8004, 10
	GoTo TypeTutor_EventScript_Talk
	
LavenderTown_EventScript_SilphScopeNotice:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0475_T05_LavenderTown_Text_SilphScopeNotice
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
LavenderTown_EventScript_TownSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0475_T05_LavenderTown_Text_TownSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
LavenderTown_EventScript_PokemonTowerSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0475_T05_LavenderTown_Text_PokemonTowerSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
LavenderTown_EventScript_VolunteerHouseSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0475_T05_LavenderTown_Text_VolunteerPokemonHouse
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
LavenderTown_OnTransition:
	SetFlag FLAG_SYS_FLYPOINT_LAVENDER
	SetVar 0x502A, 1
	SetFlag 0x2060
	End
	
LavenderTown_EventScript_LittleGirlBelieve:
	NPCMsg msg_0475_T05_LavenderTown_Text_SoThereAreBelievers
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
	NPCMsg msg_0475_T05_TypeTutor_Text_WhichMove
	// TODO(gba) special TypeTutor_PushMoves
	GoTo _cv_stop
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_4
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq TypeTutor_EventScript_Bye
	CopyVar 0x8004, 0x8008
	// TODO(gba) special TypeTutor_SelectMove
	GoTo _cv_stop
	NPCMsg msg_0475_T05_TypeTutor_Text_WhichMon
	WaitButton
	Call EventScript_ChooseMoveTutorMon
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TypeTutor_EventScript_Teach
	NPCMsg msg_0475_T05_TypeTutor_Text_Taught
	WaitButton
	GoTo TypeTutor_EventScript_Teach
	
TypeTutor_EventScript_Bye:
	NPCMsg msg_0475_T05_TypeTutor_Text_Bye
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
	NPCMsg msg_0475_T05_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
