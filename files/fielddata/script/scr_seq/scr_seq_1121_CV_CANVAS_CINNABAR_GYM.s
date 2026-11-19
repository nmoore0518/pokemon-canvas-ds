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
	TrainerBattle 929, 0, 0, 0
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
	End
	
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
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_DefeatedAvery:
	CallIfUnset 0x21F1, CinnabarIsland_Gym_EventScript_Quiz2CompleteTrainer
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_DefeatedRamon:
	CallIfUnset 0x21F2, CinnabarIsland_Gym_EventScript_Quiz3CompleteTrainer
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_DefeatedDerek:
	CallIfUnset 0x21F3, CinnabarIsland_Gym_EventScript_Quiz4CompleteTrainer
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_DefeatedDusty:
	CallIfUnset 0x21F4, CinnabarIsland_Gym_EventScript_Quiz5CompleteTrainer
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_DefeatedZac:
	CallIfUnset 0x21F5, CinnabarIsland_Gym_EventScript_Quiz6CompleteTrainer
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_MentorBattle:
	CheckTrainerFlag 1155
	GoToIf TRUE, _cv_beaten_26
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
	
CinnabarIsland_Gym_EventScript_DefeatedBlaine:
	SetFlag 0x21EF
	SetFlag 0x2090
	SetVar 0x8008, 7
	Call Common_EventScript_SetGymTrainers_Frlg
	GoTo CinnabarIsland_Gym_EventScript_GiveTM38
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
	
CinnabarIsland_Gym_EventScript_AfterLeaderBattle:
	GoToIfUnset 0x21F6, CinnabarIsland_Gym_EventScript_GiveTM38
	Call GymHack_EventScript_BlaineGifts
	Call GymCandidate_EventScript_CinnabarIslandTalk
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_BlainePostBattle
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
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
	
CinnabarIsland_Gym_EventScript_Quiz1Correct:
	Call CinnabarIsland_Gym_EventScript_CorrectAnswer
	GoToIfSet 0x21F0, CinnabarIsland_Gym_EventScript_DoorAlreadyOpen
	Call CinnabarIsland_Gym_EventScript_Quiz1Complete
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_Quiz1Incorrect:
	Call CinnabarIsland_Gym_EventScript_IncorrectAnswer
	CheckTrainerFlag 960
	GoToIf FALSE, CinnabarIsland_Gym_EventScript_BattleQuinn
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_Quiz2Incorrect:
	Call CinnabarIsland_Gym_EventScript_IncorrectAnswer
	CheckTrainerFlag 929
	GoToIf FALSE, CinnabarIsland_Gym_EventScript_BattleAvery
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_Quiz2Correct:
	Call CinnabarIsland_Gym_EventScript_CorrectAnswer
	GoToIfSet 0x21F1, CinnabarIsland_Gym_EventScript_DoorAlreadyOpen
	Call CinnabarIsland_Gym_EventScript_Quiz2Complete
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_Quiz3Incorrect:
	Call CinnabarIsland_Gym_EventScript_IncorrectAnswer
	CheckTrainerFlag 961
	GoToIf FALSE, CinnabarIsland_Gym_EventScript_BattleRamon
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_Quiz3Correct:
	Call CinnabarIsland_Gym_EventScript_CorrectAnswer
	GoToIfSet 0x21F2, CinnabarIsland_Gym_EventScript_DoorAlreadyOpen
	Call CinnabarIsland_Gym_EventScript_Quiz3Complete
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_Quiz4Incorrect:
	Call CinnabarIsland_Gym_EventScript_IncorrectAnswer
	CheckTrainerFlag 930
	GoToIf FALSE, CinnabarIsland_Gym_EventScript_BattleDerek
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_Quiz4Correct:
	Call CinnabarIsland_Gym_EventScript_CorrectAnswer
	GoToIfSet 0x21F3, CinnabarIsland_Gym_EventScript_DoorAlreadyOpen
	Call CinnabarIsland_Gym_EventScript_Quiz4Complete
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_Quiz5Correct:
	Call CinnabarIsland_Gym_EventScript_CorrectAnswer
	GoToIfSet 0x21F4, CinnabarIsland_Gym_EventScript_DoorAlreadyOpen
	Call CinnabarIsland_Gym_EventScript_Quiz5Complete
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_Quiz5Incorrect:
	Call CinnabarIsland_Gym_EventScript_IncorrectAnswer
	CheckTrainerFlag 962
	GoToIf FALSE, CinnabarIsland_Gym_EventScript_BattleDusty
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_Quiz6Incorrect:
	Call CinnabarIsland_Gym_EventScript_IncorrectAnswer
	CheckTrainerFlag 931
	GoToIf FALSE, CinnabarIsland_Gym_EventScript_BattleZac
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_Quiz6Correct:
	Call CinnabarIsland_Gym_EventScript_CorrectAnswer
	GoToIfSet 0x21F5, CinnabarIsland_Gym_EventScript_DoorAlreadyOpen
	Call CinnabarIsland_Gym_EventScript_Quiz6Complete
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
	
CinnabarIsland_Gym_EventScript_CorrectAnswer:
	PlayFanfare SEQ_ME_LVUP
	WaitFanfare
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_CorrectGoOnThrough
	WaitButton
	Return
	
CinnabarIsland_Gym_EventScript_DoorAlreadyOpen:
	ReleaseAll
	End
	
CinnabarIsland_Gym_EventScript_IncorrectAnswer:
	WaitSE SEQ_SE_DP_SELECT
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_SorryBadCall
	WaitButton
	CloseMsg
	Return
	
CinnabarIsland_Gym_EventScript_BattleQuinn:
	CompareVarToValue 0x4001, 0
	CallIfEq CinnabarIsland_Gym_EventScript_QuinnApproachLeft
	CompareVarToValue 0x4001, 1
	CallIfEq CinnabarIsland_Gym_EventScript_QuinnApproachRight
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_CinnabarIsland_Gym_Text_QuinnIntro
	WaitButton
	CheckTrainerFlag 960
	GoToIf TRUE, _cv_beaten_52
	TrainerBattle 960, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_53
	WhiteOut
	End
_cv_won_53:
	SetTrainerFlag 960
	ReleaseAll
	End
_cv_beaten_52:
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
	CheckTrainerFlag 929
	GoToIf TRUE, _cv_beaten_54
	TrainerBattle 929, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_55
	WhiteOut
	End
_cv_won_55:
	SetTrainerFlag 929
	ReleaseAll
	End
_cv_beaten_54:
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
	CheckTrainerFlag 961
	GoToIf TRUE, _cv_beaten_56
	TrainerBattle 961, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_57
	WhiteOut
	End
_cv_won_57:
	SetTrainerFlag 961
	ReleaseAll
	End
_cv_beaten_56:
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
	CheckTrainerFlag 930
	GoToIf TRUE, _cv_beaten_58
	TrainerBattle 930, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_59
	WhiteOut
	End
_cv_won_59:
	SetTrainerFlag 930
	ReleaseAll
	End
_cv_beaten_58:
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
	CheckTrainerFlag 962
	GoToIf TRUE, _cv_beaten_60
	TrainerBattle 962, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_61
	WhiteOut
	End
_cv_won_61:
	SetTrainerFlag 962
	ReleaseAll
	End
_cv_beaten_60:
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
	CheckTrainerFlag 931
	GoToIf TRUE, _cv_beaten_62
	TrainerBattle 931, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_63
	WhiteOut
	End
_cv_won_63:
	SetTrainerFlag 931
	ReleaseAll
	End
_cv_beaten_62:
	GoToIfSet 0x21F5, CinnabarIsland_Gym_EventScript_DoorAlreadyOpen
	Call CinnabarIsland_Gym_EventScript_Quiz6Complete
	CloseMsg
	ReleaseAll
	End
	
GymHack_EventScript_GiftsDone:
	Return
	
GymHack_EventScript_GiveStatItem:
	GiveItem 0x8009, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymHack_EventScript_GiveStatItemDone
	BufferItemName 1, 0x8009
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_GymHack_Text_GiftSentToPC
	WaitButton
	End
	
GymCandidate_EventScript_TalkAgain:
	Call GymCandidate_EventScript_MentorGift
	// TODO(gba) special GymCandidate_IsApproved
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_Offer
	CompareVarToValue 0x8009, 7
	GoToIfEq GymCandidate_EventScript_Return
	GoToIfSet 0x2008, GymCandidate_EventScript_OwnGym
	// TODO(gba) special GymCandidate_BufferRepeatOffer
	GoTo _cv_stop
	Call _cv_str4
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_64
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_65
_cv_yes_64:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_65:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_NotYet
	SetVar 0x8007, 1
	GoTo GymCandidate_EventScript_Start
	CloseMsg
	End
	
GymCandidate_EventScript_AfterBadge:
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_mentor_66
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_mentor_66
	SetVar 0x401F, 12
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_66:
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_mentor_67
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_mentor_67
	SetVar 0x401F, 13
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_67:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_mentor_68
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_mentor_68
	SetVar 0x401F, 14
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_68:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_mentor_69
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_mentor_69
	SetVar 0x401F, 15
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_69:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_mentor_70
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_mentor_70
	SetVar 0x401F, 16
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_70:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_mentor_71
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_mentor_71
	SetVar 0x401F, 17
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_71:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_mentor_72
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_mentor_72
	SetVar 0x401F, 18
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_72:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_mentor_73
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_mentor_73
	SetVar 0x401F, 19
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_73:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_mentor_74
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_mentor_74
	SetVar 0x401F, 20
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_74:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_mentor_75
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_mentor_75
	SetVar 0x401F, 21
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_75:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_mentor_76
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_mentor_76
	SetVar 0x401F, 22
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_76:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq GymCandidate_EventScript_ShowText4
	Call GymCandidate_EventScript_MentorGift
	GoTo GymCandidate_EventScript_Offer
	End
	
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
	
GymHack_EventScript_GiveStatItemDone:
	Return
	
GymCandidate_EventScript_MentorGift:
	// TODO(gba) special GymCandidate_PrepareMentorGift
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_Return
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymCandidate_EventScript_MentorGiveItem
	PlaySE SEQ_SE_DP_DOOR
	BufferPlayersName 6
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_GymCandidate_Text_SomeoneToSeeYou
	WaitButton
	CloseMsg
	Call GymCandidate_EventScript_VisitorWalksIn
	Call GymCandidate_EventScript_MentorGiveItem
	Call GymCandidate_EventScript_VisitorWalksOut
	Return
	
GymCandidate_EventScript_Offer:
	// TODO(gba) special GymCandidate_BufferOffer
	GoTo _cv_stop
	Call _cv_str4
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_77
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_78
_cv_yes_77:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_78:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_NotYet
	SetVar 0x8007, 0
	End
	
GymCandidate_EventScript_Return:
	Return
	
GymCandidate_EventScript_OwnGym:
	// TODO(gba) special GymCandidate_BufferOwnGym
	GoTo _cv_stop
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
	// TODO(gba) special GymHack_CheckTeamSpecial
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe GymCandidate_EventScript_TeamBreaksRules
	SetVar 0x800B, 0
	Call GymCandidate_EventScript_TakeLeadersPlace
	End
	
GymCandidate_EventScript_ShowText4:
	Call _cv_str4
	WaitButton
	Return
	
GymCandidate_EventScript_MentorGiveItem:
	// TODO(gba) special GymCandidate_BufferMentorGift
	GoTo _cv_stop
	Call _cv_str4
	WaitButton
	GiveItem 0x8004, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymCandidate_EventScript_MentorItemExplain
	BufferItemName 1, 0x8004
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_GymHack_Text_GiftSentToPC
	WaitButton
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
	
GymCandidate_EventScript_TeamBreaksRules:
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfEq GymCandidate_EventScript_ItemClause
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_GymCandidate_Text_TeamBreaksRules
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_TakeLeadersPlace:
	// TODO(gba) special GymCandidate_PlanHold
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_Return
	// TODO(gba) special GymCandidate_BufferHoldText
	GoTo _cv_stop
	Call _cv_str4
	WaitButton
	CloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special GymCandidate_HoldLeaderAside
	GoTo _cv_stop
	ApplyMovement obj_player, gHoldPlayerIn
	WaitMovement
	Wait 30, VAR_SPECIAL_RESULT
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	Return
	
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
	
GymCandidate_EventScript_ItemClause:
	Call EventScript_GymHack_ShowTeamRuleMessage
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
	End
	
GymCandidate_EventScript_MentorNoRoom:
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
	
Outfits_EventScript_Return:
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
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_first_rock
	Return
_cv_str4_11:
	CompareVarToValue 0x401F, 13
	GoToIfNe _cv_str4_12
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_first_normal
	Return
_cv_str4_12:
	CompareVarToValue 0x401F, 14
	GoToIfNe _cv_str4_13
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_first_water
	Return
_cv_str4_13:
	CompareVarToValue 0x401F, 15
	GoToIfNe _cv_str4_14
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_first_electric
	Return
_cv_str4_14:
	CompareVarToValue 0x401F, 16
	GoToIfNe _cv_str4_15
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_first_steel
	Return
_cv_str4_15:
	CompareVarToValue 0x401F, 17
	GoToIfNe _cv_str4_16
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_first_grass
	Return
_cv_str4_16:
	CompareVarToValue 0x401F, 18
	GoToIfNe _cv_str4_17
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_first_poison
	Return
_cv_str4_17:
	CompareVarToValue 0x401F, 19
	GoToIfNe _cv_str4_18
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_first_bug
	Return
_cv_str4_18:
	CompareVarToValue 0x401F, 20
	GoToIfNe _cv_str4_19
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_first_psychic
	Return
_cv_str4_19:
	CompareVarToValue 0x401F, 21
	GoToIfNe _cv_str4_20
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_first_fairy
	Return
_cv_str4_20:
	CompareVarToValue 0x401F, 22
	GoToIfNe _cv_str4_21
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_mentor_first_fire
	Return
_cv_str4_21:
	Return

_cv_stop:
	NPCMsg msg_0932_CV_CANVAS_CINNABAR_GYM_cv_unported
	WaitButton
	CloseMsg
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
gMentorWalkIn:
	EndMovement

	.balign 4, 0
gMentorWalkOut:
	EndMovement

	.balign 4, 0
gHoldPlayerIn:
	EndMovement
	.balign 4, 0
