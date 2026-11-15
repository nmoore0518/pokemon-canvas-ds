#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T02FS0101.h"
#include "constants/init_script_types.h"
#include "macros/script.inc"

	InitScriptEntry_OnFrameTable _cv_T02FS0101_frame
	InitScriptEntry_OnLoad _EV_ViridianCity_Mart_OnLoad + 1
	InitScriptEntryEnd

_cv_T02FS0101_frame:
	InitScriptGoToIfEqual 0x5010, 0, _EV_ViridianCity_Mart_EventScript_ParcelScene + 1
	InitScriptFrameTableEnd

	InitScriptEnd
