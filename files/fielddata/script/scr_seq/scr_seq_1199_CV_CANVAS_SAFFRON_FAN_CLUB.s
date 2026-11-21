#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SAFFRON_FAN_CLUB.h"
#include "msgdata/msg/msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SaffronCity_PokemonTrainerFanClub_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SaffronCity_PokemonTrainerFanClub_EventScript_BattleGirl
	ScrDef SaffronCity_PokemonTrainerFanClub_EventScript_LittleGirl
	ScrDef SaffronCity_PokemonTrainerFanClub_EventScript_Youngster
	ScrDef SaffronCity_PokemonTrainerFanClub_EventScript_Gentleman
	ScrDef SaffronCity_PokemonTrainerFanClub_EventScript_Woman
	ScrDef SaffronCity_PokemonTrainerFanClub_EventScript_Rocker
	ScrDef SaffronCity_PokemonTrainerFanClub_EventScript_Beauty
	ScrDef SaffronCity_PokemonTrainerFanClub_EventScript_BlackBelt
	ScrDef SaffronCity_PokemonTrainerFanClub_EventScript_PokemonJournalBruno
	ScrDef SaffronCity_PokemonTrainerFanClub_EventScript_MeetFirstFans
	ScrDef SaffronCity_PokemonTrainerFanClub_OnTransition
	ScrDefEnd
	
SaffronCity_PokemonTrainerFanClub_EventScript_BattleGirl:
	LockAll
	FacePlayer
	SetVar 0x8004, 8
	// TODO(gba) special Script_BufferFanClubTrainerName
	GoTo _cv_stop
	CompareVarToValue 0x5043, 0
	GoToIfEq SaffronCity_PokemonTrainerFanClub_EventScript_BattleGirlPlayerNotChampion
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar Script_IsFanClubMemberFanOfPlayer
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq SaffronCity_PokemonTrainerFanClub_EventScript_BattleGirlPlayersFan
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar Script_GetNumFansOfPlayerInTrainerFanClub
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 7
	GoToIfEq SaffronCity_PokemonTrainerFanClub_EventScript_BattleGirlOnlyNonFan
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_SaffronCity_PokemonTrainerFanClub_Text_WasYourFanNotAnymore
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_LittleGirl:
	LockAll
	FacePlayer
	SetVar 0x8004, 11
	// TODO(gba) special Script_BufferFanClubTrainerName
	GoTo _cv_stop
	CompareVarToValue 0x5043, 0
	GoToIfEq SaffronCity_PokemonTrainerFanClub_EventScript_LittleGirlPlayerNotChampion
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar Script_IsFanClubMemberFanOfPlayer
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq SaffronCity_PokemonTrainerFanClub_EventScript_LittleGirlPlayersFan
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar Script_GetNumFansOfPlayerInTrainerFanClub
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 7
	GoToIfEq SaffronCity_PokemonTrainerFanClub_EventScript_LittleGirlOnlyNonFan
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_SaffronCity_PokemonTrainerFanClub_Text_WantToBeLikeSabrina
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_Youngster:
	LockAll
	FacePlayer
	SetVar 0x8004, 9
	// TODO(gba) special Script_BufferFanClubTrainerName
	GoTo _cv_stop
	CompareVarToValue 0x5043, 0
	GoToIfEq SaffronCity_PokemonTrainerFanClub_EventScript_YoungsterPlayerNotChampion
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar Script_IsFanClubMemberFanOfPlayer
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq SaffronCity_PokemonTrainerFanClub_EventScript_YoungsterPlayersFan
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar Script_GetNumFansOfPlayerInTrainerFanClub
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 7
	GoToIfEq SaffronCity_PokemonTrainerFanClub_EventScript_YoungsterOnlyNonFan
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_SaffronCity_PokemonTrainerFanClub_Text_BrocksMyHero
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_Gentleman:
	LockAll
	FacePlayer
	SetVar 0x8004, 10
	// TODO(gba) special Script_BufferFanClubTrainerName
	GoTo _cv_stop
	CompareVarToValue 0x5043, 0
	GoToIfEq SaffronCity_PokemonTrainerFanClub_EventScript_GentlemanPlayerNotChampion
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar Script_IsFanClubMemberFanOfPlayer
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq SaffronCity_PokemonTrainerFanClub_EventScript_GentlemanPlayersFan
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar Script_GetNumFansOfPlayerInTrainerFanClub
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 7
	GoToIfEq SaffronCity_PokemonTrainerFanClub_EventScript_GentlemanOnlyNonFan
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_SaffronCity_PokemonTrainerFanClub_Text_HmmAndYouAre
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_Woman:
	LockAll
	FacePlayer
	SetVar 0x8004, 13
	// TODO(gba) special Script_BufferFanClubTrainerName
	GoTo _cv_stop
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar Script_IsFanClubMemberFanOfPlayer
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq SaffronCity_PokemonTrainerFanClub_EventScript_WomanPlayersFan
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar Script_GetNumFansOfPlayerInTrainerFanClub
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 7
	GoToIfEq SaffronCity_PokemonTrainerFanClub_EventScript_WomanOnlyNonFan
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_SaffronCity_PokemonTrainerFanClub_Text_TrainerHasBeenOnFire
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_Rocker:
	LockAll
	FacePlayer
	SetVar 0x8004, 12
	// TODO(gba) special Script_BufferFanClubTrainerName
	GoTo _cv_stop
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar Script_IsFanClubMemberFanOfPlayer
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq SaffronCity_PokemonTrainerFanClub_EventScript_RockerPlayersFan
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar Script_GetNumFansOfPlayerInTrainerFanClub
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 7
	GoToIfEq SaffronCity_PokemonTrainerFanClub_EventScript_RockerOnlyNonFan
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_SaffronCity_PokemonTrainerFanClub_Text_LoveWayTrainerTalks
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_Beauty:
	LockAll
	FacePlayer
	SetVar 0x8004, 14
	// TODO(gba) special Script_BufferFanClubTrainerName
	GoTo _cv_stop
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar Script_IsFanClubMemberFanOfPlayer
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq SaffronCity_PokemonTrainerFanClub_EventScript_BeautyPlayersFan
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar Script_GetNumFansOfPlayerInTrainerFanClub
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 7
	GoToIfEq SaffronCity_PokemonTrainerFanClub_EventScript_BeautyOnlyNonFan
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_SaffronCity_PokemonTrainerFanClub_Text_WhyCantOthersSeeMastersDignity
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_BlackBelt:
	LockAll
	FacePlayer
	SetVar 0x8004, 15
	// TODO(gba) special Script_BufferFanClubTrainerName
	GoTo _cv_stop
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar Script_IsFanClubMemberFanOfPlayer
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq SaffronCity_PokemonTrainerFanClub_EventScript_BlackBeltPlayersFan
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar Script_GetNumFansOfPlayerInTrainerFanClub
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 7
	GoToIfEq SaffronCity_PokemonTrainerFanClub_EventScript_BlackBeltOnlyNonFan
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_SaffronCity_PokemonTrainerFanClub_Text_OnlyMasterHasMyRespect
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_PokemonJournalBruno:
	LockAll
	FacePlayer
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_PokemonJournal_Text_SpecialFeatureBruno
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_MeetFirstFans:
	LockAll
	ApplyMovement 1, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	PlaySE SEQ_SE_DP_SELECT
	ApplyMovement 1, Common_Movement_ExclamationMark
	WaitMovement
	ApplyMovement 1, Common_Movement_Delay48
	WaitMovement
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_SaffronCity_PokemonTrainerFanClub_Text_HuhYou
	WaitButton
	CanvasCloseMsg
	ApplyMovement 1, SaffronCity_PokemonTrainerFanClub_Movement_FanApproachPlayer
	WaitMovement
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterRight
	WaitMovement
	BufferPlayersName 6
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_SaffronCity_PokemonTrainerFanClub_Text_YourePlayerWereYourFansNow
	WaitButton
	SetVar 0x5043, 2
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonTrainerFanClub_OnTransition:
	CompareVarToValue 0x5043, 1
	GoToIfEq SaffronCity_PokemonTrainerFanClub_EventScript_SetMemberPosForFirstMeeting
	CompareVarToValue 0x5043, 2
	GoToIfEq SaffronCity_PokemonTrainerFanClub_EventScript_UpdateFanMemberPositions
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_BattleGirlPlayerNotChampion:
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_SaffronCity_PokemonTrainerFanClub_Text_TrainersCoolWhenBattling
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_BattleGirlPlayersFan:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar Script_GetNumFansOfPlayerInTrainerFanClub
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq SaffronCity_PokemonTrainerFanClub_EventScript_BattleGirlOnlyFan
	BufferPlayersName 6
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_SaffronCity_PokemonTrainerFanClub_Text_AlwaysCheerForYou
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_BattleGirlOnlyNonFan:
	BufferPlayersName 6
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_SaffronCity_PokemonTrainerFanClub_Text_EveryonesYourFanButICantBe
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_LittleGirlPlayerNotChampion:
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_SaffronCity_PokemonTrainerFanClub_Text_CanIBecomeCoolTrainerOneDay
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_LittleGirlPlayersFan:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar Script_GetNumFansOfPlayerInTrainerFanClub
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq SaffronCity_PokemonTrainerFanClub_EventScript_LittleGirlOnlyFan
	BufferPlayersName 6
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_SaffronCity_PokemonTrainerFanClub_Text_WantToBeLikeYouOneDay
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_LittleGirlOnlyNonFan:
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_SaffronCity_PokemonTrainerFanClub_Text_WontStopBeingSabrinasFan
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_YoungsterPlayerNotChampion:
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_SaffronCity_PokemonTrainerFanClub_Text_BrocksLastWordOnCool
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_YoungsterPlayersFan:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar Script_GetNumFansOfPlayerInTrainerFanClub
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq SaffronCity_PokemonTrainerFanClub_EventScript_YoungsterOnlyFan
	BufferPlayersName 6
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_SaffronCity_PokemonTrainerFanClub_Text_CanYouAutographShorts
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_YoungsterOnlyNonFan:
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_SaffronCity_PokemonTrainerFanClub_Text_BrocksFanToBitterEnd
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_GentlemanPlayerNotChampion:
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_SaffronCity_PokemonTrainerFanClub_Text_YoullBeTalkedAboutIfYouKeepWinning
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_GentlemanPlayersFan:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar Script_GetNumFansOfPlayerInTrainerFanClub
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq SaffronCity_PokemonTrainerFanClub_EventScript_GentlemanOnlyFan
	BufferPlayersName 6
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_SaffronCity_PokemonTrainerFanClub_Text_HadPleasureOfWatchingYouBattle
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_GentlemanOnlyNonFan:
	BufferPlayersName 6
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_SaffronCity_PokemonTrainerFanClub_Text_YouveStillAWaysToGo
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_WomanPlayersFan:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar Script_GetNumFansOfPlayerInTrainerFanClub
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq SaffronCity_PokemonTrainerFanClub_EventScript_WomanOnlyFan
	BufferPlayersName 6
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_SaffronCity_PokemonTrainerFanClub_Text_AdoreWayYouBattle
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_WomanOnlyNonFan:
	BufferPlayersName 6
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_SaffronCity_PokemonTrainerFanClub_Text_EveryoneTalksAboutYou
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_RockerPlayersFan:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar Script_GetNumFansOfPlayerInTrainerFanClub
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq SaffronCity_PokemonTrainerFanClub_EventScript_RockerOnlyFan
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_SaffronCity_PokemonTrainerFanClub_Text_TheWayYouBattleIsCool
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_RockerOnlyNonFan:
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_SaffronCity_PokemonTrainerFanClub_Text_ImLoneTrainerFan
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_BeautyPlayersFan:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar Script_GetNumFansOfPlayerInTrainerFanClub
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq SaffronCity_PokemonTrainerFanClub_EventScript_BeautyOnlyFan
	BufferPlayersName 6
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_SaffronCity_PokemonTrainerFanClub_Text_YouReallyAreAmazing
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_BeautyOnlyNonFan:
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_SaffronCity_PokemonTrainerFanClub_Text_BelieveInMasterWithAllMyHeart
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_BlackBeltPlayersFan:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar Script_GetNumFansOfPlayerInTrainerFanClub
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq SaffronCity_PokemonTrainerFanClub_EventScript_BlackBeltOnlyFan
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_SaffronCity_PokemonTrainerFanClub_Text_YourBattleStyleIsEducational
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_BlackBeltOnlyNonFan:
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_SaffronCity_PokemonTrainerFanClub_Text_NeverBeFanOfAnyoneButMaster
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_SetMemberPosForFirstMeeting:
	Call SaffronCity_PokemonTrainerFanClub_EventScript_MoveMember4ToFarTable
	Call SaffronCity_PokemonTrainerFanClub_EventScript_MoveMember5ToFarTable
	Call SaffronCity_PokemonTrainerFanClub_EventScript_MoveMember6ToFarTable
	Call SaffronCity_PokemonTrainerFanClub_EventScript_MoveMember7ToFarTable
	Call SaffronCity_PokemonTrainerFanClub_EventScript_MoveMember8ToFarTable
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_UpdateFanMemberPositions:
	// TODO(gba) special Script_TryLoseFansFromPlayTime
	SetVar 0x4014, 8
	SetVar 0x401C, 0  // TODO(gba) specialvar Script_IsFanClubMemberFanOfPlayer
	CompareVarToValue 0x401C, 0
	CallIfEq SaffronCity_PokemonTrainerFanClub_EventScript_MoveMember1ToFarTable
	SetVar 0x4014, 9
	SetVar 0x401C, 0  // TODO(gba) specialvar Script_IsFanClubMemberFanOfPlayer
	CompareVarToValue 0x401C, 0
	CallIfEq SaffronCity_PokemonTrainerFanClub_EventScript_MoveMember2ToFarTable
	SetVar 0x4014, 10
	SetVar 0x401C, 0  // TODO(gba) specialvar Script_IsFanClubMemberFanOfPlayer
	CompareVarToValue 0x401C, 0
	CallIfEq SaffronCity_PokemonTrainerFanClub_EventScript_MoveMember3ToFarTable
	SetVar 0x4014, 11
	SetVar 0x401C, 0  // TODO(gba) specialvar Script_IsFanClubMemberFanOfPlayer
	CompareVarToValue 0x401C, 0
	CallIfEq SaffronCity_PokemonTrainerFanClub_EventScript_MoveMember4ToFarTable
	SetVar 0x4014, 12
	SetVar 0x401C, 0  // TODO(gba) specialvar Script_IsFanClubMemberFanOfPlayer
	CompareVarToValue 0x401C, 0
	CallIfEq SaffronCity_PokemonTrainerFanClub_EventScript_MoveMember5ToFarTable
	SetVar 0x4014, 13
	SetVar 0x401C, 0  // TODO(gba) specialvar Script_IsFanClubMemberFanOfPlayer
	CompareVarToValue 0x401C, 0
	CallIfEq SaffronCity_PokemonTrainerFanClub_EventScript_MoveMember6ToFarTable
	SetVar 0x4014, 14
	SetVar 0x401C, 0  // TODO(gba) specialvar Script_IsFanClubMemberFanOfPlayer
	CompareVarToValue 0x401C, 0
	CallIfEq SaffronCity_PokemonTrainerFanClub_EventScript_MoveMember7ToFarTable
	SetVar 0x4014, 15
	SetVar 0x401C, 0  // TODO(gba) specialvar Script_IsFanClubMemberFanOfPlayer
	CompareVarToValue 0x401C, 0
	CallIfEq SaffronCity_PokemonTrainerFanClub_EventScript_MoveMember8ToFarTable
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_BattleGirlOnlyFan:
	BufferPlayersName 6
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_SaffronCity_PokemonTrainerFanClub_Text_IllAlwaysBelieveInYou
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_LittleGirlOnlyFan:
	BufferPlayersName 6
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_SaffronCity_PokemonTrainerFanClub_Text_EveryoneButMeStoppedBeingYourFan
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_YoungsterOnlyFan:
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_SaffronCity_PokemonTrainerFanClub_Text_CountingOnYou
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_GentlemanOnlyFan:
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_SaffronCity_PokemonTrainerFanClub_Text_NeverSeenTrainerOfYourMagnificence
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_WomanOnlyFan:
	BufferPlayersName 6
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_SaffronCity_PokemonTrainerFanClub_Text_ImYourNumberOneFan
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_RockerOnlyFan:
	BufferPlayersName 6
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_SaffronCity_PokemonTrainerFanClub_Text_ImOnlyOneLeftOfYourFans
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_BeautyOnlyFan:
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_SaffronCity_PokemonTrainerFanClub_Text_ImYourOnlyFan
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_BlackBeltOnlyFan:
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_SaffronCity_PokemonTrainerFanClub_Text_WontStopBeingYourFan
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_PokemonTrainerFanClub_EventScript_MoveMember4ToFarTable:
	MovePerson 4, 3, 4
	SetObjectMovementType 4, 17
	SetObjectFacing 4, 3
	Return
	
SaffronCity_PokemonTrainerFanClub_EventScript_MoveMember5ToFarTable:
	MovePerson 6, 4, 6
	SetObjectMovementType 6, 14
	SetObjectFacing 6, 0
	Return
	
SaffronCity_PokemonTrainerFanClub_EventScript_MoveMember6ToFarTable:
	MovePerson 7, 10, 3
	SetObjectMovementType 7, 14
	SetObjectFacing 7, 0
	Return
	
SaffronCity_PokemonTrainerFanClub_EventScript_MoveMember7ToFarTable:
	MovePerson 7, 7, 5
	SetObjectMovementType 7, 16
	SetObjectFacing 7, 2
	Return
	
SaffronCity_PokemonTrainerFanClub_EventScript_MoveMember8ToFarTable:
	MovePerson 8, 9, 6
	SetObjectMovementType 8, 16
	SetObjectFacing 8, 2
	Return
	
SaffronCity_PokemonTrainerFanClub_EventScript_MoveMember1ToFarTable:
	MovePerson 1, 5, 2
	SetObjectMovementType 1, 14
	SetObjectFacing 1, 0
	Return
	
SaffronCity_PokemonTrainerFanClub_EventScript_MoveMember2ToFarTable:
	MovePerson 3, 7, 4
	SetObjectMovementType 3, 16
	SetObjectFacing 3, 2
	Return
	
SaffronCity_PokemonTrainerFanClub_EventScript_MoveMember3ToFarTable:
	MovePerson 4, 2, 2
	SetObjectMovementType 4, 14
	SetObjectFacing 4, 0
	Return

_cv_stop:
	NPCMsg msg_0971_CV_CANVAS_SAFFRON_FAN_CLUB_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
Common_Movement_WalkInPlaceFasterDown:
	WalkOnSpotFasterSouth
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
SaffronCity_PokemonTrainerFanClub_Movement_FanApproachPlayer:
	Delay16
	Delay8
	WalkNormalSouth
	Delay16
	WalkNormalSouth
	Delay8
	WalkNormalWest
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterRight:
	WalkOnSpotFasterEast
	EndMovement
	.balign 4, 0
