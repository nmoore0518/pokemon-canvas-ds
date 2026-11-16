#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SSANNE_KITCHEN.h"
#include "msgdata/msg/msg_0908_CV_CANVAS_SSANNE_KITCHEN.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SSAnne_Kitchen_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SSAnne_Kitchen_EventScript_Chef1
	ScrDef SSAnne_Kitchen_EventScript_Chef2
	ScrDef SSAnne_Kitchen_EventScript_Chef3
	ScrDef SSAnne_Kitchen_EventScript_Chef4
	ScrDef SSAnne_Kitchen_EventScript_Chef5
	ScrDef SSAnne_Kitchen_EventScript_Chef6
	ScrDef SSAnne_Kitchen_EventScript_Chef7
	ScrDef SSAnne_Kitchen_EventScript_ItemGreatBall
	ScrDefEnd
	
SSAnne_Kitchen_EventScript_Chef1:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0908_CV_CANVAS_SSANNE_KITCHEN_SSAnne_Kitchen_Text_BusyOutOfTheWay
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SSAnne_Kitchen_EventScript_Chef2:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0908_CV_CANVAS_SSANNE_KITCHEN_SSAnne_Kitchen_Text_SawOddBerryInTrash
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SSAnne_Kitchen_EventScript_Chef3:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0908_CV_CANVAS_SSANNE_KITCHEN_SSAnne_Kitchen_Text_SoBusyImDizzy
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SSAnne_Kitchen_EventScript_Chef4:
	LockAll
	FacePlayer
	NPCMsg msg_0908_CV_CANVAS_SSANNE_KITCHEN_SSAnne_Kitchen_Text_IAmLeChefMainCourseIs
	WaitButton
	Random VAR_SPECIAL_RESULT, 3
	CopyVar 0x8008, VAR_SPECIAL_RESULT
	CompareVarToValue 0x8008, 0
	CallIfEq SSAnne_Kitchen_EventScript_SalmonDuSalad
	CompareVarToValue 0x8008, 1
	CallIfEq SSAnne_Kitchen_EventScript_EelsAuBarbecue
	CompareVarToValue 0x8008, 2
	CallIfEq SSAnne_Kitchen_EventScript_PrimeBeefsteak
	CloseMsg
	ReleaseAll
	End
	
SSAnne_Kitchen_EventScript_Chef5:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0908_CV_CANVAS_SSANNE_KITCHEN_SSAnne_Kitchen_Text_PeelSpudsEveryDay
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SSAnne_Kitchen_EventScript_Chef6:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0908_CV_CANVAS_SSANNE_KITCHEN_SSAnne_Kitchen_Text_HearAboutSnorlaxItsAGlutton
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SSAnne_Kitchen_EventScript_Chef7:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0908_CV_CANVAS_SSANNE_KITCHEN_SSAnne_Kitchen_Text_OnlyGetToPeelOnions
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SSAnne_Kitchen_EventScript_ItemGreatBall:
	SetVar 0x8004, ITEM_GREAT_BALL
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
SSAnne_Kitchen_EventScript_SalmonDuSalad:
	NPCMsg msg_0908_CV_CANVAS_SSANNE_KITCHEN_SSAnne_Kitchen_Text_SalmonDuSalad
	WaitButton
	Return
	
SSAnne_Kitchen_EventScript_EelsAuBarbecue:
	NPCMsg msg_0908_CV_CANVAS_SSANNE_KITCHEN_SSAnne_Kitchen_Text_EelsAuBarbecue
	WaitButton
	Return
	
SSAnne_Kitchen_EventScript_PrimeBeefsteak:
	NPCMsg msg_0908_CV_CANVAS_SSANNE_KITCHEN_SSAnne_Kitchen_Text_PrimeBeefsteak
	WaitButton
	Return

_cv_stop:
	NPCMsg msg_0908_CV_CANVAS_SSANNE_KITCHEN_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
