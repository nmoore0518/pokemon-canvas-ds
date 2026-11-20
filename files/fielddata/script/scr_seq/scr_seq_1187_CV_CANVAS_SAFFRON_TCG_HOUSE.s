#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SAFFRON_TCG_HOUSE.h"
#include "msgdata/msg/msg_0965_CV_CANVAS_SAFFRON_TCG_HOUSE.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SaffronCity_TcgHouse_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SaffronCity_TcgHouse_EventScript_Rod
	ScrDef SaffronCity_TcgHouse_OnTransition
	ScrDef SaffronCity_TcgHouse_OnResume
	ScrDefEnd
	
SaffronCity_TcgHouse_EventScript_Rod:
	LockAll
	FacePlayer
	GoToIfSet 0x2223, SaffronCity_TcgHouse_EventScript_RodAgain
	NPCMsg msg_0965_CV_CANVAS_SAFFRON_TCG_HOUSE_SaffronCity_TcgHouse_Text_Intro
	WaitButton
	SetFlag 0x2223
	NPCMsg msg_0965_CV_CANVAS_SAFFRON_TCG_HOUSE_SaffronCity_TcgHouse_Text_WantToDuel
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	GoTo SaffronCity_TcgHouse_EventScript_Answer
	
SaffronCity_TcgHouse_OnTransition:
	GoTo SaffronCity_TcgHouse_OnResume
	
SaffronCity_TcgHouse_OnResume:
	// TODO(gba) special PlayTcgHouseMusic
	End
	
SaffronCity_TcgHouse_EventScript_RodAgain:
	NPCMsg msg_0965_CV_CANVAS_SAFFRON_TCG_HOUSE_SaffronCity_TcgHouse_Text_WantToDuelAgain
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_3
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_4
_cv_yes_3:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_4:
	GoTo SaffronCity_TcgHouse_EventScript_Answer
	
SaffronCity_TcgHouse_EventScript_Answer:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq SaffronCity_TcgHouse_EventScript_Declined
	NPCMsg msg_0965_CV_CANVAS_SAFFRON_TCG_HOUSE_SaffronCity_TcgHouse_Text_ChooseDeck
	TouchscreenMenuHide
_cv_page_5:
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0965_CV_CANVAS_SAFFRON_TCG_HOUSE_SaffronCity_TcgHouse_Text_DeckGrass, 0
	ScrCmd_559 msg_0965_CV_CANVAS_SAFFRON_TCG_HOUSE_SaffronCity_TcgHouse_Text_DeckFire, 1
	ScrCmd_559 msg_0965_CV_CANVAS_SAFFRON_TCG_HOUSE_SaffronCity_TcgHouse_Text_DeckWater, 2
	ScrCmd_559 msg_0965_CV_CANVAS_SAFFRON_TCG_HOUSE_SaffronCity_TcgHouse_Text_DeckLightning, 3
	ScrCmd_559 msg_0965_CV_CANVAS_SAFFRON_TCG_HOUSE_SaffronCity_TcgHouse_Text_DeckPsychic, 4
	ScrCmd_559 msg_0965_CV_CANVAS_SAFFRON_TCG_HOUSE_SaffronCity_TcgHouse_Text_DeckFighting, 5
	ScrCmd_559 msg_0965_CV_CANVAS_SAFFRON_TCG_HOUSE_cv_more, 254
	ScrCmd_067
	CompareVarToValue VAR_SPECIAL_RESULT, 254
	GoToIfEq _cv_page_6
	GoTo _cv_page_6_end
_cv_page_6:
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0965_CV_CANVAS_SAFFRON_TCG_HOUSE_SaffronCity_TcgHouse_Text_DeckColorless, 6
	ScrCmd_559 msg_0965_CV_CANVAS_SAFFRON_TCG_HOUSE_cv_more, 254
	ScrCmd_067
	CompareVarToValue VAR_SPECIAL_RESULT, 254
	GoToIfEq _cv_page_5
_cv_page_6_end:
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_7
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_7:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq SaffronCity_TcgHouse_EventScript_Declined
	CopyVar 0x8004, VAR_SPECIAL_RESULT
	AddVar 0x8004, 1
	NPCMsg msg_0965_CV_CANVAS_SAFFRON_TCG_HOUSE_SaffronCity_TcgHouse_Text_LetsDuel
	WaitButton
	CloseMsg
	// TODO(gba) special StartTcgDuel
	GoTo _cv_stop
	LockAll
	FacePlayer
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe SaffronCity_TcgHouse_EventScript_Lost
	NPCMsg msg_0965_CV_CANVAS_SAFFRON_TCG_HOUSE_SaffronCity_TcgHouse_Text_YouWon
	WaitButton
	CopyVar 0x8005, 0x8004
	AddVar 0x8005, 0
	GiveItem 0x8005, 1, VAR_SPECIAL_RESULT
	NPCMsg msg_0965_CV_CANVAS_SAFFRON_TCG_HOUSE_SaffronCity_TcgHouse_Text_AboutEnergy
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_TcgHouse_EventScript_Declined:
	NPCMsg msg_0965_CV_CANVAS_SAFFRON_TCG_HOUSE_SaffronCity_TcgHouse_Text_Declined
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_TcgHouse_EventScript_Lost:
	NPCMsg msg_0965_CV_CANVAS_SAFFRON_TCG_HOUSE_SaffronCity_TcgHouse_Text_YouLost
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0965_CV_CANVAS_SAFFRON_TCG_HOUSE_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
