#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T06.h"
#include "constants/init_script_types.h"
#include "macros/script.inc"

	InitScriptEntry_OnFrameTable _cv_T06_frame
	InitScriptEntry_OnTransition _EV_VermilionCity_OnTransition + 1
	InitScriptEntry_OnLoad _EV_VermilionCity_OnLoad + 1
	InitScriptEntryEnd

_cv_T06_frame:
	InitScriptGoToIfEqual 0x5027, 2, _EV_VermilionCity_EventScript_ExitSSAnne + 1
	InitScriptFrameTableEnd

	InitScriptEnd
