#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T10R0101.h"
#include "msgdata/msg/msg_0522_T10R0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's IndigoPlateau_PokemonCenter_1F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef IndigoPlateau_PokemonCenter_1F_EventScript_Clerk
	ScrDef IndigoPlateau_PokemonCenter_1F_EventScript_Nurse
	ScrDef IndigoPlateau_PokemonCenter_1F_EventScript_GymGuy
	ScrDef IndigoPlateau_PokemonCenter_1F_EventScript_DoorGuard
	ScrDef IndigoPlateau_PokemonCenter_1F_EventScript_BlackBelt
	ScrDef IndigoPlateau_PokemonCenter_1F_EventScript_CooltrainerM
	ScrDef TypeTutor_EventScript_Dragon
	ScrDef IndigoPlateau_PokemonCenter_1F_EventScript_PokemonJournal
	ScrDef IndigoPlateau_PokemonCenter_1F_EventScript_LeagueTeamCheck
	ScrDef IndigoPlateau_PokemonCenter_1F_OnTransition
	ScrDef CableClub_OnResume
	ScrDefEnd
	
IndigoPlateau_PokemonCenter_1F_EventScript_Clerk:
	LockAll
	FacePlayer
	NPCMsg msg_0522_T10R0101_gText_HowMayIServeYou
	CanvasMart 7
	.short ITEM_ULTRA_BALL
	.short ITEM_GREAT_BALL
	.short ITEM_FULL_RESTORE
	.short ITEM_MAX_POTION
	.short ITEM_REVIVE
	.short ITEM_FULL_HEAL
	.short ITEM_MAX_REPEL
	NPCMsg msg_0522_T10R0101_gText_PleaseComeAgain
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
IndigoPlateau_PokemonCenter_1F_EventScript_Nurse:
	LockAll
	FacePlayer
	SetVar VAR_SPECIAL_x8007, 0
	CallStd std_nurse_joy
	CanvasCloseMsg
	ReleaseAll
	End
	
IndigoPlateau_PokemonCenter_1F_EventScript_GymGuy:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0522_T10R0101_IndigoPlateau_PokemonCenter_1F_Text_GymGuyAdvice
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
IndigoPlateau_PokemonCenter_1F_EventScript_DoorGuard:
	LockAll
	FacePlayer
	CompareVarToValue 0x5037, 2
	GoToIfGe IndigoPlateau_PokemonCenter_1F_EventScript_ChampionSkipOffer
	NPCMsg msg_0522_T10R0101_IndigoPlateau_PokemonCenter_1F_Text_FaceEliteFourGoodLuck
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
IndigoPlateau_PokemonCenter_1F_EventScript_BlackBelt:
	LockAll
	FacePlayer
	NPCMsg msg_0522_T10R0101_IndigoPlateau_PokemonCenter_1F_Text_AgathaWhuppedUs
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
IndigoPlateau_PokemonCenter_1F_EventScript_CooltrainerM:
	LockAll
	FacePlayer
	NPCMsg msg_0522_T10R0101_IndigoPlateau_PokemonCenter_1F_Text_LancesCousinGymLeaderFarAway
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TypeTutor_EventScript_Dragon:
	LockAll
	FacePlayer
	SetVar 0x8004, 18
	GoTo TypeTutor_EventScript_Talk
	
IndigoPlateau_PokemonCenter_1F_EventScript_PokemonJournal:
	LockAll
	FacePlayer
	NPCMsg msg_0522_T10R0101_PokemonJournal_Text_SpecialFeatureLance
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
IndigoPlateau_PokemonCenter_1F_EventScript_LeagueTeamCheck:
	LockAll
	Call GymCandidate_EventScript_LeagueApprovalCheck
	CanvasCheckTeam 7, 0x5019
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq IndigoPlateau_PokemonCenter_1F_EventScript_LeagueTeamOk
	Call EventScript_GymHack_ShowTeamRuleMessage
	CanvasCloseMsg
	ApplyMovement obj_player, Common_Movement_WalkDown
	WaitMovement
	CanvasCloseMsg
	ReleaseAll
	End
	
IndigoPlateau_PokemonCenter_1F_OnTransition:
	Call EventScript_ResetEliteFour
	End
	// TODO(gba) @ Gym Trainer hack: FireRed's guard blocked the door ("Lorelei is absent") from the National Dex
	GoTo IndigoPlateau_PokemonCenter_1F_EventScript_DoorGuard
	
CableClub_OnResume:
	// TODO(gba) special InitUnionRoom
	End
	
IndigoPlateau_PokemonCenter_1F_EventScript_ChampionSkipOffer:
	NPCMsg msg_0522_T10R0101_IndigoPlateau_PokemonCenter_1F_Text_ChampionSkipOffer
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq IndigoPlateau_PokemonCenter_1F_EventScript_ChampionSkipNo
	CanvasCheckTeam 7, 0x5019
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe IndigoPlateau_PokemonCenter_1F_EventScript_ChampionSkipTeam
	NPCMsg msg_0522_T10R0101_IndigoPlateau_PokemonCenter_1F_Text_ChampionSkipGo
	WaitButton
	CanvasCloseMsg
	PlaySE SEQ_SE_DP_KAIDAN2
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	Warp MAP_POKEMON_LEAGUE_LANCE_ROOM, 0, 6, 28, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	CanvasCloseMsg
	ReleaseAll
	End
	
TypeTutor_EventScript_Talk:
	CopyVar 0x8008, 0x8004
	// TODO(gba) special TypeTutor_GetState
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TypeTutor_EventScript_Intro
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq TypeTutor_EventScript_Trial
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq TypeTutor_EventScript_JustDone
	GoTo TypeTutor_EventScript_Teach
	
GymCandidate_EventScript_LeagueApprovalCheck:
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x2093, _cv_appr_3
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_3:
	GoToIfUnset 0x2094, _cv_appr_4
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_4:
	GoToIfUnset 0x2095, _cv_appr_5
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_5:
	GoToIfUnset 0x2096, _cv_appr_6
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_6:
	GoToIfUnset 0x2097, _cv_appr_7
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_7:
	GoToIfUnset 0x2098, _cv_appr_8
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_8:
	GoToIfUnset 0x2099, _cv_appr_9
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_9:
	GoToIfUnset 0x2007, _cv_appr_10
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_10:
	BufferInt 0, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 8
	GoToIfLt GymCandidate_EventScript_NotApproved
	Return
	
IndigoPlateau_PokemonCenter_1F_EventScript_LeagueTeamOk:
	CanvasCloseMsg
	ReleaseAll
	End
	
EventScript_GymHack_ShowTeamRuleMessage:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq EventScript_GymHack_MsgWrongType
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	CallIfEq EventScript_GymHack_MsgDuplicate
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	CallIfEq EventScript_GymHack_MsgDuplicateItem
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
	
IndigoPlateau_PokemonCenter_1F_EventScript_ChampionSkipNo:
	NPCMsg msg_0522_T10R0101_IndigoPlateau_PokemonCenter_1F_Text_FaceEliteFourGoodLuck
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
IndigoPlateau_PokemonCenter_1F_EventScript_ChampionSkipTeam:
	Call EventScript_GymHack_ShowTeamRuleMessage
	CanvasCloseMsg
	ReleaseAll
	End
	
TypeTutor_EventScript_Intro:
	// TODO(gba) special TypeTutor_BufferIntro
	GoTo _cv_stop
	Call _cv_str4
	WaitButton
	// TODO(gba) special TypeTutor_SetMet
	GoTo _cv_stop
	// TODO(gba) special TypeTutor_GetState
	GoTo _cv_stop
	GoTo TypeTutor_EventScript_Trial
	
TypeTutor_EventScript_Trial:
	// TODO(gba) special TypeTutor_BufferTrial
	GoTo _cv_stop
	Call _cv_str4
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TypeTutor_EventScript_JustDone:
	// TODO(gba) special TypeTutor_BufferDone
	GoTo _cv_stop
	Call _cv_str4
	WaitButton
	// TODO(gba) special TypeTutor_SetOpened
	GoTo _cv_stop
	GoTo TypeTutor_EventScript_Teach
	
TypeTutor_EventScript_Teach:
	CopyVar 0x8004, 0x8008
	NPCMsg msg_0522_T10R0101_TypeTutor_Text_WhichMove
	// TODO(gba) special TypeTutor_PushMoves
	GoTo _cv_stop
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_12
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_12:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq TypeTutor_EventScript_Bye
	CopyVar 0x8004, 0x8008
	// TODO(gba) special TypeTutor_SelectMove
	GoTo _cv_stop
	NPCMsg msg_0522_T10R0101_TypeTutor_Text_WhichMon
	WaitButton
	Call EventScript_ChooseMoveTutorMon
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TypeTutor_EventScript_Teach
	NPCMsg msg_0522_T10R0101_TypeTutor_Text_Taught
	WaitButton
	GoTo TypeTutor_EventScript_Teach
	
GymCandidate_EventScript_NotApproved:
	NPCMsg msg_0522_T10R0101_GymCandidate_Text_NeedApprovals
	WaitButton
	CanvasCloseMsg
	ApplyMovement obj_player, Common_Movement_WalkDown
	WaitMovement
	CanvasCloseMsg
	ReleaseAll
	End
	
EventScript_GymHack_MsgWrongType:
	NPCMsg msg_0522_T10R0101_Text_GymHack_WrongType
	WaitButton
	Return
	
EventScript_GymHack_MsgDuplicate:
	NPCMsg msg_0522_T10R0101_Text_GymHack_Duplicate
	WaitButton
	Return
	
EventScript_GymHack_MsgDuplicateItem:
	NPCMsg msg_0522_T10R0101_Text_GymHack_DuplicateItem
	WaitButton
	Return
	
TypeTutor_EventScript_Bye:
	NPCMsg msg_0522_T10R0101_TypeTutor_Text_Bye
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_ChooseMoveTutorMon:
	// TODO(gba) special ChooseMonForMoveTutor
	GoTo _cv_stop
	LockAll
	FacePlayer
	Return

_cv_str4:
	BufferPlayersName 6
	BufferRivalsName 7
	Return

_cv_stop:
	NPCMsg msg_0522_T10R0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
Common_Movement_WalkDown:
	WalkNormalSouth
	EndMovement
	.balign 4, 0
