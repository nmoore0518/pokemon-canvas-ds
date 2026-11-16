#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T10R0501.h"
#include "constants/init_script_types.h"
#include "macros/script.inc"

	InitScriptEntry_OnFrameTable _cv_T10R0501_frame
	InitScriptEntry_OnLoad _EV_PokemonLeague_LancesRoom_OnLoad + 1
	InitScriptEntry_OnResume _EV_PokemonLeague_LancesRoom_OnResume + 1
	InitScriptEntryEnd

_cv_T10R0501_frame:
	// (not yet: PokemonLeague_LancesRoom_EventScript_EnterRoom)
	InitScriptFrameTableEnd

	InitScriptEnd
