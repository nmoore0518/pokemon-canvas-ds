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
	CanvasCloseMsg
	ApplyMovement obj_player, PalletTown_ProfessorOaksLab_Movement_PlayerWalkUp
	WaitMovement
	CanvasCloseMsg
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
	CanvasCloseMsg
	Wait 60, VAR_SPECIAL_RESULT
	BufferPlayersName 6
	BufferRivalsName 7
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_OakThreeMonsChooseOne
	WaitButton
	CanvasCloseMsg
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
	CanvasCloseMsg
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
	CanvasCloseMsg
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
	CanvasCloseMsg
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
	CanvasCloseMsg
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
	CanvasCloseMsg
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
	CanvasCloseMsg
	Wait 40, VAR_SPECIAL_RESULT
	BufferPlayersName 6
	BufferRivalsName 7
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_OakTakeTheseWithYou
	WaitButton
	CanvasCloseMsg
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
	CanvasCloseMsg
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
	CanvasCloseMsg
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
	CanvasCloseMsg
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
	CanvasCloseMsg
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
	CanvasCloseMsg
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
	CanvasCloseMsg
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
	CanvasCloseMsg
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
	CanvasCloseMsg
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
	CanvasCloseMsg
	ReleaseAll
	End
	
PokedexRating_EventScript_RateInPerson:
	CallIfSet 0x201B, PokedexRating_EventScript_DexCompleteIntro
	CallIfUnset 0x201B, PokedexRating_EventScript_NormalIntro
	Call PokedexRating_EventScript_Rate
	Return
	
PalletTown_ProfessorOaksLab_EventScript_DexCompleted:
	CanvasCloseMsg
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
	CanvasCloseMsg
	Wait 70, VAR_SPECIAL_RESULT
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_PokedexRating_Text_ThankYouMadeDreamReality
	WaitButton
	SetFlag 2
	CloseMsg
	ReleaseAll
	End
	
PalletTown_ProfessorOaksLab_EventScript_DontStartNationalDexScene:
	CanvasCloseMsg
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
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfSet 0x22E7, _cv_mentor_127
	SetFlag 0x22E7
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_129
	SetVar 0x4020, SPRITE_GSLEADER14
	GoTo _cv_done_128
_cv_next_129:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_130
	SetVar 0x4020, SPRITE_GSLEADER14
	GoTo _cv_done_128
_cv_next_130:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_131
	SetVar 0x4020, SPRITE_GSLEADER11
	GoTo _cv_done_128
_cv_next_131:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_132
	SetVar 0x4020, SPRITE_GSLEADER9
	GoTo _cv_done_128
_cv_next_132:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_133
	SetVar 0x4020, SPRITE_GSLEADER9
	GoTo _cv_done_128
_cv_next_133:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_134
	SetVar 0x4020, SPRITE_GSLEADER12
	GoTo _cv_done_128
_cv_next_134:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_135
	SetVar 0x4020, SPRITE_GSBIGFOUR2
	GoTo _cv_done_128
_cv_next_135:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_136
	SetVar 0x4020, SPRITE_GSBIGFOUR2
	GoTo _cv_done_128
_cv_next_136:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_137
	SetVar 0x4020, SPRITE_GSLEADER10
	GoTo _cv_done_128
_cv_next_137:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_138
	SetVar 0x4020, SPRITE_GSLEADER10
	GoTo _cv_done_128
_cv_next_138:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_139
	SetVar 0x4020, SPRITE_GSLEADER15
	GoTo _cv_done_128
_cv_next_139:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_140
	SetVar 0x4020, SPRITE_GSBIGFOUR3
	GoTo _cv_done_128
_cv_next_140:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_141
	SetVar 0x4020, SPRITE_GSOLDWOMAN1
	GoTo _cv_done_128
_cv_next_141:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_142
	SetVar 0x4020, SPRITE_GSBIGFOUR4
	GoTo _cv_done_128
_cv_next_142:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_143
	SetVar 0x4020, SPRITE_GSBIGFOUR3
	GoTo _cv_done_128
_cv_next_143:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_144
	SetVar 0x4020, SPRITE_GSOLDWOMAN1
	GoTo _cv_done_128
_cv_next_144:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_145
	SetVar 0x4020, SPRITE_WATARU
	GoTo _cv_done_128
_cv_next_145:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_146
	SetVar 0x4020, SPRITE_WATARU
	GoTo _cv_done_128
_cv_next_146:
_cv_done_128:
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_148
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_147
_cv_next_148:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_149
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_147
_cv_next_149:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_150
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Misty
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_147
_cv_next_150:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_151
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_147
_cv_next_151:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_152
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_147
_cv_next_152:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_153
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Erika
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_147
_cv_next_153:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_154
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_147
_cv_next_154:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_155
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_147
_cv_next_155:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_156
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_147
_cv_next_156:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_157
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_147
_cv_next_157:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_158
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Blaine
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_147
_cv_next_158:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_159
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_147
_cv_next_159:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_160
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_147
_cv_next_160:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_161
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Lorelei
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_147
_cv_next_161:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_162
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_147
_cv_next_162:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_163
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_147
_cv_next_163:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_164
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_147
_cv_next_164:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_165
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_147
_cv_next_165:
_cv_done_147:
_cv_mentor_127:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_Return
	Wait 30, VAR_SPECIAL_RESULT
	PlaySE SEQ_SE_DP_DOOR
	NPCMsg msg_0451_T01R0301_GymCandidate_Text_MentorAtDoor
	WaitButton
	CanvasCloseMsg
	Call GymCandidate_EventScript_VisitorWalksIn
	PlaySE SEQ_SE_DP_SELECT
	ApplyMovement 4, Common_Movement_ExclamationMark
	WaitMovement
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_167
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_166
_cv_next_167:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_168
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_166
_cv_next_168:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_169
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Misty
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_166
_cv_next_169:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_170
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_166
_cv_next_170:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_171
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_166
_cv_next_171:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_172
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Erika
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_166
_cv_next_172:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_173
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_166
_cv_next_173:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_174
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_166
_cv_next_174:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_175
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_166
_cv_next_175:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_176
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_166
_cv_next_176:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_177
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Blaine
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_166
_cv_next_177:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_178
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_166
_cv_next_178:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_179
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_166
_cv_next_179:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_180
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Lorelei
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_166
_cv_next_180:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_181
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_166
_cv_next_181:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_182
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_166
_cv_next_182:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_183
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_166
_cv_next_183:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_184
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_166
_cv_next_184:
_cv_done_166:
	BufferPlayersName 6
	NPCMsg msg_0451_T01R0301_GymCandidate_Text_OakWelcomesMentor
	WaitButton
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_186
	SetVar 0x401F, 1
	GoTo _cv_done_185
_cv_next_186:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_187
	SetVar 0x401F, 2
	GoTo _cv_done_185
_cv_next_187:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_188
	SetVar 0x401F, 3
	GoTo _cv_done_185
_cv_next_188:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_189
	SetVar 0x401F, 4
	GoTo _cv_done_185
_cv_next_189:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_190
	SetVar 0x401F, 5
	GoTo _cv_done_185
_cv_next_190:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_191
	SetVar 0x401F, 6
	GoTo _cv_done_185
_cv_next_191:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_192
	SetVar 0x401F, 7
	GoTo _cv_done_185
_cv_next_192:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_193
	SetVar 0x401F, 8
	GoTo _cv_done_185
_cv_next_193:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_194
	SetVar 0x401F, 9
	GoTo _cv_done_185
_cv_next_194:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_195
	SetVar 0x401F, 10
	GoTo _cv_done_185
_cv_next_195:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_196
	SetVar 0x401F, 11
	GoTo _cv_done_185
_cv_next_196:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_197
	SetVar 0x401F, 12
	GoTo _cv_done_185
_cv_next_197:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_198
	SetVar 0x401F, 13
	GoTo _cv_done_185
_cv_next_198:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_199
	SetVar 0x401F, 14
	GoTo _cv_done_185
_cv_next_199:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_200
	SetVar 0x401F, 15
	GoTo _cv_done_185
_cv_next_200:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_201
	SetVar 0x401F, 16
	GoTo _cv_done_185
_cv_next_201:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_202
	SetVar 0x401F, 17
	GoTo _cv_done_185
_cv_next_202:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_203
	SetVar 0x401F, 18
	GoTo _cv_done_185
_cv_next_203:
_cv_done_185:
	Call _cv_str4
	WaitButton
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_205
	SetVar 0x401F, 19
	GoTo _cv_done_204
_cv_next_205:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_206
	SetVar 0x401F, 19
	GoTo _cv_done_204
_cv_next_206:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_207
	SetVar 0x401F, 20
	GoTo _cv_done_204
_cv_next_207:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_208
	SetVar 0x401F, 21
	GoTo _cv_done_204
_cv_next_208:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_209
	SetVar 0x401F, 21
	GoTo _cv_done_204
_cv_next_209:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_210
	SetVar 0x401F, 22
	GoTo _cv_done_204
_cv_next_210:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_211
	SetVar 0x401F, 23
	GoTo _cv_done_204
_cv_next_211:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_212
	SetVar 0x401F, 23
	GoTo _cv_done_204
_cv_next_212:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_213
	SetVar 0x401F, 24
	GoTo _cv_done_204
_cv_next_213:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_214
	SetVar 0x401F, 24
	GoTo _cv_done_204
_cv_next_214:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_215
	SetVar 0x401F, 25
	GoTo _cv_done_204
_cv_next_215:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_216
	SetVar 0x401F, 26
	GoTo _cv_done_204
_cv_next_216:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_217
	SetVar 0x401F, 27
	GoTo _cv_done_204
_cv_next_217:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_218
	SetVar 0x401F, 28
	GoTo _cv_done_204
_cv_next_218:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_219
	SetVar 0x401F, 26
	GoTo _cv_done_204
_cv_next_219:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_220
	SetVar 0x401F, 27
	GoTo _cv_done_204
_cv_next_220:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_221
	SetVar 0x401F, 29
	GoTo _cv_done_204
_cv_next_221:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_222
	SetVar 0x401F, 29
	GoTo _cv_done_204
_cv_next_222:
_cv_done_204:
	Call _cv_str4
	WaitButton
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_224
	SetVar 0x401F, 30
	GoTo _cv_done_223
_cv_next_224:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_225
	SetVar 0x401F, 30
	GoTo _cv_done_223
_cv_next_225:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_226
	SetVar 0x401F, 31
	GoTo _cv_done_223
_cv_next_226:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_227
	SetVar 0x401F, 32
	GoTo _cv_done_223
_cv_next_227:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_228
	SetVar 0x401F, 32
	GoTo _cv_done_223
_cv_next_228:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_229
	SetVar 0x401F, 33
	GoTo _cv_done_223
_cv_next_229:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_230
	SetVar 0x401F, 34
	GoTo _cv_done_223
_cv_next_230:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_231
	SetVar 0x401F, 34
	GoTo _cv_done_223
_cv_next_231:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_232
	SetVar 0x401F, 35
	GoTo _cv_done_223
_cv_next_232:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_233
	SetVar 0x401F, 35
	GoTo _cv_done_223
_cv_next_233:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_234
	SetVar 0x401F, 36
	GoTo _cv_done_223
_cv_next_234:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_235
	SetVar 0x401F, 37
	GoTo _cv_done_223
_cv_next_235:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_236
	SetVar 0x401F, 38
	GoTo _cv_done_223
_cv_next_236:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_237
	SetVar 0x401F, 39
	GoTo _cv_done_223
_cv_next_237:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_238
	SetVar 0x401F, 37
	GoTo _cv_done_223
_cv_next_238:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_239
	SetVar 0x401F, 38
	GoTo _cv_done_223
_cv_next_239:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_240
	SetVar 0x401F, 40
	GoTo _cv_done_223
_cv_next_240:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_241
	SetVar 0x401F, 40
	GoTo _cv_done_223
_cv_next_241:
_cv_done_223:
	Call _cv_str4
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_242
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_243
_cv_yes_242:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_243:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq _cv_answer_244
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_247
	SetVar 0x401F, 41
	GoTo _cv_done_246
_cv_next_247:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_248
	SetVar 0x401F, 41
	GoTo _cv_done_246
_cv_next_248:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_249
	SetVar 0x401F, 42
	GoTo _cv_done_246
_cv_next_249:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_250
	SetVar 0x401F, 43
	GoTo _cv_done_246
_cv_next_250:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_251
	SetVar 0x401F, 43
	GoTo _cv_done_246
_cv_next_251:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_252
	SetVar 0x401F, 44
	GoTo _cv_done_246
_cv_next_252:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_253
	SetVar 0x401F, 45
	GoTo _cv_done_246
_cv_next_253:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_254
	SetVar 0x401F, 45
	GoTo _cv_done_246
_cv_next_254:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_255
	SetVar 0x401F, 46
	GoTo _cv_done_246
_cv_next_255:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_256
	SetVar 0x401F, 46
	GoTo _cv_done_246
_cv_next_256:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_257
	SetVar 0x401F, 47
	GoTo _cv_done_246
_cv_next_257:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_258
	SetVar 0x401F, 48
	GoTo _cv_done_246
_cv_next_258:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_259
	SetVar 0x401F, 49
	GoTo _cv_done_246
_cv_next_259:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_260
	SetVar 0x401F, 50
	GoTo _cv_done_246
_cv_next_260:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_261
	SetVar 0x401F, 48
	GoTo _cv_done_246
_cv_next_261:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_262
	SetVar 0x401F, 49
	GoTo _cv_done_246
_cv_next_262:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_263
	SetVar 0x401F, 51
	GoTo _cv_done_246
_cv_next_263:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_264
	SetVar 0x401F, 51
	GoTo _cv_done_246
_cv_next_264:
_cv_done_246:
	GoTo _cv_answer_245
_cv_answer_244:
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_266
	SetVar 0x401F, 52
	GoTo _cv_done_265
_cv_next_266:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_267
	SetVar 0x401F, 52
	GoTo _cv_done_265
_cv_next_267:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_268
	SetVar 0x401F, 53
	GoTo _cv_done_265
_cv_next_268:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_269
	SetVar 0x401F, 54
	GoTo _cv_done_265
_cv_next_269:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_270
	SetVar 0x401F, 54
	GoTo _cv_done_265
_cv_next_270:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_271
	SetVar 0x401F, 55
	GoTo _cv_done_265
_cv_next_271:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_272
	SetVar 0x401F, 56
	GoTo _cv_done_265
_cv_next_272:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_273
	SetVar 0x401F, 56
	GoTo _cv_done_265
_cv_next_273:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_274
	SetVar 0x401F, 57
	GoTo _cv_done_265
_cv_next_274:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_275
	SetVar 0x401F, 57
	GoTo _cv_done_265
_cv_next_275:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_276
	SetVar 0x401F, 58
	GoTo _cv_done_265
_cv_next_276:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_277
	SetVar 0x401F, 59
	GoTo _cv_done_265
_cv_next_277:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_278
	SetVar 0x401F, 60
	GoTo _cv_done_265
_cv_next_278:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_279
	SetVar 0x401F, 61
	GoTo _cv_done_265
_cv_next_279:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_280
	SetVar 0x401F, 59
	GoTo _cv_done_265
_cv_next_280:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_281
	SetVar 0x401F, 60
	GoTo _cv_done_265
_cv_next_281:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_282
	SetVar 0x401F, 62
	GoTo _cv_done_265
_cv_next_282:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_283
	SetVar 0x401F, 62
	GoTo _cv_done_265
_cv_next_283:
_cv_done_265:
_cv_answer_245:
	Call _cv_str4
	WaitButton
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq GymCandidate_EventScript_MentorDecorGift
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_285
	SetVar 0x401F, 63
	GoTo _cv_done_284
_cv_next_285:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_286
	SetVar 0x401F, 63
	GoTo _cv_done_284
_cv_next_286:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_287
	SetVar 0x401F, 64
	GoTo _cv_done_284
_cv_next_287:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_288
	SetVar 0x401F, 65
	GoTo _cv_done_284
_cv_next_288:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_289
	SetVar 0x401F, 65
	GoTo _cv_done_284
_cv_next_289:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_290
	SetVar 0x401F, 66
	GoTo _cv_done_284
_cv_next_290:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_291
	SetVar 0x401F, 67
	GoTo _cv_done_284
_cv_next_291:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_292
	SetVar 0x401F, 67
	GoTo _cv_done_284
_cv_next_292:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_293
	SetVar 0x401F, 68
	GoTo _cv_done_284
_cv_next_293:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_294
	SetVar 0x401F, 68
	GoTo _cv_done_284
_cv_next_294:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_295
	SetVar 0x401F, 69
	GoTo _cv_done_284
_cv_next_295:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_296
	SetVar 0x401F, 70
	GoTo _cv_done_284
_cv_next_296:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_297
	SetVar 0x401F, 71
	GoTo _cv_done_284
_cv_next_297:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_298
	SetVar 0x401F, 72
	GoTo _cv_done_284
_cv_next_298:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_299
	SetVar 0x401F, 70
	GoTo _cv_done_284
_cv_next_299:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_300
	SetVar 0x401F, 71
	GoTo _cv_done_284
_cv_next_300:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_301
	SetVar 0x401F, 73
	GoTo _cv_done_284
_cv_next_301:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_302
	SetVar 0x401F, 73
	GoTo _cv_done_284
_cv_next_302:
_cv_done_284:
	Call _cv_str4
	WaitButton
	Call GymCandidate_EventScript_VisitorWalksOut
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_304
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_303
_cv_next_304:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_305
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_303
_cv_next_305:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_306
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Misty
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_303
_cv_next_306:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_307
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_303
_cv_next_307:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_308
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_303
_cv_next_308:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_309
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Erika
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_303
_cv_next_309:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_310
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_303
_cv_next_310:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_311
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_303
_cv_next_311:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_312
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_303
_cv_next_312:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_313
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_303
_cv_next_313:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_314
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Blaine
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_303
_cv_next_314:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_315
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_303
_cv_next_315:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_316
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_303
_cv_next_316:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_317
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Lorelei
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_303
_cv_next_317:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_318
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_303
_cv_next_318:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_319
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_303
_cv_next_319:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_320
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_303
_cv_next_320:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_321
	CanvasBufferMsg 0, msg_0451_T01R0301_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_303
_cv_next_321:
_cv_done_303:
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
	CanvasCloseMsg
	CanvasCloseMsg
	ReleaseAll
	End
	
PalletTown_ProfessorOaksLab_EventScript_HardType:
	NPCMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_HardType
	WaitButton
	Return
	
PalletTown_ProfessorOaksLab_EventScript_DeclinedStarter:
	CanvasCloseMsg
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
	GoToIfEq _cv_yes_322
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_323
_cv_yes_322:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_323:
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
	GoToIfUnset 0x2024, _cv_show_324
	ClearFlag 0x2024
	ShowPerson 5
	SetFlag 0x2024
	GoTo _cv_shown_325
_cv_show_324:
	ShowPerson 5
_cv_shown_325:
	PlayBGM SEQ_GS_E_RIVAL1
	ApplyMovement obj_player, PalletTown_ProfessorOaksLab_Movement_WatchRivalEnterNorth
	ApplyMovement 5, PalletTown_ProfessorOaksLab_Movement_RivalEnter
	WaitMovement
	Return
	
PalletTown_ProfessorOaksLab_EventScript_NationalDexSceneRivalEnterSouth:
	MovePerson 5, 6, 10
	GoToIfUnset 0x2024, _cv_show_326
	ClearFlag 0x2024
	ShowPerson 5
	SetFlag 0x2024
	GoTo _cv_shown_327
_cv_show_326:
	ShowPerson 5
_cv_shown_327:
	PlayBGM SEQ_GS_E_RIVAL1
	ApplyMovement 4, Common_Movement_WalkInPlaceFasterDown
	ApplyMovement 5, PalletTown_ProfessorOaksLab_Movement_RivalEnter
	WaitMovement
	Return
	
PalletTown_ProfessorOaksLab_EventScript_NationalDexSceneRivalEnterEastWest:
	MovePerson 5, 6, 10
	GoToIfUnset 0x2024, _cv_show_328
	ClearFlag 0x2024
	ShowPerson 5
	SetFlag 0x2024
	GoTo _cv_shown_329
_cv_show_328:
	ShowPerson 5
_cv_shown_329:
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
	CanvasCloseMsg
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
	GoToIfUnset 0x2026, _cv_dex_330
	SetVar VAR_SPECIAL_RESULT, 1
_cv_dex_330:
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
	GoToIfUnset 0x2026, _cv_dex_331
	SetVar VAR_SPECIAL_RESULT, 1
_cv_dex_331:
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
	CanvasCloseMsg
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
	CanvasMsg msg_0451_T01R0301_GymSwitch_Text_WhichType
	GoTo GymSwitch_EventScript_TypeMenu
	
GymSwitch_EventScript_TypeMenu:
	// TODO(gba) special GymSwitch_PushTypes
	GoTo _cv_stop
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_333
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_333:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq GymSwitch_EventScript_ChoiceCancelled
	// TODO(gba) special GymSwitch_BufferChoice
	GoTo _cv_stop
	CopyVar 0x8009, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymSwitch_EventScript_ConfirmNew
	CanvasMsg msg_0451_T01R0301_GymSwitch_Text_ConfirmOld
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_334
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_335
_cv_yes_334:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_335:
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
	CanvasMsg msg_0451_T01R0301_PokedexRating_Text_LookForwardToFilledNationalDex
	WaitButton
	GoTo PokedexRating_EventScript_EndRating
	CloseMsg
	End
	
PokedexRating_EventScript_DexComplete:
	SetFlag 0x201B
	CanvasMsg msg_0451_T01R0301_PokedexRating_Text_YouveCompletedDex
	WaitButton
	GoTo PokedexRating_EventScript_EndRating
	CloseMsg
	End
	
PalletTown_ProfessorOaksLab_EventScript_GivePlayerMoreBalls:
	BufferPlayersName 6
	BufferRivalsName 7
	CanvasMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_OakAddedNothingToPokedex
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
	CanvasCheckTeam 7, 0x5019
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_team_not_allowed
	CanvasCloseMsg
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_337
	TrainerBattle 742, 0, 1, 0
	GoTo _cv_battle_336
_cv_next_337:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_338
	TrainerBattle 746, 0, 1, 0
	GoTo _cv_battle_336
_cv_next_338:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_339
	TrainerBattle 740, 0, 1, 0
	GoTo _cv_battle_336
_cv_next_339:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_340
	TrainerBattle 738, 0, 1, 0
	GoTo _cv_battle_336
_cv_next_340:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_341
	TrainerBattle 748, 0, 1, 0
	GoTo _cv_battle_336
_cv_next_341:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_342
	TrainerBattle 743, 0, 1, 0
	GoTo _cv_battle_336
_cv_next_342:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_343
	TrainerBattle 745, 0, 1, 0
	GoTo _cv_battle_336
_cv_next_343:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_344
	TrainerBattle 747, 0, 1, 0
	GoTo _cv_battle_336
_cv_next_344:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_345
	TrainerBattle 741, 0, 1, 0
	GoTo _cv_battle_336
_cv_next_345:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_346
	TrainerBattle 749, 0, 1, 0
	GoTo _cv_battle_336
_cv_next_346:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_347
	TrainerBattle 744, 0, 1, 0
	GoTo _cv_battle_336
_cv_next_347:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_348
	TrainerBattle 739, 0, 1, 0
	GoTo _cv_battle_336
_cv_next_348:
	TrainerBattle 738, 0, 1, 0
_cv_battle_336:
	SetFlag 0x202F
	GoTo PalletTown_ProfessorOaksLab_EventScript_EndRivalBattle
	End
	
PalletTown_ProfessorOaksLab_EventScript_RivalBattleBulbasaur:
	CanvasCheckTeam 7, 0x5019
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_team_not_allowed
	CanvasCloseMsg
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_350
	TrainerBattle 742, 0, 1, 0
	GoTo _cv_battle_349
_cv_next_350:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_351
	TrainerBattle 746, 0, 1, 0
	GoTo _cv_battle_349
_cv_next_351:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_352
	TrainerBattle 740, 0, 1, 0
	GoTo _cv_battle_349
_cv_next_352:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_353
	TrainerBattle 738, 0, 1, 0
	GoTo _cv_battle_349
_cv_next_353:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_354
	TrainerBattle 748, 0, 1, 0
	GoTo _cv_battle_349
_cv_next_354:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_355
	TrainerBattle 743, 0, 1, 0
	GoTo _cv_battle_349
_cv_next_355:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_356
	TrainerBattle 745, 0, 1, 0
	GoTo _cv_battle_349
_cv_next_356:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_357
	TrainerBattle 747, 0, 1, 0
	GoTo _cv_battle_349
_cv_next_357:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_358
	TrainerBattle 741, 0, 1, 0
	GoTo _cv_battle_349
_cv_next_358:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_359
	TrainerBattle 749, 0, 1, 0
	GoTo _cv_battle_349
_cv_next_359:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_360
	TrainerBattle 744, 0, 1, 0
	GoTo _cv_battle_349
_cv_next_360:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_361
	TrainerBattle 739, 0, 1, 0
	GoTo _cv_battle_349
_cv_next_361:
	TrainerBattle 738, 0, 1, 0
_cv_battle_349:
	SetFlag 0x2030
	GoTo PalletTown_ProfessorOaksLab_EventScript_EndRivalBattle
	End
	
PalletTown_ProfessorOaksLab_EventScript_RivalBattleSquirtle:
	CanvasCheckTeam 7, 0x5019
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_team_not_allowed
	CanvasCloseMsg
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_363
	TrainerBattle 742, 0, 1, 0
	GoTo _cv_battle_362
_cv_next_363:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_364
	TrainerBattle 746, 0, 1, 0
	GoTo _cv_battle_362
_cv_next_364:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_365
	TrainerBattle 740, 0, 1, 0
	GoTo _cv_battle_362
_cv_next_365:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_366
	TrainerBattle 738, 0, 1, 0
	GoTo _cv_battle_362
_cv_next_366:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_367
	TrainerBattle 748, 0, 1, 0
	GoTo _cv_battle_362
_cv_next_367:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_368
	TrainerBattle 743, 0, 1, 0
	GoTo _cv_battle_362
_cv_next_368:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_369
	TrainerBattle 745, 0, 1, 0
	GoTo _cv_battle_362
_cv_next_369:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_370
	TrainerBattle 747, 0, 1, 0
	GoTo _cv_battle_362
_cv_next_370:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_371
	TrainerBattle 741, 0, 1, 0
	GoTo _cv_battle_362
_cv_next_371:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_372
	TrainerBattle 749, 0, 1, 0
	GoTo _cv_battle_362
_cv_next_372:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_373
	TrainerBattle 744, 0, 1, 0
	GoTo _cv_battle_362
_cv_next_373:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_374
	TrainerBattle 739, 0, 1, 0
	GoTo _cv_battle_362
_cv_next_374:
	TrainerBattle 738, 0, 1, 0
_cv_battle_362:
	SetFlag 0x2031
	GoTo PalletTown_ProfessorOaksLab_EventScript_EndRivalBattle
	End
	
GymSwitch_EventScript_ChoiceCancelled:
	SetVar VAR_SPECIAL_RESULT, 0
	Return
	
GymSwitch_EventScript_ConfirmNew:
	CanvasMsg msg_0451_T01R0301_GymSwitch_Text_ConfirmNew
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_375
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_376
_cv_yes_375:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_376:
	GoTo GymSwitch_EventScript_Confirmed
	
GymSwitch_EventScript_Confirmed:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymSwitch_EventScript_ChooseType
	// TODO(gba) special GymSwitch_SetType
	GoTo _cv_stop
	PlayFanfare SEQ_ME_BADGE
	BufferPlayersName 6
	CanvasMsg msg_0451_T01R0301_GymSwitch_Text_NowType
	WaitButton
	WaitFanfare
	Call Outfits_EventScript_AllGymUniforms
	CompareVarToValue 0x8007, 1
	CallIfEq GymSwitch_EventScript_OldLegendLeaves
	CompareVarToValue 0x8009, 1
	GoToIfEq GymSwitch_EventScript_NewTypeTips
	CanvasMsg msg_0451_T01R0301_GymSwitch_Text_BackToType
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
	GoToIfNe _cv_next_378
	BufferSpeciesName 0, SPECIES_POOCHYENA, 0, 0
	GoTo _cv_done_377
_cv_next_378:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_379
	BufferSpeciesName 0, SPECIES_PIKACHU, 0, 0
	GoTo _cv_done_377
_cv_next_379:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_380
	BufferSpeciesName 0, SPECIES_TYROGUE, 0, 0
	GoTo _cv_done_377
_cv_next_380:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_381
	BufferSpeciesName 0, SPECIES_CHARMANDER, 0, 0
	GoTo _cv_done_377
_cv_next_381:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_382
	BufferSpeciesName 0, SPECIES_BULBASAUR, 0, 0
	GoTo _cv_done_377
_cv_next_382:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_383
	BufferSpeciesName 0, SPECIES_SANDSHREW, 0, 0
	GoTo _cv_done_377
_cv_next_383:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_384
	BufferSpeciesName 0, SPECIES_SPHEAL, 0, 0
	GoTo _cv_done_377
_cv_next_384:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_385
	BufferSpeciesName 0, SPECIES_EKANS, 0, 0
	GoTo _cv_done_377
_cv_next_385:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_386
	BufferSpeciesName 0, SPECIES_RALTS, 0, 0
	GoTo _cv_done_377
_cv_next_386:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_387
	BufferSpeciesName 0, SPECIES_LARVITAR, 0, 0
	GoTo _cv_done_377
_cv_next_387:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_388
	BufferSpeciesName 0, SPECIES_BELDUM, 0, 0
	GoTo _cv_done_377
_cv_next_388:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_389
	BufferSpeciesName 0, SPECIES_SQUIRTLE, 0, 0
	GoTo _cv_done_377
_cv_next_389:
_cv_done_377:
	BufferTypeName 1, 0x5019
	BufferTypeName 2, 0x501A
	BufferRivalsName 7
	CanvasMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_RivalPicksType
	WaitButton
	BufferSpeciesName 0, 0x4003, 0, 0
	BufferRivalsName 7
	CanvasMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_RivalReceivedMonFromOak
	PlayFanfare SEQ_ME_ITEM
	WaitFanfare
	SetVar 0x5006, 3
	CallIfSet 0x200A, PalletTown_ProfessorOaksLab_EventScript_ReadyEndSignLadyScene
	CloseMsg
	ReleaseAll
	End
	
EventScript_GymHack_ShowTeamRuleMessage:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq EventScript_GymHack_MsgWrongType
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	CallIfEq EventScript_GymHack_MsgDuplicate
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	CallIfEq EventScript_GymHack_MsgDuplicateItem
	Return
	
PalletTown_ProfessorOaksLab_EventScript_EndRivalBattle:
	HealParty
	BufferPlayersName 6
	BufferRivalsName 7
	CanvasMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_RivalGoToughenMyMon
	WaitButton
	CanvasCloseMsg
	ApplyMovement 4, Common_Movement_FaceDown
	WaitMovement
	BufferRivalsName 7
	CanvasMsg msg_0451_T01R0301_PalletTown_ProfessorOaksLab_Text_OakFollowMeToGym
	WaitButton
	CanvasCloseMsg
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
	CanvasCloseMsg
	ReleaseAll
	End
	
Outfits_EventScript_AllGymUniforms:
	// TODO(gba) special Outfit_UnlockAllGymUniforms
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Outfits_EventScript_Return
	PlayFanfare SEQ_ME_ITEM
	BufferPlayersName 6
	CanvasMsg msg_0451_T01R0301_Outfits_Text_ReceivedAllGymUniforms
	WaitFanfare
	CanvasMsg msg_0451_T01R0301_Outfits_Text_AllInWardrobe
	WaitButton
	Return
	
GymSwitch_EventScript_OldLegendLeaves:
	CanvasMsg msg_0451_T01R0301_GymSwitch_Text_OldLegendLeaves
	WaitButton
	Return
	
GymSwitch_EventScript_NewTypeTips:
	CanvasMsg msg_0451_T01R0301_GymSwitch_Text_NewTypeTips
	WaitButton
	SetVar VAR_SPECIAL_RESULT, 1
	Return
	
PalletTown_ProfessorOaksLab_EventScript_ReadyEndSignLadyScene:
	SetVar 0x5000, 1
	Return
	
EventScript_GymHack_MsgWrongType:
	CanvasMsg msg_0451_T01R0301_Text_GymHack_WrongType
	WaitButton
	Return
	
EventScript_GymHack_MsgDuplicate:
	CanvasMsg msg_0451_T01R0301_Text_GymHack_Duplicate
	WaitButton
	Return
	
EventScript_GymHack_MsgDuplicateItem:
	CanvasMsg msg_0451_T01R0301_Text_GymHack_DuplicateItem
	WaitButton
	Return
	
Outfits_EventScript_Return:
	Return

_cv_str4:
	BufferPlayersName 6
	BufferRivalsName 7
	CompareVarToValue 0x401F, 1
	GoToIfNe _cv_str4_0
	NPCMsg msg_0451_T01R0301_cv_mentor_intro_rock
	Return
_cv_str4_0:
	CompareVarToValue 0x401F, 2
	GoToIfNe _cv_str4_1
	NPCMsg msg_0451_T01R0301_cv_mentor_intro_normal
	Return
_cv_str4_1:
	CompareVarToValue 0x401F, 3
	GoToIfNe _cv_str4_2
	NPCMsg msg_0451_T01R0301_cv_mentor_intro_water
	Return
_cv_str4_2:
	CompareVarToValue 0x401F, 4
	GoToIfNe _cv_str4_3
	NPCMsg msg_0451_T01R0301_cv_mentor_intro_electric
	Return
_cv_str4_3:
	CompareVarToValue 0x401F, 5
	GoToIfNe _cv_str4_4
	NPCMsg msg_0451_T01R0301_cv_mentor_intro_steel
	Return
_cv_str4_4:
	CompareVarToValue 0x401F, 6
	GoToIfNe _cv_str4_5
	NPCMsg msg_0451_T01R0301_cv_mentor_intro_grass
	Return
_cv_str4_5:
	CompareVarToValue 0x401F, 7
	GoToIfNe _cv_str4_6
	NPCMsg msg_0451_T01R0301_cv_mentor_intro_poison
	Return
_cv_str4_6:
	CompareVarToValue 0x401F, 8
	GoToIfNe _cv_str4_7
	NPCMsg msg_0451_T01R0301_cv_mentor_intro_bug
	Return
_cv_str4_7:
	CompareVarToValue 0x401F, 9
	GoToIfNe _cv_str4_8
	NPCMsg msg_0451_T01R0301_cv_mentor_intro_psychic
	Return
_cv_str4_8:
	CompareVarToValue 0x401F, 10
	GoToIfNe _cv_str4_9
	NPCMsg msg_0451_T01R0301_cv_mentor_intro_fairy
	Return
_cv_str4_9:
	CompareVarToValue 0x401F, 11
	GoToIfNe _cv_str4_10
	NPCMsg msg_0451_T01R0301_cv_mentor_intro_fire
	Return
_cv_str4_10:
	CompareVarToValue 0x401F, 12
	GoToIfNe _cv_str4_11
	NPCMsg msg_0451_T01R0301_cv_mentor_intro_ground
	Return
_cv_str4_11:
	CompareVarToValue 0x401F, 13
	GoToIfNe _cv_str4_12
	NPCMsg msg_0451_T01R0301_cv_mentor_intro_dark
	Return
_cv_str4_12:
	CompareVarToValue 0x401F, 14
	GoToIfNe _cv_str4_13
	NPCMsg msg_0451_T01R0301_cv_mentor_intro_ice
	Return
_cv_str4_13:
	CompareVarToValue 0x401F, 15
	GoToIfNe _cv_str4_14
	NPCMsg msg_0451_T01R0301_cv_mentor_intro_fighting
	Return
_cv_str4_14:
	CompareVarToValue 0x401F, 16
	GoToIfNe _cv_str4_15
	NPCMsg msg_0451_T01R0301_cv_mentor_intro_ghost
	Return
_cv_str4_15:
	CompareVarToValue 0x401F, 17
	GoToIfNe _cv_str4_16
	NPCMsg msg_0451_T01R0301_cv_mentor_intro_dragon
	Return
_cv_str4_16:
	CompareVarToValue 0x401F, 18
	GoToIfNe _cv_str4_17
	NPCMsg msg_0451_T01R0301_cv_mentor_intro_flying
	Return
_cv_str4_17:
	CompareVarToValue 0x401F, 19
	GoToIfNe _cv_str4_18
	NPCMsg msg_0451_T01R0301_cv_mentor_story_0
	Return
_cv_str4_18:
	CompareVarToValue 0x401F, 20
	GoToIfNe _cv_str4_19
	NPCMsg msg_0451_T01R0301_cv_mentor_story_1
	Return
_cv_str4_19:
	CompareVarToValue 0x401F, 21
	GoToIfNe _cv_str4_20
	NPCMsg msg_0451_T01R0301_cv_mentor_story_2
	Return
_cv_str4_20:
	CompareVarToValue 0x401F, 22
	GoToIfNe _cv_str4_21
	NPCMsg msg_0451_T01R0301_cv_mentor_story_3
	Return
_cv_str4_21:
	CompareVarToValue 0x401F, 23
	GoToIfNe _cv_str4_22
	NPCMsg msg_0451_T01R0301_cv_mentor_story_4
	Return
_cv_str4_22:
	CompareVarToValue 0x401F, 24
	GoToIfNe _cv_str4_23
	NPCMsg msg_0451_T01R0301_cv_mentor_story_5
	Return
_cv_str4_23:
	CompareVarToValue 0x401F, 25
	GoToIfNe _cv_str4_24
	NPCMsg msg_0451_T01R0301_cv_mentor_story_6
	Return
_cv_str4_24:
	CompareVarToValue 0x401F, 26
	GoToIfNe _cv_str4_25
	NPCMsg msg_0451_T01R0301_cv_mentor_story_9
	Return
_cv_str4_25:
	CompareVarToValue 0x401F, 27
	GoToIfNe _cv_str4_26
	NPCMsg msg_0451_T01R0301_cv_mentor_story_10
	Return
_cv_str4_26:
	CompareVarToValue 0x401F, 28
	GoToIfNe _cv_str4_27
	NPCMsg msg_0451_T01R0301_cv_mentor_story_8
	Return
_cv_str4_27:
	CompareVarToValue 0x401F, 29
	GoToIfNe _cv_str4_28
	NPCMsg msg_0451_T01R0301_cv_mentor_story_11
	Return
_cv_str4_28:
	CompareVarToValue 0x401F, 30
	GoToIfNe _cv_str4_29
	NPCMsg msg_0451_T01R0301_cv_mentor_question_0
	Return
_cv_str4_29:
	CompareVarToValue 0x401F, 31
	GoToIfNe _cv_str4_30
	NPCMsg msg_0451_T01R0301_cv_mentor_question_1
	Return
_cv_str4_30:
	CompareVarToValue 0x401F, 32
	GoToIfNe _cv_str4_31
	NPCMsg msg_0451_T01R0301_cv_mentor_question_2
	Return
_cv_str4_31:
	CompareVarToValue 0x401F, 33
	GoToIfNe _cv_str4_32
	NPCMsg msg_0451_T01R0301_cv_mentor_question_3
	Return
_cv_str4_32:
	CompareVarToValue 0x401F, 34
	GoToIfNe _cv_str4_33
	NPCMsg msg_0451_T01R0301_cv_mentor_question_4
	Return
_cv_str4_33:
	CompareVarToValue 0x401F, 35
	GoToIfNe _cv_str4_34
	NPCMsg msg_0451_T01R0301_cv_mentor_question_5
	Return
_cv_str4_34:
	CompareVarToValue 0x401F, 36
	GoToIfNe _cv_str4_35
	NPCMsg msg_0451_T01R0301_cv_mentor_question_6
	Return
_cv_str4_35:
	CompareVarToValue 0x401F, 37
	GoToIfNe _cv_str4_36
	NPCMsg msg_0451_T01R0301_cv_mentor_question_9
	Return
_cv_str4_36:
	CompareVarToValue 0x401F, 38
	GoToIfNe _cv_str4_37
	NPCMsg msg_0451_T01R0301_cv_mentor_question_10
	Return
_cv_str4_37:
	CompareVarToValue 0x401F, 39
	GoToIfNe _cv_str4_38
	NPCMsg msg_0451_T01R0301_cv_mentor_question_8
	Return
_cv_str4_38:
	CompareVarToValue 0x401F, 40
	GoToIfNe _cv_str4_39
	NPCMsg msg_0451_T01R0301_cv_mentor_question_11
	Return
_cv_str4_39:
	CompareVarToValue 0x401F, 41
	GoToIfNe _cv_str4_40
	NPCMsg msg_0451_T01R0301_cv_mentor_no_0
	Return
_cv_str4_40:
	CompareVarToValue 0x401F, 42
	GoToIfNe _cv_str4_41
	NPCMsg msg_0451_T01R0301_cv_mentor_no_1
	Return
_cv_str4_41:
	CompareVarToValue 0x401F, 43
	GoToIfNe _cv_str4_42
	NPCMsg msg_0451_T01R0301_cv_mentor_no_2
	Return
_cv_str4_42:
	CompareVarToValue 0x401F, 44
	GoToIfNe _cv_str4_43
	NPCMsg msg_0451_T01R0301_cv_mentor_no_3
	Return
_cv_str4_43:
	CompareVarToValue 0x401F, 45
	GoToIfNe _cv_str4_44
	NPCMsg msg_0451_T01R0301_cv_mentor_no_4
	Return
_cv_str4_44:
	CompareVarToValue 0x401F, 46
	GoToIfNe _cv_str4_45
	NPCMsg msg_0451_T01R0301_cv_mentor_no_5
	Return
_cv_str4_45:
	CompareVarToValue 0x401F, 47
	GoToIfNe _cv_str4_46
	NPCMsg msg_0451_T01R0301_cv_mentor_no_6
	Return
_cv_str4_46:
	CompareVarToValue 0x401F, 48
	GoToIfNe _cv_str4_47
	NPCMsg msg_0451_T01R0301_cv_mentor_no_9
	Return
_cv_str4_47:
	CompareVarToValue 0x401F, 49
	GoToIfNe _cv_str4_48
	NPCMsg msg_0451_T01R0301_cv_mentor_no_10
	Return
_cv_str4_48:
	CompareVarToValue 0x401F, 50
	GoToIfNe _cv_str4_49
	NPCMsg msg_0451_T01R0301_cv_mentor_no_8
	Return
_cv_str4_49:
	CompareVarToValue 0x401F, 51
	GoToIfNe _cv_str4_50
	NPCMsg msg_0451_T01R0301_cv_mentor_no_11
	Return
_cv_str4_50:
	CompareVarToValue 0x401F, 52
	GoToIfNe _cv_str4_51
	NPCMsg msg_0451_T01R0301_cv_mentor_yes_0
	Return
_cv_str4_51:
	CompareVarToValue 0x401F, 53
	GoToIfNe _cv_str4_52
	NPCMsg msg_0451_T01R0301_cv_mentor_yes_1
	Return
_cv_str4_52:
	CompareVarToValue 0x401F, 54
	GoToIfNe _cv_str4_53
	NPCMsg msg_0451_T01R0301_cv_mentor_yes_2
	Return
_cv_str4_53:
	CompareVarToValue 0x401F, 55
	GoToIfNe _cv_str4_54
	NPCMsg msg_0451_T01R0301_cv_mentor_yes_3
	Return
_cv_str4_54:
	CompareVarToValue 0x401F, 56
	GoToIfNe _cv_str4_55
	NPCMsg msg_0451_T01R0301_cv_mentor_yes_4
	Return
_cv_str4_55:
	CompareVarToValue 0x401F, 57
	GoToIfNe _cv_str4_56
	NPCMsg msg_0451_T01R0301_cv_mentor_yes_5
	Return
_cv_str4_56:
	CompareVarToValue 0x401F, 58
	GoToIfNe _cv_str4_57
	NPCMsg msg_0451_T01R0301_cv_mentor_yes_6
	Return
_cv_str4_57:
	CompareVarToValue 0x401F, 59
	GoToIfNe _cv_str4_58
	NPCMsg msg_0451_T01R0301_cv_mentor_yes_9
	Return
_cv_str4_58:
	CompareVarToValue 0x401F, 60
	GoToIfNe _cv_str4_59
	NPCMsg msg_0451_T01R0301_cv_mentor_yes_10
	Return
_cv_str4_59:
	CompareVarToValue 0x401F, 61
	GoToIfNe _cv_str4_60
	NPCMsg msg_0451_T01R0301_cv_mentor_yes_8
	Return
_cv_str4_60:
	CompareVarToValue 0x401F, 62
	GoToIfNe _cv_str4_61
	NPCMsg msg_0451_T01R0301_cv_mentor_yes_11
	Return
_cv_str4_61:
	CompareVarToValue 0x401F, 63
	GoToIfNe _cv_str4_62
	NPCMsg msg_0451_T01R0301_cv_mentor_farewell_0
	Return
_cv_str4_62:
	CompareVarToValue 0x401F, 64
	GoToIfNe _cv_str4_63
	NPCMsg msg_0451_T01R0301_cv_mentor_farewell_1
	Return
_cv_str4_63:
	CompareVarToValue 0x401F, 65
	GoToIfNe _cv_str4_64
	NPCMsg msg_0451_T01R0301_cv_mentor_farewell_2
	Return
_cv_str4_64:
	CompareVarToValue 0x401F, 66
	GoToIfNe _cv_str4_65
	NPCMsg msg_0451_T01R0301_cv_mentor_farewell_3
	Return
_cv_str4_65:
	CompareVarToValue 0x401F, 67
	GoToIfNe _cv_str4_66
	NPCMsg msg_0451_T01R0301_cv_mentor_farewell_4
	Return
_cv_str4_66:
	CompareVarToValue 0x401F, 68
	GoToIfNe _cv_str4_67
	NPCMsg msg_0451_T01R0301_cv_mentor_farewell_5
	Return
_cv_str4_67:
	CompareVarToValue 0x401F, 69
	GoToIfNe _cv_str4_68
	NPCMsg msg_0451_T01R0301_cv_mentor_farewell_6
	Return
_cv_str4_68:
	CompareVarToValue 0x401F, 70
	GoToIfNe _cv_str4_69
	NPCMsg msg_0451_T01R0301_cv_mentor_farewell_9
	Return
_cv_str4_69:
	CompareVarToValue 0x401F, 71
	GoToIfNe _cv_str4_70
	NPCMsg msg_0451_T01R0301_cv_mentor_farewell_10
	Return
_cv_str4_70:
	CompareVarToValue 0x401F, 72
	GoToIfNe _cv_str4_71
	NPCMsg msg_0451_T01R0301_cv_mentor_farewell_8
	Return
_cv_str4_71:
	CompareVarToValue 0x401F, 73
	GoToIfNe _cv_str4_72
	NPCMsg msg_0451_T01R0301_cv_mentor_farewell_11
	Return
_cv_str4_72:
	Return

_cv_stop:
	CanvasMsg msg_0451_T01R0301_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_team_not_allowed:
	Call EventScript_GymHack_ShowTeamRuleMessage
	CanvasCloseMsg
	GetPlayerCoords 0x8008, 0x8009
	GetPlayerFacing 0x800A
	Warp MAP_PALLET_TOWN_OAKS_LAB, 0, 0x8008, 0x8009, 0x800A
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
