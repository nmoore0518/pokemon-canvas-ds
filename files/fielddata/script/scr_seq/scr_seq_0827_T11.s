#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T11.h"
#include "msgdata/msg/msg_0529_T11.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SaffronCity_Frlg#world by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SaffronCity_EventScript_RocketGrunt1
	ScrDef SaffronCity_EventScript_RocketGrunt2
	ScrDef SaffronCity_EventScript_RocketGrunt3
	ScrDef SaffronCity_EventScript_RocketGrunt4
	ScrDef SaffronCity_EventScript_RocketGrunt5
	ScrDef SaffronCity_EventScript_DoorGuardGrunt
	ScrDef SaffronCity_EventScript_RocketGrunt7
	ScrDef SaffronCity_EventScript_RocketGrunt6
	ScrDef SaffronCity_EventScript_Youngster
	ScrDef SaffronCity_EventScript_WorkerM
	ScrDef SaffronCity_EventScript_Man
	ScrDef SaffronCity_EventScript_Boy
	ScrDef SaffronCity_EventScript_Pidgeot
	ScrDef SaffronCity_EventScript_Lass
	ScrDef SaffronCity_EventScript_BattleGirl
	ScrDef PaintWorld_EventScript_Figure
	ScrDef SaffronCity_EventScript_CitySign
	ScrDef SaffronCity_EventScript_DojoSign
	ScrDef SaffronCity_EventScript_SilphProductSign
	ScrDef SaffronCity_EventScript_TrainerTips2
	ScrDef SaffronCity_EventScript_SilphCoSign
	ScrDef SaffronCity_EventScript_TrainerTips1
	ScrDef SaffronCity_EventScript_GymSign
	ScrDef SaffronCity_EventScript_MrPsychicsHouseSign
	ScrDef SaffronCity_EventScript_TrainerFanClubSign
	ScrDef Route5_EventScript_UndergroundPathSign
	ScrDef SaffronCity_OnTransition
	ScrDef _cv_unported_27
	ScrDefEnd
	
SaffronCity_EventScript_RocketGrunt1:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0529_T11_SaffronCity_Text_WhatDoYouWantGetLost
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_EventScript_RocketGrunt2:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0529_T11_SaffronCity_Text_BossTakeTownForTeamRocket
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_EventScript_RocketGrunt3:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0529_T11_SaffronCity_Text_DontGetDefiantOrIllHurtYou
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_EventScript_RocketGrunt4:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0529_T11_SaffronCity_Text_SaffronBelongsToTeamRocket
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_EventScript_RocketGrunt5:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0529_T11_SaffronCity_Text_CriminalLifeMakesMeFeelAlive
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_EventScript_DoorGuardGrunt:
	LockAll
	GoToIfSet 0x20FA, SaffronCity_EventScript_DoorGuardAsleep
	FacePlayer
	WaitMovement
	NPCMsg msg_0529_T11_SaffronCity_Text_ImASecurityGuard
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_EventScript_RocketGrunt7:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0529_T11_SaffronCity_Text_WeCanExploitMonsAroundWorld
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_EventScript_RocketGrunt6:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0529_T11_SaffronCity_Text_WatchWhereYoureWalking
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_EventScript_Youngster:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0529_T11_SaffronCity_Text_SafeToGoOutAgain
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_EventScript_WorkerM:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0529_T11_SaffronCity_Text_YouBeatTeamRocket
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_EventScript_Man:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0529_T11_SaffronCity_Text_SawRocketBossEscaping
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_EventScript_Boy:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0529_T11_SaffronCity_Text_FlewHereOnPidgeot
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_EventScript_Pidgeot:
	LockAll
	FacePlayer
	WaitSE SEQ_SE_DP_SELECT
	PlayCry SPECIES_PIDGEOT, 0
	NPCMsg msg_0529_T11_SaffronCity_Text_Pidgeot
	WaitButton
	WaitCry
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_EventScript_Lass:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0529_T11_SaffronCity_Text_PeopleComingBackToSaffron
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_EventScript_BattleGirl:
	LockAll
	FacePlayer
	NPCMsg msg_0529_T11_SaffronCity_Text_HowCanClubNotRecognizeLance
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PaintWorld_EventScript_Figure:
	LockAll
	FacePlayer
	CompareVarToValue 0x5020, 2
	GoToIfEq PaintWorld_EventScript_FigureSketch
	CompareVarToValue 0x5020, 3
	GoToIfEq PaintWorld_EventScript_FigureMega
	NPCMsg msg_0529_T11_PaintWorld_Text_FigureFirst
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
SaffronCity_EventScript_CitySign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0529_T11_SaffronCity_Text_CitySign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_EventScript_DojoSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0529_T11_SaffronCity_Text_FightingDojo
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_EventScript_SilphProductSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0529_T11_SaffronCity_Text_SilphsLatestProduct
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_EventScript_TrainerTips2:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0529_T11_SaffronCity_Text_GreatBallImprovedCatchRate
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_EventScript_SilphCoSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0529_T11_SaffronCity_Text_SilphCoSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_EventScript_TrainerTips1:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0529_T11_SaffronCity_Text_FullHealCuresStatus
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_EventScript_GymSign:
	LockAll
	NPCMsg msg_0529_T11_SaffronCity_Text_GymSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_EventScript_MrPsychicsHouseSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0529_T11_SaffronCity_Text_MrPsychicsHouse
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_EventScript_TrainerFanClubSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0529_T11_SaffronCity_Text_TrainerFanClubSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route5_EventScript_UndergroundPathSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0529_T11_Route5_Text_UndergroundPathSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_OnTransition:
	SetFlag 0x2089
	SetVar 0x4014, 2
	// TODO(gba) special MoveExtractor_VisitDue
	CopyVar 0x4009, 0x401C
	SetFlag FLAG_SYS_FLYPOINT_SAFFRON
	CallIfUnset 0x20FA, SaffronCity_EventScript_MoveDoorGuardGrunt
	End
	
MoveExtractor_EventScript_SaffronVisit:
	SetVar 0x800A, 16
	SetVar 0x8008, 2
	GoTo MoveExtractor_EventScript_Visit
	End
	
SaffronCity_EventScript_DoorGuardAsleep:
	NPCMsg msg_0529_T11_SaffronCity_Text_HesTakingASnooze
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PaintWorld_EventScript_FigureSketch:
	NPCMsg msg_0529_T11_PaintWorld_Text_FigureSketch
	WaitButton
	GoTo PaintWorld_EventScript_FigureBattle
	
PaintWorld_EventScript_FigureMega:
	NPCMsg msg_0529_T11_PaintWorld_Text_FigureMega
	WaitButton
	End
	
PaintWorld_EventScript_FigureBattle:
	CloseMsg
	// TODO(gba) special Painter_SetupFigure
	GoTo _cv_stop
	ClearTrainerFlag 1442
	SetFlag 0x2036
	CheckTrainerFlag 1442
	GoToIf TRUE, _cv_beaten_1
	TrainerBattle 1442, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_2
	WhiteOut
	End
_cv_won_2:
	SetTrainerFlag 1442
	ReleaseAll
	End
_cv_beaten_1:
	ClearFlag 0x2036
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq _cv_won_3
	SetVar VAR_SPECIAL_RESULT, 2
_cv_won_3:
	// TODO(gba) special Painter_RecordBattle
	GoTo _cv_stop
	NPCMsg msg_0529_T11_PaintWorld_Text_Dissolve
	WaitButton
	CloseMsg
	FadeScreen 6, 1, 0, RGB_WHITE
	WaitFade
	// TODO(gba) warpsilent MAP_PEWTER_CITY_PAINTER_LOFT, 8, 4
	GoTo _cv_stop
	ReleaseAll
	End
	
SaffronCity_EventScript_MoveDoorGuardGrunt:
	MovePerson 6, 1254, 236
	Return
	
MoveExtractor_EventScript_Visit:
	LockAll
	SetVar 0x4009, 0
	// TODO(gba) special GymCandidate_PlaceGuest
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq MoveExtractor_EventScript_VisitNoRoom
	CopyVar 0x401E, 0x8005
	AddVar 0x401E, 1221
	CopyVar 0x401F, 0x8006
	AddVar 0x401F, 205
	MovePerson 0x800A, 0x401E, 0x401F
	ClearFlag 0x2089
	ShowPerson 0x800A
	// TODO(gba) special GymCandidate_FaceGuest
	GoTo _cv_stop
	PlaySE SEQ_SE_DP_SELECT
	ApplyMovement 0x800A, Common_Movement_ExclamationMark
	WaitMovement
	CompareVarToValue 0x8008, 2
	CallIfEq MoveExtractor_EventScript_SecondVisit
	CompareVarToValue 0x8008, 3
	CallIfEq MoveExtractor_EventScript_ThirdVisit
	CloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	HidePerson 0x800A
	SetFlag 0x2089
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	End
	
MoveExtractor_EventScript_VisitNoRoom:
	ReleaseAll
	End
	
MoveExtractor_EventScript_SecondVisit:
	NPCMsg msg_0529_T11_MoveExtractor_Text_SecondVisit
	WaitButton
	SetVar 0x8009, 0
	Call GymHack_EventScript_GiveStatItem
	SetVar 0x501F, 2
	NPCMsg msg_0529_T11_MoveExtractor_Text_SecondVisitAfter
	WaitButton
	Return
	
MoveExtractor_EventScript_ThirdVisit:
	NPCMsg msg_0529_T11_MoveExtractor_Text_ThirdVisit
	WaitButton
	SetVar 0x8009, 0
	Call GymHack_EventScript_GiveStatItem
	SetVar 0x501F, 3
	NPCMsg msg_0529_T11_MoveExtractor_Text_ThirdVisitAfter
	WaitButton
	Return
	
GymHack_EventScript_GiveStatItem:
	GiveItem 0x8009, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymHack_EventScript_GiveStatItemDone
	BufferItemName 1, 0x8009
	NPCMsg msg_0529_T11_GymHack_Text_GiftSentToPC
	WaitButton
	End
	
GymHack_EventScript_GiveStatItemDone:
	Return

_cv_unported_27:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0529_T11_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0529_T11_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
Common_Movement_ExclamationMark:
	EmoteExclamationMark
	EndMovement
	.balign 4, 0
