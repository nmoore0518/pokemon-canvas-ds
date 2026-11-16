#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T03R0201.h"
#include "msgdata/msg/msg_0465_T03R0201.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PewterCity_House1_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef PewterCity_House1_EventScript_BaldingMan
	ScrDef PewterCity_House1_EventScript_LittleBoy
	ScrDef PewterCity_House1_EventScript_Nidoran
	ScrDefEnd
	
PewterCity_House1_EventScript_BaldingMan:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0465_T03R0201_PewterCity_House1_Text_TradeMonsAreFinicky
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_House1_EventScript_LittleBoy:
	LockAll
	NPCMsg msg_0465_T03R0201_PewterCity_House1_Text_NidoranSit
	WaitButton
	Call PewterCity_House1_EventScript_DoNidoranCry
	CloseMsg
	ReleaseAll
	End
	
PewterCity_House1_EventScript_Nidoran:
	LockAll
	FacePlayer
	Call PewterCity_House1_EventScript_DoNidoranCry
	ApplyMovement 3, Common_Movement_FaceOriginalDirection
	WaitMovement
	ReleaseAll
	End
	
PewterCity_House1_EventScript_DoNidoranCry:
	WaitSE SEQ_SE_DP_SELECT
	PlayCry SPECIES_NIDORAN_M, 0
	NPCMsg msg_0465_T03R0201_PewterCity_House1_Text_Nidoran
	WaitButton
	WaitCry
	Call EventScript_RestorePrevTextColor
	Return
	
EventScript_RestorePrevTextColor:
	CopyVar 0x5015, 0x5016
	Return

_cv_stop:
	NPCMsg msg_0465_T03R0201_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
Common_Movement_FaceOriginalDirection:
	EndMovement
	.balign 4, 0
