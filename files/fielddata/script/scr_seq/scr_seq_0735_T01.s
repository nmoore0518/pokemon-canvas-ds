#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T01.h"
#include "msgdata/msg/msg_0446_T01.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PalletTown_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef PalletTown_EventScript_SignLady
	ScrDef PalletTown_EventScript_FatMan
	ScrDef GymFinale_EventScript_CeremonyMom
	ScrDef GymFinale_EventScript_CeremonyDaisy
	ScrDef GymFinale_EventScript_CeremonyMentor
	ScrDef GymFinale_EventScript_CeremonyLeader
	ScrDef TypeTutor_EventScript_NormalAttacks
	ScrDef PalletTown_EventScript_OaksLabSign
	ScrDef PalletTown_EventScript_PlayersHouseSign
	ScrDef PalletTown_EventScript_RivalsHouseSign
	ScrDef PalletTown_EventScript_NeighborsHouseSign
	ScrDef PalletTown_EventScript_House2Sign
	ScrDef PalletTown_EventScript_TownSign
	ScrDef PalletTown_EventScript_TrainerTips
	ScrDef PalletTown_EventScript_GymSign
	ScrDef PalletTown_EventScript_TrainingHallSign
	ScrDef PalletTown_EventScript_GymDoorLocked
	ScrDef BerryField_EventScript_Sign
	ScrDef BerryField_EventScript_Plot
	ScrDef PalletTown_EventScript_ChanseyStatue
	ScrDef PalletTown_EventScript_OakTriggerLeft
	ScrDef PalletTown_EventScript_OakTriggerRight
	ScrDef _cv_unported_22
	ScrDef PalletTown_OnLoad
	ScrDef PalletTown_OnTransition
	ScrDef _cv_unported_25
	ScrDef GymFinale_EventScript_OakAtTheDoor
	ScrDef PalletTown_EventScript_OakRatingScene
	ScrDef DadStory_EventScript_Sendoff
	ScrDef DadStory_EventScript_Memorial
	ScrDefEnd
	
PalletTown_EventScript_SignLady:
	LockAll
	CompareVarToValue 0x5000, 2
	GoToIfEq PalletTown_EventScript_SignLadyDone
	CompareVarToValue 0x5000, 1
	GoToIfEq PalletTown_EventScript_SignLadyJustShowedSign
	CompareVarToValue 0x4002, 1
	GoToIfEq PalletTown_EventScript_SignLadyStartShowSign
	GoToIfSet 2, PalletTown_EventScript_SignLadyGoReadSign
	NPCMsg msg_0446_T01_PalletTown_Text_HmmIsThatRight
	WaitButton
	FacePlayer
	WaitMovement
	PlaySE SEQ_SE_DP_SELECT
	ApplyMovement 1, Common_Movement_ExclamationMark
	WaitMovement
	ApplyMovement 1, Common_Movement_Delay48
	WaitMovement
	NPCMsg msg_0446_T01_PalletTown_Text_OhLookLook
	WaitButton
	CloseMsg
	CompareVarToValue 0x5002, 3
	CallIfEq PalletTown_EventScript_SignLadyMoveOutOfWayRight
	CompareVarToValue 0x5002, 3
	CallIfNe PalletTown_EventScript_SignLadyMoveOutOfWayLeft
	GetPersonCoords 1, 0x401E, 0x401F
	MovePerson 1, 0x401E, 0x401F
	SetFlag 2
	ReleaseAll
	End
	
PalletTown_EventScript_FatMan:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0446_T01_PalletTown_Text_CanStoreItemsAndMonsInPC
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymFinale_EventScript_CeremonyMom:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0446_T01_GymFinale_Text_CeremonyMomAfter
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymFinale_EventScript_CeremonyDaisy:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0446_T01_GymFinale_Text_CeremonyDaisyAfter
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymFinale_EventScript_CeremonyMentor:
	LockAll
	FacePlayer
	// TODO(gba) special GymCandidate_SetupCeremony
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymFinale_EventScript_CeremonyLeaderTalk
	NPCMsg msg_0446_T01_GymFinale_Text_CeremonyMentorAfter
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymFinale_EventScript_CeremonyLeader:
	LockAll
	FacePlayer
	End
	
TypeTutor_EventScript_NormalAttacks:
	LockAll
	FacePlayer
	SetVar 0x8004, 0
	GoTo TypeTutor_EventScript_Talk
	
PalletTown_EventScript_OaksLabSign:
	LockAll
	NPCMsg msg_0446_T01_PalletTown_Text_OakPokemonResearchLab
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_EventScript_PlayersHouseSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	BufferPlayersName 6
	NPCMsg msg_0446_T01_PalletTown_Text_PlayersHouse
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_EventScript_RivalsHouseSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	BufferRivalsName 7
	NPCMsg msg_0446_T01_PalletTown_Text_RivalsHouse
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_EventScript_NeighborsHouseSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0446_T01_PalletTown_Text_NeighborsHouse
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_EventScript_House2Sign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0446_T01_PalletTown_Text_House2
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_EventScript_TownSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0446_T01_PalletTown_Text_TownSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_EventScript_TrainerTips:
	LockAll
	NPCMsg msg_0446_T01_PalletTown_Text_PressStartToOpenMenu
	WaitButton
	SetVar 0x5000, 1
	CloseMsg
	ReleaseAll
	End
	
PalletTown_EventScript_GymSign:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar GymChallenge_IsOpen
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq PalletTown_EventScript_GymSignLeader
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0446_T01_PalletTown_Text_GymSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_EventScript_TrainingHallSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0446_T01_PalletTown_Text_TrainingHallSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_EventScript_GymDoorLocked:
	GoToIfSet 0x2000, PalletTown_EventScript_GymDoorOpen
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0446_T01_PalletTown_Text_GymDoorLocked
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
BerryField_EventScript_Sign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0446_T01_BerryField_Text_Sign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
BerryField_EventScript_Plot:
	LockAll
	// TODO(gba) special BerryField_GetFacingPlot
	GoTo _cv_stop
	CompareVarToValue 0x8004, 24
	GoToIfGe BerryField_EventScript_End
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq BerryField_EventScript_Growing
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq BerryField_EventScript_Ripe
	NPCMsg msg_0446_T01_BerryField_Text_Soil
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq BerryField_EventScript_End
	CloseMsg
	// TODO(gba) special Bag_ChooseBerry
	GoTo _cv_stop
	CompareVarToValue 0x5003, ITEM_NONE
	GoToIfEq BerryField_EventScript_End
	// TODO(gba) special BerryField_Plant
	GoTo _cv_stop
	PlaySE SEQ_SE_DP_SELECT
	BufferPlayersName 6
	NPCMsg msg_0446_T01_BerryField_Text_Planted
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_EventScript_ChanseyStatue:
	GoToIfUnset 0x2001, PalletTown_EventScript_ChanseyStatueEgg
	LockAll
	NPCMsg msg_0446_T01_PalletTown_Text_ChanseyStatue
	WaitButton
	SetVar 0x8004, ITEM_LUCKY_EGG
	// TODO(gba) special ItemUpgrade_HasItem
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PalletTown_EventScript_ChanseyStatueEnd
	GoToIfSet 0x2002, PalletTown_EventScript_ChanseyStatueWish
	NPCMsg msg_0446_T01_PalletTown_Text_ChanseyStatueLegend
	WaitButton
	SetFlag 0x2002
	End
	
PalletTown_EventScript_OakTriggerLeft:
	LockAll
	SetVar 0x4001, 0
	GoTo PalletTown_EventScript_OakTrigger
	End
	
PalletTown_EventScript_OakTriggerRight:
	LockAll
	SetVar 0x4001, 1
	GoTo PalletTown_EventScript_OakTrigger
	End
	
PalletTown_EventScript_SignLadyTrigger:
	LockAll
	ApplyMovement 1, Common_Movement_WalkInPlaceFasterRight
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterLeft
	WaitMovement
	Call PalletTown_EventScript_SignLadyShowSign
	ReleaseAll
	End
	
PalletTown_OnLoad:
	// TODO(gba) special BerryField_DrawPlots
	CallIfUnset 0x2000, PalletTown_EventScript_LockGymDoor
	End
	
PalletTown_OnTransition:
	GoToIfSet 0x2059, _cv_new_game_3
	SetFlag 0x2019
	SetFlag 0x2004
	SetFlag 0x205A
	SetFlag 0x205B
	SetFlag 0x205C
	SetFlag 0x205D
	SetFlag 0x205E
	SetFlag 0x205F
	SetFlag 0x2060
	SetFlag 0x2061
	SetFlag 0x2062
	SetFlag 0x2063
	SetFlag 0x2064
	SetFlag 0x2065
	SetFlag 0x2066
	SetFlag 0x2067
	SetFlag 0x2068
	SetFlag 0x2069
	SetFlag 0x206A
	SetFlag 0x206B
	SetFlag 0x206C
	SetFlag 0x206D
	SetFlag 0x206E
	SetFlag 0x206F
	SetFlag 0x2070
	SetFlag 0x2071
	SetFlag 0x2072
	SetFlag 0x2073
	SetFlag 0x2074
	SetFlag 0x2075
	SetFlag 0x2076
	SetFlag 0x2077
	SetFlag 0x2078
	SetFlag 0x2079
	SetFlag 0x207A
	SetFlag 0x207B
	SetFlag 0x207C
	SetFlag 0x207D
	SetFlag 0x207E
	SetFlag 0x207F
	SetFlag 0x2080
	SetFlag 0x2081
	SetFlag 0x2082
	SetFlag 0x2083
	SetFlag 0x203C
	SetFlag 0x2084
	SetFlag 0x2085
	SetFlag 0x2086
	SetFlag 0x2087
	SetVar 0x500E, 500
	SetFlag 0x2059
_cv_new_game_3:
	SetFlag FLAG_SYS_FLYPOINT_PALLET
	Call DadStory_EventScript_PalletTransition
	Call Johto_EventScript_TryInviteWaiting
	Call GymFinale_EventScript_CeremonyTransition
	CallIfSet 0x2003, PalletTown_EventScript_TryReadySignLady
	CompareVarToValue 0x5000, 0
	CallIfEq PalletTown_EventScript_SetSignLadyPos
	CompareVarToValue 0x5000, 1
	CallIfEq PalletTown_EventScript_SetSignLadyDone
	End
	
GymFinale_EventScript_Ceremony:
	LockAll
	PlayBGM SEQ_GS_E_TSURETEKE1
	ApplyMovement obj_player, GymFinale_Movement_UpTheSteps
	WaitMovement
	BufferPlayersName 6
	NPCMsg msg_0446_T01_GymFinale_Text_CeremonyMomHere
	WaitButton
	CloseMsg
	ApplyMovement 7, Common_Movement_WalkInPlaceFasterUp
	ApplyMovement 8, Common_Movement_WalkInPlaceFasterUp
	ApplyMovement 9, Common_Movement_WalkInPlaceFasterUp
	ApplyMovement 10, Common_Movement_WalkInPlaceFasterUp
	ApplyMovement 11, Common_Movement_WalkInPlaceFasterUp
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	NPCMsg msg_0446_T01_GymFinale_Text_CeremonyOfficial1
	WaitButton
	BufferPlayersName 6
	NPCMsg msg_0446_T01_GymFinale_Text_CeremonyOfficial2
	WaitButton
	CloseMsg
	PlaySE SEQ_SE_DP_SELECT
	ApplyMovement 7, Common_Movement_ExclamationMark
	ApplyMovement 8, Common_Movement_ExclamationMark
	ApplyMovement 9, Common_Movement_ExclamationMark
	ApplyMovement 10, Common_Movement_ExclamationMark
	ApplyMovement 11, Common_Movement_ExclamationMark
	WaitMovement
	WaitSE SEQ_SE_DP_SELECT
	BufferPlayersName 6
	NPCMsg msg_0446_T01_GymFinale_Text_CeremonyOfficial3
	WaitButton
	CloseMsg
	PlayFanfare SEQ_ME_BADGE
	WaitFanfare
	// TODO(gba) special GymCandidate_SetupCeremony
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq GymFinale_EventScript_CeremonyMentorSpeaks
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterLeft
	ApplyMovement 7, Common_Movement_WalkInPlaceFasterRight
	ApplyMovement 8, Common_Movement_WalkInPlaceFasterRight
	WaitMovement
	BufferPlayersName 6
	NPCMsg msg_0446_T01_GymFinale_Text_CeremonyMomProud
	WaitButton
	BufferPlayersName 6
	NPCMsg msg_0446_T01_GymFinale_Text_CeremonyDaisyWheresGrandpa
	WaitButton
	CloseMsg
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	NPCMsg msg_0446_T01_GymFinale_Text_CeremonyOfficialGoIn
	WaitButton
	CloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	HidePerson 6
	HidePerson 5
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	SetVar 0x5004, 5
	SetVar 0x5005, 3
	ResetBGM
	ReleaseAll
	End
	
GymFinale_EventScript_OakAtTheDoor:
	LockAll
	MovePerson 3, 1032, 395
	SetObjectMovementType 3, 16
	SetObjectFacing 3, 2
	ShowPerson 3
	PlayBGM SEQ_GS_OHKIDO
	ApplyMovement 3, PalletTown_Movement_OakWalkToPlayersDoor
	WaitMovement
	BufferPlayersName 6
	NPCMsg msg_0446_T01_GymFinale_Text_OakComeToTheGym
	WaitButton
	CloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	HidePerson 3
	SetFlag 0x2004
	SetVar 0x5005, 3
	Warp MAP_FIGHT_AREA_UNUSED_7, 0, 12, 25, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	ReleaseAll
	End
	
PalletTown_EventScript_OakRatingScene:
	LockAll
	MovePerson 3, 1032, 395
	SetObjectMovementType 3, 16
	SetObjectFacing 3, 2
	ShowPerson 3
	ApplyMovement 3, PalletTown_Movement_OakWalkToPlayersDoor
	WaitMovement
	GoToIfUnset 0x2005, PalletTown_EventScript_NotBeenToOneIslandYet
	BufferPlayersName 6
	NPCMsg msg_0446_T01_PalletTown_Text_OakLetMeSeePokedex
	WaitButton
	SetVar 0x8004, 0
	CountNationalDexSeen 0x8005
	CountNationalDexOwned 0x8006
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x2026, _cv_dex_4
	SetVar VAR_SPECIAL_RESULT, 1
_cv_dex_4:
	CopyVar 0x8008, 0x8005
	CopyVar 0x8009, 0x8006
	BufferInt 0, 0x8008
	BufferInt 1, 0x8009
	CompareVarToValue 0x8009, 60
	GoToIfLt PalletTown_EventScript_NotEnoughMonsForNationalDex
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq PalletTown_EventScript_NotEnoughMonsForNationalDex
	BufferPlayersName 6
	NPCMsg msg_0446_T01_PalletTown_Text_CaughtXImpressiveFollowMe
	WaitButton
	CloseMsg
	PlayBGM SEQ_GS_E_TSURETEKE1
	ApplyMovement obj_player, PalletTown_Movement_FromHouse_PlayerWalkToLab
	ApplyMovement 3, PalletTown_Movement_FromHouse_OakWalkToLab
	WaitMovement
	ApplyMovement 3, PalletTown_Movement_OakEnterLab
	ApplyMovement obj_player, PalletTown_Movement_FromHouse_PlayerEnterLab
	WaitMovement
	SetVar 0x5006, 7
	SetVar 0x5007, 3
	SetFlag 0x2004
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	Warp MAP_PALLET_TOWN_OAKS_LAB, 0, 6, 12, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	ReleaseAll
	End
	
DadStory_EventScript_Sendoff:
	LockAll
	ApplyMovement 4, PalletTown_Movement_MomSendoffApproach
	WaitMovement
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	BufferPlayersName 6
	NPCMsg msg_0446_T01_DadStory_Text_MomSendoff
	WaitButton
	CloseMsg
	ApplyMovement 4, PalletTown_Movement_MomSendoffGoHome
	WaitMovement
	HidePerson 4
	SetFlag 0x2006
	SetVar 0x5008, 2
	ReleaseAll
	End
	
DadStory_EventScript_Memorial:
	LockAll
	GetPlayerCoords 0x8004, 0x8005
	SubVar 0x8004, 1019
	SubVar 0x8005, 352
	CompareVarToValue 0x8004, 42
	GoToIfNe DadStory_EventScript_MemorialGoThere
	CompareVarToValue 0x8005, 8
	GoToIfNe DadStory_EventScript_MemorialGoThere
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	Wait 30, VAR_SPECIAL_RESULT
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterRight
	WaitMovement
	BufferPlayersName 6
	NPCMsg msg_0446_T01_DadStory_Text_MemorialOak1
	WaitButton
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterLeft
	WaitMovement
	NPCMsg msg_0446_T01_DadStory_Text_MemorialMom1
	WaitButton
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterRight
	WaitMovement
	BufferPlayersName 6
	NPCMsg msg_0446_T01_DadStory_Text_MemorialOak2
	WaitButton
	NPCMsg msg_0446_T01_DadStory_Text_MemorialMom2
	WaitButton
	BufferPlayersName 6
	NPCMsg msg_0446_T01_DadStory_Text_MemorialOak3
	WaitButton
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterLeft
	WaitMovement
	NPCMsg msg_0446_T01_DadStory_Text_MemorialMom3
	WaitButton
	CloseMsg
	SetFlag 0x2007
	SetVar 0x5008, 9
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	HidePerson 4
	HidePerson 3
	SetFlag 0x2006
	SetFlag 0x2004
	MovePerson 4, 1057, 382
	SetObjectMovementType 4, 14
	SetObjectFacing 4, 0
	MovePerson 3, 1040, 365
	SetObjectMovementType 3, 14
	SetObjectFacing 3, 0
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	ReleaseAll
	End
	
PalletTown_EventScript_SignLadyDone:
	FacePlayer
	WaitMovement
	NPCMsg msg_0446_T01_PalletTown_Text_RaisingMonsToo
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_EventScript_SignLadyJustShowedSign:
	FacePlayer
	WaitMovement
	NPCMsg msg_0446_T01_PalletTown_Text_SignsAreUsefulArentThey
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_EventScript_SignLadyStartShowSign:
	FacePlayer
	WaitMovement
	Call PalletTown_EventScript_SignLadyShowSign
	ReleaseAll
	End
	
PalletTown_EventScript_SignLadyGoReadSign:
	FacePlayer
	WaitMovement
	NPCMsg msg_0446_T01_PalletTown_Text_ReadItReadIt
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_EventScript_SignLadyMoveOutOfWayRight:
	ApplyMovement 1, PalletTown_Movement_SignLadyMoveOutOfWayRight
	WaitMovement
	Return
	
PalletTown_EventScript_SignLadyMoveOutOfWayLeft:
	ApplyMovement 1, PalletTown_Movement_SignLadyMoveOutOfWayLeft
	WaitMovement
	Return
	
GymFinale_EventScript_CeremonyLeaderTalk:
	BufferPlayersName 6
	NPCMsg msg_0446_T01_GymFinale_Text_CeremonyLeaderAfter
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
	
PalletTown_EventScript_GymSignLeader:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	BufferPlayersName 6
	NPCMsg msg_0446_T01_PalletTown_Text_GymSignLeader
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_EventScript_GymDoorOpen:
	End
	
BerryField_EventScript_End:
	CloseMsg
	ReleaseAll
	End
	
BerryField_EventScript_Growing:
	NPCMsg msg_0446_T01_BerryField_Text_Growing
	WaitButton
	NPCMsg msg_0446_T01_BerryField_Text_PullUp
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_5
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_6
_cv_yes_5:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_6:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq BerryField_EventScript_End
	// TODO(gba) special BerryField_PullUp
	GoTo _cv_stop
	BufferPlayersName 6
	NPCMsg msg_0446_T01_BerryField_Text_PulledUp
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
BerryField_EventScript_Ripe:
	// TODO(gba) special BerryField_Harvest
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq BerryField_EventScript_BagFull
	PlayFanfare SEQ_ME_ITEM
	BufferPlayersName 6
	NPCMsg msg_0446_T01_BerryField_Text_Picked
	WaitButton
	WaitFanfare
	CloseMsg
	ReleaseAll
	End
	
PalletTown_EventScript_ChanseyStatueEgg:
	LockAll
	NPCMsg msg_0446_T01_PalletTown_Text_ChanseyStatue
	WaitButton
	NPCMsg msg_0446_T01_PalletTown_Text_ChanseyStatueEgg
	WaitButton
	GiveItem ITEM_LUCKY_EGG, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PalletTown_EventScript_ChanseyStatueEggEnd
	SetFlag 0x2001
	End
	
PalletTown_EventScript_ChanseyStatueEnd:
	ReleaseAll
	End
	
PalletTown_EventScript_ChanseyStatueWish:
	// TODO(gba) special ItemUpgrade_CheckCost
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PalletTown_EventScript_ChanseyStatueMaxed
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PalletTown_EventScript_ChanseyStatueShort
	NPCMsg msg_0446_T01_PalletTown_Text_ChanseyStatueLeaveClovers
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_7
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_8
_cv_yes_7:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_8:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PalletTown_EventScript_ChanseyStatueEnd
	// TODO(gba) special ItemUpgrade_PayAndUpgrade
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PalletTown_EventScript_ChanseyStatueEnd
	PlayFanfare SEQ_ME_LVUP
	NPCMsg msg_0446_T01_PalletTown_Text_ChanseyStatueEggGlows
	WaitFanfare
	// TODO(gba) special ItemUpgrade_BufferLevel
	GoTo _cv_stop
	NPCMsg msg_0446_T01_PalletTown_Text_ChanseyStatueEggLevel
	WaitButton
	GoTo PalletTown_EventScript_ChanseyStatueEnd
	
PalletTown_EventScript_OakTrigger:
	Wait 30, VAR_SPECIAL_RESULT
	PlayBGM SEQ_GS_OHKIDO
	NPCMsg msg_0446_T01_PalletTown_Text_OakDontGoOut
	Wait 85, VAR_SPECIAL_RESULT
	CloseMsg
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	PlaySE SEQ_SE_DP_SELECT
	ApplyMovement obj_player, Common_Movement_ExclamationMark
	WaitMovement
	Wait 30, VAR_SPECIAL_RESULT
	ShowPerson 3
	CompareVarToValue 0x4001, 0
	CallIfEq PalletTown_EventScript_OakEnterLeft
	CompareVarToValue 0x4001, 1
	CallIfEq PalletTown_EventScript_OakEnterRight
	Wait 30, VAR_SPECIAL_RESULT
	NPCMsg msg_0446_T01_PalletTown_Text_OakGrassUnsafeNeedMon
	WaitButton
	CloseMsg
	Wait 30, VAR_SPECIAL_RESULT
	CompareVarToValue 0x4001, 0
	CallIfEq PalletTown_EventScript_OakLeadPlayerToLabLeft
	CompareVarToValue 0x4001, 1
	CallIfEq PalletTown_EventScript_OakLeadPlayerToLabRight
	ApplyMovement 3, PalletTown_Movement_OakEnterLab
	CompareVarToValue 0x4001, 0
	CallIfEq PalletTown_EventScript_PlayerEnterLabLeft
	CompareVarToValue 0x4001, 1
	CallIfEq PalletTown_EventScript_PlayerEnterLabRight
	WaitMovement
	SetVar 0x5006, 1
	ClearFlag 0x2019
	SetVar 0x5007, 1
	SetFlag 0x2004
	SetFlag 0x201A
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	Warp MAP_PALLET_TOWN_OAKS_LAB, 0, 6, 12, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	ReleaseAll
	End
	
PalletTown_EventScript_SignLadyShowSign:
	NPCMsg msg_0446_T01_PalletTown_Text_LookCopiedTrainerTipsSign
	WaitButton
	CloseMsg
	Wait 20, VAR_SPECIAL_RESULT
	SetFlag 0x200A
	SetVar 0x5000, 1
	SetVar 0x4002, 0
	// TODO(gba) special SetWalkingIntoSignVars
	GoTo _cv_stop
	// TODO(gba) special DisableMsgBoxWalkaway
	GoTo _cv_stop
	NPCMsg msg_0446_T01_PalletTown_Text_PressStartToOpenMenuCopy
	WaitButton
	Return
	
PalletTown_EventScript_LockGymDoor:
	// TODO(gba) setmetatile PALLET_GYM_DOOR_X, PALLET_GYM_DOOR_Y, METATILE_PALLET_GYM_DOOR_LOCKED, TRUE
	Return
	
DadStory_EventScript_PalletTransition:
	SetFlag 0x2006
	CompareVarToValue 0x5008, 8
	GoToIfEq DadStory_EventScript_MemorialSetup
	CompareVarToValue 0x5008, 1
	GoToIfNe Common_EventScript_NopReturn
	ClearFlag 0x2006
	Return
	
Johto_EventScript_TryInviteWaiting:
	GoToIfUnset 0x2008, Common_EventScript_NopReturn
	CompareVarToValue 0x5009, 0
	GoToIfNe Common_EventScript_NopReturn
	CompareVarToValue 0x5005, 4
	GoToIfEq Common_EventScript_NopReturn
	SetVar 0x5009, 1
	Return
	
GymFinale_EventScript_CeremonyTransition:
	SetFlag 0x2009
	CompareVarToValue 0x5004, 4
	GoToIfNe Common_EventScript_NopReturn
	ClearFlag 0x2009
	// TODO(gba) special GymCandidate_SetupCeremony
	Return
	
PalletTown_EventScript_TryReadySignLady:
	GoToIfUnset 0x200A, Common_EventScript_NopReturn
	CompareVarToValue 0x5000, 1
	GoToIfGe Common_EventScript_NopReturn
	SetVar 0x5000, 1
	Return
	
PalletTown_EventScript_SetSignLadyPos:
	GoToIfSet 0x2003, PalletTown_EventScript_MoveSignLadyToRouteEntrance
	MovePerson 1, 1035, 381
	SetObjectMovementType 1, 14
	SetObjectFacing 1, 0
	Return
	
PalletTown_EventScript_SetSignLadyDone:
	SetVar 0x5000, 2
	Return
	
GymFinale_EventScript_CeremonyMentorSpeaks:
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterRight
	ApplyMovement 9, Common_Movement_WalkInPlaceFasterLeft
	WaitMovement
	NPCMsg msg_0446_T01_GymFinale_Text_CeremonyMentor
	WaitButton
	CloseMsg
	Return
	
PalletTown_EventScript_NotBeenToOneIslandYet:
	BufferPlayersName 6
	NPCMsg msg_0446_T01_PalletTown_Text_OakYouEnjoyingTraveling
	WaitButton
	GoTo PalletTown_EventScript_EndOakRatingScene
	CloseMsg
	End
	
PalletTown_EventScript_NotEnoughMonsForNationalDex:
	NPCMsg msg_0446_T01_PalletTown_Text_CaughtXPuttingInHonestEffort
	WaitButton
	GoTo PalletTown_EventScript_EndOakRatingScene
	CloseMsg
	End
	
DadStory_EventScript_MemorialGoThere:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	Warp MAP_PALLET, 0, 1061, 360, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	ReleaseAll
	End
	
TypeTutor_EventScript_Intro:
	// TODO(gba) special TypeTutor_BufferIntro
	GoTo _cv_stop
	NPCMsg msg_0446_T01_gStringVar4
	WaitButton
	// TODO(gba) special TypeTutor_SetMet
	GoTo _cv_stop
	// TODO(gba) special TypeTutor_GetState
	GoTo _cv_stop
	End
	
TypeTutor_EventScript_Trial:
	// TODO(gba) special TypeTutor_BufferTrial
	GoTo _cv_stop
	NPCMsg msg_0446_T01_gStringVar4
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TypeTutor_EventScript_JustDone:
	// TODO(gba) special TypeTutor_BufferDone
	GoTo _cv_stop
	NPCMsg msg_0446_T01_gStringVar4
	WaitButton
	// TODO(gba) special TypeTutor_SetOpened
	GoTo _cv_stop
	End
	
TypeTutor_EventScript_Teach:
	CopyVar 0x8004, 0x8008
	NPCMsg msg_0446_T01_TypeTutor_Text_WhichMove
	// TODO(gba) special TypeTutor_PushMoves
	GoTo _cv_stop
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_10
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_10:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq TypeTutor_EventScript_Bye
	CopyVar 0x8004, 0x8008
	// TODO(gba) special TypeTutor_SelectMove
	GoTo _cv_stop
	NPCMsg msg_0446_T01_TypeTutor_Text_WhichMon
	WaitButton
	Call EventScript_ChooseMoveTutorMon
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TypeTutor_EventScript_Teach
	NPCMsg msg_0446_T01_TypeTutor_Text_Taught
	WaitButton
	GoTo TypeTutor_EventScript_Teach
	
BerryField_EventScript_BagFull:
	NPCMsg msg_0446_T01_BerryField_Text_BagFull
	WaitButton
	End
	
PalletTown_EventScript_ChanseyStatueEggEnd:
	ReleaseAll
	End
	
PalletTown_EventScript_ChanseyStatueMaxed:
	NPCMsg msg_0446_T01_PalletTown_Text_ChanseyStatueMaxed
	WaitButton
	End
	
PalletTown_EventScript_ChanseyStatueShort:
	NPCMsg msg_0446_T01_PalletTown_Text_ChanseyStatueShort
	WaitButton
	GoTo PalletTown_EventScript_ChanseyStatueEnd
	
PalletTown_EventScript_OakEnterLeft:
	ApplyMovement 3, PalletTown_Movement_OakEnterLeft
	WaitMovement
	Return
	
PalletTown_EventScript_OakEnterRight:
	ApplyMovement 3, PalletTown_Movement_OakEnterRight
	WaitMovement
	Return
	
PalletTown_EventScript_OakLeadPlayerToLabLeft:
	ApplyMovement 3, PalletTown_Movement_Left_OakWalkToLab
	ApplyMovement obj_player, PalletTown_Movement_Left_PlayerWalkToLab
	WaitMovement
	Return
	
PalletTown_EventScript_OakLeadPlayerToLabRight:
	ApplyMovement 3, PalletTown_Movement_Right_OakWalkToLab
	ApplyMovement obj_player, PalletTown_Movement_Right_PlayerWalkToLab
	WaitMovement
	Return
	
PalletTown_EventScript_PlayerEnterLabLeft:
	ApplyMovement obj_player, PalletTown_Movement_Left_PlayerEnterLab
	Return
	
PalletTown_EventScript_PlayerEnterLabRight:
	ApplyMovement obj_player, PalletTown_Movement_Right_PlayerEnterLab
	Return
	
DadStory_EventScript_MemorialSetup:
	ClearFlag 0x2006
	MovePerson 4, 1060, 360
	SetObjectMovementType 4, 17
	SetObjectFacing 4, 3
	ClearFlag 0x2004
	MovePerson 3, 1062, 360
	SetObjectMovementType 3, 16
	SetObjectFacing 3, 2
	Return
	
Common_EventScript_NopReturn:
	Return
	
PalletTown_EventScript_MoveSignLadyToRouteEntrance:
	MovePerson 1, 1039, 354
	SetObjectMovementType 1, 15
	SetObjectFacing 1, 1
	SetVar 0x4002, 1
	Return
	
PalletTown_EventScript_EndOakRatingScene:
	CloseMsg
	ApplyMovement 3, PalletTown_Movement_OakExit
	WaitMovement
	HidePerson 3
	SetVar 0x5007, 3
	ReleaseAll
	End
	
TypeTutor_EventScript_Bye:
	NPCMsg msg_0446_T01_TypeTutor_Text_Bye
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

_cv_unported_22:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0446_T01_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_25:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0446_T01_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0446_T01_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
Common_Movement_ExclamationMark:
	EmoteExclamationMark
	EndMovement

	.balign 4, 0
Common_Movement_Delay48:
	Delay16 3
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
GymFinale_Movement_UpTheSteps:
	WalkNormalNorth 3
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterUp:
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
PalletTown_Movement_OakWalkToPlayersDoor:
	WalkNormalSouth 5
	WalkNormalWest 2
	WalkNormalSouth 2
	WalkNormalWest 5
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
PalletTown_Movement_FromHouse_PlayerWalkToLab:
	WalkNormalSouth
	WalkNormalNorth
	WalkNormalEast 5
	WalkNormalNorth 6
	WalkNormalEast
	WalkNormalNorth 11
	WalkNormalEast 26
	WalkNormalNorth 3
	EndMovement

	.balign 4, 0
PalletTown_Movement_FromHouse_OakWalkToLab:
	WalkNormalNorth
	WalkNormalEast 5
	WalkNormalNorth 6
	WalkNormalEast
	WalkNormalNorth 11
	WalkNormalEast 26
	WalkNormalNorth 4
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
PalletTown_Movement_OakEnterLab:
	WalkNormalNorth
	SetInvisible
	EndMovement

	.balign 4, 0
PalletTown_Movement_FromHouse_PlayerEnterLab:
	WalkNormalNorth 2
	SetInvisible
	EndMovement

	.balign 4, 0
PalletTown_Movement_MomSendoffApproach:
	WalkNormalNorth
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterDown:
	WalkOnSpotFasterSouth
	EndMovement

	.balign 4, 0
PalletTown_Movement_MomSendoffGoHome:
	WalkNormalSouth 3
	WalkNormalWest 8
	EndMovement

	.balign 4, 0
PalletTown_Movement_SignLadyMoveOutOfWayRight:
	WalkNormalEast
	WalkOnSpotFasterWest
	EndMovement

	.balign 4, 0
PalletTown_Movement_SignLadyMoveOutOfWayLeft:
	WalkNormalWest
	WalkOnSpotFasterEast
	EndMovement

	.balign 4, 0
PalletTown_Movement_OakEnterLeft:
	WalkNormalNorth 11
	WalkNormalWest
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
PalletTown_Movement_OakEnterRight:
	WalkNormalNorth 11
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
PalletTown_Movement_Left_OakWalkToLab:
	WalkNormalSouth 13
	WalkNormalEast 7
	WalkNormalSouth 17
	WalkNormalEast 11
	WalkNormalNorth 4
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
PalletTown_Movement_Left_PlayerWalkToLab:
	WalkNormalSouth 14
	WalkNormalEast 7
	WalkNormalSouth 17
	WalkNormalEast 11
	WalkNormalNorth 3
	EndMovement

	.balign 4, 0
PalletTown_Movement_Right_OakWalkToLab:
	WalkNormalSouth 13
	WalkNormalEast 6
	WalkNormalSouth 17
	WalkNormalEast 11
	WalkNormalNorth 4
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
PalletTown_Movement_Right_PlayerWalkToLab:
	WalkNormalSouth 14
	WalkNormalEast 6
	WalkNormalSouth 17
	WalkNormalEast 11
	WalkNormalNorth 3
	EndMovement

	.balign 4, 0
PalletTown_Movement_Left_PlayerEnterLab:
	WalkNormalNorth 2
	SetInvisible
	EndMovement

	.balign 4, 0
PalletTown_Movement_Right_PlayerEnterLab:
	WalkNormalNorth 2
	SetInvisible
	EndMovement

	.balign 4, 0
PalletTown_Movement_OakExit:
	WalkNormalEast 5
	WalkNormalNorth 2
	WalkNormalEast 2
	WalkNormalNorth 5
	EndMovement
	.balign 4, 0
