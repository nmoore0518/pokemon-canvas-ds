#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T11.h"
#include "constants/init_script_types.h"
#include "macros/script.inc"

	InitScriptEntry_OnFrameTable _cv_T11_frame
	InitScriptEntry_OnTransition _EV_SaffronCity_OnTransition + 1
	InitScriptEntryEnd

_cv_T11_frame:
	InitScriptGoToIfEqual 0x4009, 1, _EV_MoveExtractor_EventScript_SaffronVisit + 1
	InitScriptFrameTableEnd

	InitScriptEnd
