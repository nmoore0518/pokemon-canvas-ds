#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T03PC0101.h"
#include "msgdata/msg/msg_0463_T03PC0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PewterCity_PokemonCenter_1F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef PewterCity_PokemonCenter_1F_EventScript_Jigglypuff
	ScrDef PewterCity_PokemonCenter_1F_EventScript_Gentleman
	ScrDef PewterCity_PokemonCenter_1F_EventScript_Nurse
	ScrDef PewterCity_PokemonCenter_1F_EventScript_Youngster
	ScrDef MysteryEventClub_EventScript_Woman
	ScrDef PewterCity_PokemonCenter_1F_EventScript_GBAKid1
	ScrDef PewterCity_PokemonCenter_1F_EventScript_GBAKid2
	ScrDef TypeTutor_EventScript_NormalSupport
	ScrDef PewterCity_PokemonCenter_1F_OnTransition
	ScrDef CableClub_OnResume
	ScrDefEnd
	
PewterCity_PokemonCenter_1F_EventScript_Jigglypuff:
	LockAll
	FacePlayer
	// (music MUS_RG_JIGGLYPUFF: no HeartGold match yet)
	NPCMsg msg_0463_T03PC0101_PewterCity_PokemonCenter_1F_Text_Jigglypuff
	Wait 455, VAR_SPECIAL_RESULT
	PlayBGM SEQ_GS_POKESEN
	CloseMsg
	ReleaseAll
	End
	
PewterCity_PokemonCenter_1F_EventScript_Gentleman:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0463_T03PC0101_PewterCity_PokemonCenter_1F_Text_TeamRocketMtMoonImOnPhone
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_PokemonCenter_1F_EventScript_Nurse:
	LockAll
	FacePlayer
	SetVar VAR_SPECIAL_x8007, 0
	CallStd std_nurse_joy
	ReleaseAll
	End
	
PewterCity_PokemonCenter_1F_EventScript_Youngster:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0463_T03PC0101_PewterCity_PokemonCenter_1F_Text_WhenJiggylypuffSingsMonsGetDrowsy
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
MysteryEventClub_EventScript_Woman:
	LockAll
	FacePlayer
	CompareVarToValue 0x4001, 1
	GoToIfEq EventScript_AlreadyGaveProfile
	GoToIfSet 0x20B9, EventScript_GivenProfileBefore
	NPCMsg msg_0463_T03PC0101_Text_IdLoveToHearYourProfile
	WaitButton
	GoTo EventScript_AskForProfile
	CloseMsg
	End
	
PewterCity_PokemonCenter_1F_EventScript_GBAKid1:
	LockAll
	NPCMsg msg_0463_T03PC0101_PewterCity_PokemonCenter_1F_Text_TradingMyClefairyForPikachu
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_PokemonCenter_1F_EventScript_GBAKid2:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0463_T03PC0101_PewterCity_PokemonCenter_1F_Text_TradingPikachuWithKid
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TypeTutor_EventScript_NormalSupport:
	LockAll
	FacePlayer
	SetVar 0x8004, 3
	GoTo TypeTutor_EventScript_Talk
	
PewterCity_PokemonCenter_1F_OnTransition:
	End
	
CableClub_OnResume:
	// TODO(gba) special InitUnionRoom
	// TODO(gba) .if OW_FLAG_MOVE_UNION_ROOM_CHECK != 0
	Return
	// TODO(gba) .else 
	End
	// TODO(gba) .endif 
	End
	
EventScript_AlreadyGaveProfile:
	NPCMsg msg_0463_T03PC0101_Text_TellMoreNextTime
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_GivenProfileBefore:
	NPCMsg msg_0463_T03PC0101_Text_HiWeMeetAgain
	WaitButton
	GoTo EventScript_AskForNewProfile
	CloseMsg
	End
	
EventScript_AskForProfile:
	NPCMsg msg_0463_T03PC0101_Text_TellMeWhatsYourProfile
	// TODO(gba) multichoice 18, 6, MULTI_YESNOINFO_2, FALSE
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq EventScript_AcceptGiveProfile
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq EventScript_DeclineGiveProfile
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq EventScript_ProfileInfo
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq EventScript_DeclineGiveProfile
	CloseMsg
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
	
EventScript_AskForNewProfile:
	NPCMsg msg_0463_T03PC0101_Text_ChangeYourProfile
	// TODO(gba) multichoice 18, 6, MULTI_YESNOINFO_2, FALSE
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq EventScript_AcceptGiveNewProfile
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq EventScript_DeclineGiveNewProfile
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq EventScript_ProfileInfo2
	CloseMsg
	End
	
EventScript_AcceptGiveProfile:
	NPCMsg msg_0463_T03PC0101_Text_WhatsYourProfile
	WaitButton
	CloseMsg
	GoTo EventScript_GiveProfile
	End
	
EventScript_DeclineGiveProfile:
	NPCMsg msg_0463_T03PC0101_Text_DontBeLikeThat
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_ProfileInfo:
	NPCMsg msg_0463_T03PC0101_Text_ExplainProfile
	WaitButton
	GoTo EventScript_AskForProfile
	CloseMsg
	End
	
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
	NPCMsg msg_0463_T03PC0101_TypeTutor_Text_WhichMove
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
	NPCMsg msg_0463_T03PC0101_TypeTutor_Text_WhichMon
	WaitButton
	Call EventScript_ChooseMoveTutorMon
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TypeTutor_EventScript_Teach
	NPCMsg msg_0463_T03PC0101_TypeTutor_Text_Taught
	WaitButton
	GoTo TypeTutor_EventScript_Teach
	
EventScript_AcceptGiveNewProfile:
	NPCMsg msg_0463_T03PC0101_Text_WhatAreYouLikeNow
	WaitButton
	CloseMsg
	GoTo EventScript_GiveProfile
	End
	
EventScript_DeclineGiveNewProfile:
	NPCMsg msg_0463_T03PC0101_Text_LikeProfileWayItIs
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_ProfileInfo2:
	NPCMsg msg_0463_T03PC0101_Text_ExplainProfile
	WaitButton
	GoTo EventScript_AskForNewProfile
	CloseMsg
	End
	
EventScript_GiveProfile:
	SetVar 0x8004, 0
	Call Common_ShowEasyChatScreen
	LockAll
	FacePlayer
	CompareVarToValue 0x8004, 0
	GoToIfEq EventScript_GaveSpecialProfile
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq EventScript_CancelGiveProfile
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq EventScript_GaveProfile
	End
	
TypeTutor_EventScript_Bye:
	NPCMsg msg_0463_T03PC0101_TypeTutor_Text_Bye
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
	
Common_ShowEasyChatScreen:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special ShowEasyChatScreen
	GoTo _cv_stop
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	Return
	
EventScript_GaveSpecialProfile:
	SetVar 0x4001, 1
	SetVar 0x8004, 0
	// TODO(gba) special ShowEasyChatProfile
	GoTo _cv_stop
	Wait 80, VAR_SPECIAL_RESULT
	NPCMsg msg_0463_T03PC0101_Text_HeardThatBefore
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_CancelGiveProfile:
	NPCMsg msg_0463_T03PC0101_Text_DecidedNotTo
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_GaveProfile:
	SetVar 0x4001, 1
	SetVar 0x8004, 0
	// TODO(gba) special ShowEasyChatProfile
	GoTo _cv_stop
	Wait 80, VAR_SPECIAL_RESULT
	NPCMsg msg_0463_T03PC0101_Text_ProfileSaysSomethingAboutYou
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_str4:
	BufferPlayersName 6
	BufferRivalsName 7
	Return

_cv_stop:
	NPCMsg msg_0463_T03PC0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
