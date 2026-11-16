#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R17.h"
#include "msgdata/msg/msg_0357_R17.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route17_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route17_EventScript_RouteSign
	ScrDef Route17_EventScript_TrainerTips2
	ScrDef Route17_EventScript_TrainerTips1
	ScrDef Route17_EventScript_ItemsNotice
	ScrDef Route17_EventScript_BallsNotice
	ScrDef Route17_EventScript_CyclingRoadSign
	ScrDefEnd
	
Route17_EventScript_RouteSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0357_R17_Route17_Text_RouteSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route17_EventScript_TrainerTips2:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0357_R17_Route17_Text_PressBToStayInPlace
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route17_EventScript_TrainerTips1:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0357_R17_Route17_Text_SameSpeciesGrowDifferentRates
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route17_EventScript_ItemsNotice:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0357_R17_Route17_Text_WatchOutForDiscardedItems
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route17_EventScript_BallsNotice:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0357_R17_Route17_Text_DontThrowGameThrowBalls
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route17_EventScript_CyclingRoadSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0357_R17_Route17_Text_CyclingRoadSign
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0357_R17_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
