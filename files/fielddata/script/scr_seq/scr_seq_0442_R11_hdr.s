#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_R11.h"
#include "constants/init_script_types.h"
#include "macros/script.inc"

	InitScriptEntry_OnFrameTable _cv_R11_frame
	InitScriptEntry_OnTransition _EV_Route11_OnTransition + 1
	InitScriptEntryEnd

_cv_R11_frame:
	// (not yet: Academy_EventScript_Invite)
	// (not yet: Academy_EventScript_Escort)
	InitScriptFrameTableEnd

	InitScriptEnd
