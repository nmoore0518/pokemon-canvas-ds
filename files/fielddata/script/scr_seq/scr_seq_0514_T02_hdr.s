#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T02.h"
#include "constants/init_script_types.h"
#include "macros/script.inc"

	InitScriptEntry_OnFrameTable _cv_T02_frame
	InitScriptEntry_OnTransition _EV_ViridianCity_OnTransition + 1
	InitScriptEntryEnd

_cv_T02_frame:
	InitScriptGoToIfEqual 0x4009, 1, _EV_MoveExtractor_EventScript_ViridianVisit + 1
	InitScriptFrameTableEnd

	InitScriptEnd
