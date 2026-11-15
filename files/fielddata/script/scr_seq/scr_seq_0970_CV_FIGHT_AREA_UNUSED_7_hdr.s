#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_FIGHT_AREA_UNUSED_7.h"
#include "constants/init_script_types.h"
#include "macros/script.inc"

	InitScriptEntry_OnFrameTable _cv_CV_FIGHT_AREA_UNUSED_7_frame
	InitScriptEntry_OnTransition _EV_PalletTown_Gym_OnTransition + 1
	InitScriptEntry_OnLoad _EV_PalletTown_Gym_OnLoad + 1
	InitScriptEntryEnd

_cv_CV_FIGHT_AREA_UNUSED_7_frame:
	InitScriptGoToIfEqual 0x5005, 4, _EV_GymFinale_EventScript_FirstDay + 1
	InitScriptGoToIfEqual 0x5005, 1, _EV_PalletTown_Gym_EventScript_OakShowsGym + 1
	// (not yet: PalletTown_Gym_EventScript_OakWantsTheGym)
	// (not yet: GymLegend_EventScript_RivalEscaped)
	// (not yet: GymLegend_EventScript_RivalCaught)
	// (not yet: GymLegend_EventScript_ArrivesLater)
	// (not yet: Johto_EventScript_Invitation)
	InitScriptGoToIfEqual 0x501B, 1, _EV_Gauntlet_EventScript_Arrives + 1
	InitScriptFrameTableEnd

	InitScriptEnd
