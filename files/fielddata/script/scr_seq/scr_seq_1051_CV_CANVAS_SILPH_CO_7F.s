#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SILPH_CO_7F.h"
#include "msgdata/msg/msg_0897_CV_CANVAS_SILPH_CO_7F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SilphCo_7F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SilphCo_7F_EventScript_LaprasGuy
	ScrDef SilphCo_7F_EventScript_WorkerF
	ScrDef SilphCo_7F_EventScript_WorkerM1
	ScrDef SilphCo_7F_EventScript_WorkerM2
	ScrDef SilphCo_7F_EventScript_ItemCalcium
	ScrDef SilphCo_7F_EventScript_ItemTM08
	ScrDef BerryField_EventScript_FindSteel
	ScrDef SilphCo_7F_EventScript_Door1
	ScrDef SilphCo_7F_EventScript_Door2
	ScrDef SilphCo_7F_EventScript_Door3
	ScrDef SilphCo_7F_EventScript_FloorSign
	ScrDef SilphCo_7F_EventScript_RivalTriggerTop
	ScrDef SilphCo_7F_EventScript_RivalTriggerBottom
	ScrDef SilphCo_7F_OnLoad
	ScrDef SilphCo_7F_OnTransition
	ScrDef SilphCo_7F_Frlg_cv_Barriers
	ScrDefEnd
	
SilphCo_7F_EventScript_LaprasGuy:
	LockAll
	FacePlayer
	GoToIfSet 0x21AB, SilphCo_7F_EventScript_AlreadyGotLapras
	NPCMsg msg_0897_CV_CANVAS_SILPH_CO_7F_SilphCo_7F_Text_HaveMonForSavingUs
	WaitButton
	SetVar 0x4001, SPECIES_LAPRAS
	GiveMon SPECIES_LAPRAS, 25, 0, 0, 0, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq SilphCo_7F_EventScript_ReceiveLaprasParty
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq SilphCo_7F_EventScript_ReceiveLaprasPC
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq Common_EventScript_NoMoreRoomForPokemon
	CloseMsg
	ReleaseAll
	End
	
SilphCo_7F_EventScript_WorkerF:
	LockAll
	FacePlayer
	CompareVarToValue 0x5031, 1
	GoToIfGe SilphCo_7F_EventScript_WorkerFRocketsGone
	NPCMsg msg_0897_CV_CANVAS_SILPH_CO_7F_SilphCo_7F_Text_ReallyDangerousHere
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SilphCo_7F_EventScript_WorkerM1:
	LockAll
	FacePlayer
	CompareVarToValue 0x5031, 1
	GoToIfGe SilphCo_7F_EventScript_WorkerM1RocketsGone
	NPCMsg msg_0897_CV_CANVAS_SILPH_CO_7F_SilphCo_7F_Text_RocketsAfterMasterBall
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SilphCo_7F_EventScript_WorkerM2:
	LockAll
	FacePlayer
	CompareVarToValue 0x5031, 1
	GoToIfGe SilphCo_7F_EventScript_WorkerM2RocketsGone
	NPCMsg msg_0897_CV_CANVAS_SILPH_CO_7F_SilphCo_7F_Text_BadIfTeamRocketTookOver
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SilphCo_7F_EventScript_ItemCalcium:
	SetVar 0x8004, ITEM_CALCIUM
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
SilphCo_7F_EventScript_ItemTM08:
	SetVar 0x8004, ITEM_TM08
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
BerryField_EventScript_FindSteel:
	SetVar 0x8004, ITEM_BABIRI_BERRY
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
SilphCo_7F_EventScript_Door1:
	LockAll
	SetVar 0x4001, 11
	SetVar 0x8004, 0x21AC
	GoToIfSet 0x21AC, EventScript_DoorUnlocked
	GoTo EventScript_TryUnlockDoor
	End
	
SilphCo_7F_EventScript_Door2:
	LockAll
	SetVar 0x4001, 12
	SetVar 0x8004, 0x21AD
	GoToIfSet 0x21AD, EventScript_DoorUnlocked
	GoTo EventScript_TryUnlockDoor
	End
	
SilphCo_7F_EventScript_Door3:
	LockAll
	SetVar 0x4001, 13
	SetVar 0x8004, 0x21AE
	GoToIfSet 0x21AE, EventScript_DoorUnlocked
	GoTo EventScript_TryUnlockDoor
	End
	
SilphCo_7F_EventScript_FloorSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0897_CV_CANVAS_SILPH_CO_7F_SilphCo_7F_Text_FloorSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SilphCo_7F_EventScript_RivalTriggerTop:
	LockAll
	SetVar 0x4001, 0
	GoTo SilphCo_7F_EventScript_RivalScene
	End
	
SilphCo_7F_EventScript_RivalTriggerBottom:
	LockAll
	SetVar 0x4001, 1
	GoTo SilphCo_7F_EventScript_RivalScene
	End
	
SilphCo_7F_OnLoad:
	CallIfUnset 0x21AC, EventScript_Close7FDoor1
	CallIfUnset 0x21AD, EventScript_Close7FDoor2
	CallIfUnset 0x21AE, EventScript_Close7FDoor3
	End
	
SilphCo_7F_OnTransition:
	CompareVarToValue 0x5031, 1
	CallIfGe SilphCo_7F_EventScript_SetObjRocketsGone
	End
	
SilphCo_7F_Frlg_cv_Barriers:
	SetVar 0x5044, 1
	SetFlag 0x2290
	SetFlag 0x2291
	SetFlag 0x2292
	SetFlag 0x2293
	SetFlag 0x2294
	SetFlag 0x2295
	SetFlag 0x2296
	SetFlag 0x2297
	SetFlag 0x2298
	SetFlag 0x2299
	SetFlag 0x229A
	SetFlag 0x229B
	Call SilphCo_7F_OnLoad_cv_init
	SetVar 0x5044, 0
	GoTo SilphCo_7F_OnTransition
	
SilphCo_7F_EventScript_AlreadyGotLapras:
	NPCMsg msg_0897_CV_CANVAS_SILPH_CO_7F_SilphCo_7F_Text_RocketBossWentToBoardroom
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SilphCo_7F_EventScript_ReceiveLaprasParty:
	PlayFanfare SEQ_ME_LVUP
	BufferPlayersName 6
	NPCMsg msg_0897_CV_CANVAS_SILPH_CO_7F_SilphCo_7F_Text_ObtainedLaprasFromEmployee
	WaitFanfare
	BufferSpeciesName 0, SPECIES_LAPRAS, 0, 0
	NPCMsg msg_0897_CV_CANVAS_SILPH_CO_7F_gText_NicknameThisPokemon
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq SilphCo_7F_EventScript_EndReceiveLapras
	Call Common_EventScript_GetGiftMonPartySlot
	Call Common_EventScript_NameReceivedPartyMon
	GoTo SilphCo_7F_EventScript_EndReceiveLapras
	CloseMsg
	End
	
SilphCo_7F_EventScript_ReceiveLaprasPC:
	PlayFanfare SEQ_ME_LVUP
	BufferPlayersName 6
	NPCMsg msg_0897_CV_CANVAS_SILPH_CO_7F_SilphCo_7F_Text_ObtainedLaprasFromEmployee
	WaitFanfare
	BufferSpeciesName 0, SPECIES_LAPRAS, 0, 0
	NPCMsg msg_0897_CV_CANVAS_SILPH_CO_7F_gText_NicknameThisPokemon
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_3
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_4
_cv_yes_3:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq SilphCo_7F_EventScript_LaprasTransferredToPC
	Call Common_EventScript_NameReceivedBoxMon
	GoTo SilphCo_7F_EventScript_LaprasTransferredToPC
	CloseMsg
	End
	
Common_EventScript_NoMoreRoomForPokemon:
	NPCMsg msg_0897_CV_CANVAS_SILPH_CO_7F_gText_NoMoreRoomForPokemon
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SilphCo_7F_EventScript_WorkerFRocketsGone:
	NPCMsg msg_0897_CV_CANVAS_SILPH_CO_7F_SilphCo_7F_Text_ThankYouSoMuch
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SilphCo_7F_EventScript_WorkerM1RocketsGone:
	NPCMsg msg_0897_CV_CANVAS_SILPH_CO_7F_SilphCo_7F_Text_CanceledMasterBallProject
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SilphCo_7F_EventScript_WorkerM2RocketsGone:
	NPCMsg msg_0897_CV_CANVAS_SILPH_CO_7F_SilphCo_7F_Text_WowYouChasedOffTeamRocket
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_DoorUnlocked:
	NPCMsg msg_0897_CV_CANVAS_SILPH_CO_7F_Text_TheDoorIsOpen
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_TryUnlockDoor:
	GoToIfSet 0x2198, EventScript_OpenDoor
	GoTo EventScript_NeedCardKey
	End
	
SilphCo_7F_EventScript_RivalScene:
	PlayBGM SEQ_GS_E_RIVAL1
	ApplyMovement 1, Common_Movement_ExclamationMark
	WaitMovement
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterDown
	ApplyMovement 1, Common_Movement_Delay48
	WaitMovement
	BufferPlayersName 6
	BufferRivalsName 7
	NPCMsg msg_0897_CV_CANVAS_SILPH_CO_7F_SilphCo_7F_Text_RivalWhatKeptYou
	WaitButton
	CompareVarToValue 0x4001, 0
	CallIfEq SilphCo_7F_EventScript_RivalApproachTop
	CompareVarToValue 0x4001, 1
	CallIfEq SilphCo_7F_EventScript_RivalApproachBottom
	BufferRivalsName 7
	NPCMsg msg_0897_CV_CANVAS_SILPH_CO_7F_SilphCo_7F_Text_RivalIntro
	WaitButton
	SetVar VAR_SPECIAL_LAST_TALKED, 1
	CompareVarToValue 0x5018, 2
	CallIfEq SilphCo_7F_EventScript_RivalSquirtle
	CompareVarToValue 0x5018, 1
	CallIfEq SilphCo_7F_EventScript_RivalBulbasaur
	CompareVarToValue 0x5018, 0
	CallIfEq SilphCo_7F_EventScript_RivalCharmander
	BufferPlayersName 6
	NPCMsg msg_0897_CV_CANVAS_SILPH_CO_7F_SilphCo_7F_Text_RivalPostBattle
	WaitButton
	CloseMsg
	PlayBGM SEQ_GS_E_RIVAL2
	CompareVarToValue 0x4001, 0
	CallIfEq SilphCo_7F_EventScript_RivalExitTop
	CompareVarToValue 0x4001, 1
	CallIfEq SilphCo_7F_EventScript_RivalExitBottom
	PlaySE SEQ_SE_DP_SELECT
	ResetBGM
	HidePerson 1
	SetFlag 0x21AF
	WaitSE SEQ_SE_DP_SELECT
	SetVar 0x503F, 1
	ReleaseAll
	End
	
EventScript_Close7FDoor1:
	GoToIfUnset 0x2292, _cv_bar_5
	ClearFlag 0x2292
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_5
	ShowPerson 202
_cv_bar_5:
	GoToIfUnset 0x2293, _cv_bar_6
	ClearFlag 0x2293
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_6
	ShowPerson 203
_cv_bar_6:
	GoToIfUnset 0x2296, _cv_bar_7
	ClearFlag 0x2296
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_7
	ShowPerson 206
_cv_bar_7:
	GoToIfUnset 0x2297, _cv_bar_8
	ClearFlag 0x2297
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_8
	ShowPerson 207
_cv_bar_8:
	// (the GBA redraws a square here: 12, 10, METATILE_SilphCo_Floor_ShadeFull, 0)
	Return
	
EventScript_Close7FDoor2:
	GoToIfUnset 0x2290, _cv_bar_9
	ClearFlag 0x2290
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_9
	ShowPerson 200
_cv_bar_9:
	GoToIfUnset 0x2291, _cv_bar_10
	ClearFlag 0x2291
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_10
	ShowPerson 201
_cv_bar_10:
	GoToIfUnset 0x2294, _cv_bar_11
	ClearFlag 0x2294
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_11
	ShowPerson 204
_cv_bar_11:
	GoToIfUnset 0x2295, _cv_bar_12
	ClearFlag 0x2295
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_12
	ShowPerson 205
_cv_bar_12:
	// (the GBA redraws a square here: 25, 9, METATILE_SilphCo_Floor_ShadeFull, 0)
	Return
	
EventScript_Close7FDoor3:
	GoToIfUnset 0x2298, _cv_bar_13
	ClearFlag 0x2298
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_13
	ShowPerson 208
_cv_bar_13:
	GoToIfUnset 0x2299, _cv_bar_14
	ClearFlag 0x2299
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_14
	ShowPerson 209
_cv_bar_14:
	GoToIfUnset 0x229A, _cv_bar_15
	ClearFlag 0x229A
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_15
	ShowPerson 210
_cv_bar_15:
	GoToIfUnset 0x229B, _cv_bar_16
	ClearFlag 0x229B
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_16
	ShowPerson 211
_cv_bar_16:
	// (the GBA redraws a square here: 26, 15, METATILE_SilphCo_Floor_ShadeFull, 0)
	Return
	
SilphCo_7F_EventScript_SetObjRocketsGone:
	SetObjectMovementType 8, 14
	SetObjectFacing 8, 0
	Return
	
SilphCo_7F_OnLoad_cv_init:
	CallIfUnset 0x21AC, EventScript_Close7FDoor1
	CallIfUnset 0x21AD, EventScript_Close7FDoor2
	CallIfUnset 0x21AE, EventScript_Close7FDoor3
	Return
	
SilphCo_7F_EventScript_EndReceiveLapras:
	NPCMsg msg_0897_CV_CANVAS_SILPH_CO_7F_SilphCo_7F_Text_ExplainLapras
	WaitButton
	SetFlag 0x21AB
	CloseMsg
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
	
SilphCo_7F_EventScript_LaprasTransferredToPC:
	Call Common_EventScript_TransferredToPC
	GoTo SilphCo_7F_EventScript_EndReceiveLapras
	End
	
Common_EventScript_NameReceivedBoxMon:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	SetVar 0x8004, 0
	NicknameInput 0x8004, VAR_SPECIAL_RESULT
	LockAll
	FacePlayer
	Return
	
EventScript_OpenDoor:
	PlayFanfare SEQ_ME_LVUP
	NPCMsg msg_0897_CV_CANVAS_SILPH_CO_7F_Text_CardKeyOpenedDoor
	WaitButton
	WaitFanfare
	CompareVarToValue 0x4001, 1
	CallIfEq EventScript_Open2FDoor1
	CompareVarToValue 0x4001, 2
	CallIfEq EventScript_Open2FDoor2
	CompareVarToValue 0x4001, 3
	CallIfEq EventScript_Open3FDoor1
	CompareVarToValue 0x4001, 4
	CallIfEq EventScript_Open3FDoor2
	CompareVarToValue 0x4001, 5
	CallIfEq EventScript_Open4FDoor1
	CompareVarToValue 0x4001, 6
	CallIfEq EventScript_Open4FDoor2
	CompareVarToValue 0x4001, 7
	CallIfEq EventScript_Open5FDoor1
	CompareVarToValue 0x4001, 8
	CallIfEq EventScript_Open5FDoor2
	CompareVarToValue 0x4001, 9
	CallIfEq EventScript_Open5FDoor3
	CompareVarToValue 0x4001, 10
	CallIfEq EventScript_Open6FDoor
	CompareVarToValue 0x4001, 11
	CallIfEq EventScript_Open7FDoor1
	CompareVarToValue 0x4001, 12
	CallIfEq EventScript_Open7FDoor2
	CompareVarToValue 0x4001, 13
	CallIfEq EventScript_Open7FDoor3
	CompareVarToValue 0x4001, 14
	CallIfEq EventScript_Open8FDoor
	CompareVarToValue 0x4001, 15
	CallIfEq EventScript_Open9FDoor1
	CompareVarToValue 0x4001, 16
	CallIfEq EventScript_Open9FDoor2
	CompareVarToValue 0x4001, 17
	CallIfEq EventScript_Open9FDoor3
	CompareVarToValue 0x4001, 18
	CallIfEq EventScript_Open9FDoor4
	CompareVarToValue 0x4001, 19
	CallIfEq EventScript_Open10FDoor
	CompareVarToValue 0x4001, 20
	CallIfEq EventScript_Open11FDoor
	WaitSE SEQ_SE_DP_SELECT
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	SetFlagVar 0x8004
	CloseMsg
	ReleaseAll
	End
	
EventScript_NeedCardKey:
	NPCMsg msg_0897_CV_CANVAS_SILPH_CO_7F_Text_ItNeedsCardKey
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SilphCo_7F_EventScript_RivalApproachTop:
	CloseMsg
	ApplyMovement 1, SilphCo_7F_Movement_RivalApproachTop
	WaitMovement
	Return
	
SilphCo_7F_EventScript_RivalApproachBottom:
	Return
	
SilphCo_7F_EventScript_RivalSquirtle:
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_18
	TrainerBattle 802, 0, 0, 0
	GoTo _cv_battle_17
_cv_next_18:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_19
	TrainerBattle 806, 0, 0, 0
	GoTo _cv_battle_17
_cv_next_19:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_20
	TrainerBattle 800, 0, 0, 0
	GoTo _cv_battle_17
_cv_next_20:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_21
	TrainerBattle 798, 0, 0, 0
	GoTo _cv_battle_17
_cv_next_21:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_22
	TrainerBattle 808, 0, 0, 0
	GoTo _cv_battle_17
_cv_next_22:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_23
	TrainerBattle 803, 0, 0, 0
	GoTo _cv_battle_17
_cv_next_23:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_24
	TrainerBattle 805, 0, 0, 0
	GoTo _cv_battle_17
_cv_next_24:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_25
	TrainerBattle 807, 0, 0, 0
	GoTo _cv_battle_17
_cv_next_25:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_26
	TrainerBattle 801, 0, 0, 0
	GoTo _cv_battle_17
_cv_next_26:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_27
	TrainerBattle 809, 0, 0, 0
	GoTo _cv_battle_17
_cv_next_27:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_28
	TrainerBattle 804, 0, 0, 0
	GoTo _cv_battle_17
_cv_next_28:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_29
	TrainerBattle 799, 0, 0, 0
	GoTo _cv_battle_17
_cv_next_29:
	TrainerBattle 798, 0, 0, 0
_cv_battle_17:
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_30
	WhiteOut
	End
_cv_won_30:
	SetFlag 0x21B0
	Return
	
SilphCo_7F_EventScript_RivalBulbasaur:
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_32
	TrainerBattle 802, 0, 0, 0
	GoTo _cv_battle_31
_cv_next_32:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_33
	TrainerBattle 806, 0, 0, 0
	GoTo _cv_battle_31
_cv_next_33:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_34
	TrainerBattle 800, 0, 0, 0
	GoTo _cv_battle_31
_cv_next_34:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_35
	TrainerBattle 798, 0, 0, 0
	GoTo _cv_battle_31
_cv_next_35:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_36
	TrainerBattle 808, 0, 0, 0
	GoTo _cv_battle_31
_cv_next_36:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_37
	TrainerBattle 803, 0, 0, 0
	GoTo _cv_battle_31
_cv_next_37:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_38
	TrainerBattle 805, 0, 0, 0
	GoTo _cv_battle_31
_cv_next_38:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_39
	TrainerBattle 807, 0, 0, 0
	GoTo _cv_battle_31
_cv_next_39:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_40
	TrainerBattle 801, 0, 0, 0
	GoTo _cv_battle_31
_cv_next_40:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_41
	TrainerBattle 809, 0, 0, 0
	GoTo _cv_battle_31
_cv_next_41:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_42
	TrainerBattle 804, 0, 0, 0
	GoTo _cv_battle_31
_cv_next_42:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_43
	TrainerBattle 799, 0, 0, 0
	GoTo _cv_battle_31
_cv_next_43:
	TrainerBattle 798, 0, 0, 0
_cv_battle_31:
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_44
	WhiteOut
	End
_cv_won_44:
	SetFlag 0x21B1
	Return
	
SilphCo_7F_EventScript_RivalCharmander:
	CompareVarToValue 0x501A, 17
	GoToIfNe _cv_next_46
	TrainerBattle 802, 0, 0, 0
	GoTo _cv_battle_45
_cv_next_46:
	CompareVarToValue 0x501A, 13
	GoToIfNe _cv_next_47
	TrainerBattle 806, 0, 0, 0
	GoTo _cv_battle_45
_cv_next_47:
	CompareVarToValue 0x501A, 1
	GoToIfNe _cv_next_48
	TrainerBattle 800, 0, 0, 0
	GoTo _cv_battle_45
_cv_next_48:
	CompareVarToValue 0x501A, 10
	GoToIfNe _cv_next_49
	TrainerBattle 798, 0, 0, 0
	GoTo _cv_battle_45
_cv_next_49:
	CompareVarToValue 0x501A, 12
	GoToIfNe _cv_next_50
	TrainerBattle 808, 0, 0, 0
	GoTo _cv_battle_45
_cv_next_50:
	CompareVarToValue 0x501A, 4
	GoToIfNe _cv_next_51
	TrainerBattle 803, 0, 0, 0
	GoTo _cv_battle_45
_cv_next_51:
	CompareVarToValue 0x501A, 15
	GoToIfNe _cv_next_52
	TrainerBattle 805, 0, 0, 0
	GoTo _cv_battle_45
_cv_next_52:
	CompareVarToValue 0x501A, 3
	GoToIfNe _cv_next_53
	TrainerBattle 807, 0, 0, 0
	GoTo _cv_battle_45
_cv_next_53:
	CompareVarToValue 0x501A, 14
	GoToIfNe _cv_next_54
	TrainerBattle 801, 0, 0, 0
	GoTo _cv_battle_45
_cv_next_54:
	CompareVarToValue 0x501A, 5
	GoToIfNe _cv_next_55
	TrainerBattle 809, 0, 0, 0
	GoTo _cv_battle_45
_cv_next_55:
	CompareVarToValue 0x501A, 8
	GoToIfNe _cv_next_56
	TrainerBattle 804, 0, 0, 0
	GoTo _cv_battle_45
_cv_next_56:
	CompareVarToValue 0x501A, 11
	GoToIfNe _cv_next_57
	TrainerBattle 799, 0, 0, 0
	GoTo _cv_battle_45
_cv_next_57:
	TrainerBattle 798, 0, 0, 0
_cv_battle_45:
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_58
	WhiteOut
	End
_cv_won_58:
	SetFlag 0x21B2
	Return
	
SilphCo_7F_EventScript_RivalExitTop:
	ApplyMovement 1, SilphCo_7F_Movement_RivalExitTop
	WaitMovement
	Return
	
SilphCo_7F_EventScript_RivalExitBottom:
	ApplyMovement 1, SilphCo_7F_Movement_RivalExitBottom
	WaitMovement
	Return
	
Common_EventScript_TransferredToPC:
	// TODO(gba) bufferboxname STR_VAR_1, VAR_PC_BOX_TO_SEND_MON
	GoTo _cv_stop
	BufferSpeciesName 1, 0x5024, 0, 0
	CallIfUnset 0x20D0, EventScript_TransferredSomeonesPC
	CallIfSet 0x20D0, EventScript_TransferredLanettesPC
	Return
	
EventScript_Open2FDoor1:
	// (the GBA redraws a square here: 5, 8, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 6, 8, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 5, 9, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 6, 9, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 6, 10, METATILE_SilphCo_Floor, 0)
	Return
	
EventScript_Open2FDoor2:
	// (the GBA redraws a square here: 5, 15, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 6, 15, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 5, 16, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 6, 16, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 6, 17, METATILE_SilphCo_Floor, 0)
	Return
	
EventScript_Open3FDoor1:
	// (the GBA redraws a square here: 9, 11, METATILE_SilphCo_Wall_LeftEdge, 1)
	// (the GBA redraws a square here: 10, 11, METATILE_SilphCo_Wall_RightEdge, 1)
	// (the GBA redraws a square here: 9, 12, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 10, 12, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 9, 13, METATILE_SilphCo_Floor_WallLeftCorner, 0)
	// (the GBA redraws a square here: 10, 13, METATILE_SilphCo_Floor_WallRightCorner, 0)
	Return
	
EventScript_Open3FDoor2:
	// (the GBA redraws a square here: 20, 11, METATILE_SilphCo_Wall_LeftEdge, 1)
	// (the GBA redraws a square here: 21, 11, METATILE_SilphCo_Wall_RightEdge, 1)
	// (the GBA redraws a square here: 20, 12, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 21, 12, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 20, 13, METATILE_SilphCo_Floor_WallLeftCorner, 0)
	// (the GBA redraws a square here: 21, 13, METATILE_SilphCo_Floor_WallRightCorner, 0)
	Return
	
EventScript_Open4FDoor1:
	// (the GBA redraws a square here: 3, 16, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 4, 16, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 3, 17, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 4, 17, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 4, 18, METATILE_SilphCo_Floor, 0)
	Return
	
EventScript_Open4FDoor2:
	// (the GBA redraws a square here: 14, 11, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 15, 11, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 14, 12, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 15, 12, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 15, 13, METATILE_SilphCo_Floor, 0)
	Return
	
EventScript_Open5FDoor1:
	// (the GBA redraws a square here: 7, 8, METATILE_SilphCo_Wall_LeftEdge, 1)
	// (the GBA redraws a square here: 8, 8, METATILE_SilphCo_Wall_RightEdge, 1)
	// (the GBA redraws a square here: 7, 9, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 8, 9, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 7, 10, METATILE_SilphCo_Floor_WallLeftCorner, 0)
	// (the GBA redraws a square here: 8, 10, METATILE_SilphCo_Floor_WallRightCorner, 0)
	Return
	
EventScript_Open5FDoor2:
	// (the GBA redraws a square here: 7, 17, METATILE_SilphCo_Wall_LeftEdge, 1)
	// (the GBA redraws a square here: 8, 17, METATILE_SilphCo_Wall_RightEdge, 1)
	// (the GBA redraws a square here: 7, 18, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 8, 18, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 7, 19, METATILE_SilphCo_Floor_WallLeftCorner, 0)
	// (the GBA redraws a square here: 8, 19, METATILE_SilphCo_Floor_WallRightCorner, 0)
	Return
	
EventScript_Open5FDoor3:
	// (the GBA redraws a square here: 18, 12, METATILE_SilphCo_Wall_LeftEdge, 1)
	// (the GBA redraws a square here: 19, 12, METATILE_SilphCo_Wall_RightEdge, 1)
	// (the GBA redraws a square here: 18, 13, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 19, 13, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 18, 14, METATILE_SilphCo_Floor_WallLeftCorner, 0)
	// (the GBA redraws a square here: 19, 14, METATILE_SilphCo_Floor_WallRightCorner, 0)
	Return
	
EventScript_Open6FDoor:
	// (the GBA redraws a square here: 5, 14, METATILE_SilphCo_Wall_LeftEdge, 1)
	// (the GBA redraws a square here: 6, 14, METATILE_SilphCo_Wall_RightEdge, 1)
	// (the GBA redraws a square here: 5, 15, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 6, 15, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 5, 16, METATILE_SilphCo_Floor_WallLeftCorner, 0)
	// (the GBA redraws a square here: 6, 16, METATILE_SilphCo_Floor_WallRightCorner, 0)
	Return
	
EventScript_Open7FDoor1:
	GoToIfSet 0x2292, _cv_bar_59
	SetFlag 0x2292
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_59
	HidePerson 202
_cv_bar_59:
	GoToIfSet 0x2293, _cv_bar_60
	SetFlag 0x2293
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_60
	HidePerson 203
_cv_bar_60:
	GoToIfSet 0x2296, _cv_bar_61
	SetFlag 0x2296
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_61
	HidePerson 206
_cv_bar_61:
	GoToIfSet 0x2297, _cv_bar_62
	SetFlag 0x2297
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_62
	HidePerson 207
_cv_bar_62:
	// (the GBA redraws a square here: 12, 10, METATILE_SilphCo_Floor, 0)
	Return
	
EventScript_Open7FDoor2:
	GoToIfSet 0x2290, _cv_bar_63
	SetFlag 0x2290
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_63
	HidePerson 200
_cv_bar_63:
	GoToIfSet 0x2291, _cv_bar_64
	SetFlag 0x2291
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_64
	HidePerson 201
_cv_bar_64:
	GoToIfSet 0x2294, _cv_bar_65
	SetFlag 0x2294
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_65
	HidePerson 204
_cv_bar_65:
	GoToIfSet 0x2295, _cv_bar_66
	SetFlag 0x2295
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_66
	HidePerson 205
_cv_bar_66:
	// (the GBA redraws a square here: 25, 9, METATILE_SilphCo_Floor, 0)
	Return
	
EventScript_Open7FDoor3:
	GoToIfSet 0x2298, _cv_bar_67
	SetFlag 0x2298
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_67
	HidePerson 208
_cv_bar_67:
	GoToIfSet 0x2299, _cv_bar_68
	SetFlag 0x2299
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_68
	HidePerson 209
_cv_bar_68:
	GoToIfSet 0x229A, _cv_bar_69
	SetFlag 0x229A
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_69
	HidePerson 210
_cv_bar_69:
	GoToIfSet 0x229B, _cv_bar_70
	SetFlag 0x229B
	CompareVarToValue 0x5044, 1
	GoToIfEq _cv_bar_70
	HidePerson 211
_cv_bar_70:
	// (the GBA redraws a square here: 26, 15, METATILE_SilphCo_Floor, 0)
	Return
	
EventScript_Open8FDoor:
	// (the GBA redraws a square here: 5, 9, METATILE_SilphCo_Wall_LeftEdge, 1)
	// (the GBA redraws a square here: 6, 9, METATILE_SilphCo_Wall_RightEdge, 1)
	// (the GBA redraws a square here: 5, 10, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 6, 10, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 5, 11, METATILE_SilphCo_Floor_WallLeftCorner, 0)
	// (the GBA redraws a square here: 6, 11, METATILE_SilphCo_Floor_WallRightCorner, 0)
	Return
	
EventScript_Open9FDoor1:
	// (the GBA redraws a square here: 2, 9, METATILE_SilphCo_Wall_LeftEdge, 1)
	// (the GBA redraws a square here: 3, 9, METATILE_SilphCo_Wall_RightEdge, 1)
	// (the GBA redraws a square here: 2, 10, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 3, 10, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 2, 11, METATILE_SilphCo_Floor_WallLeftCorner, 0)
	// (the GBA redraws a square here: 3, 11, METATILE_SilphCo_Floor_WallRightCorner, 0)
	Return
	
EventScript_Open9FDoor2:
	// (the GBA redraws a square here: 12, 15, METATILE_SilphCo_Wall_LeftEdge, 1)
	// (the GBA redraws a square here: 13, 15, METATILE_SilphCo_Wall_RightEdge, 1)
	// (the GBA redraws a square here: 12, 16, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 13, 16, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 12, 17, METATILE_SilphCo_Floor_WallLeftCorner, 0)
	// (the GBA redraws a square here: 13, 17, METATILE_SilphCo_Floor_WallRightCorner, 0)
	Return
	
EventScript_Open9FDoor3:
	// (the GBA redraws a square here: 21, 6, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 22, 6, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 21, 7, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 22, 7, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 22, 8, METATILE_SilphCo_Floor, 0)
	Return
	
EventScript_Open9FDoor4:
	// (the GBA redraws a square here: 21, 12, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 22, 12, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 21, 13, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 22, 13, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 22, 14, METATILE_SilphCo_Floor, 0)
	Return
	
EventScript_Open10FDoor:
	// (the GBA redraws a square here: 12, 11, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 13, 11, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 12, 12, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 13, 12, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 13, 13, METATILE_SilphCo_Floor, 0)
	Return
	
EventScript_Open11FDoor:
	// (the GBA redraws a square here: 5, 16, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 6, 16, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 5, 17, METATILE_SilphCo_Floor_ShadeFull, 0)
	// (the GBA redraws a square here: 6, 17, METATILE_SilphCo_Floor, 0)
	// (the GBA redraws a square here: 6, 18, METATILE_SilphCo_Floor, 0)
	Return
	
EventScript_TransferredSomeonesPC:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar ShouldShowBoxWasFullMessage
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq EventScript_SomeonesPCBoxFull
	NPCMsg msg_0897_CV_CANVAS_SILPH_CO_7F_gText_PkmnTransferredSomeonesPC
	WaitButton
	Return
	
EventScript_TransferredLanettesPC:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar ShouldShowBoxWasFullMessage
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq EventScript_LanettesPCBoxFull
	NPCMsg msg_0897_CV_CANVAS_SILPH_CO_7F_gText_PkmnTransferredLanettesPC
	WaitButton
	Return
	
EventScript_SomeonesPCBoxFull:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar GetPCBoxToSendMon
	GoTo _cv_stop
	// TODO(gba) bufferboxname STR_VAR_3, VAR_RESULT
	GoTo _cv_stop
	NPCMsg msg_0897_CV_CANVAS_SILPH_CO_7F_gText_PkmnTransferredSomeonesPCBoxFull
	WaitButton
	Return
	
EventScript_LanettesPCBoxFull:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar GetPCBoxToSendMon
	GoTo _cv_stop
	// TODO(gba) bufferboxname STR_VAR_3, VAR_RESULT
	GoTo _cv_stop
	NPCMsg msg_0897_CV_CANVAS_SILPH_CO_7F_gText_PkmnTransferredLanettesPCBoxFull
	WaitButton
	Return

_cv_stop:
	NPCMsg msg_0897_CV_CANVAS_SILPH_CO_7F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
Common_Movement_ExclamationMark:
	EmoteExclamationMark
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterDown:
	WalkOnSpotFasterSouth
	EndMovement

	.balign 4, 0
Common_Movement_Delay48:
	Delay16 3
	EndMovement

	.balign 4, 0
SilphCo_7F_Movement_RivalApproachTop:
	WalkNormalNorth
	EndMovement

	.balign 4, 0
SilphCo_7F_Movement_RivalExitTop:
	WalkNormalEast 3
	WalkNormalNorth
	Delay16
	EndMovement

	.balign 4, 0
SilphCo_7F_Movement_RivalExitBottom:
	WalkNormalWest
	WalkNormalNorth 2
	WalkNormalEast 4
	Delay16
	EndMovement
	.balign 4, 0
