#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_ACADEMY_LECTURE_A.h"
#include "msgdata/msg/msg_0976_CV_CANVAS_ACADEMY_LECTURE_A.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's LeaderAcademy_LectureA by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Academy_EventScript_Larkspur
	ScrDef Academy_EventScript_Camellia
	ScrDef Academy_EventScript_LectureAStudent
	ScrDefEnd
	
Academy_EventScript_Larkspur:
	LockAll
	FacePlayer
	SetVar 0x8008, 0
	GoToIfSet 0x2230, Academy_EventScript_LarkspurMenu
	Call Academy_EventScript_LarkspurLecture
	SetFlag 0x2230
	End
	
Academy_EventScript_Camellia:
	LockAll
	FacePlayer
	SetVar 0x8008, 1
	GoToIfSet 0x2231, Academy_EventScript_CamelliaMenu
	Call Academy_EventScript_CamelliaLecture
	SetFlag 0x2231
	End
	
Academy_EventScript_LectureAStudent:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0976_CV_CANVAS_ACADEMY_LECTURE_A_Academy_Text_LectureAStudent
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Academy_EventScript_LarkspurMenu:
	NPCMsg msg_0976_CV_CANVAS_ACADEMY_LECTURE_A_Academy_Text_TeacherMenu
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0976_CV_CANVAS_ACADEMY_LECTURE_A_Academy_Text_OptDemo, 0
	ScrCmd_559 msg_0976_CV_CANVAS_ACADEMY_LECTURE_A_Academy_Text_OptLecture, 1
	ScrCmd_559 msg_0976_CV_CANVAS_ACADEMY_LECTURE_A_Academy_Text_OptBye, 2
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
	Call Academy_EventScript_LarkspurLecture
	GoTo Academy_EventScript_LarkspurMenu
	
Academy_EventScript_LarkspurLecture:
	NPCMsg msg_0976_CV_CANVAS_ACADEMY_LECTURE_A_Academy_Text_LarkspurLecture0
	WaitButton
	NPCMsg msg_0976_CV_CANVAS_ACADEMY_LECTURE_A_Academy_Text_LarkspurLecture1
	WaitButton
	NPCMsg msg_0976_CV_CANVAS_ACADEMY_LECTURE_A_Academy_Text_LarkspurLecture2
	WaitButton
	NPCMsg msg_0976_CV_CANVAS_ACADEMY_LECTURE_A_Academy_Text_LarkspurLecture3
	WaitButton
	Return
	// TODO(gba) .global Academy_EventScript_Camellia
	GoTo _cv_stop
	End
	
Academy_EventScript_CamelliaMenu:
	NPCMsg msg_0976_CV_CANVAS_ACADEMY_LECTURE_A_Academy_Text_TeacherMenu
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0976_CV_CANVAS_ACADEMY_LECTURE_A_Academy_Text_OptDemo, 0
	ScrCmd_559 msg_0976_CV_CANVAS_ACADEMY_LECTURE_A_Academy_Text_OptLecture, 1
	ScrCmd_559 msg_0976_CV_CANVAS_ACADEMY_LECTURE_A_Academy_Text_OptBye, 2
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
	Call Academy_EventScript_CamelliaLecture
	GoTo Academy_EventScript_CamelliaMenu
	
Academy_EventScript_CamelliaLecture:
	NPCMsg msg_0976_CV_CANVAS_ACADEMY_LECTURE_A_Academy_Text_CamelliaLecture0
	WaitButton
	NPCMsg msg_0976_CV_CANVAS_ACADEMY_LECTURE_A_Academy_Text_CamelliaLecture1
	WaitButton
	NPCMsg msg_0976_CV_CANVAS_ACADEMY_LECTURE_A_Academy_Text_CamelliaLecture2
	WaitButton
	NPCMsg msg_0976_CV_CANVAS_ACADEMY_LECTURE_A_Academy_Text_CamelliaLecture3
	WaitButton
	Return
	// TODO(gba) .global Academy_EventScript_Foxglove
	GoTo _cv_stop
	End
	
Academy_EventScript_Demo:
	CopyVar 0x8004, 0x8008
	// TODO(gba) special Academy_SetupTeacher
	GoTo _cv_stop
	NPCMsg msg_0976_CV_CANVAS_ACADEMY_LECTURE_A_Academy_Text_DemoIntro
	WaitButton
	Call Academy_EventScript_PickRentals
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq Academy_EventScript_TeacherBye
	CopyVar 0x8004, 0x8008
	// TODO(gba) special Academy_SetupTeacher
	GoTo _cv_stop
	NPCMsg msg_0976_CV_CANVAS_ACADEMY_LECTURE_A_gGymChallengeIntroText
	WaitButton
	CloseMsg
	Call Academy_EventScript_Battle
	CopyVar 0x8009, VAR_SPECIAL_RESULT
	// TODO(gba) special Academy_RentalEnd
	GoTo _cv_stop
	CopyVar 0x8004, 0x8008
	// TODO(gba) special Academy_SetupTeacher
	GoTo _cv_stop
	CompareVarToValue 0x8009, 1
	GoToIfNe Academy_EventScript_DemoLost
	NPCMsg msg_0976_CV_CANVAS_ACADEMY_LECTURE_A_Academy_Text_DemoWon
	WaitButton
	SetVar 0x8004, 3
	Call Academy_EventScript_EarnBP
	NPCMsg msg_0976_CV_CANVAS_ACADEMY_LECTURE_A_Academy_Text_RentalReturn
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Academy_EventScript_TeacherBye:
	ReleaseAll
	End
	
Academy_EventScript_PickRentals:
	// TODO(gba) special Academy_RentalBegin
	GoTo _cv_stop
	SetVar 0x8007, 1
	End
	
Academy_EventScript_Battle:
	ClearTrainerFlag 1442
	SetFlag 0x2036
	CheckTrainerFlag 1442
	GoToIf TRUE, _cv_beaten_5
	TrainerBattle 1442, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_6
	WhiteOut
	End
_cv_won_6:
	SetTrainerFlag 1442
	ReleaseAll
	End
_cv_beaten_5:
	ClearFlag 0x2036
	// TODO(gba) special GymChallenge_EndPractice
	GoTo _cv_stop
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq _cv_won_7
	SetVar VAR_SPECIAL_RESULT, 2
_cv_won_7:
	Return
	
Academy_EventScript_DemoLost:
	NPCMsg msg_0976_CV_CANVAS_ACADEMY_LECTURE_A_Academy_Text_DemoLost
	WaitButton
	NPCMsg msg_0976_CV_CANVAS_ACADEMY_LECTURE_A_Academy_Text_RentalReturn
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Academy_EventScript_EarnBP:
	// TODO(gba) special Academy_AddBP
	GoTo _cv_stop
	PlayFanfare SEQ_ME_LVUP
	BufferPlayersName 6
	NPCMsg msg_0976_CV_CANVAS_ACADEMY_LECTURE_A_Academy_Text_EarnedBP
	WaitFanfare
	WaitButton
	Return
	// TODO(gba) .global Academy_EventScript_Koji
	GoTo _cv_stop
	End

_cv_stop:
	NPCMsg msg_0976_CV_CANVAS_ACADEMY_LECTURE_A_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
