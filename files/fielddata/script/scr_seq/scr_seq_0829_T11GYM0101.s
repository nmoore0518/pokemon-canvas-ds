#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T11GYM0101.h"
#include "msgdata/msg/msg_0531_T11GYM0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SaffronCity_Gym_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SaffronCity_Gym_EventScript_Sabrina
	ScrDef SaffronCity_Gym_EventScript_GymGuy
	ScrDef GymAides_EventScript_SaffronCity
	ScrDef SaffronCity_Gym_EventScript_GymStatue
	ScrDef SaffronCity_Gym_OnTransitionGuest
	ScrDefEnd
	
SaffronCity_Gym_EventScript_Sabrina:
	SetVar 0x8009, 5
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
	GoToIfEq SaffronCity_Gym_EventScript_MentorBattle
	CheckTrainerFlag 1156
	GoToIf TRUE, _cv_beaten_12
	NPCMsg msg_0531_T11GYM0101_SaffronCity_Gym_Text_SabrinaIntro
	WaitButton
	CloseMsg
	CanvasCheckTeam 7, 0x5019
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_team_not_allowed
	TrainerBattle 1156, 1156, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_13
	WhiteOut
	End
_cv_won_13:
	SetTrainerFlag 1156
	GoTo SaffronCity_Gym_EventScript_DefeatedSabrina
_cv_beaten_12:
	GoTo SaffronCity_Gym_EventScript_AfterLeaderBattle
	
SaffronCity_Gym_EventScript_GymGuy:
	LockAll
	FacePlayer
	GoToIfSet 0x2142, SaffronCity_Gym_EventScript_GymGuyPostVictory
	NPCMsg msg_0531_T11GYM0101_SaffronCity_Gym_Text_GymGuyAdvice
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymAides_EventScript_SaffronCity:
	GoToIfSet 0x208F, GymAides_EventScript_SaffronCityAfter
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0531_T11GYM0101_GymAides_Text_SaffronCity
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_Gym_EventScript_GymStatue:
	LockAll
	GoToIfSet 0x208F, SaffronCity_Gym_EventScript_GymStatuePostVictory
	BufferRivalsName 7
	NPCMsg msg_0531_T11GYM0101_SaffronCity_Gym_Text_GymStatue
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_Gym_OnTransitionGuest:
	SetFlag 0x2017
	End
	
SaffronCity_Gym_EventScript_MentorBattle:
	CheckTrainerFlag 1156
	GoToIf TRUE, _cv_beaten_14
	CanvasCheckTeam 7, 0x5019
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_team_not_allowed
	TrainerBattle 1156, 1156, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_15
	WhiteOut
	End
_cv_won_15:
	SetTrainerFlag 1156
	GoTo SaffronCity_Gym_EventScript_DefeatedSabrina
_cv_beaten_14:
	GoTo SaffronCity_Gym_EventScript_AfterLeaderBattle
	
EventScript_GymHack_ShowTeamRuleMessage:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq EventScript_GymHack_MsgWrongType
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	CallIfEq EventScript_GymHack_MsgDuplicate
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	CallIfEq EventScript_GymHack_MsgDuplicateItem
	Return
	
SaffronCity_Gym_EventScript_DefeatedSabrina:
	ClearFlag 0x2087
	SetFlag 0x2142
	SetFlag 0x208F
	SetVar 0x8008, 6
	Call Common_EventScript_SetGymTrainers_Frlg
	GoTo SaffronCity_Gym_EventScript_GiveTM04
	End
	
SaffronCity_Gym_EventScript_AfterLeaderBattle:
	GoToIfUnset 0x2143, SaffronCity_Gym_EventScript_GiveTM04
	Call GymHack_EventScript_SabrinaGifts
	Call GymCandidate_EventScript_SaffronCityTalk
	NPCMsg msg_0531_T11GYM0101_SaffronCity_Gym_Text_ExplainTM04
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_Gym_EventScript_GymGuyPostVictory:
	NPCMsg msg_0531_T11GYM0101_SaffronCity_Gym_Text_GymGuyPostVictory
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymAides_EventScript_SaffronCityAfter:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0531_T11GYM0101_GymAides_Text_SaffronCityAfter
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_Gym_EventScript_GymStatuePostVictory:
	BufferPlayersName 6
	BufferRivalsName 7
	NPCMsg msg_0531_T11GYM0101_SaffronCity_Gym_Text_GymStatuePlayerWon
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_GymHack_MsgWrongType:
	NPCMsg msg_0531_T11GYM0101_Text_GymHack_WrongType
	WaitButton
	Return
	
EventScript_GymHack_MsgDuplicate:
	NPCMsg msg_0531_T11GYM0101_Text_GymHack_Duplicate
	WaitButton
	Return
	
EventScript_GymHack_MsgDuplicateItem:
	NPCMsg msg_0531_T11GYM0101_Text_GymHack_DuplicateItem
	WaitButton
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
	
SaffronCity_Gym_EventScript_GiveTM04:
	NPCMsg msg_0531_T11GYM0101_SaffronCity_Gym_Text_ExplainMarshBadgeTakeThis
	WaitButton
	HasSpaceForItem ITEM_TM04, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq SaffronCity_Gym_EventScript_NoRoomForTM04
	GiveItem ITEM_TM04, 1, VAR_SPECIAL_RESULT
	BufferItemName 1, ITEM_TM04
	BufferPlayersName 6
	NPCMsg msg_0531_T11GYM0101_SaffronCity_Gym_Text_ReceivedTM04FromSabrina
	PlayFanfare SEQ_ME_LVUP
	WaitFanfare
	WaitButton
	SetFlag 0x2143
	NPCMsg msg_0531_T11GYM0101_SaffronCity_Gym_Text_SabrinaPostBattle
	WaitButton
	Call GymHack_EventScript_SabrinaGifts
	GoTo GymCandidate_EventScript_SaffronCityAfterBadge
	CloseMsg
	ReleaseAll
	End
	
GymHack_EventScript_SabrinaGifts:
	GoToIfSet 0x2144, GymHack_EventScript_GiftsDone
	NPCMsg msg_0531_T11GYM0101_GymHack_Text_SabrinaSilverCap
	WaitButton
	SetVar 0x8009, 795
	Call GymHack_EventScript_GiveStatItem
	SetFlag 0x2144
	NPCMsg msg_0531_T11GYM0101_GymHack_Text_SabrinaSilverCapAfter
	WaitButton
	Return
	
GymCandidate_EventScript_SaffronCityTalk:
	SetVar 0x8009, 5
	SetVar 0x800A, 11
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
	
SaffronCity_Gym_EventScript_NoRoomForTM04:
	NPCMsg msg_0531_T11GYM0101_SaffronCity_Gym_Text_BagFullOfOtherItems
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_SaffronCityAfterBadge:
	SetVar 0x8009, 5
	SetVar 0x800A, 11
	GoTo GymCandidate_EventScript_AfterBadge
	End
	
GymHack_EventScript_GiftsDone:
	Return
	
GymHack_EventScript_GiveStatItem:
	SetOrCopyVar 0x8004, 0x8009
	SetOrCopyVar 0x8005, 1
	HasSpaceForItem 0x8004, 0x8005, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_full_16
	CallStd std_give_item_verbose
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_given_17
_cv_full_16:
	SetVar VAR_SPECIAL_RESULT, 0
_cv_given_17:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymHack_EventScript_GiveStatItemDone
	BufferItemName 1, 0x8009
	NPCMsg msg_0531_T11GYM0101_GymHack_Text_GiftSentToPC
	WaitButton
	GoTo GymHack_EventScript_GiveStatItemDone
	
GymCandidate_EventScript_TalkAgain:
	Call GymCandidate_EventScript_MentorGift
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_appr_18
	GoToIfUnset 0x2093, _cv_appr_18
	SetVar VAR_SPECIAL_RESULT, 1
_cv_appr_18:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_appr_19
	GoToIfUnset 0x2094, _cv_appr_19
	SetVar VAR_SPECIAL_RESULT, 1
_cv_appr_19:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_appr_20
	GoToIfUnset 0x2095, _cv_appr_20
	SetVar VAR_SPECIAL_RESULT, 1
_cv_appr_20:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_appr_21
	GoToIfUnset 0x2096, _cv_appr_21
	SetVar VAR_SPECIAL_RESULT, 1
_cv_appr_21:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_appr_22
	GoToIfUnset 0x2097, _cv_appr_22
	SetVar VAR_SPECIAL_RESULT, 1
_cv_appr_22:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_appr_23
	GoToIfUnset 0x2098, _cv_appr_23
	SetVar VAR_SPECIAL_RESULT, 1
_cv_appr_23:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_appr_24
	GoToIfUnset 0x2099, _cv_appr_24
	SetVar VAR_SPECIAL_RESULT, 1
_cv_appr_24:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_appr_25
	GoToIfUnset 0x2007, _cv_appr_25
	SetVar VAR_SPECIAL_RESULT, 1
_cv_appr_25:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_Offer
	CompareVarToValue 0x8009, 7
	GoToIfEq GymCandidate_EventScript_Return
	GoToIfSet 0x2008, GymCandidate_EventScript_OwnGym
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_next_27
	SetVar 0x401F, 12
	GoTo _cv_done_26
_cv_next_27:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_next_28
	SetVar 0x401F, 13
	GoTo _cv_done_26
_cv_next_28:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_next_29
	SetVar 0x401F, 14
	GoTo _cv_done_26
_cv_next_29:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_next_30
	SetVar 0x401F, 15
	GoTo _cv_done_26
_cv_next_30:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_next_31
	SetVar 0x401F, 16
	GoTo _cv_done_26
_cv_next_31:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_next_32
	SetVar 0x401F, 17
	GoTo _cv_done_26
_cv_next_32:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_next_33
	SetVar 0x401F, 18
	GoTo _cv_done_26
_cv_next_33:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_next_34
	SetVar 0x401F, 19
	GoTo _cv_done_26
_cv_next_34:
_cv_done_26:
	Call _cv_str4
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_35
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_36
_cv_yes_35:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_36:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_NotYet
	SetVar 0x8007, 1
	GoTo GymCandidate_EventScript_Start
	CloseMsg
	End
	
GymCandidate_EventScript_AfterBadge:
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_mentor_37
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_mentor_37
	SetVar 0x401F, 20
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_37:
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_mentor_38
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_mentor_38
	SetVar 0x401F, 21
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_38:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_mentor_39
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_mentor_39
	SetVar 0x401F, 22
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_39:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_mentor_40
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_mentor_40
	SetVar 0x401F, 23
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_40:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_mentor_41
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_mentor_41
	SetVar 0x401F, 24
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_41:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_mentor_42
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_mentor_42
	SetVar 0x401F, 25
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_42:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_mentor_43
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_mentor_43
	SetVar 0x401F, 26
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_43:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_mentor_44
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_mentor_44
	SetVar 0x401F, 27
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_44:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_mentor_45
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_mentor_45
	SetVar 0x401F, 28
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_45:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_mentor_46
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_mentor_46
	SetVar 0x401F, 29
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_46:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_mentor_47
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_mentor_47
	SetVar 0x401F, 30
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_47:
	CompareVarToValue 0x8009, 9
	GoToIfNe _cv_mentor_48
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_mentor_48
	SetVar 0x401F, 31
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_48:
	CompareVarToValue 0x8009, 10
	GoToIfNe _cv_mentor_49
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_mentor_49
	SetVar 0x401F, 32
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_49:
	CompareVarToValue 0x8009, 8
	GoToIfNe _cv_mentor_50
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_mentor_50
	SetVar 0x401F, 33
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_50:
	CompareVarToValue 0x8009, 9
	GoToIfNe _cv_mentor_51
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_mentor_51
	SetVar 0x401F, 34
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_51:
	CompareVarToValue 0x8009, 10
	GoToIfNe _cv_mentor_52
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_mentor_52
	SetVar 0x401F, 35
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_52:
	CompareVarToValue 0x8009, 11
	GoToIfNe _cv_mentor_53
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_mentor_53
	SetVar 0x401F, 36
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_53:
	CompareVarToValue 0x8009, 11
	GoToIfNe _cv_mentor_54
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_mentor_54
	SetVar 0x401F, 37
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_54:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq GymCandidate_EventScript_ShowText4
	Call GymCandidate_EventScript_MentorGift
	GoTo GymCandidate_EventScript_Offer
	End
	
GymHack_EventScript_GiveStatItemDone:
	Return
	
GymCandidate_EventScript_MentorGift:
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_gift_56
	GoToIfSet 0x22F3, _cv_gift_55
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_58
	SetFlag 0x22F3
	SetVar 0x8004, 2696
	SetVar 0x4020, SPRITE_GSLEADER14
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_57
_cv_next_58:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_59
	SetFlag 0x22F3
	SetVar 0x8004, 2686
	SetVar 0x4020, SPRITE_GSLEADER14
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_57
_cv_next_59:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_60
	SetFlag 0x22F3
	SetVar 0x8004, 2706
	SetVar 0x4020, SPRITE_GSLEADER11
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_57
_cv_next_60:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_61
	SetFlag 0x22F3
	SetVar 0x8004, 2710
	SetVar 0x4020, SPRITE_GSLEADER9
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_57
_cv_next_61:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_62
	SetFlag 0x22F3
	SetVar 0x8004, 2702
	SetVar 0x4020, SPRITE_GSLEADER9
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_57
_cv_next_62:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_63
	SetFlag 0x22F3
	SetVar 0x8004, 2708
	SetVar 0x4020, SPRITE_GSLEADER12
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_57
_cv_next_63:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_64
	SetFlag 0x22F3
	SetVar 0x8004, 2692
	SetVar 0x4020, SPRITE_GSBIGFOUR2
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_57
_cv_next_64:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_65
	SetFlag 0x22F3
	SetVar 0x8004, 2698
	SetVar 0x4020, SPRITE_GSBIGFOUR2
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_57
_cv_next_65:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_66
	SetFlag 0x22F3
	SetVar 0x8004, 2712
	SetVar 0x4020, SPRITE_GSLEADER10
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_57
_cv_next_66:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_67
	SetFlag 0x22F3
	SetVar 0x8004, 2720
	SetVar 0x4020, SPRITE_GSLEADER10
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_57
_cv_next_67:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_68
	SetFlag 0x22F3
	SetVar 0x8004, 2704
	SetVar 0x4020, SPRITE_GSLEADER15
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_57
_cv_next_68:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_69
	SetFlag 0x22F3
	SetVar 0x8004, 2694
	SetVar 0x4020, SPRITE_GSBIGFOUR3
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_57
_cv_next_69:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_70
	SetFlag 0x22F3
	SetVar 0x8004, 2718
	SetVar 0x4020, SPRITE_GSOLDWOMAN1
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_57
_cv_next_70:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_71
	SetFlag 0x22F3
	SetVar 0x8004, 2714
	SetVar 0x4020, SPRITE_GSBIGFOUR4
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_57
_cv_next_71:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_72
	SetFlag 0x22F3
	SetVar 0x8004, 2688
	SetVar 0x4020, SPRITE_GSBIGFOUR3
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_57
_cv_next_72:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_73
	SetFlag 0x22F3
	SetVar 0x8004, 2700
	SetVar 0x4020, SPRITE_GSOLDWOMAN1
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_57
_cv_next_73:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_74
	SetFlag 0x22F3
	SetVar 0x8004, 2716
	SetVar 0x4020, SPRITE_WATARU
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_57
_cv_next_74:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_75
	SetFlag 0x22F3
	SetVar 0x8004, 2690
	SetVar 0x4020, SPRITE_WATARU
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_57
_cv_next_75:
_cv_done_57:
	GoTo _cv_gift_55
_cv_gift_56:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_gift_76
	GoToIfSet 0x22F4, _cv_gift_55
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_78
	SetFlag 0x22F4
	SetVar 0x8004, 2697
	SetVar 0x4020, SPRITE_GSLEADER14
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_77
_cv_next_78:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_79
	SetFlag 0x22F4
	SetVar 0x8004, 2687
	SetVar 0x4020, SPRITE_GSLEADER14
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_77
_cv_next_79:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_80
	SetFlag 0x22F4
	SetVar 0x8004, 2707
	SetVar 0x4020, SPRITE_GSLEADER11
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_77
_cv_next_80:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_81
	SetFlag 0x22F4
	SetVar 0x8004, 2711
	SetVar 0x4020, SPRITE_GSLEADER9
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_77
_cv_next_81:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_82
	SetFlag 0x22F4
	SetVar 0x8004, 2703
	SetVar 0x4020, SPRITE_GSLEADER9
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_77
_cv_next_82:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_83
	SetFlag 0x22F4
	SetVar 0x8004, 2709
	SetVar 0x4020, SPRITE_GSLEADER12
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_77
_cv_next_83:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_84
	SetFlag 0x22F4
	SetVar 0x8004, 2693
	SetVar 0x4020, SPRITE_GSBIGFOUR2
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_77
_cv_next_84:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_85
	SetFlag 0x22F4
	SetVar 0x8004, 2699
	SetVar 0x4020, SPRITE_GSBIGFOUR2
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_77
_cv_next_85:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_86
	SetFlag 0x22F4
	SetVar 0x8004, 2713
	SetVar 0x4020, SPRITE_GSLEADER10
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_77
_cv_next_86:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_87
	SetFlag 0x22F4
	SetVar 0x8004, 2721
	SetVar 0x4020, SPRITE_GSLEADER10
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_77
_cv_next_87:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_88
	SetFlag 0x22F4
	SetVar 0x8004, 2705
	SetVar 0x4020, SPRITE_GSLEADER15
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_done_77
_cv_next_88:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_89
	SetFlag 0x22F4
	SetVar 0x8004, 2695
	SetVar 0x4020, SPRITE_GSBIGFOUR3
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_77
_cv_next_89:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_90
	SetFlag 0x22F4
	SetVar 0x8004, 2719
	SetVar 0x4020, SPRITE_GSOLDWOMAN1
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_77
_cv_next_90:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_91
	SetFlag 0x22F4
	SetVar 0x8004, 2715
	SetVar 0x4020, SPRITE_GSBIGFOUR4
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_77
_cv_next_91:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_92
	SetFlag 0x22F4
	SetVar 0x8004, 2689
	SetVar 0x4020, SPRITE_GSBIGFOUR3
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_77
_cv_next_92:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_93
	SetFlag 0x22F4
	SetVar 0x8004, 2701
	SetVar 0x4020, SPRITE_GSOLDWOMAN1
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_77
_cv_next_93:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_94
	SetFlag 0x22F4
	SetVar 0x8004, 2717
	SetVar 0x4020, SPRITE_WATARU
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_77
_cv_next_94:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_95
	SetFlag 0x22F4
	SetVar 0x8004, 2691
	SetVar 0x4020, SPRITE_WATARU
	SetVar VAR_SPECIAL_RESULT, 2
	GoTo _cv_done_77
_cv_next_95:
_cv_done_77:
	GoTo _cv_gift_55
_cv_gift_76:
_cv_gift_55:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_Return
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymCandidate_EventScript_MentorGiveItem
	PlaySE SEQ_SE_DP_DOOR
	BufferPlayersName 6
	NPCMsg msg_0531_T11GYM0101_GymCandidate_Text_SomeoneToSeeYou
	WaitButton
	CanvasCloseMsg
	Call GymCandidate_EventScript_VisitorWalksIn
	Call GymCandidate_EventScript_MentorGiveItem
	Call GymCandidate_EventScript_VisitorWalksOut
	Return
	
GymCandidate_EventScript_Offer:
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_next_97
	SetVar 0x401F, 38
	GoTo _cv_done_96
_cv_next_97:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_next_98
	SetVar 0x401F, 39
	GoTo _cv_done_96
_cv_next_98:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_next_99
	SetVar 0x401F, 40
	GoTo _cv_done_96
_cv_next_99:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_next_100
	SetVar 0x401F, 41
	GoTo _cv_done_96
_cv_next_100:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_next_101
	SetVar 0x401F, 42
	GoTo _cv_done_96
_cv_next_101:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_next_102
	SetVar 0x401F, 43
	GoTo _cv_done_96
_cv_next_102:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_next_103
	SetVar 0x401F, 44
	GoTo _cv_done_96
_cv_next_103:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_next_104
	SetVar 0x401F, 45
	GoTo _cv_done_96
_cv_next_104:
_cv_done_96:
	Call _cv_str4
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_105
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_106
_cv_yes_105:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_106:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_NotYet
	SetVar 0x8007, 0
	GoTo GymCandidate_EventScript_Start
	
GymCandidate_EventScript_Return:
	Return
	
GymCandidate_EventScript_OwnGym:
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_next_108
	SetVar 0x401F, 46
	GoTo _cv_done_107
_cv_next_108:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_next_109
	SetVar 0x401F, 47
	GoTo _cv_done_107
_cv_next_109:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_next_110
	SetVar 0x401F, 48
	GoTo _cv_done_107
_cv_next_110:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_next_111
	SetVar 0x401F, 49
	GoTo _cv_done_107
_cv_next_111:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_next_112
	SetVar 0x401F, 50
	GoTo _cv_done_107
_cv_next_112:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_next_113
	SetVar 0x401F, 51
	GoTo _cv_done_107
_cv_next_113:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_next_114
	SetVar 0x401F, 52
	GoTo _cv_done_107
_cv_next_114:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_next_115
	SetVar 0x401F, 53
	GoTo _cv_done_107
_cv_next_115:
_cv_done_107:
	Call _cv_str4
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_NotYet:
	NPCMsg msg_0531_T11GYM0101_GymCandidate_Text_NotYet
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_Start:
	CanvasCheckTeam 7, 0x5019
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe GymCandidate_EventScript_TeamBreaksRules
	SetVar 0x800B, 0
	Call GymCandidate_EventScript_TakeLeadersPlace
	GoTo GymCandidate_EventScript_NextGuest
	
GymCandidate_EventScript_ShowText4:
	Call _cv_str4
	WaitButton
	Return
	
GymCandidate_EventScript_MentorGiveItem:
	CompareVarToValue 0x8009, 6
	GoToIfEq _cv_gift_116
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_119
	SetVar 0x401F, 54
	GoTo _cv_done_118
_cv_next_119:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_120
	SetVar 0x401F, 54
	GoTo _cv_done_118
_cv_next_120:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_121
	SetVar 0x401F, 55
	GoTo _cv_done_118
_cv_next_121:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_122
	SetVar 0x401F, 56
	GoTo _cv_done_118
_cv_next_122:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_123
	SetVar 0x401F, 56
	GoTo _cv_done_118
_cv_next_123:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_124
	SetVar 0x401F, 57
	GoTo _cv_done_118
_cv_next_124:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_125
	SetVar 0x401F, 58
	GoTo _cv_done_118
_cv_next_125:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_126
	SetVar 0x401F, 58
	GoTo _cv_done_118
_cv_next_126:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_127
	SetVar 0x401F, 59
	GoTo _cv_done_118
_cv_next_127:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_128
	SetVar 0x401F, 59
	GoTo _cv_done_118
_cv_next_128:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_129
	SetVar 0x401F, 60
	GoTo _cv_done_118
_cv_next_129:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_130
	SetVar 0x401F, 61
	GoTo _cv_done_118
_cv_next_130:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_131
	SetVar 0x401F, 62
	GoTo _cv_done_118
_cv_next_131:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_132
	SetVar 0x401F, 63
	GoTo _cv_done_118
_cv_next_132:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_133
	SetVar 0x401F, 61
	GoTo _cv_done_118
_cv_next_133:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_134
	SetVar 0x401F, 62
	GoTo _cv_done_118
_cv_next_134:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_135
	SetVar 0x401F, 64
	GoTo _cv_done_118
_cv_next_135:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_136
	SetVar 0x401F, 64
	GoTo _cv_done_118
_cv_next_136:
_cv_done_118:
	GoTo _cv_gift_117
_cv_gift_116:
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_138
	SetVar 0x401F, 65
	GoTo _cv_done_137
_cv_next_138:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_139
	SetVar 0x401F, 65
	GoTo _cv_done_137
_cv_next_139:
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_140
	SetVar 0x401F, 66
	GoTo _cv_done_137
_cv_next_140:
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_141
	SetVar 0x401F, 67
	GoTo _cv_done_137
_cv_next_141:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_142
	SetVar 0x401F, 67
	GoTo _cv_done_137
_cv_next_142:
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_143
	SetVar 0x401F, 68
	GoTo _cv_done_137
_cv_next_143:
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_144
	SetVar 0x401F, 69
	GoTo _cv_done_137
_cv_next_144:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_145
	SetVar 0x401F, 69
	GoTo _cv_done_137
_cv_next_145:
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_146
	SetVar 0x401F, 70
	GoTo _cv_done_137
_cv_next_146:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_147
	SetVar 0x401F, 70
	GoTo _cv_done_137
_cv_next_147:
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_148
	SetVar 0x401F, 71
	GoTo _cv_done_137
_cv_next_148:
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_next_149
	SetVar 0x401F, 72
	GoTo _cv_done_137
_cv_next_149:
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_next_150
	SetVar 0x401F, 73
	GoTo _cv_done_137
_cv_next_150:
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_next_151
	SetVar 0x401F, 74
	GoTo _cv_done_137
_cv_next_151:
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_next_152
	SetVar 0x401F, 72
	GoTo _cv_done_137
_cv_next_152:
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_next_153
	SetVar 0x401F, 73
	GoTo _cv_done_137
_cv_next_153:
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_next_154
	SetVar 0x401F, 75
	GoTo _cv_done_137
_cv_next_154:
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_next_155
	SetVar 0x401F, 75
	GoTo _cv_done_137
_cv_next_155:
_cv_done_137:
_cv_gift_117:
	Call _cv_str4
	WaitButton
	SetOrCopyVar 0x8004, 0x8004
	SetOrCopyVar 0x8005, 1
	HasSpaceForItem 0x8004, 0x8005, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_full_156
	CallStd std_give_item_verbose
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_given_157
_cv_full_156:
	SetVar VAR_SPECIAL_RESULT, 0
_cv_given_157:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymCandidate_EventScript_MentorItemExplain
	BufferItemName 1, 0x8004
	NPCMsg msg_0531_T11GYM0101_GymHack_Text_GiftSentToPC
	WaitButton
	GoTo GymCandidate_EventScript_MentorItemExplain
	
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
	
GymCandidate_EventScript_TeamBreaksRules:
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfEq GymCandidate_EventScript_ItemClause
	NPCMsg msg_0531_T11GYM0101_GymCandidate_Text_TeamBreaksRules
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_TakeLeadersPlace:
	CanvasCandidate 7
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_Return
	CompareVarToValue 0x8007, 0
	GoToIfEq _cv_hold_158
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_next_160
	CanvasBufferMsg 2, msg_0531_T11GYM0101_cv_leader_0
	GoTo _cv_done_159
_cv_next_160:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_next_161
	CanvasBufferMsg 2, msg_0531_T11GYM0101_cv_leader_1
	GoTo _cv_done_159
_cv_next_161:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_next_162
	CanvasBufferMsg 2, msg_0531_T11GYM0101_cv_leader_2
	GoTo _cv_done_159
_cv_next_162:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_next_163
	CanvasBufferMsg 2, msg_0531_T11GYM0101_cv_leader_3
	GoTo _cv_done_159
_cv_next_163:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_next_164
	CanvasBufferMsg 2, msg_0531_T11GYM0101_cv_leader_4
	GoTo _cv_done_159
_cv_next_164:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_next_165
	CanvasBufferMsg 2, msg_0531_T11GYM0101_cv_leader_5
	GoTo _cv_done_159
_cv_next_165:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_next_166
	CanvasBufferMsg 2, msg_0531_T11GYM0101_cv_leader_6
	GoTo _cv_done_159
_cv_next_166:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_next_167
	CanvasBufferMsg 2, msg_0531_T11GYM0101_cv_leader_7
	GoTo _cv_done_159
_cv_next_167:
_cv_done_159:
	SetVar 0x401F, 76
	GoTo _cv_hold_168
_cv_hold_158:
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_next_170
	SetVar 0x401F, 77
	GoTo _cv_done_169
_cv_next_170:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_next_171
	SetVar 0x401F, 78
	GoTo _cv_done_169
_cv_next_171:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_next_172
	SetVar 0x401F, 79
	GoTo _cv_done_169
_cv_next_172:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_next_173
	SetVar 0x401F, 80
	GoTo _cv_done_169
_cv_next_173:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_next_174
	SetVar 0x401F, 81
	GoTo _cv_done_169
_cv_next_174:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_next_175
	SetVar 0x401F, 82
	GoTo _cv_done_169
_cv_next_175:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_next_176
	SetVar 0x401F, 83
	GoTo _cv_done_169
_cv_next_176:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_next_177
	SetVar 0x401F, 84
	GoTo _cv_done_169
_cv_next_177:
_cv_done_169:
_cv_hold_168:
	Call _cv_str4
	WaitButton
	CanvasCloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	CanvasCandidate 8, 0x8007
	CanvasCandidate 11, 0
	WaitMovement
	Wait 30, VAR_SPECIAL_RESULT
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	Return
	
GymCandidate_EventScript_NextGuest:
	HealParty
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_guest_178
	CanvasBufferMsg 2, msg_0531_T11GYM0101_cv_leader_0
	CanvasCandidate 0, 12, 2, 0, 0x8007
_cv_guest_178:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_guest_179
	CanvasBufferMsg 2, msg_0531_T11GYM0101_cv_leader_1
	CanvasCandidate 0, 20, 3, 0, 0x8007
_cv_guest_179:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_guest_180
	CanvasBufferMsg 2, msg_0531_T11GYM0101_cv_leader_2
	CanvasCandidate 0, 24, 3, 1, 0x8007
_cv_guest_180:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_guest_181
	CanvasBufferMsg 2, msg_0531_T11GYM0101_cv_leader_3
	CanvasCandidate 0, 29, 4, 1, 0x8007
_cv_guest_181:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_guest_182
	CanvasBufferMsg 2, msg_0531_T11GYM0101_cv_leader_4
	CanvasCandidate 0, 37, 4, 1, 0x8007
_cv_guest_182:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_guest_183
	CanvasBufferMsg 2, msg_0531_T11GYM0101_cv_leader_5
	CanvasCandidate 0, 40, 4, 2, 0x8007
_cv_guest_183:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_guest_184
	CanvasBufferMsg 2, msg_0531_T11GYM0101_cv_leader_6
	CanvasCandidate 0, 44, 5, 2, 0x8007
_cv_guest_184:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_guest_185
	CanvasBufferMsg 2, msg_0531_T11GYM0101_cv_leader_7
	CanvasCandidate 0, 47, 5, 2, 0x8007
_cv_guest_185:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_next_187
	SetVar 0x4020, SPRITE_GSMAN3
	GoTo _cv_done_186
_cv_next_187:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfNe _cv_next_188
	SetVar 0x4020, SPRITE_GSWOMAN3
	GoTo _cv_done_186
_cv_next_188:
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfNe _cv_next_189
	SetVar 0x4020, SPRITE_GSMAN3
	GoTo _cv_done_186
_cv_next_189:
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfNe _cv_next_190
	SetVar 0x4020, SPRITE_GSWOMAN3
	GoTo _cv_done_186
_cv_next_190:
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfNe _cv_next_191
	SetVar 0x4020, SPRITE_GSFIGHTER
	GoTo _cv_done_186
_cv_next_191:
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfNe _cv_next_192
	SetVar 0x4020, SPRITE_GSGENTLEMAN
	GoTo _cv_done_186
_cv_next_192:
	CompareVarToValue VAR_SPECIAL_RESULT, 6
	GoToIfNe _cv_next_193
	SetVar 0x4020, SPRITE_MOUNT_2
	GoTo _cv_done_186
_cv_next_193:
	CompareVarToValue VAR_SPECIAL_RESULT, 7
	GoToIfNe _cv_next_194
	SetVar 0x4020, SPRITE_GSMAN2
	GoTo _cv_done_186
_cv_next_194:
	CompareVarToValue VAR_SPECIAL_RESULT, 8
	GoToIfNe _cv_next_195
	SetVar 0x4020, SPRITE_BADMAN
	GoTo _cv_done_186
_cv_next_195:
	CompareVarToValue VAR_SPECIAL_RESULT, 9
	GoToIfNe _cv_next_196
	SetVar 0x4020, SPRITE_WORKMAN
	GoTo _cv_done_186
_cv_next_196:
	CompareVarToValue VAR_SPECIAL_RESULT, 10
	GoToIfNe _cv_next_197
	SetVar 0x4020, SPRITE_GSASSISTANTM
	GoTo _cv_done_186
_cv_next_197:
	CompareVarToValue VAR_SPECIAL_RESULT, 11
	GoToIfNe _cv_next_198
	SetVar 0x4020, SPRITE_MANIA
	GoTo _cv_done_186
_cv_next_198:
	CompareVarToValue VAR_SPECIAL_RESULT, 12
	GoToIfNe _cv_next_199
	SetVar 0x4020, SPRITE_CAMPBOY_2
	GoTo _cv_done_186
_cv_next_199:
	CompareVarToValue VAR_SPECIAL_RESULT, 13
	GoToIfNe _cv_next_200
	SetVar 0x4020, SPRITE_SEAMAN_2
	GoTo _cv_done_186
_cv_next_200:
	CompareVarToValue VAR_SPECIAL_RESULT, 14
	GoToIfNe _cv_next_201
	SetVar 0x4020, SPRITE_FISHING_2
	GoTo _cv_done_186
_cv_next_201:
	CompareVarToValue VAR_SPECIAL_RESULT, 15
	GoToIfNe _cv_next_202
	SetVar 0x4020, SPRITE_GSBOY2
	GoTo _cv_done_186
_cv_next_202:
	CompareVarToValue VAR_SPECIAL_RESULT, 16
	GoToIfNe _cv_next_203
	SetVar 0x4020, SPRITE_WOMAN2
	GoTo _cv_done_186
_cv_next_203:
	CompareVarToValue VAR_SPECIAL_RESULT, 17
	GoToIfNe _cv_next_204
	SetVar 0x4020, SPRITE_GSGIRL2
	GoTo _cv_done_186
_cv_next_204:
	CompareVarToValue VAR_SPECIAL_RESULT, 18
	GoToIfNe _cv_next_205
	SetVar 0x4020, SPRITE_PICNICGIRL_2
	GoTo _cv_done_186
_cv_next_205:
	CompareVarToValue VAR_SPECIAL_RESULT, 19
	GoToIfNe _cv_next_206
	SetVar 0x4020, SPRITE_GSGIRL3
	GoTo _cv_done_186
_cv_next_206:
	CompareVarToValue VAR_SPECIAL_RESULT, 20
	GoToIfNe _cv_next_207
	SetVar 0x4020, SPRITE_GSSWIMMERW
	GoTo _cv_done_186
_cv_next_207:
	CompareVarToValue VAR_SPECIAL_RESULT, 21
	GoToIfNe _cv_next_208
	SetVar 0x4020, SPRITE_GSSWIMMERM
	GoTo _cv_done_186
_cv_next_208:
_cv_done_186:
	Random 0x5048, 4
	Random 0x5049, 3
	Random 0x504A, 3
	Random 0x504B, 2
	SetVar 0x504C, 0
	GoToIfUnset 0x208D, _cv_single_209
	Random 0x401E, 3
	CompareVarToValue 0x401E, 0
	GoToIfEq _cv_single_209
	SetVar 0x504C, 1
_cv_single_209:
	CompareVarToValue 0x800B, 0
	CallIfEq GymCandidate_EventScript_LaterThatDay
	CompareVarToValue 0x800B, 0
	CallIfNe GymCandidate_EventScript_AnotherOne
	CanvasCloseMsg
	Call GymCandidate_EventScript_ChallengerWalksIn
	CompareVarToValue 0x5048, 0
	GoToIfNe _cv_line_211
	NPCMsg msg_0531_T11GYM0101_cv_guest_intro_0
	WaitButton
	GoTo _cv_line_210
_cv_line_211:
	CompareVarToValue 0x5048, 1
	GoToIfNe _cv_line_212
	NPCMsg msg_0531_T11GYM0101_cv_guest_intro_1
	WaitButton
	GoTo _cv_line_210
_cv_line_212:
	CompareVarToValue 0x5048, 2
	GoToIfNe _cv_line_213
	NPCMsg msg_0531_T11GYM0101_cv_guest_intro_2
	WaitButton
	GoTo _cv_line_210
_cv_line_213:
	CompareVarToValue 0x5048, 3
	GoToIfNe _cv_line_214
	NPCMsg msg_0531_T11GYM0101_cv_guest_intro_3
	WaitButton
	GoTo _cv_line_210
_cv_line_214:
_cv_line_210:
	CanvasCloseMsg
	CanvasCloseMsg
	CompareVarToValue 0x504C, 0
	GoToIfNe _cv_battle_216
	CompareVarToValue 0x5049, 0
	GoToIfNe _cv_battle_216
	ClearTrainerFlag 1470
	TrainerBattle 1470, 0, 1, 0
	GoTo _cv_battle_215
_cv_battle_216:
	CompareVarToValue 0x504C, 0
	GoToIfNe _cv_battle_217
	CompareVarToValue 0x5049, 1
	GoToIfNe _cv_battle_217
	ClearTrainerFlag 1471
	TrainerBattle 1471, 0, 1, 0
	GoTo _cv_battle_215
_cv_battle_217:
	CompareVarToValue 0x504C, 0
	GoToIfNe _cv_battle_218
	CompareVarToValue 0x5049, 2
	GoToIfNe _cv_battle_218
	ClearTrainerFlag 1472
	TrainerBattle 1472, 0, 1, 0
	GoTo _cv_battle_215
_cv_battle_218:
	CompareVarToValue 0x504C, 1
	GoToIfNe _cv_battle_219
	CompareVarToValue 0x5049, 0
	GoToIfNe _cv_battle_219
	ClearTrainerFlag 1473
	TrainerBattle 1473, 1473, 1, 0
	GoTo _cv_battle_215
_cv_battle_219:
	CompareVarToValue 0x504C, 1
	GoToIfNe _cv_battle_220
	CompareVarToValue 0x5049, 1
	GoToIfNe _cv_battle_220
	ClearTrainerFlag 1474
	TrainerBattle 1474, 1474, 1, 0
	GoTo _cv_battle_215
_cv_battle_220:
	CompareVarToValue 0x504C, 1
	GoToIfNe _cv_battle_221
	CompareVarToValue 0x5049, 2
	GoToIfNe _cv_battle_221
	ClearTrainerFlag 1475
	TrainerBattle 1475, 1475, 1, 0
	GoTo _cv_battle_215
_cv_battle_221:
_cv_battle_215:
	CheckBattleWon VAR_SPECIAL_RESULT
	CanvasCandidate 12
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfNe GymCandidate_EventScript_GuestWon
	HealParty
	CompareVarToValue 0x504A, 0
	GoToIfNe _cv_line_223
	NPCMsg msg_0531_T11GYM0101_cv_guest_after_0
	WaitButton
	GoTo _cv_line_222
_cv_line_223:
	CompareVarToValue 0x504A, 1
	GoToIfNe _cv_line_224
	NPCMsg msg_0531_T11GYM0101_cv_guest_after_1
	WaitButton
	GoTo _cv_line_222
_cv_line_224:
	CompareVarToValue 0x504A, 2
	GoToIfNe _cv_line_225
	NPCMsg msg_0531_T11GYM0101_cv_guest_after_2
	WaitButton
	GoTo _cv_line_222
_cv_line_225:
_cv_line_222:
	Call GymCandidate_EventScript_VisitorWalksOut
	AddVar 0x800B, 1
	SetVar VAR_SPECIAL_RESULT, 0
	SetVar 0x401E, 1
	CompareVarToValue 0x8007, 0
	GoToIfNe _cv_guests_226
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_next_228
	SetVar 0x401E, 1
	GoTo _cv_done_227
_cv_next_228:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_next_229
	SetVar 0x401E, 1
	GoTo _cv_done_227
_cv_next_229:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_next_230
	SetVar 0x401E, 1
	GoTo _cv_done_227
_cv_next_230:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_next_231
	SetVar 0x401E, 1
	GoTo _cv_done_227
_cv_next_231:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_next_232
	SetVar 0x401E, 2
	GoTo _cv_done_227
_cv_next_232:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_next_233
	SetVar 0x401E, 2
	GoTo _cv_done_227
_cv_next_233:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_next_234
	SetVar 0x401E, 2
	GoTo _cv_done_227
_cv_next_234:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_next_235
	SetVar 0x401E, 2
	GoTo _cv_done_227
_cv_next_235:
_cv_done_227:
_cv_guests_226:
	CompareVarToVar 0x800B, 0x401E
	GoToIfGe _cv_guests_236
	SetVar VAR_SPECIAL_RESULT, 1
_cv_guests_236:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymCandidate_EventScript_NextGuest
	Call GymCandidate_EventScript_ReturnLeadersPlace
	CompareVarToValue 0x8007, 1
	GoToIfEq GymCandidate_EventScript_ShiftDone
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_next_256
	SetFlag 0x2093
	SetVar 0x401F, 85
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_238
	SetVar 0x401F, 86
	GoTo _cv_done_237
_cv_next_238:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_239
	SetVar 0x401F, 87
	GoTo _cv_done_237
_cv_next_239:
_cv_done_237:
	GoTo _cv_done_255
_cv_next_256:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_next_257
	SetFlag 0x2094
	SetVar 0x401F, 88
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_241
	SetVar 0x401F, 89
	GoTo _cv_done_240
_cv_next_241:
_cv_done_240:
	GoTo _cv_done_255
_cv_next_257:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_next_258
	SetFlag 0x2095
	SetVar 0x401F, 90
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_243
	SetVar 0x401F, 91
	GoTo _cv_done_242
_cv_next_243:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_244
	SetVar 0x401F, 92
	GoTo _cv_done_242
_cv_next_244:
_cv_done_242:
	GoTo _cv_done_255
_cv_next_258:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_next_259
	SetFlag 0x2096
	SetVar 0x401F, 93
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_246
	SetVar 0x401F, 94
	GoTo _cv_done_245
_cv_next_246:
_cv_done_245:
	GoTo _cv_done_255
_cv_next_259:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_next_260
	SetFlag 0x2097
	SetVar 0x401F, 95
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_248
	SetVar 0x401F, 96
	GoTo _cv_done_247
_cv_next_248:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_249
	SetVar 0x401F, 97
	GoTo _cv_done_247
_cv_next_249:
_cv_done_247:
	GoTo _cv_done_255
_cv_next_260:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_next_261
	SetFlag 0x2098
	SetVar 0x401F, 98
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_251
	SetVar 0x401F, 99
	GoTo _cv_done_250
_cv_next_251:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_252
	SetVar 0x401F, 100
	GoTo _cv_done_250
_cv_next_252:
_cv_done_250:
	GoTo _cv_done_255
_cv_next_261:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_next_262
	SetFlag 0x2099
	SetVar 0x401F, 101
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_254
	SetVar 0x401F, 102
	GoTo _cv_done_253
_cv_next_254:
_cv_done_253:
	GoTo _cv_done_255
_cv_next_262:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_next_263
	SetFlag 0x2007
	SetVar 0x401F, 103
	GoTo _cv_done_255
_cv_next_263:
_cv_done_255:
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x2093, _cv_appr_264
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_264:
	GoToIfUnset 0x2094, _cv_appr_265
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_265:
	GoToIfUnset 0x2095, _cv_appr_266
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_266:
	GoToIfUnset 0x2096, _cv_appr_267
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_267:
	GoToIfUnset 0x2097, _cv_appr_268
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_268:
	GoToIfUnset 0x2098, _cv_appr_269
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_269:
	GoToIfUnset 0x2099, _cv_appr_270
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_270:
	GoToIfUnset 0x2007, _cv_appr_271
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_271:
	BufferInt 0, VAR_SPECIAL_RESULT
	PlayFanfare SEQ_ME_LVUP
	Call _cv_str4
	WaitButton
	WaitFanfare
	NPCMsg msg_0531_T11GYM0101_GymCandidate_Text_ApprovalCount
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_MentorItemExplain:
	BufferItemName 0, 0x8004
	CompareVarToValue 0x8009, 6
	GoToIfEq GymCandidate_EventScript_EdgeItemExplain
	NPCMsg msg_0531_T11GYM0101_GymCandidate_Text_GuardItemExplain
	WaitButton
	Call Outfits_EventScript_GymUniform
	Return
	
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
	
GymCandidate_EventScript_ItemClause:
	Call EventScript_GymHack_ShowTeamRuleMessage
	CanvasCloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_LaterThatDay:
	NPCMsg msg_0531_T11GYM0101_GymCandidate_Text_LaterThatDay
	WaitButton
	Return
	
GymCandidate_EventScript_AnotherOne:
	NPCMsg msg_0531_T11GYM0101_GymCandidate_Text_AnotherOne
	WaitButton
	Return
	
GymCandidate_EventScript_ChallengerWalksIn:
	CanvasCandidate 4, 1
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_ChallengerAppears
	MovePerson 0x800A, 0x8005, 0x8006
	ClearFlag 0x2017
	ShowPerson 0x800A
	PlaySE SEQ_SE_DP_KAIDAN2
	CanvasCandidate 5, 0x800A, 0
	WaitMovement
	CanvasCandidate 2, 0x800A
	Return
	
GymCandidate_EventScript_GuestWon:
	HealParty
	CompareVarToValue 0x504B, 0
	GoToIfNe _cv_line_273
	NPCMsg msg_0531_T11GYM0101_cv_guest_win_0
	WaitButton
	GoTo _cv_line_272
_cv_line_273:
	CompareVarToValue 0x504B, 1
	GoToIfNe _cv_line_274
	NPCMsg msg_0531_T11GYM0101_cv_guest_win_1
	WaitButton
	GoTo _cv_line_272
_cv_line_274:
_cv_line_272:
	Call GymCandidate_EventScript_VisitorWalksOut
	Call GymCandidate_EventScript_ReturnLeadersPlace
	NPCMsg msg_0531_T11GYM0101_GymCandidate_Text_TryAgain
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_ReturnLeadersPlace:
	CanvasCandidate 9
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_Return
	CanvasCloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	CanvasCandidate 11, 1
	WaitMovement
	CanvasCandidate 10
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	Return
	
GymCandidate_EventScript_ShiftDone:
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_next_276
	SetVar 0x401F, 104
	GoTo _cv_done_275
_cv_next_276:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_next_277
	SetVar 0x401F, 105
	GoTo _cv_done_275
_cv_next_277:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_next_278
	SetVar 0x401F, 106
	GoTo _cv_done_275
_cv_next_278:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_next_279
	SetVar 0x401F, 107
	GoTo _cv_done_275
_cv_next_279:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_next_280
	SetVar 0x401F, 108
	GoTo _cv_done_275
_cv_next_280:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_next_281
	SetVar 0x401F, 109
	GoTo _cv_done_275
_cv_next_281:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_next_282
	SetVar 0x401F, 110
	GoTo _cv_done_275
_cv_next_282:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_next_283
	SetVar 0x401F, 111
	GoTo _cv_done_275
_cv_next_283:
_cv_done_275:
	Call _cv_str4
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_EdgeItemExplain:
	NPCMsg msg_0531_T11GYM0101_GymCandidate_Text_EdgeItemExplain
	WaitButton
	Return
	
Outfits_EventScript_GymUniform:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Outfits_EventScript_Return
	PlayFanfare SEQ_ME_ITEM
	BufferPlayersName 6
	NPCMsg msg_0531_T11GYM0101_Outfits_Text_ReceivedGymUniform
	WaitFanfare
	BufferPlayersName 6
	NPCMsg msg_0531_T11GYM0101_Outfits_Text_PutInWardrobe
	WaitButton
	GoTo Outfits_EventScript_Return
	
GymCandidate_EventScript_MentorNoRoom:
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	Return
	
GymCandidate_EventScript_ChallengerAppears:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	CanvasCandidate 1
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_GuestNoRoom
	MovePerson 0x800A, 0x8005, 0x8006
	ClearFlag 0x2017
	ShowPerson 0x800A
	CanvasCandidate 2, 0x800A
	GoTo GymCandidate_EventScript_GuestNoRoom
	
Outfits_EventScript_Return:
	Return
	
GymCandidate_EventScript_GuestNoRoom:
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	Return

_cv_str4:
	BufferPlayersName 6
	BufferRivalsName 7
	CompareVarToValue 0x401F, 1
	GoToIfNe _cv_str4_0
	NPCMsg msg_0531_T11GYM0101_cv_mentor_prebattle_rock
	Return
_cv_str4_0:
	CompareVarToValue 0x401F, 2
	GoToIfNe _cv_str4_1
	NPCMsg msg_0531_T11GYM0101_cv_mentor_prebattle_normal
	Return
_cv_str4_1:
	CompareVarToValue 0x401F, 3
	GoToIfNe _cv_str4_2
	NPCMsg msg_0531_T11GYM0101_cv_mentor_prebattle_water
	Return
_cv_str4_2:
	CompareVarToValue 0x401F, 4
	GoToIfNe _cv_str4_3
	NPCMsg msg_0531_T11GYM0101_cv_mentor_prebattle_electric
	Return
_cv_str4_3:
	CompareVarToValue 0x401F, 5
	GoToIfNe _cv_str4_4
	NPCMsg msg_0531_T11GYM0101_cv_mentor_prebattle_steel
	Return
_cv_str4_4:
	CompareVarToValue 0x401F, 6
	GoToIfNe _cv_str4_5
	NPCMsg msg_0531_T11GYM0101_cv_mentor_prebattle_grass
	Return
_cv_str4_5:
	CompareVarToValue 0x401F, 7
	GoToIfNe _cv_str4_6
	NPCMsg msg_0531_T11GYM0101_cv_mentor_prebattle_poison
	Return
_cv_str4_6:
	CompareVarToValue 0x401F, 8
	GoToIfNe _cv_str4_7
	NPCMsg msg_0531_T11GYM0101_cv_mentor_prebattle_bug
	Return
_cv_str4_7:
	CompareVarToValue 0x401F, 9
	GoToIfNe _cv_str4_8
	NPCMsg msg_0531_T11GYM0101_cv_mentor_prebattle_psychic
	Return
_cv_str4_8:
	CompareVarToValue 0x401F, 10
	GoToIfNe _cv_str4_9
	NPCMsg msg_0531_T11GYM0101_cv_mentor_prebattle_fairy
	Return
_cv_str4_9:
	CompareVarToValue 0x401F, 11
	GoToIfNe _cv_str4_10
	NPCMsg msg_0531_T11GYM0101_cv_mentor_prebattle_fire
	Return
_cv_str4_10:
	CompareVarToValue 0x401F, 12
	GoToIfNe _cv_str4_11
	NPCMsg msg_0531_T11GYM0101_cv_leader_repeatOffer_0
	Return
_cv_str4_11:
	CompareVarToValue 0x401F, 13
	GoToIfNe _cv_str4_12
	NPCMsg msg_0531_T11GYM0101_cv_leader_repeatOffer_1
	Return
_cv_str4_12:
	CompareVarToValue 0x401F, 14
	GoToIfNe _cv_str4_13
	NPCMsg msg_0531_T11GYM0101_cv_leader_repeatOffer_2
	Return
_cv_str4_13:
	CompareVarToValue 0x401F, 15
	GoToIfNe _cv_str4_14
	NPCMsg msg_0531_T11GYM0101_cv_leader_repeatOffer_3
	Return
_cv_str4_14:
	CompareVarToValue 0x401F, 16
	GoToIfNe _cv_str4_15
	NPCMsg msg_0531_T11GYM0101_cv_leader_repeatOffer_4
	Return
_cv_str4_15:
	CompareVarToValue 0x401F, 17
	GoToIfNe _cv_str4_16
	NPCMsg msg_0531_T11GYM0101_cv_leader_repeatOffer_5
	Return
_cv_str4_16:
	CompareVarToValue 0x401F, 18
	GoToIfNe _cv_str4_17
	NPCMsg msg_0531_T11GYM0101_cv_leader_repeatOffer_6
	Return
_cv_str4_17:
	CompareVarToValue 0x401F, 19
	GoToIfNe _cv_str4_18
	NPCMsg msg_0531_T11GYM0101_cv_leader_repeatOffer_7
	Return
_cv_str4_18:
	CompareVarToValue 0x401F, 20
	GoToIfNe _cv_str4_19
	NPCMsg msg_0531_T11GYM0101_cv_mentor_first_rock
	Return
_cv_str4_19:
	CompareVarToValue 0x401F, 21
	GoToIfNe _cv_str4_20
	NPCMsg msg_0531_T11GYM0101_cv_mentor_first_normal
	Return
_cv_str4_20:
	CompareVarToValue 0x401F, 22
	GoToIfNe _cv_str4_21
	NPCMsg msg_0531_T11GYM0101_cv_mentor_first_water
	Return
_cv_str4_21:
	CompareVarToValue 0x401F, 23
	GoToIfNe _cv_str4_22
	NPCMsg msg_0531_T11GYM0101_cv_mentor_first_electric
	Return
_cv_str4_22:
	CompareVarToValue 0x401F, 24
	GoToIfNe _cv_str4_23
	NPCMsg msg_0531_T11GYM0101_cv_mentor_first_steel
	Return
_cv_str4_23:
	CompareVarToValue 0x401F, 25
	GoToIfNe _cv_str4_24
	NPCMsg msg_0531_T11GYM0101_cv_mentor_first_grass
	Return
_cv_str4_24:
	CompareVarToValue 0x401F, 26
	GoToIfNe _cv_str4_25
	NPCMsg msg_0531_T11GYM0101_cv_mentor_first_poison
	Return
_cv_str4_25:
	CompareVarToValue 0x401F, 27
	GoToIfNe _cv_str4_26
	NPCMsg msg_0531_T11GYM0101_cv_mentor_first_bug
	Return
_cv_str4_26:
	CompareVarToValue 0x401F, 28
	GoToIfNe _cv_str4_27
	NPCMsg msg_0531_T11GYM0101_cv_mentor_first_psychic
	Return
_cv_str4_27:
	CompareVarToValue 0x401F, 29
	GoToIfNe _cv_str4_28
	NPCMsg msg_0531_T11GYM0101_cv_mentor_first_fairy
	Return
_cv_str4_28:
	CompareVarToValue 0x401F, 30
	GoToIfNe _cv_str4_29
	NPCMsg msg_0531_T11GYM0101_cv_mentor_first_fire
	Return
_cv_str4_29:
	CompareVarToValue 0x401F, 31
	GoToIfNe _cv_str4_30
	NPCMsg msg_0531_T11GYM0101_cv_mentor_first_ground
	Return
_cv_str4_30:
	CompareVarToValue 0x401F, 32
	GoToIfNe _cv_str4_31
	NPCMsg msg_0531_T11GYM0101_cv_mentor_first_dark
	Return
_cv_str4_31:
	CompareVarToValue 0x401F, 33
	GoToIfNe _cv_str4_32
	NPCMsg msg_0531_T11GYM0101_cv_mentor_first_ice
	Return
_cv_str4_32:
	CompareVarToValue 0x401F, 34
	GoToIfNe _cv_str4_33
	NPCMsg msg_0531_T11GYM0101_cv_mentor_first_fighting
	Return
_cv_str4_33:
	CompareVarToValue 0x401F, 35
	GoToIfNe _cv_str4_34
	NPCMsg msg_0531_T11GYM0101_cv_mentor_first_ghost
	Return
_cv_str4_34:
	CompareVarToValue 0x401F, 36
	GoToIfNe _cv_str4_35
	NPCMsg msg_0531_T11GYM0101_cv_mentor_first_dragon
	Return
_cv_str4_35:
	CompareVarToValue 0x401F, 37
	GoToIfNe _cv_str4_36
	NPCMsg msg_0531_T11GYM0101_cv_mentor_first_flying
	Return
_cv_str4_36:
	CompareVarToValue 0x401F, 38
	GoToIfNe _cv_str4_37
	NPCMsg msg_0531_T11GYM0101_cv_leader_offer_0
	Return
_cv_str4_37:
	CompareVarToValue 0x401F, 39
	GoToIfNe _cv_str4_38
	NPCMsg msg_0531_T11GYM0101_cv_leader_offer_1
	Return
_cv_str4_38:
	CompareVarToValue 0x401F, 40
	GoToIfNe _cv_str4_39
	NPCMsg msg_0531_T11GYM0101_cv_leader_offer_2
	Return
_cv_str4_39:
	CompareVarToValue 0x401F, 41
	GoToIfNe _cv_str4_40
	NPCMsg msg_0531_T11GYM0101_cv_leader_offer_3
	Return
_cv_str4_40:
	CompareVarToValue 0x401F, 42
	GoToIfNe _cv_str4_41
	NPCMsg msg_0531_T11GYM0101_cv_leader_offer_4
	Return
_cv_str4_41:
	CompareVarToValue 0x401F, 43
	GoToIfNe _cv_str4_42
	NPCMsg msg_0531_T11GYM0101_cv_leader_offer_5
	Return
_cv_str4_42:
	CompareVarToValue 0x401F, 44
	GoToIfNe _cv_str4_43
	NPCMsg msg_0531_T11GYM0101_cv_leader_offer_6
	Return
_cv_str4_43:
	CompareVarToValue 0x401F, 45
	GoToIfNe _cv_str4_44
	NPCMsg msg_0531_T11GYM0101_cv_leader_offer_7
	Return
_cv_str4_44:
	CompareVarToValue 0x401F, 46
	GoToIfNe _cv_str4_45
	NPCMsg msg_0531_T11GYM0101_cv_leader_ownGym_0
	Return
_cv_str4_45:
	CompareVarToValue 0x401F, 47
	GoToIfNe _cv_str4_46
	NPCMsg msg_0531_T11GYM0101_cv_leader_ownGym_1
	Return
_cv_str4_46:
	CompareVarToValue 0x401F, 48
	GoToIfNe _cv_str4_47
	NPCMsg msg_0531_T11GYM0101_cv_leader_ownGym_2
	Return
_cv_str4_47:
	CompareVarToValue 0x401F, 49
	GoToIfNe _cv_str4_48
	NPCMsg msg_0531_T11GYM0101_cv_leader_ownGym_3
	Return
_cv_str4_48:
	CompareVarToValue 0x401F, 50
	GoToIfNe _cv_str4_49
	NPCMsg msg_0531_T11GYM0101_cv_leader_ownGym_4
	Return
_cv_str4_49:
	CompareVarToValue 0x401F, 51
	GoToIfNe _cv_str4_50
	NPCMsg msg_0531_T11GYM0101_cv_leader_ownGym_5
	Return
_cv_str4_50:
	CompareVarToValue 0x401F, 52
	GoToIfNe _cv_str4_51
	NPCMsg msg_0531_T11GYM0101_cv_leader_ownGym_6
	Return
_cv_str4_51:
	CompareVarToValue 0x401F, 53
	GoToIfNe _cv_str4_52
	NPCMsg msg_0531_T11GYM0101_cv_leader_ownGym_7
	Return
_cv_str4_52:
	CompareVarToValue 0x401F, 54
	GoToIfNe _cv_str4_53
	NPCMsg msg_0531_T11GYM0101_cv_mentor_guardGift_0
	Return
_cv_str4_53:
	CompareVarToValue 0x401F, 55
	GoToIfNe _cv_str4_54
	NPCMsg msg_0531_T11GYM0101_cv_mentor_guardGift_1
	Return
_cv_str4_54:
	CompareVarToValue 0x401F, 56
	GoToIfNe _cv_str4_55
	NPCMsg msg_0531_T11GYM0101_cv_mentor_guardGift_2
	Return
_cv_str4_55:
	CompareVarToValue 0x401F, 57
	GoToIfNe _cv_str4_56
	NPCMsg msg_0531_T11GYM0101_cv_mentor_guardGift_3
	Return
_cv_str4_56:
	CompareVarToValue 0x401F, 58
	GoToIfNe _cv_str4_57
	NPCMsg msg_0531_T11GYM0101_cv_mentor_guardGift_4
	Return
_cv_str4_57:
	CompareVarToValue 0x401F, 59
	GoToIfNe _cv_str4_58
	NPCMsg msg_0531_T11GYM0101_cv_mentor_guardGift_5
	Return
_cv_str4_58:
	CompareVarToValue 0x401F, 60
	GoToIfNe _cv_str4_59
	NPCMsg msg_0531_T11GYM0101_cv_mentor_guardGift_6
	Return
_cv_str4_59:
	CompareVarToValue 0x401F, 61
	GoToIfNe _cv_str4_60
	NPCMsg msg_0531_T11GYM0101_cv_mentor_guardGift_9
	Return
_cv_str4_60:
	CompareVarToValue 0x401F, 62
	GoToIfNe _cv_str4_61
	NPCMsg msg_0531_T11GYM0101_cv_mentor_guardGift_10
	Return
_cv_str4_61:
	CompareVarToValue 0x401F, 63
	GoToIfNe _cv_str4_62
	NPCMsg msg_0531_T11GYM0101_cv_mentor_guardGift_8
	Return
_cv_str4_62:
	CompareVarToValue 0x401F, 64
	GoToIfNe _cv_str4_63
	NPCMsg msg_0531_T11GYM0101_cv_mentor_guardGift_11
	Return
_cv_str4_63:
	CompareVarToValue 0x401F, 65
	GoToIfNe _cv_str4_64
	NPCMsg msg_0531_T11GYM0101_cv_mentor_edgeGift_0
	Return
_cv_str4_64:
	CompareVarToValue 0x401F, 66
	GoToIfNe _cv_str4_65
	NPCMsg msg_0531_T11GYM0101_cv_mentor_edgeGift_1
	Return
_cv_str4_65:
	CompareVarToValue 0x401F, 67
	GoToIfNe _cv_str4_66
	NPCMsg msg_0531_T11GYM0101_cv_mentor_edgeGift_2
	Return
_cv_str4_66:
	CompareVarToValue 0x401F, 68
	GoToIfNe _cv_str4_67
	NPCMsg msg_0531_T11GYM0101_cv_mentor_edgeGift_3
	Return
_cv_str4_67:
	CompareVarToValue 0x401F, 69
	GoToIfNe _cv_str4_68
	NPCMsg msg_0531_T11GYM0101_cv_mentor_edgeGift_4
	Return
_cv_str4_68:
	CompareVarToValue 0x401F, 70
	GoToIfNe _cv_str4_69
	NPCMsg msg_0531_T11GYM0101_cv_mentor_edgeGift_5
	Return
_cv_str4_69:
	CompareVarToValue 0x401F, 71
	GoToIfNe _cv_str4_70
	NPCMsg msg_0531_T11GYM0101_cv_mentor_edgeGift_6
	Return
_cv_str4_70:
	CompareVarToValue 0x401F, 72
	GoToIfNe _cv_str4_71
	NPCMsg msg_0531_T11GYM0101_cv_mentor_edgeGift_9
	Return
_cv_str4_71:
	CompareVarToValue 0x401F, 73
	GoToIfNe _cv_str4_72
	NPCMsg msg_0531_T11GYM0101_cv_mentor_edgeGift_10
	Return
_cv_str4_72:
	CompareVarToValue 0x401F, 74
	GoToIfNe _cv_str4_73
	NPCMsg msg_0531_T11GYM0101_cv_mentor_edgeGift_8
	Return
_cv_str4_73:
	CompareVarToValue 0x401F, 75
	GoToIfNe _cv_str4_74
	NPCMsg msg_0531_T11GYM0101_cv_mentor_edgeGift_11
	Return
_cv_str4_74:
	CompareVarToValue 0x401F, 76
	GoToIfNe _cv_str4_75
	NPCMsg msg_0531_T11GYM0101_cv_hold_shift
	Return
_cv_str4_75:
	CompareVarToValue 0x401F, 77
	GoToIfNe _cv_str4_76
	NPCMsg msg_0531_T11GYM0101_cv_leader_observe_0
	Return
_cv_str4_76:
	CompareVarToValue 0x401F, 78
	GoToIfNe _cv_str4_77
	NPCMsg msg_0531_T11GYM0101_cv_leader_observe_1
	Return
_cv_str4_77:
	CompareVarToValue 0x401F, 79
	GoToIfNe _cv_str4_78
	NPCMsg msg_0531_T11GYM0101_cv_leader_observe_2
	Return
_cv_str4_78:
	CompareVarToValue 0x401F, 80
	GoToIfNe _cv_str4_79
	NPCMsg msg_0531_T11GYM0101_cv_leader_observe_3
	Return
_cv_str4_79:
	CompareVarToValue 0x401F, 81
	GoToIfNe _cv_str4_80
	NPCMsg msg_0531_T11GYM0101_cv_leader_observe_4
	Return
_cv_str4_80:
	CompareVarToValue 0x401F, 82
	GoToIfNe _cv_str4_81
	NPCMsg msg_0531_T11GYM0101_cv_leader_observe_5
	Return
_cv_str4_81:
	CompareVarToValue 0x401F, 83
	GoToIfNe _cv_str4_82
	NPCMsg msg_0531_T11GYM0101_cv_leader_observe_6
	Return
_cv_str4_82:
	CompareVarToValue 0x401F, 84
	GoToIfNe _cv_str4_83
	NPCMsg msg_0531_T11GYM0101_cv_leader_observe_7
	Return
_cv_str4_83:
	CompareVarToValue 0x401F, 85
	GoToIfNe _cv_str4_84
	NPCMsg msg_0531_T11GYM0101_cv_leader_approve_0
	Return
_cv_str4_84:
	CompareVarToValue 0x401F, 86
	GoToIfNe _cv_str4_85
	NPCMsg msg_0531_T11GYM0101_cv_mentor_approve_rock
	Return
_cv_str4_85:
	CompareVarToValue 0x401F, 87
	GoToIfNe _cv_str4_86
	NPCMsg msg_0531_T11GYM0101_cv_mentor_approve_normal
	Return
_cv_str4_86:
	CompareVarToValue 0x401F, 88
	GoToIfNe _cv_str4_87
	NPCMsg msg_0531_T11GYM0101_cv_leader_approve_1
	Return
_cv_str4_87:
	CompareVarToValue 0x401F, 89
	GoToIfNe _cv_str4_88
	NPCMsg msg_0531_T11GYM0101_cv_mentor_approve_water
	Return
_cv_str4_88:
	CompareVarToValue 0x401F, 90
	GoToIfNe _cv_str4_89
	NPCMsg msg_0531_T11GYM0101_cv_leader_approve_2
	Return
_cv_str4_89:
	CompareVarToValue 0x401F, 91
	GoToIfNe _cv_str4_90
	NPCMsg msg_0531_T11GYM0101_cv_mentor_approve_electric
	Return
_cv_str4_90:
	CompareVarToValue 0x401F, 92
	GoToIfNe _cv_str4_91
	NPCMsg msg_0531_T11GYM0101_cv_mentor_approve_steel
	Return
_cv_str4_91:
	CompareVarToValue 0x401F, 93
	GoToIfNe _cv_str4_92
	NPCMsg msg_0531_T11GYM0101_cv_leader_approve_3
	Return
_cv_str4_92:
	CompareVarToValue 0x401F, 94
	GoToIfNe _cv_str4_93
	NPCMsg msg_0531_T11GYM0101_cv_mentor_approve_grass
	Return
_cv_str4_93:
	CompareVarToValue 0x401F, 95
	GoToIfNe _cv_str4_94
	NPCMsg msg_0531_T11GYM0101_cv_leader_approve_4
	Return
_cv_str4_94:
	CompareVarToValue 0x401F, 96
	GoToIfNe _cv_str4_95
	NPCMsg msg_0531_T11GYM0101_cv_mentor_approve_poison
	Return
_cv_str4_95:
	CompareVarToValue 0x401F, 97
	GoToIfNe _cv_str4_96
	NPCMsg msg_0531_T11GYM0101_cv_mentor_approve_bug
	Return
_cv_str4_96:
	CompareVarToValue 0x401F, 98
	GoToIfNe _cv_str4_97
	NPCMsg msg_0531_T11GYM0101_cv_leader_approve_5
	Return
_cv_str4_97:
	CompareVarToValue 0x401F, 99
	GoToIfNe _cv_str4_98
	NPCMsg msg_0531_T11GYM0101_cv_mentor_approve_psychic
	Return
_cv_str4_98:
	CompareVarToValue 0x401F, 100
	GoToIfNe _cv_str4_99
	NPCMsg msg_0531_T11GYM0101_cv_mentor_approve_fairy
	Return
_cv_str4_99:
	CompareVarToValue 0x401F, 101
	GoToIfNe _cv_str4_100
	NPCMsg msg_0531_T11GYM0101_cv_leader_approve_6
	Return
_cv_str4_100:
	CompareVarToValue 0x401F, 102
	GoToIfNe _cv_str4_101
	NPCMsg msg_0531_T11GYM0101_cv_mentor_approve_fire
	Return
_cv_str4_101:
	CompareVarToValue 0x401F, 103
	GoToIfNe _cv_str4_102
	NPCMsg msg_0531_T11GYM0101_cv_leader_approve_7
	Return
_cv_str4_102:
	CompareVarToValue 0x401F, 104
	GoToIfNe _cv_str4_103
	NPCMsg msg_0531_T11GYM0101_cv_leader_repeatThanks_0
	Return
_cv_str4_103:
	CompareVarToValue 0x401F, 105
	GoToIfNe _cv_str4_104
	NPCMsg msg_0531_T11GYM0101_cv_leader_repeatThanks_1
	Return
_cv_str4_104:
	CompareVarToValue 0x401F, 106
	GoToIfNe _cv_str4_105
	NPCMsg msg_0531_T11GYM0101_cv_leader_repeatThanks_2
	Return
_cv_str4_105:
	CompareVarToValue 0x401F, 107
	GoToIfNe _cv_str4_106
	NPCMsg msg_0531_T11GYM0101_cv_leader_repeatThanks_3
	Return
_cv_str4_106:
	CompareVarToValue 0x401F, 108
	GoToIfNe _cv_str4_107
	NPCMsg msg_0531_T11GYM0101_cv_leader_repeatThanks_4
	Return
_cv_str4_107:
	CompareVarToValue 0x401F, 109
	GoToIfNe _cv_str4_108
	NPCMsg msg_0531_T11GYM0101_cv_leader_repeatThanks_5
	Return
_cv_str4_108:
	CompareVarToValue 0x401F, 110
	GoToIfNe _cv_str4_109
	NPCMsg msg_0531_T11GYM0101_cv_leader_repeatThanks_6
	Return
_cv_str4_109:
	CompareVarToValue 0x401F, 111
	GoToIfNe _cv_str4_110
	NPCMsg msg_0531_T11GYM0101_cv_leader_repeatThanks_7
	Return
_cv_str4_110:
	Return

_cv_stop:
	NPCMsg msg_0531_T11GYM0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_team_not_allowed:
	Call EventScript_GymHack_ShowTeamRuleMessage
	CanvasCloseMsg
	GetPlayerCoords 0x8008, 0x8009
	GetPlayerFacing 0x800A
	Warp MAP_SAFFRON_GYM, 0, 0x8008, 0x8009, 0x800A
	ReleaseAll
	End
	.balign 4, 0
