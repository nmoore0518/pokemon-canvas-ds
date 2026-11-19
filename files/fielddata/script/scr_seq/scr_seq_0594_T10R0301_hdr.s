#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T10R0301.h"
#include "constants/init_script_types.h"
#include "macros/script.inc"

	InitScriptEntry_OnFrameTable _cv_T10R0301_frame
	InitScriptEntry_OnLoad _EV_PokemonLeague_BrunosRoom_OnLoad + 1
	InitScriptEntry_OnResume _EV_PokemonLeague_BrunosRoom_OnResume + 1
	InitScriptEntryEnd

_cv_T10R0301_frame:
	InitScriptGoToIfEqual 0x501D, 1, _EV_PokemonLeague_BrunosRoom_EventScript_EnterRoom + 1
	InitScriptFrameTableEnd

	InitScriptEnd
