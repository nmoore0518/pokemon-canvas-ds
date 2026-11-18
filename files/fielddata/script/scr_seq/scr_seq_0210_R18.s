#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R18.h"
#include "msgdata/msg/msg_0358_R18.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route18_Frlg#world by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef TypeTutor_EventScript_Flying
	ScrDef Route18_EventScript_CyclingRoadSign
	ScrDef Route18_EventScript_RouteSign
	ScrDef Route17_EventScript_CyclingRoadSign
	ScrDef Route18_OnTransition
	ScrDefEnd
	
TypeTutor_EventScript_Flying:
	LockAll
	FacePlayer
	SetVar 0x8004, 16
	GoTo TypeTutor_EventScript_Talk
	
Route18_EventScript_CyclingRoadSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0358_R18_Route18_Text_CyclingRoadSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route18_EventScript_RouteSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0358_R18_Route18_Text_RouteSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route17_EventScript_CyclingRoadSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0358_R18_Route17_Text_CyclingRoadSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route18_OnTransition:
	CompareVarToValue 0x5030, 1
	CallIfEq Route18_OnTransitionCyclingRoad
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
	
Route18_OnTransitionCyclingRoad:
	SetFlag 0x210F
	Return
	
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
	NPCMsg msg_0358_R18_TypeTutor_Text_WhichMove
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
	NPCMsg msg_0358_R18_TypeTutor_Text_WhichMon
	WaitButton
	Call EventScript_ChooseMoveTutorMon
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TypeTutor_EventScript_Teach
	NPCMsg msg_0358_R18_TypeTutor_Text_Taught
	WaitButton
	GoTo TypeTutor_EventScript_Teach
	
TypeTutor_EventScript_Bye:
	NPCMsg msg_0358_R18_TypeTutor_Text_Bye
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
	NPCMsg msg_0358_R18_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
