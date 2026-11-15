#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T02.h"
#include "constants/init_script_types.h"
#include "macros/script.inc"

	InitScriptEntry_OnFrameTable _cv_T02_frame
	InitScriptEntry_OnTransition _EV_ViridianCity_OnTransition + 1
	InitScriptEntryEnd

_cv_T02_frame:
	// (not yet: MoveExtractor_EventScript_ViridianVisit)
	InitScriptFrameTableEnd

	InitScriptEnd
