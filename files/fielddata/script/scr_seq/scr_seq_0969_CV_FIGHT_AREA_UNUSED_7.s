#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_FIGHT_AREA_UNUSED_7.h"
#include "msgdata/msg/msg_0856_CV_FIGHT_AREA_UNUSED_7.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PalletTown_Gym_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef PalletTown_Gym_EventScript_Oak
	ScrDef GymChallenge_EventScript_Aide
	ScrDef GymPractice_EventScript_Trainer0
	ScrDef GymPractice_EventScript_Trainer1
	ScrDef GymPractice_EventScript_Trainer2
	ScrDef GymPractice_EventScript_Trainer3
	ScrDef GymPractice_EventScript_Trainer4
	ScrDef GymPractice_EventScript_Trainer5
	ScrDef GymPractice_EventScript_Trainer6
	ScrDef GymPractice_EventScript_Trainer7
	ScrDef GymPractice_EventScript_Trainer8
	ScrDef GymPractice_EventScript_Trainer9
	ScrDef GymPractice_EventScript_Trainer10
	ScrDef GymLegend_EventScript_Legend
	ScrDef Gauntlet_EventScript_Figure
	ScrDef PalletTown_Gym_EventScript_GymStatue
	ScrDef GymDecor_EventScript_GymPC
	ScrDef PalletTown_Gym_OnLoad
	ScrDef PalletTown_Gym_OnTransition
	ScrDef GymFinale_EventScript_FirstDay
	ScrDef PalletTown_Gym_EventScript_OakShowsGym
	ScrDef _cv_unported_21
	ScrDef _cv_unported_22
	ScrDef _cv_unported_23
	ScrDef _cv_unported_24
	ScrDef _cv_unported_25
	ScrDef Gauntlet_EventScript_Arrives
	ScrDefEnd
	
PalletTown_Gym_EventScript_Oak:
	LockAll
	FacePlayer
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_OakYouCameBack
	WaitButton
	GoTo GymFinale_EventScript_OakAsksToBattle
	CloseMsg
	End
	
GymChallenge_EventScript_Aide:
	LockAll
	FacePlayer
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar GymChallenge_IsOpen
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymChallenge_EventScript_AideNotYet
	// TODO(gba) special GymChallenge_BufferRecord
	GoTo _cv_stop
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_AideWelcome
	WaitButton
	// TODO(gba) special GymSwitch_BufferGoal
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq GymSwitch_EventScript_AideGoal
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_ReadyToBattle
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymChallenge_EventScript_NotNow
	// TODO(gba) special GymHack_CheckTeamSpecial
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe GymChallenge_EventScript_TeamBreaksRules
	HealParty
	// TODO(gba) special GymChallenge_PlanPlayerWalk
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymChallenge_EventScript_CantReachSpot
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	CallIfEq GymChallenge_EventScript_NoStage
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	CallIfEq GymChallenge_EventScript_StageBlocked
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_TakeYourPlace
	WaitButton
	CloseMsg
	ApplyMovement obj_player, gGymChallengePlayerPath
	WaitMovement
	GoTo GymChallenge_EventScript_NextChallenger
	End
	
GymPractice_EventScript_Trainer0:
	SetVar 0x8004, 0
	GoTo GymPractice_EventScript_Trainer
	End
	
GymPractice_EventScript_Trainer1:
	SetVar 0x8004, 1
	GoTo GymPractice_EventScript_Trainer
	End
	
GymPractice_EventScript_Trainer2:
	SetVar 0x8004, 2
	GoTo GymPractice_EventScript_Trainer
	End
	
GymPractice_EventScript_Trainer3:
	SetVar 0x8004, 3
	GoTo GymPractice_EventScript_Trainer
	End
	
GymPractice_EventScript_Trainer4:
	SetVar 0x8004, 4
	GoTo GymPractice_EventScript_Trainer
	End
	
GymPractice_EventScript_Trainer5:
	SetVar 0x8004, 5
	GoTo GymPractice_EventScript_Trainer
	End
	
GymPractice_EventScript_Trainer6:
	SetVar 0x8004, 6
	GoTo GymPractice_EventScript_Trainer
	End
	
GymPractice_EventScript_Trainer7:
	SetVar 0x8004, 7
	GoTo GymPractice_EventScript_Trainer
	End
	
GymPractice_EventScript_Trainer8:
	SetVar 0x8004, 8
	GoTo GymPractice_EventScript_Trainer
	End
	
GymPractice_EventScript_Trainer9:
	SetVar 0x8004, 9
	GoTo GymPractice_EventScript_Trainer
	End
	
GymPractice_EventScript_Trainer10:
	SetVar 0x8004, 10
	GoTo GymPractice_EventScript_Trainer
	End
	
GymLegend_EventScript_Legend:
	LockAll
	FacePlayer
	// TODO(gba) special GymLegend_Setup
	GoTo _cv_stop
	CopyVar 0x8008, 0x8004
	PlayCry 0x8008, 0
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymLegend_Text_Challenge
	WaitButton
	WaitCry
	CloseMsg
	SetVar 0x5014, 1
	// TODO(gba) special GymLegend_CreateMon
	GoTo _cv_stop
	SetFlag 0x2032
	// TODO(gba) special BattleSetup_StartLegendaryBattle
	GoTo _cv_stop
	ClearFlag 0x2032
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq _cv_won_3
	SetVar VAR_SPECIAL_RESULT, 2
_cv_won_3:
	HidePerson 16
	SetFlag 0x203A
	CompareVarToValue VAR_SPECIAL_RESULT, 7
	GoToIfEq GymLegend_EventScript_Caught
	// TODO(gba) special GymLegend_Setup
	GoTo _cv_stop
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymLegend_Text_Fled
	WaitButton
	CloseMsg
	GoTo GymLegend_EventScript_RivalEscaped
	End
	
Gauntlet_EventScript_Figure:
	LockAll
	CompareVarToValue 0x501B, 4
	GoToIfEq Gauntlet_EventScript_PalmPilot
	FacePlayer
	CompareVarToValue 0x501B, 3
	GoToIfEq Gauntlet_EventScript_AllBeaten
	GoTo Tourney_EventScript_Menu
	
PalletTown_Gym_EventScript_GymStatue:
	GoTo GymChallenge_EventScript_Statue
	End
	
GymDecor_EventScript_GymPC:
	LockAll
	PlaySE SEQ_SE_DP_SELECT
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_BootedUpGymPC
	WaitButton
	End
	
PalletTown_Gym_OnLoad:
	End
	
PalletTown_Gym_OnTransition:
	SetFlag 0x2046
	SetFlag 0x2047
	SetFlag 0x2048
	SetFlag 0x2049
	SetFlag 0x204A
	SetFlag 0x204B
	SetFlag 0x204C
	SetFlag 0x204D
	SetFlag 0x204E
	SetFlag 0x204F
	SetFlag 0x2050
	SetFlag 0x2035
	SetFlag 0x2017
	SetFlag 0x2033
	SetFlag 0x2034
	CompareVarToValue 0x5005, 1
	CallIfEq PalletTown_Gym_EventScript_FirstVisitPeople
	CompareVarToValue 0x5005, 1
	CallIfNe PalletTown_Gym_EventScript_ShowAide
	CompareVarToValue 0x5005, 3
	CallIfEq PalletTown_Gym_EventScript_ShowOak
	CompareVarToValue 0x5005, 4
	CallIfEq PalletTown_Gym_EventScript_ShowOak
	CompareVarToValue 0x5004, 2
	CallIfEq PalletTown_Gym_EventScript_ShowOak
	End
	
GymFinale_EventScript_FirstDay:
	LockAll
	SetVar 0x5005, 2
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	PlayBGM SEQ_GS_T_MASARA
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_OakFirstDay
	WaitButton
	Call EventScript_TryReadyNationalDexScene
	End
	
PalletTown_Gym_EventScript_OakShowsGym:
	LockAll
	PlayBGM SEQ_GS_OHKIDO
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_PalletTown_Gym_Text_OakHereWeAre
	WaitButton
	ApplyMovement 2, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	BufferRivalsName 7
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_PalletTown_Gym_Text_RivalAsGoodAsMine
	WaitButton
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_PalletTown_Gym_Text_OakDecorateIt
	WaitButton
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_PalletTown_Gym_Text_OakTakeBalloon
	WaitButton
	Call EventScript_GiveHotAirBalloon
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_PalletTown_Gym_Text_OakBalloonHowTo
	WaitButton
	ApplyMovement 2, Common_Movement_WalkInPlaceFasterLeft
	WaitMovement
	BufferPlayersName 6
	BufferRivalsName 7
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_PalletTown_Gym_Text_RivalTossYourJunk
	WaitButton
	ApplyMovement 2, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_PalletTown_Gym_Text_OakRunItMyself
	WaitButton
	ApplyMovement 2, Common_Movement_ExclamationMark
	WaitMovement
	BufferPlayersName 6
	BufferRivalsName 7
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_PalletTown_Gym_Text_RivalSeeYouAtTheTop
	WaitButton
	CloseMsg
	PlayBGM SEQ_GS_E_RIVAL2
	ApplyMovement obj_player, PalletTown_Gym_Movement_WatchRivalLeave
	ApplyMovement 2, PalletTown_Gym_Movement_RivalLeave
	WaitMovement
	HidePerson 2
	SetFlag 0x2033
	PlaySE SEQ_SE_DP_KAIDAN2
	Wait 30, VAR_SPECIAL_RESULT
	PlayBGM SEQ_GS_OHKIDO
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_PalletTown_Gym_Text_OakWaitingForYou
	WaitButton
	CloseMsg
	ApplyMovement 1, PalletTown_Gym_Movement_OakLeave
	WaitMovement
	HidePerson 1
	SetFlag 0x2034
	PlaySE SEQ_SE_DP_KAIDAN2
	SetFlag 0x2034
	SetFlag 0x2033
	SetFlag 0x2000
	SetVar 0x5005, 2
	ResetBGM
	ReleaseAll
	End
	
PalletTown_Gym_EventScript_OakWantsTheGym:
	LockAll
	SetVar 0x5005, 2
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	CompareVarToValue 0x5004, 5
	GoToIfEq GymFinale_EventScript_OakSkippedTheCeremony
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_OakHereWeAre
	WaitButton
	ApplyMovement 1, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_OakThinking
	WaitButton
	ApplyMovement 1, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	PlaySE SEQ_SE_DP_SELECT
	ApplyMovement 1, Common_Movement_ExclamationMark
	WaitMovement
	PlayBGM SEQ_GS_E_RIVAL1
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_OakWontGiveItUp
	WaitButton
	GoTo GymFinale_EventScript_OakAsksToBattle
	CloseMsg
	End
	
GymLegend_EventScript_RivalEscaped:
	LockAll
	Call GymLegend_EventScript_RivalWalksIn
	BufferPlayersName 6
	BufferRivalsName 7
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymLegend_Text_RivalEscaped
	WaitButton
	Call GymLegend_EventScript_RivalWalksOut
	SetVar 0x5014, 2
	CloseMsg
	ReleaseAll
	End
	
GymLegend_EventScript_RivalCaught:
	LockAll
	Call GymLegend_EventScript_RivalWalksIn
	BufferRivalsName 7
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymLegend_Text_RivalCaught
	WaitButton
	Call GymLegend_EventScript_RivalWalksOut
	SetVar 0x5014, 4
	CloseMsg
	ReleaseAll
	End
	
GymLegend_EventScript_ArrivesLater:
	LockAll
	Call GymLegend_EventScript_Appears
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymLegend_EventScript_ArrivesLaterEnd
	PlaySE SEQ_SE_DP_SELECT
	ApplyMovement obj_player, Common_Movement_ExclamationMark
	ApplyMovement 3, Common_Movement_ExclamationMark
	WaitMovement
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymLegend_Text_AideWhatOnEarth
	WaitButton
	CloseMsg
	ResetBGM
	End
	
Johto_EventScript_Invitation:
	LockAll
	// TODO(gba) special GymCandidate_PrepareMentorVisit
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Johto_EventScript_InvitationByMail
	Wait 20, VAR_SPECIAL_RESULT
	PlaySE SEQ_SE_DP_DOOR
	SetVar 0x800A, 4
	Call GymCandidate_EventScript_VisitorWalksIn
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_5
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_4
_cv_next_5:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_6
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_4
_cv_next_6:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_7
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Misty
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_4
_cv_next_7:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_8
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_4
_cv_next_8:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_9
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_4
_cv_next_9:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_10
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Erika
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_4
_cv_next_10:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_11
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_4
_cv_next_11:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_12
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_4
_cv_next_12:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_13
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_4
_cv_next_13:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_14
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_4
_cv_next_14:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_15
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Blaine
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_4
_cv_next_15:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_16
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_4
_cv_next_16:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_17
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_4
_cv_next_17:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_18
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lorelei
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_4
_cv_next_18:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_19
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_4
_cv_next_19:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_20
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_4
_cv_next_20:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_21
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_4
_cv_next_21:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_22
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_4
_cv_next_22:
_cv_done_4:
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Johto_Text_MentorInvite
	WaitButton
	Call Johto_EventScript_ReceiveInvitation
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_24
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_23
_cv_next_24:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_25
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_23
_cv_next_25:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_26
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Misty
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_23
_cv_next_26:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_27
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_23
_cv_next_27:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_28
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_23
_cv_next_28:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_29
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Erika
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_23
_cv_next_29:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_30
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_23
_cv_next_30:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_31
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_23
_cv_next_31:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_32
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_23
_cv_next_32:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_33
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_23
_cv_next_33:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_34
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Blaine
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_23
_cv_next_34:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_35
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_23
_cv_next_35:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_36
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_23
_cv_next_36:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_37
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lorelei
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_23
_cv_next_37:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_38
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_23
_cv_next_38:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_39
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_23
_cv_next_39:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_40
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_23
_cv_next_40:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_41
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_23
_cv_next_41:
_cv_done_23:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Johto_Text_MentorInviteFerry
	WaitButton
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_43
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_42
_cv_next_43:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_44
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_42
_cv_next_44:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_45
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Misty
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_42
_cv_next_45:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_46
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_42
_cv_next_46:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_47
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_42
_cv_next_47:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_48
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Erika
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_42
_cv_next_48:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_49
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_42
_cv_next_49:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_50
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_42
_cv_next_50:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_51
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_42
_cv_next_51:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_52
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_42
_cv_next_52:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_53
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Blaine
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_42
_cv_next_53:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_54
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_42
_cv_next_54:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_55
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_42
_cv_next_55:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_56
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lorelei
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_42
_cv_next_56:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_57
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_42
_cv_next_57:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_58
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_42
_cv_next_58:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_59
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_42
_cv_next_59:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_60
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_42
_cv_next_60:
_cv_done_42:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Johto_Text_MentorGymCharm
	WaitButton
	Call Johto_EventScript_ReceiveGymCharm
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_62
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_61
_cv_next_62:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_63
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_61
_cv_next_63:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_64
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Misty
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_61
_cv_next_64:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_65
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_61
_cv_next_65:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_66
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_61
_cv_next_66:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_67
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Erika
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_61
_cv_next_67:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_68
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_61
_cv_next_68:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_69
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_61
_cv_next_69:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_70
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_61
_cv_next_70:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_71
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_61
_cv_next_71:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_72
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Blaine
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_61
_cv_next_72:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_73
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_61
_cv_next_73:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_74
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_61
_cv_next_74:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_75
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lorelei
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_61
_cv_next_75:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_76
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_61
_cv_next_76:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_77
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_61
_cv_next_77:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_78
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_61
_cv_next_78:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_79
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_61
_cv_next_79:
_cv_done_61:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Johto_Text_MentorGymCharmHow
	WaitButton
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_81
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_80
_cv_next_81:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_82
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_80
_cv_next_82:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_83
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Misty
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_80
_cv_next_83:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_84
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_80
_cv_next_84:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_85
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_80
_cv_next_85:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_86
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Erika
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_80
_cv_next_86:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_87
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_80
_cv_next_87:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_88
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_80
_cv_next_88:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_89
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_80
_cv_next_89:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_90
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_80
_cv_next_90:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_91
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Blaine
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_80
_cv_next_91:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_92
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_80
_cv_next_92:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_93
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_80
_cv_next_93:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_94
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lorelei
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_80
_cv_next_94:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_95
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_80
_cv_next_95:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_96
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_80
_cv_next_96:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_97
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_80
_cv_next_97:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_98
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_80
_cv_next_98:
_cv_done_80:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Johto_Text_MentorLeaderPerks
	WaitButton
	Call GymCandidate_EventScript_VisitorWalksOut
	SetVar 0x5009, 2
	CloseMsg
	ReleaseAll
	End
	
Gauntlet_EventScript_Arrives:
	LockAll
	SetVar 0x501B, 2
	ClearFlag 0x2035
	GoToIfUnset 0x2035, _cv_show_99
	ClearFlag 0x2035
	ShowPerson 17
	SetFlag 0x2035
	GoTo _cv_shown_100
_cv_show_99:
	ShowPerson 17
_cv_shown_100:
	PlaySE SEQ_SE_DP_SELECT
	ApplyMovement 17, Common_Movement_ExclamationMark
	WaitMovement
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Arrival1
	WaitButton
	PlayBGM SEQ_GS_EYE_ROCKET
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Arrival2
	WaitButton
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Arrival3
	WaitButton
	ResetBGM
	CloseMsg
	ReleaseAll
	End
	
GymFinale_EventScript_OakAsksToBattle:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_OakWillYouBattle
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_101
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_102
_cv_yes_101:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_102:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymFinale_EventScript_PutOff
	// TODO(gba) special GymHack_CheckTeamSpecial
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe GymFinale_EventScript_TeamBreaksRules
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_OakThenShowMe
	WaitButton
	CloseMsg
	HealParty
	// TODO(gba) special GymChallenge_GenerateOakFinale
	GoTo _cv_stop
	ClearTrainerFlag 1442
	SetFlag 0x2036
	CheckTrainerFlag 1442
	GoToIf TRUE, _cv_beaten_103
	TrainerBattle 1442, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_104
	WhiteOut
	End
_cv_won_104:
	SetTrainerFlag 1442
	ReleaseAll
	End
_cv_beaten_103:
	ClearFlag 0x2036
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq _cv_won_105
	SetVar VAR_SPECIAL_RESULT, 2
_cv_won_105:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymFinale_EventScript_BeatOak
	GoTo GymFinale_EventScript_LostToOak
	End
	
GymChallenge_EventScript_AideNotYet:
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x2093, _cv_appr_106
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_106:
	GoToIfUnset 0x2094, _cv_appr_107
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_107:
	GoToIfUnset 0x2095, _cv_appr_108
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_108:
	GoToIfUnset 0x2096, _cv_appr_109
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_109:
	GoToIfUnset 0x2097, _cv_appr_110
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_110:
	GoToIfUnset 0x2098, _cv_appr_111
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_111:
	GoToIfUnset 0x2099, _cv_appr_112
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_112:
	GoToIfUnset 0x2007, _cv_appr_113
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_113:
	BufferInt 0, VAR_SPECIAL_RESULT
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_AideNotYet
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymSwitch_EventScript_AideGoal:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymSwitch_Text_AideGoal
	WaitButton
	Return
	
GymChallenge_EventScript_NotNow:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_NotNow
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymChallenge_EventScript_TeamBreaksRules:
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfEq GymChallenge_EventScript_ItemClause
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_TeamBreaksRules
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymChallenge_EventScript_CantReachSpot:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_CantReachSpot
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymChallenge_EventScript_NoStage:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_NoStage
	WaitButton
	Return
	
GymChallenge_EventScript_StageBlocked:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_StageBlocked
	WaitButton
	Return
	
GymChallenge_EventScript_NextChallenger:
	// TODO(gba) special GymChallenge_NextChallenger
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq GymChallenge_EventScript_AnnounceFamous
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	CallIfEq GymChallenge_EventScript_AnnounceTownsfolk
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	CallIfEq GymChallenge_EventScript_AnnounceTrainer
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	CallIfEq GymSwitch_EventScript_AnnounceMentor
	CloseMsg
	ClearFlag 0x2017
	GoToIfUnset 0x2017, _cv_show_114
	ClearFlag 0x2017
	ShowPerson 4
	SetFlag 0x2017
	GoTo _cv_shown_115
_cv_show_114:
	ShowPerson 4
_cv_shown_115:
	SetVar 0x8004, 0
	// TODO(gba) special GymChallenge_PlanChallengerWalk
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	CallIfEq GymChallenge_EventScript_ChallengerJumpsIn
	ApplyMovement 4, gGymChallengeChallengerPath
	WaitMovement
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_gGymChallengeIntroText
	WaitButton
	CloseMsg
	ClearTrainerFlag 1442
	SetFlag 0x2036
	CheckTrainerFlag 1442
	GoToIf TRUE, _cv_beaten_116
	TrainerBattle 1442, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_117
	WhiteOut
	End
_cv_won_117:
	SetTrainerFlag 1442
	ReleaseAll
	End
_cv_beaten_116:
	ClearFlag 0x2036
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq _cv_won_118
	SetVar VAR_SPECIAL_RESULT, 2
_cv_won_118:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymChallenge_EventScript_Won
	GoTo GymChallenge_EventScript_Lost
	End
	
GymPractice_EventScript_Trainer:
	LockAll
	FacePlayer
	// TODO(gba) special GymChallenge_BufferPracticeTrainer
	GoTo _cv_stop
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymPractice_Text_Offer
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_119
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_120
_cv_yes_119:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_120:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymPractice_EventScript_NotNow
	// TODO(gba) special GymChallenge_GeneratePractice
	GoTo _cv_stop
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymPractice_Text_Go
	WaitButton
	CloseMsg
	ClearTrainerFlag 1442
	SetFlag 0x2036
	CheckTrainerFlag 1442
	GoToIf TRUE, _cv_beaten_121
	TrainerBattle 1442, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_122
	WhiteOut
	End
_cv_won_122:
	SetTrainerFlag 1442
	ReleaseAll
	End
_cv_beaten_121:
	ClearFlag 0x2036
	// TODO(gba) special GymChallenge_EndPractice
	GoTo _cv_stop
	HealParty
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq _cv_won_123
	SetVar VAR_SPECIAL_RESULT, 2
_cv_won_123:
	// TODO(gba) special GymChallenge_BufferPracticeTrainer
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymPractice_EventScript_Won
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymPractice_Text_Lost
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymLegend_EventScript_Caught:
	SetFlag 0x2037
	SetVar 0x5014, 3
	GoTo GymLegend_EventScript_RivalCaught
	End
	
Gauntlet_EventScript_PalmPilot:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Pilot
	WaitButton
	CompareVarToValue 0x501C, 0
	GoToIfEq Gauntlet_EventScript_PilotMenu
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_WithdrawAsk
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_124
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_125
_cv_yes_124:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_125:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Gauntlet_EventScript_Withdraw
	End
	
Gauntlet_EventScript_AllBeaten:
	GoToIfSet 0x2038, Gauntlet_EventScript_BillAgain
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_ReadyToMeet
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_126
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_127
_cv_yes_126:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_127:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Gauntlet_EventScript_NotYet
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Reveal1
	WaitButton
	CloseMsg
	Wait 30, VAR_SPECIAL_RESULT
	FadeScreen 6, 1, 0, RGB_WHITE
	WaitFade
	// TODO(gba) special Gauntlet_RevealBill
	GoTo _cv_stop
	HidePerson 17
	SetFlag 0x2035
	GoToIfUnset 0x2035, _cv_show_128
	ClearFlag 0x2035
	ShowPerson 17
	SetFlag 0x2035
	GoTo _cv_shown_129
_cv_show_128:
	ShowPerson 17
_cv_shown_129:
	PlaySE SEQ_SE_DP_SELECT
	FadeScreen 6, 1, 1, RGB_WHITE
	WaitFade
	WaitSE SEQ_SE_DP_SELECT
	PlayBGM SEQ_GS_D_AJITO
	FacePlayer
	WaitMovement
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Reveal2
	WaitButton
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Reveal3
	WaitButton
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Reveal4
	WaitButton
	GoTo Gauntlet_EventScript_BillBattle
	
Tourney_EventScript_Menu:
	// TODO(gba) special Tourney_GetStatus
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Tourney_EventScript_MenuActive
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfEq Tourney_EventScript_MenuSimBill
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Tourney_EventScript_MenuFirst
	Call Tourney_EventScript_SayAsk
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptEnter, 0
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptLast, 1
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptNotNow, 2
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_131
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_131:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Tourney_EventScript_Enter
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Tourney_EventScript_LastResults
	GoTo Tourney_EventScript_NotNow
	
GymChallenge_EventScript_Statue:
	LockAll
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar GymChallenge_IsOpen
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymChallenge_EventScript_StatueNoLeader
	// TODO(gba) special GymChallenge_BufferRecord
	GoTo _cv_stop
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_StatueLeader
	WaitButton
	// TODO(gba) special GymChallenge_BufferVictorList
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymChallenge_EventScript_StatueUnbeaten
	// TODO(gba) special GymBadge_BufferName
	GoTo _cv_stop
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_StatueVictors
	WaitButton
	// TODO(gba) special GymChallenge_BufferVictorList
	GoTo _cv_stop
	Call _cv_str4
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_Gym_EventScript_FirstVisitPeople:
	SetFlag 0x2039
	ClearFlag 0x2033
	ClearFlag 0x2034
	Return
	
PalletTown_Gym_EventScript_ShowAide:
	ClearFlag 0x2039
	Return
	
PalletTown_Gym_EventScript_ShowOak:
	ClearFlag 0x2034
	Return
	
EventScript_TryReadyNationalDexScene:
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x2026, _cv_dex_132
	SetVar VAR_SPECIAL_RESULT, 1
_cv_dex_132:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	CallIfEq EventScript_SetReadyTryGiveNationalDexScene
	Return
	
EventScript_GiveHotAirBalloon:
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x202C, _cv_has_133
	SetVar VAR_SPECIAL_RESULT, 1
_cv_has_133:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq EventScript_PalmPilotReturn
	SetFlag 0x202C
	SetVar VAR_SPECIAL_RESULT, 1
	Return
	
GymFinale_EventScript_OakSkippedTheCeremony:
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_OakHeardTheCheering
	WaitButton
	ApplyMovement 1, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_OakThinking
	WaitButton
	ApplyMovement 1, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	PlaySE SEQ_SE_DP_SELECT
	ApplyMovement 1, Common_Movement_ExclamationMark
	WaitMovement
	PlayBGM SEQ_GS_E_RIVAL1
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_OakWontGiveItUpSpeeches
	WaitButton
	GoTo GymFinale_EventScript_OakAsksToBattle
	CloseMsg
	End
	
GymLegend_EventScript_RivalWalksIn:
	PlayBGM SEQ_GS_E_RIVAL1
	SetVar 0x800A, 2
	// TODO(gba) special GymCandidate_PlanVisitorWalk
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymLegend_EventScript_RivalAppears
	CopyVar 0x401E, 0x8005
	CopyVar 0x401F, 0x8006
	MovePerson 2, 0x401E, 0x401F
	ClearFlag 0x2033
	GoToIfUnset 0x2033, _cv_show_134
	ClearFlag 0x2033
	ShowPerson 2
	SetFlag 0x2033
	GoTo _cv_shown_135
_cv_show_134:
	ShowPerson 2
_cv_shown_135:
	ApplyMovement 2, gMentorWalkIn
	WaitMovement
	// TODO(gba) special GymCandidate_FaceGuest
	GoTo _cv_stop
	Return
	
GymLegend_EventScript_RivalWalksOut:
	CloseMsg
	PlayBGM SEQ_GS_E_RIVAL2
	// TODO(gba) special GymCandidate_VisitorWalked
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymLegend_EventScript_RivalVanishes
	ApplyMovement 2, gMentorWalkOut
	WaitMovement
	End
	
GymLegend_EventScript_Appears:
	// TODO(gba) special GymLegend_Setup
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymLegend_EventScript_NoLegend
	CopyVar 0x8008, 0x8004
	// TODO(gba) special GymLegend_FindSpot
	GoTo _cv_stop
	CopyVar 0x401E, 0x8005
	CopyVar 0x401F, 0x8006
	MovePerson 16, 0x401E, 0x401F
	// TODO(gba) special GymLegend_PlanCamera
	GoTo _cv_stop
	Wait 30, VAR_SPECIAL_RESULT
	SetVar 0x8004, 2
	SetVar 0x8005, 2
	SetVar 0x8006, 12
	SetVar 0x8007, 4
	// TODO(gba) special ShakeCamera
	GoTo _cv_stop
	PlaySE SEQ_SE_DP_SELECT
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymLegend_Text_LightsOut
	WaitButton
	CloseMsg
	ClearFlag 0x203A
	GoToIfUnset 0x203A, _cv_show_136
	ClearFlag 0x203A
	ShowPerson 16
	SetFlag 0x203A
	GoTo _cv_shown_137
_cv_show_136:
	ShowPerson 16
_cv_shown_137:
	Wait 40, VAR_SPECIAL_RESULT
	PlaySE SEQ_SE_DP_SELECT
	FadeScreen 6, 1, 1, RGB_WHITE
	WaitFade
	PlayCry 0x8008, 0
	WaitCry
	ApplyMovement 127, gGymLegendCameraIn
	WaitMovement
	PlayBGM SEQ_GS_E_ARCEUS
	Wait 30, VAR_SPECIAL_RESULT
	PlayCry 0x8008, 0
	WaitCry
	Wait 30, VAR_SPECIAL_RESULT
	ApplyMovement 127, gGymLegendCameraOut
	WaitMovement
	SetFlag 0x203B
	SetVar 0x5014, 0
	// TODO(gba) special GymLegend_Setup
	GoTo _cv_stop
	SetVar VAR_SPECIAL_RESULT, 1
	Return
	
GymLegend_EventScript_ArrivesLaterEnd:
	ReleaseAll
	End
	
Johto_EventScript_InvitationByMail:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Johto_Text_InvitationByMail
	WaitButton
	Call Johto_EventScript_ReceiveInvitation
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Johto_Text_InvitationFerry
	WaitButton
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Johto_Text_GymCharmByMail
	WaitButton
	Call Johto_EventScript_ReceiveGymCharm
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Johto_Text_GymCharmHowByMail
	WaitButton
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Johto_Text_LeaderPerksByMail
	WaitButton
	SetVar 0x5009, 2
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_VisitorWalksIn:
	// TODO(gba) special GymCandidate_PlanVisitorWalk
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_MentorAppears
	CopyVar 0x401E, 0x8005
	CopyVar 0x401F, 0x8006
	MovePerson 0x800A, 0x401E, 0x401F
	ClearFlag 0x2017
	ShowPerson 0x800A
	ApplyMovement 0x800A, gMentorWalkIn
	WaitMovement
	// TODO(gba) special GymCandidate_FaceGuest
	GoTo _cv_stop
	Return
	
Johto_EventScript_ReceiveInvitation:
	PlayFanfare SEQ_ME_ITEM
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Johto_Text_ReceivedInvitation
	WaitFanfare
	Return
	
Johto_EventScript_ReceiveGymCharm:
	SetFlag 0x202E
	SetVar VAR_SPECIAL_RESULT, 1
	Return
	
GymCandidate_EventScript_VisitorWalksOut:
	// TODO(gba) special GymCandidate_VisitorWalked
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_GuestLeaves
	CloseMsg
	ApplyMovement 0x800A, gMentorWalkOut
	WaitMovement
	HidePerson 0x800A
	SetFlag 0x2017
	PlaySE SEQ_SE_DP_KAIDAN2
	// TODO(gba) special GymCandidate_FaceBack
	GoTo _cv_stop
	Return
	
GymFinale_EventScript_PutOff:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_OakComeBackWhenReady
	WaitButton
	SetVar 0x5004, 2
	ResetBGM
	CloseMsg
	ReleaseAll
	End
	
GymFinale_EventScript_TeamBreaksRules:
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	CallIfEq EventScript_GymHack_ShowTeamRuleMessage
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	CallIfNe GymFinale_EventScript_OakRulesMsg
	SetVar 0x5004, 2
	ResetBGM
	ReleaseAll
	End
	
GymFinale_EventScript_BeatOak:
	PlayBGM SEQ_GS_T_MASARA
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_OakGivesUp
	WaitButton
	GoToIfUnset FLAG_GAME_CLEAR, GymFinale_EventScript_HallOfFame
	SetFlag 0x2008
	SetVar 0x5004, 3
	Call GymFinale_EventScript_Badge
	Call EventScript_TryReadyNationalDexScene
	GoTo GymFinale_EventScript_AideAndLegend
	
GymFinale_EventScript_LostToOak:
	HealParty
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_OakStillHasIt
	WaitButton
	CloseMsg
	SetVar 0x5004, 2
	SetFlag 0x2034
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	Warp MAP_PALLET_TOWN_REDS_HOUSE_1F, 0, 9, 6, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	ReleaseAll
	End
	
GymChallenge_EventScript_ItemClause:
	Call EventScript_GymHack_ShowTeamRuleMessage
	ReleaseAll
	End
	
GymChallenge_EventScript_AnnounceFamous:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_AnnounceFamous
	WaitButton
	Return
	
GymChallenge_EventScript_AnnounceTownsfolk:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_AnnounceTownsfolk
	WaitButton
	Return
	
GymChallenge_EventScript_AnnounceTrainer:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_AnnounceTrainer
	WaitButton
	Return
	
GymSwitch_EventScript_AnnounceMentor:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymSwitch_Text_AnnounceMentor
	WaitButton
	Return
	
GymChallenge_EventScript_ChallengerJumpsIn:
	// TODO(gba) setobjectxy LOCALID_PALLET_GYM_CHALLENGER, VAR_0x8005, VAR_0x8006
	GoTo _cv_stop
	Return
	
GymChallenge_EventScript_Won:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_gGymChallengeAfterText
	WaitButton
	Call GymChallenge_EventScript_ChallengerLeaves
	// TODO(gba) special GymChallenge_RecordWin
	GoTo _cv_stop
	CopyVar 0x8008, VAR_SPECIAL_RESULT
	PlaySE SEQ_SE_DP_SELECT
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_Won
	WaitButton
	CompareVarToValue 0x8008, 1
	CallIfEq GymChallenge_EventScript_NewRecord
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_LeftAGift
	WaitButton
	CompareVarToValue 0x8009, 0
	CallIfEq GymChallenge_EventScript_RareGift
	Call GymHack_EventScript_GiveStatItem
	// TODO(gba) special GymSwitch_AfterWin
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq GymSwitch_EventScript_Mastered
	HealParty
	GoToIfSet 0x201F, GymSwitch_EventScript_KeepGoingOrRetire
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_KeepGoing
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_138
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_139
_cv_yes_138:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_139:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymChallenge_EventScript_KeepGoing
	// TODO(gba) special GymChallenge_BufferRecord
	GoTo _cv_stop
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_TakeABreak
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymChallenge_EventScript_Lost:
	HealParty
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_gGymChallengeWinText
	WaitButton
	// TODO(gba) special GymChallenge_RecordLoss
	GoTo _cv_stop
	// TODO(gba) special GymBadge_BufferName
	GoTo _cv_stop
	// TODO(gba) special GymBadge_ShowIcon
	GoTo _cv_stop
	PlayFanfare SEQ_ME_BADGE
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_AwardBadge
	WaitButton
	WaitFanfare
	// TODO(gba) special GymBadge_HideIcon
	GoTo _cv_stop
	Call GymChallenge_EventScript_ChallengerLeaves
	// TODO(gba) special GymChallenge_BufferLastResult
	GoTo _cv_stop
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_Lost
	WaitButton
	GoToIfSet 0x201F, GymSwitch_EventScript_OakComes
	CloseMsg
	ReleaseAll
	End
	
GymPractice_EventScript_NotNow:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymPractice_Text_NotNow
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymPractice_EventScript_Won:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymPractice_Text_Won
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Gauntlet_EventScript_PilotMenu:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_PilotMenu
	CompareVarToValue 0x501C, 0
	GoToIfNe Gauntlet_EventScript_PilotMenuWithdraw
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptSim, 0
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptOff, 1
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_141
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_141:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Tourney_EventScript_Menu
	GoTo Gauntlet_EventScript_PilotOff
	
Gauntlet_EventScript_Withdraw:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_WithdrawWhich
	// TODO(gba) special Gauntlet_ChooseWithdraw
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, SPECIES_NONE
	GoToIfEq Gauntlet_EventScript_PilotMenu
	CopyVar 0x8005, VAR_SPECIAL_RESULT
	BufferSpeciesName 0, 0x8005, 0, 0
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_WithdrawConfirm
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_142
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_143
_cv_yes_142:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_143:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Gauntlet_EventScript_Withdraw
	GiveMon 0x8005, 70, 0, 0, 0, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq Gauntlet_EventScript_NoRoom
	CopyVar 0x8006, VAR_SPECIAL_RESULT
	// TODO(gba) special Gauntlet_UseWithdraw
	GoTo _cv_stop
	PlayFanfare SEQ_ME_ITEM
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Withdrew
	WaitFanfare
	CompareVarToValue 0x8006, 1
	CallIfEq Gauntlet_EventScript_SentToPC
	GoTo Gauntlet_EventScript_PilotMenu
	
Gauntlet_EventScript_BillAgain:
	PlayBGM SEQ_GS_D_AJITO
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_BillAgain
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_144
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_145
_cv_yes_144:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_145:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Gauntlet_EventScript_BillWait
	End
	
Gauntlet_EventScript_NotYet:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_NotYet
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Gauntlet_EventScript_BillBattle:
	HealParty
	// TODO(gba) special Gauntlet_SetupBill
	GoTo _cv_stop
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_gGymChallengeIntroText
	WaitButton
	CloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special Gauntlet_ShowBillCard
	GoTo _cv_stop
	ClearTrainerFlag 1442
	SetFlag 0x2036
	CheckTrainerFlag 1442
	GoToIf TRUE, _cv_beaten_146
	TrainerBattle 1442, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_147
	WhiteOut
	End
_cv_won_147:
	SetTrainerFlag 1442
	ReleaseAll
	End
_cv_beaten_146:
	ClearFlag 0x2036
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq _cv_won_148
	SetVar VAR_SPECIAL_RESULT, 2
_cv_won_148:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Gauntlet_EventScript_BillWon
	HealParty
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_gGymChallengeWinText
	WaitButton
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_BillLost
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Tourney_EventScript_MenuActive:
	// TODO(gba) special Tourney_SetupNext
	GoTo _cv_stop
	Call Tourney_EventScript_SayNext
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptNext, 0
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptBoard, 1
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptForfeit, 2
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptNotNow, 3
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_150
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_150:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Tourney_EventScript_Match
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Tourney_EventScript_Board
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq Tourney_EventScript_Forfeit
	End
	
Tourney_EventScript_MenuSimBill:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimBillMenu
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptBill, 0
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptBoard, 1
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptNotNow, 2
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_152
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_152:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Tourney_EventScript_SimBill
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Tourney_EventScript_Board
	GoTo Tourney_EventScript_NotNow
	
Tourney_EventScript_MenuFirst:
	Call Tourney_EventScript_SayAsk
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptEnter, 0
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptNotNow, 1
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_154
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_154:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Tourney_EventScript_Enter
	GoTo Tourney_EventScript_NotNow
	
Tourney_EventScript_SayAsk:
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SayAskSim
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_FigureAsk
	Return
	
Tourney_EventScript_Enter:
	Call Tourney_EventScript_SayRules
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Tourney_EventScript_NotNow
	// TODO(gba) special Tourney_CheckClauses
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe Tourney_EventScript_BreaksClause
	CompareVarToValue 0x501B, 4
	CallIfEq Tourney_EventScript_SimFormat
	// TODO(gba) special Tourney_Begin
	GoTo _cv_stop
	Call Tourney_EventScript_SayDraw
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special Tourney_ShowBoard
	GoTo _cv_stop
	// TODO(gba) special Tourney_SetupNext
	GoTo _cv_stop
	Call Tourney_EventScript_SayFirst
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Tourney_EventScript_NotNow
	End
	
Tourney_EventScript_LastResults:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special Tourney_ShowBoard
	GoTo _cv_stop
	// TODO(gba) special Tourney_BufferChampion
	GoTo _cv_stop
	Call Tourney_EventScript_SayChampion
	GoTo Tourney_EventScript_Menu
	
Tourney_EventScript_NotNow:
	CompareVarToValue 0x501B, 4
	GoToIfEq Gauntlet_EventScript_PilotOff
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_NotNow
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymChallenge_EventScript_StatueNoLeader:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_StatueNoLeader
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymChallenge_EventScript_StatueUnbeaten:
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_StatueUnbeaten
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_SetReadyTryGiveNationalDexScene:
	SetVar 0x5007, 2
	Return
	
EventScript_PalmPilotReturn:
	Return
	
GymLegend_EventScript_RivalAppears:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special GymCandidate_PlaceGuest
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymLegend_EventScript_RivalNoRoom
	CopyVar 0x401E, 0x8005
	CopyVar 0x401F, 0x8006
	MovePerson 2, 0x401E, 0x401F
	ClearFlag 0x2033
	GoToIfUnset 0x2033, _cv_show_155
	ClearFlag 0x2033
	ShowPerson 2
	SetFlag 0x2033
	GoTo _cv_shown_156
_cv_show_155:
	ShowPerson 2
_cv_shown_156:
	// TODO(gba) special GymCandidate_FaceGuest
	GoTo _cv_stop
	End
	
GymLegend_EventScript_RivalVanishes:
	HidePerson 2
	SetFlag 0x2033
	PlaySE SEQ_SE_DP_KAIDAN2
	// TODO(gba) special GymCandidate_FaceBack
	GoTo _cv_stop
	ResetBGM
	Return
	
GymLegend_EventScript_NoLegend:
	SetVar 0x5014, 4
	SetVar VAR_SPECIAL_RESULT, 0
	End
	
GymCandidate_EventScript_MentorAppears:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special GymCandidate_PlaceGuest
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_MentorNoRoom
	CopyVar 0x401E, 0x8005
	CopyVar 0x401F, 0x8006
	MovePerson 0x800A, 0x401E, 0x401F
	ClearFlag 0x2017
	ShowPerson 0x800A
	// TODO(gba) special GymCandidate_FaceGuest
	GoTo _cv_stop
	End
	
GymCandidate_EventScript_GuestLeaves:
	CloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	HidePerson 0x800A
	SetFlag 0x2017
	// TODO(gba) special GymCandidate_FaceBack
	GoTo _cv_stop
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	Return
	
EventScript_GymHack_ShowTeamRuleMessage:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq EventScript_GymHack_MsgWrongType
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	CallIfEq EventScript_GymHack_MsgDuplicate
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	CallIfEq EventScript_GymHack_MsgDuplicateItem
	Return
	
GymFinale_EventScript_OakRulesMsg:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_OakRulesStillApply
	WaitButton
	Return
	
GymFinale_EventScript_HallOfFame:
	Call EventScript_SetDefeatedEliteFourFlagsVars
	SetFlag 0x2008
	SetVar 0x5004, 3
	Call GymFinale_EventScript_Badge
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_OakHallOfFame
	WaitButton
	CloseMsg
	SetVar 0x5005, 4
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special EnterHallOfFame
	GoTo _cv_stop
	ReleaseAll
	End
	
GymFinale_EventScript_Badge:
	// TODO(gba) special GymBadge_BufferName
	GoTo _cv_stop
	// TODO(gba) special GymBadge_ShowIcon
	GoTo _cv_stop
	PlayFanfare SEQ_ME_BADGE
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_YourBadge
	WaitButton
	WaitFanfare
	// TODO(gba) special GymBadge_HideIcon
	GoTo _cv_stop
	Return
	
GymFinale_EventScript_AideAndLegend:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_OakMeetMyAide
	WaitButton
	ApplyMovement 1, Common_Movement_WalkInPlaceFasterRight
	ApplyMovement obj_player, GymFinale_Movement_PlayerLookAtAide
	WaitMovement
	ApplyMovement 3, Common_Movement_WalkInPlaceFasterLeft
	WaitMovement
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_AideHello
	WaitButton
	ApplyMovement 1, Common_Movement_WalkInPlaceFasterDown
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_OakHowItWorks
	WaitButton
	CloseMsg
	Call GymLegend_EventScript_Arrives
	CloseMsg
	ApplyMovement 1, PalletTown_Gym_Movement_OakLeave
	WaitMovement
	HidePerson 1
	SetFlag 0x2034
	PlaySE SEQ_SE_DP_KAIDAN2
	SetFlag 0x2034
	ResetBGM
	ReleaseAll
	End
	
GymChallenge_EventScript_ChallengerLeaves:
	CloseMsg
	SetVar 0x8004, 1
	// TODO(gba) special GymChallenge_PlanChallengerWalk
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymChallenge_EventScript_ChallengerGone
	ApplyMovement 4, gGymChallengeChallengerPath
	WaitMovement
	PlaySE SEQ_SE_DP_KAIDAN2
	End
	
GymChallenge_EventScript_NewRecord:
	PlayFanfare SEQ_ME_LVUP
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_NewRecord
	WaitButton
	WaitFanfare
	Return
	
GymChallenge_EventScript_RareGift:
	PlaySE SEQ_SE_DP_SELECT
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_RareGift
	WaitButton
	Return
	
GymHack_EventScript_GiveStatItem:
	GiveItem 0x8009, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymHack_EventScript_GiveStatItemDone
	BufferItemName 1, 0x8009
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymHack_Text_GiftSentToPC
	WaitButton
	End
	
GymSwitch_EventScript_Mastered:
	PlayFanfare SEQ_ME_ITEM
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymSwitch_Text_Mastered
	WaitButton
	WaitFanfare
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymSwitch_Text_OakWillCome
	WaitButton
	Return
	
GymSwitch_EventScript_KeepGoingOrRetire:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymSwitch_Text_WhatNext
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_GymSwitch_Text_KeepGoing, 0
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_GymSwitch_Text_CallItADay, 1
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_GymSwitch_Text_TakeABreak, 2
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_158
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_158:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymChallenge_EventScript_KeepGoing
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymSwitch_EventScript_CallItADay
	// TODO(gba) special GymChallenge_BufferRecord
	GoTo _cv_stop
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_TakeABreak
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymChallenge_EventScript_KeepGoing:
	CloseMsg
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	GoTo GymChallenge_EventScript_NextChallenger
	End
	
GymSwitch_EventScript_OakComes:
	CloseMsg
	ClearFlag 0x201F
	PlayBGM SEQ_GS_OHKIDO
	SetVar 0x800A, 1
	// TODO(gba) special GymCandidate_PlanChallengerWalk
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymSwitch_EventScript_OakAppears
	CopyVar 0x401E, 0x8005
	CopyVar 0x401F, 0x8006
	MovePerson 1, 0x401E, 0x401F
	ClearFlag 0x2034
	GoToIfUnset 0x2034, _cv_show_159
	ClearFlag 0x2034
	ShowPerson 1
	SetFlag 0x2034
	GoTo _cv_shown_160
_cv_show_159:
	ShowPerson 1
_cv_shown_160:
	ApplyMovement 1, gMentorWalkIn
	WaitMovement
	// TODO(gba) special GymCandidate_FaceGuest
	GoTo _cv_stop
	End
	
Gauntlet_EventScript_PilotMenuWithdraw:
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptWithdraw, 0
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptSim, 1
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptOff, 2
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_162
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_162:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Gauntlet_EventScript_Withdraw
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Tourney_EventScript_Menu
	End
	
Gauntlet_EventScript_PilotOff:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_PilotOff
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Gauntlet_EventScript_NoRoom:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_NoRoom
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Gauntlet_EventScript_SentToPC:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SentToPC
	WaitButton
	Return
	
Gauntlet_EventScript_BillWait:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_BillWait
	WaitButton
	ResetBGM
	CloseMsg
	ReleaseAll
	End
	
Gauntlet_EventScript_BillWon:
	HealParty
	PlayBGM SEQ_GS_D_AJITO
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_gGymChallengeAfterText
	WaitButton
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_BillLast
	WaitButton
	CloseMsg
	ApplyMovement 17, Gauntlet_Movement_Collapse
	WaitMovement
	PlayCry SPECIES_CLEFABLE, 0
	WaitCry
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special Gauntlet_BillDefeated
	GoTo _cv_stop
	HidePerson 17
	SetFlag 0x2035
	GoToIfUnset 0x2035, _cv_show_163
	ClearFlag 0x2035
	ShowPerson 17
	SetFlag 0x2035
	GoTo _cv_shown_164
_cv_show_163:
	ShowPerson 17
_cv_shown_164:
	Wait 60, VAR_SPECIAL_RESULT
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Faded
	WaitButton
	// TODO(gba) special Overworld_PlaySpecialMapMusic
	GoTo _cv_stop
	CloseMsg
	ReleaseAll
	End
	
Tourney_EventScript_SayNext:
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SayNextSim
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Next
	Return
	
Tourney_EventScript_Match:
	// TODO(gba) special Tourney_CheckTeam
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Tourney_EventScript_WrongTeam
	// TODO(gba) special Tourney_CheckClauses
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe Tourney_EventScript_BreaksClause
	HealParty
	// TODO(gba) special GymChallenge_PlanPlayerWalk
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymChallenge_EventScript_CantReachSpot
	Call Tourney_EventScript_SayTakeYourPlace
	CloseMsg
	ApplyMovement obj_player, gGymChallengePlayerPath
	WaitMovement
	End
	
Tourney_EventScript_Board:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special Tourney_ShowBoard
	GoTo _cv_stop
	GoTo Tourney_EventScript_Menu
	
Tourney_EventScript_Forfeit:
	Call Tourney_EventScript_SayForfeitAsk
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Tourney_EventScript_Menu
	// TODO(gba) special Tourney_Forfeit
	GoTo _cv_stop
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SimForfeited
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Forfeited
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Tourney_EventScript_SimBill:
	HealParty
	// TODO(gba) special Gauntlet_SetupBill
	GoTo _cv_stop
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimBillAnnounce
	WaitButton
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_gGymChallengeIntroText
	WaitButton
	CloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special Gauntlet_ShowBillCard
	GoTo _cv_stop
	ClearTrainerFlag 1442
	SetFlag 0x2036
	CheckTrainerFlag 1442
	GoToIf TRUE, _cv_beaten_165
	TrainerBattle 1442, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_166
	WhiteOut
	End
_cv_won_166:
	SetTrainerFlag 1442
	ReleaseAll
	End
_cv_beaten_165:
	ClearFlag 0x2036
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq _cv_won_167
	SetVar VAR_SPECIAL_RESULT, 2
_cv_won_167:
	HealParty
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Tourney_EventScript_SimBillWon
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimBillLost
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Tourney_EventScript_SayAskSim:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimAsk
	Return
	
Tourney_EventScript_SayRules:
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SayRulesSim
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Rules
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_168
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_169
_cv_yes_168:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_169:
	Return
	
Tourney_EventScript_BreaksClause:
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	CallIfEq Tourney_EventScript_SpeciesClause
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	CallIfEq Tourney_EventScript_ItemClause
	ReleaseAll
	End
	
Tourney_EventScript_SimFormat:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimFormat
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 1, 0, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptSingles, 0
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptDoubles, 1
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_171
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_171:
	// TODO(gba) special Tourney_SetSimFormat
	GoTo _cv_stop
	CloseMsg
	Return
	
Tourney_EventScript_SayDraw:
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SayDrawSim
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Draw
	WaitButton
	Return
	
Tourney_EventScript_SayFirst:
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SayFirstSim
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_First
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_172
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_173
_cv_yes_172:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_173:
	Return
	
Tourney_EventScript_SayChampion:
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SayChampionSim
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Champion
	WaitButton
	Return
	
GymLegend_EventScript_RivalNoRoom:
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	Return
	
GymCandidate_EventScript_MentorNoRoom:
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	Return
	
EventScript_GymHack_MsgWrongType:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Text_GymHack_WrongType
	WaitButton
	Return
	
EventScript_GymHack_MsgDuplicate:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Text_GymHack_Duplicate
	WaitButton
	Return
	
EventScript_GymHack_MsgDuplicateItem:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Text_GymHack_DuplicateItem
	WaitButton
	Return
	
EventScript_SetDefeatedEliteFourFlagsVars:
	ClearFlag 0x203C
	Call EventScript_ResetEliteFour
	// TODO(gba) special Script_UpdateTrainerFanClubGameClear
	GoTo _cv_stop
	CompareVarToValue 0x5004, 0
	CallIfEq EventScript_GymHack_StartGymFinale
	CompareVarToValue 0x5004, 3
	CallIfEq EventScript_TryReadyNationalDexScene
	Call EventScript_ResetLegendaries
	Return
	
GymLegend_EventScript_Arrives:
	Call GymLegend_EventScript_Appears
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymLegend_EventScript_Return
	PlaySE SEQ_SE_DP_SELECT
	ApplyMovement obj_player, Common_Movement_ExclamationMark
	ApplyMovement 1, Common_Movement_ExclamationMark
	WaitMovement
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymLegend_Text_OakWhatOnEarth
	WaitButton
	// TODO(gba) special GymSwitch_HasSwitched
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymLegend_EventScript_OakCatchAnother
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymLegend_Text_OakCatchIt
	WaitButton
	Return
	
GymChallenge_EventScript_ChallengerGone:
	HidePerson 4
	SetFlag 0x2017
	SetFlag 0x2017
	Return
	
GymHack_EventScript_GiveStatItemDone:
	Return
	
GymSwitch_EventScript_CallItADay:
	// TODO(gba) special GymChallenge_RetireStreak
	GoTo _cv_stop
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymSwitch_Text_CalledItADay
	WaitButton
	GoTo GymSwitch_EventScript_OakComes
	CloseMsg
	End
	
GymSwitch_EventScript_OakAppears:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special GymCandidate_PlaceGuest
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymSwitch_EventScript_OakNoRoom
	CopyVar 0x401E, 0x8005
	CopyVar 0x401F, 0x8006
	MovePerson 1, 0x401E, 0x401F
	ClearFlag 0x2034
	GoToIfUnset 0x2034, _cv_show_174
	ClearFlag 0x2034
	ShowPerson 1
	SetFlag 0x2034
	GoTo _cv_shown_175
_cv_show_174:
	ShowPerson 1
_cv_shown_175:
	// TODO(gba) special GymCandidate_FaceGuest
	GoTo _cv_stop
	End
	
Tourney_EventScript_SayNextSim:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimNext
	Return
	
Tourney_EventScript_WrongTeam:
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SimWrongTeam
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_WrongTeam
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Tourney_EventScript_SayTakeYourPlace:
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_Return
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_TakeYourPlace
	WaitButton
	End
	
Tourney_EventScript_SayForfeitAsk:
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SayForfeitAskSim
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_ForfeitAsk
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_176
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_177
_cv_yes_176:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_177:
	Return
	
Tourney_EventScript_SimForfeited:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimForfeited
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Tourney_EventScript_SimBillWon:
	// TODO(gba) special Tourney_SimBillWon
	GoTo _cv_stop
	PlayFanfare SEQ_ME_ITEM
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimComplete
	WaitFanfare
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_WithdrawAsk
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_178
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_179
_cv_yes_178:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_179:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Gauntlet_EventScript_Withdraw
	CloseMsg
	ReleaseAll
	End
	
Tourney_EventScript_SayRulesSim:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimStart
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_180
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_181
_cv_yes_180:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_181:
	Return
	
Tourney_EventScript_SpeciesClause:
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SimSpeciesClause
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SpeciesClause
	WaitButton
	Return
	
Tourney_EventScript_ItemClause:
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SimItemClause
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_ItemClause
	WaitButton
	Return
	
Tourney_EventScript_SayDrawSim:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimDraw
	WaitButton
	Return
	
Tourney_EventScript_SayFirstSim:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimFirst
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_182
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_183
_cv_yes_182:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_183:
	Return
	
Tourney_EventScript_SayChampionSim:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimChampion
	WaitButton
	Return
	
EventScript_ResetEliteFour:
	ClearFlag 0x203D
	ClearFlag 0x203E
	ClearFlag 0x203F
	ClearFlag 0x2040
	ClearFlag 0x2041
	ClearFlag 0x2053
	ClearFlag 0x2054
	ClearFlag 0x2055
	ClearFlag 0x2056
	ClearFlag 0x2057
	ClearFlag 0x2058
	SetVar 0x501D, 0
	Return
	
EventScript_GymHack_StartGymFinale:
	SetVar 0x5004, 1
	Return
	
EventScript_ResetLegendaries:
	ClearFlag 0x2042
	ClearFlag 0x2043
	ClearFlag 0x2044
	Return
	
GymLegend_EventScript_Return:
	Return
	
GymLegend_EventScript_OakCatchAnother:
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymLegend_Text_OakCatchAnother
	WaitButton
	Return
	
GymSwitch_EventScript_OakNoRoom:
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	GoTo GymSwitch_EventScript_OakHere
	End
	
Tourney_EventScript_SimWrongTeam:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimWrongTeam
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Tourney_EventScript_Return:
	Return
	
Tourney_EventScript_SayForfeitAskSim:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimForfeitAsk
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_184
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_185
_cv_yes_184:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_185:
	Return
	
Tourney_EventScript_SimSpeciesClause:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimSpeciesClause
	WaitButton
	Return
	
Tourney_EventScript_SimItemClause:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimItemClause
	WaitButton
	Return
	
GymSwitch_EventScript_OakHere:
	// TODO(gba) special GymSwitch_BufferStatus
	GoTo _cv_stop
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymSwitch_Text_OakMastered
	WaitButton
	HasItem 1833, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq GymSwitch_EventScript_OakTeraTip
	// TODO(gba) special GymSwitch_CanTakeNewType
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymSwitch_EventScript_OakNothingToOffer
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymSwitch_Text_OakTryAnother
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_186
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_187
_cv_yes_186:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_187:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymSwitch_EventScript_OakDeclined
	SetVar 0x8004, 1
	Call GymSwitch_EventScript_ChooseType
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymSwitch_EventScript_OakDeclined
	CompareVarToValue 0x5014, 5
	GoToIfNe GymSwitch_EventScript_OakLeaves
	CloseMsg
	Call GymLegend_EventScript_Arrives
	CloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	HidePerson 1
	SetFlag 0x2034
	SetFlag 0x2034
	// TODO(gba) special GymCandidate_FaceBack
	GoTo _cv_stop
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	ResetBGM
	ReleaseAll
	End
	
GymSwitch_EventScript_OakTeraTip:
	// TODO(gba) special GymSwitch_BufferStatus
	GoTo _cv_stop
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymSwitch_Text_OakTeraTip
	WaitButton
	Return
	
GymSwitch_EventScript_OakNothingToOffer:
	// TODO(gba) special GymSwitch_AllMastered
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymSwitch_EventScript_OakAllMastered
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymSwitch_Text_OakKeepItUp
	WaitButton
	GoTo GymSwitch_EventScript_OakLeaves
	CloseMsg
	End
	
GymSwitch_EventScript_OakDeclined:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymSwitch_Text_OakOfferStands
	WaitButton
	End
	
GymSwitch_EventScript_ChooseType:
	CompareVarToValue 0x8004, 1
	GoToIfEq GymSwitch_EventScript_AskNewType
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymSwitch_Text_WhichTypeStars
	GoTo GymSwitch_EventScript_TypeMenu
	CloseMsg
	End
	
GymSwitch_EventScript_OakLeaves:
	CloseMsg
	// TODO(gba) special GymCandidate_VisitorWalked
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymSwitch_EventScript_OakGone
	ApplyMovement 1, gMentorWalkOut
	WaitMovement
	PlaySE SEQ_SE_DP_KAIDAN2
	End
	
GymSwitch_EventScript_OakAllMastered:
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymSwitch_Text_OakAllMastered
	WaitButton
	GoTo GymSwitch_EventScript_OakLeaves
	CloseMsg
	End
	
GymSwitch_EventScript_AskNewType:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymSwitch_Text_WhichType
	End
	
GymSwitch_EventScript_TypeMenu:
	// TODO(gba) special GymSwitch_PushTypes
	GoTo _cv_stop
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_189
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_189:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq GymSwitch_EventScript_ChoiceCancelled
	// TODO(gba) special GymSwitch_BufferChoice
	GoTo _cv_stop
	CopyVar 0x8009, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymSwitch_EventScript_ConfirmNew
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymSwitch_Text_ConfirmOld
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_190
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_191
_cv_yes_190:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_191:
	GoTo GymSwitch_EventScript_Confirmed
	CloseMsg
	End
	
GymSwitch_EventScript_OakGone:
	HidePerson 1
	SetFlag 0x2034
	SetFlag 0x2034
	// TODO(gba) special GymCandidate_FaceBack
	GoTo _cv_stop
	ResetBGM
	ReleaseAll
	End
	
GymSwitch_EventScript_ChoiceCancelled:
	SetVar VAR_SPECIAL_RESULT, 0
	Return
	
GymSwitch_EventScript_ConfirmNew:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymSwitch_Text_ConfirmNew
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_192
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_193
_cv_yes_192:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_193:
	End
	
GymSwitch_EventScript_Confirmed:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymSwitch_EventScript_ChooseType
	// TODO(gba) special GymSwitch_SetType
	GoTo _cv_stop
	// TODO(gba) special GymBadge_ShowIcon
	GoTo _cv_stop
	PlayFanfare SEQ_ME_BADGE
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymSwitch_Text_NowType
	WaitButton
	WaitFanfare
	// TODO(gba) special GymBadge_HideIcon
	GoTo _cv_stop
	Call Outfits_EventScript_AllGymUniforms
	CompareVarToValue 0x8007, 1
	CallIfEq GymSwitch_EventScript_OldLegendLeaves
	CompareVarToValue 0x8009, 1
	GoToIfEq GymSwitch_EventScript_NewTypeTips
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymSwitch_Text_BackToType
	WaitButton
	SetVar VAR_SPECIAL_RESULT, 1
	Return
	
Outfits_EventScript_AllGymUniforms:
	// TODO(gba) special Outfit_UnlockAllGymUniforms
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Outfits_EventScript_Return
	PlayFanfare SEQ_ME_ITEM
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Outfits_Text_ReceivedAllGymUniforms
	WaitFanfare
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Outfits_Text_AllInWardrobe
	WaitButton
	Return
	
GymSwitch_EventScript_OldLegendLeaves:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymSwitch_Text_OldLegendLeaves
	WaitButton
	Return
	
GymSwitch_EventScript_NewTypeTips:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymSwitch_Text_NewTypeTips
	WaitButton
	SetVar VAR_SPECIAL_RESULT, 1
	Return
	
Outfits_EventScript_Return:
	Return

_cv_unported_21:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_22:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_23:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_24:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_25:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_str4:
	BufferPlayersName 6
	BufferRivalsName 7
	Return

_cv_stop:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
gGymChallengePlayerPath:
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterUp:
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterLeft:
	WalkOnSpotFasterWest
	EndMovement

	.balign 4, 0
Common_Movement_ExclamationMark:
	EmoteExclamationMark
	EndMovement

	.balign 4, 0
PalletTown_Gym_Movement_WatchRivalLeave:
	WalkOnSpotFasterEast
	Delay16
	WalkOnSpotFasterSouth
	EndMovement

	.balign 4, 0
PalletTown_Gym_Movement_RivalLeave:
	WalkNormalSouth
	WalkNormalWest
	WalkNormalSouth
	SetInvisible
	EndMovement

	.balign 4, 0
PalletTown_Gym_Movement_OakLeave:
	WalkNormalEast
	WalkNormalSouth 3
	WalkNormalWest
	WalkNormalSouth
	SetInvisible
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterDown:
	WalkOnSpotFasterSouth
	EndMovement

	.balign 4, 0
gGymChallengeChallengerPath:
	EndMovement

	.balign 4, 0
gMentorWalkIn:
	EndMovement

	.balign 4, 0
gMentorWalkOut:
	EndMovement

	.balign 4, 0
gGymLegendCameraIn:
	EndMovement

	.balign 4, 0
gGymLegendCameraOut:
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterRight:
	WalkOnSpotFasterEast
	EndMovement

	.balign 4, 0
GymFinale_Movement_PlayerLookAtAide:
	WalkOnSpotFasterEast
	EndMovement

	.balign 4, 0
Gauntlet_Movement_Collapse:
	WalkOnSpotSlowSouth
	Delay16
	WalkOnSpotSlowSouth
	Delay16
	FaceNorth
	Delay8
	FaceSouth
	Delay16
	EndMovement
	.balign 4, 0
