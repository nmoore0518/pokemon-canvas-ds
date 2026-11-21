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
	CanvasCheckTeam 7, 0x5019
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_team_not_allowed
	TrainerBattle 1086, 1086, 0, 0
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
	CanvasCloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	HidePerson 8
	SetFlag 0x214F
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	CanvasCloseMsg
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
	GoTo DadStory_EventScript_GiovanniLastBattle
	
EventScript_GymHack_ShowTeamRuleMessage:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq EventScript_GymHack_MsgWrongType
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	CallIfEq EventScript_GymHack_MsgDuplicate
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	CallIfEq EventScript_GymHack_MsgDuplicateItem
	Return
	
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
	GoTo DadStory_EventScript_ArcherAgain
	
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
	
DadStory_EventScript_GiovanniLastBattle:
	CanvasCloseMsg
	SetFlag 0x2036
	ClearTrainerFlag 1467
	SetVar VAR_SPECIAL_LAST_TALKED, 8
	CanvasCloseMsg
	TrainerBattle 1467, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_6
	WhiteOut
	End
_cv_won_6:
	SetTrainerFlag 1467
	ClearFlag 0x2036
	GetStaticEncounterOutcome VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfNe _cv_outcome_7
	SetVar VAR_SPECIAL_RESULT, 7
	GoTo _cv_outcome_8
_cv_outcome_7:
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfNe _cv_outcome_8
	SetVar VAR_SPECIAL_RESULT, 4
_cv_outcome_8:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq DadStory_EventScript_GiovanniFinale
	HealParty
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_GiovanniYouLost
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
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
	GoTo DadStory_EventScript_GiovanniStory
	
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
	GoTo GymHack_EventScript_GiveStatItemDone
	
GymCandidate_EventScript_TalkAgain:
	Call GymCandidate_EventScript_MentorGift
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_appr_9
	GoToIfUnset 0x2093, _cv_appr_9
	SetVar VAR_SPECIAL_RESULT, 1
_cv_appr_9:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_appr_10
	GoToIfUnset 0x2094, _cv_appr_10
	SetVar VAR_SPECIAL_RESULT, 1
_cv_appr_10:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_appr_11
	GoToIfUnset 0x2095, _cv_appr_11
	SetVar VAR_SPECIAL_RESULT, 1
_cv_appr_11:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_appr_12
	GoToIfUnset 0x2096, _cv_appr_12
	SetVar VAR_SPECIAL_RESULT, 1
_cv_appr_12:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_appr_13
	GoToIfUnset 0x2097, _cv_appr_13
	SetVar VAR_SPECIAL_RESULT, 1
_cv_appr_13:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_appr_14
	GoToIfUnset 0x2098, _cv_appr_14
	SetVar VAR_SPECIAL_RESULT, 1
_cv_appr_14:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_appr_15
	GoToIfUnset 0x2099, _cv_appr_15
	SetVar VAR_SPECIAL_RESULT, 1
_cv_appr_15:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_appr_16
	GoToIfUnset 0x2007, _cv_appr_16
	SetVar VAR_SPECIAL_RESULT, 1
_cv_appr_16:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_Offer
	CompareVarToValue 0x8009, 7
	GoToIfEq GymCandidate_EventScript_Return
	GoToIfSet 0x2008, GymCandidate_EventScript_OwnGym
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_next_18
	SetVar 0x401F, 1
	GoTo _cv_done_17
_cv_next_18:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_next_19
	SetVar 0x401F, 2
	GoTo _cv_done_17
_cv_next_19:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_next_20
	SetVar 0x401F, 3
	GoTo _cv_done_17
_cv_next_20:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_next_21
	SetVar 0x401F, 4
	GoTo _cv_done_17
_cv_next_21:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_next_22
	SetVar 0x401F, 5
	GoTo _cv_done_17
_cv_next_22:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_next_23
	SetVar 0x401F, 6
	GoTo _cv_done_17
_cv_next_23:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_next_24
	SetVar 0x401F, 7
	GoTo _cv_done_17
_cv_next_24:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_next_25
	SetVar 0x401F, 8
	GoTo _cv_done_17
_cv_next_25:
_cv_done_17:
	Call _cv_str4
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_26
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_27
_cv_yes_26:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_27:
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
	GoToIfEq _cv_yes_28
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_29
_cv_yes_28:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_29:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Later
	CloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	ScrCmd_566
	GetPartySelection 0x8004
	RestoreOverworld
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
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
	GoToIfLt _cv_menu_31
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_31:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq GymTera_EventScript_Later
	CopyVar 0x8005, VAR_SPECIAL_RESULT
	CanvasCloseMsg
	// TODO(gba) special GymTera_CheckPrice
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Already
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq GymTera_EventScript_NoBerries
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_ArcherTunePrice
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_32
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_33
_cv_yes_32:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_33:
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
	
DadStory_EventScript_ArcherAgain:
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_ArcherAgain
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
	
DadStory_EventScript_GiovanniFinale:
	// TODO(gba) special DadStory_BufferAce
	GoTo _cv_stop
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_GiovanniHow
	WaitButton
	CanvasCloseMsg
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
	GoToIfUnset 0x2153, _cv_show_34
	ClearFlag 0x2153
	ShowPerson 13
	SetFlag 0x2153
	GoTo _cv_shown_35
_cv_show_34:
	ShowPerson 13
_cv_shown_35:
	ApplyMovement 13, DadStory_Movement_MomUpToGiovanni
	WaitMovement
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_MomLastTime
	WaitButton
	CanvasCloseMsg
	PlaySE SEQ_SE_DP_SELECT
	Wait 20, VAR_SPECIAL_RESULT
	PlaySE SEQ_SE_DP_SELECT
	ClearFlag 0x2154
	GoToIfUnset 0x2154, _cv_show_36
	ClearFlag 0x2154
	ShowPerson 14
	SetFlag 0x2154
	GoTo _cv_shown_37
_cv_show_36:
	ShowPerson 14
_cv_shown_37:
	PlayCry SPECIES_CHANSEY, 0
	WaitCry
	Wait 20, VAR_SPECIAL_RESULT
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_ChanseyGlows
	WaitButton
	CanvasCloseMsg
	SetVar 0x8004, 2
	SetVar 0x8005, 2
	SetVar 0x8006, 16
	SetVar 0x8007, 3
	PlaySE SEQ_SE_DP_SELECT
	ScreenShake 0x8005, 0x8004, 0x8007, 0x8006
	ApplyMovement 14, DadStory_Movement_ChanseyAttacks
	WaitMovement
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_ChanseyUnleashes
	WaitButton
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_GiovanniOverwhelmed
	WaitButton
	CanvasCloseMsg
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
	CanvasCloseMsg
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
	CanvasCloseMsg
	SetFlag 0x2153
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	Warp MAP_PALLET, 0, 1061, 360, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	CanvasCloseMsg
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
	
DadStory_EventScript_GiovanniStory:
	BufferPlayersName 6
	NPCMsg msg_0454_T02GYM0101_DadStory_Text_GiovanniYourFather
	WaitButton
	SetVar 0x5008, 7
	GoTo DadStory_EventScript_GiovanniLastBattle
	
GymCandidate_EventScript_AfterBadge:
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_mentor_38
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_mentor_38
	SetVar 0x401F, 9
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_38:
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_mentor_39
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_mentor_39
	SetVar 0x401F, 10
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_39:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_mentor_40
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_mentor_40
	SetVar 0x401F, 11
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_40:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_mentor_41
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_mentor_41
	SetVar 0x401F, 12
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_41:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_mentor_42
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_mentor_42
	SetVar 0x401F, 13
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_42:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_mentor_43
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_mentor_43
	SetVar 0x401F, 14
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_43:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_mentor_44
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_mentor_44
	SetVar 0x401F, 15
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_44:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_mentor_45
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_mentor_45
	SetVar 0x401F, 16
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_45:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_mentor_46
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_mentor_46
	SetVar 0x401F, 17
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_46:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_mentor_47
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_mentor_47
	SetVar 0x401F, 18
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_47:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_mentor_48
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_mentor_48
	SetVar 0x401F, 19
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_48:
	CompareVarToValue 0x8009, 9
	GoToIfNe _cv_mentor_49
	CompareVarToValue 0x5019, 4
	GoToIfNe _cv_mentor_49
	SetVar 0x401F, 20
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_49:
	CompareVarToValue 0x8009, 10
	GoToIfNe _cv_mentor_50
	CompareVarToValue 0x5019, 17
	GoToIfNe _cv_mentor_50
	SetVar 0x401F, 21
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_50:
	CompareVarToValue 0x8009, 8
	GoToIfNe _cv_mentor_51
	CompareVarToValue 0x5019, 15
	GoToIfNe _cv_mentor_51
	SetVar 0x401F, 22
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_51:
	CompareVarToValue 0x8009, 9
	GoToIfNe _cv_mentor_52
	CompareVarToValue 0x5019, 1
	GoToIfNe _cv_mentor_52
	SetVar 0x401F, 23
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_52:
	CompareVarToValue 0x8009, 10
	GoToIfNe _cv_mentor_53
	CompareVarToValue 0x5019, 7
	GoToIfNe _cv_mentor_53
	SetVar 0x401F, 24
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_53:
	CompareVarToValue 0x8009, 11
	GoToIfNe _cv_mentor_54
	CompareVarToValue 0x5019, 16
	GoToIfNe _cv_mentor_54
	SetVar 0x401F, 25
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_54:
	CompareVarToValue 0x8009, 11
	GoToIfNe _cv_mentor_55
	CompareVarToValue 0x5019, 2
	GoToIfNe _cv_mentor_55
	SetVar 0x401F, 26
	SetVar VAR_SPECIAL_RESULT, 1
_cv_mentor_55:
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
	NPCMsg msg_0454_T02GYM0101_GymCandidate_Text_SomeoneToSeeYou
	WaitButton
	CanvasCloseMsg
	Call GymCandidate_EventScript_VisitorWalksIn
	Call GymCandidate_EventScript_MentorGiveItem
	Call GymCandidate_EventScript_VisitorWalksOut
	Return
	
GymCandidate_EventScript_Offer:
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_next_57
	SetVar 0x401F, 27
	GoTo _cv_done_56
_cv_next_57:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_next_58
	SetVar 0x401F, 28
	GoTo _cv_done_56
_cv_next_58:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_next_59
	SetVar 0x401F, 29
	GoTo _cv_done_56
_cv_next_59:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_next_60
	SetVar 0x401F, 30
	GoTo _cv_done_56
_cv_next_60:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_next_61
	SetVar 0x401F, 31
	GoTo _cv_done_56
_cv_next_61:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_next_62
	SetVar 0x401F, 32
	GoTo _cv_done_56
_cv_next_62:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_next_63
	SetVar 0x401F, 33
	GoTo _cv_done_56
_cv_next_63:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_next_64
	SetVar 0x401F, 34
	GoTo _cv_done_56
_cv_next_64:
_cv_done_56:
	Call _cv_str4
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_65
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_66
_cv_yes_65:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_66:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_NotYet
	SetVar 0x8007, 0
	GoTo GymCandidate_EventScript_Start
	
GymCandidate_EventScript_Return:
	Return
	
GymCandidate_EventScript_OwnGym:
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_next_68
	SetVar 0x401F, 35
	GoTo _cv_done_67
_cv_next_68:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_next_69
	SetVar 0x401F, 36
	GoTo _cv_done_67
_cv_next_69:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_next_70
	SetVar 0x401F, 37
	GoTo _cv_done_67
_cv_next_70:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_next_71
	SetVar 0x401F, 38
	GoTo _cv_done_67
_cv_next_71:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_next_72
	SetVar 0x401F, 39
	GoTo _cv_done_67
_cv_next_72:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_next_73
	SetVar 0x401F, 40
	GoTo _cv_done_67
_cv_next_73:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_next_74
	SetVar 0x401F, 41
	GoTo _cv_done_67
_cv_next_74:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_next_75
	SetVar 0x401F, 42
	GoTo _cv_done_67
_cv_next_75:
_cv_done_67:
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
	CanvasCheckTeam 7, 0x5019
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe GymCandidate_EventScript_TeamBreaksRules
	SetVar 0x800B, 0
	Call GymCandidate_EventScript_TakeLeadersPlace
	GoTo GymCandidate_EventScript_NextGuest
	
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
	GoTo GymTera_EventScript_Skip_NORMAL
	
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
	
GymCandidate_EventScript_ShowText4:
	Call _cv_str4
	WaitButton
	Return
	
GymCandidate_EventScript_MentorGiveItem:
	Call _cv_str4
	WaitButton
	GiveItem 0x8004, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymCandidate_EventScript_MentorItemExplain
	BufferItemName 1, 0x8004
	NPCMsg msg_0454_T02GYM0101_GymHack_Text_GiftSentToPC
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
	NPCMsg msg_0454_T02GYM0101_GymCandidate_Text_TeamBreaksRules
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_TakeLeadersPlace:
	CanvasCandidate 7
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_Return
	CompareVarToValue 0x8007, 0
	GoToIfEq _cv_hold_76
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_next_78
	CanvasBufferMsg 2, msg_0454_T02GYM0101_cv_leader_0
	GoTo _cv_done_77
_cv_next_78:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_next_79
	CanvasBufferMsg 2, msg_0454_T02GYM0101_cv_leader_1
	GoTo _cv_done_77
_cv_next_79:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_next_80
	CanvasBufferMsg 2, msg_0454_T02GYM0101_cv_leader_2
	GoTo _cv_done_77
_cv_next_80:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_next_81
	CanvasBufferMsg 2, msg_0454_T02GYM0101_cv_leader_3
	GoTo _cv_done_77
_cv_next_81:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_next_82
	CanvasBufferMsg 2, msg_0454_T02GYM0101_cv_leader_4
	GoTo _cv_done_77
_cv_next_82:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_next_83
	CanvasBufferMsg 2, msg_0454_T02GYM0101_cv_leader_5
	GoTo _cv_done_77
_cv_next_83:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_next_84
	CanvasBufferMsg 2, msg_0454_T02GYM0101_cv_leader_6
	GoTo _cv_done_77
_cv_next_84:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_next_85
	CanvasBufferMsg 2, msg_0454_T02GYM0101_cv_leader_7
	GoTo _cv_done_77
_cv_next_85:
_cv_done_77:
	SetVar 0x401F, 43
	GoTo _cv_hold_86
_cv_hold_76:
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_next_88
	SetVar 0x401F, 44
	GoTo _cv_done_87
_cv_next_88:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_next_89
	SetVar 0x401F, 45
	GoTo _cv_done_87
_cv_next_89:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_next_90
	SetVar 0x401F, 46
	GoTo _cv_done_87
_cv_next_90:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_next_91
	SetVar 0x401F, 47
	GoTo _cv_done_87
_cv_next_91:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_next_92
	SetVar 0x401F, 48
	GoTo _cv_done_87
_cv_next_92:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_next_93
	SetVar 0x401F, 49
	GoTo _cv_done_87
_cv_next_93:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_next_94
	SetVar 0x401F, 50
	GoTo _cv_done_87
_cv_next_94:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_next_95
	SetVar 0x401F, 51
	GoTo _cv_done_87
_cv_next_95:
_cv_done_87:
_cv_hold_86:
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
	GoToIfNe _cv_guest_96
	CanvasBufferMsg 2, msg_0454_T02GYM0101_cv_leader_0
	CanvasCandidate 0, 12, 2, 0, 0x8007
_cv_guest_96:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_guest_97
	CanvasBufferMsg 2, msg_0454_T02GYM0101_cv_leader_1
	CanvasCandidate 0, 20, 3, 0, 0x8007
_cv_guest_97:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_guest_98
	CanvasBufferMsg 2, msg_0454_T02GYM0101_cv_leader_2
	CanvasCandidate 0, 24, 3, 1, 0x8007
_cv_guest_98:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_guest_99
	CanvasBufferMsg 2, msg_0454_T02GYM0101_cv_leader_3
	CanvasCandidate 0, 29, 4, 1, 0x8007
_cv_guest_99:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_guest_100
	CanvasBufferMsg 2, msg_0454_T02GYM0101_cv_leader_4
	CanvasCandidate 0, 37, 4, 1, 0x8007
_cv_guest_100:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_guest_101
	CanvasBufferMsg 2, msg_0454_T02GYM0101_cv_leader_5
	CanvasCandidate 0, 40, 4, 2, 0x8007
_cv_guest_101:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_guest_102
	CanvasBufferMsg 2, msg_0454_T02GYM0101_cv_leader_6
	CanvasCandidate 0, 44, 5, 2, 0x8007
_cv_guest_102:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_guest_103
	CanvasBufferMsg 2, msg_0454_T02GYM0101_cv_leader_7
	CanvasCandidate 0, 47, 5, 2, 0x8007
_cv_guest_103:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_next_105
	SetVar 0x4020, SPRITE_GSMAN3
	GoTo _cv_done_104
_cv_next_105:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfNe _cv_next_106
	SetVar 0x4020, SPRITE_GSWOMAN3
	GoTo _cv_done_104
_cv_next_106:
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfNe _cv_next_107
	SetVar 0x4020, SPRITE_GSMAN3
	GoTo _cv_done_104
_cv_next_107:
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfNe _cv_next_108
	SetVar 0x4020, SPRITE_GSWOMAN3
	GoTo _cv_done_104
_cv_next_108:
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfNe _cv_next_109
	SetVar 0x4020, SPRITE_GSFIGHTER
	GoTo _cv_done_104
_cv_next_109:
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfNe _cv_next_110
	SetVar 0x4020, SPRITE_GSGENTLEMAN
	GoTo _cv_done_104
_cv_next_110:
	CompareVarToValue VAR_SPECIAL_RESULT, 6
	GoToIfNe _cv_next_111
	SetVar 0x4020, SPRITE_MOUNT_2
	GoTo _cv_done_104
_cv_next_111:
	CompareVarToValue VAR_SPECIAL_RESULT, 7
	GoToIfNe _cv_next_112
	SetVar 0x4020, SPRITE_GSMAN2
	GoTo _cv_done_104
_cv_next_112:
	CompareVarToValue VAR_SPECIAL_RESULT, 8
	GoToIfNe _cv_next_113
	SetVar 0x4020, SPRITE_BADMAN
	GoTo _cv_done_104
_cv_next_113:
	CompareVarToValue VAR_SPECIAL_RESULT, 9
	GoToIfNe _cv_next_114
	SetVar 0x4020, SPRITE_WORKMAN
	GoTo _cv_done_104
_cv_next_114:
	CompareVarToValue VAR_SPECIAL_RESULT, 10
	GoToIfNe _cv_next_115
	SetVar 0x4020, SPRITE_GSASSISTANTM
	GoTo _cv_done_104
_cv_next_115:
	CompareVarToValue VAR_SPECIAL_RESULT, 11
	GoToIfNe _cv_next_116
	SetVar 0x4020, SPRITE_MANIA
	GoTo _cv_done_104
_cv_next_116:
	CompareVarToValue VAR_SPECIAL_RESULT, 12
	GoToIfNe _cv_next_117
	SetVar 0x4020, SPRITE_CAMPBOY_2
	GoTo _cv_done_104
_cv_next_117:
	CompareVarToValue VAR_SPECIAL_RESULT, 13
	GoToIfNe _cv_next_118
	SetVar 0x4020, SPRITE_SEAMAN_2
	GoTo _cv_done_104
_cv_next_118:
	CompareVarToValue VAR_SPECIAL_RESULT, 14
	GoToIfNe _cv_next_119
	SetVar 0x4020, SPRITE_FISHING_2
	GoTo _cv_done_104
_cv_next_119:
	CompareVarToValue VAR_SPECIAL_RESULT, 15
	GoToIfNe _cv_next_120
	SetVar 0x4020, SPRITE_GSBOY2
	GoTo _cv_done_104
_cv_next_120:
	CompareVarToValue VAR_SPECIAL_RESULT, 16
	GoToIfNe _cv_next_121
	SetVar 0x4020, SPRITE_WOMAN2
	GoTo _cv_done_104
_cv_next_121:
	CompareVarToValue VAR_SPECIAL_RESULT, 17
	GoToIfNe _cv_next_122
	SetVar 0x4020, SPRITE_GSGIRL2
	GoTo _cv_done_104
_cv_next_122:
	CompareVarToValue VAR_SPECIAL_RESULT, 18
	GoToIfNe _cv_next_123
	SetVar 0x4020, SPRITE_PICNICGIRL_2
	GoTo _cv_done_104
_cv_next_123:
	CompareVarToValue VAR_SPECIAL_RESULT, 19
	GoToIfNe _cv_next_124
	SetVar 0x4020, SPRITE_GSGIRL3
	GoTo _cv_done_104
_cv_next_124:
	CompareVarToValue VAR_SPECIAL_RESULT, 20
	GoToIfNe _cv_next_125
	SetVar 0x4020, SPRITE_GSSWIMMERW
	GoTo _cv_done_104
_cv_next_125:
	CompareVarToValue VAR_SPECIAL_RESULT, 21
	GoToIfNe _cv_next_126
	SetVar 0x4020, SPRITE_GSSWIMMERM
	GoTo _cv_done_104
_cv_next_126:
_cv_done_104:
	Random 0x5048, 4
	Random 0x5049, 3
	Random 0x504A, 3
	Random 0x504B, 2
	SetVar 0x504C, 0
	GoToIfUnset 0x208D, _cv_single_127
	Random 0x401E, 3
	CompareVarToValue 0x401E, 0
	GoToIfEq _cv_single_127
	SetVar 0x504C, 1
_cv_single_127:
	CompareVarToValue 0x800B, 0
	CallIfEq GymCandidate_EventScript_LaterThatDay
	CompareVarToValue 0x800B, 0
	CallIfNe GymCandidate_EventScript_AnotherOne
	CanvasCloseMsg
	Call GymCandidate_EventScript_ChallengerWalksIn
	CompareVarToValue 0x5048, 0
	GoToIfNe _cv_line_129
	NPCMsg msg_0454_T02GYM0101_cv_guest_intro_0
	WaitButton
	GoTo _cv_line_128
_cv_line_129:
	CompareVarToValue 0x5048, 1
	GoToIfNe _cv_line_130
	NPCMsg msg_0454_T02GYM0101_cv_guest_intro_1
	WaitButton
	GoTo _cv_line_128
_cv_line_130:
	CompareVarToValue 0x5048, 2
	GoToIfNe _cv_line_131
	NPCMsg msg_0454_T02GYM0101_cv_guest_intro_2
	WaitButton
	GoTo _cv_line_128
_cv_line_131:
	CompareVarToValue 0x5048, 3
	GoToIfNe _cv_line_132
	NPCMsg msg_0454_T02GYM0101_cv_guest_intro_3
	WaitButton
	GoTo _cv_line_128
_cv_line_132:
_cv_line_128:
	CanvasCloseMsg
	CanvasCloseMsg
	CompareVarToValue 0x504C, 0
	GoToIfNe _cv_battle_134
	CompareVarToValue 0x5049, 0
	GoToIfNe _cv_battle_134
	ClearTrainerFlag 1470
	TrainerBattle 1470, 0, 1, 0
	GoTo _cv_battle_133
_cv_battle_134:
	CompareVarToValue 0x504C, 0
	GoToIfNe _cv_battle_135
	CompareVarToValue 0x5049, 1
	GoToIfNe _cv_battle_135
	ClearTrainerFlag 1471
	TrainerBattle 1471, 0, 1, 0
	GoTo _cv_battle_133
_cv_battle_135:
	CompareVarToValue 0x504C, 0
	GoToIfNe _cv_battle_136
	CompareVarToValue 0x5049, 2
	GoToIfNe _cv_battle_136
	ClearTrainerFlag 1472
	TrainerBattle 1472, 0, 1, 0
	GoTo _cv_battle_133
_cv_battle_136:
	CompareVarToValue 0x504C, 1
	GoToIfNe _cv_battle_137
	CompareVarToValue 0x5049, 0
	GoToIfNe _cv_battle_137
	ClearTrainerFlag 1473
	TrainerBattle 1473, 1473, 1, 0
	GoTo _cv_battle_133
_cv_battle_137:
	CompareVarToValue 0x504C, 1
	GoToIfNe _cv_battle_138
	CompareVarToValue 0x5049, 1
	GoToIfNe _cv_battle_138
	ClearTrainerFlag 1474
	TrainerBattle 1474, 1474, 1, 0
	GoTo _cv_battle_133
_cv_battle_138:
	CompareVarToValue 0x504C, 1
	GoToIfNe _cv_battle_139
	CompareVarToValue 0x5049, 2
	GoToIfNe _cv_battle_139
	ClearTrainerFlag 1475
	TrainerBattle 1475, 1475, 1, 0
	GoTo _cv_battle_133
_cv_battle_139:
_cv_battle_133:
	CheckBattleWon VAR_SPECIAL_RESULT
	CanvasCandidate 12
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfNe GymCandidate_EventScript_GuestWon
	HealParty
	CompareVarToValue 0x504A, 0
	GoToIfNe _cv_line_141
	NPCMsg msg_0454_T02GYM0101_cv_guest_after_0
	WaitButton
	GoTo _cv_line_140
_cv_line_141:
	CompareVarToValue 0x504A, 1
	GoToIfNe _cv_line_142
	NPCMsg msg_0454_T02GYM0101_cv_guest_after_1
	WaitButton
	GoTo _cv_line_140
_cv_line_142:
	CompareVarToValue 0x504A, 2
	GoToIfNe _cv_line_143
	NPCMsg msg_0454_T02GYM0101_cv_guest_after_2
	WaitButton
	GoTo _cv_line_140
_cv_line_143:
_cv_line_140:
	Call GymCandidate_EventScript_VisitorWalksOut
	AddVar 0x800B, 1
	SetVar VAR_SPECIAL_RESULT, 0
	SetVar 0x401E, 1
	CompareVarToValue 0x8007, 0
	GoToIfNe _cv_guests_144
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_next_146
	SetVar 0x401E, 1
	GoTo _cv_done_145
_cv_next_146:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_next_147
	SetVar 0x401E, 1
	GoTo _cv_done_145
_cv_next_147:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_next_148
	SetVar 0x401E, 1
	GoTo _cv_done_145
_cv_next_148:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_next_149
	SetVar 0x401E, 1
	GoTo _cv_done_145
_cv_next_149:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_next_150
	SetVar 0x401E, 2
	GoTo _cv_done_145
_cv_next_150:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_next_151
	SetVar 0x401E, 2
	GoTo _cv_done_145
_cv_next_151:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_next_152
	SetVar 0x401E, 2
	GoTo _cv_done_145
_cv_next_152:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_next_153
	SetVar 0x401E, 2
	GoTo _cv_done_145
_cv_next_153:
_cv_done_145:
_cv_guests_144:
	CompareVarToVar 0x800B, 0x401E
	GoToIfGe _cv_guests_154
	SetVar VAR_SPECIAL_RESULT, 1
_cv_guests_154:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymCandidate_EventScript_NextGuest
	Call GymCandidate_EventScript_ReturnLeadersPlace
	CompareVarToValue 0x8007, 1
	GoToIfEq GymCandidate_EventScript_ShiftDone
	CompareVarToValue 0x8009, 0
	GoToIfNe _cv_next_174
	SetFlag 0x2093
	SetVar 0x401F, 52
	CompareVarToValue 0x5019, 5
	GoToIfNe _cv_next_156
	SetVar 0x401F, 53
	GoTo _cv_done_155
_cv_next_156:
	CompareVarToValue 0x5019, 0
	GoToIfNe _cv_next_157
	SetVar 0x401F, 54
	GoTo _cv_done_155
_cv_next_157:
_cv_done_155:
	GoTo _cv_done_173
_cv_next_174:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_next_175
	SetFlag 0x2094
	SetVar 0x401F, 55
	CompareVarToValue 0x5019, 11
	GoToIfNe _cv_next_159
	SetVar 0x401F, 56
	GoTo _cv_done_158
_cv_next_159:
_cv_done_158:
	GoTo _cv_done_173
_cv_next_175:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_next_176
	SetFlag 0x2095
	SetVar 0x401F, 57
	CompareVarToValue 0x5019, 13
	GoToIfNe _cv_next_161
	SetVar 0x401F, 58
	GoTo _cv_done_160
_cv_next_161:
	CompareVarToValue 0x5019, 8
	GoToIfNe _cv_next_162
	SetVar 0x401F, 59
	GoTo _cv_done_160
_cv_next_162:
_cv_done_160:
	GoTo _cv_done_173
_cv_next_176:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_next_177
	SetFlag 0x2096
	SetVar 0x401F, 60
	CompareVarToValue 0x5019, 12
	GoToIfNe _cv_next_164
	SetVar 0x401F, 61
	GoTo _cv_done_163
_cv_next_164:
_cv_done_163:
	GoTo _cv_done_173
_cv_next_177:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_next_178
	SetFlag 0x2097
	SetVar 0x401F, 62
	CompareVarToValue 0x5019, 3
	GoToIfNe _cv_next_166
	SetVar 0x401F, 63
	GoTo _cv_done_165
_cv_next_166:
	CompareVarToValue 0x5019, 6
	GoToIfNe _cv_next_167
	SetVar 0x401F, 64
	GoTo _cv_done_165
_cv_next_167:
_cv_done_165:
	GoTo _cv_done_173
_cv_next_178:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_next_179
	SetFlag 0x2098
	SetVar 0x401F, 65
	CompareVarToValue 0x5019, 14
	GoToIfNe _cv_next_169
	SetVar 0x401F, 66
	GoTo _cv_done_168
_cv_next_169:
	CompareVarToValue 0x5019, 9
	GoToIfNe _cv_next_170
	SetVar 0x401F, 67
	GoTo _cv_done_168
_cv_next_170:
_cv_done_168:
	GoTo _cv_done_173
_cv_next_179:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_next_180
	SetFlag 0x2099
	SetVar 0x401F, 68
	CompareVarToValue 0x5019, 10
	GoToIfNe _cv_next_172
	SetVar 0x401F, 69
	GoTo _cv_done_171
_cv_next_172:
_cv_done_171:
	GoTo _cv_done_173
_cv_next_180:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_next_181
	SetFlag 0x2007
	SetVar 0x401F, 70
	GoTo _cv_done_173
_cv_next_181:
_cv_done_173:
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x2093, _cv_appr_182
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_182:
	GoToIfUnset 0x2094, _cv_appr_183
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_183:
	GoToIfUnset 0x2095, _cv_appr_184
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_184:
	GoToIfUnset 0x2096, _cv_appr_185
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_185:
	GoToIfUnset 0x2097, _cv_appr_186
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_186:
	GoToIfUnset 0x2098, _cv_appr_187
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_187:
	GoToIfUnset 0x2099, _cv_appr_188
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_188:
	GoToIfUnset 0x2007, _cv_appr_189
	AddVar VAR_SPECIAL_RESULT, 1
_cv_appr_189:
	BufferInt 0, VAR_SPECIAL_RESULT
	PlayFanfare SEQ_ME_LVUP
	Call _cv_str4
	WaitButton
	WaitFanfare
	NPCMsg msg_0454_T02GYM0101_GymCandidate_Text_ApprovalCount
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymTera_EventScript_Skip_NORMAL:
	SetVar 0x8005, 1
	// TODO(gba) special GymTera_IsTypeAllowed
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Skip_FIGHTING
	GoTo GymTera_EventScript_Skip_FIGHTING
	
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
	NPCMsg msg_0454_T02GYM0101_GymCandidate_Text_LaterThatDay
	WaitButton
	Return
	
GymCandidate_EventScript_AnotherOne:
	NPCMsg msg_0454_T02GYM0101_GymCandidate_Text_AnotherOne
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
	GoToIfNe _cv_line_191
	NPCMsg msg_0454_T02GYM0101_cv_guest_win_0
	WaitButton
	GoTo _cv_line_190
_cv_line_191:
	CompareVarToValue 0x504B, 1
	GoToIfNe _cv_line_192
	NPCMsg msg_0454_T02GYM0101_cv_guest_win_1
	WaitButton
	GoTo _cv_line_190
_cv_line_192:
_cv_line_190:
	Call GymCandidate_EventScript_VisitorWalksOut
	Call GymCandidate_EventScript_ReturnLeadersPlace
	NPCMsg msg_0454_T02GYM0101_GymCandidate_Text_TryAgain
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
	GoToIfNe _cv_next_194
	SetVar 0x401F, 71
	GoTo _cv_done_193
_cv_next_194:
	CompareVarToValue 0x8009, 1
	GoToIfNe _cv_next_195
	SetVar 0x401F, 72
	GoTo _cv_done_193
_cv_next_195:
	CompareVarToValue 0x8009, 2
	GoToIfNe _cv_next_196
	SetVar 0x401F, 73
	GoTo _cv_done_193
_cv_next_196:
	CompareVarToValue 0x8009, 3
	GoToIfNe _cv_next_197
	SetVar 0x401F, 74
	GoTo _cv_done_193
_cv_next_197:
	CompareVarToValue 0x8009, 4
	GoToIfNe _cv_next_198
	SetVar 0x401F, 75
	GoTo _cv_done_193
_cv_next_198:
	CompareVarToValue 0x8009, 5
	GoToIfNe _cv_next_199
	SetVar 0x401F, 76
	GoTo _cv_done_193
_cv_next_199:
	CompareVarToValue 0x8009, 6
	GoToIfNe _cv_next_200
	SetVar 0x401F, 77
	GoTo _cv_done_193
_cv_next_200:
	CompareVarToValue 0x8009, 7
	GoToIfNe _cv_next_201
	SetVar 0x401F, 78
	GoTo _cv_done_193
_cv_next_201:
_cv_done_193:
	Call _cv_str4
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymTera_EventScript_Skip_FIGHTING:
	SetVar 0x8005, 2
	// TODO(gba) special GymTera_IsTypeAllowed
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Skip_FLYING
	GoTo GymTera_EventScript_Skip_FLYING
	
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
	
GymTera_EventScript_Skip_FLYING:
	SetVar 0x8005, 3
	// TODO(gba) special GymTera_IsTypeAllowed
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Skip_POISON
	GoTo GymTera_EventScript_Skip_POISON
	
Outfits_EventScript_Return:
	Return
	
GymCandidate_EventScript_GuestNoRoom:
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	Return
	
GymTera_EventScript_Skip_POISON:
	SetVar 0x8005, 4
	// TODO(gba) special GymTera_IsTypeAllowed
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Skip_GROUND
	GoTo GymTera_EventScript_Skip_GROUND
	
GymTera_EventScript_Skip_GROUND:
	SetVar 0x8005, 5
	// TODO(gba) special GymTera_IsTypeAllowed
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Skip_ROCK
	GoTo GymTera_EventScript_Skip_ROCK
	
GymTera_EventScript_Skip_ROCK:
	SetVar 0x8005, 6
	// TODO(gba) special GymTera_IsTypeAllowed
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Skip_BUG
	GoTo GymTera_EventScript_Skip_BUG
	
GymTera_EventScript_Skip_BUG:
	SetVar 0x8005, 7
	// TODO(gba) special GymTera_IsTypeAllowed
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Skip_GHOST
	GoTo GymTera_EventScript_Skip_GHOST
	
GymTera_EventScript_Skip_GHOST:
	SetVar 0x8005, 8
	// TODO(gba) special GymTera_IsTypeAllowed
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Skip_STEEL
	GoTo GymTera_EventScript_Skip_STEEL
	
GymTera_EventScript_Skip_STEEL:
	SetVar 0x8005, 10
	// TODO(gba) special GymTera_IsTypeAllowed
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Skip_FIRE
	GoTo GymTera_EventScript_Skip_FIRE
	
GymTera_EventScript_Skip_FIRE:
	SetVar 0x8005, 11
	// TODO(gba) special GymTera_IsTypeAllowed
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Skip_WATER
	GoTo GymTera_EventScript_Skip_WATER
	
GymTera_EventScript_Skip_WATER:
	SetVar 0x8005, 12
	// TODO(gba) special GymTera_IsTypeAllowed
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Skip_GRASS
	GoTo GymTera_EventScript_Skip_GRASS
	
GymTera_EventScript_Skip_GRASS:
	SetVar 0x8005, 13
	// TODO(gba) special GymTera_IsTypeAllowed
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Skip_ELECTRIC
	GoTo GymTera_EventScript_Skip_ELECTRIC
	
GymTera_EventScript_Skip_ELECTRIC:
	SetVar 0x8005, 14
	// TODO(gba) special GymTera_IsTypeAllowed
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Skip_PSYCHIC
	GoTo GymTera_EventScript_Skip_PSYCHIC
	
GymTera_EventScript_Skip_PSYCHIC:
	SetVar 0x8005, 15
	// TODO(gba) special GymTera_IsTypeAllowed
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Skip_ICE
	GoTo GymTera_EventScript_Skip_ICE
	
GymTera_EventScript_Skip_ICE:
	SetVar 0x8005, 16
	// TODO(gba) special GymTera_IsTypeAllowed
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Skip_DRAGON
	GoTo GymTera_EventScript_Skip_DRAGON
	
GymTera_EventScript_Skip_DRAGON:
	SetVar 0x8005, 17
	// TODO(gba) special GymTera_IsTypeAllowed
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Skip_DARK
	GoTo GymTera_EventScript_Skip_DARK
	
GymTera_EventScript_Skip_DARK:
	SetVar 0x8005, 9
	// TODO(gba) special GymTera_IsTypeAllowed
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymTera_EventScript_Skip_FAIRY
	GoTo GymTera_EventScript_Skip_FAIRY
	
GymTera_EventScript_Skip_FAIRY:
	Return

_cv_str4:
	BufferPlayersName 6
	BufferRivalsName 7
	CompareVarToValue 0x401F, 1
	GoToIfNe _cv_str4_0
	NPCMsg msg_0454_T02GYM0101_cv_leader_repeatOffer_0
	Return
_cv_str4_0:
	CompareVarToValue 0x401F, 2
	GoToIfNe _cv_str4_1
	NPCMsg msg_0454_T02GYM0101_cv_leader_repeatOffer_1
	Return
_cv_str4_1:
	CompareVarToValue 0x401F, 3
	GoToIfNe _cv_str4_2
	NPCMsg msg_0454_T02GYM0101_cv_leader_repeatOffer_2
	Return
_cv_str4_2:
	CompareVarToValue 0x401F, 4
	GoToIfNe _cv_str4_3
	NPCMsg msg_0454_T02GYM0101_cv_leader_repeatOffer_3
	Return
_cv_str4_3:
	CompareVarToValue 0x401F, 5
	GoToIfNe _cv_str4_4
	NPCMsg msg_0454_T02GYM0101_cv_leader_repeatOffer_4
	Return
_cv_str4_4:
	CompareVarToValue 0x401F, 6
	GoToIfNe _cv_str4_5
	NPCMsg msg_0454_T02GYM0101_cv_leader_repeatOffer_5
	Return
_cv_str4_5:
	CompareVarToValue 0x401F, 7
	GoToIfNe _cv_str4_6
	NPCMsg msg_0454_T02GYM0101_cv_leader_repeatOffer_6
	Return
_cv_str4_6:
	CompareVarToValue 0x401F, 8
	GoToIfNe _cv_str4_7
	NPCMsg msg_0454_T02GYM0101_cv_leader_repeatOffer_7
	Return
_cv_str4_7:
	CompareVarToValue 0x401F, 9
	GoToIfNe _cv_str4_8
	NPCMsg msg_0454_T02GYM0101_cv_mentor_first_rock
	Return
_cv_str4_8:
	CompareVarToValue 0x401F, 10
	GoToIfNe _cv_str4_9
	NPCMsg msg_0454_T02GYM0101_cv_mentor_first_normal
	Return
_cv_str4_9:
	CompareVarToValue 0x401F, 11
	GoToIfNe _cv_str4_10
	NPCMsg msg_0454_T02GYM0101_cv_mentor_first_water
	Return
_cv_str4_10:
	CompareVarToValue 0x401F, 12
	GoToIfNe _cv_str4_11
	NPCMsg msg_0454_T02GYM0101_cv_mentor_first_electric
	Return
_cv_str4_11:
	CompareVarToValue 0x401F, 13
	GoToIfNe _cv_str4_12
	NPCMsg msg_0454_T02GYM0101_cv_mentor_first_steel
	Return
_cv_str4_12:
	CompareVarToValue 0x401F, 14
	GoToIfNe _cv_str4_13
	NPCMsg msg_0454_T02GYM0101_cv_mentor_first_grass
	Return
_cv_str4_13:
	CompareVarToValue 0x401F, 15
	GoToIfNe _cv_str4_14
	NPCMsg msg_0454_T02GYM0101_cv_mentor_first_poison
	Return
_cv_str4_14:
	CompareVarToValue 0x401F, 16
	GoToIfNe _cv_str4_15
	NPCMsg msg_0454_T02GYM0101_cv_mentor_first_bug
	Return
_cv_str4_15:
	CompareVarToValue 0x401F, 17
	GoToIfNe _cv_str4_16
	NPCMsg msg_0454_T02GYM0101_cv_mentor_first_psychic
	Return
_cv_str4_16:
	CompareVarToValue 0x401F, 18
	GoToIfNe _cv_str4_17
	NPCMsg msg_0454_T02GYM0101_cv_mentor_first_fairy
	Return
_cv_str4_17:
	CompareVarToValue 0x401F, 19
	GoToIfNe _cv_str4_18
	NPCMsg msg_0454_T02GYM0101_cv_mentor_first_fire
	Return
_cv_str4_18:
	CompareVarToValue 0x401F, 20
	GoToIfNe _cv_str4_19
	NPCMsg msg_0454_T02GYM0101_cv_mentor_first_ground
	Return
_cv_str4_19:
	CompareVarToValue 0x401F, 21
	GoToIfNe _cv_str4_20
	NPCMsg msg_0454_T02GYM0101_cv_mentor_first_dark
	Return
_cv_str4_20:
	CompareVarToValue 0x401F, 22
	GoToIfNe _cv_str4_21
	NPCMsg msg_0454_T02GYM0101_cv_mentor_first_ice
	Return
_cv_str4_21:
	CompareVarToValue 0x401F, 23
	GoToIfNe _cv_str4_22
	NPCMsg msg_0454_T02GYM0101_cv_mentor_first_fighting
	Return
_cv_str4_22:
	CompareVarToValue 0x401F, 24
	GoToIfNe _cv_str4_23
	NPCMsg msg_0454_T02GYM0101_cv_mentor_first_ghost
	Return
_cv_str4_23:
	CompareVarToValue 0x401F, 25
	GoToIfNe _cv_str4_24
	NPCMsg msg_0454_T02GYM0101_cv_mentor_first_dragon
	Return
_cv_str4_24:
	CompareVarToValue 0x401F, 26
	GoToIfNe _cv_str4_25
	NPCMsg msg_0454_T02GYM0101_cv_mentor_first_flying
	Return
_cv_str4_25:
	CompareVarToValue 0x401F, 27
	GoToIfNe _cv_str4_26
	NPCMsg msg_0454_T02GYM0101_cv_leader_offer_0
	Return
_cv_str4_26:
	CompareVarToValue 0x401F, 28
	GoToIfNe _cv_str4_27
	NPCMsg msg_0454_T02GYM0101_cv_leader_offer_1
	Return
_cv_str4_27:
	CompareVarToValue 0x401F, 29
	GoToIfNe _cv_str4_28
	NPCMsg msg_0454_T02GYM0101_cv_leader_offer_2
	Return
_cv_str4_28:
	CompareVarToValue 0x401F, 30
	GoToIfNe _cv_str4_29
	NPCMsg msg_0454_T02GYM0101_cv_leader_offer_3
	Return
_cv_str4_29:
	CompareVarToValue 0x401F, 31
	GoToIfNe _cv_str4_30
	NPCMsg msg_0454_T02GYM0101_cv_leader_offer_4
	Return
_cv_str4_30:
	CompareVarToValue 0x401F, 32
	GoToIfNe _cv_str4_31
	NPCMsg msg_0454_T02GYM0101_cv_leader_offer_5
	Return
_cv_str4_31:
	CompareVarToValue 0x401F, 33
	GoToIfNe _cv_str4_32
	NPCMsg msg_0454_T02GYM0101_cv_leader_offer_6
	Return
_cv_str4_32:
	CompareVarToValue 0x401F, 34
	GoToIfNe _cv_str4_33
	NPCMsg msg_0454_T02GYM0101_cv_leader_offer_7
	Return
_cv_str4_33:
	CompareVarToValue 0x401F, 35
	GoToIfNe _cv_str4_34
	NPCMsg msg_0454_T02GYM0101_cv_leader_ownGym_0
	Return
_cv_str4_34:
	CompareVarToValue 0x401F, 36
	GoToIfNe _cv_str4_35
	NPCMsg msg_0454_T02GYM0101_cv_leader_ownGym_1
	Return
_cv_str4_35:
	CompareVarToValue 0x401F, 37
	GoToIfNe _cv_str4_36
	NPCMsg msg_0454_T02GYM0101_cv_leader_ownGym_2
	Return
_cv_str4_36:
	CompareVarToValue 0x401F, 38
	GoToIfNe _cv_str4_37
	NPCMsg msg_0454_T02GYM0101_cv_leader_ownGym_3
	Return
_cv_str4_37:
	CompareVarToValue 0x401F, 39
	GoToIfNe _cv_str4_38
	NPCMsg msg_0454_T02GYM0101_cv_leader_ownGym_4
	Return
_cv_str4_38:
	CompareVarToValue 0x401F, 40
	GoToIfNe _cv_str4_39
	NPCMsg msg_0454_T02GYM0101_cv_leader_ownGym_5
	Return
_cv_str4_39:
	CompareVarToValue 0x401F, 41
	GoToIfNe _cv_str4_40
	NPCMsg msg_0454_T02GYM0101_cv_leader_ownGym_6
	Return
_cv_str4_40:
	CompareVarToValue 0x401F, 42
	GoToIfNe _cv_str4_41
	NPCMsg msg_0454_T02GYM0101_cv_leader_ownGym_7
	Return
_cv_str4_41:
	CompareVarToValue 0x401F, 43
	GoToIfNe _cv_str4_42
	NPCMsg msg_0454_T02GYM0101_cv_hold_shift
	Return
_cv_str4_42:
	CompareVarToValue 0x401F, 44
	GoToIfNe _cv_str4_43
	NPCMsg msg_0454_T02GYM0101_cv_leader_observe_0
	Return
_cv_str4_43:
	CompareVarToValue 0x401F, 45
	GoToIfNe _cv_str4_44
	NPCMsg msg_0454_T02GYM0101_cv_leader_observe_1
	Return
_cv_str4_44:
	CompareVarToValue 0x401F, 46
	GoToIfNe _cv_str4_45
	NPCMsg msg_0454_T02GYM0101_cv_leader_observe_2
	Return
_cv_str4_45:
	CompareVarToValue 0x401F, 47
	GoToIfNe _cv_str4_46
	NPCMsg msg_0454_T02GYM0101_cv_leader_observe_3
	Return
_cv_str4_46:
	CompareVarToValue 0x401F, 48
	GoToIfNe _cv_str4_47
	NPCMsg msg_0454_T02GYM0101_cv_leader_observe_4
	Return
_cv_str4_47:
	CompareVarToValue 0x401F, 49
	GoToIfNe _cv_str4_48
	NPCMsg msg_0454_T02GYM0101_cv_leader_observe_5
	Return
_cv_str4_48:
	CompareVarToValue 0x401F, 50
	GoToIfNe _cv_str4_49
	NPCMsg msg_0454_T02GYM0101_cv_leader_observe_6
	Return
_cv_str4_49:
	CompareVarToValue 0x401F, 51
	GoToIfNe _cv_str4_50
	NPCMsg msg_0454_T02GYM0101_cv_leader_observe_7
	Return
_cv_str4_50:
	CompareVarToValue 0x401F, 52
	GoToIfNe _cv_str4_51
	NPCMsg msg_0454_T02GYM0101_cv_leader_approve_0
	Return
_cv_str4_51:
	CompareVarToValue 0x401F, 53
	GoToIfNe _cv_str4_52
	NPCMsg msg_0454_T02GYM0101_cv_mentor_approve_rock
	Return
_cv_str4_52:
	CompareVarToValue 0x401F, 54
	GoToIfNe _cv_str4_53
	NPCMsg msg_0454_T02GYM0101_cv_mentor_approve_normal
	Return
_cv_str4_53:
	CompareVarToValue 0x401F, 55
	GoToIfNe _cv_str4_54
	NPCMsg msg_0454_T02GYM0101_cv_leader_approve_1
	Return
_cv_str4_54:
	CompareVarToValue 0x401F, 56
	GoToIfNe _cv_str4_55
	NPCMsg msg_0454_T02GYM0101_cv_mentor_approve_water
	Return
_cv_str4_55:
	CompareVarToValue 0x401F, 57
	GoToIfNe _cv_str4_56
	NPCMsg msg_0454_T02GYM0101_cv_leader_approve_2
	Return
_cv_str4_56:
	CompareVarToValue 0x401F, 58
	GoToIfNe _cv_str4_57
	NPCMsg msg_0454_T02GYM0101_cv_mentor_approve_electric
	Return
_cv_str4_57:
	CompareVarToValue 0x401F, 59
	GoToIfNe _cv_str4_58
	NPCMsg msg_0454_T02GYM0101_cv_mentor_approve_steel
	Return
_cv_str4_58:
	CompareVarToValue 0x401F, 60
	GoToIfNe _cv_str4_59
	NPCMsg msg_0454_T02GYM0101_cv_leader_approve_3
	Return
_cv_str4_59:
	CompareVarToValue 0x401F, 61
	GoToIfNe _cv_str4_60
	NPCMsg msg_0454_T02GYM0101_cv_mentor_approve_grass
	Return
_cv_str4_60:
	CompareVarToValue 0x401F, 62
	GoToIfNe _cv_str4_61
	NPCMsg msg_0454_T02GYM0101_cv_leader_approve_4
	Return
_cv_str4_61:
	CompareVarToValue 0x401F, 63
	GoToIfNe _cv_str4_62
	NPCMsg msg_0454_T02GYM0101_cv_mentor_approve_poison
	Return
_cv_str4_62:
	CompareVarToValue 0x401F, 64
	GoToIfNe _cv_str4_63
	NPCMsg msg_0454_T02GYM0101_cv_mentor_approve_bug
	Return
_cv_str4_63:
	CompareVarToValue 0x401F, 65
	GoToIfNe _cv_str4_64
	NPCMsg msg_0454_T02GYM0101_cv_leader_approve_5
	Return
_cv_str4_64:
	CompareVarToValue 0x401F, 66
	GoToIfNe _cv_str4_65
	NPCMsg msg_0454_T02GYM0101_cv_mentor_approve_psychic
	Return
_cv_str4_65:
	CompareVarToValue 0x401F, 67
	GoToIfNe _cv_str4_66
	NPCMsg msg_0454_T02GYM0101_cv_mentor_approve_fairy
	Return
_cv_str4_66:
	CompareVarToValue 0x401F, 68
	GoToIfNe _cv_str4_67
	NPCMsg msg_0454_T02GYM0101_cv_leader_approve_6
	Return
_cv_str4_67:
	CompareVarToValue 0x401F, 69
	GoToIfNe _cv_str4_68
	NPCMsg msg_0454_T02GYM0101_cv_mentor_approve_fire
	Return
_cv_str4_68:
	CompareVarToValue 0x401F, 70
	GoToIfNe _cv_str4_69
	NPCMsg msg_0454_T02GYM0101_cv_leader_approve_7
	Return
_cv_str4_69:
	CompareVarToValue 0x401F, 71
	GoToIfNe _cv_str4_70
	NPCMsg msg_0454_T02GYM0101_cv_leader_repeatThanks_0
	Return
_cv_str4_70:
	CompareVarToValue 0x401F, 72
	GoToIfNe _cv_str4_71
	NPCMsg msg_0454_T02GYM0101_cv_leader_repeatThanks_1
	Return
_cv_str4_71:
	CompareVarToValue 0x401F, 73
	GoToIfNe _cv_str4_72
	NPCMsg msg_0454_T02GYM0101_cv_leader_repeatThanks_2
	Return
_cv_str4_72:
	CompareVarToValue 0x401F, 74
	GoToIfNe _cv_str4_73
	NPCMsg msg_0454_T02GYM0101_cv_leader_repeatThanks_3
	Return
_cv_str4_73:
	CompareVarToValue 0x401F, 75
	GoToIfNe _cv_str4_74
	NPCMsg msg_0454_T02GYM0101_cv_leader_repeatThanks_4
	Return
_cv_str4_74:
	CompareVarToValue 0x401F, 76
	GoToIfNe _cv_str4_75
	NPCMsg msg_0454_T02GYM0101_cv_leader_repeatThanks_5
	Return
_cv_str4_75:
	CompareVarToValue 0x401F, 77
	GoToIfNe _cv_str4_76
	NPCMsg msg_0454_T02GYM0101_cv_leader_repeatThanks_6
	Return
_cv_str4_76:
	CompareVarToValue 0x401F, 78
	GoToIfNe _cv_str4_77
	NPCMsg msg_0454_T02GYM0101_cv_leader_repeatThanks_7
	Return
_cv_str4_77:
	Return

_cv_stop:
	NPCMsg msg_0454_T02GYM0101_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_team_not_allowed:
	Call EventScript_GymHack_ShowTeamRuleMessage
	CanvasCloseMsg
	GetPlayerCoords 0x8008, 0x8009
	GetPlayerFacing 0x800A
	Warp MAP_VIRIDIAN_GYM, 0, 0x8008, 0x8009, 0x800A
	ReleaseAll
	End

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
