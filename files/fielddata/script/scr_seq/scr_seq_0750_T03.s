#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T03.h"
#include "msgdata/msg/msg_0460_T03.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PewterCity_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef PewterCity_EventScript_Lass
	ScrDef PewterCity_EventScript_MuseumGuide
	ScrDef PewterCity_EventScript_FatMan
	ScrDef PewterCity_EventScript_BugCatcher
	ScrDef PewterCity_EventScript_GymGuide
	ScrDef PewterCity_EventScript_RunningShoesAide
	ScrDef TypeTutor_EventScript_Rock
	ScrDef PewterCity_EventScript_MuseumSign
	ScrDef PewterCity_EventScript_PoliceNotice
	ScrDef PewterCity_EventScript_GymSign
	ScrDef PewterCity_EventScript_TrainerTips
	ScrDef PewterCity_EventScript_CitySign
	ScrDef PewterCity_EventScript_GymGuideTriggerTop
	ScrDef PewterCity_EventScript_GymGuideTriggerMid
	ScrDef PewterCity_EventScript_GymGuideTriggerBottom
	ScrDef PewterCity_EventScript_GymGuideTriggerRight
	ScrDef PewterCity_EventScript_RunningShoesAideTriggerTop
	ScrDef PewterCity_EventScript_RunningShoesAideTriggerMid
	ScrDef PewterCity_EventScript_RunningShoesAideTriggerBottom
	ScrDef PewterCity_OnTransition
	ScrDefEnd
	
PewterCity_EventScript_Lass:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0460_T03_PewterCity_Text_ClefairyCameFromMoon
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_EventScript_MuseumGuide:
	LockAll
	FacePlayer
	NPCMsg msg_0460_T03_PewterCity_Text_DidYouCheckOutMuseum
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq PewterCity_EventScript_CheckedOutMuseum
	NPCMsg msg_0460_T03_PewterCity_Text_ReallyYouHaveToGo
	WaitButton
	CloseMsg
	Wait 10, VAR_SPECIAL_RESULT
	PlayBGM SEQ_GS_E_TSURETEKE1
	CompareVarToValue 0x5002, 0
	CallIfEq PewterCity_EventScript_LeadToMuseumNorth
	CompareVarToValue 0x5002, 1
	CallIfEq PewterCity_EventScript_LeadToMuseumSouth
	CompareVarToValue 0x5002, 2
	CallIfEq PewterCity_EventScript_LeadToMuseumWest
	CompareVarToValue 0x5002, 3
	CallIfEq PewterCity_EventScript_LeadToMuseumEast
	NPCMsg msg_0460_T03_PewterCity_Text_ThisIsTheMuseum
	WaitButton
	CloseMsg
	Wait 10, VAR_SPECIAL_RESULT
	ApplyMovement 2, PewterCity_Movement_MuseumGuideExit
	WaitMovement
	ResetBGM
	HidePerson 2
	SetFlag 0x20B3
	ClearFlag 0x20B3
	ShowPerson 2
	ReleaseAll
	End
	
PewterCity_EventScript_FatMan:
	LockAll
	FacePlayer
	NPCMsg msg_0460_T03_PewterCity_Text_BrockOnlySeriousTrainerHere
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_EventScript_BugCatcher:
	LockAll
	FacePlayer
	NPCMsg msg_0460_T03_PewterCity_Text_DoYouKnowWhatImDoing
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_3
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_4
_cv_yes_3:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq PewterCity_EventScript_KnowWhatTheyreDoing
	NPCMsg msg_0460_T03_PewterCity_Text_SprayingRepelToKeepWildMonsOut
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_EventScript_GymGuide:
	LockAll
	FacePlayer
	NPCMsg msg_0460_T03_PewterCity_Text_BrocksLookingForChallengersFollowMe
	WaitButton
	CloseMsg
	PlayBGM SEQ_GS_E_TSURETEKE1
	CompareVarToValue 0x5002, 3
	CallIfEq PewterCity_EventScript_WalkToGymEast
	NPCMsg msg_0460_T03_PewterCity_Text_GoTakeOnBrock
	WaitButton
	CloseMsg
	ApplyMovement 5, PewterCity_Movement_GymGuideExit
	WaitMovement
	ResetBGM
	HidePerson 5
	SetFlag 0x20B4
	ClearFlag 0x20B4
	ShowPerson 5
	ReleaseAll
	End
	
PewterCity_EventScript_RunningShoesAide:
	LockAll
	FacePlayer
	SetVar 0x4001, 0
	Call PewterCity_EventScript_AideGiveRunningShoes
	ReleaseAll
	End
	
TypeTutor_EventScript_Rock:
	LockAll
	FacePlayer
	SetVar 0x8004, 4
	GoTo TypeTutor_EventScript_Talk
	
PewterCity_EventScript_MuseumSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0460_T03_PewterCity_Text_MuseumOfScience
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_EventScript_PoliceNotice:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0460_T03_PewterCity_Text_CallPoliceIfInfoOnThieves
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_EventScript_GymSign:
	LockAll
	NPCMsg msg_0460_T03_PewterCity_Text_GymSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_EventScript_TrainerTips:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0460_T03_PewterCity_Text_TrainerTipsEarningEXP
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_EventScript_CitySign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0460_T03_PewterCity_Text_CitySign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_EventScript_GymGuideTriggerTop:
	LockAll
	SetVar 0x4001, 0
	GoTo PewterCity_EventScript_GymGuideTrigger
	End
	
PewterCity_EventScript_GymGuideTriggerMid:
	LockAll
	SetVar 0x4001, 1
	GoTo PewterCity_EventScript_GymGuideTrigger
	End
	
PewterCity_EventScript_GymGuideTriggerBottom:
	LockAll
	SetVar 0x4001, 2
	GoTo PewterCity_EventScript_GymGuideTrigger
	End
	
PewterCity_EventScript_GymGuideTriggerRight:
	LockAll
	SetVar 0x4001, 3
	GoTo PewterCity_EventScript_GymGuideTrigger
	End
	
PewterCity_EventScript_RunningShoesAideTriggerTop:
	LockAll
	SetVar 0x4001, 1
	Call PewterCity_EventScript_AideGiveRunningShoes
	ReleaseAll
	End
	
PewterCity_EventScript_RunningShoesAideTriggerMid:
	LockAll
	SetVar 0x4001, 2
	Call PewterCity_EventScript_AideGiveRunningShoes
	ReleaseAll
	End
	
PewterCity_EventScript_RunningShoesAideTriggerBottom:
	LockAll
	SetVar 0x4001, 3
	Call PewterCity_EventScript_AideGiveRunningShoes
	ReleaseAll
	End
	
PewterCity_OnTransition:
	SetFlag FLAG_SYS_FLYPOINT_PEWTER
	SetVar 0x5021, 0
	End
	
PewterCity_EventScript_CheckedOutMuseum:
	NPCMsg msg_0460_T03_PewterCity_Text_WerentThoseFossilsAmazing
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_EventScript_LeadToMuseumNorth:
	ApplyMovement 2, PewterCity_Movement_GuideWalkToMuseumNorth
	ApplyMovement obj_player, PewterCity_Movement_PlayerWalkToMuseumNorth
	WaitMovement
	Return
	
PewterCity_EventScript_LeadToMuseumSouth:
	ApplyMovement 2, PewterCity_Movement_GuideWalkToMuseumSouth
	ApplyMovement obj_player, PewterCity_Movement_PlayerWalkToMuseumSouth
	WaitMovement
	Return
	
PewterCity_EventScript_LeadToMuseumWest:
	ApplyMovement 2, PewterCity_Movement_GuideWalkToMuseumWest
	ApplyMovement obj_player, PewterCity_Movement_PlayerWalkToMuseumWest
	WaitMovement
	Return
	
PewterCity_EventScript_LeadToMuseumEast:
	ApplyMovement 2, PewterCity_Movement_GuideWalkToMuseumEast
	ApplyMovement obj_player, PewterCity_Movement_PlayerWalkToMuseumEast
	WaitMovement
	Return
	
PewterCity_EventScript_KnowWhatTheyreDoing:
	NPCMsg msg_0460_T03_PewterCity_Text_ThatsRightItsHardWork
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_EventScript_WalkToGymEast:
	ApplyMovement obj_player, PewterCity_Movement_PlayerWaitForGuideEast
	ApplyMovement 5, PewterCity_Movement_GuideMoveToLeadEast
	WaitMovement
	ApplyMovement obj_player, PewterCity_Movement_PlayerWalkToGymEast
	ApplyMovement 5, PewterCity_Movement_GuideWalkToGymEast
	WaitMovement
	Return
	
PewterCity_EventScript_AideGiveRunningShoes:
	CompareVarToValue 0x4001, 1
	CallIfEq PewterCity_EventScript_AideNoticePlayer
	CompareVarToValue 0x4001, 2
	CallIfEq PewterCity_EventScript_AideNoticePlayer
	CompareVarToValue 0x4001, 3
	CallIfEq PewterCity_EventScript_AideNoticePlayer
	WaitSE SEQ_SE_DP_SELECT
	PlaySE SEQ_SE_DP_SELECT
	ApplyMovement 7, Common_Movement_ExclamationMark
	WaitMovement
	ApplyMovement 7, Common_Movement_Delay48
	WaitMovement
	BufferPlayersName 6
	NPCMsg msg_0460_T03_PewterCity_Text_OhPlayer
	WaitButton
	CompareVarToValue 0x4001, 0
	CallIfEq PewterCity_EventScript_AideApproachPlayer0
	CompareVarToValue 0x4001, 1
	CallIfEq PewterCity_EventScript_AideApproachPlayer1
	CompareVarToValue 0x4001, 2
	CallIfEq PewterCity_EventScript_AideApproachPlayer2
	CompareVarToValue 0x4001, 3
	CallIfEq PewterCity_EventScript_AideApproachPlayer3
	NPCMsg msg_0460_T03_PewterCity_Text_AskedToDeliverThis
	WaitButton
	PlayFanfare SEQ_ME_ITEM
	BufferPlayersName 6
	NPCMsg msg_0460_T03_PewterCity_Text_ReceivedRunningShoesFromAide
	WaitFanfare
	BufferPlayersName 6
	NPCMsg msg_0460_T03_PewterCity_Text_SwitchedShoesWithRunningShoes
	WaitButton
	NPCMsg msg_0460_T03_PewterCity_Text_ExplainRunningShoes
	WaitButton
	Call EventScript_RestorePrevTextColor
	NPCMsg msg_0460_T03_PewterCity_Text_MustBeGoingBackToLab
	WaitButton
	CloseMsg
	CompareVarToValue 0x4001, 0
	CallIfEq PewterCity_EventScript_AideExit0
	CompareVarToValue 0x4001, 1
	CallIfEq PewterCity_EventScript_AideExit1
	CompareVarToValue 0x4001, 2
	CallIfEq PewterCity_EventScript_AideExit2
	CompareVarToValue 0x4001, 3
	CallIfEq PewterCity_EventScript_AideExit3
	Wait 30, VAR_SPECIAL_RESULT
	BufferPlayersName 6
	NPCMsg msg_0460_T03_PewterCity_Text_RunningShoesLetterFromMom
	WaitButton
	CloseMsg
	HidePerson 7
	SetFlag 0x205B
	SetFlag 0x20B5
	GiveRunningShoes
	SetVar 0x5022, 2
	Return
	
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
	
PewterCity_EventScript_GymGuideTrigger:
	NPCMsg msg_0460_T03_PewterCity_Text_BrocksLookingForChallengersFollowMe
	WaitButton
	CloseMsg
	PlayBGM SEQ_GS_E_TSURETEKE1
	CompareVarToValue 0x4001, 3
	GoToIfNe _cv_lane_5
	Call PewterCity_EventScript_WalkToGymRight
_cv_lane_5:
	CompareVarToValue 0x4001, 0
	CallIfEq PewterCity_EventScript_WalkToGymTop
	CompareVarToValue 0x4001, 1
	CallIfEq PewterCity_EventScript_WalkToGymMid
	CompareVarToValue 0x4001, 2
	CallIfEq PewterCity_EventScript_WalkToGymBottom
	NPCMsg msg_0460_T03_PewterCity_Text_GoTakeOnBrock
	WaitButton
	CloseMsg
	ApplyMovement 5, PewterCity_Movement_GymGuideExit
	WaitMovement
	ResetBGM
	HidePerson 5
	SetFlag 0x20B4
	ClearFlag 0x20B4
	ShowPerson 5
	ReleaseAll
	End
	
PewterCity_EventScript_AideNoticePlayer:
	ApplyMovement 7, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	Return
	
PewterCity_EventScript_AideApproachPlayer0:
	CloseMsg
	Wait 20, VAR_SPECIAL_RESULT
	Return
	
PewterCity_EventScript_AideApproachPlayer1:
	CloseMsg
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	Return
	
PewterCity_EventScript_AideApproachPlayer2:
	CloseMsg
	ApplyMovement 7, PewterCity_Movement_AideApproachPlayerMid
	WaitMovement
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	Return
	
PewterCity_EventScript_AideApproachPlayer3:
	CloseMsg
	ApplyMovement 7, PewterCity_Movement_AideApproachPlayerBottom
	WaitMovement
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	Return
	
EventScript_RestorePrevTextColor:
	CopyVar 0x5015, 0x5016
	Return
	
PewterCity_EventScript_AideExit0:
	ApplyMovement 7, PewterCity_Movement_AideExit0
	WaitMovement
	Return
	
PewterCity_EventScript_AideExit1:
	ApplyMovement 7, PewterCity_Movement_AideExit1
	WaitMovement
	Return
	
PewterCity_EventScript_AideExit2:
	ApplyMovement 7, PewterCity_Movement_AideExit2
	WaitMovement
	Return
	
PewterCity_EventScript_AideExit3:
	ApplyMovement 7, PewterCity_Movement_AideExit3
	WaitMovement
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
	NPCMsg msg_0460_T03_TypeTutor_Text_WhichMove
	// TODO(gba) special TypeTutor_PushMoves
	GoTo _cv_stop
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_7
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_7:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq TypeTutor_EventScript_Bye
	CopyVar 0x8004, 0x8008
	// TODO(gba) special TypeTutor_SelectMove
	GoTo _cv_stop
	NPCMsg msg_0460_T03_TypeTutor_Text_WhichMon
	WaitButton
	Call EventScript_ChooseMoveTutorMon
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TypeTutor_EventScript_Teach
	NPCMsg msg_0460_T03_TypeTutor_Text_Taught
	WaitButton
	GoTo TypeTutor_EventScript_Teach
	
PewterCity_EventScript_WalkToGymRight:
	ApplyMovement 5, PewterCity_Movement_GuideApproachPlayerRight
	WaitMovement
	ApplyMovement obj_player, PewterCity_Movement_PlayerWalkToGymRight
	ApplyMovement 5, PewterCity_Movement_GuideWalkToGymRight
	WaitMovement
	Return
	
PewterCity_EventScript_WalkToGymTop:
	ApplyMovement 5, PewterCity_Movement_GuideMoveToLeadTop
	WaitMovement
	ApplyMovement obj_player, PewterCity_Movement_PlayerWalkToGymTop
	ApplyMovement 5, PewterCity_Movement_GuideWalkToGymTop
	WaitMovement
	Return
	
PewterCity_EventScript_WalkToGymMid:
	ApplyMovement 5, PewterCity_Movement_GuideMoveToLeadMid
	WaitMovement
	ApplyMovement obj_player, PewterCity_Movement_PlayerWalkToGymMid
	ApplyMovement 5, PewterCity_Movement_GuideWalkToGymMid
	WaitMovement
	Return
	
PewterCity_EventScript_WalkToGymBottom:
	ApplyMovement 5, PewterCity_Movement_GuideMoveToLeadBottom
	WaitMovement
	ApplyMovement obj_player, PewterCity_Movement_PlayerWalkToGymBottom
	ApplyMovement 5, PewterCity_Movement_GuideWalkToGymBottom
	WaitMovement
	Return
	
TypeTutor_EventScript_Bye:
	NPCMsg msg_0460_T03_TypeTutor_Text_Bye
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
	NPCMsg msg_0460_T03_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
PewterCity_Movement_MuseumGuideExit:
	WalkNormalSouth 3
	EndMovement

	.balign 4, 0
PewterCity_Movement_GymGuideExit:
	WalkNormalSouth 4
	EndMovement

	.balign 4, 0
PewterCity_Movement_GuideWalkToMuseumNorth:
	WalkNormalWest 10
	WalkNormalNorth 16
	WalkNormalWest 8
	WalkNormalNorth 3
	WalkNormalWest 2
	WalkNormalSouth
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
PewterCity_Movement_PlayerWalkToMuseumNorth:
	WalkNormalNorth
	WalkNormalWest 10
	WalkNormalNorth 16
	WalkNormalWest 8
	WalkNormalNorth 3
	WalkNormalWest 2
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
PewterCity_Movement_GuideWalkToMuseumSouth:
	WalkNormalWest 10
	WalkNormalNorth 16
	WalkNormalWest 8
	WalkNormalNorth 3
	WalkNormalWest 2
	WalkNormalSouth
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
PewterCity_Movement_PlayerWalkToMuseumSouth:
	WalkNormalSouth
	WalkNormalWest 10
	WalkNormalNorth 16
	WalkNormalWest 8
	WalkNormalNorth 3
	WalkNormalWest 2
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
PewterCity_Movement_GuideWalkToMuseumWest:
	WalkNormalWest 10
	WalkNormalNorth 16
	WalkNormalWest 8
	WalkNormalNorth 3
	WalkNormalWest 2
	WalkNormalSouth
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
PewterCity_Movement_PlayerWalkToMuseumWest:
	WalkNormalWest 11
	WalkNormalNorth 16
	WalkNormalWest 8
	WalkNormalNorth 3
	WalkNormalWest 2
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
PewterCity_Movement_GuideWalkToMuseumEast:
	WalkNormalSouth
	WalkNormalWest 2
	WalkNormalNorth
	WalkNormalWest 8
	WalkNormalNorth 16
	WalkNormalWest 8
	WalkNormalNorth 3
	WalkNormalWest 2
	WalkNormalSouth
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
PewterCity_Movement_PlayerWalkToMuseumEast:
	WalkNormalEast
	WalkNormalSouth
	WalkNormalWest 2
	WalkNormalNorth
	WalkNormalWest 8
	WalkNormalNorth 16
	WalkNormalWest 8
	WalkNormalNorth 3
	WalkNormalWest 2
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
PewterCity_Movement_PlayerWaitForGuideEast:
	EndMovement

	.balign 4, 0
PewterCity_Movement_GuideMoveToLeadEast:
	EndMovement

	.balign 4, 0
PewterCity_Movement_PlayerWalkToGymEast:
	WalkNormalEast
	WalkNormalNorth 13
	WalkNormalWest 17
	WalkNormalNorth 3
	WalkNormalWest 18
	WalkNormalSouth 11
	WalkNormalEast 6
	WalkNormalNorth 3
	WalkNormalEast
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
PewterCity_Movement_GuideWalkToGymEast:
	WalkNormalNorth 13
	WalkNormalWest 17
	WalkNormalNorth 3
	WalkNormalWest 18
	WalkNormalSouth 11
	WalkNormalEast 6
	WalkNormalNorth 3
	WalkNormalEast
	WalkNormalSouth
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
Common_Movement_ExclamationMark:
	EmoteExclamationMark
	EndMovement

	.balign 4, 0
Common_Movement_Delay48:
	Delay16 3
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterDown:
	WalkOnSpotFasterSouth
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterUp:
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
PewterCity_Movement_AideApproachPlayerMid:
	Delay4
	WalkNormalSouth
	EndMovement

	.balign 4, 0
PewterCity_Movement_AideApproachPlayerBottom:
	Delay4
	WalkNormalSouth 2
	EndMovement

	.balign 4, 0
PewterCity_Movement_AideExit0:
	WalkNormalEast 7
	EndMovement

	.balign 4, 0
PewterCity_Movement_AideExit1:
	WalkNormalEast 7
	EndMovement

	.balign 4, 0
PewterCity_Movement_AideExit2:
	WalkNormalEast 7
	EndMovement

	.balign 4, 0
PewterCity_Movement_AideExit3:
	WalkNormalEast 7
	EndMovement

	.balign 4, 0
PewterCity_Movement_GuideApproachPlayerRight:
	WalkNormalSouth 4
	WalkOnSpotFasterEast
	EndMovement

	.balign 4, 0
PewterCity_Movement_PlayerWalkToGymRight:
	WalkNormalWest
	WalkNormalNorth 17
	WalkNormalWest 17
	WalkNormalNorth 3
	WalkNormalWest 18
	WalkNormalSouth 11
	WalkNormalEast 6
	WalkNormalNorth 3
	WalkNormalEast
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
PewterCity_Movement_GuideWalkToGymRight:
	WalkNormalNorth 17
	WalkNormalWest 17
	WalkNormalNorth 3
	WalkNormalWest 18
	WalkNormalSouth 11
	WalkNormalEast 6
	WalkNormalNorth 3
	WalkNormalEast
	WalkNormalSouth
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
PewterCity_Movement_GuideMoveToLeadTop:
	WalkNormalSouth
	WalkOnSpotFasterEast
	EndMovement

	.balign 4, 0
PewterCity_Movement_PlayerWalkToGymTop:
	WalkNormalWest
	WalkNormalNorth 14
	WalkNormalWest 17
	WalkNormalNorth 3
	WalkNormalWest 18
	WalkNormalSouth 11
	WalkNormalEast 6
	WalkNormalNorth 3
	WalkNormalEast
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
PewterCity_Movement_GuideWalkToGymTop:
	WalkNormalNorth 14
	WalkNormalWest 17
	WalkNormalNorth 3
	WalkNormalWest 18
	WalkNormalSouth 11
	WalkNormalEast 6
	WalkNormalNorth 3
	WalkNormalEast
	WalkNormalSouth
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
PewterCity_Movement_GuideMoveToLeadMid:
	WalkNormalSouth 2
	WalkOnSpotFasterEast
	EndMovement

	.balign 4, 0
PewterCity_Movement_PlayerWalkToGymMid:
	WalkNormalWest
	WalkNormalNorth 15
	WalkNormalWest 17
	WalkNormalNorth 3
	WalkNormalWest 18
	WalkNormalSouth 11
	WalkNormalEast 6
	WalkNormalNorth 3
	WalkNormalEast
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
PewterCity_Movement_GuideWalkToGymMid:
	WalkNormalNorth 15
	WalkNormalWest 17
	WalkNormalNorth 3
	WalkNormalWest 18
	WalkNormalSouth 11
	WalkNormalEast 6
	WalkNormalNorth 3
	WalkNormalEast
	WalkNormalSouth
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
PewterCity_Movement_GuideMoveToLeadBottom:
	WalkNormalSouth 3
	WalkOnSpotFasterEast
	EndMovement

	.balign 4, 0
PewterCity_Movement_PlayerWalkToGymBottom:
	WalkNormalWest
	WalkNormalNorth 16
	WalkNormalWest 17
	WalkNormalNorth 3
	WalkNormalWest 18
	WalkNormalSouth 11
	WalkNormalEast 6
	WalkNormalNorth 3
	WalkNormalEast
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
PewterCity_Movement_GuideWalkToGymBottom:
	WalkNormalNorth 16
	WalkNormalWest 17
	WalkNormalNorth 3
	WalkNormalWest 18
	WalkNormalSouth 11
	WalkNormalEast 6
	WalkNormalNorth 3
	WalkNormalEast
	WalkNormalSouth
	WalkOnSpotFasterNorth
	EndMovement
	.balign 4, 0
