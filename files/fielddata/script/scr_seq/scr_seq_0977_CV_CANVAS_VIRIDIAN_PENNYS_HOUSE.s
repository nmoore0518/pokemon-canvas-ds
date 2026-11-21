#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_VIRIDIAN_PENNYS_HOUSE.h"
#include "msgdata/msg/msg_0860_CV_CANVAS_VIRIDIAN_PENNYS_HOUSE.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's ViridianCity_PennysHouse_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef ViridianCity_PennysHouse_EventScript_Penny
	ScrDef ViridianCity_PennysHouse_EventScript_Plush
	ScrDef ViridianCity_PennysHouse_EventScript_PlushNew
	ScrDef Canvas_PennysHouse_EventScript_PlushOdeon
	ScrDef Canvas_PennysHouse_EventScript_PlushHypereon
	ScrDef Canvas_PennysHouse_EventScript_PlushAutomateon
	ScrDef Canvas_PennysHouse_EventScript_PlushAppariteon
	ScrDefEnd
	
ViridianCity_PennysHouse_EventScript_Penny:
	LockAll
	FacePlayer
	GoToIfSet 0x20A1, ViridianCity_PennysHouse_EventScript_PennyAgain
	NPCMsg msg_0860_CV_CANVAS_VIRIDIAN_PENNYS_HOUSE_ViridianCity_PennysHouse_Text_Intro
	WaitButton
	SetFlag 0x20A1
	GoTo ViridianCity_PennysHouse_EventScript_FirstEevee
	
ViridianCity_PennysHouse_EventScript_Plush:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0860_CV_CANVAS_VIRIDIAN_PENNYS_HOUSE_ViridianCity_PennysHouse_Text_Plush
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianCity_PennysHouse_EventScript_PlushNew:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0860_CV_CANVAS_VIRIDIAN_PENNYS_HOUSE_ViridianCity_PennysHouse_Text_PlushNew
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Canvas_PennysHouse_EventScript_PlushOdeon:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0860_CV_CANVAS_VIRIDIAN_PENNYS_HOUSE_Canvas_PennysHouse_EventScript_PlushOdeon_Text
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Canvas_PennysHouse_EventScript_PlushHypereon:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0860_CV_CANVAS_VIRIDIAN_PENNYS_HOUSE_Canvas_PennysHouse_EventScript_PlushHypereon_Text
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Canvas_PennysHouse_EventScript_PlushAutomateon:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0860_CV_CANVAS_VIRIDIAN_PENNYS_HOUSE_Canvas_PennysHouse_EventScript_PlushAutomateon_Text
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Canvas_PennysHouse_EventScript_PlushAppariteon:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0860_CV_CANVAS_VIRIDIAN_PENNYS_HOUSE_Canvas_PennysHouse_EventScript_PlushAppariteon_Text
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianCity_PennysHouse_EventScript_PennyAgain:
	GoToIfUnset 0x20A2, ViridianCity_PennysHouse_EventScript_FirstEevee
	CompareVarToValue 0x5004, 3
	GoToIfLt ViridianCity_PennysHouse_EventScript_NotYet
	// TODO(gba) special Penny_HasEevee
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq ViridianCity_PennysHouse_EventScript_BringAnother
	NPCMsg msg_0860_CV_CANVAS_VIRIDIAN_PENNYS_HOUSE_ViridianCity_PennysHouse_Text_AnotherEevee
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq ViridianCity_PennysHouse_EventScript_Maybe
	NPCMsg msg_0860_CV_CANVAS_VIRIDIAN_PENNYS_HOUSE_ViridianCity_PennysHouse_Text_WhichType
	Call ViridianCity_PennysHouse_EventScript_PushTypes
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_4
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq ViridianCity_PennysHouse_EventScript_Maybe
	CopyVar 0x8004, VAR_SPECIAL_RESULT
	CanvasCloseMsg
	// TODO(gba) special Penny_WasGiven
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq ViridianCity_PennysHouse_EventScript_Already
	Call ViridianCity_PennysHouse_EventScript_Teach
	CanvasCloseMsg
	ReleaseAll
	End
	
ViridianCity_PennysHouse_EventScript_FirstEevee:
	// TODO(gba) special Penny_HasEevee
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq ViridianCity_PennysHouse_EventScript_StillLooking
	NPCMsg msg_0860_CV_CANVAS_VIRIDIAN_PENNYS_HOUSE_ViridianCity_PennysHouse_Text_YouFoundOne
	WaitButton
	CopyVar 0x8004, 0x5019
	Call ViridianCity_PennysHouse_EventScript_Teach
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq ViridianCity_PennysHouse_EventScript_End
	SetFlag 0x20A2
	NPCMsg msg_0860_CV_CANVAS_VIRIDIAN_PENNYS_HOUSE_ViridianCity_PennysHouse_Text_ComeBackLater
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianCity_PennysHouse_EventScript_NotYet:
	NPCMsg msg_0860_CV_CANVAS_VIRIDIAN_PENNYS_HOUSE_ViridianCity_PennysHouse_Text_NotYet
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianCity_PennysHouse_EventScript_BringAnother:
	NPCMsg msg_0860_CV_CANVAS_VIRIDIAN_PENNYS_HOUSE_ViridianCity_PennysHouse_Text_BringAnother
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianCity_PennysHouse_EventScript_Maybe:
	NPCMsg msg_0860_CV_CANVAS_VIRIDIAN_PENNYS_HOUSE_ViridianCity_PennysHouse_Text_Maybe
	WaitButton
	GoTo ViridianCity_PennysHouse_EventScript_End
	
ViridianCity_PennysHouse_EventScript_PushTypes:
	Return
	
ViridianCity_PennysHouse_EventScript_Already:
	// TODO(gba) special Penny_BufferEvo
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq ViridianCity_PennysHouse_EventScript_AlreadyFairy
	NPCMsg msg_0860_CV_CANVAS_VIRIDIAN_PENNYS_HOUSE_ViridianCity_PennysHouse_Text_Already
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianCity_PennysHouse_EventScript_Teach:
	// TODO(gba) special Penny_BufferEvo
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq ViridianCity_PennysHouse_EventScript_TeachFairy
	NPCMsg msg_0860_CV_CANVAS_VIRIDIAN_PENNYS_HOUSE_ViridianCity_PennysHouse_Text_ForThisType
	WaitButton
	SetOrCopyVar 0x8004, 0x8005
	SetOrCopyVar 0x8005, 1
	HasSpaceForItem 0x8004, 0x8005, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_full_5
	CallStd std_give_item_verbose
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_given_6
_cv_full_5:
	SetVar VAR_SPECIAL_RESULT, 0
_cv_given_6:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq ViridianCity_PennysHouse_EventScript_BagFull
	// TODO(gba) special Penny_MarkGiven
	GoTo _cv_stop
	// TODO(gba) special Penny_BufferEvo
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq ViridianCity_PennysHouse_EventScript_TeachUse
	NPCMsg msg_0860_CV_CANVAS_VIRIDIAN_PENNYS_HOUSE_ViridianCity_PennysHouse_Text_HowHold
	WaitButton
	SetVar VAR_SPECIAL_RESULT, 1
	Return
	
ViridianCity_PennysHouse_EventScript_StillLooking:
	NPCMsg msg_0860_CV_CANVAS_VIRIDIAN_PENNYS_HOUSE_ViridianCity_PennysHouse_Text_StillLooking
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianCity_PennysHouse_EventScript_End:
	CanvasCloseMsg
	ReleaseAll
	End
	
ViridianCity_PennysHouse_EventScript_AlreadyFairy:
	NPCMsg msg_0860_CV_CANVAS_VIRIDIAN_PENNYS_HOUSE_ViridianCity_PennysHouse_Text_HowFairy
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianCity_PennysHouse_EventScript_TeachFairy:
	NPCMsg msg_0860_CV_CANVAS_VIRIDIAN_PENNYS_HOUSE_ViridianCity_PennysHouse_Text_HowFairy
	WaitButton
	// TODO(gba) special Penny_MarkGiven
	GoTo _cv_stop
	SetVar VAR_SPECIAL_RESULT, 1
	Return
	
ViridianCity_PennysHouse_EventScript_BagFull:
	NPCMsg msg_0860_CV_CANVAS_VIRIDIAN_PENNYS_HOUSE_ViridianCity_PennysHouse_Text_BagFull
	WaitButton
	SetVar VAR_SPECIAL_RESULT, 0
	Return
	
ViridianCity_PennysHouse_EventScript_TeachUse:
	NPCMsg msg_0860_CV_CANVAS_VIRIDIAN_PENNYS_HOUSE_ViridianCity_PennysHouse_Text_HowUse
	WaitButton
	SetVar VAR_SPECIAL_RESULT, 1
	Return

_cv_stop:
	NPCMsg msg_0860_CV_CANVAS_VIRIDIAN_PENNYS_HOUSE_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
