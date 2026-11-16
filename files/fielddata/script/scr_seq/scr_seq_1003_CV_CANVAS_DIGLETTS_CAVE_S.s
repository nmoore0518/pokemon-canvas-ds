#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_DIGLETTS_CAVE_S.h"
#include "msgdata/msg/msg_0873_CV_CANVAS_DIGLETTS_CAVE_S.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's DiglettsCave_SouthEntrance_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef DiglettsCave_SouthEntrance_EventScript_OldMan
	ScrDefEnd
	
DiglettsCave_SouthEntrance_EventScript_OldMan:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0873_CV_CANVAS_DIGLETTS_CAVE_S_DiglettsCave_SouthEntrance_Text_DiglettDugThisTunnel
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0873_CV_CANVAS_DIGLETTS_CAVE_S_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
