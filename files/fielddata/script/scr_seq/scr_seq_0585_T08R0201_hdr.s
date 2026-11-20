#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T08R0201.h"
#include "constants/init_script_types.h"
#include "macros/script.inc"

	InitScriptEntry_OnFrameTable _cv_T08R0201_frame
	InitScriptEntryEnd

_cv_T08R0201_frame:
	InitScriptGoToIfEqual 0x5034, 1, _EV_FuchsiaCity_SafariZone_Entrance_EventScript_ExitWarpIn + 1
	InitScriptGoToIfEqual 0x5034, 2, _EV_FuchsiaCity_SafariZone_Entrance_EventScript_ExitEarly + 1
	InitScriptGoToIfEqual 0x5034, 3, _EV_FuchsiaCity_SafariZone_Entrance_EventScript_ExitWalkIn + 1
	InitScriptFrameTableEnd

	InitScriptEnd
