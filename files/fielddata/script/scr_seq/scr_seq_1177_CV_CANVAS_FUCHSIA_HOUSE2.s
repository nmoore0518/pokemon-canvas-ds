#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_FUCHSIA_HOUSE2.h"
#include "msgdata/msg/msg_0960_CV_CANVAS_FUCHSIA_HOUSE2.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's FuchsiaCity_House2_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef FuchsiaCity_House2_EventScript_FishingGurusBrother
	ScrDefEnd
	
FuchsiaCity_House2_EventScript_FishingGurusBrother:
	LockAll
	FacePlayer
	GoToIfSet 0x221F, FuchsiaCity_House2_EventScript_AlreadyGotGoodRod
	NPCMsg msg_0960_CV_CANVAS_FUCHSIA_HOUSE2_FuchsiaCity_House2_Text_DoYouLikeToFish
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq FuchsiaCity_House2_EventScript_GiveGoodRod
	NPCMsg msg_0960_CV_CANVAS_FUCHSIA_HOUSE2_FuchsiaCity_House2_Text_OhThatsDisappointing
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_House2_EventScript_AlreadyGotGoodRod:
	BufferPlayersName 6
	NPCMsg msg_0960_CV_CANVAS_FUCHSIA_HOUSE2_FuchsiaCity_House2_Text_HowAreTheFishBiting
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_House2_EventScript_GiveGoodRod:
	NPCMsg msg_0960_CV_CANVAS_FUCHSIA_HOUSE2_FuchsiaCity_House2_Text_LikeYourStyleTakeThis
	WaitButton
	HasSpaceForItem ITEM_GOOD_ROD, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq FuchsiaCity_House2_EventScript_NoRoomForGoodRod
	GiveItem ITEM_GOOD_ROD, 1, VAR_SPECIAL_RESULT
	BufferItemName 1, ITEM_GOOD_ROD
	BufferPlayersName 6
	NPCMsg msg_0960_CV_CANVAS_FUCHSIA_HOUSE2_FuchsiaCity_House2_Text_ReceivedGoodRod
	PlayFanfare SEQ_ME_LVUP
	WaitFanfare
	WaitButton
	NPCMsg msg_0960_CV_CANVAS_FUCHSIA_HOUSE2_FuchsiaCity_House2_Text_GoodRodCanCatchBetterMons
	WaitButton
	SetFlag 0x221F
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_House2_EventScript_NoRoomForGoodRod:
	NPCMsg msg_0960_CV_CANVAS_FUCHSIA_HOUSE2_FuchsiaCity_House2_Text_YouHaveNoRoomForGift
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0960_CV_CANVAS_FUCHSIA_HOUSE2_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
