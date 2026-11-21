#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R25.h"
#include "msgdata/msg/msg_0363_R25.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route25_Frlg#world by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route25_EventScript_ItemTM43
	ScrDef Route25_EventScript_Beauty
	ScrDef Route25_EventScript_Man
	ScrDef Route25_EventScript_ItemDouseDrive
	ScrDef BerryField_EventScript_FindWater
	ScrDef Route25_EventScript_SeaCottageSign
	ScrDef EventMons_EventScript_Cap2
	ScrDefEnd
	
Route25_EventScript_ItemTM43:
	SetVar 0x8004, ITEM_TM43
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
Route25_EventScript_Beauty:
	LockAll
	FacePlayer
	NPCMsg msg_0363_R25_Route25_Text_MistyHighHopesAboutThisPlace
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route25_EventScript_Man:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0363_R25_Route25_Text_AreYouHereAlone
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route25_EventScript_ItemDouseDrive:
	SetVar 0x8004, 116
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
BerryField_EventScript_FindWater:
	SetVar 0x8004, ITEM_PASSHO_BERRY
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
Route25_EventScript_SeaCottageSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0363_R25_Route25_Text_SeaCottageSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventMons_EventScript_Cap2:
	SetVar 0x8004, 2
	GoTo EventMons_EventScript_Cap
	
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
	NPCMsg msg_0363_R25_EventMons_Text_CapFound
	WaitFanfare
	BufferPlayersName 6
	NPCMsg msg_0363_R25_EventMons_Text_CapInCase
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventMons_EventScript_CapNoCase:
	NPCMsg msg_0363_R25_EventMons_Text_CapNoCase
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventMons_EventScript_ReleaseAllEnd:
	CanvasCloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0363_R25_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
