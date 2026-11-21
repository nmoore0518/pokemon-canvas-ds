#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_FIGHT_AREA_UNUSED_7.h"
#include "msgdata/msg/msg_0856_CV_FIGHT_AREA_UNUSED_7.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PalletTown_Gym_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef PalletTown_Gym_EventScript_Oak
	ScrDef GymChallenge_EventScript_Aide
	ScrDef GymPractice_EventScript_Trainer0
	ScrDef GymPractice_EventScript_Trainer1
	ScrDef GymPractice_EventScript_Trainer2
	ScrDef GymPractice_EventScript_Trainer3
	ScrDef GymPractice_EventScript_Trainer4
	ScrDef GymPractice_EventScript_Trainer5
	ScrDef GymPractice_EventScript_Trainer6
	ScrDef GymPractice_EventScript_Trainer7
	ScrDef GymPractice_EventScript_Trainer8
	ScrDef GymPractice_EventScript_Trainer9
	ScrDef GymPractice_EventScript_Trainer10
	ScrDef GymLegend_EventScript_Legend
	ScrDef Gauntlet_EventScript_Figure
	ScrDef PalletTown_Gym_EventScript_GymStatue
	ScrDef GymDecor_EventScript_GymPC
	ScrDef PalletTown_Gym_OnLoad
	ScrDef PalletTown_Gym_OnTransition
	ScrDef GymFinale_EventScript_FirstDay
	ScrDef PalletTown_Gym_EventScript_OakShowsGym
	ScrDef PalletTown_Gym_EventScript_OakWantsTheGym
	ScrDef GymLegend_EventScript_RivalEscaped
	ScrDef GymLegend_EventScript_RivalCaught
	ScrDef GymLegend_EventScript_ArrivesLater
	ScrDef _cv_unported_25
	ScrDef Gauntlet_EventScript_Arrives
	ScrDefEnd
	
PalletTown_Gym_EventScript_Oak:
	LockAll
	FacePlayer
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_OakYouCameBack
	WaitButton
	GoTo GymFinale_EventScript_OakAsksToBattle
	CloseMsg
	End
	
GymChallenge_EventScript_Aide:
	LockAll
	FacePlayer
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x2008, _cv_open_1
	SetVar VAR_SPECIAL_RESULT, 1
_cv_open_1:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymChallenge_EventScript_AideNotYet
	BufferInt 0, 0x504D
	BufferInt 1, 0x504E
	BufferInt 2, 0x504F
	BufferInt 3, 0x5050
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_AideWelcome
	WaitButton
	SetVar 0x401E, 15
	BufferInt 0, 0x401E
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfSet 0x22E8, _cv_goal_2
	CompareVarToValue 0x504D, 15
	GoToIfGe _cv_goal_2
	SetVar VAR_SPECIAL_RESULT, 1
_cv_goal_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq GymSwitch_EventScript_AideGoal
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_ReadyToBattle
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_3
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_4
_cv_yes_3:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymChallenge_EventScript_NotNow
	CanvasCheckTeam 7, 0x5019
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe GymChallenge_EventScript_TeamBreaksRules
	HealParty
	SetVar VAR_SPECIAL_RESULT, 1
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymChallenge_EventScript_CantReachSpot
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	CallIfEq GymChallenge_EventScript_NoStage
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	CallIfEq GymChallenge_EventScript_StageBlocked
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_TakeYourPlace
	WaitButton
	CanvasCloseMsg
	GoTo GymChallenge_EventScript_NextChallenger
	End
	
GymPractice_EventScript_Trainer0:
	SetVar 0x8004, 0
	GoTo GymPractice_EventScript_Trainer
	End
	
GymPractice_EventScript_Trainer1:
	SetVar 0x8004, 1
	GoTo GymPractice_EventScript_Trainer
	End
	
GymPractice_EventScript_Trainer2:
	SetVar 0x8004, 2
	GoTo GymPractice_EventScript_Trainer
	End
	
GymPractice_EventScript_Trainer3:
	SetVar 0x8004, 3
	GoTo GymPractice_EventScript_Trainer
	End
	
GymPractice_EventScript_Trainer4:
	SetVar 0x8004, 4
	GoTo GymPractice_EventScript_Trainer
	End
	
GymPractice_EventScript_Trainer5:
	SetVar 0x8004, 5
	GoTo GymPractice_EventScript_Trainer
	End
	
GymPractice_EventScript_Trainer6:
	SetVar 0x8004, 6
	GoTo GymPractice_EventScript_Trainer
	End
	
GymPractice_EventScript_Trainer7:
	SetVar 0x8004, 7
	GoTo GymPractice_EventScript_Trainer
	End
	
GymPractice_EventScript_Trainer8:
	SetVar 0x8004, 8
	GoTo GymPractice_EventScript_Trainer
	End
	
GymPractice_EventScript_Trainer9:
	SetVar 0x8004, 9
	GoTo GymPractice_EventScript_Trainer
	End
	
GymPractice_EventScript_Trainer10:
	SetVar 0x8004, 10
	GoTo GymPractice_EventScript_Trainer
	End
	
GymLegend_EventScript_Legend:
	LockAll
	FacePlayer
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_7
	SetVar 0x8004, 698
	SetVar 0x402C, 3198
	GoTo _cv_done_6
_cv_next_7:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_8
	SetVar 0x8004, 1057
	SetVar 0x402C, 3557
	GoTo _cv_done_6
_cv_next_8:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_9
	SetVar 0x8004, 691
	SetVar 0x402C, 3191
	GoTo _cv_done_6
_cv_next_9:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_10
	SetVar 0x8004, 940
	SetVar 0x402C, 3440
	GoTo _cv_done_6
_cv_next_10:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_11
	SetVar 0x8004, SPECIES_GROUDON
	SetVar 0x402C, SPRITE_FOLLOWER_MON_STATIC_GROUDON
	GoTo _cv_done_6
_cv_next_11:
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_12
	SetVar 0x8004, 769
	SetVar 0x402C, 3269
	GoTo _cv_done_6
_cv_next_12:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_13
	SetVar 0x8004, 699
	SetVar 0x402C, 3199
	GoTo _cv_done_6
_cv_next_13:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_14
	SetVar 0x8004, SPECIES_GIRATINA
	SetVar 0x402C, 2987
	GoTo _cv_done_6
_cv_next_14:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_15
	SetVar 0x8004, SPECIES_DIALGA
	SetVar 0x402C, 2983
	GoTo _cv_done_6
_cv_next_15:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_16
	SetVar 0x8004, SPECIES_HO_OH
	SetVar 0x402C, 2750
	GoTo _cv_done_6
_cv_next_16:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_17
	SetVar 0x8004, SPECIES_PALKIA
	SetVar 0x402C, 2984
	GoTo _cv_done_6
_cv_next_17:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_18
	SetVar 0x8004, SPECIES_SHAYMIN
	SetVar 0x402C, 2992
	GoTo _cv_done_6
_cv_next_18:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_19
	SetVar 0x8004, 1058
	SetVar 0x402C, 3558
	GoTo _cv_done_6
_cv_next_19:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_20
	SetVar 0x8004, SPECIES_CRESSELIA
	SetVar 0x402C, 2988
	GoTo _cv_done_6
_cv_next_20:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_21
	SetVar 0x8004, 946
	SetVar 0x402C, 3446
	GoTo _cv_done_6
_cv_next_21:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_22
	SetVar 0x8004, SPECIES_RAYQUAZA
	SetVar 0x402C, SPRITE_FOLLOWER_MON_STATIC_RAYQUAZA
	GoTo _cv_done_6
_cv_next_22:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_23
	SetVar 0x8004, SPECIES_DARKRAI
	SetVar 0x402C, 2991
	GoTo _cv_done_6
_cv_next_23:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_24
	SetVar 0x8004, 766
	SetVar 0x402C, 3266
	GoTo _cv_done_6
_cv_next_24:
_cv_done_6:
	BufferSpeciesName 0, 0x8004, 0, 0
	BufferTypeName 1, 0x5019
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfSet 0x2037, _cv_legend_5
	SetVar VAR_SPECIAL_RESULT, 1
_cv_legend_5:
	CopyVar 0x8008, 0x8004
	PlayCry 0x8008, 0
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymLegend_Text_Challenge
	WaitButton
	WaitCry
	CanvasCloseMsg
	SetVar 0x5014, 1
	SetFlag 0x2032
	WildBattle 0x8008, 70, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_wild_25
	WhiteOut
	ReleaseAll
	End
_cv_wild_25:
	ClearFlag 0x2032
	GetStaticEncounterOutcome VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfNe _cv_outcome_26
	SetVar VAR_SPECIAL_RESULT, 7
	GoTo _cv_outcome_27
_cv_outcome_26:
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfNe _cv_outcome_27
	SetVar VAR_SPECIAL_RESULT, 4
_cv_outcome_27:
	HidePerson 16
	SetFlag 0x203A
	CompareVarToValue VAR_SPECIAL_RESULT, 7
	GoToIfEq GymLegend_EventScript_Caught
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_30
	SetVar 0x8004, 698
	SetVar 0x402C, 3198
	GoTo _cv_done_29
_cv_next_30:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_31
	SetVar 0x8004, 1057
	SetVar 0x402C, 3557
	GoTo _cv_done_29
_cv_next_31:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_32
	SetVar 0x8004, 691
	SetVar 0x402C, 3191
	GoTo _cv_done_29
_cv_next_32:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_33
	SetVar 0x8004, 940
	SetVar 0x402C, 3440
	GoTo _cv_done_29
_cv_next_33:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_34
	SetVar 0x8004, SPECIES_GROUDON
	SetVar 0x402C, SPRITE_FOLLOWER_MON_STATIC_GROUDON
	GoTo _cv_done_29
_cv_next_34:
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_35
	SetVar 0x8004, 769
	SetVar 0x402C, 3269
	GoTo _cv_done_29
_cv_next_35:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_36
	SetVar 0x8004, 699
	SetVar 0x402C, 3199
	GoTo _cv_done_29
_cv_next_36:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_37
	SetVar 0x8004, SPECIES_GIRATINA
	SetVar 0x402C, 2987
	GoTo _cv_done_29
_cv_next_37:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_38
	SetVar 0x8004, SPECIES_DIALGA
	SetVar 0x402C, 2983
	GoTo _cv_done_29
_cv_next_38:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_39
	SetVar 0x8004, SPECIES_HO_OH
	SetVar 0x402C, 2750
	GoTo _cv_done_29
_cv_next_39:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_40
	SetVar 0x8004, SPECIES_PALKIA
	SetVar 0x402C, 2984
	GoTo _cv_done_29
_cv_next_40:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_41
	SetVar 0x8004, SPECIES_SHAYMIN
	SetVar 0x402C, 2992
	GoTo _cv_done_29
_cv_next_41:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_42
	SetVar 0x8004, 1058
	SetVar 0x402C, 3558
	GoTo _cv_done_29
_cv_next_42:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_43
	SetVar 0x8004, SPECIES_CRESSELIA
	SetVar 0x402C, 2988
	GoTo _cv_done_29
_cv_next_43:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_44
	SetVar 0x8004, 946
	SetVar 0x402C, 3446
	GoTo _cv_done_29
_cv_next_44:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_45
	SetVar 0x8004, SPECIES_RAYQUAZA
	SetVar 0x402C, SPRITE_FOLLOWER_MON_STATIC_RAYQUAZA
	GoTo _cv_done_29
_cv_next_45:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_46
	SetVar 0x8004, SPECIES_DARKRAI
	SetVar 0x402C, 2991
	GoTo _cv_done_29
_cv_next_46:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_47
	SetVar 0x8004, 766
	SetVar 0x402C, 3266
	GoTo _cv_done_29
_cv_next_47:
_cv_done_29:
	BufferSpeciesName 0, 0x8004, 0, 0
	BufferTypeName 1, 0x5019
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfSet 0x2037, _cv_legend_28
	SetVar VAR_SPECIAL_RESULT, 1
_cv_legend_28:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymLegend_Text_Fled
	WaitButton
	CanvasCloseMsg
	GoTo GymLegend_EventScript_RivalEscaped
	End
	
Gauntlet_EventScript_Figure:
	LockAll
	CompareVarToValue 0x501B, 4
	GoToIfEq Gauntlet_EventScript_PalmPilot
	FacePlayer
	CompareVarToValue 0x501B, 3
	GoToIfEq Gauntlet_EventScript_AllBeaten
	GoTo Tourney_EventScript_Menu
	
PalletTown_Gym_EventScript_GymStatue:
	GoTo GymChallenge_EventScript_Statue
	End
	
GymDecor_EventScript_GymPC:
	LockAll
	PlaySE SEQ_SE_DP_SELECT
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_BootedUpGymPC
	WaitButton
	GoTo GymDecor_EventScript_PCMenu
	
PalletTown_Gym_OnLoad:
	SetFlag 0x203A
	GoToIfUnset 0x203B, _cv_legend_48
	GoToIfSet 0x2037, _cv_legend_48
	CompareVarToValue 0x5014, 0
	GoToIfNe _cv_legend_48
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_50
	SetVar 0x402C, 3198
	GoTo _cv_done_49
_cv_next_50:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_51
	SetVar 0x402C, 3557
	GoTo _cv_done_49
_cv_next_51:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_52
	SetVar 0x402C, 3191
	GoTo _cv_done_49
_cv_next_52:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_53
	SetVar 0x402C, 3440
	GoTo _cv_done_49
_cv_next_53:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_54
	SetVar 0x402C, SPRITE_FOLLOWER_MON_STATIC_GROUDON
	GoTo _cv_done_49
_cv_next_54:
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_55
	SetVar 0x402C, 3269
	GoTo _cv_done_49
_cv_next_55:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_56
	SetVar 0x402C, 3199
	GoTo _cv_done_49
_cv_next_56:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_57
	SetVar 0x402C, 2987
	GoTo _cv_done_49
_cv_next_57:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_58
	SetVar 0x402C, 2983
	GoTo _cv_done_49
_cv_next_58:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_59
	SetVar 0x402C, 2750
	GoTo _cv_done_49
_cv_next_59:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_60
	SetVar 0x402C, 2984
	GoTo _cv_done_49
_cv_next_60:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_61
	SetVar 0x402C, 2992
	GoTo _cv_done_49
_cv_next_61:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_62
	SetVar 0x402C, 3558
	GoTo _cv_done_49
_cv_next_62:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_63
	SetVar 0x402C, 2988
	GoTo _cv_done_49
_cv_next_63:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_64
	SetVar 0x402C, 3446
	GoTo _cv_done_49
_cv_next_64:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_65
	SetVar 0x402C, SPRITE_FOLLOWER_MON_STATIC_RAYQUAZA
	GoTo _cv_done_49
_cv_next_65:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_66
	SetVar 0x402C, 2991
	GoTo _cv_done_49
_cv_next_66:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_67
	SetVar 0x402C, 3266
	GoTo _cv_done_49
_cv_next_67:
_cv_done_49:
	MovePerson 16, 12, 18
	ClearFlag 0x203A
_cv_legend_48:
	End
	
PalletTown_Gym_OnTransition:
	SetFlag 0x203A
	GoToIfUnset 0x203B, _cv_legend_68
	GoToIfSet 0x2037, _cv_legend_68
	CompareVarToValue 0x5014, 0
	GoToIfNe _cv_legend_68
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_70
	SetVar 0x402C, 3198
	GoTo _cv_done_69
_cv_next_70:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_71
	SetVar 0x402C, 3557
	GoTo _cv_done_69
_cv_next_71:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_72
	SetVar 0x402C, 3191
	GoTo _cv_done_69
_cv_next_72:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_73
	SetVar 0x402C, 3440
	GoTo _cv_done_69
_cv_next_73:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_74
	SetVar 0x402C, SPRITE_FOLLOWER_MON_STATIC_GROUDON
	GoTo _cv_done_69
_cv_next_74:
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_75
	SetVar 0x402C, 3269
	GoTo _cv_done_69
_cv_next_75:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_76
	SetVar 0x402C, 3199
	GoTo _cv_done_69
_cv_next_76:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_77
	SetVar 0x402C, 2987
	GoTo _cv_done_69
_cv_next_77:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_78
	SetVar 0x402C, 2983
	GoTo _cv_done_69
_cv_next_78:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_79
	SetVar 0x402C, 2750
	GoTo _cv_done_69
_cv_next_79:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_80
	SetVar 0x402C, 2984
	GoTo _cv_done_69
_cv_next_80:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_81
	SetVar 0x402C, 2992
	GoTo _cv_done_69
_cv_next_81:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_82
	SetVar 0x402C, 3558
	GoTo _cv_done_69
_cv_next_82:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_83
	SetVar 0x402C, 2988
	GoTo _cv_done_69
_cv_next_83:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_84
	SetVar 0x402C, 3446
	GoTo _cv_done_69
_cv_next_84:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_85
	SetVar 0x402C, SPRITE_FOLLOWER_MON_STATIC_RAYQUAZA
	GoTo _cv_done_69
_cv_next_85:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_86
	SetVar 0x402C, 2991
	GoTo _cv_done_69
_cv_next_86:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_87
	SetVar 0x402C, 3266
	GoTo _cv_done_69
_cv_next_87:
_cv_done_69:
	MovePerson 16, 12, 18
	ClearFlag 0x203A
_cv_legend_68:
	SetFlag 0x2046
	SetFlag 0x2047
	SetFlag 0x2048
	SetFlag 0x2049
	SetFlag 0x204A
	SetFlag 0x204B
	SetFlag 0x204C
	SetFlag 0x204D
	SetFlag 0x204E
	SetFlag 0x204F
	SetFlag 0x2050
	SetFlag 0x2035
	SetFlag 0x2017
	SetFlag 0x2033
	SetFlag 0x2034
	CompareVarToValue 0x5005, 1
	CallIfEq PalletTown_Gym_EventScript_FirstVisitPeople
	CompareVarToValue 0x5005, 1
	CallIfNe PalletTown_Gym_EventScript_ShowAide
	CompareVarToValue 0x5005, 3
	CallIfEq PalletTown_Gym_EventScript_ShowOak
	CompareVarToValue 0x5005, 4
	CallIfEq PalletTown_Gym_EventScript_ShowOak
	CompareVarToValue 0x5004, 2
	CallIfEq PalletTown_Gym_EventScript_ShowOak
	End
	
GymFinale_EventScript_FirstDay:
	LockAll
	SetVar 0x5005, 2
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	PlayBGM SEQ_GS_T_MASARA
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_OakFirstDay
	WaitButton
	Call EventScript_TryReadyNationalDexScene
	GoTo GymFinale_EventScript_AideAndLegend
	
PalletTown_Gym_EventScript_OakShowsGym:
	LockAll
	PlayBGM SEQ_GS_OHKIDO
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_PalletTown_Gym_Text_OakHereWeAre
	WaitButton
	ApplyMovement 2, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	BufferRivalsName 7
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_PalletTown_Gym_Text_RivalAsGoodAsMine
	WaitButton
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_PalletTown_Gym_Text_OakDecorateIt
	WaitButton
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_PalletTown_Gym_Text_OakTakeBalloon
	WaitButton
	Call EventScript_GiveHotAirBalloon
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_PalletTown_Gym_Text_OakBalloonHowTo
	WaitButton
	ApplyMovement 2, Common_Movement_WalkInPlaceFasterLeft
	WaitMovement
	BufferPlayersName 6
	BufferRivalsName 7
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_PalletTown_Gym_Text_RivalTossYourJunk
	WaitButton
	ApplyMovement 2, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_PalletTown_Gym_Text_OakRunItMyself
	WaitButton
	ApplyMovement 2, Common_Movement_ExclamationMark
	WaitMovement
	BufferPlayersName 6
	BufferRivalsName 7
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_PalletTown_Gym_Text_RivalSeeYouAtTheTop
	WaitButton
	CanvasCloseMsg
	PlayBGM SEQ_GS_E_RIVAL2
	ApplyMovement obj_player, PalletTown_Gym_Movement_WatchRivalLeave
	ApplyMovement 2, PalletTown_Gym_Movement_RivalLeave
	WaitMovement
	HidePerson 2
	SetFlag 0x2033
	PlaySE SEQ_SE_DP_KAIDAN2
	Wait 30, VAR_SPECIAL_RESULT
	PlayBGM SEQ_GS_OHKIDO
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_PalletTown_Gym_Text_OakWaitingForYou
	WaitButton
	CanvasCloseMsg
	ApplyMovement 1, PalletTown_Gym_Movement_OakLeave
	WaitMovement
	HidePerson 1
	SetFlag 0x2034
	PlaySE SEQ_SE_DP_KAIDAN2
	SetFlag 0x2034
	SetFlag 0x2033
	SetFlag 0x2000
	SetVar 0x5005, 2
	ResetBGM
	CanvasCloseMsg
	ReleaseAll
	End
	
PalletTown_Gym_EventScript_OakWantsTheGym:
	LockAll
	SetVar 0x5005, 2
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	CompareVarToValue 0x5004, 5
	GoToIfEq GymFinale_EventScript_OakSkippedTheCeremony
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_OakHereWeAre
	WaitButton
	ApplyMovement 1, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_OakThinking
	WaitButton
	ApplyMovement 1, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	PlaySE SEQ_SE_DP_SELECT
	ApplyMovement 1, Common_Movement_ExclamationMark
	WaitMovement
	PlayBGM SEQ_GS_E_RIVAL1
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_OakWontGiveItUp
	WaitButton
	GoTo GymFinale_EventScript_OakAsksToBattle
	CloseMsg
	End
	
GymLegend_EventScript_RivalEscaped:
	LockAll
	Call GymLegend_EventScript_RivalWalksIn
	BufferPlayersName 6
	BufferRivalsName 7
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymLegend_Text_RivalEscaped
	WaitButton
	Call GymLegend_EventScript_RivalWalksOut
	SetVar 0x5014, 2
	CloseMsg
	ReleaseAll
	End
	
GymLegend_EventScript_RivalCaught:
	LockAll
	Call GymLegend_EventScript_RivalWalksIn
	BufferRivalsName 7
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymLegend_Text_RivalCaught
	WaitButton
	Call GymLegend_EventScript_RivalWalksOut
	SetVar 0x5014, 4
	CloseMsg
	ReleaseAll
	End
	
GymLegend_EventScript_ArrivesLater:
	LockAll
	Call GymLegend_EventScript_Appears
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymLegend_EventScript_ArrivesLaterEnd
	PlaySE SEQ_SE_DP_SELECT
	ApplyMovement obj_player, Common_Movement_ExclamationMark
	ApplyMovement 3, Common_Movement_ExclamationMark
	WaitMovement
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymLegend_Text_AideWhatOnEarth
	WaitButton
	CanvasCloseMsg
	ResetBGM
	GoTo GymLegend_EventScript_ArrivesLaterEnd
	
Johto_EventScript_Invitation:
	LockAll
	// TODO(gba) special GymCandidate_PrepareMentorVisit
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Johto_EventScript_InvitationByMail
	Wait 20, VAR_SPECIAL_RESULT
	PlaySE SEQ_SE_DP_DOOR
	SetVar 0x800A, 4
	Call GymCandidate_EventScript_VisitorWalksIn
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_89
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_88
_cv_next_89:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_90
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_88
_cv_next_90:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_91
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Misty
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_88
_cv_next_91:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_92
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_88
_cv_next_92:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_93
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_88
_cv_next_93:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_94
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Erika
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_88
_cv_next_94:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_95
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_88
_cv_next_95:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_96
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_88
_cv_next_96:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_97
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_88
_cv_next_97:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_98
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_88
_cv_next_98:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_99
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Blaine
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_88
_cv_next_99:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_100
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_88
_cv_next_100:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_101
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_88
_cv_next_101:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_102
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lorelei
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_88
_cv_next_102:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_103
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_88
_cv_next_103:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_104
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_88
_cv_next_104:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_105
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_88
_cv_next_105:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_106
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_88
_cv_next_106:
_cv_done_88:
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Johto_Text_MentorInvite
	WaitButton
	Call Johto_EventScript_ReceiveInvitation
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_108
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_107
_cv_next_108:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_109
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_107
_cv_next_109:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_110
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Misty
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_107
_cv_next_110:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_111
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_107
_cv_next_111:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_112
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_107
_cv_next_112:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_113
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Erika
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_107
_cv_next_113:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_114
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_107
_cv_next_114:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_115
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_107
_cv_next_115:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_116
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_107
_cv_next_116:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_117
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_107
_cv_next_117:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_118
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Blaine
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_107
_cv_next_118:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_119
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_107
_cv_next_119:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_120
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_107
_cv_next_120:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_121
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lorelei
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_107
_cv_next_121:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_122
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_107
_cv_next_122:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_123
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_107
_cv_next_123:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_124
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_107
_cv_next_124:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_125
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_107
_cv_next_125:
_cv_done_107:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Johto_Text_MentorInviteFerry
	WaitButton
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_127
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_126
_cv_next_127:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_128
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_126
_cv_next_128:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_129
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Misty
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_126
_cv_next_129:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_130
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_126
_cv_next_130:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_131
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_126
_cv_next_131:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_132
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Erika
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_126
_cv_next_132:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_133
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_126
_cv_next_133:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_134
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_126
_cv_next_134:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_135
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_126
_cv_next_135:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_136
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_126
_cv_next_136:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_137
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Blaine
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_126
_cv_next_137:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_138
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_126
_cv_next_138:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_139
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_126
_cv_next_139:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_140
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lorelei
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_126
_cv_next_140:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_141
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_126
_cv_next_141:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_142
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_126
_cv_next_142:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_143
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_126
_cv_next_143:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_144
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_126
_cv_next_144:
_cv_done_126:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Johto_Text_MentorGymCharm
	WaitButton
	Call Johto_EventScript_ReceiveGymCharm
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_146
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_145
_cv_next_146:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_147
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_145
_cv_next_147:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_148
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Misty
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_145
_cv_next_148:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_149
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_145
_cv_next_149:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_150
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_145
_cv_next_150:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_151
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Erika
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_145
_cv_next_151:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_152
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_145
_cv_next_152:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_153
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_145
_cv_next_153:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_154
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_145
_cv_next_154:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_155
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_145
_cv_next_155:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_156
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Blaine
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_145
_cv_next_156:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_157
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_145
_cv_next_157:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_158
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_145
_cv_next_158:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_159
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lorelei
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_145
_cv_next_159:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_160
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_145
_cv_next_160:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_161
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_145
_cv_next_161:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_162
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_145
_cv_next_162:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_163
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_145
_cv_next_163:
_cv_done_145:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Johto_Text_MentorGymCharmHow
	WaitButton
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_165
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_164
_cv_next_165:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_166
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_164
_cv_next_166:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_167
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Misty
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_164
_cv_next_167:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_168
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_164
_cv_next_168:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_169
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_164
_cv_next_169:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_170
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Erika
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_164
_cv_next_170:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_171
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_164
_cv_next_171:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_172
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_164
_cv_next_172:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_173
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_164
_cv_next_173:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_174
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_164
_cv_next_174:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_175
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Blaine
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_164
_cv_next_175:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_176
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_164
_cv_next_176:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_177
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_164
_cv_next_177:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_178
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lorelei
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_164
_cv_next_178:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_179
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_164
_cv_next_179:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_180
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_164
_cv_next_180:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_181
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_164
_cv_next_181:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_182
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_164
_cv_next_182:
_cv_done_164:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Johto_Text_MentorLeaderPerks
	WaitButton
	Call GymCandidate_EventScript_VisitorWalksOut
	SetVar 0x5009, 2
	CloseMsg
	ReleaseAll
	End
	
Gauntlet_EventScript_Arrives:
	LockAll
	SetVar 0x501B, 2
	ClearFlag 0x2035
	GoToIfUnset 0x2035, _cv_show_183
	ClearFlag 0x2035
	ShowPerson 17
	SetFlag 0x2035
	GoTo _cv_shown_184
_cv_show_183:
	ShowPerson 17
_cv_shown_184:
	PlaySE SEQ_SE_DP_SELECT
	ApplyMovement 17, Common_Movement_ExclamationMark
	WaitMovement
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Arrival1
	WaitButton
	PlayBGM SEQ_GS_EYE_ROCKET
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Arrival2
	WaitButton
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Arrival3
	WaitButton
	ResetBGM
	CloseMsg
	ReleaseAll
	End
	
GymFinale_EventScript_OakAsksToBattle:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_OakWillYouBattle
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_185
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_186
_cv_yes_185:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_186:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymFinale_EventScript_PutOff
	CanvasCheckTeam 7, 0x5019
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe GymFinale_EventScript_TeamBreaksRules
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_OakThenShowMe
	WaitButton
	CanvasCloseMsg
	HealParty
	CanvasCandidate 13
	CanvasCloseMsg
	ClearTrainerFlag 1476
	TrainerBattle 1476, 1476, 1, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CanvasCandidate 12
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymFinale_EventScript_BeatOak
	GoTo GymFinale_EventScript_LostToOak
	End
	
GymChallenge_EventScript_AideNotYet:
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x2093, _cv_appr_187
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_187:
	GoToIfUnset 0x2094, _cv_appr_188
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_188:
	GoToIfUnset 0x2095, _cv_appr_189
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_189:
	GoToIfUnset 0x2096, _cv_appr_190
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_190:
	GoToIfUnset 0x2097, _cv_appr_191
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_191:
	GoToIfUnset 0x2098, _cv_appr_192
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_192:
	GoToIfUnset 0x2099, _cv_appr_193
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_193:
	GoToIfUnset 0x2007, _cv_appr_194
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_194:
	BufferInt 0, VAR_SPECIAL_RESULT
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_AideNotYet
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymSwitch_EventScript_AideGoal:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymSwitch_Text_AideGoal
	WaitButton
	Return
	
GymChallenge_EventScript_NotNow:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_NotNow
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymChallenge_EventScript_TeamBreaksRules:
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfEq GymChallenge_EventScript_ItemClause
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_TeamBreaksRules
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymChallenge_EventScript_CantReachSpot:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_CantReachSpot
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymChallenge_EventScript_NoStage:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_NoStage
	WaitButton
	Return
	
GymChallenge_EventScript_StageBlocked:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_StageBlocked
	WaitButton
	Return
	
GymChallenge_EventScript_NextChallenger:
	GoToIfUnset 0x2008, _cv_trainer_197
	GoToIfSet 0x22E8, _cv_famous_196_roll
	CompareVarToValue 0x504D, 14
	GoToIfEq _cv_boss_195
_cv_famous_196_roll:
	CompareVarToValue 0x5051, 6
	GoToIfEq _cv_famous_196
	Random 0x401E, 12
	CompareVarToValue 0x401E, 2
	GoToIfLt _cv_famous_196
	GoTo _cv_trainer_197
_cv_boss_195:
	SetVar 0x5052, 3
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_200
	SetVar 0x5053, 0
	GoTo _cv_done_199
_cv_next_200:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_201
	SetVar 0x5053, 0
	GoTo _cv_done_199
_cv_next_201:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_202
	SetVar 0x5053, 1
	GoTo _cv_done_199
_cv_next_202:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_203
	SetVar 0x5053, 2
	GoTo _cv_done_199
_cv_next_203:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_204
	SetVar 0x5053, 2
	GoTo _cv_done_199
_cv_next_204:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_205
	SetVar 0x5053, 3
	GoTo _cv_done_199
_cv_next_205:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_206
	SetVar 0x5053, 4
	GoTo _cv_done_199
_cv_next_206:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_207
	SetVar 0x5053, 4
	GoTo _cv_done_199
_cv_next_207:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_208
	SetVar 0x5053, 5
	GoTo _cv_done_199
_cv_next_208:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_209
	SetVar 0x5053, 5
	GoTo _cv_done_199
_cv_next_209:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_210
	SetVar 0x5053, 6
	GoTo _cv_done_199
_cv_next_210:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_211
	SetVar 0x5053, 9
	GoTo _cv_done_199
_cv_next_211:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_212
	SetVar 0x5053, 10
	GoTo _cv_done_199
_cv_next_212:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_213
	SetVar 0x5053, 8
	GoTo _cv_done_199
_cv_next_213:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_214
	SetVar 0x5053, 9
	GoTo _cv_done_199
_cv_next_214:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_215
	SetVar 0x5053, 10
	GoTo _cv_done_199
_cv_next_215:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_216
	SetVar 0x5053, 11
	GoTo _cv_done_199
_cv_next_216:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_217
	SetVar 0x5053, 11
	GoTo _cv_done_199
_cv_next_217:
_cv_done_199:
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_219
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_218
_cv_next_219:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_220
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Brock
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_218
_cv_next_220:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_221
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Misty
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_218
_cv_next_221:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_222
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_218
_cv_next_222:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_223
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_LtSurge
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_218
_cv_next_223:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_224
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Erika
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_218
_cv_next_224:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_225
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_218
_cv_next_225:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_226
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Koga
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_218
_cv_next_226:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_227
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_218
_cv_next_227:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_228
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Sabrina
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_218
_cv_next_228:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_229
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Blaine
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_218
_cv_next_229:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_230
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_218
_cv_next_230:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_231
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_218
_cv_next_231:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_232
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lorelei
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_218
_cv_next_232:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_233
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Bruno
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_218
_cv_next_233:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_234
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Agatha
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_218
_cv_next_234:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_235
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_218
_cv_next_235:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_236
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_name_Lance
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_218
_cv_next_236:
_cv_done_218:
	GoTo _cv_famous_196_set
_cv_famous_196:
	SetVar 0x5052, 1
	Random 0x401E, 11
	CompareVarToValue 0x401E, 0
	GoToIfNe _cv_next_238
	SetVar 0x5053, 0
	GoTo _cv_done_237
_cv_next_238:
	CompareVarToValue 0x401E, 1
	GoToIfNe _cv_next_239
	SetVar 0x5053, 1
	GoTo _cv_done_237
_cv_next_239:
	CompareVarToValue 0x401E, 2
	GoToIfNe _cv_next_240
	SetVar 0x5053, 2
	GoTo _cv_done_237
_cv_next_240:
	CompareVarToValue 0x401E, 3
	GoToIfNe _cv_next_241
	SetVar 0x5053, 3
	GoTo _cv_done_237
_cv_next_241:
	CompareVarToValue 0x401E, 4
	GoToIfNe _cv_next_242
	SetVar 0x5053, 4
	GoTo _cv_done_237
_cv_next_242:
	CompareVarToValue 0x401E, 5
	GoToIfNe _cv_next_243
	SetVar 0x5053, 5
	GoTo _cv_done_237
_cv_next_243:
	CompareVarToValue 0x401E, 6
	GoToIfNe _cv_next_244
	SetVar 0x5053, 6
	GoTo _cv_done_237
_cv_next_244:
	CompareVarToValue 0x401E, 7
	GoToIfNe _cv_next_245
	SetVar 0x5053, 8
	GoTo _cv_done_237
_cv_next_245:
	CompareVarToValue 0x401E, 8
	GoToIfNe _cv_next_246
	SetVar 0x5053, 9
	GoTo _cv_done_237
_cv_next_246:
	CompareVarToValue 0x401E, 9
	GoToIfNe _cv_next_247
	SetVar 0x5053, 10
	GoTo _cv_done_237
_cv_next_247:
	CompareVarToValue 0x401E, 10
	GoToIfNe _cv_next_248
	SetVar 0x5053, 11
	GoTo _cv_done_237
_cv_next_248:
_cv_done_237:
_cv_famous_196_set:
	CompareVarToValue 0x5053, 0
	GoToIfNe _cv_next_251
	SetVar 0x4020, SPRITE_GSLEADER14
	SetVar 0x401E, 0
	CompareVarToValue 0x5052, 3
	GoToIfNe _cv_plus_249_0
	SetVar 0x401E, 3
_cv_plus_249_0:
	CanvasCandidate 15, 1150, 13, 0x401E
	GoTo _cv_done_250
_cv_next_251:
	CompareVarToValue 0x5053, 1
	GoToIfNe _cv_next_252
	SetVar 0x4020, SPRITE_GSLEADER11
	SetVar 0x401E, 0
	CompareVarToValue 0x5052, 3
	GoToIfNe _cv_plus_249_1
	SetVar 0x401E, 3
_cv_plus_249_1:
	CanvasCandidate 15, 1151, 20, 0x401E
	GoTo _cv_done_250
_cv_next_252:
	CompareVarToValue 0x5053, 2
	GoToIfNe _cv_next_253
	SetVar 0x4020, SPRITE_GSLEADER9
	SetVar 0x401E, 0
	CompareVarToValue 0x5052, 3
	GoToIfNe _cv_plus_249_2
	SetVar 0x401E, 3
_cv_plus_249_2:
	CanvasCandidate 15, 1152, 21, 0x401E
	GoTo _cv_done_250
_cv_next_253:
	CompareVarToValue 0x5053, 3
	GoToIfNe _cv_next_254
	SetVar 0x4020, SPRITE_GSLEADER12
	SetVar 0x401E, 0
	CompareVarToValue 0x5052, 3
	GoToIfNe _cv_plus_249_3
	SetVar 0x401E, 3
_cv_plus_249_3:
	CanvasCandidate 15, 1153, 27, 0x401E
	GoTo _cv_done_250
_cv_next_254:
	CompareVarToValue 0x5053, 4
	GoToIfNe _cv_next_255
	SetVar 0x4020, SPRITE_GSBIGFOUR2
	SetVar 0x401E, 0
	CompareVarToValue 0x5052, 3
	GoToIfNe _cv_plus_249_4
	SetVar 0x401E, 3
_cv_plus_249_4:
	CanvasCandidate 15, 1154, 39, 0x401E
	GoTo _cv_done_250
_cv_next_255:
	CompareVarToValue 0x5053, 5
	GoToIfNe _cv_next_256
	SetVar 0x4020, SPRITE_GSLEADER10
	SetVar 0x401E, 0
	CompareVarToValue 0x5052, 3
	GoToIfNe _cv_plus_249_5
	SetVar 0x401E, 3
_cv_plus_249_5:
	CanvasCandidate 15, 1156, 39, 0x401E
	GoTo _cv_done_250
_cv_next_256:
	CompareVarToValue 0x5053, 6
	GoToIfNe _cv_next_257
	SetVar 0x4020, SPRITE_GSLEADER15
	SetVar 0x401E, 0
	CompareVarToValue 0x5052, 3
	GoToIfNe _cv_plus_249_6
	SetVar 0x401E, 3
_cv_plus_249_6:
	CanvasCandidate 15, 1155, 43, 0x401E
	GoTo _cv_done_250
_cv_next_257:
	CompareVarToValue 0x5053, 8
	GoToIfNe _cv_next_258
	SetVar 0x4020, SPRITE_GSBIGFOUR4
	SetVar 0x401E, 0
	CompareVarToValue 0x5052, 3
	GoToIfNe _cv_plus_249_8
	SetVar 0x401E, 3
_cv_plus_249_8:
	CanvasCandidate 15, 1146, 53, 0x401E
	GoTo _cv_done_250
_cv_next_258:
	CompareVarToValue 0x5053, 9
	GoToIfNe _cv_next_259
	SetVar 0x4020, SPRITE_GSBIGFOUR3
	SetVar 0x401E, 0
	CompareVarToValue 0x5052, 3
	GoToIfNe _cv_plus_249_9
	SetVar 0x401E, 3
_cv_plus_249_9:
	CanvasCandidate 15, 1147, 53, 0x401E
	GoTo _cv_done_250
_cv_next_259:
	CompareVarToValue 0x5053, 10
	GoToIfNe _cv_next_260
	SetVar 0x4020, SPRITE_GSOLDWOMAN1
	SetVar 0x401E, 0
	CompareVarToValue 0x5052, 3
	GoToIfNe _cv_plus_249_10
	SetVar 0x401E, 3
_cv_plus_249_10:
	CanvasCandidate 15, 1148, 55, 0x401E
	GoTo _cv_done_250
_cv_next_260:
	CompareVarToValue 0x5053, 11
	GoToIfNe _cv_next_261
	SetVar 0x4020, SPRITE_WATARU
	SetVar 0x401E, 0
	CompareVarToValue 0x5052, 3
	GoToIfNe _cv_plus_249_11
	SetVar 0x401E, 3
_cv_plus_249_11:
	CanvasCandidate 15, 1149, 56, 0x401E
	GoTo _cv_done_250
_cv_next_261:
_cv_done_250:
	CopyVar VAR_SPECIAL_RESULT, 0x5052
	GoTo _cv_next_198
_cv_trainer_197:
	SetVar 0x5052, 0
	CanvasCandidate 14
	CopyVar 0x5054, VAR_SPECIAL_RESULT
	CopyVar 0x5055, 0x8005
	CompareVarToValue 0x5054, 0
	GoToIfNe _cv_next_263
	SetVar 0x4020, SPRITE_GSMAN3
	GoTo _cv_done_262
_cv_next_263:
	CompareVarToValue 0x5054, 1
	GoToIfNe _cv_next_264
	SetVar 0x4020, SPRITE_GSWOMAN3
	GoTo _cv_done_262
_cv_next_264:
	CompareVarToValue 0x5054, 2
	GoToIfNe _cv_next_265
	SetVar 0x4020, SPRITE_GSMAN3
	GoTo _cv_done_262
_cv_next_265:
	CompareVarToValue 0x5054, 3
	GoToIfNe _cv_next_266
	SetVar 0x4020, SPRITE_GSWOMAN3
	GoTo _cv_done_262
_cv_next_266:
	CompareVarToValue 0x5054, 4
	GoToIfNe _cv_next_267
	SetVar 0x4020, SPRITE_GSFIGHTER
	GoTo _cv_done_262
_cv_next_267:
	CompareVarToValue 0x5054, 5
	GoToIfNe _cv_next_268
	SetVar 0x4020, SPRITE_GSGENTLEMAN
	GoTo _cv_done_262
_cv_next_268:
	CompareVarToValue 0x5054, 6
	GoToIfNe _cv_next_269
	SetVar 0x4020, SPRITE_MOUNT_2
	GoTo _cv_done_262
_cv_next_269:
	CompareVarToValue 0x5054, 7
	GoToIfNe _cv_next_270
	SetVar 0x4020, SPRITE_GSMAN2
	GoTo _cv_done_262
_cv_next_270:
	CompareVarToValue 0x5054, 8
	GoToIfNe _cv_next_271
	SetVar 0x4020, SPRITE_BADMAN
	GoTo _cv_done_262
_cv_next_271:
	CompareVarToValue 0x5054, 9
	GoToIfNe _cv_next_272
	SetVar 0x4020, SPRITE_WORKMAN
	GoTo _cv_done_262
_cv_next_272:
	CompareVarToValue 0x5054, 10
	GoToIfNe _cv_next_273
	SetVar 0x4020, SPRITE_GSASSISTANTM
	GoTo _cv_done_262
_cv_next_273:
	CompareVarToValue 0x5054, 11
	GoToIfNe _cv_next_274
	SetVar 0x4020, SPRITE_MANIA
	GoTo _cv_done_262
_cv_next_274:
	CompareVarToValue 0x5054, 12
	GoToIfNe _cv_next_275
	SetVar 0x4020, SPRITE_CAMPBOY_2
	GoTo _cv_done_262
_cv_next_275:
	CompareVarToValue 0x5054, 13
	GoToIfNe _cv_next_276
	SetVar 0x4020, SPRITE_SEAMAN_2
	GoTo _cv_done_262
_cv_next_276:
	CompareVarToValue 0x5054, 14
	GoToIfNe _cv_next_277
	SetVar 0x4020, SPRITE_FISHING_2
	GoTo _cv_done_262
_cv_next_277:
	CompareVarToValue 0x5054, 15
	GoToIfNe _cv_next_278
	SetVar 0x4020, SPRITE_GSBOY2
	GoTo _cv_done_262
_cv_next_278:
	CompareVarToValue 0x5054, 16
	GoToIfNe _cv_next_279
	SetVar 0x4020, SPRITE_WOMAN2
	GoTo _cv_done_262
_cv_next_279:
	CompareVarToValue 0x5054, 17
	GoToIfNe _cv_next_280
	SetVar 0x4020, SPRITE_GSGIRL2
	GoTo _cv_done_262
_cv_next_280:
	CompareVarToValue 0x5054, 18
	GoToIfNe _cv_next_281
	SetVar 0x4020, SPRITE_PICNICGIRL_2
	GoTo _cv_done_262
_cv_next_281:
	CompareVarToValue 0x5054, 19
	GoToIfNe _cv_next_282
	SetVar 0x4020, SPRITE_GSGIRL3
	GoTo _cv_done_262
_cv_next_282:
	CompareVarToValue 0x5054, 20
	GoToIfNe _cv_next_283
	SetVar 0x4020, SPRITE_GSSWIMMERW
	GoTo _cv_done_262
_cv_next_283:
	CompareVarToValue 0x5054, 21
	GoToIfNe _cv_next_284
	SetVar 0x4020, SPRITE_GSSWIMMERM
	GoTo _cv_done_262
_cv_next_284:
_cv_done_262:
	Random 0x5056, 10
	Random 0x5057, 6
	Random 0x5058, 4
	Random 0x5059, 4
	SetVar 0x505A, 0
	Random 0x401E, 3
	CompareVarToValue 0x401E, 0
	GoToIfEq _cv_trainer_197_single
	SetVar 0x505A, 1
_cv_trainer_197_single:
	SetVar VAR_SPECIAL_RESULT, 0
_cv_next_198:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq GymChallenge_EventScript_AnnounceFamous
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	CallIfEq GymChallenge_EventScript_AnnounceTownsfolk
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	CallIfEq GymChallenge_EventScript_AnnounceTrainer
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	CallIfEq GymSwitch_EventScript_AnnounceMentor
	CanvasCloseMsg
	ClearFlag 0x2017
	GoToIfUnset 0x2017, _cv_show_285
	ClearFlag 0x2017
	ShowPerson 4
	SetFlag 0x2017
	GoTo _cv_shown_286
_cv_show_285:
	ShowPerson 4
_cv_shown_286:
	SetVar 0x8004, 0
	CompareVarToValue 0x8004, 1
	GoToIfEq _cv_cwalk_287
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	CanvasCandidate 4, 1
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_cwalk_288
	CanvasCandidate 17, 4, 0x8005, 0x8006
	GoTo _cv_cwalk_288
_cv_cwalk_287:
	CanvasCandidate 6
_cv_cwalk_288:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	CallIfEq GymChallenge_EventScript_ChallengerJumpsIn
	CompareVarToValue 0x8004, 1
	GoToIfEq _cv_capply_289
	CanvasCandidate 5, 4, 0
	WaitMovement
	CanvasCandidate 2, 4
	GoTo _cv_capply_290
_cv_capply_289:
	CanvasCandidate 5, 4, 1
	WaitMovement
_cv_capply_290:
	CompareVarToValue 0x5052, 0
	GoToIfEq _cv_gline_292
	CompareVarToValue 0x5052, 3
	GoToIfEq _cv_gline_293
	CompareVarToValue 0x5053, 0
	GoToIfNe _cv_next_295
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_intro_0
	WaitButton
	GoTo _cv_done_294
_cv_next_295:
	CompareVarToValue 0x5053, 1
	GoToIfNe _cv_next_296
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_intro_1
	WaitButton
	GoTo _cv_done_294
_cv_next_296:
	CompareVarToValue 0x5053, 2
	GoToIfNe _cv_next_297
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_intro_2
	WaitButton
	GoTo _cv_done_294
_cv_next_297:
	CompareVarToValue 0x5053, 3
	GoToIfNe _cv_next_298
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_intro_3
	WaitButton
	GoTo _cv_done_294
_cv_next_298:
	CompareVarToValue 0x5053, 4
	GoToIfNe _cv_next_299
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_intro_4
	WaitButton
	GoTo _cv_done_294
_cv_next_299:
	CompareVarToValue 0x5053, 5
	GoToIfNe _cv_next_300
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_intro_5
	WaitButton
	GoTo _cv_done_294
_cv_next_300:
	CompareVarToValue 0x5053, 6
	GoToIfNe _cv_next_301
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_intro_6
	WaitButton
	GoTo _cv_done_294
_cv_next_301:
	CompareVarToValue 0x5053, 8
	GoToIfNe _cv_next_302
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_intro_8
	WaitButton
	GoTo _cv_done_294
_cv_next_302:
	CompareVarToValue 0x5053, 9
	GoToIfNe _cv_next_303
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_intro_9
	WaitButton
	GoTo _cv_done_294
_cv_next_303:
	CompareVarToValue 0x5053, 10
	GoToIfNe _cv_next_304
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_intro_10
	WaitButton
	GoTo _cv_done_294
_cv_next_304:
	CompareVarToValue 0x5053, 11
	GoToIfNe _cv_next_305
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_intro_11
	WaitButton
	GoTo _cv_done_294
_cv_next_305:
_cv_done_294:
	GoTo _cv_gline_291
_cv_gline_293:
	BufferTypeName 1, 0x5019
	CopyVar 0x401E, 0x504D
	BufferInt 2, 0x401E
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_boss_intro
	WaitButton
	GoTo _cv_gline_291
_cv_gline_292:
	CompareVarToValue 0x5056, 0
	GoToIfNe _cv_next_306
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_gym_intro_0
	WaitButton
	GoTo _cv_gline_291
_cv_next_306:
	CompareVarToValue 0x5056, 1
	GoToIfNe _cv_next_307
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_gym_intro_1
	WaitButton
	GoTo _cv_gline_291
_cv_next_307:
	CompareVarToValue 0x5056, 2
	GoToIfNe _cv_next_308
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_gym_intro_2
	WaitButton
	GoTo _cv_gline_291
_cv_next_308:
	CompareVarToValue 0x5056, 3
	GoToIfNe _cv_next_309
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_gym_intro_3
	WaitButton
	GoTo _cv_gline_291
_cv_next_309:
	CompareVarToValue 0x5056, 4
	GoToIfNe _cv_next_310
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_gym_intro_4
	WaitButton
	GoTo _cv_gline_291
_cv_next_310:
	CompareVarToValue 0x5056, 5
	GoToIfNe _cv_next_311
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_gym_intro_5
	WaitButton
	GoTo _cv_gline_291
_cv_next_311:
	CompareVarToValue 0x5056, 6
	GoToIfNe _cv_next_312
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_gym_intro_6
	WaitButton
	GoTo _cv_gline_291
_cv_next_312:
	CompareVarToValue 0x5056, 7
	GoToIfNe _cv_next_313
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_gym_intro_7
	WaitButton
	GoTo _cv_gline_291
_cv_next_313:
	CompareVarToValue 0x5056, 8
	GoToIfNe _cv_next_314
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_gym_intro_8
	WaitButton
	GoTo _cv_gline_291
_cv_next_314:
	CompareVarToValue 0x5056, 9
	GoToIfNe _cv_next_315
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_gym_intro_9
	WaitButton
	GoTo _cv_gline_291
_cv_next_315:
_cv_gline_291:
	CanvasCloseMsg
	CanvasCloseMsg
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_gbattle_317
	CompareVarToValue 0x505A, 0
	GoToIfNe _cv_gbattle_318
	CompareVarToValue 0x5057, 0
	GoToIfNe _cv_gbattle_318
	ClearTrainerFlag 1477
	TrainerBattle 1477, 0, 1, 0
	GoTo _cv_gbattle_316
_cv_gbattle_318:
	CompareVarToValue 0x505A, 0
	GoToIfNe _cv_gbattle_319
	CompareVarToValue 0x5057, 1
	GoToIfNe _cv_gbattle_319
	ClearTrainerFlag 1478
	TrainerBattle 1478, 0, 1, 0
	GoTo _cv_gbattle_316
_cv_gbattle_319:
	CompareVarToValue 0x505A, 0
	GoToIfNe _cv_gbattle_320
	CompareVarToValue 0x5057, 2
	GoToIfNe _cv_gbattle_320
	ClearTrainerFlag 1479
	TrainerBattle 1479, 0, 1, 0
	GoTo _cv_gbattle_316
_cv_gbattle_320:
	CompareVarToValue 0x505A, 0
	GoToIfNe _cv_gbattle_321
	CompareVarToValue 0x5057, 3
	GoToIfNe _cv_gbattle_321
	ClearTrainerFlag 1480
	TrainerBattle 1480, 0, 1, 0
	GoTo _cv_gbattle_316
_cv_gbattle_321:
	CompareVarToValue 0x505A, 0
	GoToIfNe _cv_gbattle_322
	CompareVarToValue 0x5057, 4
	GoToIfNe _cv_gbattle_322
	ClearTrainerFlag 1481
	TrainerBattle 1481, 0, 1, 0
	GoTo _cv_gbattle_316
_cv_gbattle_322:
	CompareVarToValue 0x505A, 0
	GoToIfNe _cv_gbattle_323
	CompareVarToValue 0x5057, 5
	GoToIfNe _cv_gbattle_323
	ClearTrainerFlag 1482
	TrainerBattle 1482, 0, 1, 0
	GoTo _cv_gbattle_316
_cv_gbattle_323:
	CompareVarToValue 0x505A, 1
	GoToIfNe _cv_gbattle_324
	CompareVarToValue 0x5057, 0
	GoToIfNe _cv_gbattle_324
	ClearTrainerFlag 1483
	TrainerBattle 1483, 1483, 1, 0
	GoTo _cv_gbattle_316
_cv_gbattle_324:
	CompareVarToValue 0x505A, 1
	GoToIfNe _cv_gbattle_325
	CompareVarToValue 0x5057, 1
	GoToIfNe _cv_gbattle_325
	ClearTrainerFlag 1484
	TrainerBattle 1484, 1484, 1, 0
	GoTo _cv_gbattle_316
_cv_gbattle_325:
	CompareVarToValue 0x505A, 1
	GoToIfNe _cv_gbattle_326
	CompareVarToValue 0x5057, 2
	GoToIfNe _cv_gbattle_326
	ClearTrainerFlag 1485
	TrainerBattle 1485, 1485, 1, 0
	GoTo _cv_gbattle_316
_cv_gbattle_326:
	CompareVarToValue 0x505A, 1
	GoToIfNe _cv_gbattle_327
	CompareVarToValue 0x5057, 3
	GoToIfNe _cv_gbattle_327
	ClearTrainerFlag 1486
	TrainerBattle 1486, 1486, 1, 0
	GoTo _cv_gbattle_316
_cv_gbattle_327:
	CompareVarToValue 0x505A, 1
	GoToIfNe _cv_gbattle_328
	CompareVarToValue 0x5057, 4
	GoToIfNe _cv_gbattle_328
	ClearTrainerFlag 1487
	TrainerBattle 1487, 1487, 1, 0
	GoTo _cv_gbattle_316
_cv_gbattle_328:
	CompareVarToValue 0x505A, 1
	GoToIfNe _cv_gbattle_329
	CompareVarToValue 0x5057, 5
	GoToIfNe _cv_gbattle_329
	ClearTrainerFlag 1488
	TrainerBattle 1488, 1488, 1, 0
	GoTo _cv_gbattle_316
_cv_gbattle_329:
	GoTo _cv_gbattle_316
_cv_gbattle_317:
	CompareVarToValue 0x5053, 0
	GoToIfNe _cv_next_330
	ClearTrainerFlag 1150
	TrainerBattle 1150, 0, 1, 0
	GoTo _cv_gbattle_316
_cv_next_330:
	CompareVarToValue 0x5053, 1
	GoToIfNe _cv_next_331
	ClearTrainerFlag 1151
	TrainerBattle 1151, 0, 1, 0
	GoTo _cv_gbattle_316
_cv_next_331:
	CompareVarToValue 0x5053, 2
	GoToIfNe _cv_next_332
	ClearTrainerFlag 1152
	TrainerBattle 1152, 0, 1, 0
	GoTo _cv_gbattle_316
_cv_next_332:
	CompareVarToValue 0x5053, 3
	GoToIfNe _cv_next_333
	ClearTrainerFlag 1153
	TrainerBattle 1153, 0, 1, 0
	GoTo _cv_gbattle_316
_cv_next_333:
	CompareVarToValue 0x5053, 4
	GoToIfNe _cv_next_334
	ClearTrainerFlag 1154
	TrainerBattle 1154, 1154, 1, 0
	GoTo _cv_gbattle_316
_cv_next_334:
	CompareVarToValue 0x5053, 5
	GoToIfNe _cv_next_335
	ClearTrainerFlag 1156
	TrainerBattle 1156, 1156, 1, 0
	GoTo _cv_gbattle_316
_cv_next_335:
	CompareVarToValue 0x5053, 6
	GoToIfNe _cv_next_336
	ClearTrainerFlag 1155
	TrainerBattle 1155, 0, 1, 0
	GoTo _cv_gbattle_316
_cv_next_336:
	CompareVarToValue 0x5053, 8
	GoToIfNe _cv_next_337
	ClearTrainerFlag 1146
	TrainerBattle 1146, 1146, 1, 0
	GoTo _cv_gbattle_316
_cv_next_337:
	CompareVarToValue 0x5053, 9
	GoToIfNe _cv_next_338
	ClearTrainerFlag 1147
	TrainerBattle 1147, 0, 1, 0
	GoTo _cv_gbattle_316
_cv_next_338:
	CompareVarToValue 0x5053, 10
	GoToIfNe _cv_next_339
	ClearTrainerFlag 1148
	TrainerBattle 1148, 1148, 1, 0
	GoTo _cv_gbattle_316
_cv_next_339:
	CompareVarToValue 0x5053, 11
	GoToIfNe _cv_next_340
	ClearTrainerFlag 1149
	TrainerBattle 1149, 1149, 1, 0
	GoTo _cv_gbattle_316
_cv_next_340:
_cv_gbattle_316:
	CheckBattleWon VAR_SPECIAL_RESULT
	CanvasCandidate 12
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymChallenge_EventScript_Won
	GoTo GymChallenge_EventScript_Lost
	End
	
GymPractice_EventScript_Trainer:
	LockAll
	FacePlayer
	// TODO(gba) special GymChallenge_BufferPracticeTrainer
	GoTo _cv_stop
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymPractice_Text_Offer
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_341
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_342
_cv_yes_341:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_342:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymPractice_EventScript_NotNow
	// TODO(gba) special GymChallenge_GeneratePractice
	GoTo _cv_stop
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymPractice_Text_Go
	WaitButton
	CanvasCloseMsg
	ClearTrainerFlag 1442
	SetFlag 0x2036
	CanvasCloseMsg
	TrainerBattle 1442, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_344
	WhiteOut
	End
_cv_won_344:
	SetTrainerFlag 1442
	ClearFlag 0x2036
	CanvasCandidate 12
	HealParty
	GetStaticEncounterOutcome VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfNe _cv_outcome_345
	SetVar VAR_SPECIAL_RESULT, 7
	GoTo _cv_outcome_346
_cv_outcome_345:
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfNe _cv_outcome_346
	SetVar VAR_SPECIAL_RESULT, 4
_cv_outcome_346:
	// TODO(gba) special GymChallenge_BufferPracticeTrainer
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymPractice_EventScript_Won
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymPractice_Text_Lost
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymLegend_EventScript_Caught:
	SetFlag 0x2037
	SetVar 0x5014, 3
	GoTo GymLegend_EventScript_RivalCaught
	End
	
Gauntlet_EventScript_PalmPilot:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Pilot
	WaitButton
	CompareVarToValue 0x501C, 0
	GoToIfEq Gauntlet_EventScript_PilotMenu
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_WithdrawAsk
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_347
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_348
_cv_yes_347:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_348:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Gauntlet_EventScript_Withdraw
	GoTo Gauntlet_EventScript_PilotMenu
	
Gauntlet_EventScript_AllBeaten:
	GoToIfSet 0x2038, Gauntlet_EventScript_BillAgain
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_ReadyToMeet
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_349
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_350
_cv_yes_349:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_350:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Gauntlet_EventScript_NotYet
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Reveal1
	WaitButton
	CanvasCloseMsg
	Wait 30, VAR_SPECIAL_RESULT
	FadeScreen 6, 1, 0, RGB_WHITE
	WaitFade
	// TODO(gba) special Gauntlet_RevealBill
	GoTo _cv_stop
	HidePerson 17
	SetFlag 0x2035
	GoToIfUnset 0x2035, _cv_show_351
	ClearFlag 0x2035
	ShowPerson 17
	SetFlag 0x2035
	GoTo _cv_shown_352
_cv_show_351:
	ShowPerson 17
_cv_shown_352:
	PlaySE SEQ_SE_DP_SELECT
	FadeScreen 6, 1, 1, RGB_WHITE
	WaitFade
	WaitSE SEQ_SE_DP_SELECT
	PlayBGM SEQ_GS_D_AJITO
	FacePlayer
	WaitMovement
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Reveal2
	WaitButton
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Reveal3
	WaitButton
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Reveal4
	WaitButton
	GoTo Gauntlet_EventScript_BillBattle
	
Tourney_EventScript_Menu:
	// TODO(gba) special Tourney_GetStatus
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Tourney_EventScript_MenuActive
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfEq Tourney_EventScript_MenuSimBill
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Tourney_EventScript_MenuFirst
	Call Tourney_EventScript_SayAsk
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptEnter, 0
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptLast, 1
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptNotNow, 2
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_354
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_354:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Tourney_EventScript_Enter
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Tourney_EventScript_LastResults
	GoTo Tourney_EventScript_NotNow
	
GymChallenge_EventScript_Statue:
	LockAll
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x2008, _cv_open_355
	SetVar VAR_SPECIAL_RESULT, 1
_cv_open_355:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymChallenge_EventScript_StatueNoLeader
	BufferInt 0, 0x504D
	BufferInt 1, 0x504E
	BufferInt 2, 0x504F
	BufferInt 3, 0x5050
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_StatueLeader
	WaitButton
	CopyVar VAR_SPECIAL_RESULT, 0x505B
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymChallenge_EventScript_StatueUnbeaten
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_357
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_normal
	GoTo _cv_done_356
_cv_next_357:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_358
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_fighting
	GoTo _cv_done_356
_cv_next_358:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_359
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_flying
	GoTo _cv_done_356
_cv_next_359:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_360
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_poison
	GoTo _cv_done_356
_cv_next_360:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_361
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_ground
	GoTo _cv_done_356
_cv_next_361:
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_362
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_rock
	GoTo _cv_done_356
_cv_next_362:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_363
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_bug
	GoTo _cv_done_356
_cv_next_363:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_364
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_ghost
	GoTo _cv_done_356
_cv_next_364:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_365
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_steel
	GoTo _cv_done_356
_cv_next_365:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_366
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_fire
	GoTo _cv_done_356
_cv_next_366:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_367
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_water
	GoTo _cv_done_356
_cv_next_367:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_368
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_grass
	GoTo _cv_done_356
_cv_next_368:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_369
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_electric
	GoTo _cv_done_356
_cv_next_369:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_370
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_psychic
	GoTo _cv_done_356
_cv_next_370:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_371
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_ice
	GoTo _cv_done_356
_cv_next_371:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_372
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_dragon
	GoTo _cv_done_356
_cv_next_372:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_373
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_dark
	GoTo _cv_done_356
_cv_next_373:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_374
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_fairy
	GoTo _cv_done_356
_cv_next_374:
_cv_done_356:
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_StatueVictors
	WaitButton
	CopyVar VAR_SPECIAL_RESULT, 0x505B
	CompareVarToValue 0x505B, 1
	GoToIfLt _cv_victors_375
	CompareVarToValue 0x505C, 100
	GoToIfGe _cv_victor_376
	CompareVarToValue 0x505C, 0
	GoToIfNe _cv_next_379
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_0
	GoTo _cv_done_378
_cv_next_379:
	CompareVarToValue 0x505C, 1
	GoToIfNe _cv_next_380
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_1
	GoTo _cv_done_378
_cv_next_380:
	CompareVarToValue 0x505C, 2
	GoToIfNe _cv_next_381
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_2
	GoTo _cv_done_378
_cv_next_381:
	CompareVarToValue 0x505C, 3
	GoToIfNe _cv_next_382
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_3
	GoTo _cv_done_378
_cv_next_382:
	CompareVarToValue 0x505C, 4
	GoToIfNe _cv_next_383
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_4
	GoTo _cv_done_378
_cv_next_383:
	CompareVarToValue 0x505C, 5
	GoToIfNe _cv_next_384
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_5
	GoTo _cv_done_378
_cv_next_384:
	CompareVarToValue 0x505C, 6
	GoToIfNe _cv_next_385
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_6
	GoTo _cv_done_378
_cv_next_385:
	CompareVarToValue 0x505C, 7
	GoToIfNe _cv_next_386
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_7
	GoTo _cv_done_378
_cv_next_386:
	CompareVarToValue 0x505C, 8
	GoToIfNe _cv_next_387
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_8
	GoTo _cv_done_378
_cv_next_387:
	CompareVarToValue 0x505C, 9
	GoToIfNe _cv_next_388
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_9
	GoTo _cv_done_378
_cv_next_388:
	CompareVarToValue 0x505C, 10
	GoToIfNe _cv_next_389
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_10
	GoTo _cv_done_378
_cv_next_389:
	CompareVarToValue 0x505C, 11
	GoToIfNe _cv_next_390
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_11
	GoTo _cv_done_378
_cv_next_390:
	CompareVarToValue 0x505C, 12
	GoToIfNe _cv_next_391
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_12
	GoTo _cv_done_378
_cv_next_391:
	CompareVarToValue 0x505C, 13
	GoToIfNe _cv_next_392
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_13
	GoTo _cv_done_378
_cv_next_392:
	CompareVarToValue 0x505C, 14
	GoToIfNe _cv_next_393
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_14
	GoTo _cv_done_378
_cv_next_393:
	CompareVarToValue 0x505C, 15
	GoToIfNe _cv_next_394
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_15
	GoTo _cv_done_378
_cv_next_394:
	CompareVarToValue 0x505C, 16
	GoToIfNe _cv_next_395
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_16
	GoTo _cv_done_378
_cv_next_395:
	CompareVarToValue 0x505C, 17
	GoToIfNe _cv_next_396
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_17
	GoTo _cv_done_378
_cv_next_396:
	CompareVarToValue 0x505C, 18
	GoToIfNe _cv_next_397
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_18
	GoTo _cv_done_378
_cv_next_397:
	CompareVarToValue 0x505C, 19
	GoToIfNe _cv_next_398
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_19
	GoTo _cv_done_378
_cv_next_398:
	CompareVarToValue 0x505C, 20
	GoToIfNe _cv_next_399
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_20
	GoTo _cv_done_378
_cv_next_399:
	CompareVarToValue 0x505C, 21
	GoToIfNe _cv_next_400
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_21
	GoTo _cv_done_378
_cv_next_400:
_cv_done_378:
	CanvasCandidate 16, 1, 0x505D
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_statue_victor
	WaitButton
	GoTo _cv_victor_377
_cv_victor_376:
	CompareVarToValue 0x505C, 100
	GoToIfNe _cv_next_402
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_0
	GoTo _cv_done_401
_cv_next_402:
	CompareVarToValue 0x505C, 101
	GoToIfNe _cv_next_403
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_1
	GoTo _cv_done_401
_cv_next_403:
	CompareVarToValue 0x505C, 102
	GoToIfNe _cv_next_404
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_2
	GoTo _cv_done_401
_cv_next_404:
	CompareVarToValue 0x505C, 103
	GoToIfNe _cv_next_405
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_3
	GoTo _cv_done_401
_cv_next_405:
	CompareVarToValue 0x505C, 104
	GoToIfNe _cv_next_406
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_4
	GoTo _cv_done_401
_cv_next_406:
	CompareVarToValue 0x505C, 105
	GoToIfNe _cv_next_407
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_5
	GoTo _cv_done_401
_cv_next_407:
	CompareVarToValue 0x505C, 106
	GoToIfNe _cv_next_408
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_6
	GoTo _cv_done_401
_cv_next_408:
	CompareVarToValue 0x505C, 108
	GoToIfNe _cv_next_409
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_8
	GoTo _cv_done_401
_cv_next_409:
	CompareVarToValue 0x505C, 109
	GoToIfNe _cv_next_410
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_9
	GoTo _cv_done_401
_cv_next_410:
	CompareVarToValue 0x505C, 110
	GoToIfNe _cv_next_411
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_10
	GoTo _cv_done_401
_cv_next_411:
	CompareVarToValue 0x505C, 111
	GoToIfNe _cv_next_412
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_11
	GoTo _cv_done_401
_cv_next_412:
_cv_done_401:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_statue_famous
	WaitButton
_cv_victor_377:
	CompareVarToValue 0x505B, 2
	GoToIfLt _cv_victors_375
	CompareVarToValue 0x505E, 100
	GoToIfGe _cv_victor_413
	CompareVarToValue 0x505E, 0
	GoToIfNe _cv_next_416
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_0
	GoTo _cv_done_415
_cv_next_416:
	CompareVarToValue 0x505E, 1
	GoToIfNe _cv_next_417
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_1
	GoTo _cv_done_415
_cv_next_417:
	CompareVarToValue 0x505E, 2
	GoToIfNe _cv_next_418
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_2
	GoTo _cv_done_415
_cv_next_418:
	CompareVarToValue 0x505E, 3
	GoToIfNe _cv_next_419
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_3
	GoTo _cv_done_415
_cv_next_419:
	CompareVarToValue 0x505E, 4
	GoToIfNe _cv_next_420
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_4
	GoTo _cv_done_415
_cv_next_420:
	CompareVarToValue 0x505E, 5
	GoToIfNe _cv_next_421
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_5
	GoTo _cv_done_415
_cv_next_421:
	CompareVarToValue 0x505E, 6
	GoToIfNe _cv_next_422
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_6
	GoTo _cv_done_415
_cv_next_422:
	CompareVarToValue 0x505E, 7
	GoToIfNe _cv_next_423
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_7
	GoTo _cv_done_415
_cv_next_423:
	CompareVarToValue 0x505E, 8
	GoToIfNe _cv_next_424
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_8
	GoTo _cv_done_415
_cv_next_424:
	CompareVarToValue 0x505E, 9
	GoToIfNe _cv_next_425
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_9
	GoTo _cv_done_415
_cv_next_425:
	CompareVarToValue 0x505E, 10
	GoToIfNe _cv_next_426
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_10
	GoTo _cv_done_415
_cv_next_426:
	CompareVarToValue 0x505E, 11
	GoToIfNe _cv_next_427
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_11
	GoTo _cv_done_415
_cv_next_427:
	CompareVarToValue 0x505E, 12
	GoToIfNe _cv_next_428
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_12
	GoTo _cv_done_415
_cv_next_428:
	CompareVarToValue 0x505E, 13
	GoToIfNe _cv_next_429
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_13
	GoTo _cv_done_415
_cv_next_429:
	CompareVarToValue 0x505E, 14
	GoToIfNe _cv_next_430
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_14
	GoTo _cv_done_415
_cv_next_430:
	CompareVarToValue 0x505E, 15
	GoToIfNe _cv_next_431
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_15
	GoTo _cv_done_415
_cv_next_431:
	CompareVarToValue 0x505E, 16
	GoToIfNe _cv_next_432
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_16
	GoTo _cv_done_415
_cv_next_432:
	CompareVarToValue 0x505E, 17
	GoToIfNe _cv_next_433
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_17
	GoTo _cv_done_415
_cv_next_433:
	CompareVarToValue 0x505E, 18
	GoToIfNe _cv_next_434
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_18
	GoTo _cv_done_415
_cv_next_434:
	CompareVarToValue 0x505E, 19
	GoToIfNe _cv_next_435
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_19
	GoTo _cv_done_415
_cv_next_435:
	CompareVarToValue 0x505E, 20
	GoToIfNe _cv_next_436
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_20
	GoTo _cv_done_415
_cv_next_436:
	CompareVarToValue 0x505E, 21
	GoToIfNe _cv_next_437
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_21
	GoTo _cv_done_415
_cv_next_437:
_cv_done_415:
	CanvasCandidate 16, 1, 0x505F
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_statue_victor
	WaitButton
	GoTo _cv_victor_414
_cv_victor_413:
	CompareVarToValue 0x505E, 100
	GoToIfNe _cv_next_439
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_0
	GoTo _cv_done_438
_cv_next_439:
	CompareVarToValue 0x505E, 101
	GoToIfNe _cv_next_440
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_1
	GoTo _cv_done_438
_cv_next_440:
	CompareVarToValue 0x505E, 102
	GoToIfNe _cv_next_441
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_2
	GoTo _cv_done_438
_cv_next_441:
	CompareVarToValue 0x505E, 103
	GoToIfNe _cv_next_442
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_3
	GoTo _cv_done_438
_cv_next_442:
	CompareVarToValue 0x505E, 104
	GoToIfNe _cv_next_443
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_4
	GoTo _cv_done_438
_cv_next_443:
	CompareVarToValue 0x505E, 105
	GoToIfNe _cv_next_444
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_5
	GoTo _cv_done_438
_cv_next_444:
	CompareVarToValue 0x505E, 106
	GoToIfNe _cv_next_445
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_6
	GoTo _cv_done_438
_cv_next_445:
	CompareVarToValue 0x505E, 108
	GoToIfNe _cv_next_446
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_8
	GoTo _cv_done_438
_cv_next_446:
	CompareVarToValue 0x505E, 109
	GoToIfNe _cv_next_447
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_9
	GoTo _cv_done_438
_cv_next_447:
	CompareVarToValue 0x505E, 110
	GoToIfNe _cv_next_448
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_10
	GoTo _cv_done_438
_cv_next_448:
	CompareVarToValue 0x505E, 111
	GoToIfNe _cv_next_449
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_11
	GoTo _cv_done_438
_cv_next_449:
_cv_done_438:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_statue_famous
	WaitButton
_cv_victor_414:
	CompareVarToValue 0x505B, 3
	GoToIfLt _cv_victors_375
	CompareVarToValue 0x5060, 100
	GoToIfGe _cv_victor_450
	CompareVarToValue 0x5060, 0
	GoToIfNe _cv_next_453
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_0
	GoTo _cv_done_452
_cv_next_453:
	CompareVarToValue 0x5060, 1
	GoToIfNe _cv_next_454
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_1
	GoTo _cv_done_452
_cv_next_454:
	CompareVarToValue 0x5060, 2
	GoToIfNe _cv_next_455
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_2
	GoTo _cv_done_452
_cv_next_455:
	CompareVarToValue 0x5060, 3
	GoToIfNe _cv_next_456
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_3
	GoTo _cv_done_452
_cv_next_456:
	CompareVarToValue 0x5060, 4
	GoToIfNe _cv_next_457
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_4
	GoTo _cv_done_452
_cv_next_457:
	CompareVarToValue 0x5060, 5
	GoToIfNe _cv_next_458
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_5
	GoTo _cv_done_452
_cv_next_458:
	CompareVarToValue 0x5060, 6
	GoToIfNe _cv_next_459
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_6
	GoTo _cv_done_452
_cv_next_459:
	CompareVarToValue 0x5060, 7
	GoToIfNe _cv_next_460
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_7
	GoTo _cv_done_452
_cv_next_460:
	CompareVarToValue 0x5060, 8
	GoToIfNe _cv_next_461
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_8
	GoTo _cv_done_452
_cv_next_461:
	CompareVarToValue 0x5060, 9
	GoToIfNe _cv_next_462
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_9
	GoTo _cv_done_452
_cv_next_462:
	CompareVarToValue 0x5060, 10
	GoToIfNe _cv_next_463
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_10
	GoTo _cv_done_452
_cv_next_463:
	CompareVarToValue 0x5060, 11
	GoToIfNe _cv_next_464
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_11
	GoTo _cv_done_452
_cv_next_464:
	CompareVarToValue 0x5060, 12
	GoToIfNe _cv_next_465
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_12
	GoTo _cv_done_452
_cv_next_465:
	CompareVarToValue 0x5060, 13
	GoToIfNe _cv_next_466
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_13
	GoTo _cv_done_452
_cv_next_466:
	CompareVarToValue 0x5060, 14
	GoToIfNe _cv_next_467
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_14
	GoTo _cv_done_452
_cv_next_467:
	CompareVarToValue 0x5060, 15
	GoToIfNe _cv_next_468
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_15
	GoTo _cv_done_452
_cv_next_468:
	CompareVarToValue 0x5060, 16
	GoToIfNe _cv_next_469
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_16
	GoTo _cv_done_452
_cv_next_469:
	CompareVarToValue 0x5060, 17
	GoToIfNe _cv_next_470
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_17
	GoTo _cv_done_452
_cv_next_470:
	CompareVarToValue 0x5060, 18
	GoToIfNe _cv_next_471
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_18
	GoTo _cv_done_452
_cv_next_471:
	CompareVarToValue 0x5060, 19
	GoToIfNe _cv_next_472
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_19
	GoTo _cv_done_452
_cv_next_472:
	CompareVarToValue 0x5060, 20
	GoToIfNe _cv_next_473
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_20
	GoTo _cv_done_452
_cv_next_473:
	CompareVarToValue 0x5060, 21
	GoToIfNe _cv_next_474
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_21
	GoTo _cv_done_452
_cv_next_474:
_cv_done_452:
	CanvasCandidate 16, 1, 0x5061
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_statue_victor
	WaitButton
	GoTo _cv_victor_451
_cv_victor_450:
	CompareVarToValue 0x5060, 100
	GoToIfNe _cv_next_476
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_0
	GoTo _cv_done_475
_cv_next_476:
	CompareVarToValue 0x5060, 101
	GoToIfNe _cv_next_477
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_1
	GoTo _cv_done_475
_cv_next_477:
	CompareVarToValue 0x5060, 102
	GoToIfNe _cv_next_478
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_2
	GoTo _cv_done_475
_cv_next_478:
	CompareVarToValue 0x5060, 103
	GoToIfNe _cv_next_479
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_3
	GoTo _cv_done_475
_cv_next_479:
	CompareVarToValue 0x5060, 104
	GoToIfNe _cv_next_480
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_4
	GoTo _cv_done_475
_cv_next_480:
	CompareVarToValue 0x5060, 105
	GoToIfNe _cv_next_481
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_5
	GoTo _cv_done_475
_cv_next_481:
	CompareVarToValue 0x5060, 106
	GoToIfNe _cv_next_482
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_6
	GoTo _cv_done_475
_cv_next_482:
	CompareVarToValue 0x5060, 108
	GoToIfNe _cv_next_483
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_8
	GoTo _cv_done_475
_cv_next_483:
	CompareVarToValue 0x5060, 109
	GoToIfNe _cv_next_484
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_9
	GoTo _cv_done_475
_cv_next_484:
	CompareVarToValue 0x5060, 110
	GoToIfNe _cv_next_485
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_10
	GoTo _cv_done_475
_cv_next_485:
	CompareVarToValue 0x5060, 111
	GoToIfNe _cv_next_486
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_11
	GoTo _cv_done_475
_cv_next_486:
_cv_done_475:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_statue_famous
	WaitButton
_cv_victor_451:
	CompareVarToValue 0x505B, 4
	GoToIfLt _cv_victors_375
	CompareVarToValue 0x5062, 100
	GoToIfGe _cv_victor_487
	CompareVarToValue 0x5062, 0
	GoToIfNe _cv_next_490
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_0
	GoTo _cv_done_489
_cv_next_490:
	CompareVarToValue 0x5062, 1
	GoToIfNe _cv_next_491
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_1
	GoTo _cv_done_489
_cv_next_491:
	CompareVarToValue 0x5062, 2
	GoToIfNe _cv_next_492
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_2
	GoTo _cv_done_489
_cv_next_492:
	CompareVarToValue 0x5062, 3
	GoToIfNe _cv_next_493
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_3
	GoTo _cv_done_489
_cv_next_493:
	CompareVarToValue 0x5062, 4
	GoToIfNe _cv_next_494
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_4
	GoTo _cv_done_489
_cv_next_494:
	CompareVarToValue 0x5062, 5
	GoToIfNe _cv_next_495
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_5
	GoTo _cv_done_489
_cv_next_495:
	CompareVarToValue 0x5062, 6
	GoToIfNe _cv_next_496
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_6
	GoTo _cv_done_489
_cv_next_496:
	CompareVarToValue 0x5062, 7
	GoToIfNe _cv_next_497
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_7
	GoTo _cv_done_489
_cv_next_497:
	CompareVarToValue 0x5062, 8
	GoToIfNe _cv_next_498
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_8
	GoTo _cv_done_489
_cv_next_498:
	CompareVarToValue 0x5062, 9
	GoToIfNe _cv_next_499
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_9
	GoTo _cv_done_489
_cv_next_499:
	CompareVarToValue 0x5062, 10
	GoToIfNe _cv_next_500
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_10
	GoTo _cv_done_489
_cv_next_500:
	CompareVarToValue 0x5062, 11
	GoToIfNe _cv_next_501
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_11
	GoTo _cv_done_489
_cv_next_501:
	CompareVarToValue 0x5062, 12
	GoToIfNe _cv_next_502
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_12
	GoTo _cv_done_489
_cv_next_502:
	CompareVarToValue 0x5062, 13
	GoToIfNe _cv_next_503
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_13
	GoTo _cv_done_489
_cv_next_503:
	CompareVarToValue 0x5062, 14
	GoToIfNe _cv_next_504
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_14
	GoTo _cv_done_489
_cv_next_504:
	CompareVarToValue 0x5062, 15
	GoToIfNe _cv_next_505
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_15
	GoTo _cv_done_489
_cv_next_505:
	CompareVarToValue 0x5062, 16
	GoToIfNe _cv_next_506
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_16
	GoTo _cv_done_489
_cv_next_506:
	CompareVarToValue 0x5062, 17
	GoToIfNe _cv_next_507
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_17
	GoTo _cv_done_489
_cv_next_507:
	CompareVarToValue 0x5062, 18
	GoToIfNe _cv_next_508
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_18
	GoTo _cv_done_489
_cv_next_508:
	CompareVarToValue 0x5062, 19
	GoToIfNe _cv_next_509
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_19
	GoTo _cv_done_489
_cv_next_509:
	CompareVarToValue 0x5062, 20
	GoToIfNe _cv_next_510
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_20
	GoTo _cv_done_489
_cv_next_510:
	CompareVarToValue 0x5062, 21
	GoToIfNe _cv_next_511
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_class_21
	GoTo _cv_done_489
_cv_next_511:
_cv_done_489:
	CanvasCandidate 16, 1, 0x5063
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_statue_victor
	WaitButton
	GoTo _cv_victor_488
_cv_victor_487:
	CompareVarToValue 0x5062, 100
	GoToIfNe _cv_next_513
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_0
	GoTo _cv_done_512
_cv_next_513:
	CompareVarToValue 0x5062, 101
	GoToIfNe _cv_next_514
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_1
	GoTo _cv_done_512
_cv_next_514:
	CompareVarToValue 0x5062, 102
	GoToIfNe _cv_next_515
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_2
	GoTo _cv_done_512
_cv_next_515:
	CompareVarToValue 0x5062, 103
	GoToIfNe _cv_next_516
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_3
	GoTo _cv_done_512
_cv_next_516:
	CompareVarToValue 0x5062, 104
	GoToIfNe _cv_next_517
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_4
	GoTo _cv_done_512
_cv_next_517:
	CompareVarToValue 0x5062, 105
	GoToIfNe _cv_next_518
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_5
	GoTo _cv_done_512
_cv_next_518:
	CompareVarToValue 0x5062, 106
	GoToIfNe _cv_next_519
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_6
	GoTo _cv_done_512
_cv_next_519:
	CompareVarToValue 0x5062, 108
	GoToIfNe _cv_next_520
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_8
	GoTo _cv_done_512
_cv_next_520:
	CompareVarToValue 0x5062, 109
	GoToIfNe _cv_next_521
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_9
	GoTo _cv_done_512
_cv_next_521:
	CompareVarToValue 0x5062, 110
	GoToIfNe _cv_next_522
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_10
	GoTo _cv_done_512
_cv_next_522:
	CompareVarToValue 0x5062, 111
	GoToIfNe _cv_next_523
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_11
	GoTo _cv_done_512
_cv_next_523:
_cv_done_512:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_statue_famous
	WaitButton
_cv_victor_488:
_cv_victors_375:
	CloseMsg
	ReleaseAll
	End
	
GymDecor_EventScript_PCMenu:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_WhatToDo
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_Buy, 0
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_Sell, 1
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_Decorate, 2
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_PutAllAway, 3
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_LogOff, 4
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_525
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_525:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymDecor_EventScript_Buy
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymDecor_EventScript_Sell
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq GymDecor_EventScript_Decorate
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfEq GymDecor_EventScript_PutAllAway
	GoTo GymDecor_EventScript_LogOff
	CloseMsg
	End
	
PalletTown_Gym_EventScript_FirstVisitPeople:
	SetFlag 0x2039
	ClearFlag 0x2033
	ClearFlag 0x2034
	Return
	
PalletTown_Gym_EventScript_ShowAide:
	ClearFlag 0x2039
	Return
	
PalletTown_Gym_EventScript_ShowOak:
	ClearFlag 0x2034
	Return
	
EventScript_TryReadyNationalDexScene:
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x2026, _cv_dex_526
	SetVar VAR_SPECIAL_RESULT, 1
_cv_dex_526:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	CallIfEq EventScript_SetReadyTryGiveNationalDexScene
	Return
	
GymFinale_EventScript_AideAndLegend:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_OakMeetMyAide
	WaitButton
	ApplyMovement 1, Common_Movement_WalkInPlaceFasterRight
	ApplyMovement obj_player, GymFinale_Movement_PlayerLookAtAide
	WaitMovement
	ApplyMovement 3, Common_Movement_WalkInPlaceFasterLeft
	WaitMovement
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_AideHello
	WaitButton
	ApplyMovement 1, Common_Movement_WalkInPlaceFasterDown
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_OakHowItWorks
	WaitButton
	CanvasCloseMsg
	Call GymLegend_EventScript_Arrives
	CanvasCloseMsg
	ApplyMovement 1, PalletTown_Gym_Movement_OakLeave
	WaitMovement
	HidePerson 1
	SetFlag 0x2034
	PlaySE SEQ_SE_DP_KAIDAN2
	SetFlag 0x2034
	ResetBGM
	CanvasCloseMsg
	ReleaseAll
	End
	
EventScript_GiveHotAirBalloon:
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x202C, _cv_has_527
	SetVar VAR_SPECIAL_RESULT, 1
_cv_has_527:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq EventScript_PalmPilotReturn
	SetFlag 0x202C
	SetVar VAR_SPECIAL_RESULT, 1
	Return
	
GymFinale_EventScript_OakSkippedTheCeremony:
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_OakHeardTheCheering
	WaitButton
	ApplyMovement 1, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_OakThinking
	WaitButton
	ApplyMovement 1, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	PlaySE SEQ_SE_DP_SELECT
	ApplyMovement 1, Common_Movement_ExclamationMark
	WaitMovement
	PlayBGM SEQ_GS_E_RIVAL1
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_OakWontGiveItUpSpeeches
	WaitButton
	GoTo GymFinale_EventScript_OakAsksToBattle
	CloseMsg
	End
	
GymLegend_EventScript_RivalWalksIn:
	PlayBGM SEQ_GS_E_RIVAL1
	SetVar 0x800A, 2
	CanvasCandidate 4, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymLegend_EventScript_RivalAppears
	CopyVar 0x401E, 0x8005
	CopyVar 0x401F, 0x8006
	MovePerson 2, 0x401E, 0x401F
	ClearFlag 0x2033
	GoToIfUnset 0x2033, _cv_show_528
	ClearFlag 0x2033
	ShowPerson 2
	SetFlag 0x2033
	GoTo _cv_shown_529
_cv_show_528:
	ShowPerson 2
_cv_shown_529:
	CanvasCandidate 5, 0x800A, 0
	WaitMovement
	CanvasCandidate 2, 0x800A
	Return
	
GymLegend_EventScript_RivalWalksOut:
	CanvasCloseMsg
	PlayBGM SEQ_GS_E_RIVAL2
	CanvasCandidate 6
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymLegend_EventScript_RivalVanishes
	CanvasCandidate 5, 0x800A, 1
	WaitMovement
	GoTo GymLegend_EventScript_RivalVanishes
	
GymLegend_EventScript_Appears:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_532
	SetVar 0x8004, 698
	SetVar 0x402C, 3198
	GoTo _cv_done_531
_cv_next_532:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_533
	SetVar 0x8004, 1057
	SetVar 0x402C, 3557
	GoTo _cv_done_531
_cv_next_533:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_534
	SetVar 0x8004, 691
	SetVar 0x402C, 3191
	GoTo _cv_done_531
_cv_next_534:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_535
	SetVar 0x8004, 940
	SetVar 0x402C, 3440
	GoTo _cv_done_531
_cv_next_535:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_536
	SetVar 0x8004, SPECIES_GROUDON
	SetVar 0x402C, SPRITE_FOLLOWER_MON_STATIC_GROUDON
	GoTo _cv_done_531
_cv_next_536:
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_537
	SetVar 0x8004, 769
	SetVar 0x402C, 3269
	GoTo _cv_done_531
_cv_next_537:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_538
	SetVar 0x8004, 699
	SetVar 0x402C, 3199
	GoTo _cv_done_531
_cv_next_538:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_539
	SetVar 0x8004, SPECIES_GIRATINA
	SetVar 0x402C, 2987
	GoTo _cv_done_531
_cv_next_539:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_540
	SetVar 0x8004, SPECIES_DIALGA
	SetVar 0x402C, 2983
	GoTo _cv_done_531
_cv_next_540:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_541
	SetVar 0x8004, SPECIES_HO_OH
	SetVar 0x402C, 2750
	GoTo _cv_done_531
_cv_next_541:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_542
	SetVar 0x8004, SPECIES_PALKIA
	SetVar 0x402C, 2984
	GoTo _cv_done_531
_cv_next_542:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_543
	SetVar 0x8004, SPECIES_SHAYMIN
	SetVar 0x402C, 2992
	GoTo _cv_done_531
_cv_next_543:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_544
	SetVar 0x8004, 1058
	SetVar 0x402C, 3558
	GoTo _cv_done_531
_cv_next_544:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_545
	SetVar 0x8004, SPECIES_CRESSELIA
	SetVar 0x402C, 2988
	GoTo _cv_done_531
_cv_next_545:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_546
	SetVar 0x8004, 946
	SetVar 0x402C, 3446
	GoTo _cv_done_531
_cv_next_546:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_547
	SetVar 0x8004, SPECIES_RAYQUAZA
	SetVar 0x402C, SPRITE_FOLLOWER_MON_STATIC_RAYQUAZA
	GoTo _cv_done_531
_cv_next_547:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_548
	SetVar 0x8004, SPECIES_DARKRAI
	SetVar 0x402C, 2991
	GoTo _cv_done_531
_cv_next_548:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_549
	SetVar 0x8004, 766
	SetVar 0x402C, 3266
	GoTo _cv_done_531
_cv_next_549:
_cv_done_531:
	BufferSpeciesName 0, 0x8004, 0, 0
	BufferTypeName 1, 0x5019
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfSet 0x2037, _cv_legend_530
	SetVar VAR_SPECIAL_RESULT, 1
_cv_legend_530:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymLegend_EventScript_NoLegend
	CopyVar 0x8008, 0x8004
	SetVar 0x8005, 12
	SetVar 0x8006, 18
	CopyVar 0x401E, 0x8005
	CopyVar 0x401F, 0x8006
	MovePerson 16, 0x401E, 0x401F
	Wait 30, VAR_SPECIAL_RESULT
	SetVar 0x8004, 2
	SetVar 0x8005, 2
	SetVar 0x8006, 12
	SetVar 0x8007, 4
	ScreenShake 0x8005, 0x8004, 0x8007, 0x8006
	PlaySE SEQ_SE_DP_T_KAMI
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymLegend_Text_LightsOut
	WaitButton
	CanvasCloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	ClearFlag 0x203A
	GoToIfUnset 0x203A, _cv_show_550
	ClearFlag 0x203A
	ShowPerson 16
	SetFlag 0x203A
	GoTo _cv_shown_551
_cv_show_550:
	ShowPerson 16
_cv_shown_551:
	Wait 40, VAR_SPECIAL_RESULT
	PlaySE SEQ_SE_DP_T_KAMI
	FadeScreen 6, 1, 1, RGB_WHITE
	WaitFade
	PlayCry 0x8008, 0
	WaitCry
	GetPlayerCoords 0x401E, 0x401F
	ScrCmd_102 0x401E, 0x401F
	CanvasCandidate 22, 12, 19
	WaitMovement
	PlayBGM SEQ_GS_E_ARCEUS
	Wait 30, VAR_SPECIAL_RESULT
	PlayCry 0x8008, 0
	WaitCry
	Wait 30, VAR_SPECIAL_RESULT
	CanvasCandidate 23
	WaitMovement
	ScrCmd_103
	SetFlag 0x203B
	SetVar 0x5014, 0
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_554
	SetVar 0x8004, 698
	SetVar 0x402C, 3198
	GoTo _cv_done_553
_cv_next_554:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_555
	SetVar 0x8004, 1057
	SetVar 0x402C, 3557
	GoTo _cv_done_553
_cv_next_555:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_556
	SetVar 0x8004, 691
	SetVar 0x402C, 3191
	GoTo _cv_done_553
_cv_next_556:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_557
	SetVar 0x8004, 940
	SetVar 0x402C, 3440
	GoTo _cv_done_553
_cv_next_557:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_558
	SetVar 0x8004, SPECIES_GROUDON
	SetVar 0x402C, SPRITE_FOLLOWER_MON_STATIC_GROUDON
	GoTo _cv_done_553
_cv_next_558:
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_559
	SetVar 0x8004, 769
	SetVar 0x402C, 3269
	GoTo _cv_done_553
_cv_next_559:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_560
	SetVar 0x8004, 699
	SetVar 0x402C, 3199
	GoTo _cv_done_553
_cv_next_560:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_561
	SetVar 0x8004, SPECIES_GIRATINA
	SetVar 0x402C, 2987
	GoTo _cv_done_553
_cv_next_561:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_562
	SetVar 0x8004, SPECIES_DIALGA
	SetVar 0x402C, 2983
	GoTo _cv_done_553
_cv_next_562:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_563
	SetVar 0x8004, SPECIES_HO_OH
	SetVar 0x402C, 2750
	GoTo _cv_done_553
_cv_next_563:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_564
	SetVar 0x8004, SPECIES_PALKIA
	SetVar 0x402C, 2984
	GoTo _cv_done_553
_cv_next_564:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_565
	SetVar 0x8004, SPECIES_SHAYMIN
	SetVar 0x402C, 2992
	GoTo _cv_done_553
_cv_next_565:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_566
	SetVar 0x8004, 1058
	SetVar 0x402C, 3558
	GoTo _cv_done_553
_cv_next_566:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_567
	SetVar 0x8004, SPECIES_CRESSELIA
	SetVar 0x402C, 2988
	GoTo _cv_done_553
_cv_next_567:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_568
	SetVar 0x8004, 946
	SetVar 0x402C, 3446
	GoTo _cv_done_553
_cv_next_568:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_569
	SetVar 0x8004, SPECIES_RAYQUAZA
	SetVar 0x402C, SPRITE_FOLLOWER_MON_STATIC_RAYQUAZA
	GoTo _cv_done_553
_cv_next_569:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_570
	SetVar 0x8004, SPECIES_DARKRAI
	SetVar 0x402C, 2991
	GoTo _cv_done_553
_cv_next_570:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_571
	SetVar 0x8004, 766
	SetVar 0x402C, 3266
	GoTo _cv_done_553
_cv_next_571:
_cv_done_553:
	BufferSpeciesName 0, 0x8004, 0, 0
	BufferTypeName 1, 0x5019
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfSet 0x2037, _cv_legend_552
	SetVar VAR_SPECIAL_RESULT, 1
_cv_legend_552:
	SetVar VAR_SPECIAL_RESULT, 1
	Return
	
GymLegend_EventScript_ArrivesLaterEnd:
	CanvasCloseMsg
	ReleaseAll
	End
	
Johto_EventScript_InvitationByMail:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Johto_Text_InvitationByMail
	WaitButton
	Call Johto_EventScript_ReceiveInvitation
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Johto_Text_InvitationFerry
	WaitButton
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Johto_Text_GymCharmByMail
	WaitButton
	Call Johto_EventScript_ReceiveGymCharm
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Johto_Text_GymCharmHowByMail
	WaitButton
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Johto_Text_LeaderPerksByMail
	WaitButton
	SetVar 0x5009, 2
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_VisitorWalksIn:
	CanvasCandidate 4, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_MentorAppears
	MovePerson 0x800A, 0x8005, 0x8006
	ClearFlag 0x2017
	ShowPerson 0x800A
	CanvasCandidate 5, 0x800A, 0
	WaitMovement
	CanvasCandidate 2, 0x800A
	Return
	
Johto_EventScript_ReceiveInvitation:
	PlayFanfare SEQ_ME_ITEM
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Johto_Text_ReceivedInvitation
	WaitFanfare
	Return
	
Johto_EventScript_ReceiveGymCharm:
	SetFlag 0x202E
	SetVar VAR_SPECIAL_RESULT, 1
	Return
	
GymCandidate_EventScript_VisitorWalksOut:
	CanvasCandidate 6
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_GuestLeaves
	CanvasCloseMsg
	CanvasCandidate 5, 0x800A, 1
	WaitMovement
	HidePerson 0x800A
	SetFlag 0x2017
	PlaySE SEQ_SE_DP_KAIDAN2
	CanvasCandidate 3
	Return
	
GymFinale_EventScript_PutOff:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_OakComeBackWhenReady
	WaitButton
	SetVar 0x5004, 2
	ResetBGM
	CloseMsg
	ReleaseAll
	End
	
GymFinale_EventScript_TeamBreaksRules:
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	CallIfEq EventScript_GymHack_ShowTeamRuleMessage
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	CallIfNe GymFinale_EventScript_OakRulesMsg
	SetVar 0x5004, 2
	ResetBGM
	CanvasCloseMsg
	ReleaseAll
	End
	
GymFinale_EventScript_BeatOak:
	PlayBGM SEQ_GS_T_MASARA
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_OakGivesUp
	WaitButton
	GoToIfUnset FLAG_GAME_CLEAR, GymFinale_EventScript_HallOfFame
	SetFlag 0x2008
	SetVar 0x5004, 3
	Call GymFinale_EventScript_Badge
	Call EventScript_TryReadyNationalDexScene
	GoTo GymFinale_EventScript_AideAndLegend
	
GymFinale_EventScript_LostToOak:
	HealParty
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_OakStillHasIt
	WaitButton
	CanvasCloseMsg
	SetVar 0x5004, 2
	SetFlag 0x2034
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	Warp MAP_PALLET_TOWN_REDS_HOUSE_1F, 0, 9, 6, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	CanvasCloseMsg
	ReleaseAll
	End
	
GymChallenge_EventScript_ItemClause:
	Call EventScript_GymHack_ShowTeamRuleMessage
	CanvasCloseMsg
	ReleaseAll
	End
	
GymChallenge_EventScript_AnnounceFamous:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_AnnounceFamous
	WaitButton
	Return
	
GymChallenge_EventScript_AnnounceTownsfolk:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_AnnounceTownsfolk
	WaitButton
	Return
	
GymChallenge_EventScript_AnnounceTrainer:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_AnnounceTrainer
	WaitButton
	Return
	
GymSwitch_EventScript_AnnounceMentor:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymSwitch_Text_AnnounceMentor
	WaitButton
	Return
	
GymChallenge_EventScript_ChallengerJumpsIn:
	CanvasCandidate 17, 4, 0x8005, 0x8006
	Return
	
GymChallenge_EventScript_Won:
	CompareVarToValue 0x5052, 0
	GoToIfEq _cv_gline_573
	CompareVarToValue 0x5052, 3
	GoToIfEq _cv_gline_574
	CompareVarToValue 0x5053, 0
	GoToIfNe _cv_next_576
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_after_0
	WaitButton
	GoTo _cv_done_575
_cv_next_576:
	CompareVarToValue 0x5053, 1
	GoToIfNe _cv_next_577
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_after_1
	WaitButton
	GoTo _cv_done_575
_cv_next_577:
	CompareVarToValue 0x5053, 2
	GoToIfNe _cv_next_578
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_after_2
	WaitButton
	GoTo _cv_done_575
_cv_next_578:
	CompareVarToValue 0x5053, 3
	GoToIfNe _cv_next_579
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_after_3
	WaitButton
	GoTo _cv_done_575
_cv_next_579:
	CompareVarToValue 0x5053, 4
	GoToIfNe _cv_next_580
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_after_4
	WaitButton
	GoTo _cv_done_575
_cv_next_580:
	CompareVarToValue 0x5053, 5
	GoToIfNe _cv_next_581
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_after_5
	WaitButton
	GoTo _cv_done_575
_cv_next_581:
	CompareVarToValue 0x5053, 6
	GoToIfNe _cv_next_582
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_after_6
	WaitButton
	GoTo _cv_done_575
_cv_next_582:
	CompareVarToValue 0x5053, 8
	GoToIfNe _cv_next_583
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_after_8
	WaitButton
	GoTo _cv_done_575
_cv_next_583:
	CompareVarToValue 0x5053, 9
	GoToIfNe _cv_next_584
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_after_9
	WaitButton
	GoTo _cv_done_575
_cv_next_584:
	CompareVarToValue 0x5053, 10
	GoToIfNe _cv_next_585
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_after_10
	WaitButton
	GoTo _cv_done_575
_cv_next_585:
	CompareVarToValue 0x5053, 11
	GoToIfNe _cv_next_586
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_after_11
	WaitButton
	GoTo _cv_done_575
_cv_next_586:
_cv_done_575:
	GoTo _cv_gline_572
_cv_gline_574:
	BufferTypeName 1, 0x5019
	CopyVar 0x401E, 0x504D
	BufferInt 2, 0x401E
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_boss_after
	WaitButton
	GoTo _cv_gline_572
_cv_gline_573:
	CompareVarToValue 0x5058, 0
	GoToIfNe _cv_next_587
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_gym_after_0
	WaitButton
	GoTo _cv_gline_572
_cv_next_587:
	CompareVarToValue 0x5058, 1
	GoToIfNe _cv_next_588
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_gym_after_1
	WaitButton
	GoTo _cv_gline_572
_cv_next_588:
	CompareVarToValue 0x5058, 2
	GoToIfNe _cv_next_589
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_gym_after_2
	WaitButton
	GoTo _cv_gline_572
_cv_next_589:
	CompareVarToValue 0x5058, 3
	GoToIfNe _cv_next_590
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_gym_after_3
	WaitButton
	GoTo _cv_gline_572
_cv_next_590:
_cv_gline_572:
	Call GymChallenge_EventScript_ChallengerLeaves
	AddVar 0x504D, 1
	AddVar 0x504F, 1
	AddVar 0x5051, 1
	CompareVarToValue 0x5051, 7
	GoToIfLt _cv_win_591
	SetVar 0x5051, 0
_cv_win_591:
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToVar 0x504D, 0x504E
	GoToIfLe _cv_win_592
	SetVar VAR_SPECIAL_RESULT, 1
	CopyVar 0x504E, 0x504D
_cv_win_592:
	CompareVarToValue 0x504D, 40
	GoToIfGt _cv_prize_633
	CompareVarToValue 0x504D, 1
	GoToIfNe _cv_next_636
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_593
	AddMoney 2200
	SetVar 0x401E, 2200
	GoTo _cv_prize_593_d
_cv_prize_593:
	AddMoney 4400
	SetVar 0x401E, 4400
_cv_prize_593_d:
	GoTo _cv_prize_634
_cv_next_636:
	CompareVarToValue 0x504D, 2
	GoToIfNe _cv_next_637
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_594
	AddMoney 2400
	SetVar 0x401E, 2400
	GoTo _cv_prize_594_d
_cv_prize_594:
	AddMoney 4800
	SetVar 0x401E, 4800
_cv_prize_594_d:
	GoTo _cv_prize_634
_cv_next_637:
	CompareVarToValue 0x504D, 3
	GoToIfNe _cv_next_638
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_595
	AddMoney 2600
	SetVar 0x401E, 2600
	GoTo _cv_prize_595_d
_cv_prize_595:
	AddMoney 5200
	SetVar 0x401E, 5200
_cv_prize_595_d:
	GoTo _cv_prize_634
_cv_next_638:
	CompareVarToValue 0x504D, 4
	GoToIfNe _cv_next_639
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_596
	AddMoney 2800
	SetVar 0x401E, 2800
	GoTo _cv_prize_596_d
_cv_prize_596:
	AddMoney 5600
	SetVar 0x401E, 5600
_cv_prize_596_d:
	GoTo _cv_prize_634
_cv_next_639:
	CompareVarToValue 0x504D, 5
	GoToIfNe _cv_next_640
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_597
	AddMoney 3000
	SetVar 0x401E, 3000
	GoTo _cv_prize_597_d
_cv_prize_597:
	AddMoney 6000
	SetVar 0x401E, 6000
_cv_prize_597_d:
	GoTo _cv_prize_634
_cv_next_640:
	CompareVarToValue 0x504D, 6
	GoToIfNe _cv_next_641
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_598
	AddMoney 3200
	SetVar 0x401E, 3200
	GoTo _cv_prize_598_d
_cv_prize_598:
	AddMoney 6400
	SetVar 0x401E, 6400
_cv_prize_598_d:
	GoTo _cv_prize_634
_cv_next_641:
	CompareVarToValue 0x504D, 7
	GoToIfNe _cv_next_642
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_599
	AddMoney 3400
	SetVar 0x401E, 3400
	GoTo _cv_prize_599_d
_cv_prize_599:
	AddMoney 6800
	SetVar 0x401E, 6800
_cv_prize_599_d:
	GoTo _cv_prize_634
_cv_next_642:
	CompareVarToValue 0x504D, 8
	GoToIfNe _cv_next_643
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_600
	AddMoney 3600
	SetVar 0x401E, 3600
	GoTo _cv_prize_600_d
_cv_prize_600:
	AddMoney 7200
	SetVar 0x401E, 7200
_cv_prize_600_d:
	GoTo _cv_prize_634
_cv_next_643:
	CompareVarToValue 0x504D, 9
	GoToIfNe _cv_next_644
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_601
	AddMoney 3800
	SetVar 0x401E, 3800
	GoTo _cv_prize_601_d
_cv_prize_601:
	AddMoney 7600
	SetVar 0x401E, 7600
_cv_prize_601_d:
	GoTo _cv_prize_634
_cv_next_644:
	CompareVarToValue 0x504D, 10
	GoToIfNe _cv_next_645
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_602
	AddMoney 4000
	SetVar 0x401E, 4000
	GoTo _cv_prize_602_d
_cv_prize_602:
	AddMoney 8000
	SetVar 0x401E, 8000
_cv_prize_602_d:
	GoTo _cv_prize_634
_cv_next_645:
	CompareVarToValue 0x504D, 11
	GoToIfNe _cv_next_646
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_603
	AddMoney 4200
	SetVar 0x401E, 4200
	GoTo _cv_prize_603_d
_cv_prize_603:
	AddMoney 8400
	SetVar 0x401E, 8400
_cv_prize_603_d:
	GoTo _cv_prize_634
_cv_next_646:
	CompareVarToValue 0x504D, 12
	GoToIfNe _cv_next_647
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_604
	AddMoney 4400
	SetVar 0x401E, 4400
	GoTo _cv_prize_604_d
_cv_prize_604:
	AddMoney 8800
	SetVar 0x401E, 8800
_cv_prize_604_d:
	GoTo _cv_prize_634
_cv_next_647:
	CompareVarToValue 0x504D, 13
	GoToIfNe _cv_next_648
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_605
	AddMoney 4600
	SetVar 0x401E, 4600
	GoTo _cv_prize_605_d
_cv_prize_605:
	AddMoney 9200
	SetVar 0x401E, 9200
_cv_prize_605_d:
	GoTo _cv_prize_634
_cv_next_648:
	CompareVarToValue 0x504D, 14
	GoToIfNe _cv_next_649
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_606
	AddMoney 4800
	SetVar 0x401E, 4800
	GoTo _cv_prize_606_d
_cv_prize_606:
	AddMoney 9600
	SetVar 0x401E, 9600
_cv_prize_606_d:
	GoTo _cv_prize_634
_cv_next_649:
	CompareVarToValue 0x504D, 15
	GoToIfNe _cv_next_650
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_607
	AddMoney 5000
	SetVar 0x401E, 5000
	GoTo _cv_prize_607_d
_cv_prize_607:
	AddMoney 10000
	SetVar 0x401E, 10000
_cv_prize_607_d:
	GoTo _cv_prize_634
_cv_next_650:
	CompareVarToValue 0x504D, 16
	GoToIfNe _cv_next_651
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_608
	AddMoney 5200
	SetVar 0x401E, 5200
	GoTo _cv_prize_608_d
_cv_prize_608:
	AddMoney 10400
	SetVar 0x401E, 10400
_cv_prize_608_d:
	GoTo _cv_prize_634
_cv_next_651:
	CompareVarToValue 0x504D, 17
	GoToIfNe _cv_next_652
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_609
	AddMoney 5400
	SetVar 0x401E, 5400
	GoTo _cv_prize_609_d
_cv_prize_609:
	AddMoney 10800
	SetVar 0x401E, 10800
_cv_prize_609_d:
	GoTo _cv_prize_634
_cv_next_652:
	CompareVarToValue 0x504D, 18
	GoToIfNe _cv_next_653
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_610
	AddMoney 5600
	SetVar 0x401E, 5600
	GoTo _cv_prize_610_d
_cv_prize_610:
	AddMoney 11200
	SetVar 0x401E, 11200
_cv_prize_610_d:
	GoTo _cv_prize_634
_cv_next_653:
	CompareVarToValue 0x504D, 19
	GoToIfNe _cv_next_654
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_611
	AddMoney 5800
	SetVar 0x401E, 5800
	GoTo _cv_prize_611_d
_cv_prize_611:
	AddMoney 11600
	SetVar 0x401E, 11600
_cv_prize_611_d:
	GoTo _cv_prize_634
_cv_next_654:
	CompareVarToValue 0x504D, 20
	GoToIfNe _cv_next_655
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_612
	AddMoney 6000
	SetVar 0x401E, 6000
	GoTo _cv_prize_612_d
_cv_prize_612:
	AddMoney 12000
	SetVar 0x401E, 12000
_cv_prize_612_d:
	GoTo _cv_prize_634
_cv_next_655:
	CompareVarToValue 0x504D, 21
	GoToIfNe _cv_next_656
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_613
	AddMoney 6200
	SetVar 0x401E, 6200
	GoTo _cv_prize_613_d
_cv_prize_613:
	AddMoney 12400
	SetVar 0x401E, 12400
_cv_prize_613_d:
	GoTo _cv_prize_634
_cv_next_656:
	CompareVarToValue 0x504D, 22
	GoToIfNe _cv_next_657
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_614
	AddMoney 6400
	SetVar 0x401E, 6400
	GoTo _cv_prize_614_d
_cv_prize_614:
	AddMoney 12800
	SetVar 0x401E, 12800
_cv_prize_614_d:
	GoTo _cv_prize_634
_cv_next_657:
	CompareVarToValue 0x504D, 23
	GoToIfNe _cv_next_658
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_615
	AddMoney 6600
	SetVar 0x401E, 6600
	GoTo _cv_prize_615_d
_cv_prize_615:
	AddMoney 13200
	SetVar 0x401E, 13200
_cv_prize_615_d:
	GoTo _cv_prize_634
_cv_next_658:
	CompareVarToValue 0x504D, 24
	GoToIfNe _cv_next_659
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_616
	AddMoney 6800
	SetVar 0x401E, 6800
	GoTo _cv_prize_616_d
_cv_prize_616:
	AddMoney 13600
	SetVar 0x401E, 13600
_cv_prize_616_d:
	GoTo _cv_prize_634
_cv_next_659:
	CompareVarToValue 0x504D, 25
	GoToIfNe _cv_next_660
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_617
	AddMoney 7000
	SetVar 0x401E, 7000
	GoTo _cv_prize_617_d
_cv_prize_617:
	AddMoney 14000
	SetVar 0x401E, 14000
_cv_prize_617_d:
	GoTo _cv_prize_634
_cv_next_660:
	CompareVarToValue 0x504D, 26
	GoToIfNe _cv_next_661
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_618
	AddMoney 7200
	SetVar 0x401E, 7200
	GoTo _cv_prize_618_d
_cv_prize_618:
	AddMoney 14400
	SetVar 0x401E, 14400
_cv_prize_618_d:
	GoTo _cv_prize_634
_cv_next_661:
	CompareVarToValue 0x504D, 27
	GoToIfNe _cv_next_662
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_619
	AddMoney 7400
	SetVar 0x401E, 7400
	GoTo _cv_prize_619_d
_cv_prize_619:
	AddMoney 14800
	SetVar 0x401E, 14800
_cv_prize_619_d:
	GoTo _cv_prize_634
_cv_next_662:
	CompareVarToValue 0x504D, 28
	GoToIfNe _cv_next_663
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_620
	AddMoney 7600
	SetVar 0x401E, 7600
	GoTo _cv_prize_620_d
_cv_prize_620:
	AddMoney 15200
	SetVar 0x401E, 15200
_cv_prize_620_d:
	GoTo _cv_prize_634
_cv_next_663:
	CompareVarToValue 0x504D, 29
	GoToIfNe _cv_next_664
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_621
	AddMoney 7800
	SetVar 0x401E, 7800
	GoTo _cv_prize_621_d
_cv_prize_621:
	AddMoney 15600
	SetVar 0x401E, 15600
_cv_prize_621_d:
	GoTo _cv_prize_634
_cv_next_664:
	CompareVarToValue 0x504D, 30
	GoToIfNe _cv_next_665
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_622
	AddMoney 8000
	SetVar 0x401E, 8000
	GoTo _cv_prize_622_d
_cv_prize_622:
	AddMoney 16000
	SetVar 0x401E, 16000
_cv_prize_622_d:
	GoTo _cv_prize_634
_cv_next_665:
	CompareVarToValue 0x504D, 31
	GoToIfNe _cv_next_666
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_623
	AddMoney 8200
	SetVar 0x401E, 8200
	GoTo _cv_prize_623_d
_cv_prize_623:
	AddMoney 16400
	SetVar 0x401E, 16400
_cv_prize_623_d:
	GoTo _cv_prize_634
_cv_next_666:
	CompareVarToValue 0x504D, 32
	GoToIfNe _cv_next_667
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_624
	AddMoney 8400
	SetVar 0x401E, 8400
	GoTo _cv_prize_624_d
_cv_prize_624:
	AddMoney 16800
	SetVar 0x401E, 16800
_cv_prize_624_d:
	GoTo _cv_prize_634
_cv_next_667:
	CompareVarToValue 0x504D, 33
	GoToIfNe _cv_next_668
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_625
	AddMoney 8600
	SetVar 0x401E, 8600
	GoTo _cv_prize_625_d
_cv_prize_625:
	AddMoney 17200
	SetVar 0x401E, 17200
_cv_prize_625_d:
	GoTo _cv_prize_634
_cv_next_668:
	CompareVarToValue 0x504D, 34
	GoToIfNe _cv_next_669
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_626
	AddMoney 8800
	SetVar 0x401E, 8800
	GoTo _cv_prize_626_d
_cv_prize_626:
	AddMoney 17600
	SetVar 0x401E, 17600
_cv_prize_626_d:
	GoTo _cv_prize_634
_cv_next_669:
	CompareVarToValue 0x504D, 35
	GoToIfNe _cv_next_670
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_627
	AddMoney 9000
	SetVar 0x401E, 9000
	GoTo _cv_prize_627_d
_cv_prize_627:
	AddMoney 18000
	SetVar 0x401E, 18000
_cv_prize_627_d:
	GoTo _cv_prize_634
_cv_next_670:
	CompareVarToValue 0x504D, 36
	GoToIfNe _cv_next_671
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_628
	AddMoney 9200
	SetVar 0x401E, 9200
	GoTo _cv_prize_628_d
_cv_prize_628:
	AddMoney 18400
	SetVar 0x401E, 18400
_cv_prize_628_d:
	GoTo _cv_prize_634
_cv_next_671:
	CompareVarToValue 0x504D, 37
	GoToIfNe _cv_next_672
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_629
	AddMoney 9400
	SetVar 0x401E, 9400
	GoTo _cv_prize_629_d
_cv_prize_629:
	AddMoney 18800
	SetVar 0x401E, 18800
_cv_prize_629_d:
	GoTo _cv_prize_634
_cv_next_672:
	CompareVarToValue 0x504D, 38
	GoToIfNe _cv_next_673
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_630
	AddMoney 9600
	SetVar 0x401E, 9600
	GoTo _cv_prize_630_d
_cv_prize_630:
	AddMoney 19200
	SetVar 0x401E, 19200
_cv_prize_630_d:
	GoTo _cv_prize_634
_cv_next_673:
	CompareVarToValue 0x504D, 39
	GoToIfNe _cv_next_674
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_631
	AddMoney 9800
	SetVar 0x401E, 9800
	GoTo _cv_prize_631_d
_cv_prize_631:
	AddMoney 19600
	SetVar 0x401E, 19600
_cv_prize_631_d:
	GoTo _cv_prize_634
_cv_next_674:
	CompareVarToValue 0x504D, 40
	GoToIfNe _cv_next_675
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_632
	AddMoney 10000
	SetVar 0x401E, 10000
	GoTo _cv_prize_632_d
_cv_prize_632:
	AddMoney 20000
	SetVar 0x401E, 20000
_cv_prize_632_d:
	GoTo _cv_prize_634
_cv_next_675:
_cv_prize_634:
	GoTo _cv_prize_635
_cv_prize_633:
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_prize_633_2
	AddMoney 10000
	SetVar 0x401E, 10000
	GoTo _cv_prize_635
_cv_prize_633_2:
	AddMoney 20000
	SetVar 0x401E, 20000
_cv_prize_635:
	BufferInt 0, 0x401E
	BufferInt 1, 0x504D
	CompareVarToValue 0x5052, 0
	GoToIfEq _cv_gname_676
	CompareVarToValue 0x5053, 0
	GoToIfNe _cv_next_679
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_0
	GoTo _cv_done_678
_cv_next_679:
	CompareVarToValue 0x5053, 1
	GoToIfNe _cv_next_680
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_1
	GoTo _cv_done_678
_cv_next_680:
	CompareVarToValue 0x5053, 2
	GoToIfNe _cv_next_681
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_2
	GoTo _cv_done_678
_cv_next_681:
	CompareVarToValue 0x5053, 3
	GoToIfNe _cv_next_682
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_3
	GoTo _cv_done_678
_cv_next_682:
	CompareVarToValue 0x5053, 4
	GoToIfNe _cv_next_683
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_4
	GoTo _cv_done_678
_cv_next_683:
	CompareVarToValue 0x5053, 5
	GoToIfNe _cv_next_684
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_5
	GoTo _cv_done_678
_cv_next_684:
	CompareVarToValue 0x5053, 6
	GoToIfNe _cv_next_685
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_6
	GoTo _cv_done_678
_cv_next_685:
	CompareVarToValue 0x5053, 8
	GoToIfNe _cv_next_686
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_8
	GoTo _cv_done_678
_cv_next_686:
	CompareVarToValue 0x5053, 9
	GoToIfNe _cv_next_687
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_9
	GoTo _cv_done_678
_cv_next_687:
	CompareVarToValue 0x5053, 10
	GoToIfNe _cv_next_688
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_10
	GoTo _cv_done_678
_cv_next_688:
	CompareVarToValue 0x5053, 11
	GoToIfNe _cv_next_689
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_11
	GoTo _cv_done_678
_cv_next_689:
_cv_done_678:
	GoTo _cv_gname_677
_cv_gname_676:
	CanvasCandidate 16, 2, 0x5055
_cv_gname_677:
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_gift_690
	Random 0x401E, 16
	CompareVarToValue 0x401E, 0
	GoToIfEq _cv_gift_690
	GoTo _cv_gift_691
_cv_gift_690:
	Random 0x401E, 3
	CompareVarToValue 0x401E, 0
	GoToIfNe _cv_next_694
	SetVar 0x8009, 796
	GoTo _cv_done_693
_cv_next_694:
	CompareVarToValue 0x401E, 1
	GoToIfNe _cv_next_695
	SetVar 0x8009, 645
	GoTo _cv_done_693
_cv_next_695:
	CompareVarToValue 0x401E, 2
	GoToIfNe _cv_next_696
	SetVar 0x8009, ITEM_MASTER_BALL
	GoTo _cv_done_693
_cv_next_696:
_cv_done_693:
	GoTo _cv_gift_692
_cv_gift_691:
	Random 0x401E, 14
	CompareVarToValue 0x401E, 0
	GoToIfNe _cv_next_698
	SetVar 0x8009, ITEM_RARE_CANDY
	GoTo _cv_done_697
_cv_next_698:
	CompareVarToValue 0x401E, 1
	GoToIfNe _cv_next_699
	SetVar 0x8009, ITEM_RARE_CANDY
	GoTo _cv_done_697
_cv_next_699:
	CompareVarToValue 0x401E, 2
	GoToIfNe _cv_next_700
	SetVar 0x8009, ITEM_NUGGET
	GoTo _cv_done_697
_cv_next_700:
	CompareVarToValue 0x401E, 3
	GoToIfNe _cv_next_701
	SetVar 0x8009, ITEM_NUGGET
	GoTo _cv_done_697
_cv_next_701:
	CompareVarToValue 0x401E, 4
	GoToIfNe _cv_next_702
	SetVar 0x8009, ITEM_PP_UP
	GoTo _cv_done_697
_cv_next_702:
	CompareVarToValue 0x401E, 5
	GoToIfNe _cv_next_703
	SetVar 0x8009, ITEM_FULL_RESTORE
	GoTo _cv_done_697
_cv_next_703:
	CompareVarToValue 0x401E, 6
	GoToIfNe _cv_next_704
	SetVar 0x8009, ITEM_MAX_REVIVE
	GoTo _cv_done_697
_cv_next_704:
	CompareVarToValue 0x401E, 7
	GoToIfNe _cv_next_705
	SetVar 0x8009, ITEM_MAX_ELIXIR
	GoTo _cv_done_697
_cv_next_705:
	CompareVarToValue 0x401E, 8
	GoToIfNe _cv_next_706
	SetVar 0x8009, ITEM_HP_UP
	GoTo _cv_done_697
_cv_next_706:
	CompareVarToValue 0x401E, 9
	GoToIfNe _cv_next_707
	SetVar 0x8009, ITEM_PROTEIN
	GoTo _cv_done_697
_cv_next_707:
	CompareVarToValue 0x401E, 10
	GoToIfNe _cv_next_708
	SetVar 0x8009, ITEM_IRON
	GoTo _cv_done_697
_cv_next_708:
	CompareVarToValue 0x401E, 11
	GoToIfNe _cv_next_709
	SetVar 0x8009, ITEM_CALCIUM
	GoTo _cv_done_697
_cv_next_709:
	CompareVarToValue 0x401E, 12
	GoToIfNe _cv_next_710
	SetVar 0x8009, ITEM_ZINC
	GoTo _cv_done_697
_cv_next_710:
	CompareVarToValue 0x401E, 13
	GoToIfNe _cv_next_711
	SetVar 0x8009, ITEM_CARBOS
	GoTo _cv_done_697
_cv_next_711:
_cv_done_697:
_cv_gift_692:
	CopyVar 0x8008, VAR_SPECIAL_RESULT
	PlaySE SEQ_SE_DP_SELECT
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_Won
	WaitButton
	CompareVarToValue 0x8008, 1
	CallIfEq GymChallenge_EventScript_NewRecord
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_LeftAGift
	WaitButton
	CompareVarToValue 0x8009, 0
	CallIfEq GymChallenge_EventScript_RareGift
	Call GymHack_EventScript_GiveStatItem
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x5052, 3
	GoToIfNe _cv_mastered_712
	SetFlag 0x22E8
	BufferTypeName 0, 0x5019
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mastered_712:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq GymSwitch_EventScript_Mastered
	HealParty
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_KeepGoing
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_713
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_714
_cv_yes_713:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_714:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymChallenge_EventScript_KeepGoing
	BufferInt 0, 0x504D
	BufferInt 1, 0x504E
	BufferInt 2, 0x504F
	BufferInt 3, 0x5050
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_TakeABreak
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymChallenge_EventScript_Lost:
	HealParty
	CompareVarToValue 0x5052, 0
	GoToIfEq _cv_gline_716
	CompareVarToValue 0x5052, 3
	GoToIfEq _cv_gline_717
	CompareVarToValue 0x5053, 0
	GoToIfNe _cv_next_719
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_win_0
	WaitButton
	GoTo _cv_done_718
_cv_next_719:
	CompareVarToValue 0x5053, 1
	GoToIfNe _cv_next_720
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_win_1
	WaitButton
	GoTo _cv_done_718
_cv_next_720:
	CompareVarToValue 0x5053, 2
	GoToIfNe _cv_next_721
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_win_2
	WaitButton
	GoTo _cv_done_718
_cv_next_721:
	CompareVarToValue 0x5053, 3
	GoToIfNe _cv_next_722
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_win_3
	WaitButton
	GoTo _cv_done_718
_cv_next_722:
	CompareVarToValue 0x5053, 4
	GoToIfNe _cv_next_723
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_win_4
	WaitButton
	GoTo _cv_done_718
_cv_next_723:
	CompareVarToValue 0x5053, 5
	GoToIfNe _cv_next_724
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_win_5
	WaitButton
	GoTo _cv_done_718
_cv_next_724:
	CompareVarToValue 0x5053, 6
	GoToIfNe _cv_next_725
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_win_6
	WaitButton
	GoTo _cv_done_718
_cv_next_725:
	CompareVarToValue 0x5053, 8
	GoToIfNe _cv_next_726
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_win_8
	WaitButton
	GoTo _cv_done_718
_cv_next_726:
	CompareVarToValue 0x5053, 9
	GoToIfNe _cv_next_727
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_win_9
	WaitButton
	GoTo _cv_done_718
_cv_next_727:
	CompareVarToValue 0x5053, 10
	GoToIfNe _cv_next_728
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_win_10
	WaitButton
	GoTo _cv_done_718
_cv_next_728:
	CompareVarToValue 0x5053, 11
	GoToIfNe _cv_next_729
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_win_11
	WaitButton
	GoTo _cv_done_718
_cv_next_729:
_cv_done_718:
	GoTo _cv_gline_715
_cv_gline_717:
	BufferTypeName 1, 0x5019
	CopyVar 0x401E, 0x504D
	BufferInt 2, 0x401E
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_boss_win
	WaitButton
	GoTo _cv_gline_715
_cv_gline_716:
	CompareVarToValue 0x5059, 0
	GoToIfNe _cv_next_730
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_gym_win_0
	WaitButton
	GoTo _cv_gline_715
_cv_next_730:
	CompareVarToValue 0x5059, 1
	GoToIfNe _cv_next_731
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_gym_win_1
	WaitButton
	GoTo _cv_gline_715
_cv_next_731:
	CompareVarToValue 0x5059, 2
	GoToIfNe _cv_next_732
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_gym_win_2
	WaitButton
	GoTo _cv_gline_715
_cv_next_732:
	CompareVarToValue 0x5059, 3
	GoToIfNe _cv_next_733
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_gym_win_3
	WaitButton
	GoTo _cv_gline_715
_cv_next_733:
_cv_gline_715:
	AddVar 0x5050, 1
	CopyVar 0x5062, 0x5060
	CopyVar 0x5063, 0x5061
	CopyVar 0x5060, 0x505E
	CopyVar 0x5061, 0x505F
	CopyVar 0x505E, 0x505C
	CopyVar 0x505F, 0x505D
	CompareVarToValue 0x5052, 0
	GoToIfNe _cv_loss_734
	CopyVar 0x505C, 0x5054
	CopyVar 0x505D, 0x5055
	GoTo _cv_loss_735
_cv_loss_734:
	CopyVar 0x505C, 0x5053
	AddVar 0x505C, 100
_cv_loss_735:
	CompareVarToValue 0x505B, 4
	GoToIfGe _cv_loss_735_full
	AddVar 0x505B, 1
_cv_loss_735_full:
	BufferInt 0, 0x504D
	BufferInt 1, 0x504E
	CompareVarToValue 0x5052, 0
	GoToIfEq _cv_gname_736
	CompareVarToValue 0x5053, 0
	GoToIfNe _cv_next_739
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_0
	GoTo _cv_done_738
_cv_next_739:
	CompareVarToValue 0x5053, 1
	GoToIfNe _cv_next_740
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_1
	GoTo _cv_done_738
_cv_next_740:
	CompareVarToValue 0x5053, 2
	GoToIfNe _cv_next_741
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_2
	GoTo _cv_done_738
_cv_next_741:
	CompareVarToValue 0x5053, 3
	GoToIfNe _cv_next_742
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_3
	GoTo _cv_done_738
_cv_next_742:
	CompareVarToValue 0x5053, 4
	GoToIfNe _cv_next_743
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_4
	GoTo _cv_done_738
_cv_next_743:
	CompareVarToValue 0x5053, 5
	GoToIfNe _cv_next_744
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_5
	GoTo _cv_done_738
_cv_next_744:
	CompareVarToValue 0x5053, 6
	GoToIfNe _cv_next_745
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_6
	GoTo _cv_done_738
_cv_next_745:
	CompareVarToValue 0x5053, 8
	GoToIfNe _cv_next_746
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_8
	GoTo _cv_done_738
_cv_next_746:
	CompareVarToValue 0x5053, 9
	GoToIfNe _cv_next_747
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_9
	GoTo _cv_done_738
_cv_next_747:
	CompareVarToValue 0x5053, 10
	GoToIfNe _cv_next_748
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_10
	GoTo _cv_done_738
_cv_next_748:
	CompareVarToValue 0x5053, 11
	GoToIfNe _cv_next_749
	CanvasBufferMsg 2, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_famous_11
	GoTo _cv_done_738
_cv_next_749:
_cv_done_738:
	GoTo _cv_gname_737
_cv_gname_736:
	CanvasCandidate 16, 2, 0x5055
_cv_gname_737:
	CopyVar 0x5064, 0x504D
	SetVar 0x504D, 0
	SetVar 0x5051, 0
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_751
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_normal
	GoTo _cv_done_750
_cv_next_751:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_752
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_fighting
	GoTo _cv_done_750
_cv_next_752:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_753
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_flying
	GoTo _cv_done_750
_cv_next_753:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_754
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_poison
	GoTo _cv_done_750
_cv_next_754:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_755
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_ground
	GoTo _cv_done_750
_cv_next_755:
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_756
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_rock
	GoTo _cv_done_750
_cv_next_756:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_757
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_bug
	GoTo _cv_done_750
_cv_next_757:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_758
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_ghost
	GoTo _cv_done_750
_cv_next_758:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_759
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_steel
	GoTo _cv_done_750
_cv_next_759:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_760
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_fire
	GoTo _cv_done_750
_cv_next_760:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_761
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_water
	GoTo _cv_done_750
_cv_next_761:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_762
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_grass
	GoTo _cv_done_750
_cv_next_762:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_763
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_electric
	GoTo _cv_done_750
_cv_next_763:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_764
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_psychic
	GoTo _cv_done_750
_cv_next_764:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_765
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_ice
	GoTo _cv_done_750
_cv_next_765:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_766
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_dragon
	GoTo _cv_done_750
_cv_next_766:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_767
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_dark
	GoTo _cv_done_750
_cv_next_767:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_768
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_fairy
	GoTo _cv_done_750
_cv_next_768:
_cv_done_750:
	CanvasCandidate 20, 0x5019
	PlayFanfare SEQ_ME_BADGE
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_AwardBadge
	WaitButton
	WaitFanfare
	CanvasCandidate 21
	Call GymChallenge_EventScript_ChallengerLeaves
	BufferInt 0, 0x5064
	BufferInt 1, 0x504E
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_Lost
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymPractice_EventScript_NotNow:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymPractice_Text_NotNow
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymPractice_EventScript_Won:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymPractice_Text_Won
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Gauntlet_EventScript_PilotMenu:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_PilotMenu
	CompareVarToValue 0x501C, 0
	GoToIfNe Gauntlet_EventScript_PilotMenuWithdraw
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptSim, 0
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptOff, 1
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_770
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_770:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Tourney_EventScript_Menu
	GoTo Gauntlet_EventScript_PilotOff
	
Gauntlet_EventScript_Withdraw:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_WithdrawWhich
	// TODO(gba) special Gauntlet_ChooseWithdraw
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, SPECIES_NONE
	GoToIfEq Gauntlet_EventScript_PilotMenu
	CopyVar 0x8005, VAR_SPECIAL_RESULT
	BufferSpeciesName 0, 0x8005, 0, 0
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_WithdrawConfirm
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_771
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_772
_cv_yes_771:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_772:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Gauntlet_EventScript_Withdraw
	GiveMon 0x8005, 70, 0, 0, 0, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq Gauntlet_EventScript_NoRoom
	CopyVar 0x8006, VAR_SPECIAL_RESULT
	// TODO(gba) special Gauntlet_UseWithdraw
	GoTo _cv_stop
	PlayFanfare SEQ_ME_ITEM
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Withdrew
	WaitFanfare
	CompareVarToValue 0x8006, 1
	CallIfEq Gauntlet_EventScript_SentToPC
	GoTo Gauntlet_EventScript_PilotMenu
	
Gauntlet_EventScript_BillAgain:
	PlayBGM SEQ_GS_D_AJITO
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_BillAgain
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_773
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_774
_cv_yes_773:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_774:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Gauntlet_EventScript_BillWait
	GoTo Gauntlet_EventScript_BillBattle
	
Gauntlet_EventScript_NotYet:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_NotYet
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Gauntlet_EventScript_BillBattle:
	HealParty
	// TODO(gba) special Gauntlet_SetupBill
	GoTo _cv_stop
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_gGymChallengeIntroText
	WaitButton
	CanvasCloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special Gauntlet_ShowBillCard
	GoTo _cv_stop
	ClearTrainerFlag 1442
	SetFlag 0x2036
	CanvasCloseMsg
	TrainerBattle 1442, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_776
	WhiteOut
	End
_cv_won_776:
	SetTrainerFlag 1442
	ClearFlag 0x2036
	GetStaticEncounterOutcome VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfNe _cv_outcome_777
	SetVar VAR_SPECIAL_RESULT, 7
	GoTo _cv_outcome_778
_cv_outcome_777:
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfNe _cv_outcome_778
	SetVar VAR_SPECIAL_RESULT, 4
_cv_outcome_778:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Gauntlet_EventScript_BillWon
	HealParty
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_gGymChallengeWinText
	WaitButton
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_BillLost
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Tourney_EventScript_MenuActive:
	// TODO(gba) special Tourney_SetupNext
	GoTo _cv_stop
	Call Tourney_EventScript_SayNext
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptNext, 0
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptBoard, 1
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptForfeit, 2
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptNotNow, 3
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_780
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_780:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Tourney_EventScript_Match
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Tourney_EventScript_Board
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq Tourney_EventScript_Forfeit
	GoTo Tourney_EventScript_NotNow
	
Tourney_EventScript_MenuSimBill:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimBillMenu
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptBill, 0
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptBoard, 1
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptNotNow, 2
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_782
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_782:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Tourney_EventScript_SimBill
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Tourney_EventScript_Board
	GoTo Tourney_EventScript_NotNow
	
Tourney_EventScript_MenuFirst:
	Call Tourney_EventScript_SayAsk
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptEnter, 0
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptNotNow, 1
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_784
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_784:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Tourney_EventScript_Enter
	GoTo Tourney_EventScript_NotNow
	
Tourney_EventScript_SayAsk:
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SayAskSim
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_FigureAsk
	Return
	
Tourney_EventScript_Enter:
	Call Tourney_EventScript_SayRules
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Tourney_EventScript_NotNow
	// TODO(gba) special Tourney_CheckClauses
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe Tourney_EventScript_BreaksClause
	CompareVarToValue 0x501B, 4
	CallIfEq Tourney_EventScript_SimFormat
	// TODO(gba) special Tourney_Begin
	GoTo _cv_stop
	Call Tourney_EventScript_SayDraw
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special Tourney_ShowBoard
	GoTo _cv_stop
	// TODO(gba) special Tourney_SetupNext
	GoTo _cv_stop
	Call Tourney_EventScript_SayFirst
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Tourney_EventScript_NotNow
	GoTo Tourney_EventScript_Match
	
Tourney_EventScript_LastResults:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special Tourney_ShowBoard
	GoTo _cv_stop
	// TODO(gba) special Tourney_BufferChampion
	GoTo _cv_stop
	Call Tourney_EventScript_SayChampion
	GoTo Tourney_EventScript_Menu
	
Tourney_EventScript_NotNow:
	CompareVarToValue 0x501B, 4
	GoToIfEq Gauntlet_EventScript_PilotOff
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_NotNow
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymChallenge_EventScript_StatueNoLeader:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_StatueNoLeader
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymChallenge_EventScript_StatueUnbeaten:
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_StatueUnbeaten
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymDecor_EventScript_Buy:
	SetVar 0x8007, 0
	ShowMoneyBox 20, 2
	GoTo GymDecor_EventScript_BuyCategory
	
GymDecor_EventScript_Sell:
	SetVar 0x8007, 0
	ShowMoneyBox 20, 2
	GoTo GymDecor_EventScript_SellCategory
	
GymDecor_EventScript_Decorate:
	// TODO(gba) special GymDecor_PushOwnedCategories
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymDecor_EventScript_NothingOwned
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_WhichKindToPlace
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_786
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_786:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq GymDecor_EventScript_PCMenu
	CopyVar 0x8006, VAR_SPECIAL_RESULT
	// TODO(gba) special GymDecor_PushOwnedList
	GoTo _cv_stop
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_WhichToPlace
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_788
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_788:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq GymDecor_EventScript_Decorate
	CopyVar 0x8004, VAR_SPECIAL_RESULT
	// TODO(gba) special GymDecor_GetKind
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfEq GymDecor_EventScript_SetWallStyle
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfEq GymDecor_EventScript_HowToPaint
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_HowToDecorate
	WaitButton
	GoTo GymDecor_EventScript_StartEditing
	
GymDecor_EventScript_PutAllAway:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_ConfirmPutAllAway
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_789
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_790
_cv_yes_789:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_790:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymDecor_EventScript_PCMenu
	// TODO(gba) special GymDecor_PutAllAway
	GoTo _cv_stop
	PlaySE SEQ_SE_DP_SELECT
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_AllPutAway
	WaitButton
	GoTo GymDecor_EventScript_PCMenu
	CloseMsg
	End
	
GymDecor_EventScript_LogOff:
	PlaySE SEQ_SE_DP_SELECT
	CanvasCloseMsg
	CanvasCloseMsg
	ReleaseAll
	End
	
EventScript_SetReadyTryGiveNationalDexScene:
	SetVar 0x5007, 2
	Return
	
GymLegend_EventScript_Arrives:
	Call GymLegend_EventScript_Appears
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymLegend_EventScript_Return
	PlaySE SEQ_SE_DP_SELECT
	ApplyMovement obj_player, Common_Movement_ExclamationMark
	ApplyMovement 1, Common_Movement_ExclamationMark
	WaitMovement
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymLegend_Text_OakWhatOnEarth
	WaitButton
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_792
	GoToIfUnset 0x22F5, _cv_owned_791
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_owned_791
_cv_next_792:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_793
	GoToIfUnset 0x22F6, _cv_owned_791
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_owned_791
_cv_next_793:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_794
	GoToIfUnset 0x22F7, _cv_owned_791
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_owned_791
_cv_next_794:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_795
	GoToIfUnset 0x22F8, _cv_owned_791
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_owned_791
_cv_next_795:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_796
	GoToIfUnset 0x22F9, _cv_owned_791
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_owned_791
_cv_next_796:
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_797
	GoToIfUnset 0x22FA, _cv_owned_791
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_owned_791
_cv_next_797:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_798
	GoToIfUnset 0x22FB, _cv_owned_791
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_owned_791
_cv_next_798:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_799
	GoToIfUnset 0x22FC, _cv_owned_791
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_owned_791
_cv_next_799:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_800
	GoToIfUnset 0x22FD, _cv_owned_791
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_owned_791
_cv_next_800:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_801
	GoToIfUnset 0x22FE, _cv_owned_791
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_owned_791
_cv_next_801:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_802
	GoToIfUnset 0x22FF, _cv_owned_791
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_owned_791
_cv_next_802:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_803
	GoToIfUnset 0x2300, _cv_owned_791
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_owned_791
_cv_next_803:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_804
	GoToIfUnset 0x2301, _cv_owned_791
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_owned_791
_cv_next_804:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_805
	GoToIfUnset 0x2302, _cv_owned_791
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_owned_791
_cv_next_805:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_806
	GoToIfUnset 0x2303, _cv_owned_791
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_owned_791
_cv_next_806:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_807
	GoToIfUnset 0x2304, _cv_owned_791
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_owned_791
_cv_next_807:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_808
	GoToIfUnset 0x2305, _cv_owned_791
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_owned_791
_cv_next_808:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_809
	GoToIfUnset 0x2306, _cv_owned_791
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_owned_791
_cv_next_809:
_cv_owned_791:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymLegend_EventScript_OakCatchAnother
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymLegend_Text_OakCatchIt
	WaitButton
	Return
	
EventScript_PalmPilotReturn:
	Return
	
GymLegend_EventScript_RivalAppears:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	CanvasCandidate 1
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymLegend_EventScript_RivalNoRoom
	CopyVar 0x401E, 0x8005
	CopyVar 0x401F, 0x8006
	MovePerson 2, 0x401E, 0x401F
	ClearFlag 0x2033
	GoToIfUnset 0x2033, _cv_show_810
	ClearFlag 0x2033
	ShowPerson 2
	SetFlag 0x2033
	GoTo _cv_shown_811
_cv_show_810:
	ShowPerson 2
_cv_shown_811:
	CanvasCandidate 2, 0x800A
	GoTo GymLegend_EventScript_RivalNoRoom
	
GymLegend_EventScript_RivalVanishes:
	HidePerson 2
	SetFlag 0x2033
	PlaySE SEQ_SE_DP_KAIDAN2
	CanvasCandidate 3
	ResetBGM
	Return
	
GymLegend_EventScript_NoLegend:
	SetVar 0x5014, 4
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo GymLegend_EventScript_Return
	
GymCandidate_EventScript_MentorAppears:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	CanvasCandidate 1
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_MentorNoRoom
	MovePerson 0x800A, 0x8005, 0x8006
	ClearFlag 0x2017
	ShowPerson 0x800A
	CanvasCandidate 2, 0x800A
	GoTo GymCandidate_EventScript_MentorNoRoom
	
GymCandidate_EventScript_GuestLeaves:
	CanvasCloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	HidePerson 0x800A
	SetFlag 0x2017
	CanvasCandidate 3
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	Return
	
EventScript_GymHack_ShowTeamRuleMessage:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq EventScript_GymHack_MsgWrongType
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	CallIfEq EventScript_GymHack_MsgDuplicate
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	CallIfEq EventScript_GymHack_MsgDuplicateItem
	Return
	
GymFinale_EventScript_OakRulesMsg:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_OakRulesStillApply
	WaitButton
	Return
	
GymFinale_EventScript_HallOfFame:
	Call EventScript_SetDefeatedEliteFourFlagsVars
	SetFlag 0x2008
	SetVar 0x5004, 3
	Call GymFinale_EventScript_Badge
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_OakHallOfFame
	WaitButton
	CanvasCloseMsg
	SetVar 0x5005, 4
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	CanvasHallOfFame
	RestoreOverworld
	SetVar 0x502E, 1
	Warp MAP_INDIGO_PLATEAU, 0, 978, 108, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	CanvasCloseMsg
	ReleaseAll
	End
	
GymFinale_EventScript_Badge:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_813
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_normal
	GoTo _cv_done_812
_cv_next_813:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_814
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_fighting
	GoTo _cv_done_812
_cv_next_814:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_815
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_flying
	GoTo _cv_done_812
_cv_next_815:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_816
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_poison
	GoTo _cv_done_812
_cv_next_816:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_817
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_ground
	GoTo _cv_done_812
_cv_next_817:
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_818
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_rock
	GoTo _cv_done_812
_cv_next_818:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_819
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_bug
	GoTo _cv_done_812
_cv_next_819:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_820
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_ghost
	GoTo _cv_done_812
_cv_next_820:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_821
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_steel
	GoTo _cv_done_812
_cv_next_821:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_822
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_fire
	GoTo _cv_done_812
_cv_next_822:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_823
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_water
	GoTo _cv_done_812
_cv_next_823:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_824
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_grass
	GoTo _cv_done_812
_cv_next_824:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_825
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_electric
	GoTo _cv_done_812
_cv_next_825:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_826
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_psychic
	GoTo _cv_done_812
_cv_next_826:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_827
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_ice
	GoTo _cv_done_812
_cv_next_827:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_828
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_dragon
	GoTo _cv_done_812
_cv_next_828:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_829
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_dark
	GoTo _cv_done_812
_cv_next_829:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_830
	CanvasBufferMsg 0, msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_badge_fairy
	GoTo _cv_done_812
_cv_next_830:
_cv_done_812:
	CanvasCandidate 20, 0x5019
	PlayFanfare SEQ_ME_BADGE
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymFinale_Text_YourBadge
	WaitButton
	WaitFanfare
	CanvasCandidate 21
	Return
	
GymChallenge_EventScript_ChallengerLeaves:
	CanvasCloseMsg
	SetVar 0x8004, 1
	CompareVarToValue 0x8004, 1
	GoToIfEq _cv_cwalk_831
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	CanvasCandidate 4, 1
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_cwalk_832
	CanvasCandidate 17, 4, 0x8005, 0x8006
	GoTo _cv_cwalk_832
_cv_cwalk_831:
	CanvasCandidate 6
_cv_cwalk_832:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymChallenge_EventScript_ChallengerGone
	CompareVarToValue 0x8004, 1
	GoToIfEq _cv_capply_833
	CanvasCandidate 5, 4, 0
	WaitMovement
	CanvasCandidate 2, 4
	GoTo _cv_capply_834
_cv_capply_833:
	CanvasCandidate 5, 4, 1
	WaitMovement
_cv_capply_834:
	PlaySE SEQ_SE_DP_KAIDAN2
	GoTo GymChallenge_EventScript_ChallengerGone
	
GymChallenge_EventScript_NewRecord:
	PlayFanfare SEQ_ME_LVUP
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_NewRecord
	WaitButton
	WaitFanfare
	Return
	
GymChallenge_EventScript_RareGift:
	PlaySE SEQ_SE_DP_SELECT
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymChallenge_Text_RareGift
	WaitButton
	Return
	
GymHack_EventScript_GiveStatItem:
	SetOrCopyVar 0x8004, 0x8009
	SetOrCopyVar 0x8005, 1
	HasSpaceForItem 0x8004, 0x8005, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_full_835
	CallStd std_give_item_verbose
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_given_836
_cv_full_835:
	SetVar VAR_SPECIAL_RESULT, 0
_cv_given_836:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymHack_EventScript_GiveStatItemDone
	BufferItemName 1, 0x8009
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymHack_Text_GiftSentToPC
	WaitButton
	GoTo GymHack_EventScript_GiveStatItemDone
	
GymSwitch_EventScript_Mastered:
	PlayFanfare SEQ_ME_ITEM
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymSwitch_Text_Mastered
	WaitButton
	WaitFanfare
	Return
	
GymChallenge_EventScript_KeepGoing:
	CanvasCloseMsg
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	GoTo GymChallenge_EventScript_NextChallenger
	End
	
Gauntlet_EventScript_PilotMenuWithdraw:
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptWithdraw, 0
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptSim, 1
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptOff, 2
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_838
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_838:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Gauntlet_EventScript_Withdraw
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Tourney_EventScript_Menu
	GoTo Gauntlet_EventScript_PilotOff
	
Gauntlet_EventScript_PilotOff:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_PilotOff
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Gauntlet_EventScript_NoRoom:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_NoRoom
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Gauntlet_EventScript_SentToPC:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SentToPC
	WaitButton
	Return
	
Gauntlet_EventScript_BillWait:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_BillWait
	WaitButton
	ResetBGM
	CloseMsg
	ReleaseAll
	End
	
Gauntlet_EventScript_BillWon:
	HealParty
	PlayBGM SEQ_GS_D_AJITO
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_gGymChallengeAfterText
	WaitButton
	BufferPlayersName 6
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_BillLast
	WaitButton
	CanvasCloseMsg
	ApplyMovement 17, Gauntlet_Movement_Collapse
	WaitMovement
	PlayCry SPECIES_CLEFABLE, 0
	WaitCry
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special Gauntlet_BillDefeated
	GoTo _cv_stop
	HidePerson 17
	SetFlag 0x2035
	GoToIfUnset 0x2035, _cv_show_839
	ClearFlag 0x2035
	ShowPerson 17
	SetFlag 0x2035
	GoTo _cv_shown_840
_cv_show_839:
	ShowPerson 17
_cv_shown_840:
	Wait 60, VAR_SPECIAL_RESULT
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Faded
	WaitButton
	// TODO(gba) special Overworld_PlaySpecialMapMusic
	GoTo _cv_stop
	CloseMsg
	ReleaseAll
	End
	
Tourney_EventScript_SayNext:
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SayNextSim
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Next
	Return
	
Tourney_EventScript_Match:
	// TODO(gba) special Tourney_CheckTeam
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Tourney_EventScript_WrongTeam
	// TODO(gba) special Tourney_CheckClauses
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe Tourney_EventScript_BreaksClause
	HealParty
	SetVar VAR_SPECIAL_RESULT, 1
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymChallenge_EventScript_CantReachSpot
	Call Tourney_EventScript_SayTakeYourPlace
	CanvasCloseMsg
	ApplyMovement obj_player, gGymChallengePlayerPath
	WaitMovement
	GoTo Tourney_EventScript_NextMatch
	
Tourney_EventScript_Board:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special Tourney_ShowBoard
	GoTo _cv_stop
	GoTo Tourney_EventScript_Menu
	
Tourney_EventScript_Forfeit:
	Call Tourney_EventScript_SayForfeitAsk
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Tourney_EventScript_Menu
	// TODO(gba) special Tourney_Forfeit
	GoTo _cv_stop
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SimForfeited
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Forfeited
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Tourney_EventScript_SimBill:
	HealParty
	// TODO(gba) special Gauntlet_SetupBill
	GoTo _cv_stop
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimBillAnnounce
	WaitButton
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_gGymChallengeIntroText
	WaitButton
	CanvasCloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special Gauntlet_ShowBillCard
	GoTo _cv_stop
	ClearTrainerFlag 1442
	SetFlag 0x2036
	CanvasCloseMsg
	TrainerBattle 1442, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_842
	WhiteOut
	End
_cv_won_842:
	SetTrainerFlag 1442
	ClearFlag 0x2036
	GetStaticEncounterOutcome VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfNe _cv_outcome_843
	SetVar VAR_SPECIAL_RESULT, 7
	GoTo _cv_outcome_844
_cv_outcome_843:
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfNe _cv_outcome_844
	SetVar VAR_SPECIAL_RESULT, 4
_cv_outcome_844:
	HealParty
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Tourney_EventScript_SimBillWon
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimBillLost
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Tourney_EventScript_SayAskSim:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimAsk
	Return
	
Tourney_EventScript_SayRules:
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SayRulesSim
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Rules
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_845
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_846
_cv_yes_845:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_846:
	Return
	
Tourney_EventScript_BreaksClause:
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	CallIfEq Tourney_EventScript_SpeciesClause
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	CallIfEq Tourney_EventScript_ItemClause
	CanvasCloseMsg
	ReleaseAll
	End
	
Tourney_EventScript_SimFormat:
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimFormat
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 1, 0, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptSingles, 0
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptDoubles, 1
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_848
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_848:
	// TODO(gba) special Tourney_SetSimFormat
	GoTo _cv_stop
	CanvasCloseMsg
	Return
	
Tourney_EventScript_SayDraw:
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SayDrawSim
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Draw
	WaitButton
	Return
	
Tourney_EventScript_SayFirst:
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SayFirstSim
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_First
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_849
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_850
_cv_yes_849:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_850:
	Return
	
Tourney_EventScript_SayChampion:
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SayChampionSim
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Champion
	WaitButton
	Return
	
GymDecor_EventScript_BuyCategory:
	// TODO(gba) special GymDecor_PushShopCategories
	GoTo _cv_stop
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_WhichKind
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_852
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_852:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq GymDecor_EventScript_BuyDone
	CopyVar 0x8006, VAR_SPECIAL_RESULT
	CopyVar 0x8007, VAR_SPECIAL_RESULT
	SetVar 0x8005, 0
	GoTo GymDecor_EventScript_BuyLoop
	
GymDecor_EventScript_SellCategory:
	// TODO(gba) special GymDecor_PushSellCategories
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymDecor_EventScript_NothingToSell
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_WhichKindToSell
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_854
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_854:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq GymDecor_EventScript_SellDone
	CopyVar 0x8006, VAR_SPECIAL_RESULT
	CopyVar 0x8007, VAR_SPECIAL_RESULT
	SetVar 0x8005, 0
	GoTo GymDecor_EventScript_SellLoop
	
GymDecor_EventScript_NothingOwned:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_NothingOwned
	WaitButton
	GoTo GymDecor_EventScript_PCMenu
	CloseMsg
	End
	
GymDecor_EventScript_SetWallStyle:
	// TODO(gba) special GymDecor_ApplyWallStyle
	GoTo _cv_stop
	// TODO(gba) special GymDecor_BufferDecorInfo
	GoTo _cv_stop
	PlaySE SEQ_SE_DP_SELECT
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_WallsChanged
	WaitButton
	GoTo GymDecor_EventScript_PCMenu
	CloseMsg
	End
	
GymDecor_EventScript_HowToPaint:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_HowToPaint
	WaitButton
	GoTo GymDecor_EventScript_StartEditing
	CloseMsg
	End
	
GymDecor_EventScript_StartEditing:
	CanvasCloseMsg
	CanvasCloseMsg
	ReleaseAll
	// TODO(gba) special GymDecor_StartEditing
	GoTo _cv_stop
	End
	
GymLegend_EventScript_Return:
	Return
	
GymLegend_EventScript_OakCatchAnother:
	BufferPlayersName 6
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymLegend_Text_OakCatchAnother
	WaitButton
	Return
	
GymLegend_EventScript_RivalNoRoom:
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	Return
	
GymCandidate_EventScript_MentorNoRoom:
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	Return
	
EventScript_GymHack_MsgWrongType:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Text_GymHack_WrongType
	WaitButton
	Return
	
EventScript_GymHack_MsgDuplicate:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Text_GymHack_Duplicate
	WaitButton
	Return
	
EventScript_GymHack_MsgDuplicateItem:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Text_GymHack_DuplicateItem
	WaitButton
	Return
	
EventScript_SetDefeatedEliteFourFlagsVars:
	ClearFlag 0x203C
	Call EventScript_ResetEliteFour
	CompareVarToValue 0x5004, 0
	CallIfEq EventScript_GymHack_StartGymFinale
	CompareVarToValue 0x5004, 3
	CallIfEq EventScript_TryReadyNationalDexScene
	Call EventScript_ResetLegendaries
	Return
	
GymChallenge_EventScript_ChallengerGone:
	HidePerson 4
	SetFlag 0x2017
	SetFlag 0x2017
	Return
	
GymHack_EventScript_GiveStatItemDone:
	Return
	
Tourney_EventScript_SayNextSim:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimNext
	Return
	
Tourney_EventScript_WrongTeam:
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SimWrongTeam
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_WrongTeam
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Tourney_EventScript_SayTakeYourPlace:
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_Return
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_TakeYourPlace
	WaitButton
	GoTo Tourney_EventScript_Return
	
Tourney_EventScript_NextMatch:
	// TODO(gba) special Tourney_SetupNext
	GoTo _cv_stop
	Call Tourney_EventScript_SayAnnounce
	CanvasCloseMsg
	ClearFlag 0x2017
	GoToIfUnset 0x2017, _cv_show_855
	ClearFlag 0x2017
	ShowPerson 4
	SetFlag 0x2017
	GoTo _cv_shown_856
_cv_show_855:
	ShowPerson 4
_cv_shown_856:
	SetVar 0x8004, 0
	CompareVarToValue 0x8004, 1
	GoToIfEq _cv_cwalk_857
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	CanvasCandidate 4, 1
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_cwalk_858
	CanvasCandidate 17, 4, 0x8005, 0x8006
	GoTo _cv_cwalk_858
_cv_cwalk_857:
	CanvasCandidate 6
_cv_cwalk_858:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	CallIfEq GymChallenge_EventScript_ChallengerJumpsIn
	ApplyMovement 4, gGymChallengeChallengerPath
	WaitMovement
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_gGymChallengeIntroText
	WaitButton
	CanvasCloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special Tourney_ShowTitleCard
	GoTo _cv_stop
	ClearTrainerFlag 1442
	SetFlag 0x2036
	CanvasCloseMsg
	TrainerBattle 1442, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_860
	WhiteOut
	End
_cv_won_860:
	SetTrainerFlag 1442
	ClearFlag 0x2036
	GetStaticEncounterOutcome VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfNe _cv_outcome_861
	SetVar VAR_SPECIAL_RESULT, 7
	GoTo _cv_outcome_862
_cv_outcome_861:
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfNe _cv_outcome_862
	SetVar VAR_SPECIAL_RESULT, 4
_cv_outcome_862:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Tourney_EventScript_Won
	HealParty
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_gGymChallengeWinText
	WaitButton
	Call GymChallenge_EventScript_ChallengerLeaves
	// TODO(gba) special Tourney_RecordLoss
	GoTo _cv_stop
	Call Tourney_EventScript_SayLost
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special Tourney_ShowBoard
	GoTo _cv_stop
	// TODO(gba) special Tourney_BufferChampion
	GoTo _cv_stop
	Call Tourney_EventScript_SayChampion
	CloseMsg
	ReleaseAll
	End
	
Tourney_EventScript_SayForfeitAsk:
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SayForfeitAskSim
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_ForfeitAsk
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_863
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_864
_cv_yes_863:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_864:
	Return
	
Tourney_EventScript_SimForfeited:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimForfeited
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Tourney_EventScript_SimBillWon:
	// TODO(gba) special Tourney_SimBillWon
	GoTo _cv_stop
	PlayFanfare SEQ_ME_ITEM
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimComplete
	WaitFanfare
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_WithdrawAsk
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_865
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_866
_cv_yes_865:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_866:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Gauntlet_EventScript_Withdraw
	CloseMsg
	ReleaseAll
	End
	
Tourney_EventScript_SayRulesSim:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimStart
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_867
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_868
_cv_yes_867:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_868:
	Return
	
Tourney_EventScript_SpeciesClause:
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SimSpeciesClause
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SpeciesClause
	WaitButton
	Return
	
Tourney_EventScript_ItemClause:
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SimItemClause
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_ItemClause
	WaitButton
	Return
	
Tourney_EventScript_SayDrawSim:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimDraw
	WaitButton
	Return
	
Tourney_EventScript_SayFirstSim:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimFirst
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_869
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_870
_cv_yes_869:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_870:
	Return
	
Tourney_EventScript_SayChampionSim:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimChampion
	WaitButton
	Return
	
GymDecor_EventScript_BuyDone:
	HideMoneyBox
	GoTo GymDecor_EventScript_PCMenu
	End
	
GymDecor_EventScript_BuyLoop:
	// TODO(gba) special GymDecor_PushShopList
	GoTo _cv_stop
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_WhichToBuy
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_872
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_872:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq GymDecor_EventScript_BuyCategory
	CopyVar 0x8004, VAR_SPECIAL_RESULT
	CopyVar 0x8005, VAR_SPECIAL_RESULT
	SetVar 0x8009, 1
	// TODO(gba) special GymDecor_GetKind
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfGe GymDecor_EventScript_ConfirmBuy
	// TODO(gba) special GymDecor_BufferDecorInfo
	GoTo _cv_stop
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_HowMany
	// TODO(gba) special GymDecor_ChooseQuantity
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymDecor_EventScript_BuyLoop
	CopyVar 0x8009, VAR_SPECIAL_RESULT
	GoTo GymDecor_EventScript_ConfirmBuy
	
GymDecor_EventScript_NothingToSell:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_NothingToSell
	WaitButton
	GoTo GymDecor_EventScript_SellDone
	
GymDecor_EventScript_SellDone:
	HideMoneyBox
	GoTo GymDecor_EventScript_PCMenu
	End
	
GymDecor_EventScript_SellLoop:
	// TODO(gba) special GymDecor_PushSellList
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymDecor_EventScript_SellCategory
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_WhichToSell
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_874
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_874:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq GymDecor_EventScript_SellCategory
	CopyVar 0x8004, VAR_SPECIAL_RESULT
	CopyVar 0x8005, VAR_SPECIAL_RESULT
	SetVar 0x8009, 1
	// TODO(gba) special GymDecor_BufferSellInfo
	GoTo _cv_stop
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_HowManyToSell
	// TODO(gba) special GymDecor_ChooseSellQuantity
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymDecor_EventScript_SellLoop
	CopyVar 0x8009, VAR_SPECIAL_RESULT
	// TODO(gba) special GymDecor_BufferSellInfo
	GoTo _cv_stop
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_ConfirmSell
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_875
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_876
_cv_yes_875:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_876:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymDecor_EventScript_SellLoop
	// TODO(gba) special GymDecor_Sell
	GoTo _cv_stop
	UpdateMoneyBox
	PlaySE SEQ_SE_DP_SELECT
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_Sold
	WaitButton
	GoTo GymDecor_EventScript_SellLoop
	CloseMsg
	End
	
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
	
EventScript_ResetLegendaries:
	ClearFlag 0x2042
	ClearFlag 0x2043
	ClearFlag 0x2044
	Return
	
Tourney_EventScript_SimWrongTeam:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimWrongTeam
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Tourney_EventScript_Return:
	Return
	
Tourney_EventScript_SayAnnounce:
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SayAnnounceSim
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Announce
	WaitButton
	Return
	
Tourney_EventScript_Won:
	HealParty
	NPCMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_gGymChallengeAfterText
	WaitButton
	Call GymChallenge_EventScript_ChallengerLeaves
	// TODO(gba) special Tourney_RollPrize
	GoTo _cv_stop
	Call Tourney_EventScript_Prize
	// TODO(gba) special Tourney_RecordWin
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Tourney_EventScript_Title
	Call Tourney_EventScript_SayWon
	GoTo Tourney_EventScript_BetweenRounds
	
Tourney_EventScript_SayLost:
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SayLostSim
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Lost
	WaitButton
	Return
	
Tourney_EventScript_SayForfeitAskSim:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimForfeitAsk
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_877
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_878
_cv_yes_877:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_878:
	Return
	
Tourney_EventScript_SimSpeciesClause:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimSpeciesClause
	WaitButton
	Return
	
Tourney_EventScript_SimItemClause:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimItemClause
	WaitButton
	Return
	
GymDecor_EventScript_ConfirmBuy:
	// TODO(gba) special GymDecor_BufferDecorInfo
	GoTo _cv_stop
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_ConfirmBuy
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_879
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_880
_cv_yes_879:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_880:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymDecor_EventScript_BuyLoop
	// TODO(gba) special GymDecor_TryBuy
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymDecor_EventScript_NotEnoughMoney
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq GymDecor_EventScript_StorageFull
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfEq GymDecor_EventScript_AlreadyHave
	UpdateMoneyBox
	// TODO(gba) special GymDecor_BufferDecorInfo
	GoTo _cv_stop
	PlaySE SEQ_SE_DP_SELECT
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_Bought
	WaitButton
	GoTo GymDecor_EventScript_BuyLoop
	CloseMsg
	End
	
Tourney_EventScript_SayAnnounceSim:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimAnnounce
	WaitButton
	Return
	
Tourney_EventScript_Prize:
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq Tourney_EventScript_RarePrize
	CompareVarToValue 0x501B, 4
	CallIfEq Tourney_EventScript_PrizeSim
	CompareVarToValue 0x501B, 4
	CallIfNe Tourney_EventScript_PrizeReal
	Call GymHack_EventScript_GiveStatItem
	Return
	
Tourney_EventScript_Title:
	PlayFanfare SEQ_ME_ITEM
	BufferPlayersName 6
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Title
	WaitFanfare
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SimTitle
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_TitleHall
	WaitButton
	CompareVarToValue 0x501B, 3
	CallIfEq Tourney_EventScript_FirstTitle
	CloseMsg
	ReleaseAll
	End
	
Tourney_EventScript_SayWon:
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SayWonSim
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Won
	Return
	
Tourney_EventScript_BetweenRounds:
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptNext, 0
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptBoard, 1
	ScrCmd_559 msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_OptRest, 2
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_882
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_882:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Tourney_EventScript_Continue
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Tourney_EventScript_BoardBetween
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SimBreak
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_Break
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Tourney_EventScript_SayLostSim:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimLost
	WaitButton
	Return
	
GymDecor_EventScript_NotEnoughMoney:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_NotEnoughMoney
	WaitButton
	GoTo GymDecor_EventScript_BuyLoop
	CloseMsg
	End
	
GymDecor_EventScript_StorageFull:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_StorageFull
	WaitButton
	GoTo GymDecor_EventScript_BuyLoop
	CloseMsg
	End
	
GymDecor_EventScript_AlreadyHave:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_GymDecor_Text_AlreadyHave
	WaitButton
	GoTo GymDecor_EventScript_BuyLoop
	CloseMsg
	End
	
Tourney_EventScript_RarePrize:
	CompareVarToValue 0x501B, 4
	CallIfEq Tourney_EventScript_RarePrizeSim
	CompareVarToValue 0x501B, 4
	CallIfNe Tourney_EventScript_RarePrizeReal
	Call GymHack_EventScript_GiveStatItem
	Return
	
Tourney_EventScript_PrizeSim:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Tourney_Text_PrizeSim
	WaitButton
	Return
	
Tourney_EventScript_PrizeReal:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Tourney_Text_Prize
	WaitButton
	Return
	
Tourney_EventScript_SimTitle:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_TitleHall
	WaitButton
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimBillNext
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_883
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_884
_cv_yes_883:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_884:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Tourney_EventScript_SimBill
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimBillLater
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Tourney_EventScript_FirstTitle:
	PlaySE SEQ_SE_DP_SELECT
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_LastOne
	WaitButton
	Return
	
Tourney_EventScript_SayWonSim:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimWon
	Return
	
Tourney_EventScript_Continue:
	CanvasCloseMsg
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterDown
	WaitMovement
	GoTo Tourney_EventScript_NextMatch
	
Tourney_EventScript_BoardBetween:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special Tourney_ShowBoard
	GoTo _cv_stop
	Call Tourney_EventScript_SayNextQuestion
	GoTo Tourney_EventScript_BetweenRounds
	
Tourney_EventScript_SimBreak:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimBreak
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Tourney_EventScript_RarePrizeSim:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Tourney_Text_RarePrizeSim
	WaitButton
	Return
	
Tourney_EventScript_RarePrizeReal:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Tourney_Text_RarePrize
	WaitButton
	Return
	
Tourney_EventScript_SayNextQuestion:
	CompareVarToValue 0x501B, 4
	GoToIfEq Tourney_EventScript_SayNextQuestionSim
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_ContinueOrBreak
	Return
	
Tourney_EventScript_SayNextQuestionSim:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_Gauntlet_Text_SimContinue
	Return

_cv_unported_25:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	CanvasMsg msg_0856_CV_FIGHT_AREA_UNUSED_7_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
Common_Movement_WalkInPlaceFasterUp:
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterLeft:
	WalkOnSpotFasterWest
	EndMovement

	.balign 4, 0
Common_Movement_ExclamationMark:
	EmoteExclamationMark
	EndMovement

	.balign 4, 0
PalletTown_Gym_Movement_WatchRivalLeave:
	WalkOnSpotFasterEast
	Delay16
	WalkOnSpotFasterSouth
	EndMovement

	.balign 4, 0
PalletTown_Gym_Movement_RivalLeave:
	WalkNormalSouth
	WalkNormalWest
	WalkNormalSouth
	SetInvisible
	EndMovement

	.balign 4, 0
PalletTown_Gym_Movement_OakLeave:
	WalkNormalEast
	WalkNormalSouth 3
	WalkNormalWest
	WalkNormalSouth
	SetInvisible
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterDown:
	WalkOnSpotFasterSouth
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterRight:
	WalkOnSpotFasterEast
	EndMovement

	.balign 4, 0
GymFinale_Movement_PlayerLookAtAide:
	WalkOnSpotFasterEast
	EndMovement

	.balign 4, 0
Gauntlet_Movement_Collapse:
	WalkOnSpotSlowSouth
	Delay16
	WalkOnSpotSlowSouth
	Delay16
	FaceNorth
	Delay8
	FaceSouth
	Delay16
	EndMovement

	.balign 4, 0
gGymChallengePlayerPath:
	EndMovement

	.balign 4, 0
gGymChallengeChallengerPath:
	EndMovement
	.balign 4, 0
