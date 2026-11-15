#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T01.h"
#include "constants/init_script_types.h"
#include "macros/script.inc"

	InitScriptEntry_OnFrameTable _cv_T01_frame
	InitScriptEntry_OnTransition _EV_PalletTown_OnTransition + 1
	InitScriptEntry_OnLoad _EV_PalletTown_OnLoad + 1
	InitScriptEntryEnd

_cv_T01_frame:
	// (not yet: GymFinale_EventScript_Ceremony)
	// (not yet: GymFinale_EventScript_OakAtTheDoor)
	// (not yet: PalletTown_EventScript_OakRatingScene)
	InitScriptGoToIfEqual 0x5008, 1, _EV_DadStory_EventScript_Sendoff + 1
	// (not yet: DadStory_EventScript_Memorial)
	InitScriptFrameTableEnd

	InitScriptEnd
