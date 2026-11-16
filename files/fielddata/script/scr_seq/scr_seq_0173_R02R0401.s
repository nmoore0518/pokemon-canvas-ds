#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R02R0401.h"
#include "msgdata/msg/msg_0324_R02R0401.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route2_ViridianForest_SouthEntrance_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route2_ViridianForest_SouthEntrance_EventScript_Woman1
	ScrDef Route2_ViridianForest_SouthEntrance_EventScript_Woman2
	ScrDefEnd
	
Route2_ViridianForest_SouthEntrance_EventScript_Woman1:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0324_R02R0401_Route2_ViridianForest_SouthEntrance_Text_ForestIsMaze
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route2_ViridianForest_SouthEntrance_EventScript_Woman2:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0324_R02R0401_Route2_ViridianForest_SouthEntrance_Text_RattataHasWickedBite
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0324_R02R0401_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
