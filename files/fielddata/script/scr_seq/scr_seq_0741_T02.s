#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T02.h"
#include "msgdata/msg/msg_0452_T02.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's ViridianCity_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef ViridianCity_EventScript_DreamEaterTutor
	ScrDef ViridianCity_EventScript_OldMan
	ScrDef ViridianCity_EventScript_TutorialOldMan
	ScrDef ViridianCity_EventScript_Woman
	ScrDef ViridianCity_EventScript_Youngster
	ScrDef ViridianCity_EventScript_Boy
	ScrDef ViridianCity_EventScript_ItemPotion
	ScrDef TypeTutor_EventScript_Ground
	ScrDef TypeTutor_EventScript_Bug
	ScrDef ViridianCity_EventScript_TrainerTips1
	ScrDef ViridianCity_EventScript_GymSign
	ScrDef ViridianCity_EventScript_TrainerTips2
	ScrDef ViridianCity_EventScript_CitySign
	ScrDef ViridianCity_EventScript_GymDoor
	ScrDef ViridianCity_EventScript_RoadBlocked
	ScrDef ViridianCity_EventScript_GymDoorLocked
	ScrDef ViridianCity_EventScript_TutorialTriggerLeft
	ScrDef ViridianCity_EventScript_TutorialTriggerRight
	ScrDef ViridianCity_OnTransition
	ScrDef _cv_unported_19
	ScrDefEnd
	
ViridianCity_EventScript_DreamEaterTutor:
	GoTo EventScript_DreamEaterTutor
	End
	
ViridianCity_EventScript_OldMan:
	LockAll
	FacePlayer
	CompareVarToValue 0x501E, 1
	GoToIfEq ViridianCity_EventScript_OldManGymLeaderReturned
	NPCMsg msg_0452_T02_ViridianCity_Text_GymClosedWonderWhoLeaderIs
	WaitButton
	CloseMsg
	ApplyMovement 3, Common_Movement_FaceOriginalDirection
	WaitMovement
	ReleaseAll
	End
	
ViridianCity_EventScript_TutorialOldMan:
	LockAll
	FacePlayer
	GoToIfSet 0x2088, ViridianCity_EventScript_AskIfTeachyTVHelpful
	CompareVarToValue 0x5012, 2
	GoToIfGe ViridianCity_EventScript_TutorialCompleted
	CompareVarToValue 0x5012, 1
	GoToIfEq ViridianCity_EventScript_TutorialStart
	CompareVarToValue 0x5012, 0
	GoToIfEq ViridianCity_EventScript_TutorialNotReady
	End
	
ViridianCity_EventScript_Woman:
	LockAll
	FacePlayer
	CompareVarToValue 0x5012, 0
	GoToIfEq ViridianCity_EventScript_WomanRoadBlocked
	NPCMsg msg_0452_T02_ViridianCity_Text_GoShoppingInPewterOccasionally
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianCity_EventScript_Youngster:
	LockAll
	FacePlayer
	NPCMsg msg_0452_T02_ViridianCity_Text_WantToKnowAboutCaterpillarMons
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq ViridianCity_EventScript_YoungsterExplainCaterpillars
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq ViridianCity_EventScript_YoungsterDeclineExplanation
	CloseMsg
	End
	
ViridianCity_EventScript_Boy:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0452_T02_ViridianCity_Text_CanCarryMonsAnywhere
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianCity_EventScript_ItemPotion:
	SetVar 0x8004, ITEM_POTION
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
TypeTutor_EventScript_Ground:
	LockAll
	FacePlayer
	SetVar 0x8004, 1
	GoTo TypeTutor_EventScript_Talk
	
TypeTutor_EventScript_Bug:
	LockAll
	FacePlayer
	SetVar 0x8004, 2
	GoTo TypeTutor_EventScript_Talk
	
ViridianCity_EventScript_TrainerTips1:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0452_T02_ViridianCity_Text_CatchMonsForEasierBattles
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianCity_EventScript_GymSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0452_T02_ViridianCity_Text_GymSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianCity_EventScript_TrainerTips2:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0452_T02_ViridianCity_Text_MovesLimitedByPP
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianCity_EventScript_CitySign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0452_T02_ViridianCity_Text_CitySign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianCity_EventScript_GymDoor:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0452_T02_ViridianCity_Text_GymDoorsAreLocked
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianCity_EventScript_RoadBlocked:
	LockAll
	NPCMsg msg_0452_T02_ViridianCity_Text_ThisIsPrivateProperty
	WaitButton
	CloseMsg
	ApplyMovement obj_player, ViridianCity_Movement_WalkDown
	WaitMovement
	ReleaseAll
	End
	
ViridianCity_EventScript_GymDoorLocked:
	LockAll
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	Wait 20, VAR_SPECIAL_RESULT
	NPCMsg msg_0452_T02_ViridianCity_Text_GymDoorsAreLocked
	WaitButton
	CloseMsg
	ApplyMovement obj_player, ViridianCity_Movement_JumpDownLedge
	WaitMovement
	ReleaseAll
	End
	
ViridianCity_EventScript_TutorialTriggerLeft:
	LockAll
	ApplyMovement 4, Common_Movement_WalkInPlaceFasterLeft
	WaitMovement
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterRight
	WaitMovement
	Call ViridianCity_EventScript_DoTutorialBattle
	ReleaseAll
	End
	
ViridianCity_EventScript_TutorialTriggerRight:
	LockAll
	ApplyMovement 4, Common_Movement_WalkInPlaceFasterRight
	WaitMovement
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterLeft
	WaitMovement
	Call ViridianCity_EventScript_DoTutorialBattle
	ReleaseAll
	End
	
ViridianCity_OnTransition:
	SetFlag 0x2089
	SetVar 0x4014, 3
	// TODO(gba) special MoveExtractor_VisitDue
	CopyVar 0x4009, 0x401C
	SetFlag FLAG_SYS_FLYPOINT_VIRIDIAN
	CompareVarToValue 0x5012, 0
	CallIfEq ViridianCity_EventScript_SetOldManBlockingRoad
	CompareVarToValue 0x5012, 1
	CallIfEq ViridianCity_EventScript_SetOldManStandingByRoad
	CompareVarToValue 0x5012, 2
	CallIfGe ViridianCity_EventScript_SetOldManNormal
	CompareVarToValue 0x501E, 0
	CallIfEq ViridianCity_EventScript_TryUnlockGym
	End
	
MoveExtractor_EventScript_ViridianVisit:
	SetVar 0x800A, 10
	SetVar 0x8008, 3
	GoTo MoveExtractor_EventScript_Visit
	End
	
EventScript_DreamEaterTutor:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0452_T02_Text_DreamEaterTutor_Retired
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianCity_EventScript_OldManGymLeaderReturned:
	NPCMsg msg_0452_T02_ViridianCity_Text_ViridiansGymLeaderReturned
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianCity_EventScript_AskIfTeachyTVHelpful:
	NPCMsg msg_0452_T02_ViridianCity_Text_HowsTeachyTVHelping
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_3
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_4
_cv_yes_3:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq ViridianCity_EventScript_TeachyTVNotHelpful
	NPCMsg msg_0452_T02_ViridianCity_Text_MyGrandsonOnTheShow
	WaitButton
	GoTo ViridianCity_EventScript_AskShowAgain
	
ViridianCity_EventScript_TutorialCompleted:
	NPCMsg msg_0452_T02_ViridianCity_Text_WeakenMonsFirstToCatch
	WaitButton
	GoTo ViridianCity_EventScript_AskShowAgain
	
ViridianCity_EventScript_TutorialStart:
	Call ViridianCity_EventScript_DoTutorialBattle
	ReleaseAll
	End
	
ViridianCity_EventScript_TutorialNotReady:
	NPCMsg msg_0452_T02_ViridianCity_Text_ThisIsPrivateProperty
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianCity_EventScript_WomanRoadBlocked:
	NPCMsg msg_0452_T02_ViridianCity_Text_GrandpaHasntHadCoffeeYet
	WaitButton
	CloseMsg
	ApplyMovement 5, Common_Movement_FaceOriginalDirection
	WaitMovement
	ReleaseAll
	End
	
ViridianCity_EventScript_YoungsterExplainCaterpillars:
	NPCMsg msg_0452_T02_ViridianCity_Text_ExplainCaterpieWeedle
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianCity_EventScript_YoungsterDeclineExplanation:
	NPCMsg msg_0452_T02_ViridianCity_Text_OhOkayThen
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
	
ViridianCity_EventScript_DoTutorialBattle:
	NPCMsg msg_0452_T02_ViridianCity_Text_ShowYouHowToCatchMons
	WaitButton
	CloseMsg
	CatchingTutorial
	SetFlag 0x20A3
	LockAll
	FacePlayer
	NPCMsg msg_0452_T02_ViridianCity_Text_ThatWasEducationalTakeThis
	WaitButton
	SetVar 0x5012, 2
	SetFlag 0x208A
	SetVar VAR_SPECIAL_RESULT, 1
	NPCMsg msg_0452_T02_ViridianCity_Text_WatchThatToLearnBasics
	WaitButton
	Return
	
ViridianCity_EventScript_SetOldManBlockingRoad:
	SetVar 0x4020, SPRITE_GSOLDMAN1
	MovePerson 4, 1030, 243
	SetObjectMovementType 4, 15
	SetObjectFacing 4, 1
	Return
	
ViridianCity_EventScript_SetOldManStandingByRoad:
	SetVar 0x4020, SPRITE_GSOLDMAN1
	MovePerson 4, 1030, 238
	SetObjectMovementType 4, 2
	Return
	
ViridianCity_EventScript_SetOldManNormal:
	SetVar 0x4020, SPRITE_GSOLDMAN1
	Return
	
ViridianCity_EventScript_TryUnlockGym:
	GoToIfUnset 0x208B, Common_EventScript_NopReturn
	GoToIfUnset 0x208C, Common_EventScript_NopReturn
	GoToIfUnset 0x208D, Common_EventScript_NopReturn
	GoToIfUnset 0x208E, Common_EventScript_NopReturn
	GoToIfUnset 0x208F, Common_EventScript_NopReturn
	GoToIfUnset 0x2090, Common_EventScript_NopReturn
	SetVar 0x501E, 1
	Return
	
MoveExtractor_EventScript_Visit:
	LockAll
	SetVar 0x4009, 0
	// TODO(gba) special GymCandidate_PlaceGuest
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq MoveExtractor_EventScript_VisitNoRoom
	CopyVar 0x401E, 0x8005
	AddVar 0x401E, 1005
	CopyVar 0x401F, 0x8006
	AddVar 0x401F, 233
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
	
ViridianCity_EventScript_TeachyTVNotHelpful:
	NPCMsg msg_0452_T02_ViridianCity_Text_TooBusyForTeachyTV
	WaitButton
	GoTo ViridianCity_EventScript_AskShowAgain
	
ViridianCity_EventScript_AskShowAgain:
	NPCMsg msg_0452_T02_ViridianCity_Text_ShowYouAgain
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_5
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_6
_cv_yes_5:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_6:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq ViridianCity_EventScript_ShowAgainNo
	CloseMsg
	CatchingTutorial
	SetFlag 0x20A3
	LockAll
	FacePlayer
	NPCMsg msg_0452_T02_ViridianCity_Text_ThereThatsHowItsDone
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TypeTutor_EventScript_Intro:
	// TODO(gba) special TypeTutor_BufferIntro
	GoTo _cv_stop
	Call _cv_str4
	WaitButton
	// TODO(gba) special TypeTutor_SetMet
	GoTo _cv_stop
	// TODO(gba) special TypeTutor_GetState
	GoTo _cv_stop
	End
	
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
	End
	
TypeTutor_EventScript_Teach:
	CopyVar 0x8004, 0x8008
	NPCMsg msg_0452_T02_TypeTutor_Text_WhichMove
	// TODO(gba) special TypeTutor_PushMoves
	GoTo _cv_stop
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_8
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_8:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq TypeTutor_EventScript_Bye
	CopyVar 0x8004, 0x8008
	// TODO(gba) special TypeTutor_SelectMove
	GoTo _cv_stop
	NPCMsg msg_0452_T02_TypeTutor_Text_WhichMon
	WaitButton
	Call EventScript_ChooseMoveTutorMon
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TypeTutor_EventScript_Teach
	NPCMsg msg_0452_T02_TypeTutor_Text_Taught
	WaitButton
	GoTo TypeTutor_EventScript_Teach
	
Common_EventScript_NopReturn:
	Return
	
MoveExtractor_EventScript_VisitNoRoom:
	ReleaseAll
	End
	
MoveExtractor_EventScript_SecondVisit:
	NPCMsg msg_0452_T02_MoveExtractor_Text_SecondVisit
	WaitButton
	SetVar 0x8009, 0
	Call GymHack_EventScript_GiveStatItem
	SetVar 0x501F, 2
	NPCMsg msg_0452_T02_MoveExtractor_Text_SecondVisitAfter
	WaitButton
	Return
	
MoveExtractor_EventScript_ThirdVisit:
	NPCMsg msg_0452_T02_MoveExtractor_Text_ThirdVisit
	WaitButton
	SetVar 0x8009, 0
	Call GymHack_EventScript_GiveStatItem
	SetVar 0x501F, 3
	NPCMsg msg_0452_T02_MoveExtractor_Text_ThirdVisitAfter
	WaitButton
	Return
	
ViridianCity_EventScript_ShowAgainNo:
	ReleaseAll
	End
	
TypeTutor_EventScript_Bye:
	NPCMsg msg_0452_T02_TypeTutor_Text_Bye
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
	
GymHack_EventScript_GiveStatItem:
	GiveItem 0x8009, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymHack_EventScript_GiveStatItemDone
	BufferItemName 1, 0x8009
	NPCMsg msg_0452_T02_GymHack_Text_GiftSentToPC
	WaitButton
	End
	
GymHack_EventScript_GiveStatItemDone:
	Return

_cv_unported_19:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0452_T02_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_str4:
	BufferPlayersName 6
	BufferRivalsName 7
	Return

_cv_stop:
	NPCMsg msg_0452_T02_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
Common_Movement_FaceOriginalDirection:
	EndMovement

	.balign 4, 0
ViridianCity_Movement_WalkDown:
	WalkNormalSouth
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterUp:
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
ViridianCity_Movement_JumpDownLedge:
	JumpFarSouth
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
Common_Movement_ExclamationMark:
	EmoteExclamationMark
	EndMovement
	.balign 4, 0
