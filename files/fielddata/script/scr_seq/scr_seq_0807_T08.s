#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T08.h"
#include "msgdata/msg/msg_0512_T08.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's FuchsiaCity_Frlg#world by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef FuchsiaCity_EventScript_Erik
	ScrDef FuchsiaCity_EventScript_Youngster
	ScrDef FuchsiaCity_EventScript_LittleBoy
	ScrDef FuchsiaCity_EventScript_OldMan
	ScrDef FuchsiaCity_EventScript_SubstituteTutor
	ScrDef FuchsiaCity_EventScript_Lass
	ScrDef TypeTutor_EventScript_Poison
	ScrDef TypeTutor_EventScript_Flying
	ScrDef FuchsiaCity_EventScript_CitySign
	ScrDef FuchsiaCity_EventScript_SafariZoneSign
	ScrDef FuchsiaCity_EventScript_GymSign
	ScrDef FuchsiaCity_EventScript_WardensHomeSign
	ScrDef FuchsiaCity_EventScript_VoltorbSign
	ScrDef FuchsiaCity_EventScript_SlowpokeSign
	ScrDef FuchsiaCity_EventScript_ChanseySign
	ScrDef FuchsiaCity_EventScript_KangaskhanSign
	ScrDef FuchsiaCity_EventScript_FossilMonSign
	ScrDef FuchsiaCity_EventScript_LaprasSign
	ScrDef FuchsiaCity_EventScript_SafariGameSign
	ScrDef Route19_EventScript_RouteSign
	ScrDef FuchsiaCity_OnTransition
	ScrDefEnd
	
FuchsiaCity_EventScript_Erik:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0512_T08_FuchsiaCity_Text_WheresSara
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_EventScript_Youngster:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0512_T08_FuchsiaCity_Text_ItemBallInThere
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_EventScript_LittleBoy:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0512_T08_FuchsiaCity_Text_DidYouTrySafariGame
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_EventScript_OldMan:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0512_T08_FuchsiaCity_Text_SafariZoneZooInFront
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_EventScript_SubstituteTutor:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0512_T08_FuchsiaCity_Text_SubstituteTutor_Retired
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_EventScript_Lass:
	LockAll
	FacePlayer
	NPCMsg msg_0512_T08_FuchsiaCity_Text_MyFatherIsGymLeader
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TypeTutor_EventScript_Poison:
	LockAll
	FacePlayer
	SetVar 0x8004, 15
	GoTo TypeTutor_EventScript_Talk
	
TypeTutor_EventScript_Flying:
	LockAll
	FacePlayer
	SetVar 0x8004, 16
	GoTo TypeTutor_EventScript_Talk
	
FuchsiaCity_EventScript_CitySign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0512_T08_FuchsiaCity_Text_CitySign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_EventScript_SafariZoneSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0512_T08_FuchsiaCity_Text_SafariZoneSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_EventScript_GymSign:
	LockAll
	NPCMsg msg_0512_T08_FuchsiaCity_Text_GymSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_EventScript_WardensHomeSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0512_T08_FuchsiaCity_Text_WardensHomeSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_EventScript_VoltorbSign:
	LockAll
	SetVar 0x8004, SPECIES_VOLTORB
	NPCMsg msg_0512_T08_FuchsiaCity_Text_VoltorbSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_EventScript_SlowpokeSign:
	LockAll
	SetVar 0x8004, SPECIES_SLOWPOKE
	NPCMsg msg_0512_T08_FuchsiaCity_Text_SlowpokeSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_EventScript_ChanseySign:
	LockAll
	SetVar 0x8004, SPECIES_CHANSEY
	NPCMsg msg_0512_T08_FuchsiaCity_Text_ChanseySign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_EventScript_KangaskhanSign:
	LockAll
	SetVar 0x8004, SPECIES_KANGASKHAN
	NPCMsg msg_0512_T08_FuchsiaCity_Text_KangaskhanSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_EventScript_FossilMonSign:
	LockAll
	GoToIfSet 0x20C7, FuchsiaCity_EventScript_OmanyteSign
	SetVar 0x8004, SPECIES_KABUTO
	NPCMsg msg_0512_T08_FuchsiaCity_Text_KabutoSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_EventScript_LaprasSign:
	LockAll
	SetVar 0x8004, SPECIES_LAPRAS
	NPCMsg msg_0512_T08_FuchsiaCity_Text_LaprasSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_EventScript_SafariGameSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0512_T08_FuchsiaCity_Text_SafariGameSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route19_EventScript_RouteSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0512_T08_Route19_Text_RouteSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_OnTransition:
	SetFlag FLAG_SYS_FLYPOINT_FUCHSIA
	CallIfSet 0x20C7, FuchsiaCity_EventScript_SetOmanyteGfx
	CallIfUnset 0x20C7, FuchsiaCity_EventScript_SetKabutoGfx
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
	
FuchsiaCity_EventScript_OmanyteSign:
	SetVar 0x8004, SPECIES_OMANYTE
	NPCMsg msg_0512_T08_FuchsiaCity_Text_OmanyteSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_EventScript_SetOmanyteGfx:
	SetVar 0x4020, 2638
	Return
	
FuchsiaCity_EventScript_SetKabutoGfx:
	SetVar 0x4020, 2640
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
	NPCMsg msg_0512_T08_TypeTutor_Text_WhichMove
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
	NPCMsg msg_0512_T08_TypeTutor_Text_WhichMon
	WaitButton
	Call EventScript_ChooseMoveTutorMon
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TypeTutor_EventScript_Teach
	NPCMsg msg_0512_T08_TypeTutor_Text_Taught
	WaitButton
	GoTo TypeTutor_EventScript_Teach
	
TypeTutor_EventScript_Bye:
	NPCMsg msg_0512_T08_TypeTutor_Text_Bye
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
	NPCMsg msg_0512_T08_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
