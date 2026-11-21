#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R05.h"
#include "msgdata/msg/msg_0329_R05.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route5_Frlg#world by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef BerryField_EventScript_FindPsychic
	ScrDef CeruleanCity_EventScript_Slowbro
	ScrDef CeruleanCity_EventScript_Lass
	ScrDef CeruleanCity_EventScript_Woman
	ScrDef CeruleanCity_EventScript_BikeShopSign
	ScrDef CeruleanCity_EventScript_TrainerTips
	ScrDefEnd
	
BerryField_EventScript_FindPsychic:
	SetVar 0x8004, ITEM_PAYAPA_BERRY
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
CeruleanCity_EventScript_Slowbro:
	LockAll
	Random VAR_SPECIAL_RESULT, 4
	CopyVar 0x8008, VAR_SPECIAL_RESULT
	CompareVarToValue 0x8008, 0
	CallIfEq CeruleanCity_EventScript_SlowbroText1
	CompareVarToValue 0x8008, 1
	CallIfEq CeruleanCity_EventScript_SlowbroText2
	CompareVarToValue 0x8008, 2
	CallIfEq CeruleanCity_EventScript_SlowbroText3
	CompareVarToValue 0x8008, 3
	CallIfEq CeruleanCity_EventScript_SlowbroText4
	CanvasCloseMsg
	ReleaseAll
	End
	
CeruleanCity_EventScript_Lass:
	LockAll
	Random VAR_SPECIAL_RESULT, 3
	CopyVar 0x8008, VAR_SPECIAL_RESULT
	CompareVarToValue 0x8008, 0
	CallIfEq CeruleanCity_EventScript_SlowbroCommand1
	CompareVarToValue 0x8008, 1
	CallIfEq CeruleanCity_EventScript_SlowbroCommand2
	CompareVarToValue 0x8008, 2
	CallIfEq CeruleanCity_EventScript_SlowbroCommand3
	Wait 40, VAR_SPECIAL_RESULT
	PlaySE SEQ_SE_DP_SELECT
	ApplyMovement 3, Common_Movement_QuestionMark
	WaitMovement
	Wait 30, VAR_SPECIAL_RESULT
	CompareVarToValue 0x8008, 0
	CallIfEq CeruleanCity_EventScript_SlowbroFailed1
	CompareVarToValue 0x8008, 1
	CallIfEq CeruleanCity_EventScript_SlowbroFailed2
	CompareVarToValue 0x8008, 2
	CallIfEq CeruleanCity_EventScript_SlowbroFailed3
	CanvasCloseMsg
	ReleaseAll
	End
	
CeruleanCity_EventScript_Woman:
	LockAll
	FacePlayer
	NPCMsg msg_0329_R05_CeruleanCity_Text_WantBrightRedBicycle
	WaitButton
	CanvasCloseMsg
	ApplyMovement 6, Common_Movement_FaceOriginalDirection
	WaitMovement
	CanvasCloseMsg
	ReleaseAll
	End
	
CeruleanCity_EventScript_BikeShopSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0329_R05_CeruleanCity_Text_BikeShopSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeruleanCity_EventScript_TrainerTips:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0329_R05_CeruleanCity_Text_TrainerTipsHeldItems
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeruleanCity_EventScript_SlowbroText1:
	NPCMsg msg_0329_R05_CeruleanCity_Text_SlowbroTookSnooze
	WaitButton
	Return
	
CeruleanCity_EventScript_SlowbroText2:
	NPCMsg msg_0329_R05_CeruleanCity_Text_SlowbroLoafingAround
	WaitButton
	Return
	
CeruleanCity_EventScript_SlowbroText3:
	NPCMsg msg_0329_R05_CeruleanCity_Text_SlowbroTurnedAway
	WaitButton
	Return
	
CeruleanCity_EventScript_SlowbroText4:
	NPCMsg msg_0329_R05_CeruleanCity_Text_SlowbroIgnoredOrders
	WaitButton
	Return
	
CeruleanCity_EventScript_SlowbroCommand1:
	NPCMsg msg_0329_R05_CeruleanCity_Text_SlowbroUseSonicboom
	Return
	
CeruleanCity_EventScript_SlowbroCommand2:
	NPCMsg msg_0329_R05_CeruleanCity_Text_SlowbroPunch
	Return
	
CeruleanCity_EventScript_SlowbroCommand3:
	NPCMsg msg_0329_R05_CeruleanCity_Text_SlowbroWithdraw
	Return
	
CeruleanCity_EventScript_SlowbroFailed1:
	NPCMsg msg_0329_R05_CeruleanCity_Text_SlowbroPayAttention
	WaitButton
	Return
	
CeruleanCity_EventScript_SlowbroFailed2:
	NPCMsg msg_0329_R05_CeruleanCity_Text_NoYouBlewItAgain
	WaitButton
	Return
	
CeruleanCity_EventScript_SlowbroFailed3:
	NPCMsg msg_0329_R05_CeruleanCity_Text_HardToControlMonsObedience
	WaitButton
	Return

_cv_stop:
	NPCMsg msg_0329_R05_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
Common_Movement_QuestionMark:
	EmoteQuestionMark
	EndMovement

	.balign 4, 0
Common_Movement_FaceOriginalDirection:
	EndMovement
	.balign 4, 0
