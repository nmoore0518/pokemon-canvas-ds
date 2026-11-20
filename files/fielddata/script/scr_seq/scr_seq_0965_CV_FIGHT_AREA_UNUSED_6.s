#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_FIGHT_AREA_UNUSED_6.h"
#include "msgdata/msg/msg_0854_CV_FIGHT_AREA_UNUSED_6.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PalletTown_PlayersHouse_B1F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef PlayersHouse_B1F_EventScript_Synthesizer
	ScrDef PlayersHouse_B1F_EventScript_BallMaker
	ScrDef PlayersHouse_B1F_EventScript_BallChanger
	ScrDef PlayersHouse_B1F_EventScript_Switch
	ScrDef PlayersHouse_B1F_EventScript_Paper1
	ScrDef PlayersHouse_B1F_EventScript_Paper2
	ScrDef PlayersHouse_B1F_EventScript_Paper3
	ScrDef PlayersHouse_B1F_EventScript_Paper4
	ScrDef PlayersHouse_B1F_EventScript_Chalkboard
	ScrDef PlayersHouse_B1F_EventScript_Bookshelf
	ScrDef PlayersHouse_B1F_EventScript_Workbench
	ScrDef PlayersHouse_B1F_EventScript_LabTable
	ScrDef PlayersHouse_B1F_EventScript_Desk
	ScrDef PlayersHouse_B1F_EventScript_TrashCan
	ScrDef PlayersHouse_B1F_EventScript_Crates
	ScrDef PlayersHouse_B1F_OnLoad
	ScrDef PlayersHouse_B1F_OnTransition
	ScrDef DadStory_EventScript_Basement
	ScrDefEnd
	
PlayersHouse_B1F_EventScript_Synthesizer:
	LockAll
	SetVar 0x8006, 0
	GoToIfUnset 0x200D, PlayersHouse_B1F_EventScript_SynthFuel
	SetVar 0x8006, 0
	GoTo PlayersHouse_B1F_EventScript_SynthFuel
	
PlayersHouse_B1F_EventScript_BallMaker:
	LockAll
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_BallMaker
	WaitButton
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_MakerAsk
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PlayersHouse_B1F_EventScript_MachineEnd
	CloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	ScrCmd_566
	GetPartySelection 0x8004
	RestoreOverworld
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	CompareVarToValue 0x8004, 6
	GoToIfGe PlayersHouse_B1F_EventScript_MachineEnd
	// TODO(gba) special BallMaker_CheckMon
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq PlayersHouse_B1F_EventScript_MachineEgg
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfEq PlayersHouse_B1F_EventScript_MakerLowLevel
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfEq PlayersHouse_B1F_EventScript_MakerLastMon
	CompareVarToValue VAR_SPECIAL_RESULT, 6
	GoToIfEq PlayersHouse_B1F_EventScript_MakerBagFull
	GoToIfSet 0x200D, PlayersHouse_B1F_EventScript_MakerNice
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_MakerConfirmEvil
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_3
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_4
_cv_yes_3:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PlayersHouse_B1F_EventScript_MachineEnd
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_MakerGrinding
	Call PlayersHouse_B1F_EventScript_CrankTurn
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_MakerExtracting
	Call PlayersHouse_B1F_EventScript_CrankTurn
	// TODO(gba) special BallMaker_Apply
	GoTo _cv_stop
	PlaySE SEQ_SE_DP_SELECT
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_MakerEliminated
	Wait 30, VAR_SPECIAL_RESULT
	Call PlayersHouse_B1F_EventScript_MakerBallOut
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_MakerCreated
	WaitButton
	Call PlayersHouse_B1F_EventScript_MakerTakeBall
	CloseMsg
	ReleaseAll
	End
	
PlayersHouse_B1F_EventScript_BallChanger:
	LockAll
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_BallChanger
	WaitButton
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_ChangerAsk
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_5
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_6
_cv_yes_5:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_6:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PlayersHouse_B1F_EventScript_MachineEnd
	CloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	ScrCmd_566
	GetPartySelection 0x8004
	RestoreOverworld
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	CompareVarToValue 0x8004, 6
	GoToIfGe PlayersHouse_B1F_EventScript_MachineEnd
	// TODO(gba) special BallChanger_CheckMon
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq PlayersHouse_B1F_EventScript_MachineEgg
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_ChangerPickBall
	WaitButton
	// TODO(gba) special Bag_ChooseBall
	GoTo _cv_stop
	CompareVarToValue 0x5003, ITEM_NONE
	GoToIfEq PlayersHouse_B1F_EventScript_MachineEnd
	// TODO(gba) special BallChanger_CheckBall
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 7
	GoToIfEq PlayersHouse_B1F_EventScript_ChangerSame
	CompareVarToValue VAR_SPECIAL_RESULT, 8
	GoToIfEq PlayersHouse_B1F_EventScript_ChangerBagFull
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_ChangerConfirm
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_7
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_8
_cv_yes_7:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_8:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PlayersHouse_B1F_EventScript_MachineEnd
	CloseMsg
	// TODO(gba) special BallChanger_ShowBalls
	GoTo _cv_stop
	PlaySE SEQ_SE_DP_SELECT
	Wait 24, VAR_SPECIAL_RESULT
	// TODO(gba) special BallChanger_Apply
	GoTo _cv_stop
	PlaySE SEQ_SE_DP_SELECT
	Call PlayersHouse_B1F_EventScript_Frame_changer1
	Wait 20, VAR_SPECIAL_RESULT
	PlaySE SEQ_SE_DP_SELECT
	// TODO(gba) special BallChanger_SwapBalls
	GoTo _cv_stop
	Wait 20, VAR_SPECIAL_RESULT
	Call PlayersHouse_B1F_EventScript_Frame_changer0
	BufferPlayersName 6
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_ChangerDone
	WaitButton
	// TODO(gba) special BallChanger_HideBalls
	GoTo _cv_stop
	CloseMsg
	ReleaseAll
	End
	
PlayersHouse_B1F_EventScript_Switch:
	LockAll
	GoToIfUnset 0x200E, PlayersHouse_B1F_EventScript_SwitchWall
	GoToIfSet 0x200D, PlayersHouse_B1F_EventScript_SwitchToEvil
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_SwitchToNice
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_9
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_10
_cv_yes_9:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_10:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PlayersHouse_B1F_EventScript_MachineEnd
	SetFlag 0x200D
	Call PlayersHouse_B1F_EventScript_Frame_switch_on
	PlaySE SEQ_SE_DP_SELECT
	BufferPlayersName 6
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_SwitchedToNice
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PlayersHouse_B1F_EventScript_Paper1:
	LockAll
	SetVar 0x8004, 0
	// TODO(gba) special ShowNotePage
	GoTo _cv_stop
	ReleaseAll
	End
	
PlayersHouse_B1F_EventScript_Paper2:
	LockAll
	SetVar 0x8004, 1
	// TODO(gba) special ShowNotePage
	GoTo _cv_stop
	ReleaseAll
	End
	
PlayersHouse_B1F_EventScript_Paper3:
	LockAll
	SetVar 0x8004, 2
	// TODO(gba) special ShowNotePage
	GoTo _cv_stop
	ReleaseAll
	End
	
PlayersHouse_B1F_EventScript_Paper4:
	LockAll
	SetVar 0x8004, 3
	// TODO(gba) special ShowNotePage
	GoTo _cv_stop
	ReleaseAll
	End
	
PlayersHouse_B1F_EventScript_Chalkboard:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_Chalkboard
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PlayersHouse_B1F_EventScript_Bookshelf:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_Bookshelf
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PlayersHouse_B1F_EventScript_Workbench:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_Workbench
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PlayersHouse_B1F_EventScript_LabTable:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_LabTable
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PlayersHouse_B1F_EventScript_Desk:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_Desk
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PlayersHouse_B1F_EventScript_TrashCan:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_TrashCan
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PlayersHouse_B1F_EventScript_Crates:
	GoTo Outfits_EventScript_BasementCrates
	
PlayersHouse_B1F_OnLoad:
	CallIfSet 0x200E, PlayersHouse_B1F_EventScript_SetSwitch
	End
	
PlayersHouse_B1F_OnTransition:
	Call DadStory_EventScript_BasementTransition
	End
	
DadStory_EventScript_Basement:
	LockAll
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterLeft
	WaitMovement
	BufferPlayersName 6
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_DadStory_Text_MomBasement
	WaitButton
	CloseMsg
	ApplyMovement 1, DadStory_Movement_MomUpstairs
	WaitMovement
	HidePerson 1
	SetFlag 0x200F
	SetFlag 0x200F
	SetVar 0x5008, 6
	ReleaseAll
	End
	
PlayersHouse_B1F_EventScript_SynthFuel:
	BufferItemName 2, 0x8006
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_Synthesizer
	WaitButton
	HasItem 0x8006, 3, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PlayersHouse_B1F_EventScript_SynthNoFuel
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_SynthAsk
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_11
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_12
_cv_yes_11:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_12:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PlayersHouse_B1F_EventScript_MachineEnd
	CloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	ScrCmd_566
	GetPartySelection 0x8004
	RestoreOverworld
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	CompareVarToValue 0x8004, 6
	GoToIfGe PlayersHouse_B1F_EventScript_MachineEnd
	// TODO(gba) special Synthesizer_CheckMon
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq PlayersHouse_B1F_EventScript_MachineEgg
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfEq PlayersHouse_B1F_EventScript_SynthBlocked
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq PlayersHouse_B1F_EventScript_SynthAlready
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_SynthConfirm
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_13
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_14
_cv_yes_13:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_14:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PlayersHouse_B1F_EventScript_MachineEnd
	TakeItem 0x8006, 3, VAR_SPECIAL_RESULT
	PlaySE SEQ_SE_DP_SELECT
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_SynthRemoving
	Call PlayersHouse_B1F_EventScript_SynthCycle
	Call PlayersHouse_B1F_EventScript_SynthCycle
	PlaySE SEQ_SE_DP_SELECT
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_SynthImplanting
	Call PlayersHouse_B1F_EventScript_SynthCycle
	Call PlayersHouse_B1F_EventScript_SynthCycle
	Call PlayersHouse_B1F_EventScript_Frame_synth0
	// TODO(gba) special Synthesizer_Apply
	GoTo _cv_stop
	GoToIfSet 0x200D, PlayersHouse_B1F_EventScript_SynthDoneNice
	PlaySE SEQ_SE_DP_SELECT
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_SynthDoneEvil
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PlayersHouse_B1F_EventScript_MachineEnd:
	ReleaseAll
	End
	
PlayersHouse_B1F_EventScript_MachineEgg:
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_MachineEgg
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PlayersHouse_B1F_EventScript_MakerLowLevel:
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_MakerLowLevel
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PlayersHouse_B1F_EventScript_MakerLastMon:
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_MakerLastMon
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PlayersHouse_B1F_EventScript_MakerBagFull:
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_MakerBagFull
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PlayersHouse_B1F_EventScript_MakerNice:
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_MakerConfirmNice
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_15
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_16
_cv_yes_15:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_16:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PlayersHouse_B1F_EventScript_MachineEnd
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_MakerScanning
	Call PlayersHouse_B1F_EventScript_CrankTurn
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_MakerSampling
	Call PlayersHouse_B1F_EventScript_CrankTurn
	// TODO(gba) special BallMaker_Apply
	GoTo _cv_stop
	Call PlayersHouse_B1F_EventScript_MakerBallOut
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_MakerCreatedNice
	WaitButton
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_MakerNiceMonBack
	WaitButton
	Call PlayersHouse_B1F_EventScript_MakerTakeBall
	CloseMsg
	ReleaseAll
	End
	
PlayersHouse_B1F_EventScript_CrankTurn:
	PlaySE SEQ_SE_DP_SELECT
	Call PlayersHouse_B1F_EventScript_Frame_maker1
	Wait 8, VAR_SPECIAL_RESULT
	Call PlayersHouse_B1F_EventScript_Frame_maker2
	Wait 8, VAR_SPECIAL_RESULT
	PlaySE SEQ_SE_DP_SELECT
	Call PlayersHouse_B1F_EventScript_Frame_maker3
	Wait 8, VAR_SPECIAL_RESULT
	Call PlayersHouse_B1F_EventScript_Frame_maker0
	Wait 8, VAR_SPECIAL_RESULT
	Return
	
PlayersHouse_B1F_EventScript_MakerBallOut:
	Call PlayersHouse_B1F_EventScript_Frame_maker_ball
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	Return
	
PlayersHouse_B1F_EventScript_MakerTakeBall:
	GiveItem 0x8005, 1, VAR_SPECIAL_RESULT
	BufferItemName 2, 0x8005
	PlayFanfare SEQ_ME_ITEM
	BufferPlayersName 6
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_MakerTookBall
	WaitButton
	WaitFanfare
	Call PlayersHouse_B1F_EventScript_Frame_maker0
	Return
	
PlayersHouse_B1F_EventScript_ChangerSame:
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_ChangerSame
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PlayersHouse_B1F_EventScript_ChangerBagFull:
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_ChangerBagFull
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PlayersHouse_B1F_EventScript_SwitchWall:
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_Wall
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PlayersHouse_B1F_EventScript_SwitchToEvil:
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_SwitchToEvil
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_17
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_18
_cv_yes_17:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_18:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PlayersHouse_B1F_EventScript_MachineEnd
	ClearFlag 0x200D
	Call PlayersHouse_B1F_EventScript_Frame_switch_off
	PlaySE SEQ_SE_DP_SELECT
	BufferPlayersName 6
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_SwitchedToEvil
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Outfits_EventScript_BasementCrates:
	SetVar 0x8004, 1
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Outfits_EventScript_CratesEmpty
	LockAll
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_Outfits_Text_LooseCrate
	WaitButton
	SetVar 0x8004, 1
	// TODO(gba) special Outfit_UnlockSpecial
	GoTo _cv_stop
	PlayFanfare SEQ_ME_ITEM
	BufferPlayersName 6
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_Outfits_Text_FoundRocketUniform
	WaitFanfare
	CompareVarToValue 0x5008, 8
	CallIfLt Outfits_EventScript_WhyIsThisHere
	CompareVarToValue 0x5008, 8
	CallIfGe Outfits_EventScript_ItsDads
	BufferPlayersName 6
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_Outfits_Text_PutInWardrobe
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PlayersHouse_B1F_EventScript_SetSwitch:
	CallIfUnset 0x2010, PlayersHouse_B1F_EventScript_Frame_switch_off
	CallIfSet 0x2010, PlayersHouse_B1F_EventScript_Frame_switch_on
	Return
	
DadStory_EventScript_BasementTransition:
	SetFlag 0x200F
	CompareVarToValue 0x5008, 5
	GoToIfNe Common_EventScript_NopReturn
	ClearFlag 0x200F
	Return
	
PlayersHouse_B1F_EventScript_SynthNoFuel:
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_SynthNoFuel
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PlayersHouse_B1F_EventScript_SynthBlocked:
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_SynthBlocked
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PlayersHouse_B1F_EventScript_SynthAlready:
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_SynthAlready
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PlayersHouse_B1F_EventScript_SynthCycle:
	Call PlayersHouse_B1F_EventScript_Frame_synth1
	Wait 6, VAR_SPECIAL_RESULT
	Call PlayersHouse_B1F_EventScript_Frame_synth2
	Wait 6, VAR_SPECIAL_RESULT
	Call PlayersHouse_B1F_EventScript_Frame_synth0
	Wait 6, VAR_SPECIAL_RESULT
	Return
	
PlayersHouse_B1F_EventScript_SynthDoneNice:
	PlayFanfare SEQ_ME_LVUP
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_PlayersHouse_B1F_Text_SynthDoneNice
	WaitButton
	WaitFanfare
	CloseMsg
	ReleaseAll
	End
	
Outfits_EventScript_CratesEmpty:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_Outfits_Text_CratesEmpty
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Outfits_EventScript_WhyIsThisHere:
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_Outfits_Text_WhyIsThisHere
	WaitButton
	Return
	
Outfits_EventScript_ItsDads:
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_DadStory_Text_CrateIsDads
	WaitButton
	Return
	
Common_EventScript_NopReturn:
	Return

_cv_stop:
	NPCMsg msg_0854_CV_FIGHT_AREA_UNUSED_6_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
PlayersHouse_B1F_EventScript_Frame_changer1:
	EndMovement

	.balign 4, 0
PlayersHouse_B1F_EventScript_Frame_changer0:
	EndMovement

	.balign 4, 0
PlayersHouse_B1F_EventScript_Frame_switch_on:
	EndMovement

	.balign 4, 0
Common_Movement_WalkInPlaceFasterLeft:
	WalkOnSpotFasterWest
	EndMovement

	.balign 4, 0
DadStory_Movement_MomUpstairs:
	WalkNormalNorth
	WalkNormalEast
	SetInvisible
	EndMovement

	.balign 4, 0
PlayersHouse_B1F_EventScript_Frame_synth0:
	EndMovement

	.balign 4, 0
PlayersHouse_B1F_EventScript_Frame_maker1:
	EndMovement

	.balign 4, 0
PlayersHouse_B1F_EventScript_Frame_maker2:
	EndMovement

	.balign 4, 0
PlayersHouse_B1F_EventScript_Frame_maker3:
	EndMovement

	.balign 4, 0
PlayersHouse_B1F_EventScript_Frame_maker0:
	EndMovement

	.balign 4, 0
PlayersHouse_B1F_EventScript_Frame_maker_ball:
	EndMovement

	.balign 4, 0
PlayersHouse_B1F_EventScript_Frame_switch_off:
	EndMovement

	.balign 4, 0
PlayersHouse_B1F_EventScript_Frame_synth1:
	EndMovement

	.balign 4, 0
PlayersHouse_B1F_EventScript_Frame_synth2:
	EndMovement
	.balign 4, 0
