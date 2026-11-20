#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T01R0301.h"
#include "msgdata/msg/msg_0451_T01R0301.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PalletTown_ProfessorOaksLab_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef PalletTown_ProfessorOaksLab_EventScript_Aide1
	ScrDef PalletTown_ProfessorOaksLab_EventScript_Aide3
	ScrDef PalletTown_ProfessorOaksLab_EventScript_Aide2
	ScrDef PalletTown_ProfessorOaksLab_EventScript_ProfOak
	ScrDef PalletTown_ProfessorOaksLab_EventScript_Rival
	ScrDef PalletTown_ProfessorOaksLab_EventScript_Pokedex
	ScrDef LeaderAide_EventScript_Aide
	ScrDef PalletTown_ProfessorOaksLab_EventScript_Computer
	ScrDef PalletTown_ProfessorOaksLab_EventScript_LeftSign
	ScrDef PalletTown_ProfessorOaksLab_EventScript_RightSign
	ScrDef PalletTown_ProfessorOaksLab_EventScript_BallShelf
	ScrDef PalletTown_ProfessorOaksLab_EventScript_LeaveStarterSceneTrigger
	ScrDef PalletTown_ProfessorOaksLab_EventScript_RivalBattleTriggerLeft
	ScrDef PalletTown_ProfessorOaksLab_EventScript_RivalBattleTriggerMid
	ScrDef PalletTown_ProfessorOaksLab_EventScript_RivalBattleTriggerRight
	ScrDef PalletTown_ProfessorOaksLab_OnTransition
	ScrDef PalletTown_ProfessorOaksLab_ChooseStarterScene
	ScrDef PalletTown_ProfessorOaksLab_EventScript_EnterForNationalDexScene
	ScrDefEnd
	
PalletTown_ProfessorOaksLab_EventScript_Aide1:
	LockAll
	FacePlayer
	GoToIfSet FLAG_GAME_CLEAR, PalletTown_ProfessorOaksLab_EventScript_Aide1GameClear
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_StudyAsOaksAide
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_ProfessorOaksLab_EventScript_Aide3:
	LockAll
	FacePlayer
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_OakIsAuthorityOnMons
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_ProfessorOaksLab_EventScript_Aide2:
	LockAll
	FacePlayer
	GoToIfSet FLAG_GAME_CLEAR, PalletTown_ProfessorOaksLab_EventScript_Aide2GameClear
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_StudyAsOaksAide
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_ProfessorOaksLab_EventScript_ProfOak:
	LockAll
	FacePlayer
	Call GymRooms_EventScript_LabOak
	Call EventMons_EventScript_OakPartners
	Call GymSwitch_EventScript_LabOak
	GoToIfSet 2, PalletTown_ProfessorOaksLab_EventScript_OakJustShownCompleteDex
	CompareVarToValue 0x5006, 9
	GoToIfEq PalletTown_ProfessorOaksLab_EventScript_RatePokedex
	CompareVarToValue 0x5006, 8
	GoToIfEq PalletTown_ProfessorOaksLab_EventScript_MonsAroundWorldWait
	GoToIfSet FLAG_GAME_CLEAR, PalletTown_ProfessorOaksLab_EventScript_TryStartNationalDexScene
	Call EventScript_OakGivesMissedBalloon
	Call GymCandidate_EventScript_OakAside
	CompareVarToValue 0x500F, 1
	GoToIfEq PalletTown_ProfessorOaksLab_EventScript_RatePokedex
	CompareVarToValue 0x5006, 6
	GoToIfEq PalletTown_ProfessorOaksLab_EventScript_RatePokedexOrTryGiveBalls
	CompareVarToValue 0x5010, 1
	GoToIfGe PalletTown_ProfessorOaksLab_EventScript_ReceiveDexScene
	CompareVarToValue 0x5006, 4
	GoToIfEq PalletTown_ProfessorOaksLab_EventScript_OakBattleMonForItToGrow
	CompareVarToValue 0x5006, 3
	GoToIfEq PalletTown_ProfessorOaksLab_EventScript_OakCanReachNextTownWithMon
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_OakWhichOneWillYouChoose
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_ProfessorOaksLab_EventScript_Rival:
	LockAll
	FacePlayer
	CompareVarToValue 0x5006, 3
	GoToIfEq PalletTown_ProfessorOaksLab_EventScript_RivalChoseStarter
	CompareVarToValue 0x5006, 2
	GoToIfEq PalletTown_ProfessorOaksLab_EventScript_RivalWaitingForStarter
	BufferPlayersName 6
	BufferRivalsName 7
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_RivalGrampsIsntAround
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_ProfessorOaksLab_EventScript_Pokedex:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_BlankEncyclopedia
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
LeaderAide_EventScript_Aide:
	LockAll
	FacePlayer
	GoToIfSet 0x2015, LeaderAide_EventScript_Again
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_LeaderAide_Text_Intro
	WaitButton
	SetFlag 0x2015
	GoTo LeaderAide_EventScript_Menu
	
PalletTown_ProfessorOaksLab_EventScript_Computer:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_EmailMessage
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_ProfessorOaksLab_EventScript_LeftSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_PressStartToOpenMenu
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_ProfessorOaksLab_EventScript_RightSign:
	LockAll
	CompareVarToValue 0x5006, 6
	GoToIfGe PalletTown_ProfessorOaksLab_EventScript_RightSignAlt
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_SaveOptionInMenu
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_ProfessorOaksLab_EventScript_BallShelf:
	LockAll
	CompareVarToValue 0x5006, 3
	GoToIfGe PalletTown_ProfessorOaksLab_EventScript_LastPokeBall
	CompareVarToValue 0x5006, 2
	GoToIfEq PalletTown_ProfessorOaksLab_EventScript_ChooseType
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_ThoseArePokeBalls
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_ProfessorOaksLab_EventScript_LeaveStarterSceneTrigger:
	LockAll
	ApplyMovement 4, Common_Movement_FaceDown
	WaitMovement
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_OakHeyDontGoAwayYet
	WaitButton
	CloseMsg
	ApplyMovement obj_player, PalletTown_ProfessorOaksLab_Movement_PlayerWalkUp
	WaitMovement
	ReleaseAll
	End
	
PalletTown_ProfessorOaksLab_EventScript_RivalBattleTriggerLeft:
	LockAll
	SetVar 0x4002, 1
	GoTo PalletTown_ProfessorOaksLab_EventScript_RivalBattle
	End
	
PalletTown_ProfessorOaksLab_EventScript_RivalBattleTriggerMid:
	LockAll
	SetVar 0x4002, 2
	GoTo PalletTown_ProfessorOaksLab_EventScript_RivalBattle
	End
	
PalletTown_ProfessorOaksLab_EventScript_RivalBattleTriggerRight:
	LockAll
	SetVar 0x4002, 3
	GoTo PalletTown_ProfessorOaksLab_EventScript_RivalBattle
	End
	
PalletTown_ProfessorOaksLab_OnTransition:
	SetFlag 0x2016
	SetFlag 0x2017
	Call LeaderAide_EventScript_LabTransition
	CompareVarToValue 0x5006, 1
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_ReadyOakForStarterScene
	CompareVarToValue 0x5006, 7
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_ReadyOakForNationalDexScene
	CompareVarToValue 0x5006, 8
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_SetNationalDexSceneFinished
	CallIfSet 0x2018, PalletTown_ProfessorOaksLab_EventScript_SetSkipPokeBallCheck
	End
	
PalletTown_ProfessorOaksLab_ChooseStarterScene:
	LockAll
	ApplyMovement 4, PalletTown_ProfessorOaksLab_Movement_OakEnter
	WaitMovement
	HidePerson 4
	SetFlag 0x2019
	MovePerson 4, 6, 3
	SetObjectMovementType 4, 15
	SetObjectFacing 4, 1
	ClearFlag 0x2019
	ShowPerson 4
	ApplyMovement obj_player, PalletTown_ProfessorOaksLab_Movement_PlayerEnter
	WaitMovement
	ApplyMovement 5, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	ClearFlag 0x201A
	ResetBGM
	GoToIfSet 0x2051, _cv_rival_named
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	NameRival VAR_SPECIAL_RESULT
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	SetFlag 0x2051
_cv_rival_named:
	BufferRivalsName 7
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_RivalFedUpWithWaiting
	WaitButton
	CloseMsg
	Wait 60, VAR_SPECIAL_RESULT
	BufferPlayersName 6
	BufferRivalsName 7
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_OakThreeMonsChooseOne
	WaitButton
	CloseMsg
	Wait 30, VAR_SPECIAL_RESULT
	ApplyMovement 5, PalletTown_ProfessorOaksLab_Movement_RivalReact
	WaitMovement
	BufferRivalsName 7
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_RivalNoFairWhatAboutMe
	WaitButton
	BufferRivalsName 7
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_OakBePatientRival
	WaitButton
	SetVar 0x5006, 2
	CloseMsg
	ReleaseAll
	End
	
PalletTown_ProfessorOaksLab_EventScript_EnterForNationalDexScene:
	LockAll
	SetVar 0x5002, 0
	ApplyMovement 4, PalletTown_ProfessorOaksLab_Movement_OakEnter
	WaitMovement
	HidePerson 4
	SetFlag 0x2019
	MovePerson 4, 6, 3
	SetObjectMovementType 4, 15
	SetObjectFacing 4, 1
	ClearFlag 0x2019
	ShowPerson 4
	ApplyMovement obj_player, PalletTown_ProfessorOaksLab_Movement_PlayerEnter
	WaitMovement
	GoTo PalletTown_ProfessorOaksLab_EventScript_NationalDexScene
	End
	
PalletTown_ProfessorOaksLab_EventScript_Aide1GameClear:
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_OakIsGoingToHaveRadioShow
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_ProfessorOaksLab_EventScript_Aide2GameClear:
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_DaisyWillGroomMons
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymRooms_EventScript_LabOak:
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x2000, _cv_rooms_1
	CountNationalDexOwned 0x401E
	GoToIfSet 0x209A, _cv_room_2
	CompareVarToValue 0x401E, 100
	GoToIfLt _cv_rooms_1
	SetVar VAR_SPECIAL_RESULT, 1
	BufferInt 0, 100
	GoTo _cv_rooms_1
_cv_room_2:
	GoToIfSet 0x209B, _cv_room_3
	CompareVarToValue 0x401E, 200
	GoToIfLt _cv_rooms_1
	SetVar VAR_SPECIAL_RESULT, 2
	BufferInt 0, 200
	GoTo _cv_rooms_1
_cv_room_3:
	GoToIfSet 0x209C, _cv_room_4
	CompareVarToValue 0x401E, 300
	GoToIfLt _cv_rooms_1
	SetVar VAR_SPECIAL_RESULT, 3
	BufferInt 0, 300
	GoTo _cv_rooms_1
_cv_room_4:
_cv_rooms_1:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymRooms_EventScript_Return
	CopyVar 0x8004, VAR_SPECIAL_RESULT
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_GymRooms_Text_OakCaughtSoMany
	WaitButton
	CompareVarToValue 0x8004, 1
	GoToIfEq GymRooms_EventScript_BackRoom
	CompareVarToValue 0x8004, 2
	GoToIfEq GymRooms_EventScript_LeftRoom
	NPCMsg msg_0451_T01R0301_GymRooms_Text_OakRightRoom
	WaitButton
	GoTo GymRooms_EventScript_Give
	
EventMons_EventScript_OakPartners:
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x209D, _cv_partner_6
	GoToIfSet 0x2021, _cv_partner_6
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_partner_5
_cv_partner_6:
	GoToIfUnset 0x209E, _cv_partner_5
	GoToIfSet 0x2022, _cv_partner_5
	SetVar VAR_SPECIAL_RESULT, 2
_cv_partner_5:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq EventMons_EventScript_Return
	CopyVar 0x8009, VAR_SPECIAL_RESULT
	CompareVarToValue 0x8009, 1
	CallIfEq EventMons_EventScript_OakPikachuOffer
	CompareVarToValue 0x8009, 2
	CallIfEq EventMons_EventScript_OakEeveeOffer
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq EventMons_EventScript_OakQuizLater
	NPCMsg msg_0451_T01R0301_EventMons_Text_OakQuizRules
	WaitButton
	SetVar 0x800A, 0
	CompareVarToValue 0x8009, 2
	GoToIfEq EventMons_EventScript_EeveeQuiz
	NPCMsg msg_0451_T01R0301_EventMons_Text_QuizE1
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 0, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0451_T01R0301_EventMons_Text_AnsGround, 0
	ScrCmd_559 msg_0451_T01R0301_EventMons_Text_AnsFlying, 1
	ScrCmd_559 msg_0451_T01R0301_EventMons_Text_AnsSteel, 2
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_8
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_8:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	CallIfEq EventMons_EventScript_QuizRight
	NPCMsg msg_0451_T01R0301_EventMons_Text_QuizE2
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 0, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0451_T01R0301_EventMons_Text_AnsGrass, 0
	ScrCmd_559 msg_0451_T01R0301_EventMons_Text_AnsDragon, 1
	ScrCmd_559 msg_0451_T01R0301_EventMons_Text_AnsWater, 2
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_10
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_10:
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	CallIfEq EventMons_EventScript_QuizRight
	NPCMsg msg_0451_T01R0301_EventMons_Text_QuizE3
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 0, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0451_T01R0301_EventMons_Text_AnsStatic, 0
	ScrCmd_559 msg_0451_T01R0301_EventMons_Text_AnsVoltAbsorb, 1
	ScrCmd_559 msg_0451_T01R0301_EventMons_Text_AnsSwiftSwim, 2
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_12
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_12:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq EventMons_EventScript_QuizRight
	NPCMsg msg_0451_T01R0301_EventMons_Text_QuizE4
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 0, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0451_T01R0301_EventMons_Text_AnsParalysis, 0
	ScrCmd_559 msg_0451_T01R0301_EventMons_Text_AnsBurn, 1
	ScrCmd_559 msg_0451_T01R0301_EventMons_Text_AnsSleep, 2
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_14
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_14:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	CallIfEq EventMons_EventScript_QuizRight
	NPCMsg msg_0451_T01R0301_EventMons_Text_QuizE5
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 0, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0451_T01R0301_EventMons_Text_AnsWater, 0
	ScrCmd_559 msg_0451_T01R0301_EventMons_Text_AnsNormal, 1
	ScrCmd_559 msg_0451_T01R0301_EventMons_Text_AnsDragon, 2
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_16
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_16:
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	CallIfEq EventMons_EventScript_QuizRight
	GoTo EventMons_EventScript_QuizScore
	
GymSwitch_EventScript_LabOak:
	GoToIfUnset 0x2008, GymSwitch_EventScript_Return
	Call GymSwitch_EventScript_LabGymCharm
	// TODO(gba) special GymSwitch_BufferStatus
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymSwitch_EventScript_LabGoal
	// TODO(gba) special GymSwitch_StreakInProgress
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymSwitch_EventScript_LabMidStreak
	// TODO(gba) special GymSwitch_CanTakeNewType
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymSwitch_EventScript_LabOffer
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_GymSwitch_Text_LabSwitchBack
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_17
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_18
_cv_yes_17:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_18:
	GoTo GymSwitch_EventScript_LabAnswer
	CloseMsg
	End
	
PalletTown_ProfessorOaksLab_EventScript_OakJustShownCompleteDex:
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_PokedexRating_Text_ThankYouMadeDreamReality
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_ProfessorOaksLab_EventScript_RatePokedex:
	Call PokedexRating_EventScript_RateInPerson
	GoToIfSet 0x201B, PalletTown_ProfessorOaksLab_EventScript_DexCompleted
	ReleaseAll
	End
	
PalletTown_ProfessorOaksLab_EventScript_MonsAroundWorldWait:
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_OakMonsAroundWorldWait
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_ProfessorOaksLab_EventScript_TryStartNationalDexScene:
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x2026, _cv_dex_19
	SetVar VAR_SPECIAL_RESULT, 1
_cv_dex_19:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq PalletTown_ProfessorOaksLab_EventScript_RatePokedex
	Call PokedexRating_EventScript_RateInPerson
	CloseMsg
	CompareVarToValue 0x8009, 60
	GoToIfLt PalletTown_ProfessorOaksLab_EventScript_DontStartNationalDexScene
	GoToIfUnset 0x2005, PalletTown_ProfessorOaksLab_EventScript_DontStartNationalDexScene
	Wait 30, VAR_SPECIAL_RESULT
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_OakFavorToAskYouPlayer
	WaitButton
	GoTo PalletTown_ProfessorOaksLab_EventScript_NationalDexScene
	CloseMsg
	End
	
EventScript_OakGivesMissedBalloon:
	GoToIfUnset 0x2000, EventScript_PalmPilotReturn
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x202C, _cv_has_20
	SetVar VAR_SPECIAL_RESULT, 1
_cv_has_20:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq EventScript_PalmPilotReturn
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_Text_OakMissedBalloon
	WaitButton
	SetFlag 0x202C
	SetVar VAR_SPECIAL_RESULT, 1
	Return
	
GymCandidate_EventScript_OakAside:
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x2093, _cv_appr_21
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_21:
	GoToIfUnset 0x2094, _cv_appr_22
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_22:
	GoToIfUnset 0x2095, _cv_appr_23
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_23:
	GoToIfUnset 0x2096, _cv_appr_24
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_24:
	GoToIfUnset 0x2097, _cv_appr_25
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_25:
	GoToIfUnset 0x2098, _cv_appr_26
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_26:
	GoToIfUnset 0x2099, _cv_appr_27
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_27:
	GoToIfUnset 0x2007, _cv_appr_28
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_28:
	BufferInt 0, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_Return
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfLe GymCandidate_EventScript_OakAside1
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfLe GymCandidate_EventScript_OakAside2
	CompareVarToValue VAR_SPECIAL_RESULT, 6
	GoToIfLe GymCandidate_EventScript_OakAside3
	NPCMsg msg_0451_T01R0301_GymCandidate_Text_OakAside4
	WaitButton
	Return
	
PalletTown_ProfessorOaksLab_EventScript_RatePokedexOrTryGiveBalls:
	SetVar 0x8004, 0
	CountNationalDexSeen 0x8005
	CountNationalDexOwned 0x8006
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x2026, _cv_dex_29
	SetVar VAR_SPECIAL_RESULT, 1
_cv_dex_29:
	CopyVar 0x8008, 0x8005
	CopyVar 0x8009, 0x8006
	BufferInt 0, 0x8008
	BufferInt 1, 0x8009
	CompareVarToValue 0x8009, 1
	GoToIfEq PalletTown_ProfessorOaksLab_EventScript_CheckIfPlayerNeedsBalls
	GoTo PalletTown_ProfessorOaksLab_EventScript_RatePokedex
	End
	
PalletTown_ProfessorOaksLab_EventScript_ReceiveDexScene:
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_OakHaveSomethingForMe
	WaitButton
	PlayFanfare SEQ_ME_WAZA
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_DeliveredOaksParcel
	WaitFanfare
	Call EventScript_RestorePrevTextColor
	ClearFlag 0x202D
	SetVar VAR_SPECIAL_RESULT, 1
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_31
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_30
_cv_next_31:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_32
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_30
_cv_next_32:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_33
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Misty
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_30
_cv_next_33:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_34
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_30
_cv_next_34:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_35
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_30
_cv_next_35:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_36
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Erika
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_30
_cv_next_36:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_37
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_30
_cv_next_37:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_38
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_30
_cv_next_38:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_39
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_30
_cv_next_39:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_40
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_30
_cv_next_40:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_41
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Blaine
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_30
_cv_next_41:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_42
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_30
_cv_next_42:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_43
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_30
_cv_next_43:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_44
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Lorelei
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_30
_cv_next_44:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_45
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_30
_cv_next_45:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_46
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_30
_cv_next_46:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_47
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_30
_cv_next_47:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_48
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_30
_cv_next_48:
_cv_done_30:
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_OakCustomBallIOrdered
	WaitButton
	PlayBGM SEQ_GS_E_RIVAL1
	BufferRivalsName 7
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_RivalGramps
	WaitButton
	CloseMsg
	CompareVarToValue 0x5002, 0
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_DexSceneRivalEnterNorth
	CompareVarToValue 0x5002, 1
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_DexSceneRivalEnterSouth
	CompareVarToValue 0x5002, 3
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_DexSceneRivalEnterEastWest
	CompareVarToValue 0x5002, 2
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_DexSceneRivalEnterEastWest
	ResetBGM
	BufferRivalsName 7
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_RivalWhatDidYouCallMeFor
	WaitButton
	CloseMsg
	Wait 30, VAR_SPECIAL_RESULT
	PlaySE SEQ_SE_DP_SELECT
	ApplyMovement 4, Common_Movement_ExclamationMark
	WaitMovement
	ApplyMovement 4, Common_Movement_Delay48
	WaitMovement
	CompareVarToValue 0x5002, 1
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_DexSceneOakFacePlayerAndRivalSouth
	CompareVarToValue 0x5002, 3
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_DexSceneOakFacePlayerAndRivalEast
	CompareVarToValue 0x5002, 2
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_DexSceneOakFacePlayerAndRivalWest
	CompareVarToValue 0x5002, 0
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_DexSceneOakFacePlayerAndRivalNorth
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_OakHaveRequestForYouTwo
	WaitButton
	CloseMsg
	CompareVarToValue 0x5002, 0
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_DexSceneOakWalkToDeskNorth
	CompareVarToValue 0x5002, 1
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_DexSceneOakWalkToDeskSouth
	CompareVarToValue 0x5002, 3
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_DexSceneOakWalkToDeskEast
	CompareVarToValue 0x5002, 2
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_DexSceneOakWalkToDeskWest
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_OakPokedexOnDesk
	WaitButton
	CloseMsg
	Wait 40, VAR_SPECIAL_RESULT
	BufferPlayersName 6
	BufferRivalsName 7
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_OakTakeTheseWithYou
	WaitButton
	CloseMsg
	ApplyMovement 4, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	HidePerson 6
	SetFlag 0x2025
	Wait 10, VAR_SPECIAL_RESULT
	HidePerson 7
	SetFlag 0x2025
	Wait 25, VAR_SPECIAL_RESULT
	CompareVarToValue 0x5002, 0
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_OakBringDexesOverNorth
	CompareVarToValue 0x5002, 1
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_OakBringDexesOverSouth
	CompareVarToValue 0x5002, 3
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_OakBringDexesOverEast
	CompareVarToValue 0x5002, 2
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_OakBringDexesOverWest
	Wait 10, VAR_SPECIAL_RESULT
	PlayFanfare SEQ_ME_ITEM
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_ReceivedPokedexFromOak
	WaitFanfare
	Call EventScript_RestorePrevTextColor
	SetFlag 0x201C
	GivePokedex
	SetFlag 0x2026
	SetVar 0x5011, 1
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_OakCatchMonsForDataTakeThese
	WaitButton
	GiveItem ITEM_POKE_BALL, 5, VAR_SPECIAL_RESULT
	BufferItemName 1, ITEM_POKE_BALL
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_ReceivedFivePokeBalls
	PlayFanfare SEQ_ME_LVUP
	WaitFanfare
	WaitButton
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_OakExplainCatching
	WaitButton
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_OakCompleteMonGuideWasMyDream
	WaitButton
	BufferRivalsName 7
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_RivalLeaveItToMeGramps
	WaitButton
	CompareVarToValue 0x5002, 0
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_DexSceneRivalFacePlayerNorth
	CompareVarToValue 0x5002, 1
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_DexSceneRivalFacePlayerSouth
	CompareVarToValue 0x5002, 3
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_DexSceneRivalFacePlayerEastWest
	CompareVarToValue 0x5002, 2
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_DexSceneRivalFacePlayerEastWest
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_RivalTellSisNotToGiveYouMap
	WaitButton
	CloseMsg
	PlayBGM SEQ_GS_E_RIVAL2
	CompareVarToValue 0x5002, 0
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_RivalExitNorth
	CompareVarToValue 0x5002, 1
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_RivalExit
	CompareVarToValue 0x5002, 3
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_RivalExit
	CompareVarToValue 0x5002, 2
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_RivalExit
	HidePerson 5
	SetFlag 0x2024
	ResetBGM
	SetVar 0x5006, 6
	SetVar 0x5010, 2
	SetVar 0x5012, 1
	SetVar 0x500D, 1
	SetVar 0x5013, 1
	SetVar 0x800A, 8
	Call GymCandidate_EventScript_MentorIntro
	Call DadStory_EventScript_ArmSendoff
	ReleaseAll
	End
	
PalletTown_ProfessorOaksLab_EventScript_OakBattleMonForItToGrow:
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_OakBattleMonForItToGrow
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_ProfessorOaksLab_EventScript_OakCanReachNextTownWithMon:
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_OakCanReachNextTownWithMon
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_ProfessorOaksLab_EventScript_RivalChoseStarter:
	BufferRivalsName 7
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_RivalMyMonLooksTougher
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_ProfessorOaksLab_EventScript_RivalWaitingForStarter:
	BufferPlayersName 6
	BufferRivalsName 7
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_RivalGoChoosePlayer
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
LeaderAide_EventScript_Again:
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_LeaderAide_Text_Again
	WaitButton
	GoTo LeaderAide_EventScript_Menu
	
LeaderAide_EventScript_Menu:
	NPCMsg msg_0451_T01R0301_LeaderAide_Text_WhichTopic
	TouchscreenMenuHide
_cv_page_49:
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0451_T01R0301_LeaderAide_Text_OptChallengers, 0
	ScrCmd_559 msg_0451_T01R0301_LeaderAide_Text_OptConvention, 1
	ScrCmd_559 msg_0451_T01R0301_LeaderAide_Text_OptNewPokemon, 2
	ScrCmd_559 msg_0451_T01R0301_LeaderAide_Text_OptMastery, 3
	ScrCmd_559 msg_0451_T01R0301_LeaderAide_Text_OptRooms, 4
	ScrCmd_559 msg_0451_T01R0301_LeaderAide_Text_OptLegends, 5
	ScrCmd_559 msg_0451_T01R0301_cv_more, 254
	ScrCmd_067
	CompareVarToValue VAR_SPECIAL_RESULT, 254
	GoToIfEq _cv_page_50
	GoTo _cv_page_50_end
_cv_page_50:
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0451_T01R0301_LeaderAide_Text_OptPenny, 6
	ScrCmd_559 msg_0451_T01R0301_LeaderAide_Text_OptCostumes, 7
	ScrCmd_559 msg_0451_T01R0301_LeaderAide_Text_OptTutors, 8
	ScrCmd_559 msg_0451_T01R0301_LeaderAide_Text_OptDone, 9
	ScrCmd_559 msg_0451_T01R0301_cv_more, 254
	ScrCmd_067
	CompareVarToValue VAR_SPECIAL_RESULT, 254
	GoToIfEq _cv_page_49
_cv_page_50_end:
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_51
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_51:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq LeaderAide_EventScript_Challengers
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq LeaderAide_EventScript_Convention
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq LeaderAide_EventScript_NewPokemon
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfEq LeaderAide_EventScript_Mastery
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfEq LeaderAide_EventScript_Rooms
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfEq LeaderAide_EventScript_Legends
	CompareVarToValue VAR_SPECIAL_RESULT, 6
	GoToIfEq LeaderAide_EventScript_Penny
	CompareVarToValue VAR_SPECIAL_RESULT, 7
	GoToIfEq LeaderAide_EventScript_Costumes
	CompareVarToValue VAR_SPECIAL_RESULT, 8
	GoToIfEq LeaderAide_EventScript_Tutors
	NPCMsg msg_0451_T01R0301_LeaderAide_Text_Bye
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_ProfessorOaksLab_EventScript_RightSignAlt:
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_AllMonTypesHaveStrongAndWeakPoints
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_ProfessorOaksLab_EventScript_LastPokeBall:
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_OaksLastMon
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_ProfessorOaksLab_EventScript_ChooseType:
	ApplyMovement 4, Common_Movement_FaceRight
	WaitMovement
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_WhichType
	TouchscreenMenuHide
_cv_page_52:
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0451_T01R0301_GymHack_Text_TypePsychic, 0
	ScrCmd_559 msg_0451_T01R0301_GymHack_Text_TypeFire, 1
	ScrCmd_559 msg_0451_T01R0301_GymHack_Text_TypeNormal, 2
	ScrCmd_559 msg_0451_T01R0301_GymHack_Text_TypeWater, 3
	ScrCmd_559 msg_0451_T01R0301_GymHack_Text_TypeGrass, 4
	ScrCmd_559 msg_0451_T01R0301_GymHack_Text_TypeElectric, 5
	ScrCmd_559 msg_0451_T01R0301_cv_more, 254
	ScrCmd_067
	CompareVarToValue VAR_SPECIAL_RESULT, 254
	GoToIfEq _cv_page_53
	GoTo _cv_page_54_end
_cv_page_53:
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0451_T01R0301_GymHack_Text_TypeRock, 6
	ScrCmd_559 msg_0451_T01R0301_GymHack_Text_TypePoison, 7
	ScrCmd_559 msg_0451_T01R0301_GymHack_Text_TypeBug, 8
	ScrCmd_559 msg_0451_T01R0301_GymHack_Text_TypeSteel, 9
	ScrCmd_559 msg_0451_T01R0301_GymHack_Text_TypeIce, 10
	ScrCmd_559 msg_0451_T01R0301_GymHack_Text_TypeGround, 11
	ScrCmd_559 msg_0451_T01R0301_cv_more, 254
	ScrCmd_067
	CompareVarToValue VAR_SPECIAL_RESULT, 254
	GoToIfEq _cv_page_54
	GoTo _cv_page_54_end
_cv_page_54:
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0451_T01R0301_GymHack_Text_TypeFlying, 12
	ScrCmd_559 msg_0451_T01R0301_GymHack_Text_TypeDragon, 13
	ScrCmd_559 msg_0451_T01R0301_GymHack_Text_TypeFighting, 14
	ScrCmd_559 msg_0451_T01R0301_GymHack_Text_TypeDark, 15
	ScrCmd_559 msg_0451_T01R0301_GymHack_Text_TypeGhost, 16
	ScrCmd_559 msg_0451_T01R0301_GymHack_Text_TypeFairy, 17
	ScrCmd_559 msg_0451_T01R0301_cv_more, 254
	ScrCmd_067
	CompareVarToValue VAR_SPECIAL_RESULT, 254
	GoToIfEq _cv_page_52
_cv_page_54_end:
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_55
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_55:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq PalletTown_ProfessorOaksLab_EventScript_CancelTypeMenu
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_next_57
	SetVar 0x4002, SPECIES_RALTS
	SetVar 0x401E, 14
	GoTo _cv_done_56
_cv_next_57:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfNe _cv_next_58
	SetVar 0x4002, SPECIES_CHARMANDER
	SetVar 0x401E, 10
	GoTo _cv_done_56
_cv_next_58:
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfNe _cv_next_59
	SetVar 0x4002, SPECIES_PORYGON
	SetVar 0x401E, 0
	GoTo _cv_done_56
_cv_next_59:
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfNe _cv_next_60
	SetVar 0x4002, SPECIES_SQUIRTLE
	SetVar 0x401E, 11
	GoTo _cv_done_56
_cv_next_60:
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfNe _cv_next_61
	SetVar 0x4002, SPECIES_BULBASAUR
	SetVar 0x401E, 12
	GoTo _cv_done_56
_cv_next_61:
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfNe _cv_next_62
	SetVar 0x4002, SPECIES_PIKACHU
	SetVar 0x401E, 13
	GoTo _cv_done_56
_cv_next_62:
	CompareVarToValue VAR_SPECIAL_RESULT, 6
	GoToIfNe _cv_next_63
	SetVar 0x4002, SPECIES_LARVITAR
	SetVar 0x401E, 5
	GoTo _cv_done_56
_cv_next_63:
	CompareVarToValue VAR_SPECIAL_RESULT, 7
	GoToIfNe _cv_next_64
	SetVar 0x4002, SPECIES_EKANS
	SetVar 0x401E, 3
	GoTo _cv_done_56
_cv_next_64:
	CompareVarToValue VAR_SPECIAL_RESULT, 8
	GoToIfNe _cv_next_65
	SetVar 0x4002, SPECIES_CATERPIE
	SetVar 0x401E, 6
	GoTo _cv_done_56
_cv_next_65:
	CompareVarToValue VAR_SPECIAL_RESULT, 9
	GoToIfNe _cv_next_66
	SetVar 0x4002, SPECIES_BELDUM
	SetVar 0x401E, 8
	GoTo _cv_done_56
_cv_next_66:
	CompareVarToValue VAR_SPECIAL_RESULT, 10
	GoToIfNe _cv_next_67
	SetVar 0x4002, SPECIES_SPHEAL
	SetVar 0x401E, 15
	GoTo _cv_done_56
_cv_next_67:
	CompareVarToValue VAR_SPECIAL_RESULT, 11
	GoToIfNe _cv_next_68
	SetVar 0x4002, SPECIES_SANDSHREW
	SetVar 0x401E, 4
	GoTo _cv_done_56
_cv_next_68:
	CompareVarToValue VAR_SPECIAL_RESULT, 12
	GoToIfNe _cv_next_69
	SetVar 0x4002, SPECIES_SPEAROW
	SetVar 0x401E, 2
	GoTo _cv_done_56
_cv_next_69:
	CompareVarToValue VAR_SPECIAL_RESULT, 13
	GoToIfNe _cv_next_70
	SetVar 0x4002, SPECIES_DRATINI
	SetVar 0x401E, 16
	GoTo _cv_done_56
_cv_next_70:
	CompareVarToValue VAR_SPECIAL_RESULT, 14
	GoToIfNe _cv_next_71
	SetVar 0x4002, SPECIES_TYROGUE
	SetVar 0x401E, 1
	GoTo _cv_done_56
_cv_next_71:
	CompareVarToValue VAR_SPECIAL_RESULT, 15
	GoToIfNe _cv_next_72
	SetVar 0x4002, SPECIES_POOCHYENA
	SetVar 0x401E, 17
	GoTo _cv_done_56
_cv_next_72:
	CompareVarToValue VAR_SPECIAL_RESULT, 16
	GoToIfNe _cv_next_73
	SetVar 0x4002, SPECIES_GASTLY
	SetVar 0x401E, 7
	GoTo _cv_done_56
_cv_next_73:
	CompareVarToValue VAR_SPECIAL_RESULT, 17
	GoToIfNe _cv_next_74
	SetVar 0x4002, SPECIES_CLEFAIRY
	SetVar 0x401E, 9
	GoTo _cv_done_56
_cv_next_74:
_cv_done_56:
	BufferSpeciesName 0, 0x4002, 0, 0
	BufferTypeName 1, 0x401E
	CompareVarToValue VAR_SPECIAL_RESULT, 14
	CallIfGe PalletTown_ProfessorOaksLab_EventScript_HardType
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_OakConfirmType
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_75
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_76
_cv_yes_75:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_76:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PalletTown_ProfessorOaksLab_EventScript_DeclinedStarter
	CompareVarToValue 0x4002, SPECIES_RALTS
	GoToIfNe _cv_next_78
	SetVar 0x5019, 14
	SetVar 0x501A, 17
	SetVar 0x4003, SPECIES_POOCHYENA
	GoTo _cv_done_77
_cv_next_78:
	CompareVarToValue 0x4002, SPECIES_CHARMANDER
	GoToIfNe _cv_next_79
	SetVar 0x5019, 10
	SetVar 0x501A, 11
	SetVar 0x4003, SPECIES_SQUIRTLE
	GoTo _cv_done_77
_cv_next_79:
	CompareVarToValue 0x4002, SPECIES_PORYGON
	GoToIfNe _cv_next_80
	SetVar 0x5019, 0
	SetVar 0x501A, 1
	SetVar 0x4003, SPECIES_TYROGUE
	GoTo _cv_done_77
_cv_next_80:
	CompareVarToValue 0x4002, SPECIES_SQUIRTLE
	GoToIfNe _cv_next_81
	SetVar 0x5019, 11
	SetVar 0x501A, 13
	SetVar 0x4003, SPECIES_PIKACHU
	GoTo _cv_done_77
_cv_next_81:
	CompareVarToValue 0x4002, SPECIES_BULBASAUR
	GoToIfNe _cv_next_82
	SetVar 0x5019, 12
	SetVar 0x501A, 3
	SetVar 0x4003, SPECIES_EKANS
	GoTo _cv_done_77
_cv_next_82:
	CompareVarToValue 0x4002, SPECIES_PIKACHU
	GoToIfNe _cv_next_83
	SetVar 0x5019, 13
	SetVar 0x501A, 4
	SetVar 0x4003, SPECIES_SANDSHREW
	GoTo _cv_done_77
_cv_next_83:
	CompareVarToValue 0x4002, SPECIES_LARVITAR
	GoToIfNe _cv_next_84
	SetVar 0x5019, 5
	SetVar 0x501A, 11
	SetVar 0x4003, SPECIES_SQUIRTLE
	GoTo _cv_done_77
_cv_next_84:
	CompareVarToValue 0x4002, SPECIES_EKANS
	GoToIfNe _cv_next_85
	SetVar 0x5019, 3
	SetVar 0x501A, 14
	SetVar 0x4003, SPECIES_RALTS
	GoTo _cv_done_77
_cv_next_85:
	CompareVarToValue 0x4002, SPECIES_CATERPIE
	GoToIfNe _cv_next_86
	SetVar 0x5019, 6
	SetVar 0x501A, 10
	SetVar 0x4003, SPECIES_CHARMANDER
	GoTo _cv_done_77
_cv_next_86:
	CompareVarToValue 0x4002, SPECIES_BELDUM
	GoToIfNe _cv_next_87
	SetVar 0x5019, 8
	SetVar 0x501A, 10
	SetVar 0x4003, SPECIES_CHARMANDER
	GoTo _cv_done_77
_cv_next_87:
	CompareVarToValue 0x4002, SPECIES_SPHEAL
	GoToIfNe _cv_next_88
	SetVar 0x5019, 15
	SetVar 0x501A, 5
	SetVar 0x4003, SPECIES_LARVITAR
	GoTo _cv_done_77
_cv_next_88:
	CompareVarToValue 0x4002, SPECIES_SANDSHREW
	GoToIfNe _cv_next_89
	SetVar 0x5019, 4
	SetVar 0x501A, 12
	SetVar 0x4003, SPECIES_BULBASAUR
	GoTo _cv_done_77
_cv_next_89:
	CompareVarToValue 0x4002, SPECIES_SPEAROW
	GoToIfNe _cv_next_90
	SetVar 0x5019, 2
	SetVar 0x501A, 13
	SetVar 0x4003, SPECIES_PIKACHU
	GoTo _cv_done_77
_cv_next_90:
	CompareVarToValue 0x4002, SPECIES_DRATINI
	GoToIfNe _cv_next_91
	SetVar 0x5019, 16
	SetVar 0x501A, 15
	SetVar 0x4003, SPECIES_SPHEAL
	GoTo _cv_done_77
_cv_next_91:
	CompareVarToValue 0x4002, SPECIES_TYROGUE
	GoToIfNe _cv_next_92
	SetVar 0x5019, 1
	SetVar 0x501A, 14
	SetVar 0x4003, SPECIES_RALTS
	GoTo _cv_done_77
_cv_next_92:
	CompareVarToValue 0x4002, SPECIES_POOCHYENA
	GoToIfNe _cv_next_93
	SetVar 0x5019, 17
	SetVar 0x501A, 1
	SetVar 0x4003, SPECIES_TYROGUE
	GoTo _cv_done_77
_cv_next_93:
	CompareVarToValue 0x4002, SPECIES_GASTLY
	GoToIfNe _cv_next_94
	SetVar 0x5019, 7
	SetVar 0x501A, 17
	SetVar 0x4003, SPECIES_POOCHYENA
	GoTo _cv_done_77
_cv_next_94:
	CompareVarToValue 0x4002, SPECIES_CLEFAIRY
	GoToIfNe _cv_next_95
	SetVar 0x5019, 9
	SetVar 0x501A, 8
	SetVar 0x4003, SPECIES_BELDUM
	GoTo _cv_done_77
_cv_next_95:
_cv_done_77:
	Call PalletTown_ProfessorOaksLab_EventScript_SetRivalSpot
	GoTo PalletTown_ProfessorOaksLab_EventScript_ChoseStarter
	CloseMsg
	End
	
PalletTown_ProfessorOaksLab_EventScript_RivalBattle:
	PlayBGM SEQ_GS_E_RIVAL1
	ApplyMovement 5, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	BufferPlayersName 6
	BufferRivalsName 7
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_RivalLetsCheckOutMons
	WaitButton
	CloseMsg
	ApplyMovement 4, Common_Movement_FaceDown
	WaitMovement
	CompareVarToValue 0x5018, 0
	GoToIfEq PalletTown_ProfessorOaksLab_EventScript_RivalApproachForBattleCharmander
	CompareVarToValue 0x5018, 1
	GoToIfEq PalletTown_ProfessorOaksLab_EventScript_RivalApproachForBattleBulbasaur
	CompareVarToValue 0x5018, 2
	GoToIfEq PalletTown_ProfessorOaksLab_EventScript_RivalApproachForBattleSquirtle
	End
	
LeaderAide_EventScript_LabTransition:
	SetFlag 0x201D
	GoToIfUnset 0x2008, Common_EventScript_NopReturn
	ClearFlag 0x201D
	Return
	
PalletTown_ProfessorOaksLab_EventScript_ReadyOakForStarterScene:
	MovePerson 4, 6, 11
	SetObjectMovementType 4, 14
	SetObjectFacing 4, 0
	Return
	
PalletTown_ProfessorOaksLab_EventScript_ReadyOakForNationalDexScene:
	MovePerson 4, 6, 11
	SetObjectMovementType 4, 14
	SetObjectFacing 4, 0
	Return
	
PalletTown_ProfessorOaksLab_EventScript_SetNationalDexSceneFinished:
	SetVar 0x5006, 9
	Return
	
PalletTown_ProfessorOaksLab_EventScript_SetSkipPokeBallCheck:
	SetFlag 0x201E
	Return
	
PalletTown_ProfessorOaksLab_EventScript_NationalDexScene:
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_OakSightingsOfRareMons
	WaitButton
	CloseMsg
	CompareVarToValue 0x5002, 0
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_NationalDexSceneRivalEnterNorth
	CompareVarToValue 0x5002, 1
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_NationalDexSceneRivalEnterSouth
	CompareVarToValue 0x5002, 3
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_NationalDexSceneRivalEnterEastWest
	CompareVarToValue 0x5002, 2
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_NationalDexSceneRivalEnterEastWest
	BufferPlayersName 6
	BufferRivalsName 7
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_RivalJustLetMeHandleEverything
	WaitButton
	ResetBGM
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_OakNeedYourHelpTooNeedToSeePokedexes
	WaitButton
	CompareVarToValue 0x5002, 0
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_PlayerFaceOakNorth
	CompareVarToValue 0x5002, 2
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_PlayerFaceOakWest
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_OakTookBothPokedexUnits
	WaitButton
	CloseMsg
	Call EventScript_RestorePrevTextColor
	CompareVarToValue 0x5002, 0
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_OakBringDexesToDeskNorth
	CompareVarToValue 0x5002, 1
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_OakBringDexesToDeskSouth
	CompareVarToValue 0x5002, 3
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_OakBringDexesToDeskEast
	CompareVarToValue 0x5002, 2
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_OakBringDexesToDeskWest
	GoToIfUnset 0x2025, _cv_show_96
	ClearFlag 0x2025
	ShowPerson 6
	SetFlag 0x2025
	GoTo _cv_shown_97
_cv_show_96:
	ShowPerson 6
_cv_shown_97:
	GoToIfUnset 0x2025, _cv_show_98
	ClearFlag 0x2025
	ShowPerson 7
	SetFlag 0x2025
	GoTo _cv_shown_99
_cv_show_98:
	ShowPerson 7
_cv_shown_99:
	Wait 30, VAR_SPECIAL_RESULT
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_OakNowTheseUnitsCanRecordMoreData
	WaitButton
	CloseMsg
	HidePerson 6
	SetFlag 0x2025
	HidePerson 7
	SetFlag 0x2025
	Wait 30, VAR_SPECIAL_RESULT
	CompareVarToValue 0x5002, 0
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_OakBringDexesOverNorth
	CompareVarToValue 0x5002, 1
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_OakBringDexesOverSouth
	CompareVarToValue 0x5002, 3
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_OakBringDexesOverEast
	CompareVarToValue 0x5002, 2
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_OakBringDexesOverWest
	PlayFanfare SEQ_ME_ITEM
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_PlayersPokedexWasUpgraded
	WaitFanfare
	Call EventScript_RestorePrevTextColor
	SetFlag 0x2026
	BufferPlayersName 6
	BufferRivalsName 7
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_OakMustReallyWorkToFillPokedex
	WaitButton
	BufferRivalsName 7
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_RivalIllCompleteThePokedex
	WaitButton
	CloseMsg
	PlayBGM SEQ_GS_E_RIVAL2
	CompareVarToValue 0x5002, 0
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_RivalExitNorth
	CompareVarToValue 0x5002, 1
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_RivalExit
	CompareVarToValue 0x5002, 3
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_RivalExit
	CompareVarToValue 0x5002, 2
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_RivalExit
	HidePerson 5
	SetFlag 0x2024
	ResetBGM
	SetVar 0x5006, 8
	ReleaseAll
	End
	
GymRooms_EventScript_Return:
	Return
	
GymRooms_EventScript_BackRoom:
	NPCMsg msg_0451_T01R0301_GymRooms_Text_OakBackRoom
	WaitButton
	GoTo GymRooms_EventScript_Give
	
GymRooms_EventScript_LeftRoom:
	NPCMsg msg_0451_T01R0301_GymRooms_Text_OakLeftRoom
	WaitButton
	GoTo GymRooms_EventScript_Give
	
GymRooms_EventScript_Give:
	CompareVarToValue 0x8004, 1
	GoToIfNe _cv_next_101
	SetFlag 0x209A
	GoTo _cv_done_100
_cv_next_101:
	CompareVarToValue 0x8004, 2
	GoToIfNe _cv_next_102
	SetFlag 0x209B
	GoTo _cv_done_100
_cv_next_102:
	CompareVarToValue 0x8004, 3
	GoToIfNe _cv_next_103
	SetFlag 0x209C
	GoTo _cv_done_100
_cv_next_103:
_cv_done_100:
	PlayFanfare SEQ_ME_ITEM
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_GymRooms_Text_DoorwayOpened
	WaitFanfare
	Call EventScript_RestorePrevTextColor
	NPCMsg msg_0451_T01R0301_GymRooms_Text_OakShowItOff
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventMons_EventScript_Return:
	Return
	
EventMons_EventScript_OakPikachuOffer:
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_EventMons_Text_OakPikachuOffer
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_104
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_105
_cv_yes_104:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_105:
	Return
	
EventMons_EventScript_OakEeveeOffer:
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_EventMons_Text_OakEeveeOffer
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_106
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_107
_cv_yes_106:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_107:
	Return
	
EventMons_EventScript_OakQuizLater:
	NPCMsg msg_0451_T01R0301_EventMons_Text_OakQuizLater
	WaitButton
	Return
	
EventMons_EventScript_EeveeQuiz:
	NPCMsg msg_0451_T01R0301_EventMons_Text_QuizN1
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 0, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0451_T01R0301_EventMons_Text_AnsRock, 0
	ScrCmd_559 msg_0451_T01R0301_EventMons_Text_AnsGhost, 1
	ScrCmd_559 msg_0451_T01R0301_EventMons_Text_AnsPsychic, 2
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_109
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_109:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq EventMons_EventScript_QuizRight
	NPCMsg msg_0451_T01R0301_EventMons_Text_QuizN2
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 0, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0451_T01R0301_EventMons_Text_AnsFighting, 0
	ScrCmd_559 msg_0451_T01R0301_EventMons_Text_AnsGhost, 1
	ScrCmd_559 msg_0451_T01R0301_EventMons_Text_AnsDark, 2
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_111
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_111:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	CallIfEq EventMons_EventScript_QuizRight
	NPCMsg msg_0451_T01R0301_EventMons_Text_QuizN3
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 0, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0451_T01R0301_EventMons_Text_AnsPsychic, 0
	ScrCmd_559 msg_0451_T01R0301_EventMons_Text_AnsFighting, 1
	ScrCmd_559 msg_0451_T01R0301_EventMons_Text_AnsSteel, 2
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_113
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_113:
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	CallIfEq EventMons_EventScript_QuizRight
	NPCMsg msg_0451_T01R0301_EventMons_Text_QuizN4
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 0, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0451_T01R0301_EventMons_Text_AnsRefrigerate, 0
	ScrCmd_559 msg_0451_T01R0301_EventMons_Text_AnsPixilate, 1
	ScrCmd_559 msg_0451_T01R0301_EventMons_Text_AnsAerilate, 2
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_115
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_115:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq EventMons_EventScript_QuizRight
	NPCMsg msg_0451_T01R0301_EventMons_Text_QuizN5
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 0, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0451_T01R0301_EventMons_Text_AnsHyperBeam, 0
	ScrCmd_559 msg_0451_T01R0301_EventMons_Text_AnsBodySlam, 1
	ScrCmd_559 msg_0451_T01R0301_EventMons_Text_AnsQuickAttack, 2
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_117
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_117:
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	CallIfEq EventMons_EventScript_QuizRight
	GoTo EventMons_EventScript_QuizScore
	
EventMons_EventScript_QuizRight:
	AddVar 0x800A, 1
	Return
	
EventMons_EventScript_QuizScore:
	BufferInt 0, 0x800A
	CompareVarToValue 0x800A, 5
	GoToIfNe EventMons_EventScript_QuizFailed
	NPCMsg msg_0451_T01R0301_EventMons_Text_QuizPassed
	WaitButton
	SetVar 0x8004, 0
	CompareVarToValue 0x8009, 2
	CallIfEq EventMons_EventScript_SetEeveeStarter
	SetVar 0x8005, 5
	SetVar 0x8006, 0
	Call EventMons_EventScript_Gift
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq EventMons_EventScript_ReleaseEnd
	CompareVarToValue 0x8009, 1
	CallIfEq EventMons_EventScript_SetPartnerPikachu
	CompareVarToValue 0x8009, 2
	CallIfEq EventMons_EventScript_SetPartnerEevee
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_EventMons_Text_OakPartnerAfter
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymSwitch_EventScript_Return:
	Return
	
GymSwitch_EventScript_LabGymCharm:
	CompareVarToValue 0x5009, 2
	GoToIfLt GymSwitch_EventScript_Return
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x202E, _cv_has_118
	SetVar VAR_SPECIAL_RESULT, 1
_cv_has_118:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymSwitch_EventScript_Return
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_GymSwitch_Text_LabGymCharm
	WaitButton
	SetFlag 0x202E
	SetVar VAR_SPECIAL_RESULT, 1
	NPCMsg msg_0451_T01R0301_GymSwitch_Text_LabGymCharmHow
	WaitButton
	Return
	
GymSwitch_EventScript_LabGoal:
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_GymSwitch_Text_LabGoal
	WaitButton
	GoTo GymSwitch_EventScript_Return
	
GymSwitch_EventScript_LabMidStreak:
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_GymSwitch_Text_LabMidStreak
	WaitButton
	GoToIfUnset 0x201F, GymSwitch_EventScript_Return
	NPCMsg msg_0451_T01R0301_GymSwitch_Text_LabMidStreakMastered
	WaitButton
	Return
	
GymSwitch_EventScript_LabOffer:
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_GymSwitch_Text_LabOffer
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_119
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_120
_cv_yes_119:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_120:
	GoTo GymSwitch_EventScript_LabAnswer
	
GymSwitch_EventScript_LabAnswer:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymSwitch_EventScript_LabNo
	// TODO(gba) special GymSwitch_OnlyNewTypes
	GoTo _cv_stop
	Call GymSwitch_EventScript_ChooseType
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymSwitch_EventScript_LabNo
	CompareVarToValue 0x5014, 5
	GoToIfEq GymSwitch_EventScript_LabLegendHint
	ReleaseAll
	End
	
PokedexRating_EventScript_RateInPerson:
	CallIfSet 0x201B, PokedexRating_EventScript_DexCompleteIntro
	CallIfUnset 0x201B, PokedexRating_EventScript_NormalIntro
	Call PokedexRating_EventScript_Rate
	Return
	
PalletTown_ProfessorOaksLab_EventScript_DexCompleted:
	CloseMsg
	Wait 40, VAR_SPECIAL_RESULT
	NPCMsg msg_0451_T01R0301_PokedexRating_Text_Wroooaaarrr
	CompareVarToValue 0x5002, 0
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_OakExcitedNorth
	CompareVarToValue 0x5002, 1
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_OakExcitedSouth
	CompareVarToValue 0x5002, 3
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_OakExcitedEast
	CompareVarToValue 0x5002, 2
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_OakExcitedWest
	FacePlayer
	WaitMovement
	CloseMsg
	Wait 70, VAR_SPECIAL_RESULT
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_PokedexRating_Text_ThankYouMadeDreamReality
	WaitButton
	SetFlag 2
	CloseMsg
	ReleaseAll
	End
	
PalletTown_ProfessorOaksLab_EventScript_DontStartNationalDexScene:
	ReleaseAll
	End
	
EventScript_PalmPilotReturn:
	Return
	
GymCandidate_EventScript_Return:
	Return
	
GymCandidate_EventScript_OakAside1:
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_GymCandidate_Text_OakAside1
	WaitButton
	Return
	
GymCandidate_EventScript_OakAside2:
	NPCMsg msg_0451_T01R0301_GymCandidate_Text_OakAside2
	WaitButton
	Return
	
GymCandidate_EventScript_OakAside3:
	NPCMsg msg_0451_T01R0301_GymCandidate_Text_OakAside3
	WaitButton
	Return
	
PalletTown_ProfessorOaksLab_EventScript_CheckIfPlayerNeedsBalls:
	GoToIfSet 0x201E, PalletTown_ProfessorOaksLab_EventScript_MonsAroundWorldWait
	GoToIfSet 0x2018, PalletTown_ProfessorOaksLab_EventScript_PlayerAlreadyGotBalls
	HasItem ITEM_POKE_BALL, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PalletTown_ProfessorOaksLab_EventScript_PlayerOutOfBalls
	GoTo PalletTown_ProfessorOaksLab_EventScript_MonsAroundWorldWait
	End
	
EventScript_RestorePrevTextColor:
	CopyVar 0x5015, 0x5016
	Return
	
PalletTown_ProfessorOaksLab_EventScript_DexSceneRivalEnterNorth:
	MovePerson 5, 5, 10
	GoToIfUnset 0x2024, _cv_show_121
	ClearFlag 0x2024
	ShowPerson 5
	SetFlag 0x2024
	GoTo _cv_shown_122
_cv_show_121:
	ShowPerson 5
_cv_shown_122:
	ApplyMovement obj_player, PalletTown_ProfessorOaksLab_Movement_WatchRivalEnterNorth
	ApplyMovement 5, PalletTown_ProfessorOaksLab_Movement_RivalEnter
	WaitMovement
	Return
	
PalletTown_ProfessorOaksLab_EventScript_DexSceneRivalEnterSouth:
	MovePerson 5, 6, 10
	GoToIfUnset 0x2024, _cv_show_123
	ClearFlag 0x2024
	ShowPerson 5
	SetFlag 0x2024
	GoTo _cv_shown_124
_cv_show_123:
	ShowPerson 5
_cv_shown_124:
	ApplyMovement 4, Common_Movement_WalkInPlaceFasterDown
	ApplyMovement 5, PalletTown_ProfessorOaksLab_Movement_RivalEnter
	WaitMovement
	Return
	
PalletTown_ProfessorOaksLab_EventScript_DexSceneRivalEnterEastWest:
	MovePerson 5, 6, 10
	GoToIfUnset 0x2024, _cv_show_125
	ClearFlag 0x2024
	ShowPerson 5
	SetFlag 0x2024
	GoTo _cv_shown_126
_cv_show_125:
	ShowPerson 5
_cv_shown_126:
	ApplyMovement 4, Common_Movement_WalkInPlaceFasterDown
	ApplyMovement obj_player, PalletTown_ProfessorOaksLab_Movement_WatchRivalEnterEastWest
	ApplyMovement 5, PalletTown_ProfessorOaksLab_Movement_RivalEnter
	WaitMovement
	Return
	
PalletTown_ProfessorOaksLab_EventScript_DexSceneOakFacePlayerAndRivalSouth:
	FacePlayer
	WaitMovement
	Wait 15, VAR_SPECIAL_RESULT
	ApplyMovement 4, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	Return
	
PalletTown_ProfessorOaksLab_EventScript_DexSceneOakFacePlayerAndRivalEast:
	FacePlayer
	WaitMovement
	Wait 15, VAR_SPECIAL_RESULT
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterRight
	ApplyMovement 4, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	Return
	
PalletTown_ProfessorOaksLab_EventScript_DexSceneOakFacePlayerAndRivalWest:
	FacePlayer
	WaitMovement
	Wait 15, VAR_SPECIAL_RESULT
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterLeft
	ApplyMovement 4, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	Return
	
PalletTown_ProfessorOaksLab_EventScript_DexSceneOakFacePlayerAndRivalNorth:
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	Return
	
PalletTown_ProfessorOaksLab_EventScript_DexSceneOakWalkToDeskNorth:
	ApplyMovement 4, PalletTown_ProfessorOaksLab_Movement_OakWalkToDesk
	WaitMovement
	Return
	
PalletTown_ProfessorOaksLab_EventScript_DexSceneOakWalkToDeskSouth:
	ApplyMovement 4, PalletTown_ProfessorOaksLab_Movement_OakWalkToDeskSouth
	ApplyMovement obj_player, PalletTown_ProfessorOaksLab_Movement_WatchOakWalkToDesk
	ApplyMovement 5, PalletTown_ProfessorOaksLab_Movement_WatchOakWalkToDesk
	WaitMovement
	Return
	
PalletTown_ProfessorOaksLab_EventScript_DexSceneOakWalkToDeskEast:
	ApplyMovement 4, PalletTown_ProfessorOaksLab_Movement_OakWalkToDesk
	ApplyMovement obj_player, PalletTown_ProfessorOaksLab_Movement_WatchOakWalkToDeskEast
	WaitMovement
	Return
	
PalletTown_ProfessorOaksLab_EventScript_DexSceneOakWalkToDeskWest:
	ApplyMovement 4, PalletTown_ProfessorOaksLab_Movement_OakWalkToDesk
	WaitMovement
	Return
	
PalletTown_ProfessorOaksLab_EventScript_OakBringDexesOverNorth:
	ApplyMovement 4, PalletTown_ProfessorOaksLab_Movement_OakBringDexesOver
	WaitMovement
	Return
	
PalletTown_ProfessorOaksLab_EventScript_OakBringDexesOverSouth:
	ApplyMovement 4, PalletTown_ProfessorOaksLab_Movement_OakBringDexesOverSouth
	WaitMovement
	Return
	
PalletTown_ProfessorOaksLab_EventScript_OakBringDexesOverEast:
	ApplyMovement 4, PalletTown_ProfessorOaksLab_Movement_OakBringDexesOver
	ApplyMovement obj_player, PalletTown_ProfessorOaksLab_Movement_PlayerFaceOakForDexEast
	WaitMovement
	Return
	
PalletTown_ProfessorOaksLab_EventScript_OakBringDexesOverWest:
	ApplyMovement 4, PalletTown_ProfessorOaksLab_Movement_OakBringDexesOver
	WaitMovement
	Return
	
PalletTown_ProfessorOaksLab_EventScript_DexSceneRivalFacePlayerNorth:
	FacePlayer
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterLeft
	WaitMovement
	Return
	
PalletTown_ProfessorOaksLab_EventScript_DexSceneRivalFacePlayerSouth:
	ApplyMovement 5, Common_Movement_WalkInPlaceFasterUp
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	Return
	
PalletTown_ProfessorOaksLab_EventScript_DexSceneRivalFacePlayerEastWest:
	FacePlayer
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	Return
	
PalletTown_ProfessorOaksLab_EventScript_RivalExitNorth:
	ApplyMovement obj_player, PalletTown_ProfessorOaksLab_Movement_WatchRivalEnterEastWest
	ApplyMovement 5, PalletTown_ProfessorOaksLab_Movement_RivalExit
	WaitMovement
	Return
	
PalletTown_ProfessorOaksLab_EventScript_RivalExit:
	ApplyMovement 5, PalletTown_ProfessorOaksLab_Movement_RivalExit
	WaitMovement
	Return
	
GymCandidate_EventScript_MentorIntro:
	// TODO(gba) special GymCandidate_PrepareMentorIntro
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_Return
	Wait 30, VAR_SPECIAL_RESULT
	PlaySE SEQ_SE_DP_DOOR
	NPCMsg msg_0451_T01R0301_GymCandidate_Text_MentorAtDoor
	WaitButton
	CloseMsg
	Call GymCandidate_EventScript_VisitorWalksIn
	PlaySE SEQ_SE_DP_SELECT
	ApplyMovement 4, Common_Movement_ExclamationMark
	WaitMovement
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_128
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_127
_cv_next_128:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_129
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_127
_cv_next_129:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_130
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Misty
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_127
_cv_next_130:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_131
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_127
_cv_next_131:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_132
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_127
_cv_next_132:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_133
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Erika
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_127
_cv_next_133:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_134
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_127
_cv_next_134:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_135
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_127
_cv_next_135:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_136
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_127
_cv_next_136:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_137
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_127
_cv_next_137:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_138
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Blaine
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_127
_cv_next_138:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_139
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_127
_cv_next_139:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_140
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_127
_cv_next_140:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_141
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Lorelei
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_127
_cv_next_141:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_142
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_127
_cv_next_142:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_143
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_127
_cv_next_143:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_144
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_127
_cv_next_144:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_145
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_127
_cv_next_145:
_cv_done_127:
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_GymCandidate_Text_OakWelcomesMentor
	WaitButton
	// TODO(gba) special GymCandidate_BufferMentorIntro
	GoTo _cv_stop
	Call _cv_str4
	WaitButton
	// TODO(gba) special GymCandidate_BufferMentorStory
	GoTo _cv_stop
	Call _cv_str4
	WaitButton
	// TODO(gba) special GymCandidate_BufferMentorQuestion
	GoTo _cv_stop
	Call _cv_str4
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_146
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_147
_cv_yes_146:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_147:
	// TODO(gba) special GymCandidate_BufferMentorAnswer
	GoTo _cv_stop
	Call _cv_str4
	WaitButton
	// TODO(gba) special GymCandidate_GiveMentorDecor
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq GymCandidate_EventScript_MentorDecorGift
	// TODO(gba) special GymCandidate_BufferMentorFarewell
	GoTo _cv_stop
	Call _cv_str4
	WaitButton
	Call GymCandidate_EventScript_VisitorWalksOut
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_149
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_148
_cv_next_149:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_150
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_148
_cv_next_150:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_151
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Misty
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_148
_cv_next_151:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_152
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_148
_cv_next_152:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_153
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_148
_cv_next_153:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_154
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Erika
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_148
_cv_next_154:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_155
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_148
_cv_next_155:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_156
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_148
_cv_next_156:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_157
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_148
_cv_next_157:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_158
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_148
_cv_next_158:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_159
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Blaine
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_148
_cv_next_159:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_160
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_148
_cv_next_160:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_161
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_148
_cv_next_161:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_162
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Lorelei
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_148
_cv_next_162:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_163
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_148
_cv_next_163:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_164
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_148
_cv_next_164:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_165
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_148
_cv_next_165:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_166
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_148
_cv_next_166:
_cv_done_148:
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_GymCandidate_Text_OakAfterMentor
	WaitButton
	Return
	
DadStory_EventScript_ArmSendoff:
	CompareVarToValue 0x5008, 0
	GoToIfNe Common_EventScript_NopReturn
	SetVar 0x5008, 1
	Return
	
LeaderAide_EventScript_Challengers:
	NPCMsg msg_0451_T01R0301_LeaderAide_Text_Challengers
	WaitButton
	GoTo LeaderAide_EventScript_Menu
	
LeaderAide_EventScript_Convention:
	NPCMsg msg_0451_T01R0301_LeaderAide_Text_Convention
	WaitButton
	GoTo LeaderAide_EventScript_Menu
	
LeaderAide_EventScript_NewPokemon:
	NPCMsg msg_0451_T01R0301_LeaderAide_Text_NewPokemon
	WaitButton
	GoTo LeaderAide_EventScript_Menu
	
LeaderAide_EventScript_Mastery:
	NPCMsg msg_0451_T01R0301_LeaderAide_Text_Mastery
	WaitButton
	GoTo LeaderAide_EventScript_Menu
	
LeaderAide_EventScript_Rooms:
	NPCMsg msg_0451_T01R0301_LeaderAide_Text_Rooms
	WaitButton
	GoTo LeaderAide_EventScript_Menu
	
LeaderAide_EventScript_Legends:
	NPCMsg msg_0451_T01R0301_LeaderAide_Text_Legends
	WaitButton
	GoTo LeaderAide_EventScript_Menu
	
LeaderAide_EventScript_Penny:
	NPCMsg msg_0451_T01R0301_LeaderAide_Text_Penny
	WaitButton
	GoTo LeaderAide_EventScript_Menu
	
LeaderAide_EventScript_Costumes:
	NPCMsg msg_0451_T01R0301_LeaderAide_Text_Costumes
	WaitButton
	GoTo LeaderAide_EventScript_Menu
	
LeaderAide_EventScript_Tutors:
	NPCMsg msg_0451_T01R0301_LeaderAide_Text_Tutors
	WaitButton
	GoTo LeaderAide_EventScript_Menu
	
PalletTown_ProfessorOaksLab_EventScript_CancelTypeMenu:
	CloseMsg
	ReleaseAll
	End
	
PalletTown_ProfessorOaksLab_EventScript_HardType:
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_HardType
	WaitButton
	Return
	
PalletTown_ProfessorOaksLab_EventScript_DeclinedStarter:
	ReleaseAll
	End
	
PalletTown_ProfessorOaksLab_EventScript_SetRivalSpot:
	GetPlayerCoords 0x4005, 0x4006
	SetVar 0x4001, 2
	CompareVarToValue 0x4005, 8
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_RivalSpotRight
	CompareVarToValue 0x4005, 9
	CallIfEq PalletTown_ProfessorOaksLab_EventScript_RivalSpotLeft
	Return
	
PalletTown_ProfessorOaksLab_EventScript_ChoseStarter:
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_OakThisMonIsEnergetic
	WaitButton
	Call EventScript_RestorePrevTextColor
	SetFlag 0x2020
	SetFlag 0x2003
	GiveMon 0x4002, 5, 0, 0, 0, VAR_SPECIAL_RESULT
	CopyVar 0x5018, 0x4001
	BufferSpeciesName 0, 0x4002, 0, 0
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_ReceivedMonFromOak
	PlayFanfare SEQ_ME_ITEM
	WaitFanfare
	NPCMsg msg_0451_T01R0301_gText_NicknameThisPokemon
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_167
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_168
_cv_yes_167:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_168:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq EventScript_GiveNicknameToStarter
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PalletTown_ProfessorOaksLab_EventScript_RivalPicksStarter
	CloseMsg
	End
	
PalletTown_ProfessorOaksLab_EventScript_RivalApproachForBattleCharmander:
	CompareVarToValue 0x4002, 1
	GoToIfEq PalletTown_ProfessorOaksLab_EventScript_RivalApproachForBattleCharmanderLeft
	CompareVarToValue 0x4002, 2
	GoToIfEq PalletTown_ProfessorOaksLab_EventScript_RivalApproachForBattleCharmanderMid
	CompareVarToValue 0x4002, 3
	GoToIfEq PalletTown_ProfessorOaksLab_EventScript_RivalApproachForBattleCharmanderRight
	End
	
PalletTown_ProfessorOaksLab_EventScript_RivalApproachForBattleBulbasaur:
	CompareVarToValue 0x4002, 1
	GoToIfEq PalletTown_ProfessorOaksLab_EventScript_RivalApproachForBattleBulbasaurLeft
	CompareVarToValue 0x4002, 2
	GoToIfEq PalletTown_ProfessorOaksLab_EventScript_RivalApproachForBattleBulbasaurMid
	CompareVarToValue 0x4002, 3
	GoToIfEq PalletTown_ProfessorOaksLab_EventScript_RivalApproachForBattleBulbasaurRight
	End
	
PalletTown_ProfessorOaksLab_EventScript_RivalApproachForBattleSquirtle:
	CompareVarToValue 0x4002, 1
	GoToIfEq PalletTown_ProfessorOaksLab_EventScript_RivalApproachForBattleSquirtleLeft
	CompareVarToValue 0x4002, 2
	GoToIfEq PalletTown_ProfessorOaksLab_EventScript_RivalApproachForBattleSquirtleMid
	CompareVarToValue 0x4002, 3
	GoToIfEq PalletTown_ProfessorOaksLab_EventScript_RivalApproachForBattleSquirtleRight
	End
	
Common_EventScript_NopReturn:
	Return
	
PalletTown_ProfessorOaksLab_EventScript_NationalDexSceneRivalEnterNorth:
	MovePerson 5, 5, 10
	GoToIfUnset 0x2024, _cv_show_169
	ClearFlag 0x2024
	ShowPerson 5
	SetFlag 0x2024
	GoTo _cv_shown_170
_cv_show_169:
	ShowPerson 5
_cv_shown_170:
	PlayBGM SEQ_GS_E_RIVAL1
	ApplyMovement obj_player, PalletTown_ProfessorOaksLab_Movement_WatchRivalEnterNorth
	ApplyMovement 5, PalletTown_ProfessorOaksLab_Movement_RivalEnter
	WaitMovement
	Return
	
PalletTown_ProfessorOaksLab_EventScript_NationalDexSceneRivalEnterSouth:
	MovePerson 5, 6, 10
	GoToIfUnset 0x2024, _cv_show_171
	ClearFlag 0x2024
	ShowPerson 5
	SetFlag 0x2024
	GoTo _cv_shown_172
_cv_show_171:
	ShowPerson 5
_cv_shown_172:
	PlayBGM SEQ_GS_E_RIVAL1
	ApplyMovement 4, Common_Movement_WalkInPlaceFasterDown
	ApplyMovement 5, PalletTown_ProfessorOaksLab_Movement_RivalEnter
	WaitMovement
	Return
	
PalletTown_ProfessorOaksLab_EventScript_NationalDexSceneRivalEnterEastWest:
	MovePerson 5, 6, 10
	GoToIfUnset 0x2024, _cv_show_173
	ClearFlag 0x2024
	ShowPerson 5
	SetFlag 0x2024
	GoTo _cv_shown_174
_cv_show_173:
	ShowPerson 5
_cv_shown_174:
	PlayBGM SEQ_GS_E_RIVAL1
	ApplyMovement 4, Common_Movement_WalkInPlaceFasterDown
	ApplyMovement obj_player, PalletTown_ProfessorOaksLab_Movement_WatchRivalEnterEastWest
	ApplyMovement 5, PalletTown_ProfessorOaksLab_Movement_RivalEnter
	WaitMovement
	Return
	
PalletTown_ProfessorOaksLab_EventScript_PlayerFaceOakNorth:
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	Return
	
PalletTown_ProfessorOaksLab_EventScript_PlayerFaceOakWest:
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterLeft
	WaitMovement
	Return
	
PalletTown_ProfessorOaksLab_EventScript_OakBringDexesToDeskNorth:
	ApplyMovement 4, PalletTown_ProfessorOaksLab_Movement_OakBringDexesToDesk
	WaitMovement
	Return
	
PalletTown_ProfessorOaksLab_EventScript_OakBringDexesToDeskSouth:
	ApplyMovement 4, PalletTown_ProfessorOaksLab_Movement_OakBringDexesToDeskSouth
	ApplyMovement obj_player, PalletTown_ProfessorOaksLab_Movement_WatchOakWalkToDesk
	ApplyMovement 5, PalletTown_ProfessorOaksLab_Movement_WatchOakWalkToDesk
	WaitMovement
	Return
	
PalletTown_ProfessorOaksLab_EventScript_OakBringDexesToDeskEast:
	ApplyMovement 4, PalletTown_ProfessorOaksLab_Movement_OakBringDexesToDesk
	ApplyMovement obj_player, PalletTown_ProfessorOaksLab_Movement_WatchOakWalkToDeskEast
	WaitMovement
	Return
	
PalletTown_ProfessorOaksLab_EventScript_OakBringDexesToDeskWest:
	ApplyMovement 4, PalletTown_ProfessorOaksLab_Movement_OakBringDexesToDesk
	WaitMovement
	Return
	
EventMons_EventScript_QuizFailed:
	NPCMsg msg_0451_T01R0301_EventMons_Text_QuizFailed
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventMons_EventScript_SetEeveeStarter:
	SetVar 0x8004, 0
	Return
	
EventMons_EventScript_Gift:
	// TODO(gba) special EventMons_GiveMon
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq EventMons_EventScript_GiftFull
	PlayFanfare SEQ_ME_LVUP
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_EventMons_Text_Received
	WaitFanfare
	SetVar VAR_SPECIAL_RESULT, 1
	Return
	
EventMons_EventScript_ReleaseEnd:
	ReleaseAll
	End
	
EventMons_EventScript_SetPartnerPikachu:
	SetFlag 0x2021
	Return
	
EventMons_EventScript_SetPartnerEevee:
	SetFlag 0x2022
	Return
	
GymSwitch_EventScript_LabNo:
	NPCMsg msg_0451_T01R0301_GymSwitch_Text_LabNo
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymSwitch_EventScript_ChooseType:
	CompareVarToValue 0x8004, 1
	GoToIfEq GymSwitch_EventScript_AskNewType
	NPCMsg msg_0451_T01R0301_GymSwitch_Text_WhichTypeStars
	GoTo GymSwitch_EventScript_TypeMenu
	CloseMsg
	End
	
GymSwitch_EventScript_LabLegendHint:
	NPCMsg msg_0451_T01R0301_GymSwitch_Text_LabLegendHint
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PokedexRating_EventScript_DexCompleteIntro:
	NPCMsg msg_0451_T01R0301_PokedexRating_Text_LoveSeeingYourPokedex
	WaitButton
	Return
	
PokedexRating_EventScript_NormalIntro:
	NPCMsg msg_0451_T01R0301_PokedexRating_Text_HowIsPokedexComingAlong
	WaitButton
	Return
	
PokedexRating_EventScript_Rate:
	CountNationalDexSeen 0x8005
	CountNationalDexOwned 0x8006
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x2026, _cv_dex_175
	SetVar VAR_SPECIAL_RESULT, 1
_cv_dex_175:
	CopyVar 0x8008, 0x8005
	CopyVar 0x8009, 0x8006
	CopyVar 0x800A, VAR_SPECIAL_RESULT
	BufferInt 0, 0x8008
	BufferInt 1, 0x8009
	NPCMsg msg_0451_T01R0301_PokedexRating_Text_SeenXOwnedY
	WaitButton
	CallIfUnset 0x2023, PokedexRating_EventScript_SetTextColor
	Call PokedexRating_EventScript_ShowRatingMsg
	CompareVarToValue 0x800A, 0
	GoToIfEq PokedexRating_EventScript_EndRating
	SetVar 0x8004, 1
	CountNationalDexSeen 0x8005
	CountNationalDexOwned 0x8006
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x2026, _cv_dex_176
	SetVar VAR_SPECIAL_RESULT, 1
_cv_dex_176:
	CopyVar 0x8008, 0x8005
	CopyVar 0x8009, 0x8006
	BufferInt 0, 0x8008
	BufferInt 1, 0x8009
	NPCMsg msg_0451_T01R0301_PokedexRating_Text_NationalDexSeenXOwnedY
	WaitButton
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar HasAllMons
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PokedexRating_EventScript_DexIncomplete
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq PokedexRating_EventScript_DexComplete
	CloseMsg
	End
	
PalletTown_ProfessorOaksLab_EventScript_OakExcitedNorth:
	ApplyMovement 4, PalletTown_ProfessorOaksLab_Movement_OakExcitedNorth
	WaitMovement
	Return
	
PalletTown_ProfessorOaksLab_EventScript_OakExcitedSouth:
	ApplyMovement 4, PalletTown_ProfessorOaksLab_Movement_OakExcitedSouth
	WaitMovement
	Return
	
PalletTown_ProfessorOaksLab_EventScript_OakExcitedEast:
	ApplyMovement 4, PalletTown_ProfessorOaksLab_Movement_OakExcitedEast
	WaitMovement
	Return
	
PalletTown_ProfessorOaksLab_EventScript_OakExcitedWest:
	ApplyMovement 4, PalletTown_ProfessorOaksLab_Movement_OakExcitedWest
	WaitMovement
	Return
	
PalletTown_ProfessorOaksLab_EventScript_PlayerAlreadyGotBalls:
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_OakComeSeeMeSometime
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_ProfessorOaksLab_EventScript_PlayerOutOfBalls:
	CompareVarToValue 0x5013, 2
	GoToIfGe PalletTown_ProfessorOaksLab_EventScript_GivePlayerMoreBalls
	GoTo PalletTown_ProfessorOaksLab_EventScript_MonsAroundWorldWait
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
	
GymCandidate_EventScript_MentorDecorGift:
	NPCMsg msg_0451_T01R0301_GymCandidate_Text_MentorDecorGift
	WaitButton
	PlayFanfare SEQ_ME_ITEM
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_GymCandidate_Text_ReceivedMentorDecor
	WaitButton
	WaitFanfare
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
	
PalletTown_ProfessorOaksLab_EventScript_RivalSpotRight:
	SetVar 0x4001, 0
	Return
	
PalletTown_ProfessorOaksLab_EventScript_RivalSpotLeft:
	SetVar 0x4001, 1
	Return
	
EventScript_GiveNicknameToStarter:
	SetVar 0x8004, 0
	Call Common_EventScript_NameReceivedPartyMon
	GoTo PalletTown_ProfessorOaksLab_EventScript_RivalPicksStarter
	End
	
PalletTown_ProfessorOaksLab_EventScript_RivalPicksStarter:
	CloseMsg
	CompareVarToValue 0x4001, 0
	GoToIfEq PalletTown_ProfessorOaksLab_EventScript_RivalWalksToCharmander
	CompareVarToValue 0x4001, 1
	GoToIfEq PalletTown_ProfessorOaksLab_EventScript_RivalWalksToBulbasaur
	CompareVarToValue 0x4001, 2
	GoToIfEq PalletTown_ProfessorOaksLab_EventScript_RivalWalksToSquirtle
	End
	
PalletTown_ProfessorOaksLab_EventScript_RivalApproachForBattleCharmanderLeft:
	ApplyMovement 5, PalletTown_ProfessorOaksLab_Movement_ApproachForBattleCharmanderLeft
	WaitMovement
	GoTo PalletTown_ProfessorOaksLab_EventScript_RivalBattleCharmander
	End
	
PalletTown_ProfessorOaksLab_EventScript_RivalApproachForBattleCharmanderMid:
	ApplyMovement 5, PalletTown_ProfessorOaksLab_Movement_ApproachForBattleCharmanderMid
	WaitMovement
	GoTo PalletTown_ProfessorOaksLab_EventScript_RivalBattleCharmander
	End
	
PalletTown_ProfessorOaksLab_EventScript_RivalApproachForBattleCharmanderRight:
	ApplyMovement 5, PalletTown_ProfessorOaksLab_Movement_ApproachForBattleCharmanderRight
	WaitMovement
	GoTo PalletTown_ProfessorOaksLab_EventScript_RivalBattleCharmander
	End
	
PalletTown_ProfessorOaksLab_EventScript_RivalApproachForBattleBulbasaurLeft:
	ApplyMovement 5, PalletTown_ProfessorOaksLab_Movement_RivalApproachForBattleBulbasaurLeft
	WaitMovement
	GoTo PalletTown_ProfessorOaksLab_EventScript_RivalBattleBulbasaur
	End
	
PalletTown_ProfessorOaksLab_EventScript_RivalApproachForBattleBulbasaurMid:
	ApplyMovement 5, PalletTown_ProfessorOaksLab_Movement_RivalApproachForBattleBulbasaurMid
	WaitMovement
	GoTo PalletTown_ProfessorOaksLab_EventScript_RivalBattleBulbasaur
	End
	
PalletTown_ProfessorOaksLab_EventScript_RivalApproachForBattleBulbasaurRight:
	ApplyMovement 5, PalletTown_ProfessorOaksLab_Movement_RivalApproachForBattleBulbasaurRight
	WaitMovement
	GoTo PalletTown_ProfessorOaksLab_EventScript_RivalBattleBulbasaur
	End
	
PalletTown_ProfessorOaksLab_EventScript_RivalApproachForBattleSquirtleLeft:
	ApplyMovement 5, PalletTown_ProfessorOaksLab_Movement_RivalApproachForBattleSquirtleLeft
	WaitMovement
	GoTo PalletTown_ProfessorOaksLab_EventScript_RivalBattleSquirtle
	End
	
PalletTown_ProfessorOaksLab_EventScript_RivalApproachForBattleSquirtleMid:
	ApplyMovement 5, PalletTown_ProfessorOaksLab_Movement_RivalApproachForBattleSquirtleMid
	WaitMovement
	GoTo PalletTown_ProfessorOaksLab_EventScript_RivalBattleSquirtle
	End
	
PalletTown_ProfessorOaksLab_EventScript_RivalApproachForBattleSquirtleRight:
	ApplyMovement 5, PalletTown_ProfessorOaksLab_Movement_RivalApproachForBattleSquirtleRight
	WaitMovement
	GoTo PalletTown_ProfessorOaksLab_EventScript_RivalBattleSquirtle
	End
	
EventMons_EventScript_GiftFull:
	NPCMsg msg_0451_T01R0301_EventMons_Text_NoRoom
	WaitButton
	SetVar VAR_SPECIAL_RESULT, 0
	Return
	
GymSwitch_EventScript_AskNewType:
	NPCMsg msg_0451_T01R0301_GymSwitch_Text_WhichType
	GoTo GymSwitch_EventScript_TypeMenu
	
GymSwitch_EventScript_TypeMenu:
	// TODO(gba) special GymSwitch_PushTypes
	GoTo _cv_stop
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_178
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_178:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq GymSwitch_EventScript_ChoiceCancelled
	// TODO(gba) special GymSwitch_BufferChoice
	GoTo _cv_stop
	CopyVar 0x8009, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymSwitch_EventScript_ConfirmNew
	NPCMsg msg_0451_T01R0301_GymSwitch_Text_ConfirmOld
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_179
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_180
_cv_yes_179:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_180:
	GoTo GymSwitch_EventScript_Confirmed
	CloseMsg
	End
	
PokedexRating_EventScript_SetTextColor:
	Return
	
PokedexRating_EventScript_ShowRatingMsg:
	CopyVar 0x8004, 0x8009
	// TODO(gba) special GetProfOaksRatingMessage
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	CallIfEq PokedexRating_EventScript_NormalFanfare
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq PokedexRating_EventScript_DexCompleteFanfare
	WaitFanfare
	WaitButton
	Return
	
PokedexRating_EventScript_EndRating:
	Return
	
PokedexRating_EventScript_DexIncomplete:
	NPCMsg msg_0451_T01R0301_PokedexRating_Text_LookForwardToFilledNationalDex
	WaitButton
	GoTo PokedexRating_EventScript_EndRating
	CloseMsg
	End
	
PokedexRating_EventScript_DexComplete:
	SetFlag 0x201B
	NPCMsg msg_0451_T01R0301_PokedexRating_Text_YouveCompletedDex
	WaitButton
	GoTo PokedexRating_EventScript_EndRating
	CloseMsg
	End
	
PalletTown_ProfessorOaksLab_EventScript_GivePlayerMoreBalls:
	BufferPlayersName 6
	BufferRivalsName 7
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_OakAddedNothingToPokedex
	WaitButton
	GiveItem ITEM_POKE_BALL, 5, VAR_SPECIAL_RESULT
	BufferItemName 1, ITEM_POKE_BALL
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_ReceivedFivePokeBalls
	PlayFanfare SEQ_ME_LVUP
	WaitFanfare
	WaitButton
	SetFlag 0x2018
	CloseMsg
	ReleaseAll
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
	GoTo GymCandidate_EventScript_MentorNoRoom
	
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
	
Common_EventScript_NameReceivedPartyMon:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	NicknameInput 0x8004, VAR_SPECIAL_RESULT
	Return
	
PalletTown_ProfessorOaksLab_EventScript_RivalWalksToCharmander:
	ApplyMovement 5, PalletTown_ProfessorOaksLab_Movement_RivalWalksToCharmander
	WaitMovement
	GoTo PalletTown_ProfessorOaksLab_EventScript_RivalTakesStarter
	End
	
PalletTown_ProfessorOaksLab_EventScript_RivalWalksToBulbasaur:
	ApplyMovement 5, PalletTown_ProfessorOaksLab_Movement_RivalWalksToBulbasaur
	WaitMovement
	GoTo PalletTown_ProfessorOaksLab_EventScript_RivalTakesStarter
	End
	
PalletTown_ProfessorOaksLab_EventScript_RivalWalksToSquirtle:
	ApplyMovement 5, PalletTown_ProfessorOaksLab_Movement_RivalWalksToSquirtle
	WaitMovement
	GoTo PalletTown_ProfessorOaksLab_EventScript_RivalTakesStarter
	End
	
PalletTown_ProfessorOaksLab_EventScript_RivalBattleCharmander:
	CanvasCloseMsg
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_182
	TrainerBattle 742, 0, 1, 0
	GoTo _cv_battle_181
_cv_next_182:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_183
	TrainerBattle 746, 0, 1, 0
	GoTo _cv_battle_181
_cv_next_183:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_184
	TrainerBattle 740, 0, 1, 0
	GoTo _cv_battle_181
_cv_next_184:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_185
	TrainerBattle 738, 0, 1, 0
	GoTo _cv_battle_181
_cv_next_185:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_186
	TrainerBattle 748, 0, 1, 0
	GoTo _cv_battle_181
_cv_next_186:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_187
	TrainerBattle 743, 0, 1, 0
	GoTo _cv_battle_181
_cv_next_187:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_188
	TrainerBattle 745, 0, 1, 0
	GoTo _cv_battle_181
_cv_next_188:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_189
	TrainerBattle 747, 0, 1, 0
	GoTo _cv_battle_181
_cv_next_189:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_190
	TrainerBattle 741, 0, 1, 0
	GoTo _cv_battle_181
_cv_next_190:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_191
	TrainerBattle 749, 0, 1, 0
	GoTo _cv_battle_181
_cv_next_191:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_192
	TrainerBattle 744, 0, 1, 0
	GoTo _cv_battle_181
_cv_next_192:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_193
	TrainerBattle 739, 0, 1, 0
	GoTo _cv_battle_181
_cv_next_193:
	TrainerBattle 738, 0, 1, 0
_cv_battle_181:
	SetFlag 0x202F
	GoTo PalletTown_ProfessorOaksLab_EventScript_EndRivalBattle
	End
	
PalletTown_ProfessorOaksLab_EventScript_RivalBattleBulbasaur:
	CanvasCloseMsg
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_195
	TrainerBattle 742, 0, 1, 0
	GoTo _cv_battle_194
_cv_next_195:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_196
	TrainerBattle 746, 0, 1, 0
	GoTo _cv_battle_194
_cv_next_196:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_197
	TrainerBattle 740, 0, 1, 0
	GoTo _cv_battle_194
_cv_next_197:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_198
	TrainerBattle 738, 0, 1, 0
	GoTo _cv_battle_194
_cv_next_198:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_199
	TrainerBattle 748, 0, 1, 0
	GoTo _cv_battle_194
_cv_next_199:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_200
	TrainerBattle 743, 0, 1, 0
	GoTo _cv_battle_194
_cv_next_200:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_201
	TrainerBattle 745, 0, 1, 0
	GoTo _cv_battle_194
_cv_next_201:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_202
	TrainerBattle 747, 0, 1, 0
	GoTo _cv_battle_194
_cv_next_202:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_203
	TrainerBattle 741, 0, 1, 0
	GoTo _cv_battle_194
_cv_next_203:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_204
	TrainerBattle 749, 0, 1, 0
	GoTo _cv_battle_194
_cv_next_204:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_205
	TrainerBattle 744, 0, 1, 0
	GoTo _cv_battle_194
_cv_next_205:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_206
	TrainerBattle 739, 0, 1, 0
	GoTo _cv_battle_194
_cv_next_206:
	TrainerBattle 738, 0, 1, 0
_cv_battle_194:
	SetFlag 0x2030
	GoTo PalletTown_ProfessorOaksLab_EventScript_EndRivalBattle
	End
	
PalletTown_ProfessorOaksLab_EventScript_RivalBattleSquirtle:
	CanvasCloseMsg
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_208
	TrainerBattle 742, 0, 1, 0
	GoTo _cv_battle_207
_cv_next_208:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_209
	TrainerBattle 746, 0, 1, 0
	GoTo _cv_battle_207
_cv_next_209:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_210
	TrainerBattle 740, 0, 1, 0
	GoTo _cv_battle_207
_cv_next_210:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_211
	TrainerBattle 738, 0, 1, 0
	GoTo _cv_battle_207
_cv_next_211:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_212
	TrainerBattle 748, 0, 1, 0
	GoTo _cv_battle_207
_cv_next_212:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_213
	TrainerBattle 743, 0, 1, 0
	GoTo _cv_battle_207
_cv_next_213:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_214
	TrainerBattle 745, 0, 1, 0
	GoTo _cv_battle_207
_cv_next_214:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_215
	TrainerBattle 747, 0, 1, 0
	GoTo _cv_battle_207
_cv_next_215:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_216
	TrainerBattle 741, 0, 1, 0
	GoTo _cv_battle_207
_cv_next_216:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_217
	TrainerBattle 749, 0, 1, 0
	GoTo _cv_battle_207
_cv_next_217:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_218
	TrainerBattle 744, 0, 1, 0
	GoTo _cv_battle_207
_cv_next_218:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_219
	TrainerBattle 739, 0, 1, 0
	GoTo _cv_battle_207
_cv_next_219:
	TrainerBattle 738, 0, 1, 0
_cv_battle_207:
	SetFlag 0x2031
	GoTo PalletTown_ProfessorOaksLab_EventScript_EndRivalBattle
	End
	
GymSwitch_EventScript_ChoiceCancelled:
	SetVar VAR_SPECIAL_RESULT, 0
	Return
	
GymSwitch_EventScript_ConfirmNew:
	NPCMsg msg_0451_T01R0301_GymSwitch_Text_ConfirmNew
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_220
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_221
_cv_yes_220:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_221:
	GoTo GymSwitch_EventScript_Confirmed
	
GymSwitch_EventScript_Confirmed:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymSwitch_EventScript_ChooseType
	// TODO(gba) special GymSwitch_SetType
	GoTo _cv_stop
	// TODO(gba) special GymBadge_ShowIcon
	GoTo _cv_stop
	PlayFanfare SEQ_ME_BADGE
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_GymSwitch_Text_NowType
	WaitButton
	WaitFanfare
	// TODO(gba) special GymBadge_HideIcon
	GoTo _cv_stop
	Call Outfits_EventScript_AllGymUniforms
	CompareVarToValue 0x8007, 1
	CallIfEq GymSwitch_EventScript_OldLegendLeaves
	CompareVarToValue 0x8009, 1
	GoToIfEq GymSwitch_EventScript_NewTypeTips
	NPCMsg msg_0451_T01R0301_GymSwitch_Text_BackToType
	WaitButton
	SetVar VAR_SPECIAL_RESULT, 1
	Return
	
PokedexRating_EventScript_NormalFanfare:
	PlayFanfare SEQ_ME_ITEM
	Return
	
PokedexRating_EventScript_DexCompleteFanfare:
	PlayFanfare SEQ_ME_ITEM
	Return
	
GymCandidate_EventScript_MentorNoRoom:
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	Return
	
PalletTown_ProfessorOaksLab_EventScript_RivalTakesStarter:
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_223
	BufferSpeciesName 0, SPECIES_POOCHYENA, 0, 0
	GoTo _cv_done_222
_cv_next_223:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_224
	BufferSpeciesName 0, SPECIES_PIKACHU, 0, 0
	GoTo _cv_done_222
_cv_next_224:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_225
	BufferSpeciesName 0, SPECIES_TYROGUE, 0, 0
	GoTo _cv_done_222
_cv_next_225:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_226
	BufferSpeciesName 0, SPECIES_CHARMANDER, 0, 0
	GoTo _cv_done_222
_cv_next_226:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_227
	BufferSpeciesName 0, SPECIES_BULBASAUR, 0, 0
	GoTo _cv_done_222
_cv_next_227:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_228
	BufferSpeciesName 0, SPECIES_SANDSHREW, 0, 0
	GoTo _cv_done_222
_cv_next_228:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_229
	BufferSpeciesName 0, SPECIES_SPHEAL, 0, 0
	GoTo _cv_done_222
_cv_next_229:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_230
	BufferSpeciesName 0, SPECIES_EKANS, 0, 0
	GoTo _cv_done_222
_cv_next_230:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_231
	BufferSpeciesName 0, SPECIES_RALTS, 0, 0
	GoTo _cv_done_222
_cv_next_231:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_232
	BufferSpeciesName 0, SPECIES_LARVITAR, 0, 0
	GoTo _cv_done_222
_cv_next_232:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_233
	BufferSpeciesName 0, SPECIES_BELDUM, 0, 0
	GoTo _cv_done_222
_cv_next_233:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_234
	BufferSpeciesName 0, SPECIES_SQUIRTLE, 0, 0
	GoTo _cv_done_222
_cv_next_234:
_cv_done_222:
	BufferTypeName 1, 0x5019
	BufferTypeName 2, 0x501A
	BufferRivalsName 7
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_RivalPicksType
	WaitButton
	BufferSpeciesName 0, 0x4003, 0, 0
	BufferRivalsName 7
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_RivalReceivedMonFromOak
	PlayFanfare SEQ_ME_ITEM
	WaitFanfare
	SetVar 0x5006, 3
	CallIfSet 0x200A, PalletTown_ProfessorOaksLab_EventScript_ReadyEndSignLadyScene
	CloseMsg
	ReleaseAll
	End
	
PalletTown_ProfessorOaksLab_EventScript_EndRivalBattle:
	HealParty
	BufferPlayersName 6
	BufferRivalsName 7
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_RivalGoToughenMyMon
	WaitButton
	CloseMsg
	ApplyMovement 4, Common_Movement_FaceDown
	WaitMovement
	BufferRivalsName 7
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_OakFollowMeToGym
	WaitButton
	CloseMsg
	HidePerson 5
	SetFlag 0x2024
	SetVar 0x5006, 4
	SetFlag 0x200B
	SetVar 0x5005, 1
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	Warp MAP_FIGHT_AREA_UNUSED_7, 0, 12, 25, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	ReleaseAll
	End
	
Outfits_EventScript_AllGymUniforms:
	// TODO(gba) special Outfit_UnlockAllGymUniforms
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Outfits_EventScript_Return
	PlayFanfare SEQ_ME_ITEM
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_Outfits_Text_ReceivedAllGymUniforms
	WaitFanfare
	NPCMsg msg_0451_T01R0301_Outfits_Text_AllInWardrobe
	WaitButton
	Return
	
GymSwitch_EventScript_OldLegendLeaves:
	NPCMsg msg_0451_T01R0301_GymSwitch_Text_OldLegendLeaves
	WaitButton
	Return
	
GymSwitch_EventScript_NewTypeTips:
	NPCMsg msg_0451_T01R0301_GymSwitch_Text_NewTypeTips
	WaitButton
	SetVar VAR_SPECIAL_RESULT, 1
	Return
	
PalletTown_ProfessorOaksLab_EventScript_ReadyEndSignLadyScene:
	SetVar 0x5000, 1
	Return
	
Outfits_EventScript_Return:
	Return

_cv_str4:
	BufferPlayersName 6
	BufferRivalsName 7
	Return

_cv_stop:
	NPCMsg msg_0451_T01R0301_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
Common_Movement_FaceDown:
	FaceSouth
	EndMovement

	.balign 4, 0
PalletTown_ProfessorOaksLab_Movement_PlayerWalkUp:
	WalkNormalNorth
	EndMovement

	.balign 4, 0
PalletTown_ProfessorOaksLab_Movement_OakEnter:
	WalkNormalNorth 6
	EndMovement

	.balign 4, 0
PalletTown_ProfessorOaksLab_Movement_PlayerEnter:
	WalkNormalNorth 8
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterUp:
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
PalletTown_ProfessorOaksLab_Movement_RivalReact:
	WalkOnSpotNormalNorth 2
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
Common_Movement_FaceRight:
	FaceEast
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterDown:
	WalkOnSpotFasterSouth
	EndMovement

	.balign 4, 0
PalletTown_ProfessorOaksLab_Movement_WatchRivalEnterNorth:
	WalkOnSpotFasterSouth
	Delay16 5
	Delay8
	WalkOnSpotFasterWest
	EndMovement

	.balign 4, 0
PalletTown_ProfessorOaksLab_Movement_RivalEnter:
	WalkNormalNorth 6
	EndMovement

	.balign 4, 0
PalletTown_ProfessorOaksLab_Movement_WatchRivalEnterEastWest:
	Delay4
	WalkOnSpotFasterSouth
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterRight:
	WalkOnSpotFasterEast
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterLeft:
	WalkOnSpotFasterWest
	EndMovement

	.balign 4, 0
PalletTown_ProfessorOaksLab_Movement_OakWalkToDesk:
	WalkNormalNorth
	WalkNormalWest
	Delay16
	WalkOnSpotFasterSouth
	EndMovement

	.balign 4, 0
PalletTown_ProfessorOaksLab_Movement_OakWalkToDeskSouth:
	WalkNormalWest 2
	WalkNormalNorth
	Delay16
	WalkOnSpotFasterEast
	EndMovement

	.balign 4, 0
PalletTown_ProfessorOaksLab_Movement_WatchOakWalkToDesk:
	Delay16
	Delay8
	WalkOnSpotFasterWest
	EndMovement

	.balign 4, 0
PalletTown_ProfessorOaksLab_Movement_WatchOakWalkToDeskEast:
	Delay16
	Delay8
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
PalletTown_ProfessorOaksLab_Movement_OakBringDexesOver:
	WalkNormalEast
	WalkNormalSouth
	EndMovement

	.balign 4, 0
PalletTown_ProfessorOaksLab_Movement_OakBringDexesOverSouth:
	WalkNormalSouth
	WalkNormalEast
	EndMovement

	.balign 4, 0
PalletTown_ProfessorOaksLab_Movement_PlayerFaceOakForDexEast:
	Delay16
	Delay8
	WalkOnSpotFasterEast
	EndMovement

	.balign 4, 0
PalletTown_ProfessorOaksLab_Movement_RivalExit:
	WalkNormalSouth 6
	EndMovement

	.balign 4, 0
PalletTown_ProfessorOaksLab_Movement_OakBringDexesToDesk:
	WalkNormalNorth
	WalkNormalWest
	WalkOnSpotFasterNorth
	Delay16
	Delay4
	EndMovement

	.balign 4, 0
PalletTown_ProfessorOaksLab_Movement_OakBringDexesToDeskSouth:
	WalkNormalWest 2
	WalkNormalNorth
	Delay16
	Delay4
	EndMovement

	.balign 4, 0
PalletTown_ProfessorOaksLab_Movement_OakExcitedNorth:
	WalkOnSpotNormalSouth
	WalkOnSpotFastSouth
	WalkOnSpotNormalSouth 2
	WalkOnSpotFastSouth
	WalkOnSpotNormalSouth
	EndMovement

	.balign 4, 0
PalletTown_ProfessorOaksLab_Movement_OakExcitedSouth:
	WalkOnSpotNormalNorth
	WalkOnSpotFastNorth
	WalkOnSpotNormalNorth 2
	WalkOnSpotFastNorth
	WalkOnSpotNormalNorth
	EndMovement

	.balign 4, 0
PalletTown_ProfessorOaksLab_Movement_OakExcitedEast:
	WalkOnSpotNormalWest
	WalkOnSpotFastWest
	WalkOnSpotNormalWest 2
	WalkOnSpotFastWest
	WalkOnSpotNormalWest
	EndMovement

	.balign 4, 0
PalletTown_ProfessorOaksLab_Movement_OakExcitedWest:
	WalkOnSpotNormalEast
	WalkOnSpotFastEast
	WalkOnSpotNormalEast 2
	WalkOnSpotFastEast
	WalkOnSpotNormalEast
	EndMovement

	.balign 4, 0
gMentorWalkIn:
	EndMovement

	.balign 4, 0
gMentorWalkOut:
	EndMovement

	.balign 4, 0
PalletTown_ProfessorOaksLab_Movement_ApproachForBattleCharmanderLeft:
	WalkNormalWest 5
	WalkNormalSouth 2
	EndMovement

	.balign 4, 0
PalletTown_ProfessorOaksLab_Movement_ApproachForBattleCharmanderMid:
	WalkNormalWest 4
	WalkNormalSouth 2
	EndMovement

	.balign 4, 0
PalletTown_ProfessorOaksLab_Movement_ApproachForBattleCharmanderRight:
	WalkNormalWest 3
	WalkNormalSouth 2
	EndMovement

	.balign 4, 0
PalletTown_ProfessorOaksLab_Movement_RivalApproachForBattleBulbasaurLeft:
	WalkNormalWest 3
	WalkNormalSouth 2
	EndMovement

	.balign 4, 0
PalletTown_ProfessorOaksLab_Movement_RivalApproachForBattleBulbasaurMid:
	WalkNormalWest 2
	WalkNormalSouth 2
	EndMovement

	.balign 4, 0
PalletTown_ProfessorOaksLab_Movement_RivalApproachForBattleBulbasaurRight:
	WalkNormalWest
	WalkNormalSouth 2
	EndMovement

	.balign 4, 0
PalletTown_ProfessorOaksLab_Movement_RivalApproachForBattleSquirtleLeft:
	WalkNormalWest 4
	WalkNormalSouth 2
	EndMovement

	.balign 4, 0
PalletTown_ProfessorOaksLab_Movement_RivalApproachForBattleSquirtleMid:
	WalkNormalWest 3
	WalkNormalSouth 2
	EndMovement

	.balign 4, 0
PalletTown_ProfessorOaksLab_Movement_RivalApproachForBattleSquirtleRight:
	WalkNormalWest 2
	WalkNormalSouth 2
	EndMovement

	.balign 4, 0
PalletTown_ProfessorOaksLab_Movement_RivalWalksToCharmander:
	WalkNormalSouth 2
	WalkNormalEast 5
	WalkNormalNorth
	EndMovement

	.balign 4, 0
PalletTown_ProfessorOaksLab_Movement_RivalWalksToBulbasaur:
	WalkNormalSouth
	WalkNormalEast 3
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
PalletTown_ProfessorOaksLab_Movement_RivalWalksToSquirtle:
	WalkNormalSouth
	WalkNormalEast 4
	WalkOnSpotFasterNorth
	EndMovement
	.balign 4, 0
