#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T02GYM0101.h"
#include "msgdata/msg/msg_0454_T02GYM0101.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's ViridianCity_Gym_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef ViridianCity_Gym_EventScript_Giovanni
	ScrDef ViridianCity_Gym_EventScript_GymGuy
	ScrDef GymAides_EventScript_ViridianCity
	ScrDef DadStory_EventScript_Archer
	ScrDef ViridianCity_Gym_EventScript_GymStatue
	ScrDef ViridianCity_Gym_OnTransitionGuest
	ScrDefEnd
	
ViridianCity_Gym_EventScript_Giovanni:
	CompareVarToValue 0x5008, 7
	GoToIfEq DadStory_EventScript_GiovanniRematch
	CheckTrainerFlag 1086
	GoToIf TRUE, _cv_beaten_1
	NPCMsg msg_0454_T02GYM0101_ViridianCity_Gym_Text_GiovanniIntro
	WaitButton
	CloseMsg
	TrainerBattle 1086, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_2
	WhiteOut
	End
_cv_won_2:
	SetTrainerFlag 1086
	GoTo ViridianCity_Gym_EventScript_DefeatedGiovanni
_cv_beaten_1:
	GoToIfUnset 0x214E, ViridianCity_Gym_EventScript_GiveTM26
	Call GymHack_EventScript_GiovanniGifts
	Call GymCandidate_EventScript_ViridianCityTalk
	NPCMsg msg_0454_T02GYM0101_ViridianCity_Gym_Text_GiovanniPostBattle
	WaitButton
	CloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	HidePerson 8
	SetFlag 0x214F
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	ReleaseAll
	End
	
ViridianCity_Gym_EventScript_GymGuy:
	LockAll
	FacePlayer
	GoToIfSet 0x2150, ViridianCity_Gym_EventScript_GymGuyPostVictory
	NPCMsg msg_0454_T02GYM0101_ViridianCity_Gym_Text_GymGuyAdvice
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymAides_EventScript_ViridianCity:
	GoToIfSet 0x2151, GymAides_EventScript_ViridianCityAfter
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0454_T02GYM0101_GymAides_Text_ViridianCity
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
DadStory_EventScript_Archer:
	LockAll
	FacePlayer
	CompareVarToValue 0x5008, 10
	GoToIfGe DadStory_EventScript_ArcherMet
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_ArcherIntro
	WaitButton
	Call DadStory_EventScript_ArcherOrb
	SetVar 0x5008, 10
	CloseMsg
	ReleaseAll
	End
	
ViridianCity_Gym_EventScript_GymStatue:
	LockAll
	GoToIfSet 0x2151, ViridianCity_Gym_EventScript_GymStatuePostVictory
	BufferRivalsName 7
	NPCMsg msg_0454_T02GYM0101_ViridianCity_Gym_Text_GymStatue
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
ViridianCity_Gym_OnTransitionGuest:
	SetFlag 0x2017
	Call DadStory_EventScript_ViridianGymTransition
	End
	
DadStory_EventScript_GiovanniRematch:
	LockAll
	FacePlayer
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_GiovanniRematch
	WaitButton
	End
	
ViridianCity_Gym_EventScript_DefeatedGiovanni:
	SetFlag 0x20CA
	SetFlag 0x2150
	SetFlag 0x2151
	SetVar 0x5013, 3
	SetVar 0x8008, 8
	Call Common_EventScript_SetGymTrainers_Frlg
	GoTo DadStory_EventScript_GiovanniTakeThese
	End
	
ViridianCity_Gym_EventScript_GiveTM26:
	NPCMsg msg_0454_T02GYM0101_ViridianCity_Gym_Text_ExplainEarthBadgeTakeThis
	WaitButton
	HasSpaceForItem ITEM_TM26, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq ViridianCity_Gym_EventScript_NoRoomForTM26
	GiveItem ITEM_TM26, 1, VAR_SPECIAL_RESULT
	BufferItemName 1, ITEM_TM26
	BufferPlayersName 6
	NPCMsg msg_0454_T02GYM0101_ViridianCity_Gym_Text_ReceivedTM26FromGiovanni
	PlayFanfare SEQ_ME_LVUP
	WaitFanfare
	WaitButton
	SetFlag 0x214E
	NPCMsg msg_0454_T02GYM0101_ViridianCity_Gym_Text_ExplainTM26
	WaitButton
	Call GymHack_EventScript_GiovanniGifts
	GoTo GymCandidate_EventScript_ViridianCityAfterBadge
	CloseMsg
	ReleaseAll
	End
	
GymHack_EventScript_GiovanniGifts:
	GoToIfSet 0x2152, GymHack_EventScript_GiftsDone
	NPCMsg msg_0454_T02GYM0101_GymHack_Text_GiovanniSilverCap
	WaitButton
	SetVar 0x8009, 795
	Call GymHack_EventScript_GiveStatItem
	SetFlag 0x2152
	NPCMsg msg_0454_T02GYM0101_GymHack_Text_GiovanniSilverCapAfter
	WaitButton
	Return
	
GymCandidate_EventScript_ViridianCityTalk:
	SetVar 0x8009, 7
	SetVar 0x800A, 12
	GoTo GymCandidate_EventScript_TalkAgain
	
ViridianCity_Gym_EventScript_GymGuyPostVictory:
	NPCMsg msg_0454_T02GYM0101_ViridianCity_Gym_Text_GymGuyPostVictory
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymAides_EventScript_ViridianCityAfter:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0454_T02GYM0101_GymAides_Text_ViridianCityAfter
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
DadStory_EventScript_ArcherMet:
	HasItem 1833, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq DadStory_EventScript_ArcherOrbLate
	// TODO(gba) special GymTera_CountMasteredTypes
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe GymTera_EventScript_ArcherTune
	End
	
DadStory_EventScript_ArcherOrb:
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_ArcherOwedDad
	WaitButton
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_ArcherGiveOrb
	WaitButton
	GiveItem 1833, 1, VAR_SPECIAL_RESULT
	BufferPlayersName 6
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_ArcherTeraRules
	WaitButton
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_ArcherAskForgiveness
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_3
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_4
_cv_yes_3:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq DadStory_EventScript_ArcherNotForgiven
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_ArcherForgiven
	WaitButton
	Return
	
ViridianCity_Gym_EventScript_GymStatuePostVictory:
	BufferPlayersName 6
	BufferRivalsName 7
	NPCMsg msg_0454_T02GYM0101_ViridianCity_Gym_Text_GymStatuePlayerWon
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
DadStory_EventScript_ViridianGymTransition:
	SetFlag 0x2153
	SetFlag 0x2154
	SetFlag 0x2155
	CompareVarToValue 0x5008, 9
	GoToIfLt Common_EventScript_NopReturn
	ClearFlag 0x2155
	SetFlag 0x214F
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
	
DadStory_EventScript_GiovanniTakeThese:
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_GiovanniTakeThese
	WaitButton
	PlayFanfare SEQ_ME_BADGE
	BufferPlayersName 6
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_ReceivedEarthBadge
	WaitFanfare
	GiveItem ITEM_TM26, 1, VAR_SPECIAL_RESULT
	SetFlag 0x214E
	GoToIfSet 0x2152, DadStory_EventScript_GiovanniStory
	SetVar 0x8009, 795
	Call GymHack_EventScript_GiveStatItem
	SetFlag 0x2152
	End
	
ViridianCity_Gym_EventScript_NoRoomForTM26:
	NPCMsg msg_0454_T02GYM0101_ViridianCity_Gym_Text_YouDoNotHaveSpace
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_ViridianCityAfterBadge:
	SetVar 0x8009, 7
	SetVar 0x800A, 12
	GoTo GymCandidate_EventScript_AfterBadge
	End
	
GymHack_EventScript_GiftsDone:
	Return
	
GymHack_EventScript_GiveStatItem:
	GiveItem 0x8009, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymHack_EventScript_GiveStatItemDone
	BufferItemName 1, 0x8009
	NPCMsg msg_0454_T02GYM0101_GymHack_Text_GiftSentToPC
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
	GoToIfEq _cv_yes_5
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_6
_cv_yes_5:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_6:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_NotYet
	SetVar 0x8007, 1
	GoTo GymCandidate_EventScript_Start
	CloseMsg
	End
	
DadStory_EventScript_ArcherOrbLate:
	BufferPlayersName 6
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_ArcherSomethingElse
	WaitButton
	Call DadStory_EventScript_ArcherOrb
	CloseMsg
	ReleaseAll
	End
	
GymTera_EventScript_ArcherTune:
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_ArcherTuneOffer
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_7
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_8
_cv_yes_7:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_8:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Later
	// TODO(gba) special ChoosePartyMon
	GoTo _cv_stop
	CompareVarToValue 0x8004, 6
	GoToIfGe GymTera_EventScript_Later
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar ScriptGetPartyMonSpecies
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, SPECIES_EGG
	GoToIfEq GymTera_EventScript_Egg
	// TODO(gba) special GymTera_BufferMonTera
	GoTo _cv_stop
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_ArcherTunePick
	Call GymTera_EventScript_PushTypes
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_10
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_10:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq GymTera_EventScript_Later
	CopyVar 0x8005, VAR_SPECIAL_RESULT
	CloseMsg
	// TODO(gba) special GymTera_CheckPrice
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Already
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq GymTera_EventScript_NoBerries
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_ArcherTunePrice
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_11
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_12
_cv_yes_11:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_12:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Later
	// TODO(gba) special GymTera_SetType
	GoTo _cv_stop
	PlaySE SEQ_SE_DP_SELECT
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_ArcherTuned
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
DadStory_EventScript_ArcherNotForgiven:
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_ArcherNotForgiven
	WaitButton
	Return
	
Common_EventScript_NopReturn:
	Return
	
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
	
DadStory_EventScript_GiovanniStory:
	BufferPlayersName 6
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_GiovanniYourFather
	WaitButton
	SetVar 0x5008, 7
	GoTo DadStory_EventScript_GiovanniLastBattle
	
GymCandidate_EventScript_AfterBadge:
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_mentor_13
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_mentor_13
	SetVar 0x401F, 1
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_13:
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_mentor_14
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_mentor_14
	SetVar 0x401F, 2
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_14:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_mentor_15
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_mentor_15
	SetVar 0x401F, 3
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_15:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_mentor_16
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_mentor_16
	SetVar 0x401F, 4
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_16:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_mentor_17
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_mentor_17
	SetVar 0x401F, 5
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_17:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_mentor_18
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_mentor_18
	SetVar 0x401F, 6
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_18:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_mentor_19
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_mentor_19
	SetVar 0x401F, 7
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_19:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_mentor_20
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_mentor_20
	SetVar 0x401F, 8
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_20:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_mentor_21
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_mentor_21
	SetVar 0x401F, 9
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_21:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_mentor_22
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_mentor_22
	SetVar 0x401F, 10
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_22:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_mentor_23
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_mentor_23
	SetVar 0x401F, 11
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_23:
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
	NPCMsg msg_0454_T02GYM0101_GymCandidate_Text_SomeoneToSeeYou
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
	GoToIfEq _cv_yes_24
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_25
_cv_yes_24:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_25:
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
	NPCMsg msg_0454_T02GYM0101_GymCandidate_Text_NotYet
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
	
GymTera_EventScript_Later:
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_ArcherTuneLater
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymTera_EventScript_Egg:
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_ArcherTuneEgg
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymTera_EventScript_PushTypes:
	SetVar 0x8005, 0
	// TODO(gba) special GymTera_IsTypeAllowed
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Skip_NORMAL
	End
	
GymTera_EventScript_Already:
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_ArcherTuneAlready
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymTera_EventScript_NoBerries:
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_ArcherTuneNoBerries
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
DadStory_EventScript_GiovanniLastBattle:
	CloseMsg
	SetFlag 0x2036
	ClearTrainerFlag 1467
	SetVar VAR_SPECIAL_LAST_TALKED, 8
	CheckTrainerFlag 1467
	GoToIf TRUE, _cv_beaten_26
	TrainerBattle 1467, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_27
	WhiteOut
	End
_cv_won_27:
	SetTrainerFlag 1467
	ReleaseAll
	End
_cv_beaten_26:
	ClearFlag 0x2036
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq _cv_won_28
	SetVar VAR_SPECIAL_RESULT, 2
_cv_won_28:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq DadStory_EventScript_GiovanniFinale
	HealParty
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_GiovanniYouLost
	WaitButton
	CloseMsg
	ReleaseAll
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
	NPCMsg msg_0454_T02GYM0101_GymHack_Text_GiftSentToPC
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
	NPCMsg msg_0454_T02GYM0101_GymCandidate_Text_TeamBreaksRules
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
	
GymTera_EventScript_Skip_NORMAL:
	SetVar 0x8005, 1
	// TODO(gba) special GymTera_IsTypeAllowed
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Skip_FIGHTING
	End
	
DadStory_EventScript_GiovanniFinale:
	// TODO(gba) special DadStory_BufferAce
	GoTo _cv_stop
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_GiovanniHow
	WaitButton
	CloseMsg
	GetPlayerCoords 0x8004, 0x8005
	SubVar 0x8004, 1
	CompareVarToValue 0x8004, 1
	CallIfEq DadStory_EventScript_PlayerFromLeft
	CompareVarToValue 0x8004, 3
	CallIfEq DadStory_EventScript_PlayerFromRight
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	Wait 30, VAR_SPECIAL_RESULT
	ClearFlag 0x2153
	GoToIfUnset 0x2153, _cv_show_29
	ClearFlag 0x2153
	ShowPerson 13
	SetFlag 0x2153
	GoTo _cv_shown_30
_cv_show_29:
	ShowPerson 13
_cv_shown_30:
	ApplyMovement 13, DadStory_Movement_MomUpToGiovanni
	WaitMovement
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_MomLastTime
	WaitButton
	CloseMsg
	PlaySE SEQ_SE_DP_SELECT
	Wait 20, VAR_SPECIAL_RESULT
	PlaySE SEQ_SE_DP_SELECT
	ClearFlag 0x2154
	GoToIfUnset 0x2154, _cv_show_31
	ClearFlag 0x2154
	ShowPerson 14
	SetFlag 0x2154
	GoTo _cv_shown_32
_cv_show_31:
	ShowPerson 14
_cv_shown_32:
	PlayCry SPECIES_CHANSEY, 0
	WaitCry
	Wait 20, VAR_SPECIAL_RESULT
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_ChanseyGlows
	WaitButton
	CloseMsg
	SetVar 0x8004, 2
	SetVar 0x8005, 2
	SetVar 0x8006, 16
	SetVar 0x8007, 3
	PlaySE SEQ_SE_DP_SELECT
	// TODO(gba) special ShakeCamera
	GoTo _cv_stop
	ApplyMovement 14, DadStory_Movement_ChanseyAttacks
	WaitMovement
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_ChanseyUnleashes
	WaitButton
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_GiovanniOverwhelmed
	WaitButton
	CloseMsg
	PlaySE SEQ_SE_DP_SELECT
	FadeScreen 6, 1, 0, RGB_WHITE
	WaitFade
	HidePerson 8
	SetFlag 0x214F
	SetFlag 0x214F
	Wait 60, VAR_SPECIAL_RESULT
	FadeScreen 6, 1, 1, RGB_WHITE
	WaitFade
	Wait 60, VAR_SPECIAL_RESULT
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_GiovanniGone
	WaitButton
	CloseMsg
	Wait 30, VAR_SPECIAL_RESULT
	PlaySE SEQ_SE_DP_SELECT
	HidePerson 14
	SetFlag 0x2154
	SetFlag 0x2154
	Wait 40, VAR_SPECIAL_RESULT
	ApplyMovement 13, Common_Movement_WalkInPlaceFasterLeft
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterRight
	WaitMovement
	BufferPlayersName 6
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_MomDadsChansey
	WaitButton
	// TODO(gba) special DadStory_GiveChansey
	GoTo _cv_stop
	PlayFanfare SEQ_ME_ITEM
	BufferPlayersName 6
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_ReceivedDadsChansey
	WaitFanfare
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq DadStory_EventScript_ChanseyToPC
	BufferPlayersName 6
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_ReceivedDadsNotebook
	WaitButton
	SetFlag 0x2156
	SetFlag 0x200E
	SetFlag 0x2007
	SetVar 0x5008, 8
	BufferPlayersName 6
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_MomConfession
	WaitButton
	CloseMsg
	SetFlag 0x2153
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	Warp MAP_PALLET, 0, 1061, 360, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	ReleaseAll
	End
	
GymCandidate_EventScript_MentorItemExplain:
	BufferItemName 0, 0x8004
	CompareVarToValue 0x8009, 6
	GoToIfEq GymCandidate_EventScript_EdgeItemExplain
	NPCMsg msg_0454_T02GYM0101_GymCandidate_Text_GuardItemExplain
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
	
GymTera_EventScript_Skip_FIGHTING:
	SetVar 0x8005, 2
	// TODO(gba) special GymTera_IsTypeAllowed
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Skip_FLYING
	End
	
DadStory_EventScript_PlayerFromLeft:
	ApplyMovement obj_player, DadStory_Movement_PlayerFromLeft
	WaitMovement
	Return
	
DadStory_EventScript_PlayerFromRight:
	ApplyMovement obj_player, DadStory_Movement_PlayerFromRight
	WaitMovement
	Return
	
DadStory_EventScript_ChanseyToPC:
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_ChanseySentToPC
	WaitButton
	Return
	
GymCandidate_EventScript_EdgeItemExplain:
	NPCMsg msg_0454_T02GYM0101_GymCandidate_Text_EdgeItemExplain
	WaitButton
	Return
	
Outfits_EventScript_GymUniform:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Outfits_EventScript_Return
	PlayFanfare SEQ_ME_ITEM
	BufferPlayersName 6
	NPCMsg msg_0454_T02GYM0101_Outfits_Text_ReceivedGymUniform
	WaitFanfare
	BufferPlayersName 6
	NPCMsg msg_0454_T02GYM0101_Outfits_Text_PutInWardrobe
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
	
GymTera_EventScript_Skip_FLYING:
	SetVar 0x8005, 3
	// TODO(gba) special GymTera_IsTypeAllowed
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Skip_POISON
	End
	
Outfits_EventScript_Return:
	Return
	
EventScript_GymHack_MsgWrongType:
	NPCMsg msg_0454_T02GYM0101_Text_GymHack_WrongType
	WaitButton
	Return
	
EventScript_GymHack_MsgDuplicate:
	NPCMsg msg_0454_T02GYM0101_Text_GymHack_Duplicate
	WaitButton
	Return
	
EventScript_GymHack_MsgDuplicateItem:
	NPCMsg msg_0454_T02GYM0101_Text_GymHack_DuplicateItem
	WaitButton
	Return
	
GymTera_EventScript_Skip_POISON:
	SetVar 0x8005, 4
	// TODO(gba) special GymTera_IsTypeAllowed
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Skip_GROUND
	End
	
GymTera_EventScript_Skip_GROUND:
	SetVar 0x8005, 5
	// TODO(gba) special GymTera_IsTypeAllowed
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Skip_ROCK
	End
	
GymTera_EventScript_Skip_ROCK:
	SetVar 0x8005, 6
	// TODO(gba) special GymTera_IsTypeAllowed
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Skip_BUG
	End
	
GymTera_EventScript_Skip_BUG:
	SetVar 0x8005, 7
	// TODO(gba) special GymTera_IsTypeAllowed
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Skip_GHOST
	End
	
GymTera_EventScript_Skip_GHOST:
	SetVar 0x8005, 8
	// TODO(gba) special GymTera_IsTypeAllowed
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Skip_STEEL
	End
	
GymTera_EventScript_Skip_STEEL:
	SetVar 0x8005, 10
	// TODO(gba) special GymTera_IsTypeAllowed
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Skip_FIRE
	End
	
GymTera_EventScript_Skip_FIRE:
	SetVar 0x8005, 11
	// TODO(gba) special GymTera_IsTypeAllowed
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Skip_WATER
	End
	
GymTera_EventScript_Skip_WATER:
	SetVar 0x8005, 12
	// TODO(gba) special GymTera_IsTypeAllowed
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Skip_GRASS
	End
	
GymTera_EventScript_Skip_GRASS:
	SetVar 0x8005, 13
	// TODO(gba) special GymTera_IsTypeAllowed
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Skip_ELECTRIC
	End
	
GymTera_EventScript_Skip_ELECTRIC:
	SetVar 0x8005, 14
	// TODO(gba) special GymTera_IsTypeAllowed
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Skip_PSYCHIC
	End
	
GymTera_EventScript_Skip_PSYCHIC:
	SetVar 0x8005, 15
	// TODO(gba) special GymTera_IsTypeAllowed
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Skip_ICE
	End
	
GymTera_EventScript_Skip_ICE:
	SetVar 0x8005, 16
	// TODO(gba) special GymTera_IsTypeAllowed
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Skip_DRAGON
	End
	
GymTera_EventScript_Skip_DRAGON:
	SetVar 0x8005, 17
	// TODO(gba) special GymTera_IsTypeAllowed
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Skip_DARK
	End
	
GymTera_EventScript_Skip_DARK:
	SetVar 0x8005, 9
	// TODO(gba) special GymTera_IsTypeAllowed
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Skip_FAIRY
	End
	
GymTera_EventScript_Skip_FAIRY:
	Return

_cv_str4:
	BufferPlayersName 6
	BufferRivalsName 7
	CompareVarToValue 0x401F, 1
	GoToIfNe _cv_str4_0
	NPCMsg msg_0454_T02GYM0101_cv_mentor_first_rock
	Return
_cv_str4_0:
	CompareVarToValue 0x401F, 2
	GoToIfNe _cv_str4_1
	NPCMsg msg_0454_T02GYM0101_cv_mentor_first_normal
	Return
_cv_str4_1:
	CompareVarToValue 0x401F, 3
	GoToIfNe _cv_str4_2
	NPCMsg msg_0454_T02GYM0101_cv_mentor_first_water
	Return
_cv_str4_2:
	CompareVarToValue 0x401F, 4
	GoToIfNe _cv_str4_3
	NPCMsg msg_0454_T02GYM0101_cv_mentor_first_electric
	Return
_cv_str4_3:
	CompareVarToValue 0x401F, 5
	GoToIfNe _cv_str4_4
	NPCMsg msg_0454_T02GYM0101_cv_mentor_first_steel
	Return
_cv_str4_4:
	CompareVarToValue 0x401F, 6
	GoToIfNe _cv_str4_5
	NPCMsg msg_0454_T02GYM0101_cv_mentor_first_grass
	Return
_cv_str4_5:
	CompareVarToValue 0x401F, 7
	GoToIfNe _cv_str4_6
	NPCMsg msg_0454_T02GYM0101_cv_mentor_first_poison
	Return
_cv_str4_6:
	CompareVarToValue 0x401F, 8
	GoToIfNe _cv_str4_7
	NPCMsg msg_0454_T02GYM0101_cv_mentor_first_bug
	Return
_cv_str4_7:
	CompareVarToValue 0x401F, 9
	GoToIfNe _cv_str4_8
	NPCMsg msg_0454_T02GYM0101_cv_mentor_first_psychic
	Return
_cv_str4_8:
	CompareVarToValue 0x401F, 10
	GoToIfNe _cv_str4_9
	NPCMsg msg_0454_T02GYM0101_cv_mentor_first_fairy
	Return
_cv_str4_9:
	CompareVarToValue 0x401F, 11
	GoToIfNe _cv_str4_10
	NPCMsg msg_0454_T02GYM0101_cv_mentor_first_fire
	Return
_cv_str4_10:
	Return

_cv_stop:
	NPCMsg msg_0454_T02GYM0101_cv_unported
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
Common_Movement_WalkInPlaceFasterUp:
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
DadStory_Movement_MomUpToGiovanni:
	WalkNormalNorth 4
	WalkOnSpotFasterNorth
	EndMovement

	.balign 4, 0
DadStory_Movement_ChanseyAttacks:
	WalkOnSpotFasterWest
	JumpOnSpotFastWest
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
DadStory_Movement_PlayerFromLeft:
	WalkNormalSouth
	WalkNormalEast
	EndMovement

	.balign 4, 0
DadStory_Movement_PlayerFromRight:
	WalkNormalSouth
	WalkNormalWest
	EndMovement
	.balign 4, 0
