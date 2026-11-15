#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T01R0301.h"
#include "constants/init_script_types.h"
#include "macros/script.inc"

	InitScriptEntry_OnFrameTable _cv_T01R0301_frame
	InitScriptEntry_OnTransition _EV_PalletTown_ProfessorOaksLab_OnTransition + 1
	InitScriptEntryEnd

_cv_T01R0301_frame:
	InitScriptGoToIfEqual 0x5006, 1, _EV_PalletTown_ProfessorOaksLab_ChooseStarterScene + 1
	InitScriptGoToIfEqual 0x5006, 7, _EV_PalletTown_ProfessorOaksLab_EventScript_EnterForNationalDexScene + 1
	InitScriptFrameTableEnd

	InitScriptEnd
