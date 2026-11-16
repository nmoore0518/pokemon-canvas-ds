#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SSANNE_1F_R5.h"
#include "msgdata/msg/msg_0914_CV_CANVAS_SSANNE_1F_R5.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SSAnne_1F_Room5_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDefEnd

_cv_stop:
	NPCMsg msg_0914_CV_CANVAS_SSANNE_1F_R5_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
