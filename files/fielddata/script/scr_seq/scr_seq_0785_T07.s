#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T07.h"
#include "msgdata/msg/msg_0491_T07.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's CeladonCity_Frlg#world by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef CeladonCity_EventScript_RocketGrunt1
	ScrDef CeladonCity_EventScript_FatMan
	ScrDef CeladonCity_EventScript_Poliwrath
	ScrDef CeladonCity_EventScript_LittleGirl
	ScrDef CeladonCity_EventScript_Woman
	ScrDef CeladonCity_EventScript_OldMan2
	ScrDef CeladonCity_EventScript_SoftboiledTutor
	ScrDef CeladonCity_EventScript_RocketGrunt2
	ScrDef CeladonCity_EventScript_OldMan1
	ScrDef CeladonCity_EventScript_Boy
	ScrDef CeladonCity_EventScript_ItemEther
	ScrDef CeladonCity_EventScript_SilphCoScientist
	ScrDef BerryField_EventScript_FindFairy
	ScrDef TypeTutor_EventScript_Grass
	ScrDef CeladonCity_EventScript_TrainerTips2
	ScrDef CeladonCity_EventScript_PrizeExchangeSign
	ScrDef CeladonCity_EventScript_GameCornerSign
	ScrDef CeladonCity_EventScript_CitySign
	ScrDef CeladonCity_EventScript_MansionSign
	ScrDef CeladonCity_EventScript_TrainerTips1
	ScrDef CeladonCity_EventScript_DeptStoreSign
	ScrDef CeladonCity_EventScript_GymSign
	ScrDef Route7_EventScript_UndergroundPathSign
	ScrDef CeladonCity_OnTransition
	ScrDefEnd
	
CeladonCity_EventScript_RocketGrunt1:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0491_T07_CeladonCity_Text_KeepOutOfTeamRocketsWay
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_EventScript_FatMan:
	LockAll
	FacePlayer
	NPCMsg msg_0491_T07_CeladonCity_Text_MyTrustedPalPoliwrath
	WaitButton
	CloseMsg
	ApplyMovement 2, Common_Movement_FaceOriginalDirection
	WaitMovement
	ReleaseAll
	End
	
CeladonCity_EventScript_Poliwrath:
	LockAll
	FacePlayer
	WaitSE SEQ_SE_DP_SELECT
	PlayCry SPECIES_POLIWRATH, 0
	NPCMsg msg_0491_T07_CeladonCity_Text_Poliwrath
	WaitButton
	CloseMsg
	WaitCry
	ApplyMovement 3, Common_Movement_FaceOriginalDirection
	WaitMovement
	ReleaseAll
	End
	
CeladonCity_EventScript_LittleGirl:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0491_T07_CeladonCity_Text_GotMyKoffingInCinnabar
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_EventScript_Woman:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0491_T07_CeladonCity_Text_GameCornerIsBadForCitysImage
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_EventScript_OldMan2:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0491_T07_CeladonCity_Text_BlewItAllAtSlots
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_EventScript_SoftboiledTutor:
	GoTo EventScript_SoftboiledTutor
	End
	
CeladonCity_EventScript_RocketGrunt2:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0491_T07_CeladonCity_Text_GetLostOrIllPunchYou
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_EventScript_OldMan1:
	LockAll
	NPCMsg msg_0491_T07_CeladonCity_Text_GymIsGreatFullOfWomen
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_EventScript_Boy:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0491_T07_CeladonCity_Text_ScaldedTongueOnTea
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_EventScript_ItemEther:
	SetVar 0x8004, ITEM_ETHER
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
CeladonCity_EventScript_SilphCoScientist:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0491_T07_CeladonCity_Text_SomeoneStoleSilphScope
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
BerryField_EventScript_FindFairy:
	SetVar 0x8004, 686
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
TypeTutor_EventScript_Grass:
	LockAll
	FacePlayer
	SetVar 0x8004, 11
	GoTo TypeTutor_EventScript_Talk
	
CeladonCity_EventScript_TrainerTips2:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0491_T07_CeladonCity_Text_GuardSpecProtectsFromStatus
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_EventScript_PrizeExchangeSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0491_T07_CeladonCity_Text_PrizeExchangeSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_EventScript_GameCornerSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0491_T07_CeladonCity_Text_GameCornerSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_EventScript_CitySign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0491_T07_CeladonCity_Text_CitySign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_EventScript_MansionSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0491_T07_CeladonCity_Text_MansionSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_EventScript_TrainerTips1:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0491_T07_CeladonCity_Text_ExplainXAccuracyDireHit
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_EventScript_DeptStoreSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0491_T07_CeladonCity_Text_DeptStoreSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_EventScript_GymSign:
	LockAll
	NPCMsg msg_0491_T07_CeladonCity_Text_GymSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route7_EventScript_UndergroundPathSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0491_T07_Route7_Text_UndergroundPathSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_OnTransition:
	SetFlag FLAG_SYS_FLYPOINT_CELADON
	End
	
EventScript_SoftboiledTutor:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0491_T07_Text_SoftboiledTutor_Retired
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
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
	
TypeTutor_EventScript_Intro:
	// TODO(gba) special TypeTutor_BufferIntro
	GoTo _cv_stop
	Call _cv_str4
	WaitButton
	// TODO(gba) special TypeTutor_SetMet
	GoTo _cv_stop
	// TODO(gba) special TypeTutor_GetState
	GoTo _cv_stop
	GoTo TypeTutor_EventScript_Trial
	
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
	GoTo TypeTutor_EventScript_Teach
	
TypeTutor_EventScript_Teach:
	CopyVar 0x8004, 0x8008
	NPCMsg msg_0491_T07_TypeTutor_Text_WhichMove
	// TODO(gba) special TypeTutor_PushMoves
	GoTo _cv_stop
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_2
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq TypeTutor_EventScript_Bye
	CopyVar 0x8004, 0x8008
	// TODO(gba) special TypeTutor_SelectMove
	GoTo _cv_stop
	NPCMsg msg_0491_T07_TypeTutor_Text_WhichMon
	WaitButton
	Call EventScript_ChooseMoveTutorMon
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TypeTutor_EventScript_Teach
	NPCMsg msg_0491_T07_TypeTutor_Text_Taught
	WaitButton
	GoTo TypeTutor_EventScript_Teach
	
TypeTutor_EventScript_Bye:
	NPCMsg msg_0491_T07_TypeTutor_Text_Bye
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
	NPCMsg msg_0491_T07_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
Common_Movement_FaceOriginalDirection:
	EndMovement
	.balign 4, 0
