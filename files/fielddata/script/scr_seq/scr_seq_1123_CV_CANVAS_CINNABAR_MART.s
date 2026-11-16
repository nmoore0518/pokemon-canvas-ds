#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_CINNABAR_MART.h"
#include "msgdata/msg/msg_0933_CV_CANVAS_CINNABAR_MART.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's CinnabarIsland_Mart_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef CinnabarIsland_Mart_EventScript_Clerk
	ScrDef CinnabarIsland_Mart_EventScript_Woman
	ScrDef CinnabarIsland_Mart_EventScript_Scientist
	ScrDefEnd
	
CinnabarIsland_Mart_EventScript_Clerk:
	LockAll
	FacePlayer
	NPCMsg msg_0933_CV_CANVAS_CINNABAR_MART_gText_HowMayIServeYou
	CanvasMart 7
	.short ITEM_ULTRA_BALL
	.short ITEM_GREAT_BALL
	.short ITEM_HYPER_POTION
	.short ITEM_REVIVE
	.short ITEM_FULL_HEAL
	.short ITEM_ESCAPE_ROPE
	.short ITEM_MAX_REPEL
	NPCMsg msg_0933_CV_CANVAS_CINNABAR_MART_gText_PleaseComeAgain
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_Mart_EventScript_Woman:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0933_CV_CANVAS_CINNABAR_MART_CinnabarIsland_Mart_Text_DontTheyHaveXAttack
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_Mart_EventScript_Scientist:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0933_CV_CANVAS_CINNABAR_MART_CinnabarIsland_Mart_Text_ExtraItemsNeverHurt
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0933_CV_CANVAS_CINNABAR_MART_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
