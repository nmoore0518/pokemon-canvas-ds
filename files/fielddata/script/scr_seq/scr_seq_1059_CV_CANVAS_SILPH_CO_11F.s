#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SILPH_CO_11F.h"
#include "msgdata/msg/msg_0901_CV_CANVAS_SILPH_CO_11F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SilphCo_11F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SilphCo_11F_EventScript_ItemZinc
	ScrDef SilphCo_11F_EventScript_ItemStrongAcid
	ScrDef SilphCo_11F_EventScript_Door
	ScrDef SilphCo_11F_EventScript_FloorSign
	ScrDef _cv_unported_4
	ScrDef _cv_unported_5
	ScrDef SilphCo_11F_OnLoad
	ScrDef SilphCo_11F_OnTransition
	ScrDefEnd
	
SilphCo_11F_EventScript_ItemZinc:
	SetVar 0x8004, ITEM_ZINC
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
SilphCo_11F_EventScript_ItemStrongAcid:
	SetFlag 0x21C1
	SetVar VAR_SPECIAL_RESULT, 1
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
SilphCo_11F_EventScript_Door:
	LockAll
	SetVar 0x4001, 20
	SetVar 0x8004, 0
	GoToIfSet 0x21C2, EventScript_DoorUnlocked
	GoTo EventScript_TryUnlockDoor
	End
	
SilphCo_11F_EventScript_FloorSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0901_CV_CANVAS_SILPH_CO_11F_SilphCo_11F_Text_FloorSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SilphCo_11F_EventScript_GiovanniTriggerLeft:
	LockAll
	SetVar 0x4001, 0
	GoTo SilphCo_11F_EventScript_BattleGiovanni
	End
	
SilphCo_11F_EventScript_GiovanniTriggerRight:
	LockAll
	SetVar 0x4001, 1
	GoTo SilphCo_11F_EventScript_BattleGiovanni
	End
	
SilphCo_11F_OnLoad:
	CallIfUnset 0x21C2, EventScript_Close11FDoor
	End
	
SilphCo_11F_OnTransition:
	Call DadStory_EventScript_SilphTransition
	End
	
EventScript_DoorUnlocked:
	NPCMsg msg_0901_CV_CANVAS_SILPH_CO_11F_Text_TheDoorIsOpen
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_TryUnlockDoor:
	GoToIfSet 0x2198, EventScript_OpenDoor
	GoTo EventScript_NeedCardKey
	End
	
SilphCo_11F_EventScript_BattleGiovanni:
	ApplyMovement 1, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	Wait 25, VAR_SPECIAL_RESULT
	BufferPlayersName 6
	NPCMsg msg_0901_CV_CANVAS_SILPH_CO_11F_SilphCo_11F_Text_GiovanniIntro
	WaitButton
	CloseMsg
	CompareVarToValue 0x4001, 0
	CallIfEq SilphCo_11F_EventScript_GiovanniApproachLeft
	CompareVarToValue 0x4001, 1
	CallIfEq SilphCo_11F_EventScript_GiovanniApproachRight
	SetVar VAR_SPECIAL_LAST_TALKED, 1
	CheckTrainerFlag 1085
	GoToIf TRUE, _cv_beaten_1
	TrainerBattle 1085, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_2
	WhiteOut
	End
_cv_won_2:
	SetTrainerFlag 1085
	ReleaseAll
	End
_cv_beaten_1:
	BufferPlayersName 6
	NPCMsg msg_0901_CV_CANVAS_SILPH_CO_11F_SilphCo_11F_Text_GiovanniPostBattle
	WaitButton
	Call DadStory_EventScript_SilphGiovanniGives
	CloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	HidePerson 1
	SetFlag 0x2199
	HidePerson 2
	SetFlag 0x2199
	HidePerson 4
	SetFlag 0x2199
	HidePerson 6
	SetFlag 0x21C3
	SetFlag 0x21C3
	SetVar 0x5031, 1
	SetFlag 0x20FB
	ClearFlag 0x2062
	CompareVarToValue 0x5008, 5
	GoToIfEq DadStory_EventScript_SilphWarpHome
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	ReleaseAll
	End
	
EventScript_Close11FDoor:
	// TODO(gba) setmetatile 5, 16, METATILE_SilphCo_HorizontalBarrier_TopLeft, 1
	// TODO(gba) setmetatile 6, 16, METATILE_SilphCo_HorizontalBarrier_TopRight, 1
	// TODO(gba) setmetatile 5, 17, METATILE_SilphCo_HorizontalBarrier_BottomLeft, 1
	// TODO(gba) setmetatile 6, 17, METATILE_SilphCo_HorizontalBarrier_BottomRight, 1
	// TODO(gba) setmetatile 6, 18, METATILE_SilphCo_Floor_ShadeFull, 0
	Return
	
DadStory_EventScript_SilphTransition:
	SetFlag 0x21C3
	Return
	
EventScript_OpenDoor:
	PlayFanfare SEQ_ME_LVUP
	NPCMsg msg_0901_CV_CANVAS_SILPH_CO_11F_Text_CardKeyOpenedDoor
	WaitButton
	WaitFanfare
	CompareVarToValue 0x4001, 1
	CallIfEq EventScript_Open2FDoor1
	CompareVarToValue 0x4001, 2
	CallIfEq EventScript_Open2FDoor2
	CompareVarToValue 0x4001, 3
	CallIfEq EventScript_Open3FDoor1
	CompareVarToValue 0x4001, 4
	CallIfEq EventScript_Open3FDoor2
	CompareVarToValue 0x4001, 5
	CallIfEq EventScript_Open4FDoor1
	CompareVarToValue 0x4001, 6
	CallIfEq EventScript_Open4FDoor2
	CompareVarToValue 0x4001, 7
	CallIfEq EventScript_Open5FDoor1
	CompareVarToValue 0x4001, 8
	CallIfEq EventScript_Open5FDoor2
	CompareVarToValue 0x4001, 9
	CallIfEq EventScript_Open5FDoor3
	CompareVarToValue 0x4001, 10
	CallIfEq EventScript_Open6FDoor
	CompareVarToValue 0x4001, 11
	CallIfEq EventScript_Open7FDoor1
	CompareVarToValue 0x4001, 12
	CallIfEq EventScript_Open7FDoor2
	CompareVarToValue 0x4001, 13
	CallIfEq EventScript_Open7FDoor3
	CompareVarToValue 0x4001, 14
	CallIfEq EventScript_Open8FDoor
	CompareVarToValue 0x4001, 15
	CallIfEq EventScript_Open9FDoor1
	CompareVarToValue 0x4001, 16
	CallIfEq EventScript_Open9FDoor2
	CompareVarToValue 0x4001, 17
	CallIfEq EventScript_Open9FDoor3
	CompareVarToValue 0x4001, 18
	CallIfEq EventScript_Open9FDoor4
	CompareVarToValue 0x4001, 19
	CallIfEq EventScript_Open10FDoor
	CompareVarToValue 0x4001, 20
	CallIfEq EventScript_Open11FDoor
	WaitSE SEQ_SE_DP_SELECT
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	// TODO(gba) special SetHiddenItemFlag
	GoTo _cv_stop
	CloseMsg
	ReleaseAll
	End
	
EventScript_NeedCardKey:
	NPCMsg msg_0901_CV_CANVAS_SILPH_CO_11F_Text_ItNeedsCardKey
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SilphCo_11F_EventScript_GiovanniApproachLeft:
	ApplyMovement 1, SilphCo_11F_Movement_GiovanniApproachLeft
	ApplyMovement obj_player, SilphCo_11F_Movement_PlayerFaceGiovanni
	WaitMovement
	Return
	
SilphCo_11F_EventScript_GiovanniApproachRight:
	ApplyMovement 1, SilphCo_11F_Movement_GiovanniApproachRight
	WaitMovement
	Return
	
DadStory_EventScript_SilphGiovanniGives:
	NPCMsg msg_0901_CV_CANVAS_SILPH_CO_11F_DadStory_Text_GiovanniSilphGift
	WaitButton
	GiveItem ITEM_MASTER_BALL, 1, VAR_SPECIAL_RESULT
	SetFlag 0x21C4
	Call GymHack_EventScript_SilphGiovanniGift
	CloseMsg
	CompareVarToValue 0x5008, 5
	GoToIfGe Common_EventScript_NopReturn
	ClearFlag 0x21C3
	GoToIfUnset 0x21C3, _cv_show_3
	ClearFlag 0x21C3
	ShowPerson 6
	SetFlag 0x21C3
	GoTo _cv_shown_4
_cv_show_3:
	ShowPerson 6
_cv_shown_4:
	CompareVarToValue 0x4001, 0
	CallIfEq DadStory_EventScript_SilphMomLeft
	ApplyMovement 6, DadStory_Movement_MomRunIn
	WaitMovement
	PlaySE SEQ_SE_DP_SELECT
	ApplyMovement 6, Common_Movement_ExclamationMark
	WaitMovement
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	GetPlayerGender VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	CallIfEq DadStory_EventScript_MomSilphBoy
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq DadStory_EventScript_MomSilphGirl
	CloseMsg
	SetVar 0x5008, 5
	Return
	
DadStory_EventScript_SilphWarpHome:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	Warp MAP_PALLET_TOWN_REDS_HOUSE_1F, 0, 9, 5, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	ReleaseAll
	End
	
EventScript_Open2FDoor1:
	// TODO(gba) setmetatile 5, 8, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 6, 8, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 5, 9, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 6, 9, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 6, 10, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	Return
	
EventScript_Open2FDoor2:
	// TODO(gba) setmetatile 5, 15, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 6, 15, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 5, 16, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 6, 16, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 6, 17, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	Return
	
EventScript_Open3FDoor1:
	// TODO(gba) setmetatile 9, 11, METATILE_SilphCo_Wall_LeftEdge, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 10, 11, METATILE_SilphCo_Wall_RightEdge, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 9, 12, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 10, 12, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 9, 13, METATILE_SilphCo_Floor_WallLeftCorner, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 10, 13, METATILE_SilphCo_Floor_WallRightCorner, 0
	GoTo _cv_stop
	Return
	
EventScript_Open3FDoor2:
	// TODO(gba) setmetatile 20, 11, METATILE_SilphCo_Wall_LeftEdge, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 21, 11, METATILE_SilphCo_Wall_RightEdge, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 20, 12, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 21, 12, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 20, 13, METATILE_SilphCo_Floor_WallLeftCorner, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 21, 13, METATILE_SilphCo_Floor_WallRightCorner, 0
	GoTo _cv_stop
	Return
	
EventScript_Open4FDoor1:
	// TODO(gba) setmetatile 3, 16, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 4, 16, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 3, 17, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 4, 17, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 4, 18, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	Return
	
EventScript_Open4FDoor2:
	// TODO(gba) setmetatile 14, 11, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 15, 11, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 14, 12, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 15, 12, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 15, 13, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	Return
	
EventScript_Open5FDoor1:
	// TODO(gba) setmetatile 7, 8, METATILE_SilphCo_Wall_LeftEdge, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 8, 8, METATILE_SilphCo_Wall_RightEdge, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 7, 9, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 8, 9, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 7, 10, METATILE_SilphCo_Floor_WallLeftCorner, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 8, 10, METATILE_SilphCo_Floor_WallRightCorner, 0
	GoTo _cv_stop
	Return
	
EventScript_Open5FDoor2:
	// TODO(gba) setmetatile 7, 17, METATILE_SilphCo_Wall_LeftEdge, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 8, 17, METATILE_SilphCo_Wall_RightEdge, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 7, 18, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 8, 18, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 7, 19, METATILE_SilphCo_Floor_WallLeftCorner, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 8, 19, METATILE_SilphCo_Floor_WallRightCorner, 0
	GoTo _cv_stop
	Return
	
EventScript_Open5FDoor3:
	// TODO(gba) setmetatile 18, 12, METATILE_SilphCo_Wall_LeftEdge, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 19, 12, METATILE_SilphCo_Wall_RightEdge, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 18, 13, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 19, 13, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 18, 14, METATILE_SilphCo_Floor_WallLeftCorner, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 19, 14, METATILE_SilphCo_Floor_WallRightCorner, 0
	GoTo _cv_stop
	Return
	
EventScript_Open6FDoor:
	// TODO(gba) setmetatile 5, 14, METATILE_SilphCo_Wall_LeftEdge, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 6, 14, METATILE_SilphCo_Wall_RightEdge, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 5, 15, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 6, 15, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 5, 16, METATILE_SilphCo_Floor_WallLeftCorner, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 6, 16, METATILE_SilphCo_Floor_WallRightCorner, 0
	GoTo _cv_stop
	Return
	
EventScript_Open7FDoor1:
	// TODO(gba) setmetatile 11, 8, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 12, 8, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 11, 9, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 12, 9, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 12, 10, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	Return
	
EventScript_Open7FDoor2:
	// TODO(gba) setmetatile 24, 7, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 25, 7, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 24, 8, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 25, 8, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 25, 9, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	Return
	
EventScript_Open7FDoor3:
	// TODO(gba) setmetatile 25, 13, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 26, 13, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 25, 14, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 26, 14, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 26, 15, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	Return
	
EventScript_Open8FDoor:
	// TODO(gba) setmetatile 5, 9, METATILE_SilphCo_Wall_LeftEdge, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 6, 9, METATILE_SilphCo_Wall_RightEdge, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 5, 10, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 6, 10, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 5, 11, METATILE_SilphCo_Floor_WallLeftCorner, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 6, 11, METATILE_SilphCo_Floor_WallRightCorner, 0
	GoTo _cv_stop
	Return
	
EventScript_Open9FDoor1:
	// TODO(gba) setmetatile 2, 9, METATILE_SilphCo_Wall_LeftEdge, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 3, 9, METATILE_SilphCo_Wall_RightEdge, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 2, 10, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 3, 10, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 2, 11, METATILE_SilphCo_Floor_WallLeftCorner, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 3, 11, METATILE_SilphCo_Floor_WallRightCorner, 0
	GoTo _cv_stop
	Return
	
EventScript_Open9FDoor2:
	// TODO(gba) setmetatile 12, 15, METATILE_SilphCo_Wall_LeftEdge, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 13, 15, METATILE_SilphCo_Wall_RightEdge, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 12, 16, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 13, 16, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 12, 17, METATILE_SilphCo_Floor_WallLeftCorner, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 13, 17, METATILE_SilphCo_Floor_WallRightCorner, 0
	GoTo _cv_stop
	Return
	
EventScript_Open9FDoor3:
	// TODO(gba) setmetatile 21, 6, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 22, 6, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 21, 7, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 22, 7, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 22, 8, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	Return
	
EventScript_Open9FDoor4:
	// TODO(gba) setmetatile 21, 12, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 22, 12, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 21, 13, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 22, 13, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 22, 14, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	Return
	
EventScript_Open10FDoor:
	// TODO(gba) setmetatile 12, 11, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 13, 11, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 12, 12, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 13, 12, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 13, 13, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	Return
	
EventScript_Open11FDoor:
	// TODO(gba) setmetatile 5, 16, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 6, 16, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 5, 17, METATILE_SilphCo_Floor_ShadeFull, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 6, 17, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 6, 18, METATILE_SilphCo_Floor, 0
	GoTo _cv_stop
	Return
	
GymHack_EventScript_SilphGiovanniGift:
	GoToIfSet 0x21C5, GymHack_EventScript_GiftsDone
	NPCMsg msg_0901_CV_CANVAS_SILPH_CO_11F_GymHack_Text_SilphGiovanniMultivitamin
	WaitButton
	SetVar 0x8009, 0
	Call GymHack_EventScript_GiveStatItem
	SetFlag 0x21C5
	NPCMsg msg_0901_CV_CANVAS_SILPH_CO_11F_GymHack_Text_SilphGiovanniMultivitaminAfter
	WaitButton
	Return
	
Common_EventScript_NopReturn:
	Return
	
DadStory_EventScript_SilphMomLeft:
	// TODO(gba) setobjectxy LOCALID_SILPH_CO_11F_MOM, 5, 18
	GoTo _cv_stop
	Return
	
DadStory_EventScript_MomSilphBoy:
	BufferPlayersName 6
	NPCMsg msg_0901_CV_CANVAS_SILPH_CO_11F_DadStory_Text_MomSilphBoy
	WaitButton
	Return
	
DadStory_EventScript_MomSilphGirl:
	BufferPlayersName 6
	NPCMsg msg_0901_CV_CANVAS_SILPH_CO_11F_DadStory_Text_MomSilphGirl
	WaitButton
	Return
	
GymHack_EventScript_GiftsDone:
	Return
	
GymHack_EventScript_GiveStatItem:
	GiveItem 0x8009, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymHack_EventScript_GiveStatItemDone
	BufferItemName 1, 0x8009
	NPCMsg msg_0901_CV_CANVAS_SILPH_CO_11F_GymHack_Text_GiftSentToPC
	WaitButton
	End
	
GymHack_EventScript_GiveStatItemDone:
	Return

_cv_unported_4:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0901_CV_CANVAS_SILPH_CO_11F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_5:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0901_CV_CANVAS_SILPH_CO_11F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0901_CV_CANVAS_SILPH_CO_11F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
Common_Movement_WalkInPlaceFasterDown:
	WalkOnSpotFasterSouth
	EndMovement

	.balign 4, 0
SilphCo_11F_Movement_GiovanniApproachLeft:
	WalkNormalSouth 4
	WalkOnSpotFasterWest
	EndMovement

	.balign 4, 0
SilphCo_11F_Movement_PlayerFaceGiovanni:
	Delay16 3
	Delay8
	Delay4
	WalkOnSpotFasterEast
	EndMovement

	.balign 4, 0
SilphCo_11F_Movement_GiovanniApproachRight:
	WalkNormalSouth 3
	EndMovement

	.balign 4, 0
DadStory_Movement_MomRunIn:
	WalkFastNorth 2
	EndMovement

	.balign 4, 0
Common_Movement_ExclamationMark:
	EmoteExclamationMark
	EndMovement
	.balign 4, 0
