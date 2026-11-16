#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T10R0601.h"
#include "msgdata/msg/msg_0527_T10R0601.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PokemonLeague_ChampionsRoom_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef PokemonLeague_ChampionsRoom_OnResume
	ScrDef _cv_unported_1
	ScrDefEnd
	
PokemonLeague_ChampionsRoom_OnResume:
	SetVar 0x4014, 4
	Call PokemonLeague_EventScript_DoLightingEffect
	CompareVarToValue 0x5018, 2
	CallIfEq PokemonLeague_ChampionsRoom_EventScript_CheckStopTriggerSquirtle
	CompareVarToValue 0x5018, 1
	CallIfEq PokemonLeague_ChampionsRoom_EventScript_CheckStopTriggerBulbasaur
	CompareVarToValue 0x5018, 0
	CallIfEq PokemonLeague_ChampionsRoom_EventScript_CheckStopTriggerCharmander
	End
	
PokemonLeague_ChampionsRoom_EventScript_EnterRoom:
	LockAll
	SetFlag 2
	ApplyMovement obj_player, PokemonLeague_ChampionsRoom_Movement_PlayerEnter
	WaitMovement
	Wait 20, VAR_SPECIAL_RESULT
	CallIfUnset FLAG_GAME_CLEAR, GymFinale_EventScript_OakBeforeChampion
	CallIfUnset FLAG_GAME_CLEAR, PokemonLeague_ChampionsRoom_EventScript_Intro
	CallIfSet FLAG_GAME_CLEAR, PokemonLeague_ChampionsRoom_EventScript_RematchIntro
	SetFlag 3
	SetFlag 5
	AddVar 0x5037, 1
	CallIfUnset 0x215C, PokemonLeague_ChampionsRoom_EventScript_Battle
	CallIfSet 0x215C, PokemonLeague_ChampionsRoom_EventScript_Rematch
	SetVar 0x5037, 0
	SetFlag 4
	ClearFlag 5
	SetFlag 0x2041
	SetFlag 4
	NPCMsg msg_0527_T10R0601_PokemonLeague_ChampionsRoom_Text_PostBattle
	WaitButton
	PlayBGM SEQ_GS_T_MASARA
	GoToIfUnset 0x2064, _cv_show_1
	ClearFlag 0x2064
	ShowPerson 2
	SetFlag 0x2064
	GoTo _cv_shown_2
_cv_show_1:
	ShowPerson 2
_cv_shown_2:
	BufferPlayersName 6
	NPCMsg msg_0527_T10R0601_PokemonLeague_ChampionsRoom_Text_OakPlayer
	WaitButton
	CloseMsg
	ApplyMovement obj_player, PokemonLeague_ChampionsRoom_Movement_PlayerWatchOakEnter
	ApplyMovement 1, PokemonLeague_ChampionsRoom_Movement_RivalWatchOakEnter
	ApplyMovement 2, PokemonLeague_ChampionsRoom_Movement_OakEnter
	WaitMovement
	Wait 25, VAR_SPECIAL_RESULT
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar GetStarterPokemon
	GoTo _cv_stop
	BufferSpeciesName 0, VAR_SPECIAL_RESULT, 0, 0
	CallIfUnset FLAG_GAME_CLEAR, PokemonLeague_ChampionsRoom_EventScript_GymFinaleCongratulations
	CallIfSet FLAG_GAME_CLEAR, PokemonLeague_ChampionsRoom_EventScript_Congratulations
	ApplyMovement 2, Common_Movement_WalkInPlaceFasterRight
	ApplyMovement 1, Common_Movement_WalkInPlaceFasterLeft
	WaitMovement
	CallIfUnset FLAG_GAME_CLEAR, PokemonLeague_ChampionsRoom_EventScript_GymFinaleOakToRival
	CallIfSet FLAG_GAME_CLEAR, PokemonLeague_ChampionsRoom_EventScript_OakToRival
	CloseMsg
	ApplyMovement 2, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	Wait 20, VAR_SPECIAL_RESULT
	CompareVarToValue 0x5004, 0
	GoToIfEq GymFinale_EventScript_ToTheCeremony
	BufferPlayersName 6
	NPCMsg msg_0527_T10R0601_PokemonLeague_ChampionsRoom_Text_OakPlayerComeWithMe
	WaitButton
	CloseMsg
	Wait 13, VAR_SPECIAL_RESULT
	ApplyMovement 2, PokemonLeague_ChampionsRoom_Movement_OakExit
	ApplyMovement obj_player, PokemonLeague_ChampionsRoom_Movement_PlayerExit
	WaitMovement
	SetVar 0x4001, 1
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	Warp MAP_POKEMON_LEAGUE_HALL_OF_FAME, 0, 6, 22, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	ReleaseAll
	End
	
PokemonLeague_EventScript_DoLightingEffect:
	// TODO(gba) special DoPokemonLeagueLightingEffect
	Return
	
PokemonLeague_ChampionsRoom_EventScript_CheckStopTriggerSquirtle:
	GoToIfSet 0x2053, PokemonLeague_ChampionsRoom_EventScript_StopSceneTrigger
	GoToIfSet 0x2056, PokemonLeague_ChampionsRoom_EventScript_StopSceneTrigger
	Return
	
PokemonLeague_ChampionsRoom_EventScript_CheckStopTriggerBulbasaur:
	GoToIfSet 0x2054, PokemonLeague_ChampionsRoom_EventScript_StopSceneTrigger
	GoToIfSet 0x2057, PokemonLeague_ChampionsRoom_EventScript_StopSceneTrigger
	Return
	
PokemonLeague_ChampionsRoom_EventScript_CheckStopTriggerCharmander:
	GoToIfSet 0x2055, PokemonLeague_ChampionsRoom_EventScript_StopSceneTrigger
	GoToIfSet 0x2058, PokemonLeague_ChampionsRoom_EventScript_StopSceneTrigger
	Return
	
GymFinale_EventScript_OakBeforeChampion:
	GoToIfUnset 0x2064, _cv_show_3
	ClearFlag 0x2064
	ShowPerson 2
	SetFlag 0x2064
	GoTo _cv_shown_4
_cv_show_3:
	ShowPerson 2
_cv_shown_4:
	BufferPlayersName 6
	BufferRivalsName 7
	NPCMsg msg_0527_T10R0601_GymFinale_Text_OakWait
	WaitButton
	CloseMsg
	ApplyMovement obj_player, PokemonLeague_ChampionsRoom_Movement_PlayerWatchOakEnter
	ApplyMovement 1, PokemonLeague_ChampionsRoom_Movement_RivalWatchOakEnter
	ApplyMovement 2, PokemonLeague_ChampionsRoom_Movement_OakEnter
	WaitMovement
	NPCMsg msg_0527_T10R0601_GymFinale_Text_OakMadeIt
	WaitButton
	PlayFanfare SEQ_ME_ASA
	WaitFanfare
	HealParty
	BufferPlayersName 6
	NPCMsg msg_0527_T10R0601_GymFinale_Text_PokemonHealed
	WaitButton
	NPCMsg msg_0527_T10R0601_GymFinale_Text_OakThisBattleDecides
	WaitButton
	CloseMsg
	ApplyMovement 2, GymFinale_Movement_OakStepBack
	WaitMovement
	HidePerson 2
	SetFlag 0x2064
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterUp
	ApplyMovement 1, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	Return
	
PokemonLeague_ChampionsRoom_EventScript_Intro:
	BufferPlayersName 6
	BufferRivalsName 7
	NPCMsg msg_0527_T10R0601_PokemonLeague_ChampionsRoom_Text_Intro
	WaitButton
	Return
	
PokemonLeague_ChampionsRoom_EventScript_RematchIntro:
	BufferPlayersName 6
	BufferRivalsName 7
	NPCMsg msg_0527_T10R0601_PokemonLeague_ChampionsRoom_Text_RematchIntro
	WaitButton
	Return
	
PokemonLeague_ChampionsRoom_EventScript_Battle:
	CompareVarToValue 0x5018, 2
	CallIfEq PokemonLeague_ChampionsRoom_EventScript_BattleSquirtle
	CompareVarToValue 0x5018, 1
	CallIfEq PokemonLeague_ChampionsRoom_EventScript_BattleBulbasaur
	CompareVarToValue 0x5018, 0
	CallIfEq PokemonLeague_ChampionsRoom_EventScript_BattleCharmander
	Return
	
PokemonLeague_ChampionsRoom_EventScript_Rematch:
	CompareVarToValue 0x5018, 2
	CallIfEq PokemonLeague_ChampionsRoom_EventScript_RematchSquirtle
	CompareVarToValue 0x5018, 1
	CallIfEq PokemonLeague_ChampionsRoom_EventScript_RematchBulbasaur
	CompareVarToValue 0x5018, 0
	CallIfEq PokemonLeague_ChampionsRoom_EventScript_RematchCharmander
	Return
	
PokemonLeague_ChampionsRoom_EventScript_GymFinaleCongratulations:
	BufferPlayersName 6
	NPCMsg msg_0527_T10R0601_GymFinale_Text_OakCongratulations
	WaitButton
	Return
	
PokemonLeague_ChampionsRoom_EventScript_Congratulations:
	BufferPlayersName 6
	NPCMsg msg_0527_T10R0601_PokemonLeague_ChampionsRoom_Text_OakCongratulations
	WaitButton
	Return
	
PokemonLeague_ChampionsRoom_EventScript_GymFinaleOakToRival:
	BufferPlayersName 6
	BufferRivalsName 7
	NPCMsg msg_0527_T10R0601_GymFinale_Text_OakToRival
	WaitButton
	Return
	
PokemonLeague_ChampionsRoom_EventScript_OakToRival:
	BufferRivalsName 7
	NPCMsg msg_0527_T10R0601_PokemonLeague_ChampionsRoom_Text_OakImDisappointedRival
	WaitButton
	Return
	
GymFinale_EventScript_ToTheCeremony:
	BufferPlayersName 6
	NPCMsg msg_0527_T10R0601_GymFinale_Text_OakSeeYouAtTheCeremony
	WaitButton
	CloseMsg
	SetVar 0x5004, 4
	HealParty
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	Warp MAP_PALLET, 0, 1039, 379, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	ReleaseAll
	End
	
PokemonLeague_ChampionsRoom_EventScript_StopSceneTrigger:
	SetVar 0x4001, 1
	Return
	
PokemonLeague_ChampionsRoom_EventScript_BattleSquirtle:
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_6
	TrainerBattle 826, 0, 0, 0
	GoTo _cv_battle_5
_cv_next_6:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_7
	TrainerBattle 830, 0, 0, 0
	GoTo _cv_battle_5
_cv_next_7:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_8
	TrainerBattle 824, 0, 0, 0
	GoTo _cv_battle_5
_cv_next_8:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_9
	TrainerBattle 822, 0, 0, 0
	GoTo _cv_battle_5
_cv_next_9:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_10
	TrainerBattle 832, 0, 0, 0
	GoTo _cv_battle_5
_cv_next_10:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_11
	TrainerBattle 827, 0, 0, 0
	GoTo _cv_battle_5
_cv_next_11:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_12
	TrainerBattle 829, 0, 0, 0
	GoTo _cv_battle_5
_cv_next_12:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_13
	TrainerBattle 831, 0, 0, 0
	GoTo _cv_battle_5
_cv_next_13:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_14
	TrainerBattle 825, 0, 0, 0
	GoTo _cv_battle_5
_cv_next_14:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_15
	TrainerBattle 833, 0, 0, 0
	GoTo _cv_battle_5
_cv_next_15:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_16
	TrainerBattle 828, 0, 0, 0
	GoTo _cv_battle_5
_cv_next_16:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_17
	TrainerBattle 823, 0, 0, 0
	GoTo _cv_battle_5
_cv_next_17:
	TrainerBattle 822, 0, 0, 0
_cv_battle_5:
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_18
	WhiteOut
	End
_cv_won_18:
	SetFlag 0x2053
	Return
	
PokemonLeague_ChampionsRoom_EventScript_BattleBulbasaur:
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_20
	TrainerBattle 826, 0, 0, 0
	GoTo _cv_battle_19
_cv_next_20:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_21
	TrainerBattle 830, 0, 0, 0
	GoTo _cv_battle_19
_cv_next_21:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_22
	TrainerBattle 824, 0, 0, 0
	GoTo _cv_battle_19
_cv_next_22:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_23
	TrainerBattle 822, 0, 0, 0
	GoTo _cv_battle_19
_cv_next_23:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_24
	TrainerBattle 832, 0, 0, 0
	GoTo _cv_battle_19
_cv_next_24:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_25
	TrainerBattle 827, 0, 0, 0
	GoTo _cv_battle_19
_cv_next_25:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_26
	TrainerBattle 829, 0, 0, 0
	GoTo _cv_battle_19
_cv_next_26:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_27
	TrainerBattle 831, 0, 0, 0
	GoTo _cv_battle_19
_cv_next_27:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_28
	TrainerBattle 825, 0, 0, 0
	GoTo _cv_battle_19
_cv_next_28:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_29
	TrainerBattle 833, 0, 0, 0
	GoTo _cv_battle_19
_cv_next_29:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_30
	TrainerBattle 828, 0, 0, 0
	GoTo _cv_battle_19
_cv_next_30:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_31
	TrainerBattle 823, 0, 0, 0
	GoTo _cv_battle_19
_cv_next_31:
	TrainerBattle 822, 0, 0, 0
_cv_battle_19:
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_32
	WhiteOut
	End
_cv_won_32:
	SetFlag 0x2054
	Return
	
PokemonLeague_ChampionsRoom_EventScript_BattleCharmander:
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_34
	TrainerBattle 826, 0, 0, 0
	GoTo _cv_battle_33
_cv_next_34:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_35
	TrainerBattle 830, 0, 0, 0
	GoTo _cv_battle_33
_cv_next_35:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_36
	TrainerBattle 824, 0, 0, 0
	GoTo _cv_battle_33
_cv_next_36:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_37
	TrainerBattle 822, 0, 0, 0
	GoTo _cv_battle_33
_cv_next_37:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_38
	TrainerBattle 832, 0, 0, 0
	GoTo _cv_battle_33
_cv_next_38:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_39
	TrainerBattle 827, 0, 0, 0
	GoTo _cv_battle_33
_cv_next_39:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_40
	TrainerBattle 829, 0, 0, 0
	GoTo _cv_battle_33
_cv_next_40:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_41
	TrainerBattle 831, 0, 0, 0
	GoTo _cv_battle_33
_cv_next_41:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_42
	TrainerBattle 825, 0, 0, 0
	GoTo _cv_battle_33
_cv_next_42:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_43
	TrainerBattle 833, 0, 0, 0
	GoTo _cv_battle_33
_cv_next_43:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_44
	TrainerBattle 828, 0, 0, 0
	GoTo _cv_battle_33
_cv_next_44:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_45
	TrainerBattle 823, 0, 0, 0
	GoTo _cv_battle_33
_cv_next_45:
	TrainerBattle 822, 0, 0, 0
_cv_battle_33:
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_46
	WhiteOut
	End
_cv_won_46:
	SetFlag 0x2055
	Return
	
PokemonLeague_ChampionsRoom_EventScript_RematchSquirtle:
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_48
	TrainerBattle 838, 0, 0, 0
	GoTo _cv_battle_47
_cv_next_48:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_49
	TrainerBattle 842, 0, 0, 0
	GoTo _cv_battle_47
_cv_next_49:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_50
	TrainerBattle 836, 0, 0, 0
	GoTo _cv_battle_47
_cv_next_50:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_51
	TrainerBattle 834, 0, 0, 0
	GoTo _cv_battle_47
_cv_next_51:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_52
	TrainerBattle 844, 0, 0, 0
	GoTo _cv_battle_47
_cv_next_52:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_53
	TrainerBattle 839, 0, 0, 0
	GoTo _cv_battle_47
_cv_next_53:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_54
	TrainerBattle 841, 0, 0, 0
	GoTo _cv_battle_47
_cv_next_54:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_55
	TrainerBattle 843, 0, 0, 0
	GoTo _cv_battle_47
_cv_next_55:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_56
	TrainerBattle 837, 0, 0, 0
	GoTo _cv_battle_47
_cv_next_56:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_57
	TrainerBattle 845, 0, 0, 0
	GoTo _cv_battle_47
_cv_next_57:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_58
	TrainerBattle 840, 0, 0, 0
	GoTo _cv_battle_47
_cv_next_58:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_59
	TrainerBattle 835, 0, 0, 0
	GoTo _cv_battle_47
_cv_next_59:
	TrainerBattle 834, 0, 0, 0
_cv_battle_47:
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_60
	WhiteOut
	End
_cv_won_60:
	SetFlag 0x2056
	Return
	
PokemonLeague_ChampionsRoom_EventScript_RematchBulbasaur:
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_62
	TrainerBattle 838, 0, 0, 0
	GoTo _cv_battle_61
_cv_next_62:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_63
	TrainerBattle 842, 0, 0, 0
	GoTo _cv_battle_61
_cv_next_63:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_64
	TrainerBattle 836, 0, 0, 0
	GoTo _cv_battle_61
_cv_next_64:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_65
	TrainerBattle 834, 0, 0, 0
	GoTo _cv_battle_61
_cv_next_65:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_66
	TrainerBattle 844, 0, 0, 0
	GoTo _cv_battle_61
_cv_next_66:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_67
	TrainerBattle 839, 0, 0, 0
	GoTo _cv_battle_61
_cv_next_67:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_68
	TrainerBattle 841, 0, 0, 0
	GoTo _cv_battle_61
_cv_next_68:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_69
	TrainerBattle 843, 0, 0, 0
	GoTo _cv_battle_61
_cv_next_69:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_70
	TrainerBattle 837, 0, 0, 0
	GoTo _cv_battle_61
_cv_next_70:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_71
	TrainerBattle 845, 0, 0, 0
	GoTo _cv_battle_61
_cv_next_71:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_72
	TrainerBattle 840, 0, 0, 0
	GoTo _cv_battle_61
_cv_next_72:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_73
	TrainerBattle 835, 0, 0, 0
	GoTo _cv_battle_61
_cv_next_73:
	TrainerBattle 834, 0, 0, 0
_cv_battle_61:
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_74
	WhiteOut
	End
_cv_won_74:
	SetFlag 0x2057
	Return
	
PokemonLeague_ChampionsRoom_EventScript_RematchCharmander:
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_76
	TrainerBattle 838, 0, 0, 0
	GoTo _cv_battle_75
_cv_next_76:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_77
	TrainerBattle 842, 0, 0, 0
	GoTo _cv_battle_75
_cv_next_77:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_78
	TrainerBattle 836, 0, 0, 0
	GoTo _cv_battle_75
_cv_next_78:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_79
	TrainerBattle 834, 0, 0, 0
	GoTo _cv_battle_75
_cv_next_79:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_80
	TrainerBattle 844, 0, 0, 0
	GoTo _cv_battle_75
_cv_next_80:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_81
	TrainerBattle 839, 0, 0, 0
	GoTo _cv_battle_75
_cv_next_81:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_82
	TrainerBattle 841, 0, 0, 0
	GoTo _cv_battle_75
_cv_next_82:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_83
	TrainerBattle 843, 0, 0, 0
	GoTo _cv_battle_75
_cv_next_83:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_84
	TrainerBattle 837, 0, 0, 0
	GoTo _cv_battle_75
_cv_next_84:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_85
	TrainerBattle 845, 0, 0, 0
	GoTo _cv_battle_75
_cv_next_85:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_86
	TrainerBattle 840, 0, 0, 0
	GoTo _cv_battle_75
_cv_next_86:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_87
	TrainerBattle 835, 0, 0, 0
	GoTo _cv_battle_75
_cv_next_87:
	TrainerBattle 834, 0, 0, 0
_cv_battle_75:
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_88
	WhiteOut
	End
_cv_won_88:
	SetFlag 0x2058
	Return

_cv_unported_1:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0527_T10R0601_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0527_T10R0601_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
PokemonLeague_ChampionsRoom_Movement_PlayerEnter:
	WalkNormalNorth 10
	EndMovement

	.balign 4, 0
PokemonLeague_ChampionsRoom_Movement_PlayerWatchOakEnter:
	Delay8
	WalkOnSpotFasterSouth
	Delay16 7
	WalkOnSpotFasterWest
	EndMovement

	.balign 4, 0
PokemonLeague_ChampionsRoom_Movement_RivalWatchOakEnter:
	Delay16 9
	WalkOnSpotFasterWest
	EndMovement

	.balign 4, 0
PokemonLeague_ChampionsRoom_Movement_OakEnter:
	Delay16 2
	WalkNormalNorth 5
	WalkNormalWest
	WalkNormalNorth 2
	WalkOnSpotFasterSouth
	Delay16
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterRight:
	WalkOnSpotFasterEast
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterLeft:
	WalkOnSpotFasterWest
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterDown:
	WalkOnSpotFasterSouth
	EndMovement

	.balign 4, 0
PokemonLeague_ChampionsRoom_Movement_OakExit:
	WalkNormalNorth 2
	WalkNormalEast
	WalkNormalNorth 4
	Delay8
	SetInvisible
	EndMovement

	.balign 4, 0
PokemonLeague_ChampionsRoom_Movement_PlayerExit:
	Delay16
	WalkNormalWest
	WalkNormalNorth 3
	WalkNormalEast
	WalkNormalNorth 4
	Delay8
	SetInvisible
	EndMovement

	.balign 4, 0
GymFinale_Movement_OakStepBack:
	WalkNormalSouth 2
	WalkNormalEast
	WalkNormalSouth 5
	SetInvisible
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterUp:
	WalkOnSpotFasterNorth
	EndMovement
	.balign 4, 0
