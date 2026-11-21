#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T03GYM0101.h"
#include "msgdata/msg/msg_0462_T03GYM0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PewterCity_Gym_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef PewterCity_Gym_EventScript_Brock
	ScrDef PewterCity_Gym_EventScript_GymGuy
	ScrDef GymAides_EventScript_PewterCity
	ScrDef PewterCity_Gym_EventScript_GymStatue
	ScrDef PewterCity_Gym_OnTransitionGuest
	ScrDefEnd
	
PewterCity_Gym_EventScript_Brock:
	SetVar 0x8009, 0
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
	GoToIfEq PewterCity_Gym_EventScript_MentorBattle
	CheckTrainerFlag 1150
	GoToIf TRUE, _cv_beaten_12
	NPCMsg msg_0462_T03GYM0101_PewterCity_Gym_Text_BrockIntro
	WaitButton
	CloseMsg
	CanvasCheckTeam 7, 0x5019
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_team_not_allowed
	TrainerBattle 1150, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_13
	WhiteOut
	End
_cv_won_13:
	SetTrainerFlag 1150
	GoTo PewterCity_Gym_EventScript_DefeatedBrock
_cv_beaten_12:
	GoTo PewterCity_Gym_EventScript_AfterLeaderBattle
	
PewterCity_Gym_EventScript_GymGuy:
	LockAll
	FacePlayer
	GoToIfSet 0x20B6, PewterCity_Gym_EventScript_GymGuyPostVictory
	NPCMsg msg_0462_T03GYM0101_PewterCity_Gym_Text_LetMeTakeYouToTheTop
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_14
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_15
_cv_yes_14:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_15:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq PewterCity_Gym_EventScript_GymGuyTakeMeToTop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PewterCity_Gym_EventScript_GymGuyDontTakeMeToTop
	CloseMsg
	End
	
GymAides_EventScript_PewterCity:
	GoToIfSet 0x2088, GymAides_EventScript_PewterCityAfter
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0462_T03GYM0101_GymAides_Text_PewterCity
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_Gym_EventScript_GymStatue:
	LockAll
	GoToIfSet 0x2088, PewterCity_Gym_EventScript_GymStatuePostVictory
	BufferRivalsName 7
	NPCMsg msg_0462_T03GYM0101_PewterCity_Gym_Text_GymStatue
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_Gym_OnTransitionGuest:
	SetFlag 0x2017
	End
	
PewterCity_Gym_EventScript_MentorBattle:
	CheckTrainerFlag 1150
	GoToIf TRUE, _cv_beaten_16
	CanvasCheckTeam 7, 0x5019
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_team_not_allowed
	TrainerBattle 1150, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_17
	WhiteOut
	End
_cv_won_17:
	SetTrainerFlag 1150
	GoTo PewterCity_Gym_EventScript_DefeatedBrock
_cv_beaten_16:
	GoTo PewterCity_Gym_EventScript_AfterLeaderBattle
	
EventScript_GymHack_ShowTeamRuleMessage:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq EventScript_GymHack_MsgWrongType
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	CallIfEq EventScript_GymHack_MsgDuplicate
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	CallIfEq EventScript_GymHack_MsgDuplicateItem
	Return
	
PewterCity_Gym_EventScript_DefeatedBrock:
	SetFlag 0x20B6
	SetFlag 0x2088
	SetVar 0x5022, 1
	SetFlag 0x20B4
	ClearFlag 0x205B
	SetVar 0x8008, 1
	Call Common_EventScript_SetGymTrainers_Frlg
	GoTo PewterCity_Gym_EventScript_GiveTM39
	End
	
PewterCity_Gym_EventScript_AfterLeaderBattle:
	GoToIfUnset 0x20B7, PewterCity_Gym_EventScript_GiveTM39
	Call GymHack_EventScript_BrockGifts
	Call GymCandidate_EventScript_PewterCityTalk
	NPCMsg msg_0462_T03GYM0101_PewterCity_Gym_Text_BrockPostBattle
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_Gym_EventScript_GymGuyPostVictory:
	NPCMsg msg_0462_T03GYM0101_PewterCity_Gym_Text_YoureChampMaterial
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_Gym_EventScript_GymGuyTakeMeToTop:
	NPCMsg msg_0462_T03GYM0101_PewterCity_Gym_Text_LetsGetHappening
	WaitButton
	GoTo PewterCity_Gym_EventScript_GymGuyAdvice
	CloseMsg
	End
	
PewterCity_Gym_EventScript_GymGuyDontTakeMeToTop:
	NPCMsg msg_0462_T03GYM0101_PewterCity_Gym_Text_ItsFreeLetsGetHappening
	WaitButton
	GoTo PewterCity_Gym_EventScript_GymGuyAdvice
	CloseMsg
	End
	
GymAides_EventScript_PewterCityAfter:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0462_T03GYM0101_GymAides_Text_PewterCityAfter
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PewterCity_Gym_EventScript_GymStatuePostVictory:
	BufferPlayersName 6
	BufferRivalsName 7
	NPCMsg msg_0462_T03GYM0101_PewterCity_Gym_Text_GymStatuePlayerWon
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_GymHack_MsgWrongType:
	NPCMsg msg_0462_T03GYM0101_Text_GymHack_WrongType
	WaitButton
	Return
	
EventScript_GymHack_MsgDuplicate:
	NPCMsg msg_0462_T03GYM0101_Text_GymHack_Duplicate
	WaitButton
	Return
	
EventScript_GymHack_MsgDuplicateItem:
	NPCMsg msg_0462_T03GYM0101_Text_GymHack_DuplicateItem
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
	
PewterCity_Gym_EventScript_GiveTM39:
	NPCMsg msg_0462_T03GYM0101_PewterCity_Gym_Text_TakeThisWithYou
	WaitButton
	HasSpaceForItem ITEM_TM39, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PewterCity_Gym_EventScript_NoRoomForTM39
	GiveItem ITEM_TM39, 1, VAR_SPECIAL_RESULT
	BufferItemName 1, ITEM_TM39
	BufferPlayersName 6
	NPCMsg msg_0462_T03GYM0101_PewterCity_Gym_Text_ReceivedTM39FromBrock
	PlayFanfare SEQ_ME_LVUP
	WaitFanfare
	WaitButton
	SetFlag 0x20B7
	NPCMsg msg_0462_T03GYM0101_PewterCity_Gym_Text_ExplainTM39
	WaitButton
	Call GymHack_EventScript_BrockGifts
	GoTo GymCandidate_EventScript_PewterCityAfterBadge
	CloseMsg
	ReleaseAll
	End
	
GymHack_EventScript_BrockGifts:
	GoToIfSet 0x20B8, GymHack_EventScript_GiftsDone
	NPCMsg msg_0462_T03GYM0101_GymHack_Text_BrockSilverCap
	WaitButton
	SetVar 0x8009, 795
	Call GymHack_EventScript_GiveStatItem
	SetFlag 0x20B8
	NPCMsg msg_0462_T03GYM0101_GymHack_Text_BrockSilverCapAfter
	WaitButton
	Return
	
GymCandidate_EventScript_PewterCityTalk:
	SetVar 0x8009, 0
	SetVar 0x800A, 5
	GoTo GymCandidate_EventScript_TalkAgain
	
PewterCity_Gym_EventScript_GymGuyAdvice:
	NPCMsg msg_0462_T03GYM0101_PewterCity_Gym_Text_TryDifferentPartyOrders
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
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
	
PewterCity_Gym_EventScript_NoRoomForTM39:
	NPCMsg msg_0462_T03GYM0101_PewterCity_Gym_Text_DontHaveRoomForThis
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_PewterCityAfterBadge:
	SetVar 0x8009, 0
	SetVar 0x800A, 5
	GoTo GymCandidate_EventScript_AfterBadge
	End
	
GymHack_EventScript_GiftsDone:
	Return
	
GymHack_EventScript_GiveStatItem:
	SetOrCopyVar 0x8004, 0x8009
	SetOrCopyVar 0x8005, 1
	HasSpaceForItem 0x8004, 0x8005, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_full_18
	CallStd std_give_item_verbose
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_given_19
_cv_full_18:
	SetVar VAR_SPECIAL_RESULT, 0
_cv_given_19:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymHack_EventScript_GiveStatItemDone
	BufferItemName 1, 0x8009
	NPCMsg msg_0462_T03GYM0101_GymHack_Text_GiftSentToPC
	WaitButton
	GoTo GymHack_EventScript_GiveStatItemDone
	
GymCandidate_EventScript_TalkAgain:
	Call GymCandidate_EventScript_MentorGift
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_appr_20
	GoToIfUnset 0x2093, _cv_appr_20
	SetVar VAR_SPECIAL_RESULT, 1
_cv_appr_20:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_appr_21
	GoToIfUnset 0x2094, _cv_appr_21
	SetVar VAR_SPECIAL_RESULT, 1
_cv_appr_21:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_appr_22
	GoToIfUnset 0x2095, _cv_appr_22
	SetVar VAR_SPECIAL_RESULT, 1
_cv_appr_22:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_appr_23
	GoToIfUnset 0x2096, _cv_appr_23
	SetVar VAR_SPECIAL_RESULT, 1
_cv_appr_23:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_appr_24
	GoToIfUnset 0x2097, _cv_appr_24
	SetVar VAR_SPECIAL_RESULT, 1
_cv_appr_24:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_appr_25
	GoToIfUnset 0x2098, _cv_appr_25
	SetVar VAR_SPECIAL_RESULT, 1
_cv_appr_25:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_appr_26
	GoToIfUnset 0x2099, _cv_appr_26
	SetVar VAR_SPECIAL_RESULT, 1
_cv_appr_26:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_appr_27
	GoToIfUnset 0x2007, _cv_appr_27
	SetVar VAR_SPECIAL_RESULT, 1
_cv_appr_27:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_Offer
	CompareVarToValue 0x8009, 7
	GoToIfEq GymCandidate_EventScript_Return
	GoToIfSet 0x2008, GymCandidate_EventScript_OwnGym
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_next_29
	SetVar 0x401F, 12
	GoTo _cv_done_28
_cv_next_29:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_next_30
	SetVar 0x401F, 13
	GoTo _cv_done_28
_cv_next_30:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_next_31
	SetVar 0x401F, 14
	GoTo _cv_done_28
_cv_next_31:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_next_32
	SetVar 0x401F, 15
	GoTo _cv_done_28
_cv_next_32:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_next_33
	SetVar 0x401F, 16
	GoTo _cv_done_28
_cv_next_33:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_next_34
	SetVar 0x401F, 17
	GoTo _cv_done_28
_cv_next_34:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_next_35
	SetVar 0x401F, 18
	GoTo _cv_done_28
_cv_next_35:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_next_36
	SetVar 0x401F, 19
	GoTo _cv_done_28
_cv_next_36:
_cv_done_28:
	Call _cv_str4
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_37
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_38
_cv_yes_37:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_38:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_NotYet
	SetVar 0x8007, 1
	GoTo GymCandidate_EventScript_Start
	CloseMsg
	End
	
GymCandidate_EventScript_AfterBadge:
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_mentor_39
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_mentor_39
	SetVar 0x401F, 20
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_39:
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_mentor_40
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_mentor_40
	SetVar 0x401F, 21
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_40:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_mentor_41
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_mentor_41
	SetVar 0x401F, 22
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_41:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_mentor_42
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_mentor_42
	SetVar 0x401F, 23
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_42:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_mentor_43
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_mentor_43
	SetVar 0x401F, 24
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_43:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_mentor_44
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_mentor_44
	SetVar 0x401F, 25
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_44:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_mentor_45
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_mentor_45
	SetVar 0x401F, 26
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_45:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_mentor_46
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_mentor_46
	SetVar 0x401F, 27
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_46:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_mentor_47
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_mentor_47
	SetVar 0x401F, 28
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_47:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_mentor_48
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_mentor_48
	SetVar 0x401F, 29
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_48:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_mentor_49
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_mentor_49
	SetVar 0x401F, 30
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_49:
	CompareVarToValue 0x8009, 9
	GoToIfNe _cv_mentor_50
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_mentor_50
	SetVar 0x401F, 31
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_50:
	CompareVarToValue 0x8009, 10
	GoToIfNe _cv_mentor_51
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_mentor_51
	SetVar 0x401F, 32
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_51:
	CompareVarToValue 0x8009, 8
	GoToIfNe _cv_mentor_52
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_mentor_52
	SetVar 0x401F, 33
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_52:
	CompareVarToValue 0x8009, 9
	GoToIfNe _cv_mentor_53
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_mentor_53
	SetVar 0x401F, 34
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_53:
	CompareVarToValue 0x8009, 10
	GoToIfNe _cv_mentor_54
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_mentor_54
	SetVar 0x401F, 35
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_54:
	CompareVarToValue 0x8009, 11
	GoToIfNe _cv_mentor_55
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_mentor_55
	SetVar 0x401F, 36
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_55:
	CompareVarToValue 0x8009, 11
	GoToIfNe _cv_mentor_56
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_mentor_56
	SetVar 0x401F, 37
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_56:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq GymCandidate_EventScript_ShowText4
	Call GymCandidate_EventScript_MentorGift
	GoTo GymCandidate_EventScript_Offer
	End
	
GymHack_EventScript_GiveStatItemDone:
	Return
	
GymCandidate_EventScript_MentorGift:
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_Return
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymCandidate_EventScript_MentorGiveItem
	PlaySE SEQ_SE_DP_DOOR
	BufferPlayersName 6
	NPCMsg msg_0462_T03GYM0101_GymCandidate_Text_SomeoneToSeeYou
	WaitButton
	CanvasCloseMsg
	Call GymCandidate_EventScript_VisitorWalksIn
	Call GymCandidate_EventScript_MentorGiveItem
	Call GymCandidate_EventScript_VisitorWalksOut
	Return
	
GymCandidate_EventScript_Offer:
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_next_58
	SetVar 0x401F, 38
	GoTo _cv_done_57
_cv_next_58:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_next_59
	SetVar 0x401F, 39
	GoTo _cv_done_57
_cv_next_59:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_next_60
	SetVar 0x401F, 40
	GoTo _cv_done_57
_cv_next_60:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_next_61
	SetVar 0x401F, 41
	GoTo _cv_done_57
_cv_next_61:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_next_62
	SetVar 0x401F, 42
	GoTo _cv_done_57
_cv_next_62:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_next_63
	SetVar 0x401F, 43
	GoTo _cv_done_57
_cv_next_63:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_next_64
	SetVar 0x401F, 44
	GoTo _cv_done_57
_cv_next_64:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_next_65
	SetVar 0x401F, 45
	GoTo _cv_done_57
_cv_next_65:
_cv_done_57:
	Call _cv_str4
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_66
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_67
_cv_yes_66:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_67:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_NotYet
	SetVar 0x8007, 0
	GoTo GymCandidate_EventScript_Start
	
GymCandidate_EventScript_Return:
	Return
	
GymCandidate_EventScript_OwnGym:
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_next_69
	SetVar 0x401F, 46
	GoTo _cv_done_68
_cv_next_69:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_next_70
	SetVar 0x401F, 47
	GoTo _cv_done_68
_cv_next_70:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_next_71
	SetVar 0x401F, 48
	GoTo _cv_done_68
_cv_next_71:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_next_72
	SetVar 0x401F, 49
	GoTo _cv_done_68
_cv_next_72:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_next_73
	SetVar 0x401F, 50
	GoTo _cv_done_68
_cv_next_73:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_next_74
	SetVar 0x401F, 51
	GoTo _cv_done_68
_cv_next_74:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_next_75
	SetVar 0x401F, 52
	GoTo _cv_done_68
_cv_next_75:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_next_76
	SetVar 0x401F, 53
	GoTo _cv_done_68
_cv_next_76:
_cv_done_68:
	Call _cv_str4
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_NotYet:
	NPCMsg msg_0462_T03GYM0101_GymCandidate_Text_NotYet
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
	Call _cv_str4
	WaitButton
	SetOrCopyVar 0x8004, 0x8004
	SetOrCopyVar 0x8005, 1
	HasSpaceForItem 0x8004, 0x8005, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_full_77
	CallStd std_give_item_verbose
	SetVar VAR_SPECIAL_RESULT, 1
	GoTo _cv_given_78
_cv_full_77:
	SetVar VAR_SPECIAL_RESULT, 0
_cv_given_78:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymCandidate_EventScript_MentorItemExplain
	BufferItemName 1, 0x8004
	NPCMsg msg_0462_T03GYM0101_GymHack_Text_GiftSentToPC
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
	NPCMsg msg_0462_T03GYM0101_GymCandidate_Text_TeamBreaksRules
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_TakeLeadersPlace:
	CanvasCandidate 7
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_Return
	CompareVarToValue 0x8007, 0
	GoToIfEq _cv_hold_79
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_next_81
	CanvasBufferMsg 2, msg_0462_T03GYM0101_cv_leader_0
	GoTo _cv_done_80
_cv_next_81:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_next_82
	CanvasBufferMsg 2, msg_0462_T03GYM0101_cv_leader_1
	GoTo _cv_done_80
_cv_next_82:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_next_83
	CanvasBufferMsg 2, msg_0462_T03GYM0101_cv_leader_2
	GoTo _cv_done_80
_cv_next_83:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_next_84
	CanvasBufferMsg 2, msg_0462_T03GYM0101_cv_leader_3
	GoTo _cv_done_80
_cv_next_84:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_next_85
	CanvasBufferMsg 2, msg_0462_T03GYM0101_cv_leader_4
	GoTo _cv_done_80
_cv_next_85:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_next_86
	CanvasBufferMsg 2, msg_0462_T03GYM0101_cv_leader_5
	GoTo _cv_done_80
_cv_next_86:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_next_87
	CanvasBufferMsg 2, msg_0462_T03GYM0101_cv_leader_6
	GoTo _cv_done_80
_cv_next_87:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_next_88
	CanvasBufferMsg 2, msg_0462_T03GYM0101_cv_leader_7
	GoTo _cv_done_80
_cv_next_88:
_cv_done_80:
	SetVar 0x401F, 54
	GoTo _cv_hold_89
_cv_hold_79:
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_next_91
	SetVar 0x401F, 55
	GoTo _cv_done_90
_cv_next_91:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_next_92
	SetVar 0x401F, 56
	GoTo _cv_done_90
_cv_next_92:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_next_93
	SetVar 0x401F, 57
	GoTo _cv_done_90
_cv_next_93:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_next_94
	SetVar 0x401F, 58
	GoTo _cv_done_90
_cv_next_94:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_next_95
	SetVar 0x401F, 59
	GoTo _cv_done_90
_cv_next_95:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_next_96
	SetVar 0x401F, 60
	GoTo _cv_done_90
_cv_next_96:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_next_97
	SetVar 0x401F, 61
	GoTo _cv_done_90
_cv_next_97:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_next_98
	SetVar 0x401F, 62
	GoTo _cv_done_90
_cv_next_98:
_cv_done_90:
_cv_hold_89:
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
	GoToIfNe _cv_guest_99
	CanvasBufferMsg 2, msg_0462_T03GYM0101_cv_leader_0
	CanvasCandidate 0, 12, 2, 0, 0x8007
_cv_guest_99:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_guest_100
	CanvasBufferMsg 2, msg_0462_T03GYM0101_cv_leader_1
	CanvasCandidate 0, 20, 3, 0, 0x8007
_cv_guest_100:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_guest_101
	CanvasBufferMsg 2, msg_0462_T03GYM0101_cv_leader_2
	CanvasCandidate 0, 24, 3, 1, 0x8007
_cv_guest_101:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_guest_102
	CanvasBufferMsg 2, msg_0462_T03GYM0101_cv_leader_3
	CanvasCandidate 0, 29, 4, 1, 0x8007
_cv_guest_102:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_guest_103
	CanvasBufferMsg 2, msg_0462_T03GYM0101_cv_leader_4
	CanvasCandidate 0, 37, 4, 1, 0x8007
_cv_guest_103:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_guest_104
	CanvasBufferMsg 2, msg_0462_T03GYM0101_cv_leader_5
	CanvasCandidate 0, 40, 4, 2, 0x8007
_cv_guest_104:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_guest_105
	CanvasBufferMsg 2, msg_0462_T03GYM0101_cv_leader_6
	CanvasCandidate 0, 44, 5, 2, 0x8007
_cv_guest_105:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_guest_106
	CanvasBufferMsg 2, msg_0462_T03GYM0101_cv_leader_7
	CanvasCandidate 0, 47, 5, 2, 0x8007
_cv_guest_106:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_next_108
	SetVar 0x4020, SPRITE_GSMAN3
	GoTo _cv_done_107
_cv_next_108:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfNe _cv_next_109
	SetVar 0x4020, SPRITE_GSWOMAN3
	GoTo _cv_done_107
_cv_next_109:
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfNe _cv_next_110
	SetVar 0x4020, SPRITE_GSMAN3
	GoTo _cv_done_107
_cv_next_110:
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfNe _cv_next_111
	SetVar 0x4020, SPRITE_GSWOMAN3
	GoTo _cv_done_107
_cv_next_111:
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfNe _cv_next_112
	SetVar 0x4020, SPRITE_GSFIGHTER
	GoTo _cv_done_107
_cv_next_112:
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfNe _cv_next_113
	SetVar 0x4020, SPRITE_GSGENTLEMAN
	GoTo _cv_done_107
_cv_next_113:
	CompareVarToValue VAR_SPECIAL_RESULT, 6
	GoToIfNe _cv_next_114
	SetVar 0x4020, SPRITE_MOUNT_2
	GoTo _cv_done_107
_cv_next_114:
	CompareVarToValue VAR_SPECIAL_RESULT, 7
	GoToIfNe _cv_next_115
	SetVar 0x4020, SPRITE_GSMAN2
	GoTo _cv_done_107
_cv_next_115:
	CompareVarToValue VAR_SPECIAL_RESULT, 8
	GoToIfNe _cv_next_116
	SetVar 0x4020, SPRITE_BADMAN
	GoTo _cv_done_107
_cv_next_116:
	CompareVarToValue VAR_SPECIAL_RESULT, 9
	GoToIfNe _cv_next_117
	SetVar 0x4020, SPRITE_WORKMAN
	GoTo _cv_done_107
_cv_next_117:
	CompareVarToValue VAR_SPECIAL_RESULT, 10
	GoToIfNe _cv_next_118
	SetVar 0x4020, SPRITE_GSASSISTANTM
	GoTo _cv_done_107
_cv_next_118:
	CompareVarToValue VAR_SPECIAL_RESULT, 11
	GoToIfNe _cv_next_119
	SetVar 0x4020, SPRITE_MANIA
	GoTo _cv_done_107
_cv_next_119:
	CompareVarToValue VAR_SPECIAL_RESULT, 12
	GoToIfNe _cv_next_120
	SetVar 0x4020, SPRITE_CAMPBOY_2
	GoTo _cv_done_107
_cv_next_120:
	CompareVarToValue VAR_SPECIAL_RESULT, 13
	GoToIfNe _cv_next_121
	SetVar 0x4020, SPRITE_SEAMAN_2
	GoTo _cv_done_107
_cv_next_121:
	CompareVarToValue VAR_SPECIAL_RESULT, 14
	GoToIfNe _cv_next_122
	SetVar 0x4020, SPRITE_FISHING_2
	GoTo _cv_done_107
_cv_next_122:
	CompareVarToValue VAR_SPECIAL_RESULT, 15
	GoToIfNe _cv_next_123
	SetVar 0x4020, SPRITE_GSBOY2
	GoTo _cv_done_107
_cv_next_123:
	CompareVarToValue VAR_SPECIAL_RESULT, 16
	GoToIfNe _cv_next_124
	SetVar 0x4020, SPRITE_WOMAN2
	GoTo _cv_done_107
_cv_next_124:
	CompareVarToValue VAR_SPECIAL_RESULT, 17
	GoToIfNe _cv_next_125
	SetVar 0x4020, SPRITE_GSGIRL2
	GoTo _cv_done_107
_cv_next_125:
	CompareVarToValue VAR_SPECIAL_RESULT, 18
	GoToIfNe _cv_next_126
	SetVar 0x4020, SPRITE_PICNICGIRL_2
	GoTo _cv_done_107
_cv_next_126:
	CompareVarToValue VAR_SPECIAL_RESULT, 19
	GoToIfNe _cv_next_127
	SetVar 0x4020, SPRITE_GSGIRL3
	GoTo _cv_done_107
_cv_next_127:
	CompareVarToValue VAR_SPECIAL_RESULT, 20
	GoToIfNe _cv_next_128
	SetVar 0x4020, SPRITE_GSSWIMMERW
	GoTo _cv_done_107
_cv_next_128:
	CompareVarToValue VAR_SPECIAL_RESULT, 21
	GoToIfNe _cv_next_129
	SetVar 0x4020, SPRITE_GSSWIMMERM
	GoTo _cv_done_107
_cv_next_129:
_cv_done_107:
	Random 0x5048, 4
	Random 0x5049, 3
	Random 0x504A, 3
	Random 0x504B, 2
	SetVar 0x504C, 0
	GoToIfUnset 0x208D, _cv_single_130
	Random 0x401E, 3
	CompareVarToValue 0x401E, 0
	GoToIfEq _cv_single_130
	SetVar 0x504C, 1
_cv_single_130:
	CompareVarToValue 0x800B, 0
	CallIfEq GymCandidate_EventScript_LaterThatDay
	CompareVarToValue 0x800B, 0
	CallIfNe GymCandidate_EventScript_AnotherOne
	CanvasCloseMsg
	Call GymCandidate_EventScript_ChallengerWalksIn
	CompareVarToValue 0x5048, 0
	GoToIfNe _cv_line_132
	NPCMsg msg_0462_T03GYM0101_cv_guest_intro_0
	WaitButton
	GoTo _cv_line_131
_cv_line_132:
	CompareVarToValue 0x5048, 1
	GoToIfNe _cv_line_133
	NPCMsg msg_0462_T03GYM0101_cv_guest_intro_1
	WaitButton
	GoTo _cv_line_131
_cv_line_133:
	CompareVarToValue 0x5048, 2
	GoToIfNe _cv_line_134
	NPCMsg msg_0462_T03GYM0101_cv_guest_intro_2
	WaitButton
	GoTo _cv_line_131
_cv_line_134:
	CompareVarToValue 0x5048, 3
	GoToIfNe _cv_line_135
	NPCMsg msg_0462_T03GYM0101_cv_guest_intro_3
	WaitButton
	GoTo _cv_line_131
_cv_line_135:
_cv_line_131:
	CanvasCloseMsg
	CanvasCloseMsg
	CompareVarToValue 0x504C, 0
	GoToIfNe _cv_battle_137
	CompareVarToValue 0x5049, 0
	GoToIfNe _cv_battle_137
	ClearTrainerFlag 1470
	TrainerBattle 1470, 0, 1, 0
	GoTo _cv_battle_136
_cv_battle_137:
	CompareVarToValue 0x504C, 0
	GoToIfNe _cv_battle_138
	CompareVarToValue 0x5049, 1
	GoToIfNe _cv_battle_138
	ClearTrainerFlag 1471
	TrainerBattle 1471, 0, 1, 0
	GoTo _cv_battle_136
_cv_battle_138:
	CompareVarToValue 0x504C, 0
	GoToIfNe _cv_battle_139
	CompareVarToValue 0x5049, 2
	GoToIfNe _cv_battle_139
	ClearTrainerFlag 1472
	TrainerBattle 1472, 0, 1, 0
	GoTo _cv_battle_136
_cv_battle_139:
	CompareVarToValue 0x504C, 1
	GoToIfNe _cv_battle_140
	CompareVarToValue 0x5049, 0
	GoToIfNe _cv_battle_140
	ClearTrainerFlag 1473
	TrainerBattle 1473, 1473, 1, 0
	GoTo _cv_battle_136
_cv_battle_140:
	CompareVarToValue 0x504C, 1
	GoToIfNe _cv_battle_141
	CompareVarToValue 0x5049, 1
	GoToIfNe _cv_battle_141
	ClearTrainerFlag 1474
	TrainerBattle 1474, 1474, 1, 0
	GoTo _cv_battle_136
_cv_battle_141:
	CompareVarToValue 0x504C, 1
	GoToIfNe _cv_battle_142
	CompareVarToValue 0x5049, 2
	GoToIfNe _cv_battle_142
	ClearTrainerFlag 1475
	TrainerBattle 1475, 1475, 1, 0
	GoTo _cv_battle_136
_cv_battle_142:
_cv_battle_136:
	CheckBattleWon VAR_SPECIAL_RESULT
	CanvasCandidate 12
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfNe GymCandidate_EventScript_GuestWon
	HealParty
	CompareVarToValue 0x504A, 0
	GoToIfNe _cv_line_144
	NPCMsg msg_0462_T03GYM0101_cv_guest_after_0
	WaitButton
	GoTo _cv_line_143
_cv_line_144:
	CompareVarToValue 0x504A, 1
	GoToIfNe _cv_line_145
	NPCMsg msg_0462_T03GYM0101_cv_guest_after_1
	WaitButton
	GoTo _cv_line_143
_cv_line_145:
	CompareVarToValue 0x504A, 2
	GoToIfNe _cv_line_146
	NPCMsg msg_0462_T03GYM0101_cv_guest_after_2
	WaitButton
	GoTo _cv_line_143
_cv_line_146:
_cv_line_143:
	Call GymCandidate_EventScript_VisitorWalksOut
	AddVar 0x800B, 1
	SetVar VAR_SPECIAL_RESULT, 0
	SetVar 0x401E, 1
	CompareVarToValue 0x8007, 0
	GoToIfNe _cv_guests_147
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_next_149
	SetVar 0x401E, 1
	GoTo _cv_done_148
_cv_next_149:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_next_150
	SetVar 0x401E, 1
	GoTo _cv_done_148
_cv_next_150:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_next_151
	SetVar 0x401E, 1
	GoTo _cv_done_148
_cv_next_151:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_next_152
	SetVar 0x401E, 1
	GoTo _cv_done_148
_cv_next_152:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_next_153
	SetVar 0x401E, 2
	GoTo _cv_done_148
_cv_next_153:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_next_154
	SetVar 0x401E, 2
	GoTo _cv_done_148
_cv_next_154:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_next_155
	SetVar 0x401E, 2
	GoTo _cv_done_148
_cv_next_155:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_next_156
	SetVar 0x401E, 2
	GoTo _cv_done_148
_cv_next_156:
_cv_done_148:
_cv_guests_147:
	CompareVarToVar 0x800B, 0x401E
	GoToIfGe _cv_guests_157
	SetVar VAR_SPECIAL_RESULT, 1
_cv_guests_157:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymCandidate_EventScript_NextGuest
	Call GymCandidate_EventScript_ReturnLeadersPlace
	CompareVarToValue 0x8007, 1
	GoToIfEq GymCandidate_EventScript_ShiftDone
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_next_177
	SetFlag 0x2093
	SetVar 0x401F, 63
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_159
	SetVar 0x401F, 64
	GoTo _cv_done_158
_cv_next_159:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_160
	SetVar 0x401F, 65
	GoTo _cv_done_158
_cv_next_160:
_cv_done_158:
	GoTo _cv_done_176
_cv_next_177:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_next_178
	SetFlag 0x2094
	SetVar 0x401F, 66
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_162
	SetVar 0x401F, 67
	GoTo _cv_done_161
_cv_next_162:
_cv_done_161:
	GoTo _cv_done_176
_cv_next_178:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_next_179
	SetFlag 0x2095
	SetVar 0x401F, 68
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_164
	SetVar 0x401F, 69
	GoTo _cv_done_163
_cv_next_164:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_165
	SetVar 0x401F, 70
	GoTo _cv_done_163
_cv_next_165:
_cv_done_163:
	GoTo _cv_done_176
_cv_next_179:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_next_180
	SetFlag 0x2096
	SetVar 0x401F, 71
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_167
	SetVar 0x401F, 72
	GoTo _cv_done_166
_cv_next_167:
_cv_done_166:
	GoTo _cv_done_176
_cv_next_180:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_next_181
	SetFlag 0x2097
	SetVar 0x401F, 73
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_169
	SetVar 0x401F, 74
	GoTo _cv_done_168
_cv_next_169:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_170
	SetVar 0x401F, 75
	GoTo _cv_done_168
_cv_next_170:
_cv_done_168:
	GoTo _cv_done_176
_cv_next_181:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_next_182
	SetFlag 0x2098
	SetVar 0x401F, 76
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_172
	SetVar 0x401F, 77
	GoTo _cv_done_171
_cv_next_172:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_173
	SetVar 0x401F, 78
	GoTo _cv_done_171
_cv_next_173:
_cv_done_171:
	GoTo _cv_done_176
_cv_next_182:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_next_183
	SetFlag 0x2099
	SetVar 0x401F, 79
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_175
	SetVar 0x401F, 80
	GoTo _cv_done_174
_cv_next_175:
_cv_done_174:
	GoTo _cv_done_176
_cv_next_183:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_next_184
	SetFlag 0x2007
	SetVar 0x401F, 81
	GoTo _cv_done_176
_cv_next_184:
_cv_done_176:
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x2093, _cv_appr_185
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_185:
	GoToIfUnset 0x2094, _cv_appr_186
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_186:
	GoToIfUnset 0x2095, _cv_appr_187
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_187:
	GoToIfUnset 0x2096, _cv_appr_188
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_188:
	GoToIfUnset 0x2097, _cv_appr_189
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_189:
	GoToIfUnset 0x2098, _cv_appr_190
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_190:
	GoToIfUnset 0x2099, _cv_appr_191
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_191:
	GoToIfUnset 0x2007, _cv_appr_192
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_192:
	BufferInt 0, VAR_SPECIAL_RESULT
	PlayFanfare SEQ_ME_LVUP
	Call _cv_str4
	WaitButton
	WaitFanfare
	NPCMsg msg_0462_T03GYM0101_GymCandidate_Text_ApprovalCount
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_MentorItemExplain:
	BufferItemName 0, 0x8004
	CompareVarToValue 0x8009, 6
	GoToIfEq GymCandidate_EventScript_EdgeItemExplain
	NPCMsg msg_0462_T03GYM0101_GymCandidate_Text_GuardItemExplain
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
	NPCMsg msg_0462_T03GYM0101_GymCandidate_Text_LaterThatDay
	WaitButton
	Return
	
GymCandidate_EventScript_AnotherOne:
	NPCMsg msg_0462_T03GYM0101_GymCandidate_Text_AnotherOne
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
	GoToIfNe _cv_line_194
	NPCMsg msg_0462_T03GYM0101_cv_guest_win_0
	WaitButton
	GoTo _cv_line_193
_cv_line_194:
	CompareVarToValue 0x504B, 1
	GoToIfNe _cv_line_195
	NPCMsg msg_0462_T03GYM0101_cv_guest_win_1
	WaitButton
	GoTo _cv_line_193
_cv_line_195:
_cv_line_193:
	Call GymCandidate_EventScript_VisitorWalksOut
	Call GymCandidate_EventScript_ReturnLeadersPlace
	NPCMsg msg_0462_T03GYM0101_GymCandidate_Text_TryAgain
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
	GoToIfNe _cv_next_197
	SetVar 0x401F, 82
	GoTo _cv_done_196
_cv_next_197:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_next_198
	SetVar 0x401F, 83
	GoTo _cv_done_196
_cv_next_198:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_next_199
	SetVar 0x401F, 84
	GoTo _cv_done_196
_cv_next_199:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_next_200
	SetVar 0x401F, 85
	GoTo _cv_done_196
_cv_next_200:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_next_201
	SetVar 0x401F, 86
	GoTo _cv_done_196
_cv_next_201:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_next_202
	SetVar 0x401F, 87
	GoTo _cv_done_196
_cv_next_202:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_next_203
	SetVar 0x401F, 88
	GoTo _cv_done_196
_cv_next_203:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_next_204
	SetVar 0x401F, 89
	GoTo _cv_done_196
_cv_next_204:
_cv_done_196:
	Call _cv_str4
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_EdgeItemExplain:
	NPCMsg msg_0462_T03GYM0101_GymCandidate_Text_EdgeItemExplain
	WaitButton
	Return
	
Outfits_EventScript_GymUniform:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Outfits_EventScript_Return
	PlayFanfare SEQ_ME_ITEM
	BufferPlayersName 6
	NPCMsg msg_0462_T03GYM0101_Outfits_Text_ReceivedGymUniform
	WaitFanfare
	BufferPlayersName 6
	NPCMsg msg_0462_T03GYM0101_Outfits_Text_PutInWardrobe
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
	NPCMsg msg_0462_T03GYM0101_cv_mentor_prebattle_rock
	Return
_cv_str4_0:
	CompareVarToValue 0x401F, 2
	GoToIfNe _cv_str4_1
	NPCMsg msg_0462_T03GYM0101_cv_mentor_prebattle_normal
	Return
_cv_str4_1:
	CompareVarToValue 0x401F, 3
	GoToIfNe _cv_str4_2
	NPCMsg msg_0462_T03GYM0101_cv_mentor_prebattle_water
	Return
_cv_str4_2:
	CompareVarToValue 0x401F, 4
	GoToIfNe _cv_str4_3
	NPCMsg msg_0462_T03GYM0101_cv_mentor_prebattle_electric
	Return
_cv_str4_3:
	CompareVarToValue 0x401F, 5
	GoToIfNe _cv_str4_4
	NPCMsg msg_0462_T03GYM0101_cv_mentor_prebattle_steel
	Return
_cv_str4_4:
	CompareVarToValue 0x401F, 6
	GoToIfNe _cv_str4_5
	NPCMsg msg_0462_T03GYM0101_cv_mentor_prebattle_grass
	Return
_cv_str4_5:
	CompareVarToValue 0x401F, 7
	GoToIfNe _cv_str4_6
	NPCMsg msg_0462_T03GYM0101_cv_mentor_prebattle_poison
	Return
_cv_str4_6:
	CompareVarToValue 0x401F, 8
	GoToIfNe _cv_str4_7
	NPCMsg msg_0462_T03GYM0101_cv_mentor_prebattle_bug
	Return
_cv_str4_7:
	CompareVarToValue 0x401F, 9
	GoToIfNe _cv_str4_8
	NPCMsg msg_0462_T03GYM0101_cv_mentor_prebattle_psychic
	Return
_cv_str4_8:
	CompareVarToValue 0x401F, 10
	GoToIfNe _cv_str4_9
	NPCMsg msg_0462_T03GYM0101_cv_mentor_prebattle_fairy
	Return
_cv_str4_9:
	CompareVarToValue 0x401F, 11
	GoToIfNe _cv_str4_10
	NPCMsg msg_0462_T03GYM0101_cv_mentor_prebattle_fire
	Return
_cv_str4_10:
	CompareVarToValue 0x401F, 12
	GoToIfNe _cv_str4_11
	NPCMsg msg_0462_T03GYM0101_cv_leader_repeatOffer_0
	Return
_cv_str4_11:
	CompareVarToValue 0x401F, 13
	GoToIfNe _cv_str4_12
	NPCMsg msg_0462_T03GYM0101_cv_leader_repeatOffer_1
	Return
_cv_str4_12:
	CompareVarToValue 0x401F, 14
	GoToIfNe _cv_str4_13
	NPCMsg msg_0462_T03GYM0101_cv_leader_repeatOffer_2
	Return
_cv_str4_13:
	CompareVarToValue 0x401F, 15
	GoToIfNe _cv_str4_14
	NPCMsg msg_0462_T03GYM0101_cv_leader_repeatOffer_3
	Return
_cv_str4_14:
	CompareVarToValue 0x401F, 16
	GoToIfNe _cv_str4_15
	NPCMsg msg_0462_T03GYM0101_cv_leader_repeatOffer_4
	Return
_cv_str4_15:
	CompareVarToValue 0x401F, 17
	GoToIfNe _cv_str4_16
	NPCMsg msg_0462_T03GYM0101_cv_leader_repeatOffer_5
	Return
_cv_str4_16:
	CompareVarToValue 0x401F, 18
	GoToIfNe _cv_str4_17
	NPCMsg msg_0462_T03GYM0101_cv_leader_repeatOffer_6
	Return
_cv_str4_17:
	CompareVarToValue 0x401F, 19
	GoToIfNe _cv_str4_18
	NPCMsg msg_0462_T03GYM0101_cv_leader_repeatOffer_7
	Return
_cv_str4_18:
	CompareVarToValue 0x401F, 20
	GoToIfNe _cv_str4_19
	NPCMsg msg_0462_T03GYM0101_cv_mentor_first_rock
	Return
_cv_str4_19:
	CompareVarToValue 0x401F, 21
	GoToIfNe _cv_str4_20
	NPCMsg msg_0462_T03GYM0101_cv_mentor_first_normal
	Return
_cv_str4_20:
	CompareVarToValue 0x401F, 22
	GoToIfNe _cv_str4_21
	NPCMsg msg_0462_T03GYM0101_cv_mentor_first_water
	Return
_cv_str4_21:
	CompareVarToValue 0x401F, 23
	GoToIfNe _cv_str4_22
	NPCMsg msg_0462_T03GYM0101_cv_mentor_first_electric
	Return
_cv_str4_22:
	CompareVarToValue 0x401F, 24
	GoToIfNe _cv_str4_23
	NPCMsg msg_0462_T03GYM0101_cv_mentor_first_steel
	Return
_cv_str4_23:
	CompareVarToValue 0x401F, 25
	GoToIfNe _cv_str4_24
	NPCMsg msg_0462_T03GYM0101_cv_mentor_first_grass
	Return
_cv_str4_24:
	CompareVarToValue 0x401F, 26
	GoToIfNe _cv_str4_25
	NPCMsg msg_0462_T03GYM0101_cv_mentor_first_poison
	Return
_cv_str4_25:
	CompareVarToValue 0x401F, 27
	GoToIfNe _cv_str4_26
	NPCMsg msg_0462_T03GYM0101_cv_mentor_first_bug
	Return
_cv_str4_26:
	CompareVarToValue 0x401F, 28
	GoToIfNe _cv_str4_27
	NPCMsg msg_0462_T03GYM0101_cv_mentor_first_psychic
	Return
_cv_str4_27:
	CompareVarToValue 0x401F, 29
	GoToIfNe _cv_str4_28
	NPCMsg msg_0462_T03GYM0101_cv_mentor_first_fairy
	Return
_cv_str4_28:
	CompareVarToValue 0x401F, 30
	GoToIfNe _cv_str4_29
	NPCMsg msg_0462_T03GYM0101_cv_mentor_first_fire
	Return
_cv_str4_29:
	CompareVarToValue 0x401F, 31
	GoToIfNe _cv_str4_30
	NPCMsg msg_0462_T03GYM0101_cv_mentor_first_ground
	Return
_cv_str4_30:
	CompareVarToValue 0x401F, 32
	GoToIfNe _cv_str4_31
	NPCMsg msg_0462_T03GYM0101_cv_mentor_first_dark
	Return
_cv_str4_31:
	CompareVarToValue 0x401F, 33
	GoToIfNe _cv_str4_32
	NPCMsg msg_0462_T03GYM0101_cv_mentor_first_ice
	Return
_cv_str4_32:
	CompareVarToValue 0x401F, 34
	GoToIfNe _cv_str4_33
	NPCMsg msg_0462_T03GYM0101_cv_mentor_first_fighting
	Return
_cv_str4_33:
	CompareVarToValue 0x401F, 35
	GoToIfNe _cv_str4_34
	NPCMsg msg_0462_T03GYM0101_cv_mentor_first_ghost
	Return
_cv_str4_34:
	CompareVarToValue 0x401F, 36
	GoToIfNe _cv_str4_35
	NPCMsg msg_0462_T03GYM0101_cv_mentor_first_dragon
	Return
_cv_str4_35:
	CompareVarToValue 0x401F, 37
	GoToIfNe _cv_str4_36
	NPCMsg msg_0462_T03GYM0101_cv_mentor_first_flying
	Return
_cv_str4_36:
	CompareVarToValue 0x401F, 38
	GoToIfNe _cv_str4_37
	NPCMsg msg_0462_T03GYM0101_cv_leader_offer_0
	Return
_cv_str4_37:
	CompareVarToValue 0x401F, 39
	GoToIfNe _cv_str4_38
	NPCMsg msg_0462_T03GYM0101_cv_leader_offer_1
	Return
_cv_str4_38:
	CompareVarToValue 0x401F, 40
	GoToIfNe _cv_str4_39
	NPCMsg msg_0462_T03GYM0101_cv_leader_offer_2
	Return
_cv_str4_39:
	CompareVarToValue 0x401F, 41
	GoToIfNe _cv_str4_40
	NPCMsg msg_0462_T03GYM0101_cv_leader_offer_3
	Return
_cv_str4_40:
	CompareVarToValue 0x401F, 42
	GoToIfNe _cv_str4_41
	NPCMsg msg_0462_T03GYM0101_cv_leader_offer_4
	Return
_cv_str4_41:
	CompareVarToValue 0x401F, 43
	GoToIfNe _cv_str4_42
	NPCMsg msg_0462_T03GYM0101_cv_leader_offer_5
	Return
_cv_str4_42:
	CompareVarToValue 0x401F, 44
	GoToIfNe _cv_str4_43
	NPCMsg msg_0462_T03GYM0101_cv_leader_offer_6
	Return
_cv_str4_43:
	CompareVarToValue 0x401F, 45
	GoToIfNe _cv_str4_44
	NPCMsg msg_0462_T03GYM0101_cv_leader_offer_7
	Return
_cv_str4_44:
	CompareVarToValue 0x401F, 46
	GoToIfNe _cv_str4_45
	NPCMsg msg_0462_T03GYM0101_cv_leader_ownGym_0
	Return
_cv_str4_45:
	CompareVarToValue 0x401F, 47
	GoToIfNe _cv_str4_46
	NPCMsg msg_0462_T03GYM0101_cv_leader_ownGym_1
	Return
_cv_str4_46:
	CompareVarToValue 0x401F, 48
	GoToIfNe _cv_str4_47
	NPCMsg msg_0462_T03GYM0101_cv_leader_ownGym_2
	Return
_cv_str4_47:
	CompareVarToValue 0x401F, 49
	GoToIfNe _cv_str4_48
	NPCMsg msg_0462_T03GYM0101_cv_leader_ownGym_3
	Return
_cv_str4_48:
	CompareVarToValue 0x401F, 50
	GoToIfNe _cv_str4_49
	NPCMsg msg_0462_T03GYM0101_cv_leader_ownGym_4
	Return
_cv_str4_49:
	CompareVarToValue 0x401F, 51
	GoToIfNe _cv_str4_50
	NPCMsg msg_0462_T03GYM0101_cv_leader_ownGym_5
	Return
_cv_str4_50:
	CompareVarToValue 0x401F, 52
	GoToIfNe _cv_str4_51
	NPCMsg msg_0462_T03GYM0101_cv_leader_ownGym_6
	Return
_cv_str4_51:
	CompareVarToValue 0x401F, 53
	GoToIfNe _cv_str4_52
	NPCMsg msg_0462_T03GYM0101_cv_leader_ownGym_7
	Return
_cv_str4_52:
	CompareVarToValue 0x401F, 54
	GoToIfNe _cv_str4_53
	NPCMsg msg_0462_T03GYM0101_cv_hold_shift
	Return
_cv_str4_53:
	CompareVarToValue 0x401F, 55
	GoToIfNe _cv_str4_54
	NPCMsg msg_0462_T03GYM0101_cv_leader_observe_0
	Return
_cv_str4_54:
	CompareVarToValue 0x401F, 56
	GoToIfNe _cv_str4_55
	NPCMsg msg_0462_T03GYM0101_cv_leader_observe_1
	Return
_cv_str4_55:
	CompareVarToValue 0x401F, 57
	GoToIfNe _cv_str4_56
	NPCMsg msg_0462_T03GYM0101_cv_leader_observe_2
	Return
_cv_str4_56:
	CompareVarToValue 0x401F, 58
	GoToIfNe _cv_str4_57
	NPCMsg msg_0462_T03GYM0101_cv_leader_observe_3
	Return
_cv_str4_57:
	CompareVarToValue 0x401F, 59
	GoToIfNe _cv_str4_58
	NPCMsg msg_0462_T03GYM0101_cv_leader_observe_4
	Return
_cv_str4_58:
	CompareVarToValue 0x401F, 60
	GoToIfNe _cv_str4_59
	NPCMsg msg_0462_T03GYM0101_cv_leader_observe_5
	Return
_cv_str4_59:
	CompareVarToValue 0x401F, 61
	GoToIfNe _cv_str4_60
	NPCMsg msg_0462_T03GYM0101_cv_leader_observe_6
	Return
_cv_str4_60:
	CompareVarToValue 0x401F, 62
	GoToIfNe _cv_str4_61
	NPCMsg msg_0462_T03GYM0101_cv_leader_observe_7
	Return
_cv_str4_61:
	CompareVarToValue 0x401F, 63
	GoToIfNe _cv_str4_62
	NPCMsg msg_0462_T03GYM0101_cv_leader_approve_0
	Return
_cv_str4_62:
	CompareVarToValue 0x401F, 64
	GoToIfNe _cv_str4_63
	NPCMsg msg_0462_T03GYM0101_cv_mentor_approve_rock
	Return
_cv_str4_63:
	CompareVarToValue 0x401F, 65
	GoToIfNe _cv_str4_64
	NPCMsg msg_0462_T03GYM0101_cv_mentor_approve_normal
	Return
_cv_str4_64:
	CompareVarToValue 0x401F, 66
	GoToIfNe _cv_str4_65
	NPCMsg msg_0462_T03GYM0101_cv_leader_approve_1
	Return
_cv_str4_65:
	CompareVarToValue 0x401F, 67
	GoToIfNe _cv_str4_66
	NPCMsg msg_0462_T03GYM0101_cv_mentor_approve_water
	Return
_cv_str4_66:
	CompareVarToValue 0x401F, 68
	GoToIfNe _cv_str4_67
	NPCMsg msg_0462_T03GYM0101_cv_leader_approve_2
	Return
_cv_str4_67:
	CompareVarToValue 0x401F, 69
	GoToIfNe _cv_str4_68
	NPCMsg msg_0462_T03GYM0101_cv_mentor_approve_electric
	Return
_cv_str4_68:
	CompareVarToValue 0x401F, 70
	GoToIfNe _cv_str4_69
	NPCMsg msg_0462_T03GYM0101_cv_mentor_approve_steel
	Return
_cv_str4_69:
	CompareVarToValue 0x401F, 71
	GoToIfNe _cv_str4_70
	NPCMsg msg_0462_T03GYM0101_cv_leader_approve_3
	Return
_cv_str4_70:
	CompareVarToValue 0x401F, 72
	GoToIfNe _cv_str4_71
	NPCMsg msg_0462_T03GYM0101_cv_mentor_approve_grass
	Return
_cv_str4_71:
	CompareVarToValue 0x401F, 73
	GoToIfNe _cv_str4_72
	NPCMsg msg_0462_T03GYM0101_cv_leader_approve_4
	Return
_cv_str4_72:
	CompareVarToValue 0x401F, 74
	GoToIfNe _cv_str4_73
	NPCMsg msg_0462_T03GYM0101_cv_mentor_approve_poison
	Return
_cv_str4_73:
	CompareVarToValue 0x401F, 75
	GoToIfNe _cv_str4_74
	NPCMsg msg_0462_T03GYM0101_cv_mentor_approve_bug
	Return
_cv_str4_74:
	CompareVarToValue 0x401F, 76
	GoToIfNe _cv_str4_75
	NPCMsg msg_0462_T03GYM0101_cv_leader_approve_5
	Return
_cv_str4_75:
	CompareVarToValue 0x401F, 77
	GoToIfNe _cv_str4_76
	NPCMsg msg_0462_T03GYM0101_cv_mentor_approve_psychic
	Return
_cv_str4_76:
	CompareVarToValue 0x401F, 78
	GoToIfNe _cv_str4_77
	NPCMsg msg_0462_T03GYM0101_cv_mentor_approve_fairy
	Return
_cv_str4_77:
	CompareVarToValue 0x401F, 79
	GoToIfNe _cv_str4_78
	NPCMsg msg_0462_T03GYM0101_cv_leader_approve_6
	Return
_cv_str4_78:
	CompareVarToValue 0x401F, 80
	GoToIfNe _cv_str4_79
	NPCMsg msg_0462_T03GYM0101_cv_mentor_approve_fire
	Return
_cv_str4_79:
	CompareVarToValue 0x401F, 81
	GoToIfNe _cv_str4_80
	NPCMsg msg_0462_T03GYM0101_cv_leader_approve_7
	Return
_cv_str4_80:
	CompareVarToValue 0x401F, 82
	GoToIfNe _cv_str4_81
	NPCMsg msg_0462_T03GYM0101_cv_leader_repeatThanks_0
	Return
_cv_str4_81:
	CompareVarToValue 0x401F, 83
	GoToIfNe _cv_str4_82
	NPCMsg msg_0462_T03GYM0101_cv_leader_repeatThanks_1
	Return
_cv_str4_82:
	CompareVarToValue 0x401F, 84
	GoToIfNe _cv_str4_83
	NPCMsg msg_0462_T03GYM0101_cv_leader_repeatThanks_2
	Return
_cv_str4_83:
	CompareVarToValue 0x401F, 85
	GoToIfNe _cv_str4_84
	NPCMsg msg_0462_T03GYM0101_cv_leader_repeatThanks_3
	Return
_cv_str4_84:
	CompareVarToValue 0x401F, 86
	GoToIfNe _cv_str4_85
	NPCMsg msg_0462_T03GYM0101_cv_leader_repeatThanks_4
	Return
_cv_str4_85:
	CompareVarToValue 0x401F, 87
	GoToIfNe _cv_str4_86
	NPCMsg msg_0462_T03GYM0101_cv_leader_repeatThanks_5
	Return
_cv_str4_86:
	CompareVarToValue 0x401F, 88
	GoToIfNe _cv_str4_87
	NPCMsg msg_0462_T03GYM0101_cv_leader_repeatThanks_6
	Return
_cv_str4_87:
	CompareVarToValue 0x401F, 89
	GoToIfNe _cv_str4_88
	NPCMsg msg_0462_T03GYM0101_cv_leader_repeatThanks_7
	Return
_cv_str4_88:
	Return

_cv_stop:
	NPCMsg msg_0462_T03GYM0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_team_not_allowed:
	Call EventScript_GymHack_ShowTeamRuleMessage
	CanvasCloseMsg
	GetPlayerCoords 0x8008, 0x8009
	GetPlayerFacing 0x800A
	Warp MAP_PEWTER_GYM, 0, 0x8008, 0x8009, 0x800A
	ReleaseAll
	End
	.balign 4, 0
