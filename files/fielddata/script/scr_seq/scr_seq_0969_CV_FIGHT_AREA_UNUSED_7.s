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
	ScrDef PalletTown_Gym_EventScript_OakWantsTheGym
	ScrDef GymLegend_EventScript_RivalEscaped
	ScrDef GymLegend_EventScript_RivalCaught
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
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x2008, _cv_open_1
	SetVar VAR_SPECIAL_RESULT, 1
_cv_open_1:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymChallenge_EventScript_AideNotYet
	BufferInt 0, 0x504D
	BufferInt 1, 0x504E
	BufferInt 2, 0x504F
	BufferInt 3, 0x5050
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_AideWelcome
	WaitButton
	SetVar 0x401E, 15
	BufferInt 0, 0x401E
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfSet 0x22E8, _cv_goal_2
	CompareVarToValue 0x504D, 15
	GoToIfGe _cv_goal_2
	SetVar VAR_SPECIAL_RESULT, 1
_cv_goal_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq GymSwitch_EventScript_AideGoal
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_ReadyToBattle
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_3
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_4
_cv_yes_3:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymChallenge_EventScript_NotNow
	CanvasCheckTeam 7, 0x5019
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe GymChallenge_EventScript_TeamBreaksRules
	HealParty
	SetVar VAR_SPECIAL_RESULT, 1
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymChallenge_EventScript_CantReachSpot
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	CallIfEq GymChallenge_EventScript_NoStage
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	CallIfEq GymChallenge_EventScript_StageBlocked
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_TakeYourPlace
	WaitButton
	CanvasCloseMsg
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
	CanvasCloseMsg
	SetVar 0x5014, 1
	// TODO(gba) special GymLegend_CreateMon
	GoTo _cv_stop
	SetFlag 0x2032
	WildBattle 0, 5, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_wild_5
	WhiteOut
	ReleaseAll
	End
_cv_wild_5:
	ClearFlag 0x2032
	GetStaticEncounterOutcome VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfNe _cv_outcome_6
	SetVar VAR_SPECIAL_RESULT, 7
	GoTo _cv_outcome_7
_cv_outcome_6:
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfNe _cv_outcome_7
	SetVar VAR_SPECIAL_RESULT, 4
_cv_outcome_7:
	HidePerson 16
	SetFlag 0x203A
	CompareVarToValue VAR_SPECIAL_RESULT, 7
	GoToIfEq GymLegend_EventScript_Caught
	// TODO(gba) special GymLegend_Setup
	GoTo _cv_stop
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymLegend_Text_Fled
	WaitButton
	CanvasCloseMsg
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
	GoTo GymDecor_EventScript_PCMenu
	
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
	GoTo GymFinale_EventScript_AideAndLegend
	
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
	CanvasCloseMsg
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
	CanvasCloseMsg
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
	CanvasCloseMsg
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
	CanvasCloseMsg
	ResetBGM
	GoTo GymLegend_EventScript_ArrivesLaterEnd
	
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
	GoToIfNe _cv_next_9
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_8
_cv_next_9:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_10
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_8
_cv_next_10:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_11
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Misty
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_8
_cv_next_11:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_12
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_8
_cv_next_12:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_13
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_8
_cv_next_13:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_14
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Erika
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_8
_cv_next_14:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_15
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_8
_cv_next_15:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_16
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_8
_cv_next_16:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_17
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_8
_cv_next_17:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_18
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_8
_cv_next_18:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_19
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Blaine
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_8
_cv_next_19:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_20
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_8
_cv_next_20:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_21
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_8
_cv_next_21:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_22
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lorelei
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_8
_cv_next_22:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_23
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_8
_cv_next_23:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_24
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_8
_cv_next_24:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_25
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_8
_cv_next_25:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_26
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_8
_cv_next_26:
_cv_done_8:
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Johto_Text_MentorInvite
	WaitButton
	Call Johto_EventScript_ReceiveInvitation
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_28
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_27
_cv_next_28:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_29
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_27
_cv_next_29:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_30
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Misty
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_27
_cv_next_30:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_31
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_27
_cv_next_31:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_32
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_27
_cv_next_32:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_33
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Erika
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_27
_cv_next_33:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_34
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_27
_cv_next_34:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_35
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_27
_cv_next_35:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_36
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_27
_cv_next_36:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_37
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_27
_cv_next_37:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_38
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Blaine
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_27
_cv_next_38:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_39
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_27
_cv_next_39:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_40
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_27
_cv_next_40:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_41
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lorelei
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_27
_cv_next_41:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_42
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_27
_cv_next_42:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_43
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_27
_cv_next_43:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_44
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_27
_cv_next_44:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_45
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_27
_cv_next_45:
_cv_done_27:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Johto_Text_MentorInviteFerry
	WaitButton
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_47
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_46
_cv_next_47:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_48
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_46
_cv_next_48:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_49
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Misty
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_46
_cv_next_49:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_50
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_46
_cv_next_50:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_51
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_46
_cv_next_51:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_52
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Erika
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_46
_cv_next_52:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_53
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_46
_cv_next_53:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_54
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_46
_cv_next_54:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_55
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_46
_cv_next_55:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_56
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_46
_cv_next_56:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_57
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Blaine
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_46
_cv_next_57:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_58
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_46
_cv_next_58:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_59
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_46
_cv_next_59:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_60
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lorelei
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_46
_cv_next_60:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_61
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_46
_cv_next_61:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_62
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_46
_cv_next_62:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_63
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_46
_cv_next_63:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_64
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_46
_cv_next_64:
_cv_done_46:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Johto_Text_MentorGymCharm
	WaitButton
	Call Johto_EventScript_ReceiveGymCharm
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_66
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_65
_cv_next_66:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_67
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_65
_cv_next_67:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_68
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Misty
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_65
_cv_next_68:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_69
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_65
_cv_next_69:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_70
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_65
_cv_next_70:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_71
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Erika
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_65
_cv_next_71:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_72
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_65
_cv_next_72:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_73
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_65
_cv_next_73:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_74
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_65
_cv_next_74:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_75
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_65
_cv_next_75:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_76
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Blaine
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_65
_cv_next_76:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_77
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_65
_cv_next_77:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_78
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_65
_cv_next_78:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_79
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lorelei
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_65
_cv_next_79:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_80
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_65
_cv_next_80:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_81
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_65
_cv_next_81:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_82
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_65
_cv_next_82:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_83
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_65
_cv_next_83:
_cv_done_65:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Johto_Text_MentorGymCharmHow
	WaitButton
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_85
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_84
_cv_next_85:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_86
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_84
_cv_next_86:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_87
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Misty
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_84
_cv_next_87:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_88
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_84
_cv_next_88:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_89
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_84
_cv_next_89:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_90
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Erika
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_84
_cv_next_90:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_91
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_84
_cv_next_91:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_92
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_84
_cv_next_92:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_93
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_84
_cv_next_93:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_94
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_84
_cv_next_94:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_95
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Blaine
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_84
_cv_next_95:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_96
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_84
_cv_next_96:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_97
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_84
_cv_next_97:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_98
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lorelei
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_84
_cv_next_98:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_99
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_84
_cv_next_99:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_100
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_84
_cv_next_100:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_101
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_84
_cv_next_101:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_102
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_84
_cv_next_102:
_cv_done_84:
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
	GoToIfUnset 0x2035, _cv_show_103
	ClearFlag 0x2035
	ShowPerson 17
	SetFlag 0x2035
	GoTo _cv_shown_104
_cv_show_103:
	ShowPerson 17
_cv_shown_104:
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
	GoToIfEq _cv_yes_105
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_106
_cv_yes_105:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_106:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymFinale_EventScript_PutOff
	CanvasCheckTeam 7, 0x5019
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe GymFinale_EventScript_TeamBreaksRules
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_OakThenShowMe
	WaitButton
	CanvasCloseMsg
	HealParty
	CanvasCandidate 13
	CanvasCloseMsg
	ClearTrainerFlag 1476
	TrainerBattle 1476, 1476, 1, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CanvasCandidate 12
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymFinale_EventScript_BeatOak
	GoTo GymFinale_EventScript_LostToOak
	End
	
GymChallenge_EventScript_AideNotYet:
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x2093, _cv_appr_107
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_107:
	GoToIfUnset 0x2094, _cv_appr_108
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_108:
	GoToIfUnset 0x2095, _cv_appr_109
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_109:
	GoToIfUnset 0x2096, _cv_appr_110
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_110:
	GoToIfUnset 0x2097, _cv_appr_111
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_111:
	GoToIfUnset 0x2098, _cv_appr_112
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_112:
	GoToIfUnset 0x2099, _cv_appr_113
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_113:
	GoToIfUnset 0x2007, _cv_appr_114
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_114:
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
	GoToIfUnset 0x2008, _cv_trainer_117
	GoToIfSet 0x22E8, _cv_famous_116_roll
	CompareVarToValue 0x504D, 14
	GoToIfEq _cv_boss_115
_cv_famous_116_roll:
	CompareVarToValue 0x5051, 6
	GoToIfEq _cv_famous_116
	Random 0x401E, 12
	CompareVarToValue 0x401E, 2
	GoToIfLt _cv_famous_116
	GoTo _cv_trainer_117
_cv_boss_115:
	SetVar 0x5052, 3
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_120
	SetVar 0x5053, 0
	GoTo _cv_done_119
_cv_next_120:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_121
	SetVar 0x5053, 0
	GoTo _cv_done_119
_cv_next_121:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_122
	SetVar 0x5053, 1
	GoTo _cv_done_119
_cv_next_122:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_123
	SetVar 0x5053, 2
	GoTo _cv_done_119
_cv_next_123:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_124
	SetVar 0x5053, 2
	GoTo _cv_done_119
_cv_next_124:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_125
	SetVar 0x5053, 3
	GoTo _cv_done_119
_cv_next_125:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_126
	SetVar 0x5053, 4
	GoTo _cv_done_119
_cv_next_126:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_127
	SetVar 0x5053, 4
	GoTo _cv_done_119
_cv_next_127:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_128
	SetVar 0x5053, 5
	GoTo _cv_done_119
_cv_next_128:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_129
	SetVar 0x5053, 5
	GoTo _cv_done_119
_cv_next_129:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_130
	SetVar 0x5053, 6
	GoTo _cv_done_119
_cv_next_130:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_131
	SetVar 0x5053, 9
	GoTo _cv_done_119
_cv_next_131:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_132
	SetVar 0x5053, 10
	GoTo _cv_done_119
_cv_next_132:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_133
	SetVar 0x5053, 8
	GoTo _cv_done_119
_cv_next_133:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_134
	SetVar 0x5053, 9
	GoTo _cv_done_119
_cv_next_134:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_135
	SetVar 0x5053, 10
	GoTo _cv_done_119
_cv_next_135:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_136
	SetVar 0x5053, 11
	GoTo _cv_done_119
_cv_next_136:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_137
	SetVar 0x5053, 11
	GoTo _cv_done_119
_cv_next_137:
_cv_done_119:
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_139
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_138
_cv_next_139:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_140
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_138
_cv_next_140:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_141
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Misty
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_138
_cv_next_141:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_142
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_138
_cv_next_142:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_143
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_138
_cv_next_143:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_144
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Erika
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_138
_cv_next_144:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_145
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_138
_cv_next_145:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_146
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_138
_cv_next_146:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_147
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_138
_cv_next_147:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_148
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_138
_cv_next_148:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_149
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Blaine
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_138
_cv_next_149:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_150
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_138
_cv_next_150:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_151
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_138
_cv_next_151:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_152
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lorelei
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_138
_cv_next_152:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_153
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_138
_cv_next_153:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_154
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_138
_cv_next_154:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_155
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_138
_cv_next_155:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_156
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_138
_cv_next_156:
_cv_done_138:
	GoTo _cv_famous_116_set
_cv_famous_116:
	SetVar 0x5052, 1
	Random 0x401E, 11
	CompareVarToValue 0x401E, 0
	GoToIfNe _cv_next_158
	SetVar 0x5053, 0
	GoTo _cv_done_157
_cv_next_158:
	CompareVarToValue 0x401E, 1
	GoToIfNe _cv_next_159
	SetVar 0x5053, 1
	GoTo _cv_done_157
_cv_next_159:
	CompareVarToValue 0x401E, 2
	GoToIfNe _cv_next_160
	SetVar 0x5053, 2
	GoTo _cv_done_157
_cv_next_160:
	CompareVarToValue 0x401E, 3
	GoToIfNe _cv_next_161
	SetVar 0x5053, 3
	GoTo _cv_done_157
_cv_next_161:
	CompareVarToValue 0x401E, 4
	GoToIfNe _cv_next_162
	SetVar 0x5053, 4
	GoTo _cv_done_157
_cv_next_162:
	CompareVarToValue 0x401E, 5
	GoToIfNe _cv_next_163
	SetVar 0x5053, 5
	GoTo _cv_done_157
_cv_next_163:
	CompareVarToValue 0x401E, 6
	GoToIfNe _cv_next_164
	SetVar 0x5053, 6
	GoTo _cv_done_157
_cv_next_164:
	CompareVarToValue 0x401E, 7
	GoToIfNe _cv_next_165
	SetVar 0x5053, 8
	GoTo _cv_done_157
_cv_next_165:
	CompareVarToValue 0x401E, 8
	GoToIfNe _cv_next_166
	SetVar 0x5053, 9
	GoTo _cv_done_157
_cv_next_166:
	CompareVarToValue 0x401E, 9
	GoToIfNe _cv_next_167
	SetVar 0x5053, 10
	GoTo _cv_done_157
_cv_next_167:
	CompareVarToValue 0x401E, 10
	GoToIfNe _cv_next_168
	SetVar 0x5053, 11
	GoTo _cv_done_157
_cv_next_168:
_cv_done_157:
_cv_famous_116_set:
	CompareVarToValue 0x5053, 0
	GoToIfNe _cv_next_171
	SetVar 0x4020, SPRITE_GSLEADER14
	SetVar 0x401E, 0
	CompareVarToValue 0x5052, 3
	GoToIfNe _cv_plus_169_0
	SetVar 0x401E, 3
_cv_plus_169_0:
	CanvasCandidate 15, 1150, 13, 0x401E
	GoTo _cv_done_170
_cv_next_171:
	CompareVarToValue 0x5053, 1
	GoToIfNe _cv_next_172
	SetVar 0x4020, SPRITE_GSLEADER11
	SetVar 0x401E, 0
	CompareVarToValue 0x5052, 3
	GoToIfNe _cv_plus_169_1
	SetVar 0x401E, 3
_cv_plus_169_1:
	CanvasCandidate 15, 1151, 20, 0x401E
	GoTo _cv_done_170
_cv_next_172:
	CompareVarToValue 0x5053, 2
	GoToIfNe _cv_next_173
	SetVar 0x4020, SPRITE_GSLEADER9
	SetVar 0x401E, 0
	CompareVarToValue 0x5052, 3
	GoToIfNe _cv_plus_169_2
	SetVar 0x401E, 3
_cv_plus_169_2:
	CanvasCandidate 15, 1152, 21, 0x401E
	GoTo _cv_done_170
_cv_next_173:
	CompareVarToValue 0x5053, 3
	GoToIfNe _cv_next_174
	SetVar 0x4020, SPRITE_GSLEADER12
	SetVar 0x401E, 0
	CompareVarToValue 0x5052, 3
	GoToIfNe _cv_plus_169_3
	SetVar 0x401E, 3
_cv_plus_169_3:
	CanvasCandidate 15, 1153, 27, 0x401E
	GoTo _cv_done_170
_cv_next_174:
	CompareVarToValue 0x5053, 4
	GoToIfNe _cv_next_175
	SetVar 0x4020, SPRITE_GSBIGFOUR2
	SetVar 0x401E, 0
	CompareVarToValue 0x5052, 3
	GoToIfNe _cv_plus_169_4
	SetVar 0x401E, 3
_cv_plus_169_4:
	CanvasCandidate 15, 1154, 39, 0x401E
	GoTo _cv_done_170
_cv_next_175:
	CompareVarToValue 0x5053, 5
	GoToIfNe _cv_next_176
	SetVar 0x4020, SPRITE_GSLEADER10
	SetVar 0x401E, 0
	CompareVarToValue 0x5052, 3
	GoToIfNe _cv_plus_169_5
	SetVar 0x401E, 3
_cv_plus_169_5:
	CanvasCandidate 15, 1156, 39, 0x401E
	GoTo _cv_done_170
_cv_next_176:
	CompareVarToValue 0x5053, 6
	GoToIfNe _cv_next_177
	SetVar 0x4020, SPRITE_GSLEADER15
	SetVar 0x401E, 0
	CompareVarToValue 0x5052, 3
	GoToIfNe _cv_plus_169_6
	SetVar 0x401E, 3
_cv_plus_169_6:
	CanvasCandidate 15, 1155, 43, 0x401E
	GoTo _cv_done_170
_cv_next_177:
	CompareVarToValue 0x5053, 8
	GoToIfNe _cv_next_178
	SetVar 0x4020, SPRITE_GSBIGFOUR4
	SetVar 0x401E, 0
	CompareVarToValue 0x5052, 3
	GoToIfNe _cv_plus_169_8
	SetVar 0x401E, 3
_cv_plus_169_8:
	CanvasCandidate 15, 1146, 53, 0x401E
	GoTo _cv_done_170
_cv_next_178:
	CompareVarToValue 0x5053, 9
	GoToIfNe _cv_next_179
	SetVar 0x4020, SPRITE_GSBIGFOUR3
	SetVar 0x401E, 0
	CompareVarToValue 0x5052, 3
	GoToIfNe _cv_plus_169_9
	SetVar 0x401E, 3
_cv_plus_169_9:
	CanvasCandidate 15, 1147, 53, 0x401E
	GoTo _cv_done_170
_cv_next_179:
	CompareVarToValue 0x5053, 10
	GoToIfNe _cv_next_180
	SetVar 0x4020, SPRITE_GSOLDWOMAN1
	SetVar 0x401E, 0
	CompareVarToValue 0x5052, 3
	GoToIfNe _cv_plus_169_10
	SetVar 0x401E, 3
_cv_plus_169_10:
	CanvasCandidate 15, 1148, 55, 0x401E
	GoTo _cv_done_170
_cv_next_180:
	CompareVarToValue 0x5053, 11
	GoToIfNe _cv_next_181
	SetVar 0x4020, SPRITE_WATARU
	SetVar 0x401E, 0
	CompareVarToValue 0x5052, 3
	GoToIfNe _cv_plus_169_11
	SetVar 0x401E, 3
_cv_plus_169_11:
	CanvasCandidate 15, 1149, 56, 0x401E
	GoTo _cv_done_170
_cv_next_181:
_cv_done_170:
	CopyVar VAR_SPECIAL_RESULT, 0x5052
	GoTo _cv_next_118
_cv_trainer_117:
	SetVar 0x5052, 0
	CanvasCandidate 14
	CopyVar 0x5054, VAR_SPECIAL_RESULT
	CopyVar 0x5055, 0x8005
	CompareVarToValue 0x5054, 0
	GoToIfNe _cv_next_183
	SetVar 0x4020, SPRITE_GSMAN3
	GoTo _cv_done_182
_cv_next_183:
	CompareVarToValue 0x5054, 1
	GoToIfNe _cv_next_184
	SetVar 0x4020, SPRITE_GSWOMAN3
	GoTo _cv_done_182
_cv_next_184:
	CompareVarToValue 0x5054, 2
	GoToIfNe _cv_next_185
	SetVar 0x4020, SPRITE_GSMAN3
	GoTo _cv_done_182
_cv_next_185:
	CompareVarToValue 0x5054, 3
	GoToIfNe _cv_next_186
	SetVar 0x4020, SPRITE_GSWOMAN3
	GoTo _cv_done_182
_cv_next_186:
	CompareVarToValue 0x5054, 4
	GoToIfNe _cv_next_187
	SetVar 0x4020, SPRITE_GSFIGHTER
	GoTo _cv_done_182
_cv_next_187:
	CompareVarToValue 0x5054, 5
	GoToIfNe _cv_next_188
	SetVar 0x4020, SPRITE_GSGENTLEMAN
	GoTo _cv_done_182
_cv_next_188:
	CompareVarToValue 0x5054, 6
	GoToIfNe _cv_next_189
	SetVar 0x4020, SPRITE_MOUNT_2
	GoTo _cv_done_182
_cv_next_189:
	CompareVarToValue 0x5054, 7
	GoToIfNe _cv_next_190
	SetVar 0x4020, SPRITE_GSMAN2
	GoTo _cv_done_182
_cv_next_190:
	CompareVarToValue 0x5054, 8
	GoToIfNe _cv_next_191
	SetVar 0x4020, SPRITE_BADMAN
	GoTo _cv_done_182
_cv_next_191:
	CompareVarToValue 0x5054, 9
	GoToIfNe _cv_next_192
	SetVar 0x4020, SPRITE_WORKMAN
	GoTo _cv_done_182
_cv_next_192:
	CompareVarToValue 0x5054, 10
	GoToIfNe _cv_next_193
	SetVar 0x4020, SPRITE_GSASSISTANTM
	GoTo _cv_done_182
_cv_next_193:
	CompareVarToValue 0x5054, 11
	GoToIfNe _cv_next_194
	SetVar 0x4020, SPRITE_MANIA
	GoTo _cv_done_182
_cv_next_194:
	CompareVarToValue 0x5054, 12
	GoToIfNe _cv_next_195
	SetVar 0x4020, SPRITE_CAMPBOY_2
	GoTo _cv_done_182
_cv_next_195:
	CompareVarToValue 0x5054, 13
	GoToIfNe _cv_next_196
	SetVar 0x4020, SPRITE_SEAMAN_2
	GoTo _cv_done_182
_cv_next_196:
	CompareVarToValue 0x5054, 14
	GoToIfNe _cv_next_197
	SetVar 0x4020, SPRITE_FISHING_2
	GoTo _cv_done_182
_cv_next_197:
	CompareVarToValue 0x5054, 15
	GoToIfNe _cv_next_198
	SetVar 0x4020, SPRITE_GSBOY2
	GoTo _cv_done_182
_cv_next_198:
	CompareVarToValue 0x5054, 16
	GoToIfNe _cv_next_199
	SetVar 0x4020, SPRITE_WOMAN2
	GoTo _cv_done_182
_cv_next_199:
	CompareVarToValue 0x5054, 17
	GoToIfNe _cv_next_200
	SetVar 0x4020, SPRITE_GSGIRL2
	GoTo _cv_done_182
_cv_next_200:
	CompareVarToValue 0x5054, 18
	GoToIfNe _cv_next_201
	SetVar 0x4020, SPRITE_PICNICGIRL_2
	GoTo _cv_done_182
_cv_next_201:
	CompareVarToValue 0x5054, 19
	GoToIfNe _cv_next_202
	SetVar 0x4020, SPRITE_GSGIRL3
	GoTo _cv_done_182
_cv_next_202:
	CompareVarToValue 0x5054, 20
	GoToIfNe _cv_next_203
	SetVar 0x4020, SPRITE_GSSWIMMERW
	GoTo _cv_done_182
_cv_next_203:
	CompareVarToValue 0x5054, 21
	GoToIfNe _cv_next_204
	SetVar 0x4020, SPRITE_GSSWIMMERM
	GoTo _cv_done_182
_cv_next_204:
_cv_done_182:
	Random 0x5056, 10
	Random 0x5057, 6
	Random 0x5058, 4
	Random 0x5059, 4
	SetVar 0x505A, 0
	Random 0x401E, 3
	CompareVarToValue 0x401E, 0
	GoToIfEq _cv_trainer_117_single
	SetVar 0x505A, 1
_cv_trainer_117_single:
	SetVar VAR_SPECIAL_RESULT, 0
_cv_next_118:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq GymChallenge_EventScript_AnnounceFamous
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	CallIfEq GymChallenge_EventScript_AnnounceTownsfolk
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	CallIfEq GymChallenge_EventScript_AnnounceTrainer
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	CallIfEq GymSwitch_EventScript_AnnounceMentor
	CanvasCloseMsg
	ClearFlag 0x2017
	GoToIfUnset 0x2017, _cv_show_205
	ClearFlag 0x2017
	ShowPerson 4
	SetFlag 0x2017
	GoTo _cv_shown_206
_cv_show_205:
	ShowPerson 4
_cv_shown_206:
	SetVar 0x8004, 0
	CompareVarToValue 0x8004, 1
	GoToIfEq _cv_cwalk_207
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	CanvasCandidate 4, 1
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_cwalk_208
	CanvasCandidate 17, 4, 0x8005, 0x8006
	GoTo _cv_cwalk_208
_cv_cwalk_207:
	CanvasCandidate 6
_cv_cwalk_208:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	CallIfEq GymChallenge_EventScript_ChallengerJumpsIn
	CompareVarToValue 0x8004, 1
	GoToIfEq _cv_capply_209
	CanvasCandidate 5, 4, 0
	WaitMovement
	CanvasCandidate 2, 4
	GoTo _cv_capply_210
_cv_capply_209:
	CanvasCandidate 5, 4, 1
	WaitMovement
_cv_capply_210:
	CompareVarToValue 0x5052, 0
	GoToIfEq _cv_gline_212
	CompareVarToValue 0x5052, 3
	GoToIfEq _cv_gline_213
	CompareVarToValue 0x5053, 0
	GoToIfNe _cv_next_215
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_intro_0
	WaitButton
	GoTo _cv_done_214
_cv_next_215:
	CompareVarToValue 0x5053, 1
	GoToIfNe _cv_next_216
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_intro_1
	WaitButton
	GoTo _cv_done_214
_cv_next_216:
	CompareVarToValue 0x5053, 2
	GoToIfNe _cv_next_217
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_intro_2
	WaitButton
	GoTo _cv_done_214
_cv_next_217:
	CompareVarToValue 0x5053, 3
	GoToIfNe _cv_next_218
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_intro_3
	WaitButton
	GoTo _cv_done_214
_cv_next_218:
	CompareVarToValue 0x5053, 4
	GoToIfNe _cv_next_219
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_intro_4
	WaitButton
	GoTo _cv_done_214
_cv_next_219:
	CompareVarToValue 0x5053, 5
	GoToIfNe _cv_next_220
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_intro_5
	WaitButton
	GoTo _cv_done_214
_cv_next_220:
	CompareVarToValue 0x5053, 6
	GoToIfNe _cv_next_221
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_intro_6
	WaitButton
	GoTo _cv_done_214
_cv_next_221:
	CompareVarToValue 0x5053, 8
	GoToIfNe _cv_next_222
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_intro_8
	WaitButton
	GoTo _cv_done_214
_cv_next_222:
	CompareVarToValue 0x5053, 9
	GoToIfNe _cv_next_223
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_intro_9
	WaitButton
	GoTo _cv_done_214
_cv_next_223:
	CompareVarToValue 0x5053, 10
	GoToIfNe _cv_next_224
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_intro_10
	WaitButton
	GoTo _cv_done_214
_cv_next_224:
	CompareVarToValue 0x5053, 11
	GoToIfNe _cv_next_225
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_intro_11
	WaitButton
	GoTo _cv_done_214
_cv_next_225:
_cv_done_214:
	GoTo _cv_gline_211
_cv_gline_213:
	BufferTypeName 1, 0x5019
	CopyVar 0x401E, 0x504D
	BufferInt 2, 0x401E
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_boss_intro
	WaitButton
	GoTo _cv_gline_211
_cv_gline_212:
	CompareVarToValue 0x5056, 0
	GoToIfNe _cv_next_226
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_gym_intro_0
	WaitButton
	GoTo _cv_gline_211
_cv_next_226:
	CompareVarToValue 0x5056, 1
	GoToIfNe _cv_next_227
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_gym_intro_1
	WaitButton
	GoTo _cv_gline_211
_cv_next_227:
	CompareVarToValue 0x5056, 2
	GoToIfNe _cv_next_228
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_gym_intro_2
	WaitButton
	GoTo _cv_gline_211
_cv_next_228:
	CompareVarToValue 0x5056, 3
	GoToIfNe _cv_next_229
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_gym_intro_3
	WaitButton
	GoTo _cv_gline_211
_cv_next_229:
	CompareVarToValue 0x5056, 4
	GoToIfNe _cv_next_230
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_gym_intro_4
	WaitButton
	GoTo _cv_gline_211
_cv_next_230:
	CompareVarToValue 0x5056, 5
	GoToIfNe _cv_next_231
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_gym_intro_5
	WaitButton
	GoTo _cv_gline_211
_cv_next_231:
	CompareVarToValue 0x5056, 6
	GoToIfNe _cv_next_232
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_gym_intro_6
	WaitButton
	GoTo _cv_gline_211
_cv_next_232:
	CompareVarToValue 0x5056, 7
	GoToIfNe _cv_next_233
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_gym_intro_7
	WaitButton
	GoTo _cv_gline_211
_cv_next_233:
	CompareVarToValue 0x5056, 8
	GoToIfNe _cv_next_234
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_gym_intro_8
	WaitButton
	GoTo _cv_gline_211
_cv_next_234:
	CompareVarToValue 0x5056, 9
	GoToIfNe _cv_next_235
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_gym_intro_9
	WaitButton
	GoTo _cv_gline_211
_cv_next_235:
_cv_gline_211:
	CanvasCloseMsg
	CanvasCloseMsg
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_gbattle_237
	CompareVarToValue 0x505A, 0
	GoToIfNe _cv_gbattle_238
	CompareVarToValue 0x5057, 0
	GoToIfNe _cv_gbattle_238
	ClearTrainerFlag 1477
	TrainerBattle 1477, 0, 1, 0
	GoTo _cv_gbattle_236
_cv_gbattle_238:
	CompareVarToValue 0x505A, 0
	GoToIfNe _cv_gbattle_239
	CompareVarToValue 0x5057, 1
	GoToIfNe _cv_gbattle_239
	ClearTrainerFlag 1478
	TrainerBattle 1478, 0, 1, 0
	GoTo _cv_gbattle_236
_cv_gbattle_239:
	CompareVarToValue 0x505A, 0
	GoToIfNe _cv_gbattle_240
	CompareVarToValue 0x5057, 2
	GoToIfNe _cv_gbattle_240
	ClearTrainerFlag 1479
	TrainerBattle 1479, 0, 1, 0
	GoTo _cv_gbattle_236
_cv_gbattle_240:
	CompareVarToValue 0x505A, 0
	GoToIfNe _cv_gbattle_241
	CompareVarToValue 0x5057, 3
	GoToIfNe _cv_gbattle_241
	ClearTrainerFlag 1480
	TrainerBattle 1480, 0, 1, 0
	GoTo _cv_gbattle_236
_cv_gbattle_241:
	CompareVarToValue 0x505A, 0
	GoToIfNe _cv_gbattle_242
	CompareVarToValue 0x5057, 4
	GoToIfNe _cv_gbattle_242
	ClearTrainerFlag 1481
	TrainerBattle 1481, 0, 1, 0
	GoTo _cv_gbattle_236
_cv_gbattle_242:
	CompareVarToValue 0x505A, 0
	GoToIfNe _cv_gbattle_243
	CompareVarToValue 0x5057, 5
	GoToIfNe _cv_gbattle_243
	ClearTrainerFlag 1482
	TrainerBattle 1482, 0, 1, 0
	GoTo _cv_gbattle_236
_cv_gbattle_243:
	CompareVarToValue 0x505A, 1
	GoToIfNe _cv_gbattle_244
	CompareVarToValue 0x5057, 0
	GoToIfNe _cv_gbattle_244
	ClearTrainerFlag 1483
	TrainerBattle 1483, 1483, 1, 0
	GoTo _cv_gbattle_236
_cv_gbattle_244:
	CompareVarToValue 0x505A, 1
	GoToIfNe _cv_gbattle_245
	CompareVarToValue 0x5057, 1
	GoToIfNe _cv_gbattle_245
	ClearTrainerFlag 1484
	TrainerBattle 1484, 1484, 1, 0
	GoTo _cv_gbattle_236
_cv_gbattle_245:
	CompareVarToValue 0x505A, 1
	GoToIfNe _cv_gbattle_246
	CompareVarToValue 0x5057, 2
	GoToIfNe _cv_gbattle_246
	ClearTrainerFlag 1485
	TrainerBattle 1485, 1485, 1, 0
	GoTo _cv_gbattle_236
_cv_gbattle_246:
	CompareVarToValue 0x505A, 1
	GoToIfNe _cv_gbattle_247
	CompareVarToValue 0x5057, 3
	GoToIfNe _cv_gbattle_247
	ClearTrainerFlag 1486
	TrainerBattle 1486, 1486, 1, 0
	GoTo _cv_gbattle_236
_cv_gbattle_247:
	CompareVarToValue 0x505A, 1
	GoToIfNe _cv_gbattle_248
	CompareVarToValue 0x5057, 4
	GoToIfNe _cv_gbattle_248
	ClearTrainerFlag 1487
	TrainerBattle 1487, 1487, 1, 0
	GoTo _cv_gbattle_236
_cv_gbattle_248:
	CompareVarToValue 0x505A, 1
	GoToIfNe _cv_gbattle_249
	CompareVarToValue 0x5057, 5
	GoToIfNe _cv_gbattle_249
	ClearTrainerFlag 1488
	TrainerBattle 1488, 1488, 1, 0
	GoTo _cv_gbattle_236
_cv_gbattle_249:
	GoTo _cv_gbattle_236
_cv_gbattle_237:
	CompareVarToValue 0x5053, 0
	GoToIfNe _cv_next_250
	ClearTrainerFlag 1150
	TrainerBattle 1150, 0, 1, 0
	GoTo _cv_gbattle_236
_cv_next_250:
	CompareVarToValue 0x5053, 1
	GoToIfNe _cv_next_251
	ClearTrainerFlag 1151
	TrainerBattle 1151, 0, 1, 0
	GoTo _cv_gbattle_236
_cv_next_251:
	CompareVarToValue 0x5053, 2
	GoToIfNe _cv_next_252
	ClearTrainerFlag 1152
	TrainerBattle 1152, 0, 1, 0
	GoTo _cv_gbattle_236
_cv_next_252:
	CompareVarToValue 0x5053, 3
	GoToIfNe _cv_next_253
	ClearTrainerFlag 1153
	TrainerBattle 1153, 0, 1, 0
	GoTo _cv_gbattle_236
_cv_next_253:
	CompareVarToValue 0x5053, 4
	GoToIfNe _cv_next_254
	ClearTrainerFlag 1154
	TrainerBattle 1154, 1154, 1, 0
	GoTo _cv_gbattle_236
_cv_next_254:
	CompareVarToValue 0x5053, 5
	GoToIfNe _cv_next_255
	ClearTrainerFlag 1156
	TrainerBattle 1156, 1156, 1, 0
	GoTo _cv_gbattle_236
_cv_next_255:
	CompareVarToValue 0x5053, 6
	GoToIfNe _cv_next_256
	ClearTrainerFlag 1155
	TrainerBattle 1155, 0, 1, 0
	GoTo _cv_gbattle_236
_cv_next_256:
	CompareVarToValue 0x5053, 8
	GoToIfNe _cv_next_257
	ClearTrainerFlag 1146
	TrainerBattle 1146, 1146, 1, 0
	GoTo _cv_gbattle_236
_cv_next_257:
	CompareVarToValue 0x5053, 9
	GoToIfNe _cv_next_258
	ClearTrainerFlag 1147
	TrainerBattle 1147, 0, 1, 0
	GoTo _cv_gbattle_236
_cv_next_258:
	CompareVarToValue 0x5053, 10
	GoToIfNe _cv_next_259
	ClearTrainerFlag 1148
	TrainerBattle 1148, 1148, 1, 0
	GoTo _cv_gbattle_236
_cv_next_259:
	CompareVarToValue 0x5053, 11
	GoToIfNe _cv_next_260
	ClearTrainerFlag 1149
	TrainerBattle 1149, 1149, 1, 0
	GoTo _cv_gbattle_236
_cv_next_260:
_cv_gbattle_236:
	CheckBattleWon VAR_SPECIAL_RESULT
	CanvasCandidate 12
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
	GoToIfEq _cv_yes_261
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_262
_cv_yes_261:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_262:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymPractice_EventScript_NotNow
	// TODO(gba) special GymChallenge_GeneratePractice
	GoTo _cv_stop
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymPractice_Text_Go
	WaitButton
	CanvasCloseMsg
	ClearTrainerFlag 1442
	SetFlag 0x2036
	CanvasCloseMsg
	TrainerBattle 1442, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_264
	WhiteOut
	End
_cv_won_264:
	SetTrainerFlag 1442
	ClearFlag 0x2036
	CanvasCandidate 12
	HealParty
	GetStaticEncounterOutcome VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfNe _cv_outcome_265
	SetVar VAR_SPECIAL_RESULT, 7
	GoTo _cv_outcome_266
_cv_outcome_265:
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfNe _cv_outcome_266
	SetVar VAR_SPECIAL_RESULT, 4
_cv_outcome_266:
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
	GoToIfEq _cv_yes_267
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_268
_cv_yes_267:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_268:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Gauntlet_EventScript_Withdraw
	GoTo Gauntlet_EventScript_PilotMenu
	
Gauntlet_EventScript_AllBeaten:
	GoToIfSet 0x2038, Gauntlet_EventScript_BillAgain
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_ReadyToMeet
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_269
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_270
_cv_yes_269:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_270:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Gauntlet_EventScript_NotYet
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Reveal1
	WaitButton
	CanvasCloseMsg
	Wait 30, VAR_SPECIAL_RESULT
	FadeScreen 6, 1, 0, RGB_WHITE
	WaitFade
	// TODO(gba) special Gauntlet_RevealBill
	GoTo _cv_stop
	HidePerson 17
	SetFlag 0x2035
	GoToIfUnset 0x2035, _cv_show_271
	ClearFlag 0x2035
	ShowPerson 17
	SetFlag 0x2035
	GoTo _cv_shown_272
_cv_show_271:
	ShowPerson 17
_cv_shown_272:
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
	GoToIfLt _cv_menu_274
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_274:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Tourney_EventScript_Enter
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Tourney_EventScript_LastResults
	GoTo Tourney_EventScript_NotNow
	
GymChallenge_EventScript_Statue:
	LockAll
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x2008, _cv_open_275
	SetVar VAR_SPECIAL_RESULT, 1
_cv_open_275:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymChallenge_EventScript_StatueNoLeader
	BufferInt 0, 0x504D
	BufferInt 1, 0x504E
	BufferInt 2, 0x504F
	BufferInt 3, 0x5050
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_StatueLeader
	WaitButton
	CopyVar VAR_SPECIAL_RESULT, 0x505B
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymChallenge_EventScript_StatueUnbeaten
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_277
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_normal
	GoTo _cv_done_276
_cv_next_277:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_278
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_fighting
	GoTo _cv_done_276
_cv_next_278:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_279
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_flying
	GoTo _cv_done_276
_cv_next_279:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_280
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_poison
	GoTo _cv_done_276
_cv_next_280:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_281
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_ground
	GoTo _cv_done_276
_cv_next_281:
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_282
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_rock
	GoTo _cv_done_276
_cv_next_282:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_283
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_bug
	GoTo _cv_done_276
_cv_next_283:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_284
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_ghost
	GoTo _cv_done_276
_cv_next_284:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_285
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_steel
	GoTo _cv_done_276
_cv_next_285:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_286
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_fire
	GoTo _cv_done_276
_cv_next_286:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_287
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_water
	GoTo _cv_done_276
_cv_next_287:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_288
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_grass
	GoTo _cv_done_276
_cv_next_288:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_289
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_electric
	GoTo _cv_done_276
_cv_next_289:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_290
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_psychic
	GoTo _cv_done_276
_cv_next_290:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_291
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_ice
	GoTo _cv_done_276
_cv_next_291:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_292
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_dragon
	GoTo _cv_done_276
_cv_next_292:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_293
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_dark
	GoTo _cv_done_276
_cv_next_293:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_294
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_fairy
	GoTo _cv_done_276
_cv_next_294:
_cv_done_276:
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_StatueVictors
	WaitButton
	CopyVar VAR_SPECIAL_RESULT, 0x505B
	CompareVarToValue 0x505B, 1
	GoToIfLt _cv_victors_295
	CompareVarToValue 0x505C, 100
	GoToIfGe _cv_victor_296
	CompareVarToValue 0x505C, 0
	GoToIfNe _cv_next_299
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_0
	GoTo _cv_done_298
_cv_next_299:
	CompareVarToValue 0x505C, 1
	GoToIfNe _cv_next_300
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_1
	GoTo _cv_done_298
_cv_next_300:
	CompareVarToValue 0x505C, 2
	GoToIfNe _cv_next_301
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_2
	GoTo _cv_done_298
_cv_next_301:
	CompareVarToValue 0x505C, 3
	GoToIfNe _cv_next_302
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_3
	GoTo _cv_done_298
_cv_next_302:
	CompareVarToValue 0x505C, 4
	GoToIfNe _cv_next_303
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_4
	GoTo _cv_done_298
_cv_next_303:
	CompareVarToValue 0x505C, 5
	GoToIfNe _cv_next_304
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_5
	GoTo _cv_done_298
_cv_next_304:
	CompareVarToValue 0x505C, 6
	GoToIfNe _cv_next_305
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_6
	GoTo _cv_done_298
_cv_next_305:
	CompareVarToValue 0x505C, 7
	GoToIfNe _cv_next_306
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_7
	GoTo _cv_done_298
_cv_next_306:
	CompareVarToValue 0x505C, 8
	GoToIfNe _cv_next_307
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_8
	GoTo _cv_done_298
_cv_next_307:
	CompareVarToValue 0x505C, 9
	GoToIfNe _cv_next_308
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_9
	GoTo _cv_done_298
_cv_next_308:
	CompareVarToValue 0x505C, 10
	GoToIfNe _cv_next_309
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_10
	GoTo _cv_done_298
_cv_next_309:
	CompareVarToValue 0x505C, 11
	GoToIfNe _cv_next_310
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_11
	GoTo _cv_done_298
_cv_next_310:
	CompareVarToValue 0x505C, 12
	GoToIfNe _cv_next_311
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_12
	GoTo _cv_done_298
_cv_next_311:
	CompareVarToValue 0x505C, 13
	GoToIfNe _cv_next_312
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_13
	GoTo _cv_done_298
_cv_next_312:
	CompareVarToValue 0x505C, 14
	GoToIfNe _cv_next_313
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_14
	GoTo _cv_done_298
_cv_next_313:
	CompareVarToValue 0x505C, 15
	GoToIfNe _cv_next_314
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_15
	GoTo _cv_done_298
_cv_next_314:
	CompareVarToValue 0x505C, 16
	GoToIfNe _cv_next_315
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_16
	GoTo _cv_done_298
_cv_next_315:
	CompareVarToValue 0x505C, 17
	GoToIfNe _cv_next_316
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_17
	GoTo _cv_done_298
_cv_next_316:
	CompareVarToValue 0x505C, 18
	GoToIfNe _cv_next_317
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_18
	GoTo _cv_done_298
_cv_next_317:
	CompareVarToValue 0x505C, 19
	GoToIfNe _cv_next_318
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_19
	GoTo _cv_done_298
_cv_next_318:
	CompareVarToValue 0x505C, 20
	GoToIfNe _cv_next_319
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_20
	GoTo _cv_done_298
_cv_next_319:
	CompareVarToValue 0x505C, 21
	GoToIfNe _cv_next_320
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_21
	GoTo _cv_done_298
_cv_next_320:
_cv_done_298:
	CanvasCandidate 16, 1, 0x505D
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_statue_victor
	WaitButton
	GoTo _cv_victor_297
_cv_victor_296:
	CompareVarToValue 0x505C, 100
	GoToIfNe _cv_next_322
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_0
	GoTo _cv_done_321
_cv_next_322:
	CompareVarToValue 0x505C, 101
	GoToIfNe _cv_next_323
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_1
	GoTo _cv_done_321
_cv_next_323:
	CompareVarToValue 0x505C, 102
	GoToIfNe _cv_next_324
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_2
	GoTo _cv_done_321
_cv_next_324:
	CompareVarToValue 0x505C, 103
	GoToIfNe _cv_next_325
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_3
	GoTo _cv_done_321
_cv_next_325:
	CompareVarToValue 0x505C, 104
	GoToIfNe _cv_next_326
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_4
	GoTo _cv_done_321
_cv_next_326:
	CompareVarToValue 0x505C, 105
	GoToIfNe _cv_next_327
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_5
	GoTo _cv_done_321
_cv_next_327:
	CompareVarToValue 0x505C, 106
	GoToIfNe _cv_next_328
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_6
	GoTo _cv_done_321
_cv_next_328:
	CompareVarToValue 0x505C, 108
	GoToIfNe _cv_next_329
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_8
	GoTo _cv_done_321
_cv_next_329:
	CompareVarToValue 0x505C, 109
	GoToIfNe _cv_next_330
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_9
	GoTo _cv_done_321
_cv_next_330:
	CompareVarToValue 0x505C, 110
	GoToIfNe _cv_next_331
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_10
	GoTo _cv_done_321
_cv_next_331:
	CompareVarToValue 0x505C, 111
	GoToIfNe _cv_next_332
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_11
	GoTo _cv_done_321
_cv_next_332:
_cv_done_321:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_statue_famous
	WaitButton
_cv_victor_297:
	CompareVarToValue 0x505B, 2
	GoToIfLt _cv_victors_295
	CompareVarToValue 0x505E, 100
	GoToIfGe _cv_victor_333
	CompareVarToValue 0x505E, 0
	GoToIfNe _cv_next_336
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_0
	GoTo _cv_done_335
_cv_next_336:
	CompareVarToValue 0x505E, 1
	GoToIfNe _cv_next_337
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_1
	GoTo _cv_done_335
_cv_next_337:
	CompareVarToValue 0x505E, 2
	GoToIfNe _cv_next_338
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_2
	GoTo _cv_done_335
_cv_next_338:
	CompareVarToValue 0x505E, 3
	GoToIfNe _cv_next_339
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_3
	GoTo _cv_done_335
_cv_next_339:
	CompareVarToValue 0x505E, 4
	GoToIfNe _cv_next_340
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_4
	GoTo _cv_done_335
_cv_next_340:
	CompareVarToValue 0x505E, 5
	GoToIfNe _cv_next_341
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_5
	GoTo _cv_done_335
_cv_next_341:
	CompareVarToValue 0x505E, 6
	GoToIfNe _cv_next_342
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_6
	GoTo _cv_done_335
_cv_next_342:
	CompareVarToValue 0x505E, 7
	GoToIfNe _cv_next_343
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_7
	GoTo _cv_done_335
_cv_next_343:
	CompareVarToValue 0x505E, 8
	GoToIfNe _cv_next_344
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_8
	GoTo _cv_done_335
_cv_next_344:
	CompareVarToValue 0x505E, 9
	GoToIfNe _cv_next_345
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_9
	GoTo _cv_done_335
_cv_next_345:
	CompareVarToValue 0x505E, 10
	GoToIfNe _cv_next_346
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_10
	GoTo _cv_done_335
_cv_next_346:
	CompareVarToValue 0x505E, 11
	GoToIfNe _cv_next_347
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_11
	GoTo _cv_done_335
_cv_next_347:
	CompareVarToValue 0x505E, 12
	GoToIfNe _cv_next_348
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_12
	GoTo _cv_done_335
_cv_next_348:
	CompareVarToValue 0x505E, 13
	GoToIfNe _cv_next_349
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_13
	GoTo _cv_done_335
_cv_next_349:
	CompareVarToValue 0x505E, 14
	GoToIfNe _cv_next_350
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_14
	GoTo _cv_done_335
_cv_next_350:
	CompareVarToValue 0x505E, 15
	GoToIfNe _cv_next_351
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_15
	GoTo _cv_done_335
_cv_next_351:
	CompareVarToValue 0x505E, 16
	GoToIfNe _cv_next_352
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_16
	GoTo _cv_done_335
_cv_next_352:
	CompareVarToValue 0x505E, 17
	GoToIfNe _cv_next_353
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_17
	GoTo _cv_done_335
_cv_next_353:
	CompareVarToValue 0x505E, 18
	GoToIfNe _cv_next_354
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_18
	GoTo _cv_done_335
_cv_next_354:
	CompareVarToValue 0x505E, 19
	GoToIfNe _cv_next_355
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_19
	GoTo _cv_done_335
_cv_next_355:
	CompareVarToValue 0x505E, 20
	GoToIfNe _cv_next_356
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_20
	GoTo _cv_done_335
_cv_next_356:
	CompareVarToValue 0x505E, 21
	GoToIfNe _cv_next_357
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_21
	GoTo _cv_done_335
_cv_next_357:
_cv_done_335:
	CanvasCandidate 16, 1, 0x505F
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_statue_victor
	WaitButton
	GoTo _cv_victor_334
_cv_victor_333:
	CompareVarToValue 0x505E, 100
	GoToIfNe _cv_next_359
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_0
	GoTo _cv_done_358
_cv_next_359:
	CompareVarToValue 0x505E, 101
	GoToIfNe _cv_next_360
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_1
	GoTo _cv_done_358
_cv_next_360:
	CompareVarToValue 0x505E, 102
	GoToIfNe _cv_next_361
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_2
	GoTo _cv_done_358
_cv_next_361:
	CompareVarToValue 0x505E, 103
	GoToIfNe _cv_next_362
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_3
	GoTo _cv_done_358
_cv_next_362:
	CompareVarToValue 0x505E, 104
	GoToIfNe _cv_next_363
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_4
	GoTo _cv_done_358
_cv_next_363:
	CompareVarToValue 0x505E, 105
	GoToIfNe _cv_next_364
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_5
	GoTo _cv_done_358
_cv_next_364:
	CompareVarToValue 0x505E, 106
	GoToIfNe _cv_next_365
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_6
	GoTo _cv_done_358
_cv_next_365:
	CompareVarToValue 0x505E, 108
	GoToIfNe _cv_next_366
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_8
	GoTo _cv_done_358
_cv_next_366:
	CompareVarToValue 0x505E, 109
	GoToIfNe _cv_next_367
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_9
	GoTo _cv_done_358
_cv_next_367:
	CompareVarToValue 0x505E, 110
	GoToIfNe _cv_next_368
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_10
	GoTo _cv_done_358
_cv_next_368:
	CompareVarToValue 0x505E, 111
	GoToIfNe _cv_next_369
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_11
	GoTo _cv_done_358
_cv_next_369:
_cv_done_358:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_statue_famous
	WaitButton
_cv_victor_334:
	CompareVarToValue 0x505B, 3
	GoToIfLt _cv_victors_295
	CompareVarToValue 0x5060, 100
	GoToIfGe _cv_victor_370
	CompareVarToValue 0x5060, 0
	GoToIfNe _cv_next_373
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_0
	GoTo _cv_done_372
_cv_next_373:
	CompareVarToValue 0x5060, 1
	GoToIfNe _cv_next_374
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_1
	GoTo _cv_done_372
_cv_next_374:
	CompareVarToValue 0x5060, 2
	GoToIfNe _cv_next_375
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_2
	GoTo _cv_done_372
_cv_next_375:
	CompareVarToValue 0x5060, 3
	GoToIfNe _cv_next_376
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_3
	GoTo _cv_done_372
_cv_next_376:
	CompareVarToValue 0x5060, 4
	GoToIfNe _cv_next_377
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_4
	GoTo _cv_done_372
_cv_next_377:
	CompareVarToValue 0x5060, 5
	GoToIfNe _cv_next_378
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_5
	GoTo _cv_done_372
_cv_next_378:
	CompareVarToValue 0x5060, 6
	GoToIfNe _cv_next_379
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_6
	GoTo _cv_done_372
_cv_next_379:
	CompareVarToValue 0x5060, 7
	GoToIfNe _cv_next_380
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_7
	GoTo _cv_done_372
_cv_next_380:
	CompareVarToValue 0x5060, 8
	GoToIfNe _cv_next_381
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_8
	GoTo _cv_done_372
_cv_next_381:
	CompareVarToValue 0x5060, 9
	GoToIfNe _cv_next_382
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_9
	GoTo _cv_done_372
_cv_next_382:
	CompareVarToValue 0x5060, 10
	GoToIfNe _cv_next_383
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_10
	GoTo _cv_done_372
_cv_next_383:
	CompareVarToValue 0x5060, 11
	GoToIfNe _cv_next_384
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_11
	GoTo _cv_done_372
_cv_next_384:
	CompareVarToValue 0x5060, 12
	GoToIfNe _cv_next_385
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_12
	GoTo _cv_done_372
_cv_next_385:
	CompareVarToValue 0x5060, 13
	GoToIfNe _cv_next_386
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_13
	GoTo _cv_done_372
_cv_next_386:
	CompareVarToValue 0x5060, 14
	GoToIfNe _cv_next_387
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_14
	GoTo _cv_done_372
_cv_next_387:
	CompareVarToValue 0x5060, 15
	GoToIfNe _cv_next_388
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_15
	GoTo _cv_done_372
_cv_next_388:
	CompareVarToValue 0x5060, 16
	GoToIfNe _cv_next_389
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_16
	GoTo _cv_done_372
_cv_next_389:
	CompareVarToValue 0x5060, 17
	GoToIfNe _cv_next_390
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_17
	GoTo _cv_done_372
_cv_next_390:
	CompareVarToValue 0x5060, 18
	GoToIfNe _cv_next_391
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_18
	GoTo _cv_done_372
_cv_next_391:
	CompareVarToValue 0x5060, 19
	GoToIfNe _cv_next_392
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_19
	GoTo _cv_done_372
_cv_next_392:
	CompareVarToValue 0x5060, 20
	GoToIfNe _cv_next_393
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_20
	GoTo _cv_done_372
_cv_next_393:
	CompareVarToValue 0x5060, 21
	GoToIfNe _cv_next_394
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_21
	GoTo _cv_done_372
_cv_next_394:
_cv_done_372:
	CanvasCandidate 16, 1, 0x5061
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_statue_victor
	WaitButton
	GoTo _cv_victor_371
_cv_victor_370:
	CompareVarToValue 0x5060, 100
	GoToIfNe _cv_next_396
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_0
	GoTo _cv_done_395
_cv_next_396:
	CompareVarToValue 0x5060, 101
	GoToIfNe _cv_next_397
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_1
	GoTo _cv_done_395
_cv_next_397:
	CompareVarToValue 0x5060, 102
	GoToIfNe _cv_next_398
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_2
	GoTo _cv_done_395
_cv_next_398:
	CompareVarToValue 0x5060, 103
	GoToIfNe _cv_next_399
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_3
	GoTo _cv_done_395
_cv_next_399:
	CompareVarToValue 0x5060, 104
	GoToIfNe _cv_next_400
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_4
	GoTo _cv_done_395
_cv_next_400:
	CompareVarToValue 0x5060, 105
	GoToIfNe _cv_next_401
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_5
	GoTo _cv_done_395
_cv_next_401:
	CompareVarToValue 0x5060, 106
	GoToIfNe _cv_next_402
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_6
	GoTo _cv_done_395
_cv_next_402:
	CompareVarToValue 0x5060, 108
	GoToIfNe _cv_next_403
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_8
	GoTo _cv_done_395
_cv_next_403:
	CompareVarToValue 0x5060, 109
	GoToIfNe _cv_next_404
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_9
	GoTo _cv_done_395
_cv_next_404:
	CompareVarToValue 0x5060, 110
	GoToIfNe _cv_next_405
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_10
	GoTo _cv_done_395
_cv_next_405:
	CompareVarToValue 0x5060, 111
	GoToIfNe _cv_next_406
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_11
	GoTo _cv_done_395
_cv_next_406:
_cv_done_395:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_statue_famous
	WaitButton
_cv_victor_371:
	CompareVarToValue 0x505B, 4
	GoToIfLt _cv_victors_295
	CompareVarToValue 0x5062, 100
	GoToIfGe _cv_victor_407
	CompareVarToValue 0x5062, 0
	GoToIfNe _cv_next_410
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_0
	GoTo _cv_done_409
_cv_next_410:
	CompareVarToValue 0x5062, 1
	GoToIfNe _cv_next_411
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_1
	GoTo _cv_done_409
_cv_next_411:
	CompareVarToValue 0x5062, 2
	GoToIfNe _cv_next_412
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_2
	GoTo _cv_done_409
_cv_next_412:
	CompareVarToValue 0x5062, 3
	GoToIfNe _cv_next_413
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_3
	GoTo _cv_done_409
_cv_next_413:
	CompareVarToValue 0x5062, 4
	GoToIfNe _cv_next_414
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_4
	GoTo _cv_done_409
_cv_next_414:
	CompareVarToValue 0x5062, 5
	GoToIfNe _cv_next_415
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_5
	GoTo _cv_done_409
_cv_next_415:
	CompareVarToValue 0x5062, 6
	GoToIfNe _cv_next_416
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_6
	GoTo _cv_done_409
_cv_next_416:
	CompareVarToValue 0x5062, 7
	GoToIfNe _cv_next_417
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_7
	GoTo _cv_done_409
_cv_next_417:
	CompareVarToValue 0x5062, 8
	GoToIfNe _cv_next_418
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_8
	GoTo _cv_done_409
_cv_next_418:
	CompareVarToValue 0x5062, 9
	GoToIfNe _cv_next_419
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_9
	GoTo _cv_done_409
_cv_next_419:
	CompareVarToValue 0x5062, 10
	GoToIfNe _cv_next_420
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_10
	GoTo _cv_done_409
_cv_next_420:
	CompareVarToValue 0x5062, 11
	GoToIfNe _cv_next_421
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_11
	GoTo _cv_done_409
_cv_next_421:
	CompareVarToValue 0x5062, 12
	GoToIfNe _cv_next_422
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_12
	GoTo _cv_done_409
_cv_next_422:
	CompareVarToValue 0x5062, 13
	GoToIfNe _cv_next_423
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_13
	GoTo _cv_done_409
_cv_next_423:
	CompareVarToValue 0x5062, 14
	GoToIfNe _cv_next_424
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_14
	GoTo _cv_done_409
_cv_next_424:
	CompareVarToValue 0x5062, 15
	GoToIfNe _cv_next_425
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_15
	GoTo _cv_done_409
_cv_next_425:
	CompareVarToValue 0x5062, 16
	GoToIfNe _cv_next_426
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_16
	GoTo _cv_done_409
_cv_next_426:
	CompareVarToValue 0x5062, 17
	GoToIfNe _cv_next_427
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_17
	GoTo _cv_done_409
_cv_next_427:
	CompareVarToValue 0x5062, 18
	GoToIfNe _cv_next_428
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_18
	GoTo _cv_done_409
_cv_next_428:
	CompareVarToValue 0x5062, 19
	GoToIfNe _cv_next_429
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_19
	GoTo _cv_done_409
_cv_next_429:
	CompareVarToValue 0x5062, 20
	GoToIfNe _cv_next_430
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_20
	GoTo _cv_done_409
_cv_next_430:
	CompareVarToValue 0x5062, 21
	GoToIfNe _cv_next_431
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_21
	GoTo _cv_done_409
_cv_next_431:
_cv_done_409:
	CanvasCandidate 16, 1, 0x5063
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_statue_victor
	WaitButton
	GoTo _cv_victor_408
_cv_victor_407:
	CompareVarToValue 0x5062, 100
	GoToIfNe _cv_next_433
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_0
	GoTo _cv_done_432
_cv_next_433:
	CompareVarToValue 0x5062, 101
	GoToIfNe _cv_next_434
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_1
	GoTo _cv_done_432
_cv_next_434:
	CompareVarToValue 0x5062, 102
	GoToIfNe _cv_next_435
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_2
	GoTo _cv_done_432
_cv_next_435:
	CompareVarToValue 0x5062, 103
	GoToIfNe _cv_next_436
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_3
	GoTo _cv_done_432
_cv_next_436:
	CompareVarToValue 0x5062, 104
	GoToIfNe _cv_next_437
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_4
	GoTo _cv_done_432
_cv_next_437:
	CompareVarToValue 0x5062, 105
	GoToIfNe _cv_next_438
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_5
	GoTo _cv_done_432
_cv_next_438:
	CompareVarToValue 0x5062, 106
	GoToIfNe _cv_next_439
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_6
	GoTo _cv_done_432
_cv_next_439:
	CompareVarToValue 0x5062, 108
	GoToIfNe _cv_next_440
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_8
	GoTo _cv_done_432
_cv_next_440:
	CompareVarToValue 0x5062, 109
	GoToIfNe _cv_next_441
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_9
	GoTo _cv_done_432
_cv_next_441:
	CompareVarToValue 0x5062, 110
	GoToIfNe _cv_next_442
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_10
	GoTo _cv_done_432
_cv_next_442:
	CompareVarToValue 0x5062, 111
	GoToIfNe _cv_next_443
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_11
	GoTo _cv_done_432
_cv_next_443:
_cv_done_432:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_statue_famous
	WaitButton
_cv_victor_408:
_cv_victors_295:
	CloseMsg
	ReleaseAll
	End
	
GymDecor_EventScript_PCMenu:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_WhatToDo
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_Buy, 0
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_Sell, 1
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_Decorate, 2
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_PutAllAway, 3
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_LogOff, 4
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_445
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_445:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymDecor_EventScript_Buy
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymDecor_EventScript_Sell
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq GymDecor_EventScript_Decorate
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfEq GymDecor_EventScript_PutAllAway
	GoTo GymDecor_EventScript_LogOff
	CloseMsg
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
	GoToIfUnset 0x2026, _cv_dex_446
	SetVar VAR_SPECIAL_RESULT, 1
_cv_dex_446:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	CallIfEq EventScript_SetReadyTryGiveNationalDexScene
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
	CanvasCloseMsg
	Call GymLegend_EventScript_Arrives
	CanvasCloseMsg
	ApplyMovement 1, PalletTown_Gym_Movement_OakLeave
	WaitMovement
	HidePerson 1
	SetFlag 0x2034
	PlaySE SEQ_SE_DP_KAIDAN2
	SetFlag 0x2034
	ResetBGM
	CanvasCloseMsg
	ReleaseAll
	End
	
EventScript_GiveHotAirBalloon:
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x202C, _cv_has_447
	SetVar VAR_SPECIAL_RESULT, 1
_cv_has_447:
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
	CanvasCandidate 4, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymLegend_EventScript_RivalAppears
	CopyVar 0x401E, 0x8005
	CopyVar 0x401F, 0x8006
	MovePerson 2, 0x401E, 0x401F
	ClearFlag 0x2033
	GoToIfUnset 0x2033, _cv_show_448
	ClearFlag 0x2033
	ShowPerson 2
	SetFlag 0x2033
	GoTo _cv_shown_449
_cv_show_448:
	ShowPerson 2
_cv_shown_449:
	CanvasCandidate 5, 0x800A, 0
	WaitMovement
	CanvasCandidate 2, 0x800A
	Return
	
GymLegend_EventScript_RivalWalksOut:
	CanvasCloseMsg
	PlayBGM SEQ_GS_E_RIVAL2
	CanvasCandidate 6
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymLegend_EventScript_RivalVanishes
	CanvasCandidate 5, 0x800A, 1
	WaitMovement
	GoTo GymLegend_EventScript_RivalVanishes
	
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
	ScreenShake 0x8005, 0x8004, 0x8007, 0x8006
	PlaySE SEQ_SE_DP_SELECT
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymLegend_Text_LightsOut
	WaitButton
	CanvasCloseMsg
	ClearFlag 0x203A
	GoToIfUnset 0x203A, _cv_show_450
	ClearFlag 0x203A
	ShowPerson 16
	SetFlag 0x203A
	GoTo _cv_shown_451
_cv_show_450:
	ShowPerson 16
_cv_shown_451:
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
	CanvasCloseMsg
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
	CanvasCandidate 4, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_MentorAppears
	MovePerson 0x800A, 0x8005, 0x8006
	ClearFlag 0x2017
	ShowPerson 0x800A
	CanvasCandidate 5, 0x800A, 0
	WaitMovement
	CanvasCandidate 2, 0x800A
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
	CanvasCandidate 6
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_GuestLeaves
	CanvasCloseMsg
	CanvasCandidate 5, 0x800A, 1
	WaitMovement
	HidePerson 0x800A
	SetFlag 0x2017
	PlaySE SEQ_SE_DP_KAIDAN2
	CanvasCandidate 3
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
	CanvasCloseMsg
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
	CanvasCloseMsg
	SetVar 0x5004, 2
	SetFlag 0x2034
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	Warp MAP_PALLET_TOWN_REDS_HOUSE_1F, 0, 9, 6, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	CanvasCloseMsg
	ReleaseAll
	End
	
GymChallenge_EventScript_ItemClause:
	Call EventScript_GymHack_ShowTeamRuleMessage
	CanvasCloseMsg
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
	CanvasCandidate 17, 4, 0x8005, 0x8006
	Return
	
GymChallenge_EventScript_Won:
	CompareVarToValue 0x5052, 0
	GoToIfEq _cv_gline_453
	CompareVarToValue 0x5052, 3
	GoToIfEq _cv_gline_454
	CompareVarToValue 0x5053, 0
	GoToIfNe _cv_next_456
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_after_0
	WaitButton
	GoTo _cv_done_455
_cv_next_456:
	CompareVarToValue 0x5053, 1
	GoToIfNe _cv_next_457
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_after_1
	WaitButton
	GoTo _cv_done_455
_cv_next_457:
	CompareVarToValue 0x5053, 2
	GoToIfNe _cv_next_458
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_after_2
	WaitButton
	GoTo _cv_done_455
_cv_next_458:
	CompareVarToValue 0x5053, 3
	GoToIfNe _cv_next_459
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_after_3
	WaitButton
	GoTo _cv_done_455
_cv_next_459:
	CompareVarToValue 0x5053, 4
	GoToIfNe _cv_next_460
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_after_4
	WaitButton
	GoTo _cv_done_455
_cv_next_460:
	CompareVarToValue 0x5053, 5
	GoToIfNe _cv_next_461
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_after_5
	WaitButton
	GoTo _cv_done_455
_cv_next_461:
	CompareVarToValue 0x5053, 6
	GoToIfNe _cv_next_462
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_after_6
	WaitButton
	GoTo _cv_done_455
_cv_next_462:
	CompareVarToValue 0x5053, 8
	GoToIfNe _cv_next_463
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_after_8
	WaitButton
	GoTo _cv_done_455
_cv_next_463:
	CompareVarToValue 0x5053, 9
	GoToIfNe _cv_next_464
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_after_9
	WaitButton
	GoTo _cv_done_455
_cv_next_464:
	CompareVarToValue 0x5053, 10
	GoToIfNe _cv_next_465
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_after_10
	WaitButton
	GoTo _cv_done_455
_cv_next_465:
	CompareVarToValue 0x5053, 11
	GoToIfNe _cv_next_466
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_after_11
	WaitButton
	GoTo _cv_done_455
_cv_next_466:
_cv_done_455:
	GoTo _cv_gline_452
_cv_gline_454:
	BufferTypeName 1, 0x5019
	CopyVar 0x401E, 0x504D
	BufferInt 2, 0x401E
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_boss_after
	WaitButton
	GoTo _cv_gline_452
_cv_gline_453:
	CompareVarToValue 0x5058, 0
	GoToIfNe _cv_next_467
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_gym_after_0
	WaitButton
	GoTo _cv_gline_452
_cv_next_467:
	CompareVarToValue 0x5058, 1
	GoToIfNe _cv_next_468
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_gym_after_1
	WaitButton
	GoTo _cv_gline_452
_cv_next_468:
	CompareVarToValue 0x5058, 2
	GoToIfNe _cv_next_469
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_gym_after_2
	WaitButton
	GoTo _cv_gline_452
_cv_next_469:
	CompareVarToValue 0x5058, 3
	GoToIfNe _cv_next_470
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_gym_after_3
	WaitButton
	GoTo _cv_gline_452
_cv_next_470:
_cv_gline_452:
	Call GymChallenge_EventScript_ChallengerLeaves
	AddVar 0x504D, 1
	AddVar 0x504F, 1
	AddVar 0x5051, 1
	CompareVarToValue 0x5051, 7
	GoToIfLt _cv_win_471
	SetVar 0x5051, 0
_cv_win_471:
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToVar 0x504D, 0x504E
	GoToIfLe _cv_win_472
	SetVar VAR_SPECIAL_RESULT, 1
	CopyVar 0x504E, 0x504D
_cv_win_472:
	CompareVarToValue 0x504D, 40
	GoToIfGt _cv_prize_513
	CompareVarToValue 0x504D, 1
	GoToIfNe _cv_next_516
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_473
	AddMoney 2200
	SetVar 0x401E, 2200
	GoTo _cv_prize_473_d
_cv_prize_473:
	AddMoney 4400
	SetVar 0x401E, 4400
_cv_prize_473_d:
	GoTo _cv_prize_514
_cv_next_516:
	CompareVarToValue 0x504D, 2
	GoToIfNe _cv_next_517
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_474
	AddMoney 2400
	SetVar 0x401E, 2400
	GoTo _cv_prize_474_d
_cv_prize_474:
	AddMoney 4800
	SetVar 0x401E, 4800
_cv_prize_474_d:
	GoTo _cv_prize_514
_cv_next_517:
	CompareVarToValue 0x504D, 3
	GoToIfNe _cv_next_518
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_475
	AddMoney 2600
	SetVar 0x401E, 2600
	GoTo _cv_prize_475_d
_cv_prize_475:
	AddMoney 5200
	SetVar 0x401E, 5200
_cv_prize_475_d:
	GoTo _cv_prize_514
_cv_next_518:
	CompareVarToValue 0x504D, 4
	GoToIfNe _cv_next_519
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_476
	AddMoney 2800
	SetVar 0x401E, 2800
	GoTo _cv_prize_476_d
_cv_prize_476:
	AddMoney 5600
	SetVar 0x401E, 5600
_cv_prize_476_d:
	GoTo _cv_prize_514
_cv_next_519:
	CompareVarToValue 0x504D, 5
	GoToIfNe _cv_next_520
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_477
	AddMoney 3000
	SetVar 0x401E, 3000
	GoTo _cv_prize_477_d
_cv_prize_477:
	AddMoney 6000
	SetVar 0x401E, 6000
_cv_prize_477_d:
	GoTo _cv_prize_514
_cv_next_520:
	CompareVarToValue 0x504D, 6
	GoToIfNe _cv_next_521
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_478
	AddMoney 3200
	SetVar 0x401E, 3200
	GoTo _cv_prize_478_d
_cv_prize_478:
	AddMoney 6400
	SetVar 0x401E, 6400
_cv_prize_478_d:
	GoTo _cv_prize_514
_cv_next_521:
	CompareVarToValue 0x504D, 7
	GoToIfNe _cv_next_522
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_479
	AddMoney 3400
	SetVar 0x401E, 3400
	GoTo _cv_prize_479_d
_cv_prize_479:
	AddMoney 6800
	SetVar 0x401E, 6800
_cv_prize_479_d:
	GoTo _cv_prize_514
_cv_next_522:
	CompareVarToValue 0x504D, 8
	GoToIfNe _cv_next_523
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_480
	AddMoney 3600
	SetVar 0x401E, 3600
	GoTo _cv_prize_480_d
_cv_prize_480:
	AddMoney 7200
	SetVar 0x401E, 7200
_cv_prize_480_d:
	GoTo _cv_prize_514
_cv_next_523:
	CompareVarToValue 0x504D, 9
	GoToIfNe _cv_next_524
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_481
	AddMoney 3800
	SetVar 0x401E, 3800
	GoTo _cv_prize_481_d
_cv_prize_481:
	AddMoney 7600
	SetVar 0x401E, 7600
_cv_prize_481_d:
	GoTo _cv_prize_514
_cv_next_524:
	CompareVarToValue 0x504D, 10
	GoToIfNe _cv_next_525
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_482
	AddMoney 4000
	SetVar 0x401E, 4000
	GoTo _cv_prize_482_d
_cv_prize_482:
	AddMoney 8000
	SetVar 0x401E, 8000
_cv_prize_482_d:
	GoTo _cv_prize_514
_cv_next_525:
	CompareVarToValue 0x504D, 11
	GoToIfNe _cv_next_526
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_483
	AddMoney 4200
	SetVar 0x401E, 4200
	GoTo _cv_prize_483_d
_cv_prize_483:
	AddMoney 8400
	SetVar 0x401E, 8400
_cv_prize_483_d:
	GoTo _cv_prize_514
_cv_next_526:
	CompareVarToValue 0x504D, 12
	GoToIfNe _cv_next_527
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_484
	AddMoney 4400
	SetVar 0x401E, 4400
	GoTo _cv_prize_484_d
_cv_prize_484:
	AddMoney 8800
	SetVar 0x401E, 8800
_cv_prize_484_d:
	GoTo _cv_prize_514
_cv_next_527:
	CompareVarToValue 0x504D, 13
	GoToIfNe _cv_next_528
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_485
	AddMoney 4600
	SetVar 0x401E, 4600
	GoTo _cv_prize_485_d
_cv_prize_485:
	AddMoney 9200
	SetVar 0x401E, 9200
_cv_prize_485_d:
	GoTo _cv_prize_514
_cv_next_528:
	CompareVarToValue 0x504D, 14
	GoToIfNe _cv_next_529
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_486
	AddMoney 4800
	SetVar 0x401E, 4800
	GoTo _cv_prize_486_d
_cv_prize_486:
	AddMoney 9600
	SetVar 0x401E, 9600
_cv_prize_486_d:
	GoTo _cv_prize_514
_cv_next_529:
	CompareVarToValue 0x504D, 15
	GoToIfNe _cv_next_530
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_487
	AddMoney 5000
	SetVar 0x401E, 5000
	GoTo _cv_prize_487_d
_cv_prize_487:
	AddMoney 10000
	SetVar 0x401E, 10000
_cv_prize_487_d:
	GoTo _cv_prize_514
_cv_next_530:
	CompareVarToValue 0x504D, 16
	GoToIfNe _cv_next_531
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_488
	AddMoney 5200
	SetVar 0x401E, 5200
	GoTo _cv_prize_488_d
_cv_prize_488:
	AddMoney 10400
	SetVar 0x401E, 10400
_cv_prize_488_d:
	GoTo _cv_prize_514
_cv_next_531:
	CompareVarToValue 0x504D, 17
	GoToIfNe _cv_next_532
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_489
	AddMoney 5400
	SetVar 0x401E, 5400
	GoTo _cv_prize_489_d
_cv_prize_489:
	AddMoney 10800
	SetVar 0x401E, 10800
_cv_prize_489_d:
	GoTo _cv_prize_514
_cv_next_532:
	CompareVarToValue 0x504D, 18
	GoToIfNe _cv_next_533
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_490
	AddMoney 5600
	SetVar 0x401E, 5600
	GoTo _cv_prize_490_d
_cv_prize_490:
	AddMoney 11200
	SetVar 0x401E, 11200
_cv_prize_490_d:
	GoTo _cv_prize_514
_cv_next_533:
	CompareVarToValue 0x504D, 19
	GoToIfNe _cv_next_534
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_491
	AddMoney 5800
	SetVar 0x401E, 5800
	GoTo _cv_prize_491_d
_cv_prize_491:
	AddMoney 11600
	SetVar 0x401E, 11600
_cv_prize_491_d:
	GoTo _cv_prize_514
_cv_next_534:
	CompareVarToValue 0x504D, 20
	GoToIfNe _cv_next_535
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_492
	AddMoney 6000
	SetVar 0x401E, 6000
	GoTo _cv_prize_492_d
_cv_prize_492:
	AddMoney 12000
	SetVar 0x401E, 12000
_cv_prize_492_d:
	GoTo _cv_prize_514
_cv_next_535:
	CompareVarToValue 0x504D, 21
	GoToIfNe _cv_next_536
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_493
	AddMoney 6200
	SetVar 0x401E, 6200
	GoTo _cv_prize_493_d
_cv_prize_493:
	AddMoney 12400
	SetVar 0x401E, 12400
_cv_prize_493_d:
	GoTo _cv_prize_514
_cv_next_536:
	CompareVarToValue 0x504D, 22
	GoToIfNe _cv_next_537
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_494
	AddMoney 6400
	SetVar 0x401E, 6400
	GoTo _cv_prize_494_d
_cv_prize_494:
	AddMoney 12800
	SetVar 0x401E, 12800
_cv_prize_494_d:
	GoTo _cv_prize_514
_cv_next_537:
	CompareVarToValue 0x504D, 23
	GoToIfNe _cv_next_538
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_495
	AddMoney 6600
	SetVar 0x401E, 6600
	GoTo _cv_prize_495_d
_cv_prize_495:
	AddMoney 13200
	SetVar 0x401E, 13200
_cv_prize_495_d:
	GoTo _cv_prize_514
_cv_next_538:
	CompareVarToValue 0x504D, 24
	GoToIfNe _cv_next_539
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_496
	AddMoney 6800
	SetVar 0x401E, 6800
	GoTo _cv_prize_496_d
_cv_prize_496:
	AddMoney 13600
	SetVar 0x401E, 13600
_cv_prize_496_d:
	GoTo _cv_prize_514
_cv_next_539:
	CompareVarToValue 0x504D, 25
	GoToIfNe _cv_next_540
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_497
	AddMoney 7000
	SetVar 0x401E, 7000
	GoTo _cv_prize_497_d
_cv_prize_497:
	AddMoney 14000
	SetVar 0x401E, 14000
_cv_prize_497_d:
	GoTo _cv_prize_514
_cv_next_540:
	CompareVarToValue 0x504D, 26
	GoToIfNe _cv_next_541
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_498
	AddMoney 7200
	SetVar 0x401E, 7200
	GoTo _cv_prize_498_d
_cv_prize_498:
	AddMoney 14400
	SetVar 0x401E, 14400
_cv_prize_498_d:
	GoTo _cv_prize_514
_cv_next_541:
	CompareVarToValue 0x504D, 27
	GoToIfNe _cv_next_542
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_499
	AddMoney 7400
	SetVar 0x401E, 7400
	GoTo _cv_prize_499_d
_cv_prize_499:
	AddMoney 14800
	SetVar 0x401E, 14800
_cv_prize_499_d:
	GoTo _cv_prize_514
_cv_next_542:
	CompareVarToValue 0x504D, 28
	GoToIfNe _cv_next_543
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_500
	AddMoney 7600
	SetVar 0x401E, 7600
	GoTo _cv_prize_500_d
_cv_prize_500:
	AddMoney 15200
	SetVar 0x401E, 15200
_cv_prize_500_d:
	GoTo _cv_prize_514
_cv_next_543:
	CompareVarToValue 0x504D, 29
	GoToIfNe _cv_next_544
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_501
	AddMoney 7800
	SetVar 0x401E, 7800
	GoTo _cv_prize_501_d
_cv_prize_501:
	AddMoney 15600
	SetVar 0x401E, 15600
_cv_prize_501_d:
	GoTo _cv_prize_514
_cv_next_544:
	CompareVarToValue 0x504D, 30
	GoToIfNe _cv_next_545
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_502
	AddMoney 8000
	SetVar 0x401E, 8000
	GoTo _cv_prize_502_d
_cv_prize_502:
	AddMoney 16000
	SetVar 0x401E, 16000
_cv_prize_502_d:
	GoTo _cv_prize_514
_cv_next_545:
	CompareVarToValue 0x504D, 31
	GoToIfNe _cv_next_546
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_503
	AddMoney 8200
	SetVar 0x401E, 8200
	GoTo _cv_prize_503_d
_cv_prize_503:
	AddMoney 16400
	SetVar 0x401E, 16400
_cv_prize_503_d:
	GoTo _cv_prize_514
_cv_next_546:
	CompareVarToValue 0x504D, 32
	GoToIfNe _cv_next_547
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_504
	AddMoney 8400
	SetVar 0x401E, 8400
	GoTo _cv_prize_504_d
_cv_prize_504:
	AddMoney 16800
	SetVar 0x401E, 16800
_cv_prize_504_d:
	GoTo _cv_prize_514
_cv_next_547:
	CompareVarToValue 0x504D, 33
	GoToIfNe _cv_next_548
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_505
	AddMoney 8600
	SetVar 0x401E, 8600
	GoTo _cv_prize_505_d
_cv_prize_505:
	AddMoney 17200
	SetVar 0x401E, 17200
_cv_prize_505_d:
	GoTo _cv_prize_514
_cv_next_548:
	CompareVarToValue 0x504D, 34
	GoToIfNe _cv_next_549
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_506
	AddMoney 8800
	SetVar 0x401E, 8800
	GoTo _cv_prize_506_d
_cv_prize_506:
	AddMoney 17600
	SetVar 0x401E, 17600
_cv_prize_506_d:
	GoTo _cv_prize_514
_cv_next_549:
	CompareVarToValue 0x504D, 35
	GoToIfNe _cv_next_550
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_507
	AddMoney 9000
	SetVar 0x401E, 9000
	GoTo _cv_prize_507_d
_cv_prize_507:
	AddMoney 18000
	SetVar 0x401E, 18000
_cv_prize_507_d:
	GoTo _cv_prize_514
_cv_next_550:
	CompareVarToValue 0x504D, 36
	GoToIfNe _cv_next_551
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_508
	AddMoney 9200
	SetVar 0x401E, 9200
	GoTo _cv_prize_508_d
_cv_prize_508:
	AddMoney 18400
	SetVar 0x401E, 18400
_cv_prize_508_d:
	GoTo _cv_prize_514
_cv_next_551:
	CompareVarToValue 0x504D, 37
	GoToIfNe _cv_next_552
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_509
	AddMoney 9400
	SetVar 0x401E, 9400
	GoTo _cv_prize_509_d
_cv_prize_509:
	AddMoney 18800
	SetVar 0x401E, 18800
_cv_prize_509_d:
	GoTo _cv_prize_514
_cv_next_552:
	CompareVarToValue 0x504D, 38
	GoToIfNe _cv_next_553
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_510
	AddMoney 9600
	SetVar 0x401E, 9600
	GoTo _cv_prize_510_d
_cv_prize_510:
	AddMoney 19200
	SetVar 0x401E, 19200
_cv_prize_510_d:
	GoTo _cv_prize_514
_cv_next_553:
	CompareVarToValue 0x504D, 39
	GoToIfNe _cv_next_554
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_511
	AddMoney 9800
	SetVar 0x401E, 9800
	GoTo _cv_prize_511_d
_cv_prize_511:
	AddMoney 19600
	SetVar 0x401E, 19600
_cv_prize_511_d:
	GoTo _cv_prize_514
_cv_next_554:
	CompareVarToValue 0x504D, 40
	GoToIfNe _cv_next_555
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_512
	AddMoney 10000
	SetVar 0x401E, 10000
	GoTo _cv_prize_512_d
_cv_prize_512:
	AddMoney 20000
	SetVar 0x401E, 20000
_cv_prize_512_d:
	GoTo _cv_prize_514
_cv_next_555:
_cv_prize_514:
	GoTo _cv_prize_515
_cv_prize_513:
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_513_2
	AddMoney 10000
	SetVar 0x401E, 10000
	GoTo _cv_prize_515
_cv_prize_513_2:
	AddMoney 20000
	SetVar 0x401E, 20000
_cv_prize_515:
	BufferInt 0, 0x401E
	BufferInt 1, 0x504D
	CompareVarToValue 0x5052, 0
	GoToIfEq _cv_gname_556
	CompareVarToValue 0x5053, 0
	GoToIfNe _cv_next_559
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_0
	GoTo _cv_done_558
_cv_next_559:
	CompareVarToValue 0x5053, 1
	GoToIfNe _cv_next_560
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_1
	GoTo _cv_done_558
_cv_next_560:
	CompareVarToValue 0x5053, 2
	GoToIfNe _cv_next_561
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_2
	GoTo _cv_done_558
_cv_next_561:
	CompareVarToValue 0x5053, 3
	GoToIfNe _cv_next_562
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_3
	GoTo _cv_done_558
_cv_next_562:
	CompareVarToValue 0x5053, 4
	GoToIfNe _cv_next_563
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_4
	GoTo _cv_done_558
_cv_next_563:
	CompareVarToValue 0x5053, 5
	GoToIfNe _cv_next_564
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_5
	GoTo _cv_done_558
_cv_next_564:
	CompareVarToValue 0x5053, 6
	GoToIfNe _cv_next_565
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_6
	GoTo _cv_done_558
_cv_next_565:
	CompareVarToValue 0x5053, 8
	GoToIfNe _cv_next_566
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_8
	GoTo _cv_done_558
_cv_next_566:
	CompareVarToValue 0x5053, 9
	GoToIfNe _cv_next_567
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_9
	GoTo _cv_done_558
_cv_next_567:
	CompareVarToValue 0x5053, 10
	GoToIfNe _cv_next_568
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_10
	GoTo _cv_done_558
_cv_next_568:
	CompareVarToValue 0x5053, 11
	GoToIfNe _cv_next_569
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_11
	GoTo _cv_done_558
_cv_next_569:
_cv_done_558:
	GoTo _cv_gname_557
_cv_gname_556:
	CanvasCandidate 16, 2, 0x5055
_cv_gname_557:
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_gift_570
	Random 0x401E, 16
	CompareVarToValue 0x401E, 0
	GoToIfEq _cv_gift_570
	GoTo _cv_gift_571
_cv_gift_570:
	Random 0x401E, 3
	CompareVarToValue 0x401E, 0
	GoToIfNe _cv_next_574
	SetVar 0x8009, 796
	GoTo _cv_done_573
_cv_next_574:
	CompareVarToValue 0x401E, 1
	GoToIfNe _cv_next_575
	SetVar 0x8009, 645
	GoTo _cv_done_573
_cv_next_575:
	CompareVarToValue 0x401E, 2
	GoToIfNe _cv_next_576
	SetVar 0x8009, ITEM_MASTER_BALL
	GoTo _cv_done_573
_cv_next_576:
_cv_done_573:
	GoTo _cv_gift_572
_cv_gift_571:
	Random 0x401E, 14
	CompareVarToValue 0x401E, 0
	GoToIfNe _cv_next_578
	SetVar 0x8009, ITEM_RARE_CANDY
	GoTo _cv_done_577
_cv_next_578:
	CompareVarToValue 0x401E, 1
	GoToIfNe _cv_next_579
	SetVar 0x8009, ITEM_RARE_CANDY
	GoTo _cv_done_577
_cv_next_579:
	CompareVarToValue 0x401E, 2
	GoToIfNe _cv_next_580
	SetVar 0x8009, ITEM_NUGGET
	GoTo _cv_done_577
_cv_next_580:
	CompareVarToValue 0x401E, 3
	GoToIfNe _cv_next_581
	SetVar 0x8009, ITEM_NUGGET
	GoTo _cv_done_577
_cv_next_581:
	CompareVarToValue 0x401E, 4
	GoToIfNe _cv_next_582
	SetVar 0x8009, ITEM_PP_UP
	GoTo _cv_done_577
_cv_next_582:
	CompareVarToValue 0x401E, 5
	GoToIfNe _cv_next_583
	SetVar 0x8009, ITEM_FULL_RESTORE
	GoTo _cv_done_577
_cv_next_583:
	CompareVarToValue 0x401E, 6
	GoToIfNe _cv_next_584
	SetVar 0x8009, ITEM_MAX_REVIVE
	GoTo _cv_done_577
_cv_next_584:
	CompareVarToValue 0x401E, 7
	GoToIfNe _cv_next_585
	SetVar 0x8009, ITEM_MAX_ELIXIR
	GoTo _cv_done_577
_cv_next_585:
	CompareVarToValue 0x401E, 8
	GoToIfNe _cv_next_586
	SetVar 0x8009, ITEM_HP_UP
	GoTo _cv_done_577
_cv_next_586:
	CompareVarToValue 0x401E, 9
	GoToIfNe _cv_next_587
	SetVar 0x8009, ITEM_PROTEIN
	GoTo _cv_done_577
_cv_next_587:
	CompareVarToValue 0x401E, 10
	GoToIfNe _cv_next_588
	SetVar 0x8009, ITEM_IRON
	GoTo _cv_done_577
_cv_next_588:
	CompareVarToValue 0x401E, 11
	GoToIfNe _cv_next_589
	SetVar 0x8009, ITEM_CALCIUM
	GoTo _cv_done_577
_cv_next_589:
	CompareVarToValue 0x401E, 12
	GoToIfNe _cv_next_590
	SetVar 0x8009, ITEM_ZINC
	GoTo _cv_done_577
_cv_next_590:
	CompareVarToValue 0x401E, 13
	GoToIfNe _cv_next_591
	SetVar 0x8009, ITEM_CARBOS
	GoTo _cv_done_577
_cv_next_591:
_cv_done_577:
_cv_gift_572:
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
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x5052, 3
	GoToIfNe _cv_mastered_592
	SetFlag 0x22E8
	BufferTypeName 0, 0x5019
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mastered_592:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq GymSwitch_EventScript_Mastered
	HealParty
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_KeepGoing
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_593
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_594
_cv_yes_593:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_594:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymChallenge_EventScript_KeepGoing
	BufferInt 0, 0x504D
	BufferInt 1, 0x504E
	BufferInt 2, 0x504F
	BufferInt 3, 0x5050
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_TakeABreak
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymChallenge_EventScript_Lost:
	HealParty
	CompareVarToValue 0x5052, 0
	GoToIfEq _cv_gline_596
	CompareVarToValue 0x5052, 3
	GoToIfEq _cv_gline_597
	CompareVarToValue 0x5053, 0
	GoToIfNe _cv_next_599
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_win_0
	WaitButton
	GoTo _cv_done_598
_cv_next_599:
	CompareVarToValue 0x5053, 1
	GoToIfNe _cv_next_600
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_win_1
	WaitButton
	GoTo _cv_done_598
_cv_next_600:
	CompareVarToValue 0x5053, 2
	GoToIfNe _cv_next_601
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_win_2
	WaitButton
	GoTo _cv_done_598
_cv_next_601:
	CompareVarToValue 0x5053, 3
	GoToIfNe _cv_next_602
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_win_3
	WaitButton
	GoTo _cv_done_598
_cv_next_602:
	CompareVarToValue 0x5053, 4
	GoToIfNe _cv_next_603
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_win_4
	WaitButton
	GoTo _cv_done_598
_cv_next_603:
	CompareVarToValue 0x5053, 5
	GoToIfNe _cv_next_604
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_win_5
	WaitButton
	GoTo _cv_done_598
_cv_next_604:
	CompareVarToValue 0x5053, 6
	GoToIfNe _cv_next_605
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_win_6
	WaitButton
	GoTo _cv_done_598
_cv_next_605:
	CompareVarToValue 0x5053, 8
	GoToIfNe _cv_next_606
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_win_8
	WaitButton
	GoTo _cv_done_598
_cv_next_606:
	CompareVarToValue 0x5053, 9
	GoToIfNe _cv_next_607
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_win_9
	WaitButton
	GoTo _cv_done_598
_cv_next_607:
	CompareVarToValue 0x5053, 10
	GoToIfNe _cv_next_608
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_win_10
	WaitButton
	GoTo _cv_done_598
_cv_next_608:
	CompareVarToValue 0x5053, 11
	GoToIfNe _cv_next_609
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_win_11
	WaitButton
	GoTo _cv_done_598
_cv_next_609:
_cv_done_598:
	GoTo _cv_gline_595
_cv_gline_597:
	BufferTypeName 1, 0x5019
	CopyVar 0x401E, 0x504D
	BufferInt 2, 0x401E
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_boss_win
	WaitButton
	GoTo _cv_gline_595
_cv_gline_596:
	CompareVarToValue 0x5059, 0
	GoToIfNe _cv_next_610
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_gym_win_0
	WaitButton
	GoTo _cv_gline_595
_cv_next_610:
	CompareVarToValue 0x5059, 1
	GoToIfNe _cv_next_611
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_gym_win_1
	WaitButton
	GoTo _cv_gline_595
_cv_next_611:
	CompareVarToValue 0x5059, 2
	GoToIfNe _cv_next_612
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_gym_win_2
	WaitButton
	GoTo _cv_gline_595
_cv_next_612:
	CompareVarToValue 0x5059, 3
	GoToIfNe _cv_next_613
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_gym_win_3
	WaitButton
	GoTo _cv_gline_595
_cv_next_613:
_cv_gline_595:
	AddVar 0x5050, 1
	CopyVar 0x5062, 0x5060
	CopyVar 0x5063, 0x5061
	CopyVar 0x5060, 0x505E
	CopyVar 0x5061, 0x505F
	CopyVar 0x505E, 0x505C
	CopyVar 0x505F, 0x505D
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_loss_614
	CopyVar 0x505C, 0x5054
	CopyVar 0x505D, 0x5055
	GoTo _cv_loss_615
_cv_loss_614:
	CopyVar 0x505C, 0x5053
	AddVar 0x505C, 100
_cv_loss_615:
	CompareVarToValue 0x505B, 4
	GoToIfGe _cv_loss_615_full
	AddVar 0x505B, 1
_cv_loss_615_full:
	BufferInt 0, 0x504D
	BufferInt 1, 0x504E
	CompareVarToValue 0x5052, 0
	GoToIfEq _cv_gname_616
	CompareVarToValue 0x5053, 0
	GoToIfNe _cv_next_619
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_0
	GoTo _cv_done_618
_cv_next_619:
	CompareVarToValue 0x5053, 1
	GoToIfNe _cv_next_620
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_1
	GoTo _cv_done_618
_cv_next_620:
	CompareVarToValue 0x5053, 2
	GoToIfNe _cv_next_621
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_2
	GoTo _cv_done_618
_cv_next_621:
	CompareVarToValue 0x5053, 3
	GoToIfNe _cv_next_622
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_3
	GoTo _cv_done_618
_cv_next_622:
	CompareVarToValue 0x5053, 4
	GoToIfNe _cv_next_623
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_4
	GoTo _cv_done_618
_cv_next_623:
	CompareVarToValue 0x5053, 5
	GoToIfNe _cv_next_624
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_5
	GoTo _cv_done_618
_cv_next_624:
	CompareVarToValue 0x5053, 6
	GoToIfNe _cv_next_625
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_6
	GoTo _cv_done_618
_cv_next_625:
	CompareVarToValue 0x5053, 8
	GoToIfNe _cv_next_626
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_8
	GoTo _cv_done_618
_cv_next_626:
	CompareVarToValue 0x5053, 9
	GoToIfNe _cv_next_627
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_9
	GoTo _cv_done_618
_cv_next_627:
	CompareVarToValue 0x5053, 10
	GoToIfNe _cv_next_628
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_10
	GoTo _cv_done_618
_cv_next_628:
	CompareVarToValue 0x5053, 11
	GoToIfNe _cv_next_629
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_11
	GoTo _cv_done_618
_cv_next_629:
_cv_done_618:
	GoTo _cv_gname_617
_cv_gname_616:
	CanvasCandidate 16, 2, 0x5055
_cv_gname_617:
	CopyVar 0x5064, 0x504D
	SetVar 0x504D, 0
	SetVar 0x5051, 0
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_631
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_normal
	GoTo _cv_done_630
_cv_next_631:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_632
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_fighting
	GoTo _cv_done_630
_cv_next_632:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_633
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_flying
	GoTo _cv_done_630
_cv_next_633:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_634
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_poison
	GoTo _cv_done_630
_cv_next_634:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_635
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_ground
	GoTo _cv_done_630
_cv_next_635:
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_636
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_rock
	GoTo _cv_done_630
_cv_next_636:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_637
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_bug
	GoTo _cv_done_630
_cv_next_637:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_638
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_ghost
	GoTo _cv_done_630
_cv_next_638:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_639
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_steel
	GoTo _cv_done_630
_cv_next_639:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_640
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_fire
	GoTo _cv_done_630
_cv_next_640:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_641
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_water
	GoTo _cv_done_630
_cv_next_641:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_642
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_grass
	GoTo _cv_done_630
_cv_next_642:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_643
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_electric
	GoTo _cv_done_630
_cv_next_643:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_644
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_psychic
	GoTo _cv_done_630
_cv_next_644:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_645
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_ice
	GoTo _cv_done_630
_cv_next_645:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_646
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_dragon
	GoTo _cv_done_630
_cv_next_646:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_647
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_dark
	GoTo _cv_done_630
_cv_next_647:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_648
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_fairy
	GoTo _cv_done_630
_cv_next_648:
_cv_done_630:
	PlayFanfare SEQ_ME_BADGE
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_AwardBadge
	WaitButton
	WaitFanfare
	Call GymChallenge_EventScript_ChallengerLeaves
	BufferInt 0, 0x5064
	BufferInt 1, 0x504E
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_Lost
	WaitButton
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
	GoToIfLt _cv_menu_650
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_650:
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
	GoToIfEq _cv_yes_651
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_652
_cv_yes_651:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_652:
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
	GoToIfEq _cv_yes_653
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_654
_cv_yes_653:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_654:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Gauntlet_EventScript_BillWait
	GoTo Gauntlet_EventScript_BillBattle
	
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
	CanvasCloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special Gauntlet_ShowBillCard
	GoTo _cv_stop
	ClearTrainerFlag 1442
	SetFlag 0x2036
	CanvasCloseMsg
	TrainerBattle 1442, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_656
	WhiteOut
	End
_cv_won_656:
	SetTrainerFlag 1442
	ClearFlag 0x2036
	GetStaticEncounterOutcome VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfNe _cv_outcome_657
	SetVar VAR_SPECIAL_RESULT, 7
	GoTo _cv_outcome_658
_cv_outcome_657:
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfNe _cv_outcome_658
	SetVar VAR_SPECIAL_RESULT, 4
_cv_outcome_658:
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
	GoToIfLt _cv_menu_660
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_660:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Tourney_EventScript_Match
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Tourney_EventScript_Board
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq Tourney_EventScript_Forfeit
	GoTo Tourney_EventScript_NotNow
	
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
	GoToIfLt _cv_menu_662
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_662:
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
	GoToIfLt _cv_menu_664
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_664:
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
	GoTo Tourney_EventScript_Match
	
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
	
GymDecor_EventScript_Buy:
	SetVar 0x8007, 0
	ShowMoneyBox 20, 2
	GoTo GymDecor_EventScript_BuyCategory
	
GymDecor_EventScript_Sell:
	SetVar 0x8007, 0
	ShowMoneyBox 20, 2
	GoTo GymDecor_EventScript_SellCategory
	
GymDecor_EventScript_Decorate:
	// TODO(gba) special GymDecor_PushOwnedCategories
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymDecor_EventScript_NothingOwned
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_WhichKindToPlace
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_666
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_666:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq GymDecor_EventScript_PCMenu
	CopyVar 0x8006, VAR_SPECIAL_RESULT
	// TODO(gba) special GymDecor_PushOwnedList
	GoTo _cv_stop
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_WhichToPlace
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_668
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_668:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq GymDecor_EventScript_Decorate
	CopyVar 0x8004, VAR_SPECIAL_RESULT
	// TODO(gba) special GymDecor_GetKind
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfEq GymDecor_EventScript_SetWallStyle
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfEq GymDecor_EventScript_HowToPaint
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_HowToDecorate
	WaitButton
	GoTo GymDecor_EventScript_StartEditing
	
GymDecor_EventScript_PutAllAway:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_ConfirmPutAllAway
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_669
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_670
_cv_yes_669:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_670:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymDecor_EventScript_PCMenu
	// TODO(gba) special GymDecor_PutAllAway
	GoTo _cv_stop
	PlaySE SEQ_SE_DP_SELECT
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_AllPutAway
	WaitButton
	GoTo GymDecor_EventScript_PCMenu
	CloseMsg
	End
	
GymDecor_EventScript_LogOff:
	PlaySE SEQ_SE_DP_SELECT
	CanvasCloseMsg
	CanvasCloseMsg
	ReleaseAll
	End
	
EventScript_SetReadyTryGiveNationalDexScene:
	SetVar 0x5007, 2
	Return
	
GymLegend_EventScript_Arrives:
	Return
	
EventScript_PalmPilotReturn:
	Return
	
GymLegend_EventScript_RivalAppears:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	CanvasCandidate 1
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymLegend_EventScript_RivalNoRoom
	CopyVar 0x401E, 0x8005
	CopyVar 0x401F, 0x8006
	MovePerson 2, 0x401E, 0x401F
	ClearFlag 0x2033
	GoToIfUnset 0x2033, _cv_show_671
	ClearFlag 0x2033
	ShowPerson 2
	SetFlag 0x2033
	GoTo _cv_shown_672
_cv_show_671:
	ShowPerson 2
_cv_shown_672:
	CanvasCandidate 2, 0x800A
	GoTo GymLegend_EventScript_RivalNoRoom
	
GymLegend_EventScript_RivalVanishes:
	HidePerson 2
	SetFlag 0x2033
	PlaySE SEQ_SE_DP_KAIDAN2
	CanvasCandidate 3
	ResetBGM
	Return
	
GymLegend_EventScript_NoLegend:
	SetVar 0x5014, 4
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo GymLegend_EventScript_Return
	
GymCandidate_EventScript_MentorAppears:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	CanvasCandidate 1
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_MentorNoRoom
	MovePerson 0x800A, 0x8005, 0x8006
	ClearFlag 0x2017
	ShowPerson 0x800A
	CanvasCandidate 2, 0x800A
	GoTo GymCandidate_EventScript_MentorNoRoom
	
GymCandidate_EventScript_GuestLeaves:
	CanvasCloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	HidePerson 0x800A
	SetFlag 0x2017
	CanvasCandidate 3
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
	CanvasCloseMsg
	SetVar 0x5005, 4
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	CanvasHallOfFame
	RestoreOverworld
	SetVar 0x502E, 1
	Warp MAP_INDIGO_PLATEAU, 0, 978, 108, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	CanvasCloseMsg
	ReleaseAll
	End
	
GymFinale_EventScript_Badge:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_674
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_normal
	GoTo _cv_done_673
_cv_next_674:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_675
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_fighting
	GoTo _cv_done_673
_cv_next_675:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_676
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_flying
	GoTo _cv_done_673
_cv_next_676:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_677
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_poison
	GoTo _cv_done_673
_cv_next_677:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_678
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_ground
	GoTo _cv_done_673
_cv_next_678:
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_679
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_rock
	GoTo _cv_done_673
_cv_next_679:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_680
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_bug
	GoTo _cv_done_673
_cv_next_680:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_681
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_ghost
	GoTo _cv_done_673
_cv_next_681:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_682
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_steel
	GoTo _cv_done_673
_cv_next_682:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_683
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_fire
	GoTo _cv_done_673
_cv_next_683:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_684
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_water
	GoTo _cv_done_673
_cv_next_684:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_685
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_grass
	GoTo _cv_done_673
_cv_next_685:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_686
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_electric
	GoTo _cv_done_673
_cv_next_686:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_687
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_psychic
	GoTo _cv_done_673
_cv_next_687:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_688
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_ice
	GoTo _cv_done_673
_cv_next_688:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_689
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_dragon
	GoTo _cv_done_673
_cv_next_689:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_690
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_dark
	GoTo _cv_done_673
_cv_next_690:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_691
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_fairy
	GoTo _cv_done_673
_cv_next_691:
_cv_done_673:
	PlayFanfare SEQ_ME_BADGE
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_YourBadge
	WaitButton
	WaitFanfare
	Return
	
GymChallenge_EventScript_ChallengerLeaves:
	CanvasCloseMsg
	SetVar 0x8004, 1
	CompareVarToValue 0x8004, 1
	GoToIfEq _cv_cwalk_692
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	CanvasCandidate 4, 1
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_cwalk_693
	CanvasCandidate 17, 4, 0x8005, 0x8006
	GoTo _cv_cwalk_693
_cv_cwalk_692:
	CanvasCandidate 6
_cv_cwalk_693:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymChallenge_EventScript_ChallengerGone
	CompareVarToValue 0x8004, 1
	GoToIfEq _cv_capply_694
	CanvasCandidate 5, 4, 0
	WaitMovement
	CanvasCandidate 2, 4
	GoTo _cv_capply_695
_cv_capply_694:
	CanvasCandidate 5, 4, 1
	WaitMovement
_cv_capply_695:
	PlaySE SEQ_SE_DP_KAIDAN2
	GoTo GymChallenge_EventScript_ChallengerGone
	
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
	SetOrCopyVar 0x8004, 0x8009
	SetOrCopyVar 0x8005, 1
	HasSpaceForItem 0x8004, 0x8005, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_full_696
	CallStd std_give_item_verbose
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_given_697
_cv_full_696:
	SetVar VAR_SPECIAL_RESULT, 0
_cv_given_697:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymHack_EventScript_GiveStatItemDone
	BufferItemName 1, 0x8009
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymHack_Text_GiftSentToPC
	WaitButton
	GoTo GymHack_EventScript_GiveStatItemDone
	
GymSwitch_EventScript_Mastered:
	PlayFanfare SEQ_ME_ITEM
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymSwitch_Text_Mastered
	WaitButton
	WaitFanfare
	Return
	
GymChallenge_EventScript_KeepGoing:
	CanvasCloseMsg
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	GoTo GymChallenge_EventScript_NextChallenger
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
	GoToIfLt _cv_menu_699
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_699:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Gauntlet_EventScript_Withdraw
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Tourney_EventScript_Menu
	GoTo Gauntlet_EventScript_PilotOff
	
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
	CanvasCloseMsg
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
	GoToIfUnset 0x2035, _cv_show_700
	ClearFlag 0x2035
	ShowPerson 17
	SetFlag 0x2035
	GoTo _cv_shown_701
_cv_show_700:
	ShowPerson 17
_cv_shown_701:
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
	SetVar VAR_SPECIAL_RESULT, 1
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymChallenge_EventScript_CantReachSpot
	Call Tourney_EventScript_SayTakeYourPlace
	CanvasCloseMsg
	ApplyMovement obj_player, gGymChallengePlayerPath
	WaitMovement
	GoTo Tourney_EventScript_NextMatch
	
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
	CanvasCloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special Gauntlet_ShowBillCard
	GoTo _cv_stop
	ClearTrainerFlag 1442
	SetFlag 0x2036
	CanvasCloseMsg
	TrainerBattle 1442, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_703
	WhiteOut
	End
_cv_won_703:
	SetTrainerFlag 1442
	ClearFlag 0x2036
	GetStaticEncounterOutcome VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfNe _cv_outcome_704
	SetVar VAR_SPECIAL_RESULT, 7
	GoTo _cv_outcome_705
_cv_outcome_704:
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfNe _cv_outcome_705
	SetVar VAR_SPECIAL_RESULT, 4
_cv_outcome_705:
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
	GoToIfEq _cv_yes_706
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_707
_cv_yes_706:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_707:
	Return
	
Tourney_EventScript_BreaksClause:
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	CallIfEq Tourney_EventScript_SpeciesClause
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	CallIfEq Tourney_EventScript_ItemClause
	CanvasCloseMsg
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
	GoToIfLt _cv_menu_709
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_709:
	// TODO(gba) special Tourney_SetSimFormat
	GoTo _cv_stop
	CanvasCloseMsg
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
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_First
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_710
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_711
_cv_yes_710:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_711:
	Return
	
Tourney_EventScript_SayChampion:
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SayChampionSim
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Champion
	WaitButton
	Return
	
GymDecor_EventScript_BuyCategory:
	// TODO(gba) special GymDecor_PushShopCategories
	GoTo _cv_stop
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_WhichKind
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_713
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_713:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq GymDecor_EventScript_BuyDone
	CopyVar 0x8006, VAR_SPECIAL_RESULT
	CopyVar 0x8007, VAR_SPECIAL_RESULT
	SetVar 0x8005, 0
	GoTo GymDecor_EventScript_BuyLoop
	
GymDecor_EventScript_SellCategory:
	// TODO(gba) special GymDecor_PushSellCategories
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymDecor_EventScript_NothingToSell
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_WhichKindToSell
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_715
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_715:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq GymDecor_EventScript_SellDone
	CopyVar 0x8006, VAR_SPECIAL_RESULT
	CopyVar 0x8007, VAR_SPECIAL_RESULT
	SetVar 0x8005, 0
	GoTo GymDecor_EventScript_SellLoop
	
GymDecor_EventScript_NothingOwned:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_NothingOwned
	WaitButton
	GoTo GymDecor_EventScript_PCMenu
	CloseMsg
	End
	
GymDecor_EventScript_SetWallStyle:
	// TODO(gba) special GymDecor_ApplyWallStyle
	GoTo _cv_stop
	// TODO(gba) special GymDecor_BufferDecorInfo
	GoTo _cv_stop
	PlaySE SEQ_SE_DP_SELECT
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_WallsChanged
	WaitButton
	GoTo GymDecor_EventScript_PCMenu
	CloseMsg
	End
	
GymDecor_EventScript_HowToPaint:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_HowToPaint
	WaitButton
	GoTo GymDecor_EventScript_StartEditing
	CloseMsg
	End
	
GymDecor_EventScript_StartEditing:
	CanvasCloseMsg
	CanvasCloseMsg
	ReleaseAll
	// TODO(gba) special GymDecor_StartEditing
	GoTo _cv_stop
	End
	
GymLegend_EventScript_RivalNoRoom:
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	Return
	
GymLegend_EventScript_Return:
	Return
	
GymCandidate_EventScript_MentorNoRoom:
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	Return
	
EventScript_GymHack_MsgWrongType:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Text_GymHack_WrongType
	WaitButton
	Return
	
EventScript_GymHack_MsgDuplicate:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Text_GymHack_Duplicate
	WaitButton
	Return
	
EventScript_GymHack_MsgDuplicateItem:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Text_GymHack_DuplicateItem
	WaitButton
	Return
	
EventScript_SetDefeatedEliteFourFlagsVars:
	ClearFlag 0x203C
	Call EventScript_ResetEliteFour
	CompareVarToValue 0x5004, 0
	CallIfEq EventScript_GymHack_StartGymFinale
	CompareVarToValue 0x5004, 3
	CallIfEq EventScript_TryReadyNationalDexScene
	Call EventScript_ResetLegendaries
	Return
	
GymChallenge_EventScript_ChallengerGone:
	HidePerson 4
	SetFlag 0x2017
	SetFlag 0x2017
	Return
	
GymHack_EventScript_GiveStatItemDone:
	Return
	
Tourney_EventScript_SayNextSim:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimNext
	Return
	
Tourney_EventScript_WrongTeam:
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SimWrongTeam
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_WrongTeam
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Tourney_EventScript_SayTakeYourPlace:
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_Return
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_TakeYourPlace
	WaitButton
	GoTo Tourney_EventScript_Return
	
Tourney_EventScript_NextMatch:
	// TODO(gba) special Tourney_SetupNext
	GoTo _cv_stop
	Call Tourney_EventScript_SayAnnounce
	CanvasCloseMsg
	ClearFlag 0x2017
	GoToIfUnset 0x2017, _cv_show_716
	ClearFlag 0x2017
	ShowPerson 4
	SetFlag 0x2017
	GoTo _cv_shown_717
_cv_show_716:
	ShowPerson 4
_cv_shown_717:
	SetVar 0x8004, 0
	CompareVarToValue 0x8004, 1
	GoToIfEq _cv_cwalk_718
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	CanvasCandidate 4, 1
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_cwalk_719
	CanvasCandidate 17, 4, 0x8005, 0x8006
	GoTo _cv_cwalk_719
_cv_cwalk_718:
	CanvasCandidate 6
_cv_cwalk_719:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	CallIfEq GymChallenge_EventScript_ChallengerJumpsIn
	ApplyMovement 4, gGymChallengeChallengerPath
	WaitMovement
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_gGymChallengeIntroText
	WaitButton
	CanvasCloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special Tourney_ShowTitleCard
	GoTo _cv_stop
	ClearTrainerFlag 1442
	SetFlag 0x2036
	CanvasCloseMsg
	TrainerBattle 1442, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_721
	WhiteOut
	End
_cv_won_721:
	SetTrainerFlag 1442
	ClearFlag 0x2036
	GetStaticEncounterOutcome VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfNe _cv_outcome_722
	SetVar VAR_SPECIAL_RESULT, 7
	GoTo _cv_outcome_723
_cv_outcome_722:
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfNe _cv_outcome_723
	SetVar VAR_SPECIAL_RESULT, 4
_cv_outcome_723:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Tourney_EventScript_Won
	HealParty
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_gGymChallengeWinText
	WaitButton
	Call GymChallenge_EventScript_ChallengerLeaves
	// TODO(gba) special Tourney_RecordLoss
	GoTo _cv_stop
	Call Tourney_EventScript_SayLost
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special Tourney_ShowBoard
	GoTo _cv_stop
	// TODO(gba) special Tourney_BufferChampion
	GoTo _cv_stop
	Call Tourney_EventScript_SayChampion
	CloseMsg
	ReleaseAll
	End
	
Tourney_EventScript_SayForfeitAsk:
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SayForfeitAskSim
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_ForfeitAsk
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_724
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_725
_cv_yes_724:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_725:
	Return
	
Tourney_EventScript_SimForfeited:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimForfeited
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Tourney_EventScript_SimBillWon:
	// TODO(gba) special Tourney_SimBillWon
	GoTo _cv_stop
	PlayFanfare SEQ_ME_ITEM
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimComplete
	WaitFanfare
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_WithdrawAsk
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_726
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_727
_cv_yes_726:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_727:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Gauntlet_EventScript_Withdraw
	CloseMsg
	ReleaseAll
	End
	
Tourney_EventScript_SayRulesSim:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimStart
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_728
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_729
_cv_yes_728:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_729:
	Return
	
Tourney_EventScript_SpeciesClause:
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SimSpeciesClause
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SpeciesClause
	WaitButton
	Return
	
Tourney_EventScript_ItemClause:
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SimItemClause
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_ItemClause
	WaitButton
	Return
	
Tourney_EventScript_SayDrawSim:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimDraw
	WaitButton
	Return
	
Tourney_EventScript_SayFirstSim:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimFirst
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_730
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_731
_cv_yes_730:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_731:
	Return
	
Tourney_EventScript_SayChampionSim:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimChampion
	WaitButton
	Return
	
GymDecor_EventScript_BuyDone:
	HideMoneyBox
	GoTo GymDecor_EventScript_PCMenu
	End
	
GymDecor_EventScript_BuyLoop:
	// TODO(gba) special GymDecor_PushShopList
	GoTo _cv_stop
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_WhichToBuy
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_733
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_733:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq GymDecor_EventScript_BuyCategory
	CopyVar 0x8004, VAR_SPECIAL_RESULT
	CopyVar 0x8005, VAR_SPECIAL_RESULT
	SetVar 0x8009, 1
	// TODO(gba) special GymDecor_GetKind
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfGe GymDecor_EventScript_ConfirmBuy
	// TODO(gba) special GymDecor_BufferDecorInfo
	GoTo _cv_stop
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_HowMany
	// TODO(gba) special GymDecor_ChooseQuantity
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymDecor_EventScript_BuyLoop
	CopyVar 0x8009, VAR_SPECIAL_RESULT
	GoTo GymDecor_EventScript_ConfirmBuy
	
GymDecor_EventScript_NothingToSell:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_NothingToSell
	WaitButton
	GoTo GymDecor_EventScript_SellDone
	
GymDecor_EventScript_SellDone:
	HideMoneyBox
	GoTo GymDecor_EventScript_PCMenu
	End
	
GymDecor_EventScript_SellLoop:
	// TODO(gba) special GymDecor_PushSellList
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymDecor_EventScript_SellCategory
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_WhichToSell
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_735
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_735:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq GymDecor_EventScript_SellCategory
	CopyVar 0x8004, VAR_SPECIAL_RESULT
	CopyVar 0x8005, VAR_SPECIAL_RESULT
	SetVar 0x8009, 1
	// TODO(gba) special GymDecor_BufferSellInfo
	GoTo _cv_stop
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_HowManyToSell
	// TODO(gba) special GymDecor_ChooseSellQuantity
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymDecor_EventScript_SellLoop
	CopyVar 0x8009, VAR_SPECIAL_RESULT
	// TODO(gba) special GymDecor_BufferSellInfo
	GoTo _cv_stop
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_ConfirmSell
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_736
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_737
_cv_yes_736:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_737:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymDecor_EventScript_SellLoop
	// TODO(gba) special GymDecor_Sell
	GoTo _cv_stop
	UpdateMoneyBox
	PlaySE SEQ_SE_DP_SELECT
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_Sold
	WaitButton
	GoTo GymDecor_EventScript_SellLoop
	CloseMsg
	End
	
EventScript_ResetEliteFour:
	SetFlag FLAG_HIDE_WILLS_ROOM_RETREAT
	ClearFlag FLAG_HIDE_WILLS_ROOM_EXIT
	SetFlag FLAG_HIDE_KOGAS_ROOM_RETREAT
	ClearFlag FLAG_HIDE_KOGAS_ROOM_EXIT
	SetFlag FLAG_HIDE_BRUNOS_ROOM_RETREAT
	ClearFlag FLAG_HIDE_BRUNOS_ROOM_EXIT
	SetFlag FLAG_HIDE_KARENS_ROOM_RETREAT
	ClearFlag FLAG_HIDE_KARENS_ROOM_EXIT
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
	
Tourney_EventScript_SimWrongTeam:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimWrongTeam
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Tourney_EventScript_Return:
	Return
	
Tourney_EventScript_SayAnnounce:
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SayAnnounceSim
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Announce
	WaitButton
	Return
	
Tourney_EventScript_Won:
	HealParty
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_gGymChallengeAfterText
	WaitButton
	Call GymChallenge_EventScript_ChallengerLeaves
	// TODO(gba) special Tourney_RollPrize
	GoTo _cv_stop
	Call Tourney_EventScript_Prize
	// TODO(gba) special Tourney_RecordWin
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Tourney_EventScript_Title
	Call Tourney_EventScript_SayWon
	GoTo Tourney_EventScript_BetweenRounds
	
Tourney_EventScript_SayLost:
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SayLostSim
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Lost
	WaitButton
	Return
	
Tourney_EventScript_SayForfeitAskSim:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimForfeitAsk
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_738
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_739
_cv_yes_738:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_739:
	Return
	
Tourney_EventScript_SimSpeciesClause:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimSpeciesClause
	WaitButton
	Return
	
Tourney_EventScript_SimItemClause:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimItemClause
	WaitButton
	Return
	
GymDecor_EventScript_ConfirmBuy:
	// TODO(gba) special GymDecor_BufferDecorInfo
	GoTo _cv_stop
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_ConfirmBuy
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_740
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_741
_cv_yes_740:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_741:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymDecor_EventScript_BuyLoop
	// TODO(gba) special GymDecor_TryBuy
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymDecor_EventScript_NotEnoughMoney
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq GymDecor_EventScript_StorageFull
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfEq GymDecor_EventScript_AlreadyHave
	UpdateMoneyBox
	// TODO(gba) special GymDecor_BufferDecorInfo
	GoTo _cv_stop
	PlaySE SEQ_SE_DP_SELECT
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_Bought
	WaitButton
	GoTo GymDecor_EventScript_BuyLoop
	CloseMsg
	End
	
Tourney_EventScript_SayAnnounceSim:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimAnnounce
	WaitButton
	Return
	
Tourney_EventScript_Prize:
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq Tourney_EventScript_RarePrize
	CompareVarToValue 0x501B, 4
	CallIfEq Tourney_EventScript_PrizeSim
	CompareVarToValue 0x501B, 4
	CallIfNe Tourney_EventScript_PrizeReal
	Call GymHack_EventScript_GiveStatItem
	Return
	
Tourney_EventScript_Title:
	PlayFanfare SEQ_ME_ITEM
	BufferPlayersName 6
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Title
	WaitFanfare
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SimTitle
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_TitleHall
	WaitButton
	CompareVarToValue 0x501B, 3
	CallIfEq Tourney_EventScript_FirstTitle
	CloseMsg
	ReleaseAll
	End
	
Tourney_EventScript_SayWon:
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SayWonSim
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Won
	Return
	
Tourney_EventScript_BetweenRounds:
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptNext, 0
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptBoard, 1
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptRest, 2
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_743
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_743:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Tourney_EventScript_Continue
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Tourney_EventScript_BoardBetween
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SimBreak
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Break
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Tourney_EventScript_SayLostSim:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimLost
	WaitButton
	Return
	
GymDecor_EventScript_NotEnoughMoney:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_NotEnoughMoney
	WaitButton
	GoTo GymDecor_EventScript_BuyLoop
	CloseMsg
	End
	
GymDecor_EventScript_StorageFull:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_StorageFull
	WaitButton
	GoTo GymDecor_EventScript_BuyLoop
	CloseMsg
	End
	
GymDecor_EventScript_AlreadyHave:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_AlreadyHave
	WaitButton
	GoTo GymDecor_EventScript_BuyLoop
	CloseMsg
	End
	
Tourney_EventScript_RarePrize:
	CompareVarToValue 0x501B, 4
	CallIfEq Tourney_EventScript_RarePrizeSim
	CompareVarToValue 0x501B, 4
	CallIfNe Tourney_EventScript_RarePrizeReal
	Call GymHack_EventScript_GiveStatItem
	Return
	
Tourney_EventScript_PrizeSim:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Tourney_Text_PrizeSim
	WaitButton
	Return
	
Tourney_EventScript_PrizeReal:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Tourney_Text_Prize
	WaitButton
	Return
	
Tourney_EventScript_SimTitle:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_TitleHall
	WaitButton
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimBillNext
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_744
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_745
_cv_yes_744:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_745:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Tourney_EventScript_SimBill
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimBillLater
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Tourney_EventScript_FirstTitle:
	PlaySE SEQ_SE_DP_SELECT
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_LastOne
	WaitButton
	Return
	
Tourney_EventScript_SayWonSim:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimWon
	Return
	
Tourney_EventScript_Continue:
	CanvasCloseMsg
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	GoTo Tourney_EventScript_NextMatch
	
Tourney_EventScript_BoardBetween:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special Tourney_ShowBoard
	GoTo _cv_stop
	Call Tourney_EventScript_SayNextQuestion
	GoTo Tourney_EventScript_BetweenRounds
	
Tourney_EventScript_SimBreak:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimBreak
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Tourney_EventScript_RarePrizeSim:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Tourney_Text_RarePrizeSim
	WaitButton
	Return
	
Tourney_EventScript_RarePrizeReal:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Tourney_Text_RarePrize
	WaitButton
	Return
	
Tourney_EventScript_SayNextQuestion:
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SayNextQuestionSim
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_ContinueOrBreak
	Return
	
Tourney_EventScript_SayNextQuestionSim:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimContinue
	Return

_cv_unported_24:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_25:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

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
Common_Movement_WalkInPlaceFasterRight:
	WalkOnSpotFasterEast
	EndMovement

	.balign 4, 0
GymFinale_Movement_PlayerLookAtAide:
	WalkOnSpotFasterEast
	EndMovement

	.balign 4, 0
gGymLegendCameraIn:
	EndMovement

	.balign 4, 0
gGymLegendCameraOut:
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
gGymChallengePlayerPath:
	EndMovement

	.balign 4, 0
gGymChallengeChallengerPath:
	EndMovement
	.balign 4, 0
