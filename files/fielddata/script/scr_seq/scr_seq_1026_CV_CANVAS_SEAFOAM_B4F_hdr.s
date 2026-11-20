#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SEAFOAM_B4F.h"
#include "constants/init_script_types.h"
#include "macros/script.inc"

	InitScriptEntry_OnFrameTable _cv_CV_CANVAS_SEAFOAM_B4F_frame
	InitScriptEntry_OnTransition _EV_SeafoamIslands_B4F_OnTransition + 1
	InitScriptEntry_OnLoad _EV_SeafoamIslands_B4F_OnLoad + 1
	InitScriptEntry_OnResume _EV_SeafoamIslands_B4F_OnResume + 1
	InitScriptEntryEnd

_cv_CV_CANVAS_SEAFOAM_B4F_frame:
	InitScriptGoToIfEqual 0x400E, 0, _EV_SeafoamIslands_B4F_cv_Arrive + 1
	InitScriptGoToIfEqual 0x503C, 1, _EV_SeafoamIslands_B4F_EventScript_EnterOnCurrent + 1
	InitScriptGoToIfEqual 0x4001, 1, _EV_SeafoamIslands_B4F_EventScript_EnterByFalling + 1
	InitScriptFrameTableEnd

	InitScriptEnd
