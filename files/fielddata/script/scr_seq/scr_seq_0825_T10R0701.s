#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T10R0701.h"
#include "msgdata/msg/msg_0528_T10R0701.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PokemonLeague_HallOfFame_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef PokemonLeague_HallOfFame_EventScript_EnterRoom
	ScrDefEnd
	
PokemonLeague_HallOfFame_EventScript_EnterRoom:
	LockAll
	ApplyMovement obj_player, PokemonLeague_HallOfFame_Movement_EnterRoom
	WaitMovement
	ApplyMovement 1, Common_Movement_WalkInPlaceFasterLeft
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterRight
	WaitMovement
	Wait 18, VAR_SPECIAL_RESULT
	BufferPlayersName 6
	NPCMsg msg_0528_T10R0701_PokemonLeague_HallOfFame_Text_OakCongratulations
	WaitButton
	CloseMsg
	ApplyMovement 1, Common_Movement_WalkInPlaceFasterUp
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	Wait 20, VAR_SPECIAL_RESULT
	PartyCountNotEgg VAR_SPECIAL_RESULT
	HallOfFameAnim VAR_SPECIAL_RESULT
	Wait 40, VAR_SPECIAL_RESULT
	SetVar 0x4001, 1
	Call EventScript_SetDefeatedEliteFourFlagsVars
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	CanvasHallOfFame
	RestoreOverworld
	SetVar 0x502E, 1
	Warp MAP_INDIGO_PLATEAU, 0, 978, 108, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	ReleaseAll
	End
	
EventScript_SetDefeatedEliteFourFlagsVars:
	ClearFlag 0x203C
	Call EventScript_ResetEliteFour
	CompareVarToValue 0x5004, 0
	CallIfEq EventScript_GymHack_StartGymFinale
	CompareVarToValue 0x5004, 3
	CallIfEq EventScript_TryReadyNationalDexScene
	Call EventScript_ResetLegendaries
	Return
	
EventScript_ResetEliteFour:
	SetFlag FLAG_HIDE_WILLS_ROOM_RETREAT
	ClearFlag FLAG_HIDE_WILLS_ROOM_EXIT
	SetFlag FLAG_HIDE_KOGAS_ROOM_RETREAT
	ClearFlag FLAG_HIDE_KOGAS_ROOM_EXIT
	SetFlag FLAG_HIDE_BRUNOS_ROOM_RETREAT
	ClearFlag FLAG_HIDE_BRUNOS_ROOM_EXIT
	SetFlag FLAG_HIDE_KARENS_ROOM_RETREAT
	ClearFlag FLAG_HIDE_KARENS_ROOM_EXIT
	ClearFlag 0x203D
	ClearFlag 0x203E
	ClearFlag 0x203F
	ClearFlag 0x2040
	ClearFlag 0x2041
	ClearFlag 0x2053
	ClearFlag 0x2054
	ClearFlag 0x2055
	ClearFlag 0x2056
	ClearFlag 0x2057
	ClearFlag 0x2058
	SetVar 0x501D, 0
	Return
	
EventScript_GymHack_StartGymFinale:
	SetVar 0x5004, 1
	Return
	
EventScript_TryReadyNationalDexScene:
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x2026, _cv_dex_1
	SetVar VAR_SPECIAL_RESULT, 1
_cv_dex_1:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	CallIfEq EventScript_SetReadyTryGiveNationalDexScene
	Return
	
EventScript_ResetLegendaries:
	ClearFlag 0x2042
	ClearFlag 0x2043
	ClearFlag 0x2044
	Return
	
EventScript_SetReadyTryGiveNationalDexScene:
	SetVar 0x5007, 2
	Return

_cv_stop:
	NPCMsg msg_0528_T10R0701_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
PokemonLeague_HallOfFame_Movement_EnterRoom:
	WalkNormalNorth 14
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterLeft:
	WalkOnSpotFasterWest
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterRight:
	WalkOnSpotFasterEast
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterUp:
	WalkOnSpotFasterNorth
	EndMovement
	.balign 4, 0
