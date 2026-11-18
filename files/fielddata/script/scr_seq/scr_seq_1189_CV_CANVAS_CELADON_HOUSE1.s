#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_CELADON_HOUSE1.h"
#include "msgdata/msg/msg_0966_CV_CANVAS_CELADON_HOUSE1.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's CeladonCity_House1_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef CeladonCity_House1_EventScript_RocketChief
	ScrDef CeladonCity_House1_EventScript_Rocket1
	ScrDef CeladonCity_House1_EventScript_Rocket2
	ScrDefEnd
	
CeladonCity_House1_EventScript_RocketChief:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0966_CV_CANVAS_CELADON_HOUSE1_CeladonCity_House1_Text_SlotsReelInTheDough
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_House1_EventScript_Rocket1:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0966_CV_CANVAS_CELADON_HOUSE1_CeladonCity_House1_Text_ShippedMonsAsSlotPrizes
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_House1_EventScript_Rocket2:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0966_CV_CANVAS_CELADON_HOUSE1_CeladonCity_House1_Text_DontTouchGameCornerPoster
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0966_CV_CANVAS_CELADON_HOUSE1_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
