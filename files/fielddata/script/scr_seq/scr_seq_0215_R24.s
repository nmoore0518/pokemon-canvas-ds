#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R24.h"
#include "msgdata/msg/msg_0362_R24.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route24_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route24_EventScript_Rocket
	ScrDef Route24_EventScript_ItemTM45
	ScrDef BerryField_EventScript_FindGrass
	ScrDef _cv_unported_3
	ScrDef _cv_unported_4
	ScrDef Route24_OnTransition
	ScrDefEnd
	
Route24_EventScript_Rocket:
	LockAll
	FacePlayer
	CompareVarToValue 0x5026, 1
	GoToIfEq Route24_EventScript_RocketPostBattle
	NPCMsg msg_0362_R24_Route24_Text_JustEarnedFabulousPrize
	WaitButton
	HasSpaceForItem ITEM_NUGGET, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Route24_EventScript_NoRoomForNugget
	Call Route24_EventScript_BattleRocket
	CloseMsg
	ReleaseAll
	End
	
Route24_EventScript_ItemTM45:
	SetVar 0x8004, ITEM_TM45
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
BerryField_EventScript_FindGrass:
	SetVar 0x8004, ITEM_RINDO_BERRY
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
Route24_EventScript_RocketTriggerLeft:
	LockAll
	SetVar 0x4001, 0
	GoTo Route24_EventScript_RocketTrigger
	End
	
Route24_EventScript_RocketTriggerRight:
	LockAll
	SetVar 0x4001, 1
	GoTo Route24_EventScript_RocketTrigger
	End
	
Route24_OnTransition:
	SetFlag 0x20E3
	End
	
Route24_EventScript_RocketPostBattle:
	GoTo MoveExtractor_EventScript_GruntAfterBridge
	End
	
Route24_EventScript_NoRoomForNugget:
	NPCMsg msg_0362_R24_Route24_Text_YouDontHaveAnyRoom
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route24_EventScript_BattleRocket:
	GiveItem ITEM_NUGGET, 1, VAR_SPECIAL_RESULT
	BufferItemName 1, ITEM_NUGGET
	BufferPlayersName 6
	NPCMsg msg_0362_R24_Route24_Text_ReceivedNuggetFromMysteryTrainer
	PlayFanfare SEQ_ME_LVUP
	WaitFanfare
	WaitButton
	PlayBGM SEQ_GS_EYE_ROCKET
	Call DadStory_EventScript_MustJoin
	GoTo DadStory_EventScript_RivalSendsHome
	
Route24_EventScript_RocketTrigger:
	CompareVarToValue 0x4001, 0
	CallIfEq Route24_EventScript_RocketApproachPlayer
	CompareVarToValue 0x4001, 1
	CallIfEq Route24_EventScript_RocketMotionToPlayer
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterRight
	WaitMovement
	NPCMsg msg_0362_R24_Route24_Text_JustEarnedFabulousPrize
	WaitButton
	HasSpaceForItem ITEM_NUGGET, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Route24_EventScript_NoRoomForNuggetTrigger
	Call Route24_EventScript_BattleRocket
	CloseMsg
	ReleaseAll
	End
	
MoveExtractor_EventScript_GruntAfterBridge:
	CompareVarToValue 0x501F, 1
	GoToIfGe MoveExtractor_EventScript_GruntKeepStealing
	NPCMsg msg_0362_R24_MoveExtractor_Text_ChangedYourMind
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq MoveExtractor_EventScript_GruntHmph
	Call MoveExtractor_EventScript_GruntSurprised
	CloseMsg
	ReleaseAll
	End
	
DadStory_EventScript_MustJoin:
	NPCMsg msg_0362_R24_MoveExtractor_Text_WantToJoin
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_3
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_4
_cv_yes_3:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq DadStory_EventScript_Joined
	NPCMsg msg_0362_R24_DadStory_Text_GruntInsists
	WaitButton
	GoTo DadStory_EventScript_MustJoin
	
DadStory_EventScript_RivalSendsHome:
	ResetBGM
	SetVar 0x5026, 1
	CompareVarToValue 0x5008, 3
	GoToIfGe DadStory_EventScript_ReleaseAll
	GetPlayerCoords 0x8004, 0x8005
	SubVar 0x8004, 1316
	SubVar 0x8005, 40
	ClearFlag 0x20E3
	GoToIfUnset 0x20E3, _cv_show_5
	ClearFlag 0x20E3
	ShowPerson 9
	SetFlag 0x20E3
	GoTo _cv_shown_6
_cv_show_5:
	ShowPerson 9
_cv_shown_6:
	// TODO(gba) setobjectxy LOCALID_ROUTE24_RIVAL, VAR_0x8004, 20
	GoTo _cv_stop
	PlayBGM SEQ_GS_E_RIVAL1
	ApplyMovement 9, DadStory_Movement_RivalUpTheBridge
	WaitMovement
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	BufferRivalsName 7
	NPCMsg msg_0362_R24_DadStory_Text_RivalMomHasSomething
	WaitButton
	CloseMsg
	PlayBGM SEQ_GS_E_RIVAL2
	ApplyMovement 9, DadStory_Movement_RivalDownTheBridge
	WaitMovement
	HidePerson 9
	SetFlag 0x20E3
	SetFlag 0x20E3
	ResetBGM
	SetVar 0x5008, 3
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	Warp MAP_PALLET_TOWN_REDS_HOUSE_1F, 0, 9, 5, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	ReleaseAll
	End
	
Route24_EventScript_RocketApproachPlayer:
	ApplyMovement 1, Route24_Movement_RocketApproachPlayer
	WaitMovement
	Return
	
Route24_EventScript_RocketMotionToPlayer:
	ApplyMovement 1, Common_Movement_WalkInPlaceFasterLeft
	WaitMovement
	Return
	
Route24_EventScript_NoRoomForNuggetTrigger:
	NPCMsg msg_0362_R24_Route24_Text_YouDontHaveAnyRoom
	WaitButton
	CloseMsg
	ApplyMovement obj_player, Route24_Movement_WalkDown
	WaitMovement
	CompareVarToValue 0x4001, 0
	CallIfEq Route24_EventScript_RocketWalkBackToPos
	ReleaseAll
	End
	
MoveExtractor_EventScript_GruntKeepStealing:
	NPCMsg msg_0362_R24_MoveExtractor_Text_KeepStealing
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
MoveExtractor_EventScript_GruntHmph:
	NPCMsg msg_0362_R24_MoveExtractor_Text_Hmph
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
MoveExtractor_EventScript_GruntSurprised:
	NPCMsg msg_0362_R24_MoveExtractor_Text_Surprised
	WaitButton
	SetVar 0x8009, 0
	Call GymHack_EventScript_GiveStatItem
	SetVar 0x501F, 1
	NPCMsg msg_0362_R24_MoveExtractor_Text_HowItWorks
	WaitButton
	Return
	
DadStory_EventScript_Joined:
	Call MoveExtractor_EventScript_GruntSurprised
	Return
	
DadStory_EventScript_ReleaseAll:
	ReleaseAll
	End
	
Route24_EventScript_RocketWalkBackToPos:
	ApplyMovement 1, Route24_Movement_RocketWalkBackToPos
	WaitMovement
	Return
	
GymHack_EventScript_GiveStatItem:
	GiveItem 0x8009, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymHack_EventScript_GiveStatItemDone
	BufferItemName 1, 0x8009
	NPCMsg msg_0362_R24_GymHack_Text_GiftSentToPC
	WaitButton
	End
	
GymHack_EventScript_GiveStatItemDone:
	Return

_cv_unported_3:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0362_R24_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_4:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0362_R24_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0362_R24_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
Common_Movement_WalkInPlaceFasterRight:
	WalkOnSpotFasterEast
	EndMovement

	.balign 4, 0
DadStory_Movement_RivalUpTheBridge:
	WalkNormalNorth 4
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterDown:
	WalkOnSpotFasterSouth
	EndMovement

	.balign 4, 0
DadStory_Movement_RivalDownTheBridge:
	WalkNormalSouth 6
	EndMovement

	.balign 4, 0
Route24_Movement_RocketApproachPlayer:
	WalkNormalWest
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterLeft:
	WalkOnSpotFasterWest
	EndMovement

	.balign 4, 0
Route24_Movement_WalkDown:
	WalkNormalSouth
	EndMovement

	.balign 4, 0
Route24_Movement_RocketWalkBackToPos:
	WalkNormalEast
	WalkOnSpotFasterWest
	EndMovement
	.balign 4, 0
