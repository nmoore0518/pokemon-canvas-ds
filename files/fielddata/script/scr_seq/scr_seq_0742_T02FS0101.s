#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T02FS0101.h"
#include "msgdata/msg/msg_0453_T02FS0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's ViridianCity_Mart_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef ViridianCity_Mart_EventScript_Clerk
	ScrDef ViridianCity_Mart_EventScript_Youngster
	ScrDef ViridianCity_Mart_EventScript_Woman
	ScrDef ViridianCity_Mart_OnLoad
	ScrDef ViridianCity_Mart_EventScript_ParcelScene
	ScrDefEnd
	
ViridianCity_Mart_EventScript_Clerk:
	LockAll
	FacePlayer
	CompareVarToValue 0x5010, 1
	GoToIfEq ViridianCity_Mart_EventScript_SayHiToOak
	NPCMsg msg_0453_T02FS0101_gText_HowMayIServeYou
	CanvasMart 4
	.short ITEM_POKE_BALL
	.short ITEM_POTION
	.short ITEM_ANTIDOTE
	.short ITEM_PARLYZ_HEAL
	NPCMsg msg_0453_T02FS0101_gText_PleaseComeAgain
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianCity_Mart_EventScript_Youngster:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0453_T02FS0101_ViridianCity_Mart_Text_GotToBuySomePotions
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianCity_Mart_EventScript_Woman:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0453_T02FS0101_ViridianCity_Mart_Text_ShopDoesGoodBusinessInAntidotes
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianCity_Mart_OnLoad:
	GoToIfUnset 0x201C, ViridianCity_Mart_EventScript_HideQuestionnaire
	End
	
ViridianCity_Mart_EventScript_ParcelScene:
	LockAll
	ApplyMovement 1, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	NPCMsg msg_0453_T02FS0101_ViridianCity_Mart_Text_YouCameFromPallet
	WaitButton
	CanvasCloseMsg
	ApplyMovement 1, ViridianCity_Mart_Movement_FacePlayer
	ApplyMovement obj_player, ViridianCity_Mart_Movement_ApproachCounter
	WaitMovement
	NPCMsg msg_0453_T02FS0101_ViridianCity_Mart_Text_TakeThisToProfOak
	WaitButton
	SetVar 0x5010, 1
	SetFlag 0x202D
	SetVar VAR_SPECIAL_RESULT, 1
	BufferItemName 1, 0
	BufferPlayersName 6
	NPCMsg msg_0453_T02FS0101_ViridianCity_Mart_Text_ReceivedOaksParcelFromClerk
	PlayFanfare SEQ_ME_ITEM
	WaitFanfare
	WaitButton
	SetVar 0x5006, 5
	CloseMsg
	ReleaseAll
	End
	
ViridianCity_Mart_EventScript_SayHiToOak:
	NPCMsg msg_0453_T02FS0101_ViridianCity_Mart_Text_SayHiToOakForMe
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianCity_Mart_EventScript_HideQuestionnaire:
	// (the GBA redraws a square here: 1, 3, METATILE_Mart_CounterMid_Top, 1)
	// (the GBA redraws a square here: 1, 4, METATILE_Mart_CounterMid_Bottom, 1)
	End

_cv_stop:
	NPCMsg msg_0453_T02FS0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
Common_Movement_WalkInPlaceFasterDown:
	WalkOnSpotFasterSouth
	EndMovement

	.balign 4, 0
ViridianCity_Mart_Movement_FacePlayer:
	Delay16 4
	WalkOnSpotFasterEast
	EndMovement

	.balign 4, 0
ViridianCity_Mart_Movement_ApproachCounter:
	WalkNormalNorth 4
	WalkOnSpotFasterWest
	EndMovement
	.balign 4, 0
