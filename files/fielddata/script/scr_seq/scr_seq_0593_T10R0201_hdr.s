#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T10R0201.h"
#include "constants/init_script_types.h"
#include "macros/script.inc"

	InitScriptEntry_OnFrameTable _cv_T10R0201_frame
	InitScriptEntry_OnTransition _EV_PokemonLeague_LoreleisRoom_OnTransition + 1
	InitScriptEntry_OnLoad _EV_PokemonLeague_LoreleisRoom_OnLoad + 1
	InitScriptEntry_OnResume _EV_PokemonLeague_LoreleisRoom_OnResume + 1
	InitScriptEntryEnd

_cv_T10R0201_frame:
	InitScriptGoToIfEqual 0x501D, 0, _EV_PokemonLeague_LoreleisRoom_EventScript_EnterRoom + 1
	InitScriptFrameTableEnd

	InitScriptEnd
