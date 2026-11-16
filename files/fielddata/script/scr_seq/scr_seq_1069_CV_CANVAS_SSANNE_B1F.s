#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SSANNE_B1F.h"
#include "msgdata/msg/msg_0906_CV_CANVAS_SSANNE_B1F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SSAnne_B1F_Corridor_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDefEnd

_cv_stop:
	NPCMsg msg_0906_CV_CANVAS_SSANNE_B1F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
