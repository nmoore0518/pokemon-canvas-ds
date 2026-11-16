#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_CINNABAR_LAB.h"
#include "msgdata/msg/msg_0934_CV_CANVAS_CINNABAR_LAB.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's CinnabarIsland_PokemonLab_Entrance_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef CinnabarIsland_PokemonLab_Entrance_EventScript_Scientist
	ScrDef CinnabarIsland_PokemonLab_Entrance_EventScript_DrFujiPhoto
	ScrDef CinnabarIsland_PokemonLab_Entrance_EventScript_MeetingRoomSign
	ScrDef CinnabarIsland_PokemonLab_Entrance_EventScript_RAndDRoomSign
	ScrDef CinnabarIsland_PokemonLab_Entrance_EventScript_TestingRoomSign
	ScrDef CinnabarIsland_PokemonLab_Entrance_OnTransition
	ScrDefEnd
	
CinnabarIsland_PokemonLab_Entrance_EventScript_Scientist:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0934_CV_CANVAS_CINNABAR_LAB_CinnabarIsland_PokemonLab_Entrance_Text_StudyMonsExtensively
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_PokemonLab_Entrance_EventScript_DrFujiPhoto:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0934_CV_CANVAS_CINNABAR_LAB_CinnabarIsland_PokemonLab_Entrance_Text_PhotoOfLabFounderDrFuji
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_PokemonLab_Entrance_EventScript_MeetingRoomSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0934_CV_CANVAS_CINNABAR_LAB_CinnabarIsland_PokemonLab_Entrance_Text_MeetingRoomSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_PokemonLab_Entrance_EventScript_RAndDRoomSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0934_CV_CANVAS_CINNABAR_LAB_CinnabarIsland_PokemonLab_Entrance_Text_RAndDRoomSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_PokemonLab_Entrance_EventScript_TestingRoomSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0934_CV_CANVAS_CINNABAR_LAB_CinnabarIsland_PokemonLab_Entrance_Text_TestingRoomSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CinnabarIsland_PokemonLab_Entrance_OnTransition:
	CompareVarToValue 0x5040, 1
	CallIfEq CinnabarIsland_PokemonLab_Entrance_EventScript_ReadyFossil
	End
	
CinnabarIsland_PokemonLab_Entrance_EventScript_ReadyFossil:
	SetVar 0x5040, 2
	Return

_cv_stop:
	NPCMsg msg_0934_CV_CANVAS_CINNABAR_LAB_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
