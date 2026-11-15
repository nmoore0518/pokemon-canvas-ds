#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_FIGHT_AREA_UNUSED_7.h"
#include "msgdata/msg/msg_0856_CV_FIGHT_AREA_UNUSED_7.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PalletTown_Gym_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef _cv_unported_0
	ScrDef _cv_unported_1
	ScrDef _cv_unported_2
	ScrDef _cv_unported_3
	ScrDef _cv_unported_4
	ScrDef _cv_unported_5
	ScrDef _cv_unported_6
	ScrDef _cv_unported_7
	ScrDef _cv_unported_8
	ScrDef _cv_unported_9
	ScrDef _cv_unported_10
	ScrDef _cv_unported_11
	ScrDef _cv_unported_12
	ScrDef _cv_unported_13
	ScrDef _cv_unported_14
	ScrDef _cv_unported_15
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
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymChallenge_EventScript_AideNotYet
	// TODO(gba) special GymChallenge_BufferRecord
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_AideWelcome
	WaitButton
	// TODO(gba) special GymSwitch_BufferGoal
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
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe GymChallenge_EventScript_TeamBreaksRules
	HealParty
	// TODO(gba) special GymChallenge_PlanPlayerWalk
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
	CopyVar 0x8008, 0x8004
	PlayCry 0x8008, 0
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymLegend_Text_Challenge
	WaitButton
	WaitCry
	CloseMsg
	SetVar 0x5014, 1
	// TODO(gba) special GymLegend_CreateMon
	SetFlag 0x2032
	// TODO(gba) special BattleSetup_StartLegendaryBattle
	ClearFlag 0x2032
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq _cv_won_3
	SetVar VAR_SPECIAL_RESULT, 2
_cv_won_3:
	HidePerson 16
	CompareVarToValue VAR_SPECIAL_RESULT, 7
	GoToIfEq GymLegend_EventScript_Caught
	// TODO(gba) special GymLegend_Setup
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
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Johto_EventScript_InvitationByMail
	Wait 20, VAR_SPECIAL_RESULT
	PlaySE SEQ_SE_DP_DOOR
	SetVar 0x800A, 4
	Call GymCandidate_EventScript_VisitorWalksIn
	// TODO(gba) special GymCandidate_BufferMentorName
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Johto_Text_MentorInvite
	WaitButton
	Call Johto_EventScript_ReceiveInvitation
	// TODO(gba) special GymCandidate_BufferMentorName
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Johto_Text_MentorInviteFerry
	WaitButton
	// TODO(gba) special GymCandidate_BufferMentorName
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Johto_Text_MentorGymCharm
	WaitButton
	Call Johto_EventScript_ReceiveGymCharm
	// TODO(gba) special GymCandidate_BufferMentorName
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Johto_Text_MentorGymCharmHow
	WaitButton
	// TODO(gba) special GymCandidate_BufferMentorName
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
	ShowPerson 17
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
	GoToIfEq _cv_yes_4
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_5
_cv_yes_4:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_5:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymFinale_EventScript_PutOff
	// TODO(gba) special GymHack_CheckTeamSpecial
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe GymFinale_EventScript_TeamBreaksRules
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_OakThenShowMe
	WaitButton
	CloseMsg
	HealParty
	// TODO(gba) special GymChallenge_GenerateOakFinale
	ClearFlag 0x2052
	SetFlag 0x2036
	// TODO(gba) trainerbattle_no_intro TRAINER_GYM_CHALLENGER, gGymChallengeDefeatText
	ClearFlag 0x2036
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq _cv_won_6
	SetVar VAR_SPECIAL_RESULT, 2
_cv_won_6:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymFinale_EventScript_BeatOak
	GoTo GymFinale_EventScript_LostToOak
	End
	
GymChallenge_EventScript_AideNotYet:
	// TODO(gba) special GymCandidate_BufferApprovals
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
	ShowPerson 4
	SetVar 0x8004, 0
	// TODO(gba) special GymChallenge_PlanChallengerWalk
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	CallIfEq GymChallenge_EventScript_ChallengerJumpsIn
	ApplyMovement 4, gGymChallengeChallengerPath
	WaitMovement
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_gGymChallengeIntroText
	WaitButton
	CloseMsg
	ClearFlag 0x2052
	SetFlag 0x2036
	// TODO(gba) trainerbattle_no_intro TRAINER_GYM_CHALLENGER, gGymChallengeDefeatText
	ClearFlag 0x2036
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq _cv_won_7
	SetVar VAR_SPECIAL_RESULT, 2
_cv_won_7:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymChallenge_EventScript_Won
	GoTo GymChallenge_EventScript_Lost
	End
	
GymPractice_EventScript_Trainer:
	LockAll
	FacePlayer
	// TODO(gba) special GymChallenge_BufferPracticeTrainer
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymPractice_Text_Offer
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_8
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_9
_cv_yes_8:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_9:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymPractice_EventScript_NotNow
	// TODO(gba) special GymChallenge_GeneratePractice
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymPractice_Text_Go
	WaitButton
	CloseMsg
	ClearFlag 0x2052
	SetFlag 0x2036
	// TODO(gba) trainerbattle_no_intro TRAINER_GYM_CHALLENGER, gGymChallengeDefeatText
	ClearFlag 0x2036
	// TODO(gba) special GymChallenge_EndPractice
	HealParty
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq _cv_won_10
	SetVar VAR_SPECIAL_RESULT, 2
_cv_won_10:
	// TODO(gba) special GymChallenge_BufferPracticeTrainer
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
	GoToIfEq _cv_yes_11
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_12
_cv_yes_11:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_12:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Gauntlet_EventScript_Withdraw
	End
	
Gauntlet_EventScript_AllBeaten:
	GoToIfSet 0x2038, Gauntlet_EventScript_BillAgain
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_ReadyToMeet
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_13
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_14
_cv_yes_13:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_14:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Gauntlet_EventScript_NotYet
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Reveal1
	WaitButton
	CloseMsg
	Wait 30, VAR_SPECIAL_RESULT
	FadeScreen 6, 1, 0, RGB_WHITE
	WaitFade
	// TODO(gba) special Gauntlet_RevealBill
	HidePerson 17
	ShowPerson 17
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
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Tourney_EventScript_MenuActive
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfEq Tourney_EventScript_MenuSimBill
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Tourney_EventScript_MenuFirst
	Call Tourney_EventScript_SayAsk
	TouchscreenMenuHide
	MenuInit 1, 1, 0, 1, VAR_SPECIAL_RESULT
	MenuItemAdd msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptEnter, 255, 0
	MenuItemAdd msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptLast, 255, 1
	MenuItemAdd msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptNotNow, 255, 2
	MenuExec
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_16
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_16:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Tourney_EventScript_Enter
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Tourney_EventScript_LastResults
	GoTo Tourney_EventScript_NotNow
	
GymChallenge_EventScript_Statue:
	LockAll
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar GymChallenge_IsOpen
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymChallenge_EventScript_StatueNoLeader
	// TODO(gba) special GymChallenge_BufferRecord
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_StatueLeader
	WaitButton
	// TODO(gba) special GymChallenge_BufferVictorList
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymChallenge_EventScript_StatueUnbeaten
	// TODO(gba) special GymBadge_BufferName
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_StatueVictors
	WaitButton
	// TODO(gba) special GymChallenge_BufferVictorList
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_gStringVar4
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
	GoToIfUnset 0x2026, _cv_dex_17
	SetVar VAR_SPECIAL_RESULT, 1
_cv_dex_17:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	CallIfEq EventScript_SetReadyTryGiveNationalDexScene
	Return
	
EventScript_GiveHotAirBalloon:
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x202C, _cv_has_18
	SetVar VAR_SPECIAL_RESULT, 1
_cv_has_18:
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
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymLegend_EventScript_RivalAppears
	CopyVar 0x401E, 0x8005
	CopyVar 0x401F, 0x8006
	MovePerson 2, 0x401E, 0x401F
	ClearFlag 0x2033
	ShowPerson 2
	ApplyMovement 2, gMentorWalkIn
	WaitMovement
	// TODO(gba) special GymCandidate_FaceGuest
	Return
	
GymLegend_EventScript_RivalWalksOut:
	CloseMsg
	PlayBGM SEQ_GS_E_RIVAL2
	// TODO(gba) special GymCandidate_VisitorWalked
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymLegend_EventScript_RivalVanishes
	ApplyMovement 2, gMentorWalkOut
	WaitMovement
	End
	
GymLegend_EventScript_Appears:
	// TODO(gba) special GymLegend_Setup
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymLegend_EventScript_NoLegend
	CopyVar 0x8008, 0x8004
	// TODO(gba) special GymLegend_FindSpot
	CopyVar 0x401E, 0x8005
	CopyVar 0x401F, 0x8006
	MovePerson 16, 0x401E, 0x401F
	// TODO(gba) special GymLegend_PlanCamera
	Wait 30, VAR_SPECIAL_RESULT
	SetVar 0x8004, 2
	SetVar 0x8005, 2
	SetVar 0x8006, 12
	SetVar 0x8007, 4
	// TODO(gba) special ShakeCamera
	PlaySE SEQ_SE_DP_SELECT
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymLegend_Text_LightsOut
	WaitButton
	CloseMsg
	ClearFlag 0x203A
	ShowPerson 16
	Wait 40, VAR_SPECIAL_RESULT
	PlaySE SEQ_SE_DP_SELECT
	FadeScreen 6, 1, 1, RGB_WHITE
	WaitFade
	PlayCry 0x8008, 0
	WaitCry
	// TODO(gba) special SpawnCameraObject
	ApplyMovement 127, gGymLegendCameraIn
	WaitMovement
	PlayBGM SEQ_GS_E_ARCEUS
	Wait 30, VAR_SPECIAL_RESULT
	PlayCry 0x8008, 0
	WaitCry
	Wait 30, VAR_SPECIAL_RESULT
	ApplyMovement 127, gGymLegendCameraOut
	WaitMovement
	// TODO(gba) special RemoveCameraObject
	SetFlag 0x203B
	SetVar 0x5014, 0
	// TODO(gba) special GymLegend_Setup
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
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_GuestLeaves
	CloseMsg
	ApplyMovement 0x800A, gMentorWalkOut
	WaitMovement
	HidePerson 0x800A
	SetFlag 0x2017
	PlaySE SEQ_SE_DP_KAIDAN2
	// TODO(gba) special GymCandidate_FaceBack
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
	GoToIfUnset 0x2011, GymFinale_EventScript_HallOfFame
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
	Warp MAP_PALLET_TOWN_REDS_HOUSE_1F, 0, 8, 6, DIR_SOUTH
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
	Return
	
GymChallenge_EventScript_Won:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_gGymChallengeAfterText
	WaitButton
	Call GymChallenge_EventScript_ChallengerLeaves
	// TODO(gba) special GymChallenge_RecordWin
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
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq GymSwitch_EventScript_Mastered
	HealParty
	GoToIfSet 0x201F, GymSwitch_EventScript_KeepGoingOrRetire
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_KeepGoing
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_19
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_20
_cv_yes_19:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_20:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymChallenge_EventScript_KeepGoing
	// TODO(gba) special GymChallenge_BufferRecord
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
	// TODO(gba) special GymBadge_BufferName
	// TODO(gba) special GymBadge_ShowIcon
	PlayFanfare SEQ_ME_BADGE
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_AwardBadge
	WaitButton
	WaitFanfare
	// TODO(gba) special GymBadge_HideIcon
	Call GymChallenge_EventScript_ChallengerLeaves
	// TODO(gba) special GymChallenge_BufferLastResult
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
	MenuInit 1, 1, 0, 1, VAR_SPECIAL_RESULT
	MenuItemAdd msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptSim, 255, 0
	MenuItemAdd msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptOff, 255, 1
	MenuExec
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_22
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_22:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Tourney_EventScript_Menu
	GoTo Gauntlet_EventScript_PilotOff
	
Gauntlet_EventScript_Withdraw:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_WithdrawWhich
	// TODO(gba) special Gauntlet_ChooseWithdraw
	CompareVarToValue VAR_SPECIAL_RESULT, SPECIES_NONE
	GoToIfEq Gauntlet_EventScript_PilotMenu
	CopyVar 0x8005, VAR_SPECIAL_RESULT
	BufferSpeciesName 0, 0x8005, 0, 0
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_WithdrawConfirm
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_23
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_24
_cv_yes_23:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_24:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Gauntlet_EventScript_Withdraw
	GiveMon 0x8005, 70, 0, 0, 0, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq Gauntlet_EventScript_NoRoom
	CopyVar 0x8006, VAR_SPECIAL_RESULT
	// TODO(gba) special Gauntlet_UseWithdraw
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
	GoToIfEq _cv_yes_25
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_26
_cv_yes_25:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_26:
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
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_gGymChallengeIntroText
	WaitButton
	CloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special Gauntlet_ShowBillCard
	ClearFlag 0x2052
	SetFlag 0x2036
	// TODO(gba) trainerbattle_no_intro TRAINER_GYM_CHALLENGER, gGymChallengeDefeatText
	ClearFlag 0x2036
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq _cv_won_27
	SetVar VAR_SPECIAL_RESULT, 2
_cv_won_27:
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
	Call Tourney_EventScript_SayNext
	TouchscreenMenuHide
	MenuInit 1, 1, 0, 1, VAR_SPECIAL_RESULT
	MenuItemAdd msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptNext, 255, 0
	MenuItemAdd msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptBoard, 255, 1
	MenuItemAdd msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptForfeit, 255, 2
	MenuItemAdd msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptNotNow, 255, 3
	MenuExec
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_29
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_29:
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
	MenuInit 1, 1, 0, 1, VAR_SPECIAL_RESULT
	MenuItemAdd msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptBill, 255, 0
	MenuItemAdd msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptBoard, 255, 1
	MenuItemAdd msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptNotNow, 255, 2
	MenuExec
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_31
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_31:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Tourney_EventScript_SimBill
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Tourney_EventScript_Board
	GoTo Tourney_EventScript_NotNow
	
Tourney_EventScript_MenuFirst:
	Call Tourney_EventScript_SayAsk
	TouchscreenMenuHide
	MenuInit 1, 1, 0, 1, VAR_SPECIAL_RESULT
	MenuItemAdd msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptEnter, 255, 0
	MenuItemAdd msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptNotNow, 255, 1
	MenuExec
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_33
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_33:
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
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe Tourney_EventScript_BreaksClause
	CompareVarToValue 0x501B, 4
	CallIfEq Tourney_EventScript_SimFormat
	// TODO(gba) special Tourney_Begin
	Call Tourney_EventScript_SayDraw
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special Tourney_ShowBoard
	// TODO(gba) special Tourney_SetupNext
	Call Tourney_EventScript_SayFirst
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Tourney_EventScript_NotNow
	End
	
Tourney_EventScript_LastResults:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special Tourney_ShowBoard
	// TODO(gba) special Tourney_BufferChampion
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
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymLegend_EventScript_RivalNoRoom
	CopyVar 0x401E, 0x8005
	CopyVar 0x401F, 0x8006
	MovePerson 2, 0x401E, 0x401F
	ClearFlag 0x2033
	ShowPerson 2
	// TODO(gba) special GymCandidate_FaceGuest
	End
	
GymLegend_EventScript_RivalVanishes:
	HidePerson 2
	PlaySE SEQ_SE_DP_KAIDAN2
	// TODO(gba) special GymCandidate_FaceBack
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
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_MentorNoRoom
	CopyVar 0x401E, 0x8005
	CopyVar 0x401F, 0x8006
	MovePerson 0x800A, 0x401E, 0x401F
	ClearFlag 0x2017
	ShowPerson 0x800A
	// TODO(gba) special GymCandidate_FaceGuest
	End
	
GymCandidate_EventScript_GuestLeaves:
	CloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	HidePerson 0x800A
	SetFlag 0x2017
	// TODO(gba) special GymCandidate_FaceBack
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
	ReleaseAll
	End
	
GymFinale_EventScript_Badge:
	// TODO(gba) special GymBadge_BufferName
	// TODO(gba) special GymBadge_ShowIcon
	PlayFanfare SEQ_ME_BADGE
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_YourBadge
	WaitButton
	WaitFanfare
	// TODO(gba) special GymBadge_HideIcon
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
	PlaySE SEQ_SE_DP_KAIDAN2
	SetFlag 0x2034
	ResetBGM
	ReleaseAll
	End
	
GymChallenge_EventScript_ChallengerLeaves:
	CloseMsg
	SetVar 0x8004, 1
	// TODO(gba) special GymChallenge_PlanChallengerWalk
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
	// TODO(gba) addpcitem VAR_0x8009, 1
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
	MenuInit 1, 1, 0, 1, VAR_SPECIAL_RESULT
	MenuItemAdd msg_0856_CV_FIGHT_AREA_UNUSED_7_GymSwitch_Text_KeepGoing, 255, 0
	MenuItemAdd msg_0856_CV_FIGHT_AREA_UNUSED_7_GymSwitch_Text_CallItADay, 255, 1
	MenuItemAdd msg_0856_CV_FIGHT_AREA_UNUSED_7_GymSwitch_Text_TakeABreak, 255, 2
	MenuExec
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_35
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_35:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymChallenge_EventScript_KeepGoing
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymSwitch_EventScript_CallItADay
	// TODO(gba) special GymChallenge_BufferRecord
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
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymSwitch_EventScript_OakAppears
	CopyVar 0x401E, 0x8005
	CopyVar 0x401F, 0x8006
	MovePerson 1, 0x401E, 0x401F
	ClearFlag 0x2034
	ShowPerson 1
	ApplyMovement 1, gMentorWalkIn
	WaitMovement
	// TODO(gba) special GymCandidate_FaceGuest
	End
	
Gauntlet_EventScript_PilotMenuWithdraw:
	TouchscreenMenuHide
	MenuInit 1, 1, 0, 1, VAR_SPECIAL_RESULT
	MenuItemAdd msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptWithdraw, 255, 0
	MenuItemAdd msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptSim, 255, 1
	MenuItemAdd msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptOff, 255, 2
	MenuExec
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_37
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_37:
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
	HidePerson 17
	ShowPerson 17
	Wait 60, VAR_SPECIAL_RESULT
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Faded
	WaitButton
	// TODO(gba) special Overworld_PlaySpecialMapMusic
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
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Tourney_EventScript_WrongTeam
	// TODO(gba) special Tourney_CheckClauses
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe Tourney_EventScript_BreaksClause
	HealParty
	// TODO(gba) special GymChallenge_PlanPlayerWalk
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
	GoTo Tourney_EventScript_Menu
	
Tourney_EventScript_Forfeit:
	Call Tourney_EventScript_SayForfeitAsk
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Tourney_EventScript_Menu
	// TODO(gba) special Tourney_Forfeit
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
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimBillAnnounce
	WaitButton
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_gGymChallengeIntroText
	WaitButton
	CloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special Gauntlet_ShowBillCard
	ClearFlag 0x2052
	SetFlag 0x2036
	// TODO(gba) trainerbattle_no_intro TRAINER_GYM_CHALLENGER, gGymChallengeDefeatText
	ClearFlag 0x2036
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq _cv_won_38
	SetVar VAR_SPECIAL_RESULT, 2
_cv_won_38:
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
	GoToIfEq _cv_yes_39
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_40
_cv_yes_39:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_40:
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
	MenuInit 1, 1, 1, 0, VAR_SPECIAL_RESULT
	MenuItemAdd msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptSingles, 255, 0
	MenuItemAdd msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptDoubles, 255, 1
	MenuExec
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_42
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_42:
	// TODO(gba) special Tourney_SetSimFormat
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
	GoToIfEq _cv_yes_43
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_44
_cv_yes_43:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_44:
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
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymLegend_EventScript_OakCatchAnother
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymLegend_Text_OakCatchIt
	WaitButton
	Return
	
GymChallenge_EventScript_ChallengerGone:
	HidePerson 4
	SetFlag 0x2017
	Return
	
GymHack_EventScript_GiveStatItemDone:
	Return
	
GymSwitch_EventScript_CallItADay:
	// TODO(gba) special GymChallenge_RetireStreak
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymSwitch_Text_CalledItADay
	WaitButton
	GoTo GymSwitch_EventScript_OakComes
	CloseMsg
	End
	
GymSwitch_EventScript_OakAppears:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special GymCandidate_PlaceGuest
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymSwitch_EventScript_OakNoRoom
	CopyVar 0x401E, 0x8005
	CopyVar 0x401F, 0x8006
	MovePerson 1, 0x401E, 0x401F
	ClearFlag 0x2034
	ShowPerson 1
	// TODO(gba) special GymCandidate_FaceGuest
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
	GoToIfEq _cv_yes_45
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_46
_cv_yes_45:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_46:
	Return
	
Tourney_EventScript_SimForfeited:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimForfeited
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Tourney_EventScript_SimBillWon:
	// TODO(gba) special Tourney_SimBillWon
	PlayFanfare SEQ_ME_ITEM
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimComplete
	WaitFanfare
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_WithdrawAsk
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_47
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_48
_cv_yes_47:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_48:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Gauntlet_EventScript_Withdraw
	CloseMsg
	ReleaseAll
	End
	
Tourney_EventScript_SayRulesSim:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimStart
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_49
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_50
_cv_yes_49:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_50:
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
	GoToIfEq _cv_yes_51
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_52
_cv_yes_51:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_52:
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
	GoToIfEq _cv_yes_53
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_54
_cv_yes_53:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_54:
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
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymSwitch_Text_OakMastered
	WaitButton
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x2045, _cv_has_55
	SetVar VAR_SPECIAL_RESULT, 1
_cv_has_55:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq GymSwitch_EventScript_OakTeraTip
	// TODO(gba) special GymSwitch_CanTakeNewType
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymSwitch_EventScript_OakNothingToOffer
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymSwitch_Text_OakTryAnother
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_56
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_57
_cv_yes_56:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_57:
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
	// TODO(gba) special GymCandidate_FaceBack
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	ResetBGM
	ReleaseAll
	End
	
GymSwitch_EventScript_OakTeraTip:
	// TODO(gba) special GymSwitch_BufferStatus
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymSwitch_Text_OakTeraTip
	WaitButton
	Return
	
GymSwitch_EventScript_OakNothingToOffer:
	// TODO(gba) special GymSwitch_AllMastered
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
	TouchscreenMenuHide
	MenuInit 1, 1, 0, 1, VAR_SPECIAL_RESULT
	MenuExec
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_59
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_59:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq GymSwitch_EventScript_ChoiceCancelled
	// TODO(gba) special GymSwitch_BufferChoice
	CopyVar 0x8009, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymSwitch_EventScript_ConfirmNew
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymSwitch_Text_ConfirmOld
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_60
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_61
_cv_yes_60:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_61:
	GoTo GymSwitch_EventScript_Confirmed
	CloseMsg
	End
	
GymSwitch_EventScript_OakGone:
	HidePerson 1
	SetFlag 0x2034
	// TODO(gba) special GymCandidate_FaceBack
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
	GoToIfEq _cv_yes_62
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_63
_cv_yes_62:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_63:
	End
	
GymSwitch_EventScript_Confirmed:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymSwitch_EventScript_ChooseType
	// TODO(gba) special GymSwitch_SetType
	// TODO(gba) special GymBadge_ShowIcon
	PlayFanfare SEQ_ME_BADGE
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymSwitch_Text_NowType
	WaitButton
	WaitFanfare
	// TODO(gba) special GymBadge_HideIcon
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

_cv_unported_0:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_1:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_2:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_3:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_4:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_5:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_6:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_7:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_8:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_9:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_10:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_11:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_12:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_13:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_14:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_15:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

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
