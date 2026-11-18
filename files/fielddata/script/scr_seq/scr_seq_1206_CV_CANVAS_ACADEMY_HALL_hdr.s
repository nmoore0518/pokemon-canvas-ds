#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_ACADEMY_HALL.h"
#include "constants/init_script_types.h"
#include "macros/script.inc"

	InitScriptEntry_OnFrameTable _cv_CV_CANVAS_ACADEMY_HALL_frame
	InitScriptEntry_OnTransition _EV_LeaderAcademy_Hall_OnTransition + 1
	InitScriptEntryEnd

_cv_CV_CANVAS_ACADEMY_HALL_frame:
	InitScriptGoToIfEqual 0x502F, 5, _EV_Academy_EventScript_BraceletCall + 1
	InitScriptGoToIfEqual 0x502F, 6, _EV_Academy_EventScript_BraceletGive + 1
	InitScriptFrameTableEnd

	InitScriptEnd
