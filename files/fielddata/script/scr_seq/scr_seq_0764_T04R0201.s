#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T04R0201.h"
#include "msgdata/msg/msg_0472_T04R0201.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's CeruleanCity_House2_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef CeruleanCity_House2_EventScript_Hiker
	ScrDef CeruleanCity_House2_EventScript_Lass
	ScrDef CeruleanCity_House2_EventScript_WallHole
	ScrDefEnd
	
CeruleanCity_House2_EventScript_Hiker:
	LockAll
	FacePlayer
	GoToIfSet 0x20D5, CeruleanCity_House2_EventScript_HikerGotTM28
	NPCMsg msg_0472_T04R0201_CeruleanCity_House2_Text_RocketsStoleTMForDig
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeruleanCity_House2_EventScript_Lass:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0472_T04R0201_CeruleanCity_House2_Text_TeamRocketTryingToDigIntoNoGood
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeruleanCity_House2_EventScript_WallHole:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0472_T04R0201_CeruleanCity_House2_Text_TeamRocketLeftWayOut
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeruleanCity_House2_EventScript_HikerGotTM28:
	NPCMsg msg_0472_T04R0201_CeruleanCity_House2_Text_TeachDiglettDigWithoutTM
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0472_T04R0201_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
