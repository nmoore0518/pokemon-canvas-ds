#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_GAME_CORNER.h"
#include "msgdata/msg/msg_0953_CV_CANVAS_GAME_CORNER.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's CeladonCity_GameCorner_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef CeladonCity_GameCorner_EventScript_InfoClerk
	ScrDef CeladonCity_GameCorner_EventScript_CoinsClerk
	ScrDef CeladonCity_GameCorner_EventScript_BaldingMan
	ScrDef CeladonCity_GameCorner_EventScript_Woman1
	ScrDef CeladonCity_GameCorner_EventScript_Fisher
	ScrDef CeladonCity_GameCorner_EventScript_GymGuy
	ScrDef CeladonCity_GameCorner_EventScript_Woman2
	ScrDef CeladonCity_GameCorner_EventScript_OldMan
	ScrDef CeladonCity_GameCorner_EventScript_Scientist
	ScrDef CeladonCity_GameCorner_EventScript_Gentleman
	ScrDef CeladonCity_GameCorner_EventScript_RocketGrunt
	ScrDef Pit_EventScript_GameCornerWhisperer
	ScrDef Pit_EventScript_GameCornerListener
	ScrDef CeladonCity_GameCorner_EventScript_SlotMachine0
	ScrDef CeladonCity_GameCorner_EventScript_SlotMachine1
	ScrDef CeladonCity_GameCorner_EventScript_SlotMachine2
	ScrDef CeladonCity_GameCorner_EventScript_SlotMachine3
	ScrDef CeladonCity_GameCorner_EventScript_UnusableSlotMachine1
	ScrDef CeladonCity_GameCorner_EventScript_SlotMachine5
	ScrDef CeladonCity_GameCorner_EventScript_SlotMachine6
	ScrDef CeladonCity_GameCorner_EventScript_SlotMachine7
	ScrDef CeladonCity_GameCorner_EventScript_SlotMachine8
	ScrDef CeladonCity_GameCorner_EventScript_SlotMachine9
	ScrDef CeladonCity_GameCorner_EventScript_SlotMachine10
	ScrDef CeladonCity_GameCorner_EventScript_SlotMachine11
	ScrDef CeladonCity_GameCorner_EventScript_SlotMachine12
	ScrDef CeladonCity_GameCorner_EventScript_SlotMachine13
	ScrDef CeladonCity_GameCorner_EventScript_SlotMachine14
	ScrDef CeladonCity_GameCorner_EventScript_UnusableSlotMachine2
	ScrDef CeladonCity_GameCorner_EventScript_SlotMachine16
	ScrDef CeladonCity_GameCorner_EventScript_SlotMachine17
	ScrDef CeladonCity_GameCorner_EventScript_UnusableSlotMachine3
	ScrDef CeladonCity_GameCorner_EventScript_SlotMachine19
	ScrDef CeladonCity_GameCorner_EventScript_SlotMachine20
	ScrDef CeladonCity_GameCorner_EventScript_SlotMachine21
	ScrDef CeladonCity_GameCorner_EventScript_Poster
	ScrDef CeladonCity_GameCorner_EventScript_PhotoPrinter
	ScrDef CeladonCity_GameCorner_OnLoad
	ScrDefEnd
	
CeladonCity_GameCorner_EventScript_InfoClerk:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_CanExchangeCoinsNextDoor
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_GameCorner_EventScript_CoinsClerk:
	LockAll
	FacePlayer
	ShowMoneyBox 20, 2
	// TODO(gba) showcoinsbox 0, 5
	GoTo _cv_stop
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_WelcomeBuySomeCoins
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0953_CV_CANVAS_GAME_CORNER_cv_mc_game_corner_coin_purchase_counter_0, 0
	ScrCmd_559 msg_0953_CV_CANVAS_GAME_CORNER_cv_mc_game_corner_coin_purchase_counter_1, 1
	ScrCmd_559 msg_0953_CV_CANVAS_GAME_CORNER_cv_mc_game_corner_coin_purchase_counter_2, 2
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_2
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_2:
	CopyVar 0x8009, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CeladonCity_GameCorner_EventScript_BuyCoins
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq CeladonCity_GameCorner_EventScript_BuyCoins
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq CeladonCity_GameCorner_EventScript_ClerkDeclineBuy
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq CeladonCity_GameCorner_EventScript_ClerkDeclineBuy
	CloseMsg
	End
	
CeladonCity_GameCorner_EventScript_BaldingMan:
	LockAll
	FacePlayer
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_RumoredTeamRocketRunsThisPlace
	WaitButton
	GoTo CeladonCity_GameCorner_EventScript_FaceSlotMachine
	CloseMsg
	End
	
CeladonCity_GameCorner_EventScript_Woman1:
	LockAll
	FacePlayer
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_ThinkMachinesHaveDifferentOdds
	WaitButton
	GoTo CeladonCity_GameCorner_EventScript_FaceSlotMachine
	CloseMsg
	End
	
CeladonCity_GameCorner_EventScript_Fisher:
	LockAll
	FacePlayer
	GoToIfSet 0x2135, CeladonCity_GameCorner_EventScript_FisherAlreadyGotCoins
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_DoYouWantToPlay
	WaitButton
	GoToIfUnset 0x2136, CeladonCity_GameCorner_EventScript_GamblerNoCoinCase
	// TODO(gba) checkcoins VAR_TEMP_1
	GoTo _cv_stop
	CompareVarToValue 0x4001, 9990
	GoToIfGe CeladonCity_GameCorner_EventScript_FisherNoRoomForCoins
	// TODO(gba) addcoins 10
	GoTo _cv_stop
	BufferPlayersName 6
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_Received10CoinsFromMan
	WaitButton
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	SetFlag 0x2135
	GoTo CeladonCity_GameCorner_EventScript_FaceSlotMachine
	CloseMsg
	End
	
CeladonCity_GameCorner_EventScript_GymGuy:
	LockAll
	FacePlayer
	GoToIfSet 0x2137, CeladonCity_GameCorner_EventScript_GymGuyPostVictory
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_GymGuyAdvice
	WaitButton
	GoTo CeladonCity_GameCorner_EventScript_FaceSlotMachine
	CloseMsg
	End
	
CeladonCity_GameCorner_EventScript_Woman2:
	LockAll
	FacePlayer
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_WinOrLoseItsOnlyLuck
	WaitButton
	GoTo CeladonCity_GameCorner_EventScript_FaceSlotMachine
	CloseMsg
	End
	
CeladonCity_GameCorner_EventScript_OldMan:
	LockAll
	FacePlayer
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_SoEasyToGetHooked
	WaitButton
	GoTo CeladonCity_GameCorner_EventScript_FaceSlotMachine
	CloseMsg
	End
	
CeladonCity_GameCorner_EventScript_Scientist:
	LockAll
	FacePlayer
	GoToIfSet 0x2138, CeladonCity_GameCorner_EventScript_ScientistAlreadyGotCoins
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_WantSomeCoins
	WaitButton
	GoToIfUnset 0x2136, CeladonCity_GameCorner_EventScript_GamblerNoCoinCase
	// TODO(gba) checkcoins VAR_TEMP_1
	GoTo _cv_stop
	CompareVarToValue 0x4001, 9980
	GoToIfGe CeladonCity_GameCorner_EventScript_ScientistNoRoomForCoins
	// TODO(gba) addcoins 20
	GoTo _cv_stop
	BufferPlayersName 6
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_Received20CoinsFromNiceGuy
	WaitButton
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	SetFlag 0x2138
	GoTo CeladonCity_GameCorner_EventScript_FaceSlotMachine
	CloseMsg
	End
	
CeladonCity_GameCorner_EventScript_Gentleman:
	LockAll
	FacePlayer
	GoToIfSet 0x2139, CeladonCity_GameCorner_EventScript_GentlemanAlreadyGotCoins
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_HereAreSomeCoinsShoo
	WaitButton
	GoToIfUnset 0x2136, CeladonCity_GameCorner_EventScript_GamblerNoCoinCase
	// TODO(gba) checkcoins VAR_TEMP_1
	GoTo _cv_stop
	CompareVarToValue 0x4001, 9980
	GoToIfGe CeladonCity_GameCorner_EventScript_GentlemanNoRoomForCoins
	// TODO(gba) addcoins 20
	GoTo _cv_stop
	BufferPlayersName 6
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_Received20CoinsFromMan
	WaitButton
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	SetFlag 0x2139
	GoTo CeladonCity_GameCorner_EventScript_FaceSlotMachine
	CloseMsg
	End
	
CeladonCity_GameCorner_EventScript_RocketGrunt:
	CheckTrainerFlag 1093
	GoToIf TRUE, _cv_beaten_3
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_GruntIntro
	WaitButton
	CloseMsg
	TrainerBattle 1093, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_4
	WhiteOut
	End
_cv_won_4:
	SetTrainerFlag 1093
	GoTo CeladonCity_GameCorner_Text_DefeatedGrunt
_cv_beaten_3:
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_GruntPostBattle
	WaitButton
	CloseMsg
	End
	
Pit_EventScript_GameCornerWhisperer:
	LockAll
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_Pit_Text_Overheard
	WaitButton
	FacePlayer
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_Pit_Text_WhispererCaught
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Pit_EventScript_GameCornerListener:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_Pit_Text_ListenerBeatIt
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_GameCorner_EventScript_SlotMachine0:
	LockAll
	SetVar 0x8004, 0
	GoTo CeladonCity_GameCorner_EventScript_SlotMachine
	End
	
CeladonCity_GameCorner_EventScript_SlotMachine1:
	LockAll
	SetVar 0x8004, 1
	GoTo CeladonCity_GameCorner_EventScript_SlotMachine
	End
	
CeladonCity_GameCorner_EventScript_SlotMachine2:
	LockAll
	SetVar 0x8004, 2
	GoTo CeladonCity_GameCorner_EventScript_SlotMachine
	End
	
CeladonCity_GameCorner_EventScript_SlotMachine3:
	LockAll
	SetVar 0x8004, 3
	GoTo CeladonCity_GameCorner_EventScript_SlotMachine
	End
	
CeladonCity_GameCorner_EventScript_UnusableSlotMachine1:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_OutOfOrder
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_GameCorner_EventScript_SlotMachine5:
	LockAll
	SetVar 0x8004, 5
	GoTo CeladonCity_GameCorner_EventScript_SlotMachine
	End
	
CeladonCity_GameCorner_EventScript_SlotMachine6:
	LockAll
	SetVar 0x8004, 6
	GoTo CeladonCity_GameCorner_EventScript_SlotMachine
	End
	
CeladonCity_GameCorner_EventScript_SlotMachine7:
	LockAll
	SetVar 0x8004, 7
	GoTo CeladonCity_GameCorner_EventScript_SlotMachine
	End
	
CeladonCity_GameCorner_EventScript_SlotMachine8:
	LockAll
	SetVar 0x8004, 8
	GoTo CeladonCity_GameCorner_EventScript_SlotMachine
	End
	
CeladonCity_GameCorner_EventScript_SlotMachine9:
	LockAll
	SetVar 0x8004, 9
	GoTo CeladonCity_GameCorner_EventScript_SlotMachine
	End
	
CeladonCity_GameCorner_EventScript_SlotMachine10:
	LockAll
	SetVar 0x8004, 10
	GoTo CeladonCity_GameCorner_EventScript_SlotMachine
	End
	
CeladonCity_GameCorner_EventScript_SlotMachine11:
	LockAll
	SetVar 0x8004, 11
	GoTo CeladonCity_GameCorner_EventScript_SlotMachine
	End
	
CeladonCity_GameCorner_EventScript_SlotMachine12:
	LockAll
	SetVar 0x8004, 12
	GoTo CeladonCity_GameCorner_EventScript_SlotMachine
	End
	
CeladonCity_GameCorner_EventScript_SlotMachine13:
	LockAll
	SetVar 0x8004, 13
	GoTo CeladonCity_GameCorner_EventScript_SlotMachine
	End
	
CeladonCity_GameCorner_EventScript_SlotMachine14:
	LockAll
	SetVar 0x8004, 14
	GoTo CeladonCity_GameCorner_EventScript_SlotMachine
	End
	
CeladonCity_GameCorner_EventScript_UnusableSlotMachine2:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_OutToLunch
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_GameCorner_EventScript_SlotMachine16:
	LockAll
	SetVar 0x8004, 16
	GoTo CeladonCity_GameCorner_EventScript_SlotMachine
	End
	
CeladonCity_GameCorner_EventScript_SlotMachine17:
	LockAll
	SetVar 0x8004, 17
	GoTo CeladonCity_GameCorner_EventScript_SlotMachine
	End
	
CeladonCity_GameCorner_EventScript_UnusableSlotMachine3:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_SomeonesKeys
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_GameCorner_EventScript_SlotMachine19:
	LockAll
	SetVar 0x8004, 19
	GoTo CeladonCity_GameCorner_EventScript_SlotMachine
	End
	
CeladonCity_GameCorner_EventScript_SlotMachine20:
	LockAll
	SetVar 0x8004, 20
	GoTo CeladonCity_GameCorner_EventScript_SlotMachine
	End
	
CeladonCity_GameCorner_EventScript_SlotMachine21:
	LockAll
	SetVar 0x8004, 21
	GoTo CeladonCity_GameCorner_EventScript_SlotMachine
	End
	
CeladonCity_GameCorner_EventScript_Poster:
	LockAll
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_SwitchBehindPosterPushIt
	WaitButton
	CallIfUnset 0x213A, CeladonCity_GameCorner_EventScript_OpenRocketHideout
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_GameCorner_EventScript_PhotoPrinter:
	LockAll
	ShowMoneyBox 20, 2
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_TryPokemonPrinter
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_5
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_6
_cv_yes_5:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_6:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CeladonCity_GameCorner_EventScript_DeclinePhoto
	HasEnoughMoneyImmediate VAR_SPECIAL_RESULT, 50
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CeladonCity_GameCorner_EventScript_NotEnoughMoneyForPhoto
	PlaySE SEQ_SE_DP_SELECT
	SubMoneyImmediate 50
	UpdateMoneyBox
	WaitSE SEQ_SE_DP_SELECT
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_ChoosePrintType
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 0, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0953_CV_CANVAS_GAME_CORNER_cv_mc_trainer_card_icon_tint_0, 0
	ScrCmd_559 msg_0953_CV_CANVAS_GAME_CORNER_cv_mc_trainer_card_icon_tint_1, 1
	ScrCmd_559 msg_0953_CV_CANVAS_GAME_CORNER_cv_mc_trainer_card_icon_tint_2, 2
	ScrCmd_559 msg_0953_CV_CANVAS_GAME_CORNER_cv_mc_trainer_card_icon_tint_3, 3
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_8
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_8:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CeladonCity_GameCorner_EventScript_PrintTypeNormal
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq CeladonCity_GameCorner_EventScript_PrintTypeBlack
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq CeladonCity_GameCorner_EventScript_PrintTypePink
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfEq CeladonCity_GameCorner_EventScript_PrintTypeSepia
	CloseMsg
	End
	
CeladonCity_GameCorner_OnLoad:
	CallIfUnset 0x213A, CeladonCity_GameCorner_EventScript_HideRocketHideout
	End
	
CeladonCity_GameCorner_EventScript_BuyCoins:
	GoToIfUnset 0x2136, CeladonCity_GameCorner_EventScript_ClerkNoCoinCase
	CompareVarToValue 0x8009, 0
	GoToIfEq CeladonCity_GameCorner_EventScript_Buy50Coins
	CompareVarToValue 0x8009, 1
	GoToIfEq CeladonCity_GameCorner_EventScript_Buy500Coins
	End
	
CeladonCity_GameCorner_EventScript_ClerkDeclineBuy:
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_ComePlaySometime
	WaitButton
	GoTo CeladonCity_GameCorner_EventScript_ClerkEnd
	CloseMsg
	End
	
CeladonCity_GameCorner_EventScript_FaceSlotMachine:
	CloseMsg
	ApplyMovement VAR_SPECIAL_LAST_TALKED, Common_Movement_FaceOriginalDirection
	WaitMovement
	ReleaseAll
	End
	
CeladonCity_GameCorner_EventScript_FisherAlreadyGotCoins:
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_WinsComeAndGo
	WaitButton
	GoTo CeladonCity_GameCorner_EventScript_FaceSlotMachine
	CloseMsg
	End
	
CeladonCity_GameCorner_EventScript_GamblerNoCoinCase:
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_DontHaveCoinCase
	WaitButton
	GoTo CeladonCity_GameCorner_EventScript_FaceSlotMachine
	CloseMsg
	End
	
CeladonCity_GameCorner_EventScript_FisherNoRoomForCoins:
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_DontNeedMyCoins
	WaitButton
	GoTo CeladonCity_GameCorner_EventScript_FaceSlotMachine
	CloseMsg
	End
	
CeladonCity_GameCorner_EventScript_GymGuyPostVictory:
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_RareMonsForCoins
	WaitButton
	GoTo CeladonCity_GameCorner_EventScript_FaceSlotMachine
	CloseMsg
	End
	
CeladonCity_GameCorner_EventScript_ScientistAlreadyGotCoins:
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_NeedMoreCoinsForMonIWant
	WaitButton
	GoTo CeladonCity_GameCorner_EventScript_FaceSlotMachine
	CloseMsg
	End
	
CeladonCity_GameCorner_EventScript_ScientistNoRoomForCoins:
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_YouHaveLotsOfCoins
	WaitButton
	GoTo CeladonCity_GameCorner_EventScript_FaceSlotMachine
	CloseMsg
	End
	
CeladonCity_GameCorner_EventScript_GentlemanAlreadyGotCoins:
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_WatchReelsClosely
	WaitButton
	GoTo CeladonCity_GameCorner_EventScript_FaceSlotMachine
	CloseMsg
	End
	
CeladonCity_GameCorner_EventScript_GentlemanNoRoomForCoins:
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_YouveGotPlentyCoins
	WaitButton
	GoTo CeladonCity_GameCorner_EventScript_FaceSlotMachine
	CloseMsg
	End
	
CeladonCity_GameCorner_Text_DefeatedGrunt:
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_GruntPostBattle
	WaitButton
	CloseMsg
	CompareVarToValue 0x5002, 2
	CallIfEq CeladonCity_GameCorner_Text_GruntExitWest
	CompareVarToValue 0x5002, 2
	CallIfNe CeladonCity_GameCorner_Text_GruntExit
	HidePerson 11
	SetFlag 0x213B
	ReleaseAll
	End
	
CeladonCity_GameCorner_EventScript_SlotMachine:
	GoToIfUnset 0x2136, CeladonCity_GameCorner_EventScript_SlotMachineNoCoinCase
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_SlotMachineWantToPlay
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_9
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_10
_cv_yes_9:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_10:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CeladonCity_GameCorner_EventScript_DontPlaySlotMachine
	// TODO(gba) setfieldeffectargument 0, LOCALID_PLAYER
	GoTo _cv_stop
	// TODO(gba) #ifdef BUGFIX
	GoTo _cv_stop
	// TODO(gba) setfieldeffectargument 1, MAP_NUM(MAP_CELADON_CITY_GAME_CORNER)
	GoTo _cv_stop
	// TODO(gba) setfieldeffectargument 2, MAP_GROUP(MAP_CELADON_CITY_GAME_CORNER)
	GoTo _cv_stop
	// TODO(gba) #else 
	GoTo _cv_stop
	// TODO(gba) setfieldeffectargument 1, MAP_GROUP(MAP_CELADON_CITY_GAME_CORNER)
	GoTo _cv_stop
	// TODO(gba) setfieldeffectargument 2, MAP_NUM(MAP_CELADON_CITY_GAME_CORNER)
	GoTo _cv_stop
	// TODO(gba) #endif 
	GoTo _cv_stop
	// TODO(gba) dofieldeffect FLDEFF_SMILEY_FACE_ICON
	GoTo _cv_stop
	// TODO(gba) waitfieldeffect FLDEFF_SMILEY_FACE_ICON
	GoTo _cv_stop
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar GetRandomSlotMachineId
	GoTo _cv_stop
	// TODO(gba) playslotmachine VAR_RESULT
	GoTo _cv_stop
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_GameCorner_EventScript_OpenRocketHideout:
	PlaySE SEQ_SE_DP_SELECT
	// TODO(gba) setmetatile 15, 2, METATILE_GameCorner_Floor_StairsTop, 0
	GoTo _cv_stop
	// TODO(gba) setmetatile 16, 2, METATILE_GameCorner_StairsTop, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 17, 2, METATILE_GameCorner_StairsBottom, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 16, 3, METATILE_GameCorner_PurpleWall_StairsTop, 1
	GoTo _cv_stop
	// TODO(gba) setmetatile 17, 3, METATILE_GameCorner_PurpleWall_stairsBottom, 1
	GoTo _cv_stop
	SetFlag 0x213A
	Return
	
CeladonCity_GameCorner_EventScript_DeclinePhoto:
	HideMoneyBox
	ReleaseAll
	End
	
CeladonCity_GameCorner_EventScript_NotEnoughMoneyForPhoto:
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_DontHaveEnoughMoney
	WaitButton
	HideMoneyBox
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_GameCorner_EventScript_PrintTypeNormal:
	SetVar 0x8004, 0
	GoTo CeladonCity_GameCorner_EventScript_PrintPhoto
	End
	
CeladonCity_GameCorner_EventScript_PrintTypeBlack:
	SetVar 0x8004, 1
	GoTo CeladonCity_GameCorner_EventScript_PrintPhoto
	End
	
CeladonCity_GameCorner_EventScript_PrintTypePink:
	SetVar 0x8004, 2
	GoTo CeladonCity_GameCorner_EventScript_PrintPhoto
	End
	
CeladonCity_GameCorner_EventScript_PrintTypeSepia:
	SetVar 0x8004, 3
	GoTo CeladonCity_GameCorner_EventScript_PrintPhoto
	End
	
CeladonCity_GameCorner_EventScript_HideRocketHideout:
	// TODO(gba) setmetatile 15, 2, METATILE_GameCorner_Floor_ShadeFull, 0
	// TODO(gba) setmetatile 16, 2, METATILE_GameCorner_Floor_ShadeFull, 0
	// TODO(gba) setmetatile 17, 2, METATILE_GameCorner_Floor_ShadeFull, 0
	// TODO(gba) setmetatile 16, 3, METATILE_GameCorner_PurpleWall_Floor, 1
	// TODO(gba) setmetatile 17, 3, METATILE_GameCorner_PurpleWall_Floor, 1
	Return
	
CeladonCity_GameCorner_EventScript_ClerkNoCoinCase:
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_SorryDontHaveCoinCase
	WaitButton
	GoTo CeladonCity_GameCorner_EventScript_ClerkEnd
	CloseMsg
	End
	
CeladonCity_GameCorner_EventScript_Buy50Coins:
	// TODO(gba) checkcoins VAR_TEMP_1
	GoTo _cv_stop
	CompareVarToValue 0x4001, 9950
	GoToIfGe CeladonCity_GameCorner_EventScript_ClerkNoRoomForCoins
	HasEnoughMoneyImmediate VAR_SPECIAL_RESULT, 1000
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CeladonCity_GameCorner_EventScript_ClerkNotEnoughMoney
	// TODO(gba) addcoins 50
	GoTo _cv_stop
	SubMoneyImmediate 1000
	GoTo CeladonCity_GameCorner_EventScript_BoughtCoins
	End
	
CeladonCity_GameCorner_EventScript_Buy500Coins:
	// TODO(gba) checkcoins VAR_TEMP_1
	GoTo _cv_stop
	CompareVarToValue 0x4001, 9500
	GoToIfGe CeladonCity_GameCorner_EventScript_ClerkNoRoomForCoins
	HasEnoughMoneyImmediate VAR_SPECIAL_RESULT, 10000
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CeladonCity_GameCorner_EventScript_ClerkNotEnoughMoney
	// TODO(gba) addcoins 500
	GoTo _cv_stop
	SubMoneyImmediate 10000
	GoTo CeladonCity_GameCorner_EventScript_BoughtCoins
	End
	
CeladonCity_GameCorner_EventScript_ClerkEnd:
	HideMoneyBox
	// TODO(gba) hidecoinsbox 
	GoTo _cv_stop
	ReleaseAll
	End
	
CeladonCity_GameCorner_Text_GruntExitWest:
	ApplyMovement 11, CeladonCity_GameCorner_Movement_GruntExitWest
	WaitMovement
	Return
	
CeladonCity_GameCorner_Text_GruntExit:
	ApplyMovement 11, CeladonCity_GameCorner_Movement_GruntExit
	WaitMovement
	Return
	
CeladonCity_GameCorner_EventScript_SlotMachineNoCoinCase:
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_CoinCaseIsRequired
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_GameCorner_EventScript_DontPlaySlotMachine:
	ReleaseAll
	End
	
CeladonCity_GameCorner_EventScript_PrintPhoto:
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_BigSmileForPhoto
	PlaySE SEQ_SE_DP_SELECT
	// TODO(gba) dofieldeffect FLDEFF_PHOTO_FLASH
	GoTo _cv_stop
	Wait 60, VAR_SPECIAL_RESULT
	// TODO(gba) special UpdateTrainerCardPhotoIcons
	GoTo _cv_stop
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_PrintIsReadyCheckTrainerCard
	WaitButton
	HideMoneyBox
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_GameCorner_EventScript_ClerkNoRoomForCoins:
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_CoinCaseIsFull
	WaitButton
	GoTo CeladonCity_GameCorner_EventScript_ClerkEnd
	CloseMsg
	End
	
CeladonCity_GameCorner_EventScript_ClerkNotEnoughMoney:
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_CantAffordCoins
	WaitButton
	GoTo CeladonCity_GameCorner_EventScript_ClerkEnd
	CloseMsg
	End
	
CeladonCity_GameCorner_EventScript_BoughtCoins:
	UpdateMoneyBox
	// TODO(gba) updatecoinsbox 
	GoTo _cv_stop
	PlaySE SEQ_SE_DP_SELECT
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_CeladonCity_GameCorner_Text_HereAreYourCoins
	WaitButton
	GoTo CeladonCity_GameCorner_EventScript_ClerkEnd
	CloseMsg
	End

_cv_stop:
	NPCMsg msg_0953_CV_CANVAS_GAME_CORNER_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
Common_Movement_FaceOriginalDirection:
	EndMovement

	.balign 4, 0
CeladonCity_GameCorner_Movement_GruntExitWest:
	WalkNormalSouth
	WalkNormalEast 2
	WalkNormalNorth
	WalkNormalEast 4
	EndMovement

	.balign 4, 0
CeladonCity_GameCorner_Movement_GruntExit:
	WalkNormalEast 6
	EndMovement
	.balign 4, 0
