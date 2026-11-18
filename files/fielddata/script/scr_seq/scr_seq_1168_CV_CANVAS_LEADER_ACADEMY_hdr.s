#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_LEADER_ACADEMY.h"
#include "constants/init_script_types.h"
#include "macros/script.inc"

	InitScriptEntry_OnFrameTable _cv_CV_CANVAS_LEADER_ACADEMY_frame
	InitScriptEntry_OnTransition _EV_LeaderAcademy_Campus_OnTransition + 1
	InitScriptEntryEnd

_cv_CV_CANVAS_LEADER_ACADEMY_frame:
	// (not yet: Academy_EventScript_Welcome)
	InitScriptFrameTableEnd

	InitScriptEnd
