#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R10R0101.h"
#include "msgdata/msg/msg_0343_R10R0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route10_Frlg#south by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDefEnd

_cv_stop:
	NPCMsg msg_0343_R10R0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
