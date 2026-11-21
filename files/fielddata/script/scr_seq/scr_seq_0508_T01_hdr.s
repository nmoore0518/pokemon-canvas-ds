#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T01.h"
#include "constants/init_script_types.h"
#include "macros/script.inc"

	InitScriptEntry_OnFrameTable _cv_T01_frame
	InitScriptEntry_OnTransition _EV_PalletTown_OnTransition + 1
	InitScriptEntry_OnLoad _EV_PalletTown_OnLoad + 1
	InitScriptEntryEnd

_cv_T01_frame:
	InitScriptGoToIfEqual 0x5004, 4, _EV_GymFinale_EventScript_Ceremony + 1
	InitScriptGoToIfEqual 0x5004, 1, _EV_GymFinale_EventScript_OakAtTheDoor + 1
	InitScriptGoToIfEqual 0x5007, 2, _EV_PalletTown_EventScript_OakRatingScene + 1
	InitScriptGoToIfEqual 0x5008, 1, _EV_DadStory_EventScript_Sendoff + 1
	InitScriptGoToIfEqual 0x5008, 8, _EV_DadStory_EventScript_Memorial + 1
	InitScriptFrameTableEnd

	InitScriptEnd
