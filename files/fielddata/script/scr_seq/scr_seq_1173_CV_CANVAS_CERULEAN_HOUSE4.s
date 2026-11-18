#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_CERULEAN_HOUSE4.h"
#include "msgdata/msg/msg_0958_CV_CANVAS_CERULEAN_HOUSE4.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's CeruleanCity_House4_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef CeruleanCity_House4_EventScript_WonderNewsBerryMan
	ScrDef TrainingHouse_EventScript_Edmund
	ScrDefEnd
	
CeruleanCity_House4_EventScript_WonderNewsBerryMan:
	LockAll
	SetVar 0x8004, 0  // TODO(gba) specialvar WonderNews_GetRewardInfo
	GoTo _cv_stop
	CopyVar 0x8008, VAR_SPECIAL_RESULT
	CompareVarToValue 0x8004, 0
	GoToIfEq CeruleanCity_House4_EventScript_NoNews
	CompareVarToValue 0x8004, 1
	GoToIfEq CeruleanCity_House4_EventScript_Reward_RecvSmall
	CompareVarToValue 0x8004, 2
	GoToIfEq CeruleanCity_House4_EventScript_Reward_RecvBig
	CompareVarToValue 0x8004, 3
	GoToIfEq CeruleanCity_House4_EventScript_Waiting
	CompareVarToValue 0x8004, 4
	GoToIfEq CeruleanCity_House4_EventScript_Reward_SentSmall
	CompareVarToValue 0x8004, 5
	GoToIfEq CeruleanCity_House4_EventScript_Reward_SentBig
	CompareVarToValue 0x8004, 6
	GoToIfEq CeruleanCity_House4_EventScript_AtMax
	End
	
TrainingHouse_EventScript_Edmund:
	LockAll
	FacePlayer
	NPCMsg msg_0958_CV_CANVAS_CERULEAN_HOUSE4_TrainingHouse_Text_EdmundIntro
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TrainingHouse_EventScript_Declined
	ClearTrainerFlag 1448
	CheckTrainerFlag 1448
	GoToIf TRUE, _cv_beaten_3
	TrainerBattle 1448, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_4
	WhiteOut
	End
_cv_won_4:
	SetTrainerFlag 1448
	ReleaseAll
	End
_cv_beaten_3:
	NPCMsg msg_0958_CV_CANVAS_CERULEAN_HOUSE4_TrainingHouse_Text_After
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeruleanCity_House4_EventScript_NoNews:
	NPCMsg msg_0958_CV_CANVAS_CERULEAN_HOUSE4_CeruleanCity_House4_Text_NothingEntertaining
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeruleanCity_House4_EventScript_Reward_RecvSmall:
	Call CeruleanCity_House4_EventScript_MovementReactionToNews
	NPCMsg msg_0958_CV_CANVAS_CERULEAN_HOUSE4_CeruleanCity_House4_Text_NewNewsInformativeHaveThis
	WaitButton
	GiveItem 0x8008, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CeruleanCity_House4_EventScript_NoRoomForBerries
	CloseMsg
	ReleaseAll
	End
	
CeruleanCity_House4_EventScript_Reward_RecvBig:
	Call CeruleanCity_House4_EventScript_MovementReactionToNews
	NPCMsg msg_0958_CV_CANVAS_CERULEAN_HOUSE4_CeruleanCity_House4_Text_IncredibleNewsHaveBerries
	WaitButton
	GiveItem 0x8008, 4, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CeruleanCity_House4_EventScript_NoRoomForBerries
	CloseMsg
	ReleaseAll
	End
	
CeruleanCity_House4_EventScript_Waiting:
	FacePlayer
	WaitMovement
	NPCMsg msg_0958_CV_CANVAS_CERULEAN_HOUSE4_CeruleanCity_House4_Text_WishCouldShareNewsWithOthers
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeruleanCity_House4_EventScript_Reward_SentSmall:
	Call CeruleanCity_House4_EventScript_MovementReactionToNews
	NPCMsg msg_0958_CV_CANVAS_CERULEAN_HOUSE4_CeruleanCity_House4_Text_ThanksForSpreadingNewsTakeThis
	WaitButton
	GiveItem 0x8008, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CeruleanCity_House4_EventScript_NoRoomForBerries
	CloseMsg
	ReleaseAll
	End
	
CeruleanCity_House4_EventScript_Reward_SentBig:
	Call CeruleanCity_House4_EventScript_MovementReactionToNews
	NPCMsg msg_0958_CV_CANVAS_CERULEAN_HOUSE4_CeruleanCity_House4_Text_MagnificentNewsSpreadHaveBerries
	WaitButton
	GiveItem 0x8008, 4, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CeruleanCity_House4_EventScript_NoRoomForBerries
	CloseMsg
	ReleaseAll
	End
	
CeruleanCity_House4_EventScript_AtMax:
	FacePlayer
	WaitMovement
	NPCMsg msg_0958_CV_CANVAS_CERULEAN_HOUSE4_CeruleanCity_House4_Text_EnjoyingMyselfWithAllSortsOfNews
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TrainingHouse_EventScript_Declined:
	NPCMsg msg_0958_CV_CANVAS_CERULEAN_HOUSE4_TrainingHouse_Text_Declined
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeruleanCity_House4_EventScript_MovementReactionToNews:
	PlaySE SEQ_SE_DP_SELECT
	ApplyMovement 1, Common_Movement_ExclamationMark
	WaitMovement
	FacePlayer
	WaitMovement
	ApplyMovement 1, Common_Movement_Delay48
	WaitMovement
	Return
	
CeruleanCity_House4_EventScript_NoRoomForBerries:
	NPCMsg msg_0958_CV_CANVAS_CERULEAN_HOUSE4_CeruleanCity_House4_Text_YourBerryPouchIsFull
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0958_CV_CANVAS_CERULEAN_HOUSE4_cv_unported
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
