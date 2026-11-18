#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T02.h"
#include "msgdata/msg/msg_0452_T02.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's ViridianCity_Frlg#world by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef ViridianCity_EventScript_OldMan
	ScrDef ViridianCity_EventScript_TutorialOldMan
	ScrDef ViridianCity_EventScript_Woman
	ScrDef ViridianCity_EventScript_Youngster
	ScrDef ViridianCity_EventScript_Boy
	ScrDef ViridianCity_EventScript_ItemPotion
	ScrDef TypeTutor_EventScript_Ground
	ScrDef TypeTutor_EventScript_Bug
	ScrDef Route2_EventScript_ItemParalyzeHeal
	ScrDef ViridianCity_EventScript_TrainerTips1
	ScrDef ViridianCity_EventScript_GymSign
	ScrDef ViridianCity_EventScript_TrainerTips2
	ScrDef ViridianCity_EventScript_CitySign
	ScrDef ViridianCity_EventScript_GymDoor
	ScrDef Route2_EventScript_RouteSign
	ScrDef ViridianCity_EventScript_RoadBlocked
	ScrDef ViridianCity_EventScript_GymDoorLocked
	ScrDef ViridianCity_EventScript_TutorialTriggerLeft
	ScrDef ViridianCity_EventScript_TutorialTriggerRight
	ScrDef Route22_EventScript_EarlyRivalTriggerTop
	ScrDef Route22_EventScript_EarlyRivalTriggerMid
	ScrDef Route22_EventScript_LateRivalTriggerTop
	ScrDef Route22_EventScript_LateRivalTriggerMid
	ScrDef ViridianCity_OnTransition
	ScrDef _cv_unported_24
	ScrDefEnd
	
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
	
Route2_EventScript_ItemParalyzeHeal:
	SetVar 0x8004, ITEM_PARLYZ_HEAL
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
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
	
Route2_EventScript_RouteSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0452_T02_Route2_Text_RouteSign
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
	
Route22_EventScript_EarlyRivalTriggerTop:
	LockAll
	SetVar 0x4001, 0
	GoTo Route22_EventScript_EarlyRival
	End
	
Route22_EventScript_EarlyRivalTriggerMid:
	LockAll
	SetVar 0x4001, 1
	MovePerson 15, 1040, 277
	GoTo Route22_EventScript_EarlyRival
	End
	
Route22_EventScript_LateRivalTriggerTop:
	LockAll
	SetVar 0x4001, 0
	GoTo Route22_EventScript_LateRival
	End
	
Route22_EventScript_LateRivalTriggerMid:
	LockAll
	SetVar 0x4001, 1
	MovePerson 15, 1040, 277
	GoTo Route22_EventScript_LateRival
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
	
Route22_EventScript_EarlyRival:
	PlayBGM SEQ_GS_E_RIVAL1
	GoToIfUnset 0x2063, _cv_show_5
	ClearFlag 0x2063
	ShowPerson 15
	SetFlag 0x2063
	GoTo _cv_shown_6
_cv_show_5:
	ShowPerson 15
_cv_shown_6:
	CompareVarToValue 0x4001, 0
	CallIfEq Route22_EventScript_EarlyRivalApproach
	CompareVarToValue 0x4001, 1
	CallIfEq Route22_EventScript_EarlyRivalApproach
	CompareVarToValue 0x4001, 2
	CallIfEq Route22_EventScript_EarlyRivalApproachBottom
	Wait 6, VAR_SPECIAL_RESULT
	BufferPlayersName 6
	BufferRivalsName 7
	NPCMsg msg_0452_T02_Route22_Text_EarlyRivalIntro
	WaitButton
	CompareVarToValue 0x5018, 2
	CallIfEq Route22_EventScript_EarlyRivalSquirtle
	CompareVarToValue 0x5018, 1
	CallIfEq Route22_EventScript_EarlyRivalBulbasaur
	CompareVarToValue 0x5018, 0
	CallIfEq Route22_EventScript_EarlyRivalCharmander
	NPCMsg msg_0452_T02_Route22_Text_EarlyRivalPostBattle
	WaitButton
	CloseMsg
	Wait 10, VAR_SPECIAL_RESULT
	PlayBGM SEQ_GS_E_RIVAL2
	CompareVarToValue 0x4001, 0
	CallIfEq Route22_EventScript_EarlyRivalExit
	CompareVarToValue 0x4001, 1
	CallIfEq Route22_EventScript_EarlyRivalExit
	CompareVarToValue 0x4001, 2
	CallIfEq Route22_EventScript_EarlyRivalExitBottom
	ResetBGM
	HidePerson 15
	SetFlag 0x2063
	SetVar 0x5013, 2
	ReleaseAll
	End
	
Route22_EventScript_LateRival:
	PlayBGM SEQ_GS_E_RIVAL1
	GoToIfUnset 0x2063, _cv_show_7
	ClearFlag 0x2063
	ShowPerson 15
	SetFlag 0x2063
	GoTo _cv_shown_8
_cv_show_7:
	ShowPerson 15
_cv_shown_8:
	CompareVarToValue 0x4001, 0
	CallIfEq Route22_EventScript_LateRivalApproach
	CompareVarToValue 0x4001, 1
	CallIfEq Route22_EventScript_LateRivalApproach
	CompareVarToValue 0x4001, 2
	CallIfEq Route22_EventScript_LateRivalApproachBottom
	BufferPlayersName 6
	BufferRivalsName 7
	NPCMsg msg_0452_T02_Route22_Text_LateRivalIntro
	WaitButton
	SetVar VAR_SPECIAL_LAST_TALKED, 1
	CompareVarToValue 0x5018, 2
	CallIfEq Route22_EventScript_LateRivalSquirtle
	CompareVarToValue 0x5018, 1
	CallIfEq Route22_EventScript_LateRivalBulbasaur
	CompareVarToValue 0x5018, 0
	CallIfEq Route22_EventScript_LateRivalCharmander
	BufferPlayersName 6
	NPCMsg msg_0452_T02_Route22_Text_LateRivalPostBattle
	WaitButton
	CloseMsg
	Wait 10, VAR_SPECIAL_RESULT
	PlayBGM SEQ_GS_E_RIVAL2
	ApplyMovement 15, Route22_Movement_LateRivalExit
	WaitMovement
	ResetBGM
	HidePerson 15
	SetFlag 0x2063
	SetVar 0x5013, 4
	ReleaseAll
	End
	
ViridianCity_EventScript_SetOldManBlockingRoad:
	SetVar 0x4020, SPRITE_GSOLDMAN1
	MovePerson 4, 1036, 283
	SetObjectMovementType 4, 15
	SetObjectFacing 4, 1
	Return
	
ViridianCity_EventScript_SetOldManStandingByRoad:
	SetVar 0x4020, SPRITE_GSOLDMAN1
	MovePerson 4, 1036, 280
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
	AddVar 0x401E, 1015
	CopyVar 0x401F, 0x8006
	AddVar 0x401F, 272
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
	GoToIfEq _cv_yes_9
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_10
_cv_yes_9:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_10:
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
	GoToIfLt _cv_menu_12
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_12:
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
	
Route22_EventScript_EarlyRivalApproach:
	ApplyMovement 15, Route22_Movement_RivalApproach
	WaitMovement
	Return
	
Route22_EventScript_EarlyRivalApproachBottom:
	ApplyMovement 15, Route22_Movement_RivalApproachBottom
	ApplyMovement obj_player, Route22_Movement_PlayerFaceRival
	WaitMovement
	Return
	
Route22_EventScript_EarlyRivalSquirtle:
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_14
	TrainerBattle 754, 0, 1, 0
	GoTo _cv_battle_13
_cv_next_14:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_15
	TrainerBattle 758, 0, 1, 0
	GoTo _cv_battle_13
_cv_next_15:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_16
	TrainerBattle 752, 0, 1, 0
	GoTo _cv_battle_13
_cv_next_16:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_17
	TrainerBattle 750, 0, 1, 0
	GoTo _cv_battle_13
_cv_next_17:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_18
	TrainerBattle 760, 0, 1, 0
	GoTo _cv_battle_13
_cv_next_18:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_19
	TrainerBattle 755, 0, 1, 0
	GoTo _cv_battle_13
_cv_next_19:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_20
	TrainerBattle 757, 0, 1, 0
	GoTo _cv_battle_13
_cv_next_20:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_21
	TrainerBattle 759, 0, 1, 0
	GoTo _cv_battle_13
_cv_next_21:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_22
	TrainerBattle 753, 0, 1, 0
	GoTo _cv_battle_13
_cv_next_22:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_23
	TrainerBattle 761, 0, 1, 0
	GoTo _cv_battle_13
_cv_next_23:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_24
	TrainerBattle 756, 0, 1, 0
	GoTo _cv_battle_13
_cv_next_24:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_25
	TrainerBattle 751, 0, 1, 0
	GoTo _cv_battle_13
_cv_next_25:
	TrainerBattle 750, 0, 1, 0
_cv_battle_13:
	SetFlag 0x20AD
	Return
	
Route22_EventScript_EarlyRivalBulbasaur:
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_27
	TrainerBattle 754, 0, 1, 0
	GoTo _cv_battle_26
_cv_next_27:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_28
	TrainerBattle 758, 0, 1, 0
	GoTo _cv_battle_26
_cv_next_28:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_29
	TrainerBattle 752, 0, 1, 0
	GoTo _cv_battle_26
_cv_next_29:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_30
	TrainerBattle 750, 0, 1, 0
	GoTo _cv_battle_26
_cv_next_30:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_31
	TrainerBattle 760, 0, 1, 0
	GoTo _cv_battle_26
_cv_next_31:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_32
	TrainerBattle 755, 0, 1, 0
	GoTo _cv_battle_26
_cv_next_32:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_33
	TrainerBattle 757, 0, 1, 0
	GoTo _cv_battle_26
_cv_next_33:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_34
	TrainerBattle 759, 0, 1, 0
	GoTo _cv_battle_26
_cv_next_34:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_35
	TrainerBattle 753, 0, 1, 0
	GoTo _cv_battle_26
_cv_next_35:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_36
	TrainerBattle 761, 0, 1, 0
	GoTo _cv_battle_26
_cv_next_36:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_37
	TrainerBattle 756, 0, 1, 0
	GoTo _cv_battle_26
_cv_next_37:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_38
	TrainerBattle 751, 0, 1, 0
	GoTo _cv_battle_26
_cv_next_38:
	TrainerBattle 750, 0, 1, 0
_cv_battle_26:
	SetFlag 0x20AE
	Return
	
Route22_EventScript_EarlyRivalCharmander:
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_40
	TrainerBattle 754, 0, 1, 0
	GoTo _cv_battle_39
_cv_next_40:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_41
	TrainerBattle 758, 0, 1, 0
	GoTo _cv_battle_39
_cv_next_41:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_42
	TrainerBattle 752, 0, 1, 0
	GoTo _cv_battle_39
_cv_next_42:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_43
	TrainerBattle 750, 0, 1, 0
	GoTo _cv_battle_39
_cv_next_43:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_44
	TrainerBattle 760, 0, 1, 0
	GoTo _cv_battle_39
_cv_next_44:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_45
	TrainerBattle 755, 0, 1, 0
	GoTo _cv_battle_39
_cv_next_45:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_46
	TrainerBattle 757, 0, 1, 0
	GoTo _cv_battle_39
_cv_next_46:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_47
	TrainerBattle 759, 0, 1, 0
	GoTo _cv_battle_39
_cv_next_47:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_48
	TrainerBattle 753, 0, 1, 0
	GoTo _cv_battle_39
_cv_next_48:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_49
	TrainerBattle 761, 0, 1, 0
	GoTo _cv_battle_39
_cv_next_49:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_50
	TrainerBattle 756, 0, 1, 0
	GoTo _cv_battle_39
_cv_next_50:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_51
	TrainerBattle 751, 0, 1, 0
	GoTo _cv_battle_39
_cv_next_51:
	TrainerBattle 750, 0, 1, 0
_cv_battle_39:
	SetFlag 0x20AF
	Return
	
Route22_EventScript_EarlyRivalExit:
	ApplyMovement 15, Route22_Movement_EarlyRivalExit
	WaitMovement
	Return
	
Route22_EventScript_EarlyRivalExitBottom:
	ApplyMovement 15, Route22_Movement_EarlyRivalExitBottom
	WaitMovement
	Return
	
Route22_EventScript_LateRivalApproach:
	ApplyMovement 15, Route22_Movement_RivalApproach
	WaitMovement
	Return
	
Route22_EventScript_LateRivalApproachBottom:
	ApplyMovement 15, Route22_Movement_RivalApproachBottom
	ApplyMovement obj_player, Route22_Movement_PlayerFaceRival
	WaitMovement
	Return
	
Route22_EventScript_LateRivalSquirtle:
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_53
	TrainerBattle 814, 0, 0, 0
	GoTo _cv_battle_52
_cv_next_53:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_54
	TrainerBattle 818, 0, 0, 0
	GoTo _cv_battle_52
_cv_next_54:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_55
	TrainerBattle 812, 0, 0, 0
	GoTo _cv_battle_52
_cv_next_55:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_56
	TrainerBattle 810, 0, 0, 0
	GoTo _cv_battle_52
_cv_next_56:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_57
	TrainerBattle 820, 0, 0, 0
	GoTo _cv_battle_52
_cv_next_57:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_58
	TrainerBattle 815, 0, 0, 0
	GoTo _cv_battle_52
_cv_next_58:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_59
	TrainerBattle 817, 0, 0, 0
	GoTo _cv_battle_52
_cv_next_59:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_60
	TrainerBattle 819, 0, 0, 0
	GoTo _cv_battle_52
_cv_next_60:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_61
	TrainerBattle 813, 0, 0, 0
	GoTo _cv_battle_52
_cv_next_61:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_62
	TrainerBattle 821, 0, 0, 0
	GoTo _cv_battle_52
_cv_next_62:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_63
	TrainerBattle 816, 0, 0, 0
	GoTo _cv_battle_52
_cv_next_63:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_64
	TrainerBattle 811, 0, 0, 0
	GoTo _cv_battle_52
_cv_next_64:
	TrainerBattle 810, 0, 0, 0
_cv_battle_52:
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_65
	WhiteOut
	End
_cv_won_65:
	SetFlag 0x20B0
	Return
	
Route22_EventScript_LateRivalBulbasaur:
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_67
	TrainerBattle 814, 0, 0, 0
	GoTo _cv_battle_66
_cv_next_67:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_68
	TrainerBattle 818, 0, 0, 0
	GoTo _cv_battle_66
_cv_next_68:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_69
	TrainerBattle 812, 0, 0, 0
	GoTo _cv_battle_66
_cv_next_69:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_70
	TrainerBattle 810, 0, 0, 0
	GoTo _cv_battle_66
_cv_next_70:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_71
	TrainerBattle 820, 0, 0, 0
	GoTo _cv_battle_66
_cv_next_71:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_72
	TrainerBattle 815, 0, 0, 0
	GoTo _cv_battle_66
_cv_next_72:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_73
	TrainerBattle 817, 0, 0, 0
	GoTo _cv_battle_66
_cv_next_73:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_74
	TrainerBattle 819, 0, 0, 0
	GoTo _cv_battle_66
_cv_next_74:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_75
	TrainerBattle 813, 0, 0, 0
	GoTo _cv_battle_66
_cv_next_75:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_76
	TrainerBattle 821, 0, 0, 0
	GoTo _cv_battle_66
_cv_next_76:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_77
	TrainerBattle 816, 0, 0, 0
	GoTo _cv_battle_66
_cv_next_77:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_78
	TrainerBattle 811, 0, 0, 0
	GoTo _cv_battle_66
_cv_next_78:
	TrainerBattle 810, 0, 0, 0
_cv_battle_66:
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_79
	WhiteOut
	End
_cv_won_79:
	SetFlag 0x20B1
	Return
	
Route22_EventScript_LateRivalCharmander:
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_81
	TrainerBattle 814, 0, 0, 0
	GoTo _cv_battle_80
_cv_next_81:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_82
	TrainerBattle 818, 0, 0, 0
	GoTo _cv_battle_80
_cv_next_82:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_83
	TrainerBattle 812, 0, 0, 0
	GoTo _cv_battle_80
_cv_next_83:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_84
	TrainerBattle 810, 0, 0, 0
	GoTo _cv_battle_80
_cv_next_84:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_85
	TrainerBattle 820, 0, 0, 0
	GoTo _cv_battle_80
_cv_next_85:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_86
	TrainerBattle 815, 0, 0, 0
	GoTo _cv_battle_80
_cv_next_86:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_87
	TrainerBattle 817, 0, 0, 0
	GoTo _cv_battle_80
_cv_next_87:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_88
	TrainerBattle 819, 0, 0, 0
	GoTo _cv_battle_80
_cv_next_88:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_89
	TrainerBattle 813, 0, 0, 0
	GoTo _cv_battle_80
_cv_next_89:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_90
	TrainerBattle 821, 0, 0, 0
	GoTo _cv_battle_80
_cv_next_90:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_91
	TrainerBattle 816, 0, 0, 0
	GoTo _cv_battle_80
_cv_next_91:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_92
	TrainerBattle 811, 0, 0, 0
	GoTo _cv_battle_80
_cv_next_92:
	TrainerBattle 810, 0, 0, 0
_cv_battle_80:
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_93
	WhiteOut
	End
_cv_won_93:
	SetFlag 0x20B2
	Return
	
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

_cv_unported_24:
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
Route22_Movement_LateRivalExit:
	WalkNormalWest 7
	EndMovement

	.balign 4, 0
Common_Movement_ExclamationMark:
	EmoteExclamationMark
	EndMovement

	.balign 4, 0
Route22_Movement_RivalApproach:
	WalkNormalEast 7
	EndMovement

	.balign 4, 0
Route22_Movement_RivalApproachBottom:
	WalkNormalEast 8
	WalkOnSpotFasterSouth
	EndMovement

	.balign 4, 0
Route22_Movement_PlayerFaceRival:
	Delay16 7
	Delay8
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
Route22_Movement_EarlyRivalExit:
	WalkNormalSouth
	WalkNormalEast 5
	WalkNormalSouth 6
	EndMovement

	.balign 4, 0
Route22_Movement_EarlyRivalExitBottom:
	WalkNormalEast 4
	WalkNormalSouth 7
	EndMovement
	.balign 4, 0
