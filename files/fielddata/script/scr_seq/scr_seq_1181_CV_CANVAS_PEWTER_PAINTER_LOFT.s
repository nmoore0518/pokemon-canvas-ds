#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_PEWTER_PAINTER_LOFT.h"
#include "msgdata/msg/msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PewterCity_PainterLoft_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef PainterLoft_EventScript_Painter
	ScrDef PainterLoft_EventScript_Smeargle
	ScrDef PainterLoft_EventScript_Easel
	ScrDef PainterLoft_EventScript_Canvases
	ScrDef PainterLoft_EventScript_Paint
	ScrDef PainterLoft_EventScript_PaintPot
	ScrDef _cv_unported_6
	ScrDefEnd
	
PainterLoft_EventScript_Painter:
	LockAll
	FacePlayer
	// TODO(gba) special Painter_GetPending
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe PainterLoft_EventScript_Ready
	// TODO(gba) special Painter_GetOffer
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PainterLoft_EventScript_NoBadge
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq PainterLoft_EventScript_First
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq PainterLoft_EventScript_NeedSmeargle
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfEq PainterLoft_EventScript_Sketch
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfEq PainterLoft_EventScript_Mega
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfEq PainterLoft_EventScript_Both
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_Nothing
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PainterLoft_EventScript_Smeargle:
	LockAll
	FacePlayer
	PlayCry SPECIES_SMEARGLE, 0
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_Smeargle
	WaitButton
	WaitCry
	CloseMsg
	ReleaseAll
	End
	
PainterLoft_EventScript_Easel:
	LockAll
	// TODO(gba) special Painter_GetPending
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PainterLoft_EventScript_EaselBlank
	// TODO(gba) special Painter_CanEnter
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq PainterLoft_EventScript_EaselNoRoom
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq PainterLoft_EventScript_EaselNoSmeargle
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfEq PainterLoft_EventScript_EaselTooFew
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_EaselAsk
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PainterLoft_EventScript_EaselNotYet
	// TODO(gba) special Painter_GetPending
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq PainterLoft_EventScript_Lend
	BufferPlayersName 6
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_SteppingIn
	WaitButton
	CloseMsg
	PlaySE SEQ_SE_DP_SELECT
	// TODO(gba) special Painter_Enter
	GoTo _cv_stop
	ReleaseAll
	End
	
PainterLoft_EventScript_Canvases:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_Canvases
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PainterLoft_EventScript_Paint:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_Paint
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PainterLoft_EventScript_PaintPot:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_PaintPot
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PainterLoft_EventScript_Returned:
	LockAll
	HealParty
	// TODO(gba) special Painter_Return
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq PainterLoft_EventScript_FirstWon
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq PainterLoft_EventScript_FirstLost
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfEq PainterLoft_EventScript_Sketched
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfEq PainterLoft_EventScript_NoSketch
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfEq PainterLoft_EventScript_SketchLost
	CompareVarToValue VAR_SPECIAL_RESULT, 6
	GoToIfEq PainterLoft_EventScript_MegaWon
	CompareVarToValue VAR_SPECIAL_RESULT, 7
	GoToIfEq PainterLoft_EventScript_MegaLost
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_CameBackEarly
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PainterLoft_EventScript_Ready:
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_Ready
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PainterLoft_EventScript_NoBadge:
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_NoBadge
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PainterLoft_EventScript_First:
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_FirstIntro
	WaitButton
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_FirstAsk
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_3
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_4
_cv_yes_3:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PainterLoft_EventScript_Later
	// TODO(gba) special Painter_CheckRoom
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PainterLoft_EventScript_NoRoom
	// TODO(gba) special Painter_PrepareFirst
	GoTo _cv_stop
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_FirstGo
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PainterLoft_EventScript_NeedSmeargle:
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_NeedSmeargle
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PainterLoft_EventScript_Sketch:
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_SketchIntro
	WaitButton
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_SketchAsk
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_5
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_6
_cv_yes_5:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_6:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PainterLoft_EventScript_Later
	End
	
PainterLoft_EventScript_Mega:
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_MegaIntro
	WaitButton
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_MegaAsk
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_7
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_8
_cv_yes_7:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_8:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PainterLoft_EventScript_Later
	End
	
PainterLoft_EventScript_Both:
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_BothAsk
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_ANewMove, 0
	ScrCmd_559 msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_TheMega, 1
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_10
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_10:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PainterLoft_EventScript_ChooseType
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq PainterLoft_EventScript_MegaReady
	GoTo PainterLoft_EventScript_Later
	
PainterLoft_EventScript_EaselBlank:
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_EaselBlank
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PainterLoft_EventScript_EaselNoRoom:
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_NoRoom
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PainterLoft_EventScript_EaselNoSmeargle:
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_NeedSmeargle
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PainterLoft_EventScript_EaselTooFew:
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_TooFew
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PainterLoft_EventScript_EaselNotYet:
	ReleaseAll
	End
	
PainterLoft_EventScript_Lend:
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_Lend
	WaitButton
	PlayFanfare SEQ_ME_ITEM
	BufferPlayersName 6
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_Borrowed
	WaitFanfare
	Return
	
PainterLoft_EventScript_FirstWon:
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_FirstWon
	WaitButton
	// TODO(gba) special Painter_GiveSmeargle
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq PainterLoft_EventScript_GiftNoRoom
	CopyVar 0x8005, VAR_SPECIAL_RESULT
	HidePerson 2
	PlayFanfare SEQ_ME_ITEM
	BufferPlayersName 6
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_ReceivedSmeargle
	WaitFanfare
	CompareVarToValue 0x8005, 1
	CallIfEq PainterLoft_EventScript_GiftToPC
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_FirstExplain
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PainterLoft_EventScript_FirstLost:
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_FirstLost
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PainterLoft_EventScript_Sketched:
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_Sketched
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PainterLoft_EventScript_NoSketch:
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_NoSketch
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PainterLoft_EventScript_SketchLost:
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_SketchLost
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PainterLoft_EventScript_MegaWon:
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_MegaWon
	WaitButton
	SetFlag 0x2220
	SetVar VAR_SPECIAL_RESULT, 1
	SetFlag 0x2221
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_MegaExplain
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PainterLoft_EventScript_MegaLost:
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_MegaLost
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PainterLoft_EventScript_Later:
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_Later
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PainterLoft_EventScript_NoRoom:
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_NoRoom
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PainterLoft_EventScript_ChooseType:
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_WhichType
	TouchscreenMenuHide
_cv_page_11:
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_Normal, 0
	ScrCmd_559 msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_Fire, 1
	ScrCmd_559 msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_Water, 2
	ScrCmd_559 msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_Grass, 3
	ScrCmd_559 msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_Electric, 4
	ScrCmd_559 msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_Ice, 5
	ScrCmd_559 msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_cv_more, 254
	ScrCmd_067
	CompareVarToValue VAR_SPECIAL_RESULT, 254
	GoToIfEq _cv_page_12
	GoTo _cv_page_13_end
_cv_page_12:
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_Fighting, 6
	ScrCmd_559 msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_Poison, 7
	ScrCmd_559 msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_Ground, 8
	ScrCmd_559 msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_Flying, 9
	ScrCmd_559 msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_Psychic, 10
	ScrCmd_559 msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_Bug, 11
	ScrCmd_559 msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_cv_more, 254
	ScrCmd_067
	CompareVarToValue VAR_SPECIAL_RESULT, 254
	GoToIfEq _cv_page_13
	GoTo _cv_page_13_end
_cv_page_13:
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_Rock, 12
	ScrCmd_559 msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_Ghost, 13
	ScrCmd_559 msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_Dragon, 14
	ScrCmd_559 msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_Dark, 15
	ScrCmd_559 msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_Steel, 16
	ScrCmd_559 msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_Fairy, 17
	ScrCmd_559 msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_cv_more, 254
	ScrCmd_067
	CompareVarToValue VAR_SPECIAL_RESULT, 254
	GoToIfEq _cv_page_11
_cv_page_13_end:
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_14
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_14:
	CompareVarToValue VAR_SPECIAL_RESULT, 18
	GoToIfGe PainterLoft_EventScript_Later
	CopyVar 0x8006, VAR_SPECIAL_RESULT
	// TODO(gba) special Painter_FindSmeargle
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq PainterLoft_EventScript_SketchReady
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_WhichSlot
	WaitButton
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special MoveDeleterChooseMoveToForget
	GoTo _cv_stop
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	CompareVarToValue 0x8005, 4
	GoToIfEq PainterLoft_EventScript_Later
	// TODO(gba) special BufferMoveDeleterNicknameAndMove
	GoTo _cv_stop
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_ConfirmSlot
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_15
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_16
_cv_yes_15:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_16:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PainterLoft_EventScript_Later
	End
	
PainterLoft_EventScript_MegaReady:
	// TODO(gba) special Painter_FindSmeargle
	GoTo _cv_stop
	// TODO(gba) special Painter_PrepareMega
	GoTo _cv_stop
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_MegaGo
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PainterLoft_EventScript_GiftNoRoom:
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_GiftNoRoom
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PainterLoft_EventScript_GiftToPC:
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_GiftToPC
	WaitButton
	Return
	
PainterLoft_EventScript_SketchReady:
	// TODO(gba) special Painter_PrepareSketch
	GoTo _cv_stop
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_PainterLoft_Text_SketchGo
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_6:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0962_CV_CANVAS_PEWTER_PAINTER_LOFT_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
