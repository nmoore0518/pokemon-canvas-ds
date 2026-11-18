#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SAFFRON_FAN_CLUB.h"
#include "constants/init_script_types.h"
#include "macros/script.inc"

	InitScriptEntry_OnFrameTable _cv_CV_CANVAS_SAFFRON_FAN_CLUB_frame
	InitScriptEntry_OnTransition _EV_SaffronCity_PokemonTrainerFanClub_OnTransition + 1
	InitScriptEntryEnd

_cv_CV_CANVAS_SAFFRON_FAN_CLUB_frame:
	InitScriptGoToIfEqual 0x5043, 1, _EV_SaffronCity_PokemonTrainerFanClub_EventScript_MeetFirstFans + 1
	InitScriptFrameTableEnd

	InitScriptEnd
