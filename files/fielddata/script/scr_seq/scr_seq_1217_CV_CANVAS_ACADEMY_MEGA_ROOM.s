#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_ACADEMY_MEGA_ROOM.h"
#include "msgdata/msg/msg_0980_CV_CANVAS_ACADEMY_MEGA_ROOM.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's LeaderAcademy_MegaRoom by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Academy_EventScript_MegaKeeper
	ScrDefEnd
	
Academy_EventScript_MegaKeeper:
	LockAll
	FacePlayer
	NPCMsg msg_0980_CV_CANVAS_ACADEMY_MEGA_ROOM_Academy_Text_MegaKeeperIntro
	WaitButton
	GoTo Academy_EventScript_MegaKeeperAsk
	
Academy_EventScript_MegaKeeperAsk:
	NPCMsg msg_0980_CV_CANVAS_ACADEMY_MEGA_ROOM_Academy_Text_MegaKeeperAsk
	WaitButton
	CloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	ScrCmd_566
	GetPartySelection 0x8004
	RestoreOverworld
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	CompareVarToValue 0x8004, 6
	GoToIfGe Academy_EventScript_MegaLater
	CopyVar 0x8008, 0x8004
	// TODO(gba) special Academy_MegaTrialCheck
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Academy_EventScript_MegaNoStone
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfEq Academy_EventScript_MegaHasAll
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq Academy_EventScript_MegaWhich
	SetVar 0x8004, 0
	GoTo Academy_EventScript_MegaPicked
	
Academy_EventScript_MegaLater:
	NPCMsg msg_0980_CV_CANVAS_ACADEMY_MEGA_ROOM_Academy_Text_MegaLater
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Academy_EventScript_MegaNoStone:
	NPCMsg msg_0980_CV_CANVAS_ACADEMY_MEGA_ROOM_Academy_Text_MegaNoStone
	WaitButton
	GoTo Academy_EventScript_MegaKeeperAsk
	
Academy_EventScript_MegaHasAll:
	NPCMsg msg_0980_CV_CANVAS_ACADEMY_MEGA_ROOM_Academy_Text_MegaHasAll
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Academy_EventScript_MegaWhich:
	NPCMsg msg_0980_CV_CANVAS_ACADEMY_MEGA_ROOM_Academy_Text_MegaWhich
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0980_CV_CANVAS_ACADEMY_MEGA_ROOM_gStringVar1, 0
	ScrCmd_559 msg_0980_CV_CANVAS_ACADEMY_MEGA_ROOM_gStringVar2, 1
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_2
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq Academy_EventScript_MegaLater
	CopyVar 0x8004, VAR_SPECIAL_RESULT
	GoTo Academy_EventScript_MegaPicked
	
Academy_EventScript_MegaPicked:
	// TODO(gba) special Academy_MegaTrialPickStone
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Academy_EventScript_MegaHasThis
	CopyVar 0x8009, 0x8005
	BufferItemName 0, 0x8009
	NPCMsg msg_0980_CV_CANVAS_ACADEMY_MEGA_ROOM_Academy_Text_MegaConfirm
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_3
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_4
_cv_yes_3:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Academy_EventScript_MegaLater
	CopyVar 0x8004, 0x8008
	CopyVar 0x8005, 0x8009
	// TODO(gba) special Academy_MegaTrialBegin
	GoTo _cv_stop
	NPCMsg msg_0980_CV_CANVAS_ACADEMY_MEGA_ROOM_gGymChallengeIntroText
	WaitButton
	CanvasCloseMsg
	Call Academy_EventScript_Battle
	CopyVar 0x8008, VAR_SPECIAL_RESULT
	// TODO(gba) special Academy_RentalEnd
	GoTo _cv_stop
	BufferItemName 0, 0x8009
	CompareVarToValue 0x8008, 1
	GoToIfNe Academy_EventScript_MegaLost
	NPCMsg msg_0980_CV_CANVAS_ACADEMY_MEGA_ROOM_Academy_Text_MegaWon
	WaitButton
	GiveItem 0x8009, 1, VAR_SPECIAL_RESULT
	NPCMsg msg_0980_CV_CANVAS_ACADEMY_MEGA_ROOM_Academy_Text_MegaPartyBack
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Academy_EventScript_MegaHasThis:
	NPCMsg msg_0980_CV_CANVAS_ACADEMY_MEGA_ROOM_Academy_Text_MegaHasThis
	WaitButton
	GoTo Academy_EventScript_MegaWhich
	
Academy_EventScript_Battle:
	ClearTrainerFlag 1442
	SetFlag 0x2036
	CanvasCloseMsg
	TrainerBattle 1442, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_6
	WhiteOut
	End
_cv_won_6:
	SetTrainerFlag 1442
	ClearFlag 0x2036
	CanvasCandidate 12
	GetStaticEncounterOutcome VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfNe _cv_outcome_7
	SetVar VAR_SPECIAL_RESULT, 7
	GoTo _cv_outcome_8
_cv_outcome_7:
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfNe _cv_outcome_8
	SetVar VAR_SPECIAL_RESULT, 4
_cv_outcome_8:
	Return
	
Academy_EventScript_MegaLost:
	NPCMsg msg_0980_CV_CANVAS_ACADEMY_MEGA_ROOM_Academy_Text_MegaLost
	WaitButton
	NPCMsg msg_0980_CV_CANVAS_ACADEMY_MEGA_ROOM_Academy_Text_MegaPartyBack
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0980_CV_CANVAS_ACADEMY_MEGA_ROOM_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
