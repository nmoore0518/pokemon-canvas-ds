#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T07R0105.h"
#include "msgdata/msg/msg_0498_T07R0105.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's CeladonCity_DepartmentStore_5F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef CeladonCity_DepartmentStore_5F_EventScript_Gentleman
	ScrDef CeladonCity_DepartmentStore_5F_EventScript_Sailor
	ScrDef CeladonCity_DepartmentStore_5F_EventScript_ClerkXItems
	ScrDef CeladonCity_DepartmentStore_5F_EventScript_ClerkVitamins
	ScrDef CeladonCity_DepartmentStore_5F_EventScript_FloorSign
	ScrDefEnd
	
CeladonCity_DepartmentStore_5F_EventScript_Gentleman:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0498_T07R0105_CeladonCity_DepartmentStore_5F_Text_ExplainStatEnhancers
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_DepartmentStore_5F_EventScript_Sailor:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0498_T07R0105_CeladonCity_DepartmentStore_5F_Text_HereForStatEnhancers
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_DepartmentStore_5F_EventScript_ClerkXItems:
	LockAll
	FacePlayer
	NPCMsg msg_0498_T07R0105_gText_HowMayIServeYou
	CanvasMart 6
	.short ITEM_X_ATTACK
	.short ITEM_X_SPEED
	.short ITEM_X_SPECIAL
	.short ITEM_X_ACCURACY
	.short 55
	.short ITEM_DIRE_HIT
	NPCMsg msg_0498_T07R0105_gText_PleaseComeAgain
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_DepartmentStore_5F_EventScript_ClerkVitamins:
	LockAll
	FacePlayer
	NPCMsg msg_0498_T07R0105_gText_HowMayIServeYou
	CanvasMart 6
	.short ITEM_HP_UP
	.short ITEM_PROTEIN
	.short ITEM_IRON
	.short ITEM_CALCIUM
	.short ITEM_ZINC
	.short ITEM_CARBOS
	NPCMsg msg_0498_T07R0105_gText_PleaseComeAgain
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_DepartmentStore_5F_EventScript_FloorSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0498_T07R0105_CeladonCity_DepartmentStore_5F_Text_Drugstore
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0498_T07R0105_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
