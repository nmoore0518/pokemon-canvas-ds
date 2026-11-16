#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R02R0501.h"
#include "msgdata/msg/msg_0325_R02R0501.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route2_ViridianForest_NorthEntrance_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route2_ViridianForest_NorthEntrance_EventScript_Youngster
	ScrDef Route2_ViridianForest_NorthEntrance_EventScript_OldMan
	ScrDef Route2_ViridianForest_NorthEntrance_EventScript_CooltrainerF
	ScrDefEnd
	
Route2_ViridianForest_NorthEntrance_EventScript_Youngster:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0325_R02R0501_Route2_ViridianForest_NorthEntrance_Text_ManyMonsOnlyInForests
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route2_ViridianForest_NorthEntrance_EventScript_OldMan:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0325_R02R0501_Route2_ViridianForest_NorthEntrance_Text_CanCutSkinnyTrees
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route2_ViridianForest_NorthEntrance_EventScript_CooltrainerF:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0325_R02R0501_Route2_ViridianForest_NorthEntrance_Text_CanCancelEvolution
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0325_R02R0501_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
