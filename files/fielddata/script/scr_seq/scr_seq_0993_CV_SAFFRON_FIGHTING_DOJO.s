#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_SAFFRON_FIGHTING_DOJO.h"
#include "msgdata/msg/msg_0868_CV_SAFFRON_FIGHTING_DOJO.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SaffronCity_Dojo_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SaffronCity_Dojo_EventScript_Hitoshi
	ScrDef SaffronCity_Dojo_EventScript_MasterKoichi
	ScrDef SaffronCity_Dojo_EventScript_HitmonleeBall
	ScrDef SaffronCity_Dojo_EventScript_HitmonchanBall
	ScrDef TypeTutor_EventScript_Fighting
	ScrDef SaffronCity_Dojo_EventScript_Statue
	ScrDef SaffronCity_Dojo_EventScript_LeftScroll
	ScrDef SaffronCity_Dojo_EventScript_RightScroll
	ScrDef SaffronCity_Dojo_EventScript_TriggerMasterBattleLeft
	ScrDef SaffronCity_Dojo_EventScript_TriggerMasterBattleRight
	ScrDefEnd
	
SaffronCity_Dojo_EventScript_Hitoshi:
	CheckTrainerFlag 1066
	GoToIf TRUE, _cv_beaten_1
	NPCMsg msg_0868_CV_SAFFRON_FIGHTING_DOJO_SaffronCity_Dojo_Text_HitoshiIntro
	WaitButton
	CloseMsg
	TrainerBattle 1066, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_2
	WhiteOut
	End
_cv_won_2:
	SetTrainerFlag 1066
	GoTo GymCandidate_EventScript_RecruitFighting
_cv_beaten_1:
	SetVar 0x8004, 2
	Call GymCandidate_EventScript_RecruitOffer
	NPCMsg msg_0868_CV_SAFFRON_FIGHTING_DOJO_SaffronCity_Dojo_Text_HitoshiPostBattle
	WaitButton
	CloseMsg
	End
	
SaffronCity_Dojo_EventScript_MasterKoichi:
	CheckTrainerFlag 1062
	GoToIf TRUE, _cv_beaten_3
	NPCMsg msg_0868_CV_SAFFRON_FIGHTING_DOJO_SaffronCity_Dojo_Text_MasterKoichiIntro
	WaitButton
	CloseMsg
	TrainerBattle 1062, 1062, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_4
	WhiteOut
	End
_cv_won_4:
	SetTrainerFlag 1062
	GoTo SaffronCity_Dojo_EventScript_DefeatedMasterKoichi
_cv_beaten_3:
	GoToIfSet 0x213F, SaffronCity_Dojo_EventScript_MasterKoichiAlreadyGotHitmon
	NPCMsg msg_0868_CV_SAFFRON_FIGHTING_DOJO_SaffronCity_Dojo_Text_ChoosePrizedFightingMon
	WaitButton
	CloseMsg
	End
	
SaffronCity_Dojo_EventScript_HitmonleeBall:
	LockAll
	FacePlayer
	GoToIfSet 0x213F, SaffronCity_Dojo_EventScript_AlreadyGotHitmon
	SetVar 0x4001, SPECIES_HITMONLEE
	ApplyMovement 5, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	NPCMsg msg_0868_CV_SAFFRON_FIGHTING_DOJO_SaffronCity_Dojo_Text_YouWantHitmonlee
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_5
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_6
_cv_yes_5:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_6:
	Call EventScript_RestorePrevTextColor
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq SaffronCity_Dojo_EventScript_GiveHitmon
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_Dojo_EventScript_HitmonchanBall:
	LockAll
	FacePlayer
	GoToIfSet 0x213F, SaffronCity_Dojo_EventScript_AlreadyGotHitmon
	SetVar 0x4001, SPECIES_HITMONCHAN
	ApplyMovement 5, Common_Movement_WalkInPlaceFasterUp
	WaitMovement
	NPCMsg msg_0868_CV_SAFFRON_FIGHTING_DOJO_SaffronCity_Dojo_Text_YouWantHitmonchan
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_7
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_8
_cv_yes_7:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_8:
	Call EventScript_RestorePrevTextColor
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq SaffronCity_Dojo_EventScript_GiveHitmon
	CloseMsg
	ReleaseAll
	End
	
TypeTutor_EventScript_Fighting:
	LockAll
	FacePlayer
	SetVar 0x8004, 14
	GoTo TypeTutor_EventScript_Talk
	
SaffronCity_Dojo_EventScript_Statue:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0868_CV_SAFFRON_FIGHTING_DOJO_SaffronCity_Dojo_Text_FightingDojo
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_Dojo_EventScript_LeftScroll:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0868_CV_SAFFRON_FIGHTING_DOJO_SaffronCity_Dojo_Text_EnemiesOnEverySide
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_Dojo_EventScript_RightScroll:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0868_CV_SAFFRON_FIGHTING_DOJO_SaffronCity_Dojo_Text_GoesAroundComesAround
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_Dojo_EventScript_TriggerMasterBattleLeft:
	LockAll
	SetVar 0x5033, 1
	ApplyMovement 5, Common_Movement_WalkInPlaceFasterLeft
	WaitMovement
	ReleaseAll
	End
	
SaffronCity_Dojo_EventScript_TriggerMasterBattleRight:
	LockAll
	SetVar 0x5033, 1
	ApplyMovement 5, Common_Movement_WalkInPlaceFasterRight
	WaitMovement
	ReleaseAll
	End
	
GymCandidate_EventScript_RecruitFighting:
	SetVar 0x8004, 2
	GoTo GymCandidate_EventScript_RecruitAfterBattle
	End
	
GymCandidate_EventScript_RecruitOffer:
	// TODO(gba) special GymCandidate_BufferRecruit
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymCandidate_EventScript_Return
	LockAll
	FacePlayer
	Call _cv_str4
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_9
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_10
_cv_yes_9:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_10:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_RecruitDeclined
	// TODO(gba) special GymCandidate_Recruit
	GoTo _cv_stop
	PlayFanfare SEQ_ME_ITEM
	NPCMsg msg_0868_CV_SAFFRON_FIGHTING_DOJO_GymCandidate_Text_RecruitJoined
	WaitButton
	WaitFanfare
	NPCMsg msg_0868_CV_SAFFRON_FIGHTING_DOJO_GymCandidate_Text_RecruitHowToPlace
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_Dojo_EventScript_DefeatedMasterKoichi:
	SetVar 0x5033, 1
	ReleaseAll
	End
	
SaffronCity_Dojo_EventScript_MasterKoichiAlreadyGotHitmon:
	NPCMsg msg_0868_CV_SAFFRON_FIGHTING_DOJO_SaffronCity_Dojo_Text_StayAndTrainWithUs
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_Dojo_EventScript_AlreadyGotHitmon:
	NPCMsg msg_0868_CV_SAFFRON_FIGHTING_DOJO_SaffronCity_Dojo_Text_BetterNotGetGreedy
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_RestorePrevTextColor:
	CopyVar 0x5015, 0x5016
	Return
	
SaffronCity_Dojo_EventScript_GiveHitmon:
	GiveMon 0x4001, 25, 0, 0, 0, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq SaffronCity_Dojo_EventScript_ReceivedHitmonParty
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq SaffronCity_Dojo_EventScript_ReceivedHitmonPC
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq Common_EventScript_NoMoreRoomForPokemon
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
	
GymCandidate_EventScript_RecruitAfterBattle:
	Call GymCandidate_EventScript_RecruitOffer
	ReleaseAll
	End
	
GymCandidate_EventScript_Return:
	Return
	
GymCandidate_EventScript_RecruitDeclined:
	NPCMsg msg_0868_CV_SAFFRON_FIGHTING_DOJO_GymCandidate_Text_RecruitDeclined
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SaffronCity_Dojo_EventScript_ReceivedHitmonParty:
	HidePerson VAR_SPECIAL_LAST_TALKED
	BufferSpeciesName 0, 0x4001, 0, 0
	PlayFanfare SEQ_ME_LVUP
	BufferPlayersName 6
	NPCMsg msg_0868_CV_SAFFRON_FIGHTING_DOJO_SaffronCity_Dojo_Text_ReceivedMonFromKarateMaster
	WaitFanfare
	SetFlag 0x213F
	NPCMsg msg_0868_CV_SAFFRON_FIGHTING_DOJO_gText_NicknameThisPokemon
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_11
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_12
_cv_yes_11:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_12:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq SaffronCity_Dojo_EventScript_EndGiveMon
	Call Common_EventScript_GetGiftMonPartySlot
	Call Common_EventScript_NameReceivedPartyMon
	GoTo SaffronCity_Dojo_EventScript_EndGiveMon
	CloseMsg
	End
	
SaffronCity_Dojo_EventScript_ReceivedHitmonPC:
	HidePerson VAR_SPECIAL_LAST_TALKED
	BufferSpeciesName 0, 0x4001, 0, 0
	PlayFanfare SEQ_ME_LVUP
	BufferPlayersName 6
	NPCMsg msg_0868_CV_SAFFRON_FIGHTING_DOJO_SaffronCity_Dojo_Text_ReceivedMonFromKarateMaster
	WaitFanfare
	SetFlag 0x213F
	NPCMsg msg_0868_CV_SAFFRON_FIGHTING_DOJO_gText_NicknameThisPokemon
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_13
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_14
_cv_yes_13:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_14:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq SaffronCity_Dojo_EventScript_TransferredHitmonToPC
	Call Common_EventScript_NameReceivedBoxMon
	GoTo SaffronCity_Dojo_EventScript_TransferredHitmonToPC
	CloseMsg
	End
	
Common_EventScript_NoMoreRoomForPokemon:
	NPCMsg msg_0868_CV_SAFFRON_FIGHTING_DOJO_gText_NoMoreRoomForPokemon
	WaitButton
	CloseMsg
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
	NPCMsg msg_0868_CV_SAFFRON_FIGHTING_DOJO_TypeTutor_Text_WhichMove
	// TODO(gba) special TypeTutor_PushMoves
	GoTo _cv_stop
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_16
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_16:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq TypeTutor_EventScript_Bye
	CopyVar 0x8004, 0x8008
	// TODO(gba) special TypeTutor_SelectMove
	GoTo _cv_stop
	NPCMsg msg_0868_CV_SAFFRON_FIGHTING_DOJO_TypeTutor_Text_WhichMon
	WaitButton
	Call EventScript_ChooseMoveTutorMon
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TypeTutor_EventScript_Teach
	NPCMsg msg_0868_CV_SAFFRON_FIGHTING_DOJO_TypeTutor_Text_Taught
	WaitButton
	GoTo TypeTutor_EventScript_Teach
	
SaffronCity_Dojo_EventScript_EndGiveMon:
	ReleaseAll
	End
	
Common_EventScript_GetGiftMonPartySlot:
	// TODO(gba) getpartysize 
	GoTo _cv_stop
	SubVar VAR_SPECIAL_RESULT, 1
	CopyVar 0x8004, VAR_SPECIAL_RESULT
	Return
	
Common_EventScript_NameReceivedPartyMon:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	NicknameInput 0x8004, VAR_SPECIAL_RESULT
	Return
	
SaffronCity_Dojo_EventScript_TransferredHitmonToPC:
	Call Common_EventScript_TransferredToPC
	GoTo SaffronCity_Dojo_EventScript_EndGiveMon
	End
	
Common_EventScript_NameReceivedBoxMon:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	SetVar 0x8004, 0
	NicknameInput 0x8004, VAR_SPECIAL_RESULT
	LockAll
	FacePlayer
	Return
	
TypeTutor_EventScript_Bye:
	NPCMsg msg_0868_CV_SAFFRON_FIGHTING_DOJO_TypeTutor_Text_Bye
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
	
Common_EventScript_TransferredToPC:
	// TODO(gba) bufferboxname STR_VAR_1, VAR_PC_BOX_TO_SEND_MON
	GoTo _cv_stop
	BufferSpeciesName 1, 0x5024, 0, 0
	CallIfUnset 0x20D0, EventScript_TransferredSomeonesPC
	CallIfSet 0x20D0, EventScript_TransferredLanettesPC
	Return
	
EventScript_TransferredSomeonesPC:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar ShouldShowBoxWasFullMessage
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq EventScript_SomeonesPCBoxFull
	NPCMsg msg_0868_CV_SAFFRON_FIGHTING_DOJO_gText_PkmnTransferredSomeonesPC
	WaitButton
	Return
	
EventScript_TransferredLanettesPC:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar ShouldShowBoxWasFullMessage
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq EventScript_LanettesPCBoxFull
	NPCMsg msg_0868_CV_SAFFRON_FIGHTING_DOJO_gText_PkmnTransferredLanettesPC
	WaitButton
	Return
	
EventScript_SomeonesPCBoxFull:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar GetPCBoxToSendMon
	GoTo _cv_stop
	// TODO(gba) bufferboxname STR_VAR_3, VAR_RESULT
	GoTo _cv_stop
	NPCMsg msg_0868_CV_SAFFRON_FIGHTING_DOJO_gText_PkmnTransferredSomeonesPCBoxFull
	WaitButton
	Return
	
EventScript_LanettesPCBoxFull:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar GetPCBoxToSendMon
	GoTo _cv_stop
	// TODO(gba) bufferboxname STR_VAR_3, VAR_RESULT
	GoTo _cv_stop
	NPCMsg msg_0868_CV_SAFFRON_FIGHTING_DOJO_gText_PkmnTransferredLanettesPCBoxFull
	WaitButton
	Return

_cv_str4:
	BufferPlayersName 6
	BufferRivalsName 7
	Return

_cv_stop:
	NPCMsg msg_0868_CV_SAFFRON_FIGHTING_DOJO_cv_unported
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
Common_Movement_WalkInPlaceFasterRight:
	WalkOnSpotFasterEast
	EndMovement
	.balign 4, 0
