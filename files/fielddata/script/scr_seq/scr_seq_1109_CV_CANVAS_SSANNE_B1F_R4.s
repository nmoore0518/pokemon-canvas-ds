#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SSANNE_B1F_R4.h"
#include "msgdata/msg/msg_0926_CV_CANVAS_SSANNE_B1F_R4.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SSAnne_B1F_Room4_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDefEnd

_cv_stop:
	NPCMsg msg_0926_CV_CANVAS_SSANNE_B1F_R4_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
