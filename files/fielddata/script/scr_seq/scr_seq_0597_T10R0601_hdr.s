#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T10R0601.h"
#include "constants/init_script_types.h"
#include "macros/script.inc"

	InitScriptEntry_OnFrameTable _cv_T10R0601_frame
	InitScriptEntry_OnResume _EV_PokemonLeague_ChampionsRoom_OnResume + 1
	InitScriptEntryEnd

_cv_T10R0601_frame:
	InitScriptGoToIfEqual 0x4001, 0, _EV_PokemonLeague_ChampionsRoom_EventScript_EnterRoom + 1
	InitScriptFrameTableEnd

	InitScriptEnd
