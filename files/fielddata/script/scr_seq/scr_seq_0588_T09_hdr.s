#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T09.h"
#include "constants/init_script_types.h"
#include "macros/script.inc"

	InitScriptEntry_OnFrameTable _cv_T09_frame
	InitScriptEntry_OnTransition _EV_CinnabarIsland_OnTransition + 1
	InitScriptEntryEnd

_cv_T09_frame:
	// (not yet: CinnabarIsland_EventScript_ExitPokeCenterForOneIsland)
	// (not yet: CinnabarIsland_EventScript_BillScene)
	InitScriptGoToIfEqual 0x502B, 3, _EV_CinnabarIsland_EventScript_ReturnFromSeviiIslands + 1
	InitScriptFrameTableEnd

	InitScriptEnd
