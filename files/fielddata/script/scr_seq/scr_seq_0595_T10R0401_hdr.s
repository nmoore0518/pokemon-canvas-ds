#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T10R0401.h"
#include "constants/init_script_types.h"
#include "macros/script.inc"

	InitScriptEntry_OnFrameTable _cv_T10R0401_frame
	InitScriptEntry_OnLoad _EV_PokemonLeague_AgathasRoom_OnLoad + 1
	InitScriptEntry_OnResume _EV_PokemonLeague_AgathasRoom_OnResume + 1
	InitScriptEntryEnd

_cv_T10R0401_frame:
	// (not yet: PokemonLeague_AgathasRoom_EventScript_EnterRoom)
	InitScriptFrameTableEnd

	InitScriptEnd
