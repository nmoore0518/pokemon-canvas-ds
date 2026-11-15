#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T01.h"
#include "msgdata/msg/msg_0446_T01.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PalletTown_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef _cv_unported_0
	ScrDef PalletTown_EventScript_FatMan
	ScrDef GymFinale_EventScript_CeremonyMom
	ScrDef GymFinale_EventScript_CeremonyDaisy
	ScrDef _cv_unported_4
	ScrDef GymFinale_EventScript_CeremonyLeader
	ScrDef _cv_unported_6
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
	ScrDef _cv_unported_18
	ScrDef _cv_unported_19
	ScrDef PalletTown_OnLoad
	ScrDef PalletTown_OnTransition
	ScrDef _cv_unported_22
	ScrDef _cv_unported_23
	ScrDef _cv_unported_24
	ScrDef DadStory_EventScript_Sendoff
	ScrDef _cv_unported_26
	ScrDefEnd
	
PalletTown_EventScript_SignLady:
	LockAll
	CompareVarToValue 0x5000, 2
	GoToIfEq PalletTown_EventScript_SignLadyDone
	CompareVarToValue 0x5000, 1
	GoToIfEq PalletTown_EventScript_SignLadyJustShowedSign
	CompareVarToValue 0x5001, 1
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
	CompareVarToValue 0x5002, DIR_EAST
	CallIfEq PalletTown_EventScript_SignLadyMoveOutOfWayRight
	CompareVarToValue 0x5002, DIR_EAST
	CallIfNe PalletTown_EventScript_SignLadyMoveOutOfWayLeft
	// TODO(gba) copyobjectxytoperm LOCALID_PALLET_SIGN_LADY
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
	// TODO(gba) waitstate 
	CompareVarToValue 0x5003, ITEM_NONE
	GoToIfEq BerryField_EventScript_End
	// TODO(gba) special BerryField_Plant
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
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PalletTown_EventScript_ChanseyStatueEnd
	GoToIfSet 0x2002, PalletTown_EventScript_ChanseyStatueWish
	NPCMsg msg_0446_T01_PalletTown_Text_ChanseyStatueLegend
	WaitButton
	SetFlag 0x2002
	End
	
PalletTown_OnLoad:
	// TODO(gba) special BerryField_DrawPlots
	CallIfUnset 0x2000, PalletTown_EventScript_LockGymDoor
	End
	
PalletTown_OnTransition:
	// TODO(gba) setworldmapflag FLAG_WORLD_MAP_PALLET_TOWN
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
	// TODO(gba) playbgm MUS_RG_FOLLOW_ME, 0
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
	// TODO(gba) fadescreen FADE_TO_BLACK
	HidePerson 6
	HidePerson 5
	// TODO(gba) fadescreen FADE_FROM_BLACK
	SetVar 0x5004, 5
	SetVar 0x5005, 3
	// TODO(gba) fadedefaultbgm 
	ReleaseAll
	End
	
GymFinale_EventScript_OakAtTheDoor:
	LockAll
	// TODO(gba) setobjectxyperm LOCALID_PALLET_PROF_OAK, PALLET_OAK_RATING_X, PALLET_OAK_RATING_Y
	// TODO(gba) setobjectmovementtype LOCALID_PALLET_PROF_OAK, MOVEMENT_TYPE_FACE_LEFT
	ShowPerson 3
	// TODO(gba) playbgm MUS_RG_OAK, 0
	ApplyMovement 3, PalletTown_Movement_OakWalkToPlayersDoor
	WaitMovement
	BufferPlayersName 6
	NPCMsg msg_0446_T01_GymFinale_Text_OakComeToTheGym
	WaitButton
	CloseMsg
	// TODO(gba) fadescreen FADE_TO_BLACK
	HidePerson 3
	SetFlag 0x2004
	SetVar 0x5005, 3
	// TODO(gba) warp MAP_PALLET_TOWN_GYM, GYM_PC_FRONT_X + 4, GYM_PC_FRONT_Y - 1
	// TODO(gba) waitstate 
	ReleaseAll
	End
	
PalletTown_EventScript_OakRatingScene:
	LockAll
	// TODO(gba) setobjectxyperm LOCALID_PALLET_PROF_OAK, PALLET_OAK_RATING_X, PALLET_OAK_RATING_Y
	// TODO(gba) setobjectmovementtype LOCALID_PALLET_PROF_OAK, MOVEMENT_TYPE_FACE_LEFT
	ShowPerson 3
	ApplyMovement 3, PalletTown_Movement_OakWalkToPlayersDoor
	WaitMovement
	GoToIfUnset 0x2005, PalletTown_EventScript_NotBeenToOneIslandYet
	BufferPlayersName 6
	NPCMsg msg_0446_T01_PalletTown_Text_OakLetMeSeePokedex
	WaitButton
	SetVar 0x8004, 0
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar GetFrlgPokedexCount
	CopyVar 0x8008, 0x8005
	CopyVar 0x8009, 0x8006
	// TODO(gba) buffernumberstring STR_VAR_1, VAR_0x8008
	// TODO(gba) buffernumberstring STR_VAR_2, VAR_0x8009
	CompareVarToValue 0x8009, 60
	GoToIfLt PalletTown_EventScript_NotEnoughMonsForNationalDex
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq PalletTown_EventScript_NotEnoughMonsForNationalDex
	BufferPlayersName 6
	NPCMsg msg_0446_T01_PalletTown_Text_CaughtXImpressiveFollowMe
	WaitButton
	CloseMsg
	// TODO(gba) playbgm MUS_FOLLOW_ME, 0
	ApplyMovement obj_player, PalletTown_Movement_FromHouse_PlayerWalkToLab
	ApplyMovement 3, PalletTown_Movement_FromHouse_OakWalkToLab
	WaitMovement
	// TODO(gba) opendoor PALLET_LAB_DOOR_X, PALLET_LAB_DOOR_Y
	// TODO(gba) waitdooranim 
	ApplyMovement 3, PalletTown_Movement_OakEnterLab
	ApplyMovement obj_player, PalletTown_Movement_FromHouse_PlayerEnterLab
	WaitMovement
	// TODO(gba) closedoor PALLET_LAB_DOOR_X, PALLET_LAB_DOOR_Y
	// TODO(gba) waitdooranim 
	SetVar 0x5006, 7
	SetVar 0x5007, 3
	SetFlag 0x2004
	// TODO(gba) warp MAP_PALLET_TOWN_PROFESSOR_OAKS_LAB, 6, 12
	// TODO(gba) waitstate 
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
	// TODO(gba) getplayerxy VAR_0x8004, VAR_0x8005
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
	// TODO(gba) fadescreen FADE_TO_BLACK
	HidePerson 4
	HidePerson 3
	SetFlag 0x2006
	SetFlag 0x2004
	// TODO(gba) setobjectxyperm LOCALID_PALLET_SENDOFF_MOM, PALLET_MOM_SENDOFF_X, PALLET_MOM_SENDOFF_Y
	// TODO(gba) setobjectmovementtype LOCALID_PALLET_SENDOFF_MOM, MOVEMENT_TYPE_FACE_UP
	// TODO(gba) setobjectxyperm LOCALID_PALLET_PROF_OAK, PALLET_OAK_START_X, PALLET_OAK_START_Y
	// TODO(gba) setobjectmovementtype LOCALID_PALLET_PROF_OAK, MOVEMENT_TYPE_FACE_UP
	// TODO(gba) fadescreen FADE_FROM_BLACK
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
	GoToIfEq _cv_yes_3
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_4
_cv_yes_3:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq BerryField_EventScript_End
	// TODO(gba) special BerryField_PullUp
	BufferPlayersName 6
	NPCMsg msg_0446_T01_BerryField_Text_PulledUp
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
BerryField_EventScript_Ripe:
	// TODO(gba) special BerryField_Harvest
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
	// TODO(gba) giveitem ITEM_LUCKY_EGG
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PalletTown_EventScript_ChanseyStatueEggEnd
	SetFlag 0x2001
	End
	
PalletTown_EventScript_ChanseyStatueEnd:
	ReleaseAll
	End
	
PalletTown_EventScript_ChanseyStatueWish:
	// TODO(gba) special ItemUpgrade_CheckCost
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PalletTown_EventScript_ChanseyStatueMaxed
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq PalletTown_EventScript_ChanseyStatueShort
	NPCMsg msg_0446_T01_PalletTown_Text_ChanseyStatueLeaveClovers
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_5
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_6
_cv_yes_5:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_6:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PalletTown_EventScript_ChanseyStatueEnd
	// TODO(gba) special ItemUpgrade_PayAndUpgrade
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PalletTown_EventScript_ChanseyStatueEnd
	PlayFanfare SEQ_ME_LVUP
	NPCMsg msg_0446_T01_PalletTown_Text_ChanseyStatueEggGlows
	WaitFanfare
	// TODO(gba) special ItemUpgrade_BufferLevel
	NPCMsg msg_0446_T01_PalletTown_Text_ChanseyStatueEggLevel
	WaitButton
	GoTo PalletTown_EventScript_ChanseyStatueEnd
	
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
	// TODO(gba) setobjectxyperm LOCALID_PALLET_SIGN_LADY, PALLET_SIGN_LADY_SIGN_X, PALLET_SIGN_LADY_SIGN_Y
	// TODO(gba) setobjectmovementtype LOCALID_PALLET_SIGN_LADY, MOVEMENT_TYPE_FACE_UP
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
	// TODO(gba) fadescreen FADE_TO_BLACK
	// TODO(gba) warp MAP_PALLET_TOWN, DAD_STORY_MEMORIAL_X, DAD_STORY_MEMORIAL_Y
	// TODO(gba) waitstate 
	ReleaseAll
	End
	
PalletTown_EventScript_SignLadyShowSign:
	NPCMsg msg_0446_T01_PalletTown_Text_LookCopiedTrainerTipsSign
	WaitButton
	CloseMsg
	Wait 20, VAR_SPECIAL_RESULT
	SetFlag 0x200A
	SetVar 0x5000, 1
	SetVar 0x5001, 0
	// TODO(gba) special SetWalkingIntoSignVars
	// TODO(gba) special DisableMsgBoxWalkaway
	// TODO(gba) signmsg 
	NPCMsg msg_0446_T01_PalletTown_Text_PressStartToOpenMenuCopy
	WaitButton
	// TODO(gba) normalmsg 
	Return
	
TypeTutor_EventScript_Intro:
	// TODO(gba) special TypeTutor_BufferIntro
	NPCMsg msg_0446_T01_gStringVar4
	WaitButton
	// TODO(gba) special TypeTutor_SetMet
	// TODO(gba) special TypeTutor_GetState
	End
	
TypeTutor_EventScript_Trial:
	// TODO(gba) special TypeTutor_BufferTrial
	NPCMsg msg_0446_T01_gStringVar4
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TypeTutor_EventScript_JustDone:
	// TODO(gba) special TypeTutor_BufferDone
	NPCMsg msg_0446_T01_gStringVar4
	WaitButton
	// TODO(gba) special TypeTutor_SetOpened
	End
	
TypeTutor_EventScript_Teach:
	CopyVar 0x8004, 0x8008
	NPCMsg msg_0446_T01_TypeTutor_Text_WhichMove
	// TODO(gba) special TypeTutor_PushMoves
	// TODO(gba) dynmultistack 17, 0, FALSE, 6, FALSE, 0, DYN_MULTICHOICE_CB_TYPE_TUTOR
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq TypeTutor_EventScript_Bye
	CopyVar 0x8004, 0x8008
	// TODO(gba) special TypeTutor_SelectMove
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
	
DadStory_EventScript_MemorialSetup:
	ClearFlag 0x2006
	// TODO(gba) setobjectxyperm LOCALID_PALLET_SENDOFF_MOM, DAD_STORY_MEMORIAL_X - 1, DAD_STORY_MEMORIAL_Y
	// TODO(gba) setobjectmovementtype LOCALID_PALLET_SENDOFF_MOM, MOVEMENT_TYPE_FACE_RIGHT
	ClearFlag 0x2004
	// TODO(gba) setobjectxyperm LOCALID_PALLET_PROF_OAK, DAD_STORY_MEMORIAL_X + 1, DAD_STORY_MEMORIAL_Y
	// TODO(gba) setobjectmovementtype LOCALID_PALLET_PROF_OAK, MOVEMENT_TYPE_FACE_LEFT
	Return
	
Common_EventScript_NopReturn:
	Return
	
PalletTown_EventScript_MoveSignLadyToRouteEntrance:
	// TODO(gba) setobjectxyperm LOCALID_PALLET_SIGN_LADY, PALLET_SIGN_LADY_EXIT_X, PALLET_SIGN_LADY_EXIT_Y
	// TODO(gba) setobjectmovementtype LOCALID_PALLET_SIGN_LADY, MOVEMENT_TYPE_FACE_DOWN
	SetVar 0x5001, 1
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
	LockAll
	FacePlayer
	Return

_cv_unported_0:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0446_T01_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_4:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0446_T01_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_6:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0446_T01_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_18:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0446_T01_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_19:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0446_T01_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_22:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0446_T01_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_23:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0446_T01_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_24:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0446_T01_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_26:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
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
GymFinale_Movement_UpTheSteps:
	WalkNormalNorth 3
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
Common_Movement_WalkInPlaceFasterRight:
	WalkOnSpotFasterEast
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
PalletTown_Movement_OakExit:
	WalkNormalEast 5
	WalkNormalNorth 2
	WalkNormalEast 2
	WalkNormalNorth 5
	EndMovement
	.balign 4, 0
