#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_ACADEMY_LECTURE_B.h"
#include "msgdata/msg/msg_0977_CV_CANVAS_ACADEMY_LECTURE_B.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's LeaderAcademy_LectureB by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Academy_EventScript_Foxglove
	ScrDef Academy_EventScript_Verbena
	ScrDef Academy_EventScript_LectureBStudent
	ScrDefEnd
	
Academy_EventScript_Foxglove:
	LockAll
	FacePlayer
	SetVar 0x8008, 2
	GoToIfSet 0x2232, Academy_EventScript_FoxgloveMenu
	Call Academy_EventScript_FoxgloveLecture
	SetFlag 0x2232
	GoTo Academy_EventScript_FoxgloveMenu
	
Academy_EventScript_Verbena:
	LockAll
	FacePlayer
	SetVar 0x8008, 3
	GoToIfSet 0x2233, Academy_EventScript_VerbenaMenu
	Call Academy_EventScript_VerbenaLecture
	SetFlag 0x2233
	GoTo Academy_EventScript_VerbenaMenu
	
Academy_EventScript_LectureBStudent:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0977_CV_CANVAS_ACADEMY_LECTURE_B_Academy_Text_LectureBStudent
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Academy_EventScript_FoxgloveMenu:
	NPCMsg msg_0977_CV_CANVAS_ACADEMY_LECTURE_B_Academy_Text_TeacherMenu
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0977_CV_CANVAS_ACADEMY_LECTURE_B_Academy_Text_OptDemo, 0
	ScrCmd_559 msg_0977_CV_CANVAS_ACADEMY_LECTURE_B_Academy_Text_OptLecture, 1
	ScrCmd_559 msg_0977_CV_CANVAS_ACADEMY_LECTURE_B_Academy_Text_OptBye, 2
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_2
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Academy_EventScript_Demo
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfNe Academy_EventScript_TeacherBye
	Call Academy_EventScript_FoxgloveLecture
	GoTo Academy_EventScript_FoxgloveMenu
	
Academy_EventScript_FoxgloveLecture:
	NPCMsg msg_0977_CV_CANVAS_ACADEMY_LECTURE_B_Academy_Text_FoxgloveLecture0
	WaitButton
	NPCMsg msg_0977_CV_CANVAS_ACADEMY_LECTURE_B_Academy_Text_FoxgloveLecture1
	WaitButton
	NPCMsg msg_0977_CV_CANVAS_ACADEMY_LECTURE_B_Academy_Text_FoxgloveLecture2
	WaitButton
	NPCMsg msg_0977_CV_CANVAS_ACADEMY_LECTURE_B_Academy_Text_FoxgloveLecture3
	WaitButton
	Return
	
Academy_EventScript_VerbenaMenu:
	NPCMsg msg_0977_CV_CANVAS_ACADEMY_LECTURE_B_Academy_Text_TeacherMenu
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0977_CV_CANVAS_ACADEMY_LECTURE_B_Academy_Text_OptDemo, 0
	ScrCmd_559 msg_0977_CV_CANVAS_ACADEMY_LECTURE_B_Academy_Text_OptLecture, 1
	ScrCmd_559 msg_0977_CV_CANVAS_ACADEMY_LECTURE_B_Academy_Text_OptBye, 2
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_4
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Academy_EventScript_Demo
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfNe Academy_EventScript_TeacherBye
	Call Academy_EventScript_VerbenaLecture
	GoTo Academy_EventScript_VerbenaMenu
	
Academy_EventScript_VerbenaLecture:
	NPCMsg msg_0977_CV_CANVAS_ACADEMY_LECTURE_B_Academy_Text_VerbenaLecture0
	WaitButton
	NPCMsg msg_0977_CV_CANVAS_ACADEMY_LECTURE_B_Academy_Text_VerbenaLecture1
	WaitButton
	NPCMsg msg_0977_CV_CANVAS_ACADEMY_LECTURE_B_Academy_Text_VerbenaLecture2
	WaitButton
	NPCMsg msg_0977_CV_CANVAS_ACADEMY_LECTURE_B_Academy_Text_VerbenaLecture3
	WaitButton
	Return
	
Academy_EventScript_Demo:
	CopyVar 0x8004, 0x8008
	// TODO(gba) special Academy_SetupTeacher
	GoTo _cv_stop
	NPCMsg msg_0977_CV_CANVAS_ACADEMY_LECTURE_B_Academy_Text_DemoIntro
	WaitButton
	Call Academy_EventScript_PickRentals
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq Academy_EventScript_TeacherBye
	CopyVar 0x8004, 0x8008
	// TODO(gba) special Academy_SetupTeacher
	GoTo _cv_stop
	NPCMsg msg_0977_CV_CANVAS_ACADEMY_LECTURE_B_gGymChallengeIntroText
	WaitButton
	CanvasCloseMsg
	Call Academy_EventScript_Battle
	CopyVar 0x8009, VAR_SPECIAL_RESULT
	// TODO(gba) special Academy_RentalEnd
	GoTo _cv_stop
	CopyVar 0x8004, 0x8008
	// TODO(gba) special Academy_SetupTeacher
	GoTo _cv_stop
	CompareVarToValue 0x8009, 1
	GoToIfNe Academy_EventScript_DemoLost
	NPCMsg msg_0977_CV_CANVAS_ACADEMY_LECTURE_B_Academy_Text_DemoWon
	WaitButton
	SetVar 0x8004, 3
	Call Academy_EventScript_EarnBP
	NPCMsg msg_0977_CV_CANVAS_ACADEMY_LECTURE_B_Academy_Text_RentalReturn
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Academy_EventScript_TeacherBye:
	CanvasCloseMsg
	ReleaseAll
	End
	
Academy_EventScript_PickRentals:
	// TODO(gba) special Academy_RentalBegin
	GoTo _cv_stop
	SetVar 0x8007, 1
	GoTo Academy_EventScript_PickRentalLoop
	
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
	
Academy_EventScript_DemoLost:
	NPCMsg msg_0977_CV_CANVAS_ACADEMY_LECTURE_B_Academy_Text_DemoLost
	WaitButton
	NPCMsg msg_0977_CV_CANVAS_ACADEMY_LECTURE_B_Academy_Text_RentalReturn
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Academy_EventScript_EarnBP:
	// TODO(gba) special Academy_AddBP
	GoTo _cv_stop
	PlayFanfare SEQ_ME_LVUP
	BufferPlayersName 6
	NPCMsg msg_0977_CV_CANVAS_ACADEMY_LECTURE_B_Academy_Text_EarnedBP
	WaitFanfare
	WaitButton
	Return
	
Academy_EventScript_PickRentalLoop:
	BufferInt 0, 0x8007
	NPCMsg msg_0977_CV_CANVAS_ACADEMY_LECTURE_B_Academy_Text_RentalPick
	// TODO(gba) special Academy_PushRentals
	GoTo _cv_stop
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_10
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_10:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq Academy_EventScript_PickRentalCancel
	CopyVar 0x8004, VAR_SPECIAL_RESULT
	// TODO(gba) special Academy_BufferRental
	GoTo _cv_stop
	NPCMsg msg_0977_CV_CANVAS_ACADEMY_LECTURE_B_Academy_Text_RentalInfo
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_11
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_12
_cv_yes_11:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_12:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Academy_EventScript_PickRentalLoop
	// TODO(gba) special Academy_TakeRental
	GoTo _cv_stop
	AddVar 0x8007, 1
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfLt Academy_EventScript_PickRentalLoop
	SetVar VAR_SPECIAL_RESULT, 0
	Return
	
Academy_EventScript_PickRentalCancel:
	// TODO(gba) special Academy_RentalEnd
	GoTo _cv_stop
	SetVar VAR_SPECIAL_RESULT, 127
	Return

_cv_stop:
	NPCMsg msg_0977_CV_CANVAS_ACADEMY_LECTURE_B_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
