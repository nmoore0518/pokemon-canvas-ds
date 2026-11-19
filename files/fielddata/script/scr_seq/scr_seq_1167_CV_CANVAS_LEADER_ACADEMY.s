#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_LEADER_ACADEMY.h"
#include "msgdata/msg/msg_0955_CV_CANVAS_LEADER_ACADEMY.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's LeaderAcademy_Campus#world by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Academy_EventScript_Koji
	ScrDef Academy_EventScript_Maren
	ScrDef Academy_EventScript_Rene
	ScrDef Academy_EventScript_Student1
	ScrDef Market_EventScript_TMsA
	ScrDef Market_EventScript_TMsB
	ScrDef Market_EventScript_TMsC
	ScrDef Market_EventScript_Celadon
	ScrDef Market_EventScript_Held
	ScrDef Market_EventScript_Herbs
	ScrDef Market_EventScript_Nature
	ScrDef Market_EventScript_Training
	ScrDef Academy_EventScript_HallSign
	ScrDef Academy_EventScript_BattleSign
	ScrDef Academy_EventScript_Statue
	ScrDef LeaderAcademy_Campus_OnTransition
	ScrDef _cv_unported_16
	ScrDefEnd
	
Academy_EventScript_Koji:
	LockAll
	FacePlayer
	NPCMsg msg_0955_CV_CANVAS_LEADER_ACADEMY_Academy_Text_KojiHello
	WaitButton
	SetVar 0x8004, 0
	GoTo Academy_EventScript_CandidateBattle
	// TODO(gba) .global Academy_EventScript_Maren
	GoTo _cv_stop
	End
	
Academy_EventScript_Maren:
	LockAll
	FacePlayer
	NPCMsg msg_0955_CV_CANVAS_LEADER_ACADEMY_Academy_Text_MarenHello
	WaitButton
	SetVar 0x8004, 1
	GoTo Academy_EventScript_CandidateBattle
	// TODO(gba) .global Academy_EventScript_Elias
	GoTo _cv_stop
	End
	
Academy_EventScript_Rene:
	LockAll
	FacePlayer
	NPCMsg msg_0955_CV_CANVAS_LEADER_ACADEMY_Academy_Text_ReneHello
	WaitButton
	SetVar 0x8004, 4
	GoTo Academy_EventScript_CandidateBattle
	// TODO(gba) .global Academy_EventScript_Keola
	GoTo _cv_stop
	End
	
Academy_EventScript_Student1:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0955_CV_CANVAS_LEADER_ACADEMY_Academy_Text_Student1
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Market_EventScript_TMsA:
	LockAll
	FacePlayer
	NPCMsg msg_0955_CV_CANVAS_LEADER_ACADEMY_Academy_Text_MarketTMsA
	// TODO(gba) special Market_BeginShop
	GoTo _cv_stop
	CanvasMart 0
	// TODO(gba) special Market_EndShop
	GoTo _cv_stop
	NPCMsg msg_0955_CV_CANVAS_LEADER_ACADEMY_gText_PleaseComeAgain
	WaitButton
	CloseMsg
	ReleaseAll
	End
	// TODO(gba) .global Market_EventScript_TMsB
	GoTo _cv_stop
	End
	
Market_EventScript_TMsB:
	LockAll
	FacePlayer
	NPCMsg msg_0955_CV_CANVAS_LEADER_ACADEMY_Academy_Text_MarketTMsB
	// TODO(gba) special Market_BeginShop
	GoTo _cv_stop
	CanvasMart 0
	// TODO(gba) special Market_EndShop
	GoTo _cv_stop
	NPCMsg msg_0955_CV_CANVAS_LEADER_ACADEMY_gText_PleaseComeAgain
	WaitButton
	CloseMsg
	ReleaseAll
	End
	// TODO(gba) .global Market_EventScript_TMsC
	GoTo _cv_stop
	End
	
Market_EventScript_TMsC:
	LockAll
	FacePlayer
	NPCMsg msg_0955_CV_CANVAS_LEADER_ACADEMY_Academy_Text_MarketTMsC
	// TODO(gba) special Market_BeginShop
	GoTo _cv_stop
	CanvasMart 0
	// TODO(gba) special Market_EndShop
	GoTo _cv_stop
	NPCMsg msg_0955_CV_CANVAS_LEADER_ACADEMY_gText_PleaseComeAgain
	WaitButton
	CloseMsg
	ReleaseAll
	End
	// TODO(gba) .global Market_EventScript_Celadon
	GoTo _cv_stop
	End
	
Market_EventScript_Celadon:
	LockAll
	FacePlayer
	NPCMsg msg_0955_CV_CANVAS_LEADER_ACADEMY_Academy_Text_MarketCeladon
	// TODO(gba) special Market_BeginShop
	GoTo _cv_stop
	CanvasMart 0
	// TODO(gba) special Market_EndShop
	GoTo _cv_stop
	NPCMsg msg_0955_CV_CANVAS_LEADER_ACADEMY_gText_PleaseComeAgain
	WaitButton
	CloseMsg
	ReleaseAll
	End
	// TODO(gba) .global Market_EventScript_Held
	GoTo _cv_stop
	End
	
Market_EventScript_Held:
	LockAll
	FacePlayer
	NPCMsg msg_0955_CV_CANVAS_LEADER_ACADEMY_Academy_Text_MarketHeld
	// TODO(gba) special Market_BeginShop
	GoTo _cv_stop
	CanvasMart 22
	.short ITEM_CHOICE_SCARF
	.short ITEM_CHOICE_BAND
	.short ITEM_CHOICE_SPECS
	.short ITEM_LIFE_ORB
	.short ITEM_FOCUS_SASH
	.short 640
	.short 538
	.short 1880
	.short 1886
	.short 639
	.short 540
	.short 1120
	.short ITEM_LEFTOVERS
	.short ITEM_EXPERT_BELT
	.short 1885
	.short 1882
	.short ITEM_BLACK_SLUDGE
	.short ITEM_LIGHT_CLAY
	.short 541
	.short 542
	.short 547
	.short 1119
	// TODO(gba) special Market_EndShop
	GoTo _cv_stop
	NPCMsg msg_0955_CV_CANVAS_LEADER_ACADEMY_gText_PleaseComeAgain
	WaitButton
	CloseMsg
	ReleaseAll
	End
	// TODO(gba) .global Market_EventScript_Herbs
	GoTo _cv_stop
	End
	
Market_EventScript_Herbs:
	LockAll
	FacePlayer
	NPCMsg msg_0955_CV_CANVAS_LEADER_ACADEMY_Academy_Text_MarketHerbs
	// TODO(gba) special Market_BeginShop
	GoTo _cv_stop
	CanvasMart 11
	.short ITEM_WHITE_HERB
	.short ITEM_MENTAL_HERB
	.short ITEM_POWER_HERB
	.short ITEM_TOXIC_ORB
	.short ITEM_FLAME_ORB
	.short ITEM_DAMP_ROCK
	.short ITEM_HEAT_ROCK
	.short ITEM_SMOOTH_ROCK
	.short ITEM_ICY_ROCK
	.short ITEM_LUM_BERRY
	.short ITEM_SITRUS_BERRY
	// TODO(gba) special Market_EndShop
	GoTo _cv_stop
	NPCMsg msg_0955_CV_CANVAS_LEADER_ACADEMY_gText_PleaseComeAgain
	WaitButton
	CloseMsg
	ReleaseAll
	End
	// TODO(gba) .global Market_EventScript_Nature
	GoTo _cv_stop
	End
	
Market_EventScript_Nature:
	LockAll
	FacePlayer
	NPCMsg msg_0955_CV_CANVAS_LEADER_ACADEMY_Academy_Text_MarketNature
	// TODO(gba) special Market_BeginShop
	GoTo _cv_stop
	CanvasMart 25
	.short 1231
	.short 1232
	.short 1233
	.short 1234
	.short 1235
	.short 1236
	.short 1237
	.short 1238
	.short 1239
	.short 1240
	.short 1241
	.short 1242
	.short 1243
	.short 1244
	.short 1245
	.short 1246
	.short 1247
	.short 1248
	.short 1249
	.short 1250
	.short 1251
	.short 795
	.short 796
	.short 645
	.short 1606
	// TODO(gba) special Market_EndShop
	GoTo _cv_stop
	NPCMsg msg_0955_CV_CANVAS_LEADER_ACADEMY_gText_PleaseComeAgain
	WaitButton
	CloseMsg
	ReleaseAll
	End
	// TODO(gba) .global Market_EventScript_Training
	GoTo _cv_stop
	End
	
Market_EventScript_Training:
	LockAll
	FacePlayer
	NPCMsg msg_0955_CV_CANVAS_LEADER_ACADEMY_Academy_Text_MarketTraining
	// TODO(gba) special Market_BeginShop
	GoTo _cv_stop
	CanvasMart 19
	.short ITEM_HP_UP
	.short ITEM_PROTEIN
	.short ITEM_IRON
	.short ITEM_CALCIUM
	.short ITEM_ZINC
	.short ITEM_CARBOS
	.short ITEM_POWER_WEIGHT
	.short ITEM_POWER_BRACER
	.short ITEM_POWER_BELT
	.short ITEM_POWER_LENS
	.short ITEM_POWER_BAND
	.short ITEM_POWER_ANKLET
	.short ITEM_MACHO_BRACE
	.short ITEM_POMEG_BERRY
	.short ITEM_KELPSY_BERRY
	.short ITEM_QUALOT_BERRY
	.short ITEM_HONDEW_BERRY
	.short ITEM_GREPA_BERRY
	.short ITEM_TAMATO_BERRY
	// TODO(gba) special Market_EndShop
	GoTo _cv_stop
	NPCMsg msg_0955_CV_CANVAS_LEADER_ACADEMY_gText_PleaseComeAgain
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Academy_EventScript_HallSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0955_CV_CANVAS_LEADER_ACADEMY_Academy_Text_HallSign
	WaitButton
	CloseMsg
	ReleaseAll
	// TODO(gba) special TypeTutor_CountOpened
	GoTo _cv_stop
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	BufferPlayersName 6
	NPCMsg msg_0955_CV_CANVAS_LEADER_ACADEMY_Academy_Text_MastersBoard
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Academy_EventScript_BattleSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0955_CV_CANVAS_LEADER_ACADEMY_Academy_Text_BattleSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Academy_EventScript_Statue:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0955_CV_CANVAS_LEADER_ACADEMY_Academy_Text_Statue
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
LeaderAcademy_Campus_OnTransition:
	Call Academy_EventScript_CampusTransition
	End
	
Academy_EventScript_Welcome:
	LockAll
	// TODO(gba) special Academy_PrepareMentor
	GoTo _cv_stop
	ApplyMovement 17, Academy_Movement_WalkDown3
	WaitMovement
	BufferPlayersName 6
	NPCMsg msg_0955_CV_CANVAS_LEADER_ACADEMY_Academy_Text_Welcome1
	WaitButton
	NPCMsg msg_0955_CV_CANVAS_LEADER_ACADEMY_Academy_Text_Welcome2
	WaitButton
	NPCMsg msg_0955_CV_CANVAS_LEADER_ACADEMY_Academy_Text_Welcome3
	WaitButton
	BufferPlayersName 6
	NPCMsg msg_0955_CV_CANVAS_LEADER_ACADEMY_Academy_Text_Welcome4
	WaitButton
	CloseMsg
	ApplyMovement 18, Common_Movement_FaceRight
	ApplyMovement obj_player, Common_Movement_FaceLeft
	WaitMovement
	// TODO(gba) special Academy_PrepareMentor
	GoTo _cv_stop
	BufferPlayersName 6
	NPCMsg msg_0955_CV_CANVAS_LEADER_ACADEMY_Academy_Text_MentorBye
	WaitButton
	CloseMsg
	ApplyMovement 18, Academy_Movement_WalkDown2
	WaitMovement
	HidePerson 18
	ApplyMovement obj_player, Common_Movement_FaceUp
	ApplyMovement 17, Academy_Movement_WalkUp3
	WaitMovement
	HidePerson 17
	SetFlag 0x2103
	SetFlag 0x221A
	SetVar 0x502F, 4
	ReleaseAll
	End
	
Academy_EventScript_CandidateBattle:
	// TODO(gba) special Academy_SetupCandidate
	GoTo _cv_stop
	NPCMsg msg_0955_CV_CANVAS_LEADER_ACADEMY_Academy_Text_CandidateAsk
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Academy_EventScript_CandidateLater
	CopyVar 0x8008, 0x8005
	HealParty
	NPCMsg msg_0955_CV_CANVAS_LEADER_ACADEMY_gGymChallengeIntroText
	WaitButton
	CloseMsg
	Call Academy_EventScript_Battle
	CopyVar 0x8009, VAR_SPECIAL_RESULT
	HealParty
	CompareVarToValue 0x8009, 1
	GoToIfNe Academy_EventScript_CandidateBeatPlayer
	CopyVar 0x8004, 0x8008
	Call Academy_EventScript_EarnBP
	NPCMsg msg_0955_CV_CANVAS_LEADER_ACADEMY_Academy_Text_CandidateHealed
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Academy_EventScript_CampusTransition:
	// TODO(gba) special Market_UpdateCeladonVendor
	SetFlag 0x2103
	SetFlag 0x221A
	CompareVarToValue 0x502F, 3
	GoToIfNe Common_EventScript_NopReturn
	// TODO(gba) special Academy_PrepareMentor
	ClearFlag 0x2103
	ClearFlag 0x221A
	Return
	
Academy_EventScript_CandidateLater:
	NPCMsg msg_0955_CV_CANVAS_LEADER_ACADEMY_Academy_Text_CandidateLater
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Academy_EventScript_Battle:
	ClearTrainerFlag 1442
	SetFlag 0x2036
	CheckTrainerFlag 1442
	GoToIf TRUE, _cv_beaten_3
	TrainerBattle 1442, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_4
	WhiteOut
	End
_cv_won_4:
	SetTrainerFlag 1442
	ReleaseAll
	End
_cv_beaten_3:
	ClearFlag 0x2036
	// TODO(gba) special GymChallenge_EndPractice
	GoTo _cv_stop
	GetStaticEncounterOutcome VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfNe _cv_outcome_5
	SetVar VAR_SPECIAL_RESULT, 7
	GoTo _cv_outcome_6
_cv_outcome_5:
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfNe _cv_outcome_6
	SetVar VAR_SPECIAL_RESULT, 4
_cv_outcome_6:
	Return
	
Academy_EventScript_CandidateBeatPlayer:
	NPCMsg msg_0955_CV_CANVAS_LEADER_ACADEMY_gGymChallengeWinText
	WaitButton
	NPCMsg msg_0955_CV_CANVAS_LEADER_ACADEMY_Academy_Text_CandidateHealed
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Academy_EventScript_EarnBP:
	// TODO(gba) special Academy_AddBP
	GoTo _cv_stop
	PlayFanfare SEQ_ME_LVUP
	BufferPlayersName 6
	NPCMsg msg_0955_CV_CANVAS_LEADER_ACADEMY_Academy_Text_EarnedBP
	WaitFanfare
	WaitButton
	Return
	// TODO(gba) .global Academy_EventScript_Koji
	GoTo _cv_stop
	End
	
Common_EventScript_NopReturn:
	Return

_cv_unported_16:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0955_CV_CANVAS_LEADER_ACADEMY_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0955_CV_CANVAS_LEADER_ACADEMY_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
Academy_Movement_WalkDown3:
	WalkNormalSouth 3
	EndMovement

	.balign 4, 0
Common_Movement_FaceRight:
	FaceEast
	EndMovement

	.balign 4, 0
Common_Movement_FaceLeft:
	FaceWest
	EndMovement

	.balign 4, 0
Academy_Movement_WalkDown2:
	WalkNormalSouth 2
	EndMovement

	.balign 4, 0
Common_Movement_FaceUp:
	FaceNorth
	EndMovement

	.balign 4, 0
Academy_Movement_WalkUp3:
	WalkNormalNorth 3
	EndMovement
	.balign 4, 0
