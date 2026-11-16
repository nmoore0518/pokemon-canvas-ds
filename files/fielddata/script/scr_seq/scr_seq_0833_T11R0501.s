#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T11R0501.h"
#include "msgdata/msg/msg_0534_T11R0501.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SaffronCity_MrPsychicsHouse_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SaffronCity_MrPsychicsHouse_EventScript_MrPsychic
	ScrDef TypeTutor_EventScript_Psychic
	ScrDefEnd
	
SaffronCity_MrPsychicsHouse_EventScript_MrPsychic:
	LockAll
	FacePlayer
	GoToIfSet 0x2145, SaffronCity_MrPsychicsHouse_EventScript_AlreadyGotTM29
	NPCMsg msg_0534_T11R0501_SaffronCity_MrPsychicsHouse_Text_YouWantedThis
	WaitButton
	HasSpaceForItem ITEM_TM29, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq SaffronCity_MrPsychicsHouse_EventScript_NoRoomForTM29
	GiveItem ITEM_TM29, 1, VAR_SPECIAL_RESULT
	BufferItemName 1, ITEM_TM29
	BufferPlayersName 6
	NPCMsg msg_0534_T11R0501_SaffronCity_MrPsychicsHouse_Text_ReceivedTM29FromMrPsychic
	PlayFanfare SEQ_ME_LVUP
	WaitFanfare
	WaitButton
	NPCMsg msg_0534_T11R0501_SaffronCity_MrPsychicsHouse_Text_ExplainTM29
	WaitButton
	SetFlag 0x2145
	CloseMsg
	ReleaseAll
	End
	
TypeTutor_EventScript_Psychic:
	LockAll
	FacePlayer
	SetVar 0x8004, 13
	GoTo TypeTutor_EventScript_Talk
	
SaffronCity_MrPsychicsHouse_EventScript_AlreadyGotTM29:
	NPCMsg msg_0534_T11R0501_SaffronCity_MrPsychicsHouse_Text_ExplainTM29
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_MrPsychicsHouse_EventScript_NoRoomForTM29:
	NPCMsg msg_0534_T11R0501_SaffronCity_MrPsychicsHouse_Text_YouveNoRoom
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
	NPCMsg msg_0534_T11R0501_TypeTutor_Text_WhichMove
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
	NPCMsg msg_0534_T11R0501_TypeTutor_Text_WhichMon
	WaitButton
	Call EventScript_ChooseMoveTutorMon
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TypeTutor_EventScript_Teach
	NPCMsg msg_0534_T11R0501_TypeTutor_Text_Taught
	WaitButton
	GoTo TypeTutor_EventScript_Teach
	
TypeTutor_EventScript_Bye:
	NPCMsg msg_0534_T11R0501_TypeTutor_Text_Bye
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
	NPCMsg msg_0534_T11R0501_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
