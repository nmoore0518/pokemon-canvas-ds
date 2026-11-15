#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_FIGHT_AREA_UNUSED_6.h"
#include "constants/init_script_types.h"
#include "macros/script.inc"

	InitScriptEntry_OnFrameTable _cv_CV_FIGHT_AREA_UNUSED_6_frame
	InitScriptEntry_OnTransition _EV_PlayersHouse_B1F_OnTransition + 1
	InitScriptEntry_OnLoad _EV_PlayersHouse_B1F_OnLoad + 1
	InitScriptEntryEnd

_cv_CV_FIGHT_AREA_UNUSED_6_frame:
	InitScriptGoToIfEqual 0x5008, 5, _EV_DadStory_EventScript_Basement + 1
	InitScriptFrameTableEnd

	InitScriptEnd
