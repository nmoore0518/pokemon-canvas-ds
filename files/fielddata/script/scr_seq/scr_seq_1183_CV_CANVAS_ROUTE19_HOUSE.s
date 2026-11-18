#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_ROUTE19_HOUSE.h"
#include "msgdata/msg/msg_0963_CV_CANVAS_ROUTE19_HOUSE.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route19_UnusedHouse_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route19_BeachHouse_EventScript_SurfinDude
	ScrDef Route19_BeachHouse_EventScript_Pikachu
	ScrDefEnd
	
Route19_BeachHouse_EventScript_SurfinDude:
	LockAll
	FacePlayer
	// TODO(gba) special SurfingPikachu_CheckInParty
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Route19_BeachHouse_EventScript_NoSurfer
	CompareVarToValue 0x5042, 0
	GoToIfNe Route19_BeachHouse_EventScript_Again
	NPCMsg msg_0963_CV_CANVAS_ROUTE19_HOUSE_Route19_BeachHouse_Text_WhoaASurfer
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	GoTo Route19_BeachHouse_EventScript_Answer
	
Route19_BeachHouse_EventScript_Pikachu:
	LockAll
	FacePlayer
	NPCMsg msg_0963_CV_CANVAS_ROUTE19_HOUSE_Route19_BeachHouse_Text_Pikachu
	WaitButton
	PlayCry SPECIES_PIKACHU, 0
	WaitCry
	CloseMsg
	ReleaseAll
	End
	
Route19_BeachHouse_EventScript_NoSurfer:
	NPCMsg msg_0963_CV_CANVAS_ROUTE19_HOUSE_Route19_BeachHouse_Text_NoSurfer
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route19_BeachHouse_EventScript_Again:
	BufferInt 0, 0x5042
	NPCMsg msg_0963_CV_CANVAS_ROUTE19_HOUSE_Route19_BeachHouse_Text_Again
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_3
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_4
_cv_yes_3:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_4:
	End
	
Route19_BeachHouse_EventScript_Answer:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Route19_BeachHouse_EventScript_NotToday
	NPCMsg msg_0963_CV_CANVAS_ROUTE19_HOUSE_Route19_BeachHouse_Text_HangTen
	WaitButton
	CloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special SurfingMinigame_Start
	GoTo _cv_stop
	BufferInt 0, 0x5042
	NPCMsg msg_0963_CV_CANVAS_ROUTE19_HOUSE_Route19_BeachHouse_Text_After
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route19_BeachHouse_EventScript_NotToday:
	NPCMsg msg_0963_CV_CANVAS_ROUTE19_HOUSE_Route19_BeachHouse_Text_NotToday
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0963_CV_CANVAS_ROUTE19_HOUSE_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
