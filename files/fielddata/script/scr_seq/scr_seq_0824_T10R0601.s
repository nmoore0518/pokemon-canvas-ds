#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T10R0601.h"
#include "msgdata/msg/msg_0527_T10R0601.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PokemonLeague_ChampionsRoom_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef PokemonLeague_ChampionsRoom_OnResume
	ScrDef PokemonLeague_ChampionsRoom_EventScript_EnterRoom
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
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_4
	SetVar VAR_SPECIAL_RESULT, SPECIES_RALTS
	GoTo _cv_done_3
_cv_next_4:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_5
	SetVar VAR_SPECIAL_RESULT, SPECIES_CHARMANDER
	GoTo _cv_done_3
_cv_next_5:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_6
	SetVar VAR_SPECIAL_RESULT, SPECIES_PORYGON
	GoTo _cv_done_3
_cv_next_6:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_7
	SetVar VAR_SPECIAL_RESULT, SPECIES_SQUIRTLE
	GoTo _cv_done_3
_cv_next_7:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_8
	SetVar VAR_SPECIAL_RESULT, SPECIES_BULBASAUR
	GoTo _cv_done_3
_cv_next_8:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_9
	SetVar VAR_SPECIAL_RESULT, SPECIES_PIKACHU
	GoTo _cv_done_3
_cv_next_9:
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_10
	SetVar VAR_SPECIAL_RESULT, SPECIES_LARVITAR
	GoTo _cv_done_3
_cv_next_10:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_11
	SetVar VAR_SPECIAL_RESULT, SPECIES_EKANS
	GoTo _cv_done_3
_cv_next_11:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_12
	SetVar VAR_SPECIAL_RESULT, SPECIES_CATERPIE
	GoTo _cv_done_3
_cv_next_12:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_13
	SetVar VAR_SPECIAL_RESULT, SPECIES_BELDUM
	GoTo _cv_done_3
_cv_next_13:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_14
	SetVar VAR_SPECIAL_RESULT, SPECIES_SPHEAL
	GoTo _cv_done_3
_cv_next_14:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_15
	SetVar VAR_SPECIAL_RESULT, SPECIES_SANDSHREW
	GoTo _cv_done_3
_cv_next_15:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_16
	SetVar VAR_SPECIAL_RESULT, SPECIES_SPEAROW
	GoTo _cv_done_3
_cv_next_16:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_17
	SetVar VAR_SPECIAL_RESULT, SPECIES_DRATINI
	GoTo _cv_done_3
_cv_next_17:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_18
	SetVar VAR_SPECIAL_RESULT, SPECIES_TYROGUE
	GoTo _cv_done_3
_cv_next_18:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_19
	SetVar VAR_SPECIAL_RESULT, SPECIES_POOCHYENA
	GoTo _cv_done_3
_cv_next_19:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_20
	SetVar VAR_SPECIAL_RESULT, SPECIES_GASTLY
	GoTo _cv_done_3
_cv_next_20:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_21
	SetVar VAR_SPECIAL_RESULT, SPECIES_CLEFAIRY
	GoTo _cv_done_3
_cv_next_21:
_cv_done_3:
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
	GoToIfUnset 0x2064, _cv_show_22
	ClearFlag 0x2064
	ShowPerson 2
	SetFlag 0x2064
	GoTo _cv_shown_23
_cv_show_22:
	ShowPerson 2
_cv_shown_23:
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
	CanvasCloseMsg
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_25
	TrainerBattle 826, 826, 0, 0
	GoTo _cv_battle_24
_cv_next_25:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_26
	TrainerBattle 830, 830, 0, 0
	GoTo _cv_battle_24
_cv_next_26:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_27
	TrainerBattle 824, 824, 0, 0
	GoTo _cv_battle_24
_cv_next_27:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_28
	TrainerBattle 822, 822, 0, 0
	GoTo _cv_battle_24
_cv_next_28:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_29
	TrainerBattle 832, 832, 0, 0
	GoTo _cv_battle_24
_cv_next_29:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_30
	TrainerBattle 827, 827, 0, 0
	GoTo _cv_battle_24
_cv_next_30:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_31
	TrainerBattle 829, 829, 0, 0
	GoTo _cv_battle_24
_cv_next_31:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_32
	TrainerBattle 831, 831, 0, 0
	GoTo _cv_battle_24
_cv_next_32:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_33
	TrainerBattle 825, 825, 0, 0
	GoTo _cv_battle_24
_cv_next_33:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_34
	TrainerBattle 833, 833, 0, 0
	GoTo _cv_battle_24
_cv_next_34:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_35
	TrainerBattle 828, 828, 0, 0
	GoTo _cv_battle_24
_cv_next_35:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_36
	TrainerBattle 823, 823, 0, 0
	GoTo _cv_battle_24
_cv_next_36:
	TrainerBattle 822, 822, 0, 0
_cv_battle_24:
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_37
	WhiteOut
	End
_cv_won_37:
	SetFlag 0x2053
	Return
	
PokemonLeague_ChampionsRoom_EventScript_BattleBulbasaur:
	CanvasCloseMsg
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_39
	TrainerBattle 826, 826, 0, 0
	GoTo _cv_battle_38
_cv_next_39:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_40
	TrainerBattle 830, 830, 0, 0
	GoTo _cv_battle_38
_cv_next_40:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_41
	TrainerBattle 824, 824, 0, 0
	GoTo _cv_battle_38
_cv_next_41:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_42
	TrainerBattle 822, 822, 0, 0
	GoTo _cv_battle_38
_cv_next_42:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_43
	TrainerBattle 832, 832, 0, 0
	GoTo _cv_battle_38
_cv_next_43:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_44
	TrainerBattle 827, 827, 0, 0
	GoTo _cv_battle_38
_cv_next_44:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_45
	TrainerBattle 829, 829, 0, 0
	GoTo _cv_battle_38
_cv_next_45:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_46
	TrainerBattle 831, 831, 0, 0
	GoTo _cv_battle_38
_cv_next_46:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_47
	TrainerBattle 825, 825, 0, 0
	GoTo _cv_battle_38
_cv_next_47:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_48
	TrainerBattle 833, 833, 0, 0
	GoTo _cv_battle_38
_cv_next_48:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_49
	TrainerBattle 828, 828, 0, 0
	GoTo _cv_battle_38
_cv_next_49:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_50
	TrainerBattle 823, 823, 0, 0
	GoTo _cv_battle_38
_cv_next_50:
	TrainerBattle 822, 822, 0, 0
_cv_battle_38:
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_51
	WhiteOut
	End
_cv_won_51:
	SetFlag 0x2054
	Return
	
PokemonLeague_ChampionsRoom_EventScript_BattleCharmander:
	CanvasCloseMsg
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_53
	TrainerBattle 826, 826, 0, 0
	GoTo _cv_battle_52
_cv_next_53:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_54
	TrainerBattle 830, 830, 0, 0
	GoTo _cv_battle_52
_cv_next_54:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_55
	TrainerBattle 824, 824, 0, 0
	GoTo _cv_battle_52
_cv_next_55:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_56
	TrainerBattle 822, 822, 0, 0
	GoTo _cv_battle_52
_cv_next_56:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_57
	TrainerBattle 832, 832, 0, 0
	GoTo _cv_battle_52
_cv_next_57:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_58
	TrainerBattle 827, 827, 0, 0
	GoTo _cv_battle_52
_cv_next_58:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_59
	TrainerBattle 829, 829, 0, 0
	GoTo _cv_battle_52
_cv_next_59:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_60
	TrainerBattle 831, 831, 0, 0
	GoTo _cv_battle_52
_cv_next_60:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_61
	TrainerBattle 825, 825, 0, 0
	GoTo _cv_battle_52
_cv_next_61:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_62
	TrainerBattle 833, 833, 0, 0
	GoTo _cv_battle_52
_cv_next_62:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_63
	TrainerBattle 828, 828, 0, 0
	GoTo _cv_battle_52
_cv_next_63:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_64
	TrainerBattle 823, 823, 0, 0
	GoTo _cv_battle_52
_cv_next_64:
	TrainerBattle 822, 822, 0, 0
_cv_battle_52:
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_65
	WhiteOut
	End
_cv_won_65:
	SetFlag 0x2055
	Return
	
PokemonLeague_ChampionsRoom_EventScript_RematchSquirtle:
	CanvasCloseMsg
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_67
	TrainerBattle 838, 838, 0, 0
	GoTo _cv_battle_66
_cv_next_67:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_68
	TrainerBattle 842, 842, 0, 0
	GoTo _cv_battle_66
_cv_next_68:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_69
	TrainerBattle 836, 836, 0, 0
	GoTo _cv_battle_66
_cv_next_69:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_70
	TrainerBattle 834, 834, 0, 0
	GoTo _cv_battle_66
_cv_next_70:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_71
	TrainerBattle 844, 844, 0, 0
	GoTo _cv_battle_66
_cv_next_71:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_72
	TrainerBattle 839, 839, 0, 0
	GoTo _cv_battle_66
_cv_next_72:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_73
	TrainerBattle 841, 841, 0, 0
	GoTo _cv_battle_66
_cv_next_73:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_74
	TrainerBattle 843, 843, 0, 0
	GoTo _cv_battle_66
_cv_next_74:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_75
	TrainerBattle 837, 837, 0, 0
	GoTo _cv_battle_66
_cv_next_75:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_76
	TrainerBattle 845, 845, 0, 0
	GoTo _cv_battle_66
_cv_next_76:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_77
	TrainerBattle 840, 840, 0, 0
	GoTo _cv_battle_66
_cv_next_77:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_78
	TrainerBattle 835, 835, 0, 0
	GoTo _cv_battle_66
_cv_next_78:
	TrainerBattle 834, 834, 0, 0
_cv_battle_66:
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_79
	WhiteOut
	End
_cv_won_79:
	SetFlag 0x2056
	Return
	
PokemonLeague_ChampionsRoom_EventScript_RematchBulbasaur:
	CanvasCloseMsg
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_81
	TrainerBattle 838, 838, 0, 0
	GoTo _cv_battle_80
_cv_next_81:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_82
	TrainerBattle 842, 842, 0, 0
	GoTo _cv_battle_80
_cv_next_82:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_83
	TrainerBattle 836, 836, 0, 0
	GoTo _cv_battle_80
_cv_next_83:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_84
	TrainerBattle 834, 834, 0, 0
	GoTo _cv_battle_80
_cv_next_84:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_85
	TrainerBattle 844, 844, 0, 0
	GoTo _cv_battle_80
_cv_next_85:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_86
	TrainerBattle 839, 839, 0, 0
	GoTo _cv_battle_80
_cv_next_86:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_87
	TrainerBattle 841, 841, 0, 0
	GoTo _cv_battle_80
_cv_next_87:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_88
	TrainerBattle 843, 843, 0, 0
	GoTo _cv_battle_80
_cv_next_88:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_89
	TrainerBattle 837, 837, 0, 0
	GoTo _cv_battle_80
_cv_next_89:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_90
	TrainerBattle 845, 845, 0, 0
	GoTo _cv_battle_80
_cv_next_90:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_91
	TrainerBattle 840, 840, 0, 0
	GoTo _cv_battle_80
_cv_next_91:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_92
	TrainerBattle 835, 835, 0, 0
	GoTo _cv_battle_80
_cv_next_92:
	TrainerBattle 834, 834, 0, 0
_cv_battle_80:
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_93
	WhiteOut
	End
_cv_won_93:
	SetFlag 0x2057
	Return
	
PokemonLeague_ChampionsRoom_EventScript_RematchCharmander:
	CanvasCloseMsg
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_95
	TrainerBattle 838, 838, 0, 0
	GoTo _cv_battle_94
_cv_next_95:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_96
	TrainerBattle 842, 842, 0, 0
	GoTo _cv_battle_94
_cv_next_96:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_97
	TrainerBattle 836, 836, 0, 0
	GoTo _cv_battle_94
_cv_next_97:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_98
	TrainerBattle 834, 834, 0, 0
	GoTo _cv_battle_94
_cv_next_98:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_99
	TrainerBattle 844, 844, 0, 0
	GoTo _cv_battle_94
_cv_next_99:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_100
	TrainerBattle 839, 839, 0, 0
	GoTo _cv_battle_94
_cv_next_100:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_101
	TrainerBattle 841, 841, 0, 0
	GoTo _cv_battle_94
_cv_next_101:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_102
	TrainerBattle 843, 843, 0, 0
	GoTo _cv_battle_94
_cv_next_102:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_103
	TrainerBattle 837, 837, 0, 0
	GoTo _cv_battle_94
_cv_next_103:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_104
	TrainerBattle 845, 845, 0, 0
	GoTo _cv_battle_94
_cv_next_104:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_105
	TrainerBattle 840, 840, 0, 0
	GoTo _cv_battle_94
_cv_next_105:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_106
	TrainerBattle 835, 835, 0, 0
	GoTo _cv_battle_94
_cv_next_106:
	TrainerBattle 834, 834, 0, 0
_cv_battle_94:
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_107
	WhiteOut
	End
_cv_won_107:
	SetFlag 0x2058
	Return

_cv_stop:
	NPCMsg msg_0527_T10R0601_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
PokemonLeague_ChampionsRoom_Movement_PlayerEnter:
	WalkNormalNorth 17
	EndMovement

	.balign 4, 0
PokemonLeague_ChampionsRoom_Movement_PlayerWatchOakEnter:
	Delay8
	WalkOnSpotFasterSouth
	Delay16 13
	WalkOnSpotFasterWest
	EndMovement

	.balign 4, 0
PokemonLeague_ChampionsRoom_Movement_RivalWatchOakEnter:
	Delay16 15
	WalkOnSpotFasterWest
	EndMovement

	.balign 4, 0
PokemonLeague_ChampionsRoom_Movement_OakEnter:
	Delay16 2
	WalkNormalNorth 11
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
	WalkNormalNorth 6
	Delay8
	SetInvisible
	EndMovement

	.balign 4, 0
PokemonLeague_ChampionsRoom_Movement_PlayerExit:
	Delay16
	WalkNormalWest
	WalkNormalNorth 3
	WalkNormalEast
	WalkNormalNorth 6
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
