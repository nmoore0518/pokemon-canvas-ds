#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T01R0101.h"
#include "msgdata/msg/msg_0447_T01R0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PalletTown_PlayersHouse_1F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef PalletTown_PlayersHouse_1F_EventScript_Mom
	ScrDef PalletTown_PlayersHouse_1F_EventScript_TV
	ScrDef DadStory_EventScript_HouseOnLoad
	ScrDef _cv_unported_3
	ScrDef DadStory_EventScript_MomWhyWithHim
	ScrDefEnd
	
PalletTown_PlayersHouse_1F_EventScript_Mom:
	LockAll
	FacePlayer
	GoToIfSet 0x200B, PalletTown_PlayersHouse_1F_EventScript_MomHeal
	GetPlayerGender VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	CallIfEq PalletTown_PlayersHouse_1F_EventScript_MomOakLookingForYouMale
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq PalletTown_PlayersHouse_1F_EventScript_MomOakLookingForYouFemale
	CanvasCloseMsg
	ApplyMovement 1, Common_Movement_FaceOriginalDirection
	WaitMovement
	CanvasCloseMsg
	ReleaseAll
	End
	
PalletTown_PlayersHouse_1F_EventScript_TV:
	LockAll
	CompareVarToValue 0x5002, 0
	GoToIfEq PalletTown_PlayersHouse_1F_EventScript_TVScreen
	NPCMsg msg_0447_T01R0101_PalletTown_PlayersHouse_1F_Text_OopsWrongSide
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
DadStory_EventScript_HouseOnLoad:
	GoToIfSet 0x200C, DadStory_EventScript_End
	CompareVarToValue 0x5008, 5
	GoToIfEq DadStory_EventScript_HideStairs
	CheckTrainerFlag 1085
	GoToIf TRUE, DadStory_EventScript_OldSaveStairs
	GoTo DadStory_EventScript_HideStairs
	
DadStory_EventScript_MomDadsBall:
	LockAll
	ApplyMovement 1, Common_Movement_WalkInPlaceFasterRight
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterLeft
	WaitMovement
	BufferPlayersName 6
	NPCMsg msg_0447_T01R0101_DadStory_Text_MomDadsBall
	WaitButton
	// TODO(gba) special DadStory_GetGymTypeBall
	GoTo _cv_stop
	SetOrCopyVar 0x8004, VAR_SPECIAL_RESULT
	SetOrCopyVar 0x8005, 1
	HasSpaceForItem 0x8004, 0x8005, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_full_1
	CallStd std_give_item_verbose
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_given_2
_cv_full_1:
	SetVar VAR_SPECIAL_RESULT, 0
_cv_given_2:
	NPCMsg msg_0447_T01R0101_DadStory_Text_MomMoveExtractor
	WaitButton
	CanvasCloseMsg
	SetVar 0x5008, 4
	ApplyMovement 1, Common_Movement_WalkInPlaceFasterLeft
	WaitMovement
	CanvasCloseMsg
	ReleaseAll
	End
	
DadStory_EventScript_MomWhyWithHim:
	LockAll
	ApplyMovement 1, Common_Movement_WalkInPlaceFasterRight
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterLeft
	WaitMovement
	NPCMsg msg_0447_T01R0101_DadStory_Text_MomWhyWithHim
	WaitButton
	CanvasCloseMsg
	ApplyMovement 1, DadStory_Movement_MomToBookcase
	ApplyMovement obj_player, DadStory_Movement_PlayerToBookcase
	WaitMovement
	Wait 20, VAR_SPECIAL_RESULT
	SetVar 0x8004, 1
	SetVar 0x8005, 0
	SetVar 0x8006, 6
	SetVar 0x8007, 3
	PlaySE SEQ_SE_DP_SELECT
	ScreenShake 0x8005, 0x8004, 0x8007, 0x8006
	Call DadStory_EventScript_RevealStairs
	SetFlag 0x200C
	Wait 40, VAR_SPECIAL_RESULT
	ApplyMovement 1, Common_Movement_WalkInPlaceFasterRight
	WaitMovement
	Wait 20, VAR_SPECIAL_RESULT
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	Warp MAP_FIGHT_AREA_UNUSED_6, 0, 12, 3, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	CanvasCloseMsg
	ReleaseAll
	End
	
PalletTown_PlayersHouse_1F_EventScript_MomHeal:
	CompareVarToValue 0x5008, 8
	CallIfGe DadStory_EventScript_MomAtHome
	BufferPlayersName 6
	NPCMsg msg_0447_T01R0101_PalletTown_PlayersHouse_1F_Text_YouShouldTakeQuickRest
	WaitButton
	CanvasCloseMsg
	Call Common_EventScript_OutOfCenterPartyHeal
	NPCMsg msg_0447_T01R0101_PalletTown_PlayersHouse_1F_Text_LookingGreatTakeCare
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_PlayersHouse_1F_EventScript_MomOakLookingForYouMale:
	NPCMsg msg_0447_T01R0101_PalletTown_PlayersHouse_1F_Text_AllBoysLeaveOakLookingForYou
	WaitButton
	Return
	
PalletTown_PlayersHouse_1F_EventScript_MomOakLookingForYouFemale:
	NPCMsg msg_0447_T01R0101_PalletTown_PlayersHouse_1F_Text_AllGirlsLeaveOakLookingForYou
	WaitButton
	Return
	
PalletTown_PlayersHouse_1F_EventScript_TVScreen:
	GetPlayerGender VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	CallIfEq PalletTown_PlayersHouse_1F_EventScript_TVScreenMale
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq PalletTown_PlayersHouse_1F_EventScript_TVScreenFemale
	CanvasCloseMsg
	ReleaseAll
	End
	
DadStory_EventScript_End:
	End
	
DadStory_EventScript_HideStairs:
	// (the GBA redraws a square here: 7, 0, 0x02E, TRUE)
	// (the GBA redraws a square here: 8, 0, 0x02F, TRUE)
	// (the GBA redraws a square here: 7, 1, 0x036, TRUE)
	// (the GBA redraws a square here: 8, 1, 0x037, TRUE)
	// (the GBA redraws a square here: 7, 2, 0x03E, TRUE)
	// (the GBA redraws a square here: 8, 2, 0x03F, TRUE)
	// (the GBA redraws a square here: 9, 2, 0x01D, FALSE)
	// (the GBA redraws a square here: 7, 3, 0x001, FALSE)
	// (the GBA redraws a square here: 8, 3, 0x001, FALSE)
	// (the GBA redraws a square here: 9, 3, 0x025, FALSE)
	End
	
DadStory_EventScript_OldSaveStairs:
	SetFlag 0x200C
	GoTo DadStory_EventScript_End
	
DadStory_EventScript_RevealStairs:
	// (the GBA redraws a square here: 7, 0, 0x021, TRUE)
	// (the GBA redraws a square here: 8, 0, 0x022, TRUE)
	// (the GBA redraws a square here: 7, 1, 0x029, TRUE)
	// (the GBA redraws a square here: 8, 1, 0x02A, TRUE)
	// (the GBA redraws a square here: 7, 2, 0x005, TRUE)
	// (the GBA redraws a square here: 8, 2, 0x006, TRUE)
	// (the GBA redraws a square here: 9, 2, 0x007, FALSE)
	// (the GBA redraws a square here: 7, 3, 0x00D, TRUE)
	// (the GBA redraws a square here: 8, 3, 0x00E, TRUE)
	// (the GBA redraws a square here: 9, 3, 0x00F, FALSE)
	Return
	
DadStory_EventScript_MomAtHome:
	BufferPlayersName 6
	NPCMsg msg_0447_T01R0101_DadStory_Text_MomAfterViridian
	WaitButton
	CompareVarToValue 0x5008, 10
	CallIfLt DadStory_EventScript_MomArcherNudge
	Return
	
Common_EventScript_OutOfCenterPartyHeal:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	PlayFanfare SEQ_ME_ASA
	WaitFanfare
	HealParty
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	Return
	
PalletTown_PlayersHouse_1F_EventScript_TVScreenMale:
	NPCMsg msg_0447_T01R0101_PalletTown_PlayersHouse_1F_Text_MovieOnTVFourBoysOnRailroad
	WaitButton
	Return
	
PalletTown_PlayersHouse_1F_EventScript_TVScreenFemale:
	NPCMsg msg_0447_T01R0101_PalletTown_PlayersHouse_1F_Text_MovieOnTVGirlOnBrickRoad
	WaitButton
	Return
	
DadStory_EventScript_MomArcherNudge:
	NPCMsg msg_0447_T01R0101_DadStory_Text_MomArcherNudge
	WaitButton
	Return

_cv_unported_3:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0447_T01R0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0447_T01R0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
Common_Movement_FaceOriginalDirection:
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterRight:
	WalkOnSpotFasterEast
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterLeft:
	WalkOnSpotFasterWest
	EndMovement

	.balign 4, 0
DadStory_Movement_MomToBookcase:
	WalkNormalNorth 2
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
DadStory_Movement_PlayerToBookcase:
	Delay16
	WalkNormalNorth 2
	WalkOnSpotFasterWest
	EndMovement
	.balign 4, 0
