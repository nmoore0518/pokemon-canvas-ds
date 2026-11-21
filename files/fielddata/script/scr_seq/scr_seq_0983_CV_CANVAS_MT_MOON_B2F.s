#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_MT_MOON_B2F.h"
#include "msgdata/msg/msg_0863_CV_CANVAS_MT_MOON_B2F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's MtMoon_B2F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef MtMoon_B2F_EventScript_DomeFossil
	ScrDef MtMoon_B2F_EventScript_HelixFossil
	ScrDef MtMoon_B2F_EventScript_Miguel
	ScrDef MtMoon_B2F_EventScript_ItemStarPiece
	ScrDef MtMoon_B2F_EventScript_ItemTM46
	ScrDef MtMoon_B2F_EventScript_ItemRevive
	ScrDef MtMoon_B2F_EventScript_ItemAntidote
	ScrDef EventMons_EventScript_Cap1
	ScrDef MtMoon_B2F_EventScript_MiguelTrigger
	ScrDef MtMoon_B2F_OnTransition
	ScrDefEnd
	
MtMoon_B2F_EventScript_DomeFossil:
	LockAll
	FacePlayer
	NPCMsg msg_0863_CV_CANVAS_MT_MOON_B2F_MtMoon_B2F_Text_YouWantDomeFossil
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq MtMoon_B2F_EventScript_DontTakeFossil
	HidePerson 1
	SetFlag 0x20C5
	GiveItem ITEM_DOME_FOSSIL, 1, VAR_SPECIAL_RESULT
	BufferItemName 1, ITEM_DOME_FOSSIL
	NPCMsg msg_0863_CV_CANVAS_MT_MOON_B2F_MtMoon_B2F_Text_ObtainedDomeFossil
	PlayFanfare SEQ_ME_ITEM
	WaitFanfare
	WaitButton
	CanvasCloseMsg
	Wait 10, VAR_SPECIAL_RESULT
	ApplyMovement 3, MtMoon_B2F_Movement_MiguelToHelixFossil
	WaitMovement
	GetPersonCoords 3, 0x401E, 0x401F
	MovePerson 3, 0x401E, 0x401F
	PlayFanfare SEQ_ME_ITEM
	NPCMsg msg_0863_CV_CANVAS_MT_MOON_B2F_MtMoon_B2F_Text_ThenThisFossilIsMine
	WaitFanfare
	HidePerson 2
	SetFlag 0x20C6
	SetFlag 0x20C7
	SetFlag 0x20C8
	CloseMsg
	ReleaseAll
	End
	
MtMoon_B2F_EventScript_HelixFossil:
	LockAll
	FacePlayer
	NPCMsg msg_0863_CV_CANVAS_MT_MOON_B2F_MtMoon_B2F_Text_YouWantHelixFossil
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_3
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_4
_cv_yes_3:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq MtMoon_B2F_EventScript_DontTakeFossil
	HidePerson 2
	SetFlag 0x20C6
	GiveItem ITEM_HELIX_FOSSIL, 1, VAR_SPECIAL_RESULT
	BufferItemName 1, ITEM_HELIX_FOSSIL
	NPCMsg msg_0863_CV_CANVAS_MT_MOON_B2F_MtMoon_B2F_Text_ObtainedHelixFossil
	PlayFanfare SEQ_ME_ITEM
	WaitFanfare
	WaitButton
	CanvasCloseMsg
	Wait 10, VAR_SPECIAL_RESULT
	ApplyMovement 3, MtMoon_B2F_Movement_MiguelToDomeFossil
	WaitMovement
	GetPersonCoords 3, 0x401E, 0x401F
	MovePerson 3, 0x401E, 0x401F
	PlayFanfare SEQ_ME_ITEM
	NPCMsg msg_0863_CV_CANVAS_MT_MOON_B2F_MtMoon_B2F_Text_ThenThisFossilIsMine
	WaitFanfare
	HidePerson 1
	SetFlag 0x20C5
	SetFlag 0x20C9
	SetFlag 0x20C8
	CloseMsg
	ReleaseAll
	End
	
MtMoon_B2F_EventScript_Miguel:
	LockAll
	FacePlayer
	GoToIfSet 0x20C8, MtMoon_B2F_EventScript_MiguelFossilPicked
	CheckTrainerFlag 924
	GoToIf TRUE, MtMoon_B2F_EventScript_MiguelGoPickFossil
	Call MtMoon_B2F_EventScript_BattleMiguel
	CanvasCloseMsg
	ReleaseAll
	End
	
MtMoon_B2F_EventScript_ItemStarPiece:
	SetVar 0x8004, ITEM_STAR_PIECE
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
MtMoon_B2F_EventScript_ItemTM46:
	SetVar 0x8004, ITEM_TM46
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
MtMoon_B2F_EventScript_ItemRevive:
	SetVar 0x8004, ITEM_REVIVE
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
MtMoon_B2F_EventScript_ItemAntidote:
	SetVar 0x8004, ITEM_ANTIDOTE
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
EventMons_EventScript_Cap1:
	SetVar 0x8004, 1
	GoTo EventMons_EventScript_Cap
	
MtMoon_B2F_EventScript_MiguelTrigger:
	LockAll
	ApplyMovement 3, Common_Movement_WalkInPlaceFasterRight
	WaitMovement
	Call MtMoon_B2F_EventScript_BattleMiguel
	CanvasCloseMsg
	ReleaseAll
	End
	
MtMoon_B2F_OnTransition:
	CallIfUnset 0x20C8, MtMoon_B2F_EventScript_ShowFossils
	End
	
MtMoon_B2F_EventScript_DontTakeFossil:
	CanvasCloseMsg
	ReleaseAll
	End
	
MtMoon_B2F_EventScript_MiguelFossilPicked:
	NPCMsg msg_0863_CV_CANVAS_MT_MOON_B2F_MtMoon_B2F_Text_LabOnCinnabarRegeneratesFossils
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
MtMoon_B2F_EventScript_MiguelGoPickFossil:
	NPCMsg msg_0863_CV_CANVAS_MT_MOON_B2F_MtMoon_B2F_Text_WellEachTakeAFossil
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
MtMoon_B2F_EventScript_BattleMiguel:
	NPCMsg msg_0863_CV_CANVAS_MT_MOON_B2F_MtMoon_B2F_Text_MiguelIntro
	PlayBGM SEQ_GS_GYM
	WaitButton
	SetVar VAR_SPECIAL_LAST_TALKED, 3
	CanvasCloseMsg
	TrainerBattle 924, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_6
	WhiteOut
	End
_cv_won_6:
	SetTrainerFlag 924
	SetVar 0x5023, 1
	NPCMsg msg_0863_CV_CANVAS_MT_MOON_B2F_MtMoon_B2F_Text_WellEachTakeAFossil
	WaitButton
	Return
	
EventMons_EventScript_Cap:
	LockAll
	// TODO(gba) special EventMons_CapFound
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq EventMons_EventScript_CapNoCase
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq EventMons_EventScript_ReleaseAllEnd
	PlayFanfare SEQ_ME_ITEM
	BufferPlayersName 6
	NPCMsg msg_0863_CV_CANVAS_MT_MOON_B2F_EventMons_Text_CapFound
	WaitFanfare
	BufferPlayersName 6
	NPCMsg msg_0863_CV_CANVAS_MT_MOON_B2F_EventMons_Text_CapInCase
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
MtMoon_B2F_EventScript_ShowFossils:
	ClearFlag 0x20C5
	ClearFlag 0x20C6
	Return
	
EventMons_EventScript_CapNoCase:
	NPCMsg msg_0863_CV_CANVAS_MT_MOON_B2F_EventMons_Text_CapNoCase
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventMons_EventScript_ReleaseAllEnd:
	CanvasCloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0863_CV_CANVAS_MT_MOON_B2F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
MtMoon_B2F_Movement_MiguelToHelixFossil:
	WalkNormalEast
	WalkNormalNorth 3
	EndMovement

	.balign 4, 0
MtMoon_B2F_Movement_MiguelToDomeFossil:
	WalkNormalNorth 3
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterRight:
	WalkOnSpotFasterEast
	EndMovement
	.balign 4, 0
