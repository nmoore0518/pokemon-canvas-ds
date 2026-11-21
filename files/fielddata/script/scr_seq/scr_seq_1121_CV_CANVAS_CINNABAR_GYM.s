#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_CINNABAR_GYM.h"
#include "msgdata/msg/msg_0932_CV_CANVAS_CINNABAR_GYM.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's CinnabarIsland_Gym_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef CinnabarIsland_Gym_EventScript_Quinn
	ScrDef CinnabarIsland_Gym_EventScript_Avery
	ScrDef CinnabarIsland_Gym_EventScript_Ramon
	ScrDef CinnabarIsland_Gym_EventScript_Derek
	ScrDef CinnabarIsland_Gym_EventScript_Dusty
	ScrDef CinnabarIsland_Gym_EventScript_Zac
	ScrDef CinnabarIsland_Gym_EventScript_Blaine
	ScrDef CinnabarIsland_Gym_EventScript_GymGuy
	ScrDef GymAides_EventScript_CinnabarIsland
	ScrDef CinnabarIsland_Gym_EventScript_GymStatue
	ScrDef CinnabarIsland_Gym_EventScript_Quz1Left
	ScrDef CinnabarIsland_Gym_EventScript_Quz1Right
	ScrDef CinnabarIsland_Gym_EventScript_Quiz2Left
	ScrDef CinnabarIsland_Gym_EventScript_Quiz2Right
	ScrDef CinnabarIsland_Gym_EventScript_Quiz3Left
	ScrDef CinnabarIsland_Gym_EventScript_Quiz3Right
	ScrDef CinnabarIsland_Gym_EventScript_Quiz4Left
	ScrDef CinnabarIsland_Gym_EventScript_Quiz4Right
	ScrDef CinnabarIsland_Gym_EventScript_Quiz5Left
	ScrDef CinnabarIsland_Gym_EventScript_Quiz5Right
	ScrDef CinnabarIsland_Gym_EventScript_Quiz6Left
	ScrDef CinnabarIsland_Gym_EventScript_Quiz6Right
	ScrDef CinnabarIsland_Gym_EventScript_BlaineFujiPhoto
	ScrDef CinnabarIsland_Gym_OnLoad
	ScrDef CinnabarIsland_Gym_OnTransitionGuest
	ScrDef CinnabarIsland_Gym_Frlg_cv_Barriers
	ScrDefEnd
	
CinnabarIsland_Gym_EventScript_Quinn:
	CheckTrainerFlag 960
	GoToIf TRUE, _cv_beaten_1
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_QuinnIntro
	WaitButton
	CloseMsg
	TrainerBattle 960, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_2
	WhiteOut
	End
_cv_won_2:
	SetTrainerFlag 960
	GoTo CinnabarIsland_Gym_EventScript_DefeatedQuinn
_cv_beaten_1:
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_QuinnPostBattle
	WaitButton
	CloseMsg
	End
	
CinnabarIsland_Gym_EventScript_Avery:
	CheckTrainerFlag 929
	GoToIf TRUE, _cv_beaten_3
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_AveryIntro
	WaitButton
	CloseMsg
	TrainerBattle 929, 929, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_4
	WhiteOut
	End
_cv_won_4:
	SetTrainerFlag 929
	GoTo CinnabarIsland_Gym_EventScript_DefeatedAvery
_cv_beaten_3:
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_AveryPostBattle
	WaitButton
	CloseMsg
	End
	
CinnabarIsland_Gym_EventScript_Ramon:
	CheckTrainerFlag 961
	GoToIf TRUE, _cv_beaten_5
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_RamonIntro
	WaitButton
	CloseMsg
	TrainerBattle 961, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_6
	WhiteOut
	End
_cv_won_6:
	SetTrainerFlag 961
	GoTo CinnabarIsland_Gym_EventScript_DefeatedRamon
_cv_beaten_5:
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_RamonPostBattle
	WaitButton
	CloseMsg
	End
	
CinnabarIsland_Gym_EventScript_Derek:
	CheckTrainerFlag 930
	GoToIf TRUE, _cv_beaten_7
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_DerekIntro
	WaitButton
	CloseMsg
	TrainerBattle 930, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_8
	WhiteOut
	End
_cv_won_8:
	SetTrainerFlag 930
	GoTo CinnabarIsland_Gym_EventScript_DefeatedDerek
_cv_beaten_7:
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_DerekPostBattle
	WaitButton
	CloseMsg
	End
	
CinnabarIsland_Gym_EventScript_Dusty:
	CheckTrainerFlag 962
	GoToIf TRUE, _cv_beaten_9
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_DustyIntro
	WaitButton
	CloseMsg
	TrainerBattle 962, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_10
	WhiteOut
	End
_cv_won_10:
	SetTrainerFlag 962
	GoTo CinnabarIsland_Gym_EventScript_DefeatedDusty
_cv_beaten_9:
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_DustyPostBattle
	WaitButton
	CloseMsg
	End
	
CinnabarIsland_Gym_EventScript_Zac:
	CheckTrainerFlag 931
	GoToIf TRUE, _cv_beaten_11
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_ZacIntro
	WaitButton
	CloseMsg
	TrainerBattle 931, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_12
	WhiteOut
	End
_cv_won_12:
	SetTrainerFlag 931
	GoTo CinnabarIsland_Gym_EventScript_DefeatedZac
_cv_beaten_11:
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_ZacPostBattle
	WaitButton
	CloseMsg
	End
	
CinnabarIsland_Gym_EventScript_Blaine:
	SetVar 0x8009, 6
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_mentor_13
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_mentor_13
	SetVar 0x401F, 1
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_13:
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_mentor_14
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_mentor_14
	SetVar 0x401F, 2
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_14:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_mentor_15
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_mentor_15
	SetVar 0x401F, 3
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_15:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_mentor_16
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_mentor_16
	SetVar 0x401F, 4
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_16:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_mentor_17
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_mentor_17
	SetVar 0x401F, 5
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_17:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_mentor_18
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_mentor_18
	SetVar 0x401F, 6
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_18:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_mentor_19
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_mentor_19
	SetVar 0x401F, 7
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_19:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_mentor_20
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_mentor_20
	SetVar 0x401F, 8
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_20:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_mentor_21
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_mentor_21
	SetVar 0x401F, 9
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_21:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_mentor_22
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_mentor_22
	SetVar 0x401F, 10
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_22:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_mentor_23
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_mentor_23
	SetVar 0x401F, 11
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_23:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq CinnabarIsland_Gym_EventScript_MentorBattle
	CheckTrainerFlag 1155
	GoToIf TRUE, _cv_beaten_24
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_BlaineIntro
	WaitButton
	CloseMsg
	CanvasCheckTeam 7, 0x5019
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_team_not_allowed
	TrainerBattle 1155, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_25
	WhiteOut
	End
_cv_won_25:
	SetTrainerFlag 1155
	GoTo CinnabarIsland_Gym_EventScript_DefeatedBlaine
_cv_beaten_24:
	GoTo CinnabarIsland_Gym_EventScript_AfterLeaderBattle
	
CinnabarIsland_Gym_EventScript_GymGuy:
	LockAll
	FacePlayer
	GoToIfSet 0x21EF, CinnabarIsland_Gym_EventScript_GymGuyPostVictory
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_GymGuyAdvice
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymAides_EventScript_CinnabarIsland:
	GoToIfSet 0x2090, GymAides_EventScript_CinnabarIslandAfter
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_GymAides_Text_CinnabarIsland
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_GymStatue:
	LockAll
	GoToIfSet 0x2090, CinnabarIsland_Gym_EventScript_GymStatuePostVictory
	BufferRivalsName 7
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_GymStatue
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_Quz1Left:
	LockAll
	SetVar 0x4001, 0
	GoTo CinnabarIsland_Gym_EventScript_Quiz1
	End
	
CinnabarIsland_Gym_EventScript_Quz1Right:
	LockAll
	SetVar 0x4001, 1
	GoTo CinnabarIsland_Gym_EventScript_Quiz1
	End
	
CinnabarIsland_Gym_EventScript_Quiz2Left:
	LockAll
	SetVar 0x4001, 0
	GoTo CinnabarIsland_Gym_EventScript_Quiz2
	End
	
CinnabarIsland_Gym_EventScript_Quiz2Right:
	LockAll
	SetVar 0x4001, 1
	GoTo CinnabarIsland_Gym_EventScript_Quiz2
	End
	
CinnabarIsland_Gym_EventScript_Quiz3Left:
	LockAll
	SetVar 0x4001, 0
	GoTo CinnabarIsland_Gym_EventScript_Quiz3
	End
	
CinnabarIsland_Gym_EventScript_Quiz3Right:
	LockAll
	SetVar 0x4001, 1
	GoTo CinnabarIsland_Gym_EventScript_Quiz3
	End
	
CinnabarIsland_Gym_EventScript_Quiz4Left:
	LockAll
	SetVar 0x4001, 0
	GoTo CinnabarIsland_Gym_EventScript_Quiz4
	End
	
CinnabarIsland_Gym_EventScript_Quiz4Right:
	LockAll
	SetVar 0x4001, 1
	GoTo CinnabarIsland_Gym_EventScript_Quiz4
	End
	
CinnabarIsland_Gym_EventScript_Quiz5Left:
	LockAll
	SetVar 0x4001, 0
	GoTo CinnabarIsland_Gym_EventScript_Quiz5
	End
	
CinnabarIsland_Gym_EventScript_Quiz5Right:
	LockAll
	SetVar 0x4001, 1
	GoTo CinnabarIsland_Gym_EventScript_Quiz5
	End
	
CinnabarIsland_Gym_EventScript_Quiz6Left:
	LockAll
	SetVar 0x4001, 0
	GoTo CinnabarIsland_Gym_EventScript_Quiz6
	End
	
CinnabarIsland_Gym_EventScript_Quiz6Right:
	LockAll
	SetVar 0x4001, 1
	GoTo CinnabarIsland_Gym_EventScript_Quiz6
	End
	
CinnabarIsland_Gym_EventScript_BlaineFujiPhoto:
	LockAll
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_PhotoOfBlaineAndFuji
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_Gym_OnLoad:
	GoToIfSet 0x21EF, CinnabarIsland_Gym_OnLoadOpenAllDoors
	CallIfSet 0x21F0, CinnabarIsland_Gym_OnLoadOpenDoor1
	CallIfSet 0x21F1, CinnabarIsland_Gym_OnLoadOpenDoor2
	CallIfSet 0x21F2, CinnabarIsland_Gym_OnLoadOpenDoor3
	CallIfSet 0x21F3, CinnabarIsland_Gym_OnLoadOpenDoor4
	CallIfSet 0x21F4, CinnabarIsland_Gym_OnLoadOpenDoor5
	CallIfSet 0x21F5, CinnabarIsland_Gym_OnLoadOpenDoor6
	End
	
CinnabarIsland_Gym_OnTransitionGuest:
	SetFlag 0x2017
	End
	
CinnabarIsland_Gym_Frlg_cv_Barriers:
	SetVar 0x5044, 1
	ClearFlag 0x225C
	ClearFlag 0x225D
	ClearFlag 0x225E
	ClearFlag 0x225F
	ClearFlag 0x2260
	ClearFlag 0x2261
	ClearFlag 0x2262
	ClearFlag 0x2263
	ClearFlag 0x2264
	ClearFlag 0x2265
	ClearFlag 0x2266
	ClearFlag 0x2267
	SetVar 0x5044, 0
	GoTo CinnabarIsland_Gym_OnTransitionGuest
	
CinnabarIsland_Gym_EventScript_DefeatedQuinn:
	CallIfUnset 0x21F0, CinnabarIsland_Gym_EventScript_Quiz1CompleteTrainer
	CanvasCloseMsg
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_DefeatedAvery:
	CallIfUnset 0x21F1, CinnabarIsland_Gym_EventScript_Quiz2CompleteTrainer
	CanvasCloseMsg
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_DefeatedRamon:
	CallIfUnset 0x21F2, CinnabarIsland_Gym_EventScript_Quiz3CompleteTrainer
	CanvasCloseMsg
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_DefeatedDerek:
	CallIfUnset 0x21F3, CinnabarIsland_Gym_EventScript_Quiz4CompleteTrainer
	CanvasCloseMsg
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_DefeatedDusty:
	CallIfUnset 0x21F4, CinnabarIsland_Gym_EventScript_Quiz5CompleteTrainer
	CanvasCloseMsg
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_DefeatedZac:
	CallIfUnset 0x21F5, CinnabarIsland_Gym_EventScript_Quiz6CompleteTrainer
	CanvasCloseMsg
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_MentorBattle:
	CheckTrainerFlag 1155
	GoToIf TRUE, _cv_beaten_26
	CanvasCheckTeam 7, 0x5019
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_team_not_allowed
	TrainerBattle 1155, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_27
	WhiteOut
	End
_cv_won_27:
	SetTrainerFlag 1155
	GoTo CinnabarIsland_Gym_EventScript_DefeatedBlaine
_cv_beaten_26:
	GoTo CinnabarIsland_Gym_EventScript_AfterLeaderBattle
	
EventScript_GymHack_ShowTeamRuleMessage:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq EventScript_GymHack_MsgWrongType
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	CallIfEq EventScript_GymHack_MsgDuplicate
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	CallIfEq EventScript_GymHack_MsgDuplicateItem
	Return
	
CinnabarIsland_Gym_EventScript_DefeatedBlaine:
	SetFlag 0x21EF
	SetFlag 0x2090
	SetVar 0x8008, 7
	Call Common_EventScript_SetGymTrainers_Frlg
	GoTo CinnabarIsland_Gym_EventScript_GiveTM38
	End
	
CinnabarIsland_Gym_EventScript_AfterLeaderBattle:
	GoToIfUnset 0x21F6, CinnabarIsland_Gym_EventScript_GiveTM38
	Call GymHack_EventScript_BlaineGifts
	Call GymCandidate_EventScript_CinnabarIslandTalk
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_BlainePostBattle
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_GymGuyPostVictory:
	BufferPlayersName 6
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_GymGuyPostVictory
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymAides_EventScript_CinnabarIslandAfter:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_GymAides_Text_CinnabarIslandAfter
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_GymStatuePostVictory:
	BufferPlayersName 6
	BufferRivalsName 7
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_GymStatuePlayerWon
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_Quiz1:
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_PokemonQuizRules
	WaitButton
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_QuizQuestion1
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_28
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_29
_cv_yes_28:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_29:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq CinnabarIsland_Gym_EventScript_Quiz1Correct
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CinnabarIsland_Gym_EventScript_Quiz1Incorrect
	CloseMsg
	End
	
CinnabarIsland_Gym_EventScript_Quiz2:
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_PokemonQuizRules
	WaitButton
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_QuizQuestion2
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_30
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_31
_cv_yes_30:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_31:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq CinnabarIsland_Gym_EventScript_Quiz2Incorrect
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CinnabarIsland_Gym_EventScript_Quiz2Correct
	CloseMsg
	End
	
CinnabarIsland_Gym_EventScript_Quiz3:
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_PokemonQuizRules
	WaitButton
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_QuizQuestion3
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_32
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_33
_cv_yes_32:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_33:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq CinnabarIsland_Gym_EventScript_Quiz3Incorrect
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CinnabarIsland_Gym_EventScript_Quiz3Correct
	CloseMsg
	End
	
CinnabarIsland_Gym_EventScript_Quiz4:
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_PokemonQuizRules
	WaitButton
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_QuizQuestion4
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_34
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_35
_cv_yes_34:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_35:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq CinnabarIsland_Gym_EventScript_Quiz4Incorrect
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CinnabarIsland_Gym_EventScript_Quiz4Correct
	CloseMsg
	End
	
CinnabarIsland_Gym_EventScript_Quiz5:
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_PokemonQuizRules
	WaitButton
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_QuizQuestion5
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_36
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_37
_cv_yes_36:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_37:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq CinnabarIsland_Gym_EventScript_Quiz5Correct
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CinnabarIsland_Gym_EventScript_Quiz5Incorrect
	CloseMsg
	End
	
CinnabarIsland_Gym_EventScript_Quiz6:
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_PokemonQuizRules
	WaitButton
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_QuizQuestion6
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_38
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_39
_cv_yes_38:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_39:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq CinnabarIsland_Gym_EventScript_Quiz6Incorrect
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CinnabarIsland_Gym_EventScript_Quiz6Correct
	CloseMsg
	End
	
CinnabarIsland_Gym_OnLoadOpenAllDoors:
	Call CinnabarIsland_Gym_EventScript_OpenDoor1
	Call CinnabarIsland_Gym_EventScript_OpenDoor2
	Call CinnabarIsland_Gym_EventScript_OpenDoor3
	Call CinnabarIsland_Gym_EventScript_OpenDoor4
	Call CinnabarIsland_Gym_EventScript_OpenDoor5
	Call CinnabarIsland_Gym_EventScript_OpenDoor6
	End
	
CinnabarIsland_Gym_OnLoadOpenDoor1:
	Call CinnabarIsland_Gym_EventScript_OpenDoor1
	Return
	
CinnabarIsland_Gym_OnLoadOpenDoor2:
	Call CinnabarIsland_Gym_EventScript_OpenDoor2
	Return
	
CinnabarIsland_Gym_OnLoadOpenDoor3:
	Call CinnabarIsland_Gym_EventScript_OpenDoor3
	Return
	
CinnabarIsland_Gym_OnLoadOpenDoor4:
	Call CinnabarIsland_Gym_EventScript_OpenDoor4
	Return
	
CinnabarIsland_Gym_OnLoadOpenDoor5:
	Call CinnabarIsland_Gym_EventScript_OpenDoor5
	Return
	
CinnabarIsland_Gym_OnLoadOpenDoor6:
	Call CinnabarIsland_Gym_EventScript_OpenDoor6
	Return
	
CinnabarIsland_Gym_EventScript_Quiz1CompleteTrainer:
	Call CinnabarIsland_Gym_EventScript_Quiz1Complete
	Return
	
CinnabarIsland_Gym_EventScript_Quiz2CompleteTrainer:
	Call CinnabarIsland_Gym_EventScript_Quiz2Complete
	Return
	
CinnabarIsland_Gym_EventScript_Quiz3CompleteTrainer:
	Call CinnabarIsland_Gym_EventScript_Quiz3Complete
	Return
	
CinnabarIsland_Gym_EventScript_Quiz4CompleteTrainer:
	Call CinnabarIsland_Gym_EventScript_Quiz4Complete
	Return
	
CinnabarIsland_Gym_EventScript_Quiz5CompleteTrainer:
	Call CinnabarIsland_Gym_EventScript_Quiz5Complete
	Return
	
CinnabarIsland_Gym_EventScript_Quiz6CompleteTrainer:
	Call CinnabarIsland_Gym_EventScript_Quiz6Complete
	Return
	
EventScript_GymHack_MsgWrongType:
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_Text_GymHack_WrongType
	WaitButton
	Return
	
EventScript_GymHack_MsgDuplicate:
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_Text_GymHack_Duplicate
	WaitButton
	Return
	
EventScript_GymHack_MsgDuplicateItem:
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_Text_GymHack_DuplicateItem
	WaitButton
	Return
	
Common_EventScript_SetGymTrainers_Frlg:
	CompareVarToValue 0x8008, 1
	GoToIfEq EventScript_SetPewterGymTrainers
	CompareVarToValue 0x8008, 2
	GoToIfEq EventScript_SetCeruleanGymTrainers
	CompareVarToValue 0x8008, 3
	GoToIfEq EventScript_SetVermilionGymTrainers
	CompareVarToValue 0x8008, 4
	GoToIfEq EventScript_SetCeladonGymTrainers
	CompareVarToValue 0x8008, 5
	GoToIfEq EventScript_SetFuchsiaGymTrainers
	CompareVarToValue 0x8008, 6
	GoToIfEq EventScript_SetSaffronGymTrainers
	CompareVarToValue 0x8008, 7
	GoToIfEq EventScript_SetCinnabarGymTrainers
	CompareVarToValue 0x8008, 8
	GoToIfEq EventScript_SetViridianGymTrainers
	End
	
CinnabarIsland_Gym_EventScript_GiveTM38:
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_ExplainVolcanoBadge
	WaitButton
	HasSpaceForItem ITEM_TM38, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CinnabarIsland_Gym_EventScript_NoRoomForTM38
	GiveItem ITEM_TM38, 1, VAR_SPECIAL_RESULT
	BufferItemName 1, ITEM_TM38
	BufferPlayersName 6
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_ReceivedTM38FromBlaine
	PlayFanfare SEQ_ME_LVUP
	WaitFanfare
	WaitButton
	SetFlag 0x21F6
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_FireBlastIsUltimateFireMove
	WaitButton
	Call GymHack_EventScript_BlaineGifts
	GoTo GymCandidate_EventScript_CinnabarIslandAfterBadge
	CloseMsg
	ReleaseAll
	End
	
GymHack_EventScript_BlaineGifts:
	GoToIfSet 0x21F7, GymHack_EventScript_GiftsDone
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_GymHack_Text_BlaineSilverCap
	WaitButton
	SetVar 0x8009, 795
	Call GymHack_EventScript_GiveStatItem
	SetFlag 0x21F7
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_GymHack_Text_BlaineSilverCapAfter
	WaitButton
	Return
	
GymCandidate_EventScript_CinnabarIslandTalk:
	SetVar 0x8009, 6
	SetVar 0x800A, 11
	GoTo GymCandidate_EventScript_TalkAgain
	
CinnabarIsland_Gym_EventScript_Quiz1Correct:
	Call CinnabarIsland_Gym_EventScript_CorrectAnswer
	GoToIfSet 0x21F0, CinnabarIsland_Gym_EventScript_DoorAlreadyOpen
	Call CinnabarIsland_Gym_EventScript_Quiz1Complete
	CanvasCloseMsg
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_Quiz1Incorrect:
	Call CinnabarIsland_Gym_EventScript_IncorrectAnswer
	CheckTrainerFlag 960
	GoToIf FALSE, CinnabarIsland_Gym_EventScript_BattleQuinn
	CanvasCloseMsg
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_Quiz2Incorrect:
	Call CinnabarIsland_Gym_EventScript_IncorrectAnswer
	CheckTrainerFlag 929
	GoToIf FALSE, CinnabarIsland_Gym_EventScript_BattleAvery
	CanvasCloseMsg
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_Quiz2Correct:
	Call CinnabarIsland_Gym_EventScript_CorrectAnswer
	GoToIfSet 0x21F1, CinnabarIsland_Gym_EventScript_DoorAlreadyOpen
	Call CinnabarIsland_Gym_EventScript_Quiz2Complete
	CanvasCloseMsg
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_Quiz3Incorrect:
	Call CinnabarIsland_Gym_EventScript_IncorrectAnswer
	CheckTrainerFlag 961
	GoToIf FALSE, CinnabarIsland_Gym_EventScript_BattleRamon
	CanvasCloseMsg
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_Quiz3Correct:
	Call CinnabarIsland_Gym_EventScript_CorrectAnswer
	GoToIfSet 0x21F2, CinnabarIsland_Gym_EventScript_DoorAlreadyOpen
	Call CinnabarIsland_Gym_EventScript_Quiz3Complete
	CanvasCloseMsg
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_Quiz4Incorrect:
	Call CinnabarIsland_Gym_EventScript_IncorrectAnswer
	CheckTrainerFlag 930
	GoToIf FALSE, CinnabarIsland_Gym_EventScript_BattleDerek
	CanvasCloseMsg
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_Quiz4Correct:
	Call CinnabarIsland_Gym_EventScript_CorrectAnswer
	GoToIfSet 0x21F3, CinnabarIsland_Gym_EventScript_DoorAlreadyOpen
	Call CinnabarIsland_Gym_EventScript_Quiz4Complete
	CanvasCloseMsg
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_Quiz5Correct:
	Call CinnabarIsland_Gym_EventScript_CorrectAnswer
	GoToIfSet 0x21F4, CinnabarIsland_Gym_EventScript_DoorAlreadyOpen
	Call CinnabarIsland_Gym_EventScript_Quiz5Complete
	CanvasCloseMsg
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_Quiz5Incorrect:
	Call CinnabarIsland_Gym_EventScript_IncorrectAnswer
	CheckTrainerFlag 962
	GoToIf FALSE, CinnabarIsland_Gym_EventScript_BattleDusty
	CanvasCloseMsg
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_Quiz6Incorrect:
	Call CinnabarIsland_Gym_EventScript_IncorrectAnswer
	CheckTrainerFlag 931
	GoToIf FALSE, CinnabarIsland_Gym_EventScript_BattleZac
	CanvasCloseMsg
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_Quiz6Correct:
	Call CinnabarIsland_Gym_EventScript_CorrectAnswer
	GoToIfSet 0x21F5, CinnabarIsland_Gym_EventScript_DoorAlreadyOpen
	Call CinnabarIsland_Gym_EventScript_Quiz6Complete
	CanvasCloseMsg
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_OpenDoor1:
	// (the GBA redraws a square here: 26, 8, METATILE_CinnabarGym_Floor_WallLeftCorner, 0)
	// (the GBA redraws a square here: 27, 8, METATILE_CinnabarGym_Floor_WallRightCorner, 0)
	GoToIfSet 0x2260, _cv_bar_40
	SetFlag 0x2260
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_40
	HidePerson 204
_cv_bar_40:
	GoToIfSet 0x2261, _cv_bar_41
	SetFlag 0x2261
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_41
	HidePerson 205
_cv_bar_41:
	// (the GBA redraws a square here: 26, 10, METATILE_CinnabarGym_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 27, 10, METATILE_CinnabarGym_Floor, 0)
	// (the GBA redraws a square here: 28, 10, METATILE_CinnabarGym_Floor_ShadeDiagonal, 0)
	Return
	
CinnabarIsland_Gym_EventScript_OpenDoor2:
	// (the GBA redraws a square here: 17, 8, METATILE_CinnabarGym_Floor_WallLeftCorner, 0)
	// (the GBA redraws a square here: 18, 8, METATILE_CinnabarGym_Floor_WallRightCorner, 0)
	GoToIfSet 0x225E, _cv_bar_42
	SetFlag 0x225E
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_42
	HidePerson 202
_cv_bar_42:
	GoToIfSet 0x225F, _cv_bar_43
	SetFlag 0x225F
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_43
	HidePerson 203
_cv_bar_43:
	// (the GBA redraws a square here: 17, 10, METATILE_CinnabarGym_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 18, 10, METATILE_CinnabarGym_Floor, 0)
	// (the GBA redraws a square here: 19, 10, METATILE_CinnabarGym_Floor_ShadeDiagonal, 0)
	Return
	
CinnabarIsland_Gym_EventScript_OpenDoor3:
	// (the GBA redraws a square here: 17, 15, METATILE_CinnabarGym_Floor_WallLeftCorner, 0)
	// (the GBA redraws a square here: 18, 15, METATILE_CinnabarGym_Floor_WallRightCorner, 0)
	GoToIfSet 0x2262, _cv_bar_44
	SetFlag 0x2262
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_44
	HidePerson 206
_cv_bar_44:
	GoToIfSet 0x2263, _cv_bar_45
	SetFlag 0x2263
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_45
	HidePerson 207
_cv_bar_45:
	// (the GBA redraws a square here: 17, 17, METATILE_CinnabarGym_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 18, 17, METATILE_CinnabarGym_Floor, 0)
	// (the GBA redraws a square here: 19, 17, METATILE_CinnabarGym_Floor_ShadeDiagonal, 0)
	Return
	
CinnabarIsland_Gym_EventScript_OpenDoor4:
	// (the GBA redraws a square here: 11, 21, METATILE_CinnabarGym_Wall_RetractedBarrier, 1)
	GoToIfSet 0x2266, _cv_bar_46
	SetFlag 0x2266
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_46
	HidePerson 210
_cv_bar_46:
	GoToIfSet 0x2267, _cv_bar_47
	SetFlag 0x2267
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_47
	HidePerson 211
_cv_bar_47:
	Return
	
CinnabarIsland_Gym_EventScript_OpenDoor5:
	// (the GBA redraws a square here: 5, 16, METATILE_CinnabarGym_Floor_WallLeftCorner, 0)
	// (the GBA redraws a square here: 6, 16, METATILE_CinnabarGym_Floor_WallRightCorner, 0)
	GoToIfSet 0x2264, _cv_bar_48
	SetFlag 0x2264
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_48
	HidePerson 208
_cv_bar_48:
	GoToIfSet 0x2265, _cv_bar_49
	SetFlag 0x2265
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_49
	HidePerson 209
_cv_bar_49:
	// (the GBA redraws a square here: 5, 18, METATILE_CinnabarGym_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 6, 18, METATILE_CinnabarGym_Floor, 0)
	// (the GBA redraws a square here: 7, 18, METATILE_CinnabarGym_Floor_ShadeDiagonal, 0)
	Return
	
CinnabarIsland_Gym_EventScript_OpenDoor6:
	// (the GBA redraws a square here: 5, 8, METATILE_CinnabarGym_Floor_WallLeftCorner, 0)
	// (the GBA redraws a square here: 6, 8, METATILE_CinnabarGym_Floor_WallRightCorner, 0)
	GoToIfSet 0x225C, _cv_bar_50
	SetFlag 0x225C
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_50
	HidePerson 200
_cv_bar_50:
	GoToIfSet 0x225D, _cv_bar_51
	SetFlag 0x225D
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_51
	HidePerson 201
_cv_bar_51:
	// (the GBA redraws a square here: 5, 10, METATILE_CinnabarGym_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 6, 10, METATILE_CinnabarGym_Floor, 0)
	// (the GBA redraws a square here: 7, 10, METATILE_CinnabarGym_Floor_ShadeDiagonal, 0)
	Return
	
CinnabarIsland_Gym_EventScript_Quiz1Complete:
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	Call CinnabarIsland_Gym_EventScript_OpenDoor1
	SetFlag 0x21F0
	Return
	
CinnabarIsland_Gym_EventScript_Quiz2Complete:
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	Call CinnabarIsland_Gym_EventScript_OpenDoor2
	SetFlag 0x21F1
	Return
	
CinnabarIsland_Gym_EventScript_Quiz3Complete:
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	Call CinnabarIsland_Gym_EventScript_OpenDoor3
	SetFlag 0x21F2
	Return
	
CinnabarIsland_Gym_EventScript_Quiz4Complete:
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	Call CinnabarIsland_Gym_EventScript_OpenDoor4
	SetFlag 0x21F3
	Return
	
CinnabarIsland_Gym_EventScript_Quiz5Complete:
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	Call CinnabarIsland_Gym_EventScript_OpenDoor5
	SetFlag 0x21F4
	Return
	
CinnabarIsland_Gym_EventScript_Quiz6Complete:
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	Call CinnabarIsland_Gym_EventScript_OpenDoor6
	SetFlag 0x21F5
	Return
	
EventScript_SetPewterGymTrainers:
	SetTrainerFlag 897
	Return
	
EventScript_SetCeruleanGymTrainers:
	SetTrainerFlag 904
	SetTrainerFlag 980
	Return
	
EventScript_SetVermilionGymTrainers:
	SetTrainerFlag 896
	SetTrainerFlag 966
	SetTrainerFlag 1159
	Return
	
EventScript_SetCeladonGymTrainers:
	SetTrainerFlag 887
	SetTrainerFlag 888
	SetTrainerFlag 914
	SetTrainerFlag 1010
	SetTrainerFlag 1011
	SetTrainerFlag 1012
	SetTrainerFlag 1138
	Return
	
EventScript_SetFuchsiaGymTrainers:
	SetTrainerFlag 1039
	SetTrainerFlag 1040
	SetTrainerFlag 1033
	SetTrainerFlag 1034
	SetTrainerFlag 1037
	SetTrainerFlag 1038
	Return
	
EventScript_SetSaffronGymTrainers:
	SetTrainerFlag 1025
	SetTrainerFlag 1026
	SetTrainerFlag 1027
	SetTrainerFlag 1028
	SetTrainerFlag 1175
	SetTrainerFlag 1176
	SetTrainerFlag 1177
	Return
	
EventScript_SetCinnabarGymTrainers:
	SetTrainerFlag 928
	SetTrainerFlag 929
	SetTrainerFlag 930
	SetTrainerFlag 931
	SetTrainerFlag 960
	SetTrainerFlag 961
	SetTrainerFlag 962
	Return
	
EventScript_SetViridianGymTrainers:
	SetTrainerFlag 1041
	SetTrainerFlag 1042
	SetTrainerFlag 1067
	SetTrainerFlag 1068
	SetTrainerFlag 1069
	SetTrainerFlag 1128
	SetTrainerFlag 1136
	SetTrainerFlag 1137
	Return
	
CinnabarIsland_Gym_EventScript_NoRoomForTM38:
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_MakeSpaceForThis
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_CinnabarIslandAfterBadge:
	SetVar 0x8009, 6
	SetVar 0x800A, 11
	GoTo GymCandidate_EventScript_AfterBadge
	End
	
GymHack_EventScript_GiftsDone:
	Return
	
GymHack_EventScript_GiveStatItem:
	SetOrCopyVar 0x8004, 0x8009
	SetOrCopyVar 0x8005, 1
	HasSpaceForItem 0x8004, 0x8005, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_full_52
	CallStd std_give_item_verbose
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_given_53
_cv_full_52:
	SetVar VAR_SPECIAL_RESULT, 0
_cv_given_53:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymHack_EventScript_GiveStatItemDone
	BufferItemName 1, 0x8009
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_GymHack_Text_GiftSentToPC
	WaitButton
	GoTo GymHack_EventScript_GiveStatItemDone
	
GymCandidate_EventScript_TalkAgain:
	Call GymCandidate_EventScript_MentorGift
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_appr_54
	GoToIfUnset 0x2093, _cv_appr_54
	SetVar VAR_SPECIAL_RESULT, 1
_cv_appr_54:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_appr_55
	GoToIfUnset 0x2094, _cv_appr_55
	SetVar VAR_SPECIAL_RESULT, 1
_cv_appr_55:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_appr_56
	GoToIfUnset 0x2095, _cv_appr_56
	SetVar VAR_SPECIAL_RESULT, 1
_cv_appr_56:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_appr_57
	GoToIfUnset 0x2096, _cv_appr_57
	SetVar VAR_SPECIAL_RESULT, 1
_cv_appr_57:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_appr_58
	GoToIfUnset 0x2097, _cv_appr_58
	SetVar VAR_SPECIAL_RESULT, 1
_cv_appr_58:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_appr_59
	GoToIfUnset 0x2098, _cv_appr_59
	SetVar VAR_SPECIAL_RESULT, 1
_cv_appr_59:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_appr_60
	GoToIfUnset 0x2099, _cv_appr_60
	SetVar VAR_SPECIAL_RESULT, 1
_cv_appr_60:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_appr_61
	GoToIfUnset 0x2007, _cv_appr_61
	SetVar VAR_SPECIAL_RESULT, 1
_cv_appr_61:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_Offer
	CompareVarToValue 0x8009, 7
	GoToIfEq GymCandidate_EventScript_Return
	GoToIfSet 0x2008, GymCandidate_EventScript_OwnGym
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_next_63
	SetVar 0x401F, 12
	GoTo _cv_done_62
_cv_next_63:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_next_64
	SetVar 0x401F, 13
	GoTo _cv_done_62
_cv_next_64:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_next_65
	SetVar 0x401F, 14
	GoTo _cv_done_62
_cv_next_65:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_next_66
	SetVar 0x401F, 15
	GoTo _cv_done_62
_cv_next_66:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_next_67
	SetVar 0x401F, 16
	GoTo _cv_done_62
_cv_next_67:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_next_68
	SetVar 0x401F, 17
	GoTo _cv_done_62
_cv_next_68:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_next_69
	SetVar 0x401F, 18
	GoTo _cv_done_62
_cv_next_69:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_next_70
	SetVar 0x401F, 19
	GoTo _cv_done_62
_cv_next_70:
_cv_done_62:
	Call _cv_str4
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_71
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_72
_cv_yes_71:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_72:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_NotYet
	SetVar 0x8007, 1
	GoTo GymCandidate_EventScript_Start
	CloseMsg
	End
	
CinnabarIsland_Gym_EventScript_CorrectAnswer:
	PlayFanfare SEQ_ME_LVUP
	WaitFanfare
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_CorrectGoOnThrough
	WaitButton
	Return
	
CinnabarIsland_Gym_EventScript_DoorAlreadyOpen:
	CanvasCloseMsg
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_IncorrectAnswer:
	WaitSE SEQ_SE_DP_SELECT
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_SorryBadCall
	WaitButton
	CanvasCloseMsg
	Return
	
CinnabarIsland_Gym_EventScript_BattleQuinn:
	CompareVarToValue 0x4001, 0
	CallIfEq CinnabarIsland_Gym_EventScript_QuinnApproachLeft
	CompareVarToValue 0x4001, 1
	CallIfEq CinnabarIsland_Gym_EventScript_QuinnApproachRight
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_QuinnIntro
	WaitButton
	CanvasCloseMsg
	TrainerBattle 960, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_74
	WhiteOut
	End
_cv_won_74:
	SetTrainerFlag 960
	GoToIfSet 0x21F0, CinnabarIsland_Gym_EventScript_DoorAlreadyOpen
	Call CinnabarIsland_Gym_EventScript_Quiz1Complete
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_BattleAvery:
	CompareVarToValue 0x4001, 0
	CallIfEq CinnabarIsland_Gym_EventScript_AveryApproachLeft
	CompareVarToValue 0x4001, 1
	CallIfEq CinnabarIsland_Gym_EventScript_AveryApproachRight
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_AveryIntro
	WaitButton
	CanvasCloseMsg
	TrainerBattle 929, 929, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_76
	WhiteOut
	End
_cv_won_76:
	SetTrainerFlag 929
	GoToIfSet 0x21F1, CinnabarIsland_Gym_EventScript_DoorAlreadyOpen
	Call CinnabarIsland_Gym_EventScript_Quiz2Complete
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_BattleRamon:
	CompareVarToValue 0x4001, 0
	CallIfEq CinnabarIsland_Gym_EventScript_RamonApproachLeft
	CompareVarToValue 0x4001, 1
	CallIfEq CinnabarIsland_Gym_EventScript_RamonApproachRight
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_RamonIntro
	WaitButton
	CanvasCloseMsg
	TrainerBattle 961, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_78
	WhiteOut
	End
_cv_won_78:
	SetTrainerFlag 961
	GoToIfSet 0x21F2, CinnabarIsland_Gym_EventScript_DoorAlreadyOpen
	Call CinnabarIsland_Gym_EventScript_Quiz3Complete
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_BattleDerek:
	CompareVarToValue 0x4001, 0
	CallIfEq CinnabarIsland_Gym_EventScript_DerekApproachLeft
	CompareVarToValue 0x4001, 1
	CallIfEq CinnabarIsland_Gym_EventScript_DerekApproachRight
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_DerekIntro
	WaitButton
	CanvasCloseMsg
	TrainerBattle 930, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_80
	WhiteOut
	End
_cv_won_80:
	SetTrainerFlag 930
	GoToIfSet 0x21F3, CinnabarIsland_Gym_EventScript_DoorAlreadyOpen
	Call CinnabarIsland_Gym_EventScript_Quiz4Complete
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_BattleDusty:
	CompareVarToValue 0x4001, 0
	CallIfEq CinnabarIsland_Gym_EventScript_DustyApproachLeft
	CompareVarToValue 0x4001, 1
	CallIfEq CinnabarIsland_Gym_EventScript_DustyApproachRight
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_DustyIntro
	WaitButton
	CanvasCloseMsg
	TrainerBattle 962, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_82
	WhiteOut
	End
_cv_won_82:
	SetTrainerFlag 962
	GoToIfSet 0x21F4, CinnabarIsland_Gym_EventScript_DoorAlreadyOpen
	Call CinnabarIsland_Gym_EventScript_Quiz5Complete
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_BattleZac:
	CompareVarToValue 0x4001, 0
	CallIfEq CinnabarIsland_Gym_EventScript_ZacApproachLeft
	CompareVarToValue 0x4001, 1
	CallIfEq CinnabarIsland_Gym_EventScript_ZacApproachRight
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_ZacIntro
	WaitButton
	CanvasCloseMsg
	TrainerBattle 931, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_84
	WhiteOut
	End
_cv_won_84:
	SetTrainerFlag 931
	GoToIfSet 0x21F5, CinnabarIsland_Gym_EventScript_DoorAlreadyOpen
	Call CinnabarIsland_Gym_EventScript_Quiz6Complete
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_AfterBadge:
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_mentor_85
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_mentor_85
	SetVar 0x401F, 20
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_85:
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_mentor_86
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_mentor_86
	SetVar 0x401F, 21
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_86:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_mentor_87
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_mentor_87
	SetVar 0x401F, 22
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_87:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_mentor_88
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_mentor_88
	SetVar 0x401F, 23
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_88:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_mentor_89
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_mentor_89
	SetVar 0x401F, 24
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_89:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_mentor_90
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_mentor_90
	SetVar 0x401F, 25
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_90:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_mentor_91
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_mentor_91
	SetVar 0x401F, 26
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_91:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_mentor_92
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_mentor_92
	SetVar 0x401F, 27
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_92:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_mentor_93
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_mentor_93
	SetVar 0x401F, 28
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_93:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_mentor_94
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_mentor_94
	SetVar 0x401F, 29
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_94:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_mentor_95
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_mentor_95
	SetVar 0x401F, 30
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_95:
	CompareVarToValue 0x8009, 9
	GoToIfNe _cv_mentor_96
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_mentor_96
	SetVar 0x401F, 31
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_96:
	CompareVarToValue 0x8009, 10
	GoToIfNe _cv_mentor_97
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_mentor_97
	SetVar 0x401F, 32
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_97:
	CompareVarToValue 0x8009, 8
	GoToIfNe _cv_mentor_98
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_mentor_98
	SetVar 0x401F, 33
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_98:
	CompareVarToValue 0x8009, 9
	GoToIfNe _cv_mentor_99
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_mentor_99
	SetVar 0x401F, 34
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_99:
	CompareVarToValue 0x8009, 10
	GoToIfNe _cv_mentor_100
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_mentor_100
	SetVar 0x401F, 35
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_100:
	CompareVarToValue 0x8009, 11
	GoToIfNe _cv_mentor_101
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_mentor_101
	SetVar 0x401F, 36
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_101:
	CompareVarToValue 0x8009, 11
	GoToIfNe _cv_mentor_102
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_mentor_102
	SetVar 0x401F, 37
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_102:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq GymCandidate_EventScript_ShowText4
	Call GymCandidate_EventScript_MentorGift
	GoTo GymCandidate_EventScript_Offer
	End
	
GymHack_EventScript_GiveStatItemDone:
	Return
	
GymCandidate_EventScript_MentorGift:
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_gift_104
	GoToIfSet 0x22F3, _cv_gift_103
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_106
	SetFlag 0x22F3
	SetVar 0x8004, 2696
	SetVar 0x4020, SPRITE_GSLEADER14
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_105
_cv_next_106:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_107
	SetFlag 0x22F3
	SetVar 0x8004, 2686
	SetVar 0x4020, SPRITE_GSLEADER14
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_105
_cv_next_107:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_108
	SetFlag 0x22F3
	SetVar 0x8004, 2706
	SetVar 0x4020, SPRITE_GSLEADER11
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_105
_cv_next_108:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_109
	SetFlag 0x22F3
	SetVar 0x8004, 2710
	SetVar 0x4020, SPRITE_GSLEADER9
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_105
_cv_next_109:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_110
	SetFlag 0x22F3
	SetVar 0x8004, 2702
	SetVar 0x4020, SPRITE_GSLEADER9
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_105
_cv_next_110:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_111
	SetFlag 0x22F3
	SetVar 0x8004, 2708
	SetVar 0x4020, SPRITE_GSLEADER12
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_105
_cv_next_111:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_112
	SetFlag 0x22F3
	SetVar 0x8004, 2692
	SetVar 0x4020, SPRITE_GSBIGFOUR2
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_105
_cv_next_112:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_113
	SetFlag 0x22F3
	SetVar 0x8004, 2698
	SetVar 0x4020, SPRITE_GSBIGFOUR2
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_105
_cv_next_113:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_114
	SetFlag 0x22F3
	SetVar 0x8004, 2712
	SetVar 0x4020, SPRITE_GSLEADER10
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_105
_cv_next_114:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_115
	SetFlag 0x22F3
	SetVar 0x8004, 2720
	SetVar 0x4020, SPRITE_GSLEADER10
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_105
_cv_next_115:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_116
	SetFlag 0x22F3
	SetVar 0x8004, 2704
	SetVar 0x4020, SPRITE_GSLEADER15
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_105
_cv_next_116:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_117
	SetFlag 0x22F3
	SetVar 0x8004, 2694
	SetVar 0x4020, SPRITE_GSBIGFOUR3
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_105
_cv_next_117:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_118
	SetFlag 0x22F3
	SetVar 0x8004, 2718
	SetVar 0x4020, SPRITE_GSOLDWOMAN1
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_105
_cv_next_118:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_119
	SetFlag 0x22F3
	SetVar 0x8004, 2714
	SetVar 0x4020, SPRITE_GSBIGFOUR4
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_105
_cv_next_119:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_120
	SetFlag 0x22F3
	SetVar 0x8004, 2688
	SetVar 0x4020, SPRITE_GSBIGFOUR3
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_105
_cv_next_120:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_121
	SetFlag 0x22F3
	SetVar 0x8004, 2700
	SetVar 0x4020, SPRITE_GSOLDWOMAN1
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_105
_cv_next_121:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_122
	SetFlag 0x22F3
	SetVar 0x8004, 2716
	SetVar 0x4020, SPRITE_WATARU
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_105
_cv_next_122:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_123
	SetFlag 0x22F3
	SetVar 0x8004, 2690
	SetVar 0x4020, SPRITE_WATARU
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_105
_cv_next_123:
_cv_done_105:
	GoTo _cv_gift_103
_cv_gift_104:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_gift_124
	GoToIfSet 0x22F4, _cv_gift_103
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_126
	SetFlag 0x22F4
	SetVar 0x8004, 2697
	SetVar 0x4020, SPRITE_GSLEADER14
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_125
_cv_next_126:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_127
	SetFlag 0x22F4
	SetVar 0x8004, 2687
	SetVar 0x4020, SPRITE_GSLEADER14
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_125
_cv_next_127:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_128
	SetFlag 0x22F4
	SetVar 0x8004, 2707
	SetVar 0x4020, SPRITE_GSLEADER11
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_125
_cv_next_128:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_129
	SetFlag 0x22F4
	SetVar 0x8004, 2711
	SetVar 0x4020, SPRITE_GSLEADER9
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_125
_cv_next_129:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_130
	SetFlag 0x22F4
	SetVar 0x8004, 2703
	SetVar 0x4020, SPRITE_GSLEADER9
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_125
_cv_next_130:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_131
	SetFlag 0x22F4
	SetVar 0x8004, 2709
	SetVar 0x4020, SPRITE_GSLEADER12
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_125
_cv_next_131:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_132
	SetFlag 0x22F4
	SetVar 0x8004, 2693
	SetVar 0x4020, SPRITE_GSBIGFOUR2
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_125
_cv_next_132:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_133
	SetFlag 0x22F4
	SetVar 0x8004, 2699
	SetVar 0x4020, SPRITE_GSBIGFOUR2
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_125
_cv_next_133:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_134
	SetFlag 0x22F4
	SetVar 0x8004, 2713
	SetVar 0x4020, SPRITE_GSLEADER10
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_125
_cv_next_134:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_135
	SetFlag 0x22F4
	SetVar 0x8004, 2721
	SetVar 0x4020, SPRITE_GSLEADER10
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_125
_cv_next_135:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_136
	SetFlag 0x22F4
	SetVar 0x8004, 2705
	SetVar 0x4020, SPRITE_GSLEADER15
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_125
_cv_next_136:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_137
	SetFlag 0x22F4
	SetVar 0x8004, 2695
	SetVar 0x4020, SPRITE_GSBIGFOUR3
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_125
_cv_next_137:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_138
	SetFlag 0x22F4
	SetVar 0x8004, 2719
	SetVar 0x4020, SPRITE_GSOLDWOMAN1
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_125
_cv_next_138:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_139
	SetFlag 0x22F4
	SetVar 0x8004, 2715
	SetVar 0x4020, SPRITE_GSBIGFOUR4
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_125
_cv_next_139:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_140
	SetFlag 0x22F4
	SetVar 0x8004, 2689
	SetVar 0x4020, SPRITE_GSBIGFOUR3
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_125
_cv_next_140:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_141
	SetFlag 0x22F4
	SetVar 0x8004, 2701
	SetVar 0x4020, SPRITE_GSOLDWOMAN1
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_125
_cv_next_141:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_142
	SetFlag 0x22F4
	SetVar 0x8004, 2717
	SetVar 0x4020, SPRITE_WATARU
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_125
_cv_next_142:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_143
	SetFlag 0x22F4
	SetVar 0x8004, 2691
	SetVar 0x4020, SPRITE_WATARU
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_125
_cv_next_143:
_cv_done_125:
	GoTo _cv_gift_103
_cv_gift_124:
_cv_gift_103:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_Return
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymCandidate_EventScript_MentorGiveItem
	PlaySE SEQ_SE_DP_DOOR
	BufferPlayersName 6
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_GymCandidate_Text_SomeoneToSeeYou
	WaitButton
	CanvasCloseMsg
	Call GymCandidate_EventScript_VisitorWalksIn
	Call GymCandidate_EventScript_MentorGiveItem
	Call GymCandidate_EventScript_VisitorWalksOut
	Return
	
GymCandidate_EventScript_Offer:
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_next_145
	SetVar 0x401F, 38
	GoTo _cv_done_144
_cv_next_145:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_next_146
	SetVar 0x401F, 39
	GoTo _cv_done_144
_cv_next_146:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_next_147
	SetVar 0x401F, 40
	GoTo _cv_done_144
_cv_next_147:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_next_148
	SetVar 0x401F, 41
	GoTo _cv_done_144
_cv_next_148:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_next_149
	SetVar 0x401F, 42
	GoTo _cv_done_144
_cv_next_149:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_next_150
	SetVar 0x401F, 43
	GoTo _cv_done_144
_cv_next_150:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_next_151
	SetVar 0x401F, 44
	GoTo _cv_done_144
_cv_next_151:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_next_152
	SetVar 0x401F, 45
	GoTo _cv_done_144
_cv_next_152:
_cv_done_144:
	Call _cv_str4
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_153
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_154
_cv_yes_153:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_154:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_NotYet
	SetVar 0x8007, 0
	GoTo GymCandidate_EventScript_Start
	
GymCandidate_EventScript_Return:
	Return
	
GymCandidate_EventScript_OwnGym:
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_next_156
	SetVar 0x401F, 46
	GoTo _cv_done_155
_cv_next_156:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_next_157
	SetVar 0x401F, 47
	GoTo _cv_done_155
_cv_next_157:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_next_158
	SetVar 0x401F, 48
	GoTo _cv_done_155
_cv_next_158:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_next_159
	SetVar 0x401F, 49
	GoTo _cv_done_155
_cv_next_159:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_next_160
	SetVar 0x401F, 50
	GoTo _cv_done_155
_cv_next_160:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_next_161
	SetVar 0x401F, 51
	GoTo _cv_done_155
_cv_next_161:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_next_162
	SetVar 0x401F, 52
	GoTo _cv_done_155
_cv_next_162:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_next_163
	SetVar 0x401F, 53
	GoTo _cv_done_155
_cv_next_163:
_cv_done_155:
	Call _cv_str4
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_NotYet:
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_GymCandidate_Text_NotYet
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_Start:
	CanvasCheckTeam 7, 0x5019
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe GymCandidate_EventScript_TeamBreaksRules
	SetVar 0x800B, 0
	Call GymCandidate_EventScript_TakeLeadersPlace
	GoTo GymCandidate_EventScript_NextGuest
	
CinnabarIsland_Gym_EventScript_QuinnApproachLeft:
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterRight
	ApplyMovement 1, CinnabarIsland_Gym_Movement_QuinnApproachLeft
	WaitMovement
	Return
	
CinnabarIsland_Gym_EventScript_QuinnApproachRight:
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterRight
	ApplyMovement 1, CinnabarIsland_Gym_Movement_QuinnApproachRight
	WaitMovement
	Return
	
CinnabarIsland_Gym_EventScript_AveryApproachLeft:
	ApplyMovement obj_player, CinnabarIsland_Gym_Movement_PlayerFaceAvery
	ApplyMovement 3, CinnabarIsland_Gym_Movement_AveryApproachLeft
	WaitMovement
	Return
	
CinnabarIsland_Gym_EventScript_AveryApproachRight:
	ApplyMovement obj_player, CinnabarIsland_Gym_Movement_PlayerFaceAvery
	ApplyMovement 3, CinnabarIsland_Gym_Movement_AveryApproachRight
	WaitMovement
	Return
	
CinnabarIsland_Gym_EventScript_RamonApproachLeft:
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterRight
	ApplyMovement 4, CinnabarIsland_Gym_Movement_RamonApproachLeft
	WaitMovement
	Return
	
CinnabarIsland_Gym_EventScript_RamonApproachRight:
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterRight
	ApplyMovement 4, CinnabarIsland_Gym_Movement_RamonApproachRight
	WaitMovement
	Return
	
CinnabarIsland_Gym_EventScript_DerekApproachLeft:
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterRight
	ApplyMovement 5, CinnabarIsland_Gym_Movement_DerekApproachLeft
	WaitMovement
	Return
	
CinnabarIsland_Gym_EventScript_DerekApproachRight:
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterRight
	ApplyMovement 5, CinnabarIsland_Gym_Movement_DerekApproachRight
	WaitMovement
	Return
	
CinnabarIsland_Gym_EventScript_DustyApproachLeft:
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterRight
	ApplyMovement 6, CinnabarIsland_Gym_Movement_DustyApproachLeft
	WaitMovement
	Return
	
CinnabarIsland_Gym_EventScript_DustyApproachRight:
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterRight
	ApplyMovement 6, CinnabarIsland_Gym_Movement_DustyApproachRight
	WaitMovement
	Return
	
CinnabarIsland_Gym_EventScript_ZacApproachLeft:
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterRight
	ApplyMovement 7, CinnabarIsland_Gym_Movement_ZacApproachLeft
	WaitMovement
	Return
	
CinnabarIsland_Gym_EventScript_ZacApproachRight:
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterRight
	ApplyMovement 7, CinnabarIsland_Gym_Movement_ZacApproachRight
	WaitMovement
	Return
	
GymCandidate_EventScript_ShowText4:
	Call _cv_str4
	WaitButton
	Return
	
GymCandidate_EventScript_MentorGiveItem:
	CompareVarToValue 0x8009, 6
	GoToIfEq _cv_gift_164
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_167
	SetVar 0x401F, 54
	GoTo _cv_done_166
_cv_next_167:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_168
	SetVar 0x401F, 54
	GoTo _cv_done_166
_cv_next_168:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_169
	SetVar 0x401F, 55
	GoTo _cv_done_166
_cv_next_169:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_170
	SetVar 0x401F, 56
	GoTo _cv_done_166
_cv_next_170:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_171
	SetVar 0x401F, 56
	GoTo _cv_done_166
_cv_next_171:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_172
	SetVar 0x401F, 57
	GoTo _cv_done_166
_cv_next_172:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_173
	SetVar 0x401F, 58
	GoTo _cv_done_166
_cv_next_173:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_174
	SetVar 0x401F, 58
	GoTo _cv_done_166
_cv_next_174:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_175
	SetVar 0x401F, 59
	GoTo _cv_done_166
_cv_next_175:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_176
	SetVar 0x401F, 59
	GoTo _cv_done_166
_cv_next_176:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_177
	SetVar 0x401F, 60
	GoTo _cv_done_166
_cv_next_177:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_178
	SetVar 0x401F, 61
	GoTo _cv_done_166
_cv_next_178:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_179
	SetVar 0x401F, 62
	GoTo _cv_done_166
_cv_next_179:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_180
	SetVar 0x401F, 63
	GoTo _cv_done_166
_cv_next_180:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_181
	SetVar 0x401F, 61
	GoTo _cv_done_166
_cv_next_181:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_182
	SetVar 0x401F, 62
	GoTo _cv_done_166
_cv_next_182:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_183
	SetVar 0x401F, 64
	GoTo _cv_done_166
_cv_next_183:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_184
	SetVar 0x401F, 64
	GoTo _cv_done_166
_cv_next_184:
_cv_done_166:
	GoTo _cv_gift_165
_cv_gift_164:
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_186
	SetVar 0x401F, 65
	GoTo _cv_done_185
_cv_next_186:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_187
	SetVar 0x401F, 65
	GoTo _cv_done_185
_cv_next_187:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_188
	SetVar 0x401F, 66
	GoTo _cv_done_185
_cv_next_188:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_189
	SetVar 0x401F, 67
	GoTo _cv_done_185
_cv_next_189:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_190
	SetVar 0x401F, 67
	GoTo _cv_done_185
_cv_next_190:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_191
	SetVar 0x401F, 68
	GoTo _cv_done_185
_cv_next_191:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_192
	SetVar 0x401F, 69
	GoTo _cv_done_185
_cv_next_192:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_193
	SetVar 0x401F, 69
	GoTo _cv_done_185
_cv_next_193:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_194
	SetVar 0x401F, 70
	GoTo _cv_done_185
_cv_next_194:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_195
	SetVar 0x401F, 70
	GoTo _cv_done_185
_cv_next_195:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_196
	SetVar 0x401F, 71
	GoTo _cv_done_185
_cv_next_196:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_197
	SetVar 0x401F, 72
	GoTo _cv_done_185
_cv_next_197:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_198
	SetVar 0x401F, 73
	GoTo _cv_done_185
_cv_next_198:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_199
	SetVar 0x401F, 74
	GoTo _cv_done_185
_cv_next_199:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_200
	SetVar 0x401F, 72
	GoTo _cv_done_185
_cv_next_200:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_201
	SetVar 0x401F, 73
	GoTo _cv_done_185
_cv_next_201:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_202
	SetVar 0x401F, 75
	GoTo _cv_done_185
_cv_next_202:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_203
	SetVar 0x401F, 75
	GoTo _cv_done_185
_cv_next_203:
_cv_done_185:
_cv_gift_165:
	Call _cv_str4
	WaitButton
	SetOrCopyVar 0x8004, 0x8004
	SetOrCopyVar 0x8005, 1
	HasSpaceForItem 0x8004, 0x8005, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_full_204
	CallStd std_give_item_verbose
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_given_205
_cv_full_204:
	SetVar VAR_SPECIAL_RESULT, 0
_cv_given_205:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymCandidate_EventScript_MentorItemExplain
	BufferItemName 1, 0x8004
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_GymHack_Text_GiftSentToPC
	WaitButton
	GoTo GymCandidate_EventScript_MentorItemExplain
	
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
	
GymCandidate_EventScript_TeamBreaksRules:
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfEq GymCandidate_EventScript_ItemClause
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_GymCandidate_Text_TeamBreaksRules
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_TakeLeadersPlace:
	CanvasCandidate 7
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_Return
	CompareVarToValue 0x8007, 0
	GoToIfEq _cv_hold_206
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_next_208
	CanvasBufferMsg 2, msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_0
	GoTo _cv_done_207
_cv_next_208:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_next_209
	CanvasBufferMsg 2, msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_1
	GoTo _cv_done_207
_cv_next_209:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_next_210
	CanvasBufferMsg 2, msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_2
	GoTo _cv_done_207
_cv_next_210:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_next_211
	CanvasBufferMsg 2, msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_3
	GoTo _cv_done_207
_cv_next_211:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_next_212
	CanvasBufferMsg 2, msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_4
	GoTo _cv_done_207
_cv_next_212:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_next_213
	CanvasBufferMsg 2, msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_5
	GoTo _cv_done_207
_cv_next_213:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_next_214
	CanvasBufferMsg 2, msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_6
	GoTo _cv_done_207
_cv_next_214:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_next_215
	CanvasBufferMsg 2, msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_7
	GoTo _cv_done_207
_cv_next_215:
_cv_done_207:
	SetVar 0x401F, 76
	GoTo _cv_hold_216
_cv_hold_206:
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_next_218
	SetVar 0x401F, 77
	GoTo _cv_done_217
_cv_next_218:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_next_219
	SetVar 0x401F, 78
	GoTo _cv_done_217
_cv_next_219:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_next_220
	SetVar 0x401F, 79
	GoTo _cv_done_217
_cv_next_220:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_next_221
	SetVar 0x401F, 80
	GoTo _cv_done_217
_cv_next_221:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_next_222
	SetVar 0x401F, 81
	GoTo _cv_done_217
_cv_next_222:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_next_223
	SetVar 0x401F, 82
	GoTo _cv_done_217
_cv_next_223:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_next_224
	SetVar 0x401F, 83
	GoTo _cv_done_217
_cv_next_224:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_next_225
	SetVar 0x401F, 84
	GoTo _cv_done_217
_cv_next_225:
_cv_done_217:
_cv_hold_216:
	Call _cv_str4
	WaitButton
	CanvasCloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	CanvasCandidate 8, 0x8007
	CanvasCandidate 11, 0
	WaitMovement
	Wait 30, VAR_SPECIAL_RESULT
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	Return
	
GymCandidate_EventScript_NextGuest:
	HealParty
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_guest_226
	CanvasBufferMsg 2, msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_0
	CanvasCandidate 0, 12, 2, 0, 0x8007
_cv_guest_226:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_guest_227
	CanvasBufferMsg 2, msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_1
	CanvasCandidate 0, 20, 3, 0, 0x8007
_cv_guest_227:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_guest_228
	CanvasBufferMsg 2, msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_2
	CanvasCandidate 0, 24, 3, 1, 0x8007
_cv_guest_228:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_guest_229
	CanvasBufferMsg 2, msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_3
	CanvasCandidate 0, 29, 4, 1, 0x8007
_cv_guest_229:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_guest_230
	CanvasBufferMsg 2, msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_4
	CanvasCandidate 0, 37, 4, 1, 0x8007
_cv_guest_230:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_guest_231
	CanvasBufferMsg 2, msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_5
	CanvasCandidate 0, 40, 4, 2, 0x8007
_cv_guest_231:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_guest_232
	CanvasBufferMsg 2, msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_6
	CanvasCandidate 0, 44, 5, 2, 0x8007
_cv_guest_232:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_guest_233
	CanvasBufferMsg 2, msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_7
	CanvasCandidate 0, 47, 5, 2, 0x8007
_cv_guest_233:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_next_235
	SetVar 0x4020, SPRITE_GSMAN3
	GoTo _cv_done_234
_cv_next_235:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfNe _cv_next_236
	SetVar 0x4020, SPRITE_GSWOMAN3
	GoTo _cv_done_234
_cv_next_236:
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfNe _cv_next_237
	SetVar 0x4020, SPRITE_GSMAN3
	GoTo _cv_done_234
_cv_next_237:
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfNe _cv_next_238
	SetVar 0x4020, SPRITE_GSWOMAN3
	GoTo _cv_done_234
_cv_next_238:
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfNe _cv_next_239
	SetVar 0x4020, SPRITE_GSFIGHTER
	GoTo _cv_done_234
_cv_next_239:
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfNe _cv_next_240
	SetVar 0x4020, SPRITE_GSGENTLEMAN
	GoTo _cv_done_234
_cv_next_240:
	CompareVarToValue VAR_SPECIAL_RESULT, 6
	GoToIfNe _cv_next_241
	SetVar 0x4020, SPRITE_MOUNT_2
	GoTo _cv_done_234
_cv_next_241:
	CompareVarToValue VAR_SPECIAL_RESULT, 7
	GoToIfNe _cv_next_242
	SetVar 0x4020, SPRITE_GSMAN2
	GoTo _cv_done_234
_cv_next_242:
	CompareVarToValue VAR_SPECIAL_RESULT, 8
	GoToIfNe _cv_next_243
	SetVar 0x4020, SPRITE_BADMAN
	GoTo _cv_done_234
_cv_next_243:
	CompareVarToValue VAR_SPECIAL_RESULT, 9
	GoToIfNe _cv_next_244
	SetVar 0x4020, SPRITE_WORKMAN
	GoTo _cv_done_234
_cv_next_244:
	CompareVarToValue VAR_SPECIAL_RESULT, 10
	GoToIfNe _cv_next_245
	SetVar 0x4020, SPRITE_GSASSISTANTM
	GoTo _cv_done_234
_cv_next_245:
	CompareVarToValue VAR_SPECIAL_RESULT, 11
	GoToIfNe _cv_next_246
	SetVar 0x4020, SPRITE_MANIA
	GoTo _cv_done_234
_cv_next_246:
	CompareVarToValue VAR_SPECIAL_RESULT, 12
	GoToIfNe _cv_next_247
	SetVar 0x4020, SPRITE_CAMPBOY_2
	GoTo _cv_done_234
_cv_next_247:
	CompareVarToValue VAR_SPECIAL_RESULT, 13
	GoToIfNe _cv_next_248
	SetVar 0x4020, SPRITE_SEAMAN_2
	GoTo _cv_done_234
_cv_next_248:
	CompareVarToValue VAR_SPECIAL_RESULT, 14
	GoToIfNe _cv_next_249
	SetVar 0x4020, SPRITE_FISHING_2
	GoTo _cv_done_234
_cv_next_249:
	CompareVarToValue VAR_SPECIAL_RESULT, 15
	GoToIfNe _cv_next_250
	SetVar 0x4020, SPRITE_GSBOY2
	GoTo _cv_done_234
_cv_next_250:
	CompareVarToValue VAR_SPECIAL_RESULT, 16
	GoToIfNe _cv_next_251
	SetVar 0x4020, SPRITE_WOMAN2
	GoTo _cv_done_234
_cv_next_251:
	CompareVarToValue VAR_SPECIAL_RESULT, 17
	GoToIfNe _cv_next_252
	SetVar 0x4020, SPRITE_GSGIRL2
	GoTo _cv_done_234
_cv_next_252:
	CompareVarToValue VAR_SPECIAL_RESULT, 18
	GoToIfNe _cv_next_253
	SetVar 0x4020, SPRITE_PICNICGIRL_2
	GoTo _cv_done_234
_cv_next_253:
	CompareVarToValue VAR_SPECIAL_RESULT, 19
	GoToIfNe _cv_next_254
	SetVar 0x4020, SPRITE_GSGIRL3
	GoTo _cv_done_234
_cv_next_254:
	CompareVarToValue VAR_SPECIAL_RESULT, 20
	GoToIfNe _cv_next_255
	SetVar 0x4020, SPRITE_GSSWIMMERW
	GoTo _cv_done_234
_cv_next_255:
	CompareVarToValue VAR_SPECIAL_RESULT, 21
	GoToIfNe _cv_next_256
	SetVar 0x4020, SPRITE_GSSWIMMERM
	GoTo _cv_done_234
_cv_next_256:
_cv_done_234:
	Random 0x5048, 4
	Random 0x5049, 3
	Random 0x504A, 3
	Random 0x504B, 2
	SetVar 0x504C, 0
	GoToIfUnset 0x208D, _cv_single_257
	Random 0x401E, 3
	CompareVarToValue 0x401E, 0
	GoToIfEq _cv_single_257
	SetVar 0x504C, 1
_cv_single_257:
	CompareVarToValue 0x800B, 0
	CallIfEq GymCandidate_EventScript_LaterThatDay
	CompareVarToValue 0x800B, 0
	CallIfNe GymCandidate_EventScript_AnotherOne
	CanvasCloseMsg
	Call GymCandidate_EventScript_ChallengerWalksIn
	CompareVarToValue 0x5048, 0
	GoToIfNe _cv_line_259
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_guest_intro_0
	WaitButton
	GoTo _cv_line_258
_cv_line_259:
	CompareVarToValue 0x5048, 1
	GoToIfNe _cv_line_260
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_guest_intro_1
	WaitButton
	GoTo _cv_line_258
_cv_line_260:
	CompareVarToValue 0x5048, 2
	GoToIfNe _cv_line_261
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_guest_intro_2
	WaitButton
	GoTo _cv_line_258
_cv_line_261:
	CompareVarToValue 0x5048, 3
	GoToIfNe _cv_line_262
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_guest_intro_3
	WaitButton
	GoTo _cv_line_258
_cv_line_262:
_cv_line_258:
	CanvasCloseMsg
	CanvasCloseMsg
	CompareVarToValue 0x504C, 0
	GoToIfNe _cv_battle_264
	CompareVarToValue 0x5049, 0
	GoToIfNe _cv_battle_264
	ClearTrainerFlag 1470
	TrainerBattle 1470, 0, 1, 0
	GoTo _cv_battle_263
_cv_battle_264:
	CompareVarToValue 0x504C, 0
	GoToIfNe _cv_battle_265
	CompareVarToValue 0x5049, 1
	GoToIfNe _cv_battle_265
	ClearTrainerFlag 1471
	TrainerBattle 1471, 0, 1, 0
	GoTo _cv_battle_263
_cv_battle_265:
	CompareVarToValue 0x504C, 0
	GoToIfNe _cv_battle_266
	CompareVarToValue 0x5049, 2
	GoToIfNe _cv_battle_266
	ClearTrainerFlag 1472
	TrainerBattle 1472, 0, 1, 0
	GoTo _cv_battle_263
_cv_battle_266:
	CompareVarToValue 0x504C, 1
	GoToIfNe _cv_battle_267
	CompareVarToValue 0x5049, 0
	GoToIfNe _cv_battle_267
	ClearTrainerFlag 1473
	TrainerBattle 1473, 1473, 1, 0
	GoTo _cv_battle_263
_cv_battle_267:
	CompareVarToValue 0x504C, 1
	GoToIfNe _cv_battle_268
	CompareVarToValue 0x5049, 1
	GoToIfNe _cv_battle_268
	ClearTrainerFlag 1474
	TrainerBattle 1474, 1474, 1, 0
	GoTo _cv_battle_263
_cv_battle_268:
	CompareVarToValue 0x504C, 1
	GoToIfNe _cv_battle_269
	CompareVarToValue 0x5049, 2
	GoToIfNe _cv_battle_269
	ClearTrainerFlag 1475
	TrainerBattle 1475, 1475, 1, 0
	GoTo _cv_battle_263
_cv_battle_269:
_cv_battle_263:
	CheckBattleWon VAR_SPECIAL_RESULT
	CanvasCandidate 12
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfNe GymCandidate_EventScript_GuestWon
	HealParty
	CompareVarToValue 0x504A, 0
	GoToIfNe _cv_line_271
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_guest_after_0
	WaitButton
	GoTo _cv_line_270
_cv_line_271:
	CompareVarToValue 0x504A, 1
	GoToIfNe _cv_line_272
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_guest_after_1
	WaitButton
	GoTo _cv_line_270
_cv_line_272:
	CompareVarToValue 0x504A, 2
	GoToIfNe _cv_line_273
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_guest_after_2
	WaitButton
	GoTo _cv_line_270
_cv_line_273:
_cv_line_270:
	Call GymCandidate_EventScript_VisitorWalksOut
	AddVar 0x800B, 1
	SetVar VAR_SPECIAL_RESULT, 0
	SetVar 0x401E, 1
	CompareVarToValue 0x8007, 0
	GoToIfNe _cv_guests_274
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_next_276
	SetVar 0x401E, 1
	GoTo _cv_done_275
_cv_next_276:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_next_277
	SetVar 0x401E, 1
	GoTo _cv_done_275
_cv_next_277:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_next_278
	SetVar 0x401E, 1
	GoTo _cv_done_275
_cv_next_278:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_next_279
	SetVar 0x401E, 1
	GoTo _cv_done_275
_cv_next_279:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_next_280
	SetVar 0x401E, 2
	GoTo _cv_done_275
_cv_next_280:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_next_281
	SetVar 0x401E, 2
	GoTo _cv_done_275
_cv_next_281:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_next_282
	SetVar 0x401E, 2
	GoTo _cv_done_275
_cv_next_282:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_next_283
	SetVar 0x401E, 2
	GoTo _cv_done_275
_cv_next_283:
_cv_done_275:
_cv_guests_274:
	CompareVarToVar 0x800B, 0x401E
	GoToIfGe _cv_guests_284
	SetVar VAR_SPECIAL_RESULT, 1
_cv_guests_284:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymCandidate_EventScript_NextGuest
	Call GymCandidate_EventScript_ReturnLeadersPlace
	CompareVarToValue 0x8007, 1
	GoToIfEq GymCandidate_EventScript_ShiftDone
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_next_304
	SetFlag 0x2093
	SetVar 0x401F, 85
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_286
	SetVar 0x401F, 86
	GoTo _cv_done_285
_cv_next_286:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_287
	SetVar 0x401F, 87
	GoTo _cv_done_285
_cv_next_287:
_cv_done_285:
	GoTo _cv_done_303
_cv_next_304:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_next_305
	SetFlag 0x2094
	SetVar 0x401F, 88
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_289
	SetVar 0x401F, 89
	GoTo _cv_done_288
_cv_next_289:
_cv_done_288:
	GoTo _cv_done_303
_cv_next_305:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_next_306
	SetFlag 0x2095
	SetVar 0x401F, 90
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_291
	SetVar 0x401F, 91
	GoTo _cv_done_290
_cv_next_291:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_292
	SetVar 0x401F, 92
	GoTo _cv_done_290
_cv_next_292:
_cv_done_290:
	GoTo _cv_done_303
_cv_next_306:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_next_307
	SetFlag 0x2096
	SetVar 0x401F, 93
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_294
	SetVar 0x401F, 94
	GoTo _cv_done_293
_cv_next_294:
_cv_done_293:
	GoTo _cv_done_303
_cv_next_307:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_next_308
	SetFlag 0x2097
	SetVar 0x401F, 95
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_296
	SetVar 0x401F, 96
	GoTo _cv_done_295
_cv_next_296:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_297
	SetVar 0x401F, 97
	GoTo _cv_done_295
_cv_next_297:
_cv_done_295:
	GoTo _cv_done_303
_cv_next_308:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_next_309
	SetFlag 0x2098
	SetVar 0x401F, 98
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_299
	SetVar 0x401F, 99
	GoTo _cv_done_298
_cv_next_299:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_300
	SetVar 0x401F, 100
	GoTo _cv_done_298
_cv_next_300:
_cv_done_298:
	GoTo _cv_done_303
_cv_next_309:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_next_310
	SetFlag 0x2099
	SetVar 0x401F, 101
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_302
	SetVar 0x401F, 102
	GoTo _cv_done_301
_cv_next_302:
_cv_done_301:
	GoTo _cv_done_303
_cv_next_310:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_next_311
	SetFlag 0x2007
	SetVar 0x401F, 103
	GoTo _cv_done_303
_cv_next_311:
_cv_done_303:
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x2093, _cv_appr_312
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_312:
	GoToIfUnset 0x2094, _cv_appr_313
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_313:
	GoToIfUnset 0x2095, _cv_appr_314
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_314:
	GoToIfUnset 0x2096, _cv_appr_315
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_315:
	GoToIfUnset 0x2097, _cv_appr_316
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_316:
	GoToIfUnset 0x2098, _cv_appr_317
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_317:
	GoToIfUnset 0x2099, _cv_appr_318
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_318:
	GoToIfUnset 0x2007, _cv_appr_319
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_319:
	BufferInt 0, VAR_SPECIAL_RESULT
	PlayFanfare SEQ_ME_LVUP
	Call _cv_str4
	WaitButton
	WaitFanfare
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_GymCandidate_Text_ApprovalCount
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_MentorItemExplain:
	BufferItemName 0, 0x8004
	CompareVarToValue 0x8009, 6
	GoToIfEq GymCandidate_EventScript_EdgeItemExplain
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_GymCandidate_Text_GuardItemExplain
	WaitButton
	Call Outfits_EventScript_GymUniform
	Return
	
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
	
GymCandidate_EventScript_ItemClause:
	Call EventScript_GymHack_ShowTeamRuleMessage
	CanvasCloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_LaterThatDay:
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_GymCandidate_Text_LaterThatDay
	WaitButton
	Return
	
GymCandidate_EventScript_AnotherOne:
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_GymCandidate_Text_AnotherOne
	WaitButton
	Return
	
GymCandidate_EventScript_ChallengerWalksIn:
	CanvasCandidate 4, 1
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_ChallengerAppears
	MovePerson 0x800A, 0x8005, 0x8006
	ClearFlag 0x2017
	ShowPerson 0x800A
	PlaySE SEQ_SE_DP_KAIDAN2
	CanvasCandidate 5, 0x800A, 0
	WaitMovement
	CanvasCandidate 2, 0x800A
	Return
	
GymCandidate_EventScript_GuestWon:
	HealParty
	CompareVarToValue 0x504B, 0
	GoToIfNe _cv_line_321
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_guest_win_0
	WaitButton
	GoTo _cv_line_320
_cv_line_321:
	CompareVarToValue 0x504B, 1
	GoToIfNe _cv_line_322
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_guest_win_1
	WaitButton
	GoTo _cv_line_320
_cv_line_322:
_cv_line_320:
	Call GymCandidate_EventScript_VisitorWalksOut
	Call GymCandidate_EventScript_ReturnLeadersPlace
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_GymCandidate_Text_TryAgain
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_ReturnLeadersPlace:
	CanvasCandidate 9
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_Return
	CanvasCloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	CanvasCandidate 11, 1
	WaitMovement
	CanvasCandidate 10
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	Return
	
GymCandidate_EventScript_ShiftDone:
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_next_324
	SetVar 0x401F, 104
	GoTo _cv_done_323
_cv_next_324:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_next_325
	SetVar 0x401F, 105
	GoTo _cv_done_323
_cv_next_325:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_next_326
	SetVar 0x401F, 106
	GoTo _cv_done_323
_cv_next_326:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_next_327
	SetVar 0x401F, 107
	GoTo _cv_done_323
_cv_next_327:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_next_328
	SetVar 0x401F, 108
	GoTo _cv_done_323
_cv_next_328:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_next_329
	SetVar 0x401F, 109
	GoTo _cv_done_323
_cv_next_329:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_next_330
	SetVar 0x401F, 110
	GoTo _cv_done_323
_cv_next_330:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_next_331
	SetVar 0x401F, 111
	GoTo _cv_done_323
_cv_next_331:
_cv_done_323:
	Call _cv_str4
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_EdgeItemExplain:
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_GymCandidate_Text_EdgeItemExplain
	WaitButton
	Return
	
Outfits_EventScript_GymUniform:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Outfits_EventScript_Return
	PlayFanfare SEQ_ME_ITEM
	BufferPlayersName 6
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_Outfits_Text_ReceivedGymUniform
	WaitFanfare
	BufferPlayersName 6
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_Outfits_Text_PutInWardrobe
	WaitButton
	GoTo Outfits_EventScript_Return
	
GymCandidate_EventScript_MentorNoRoom:
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	Return
	
GymCandidate_EventScript_ChallengerAppears:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	CanvasCandidate 1
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_GuestNoRoom
	MovePerson 0x800A, 0x8005, 0x8006
	ClearFlag 0x2017
	ShowPerson 0x800A
	CanvasCandidate 2, 0x800A
	GoTo GymCandidate_EventScript_GuestNoRoom
	
Outfits_EventScript_Return:
	Return
	
GymCandidate_EventScript_GuestNoRoom:
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	Return

_cv_str4:
	BufferPlayersName 6
	BufferRivalsName 7
	CompareVarToValue 0x401F, 1
	GoToIfNe _cv_str4_0
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_prebattle_rock
	Return
_cv_str4_0:
	CompareVarToValue 0x401F, 2
	GoToIfNe _cv_str4_1
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_prebattle_normal
	Return
_cv_str4_1:
	CompareVarToValue 0x401F, 3
	GoToIfNe _cv_str4_2
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_prebattle_water
	Return
_cv_str4_2:
	CompareVarToValue 0x401F, 4
	GoToIfNe _cv_str4_3
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_prebattle_electric
	Return
_cv_str4_3:
	CompareVarToValue 0x401F, 5
	GoToIfNe _cv_str4_4
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_prebattle_steel
	Return
_cv_str4_4:
	CompareVarToValue 0x401F, 6
	GoToIfNe _cv_str4_5
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_prebattle_grass
	Return
_cv_str4_5:
	CompareVarToValue 0x401F, 7
	GoToIfNe _cv_str4_6
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_prebattle_poison
	Return
_cv_str4_6:
	CompareVarToValue 0x401F, 8
	GoToIfNe _cv_str4_7
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_prebattle_bug
	Return
_cv_str4_7:
	CompareVarToValue 0x401F, 9
	GoToIfNe _cv_str4_8
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_prebattle_psychic
	Return
_cv_str4_8:
	CompareVarToValue 0x401F, 10
	GoToIfNe _cv_str4_9
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_prebattle_fairy
	Return
_cv_str4_9:
	CompareVarToValue 0x401F, 11
	GoToIfNe _cv_str4_10
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_prebattle_fire
	Return
_cv_str4_10:
	CompareVarToValue 0x401F, 12
	GoToIfNe _cv_str4_11
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_repeatOffer_0
	Return
_cv_str4_11:
	CompareVarToValue 0x401F, 13
	GoToIfNe _cv_str4_12
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_repeatOffer_1
	Return
_cv_str4_12:
	CompareVarToValue 0x401F, 14
	GoToIfNe _cv_str4_13
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_repeatOffer_2
	Return
_cv_str4_13:
	CompareVarToValue 0x401F, 15
	GoToIfNe _cv_str4_14
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_repeatOffer_3
	Return
_cv_str4_14:
	CompareVarToValue 0x401F, 16
	GoToIfNe _cv_str4_15
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_repeatOffer_4
	Return
_cv_str4_15:
	CompareVarToValue 0x401F, 17
	GoToIfNe _cv_str4_16
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_repeatOffer_5
	Return
_cv_str4_16:
	CompareVarToValue 0x401F, 18
	GoToIfNe _cv_str4_17
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_repeatOffer_6
	Return
_cv_str4_17:
	CompareVarToValue 0x401F, 19
	GoToIfNe _cv_str4_18
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_repeatOffer_7
	Return
_cv_str4_18:
	CompareVarToValue 0x401F, 20
	GoToIfNe _cv_str4_19
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_first_rock
	Return
_cv_str4_19:
	CompareVarToValue 0x401F, 21
	GoToIfNe _cv_str4_20
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_first_normal
	Return
_cv_str4_20:
	CompareVarToValue 0x401F, 22
	GoToIfNe _cv_str4_21
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_first_water
	Return
_cv_str4_21:
	CompareVarToValue 0x401F, 23
	GoToIfNe _cv_str4_22
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_first_electric
	Return
_cv_str4_22:
	CompareVarToValue 0x401F, 24
	GoToIfNe _cv_str4_23
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_first_steel
	Return
_cv_str4_23:
	CompareVarToValue 0x401F, 25
	GoToIfNe _cv_str4_24
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_first_grass
	Return
_cv_str4_24:
	CompareVarToValue 0x401F, 26
	GoToIfNe _cv_str4_25
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_first_poison
	Return
_cv_str4_25:
	CompareVarToValue 0x401F, 27
	GoToIfNe _cv_str4_26
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_first_bug
	Return
_cv_str4_26:
	CompareVarToValue 0x401F, 28
	GoToIfNe _cv_str4_27
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_first_psychic
	Return
_cv_str4_27:
	CompareVarToValue 0x401F, 29
	GoToIfNe _cv_str4_28
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_first_fairy
	Return
_cv_str4_28:
	CompareVarToValue 0x401F, 30
	GoToIfNe _cv_str4_29
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_first_fire
	Return
_cv_str4_29:
	CompareVarToValue 0x401F, 31
	GoToIfNe _cv_str4_30
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_first_ground
	Return
_cv_str4_30:
	CompareVarToValue 0x401F, 32
	GoToIfNe _cv_str4_31
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_first_dark
	Return
_cv_str4_31:
	CompareVarToValue 0x401F, 33
	GoToIfNe _cv_str4_32
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_first_ice
	Return
_cv_str4_32:
	CompareVarToValue 0x401F, 34
	GoToIfNe _cv_str4_33
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_first_fighting
	Return
_cv_str4_33:
	CompareVarToValue 0x401F, 35
	GoToIfNe _cv_str4_34
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_first_ghost
	Return
_cv_str4_34:
	CompareVarToValue 0x401F, 36
	GoToIfNe _cv_str4_35
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_first_dragon
	Return
_cv_str4_35:
	CompareVarToValue 0x401F, 37
	GoToIfNe _cv_str4_36
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_first_flying
	Return
_cv_str4_36:
	CompareVarToValue 0x401F, 38
	GoToIfNe _cv_str4_37
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_offer_0
	Return
_cv_str4_37:
	CompareVarToValue 0x401F, 39
	GoToIfNe _cv_str4_38
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_offer_1
	Return
_cv_str4_38:
	CompareVarToValue 0x401F, 40
	GoToIfNe _cv_str4_39
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_offer_2
	Return
_cv_str4_39:
	CompareVarToValue 0x401F, 41
	GoToIfNe _cv_str4_40
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_offer_3
	Return
_cv_str4_40:
	CompareVarToValue 0x401F, 42
	GoToIfNe _cv_str4_41
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_offer_4
	Return
_cv_str4_41:
	CompareVarToValue 0x401F, 43
	GoToIfNe _cv_str4_42
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_offer_5
	Return
_cv_str4_42:
	CompareVarToValue 0x401F, 44
	GoToIfNe _cv_str4_43
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_offer_6
	Return
_cv_str4_43:
	CompareVarToValue 0x401F, 45
	GoToIfNe _cv_str4_44
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_offer_7
	Return
_cv_str4_44:
	CompareVarToValue 0x401F, 46
	GoToIfNe _cv_str4_45
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_ownGym_0
	Return
_cv_str4_45:
	CompareVarToValue 0x401F, 47
	GoToIfNe _cv_str4_46
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_ownGym_1
	Return
_cv_str4_46:
	CompareVarToValue 0x401F, 48
	GoToIfNe _cv_str4_47
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_ownGym_2
	Return
_cv_str4_47:
	CompareVarToValue 0x401F, 49
	GoToIfNe _cv_str4_48
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_ownGym_3
	Return
_cv_str4_48:
	CompareVarToValue 0x401F, 50
	GoToIfNe _cv_str4_49
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_ownGym_4
	Return
_cv_str4_49:
	CompareVarToValue 0x401F, 51
	GoToIfNe _cv_str4_50
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_ownGym_5
	Return
_cv_str4_50:
	CompareVarToValue 0x401F, 52
	GoToIfNe _cv_str4_51
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_ownGym_6
	Return
_cv_str4_51:
	CompareVarToValue 0x401F, 53
	GoToIfNe _cv_str4_52
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_ownGym_7
	Return
_cv_str4_52:
	CompareVarToValue 0x401F, 54
	GoToIfNe _cv_str4_53
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_guardGift_0
	Return
_cv_str4_53:
	CompareVarToValue 0x401F, 55
	GoToIfNe _cv_str4_54
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_guardGift_1
	Return
_cv_str4_54:
	CompareVarToValue 0x401F, 56
	GoToIfNe _cv_str4_55
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_guardGift_2
	Return
_cv_str4_55:
	CompareVarToValue 0x401F, 57
	GoToIfNe _cv_str4_56
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_guardGift_3
	Return
_cv_str4_56:
	CompareVarToValue 0x401F, 58
	GoToIfNe _cv_str4_57
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_guardGift_4
	Return
_cv_str4_57:
	CompareVarToValue 0x401F, 59
	GoToIfNe _cv_str4_58
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_guardGift_5
	Return
_cv_str4_58:
	CompareVarToValue 0x401F, 60
	GoToIfNe _cv_str4_59
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_guardGift_6
	Return
_cv_str4_59:
	CompareVarToValue 0x401F, 61
	GoToIfNe _cv_str4_60
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_guardGift_9
	Return
_cv_str4_60:
	CompareVarToValue 0x401F, 62
	GoToIfNe _cv_str4_61
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_guardGift_10
	Return
_cv_str4_61:
	CompareVarToValue 0x401F, 63
	GoToIfNe _cv_str4_62
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_guardGift_8
	Return
_cv_str4_62:
	CompareVarToValue 0x401F, 64
	GoToIfNe _cv_str4_63
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_guardGift_11
	Return
_cv_str4_63:
	CompareVarToValue 0x401F, 65
	GoToIfNe _cv_str4_64
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_edgeGift_0
	Return
_cv_str4_64:
	CompareVarToValue 0x401F, 66
	GoToIfNe _cv_str4_65
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_edgeGift_1
	Return
_cv_str4_65:
	CompareVarToValue 0x401F, 67
	GoToIfNe _cv_str4_66
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_edgeGift_2
	Return
_cv_str4_66:
	CompareVarToValue 0x401F, 68
	GoToIfNe _cv_str4_67
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_edgeGift_3
	Return
_cv_str4_67:
	CompareVarToValue 0x401F, 69
	GoToIfNe _cv_str4_68
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_edgeGift_4
	Return
_cv_str4_68:
	CompareVarToValue 0x401F, 70
	GoToIfNe _cv_str4_69
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_edgeGift_5
	Return
_cv_str4_69:
	CompareVarToValue 0x401F, 71
	GoToIfNe _cv_str4_70
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_edgeGift_6
	Return
_cv_str4_70:
	CompareVarToValue 0x401F, 72
	GoToIfNe _cv_str4_71
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_edgeGift_9
	Return
_cv_str4_71:
	CompareVarToValue 0x401F, 73
	GoToIfNe _cv_str4_72
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_edgeGift_10
	Return
_cv_str4_72:
	CompareVarToValue 0x401F, 74
	GoToIfNe _cv_str4_73
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_edgeGift_8
	Return
_cv_str4_73:
	CompareVarToValue 0x401F, 75
	GoToIfNe _cv_str4_74
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_edgeGift_11
	Return
_cv_str4_74:
	CompareVarToValue 0x401F, 76
	GoToIfNe _cv_str4_75
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_hold_shift
	Return
_cv_str4_75:
	CompareVarToValue 0x401F, 77
	GoToIfNe _cv_str4_76
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_observe_0
	Return
_cv_str4_76:
	CompareVarToValue 0x401F, 78
	GoToIfNe _cv_str4_77
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_observe_1
	Return
_cv_str4_77:
	CompareVarToValue 0x401F, 79
	GoToIfNe _cv_str4_78
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_observe_2
	Return
_cv_str4_78:
	CompareVarToValue 0x401F, 80
	GoToIfNe _cv_str4_79
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_observe_3
	Return
_cv_str4_79:
	CompareVarToValue 0x401F, 81
	GoToIfNe _cv_str4_80
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_observe_4
	Return
_cv_str4_80:
	CompareVarToValue 0x401F, 82
	GoToIfNe _cv_str4_81
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_observe_5
	Return
_cv_str4_81:
	CompareVarToValue 0x401F, 83
	GoToIfNe _cv_str4_82
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_observe_6
	Return
_cv_str4_82:
	CompareVarToValue 0x401F, 84
	GoToIfNe _cv_str4_83
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_observe_7
	Return
_cv_str4_83:
	CompareVarToValue 0x401F, 85
	GoToIfNe _cv_str4_84
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_approve_0
	Return
_cv_str4_84:
	CompareVarToValue 0x401F, 86
	GoToIfNe _cv_str4_85
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_approve_rock
	Return
_cv_str4_85:
	CompareVarToValue 0x401F, 87
	GoToIfNe _cv_str4_86
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_approve_normal
	Return
_cv_str4_86:
	CompareVarToValue 0x401F, 88
	GoToIfNe _cv_str4_87
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_approve_1
	Return
_cv_str4_87:
	CompareVarToValue 0x401F, 89
	GoToIfNe _cv_str4_88
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_approve_water
	Return
_cv_str4_88:
	CompareVarToValue 0x401F, 90
	GoToIfNe _cv_str4_89
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_approve_2
	Return
_cv_str4_89:
	CompareVarToValue 0x401F, 91
	GoToIfNe _cv_str4_90
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_approve_electric
	Return
_cv_str4_90:
	CompareVarToValue 0x401F, 92
	GoToIfNe _cv_str4_91
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_approve_steel
	Return
_cv_str4_91:
	CompareVarToValue 0x401F, 93
	GoToIfNe _cv_str4_92
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_approve_3
	Return
_cv_str4_92:
	CompareVarToValue 0x401F, 94
	GoToIfNe _cv_str4_93
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_approve_grass
	Return
_cv_str4_93:
	CompareVarToValue 0x401F, 95
	GoToIfNe _cv_str4_94
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_approve_4
	Return
_cv_str4_94:
	CompareVarToValue 0x401F, 96
	GoToIfNe _cv_str4_95
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_approve_poison
	Return
_cv_str4_95:
	CompareVarToValue 0x401F, 97
	GoToIfNe _cv_str4_96
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_approve_bug
	Return
_cv_str4_96:
	CompareVarToValue 0x401F, 98
	GoToIfNe _cv_str4_97
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_approve_5
	Return
_cv_str4_97:
	CompareVarToValue 0x401F, 99
	GoToIfNe _cv_str4_98
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_approve_psychic
	Return
_cv_str4_98:
	CompareVarToValue 0x401F, 100
	GoToIfNe _cv_str4_99
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_approve_fairy
	Return
_cv_str4_99:
	CompareVarToValue 0x401F, 101
	GoToIfNe _cv_str4_100
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_approve_6
	Return
_cv_str4_100:
	CompareVarToValue 0x401F, 102
	GoToIfNe _cv_str4_101
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_approve_fire
	Return
_cv_str4_101:
	CompareVarToValue 0x401F, 103
	GoToIfNe _cv_str4_102
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_approve_7
	Return
_cv_str4_102:
	CompareVarToValue 0x401F, 104
	GoToIfNe _cv_str4_103
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_repeatThanks_0
	Return
_cv_str4_103:
	CompareVarToValue 0x401F, 105
	GoToIfNe _cv_str4_104
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_repeatThanks_1
	Return
_cv_str4_104:
	CompareVarToValue 0x401F, 106
	GoToIfNe _cv_str4_105
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_repeatThanks_2
	Return
_cv_str4_105:
	CompareVarToValue 0x401F, 107
	GoToIfNe _cv_str4_106
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_repeatThanks_3
	Return
_cv_str4_106:
	CompareVarToValue 0x401F, 108
	GoToIfNe _cv_str4_107
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_repeatThanks_4
	Return
_cv_str4_107:
	CompareVarToValue 0x401F, 109
	GoToIfNe _cv_str4_108
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_repeatThanks_5
	Return
_cv_str4_108:
	CompareVarToValue 0x401F, 110
	GoToIfNe _cv_str4_109
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_repeatThanks_6
	Return
_cv_str4_109:
	CompareVarToValue 0x401F, 111
	GoToIfNe _cv_str4_110
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_leader_repeatThanks_7
	Return
_cv_str4_110:
	Return

_cv_stop:
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_team_not_allowed:
	Call EventScript_GymHack_ShowTeamRuleMessage
	CanvasCloseMsg
	GetPlayerCoords 0x8008, 0x8009
	GetPlayerFacing 0x800A
	Warp MAP_CANVAS_CINNABAR_GYM, 0, 0x8008, 0x8009, 0x800A
	ReleaseAll
	End

	.balign 4, 0
Common_Movement_WalkInPlaceFasterRight:
	WalkOnSpotFasterEast
	EndMovement

	.balign 4, 0
CinnabarIsland_Gym_Movement_QuinnApproachLeft:
	WalkNormalWest 2
	EndMovement

	.balign 4, 0
CinnabarIsland_Gym_Movement_QuinnApproachRight:
	WalkNormalWest
	EndMovement

	.balign 4, 0
CinnabarIsland_Gym_Movement_PlayerFaceAvery:
	Delay16 2
	WalkOnSpotFasterEast
	EndMovement

	.balign 4, 0
CinnabarIsland_Gym_Movement_AveryApproachLeft:
	WalkNormalNorth 2
	WalkNormalWest
	EndMovement

	.balign 4, 0
CinnabarIsland_Gym_Movement_AveryApproachRight:
	WalkNormalNorth 2
	WalkOnSpotFasterWest
	EndMovement

	.balign 4, 0
CinnabarIsland_Gym_Movement_RamonApproachLeft:
	WalkNormalWest 2
	EndMovement

	.balign 4, 0
CinnabarIsland_Gym_Movement_RamonApproachRight:
	WalkNormalWest
	EndMovement

	.balign 4, 0
CinnabarIsland_Gym_Movement_DerekApproachLeft:
	WalkNormalWest 2
	EndMovement

	.balign 4, 0
CinnabarIsland_Gym_Movement_DerekApproachRight:
	WalkNormalWest
	EndMovement

	.balign 4, 0
CinnabarIsland_Gym_Movement_DustyApproachLeft:
	WalkNormalWest 2
	EndMovement

	.balign 4, 0
CinnabarIsland_Gym_Movement_DustyApproachRight:
	WalkNormalWest
	EndMovement

	.balign 4, 0
CinnabarIsland_Gym_Movement_ZacApproachLeft:
	WalkNormalWest 2
	EndMovement

	.balign 4, 0
CinnabarIsland_Gym_Movement_ZacApproachRight:
	WalkNormalWest
	EndMovement
	.balign 4, 0
