#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T07R0203.h"
#include "msgdata/msg/msg_0503_T07R0203.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's CeladonCity_Condominiums_3F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef CeladonCity_Condominiums_3F_EventScript_Programmer
	ScrDef CeladonCity_Condominiums_3F_EventScript_Designer
	ScrDef CeladonCity_Condominiums_3F_EventScript_GraphicArtist
	ScrDef CeladonCity_Condominiums_3F_EventScript_Writer
	ScrDef CeladonCity_Condominiums_3F_EventScript_DevelopmentRoomSign
	ScrDef CeladonCity_Condominiums_3F_EventScript_Computer1
	ScrDef CeladonCity_Condominiums_3F_EventScript_Computer2
	ScrDef CeladonCity_Condominiums_3F_EventScript_Computer3
	ScrDefEnd
	
CeladonCity_Condominiums_3F_EventScript_Programmer:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0503_T07R0203_CeladonCity_Condominiums_3F_Text_ImTheProgrammer
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_Condominiums_3F_EventScript_Designer:
	LockAll
	FacePlayer
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar HasAllKantoMons
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq CeladonCity_Condominiums_3F_EventScript_CompletedPokedex
	NPCMsg msg_0503_T07R0203_CeladonCity_Condominiums_3F_Text_ImGameDesignerShowMeFinishedPokedex
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_Condominiums_3F_EventScript_GraphicArtist:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0503_T07R0203_CeladonCity_Condominiums_3F_Text_ImTheGraphicArtist
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_Condominiums_3F_EventScript_Writer:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0503_T07R0203_CeladonCity_Condominiums_3F_Text_IWroteTheStory
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_Condominiums_3F_EventScript_DevelopmentRoomSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0503_T07R0203_CeladonCity_Condominiums_3F_Text_GameFreakDevelopmentRoom
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_Condominiums_3F_EventScript_Computer1:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0503_T07R0203_CeladonCity_Condominiums_3F_Text_ItsTheGameProgram
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_Condominiums_3F_EventScript_Computer2:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0503_T07R0203_CeladonCity_Condominiums_3F_Text_SomeonesPlayingGame
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_Condominiums_3F_EventScript_Computer3:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0503_T07R0203_CeladonCity_Condominiums_3F_Text_ItsScriptBetterNotLookAtEnding
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_Condominiums_3F_EventScript_CompletedPokedex:
	GoTo CeladonCity_Condominiums_3F_EventScript_ShowDiploma
	End
	
CeladonCity_Condominiums_3F_EventScript_ShowDiploma:
	NPCMsg msg_0503_T07R0203_CeladonCity_Condominiums_3F_Text_CompletedPokedexCongratulations
	Wait 60, VAR_SPECIAL_RESULT
	// TODO(gba) special Special_ShowDiploma
	GoTo _cv_stop
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0503_T07R0203_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
