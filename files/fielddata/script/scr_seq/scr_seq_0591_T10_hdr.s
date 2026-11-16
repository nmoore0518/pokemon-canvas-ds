#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T10.h"
#include "constants/init_script_types.h"
#include "macros/script.inc"

	InitScriptEntry_OnFrameTable _cv_T10_frame
	InitScriptEntry_OnTransition _EV_IndigoPlateau_Exterior_OnTransition + 1
	InitScriptEntryEnd

_cv_T10_frame:
	// (not yet: IndigoPlateau_Exterior_EventScript_Credits)
	InitScriptFrameTableEnd

	InitScriptEnd
