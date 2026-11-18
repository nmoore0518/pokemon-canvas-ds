#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R07.h"
#include "msgdata/msg/msg_0336_R07.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route7_Frlg#world by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDefEnd

_cv_stop:
	NPCMsg msg_0336_R07_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
