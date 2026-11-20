#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T03R0101.h"
#include "msgdata/msg/msg_0464_T03R0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PewterCity_Museum_1F_Frlg+PewterCity_Museum_2F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef PewterCity_Museum_1F_EventScript_Scientist1
	ScrDef PewterCity_Museum_1F_EventScript_OldMan
	ScrDef PewterCity_Museum_1F_EventScript_OldAmberScientist
	ScrDef PewterCity_Museum_1F_EventScript_OldAmber
	ScrDef PewterCity_Museum_1F_EventScript_Scientist2
	ScrDef PewterCity_Museum_1F_EventScript_SeismicTossTutor
	ScrDef PewterCity_Museum_2F_EventScript_Scientist
	ScrDef PewterCity_Museum_2F_EventScript_Man
	ScrDef PewterCity_Museum_2F_EventScript_OldMan
	ScrDef PewterCity_Museum_2F_EventScript_LittleGirl
	ScrDef PewterCity_Museum_2F_EventScript_BaldingMan
	ScrDef PewterCity_Museum_1F_EventScript_AerodactylFossil
	ScrDef PewterCity_Museum_1F_EventScript_KabutopsFossil
	ScrDef PewterCity_Museum_1F_EventScript_PokemonJournalBrock
	ScrDef PewterCity_Museum_2F_EventScript_MoonStone
	ScrDef PewterCity_Museum_2F_EventScript_SpaceShuttle
	ScrDef PewterCity_Museum_1F_EventScript_EntranceTriggerLeft
	ScrDef PewterCity_Museum_1F_EventScript_EntranceTriggerMid
	ScrDef PewterCity_Museum_1F_EventScript_EntranceTriggerRight
	ScrDefEnd
	
PewterCity_Museum_1F_EventScript_Scientist1:
	LockAll
	FacePlayer
	CompareVarToValue 0x5002, 2
	GoToIfEq PewterCity_Museum_1F_EventScript_Scientist1BehindCounter
	CompareVarToValue 0x5002, 1
	GoToIfEq PewterCity_Museum_1F_EventScript_Scientist1BehindCounter
	CompareVarToValue 0x5002, 0
	GoToIfEq PewterCity_Museum_1F_EventScript_Scientist1BehindCounter
	NPCMsg msg_0464_T03R0101_PewterCity_Museum_1F_Text_PleaseEnjoyYourself
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_Museum_1F_EventScript_OldMan:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0464_T03R0101_PewterCity_Museum_1F_Text_ShouldBeGratefulForLongLife
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_Museum_1F_EventScript_OldAmberScientist:
	LockAll
	FacePlayer
	GoToIfSet 0x20BA, PewterCity_Museum_1F_EventScript_AlreadyGotOldAmber
	NPCMsg msg_0464_T03R0101_PewterCity_Museum_1F_Text_WantYouToGetAmberExamined
	WaitButton
	HasSpaceForItem ITEM_OLD_AMBER, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PewterCity_Museum_1F_EventScript_NoRoomForOldAmber
	SetFlag 0x20BA
	HidePerson 4
	SetFlag 0x20BB
	GiveItem ITEM_OLD_AMBER, 1, VAR_SPECIAL_RESULT
	BufferItemName 1, ITEM_OLD_AMBER
	BufferPlayersName 6
	NPCMsg msg_0464_T03R0101_PewterCity_Museum_1F_Text_ReceivedOldAmberFromMan
	PlayFanfare SEQ_ME_ITEM
	WaitFanfare
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_Museum_1F_EventScript_OldAmber:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0464_T03R0101_PewterCity_Museum_1F_Text_BeautifulPieceOfAmber
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_Museum_1F_EventScript_Scientist2:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0464_T03R0101_PewterCity_Museum_1F_Text_WeHaveTwoFossilsOnExhibit
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_Museum_1F_EventScript_SeismicTossTutor:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0464_T03R0101_PewterCity_Museum_1F_Text_SeismicTossTutor_Retired
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_Museum_2F_EventScript_Scientist:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0464_T03R0101_PewterCity_Museum_1F_Text_RunningSpaceExhibitThisMonth
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_Museum_2F_EventScript_Man:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0464_T03R0101_PewterCity_Museum_1F_Text_WhatsSpecialAboutMoonStone
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_Museum_2F_EventScript_OldMan:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0464_T03R0101_PewterCity_Museum_1F_Text_BoughtColorTVForMoonLanding
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_Museum_2F_EventScript_LittleGirl:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0464_T03R0101_PewterCity_Museum_1F_Text_AskedDaddyToCatchPikachu
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_Museum_2F_EventScript_BaldingMan:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0464_T03R0101_PewterCity_Museum_1F_Text_PikachuSoonIPromise
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_Museum_1F_EventScript_AerodactylFossil:
	LockAll
	SetVar 0x8004, SPECIES_AERODACTYL
	SetVar 0x8005, 10
	SetVar 0x8006, 3
	NPCMsg msg_0464_T03R0101_PewterCity_Museum_1F_Text_AerodactylFossil
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_Museum_1F_EventScript_KabutopsFossil:
	LockAll
	SetVar 0x8004, SPECIES_KABUTOPS
	SetVar 0x8005, 10
	SetVar 0x8006, 3
	NPCMsg msg_0464_T03R0101_PewterCity_Museum_1F_Text_KabutopsFossil
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_Museum_1F_EventScript_PokemonJournalBrock:
	LockAll
	NPCMsg msg_0464_T03R0101_PokemonJournal_Text_SpecialFeatureBrock
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_Museum_2F_EventScript_MoonStone:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0464_T03R0101_PewterCity_Museum_1F_Text_MeteoriteThatFellOnMtMoon
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_Museum_2F_EventScript_SpaceShuttle:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0464_T03R0101_PewterCity_Museum_1F_Text_SpaceShuttle
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_Museum_1F_EventScript_EntranceTriggerLeft:
	LockAll
	SetVar 0x4001, 0
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterRight
	WaitMovement
	GoTo PewterCity_Museum_1F_EventScript_EntranceTrigger
	End
	
PewterCity_Museum_1F_EventScript_EntranceTriggerMid:
	LockAll
	SetVar 0x4001, 1
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterRight
	WaitMovement
	GoTo PewterCity_Museum_1F_EventScript_EntranceTrigger
	End
	
PewterCity_Museum_1F_EventScript_EntranceTriggerRight:
	LockAll
	SetVar 0x4001, 2
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterRight
	WaitMovement
	GoTo PewterCity_Museum_1F_EventScript_EntranceTrigger
	End
	
PewterCity_Museum_1F_EventScript_Scientist1BehindCounter:
	NPCMsg msg_0464_T03R0101_PewterCity_Museum_1F_Text_DoYouKnowWhatAmberIs
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq PewterCity_Museum_1F_EventScript_AmberHasGeneticMatter
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PewterCity_Museum_1F_EventScript_ExplainAmber
	CloseMsg
	End
	
PewterCity_Museum_1F_EventScript_AlreadyGotOldAmber:
	NPCMsg msg_0464_T03R0101_PewterCity_Museum_1F_Text_GetOldAmberChecked
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_Museum_1F_EventScript_NoRoomForOldAmber:
	NPCMsg msg_0464_T03R0101_PewterCity_Museum_1F_Text_DontHaveSpaceForThis
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_Museum_1F_EventScript_EntranceTrigger:
	ShowMoneyBox 20, 2
	NPCMsg msg_0464_T03R0101_PewterCity_Museum_1F_Text_Its50YForChildsTicket
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_3
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_4
_cv_yes_3:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq PewterCity_Museum_1F_EventScript_TryPayForTicket
	NPCMsg msg_0464_T03R0101_PewterCity_Museum_1F_Text_ComeAgain
	WaitButton
	CloseMsg
	HideMoneyBox
	ApplyMovement obj_player, PewterCity_Museum_1F_Movement_ForcePlayerExit
	WaitMovement
	ReleaseAll
	End
	
PewterCity_Museum_1F_EventScript_AmberHasGeneticMatter:
	NPCMsg msg_0464_T03R0101_PewterCity_Museum_1F_Text_AmberContainsGeneticMatter
	WaitButton
	ApplyMovement 1, Common_Movement_FaceOriginalDirection
	WaitMovement
	CloseMsg
	ReleaseAll
	End
	
PewterCity_Museum_1F_EventScript_ExplainAmber:
	NPCMsg msg_0464_T03R0101_PewterCity_Museum_1F_Text_AmberIsFossilizedSap
	WaitButton
	ApplyMovement 1, Common_Movement_FaceOriginalDirection
	WaitMovement
	CloseMsg
	ReleaseAll
	End
	
PewterCity_Museum_1F_EventScript_TryPayForTicket:
	HasEnoughMoneyImmediate VAR_SPECIAL_RESULT, 50
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PewterCity_Museum_1F_EventScript_NotEnoughMoney
	CloseMsg
	CompareVarToValue 0x4001, 0
	CallIfEq PewterCity_Museum_1F_EventScript_PlayerApproachCounterLeft
	CompareVarToValue 0x4001, 1
	CallIfEq PewterCity_Museum_1F_EventScript_PlayerApproachCounterMid
	CompareVarToValue 0x4001, 2
	CallIfEq PewterCity_Museum_1F_EventScript_PlayerApproachCounterRight
	PlaySE SEQ_SE_DP_SELECT
	SubMoneyImmediate 50
	UpdateMoneyBox
	WaitSE SEQ_SE_DP_SELECT
	NPCMsg msg_0464_T03R0101_PewterCity_Museum_1F_Text_Right50YThankYou
	WaitButton
	SetVar 0x5021, 1
	HideMoneyBox
	CloseMsg
	ReleaseAll
	End
	
PewterCity_Museum_1F_EventScript_NotEnoughMoney:
	NPCMsg msg_0464_T03R0101_PewterCity_Museum_1F_Text_DontHaveEnoughMoney
	WaitButton
	CloseMsg
	HideMoneyBox
	ApplyMovement obj_player, PewterCity_Museum_1F_Movement_ForcePlayerExit
	WaitMovement
	ReleaseAll
	End
	
PewterCity_Museum_1F_EventScript_PlayerApproachCounterLeft:
	ApplyMovement obj_player, PewterCity_Museum_1F_Movement_ApproachCounterLeft
	WaitMovement
	Return
	
PewterCity_Museum_1F_EventScript_PlayerApproachCounterMid:
	ApplyMovement obj_player, PewterCity_Museum_1F_Movement_ApproachCounterMid
	WaitMovement
	Return
	
PewterCity_Museum_1F_EventScript_PlayerApproachCounterRight:
	ApplyMovement obj_player, PewterCity_Museum_1F_Movement_ApproachCounterRight
	WaitMovement
	Return

_cv_stop:
	NPCMsg msg_0464_T03R0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
Common_Movement_WalkInPlaceFasterRight:
	WalkOnSpotFasterEast
	EndMovement

	.balign 4, 0
PewterCity_Museum_1F_Movement_ForcePlayerExit:
	WalkNormalSouth
	EndMovement

	.balign 4, 0
Common_Movement_FaceOriginalDirection:
	EndMovement

	.balign 4, 0
PewterCity_Museum_1F_Movement_ApproachCounterLeft:
	WalkNormalEast 2
	Delay8
	WalkOnSpotNormalEast
	EndMovement

	.balign 4, 0
PewterCity_Museum_1F_Movement_ApproachCounterMid:
	WalkNormalEast
	Delay8
	WalkOnSpotNormalEast
	EndMovement

	.balign 4, 0
PewterCity_Museum_1F_Movement_ApproachCounterRight:
	Delay8
	WalkOnSpotNormalEast
	EndMovement
	.balign 4, 0
