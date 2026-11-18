#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_ACADEMY_MEGA_ROOM.h"
#include "msgdata/msg/msg_0980_CV_CANVAS_ACADEMY_MEGA_ROOM.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's LeaderAcademy_MegaRoom by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Academy_EventScript_MegaKeeper
	ScrDefEnd
	
Academy_EventScript_MegaKeeper:
	LockAll
	FacePlayer
	NPCMsg msg_0980_CV_CANVAS_ACADEMY_MEGA_ROOM_Academy_Text_MegaKeeperIntro
	WaitButton
	End

_cv_stop:
	NPCMsg msg_0980_CV_CANVAS_ACADEMY_MEGA_ROOM_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
