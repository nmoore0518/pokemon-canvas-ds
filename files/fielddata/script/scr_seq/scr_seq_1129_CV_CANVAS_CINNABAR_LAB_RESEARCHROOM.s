#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_CINNABAR_LAB_RESEARCHROOM.h"
#include "msgdata/msg/msg_0936_CV_CANVAS_CINNABAR_LAB_RESEARCHROOM.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's CinnabarIsland_PokemonLab_ResearchRoom_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef CinnabarIsland_PokemonLab_ResearchRoom_EventScript_MetronomeTutor
	ScrDef CinnabarIsland_PokemonLab_ResearchRoom_EventScript_Scientist
	ScrDef CinnabarIsland_PokemonLab_ResearchRoom_EventScript_AmberPipe
	ScrDef CinnabarIsland_PokemonLab_ResearchRoom_EventScript_Computer
	ScrDefEnd
	
CinnabarIsland_PokemonLab_ResearchRoom_EventScript_MetronomeTutor:
	GoTo EventScript_MetronomeTutor
	End
	
CinnabarIsland_PokemonLab_ResearchRoom_EventScript_Scientist:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0936_CV_CANVAS_CINNABAR_LAB_RESEARCHROOM_CinnabarIsland_PokemonLab_ResearchRoom_Text_EeveeCanEvolveIntroThreeMons
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_PokemonLab_ResearchRoom_EventScript_AmberPipe:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0936_CV_CANVAS_CINNABAR_LAB_RESEARCHROOM_CinnabarIsland_PokemonLab_ResearchRoom_Text_AnAmberPipe
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_PokemonLab_ResearchRoom_EventScript_Computer:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0936_CV_CANVAS_CINNABAR_LAB_RESEARCHROOM_CinnabarIsland_PokemonLab_ResearchRoom_Text_LegendaryBirdEmail
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_MetronomeTutor:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0936_CV_CANVAS_CINNABAR_LAB_RESEARCHROOM_Text_MetronomeTutor_Retired
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0936_CV_CANVAS_CINNABAR_LAB_RESEARCHROOM_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
