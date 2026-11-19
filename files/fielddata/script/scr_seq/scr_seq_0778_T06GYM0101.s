#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T06GYM0101.h"
#include "msgdata/msg/msg_0485_T06GYM0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's VermilionCity_Gym_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef VermilionCity_Gym_EventScript_LtSurge
	ScrDef VermilionCity_Gym_EventScript_GymGuy
	ScrDef VermilionCity_Gym_EventScript_Tucker
	ScrDef GymAides_EventScript_VermilionCity
	ScrDef VermilionCity_Gym_EventScript_GymStatue
	ScrDef VermilionCity_Gym_EventScript_TrashCan1
	ScrDef VermilionCity_Gym_EventScript_TrashCan2
	ScrDef VermilionCity_Gym_EventScript_TrashCan3
	ScrDef VermilionCity_Gym_EventScript_TrashCan4
	ScrDef VermilionCity_Gym_EventScript_TrashCan5
	ScrDef VermilionCity_Gym_EventScript_TrashCan6
	ScrDef VermilionCity_Gym_EventScript_TrashCan7
	ScrDef VermilionCity_Gym_EventScript_TrashCan8
	ScrDef VermilionCity_Gym_EventScript_TrashCan9
	ScrDef VermilionCity_Gym_EventScript_TrashCan10
	ScrDef VermilionCity_Gym_EventScript_TrashCan11
	ScrDef VermilionCity_Gym_EventScript_TrashCan12
	ScrDef VermilionCity_Gym_EventScript_TrashCan13
	ScrDef VermilionCity_Gym_EventScript_TrashCan14
	ScrDef VermilionCity_Gym_EventScript_TrashCan15
	ScrDef VermilionCity_Gym_OnLoad
	ScrDef VermilionCity_Gym_OnTransition
	ScrDefEnd
	
VermilionCity_Gym_EventScript_LtSurge:
	SetVar 0x8009, 2
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_mentor_1
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_mentor_1
	SetVar 0x401F, 1
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_1:
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_mentor_2
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_mentor_2
	SetVar 0x401F, 2
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_2:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_mentor_3
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_mentor_3
	SetVar 0x401F, 3
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_3:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_mentor_4
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_mentor_4
	SetVar 0x401F, 4
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_4:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_mentor_5
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_mentor_5
	SetVar 0x401F, 5
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_5:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_mentor_6
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_mentor_6
	SetVar 0x401F, 6
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_6:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_mentor_7
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_mentor_7
	SetVar 0x401F, 7
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_7:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_mentor_8
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_mentor_8
	SetVar 0x401F, 8
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_8:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_mentor_9
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_mentor_9
	SetVar 0x401F, 9
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_9:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_mentor_10
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_mentor_10
	SetVar 0x401F, 10
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_10:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_mentor_11
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_mentor_11
	SetVar 0x401F, 11
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_11:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq VermilionCity_Gym_EventScript_MentorBattle
	CheckTrainerFlag 1152
	GoToIf TRUE, _cv_beaten_12
	NPCMsg msg_0485_T06GYM0101_VermilionCity_Gym_Text_LtSurgeIntro
	WaitButton
	CloseMsg
	TrainerBattle 1152, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_13
	WhiteOut
	End
_cv_won_13:
	SetTrainerFlag 1152
	GoTo VermilionCity_Gym_EventScript_DefeatedLtSurge
_cv_beaten_12:
	End
	
VermilionCity_Gym_EventScript_GymGuy:
	LockAll
	FacePlayer
	GoToIfSet 0x2125, VermilionCity_Gym_EventScript_GymGuyPostVictory
	NPCMsg msg_0485_T06GYM0101_VermilionCity_Gym_Text_GymGuyAdvice
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_Gym_EventScript_Tucker:
	CheckTrainerFlag 1159
	GoToIf TRUE, _cv_beaten_14
	NPCMsg msg_0485_T06GYM0101_VermilionCity_Gym_Text_TuckerIntro
	WaitButton
	CloseMsg
	TrainerBattle 1159, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_15
	WhiteOut
	End
_cv_won_15:
	SetTrainerFlag 1159
	GoTo VermilionCity_Gym_EventScript_DefeatedTucker
_cv_beaten_14:
	NPCMsg msg_0485_T06GYM0101_VermilionCity_Gym_Text_TuckerPostBattle
	WaitButton
	CloseMsg
	End
	
GymAides_EventScript_VermilionCity:
	GoToIfSet 0x208C, GymAides_EventScript_VermilionCityAfter
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0485_T06GYM0101_GymAides_Text_VermilionCity
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_Gym_EventScript_GymStatue:
	LockAll
	GoToIfSet 0x208C, VermilionCity_Gym_EventScript_GymStatuePostVictory
	BufferRivalsName 7
	NPCMsg msg_0485_T06GYM0101_VermilionCity_Gym_Text_GymStatue
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_Gym_EventScript_TrashCan1:
	LockAll
	SetVar 0x8008, 1
	GoTo VermilionCity_Gym_EventScript_TrashCan
	End
	
VermilionCity_Gym_EventScript_TrashCan2:
	LockAll
	SetVar 0x8008, 2
	GoTo VermilionCity_Gym_EventScript_TrashCan
	End
	
VermilionCity_Gym_EventScript_TrashCan3:
	LockAll
	SetVar 0x8008, 3
	GoTo VermilionCity_Gym_EventScript_TrashCan
	End
	
VermilionCity_Gym_EventScript_TrashCan4:
	LockAll
	SetVar 0x8008, 4
	GoTo VermilionCity_Gym_EventScript_TrashCan
	End
	
VermilionCity_Gym_EventScript_TrashCan5:
	LockAll
	SetVar 0x8008, 5
	GoTo VermilionCity_Gym_EventScript_TrashCan
	End
	
VermilionCity_Gym_EventScript_TrashCan6:
	LockAll
	SetVar 0x8008, 6
	GoTo VermilionCity_Gym_EventScript_TrashCan
	End
	
VermilionCity_Gym_EventScript_TrashCan7:
	LockAll
	SetVar 0x8008, 7
	GoTo VermilionCity_Gym_EventScript_TrashCan
	End
	
VermilionCity_Gym_EventScript_TrashCan8:
	LockAll
	SetVar 0x8008, 8
	GoTo VermilionCity_Gym_EventScript_TrashCan
	End
	
VermilionCity_Gym_EventScript_TrashCan9:
	LockAll
	SetVar 0x8008, 9
	GoTo VermilionCity_Gym_EventScript_TrashCan
	End
	
VermilionCity_Gym_EventScript_TrashCan10:
	LockAll
	SetVar 0x8008, 10
	GoTo VermilionCity_Gym_EventScript_TrashCan
	End
	
VermilionCity_Gym_EventScript_TrashCan11:
	LockAll
	SetVar 0x8008, 11
	GoTo VermilionCity_Gym_EventScript_TrashCan
	End
	
VermilionCity_Gym_EventScript_TrashCan12:
	LockAll
	SetVar 0x8008, 12
	GoTo VermilionCity_Gym_EventScript_TrashCan
	End
	
VermilionCity_Gym_EventScript_TrashCan13:
	LockAll
	SetVar 0x8008, 13
	GoTo VermilionCity_Gym_EventScript_TrashCan
	End
	
VermilionCity_Gym_EventScript_TrashCan14:
	LockAll
	SetVar 0x8008, 14
	GoTo VermilionCity_Gym_EventScript_TrashCan
	End
	
VermilionCity_Gym_EventScript_TrashCan15:
	LockAll
	SetVar 0x8008, 15
	GoTo VermilionCity_Gym_EventScript_TrashCan
	End
	
VermilionCity_Gym_OnLoad:
	CallIfSet 1, VermilionCity_Gym_EventScript_SetOneBeamOff
	CallIfSet 0x2126, VermilionCity_Gym_EventScript_SetBeamsOff
	End
	
VermilionCity_Gym_OnTransition:
	SetFlag 0x2017
	Call VermilionCity_Gym_EventScript_InitTrashCans
	End
	
VermilionCity_Gym_EventScript_MentorBattle:
	CheckTrainerFlag 1152
	GoToIf TRUE, _cv_beaten_16
	TrainerBattle 1152, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_17
	WhiteOut
	End
_cv_won_17:
	SetTrainerFlag 1152
	GoTo VermilionCity_Gym_EventScript_DefeatedLtSurge
_cv_beaten_16:
	GoTo VermilionCity_Gym_EventScript_AfterLeaderBattle
	
VermilionCity_Gym_EventScript_DefeatedLtSurge:
	CallIfUnset 0x2127, VermilionCity_Gym_EventScript_ShowOaksAide
	ClearFlag 0x2086
	SetFlag 0x2125
	SetFlag 0x208C
	SetVar 0x8008, 3
	Call Common_EventScript_SetGymTrainers_Frlg
	GoTo VermilionCity_Gym_EventScript_GiveTM34
	End
	
VermilionCity_Gym_EventScript_GymGuyPostVictory:
	NPCMsg msg_0485_T06GYM0101_VermilionCity_Gym_Text_GymGuyPostVictory
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_Gym_EventScript_DefeatedTucker:
	ReleaseAll
	End
	
GymAides_EventScript_VermilionCityAfter:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0485_T06GYM0101_GymAides_Text_VermilionCityAfter
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_Gym_EventScript_GymStatuePostVictory:
	BufferPlayersName 6
	BufferRivalsName 7
	NPCMsg msg_0485_T06GYM0101_VermilionCity_Gym_Text_GymStatuePlayerWon
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_Gym_EventScript_TrashCan:
	CopyVar 0x8004, 0x4000
	CopyVar 0x8005, 0x4001
	GoToIfSet 0x2126, VermilionCity_Gym_EventScript_LocksAlreadyOpen
	GoToIfSet 1, VermilionCity_Gym_EventScript_TrySwitchTwo
	CompareVarToValue 0x8004, 0x8008
	GoToIfEq VermilionCity_Gym_EventScript_FoundSwitchOne
	NPCMsg msg_0485_T06GYM0101_VermilionCity_Gym_Text_NopeOnlyTrashHere
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_Gym_EventScript_SetOneBeamOff:
	// (the GBA redraws a square here: 3, 6, METATILE_VermilionGym_Beam_Node_TopLeft_HalfOn, 1)
	// (the GBA redraws a square here: 4, 6, METATILE_VermilionGym_Beam_Node_TopLeft_Edge_HalfOn, 1)
	// (the GBA redraws a square here: 5, 6, METATILE_VermilionGym_Beam_MidTop_HalfOn, 1)
	// (the GBA redraws a square here: 6, 6, METATILE_VermilionGym_Beam_Node_TopRight_Edge_HalfOn, 1)
	// (the GBA redraws a square here: 7, 6, METATILE_VermilionGym_Beam_Node_TopRight_HalfOn, 1)
	// (the GBA redraws a square here: 3, 7, METATILE_VermilionGym_Beam_Node_BottomLeft_HalfOn, 1)
	// (the GBA redraws a square here: 4, 7, METATILE_VermilionGym_Beam_Node_BottomLeft_Edge_HalfOn, 1)
	// (the GBA redraws a square here: 5, 7, METATILE_VermilionGym_Beam_MidBottom_HalfOn, 1)
	// (the GBA redraws a square here: 6, 7, METATILE_VermilionGym_Beam_Node_BottomRight_Edge_HalfOn, 1)
	// (the GBA redraws a square here: 7, 7, METATILE_VermilionGym_Beam_Node_BottomRight_HalfOn, 1)
	Return
	
VermilionCity_Gym_EventScript_SetBeamsOff:
	// (the GBA redraws a square here: 3, 6, METATILE_VermilionGym_Beam_Node_TopLeft_Off, 1)
	// (the GBA redraws a square here: 4, 6, METATILE_VermilionGym_Beam_Node_TopLeft_Edge_Off, 0)
	// (the GBA redraws a square here: 5, 6, METATILE_VermilionGym_Floor, 0)
	// (the GBA redraws a square here: 6, 6, METATILE_VermilionGym_Beam_Node_TopRight_Edge_Off, 0)
	// (the GBA redraws a square here: 7, 6, METATILE_VermilionGym_Beam_Node_TopRight_Off, 1)
	// (the GBA redraws a square here: 3, 7, METATILE_VermilionGym_Beam_Node_BottomLeft_Off, 1)
	// (the GBA redraws a square here: 4, 7, METATILE_VermilionGym_Beam_Node_BottomLeft_Edge_Off, 0)
	// (the GBA redraws a square here: 5, 7, METATILE_VermilionGym_Floor, 0)
	// (the GBA redraws a square here: 6, 7, METATILE_VermilionGym_Beam_Node_BottomRight_Edge_Off, 0)
	// (the GBA redraws a square here: 7, 7, METATILE_VermilionGym_Beam_Node_BottomRight_Off, 1)
	Return
	
VermilionCity_Gym_EventScript_InitTrashCans:
	GoToIfSet 0x2126, Common_EventScript_NopReturn
	// TODO(gba) special SetVermilionTrashCans
	CopyVar 0x4000, 0x4014
	CopyVar 0x4001, 0x4015
	Return
	
VermilionCity_Gym_EventScript_AfterLeaderBattle:
	GoToIfUnset 0x2128, VermilionCity_Gym_EventScript_GiveTM34
	Call GymHack_EventScript_SurgeGifts
	Call GymCandidate_EventScript_VermilionCityTalk
	NPCMsg msg_0485_T06GYM0101_VermilionCity_Gym_Text_LtSurgePostBattle
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_Gym_EventScript_ShowOaksAide:
	ClearFlag 0x2061
	Return
	
Common_EventScript_SetGymTrainers_Frlg:
	CompareVarToValue 0x8008, 1
	GoToIfEq EventScript_SetPewterGymTrainers
	CompareVarToValue 0x8008, 2
	GoToIfEq EventScript_SetCeruleanGymTrainers
	CompareVarToValue 0x8008, 3
	GoToIfEq EventScript_SetVermilionGymTrainers
	CompareVarToValue 0x8008, 4
	GoToIfEq EventScript_SetCeladonGymTrainers
	CompareVarToValue 0x8008, 5
	GoToIfEq EventScript_SetFuchsiaGymTrainers
	CompareVarToValue 0x8008, 6
	GoToIfEq EventScript_SetSaffronGymTrainers
	CompareVarToValue 0x8008, 7
	GoToIfEq EventScript_SetCinnabarGymTrainers
	CompareVarToValue 0x8008, 8
	GoToIfEq EventScript_SetViridianGymTrainers
	End
	
VermilionCity_Gym_EventScript_GiveTM34:
	NPCMsg msg_0485_T06GYM0101_VermilionCity_Gym_Text_ExplainThunderBadgeTakeThis
	WaitButton
	HasSpaceForItem ITEM_TM34, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq VermilionCity_Gym_EventScript_NoRoomForTM34
	GiveItem ITEM_TM34, 1, VAR_SPECIAL_RESULT
	BufferItemName 1, ITEM_TM34
	BufferPlayersName 6
	NPCMsg msg_0485_T06GYM0101_VermilionCity_Gym_Text_ReceivedTM34FromLtSurge
	PlayFanfare SEQ_ME_LVUP
	WaitFanfare
	WaitButton
	SetFlag 0x2128
	NPCMsg msg_0485_T06GYM0101_VermilionCity_Gym_Text_ExplainTM34
	WaitButton
	Call GymHack_EventScript_SurgeGifts
	GoTo GymCandidate_EventScript_VermilionCityAfterBadge
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_Gym_EventScript_LocksAlreadyOpen:
	NPCMsg msg_0485_T06GYM0101_VermilionCity_Gym_Text_NopeOnlyTrashHere
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_Gym_EventScript_TrySwitchTwo:
	CompareVarToValue 0x8005, 0x8008
	GoToIfEq VermilionCity_Gym_EventScript_FoundSwitchTwo
	NPCMsg msg_0485_T06GYM0101_VermilionCity_Gym_Text_OnlyTrashLocksWereReset
	WaitButton
	ClearFlag 1
	// TODO(gba) special SetVermilionTrashCans
	GoTo _cv_stop
	CopyVar 0x4000, 0x8004
	CopyVar 0x4001, 0x8005
	Call VermilionCity_Gym_EventScript_SetBeamsOn
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_Gym_EventScript_FoundSwitchOne:
	NPCMsg msg_0485_T06GYM0101_VermilionCity_Gym_Text_SwitchUnderTrashFirstLockOpened
	WaitButton
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	Call VermilionCity_Gym_EventScript_SetOneBeamOff
	SetFlag 1
	CloseMsg
	ReleaseAll
	End
	
Common_EventScript_NopReturn:
	Return
	
GymHack_EventScript_SurgeGifts:
	GoToIfSet 0x2129, GymHack_EventScript_GiftsDone
	NPCMsg msg_0485_T06GYM0101_GymHack_Text_SurgeSilverCap
	WaitButton
	SetVar 0x8009, 795
	Call GymHack_EventScript_GiveStatItem
	SetFlag 0x2129
	NPCMsg msg_0485_T06GYM0101_GymHack_Text_SurgeSilverCapAfter
	WaitButton
	Return
	
GymCandidate_EventScript_VermilionCityTalk:
	SetVar 0x8009, 2
	SetVar 0x800A, 7
	GoTo GymCandidate_EventScript_TalkAgain
	
EventScript_SetPewterGymTrainers:
	SetTrainerFlag 897
	Return
	
EventScript_SetCeruleanGymTrainers:
	SetTrainerFlag 904
	SetTrainerFlag 980
	Return
	
EventScript_SetVermilionGymTrainers:
	SetTrainerFlag 896
	SetTrainerFlag 966
	SetTrainerFlag 1159
	Return
	
EventScript_SetCeladonGymTrainers:
	SetTrainerFlag 887
	SetTrainerFlag 888
	SetTrainerFlag 914
	SetTrainerFlag 1010
	SetTrainerFlag 1011
	SetTrainerFlag 1012
	SetTrainerFlag 1138
	Return
	
EventScript_SetFuchsiaGymTrainers:
	SetTrainerFlag 1039
	SetTrainerFlag 1040
	SetTrainerFlag 1033
	SetTrainerFlag 1034
	SetTrainerFlag 1037
	SetTrainerFlag 1038
	Return
	
EventScript_SetSaffronGymTrainers:
	SetTrainerFlag 1025
	SetTrainerFlag 1026
	SetTrainerFlag 1027
	SetTrainerFlag 1028
	SetTrainerFlag 1175
	SetTrainerFlag 1176
	SetTrainerFlag 1177
	Return
	
EventScript_SetCinnabarGymTrainers:
	SetTrainerFlag 928
	SetTrainerFlag 929
	SetTrainerFlag 930
	SetTrainerFlag 931
	SetTrainerFlag 960
	SetTrainerFlag 961
	SetTrainerFlag 962
	Return
	
EventScript_SetViridianGymTrainers:
	SetTrainerFlag 1041
	SetTrainerFlag 1042
	SetTrainerFlag 1067
	SetTrainerFlag 1068
	SetTrainerFlag 1069
	SetTrainerFlag 1128
	SetTrainerFlag 1136
	SetTrainerFlag 1137
	Return
	
VermilionCity_Gym_EventScript_NoRoomForTM34:
	NPCMsg msg_0485_T06GYM0101_VermilionCity_Gym_Text_MakeRoomInYourBag
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_VermilionCityAfterBadge:
	SetVar 0x8009, 2
	SetVar 0x800A, 7
	GoTo GymCandidate_EventScript_AfterBadge
	End
	
VermilionCity_Gym_EventScript_FoundSwitchTwo:
	NPCMsg msg_0485_T06GYM0101_VermilionCity_Gym_Text_SecondLockOpened
	WaitButton
	CloseMsg
	Call VermilionCity_Gym_EventScript_SetBeamsOff
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	SetFlag 0x2126
	ReleaseAll
	End
	
VermilionCity_Gym_EventScript_SetBeamsOn:
	// (the GBA redraws a square here: 3, 6, METATILE_VermilionGym_Beam_Node_TopLeft_On, 1)
	// (the GBA redraws a square here: 4, 6, METATILE_VermilionGym_Beam_Node_TopLeft_Edge_On, 1)
	// (the GBA redraws a square here: 5, 6, METATILE_VermilionGym_Beam_MidTop, 1)
	// (the GBA redraws a square here: 6, 6, METATILE_VermilionGym_Beam_Node_TopRight_Edge_On, 1)
	// (the GBA redraws a square here: 7, 6, METATILE_VermilionGym_Beam_Node_TopRight_On, 1)
	// (the GBA redraws a square here: 3, 7, METATILE_VermilionGym_Beam_Node_BottomLeft_On, 1)
	// (the GBA redraws a square here: 4, 7, METATILE_VermilionGym_Beam_Node_BottomLeft_Edge_On, 1)
	// (the GBA redraws a square here: 5, 7, METATILE_VermilionGym_Beam_MidBottom, 1)
	// (the GBA redraws a square here: 6, 7, METATILE_VermilionGym_Beam_Node_BottomRight_Edge_On, 1)
	// (the GBA redraws a square here: 7, 7, METATILE_VermilionGym_Beam_Node_BottomRight_On, 1)
	Return
	
GymHack_EventScript_GiftsDone:
	Return
	
GymHack_EventScript_GiveStatItem:
	GiveItem 0x8009, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymHack_EventScript_GiveStatItemDone
	BufferItemName 1, 0x8009
	NPCMsg msg_0485_T06GYM0101_GymHack_Text_GiftSentToPC
	WaitButton
	End
	
GymCandidate_EventScript_TalkAgain:
	Call GymCandidate_EventScript_MentorGift
	// TODO(gba) special GymCandidate_IsApproved
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_Offer
	CompareVarToValue 0x8009, 7
	GoToIfEq GymCandidate_EventScript_Return
	GoToIfSet 0x2008, GymCandidate_EventScript_OwnGym
	// TODO(gba) special GymCandidate_BufferRepeatOffer
	GoTo _cv_stop
	Call _cv_str4
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_18
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_19
_cv_yes_18:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_19:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_NotYet
	SetVar 0x8007, 1
	GoTo GymCandidate_EventScript_Start
	CloseMsg
	End
	
GymCandidate_EventScript_AfterBadge:
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_mentor_20
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_mentor_20
	SetVar 0x401F, 12
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_20:
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_mentor_21
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_mentor_21
	SetVar 0x401F, 13
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_21:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_mentor_22
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_mentor_22
	SetVar 0x401F, 14
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_22:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_mentor_23
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_mentor_23
	SetVar 0x401F, 15
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_23:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_mentor_24
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_mentor_24
	SetVar 0x401F, 16
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_24:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_mentor_25
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_mentor_25
	SetVar 0x401F, 17
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_25:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_mentor_26
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_mentor_26
	SetVar 0x401F, 18
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_26:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_mentor_27
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_mentor_27
	SetVar 0x401F, 19
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_27:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_mentor_28
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_mentor_28
	SetVar 0x401F, 20
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_28:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_mentor_29
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_mentor_29
	SetVar 0x401F, 21
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_29:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_mentor_30
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_mentor_30
	SetVar 0x401F, 22
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_30:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq GymCandidate_EventScript_ShowText4
	Call GymCandidate_EventScript_MentorGift
	GoTo GymCandidate_EventScript_Offer
	End
	
GymHack_EventScript_GiveStatItemDone:
	Return
	
GymCandidate_EventScript_MentorGift:
	// TODO(gba) special GymCandidate_PrepareMentorGift
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_Return
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymCandidate_EventScript_MentorGiveItem
	PlaySE SEQ_SE_DP_DOOR
	BufferPlayersName 6
	NPCMsg msg_0485_T06GYM0101_GymCandidate_Text_SomeoneToSeeYou
	WaitButton
	CloseMsg
	Call GymCandidate_EventScript_VisitorWalksIn
	Call GymCandidate_EventScript_MentorGiveItem
	Call GymCandidate_EventScript_VisitorWalksOut
	Return
	
GymCandidate_EventScript_Offer:
	// TODO(gba) special GymCandidate_BufferOffer
	GoTo _cv_stop
	Call _cv_str4
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_31
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_32
_cv_yes_31:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_32:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_NotYet
	SetVar 0x8007, 0
	End
	
GymCandidate_EventScript_Return:
	Return
	
GymCandidate_EventScript_OwnGym:
	// TODO(gba) special GymCandidate_BufferOwnGym
	GoTo _cv_stop
	Call _cv_str4
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_NotYet:
	NPCMsg msg_0485_T06GYM0101_GymCandidate_Text_NotYet
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_Start:
	// TODO(gba) special GymHack_CheckTeamSpecial
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe GymCandidate_EventScript_TeamBreaksRules
	SetVar 0x800B, 0
	Call GymCandidate_EventScript_TakeLeadersPlace
	End
	
GymCandidate_EventScript_ShowText4:
	Call _cv_str4
	WaitButton
	Return
	
GymCandidate_EventScript_MentorGiveItem:
	// TODO(gba) special GymCandidate_BufferMentorGift
	GoTo _cv_stop
	Call _cv_str4
	WaitButton
	GiveItem 0x8004, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymCandidate_EventScript_MentorItemExplain
	BufferItemName 1, 0x8004
	NPCMsg msg_0485_T06GYM0101_GymHack_Text_GiftSentToPC
	WaitButton
	End
	
GymCandidate_EventScript_VisitorWalksIn:
	// TODO(gba) special GymCandidate_PlanVisitorWalk
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_MentorAppears
	CopyVar 0x401E, 0x8005
	AddVar 0x401E, 1
	CopyVar 0x401F, 0x8006
	AddVar 0x401F, 3
	MovePerson 0x800A, 0x401E, 0x401F
	ClearFlag 0x2017
	ShowPerson 0x800A
	ApplyMovement 0x800A, gMentorWalkIn
	WaitMovement
	// TODO(gba) special GymCandidate_FaceGuest
	GoTo _cv_stop
	Return
	
GymCandidate_EventScript_VisitorWalksOut:
	// TODO(gba) special GymCandidate_VisitorWalked
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_GuestLeaves
	CloseMsg
	ApplyMovement 0x800A, gMentorWalkOut
	WaitMovement
	HidePerson 0x800A
	SetFlag 0x2017
	PlaySE SEQ_SE_DP_KAIDAN2
	// TODO(gba) special GymCandidate_FaceBack
	GoTo _cv_stop
	Return
	
GymCandidate_EventScript_TeamBreaksRules:
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfEq GymCandidate_EventScript_ItemClause
	NPCMsg msg_0485_T06GYM0101_GymCandidate_Text_TeamBreaksRules
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_TakeLeadersPlace:
	// TODO(gba) special GymCandidate_PlanHold
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_Return
	// TODO(gba) special GymCandidate_BufferHoldText
	GoTo _cv_stop
	Call _cv_str4
	WaitButton
	CloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special GymCandidate_HoldLeaderAside
	GoTo _cv_stop
	ApplyMovement obj_player, gHoldPlayerIn
	WaitMovement
	Wait 30, VAR_SPECIAL_RESULT
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	Return
	
GymCandidate_EventScript_MentorItemExplain:
	BufferItemName 0, 0x8004
	CompareVarToValue 0x8009, 6
	GoToIfEq GymCandidate_EventScript_EdgeItemExplain
	NPCMsg msg_0485_T06GYM0101_GymCandidate_Text_GuardItemExplain
	WaitButton
	Call Outfits_EventScript_GymUniform
	Return
	
GymCandidate_EventScript_MentorAppears:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special GymCandidate_PlaceGuest
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_MentorNoRoom
	CopyVar 0x401E, 0x8005
	AddVar 0x401E, 1
	CopyVar 0x401F, 0x8006
	AddVar 0x401F, 3
	MovePerson 0x800A, 0x401E, 0x401F
	ClearFlag 0x2017
	ShowPerson 0x800A
	// TODO(gba) special GymCandidate_FaceGuest
	GoTo _cv_stop
	End
	
GymCandidate_EventScript_GuestLeaves:
	CloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	HidePerson 0x800A
	SetFlag 0x2017
	// TODO(gba) special GymCandidate_FaceBack
	GoTo _cv_stop
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	Return
	
GymCandidate_EventScript_ItemClause:
	Call EventScript_GymHack_ShowTeamRuleMessage
	ReleaseAll
	End
	
GymCandidate_EventScript_EdgeItemExplain:
	NPCMsg msg_0485_T06GYM0101_GymCandidate_Text_EdgeItemExplain
	WaitButton
	Return
	
Outfits_EventScript_GymUniform:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Outfits_EventScript_Return
	PlayFanfare SEQ_ME_ITEM
	BufferPlayersName 6
	NPCMsg msg_0485_T06GYM0101_Outfits_Text_ReceivedGymUniform
	WaitFanfare
	BufferPlayersName 6
	NPCMsg msg_0485_T06GYM0101_Outfits_Text_PutInWardrobe
	WaitButton
	End
	
GymCandidate_EventScript_MentorNoRoom:
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
	
Outfits_EventScript_Return:
	Return
	
EventScript_GymHack_MsgWrongType:
	NPCMsg msg_0485_T06GYM0101_Text_GymHack_WrongType
	WaitButton
	Return
	
EventScript_GymHack_MsgDuplicate:
	NPCMsg msg_0485_T06GYM0101_Text_GymHack_Duplicate
	WaitButton
	Return
	
EventScript_GymHack_MsgDuplicateItem:
	NPCMsg msg_0485_T06GYM0101_Text_GymHack_DuplicateItem
	WaitButton
	Return

_cv_str4:
	BufferPlayersName 6
	BufferRivalsName 7
	CompareVarToValue 0x401F, 1
	GoToIfNe _cv_str4_0
	NPCMsg msg_0485_T06GYM0101_cv_mentor_prebattle_rock
	Return
_cv_str4_0:
	CompareVarToValue 0x401F, 2
	GoToIfNe _cv_str4_1
	NPCMsg msg_0485_T06GYM0101_cv_mentor_prebattle_normal
	Return
_cv_str4_1:
	CompareVarToValue 0x401F, 3
	GoToIfNe _cv_str4_2
	NPCMsg msg_0485_T06GYM0101_cv_mentor_prebattle_water
	Return
_cv_str4_2:
	CompareVarToValue 0x401F, 4
	GoToIfNe _cv_str4_3
	NPCMsg msg_0485_T06GYM0101_cv_mentor_prebattle_electric
	Return
_cv_str4_3:
	CompareVarToValue 0x401F, 5
	GoToIfNe _cv_str4_4
	NPCMsg msg_0485_T06GYM0101_cv_mentor_prebattle_steel
	Return
_cv_str4_4:
	CompareVarToValue 0x401F, 6
	GoToIfNe _cv_str4_5
	NPCMsg msg_0485_T06GYM0101_cv_mentor_prebattle_grass
	Return
_cv_str4_5:
	CompareVarToValue 0x401F, 7
	GoToIfNe _cv_str4_6
	NPCMsg msg_0485_T06GYM0101_cv_mentor_prebattle_poison
	Return
_cv_str4_6:
	CompareVarToValue 0x401F, 8
	GoToIfNe _cv_str4_7
	NPCMsg msg_0485_T06GYM0101_cv_mentor_prebattle_bug
	Return
_cv_str4_7:
	CompareVarToValue 0x401F, 9
	GoToIfNe _cv_str4_8
	NPCMsg msg_0485_T06GYM0101_cv_mentor_prebattle_psychic
	Return
_cv_str4_8:
	CompareVarToValue 0x401F, 10
	GoToIfNe _cv_str4_9
	NPCMsg msg_0485_T06GYM0101_cv_mentor_prebattle_fairy
	Return
_cv_str4_9:
	CompareVarToValue 0x401F, 11
	GoToIfNe _cv_str4_10
	NPCMsg msg_0485_T06GYM0101_cv_mentor_prebattle_fire
	Return
_cv_str4_10:
	CompareVarToValue 0x401F, 12
	GoToIfNe _cv_str4_11
	NPCMsg msg_0485_T06GYM0101_cv_mentor_first_rock
	Return
_cv_str4_11:
	CompareVarToValue 0x401F, 13
	GoToIfNe _cv_str4_12
	NPCMsg msg_0485_T06GYM0101_cv_mentor_first_normal
	Return
_cv_str4_12:
	CompareVarToValue 0x401F, 14
	GoToIfNe _cv_str4_13
	NPCMsg msg_0485_T06GYM0101_cv_mentor_first_water
	Return
_cv_str4_13:
	CompareVarToValue 0x401F, 15
	GoToIfNe _cv_str4_14
	NPCMsg msg_0485_T06GYM0101_cv_mentor_first_electric
	Return
_cv_str4_14:
	CompareVarToValue 0x401F, 16
	GoToIfNe _cv_str4_15
	NPCMsg msg_0485_T06GYM0101_cv_mentor_first_steel
	Return
_cv_str4_15:
	CompareVarToValue 0x401F, 17
	GoToIfNe _cv_str4_16
	NPCMsg msg_0485_T06GYM0101_cv_mentor_first_grass
	Return
_cv_str4_16:
	CompareVarToValue 0x401F, 18
	GoToIfNe _cv_str4_17
	NPCMsg msg_0485_T06GYM0101_cv_mentor_first_poison
	Return
_cv_str4_17:
	CompareVarToValue 0x401F, 19
	GoToIfNe _cv_str4_18
	NPCMsg msg_0485_T06GYM0101_cv_mentor_first_bug
	Return
_cv_str4_18:
	CompareVarToValue 0x401F, 20
	GoToIfNe _cv_str4_19
	NPCMsg msg_0485_T06GYM0101_cv_mentor_first_psychic
	Return
_cv_str4_19:
	CompareVarToValue 0x401F, 21
	GoToIfNe _cv_str4_20
	NPCMsg msg_0485_T06GYM0101_cv_mentor_first_fairy
	Return
_cv_str4_20:
	CompareVarToValue 0x401F, 22
	GoToIfNe _cv_str4_21
	NPCMsg msg_0485_T06GYM0101_cv_mentor_first_fire
	Return
_cv_str4_21:
	Return

_cv_stop:
	NPCMsg msg_0485_T06GYM0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
gMentorWalkIn:
	EndMovement

	.balign 4, 0
gMentorWalkOut:
	EndMovement

	.balign 4, 0
gHoldPlayerIn:
	EndMovement
	.balign 4, 0
