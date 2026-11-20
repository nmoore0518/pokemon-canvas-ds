#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T06.h"
#include "msgdata/msg/msg_0483_T06.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's VermilionCity_Frlg#world by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef VermilionCity_EventScript_Woman
	ScrDef VermilionCity_EventScript_OldMan1
	ScrDef VermilionCity_EventScript_Foreman
	ScrDef VermilionCity_EventScript_Machop
	ScrDef VermilionCity_EventScript_Sailor
	ScrDef VermilionCity_EventScript_FerrySailor
	ScrDef VermilionCity_EventScript_OaksAide
	ScrDef TypeTutor_EventScript_Electric
	ScrDef TypeTutor_EventScript_Steel
	ScrDef VermilionCity_EventScript_CitySign
	ScrDef VermilionCity_EventScript_PokemonFanClubSign
	ScrDef VermilionCity_EventScript_GymSign
	ScrDef VermilionCity_EventScript_HarborSign
	ScrDef VermilionCity_EventScript_SnorlaxNotice
	ScrDef _cv_unported_14
	ScrDef _cv_unported_15
	ScrDef VermilionCity_EventScript_ExitedTicketCheck
	ScrDef VermilionCity_OnLoad
	ScrDef VermilionCity_OnTransition
	ScrDef VermilionCity_EventScript_ExitSSAnne
	ScrDefEnd
	
VermilionCity_EventScript_Woman:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0483_T06_VermilionCity_Text_GrimerMultipliesInSludge
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_EventScript_OldMan1:
	LockAll
	FacePlayer
	CompareVarToValue 0x5027, 3
	GoToIfEq VermilionCity_EventScript_OldMan1SSAnneLeft
	NPCMsg msg_0483_T06_VermilionCity_Text_DidYouSeeSSAnneInHarbor
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_EventScript_Foreman:
	LockAll
	FacePlayer
	// TODO(gba) special MedCenter_BufferHelper
	GoTo _cv_stop
	CopyVar 0x8006, VAR_SPECIAL_RESULT
	CompareVarToValue 0x8006, 0
	CallIfEq VermilionCity_EventScript_ForemanIntro
	CompareVarToValue 0x8006, 0
	CallIfNe VermilionCity_EventScript_ForemanNext
	NPCMsg msg_0483_T06_VermilionCity_Text_ForemanAsk
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq VermilionCity_EventScript_ForemanNo
	NPCMsg msg_0483_T06_VermilionCity_Text_ForemanWhich
	WaitButton
	CloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	ScrCmd_566
	GetPartySelection 0x8004
	RestoreOverworld
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	CompareVarToValue 0x8004, 6
	GoToIfGe VermilionCity_EventScript_ForemanNo
	// TODO(gba) special MedCenter_CheckHelper
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq VermilionCity_EventScript_ForemanTake
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq VermilionCity_EventScript_ForemanNotShiny
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfEq VermilionCity_EventScript_ForemanEgg
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfEq VermilionCity_EventScript_ForemanLastMon
	NPCMsg msg_0483_T06_VermilionCity_Text_ForemanWrong
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_EventScript_Machop:
	LockAll
	FacePlayer
	WaitSE SEQ_SE_DP_SELECT
	PlayCry SPECIES_MACHOP, 0
	NPCMsg msg_0483_T06_VermilionCity_Text_Machop
	WaitButton
	WaitCry
	NPCMsg msg_0483_T06_VermilionCity_Text_MachopStompingLandFlat
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_EventScript_Sailor:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0483_T06_VermilionCity_Text_SSAnneVisitsOnceAYear
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_EventScript_FerrySailor:
	LockAll
	FacePlayer
	CompareVarToValue 0x5009, 2
	GoToIfGe Johto_EventScript_VermilionFerry
	CompareVarToValue 0x5027, 3
	GoToIfEq VermilionCity_EventScript_CheckSeagallopPresent
	NPCMsg msg_0483_T06_VermilionCity_Text_WelcomeToTheSSAnne
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_EventScript_OaksAide:
	LockAll
	FacePlayer
	SetFlag 0x20EF
	BufferPlayersName 6
	NPCMsg msg_0483_T06_VermilionCity_Text_Route2AideHasPackageForYou
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TypeTutor_EventScript_Electric:
	LockAll
	FacePlayer
	SetVar 0x8004, 7
	GoTo TypeTutor_EventScript_Talk
	
TypeTutor_EventScript_Steel:
	LockAll
	FacePlayer
	SetVar 0x8004, 8
	GoTo TypeTutor_EventScript_Talk
	
VermilionCity_EventScript_CitySign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0483_T06_VermilionCity_Text_CitySign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_EventScript_PokemonFanClubSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0483_T06_VermilionCity_Text_PokemonFanClubSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_EventScript_GymSign:
	LockAll
	NPCMsg msg_0483_T06_VermilionCity_Text_GymSign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_EventScript_HarborSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0483_T06_VermilionCity_Text_VermilionHarbor
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_EventScript_SnorlaxNotice:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0483_T06_VermilionCity_Text_SnorlaxBlockingRoute12
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_EventScript_CheckTicketLeft:
	LockAll
	GoTo VermilionCity_EventScript_CheckTicket
	End
	
VermilionCity_EventScript_CheckTicketRight:
	LockAll
	GoTo VermilionCity_EventScript_CheckTicket
	End
	
VermilionCity_EventScript_ExitedTicketCheck:
	LockAll
	SetVar 0x5028, 0
	ReleaseAll
	End
	
VermilionCity_OnLoad:
	CallIfSet 0x20F0, VermilionCity_EventScript_MedicalCenterBuilt
	End
	
VermilionCity_OnTransition:
	SetFlag FLAG_SYS_FLYPOINT_VERMILION
	CallIfSet 0x20EF, VermilionCity_EventScript_HideOaksAide
	End
	
VermilionCity_EventScript_ExitSSAnne:
	LockAll
	ApplyMovement obj_player, VermilionCity_Movement_ExitSSAnne
	WaitMovement
	SetVar 0x5027, 3
	ReleaseAll
	End
	
VermilionCity_EventScript_OldMan1SSAnneLeft:
	NPCMsg msg_0483_T06_VermilionCity_Text_SSAnneHasDepartedForYear
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_EventScript_ForemanIntro:
	NPCMsg msg_0483_T06_VermilionCity_Text_ForemanIntro
	WaitButton
	Return
	
VermilionCity_EventScript_ForemanNext:
	NPCMsg msg_0483_T06_VermilionCity_Text_ForemanNext
	WaitButton
	Return
	
VermilionCity_EventScript_ForemanNo:
	NPCMsg msg_0483_T06_VermilionCity_Text_ForemanNo
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_EventScript_ForemanTake:
	NPCMsg msg_0483_T06_VermilionCity_Text_ForemanThanks
	WaitButton
	// TODO(gba) special MedCenter_TakeHelper
	GoTo _cv_stop
	CopyVar 0x8006, VAR_SPECIAL_RESULT
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	CompareVarToValue 0x8006, 1
	GoToIfEq VermilionCity_EventScript_ForemanFind1
	CompareVarToValue 0x8006, 2
	GoToIfEq VermilionCity_EventScript_ForemanFind2
	CompareVarToValue 0x8006, 3
	GoToIfEq VermilionCity_EventScript_ForemanFind3
	GoTo VermilionCity_EventScript_ForemanBuilt
	CloseMsg
	End
	
VermilionCity_EventScript_ForemanNotShiny:
	NPCMsg msg_0483_T06_VermilionCity_Text_ForemanNotShiny
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_EventScript_ForemanEgg:
	NPCMsg msg_0483_T06_VermilionCity_Text_ForemanEgg
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_EventScript_ForemanLastMon:
	NPCMsg msg_0483_T06_VermilionCity_Text_ForemanLastMon
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Johto_EventScript_VermilionFerry:
	NPCMsg msg_0483_T06_Johto_Text_FerryToOlivine
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_3
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_4
_cv_yes_3:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq Johto_EventScript_FerryDeclined
	GoTo Johto_EventScript_SailToOlivine
	
VermilionCity_EventScript_CheckSeagallopPresent:
	SetVar 0x8004, 0
	CompareVarToValue 0x5029, 5
	GoToIfGe VermilionCity_EventScript_ChooseSeagallopDestRainbowPass
	CompareVarToValue 0x5029, 1
	GoToIfGe VermilionCity_EventScript_ChooseSeagallopDestTriPass
	NPCMsg msg_0483_T06_VermilionCity_Text_TheShipSetSail
	WaitButton
	CloseMsg
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
	
VermilionCity_EventScript_CheckTicket:
	ApplyMovement 6, Common_Movement_WalkInPlaceFasterLeft
	ApplyMovement obj_player, Common_Movement_WalkInPlaceFasterRight
	WaitMovement
	CompareVarToValue 0x5009, 2
	GoToIfGe Johto_EventScript_VermilionFerryTrigger
	CompareVarToValue 0x5027, 3
	GoToIfEq VermilionCity_EventScript_CheckSeagallopPresentTrigger
	NPCMsg msg_0483_T06_VermilionCity_Text_DoYouHaveATicket
	WaitButton
	GoToIfUnset 0x20D3, VermilionCity_EventScript_DontHaveSSTicket
	BufferPlayersName 6
	NPCMsg msg_0483_T06_VermilionCity_Text_FlashedSSTicket
	WaitButton
	SetVar 0x5028, 1
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_EventScript_MedicalCenterBuilt:
	// (the GBA redraws a square here: 32, 8, 0x328, TRUE)
	// (the GBA redraws a square here: 33, 8, 0x329, TRUE)
	// (the GBA redraws a square here: 34, 8, 0x32A, TRUE)
	// (the GBA redraws a square here: 35, 8, 0x32B, TRUE)
	// (the GBA redraws a square here: 36, 8, 0x32C, TRUE)
	// (the GBA redraws a square here: 37, 8, 0x32D, TRUE)
	// (the GBA redraws a square here: 38, 8, 0x32E, TRUE)
	// (the GBA redraws a square here: 32, 9, 0x32F, TRUE)
	// (the GBA redraws a square here: 33, 9, 0x330, TRUE)
	// (the GBA redraws a square here: 34, 9, 0x331, TRUE)
	// (the GBA redraws a square here: 35, 9, 0x332, TRUE)
	// (the GBA redraws a square here: 36, 9, 0x333, TRUE)
	// (the GBA redraws a square here: 37, 9, 0x334, TRUE)
	// (the GBA redraws a square here: 38, 9, 0x335, TRUE)
	// (the GBA redraws a square here: 32, 10, 0x336, TRUE)
	// (the GBA redraws a square here: 33, 10, 0x337, TRUE)
	// (the GBA redraws a square here: 34, 10, 0x338, TRUE)
	// (the GBA redraws a square here: 35, 10, 0x339, TRUE)
	// (the GBA redraws a square here: 36, 10, 0x33A, TRUE)
	// (the GBA redraws a square here: 37, 10, 0x33B, TRUE)
	// (the GBA redraws a square here: 38, 10, 0x33C, TRUE)
	// (the GBA redraws a square here: 32, 11, 0x33D, TRUE)
	// (the GBA redraws a square here: 33, 11, 0x33E, TRUE)
	// (the GBA redraws a square here: 34, 11, 0x33F, TRUE)
	// (the GBA redraws a square here: 35, 11, 0x340, TRUE)
	// (the GBA redraws a square here: 36, 11, 0x341, TRUE)
	// (the GBA redraws a square here: 37, 11, 0x342, TRUE)
	// (the GBA redraws a square here: 38, 11, 0x343, TRUE)
	// (the GBA redraws a square here: 32, 12, 0x344, TRUE)
	// (the GBA redraws a square here: 33, 12, 0x345, TRUE)
	// (the GBA redraws a square here: 34, 12, 0x346, TRUE)
	// (the GBA redraws a square here: 35, 12, 0x347, TRUE)
	// (the GBA redraws a square here: 36, 12, 0x348, TRUE)
	// (the GBA redraws a square here: 37, 12, 0x349, TRUE)
	// (the GBA redraws a square here: 38, 12, 0x34A, TRUE)
	// (the GBA redraws a square here: 32, 13, 0x34B, TRUE)
	// (the GBA redraws a square here: 33, 13, 0x34C, TRUE)
	// (the GBA redraws a square here: 34, 13, 0x34D, TRUE)
	// (the GBA redraws a square here: 35, 13, 0x34E, FALSE)
	// (the GBA redraws a square here: 36, 13, 0x34F, TRUE)
	// (the GBA redraws a square here: 37, 13, 0x350, TRUE)
	// (the GBA redraws a square here: 38, 13, 0x351, TRUE)
	// (the GBA redraws a square here: 32, 14, 0x001, FALSE)
	// (the GBA redraws a square here: 33, 14, 0x001, FALSE)
	// (the GBA redraws a square here: 34, 14, 0x001, FALSE)
	// (the GBA redraws a square here: 35, 14, 0x001, FALSE)
	// (the GBA redraws a square here: 36, 14, 0x001, FALSE)
	// (the GBA redraws a square here: 37, 14, 0x001, FALSE)
	// (the GBA redraws a square here: 38, 14, 0x001, FALSE)
	Return
	
VermilionCity_EventScript_HideOaksAide:
	SetFlag 0x2061
	Return
	
VermilionCity_EventScript_ForemanFind1:
	NPCMsg msg_0483_T06_VermilionCity_Text_ForemanFound
	WaitButton
	SetVar 0x8009, ITEM_HELIX_FOSSIL
	CallIfSet 0x20C9, VermilionCity_EventScript_ForemanDome
	Call GymHack_EventScript_GiveStatItem
	NPCMsg msg_0483_T06_VermilionCity_Text_ForemanFossil
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_EventScript_ForemanFind2:
	NPCMsg msg_0483_T06_VermilionCity_Text_ForemanFoundTwo
	WaitButton
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 0, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0483_T06_VermilionCity_Text_RootFossil, 0
	ScrCmd_559 msg_0483_T06_VermilionCity_Text_ClawFossil, 1
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_6
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_6:
	SetVar 0x8009, ITEM_ROOT_FOSSIL
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq VermilionCity_EventScript_ForemanClaw
	Call GymHack_EventScript_GiveStatItem
	NPCMsg msg_0483_T06_VermilionCity_Text_ForemanFossil
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_EventScript_ForemanFind3:
	NPCMsg msg_0483_T06_VermilionCity_Text_ForemanFoundTwo
	WaitButton
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 0, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0483_T06_VermilionCity_Text_SkullFossil, 0
	ScrCmd_559 msg_0483_T06_VermilionCity_Text_ArmorFossil, 1
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_8
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_8:
	SetVar 0x8009, ITEM_SKULL_FOSSIL
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	CallIfEq VermilionCity_EventScript_ForemanArmor
	Call GymHack_EventScript_GiveStatItem
	NPCMsg msg_0483_T06_VermilionCity_Text_ForemanFossil
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_EventScript_ForemanBuilt:
	NPCMsg msg_0483_T06_VermilionCity_Text_ForemanBuilding
	WaitButton
	CloseMsg
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	Wait 20, VAR_SPECIAL_RESULT
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	Wait 20, VAR_SPECIAL_RESULT
	PlaySE SEQ_SE_DP_SELECT
	WaitSE SEQ_SE_DP_SELECT
	Wait 30, VAR_SPECIAL_RESULT
	Warp MAP_VERMILION, 0, 1266, 306, DIR_SOUTH
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	ReleaseAll
	End
	
Johto_EventScript_FerryDeclined:
	NPCMsg msg_0483_T06_Johto_Text_FerryLater
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Johto_EventScript_SailToOlivine:
	NPCMsg msg_0483_T06_Johto_Text_FerryDeparting
	WaitButton
	SetVar 0x8004, 0
	SetVar 0x8006, 11
	GoTo EventScript_SetSail
	
VermilionCity_EventScript_ChooseSeagallopDestRainbowPass:
	Call VermilionCity_EventScript_CheckHasMysticTicket
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq VermilionCity_EventScript_HasMysticTicket
	Call VermilionCity_EventScript_CheckHasAuroraTicket
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq VermilionCity_EventScript_HasAuroraTicket
	SetVar 0x8004, 0
	NPCMsg msg_0483_T06_VermilionCity_Text_BoardSeagallopRainbowPass
	GoTo EventScript_SeviiDestinationsPage1
	CloseMsg
	End
	
VermilionCity_EventScript_ChooseSeagallopDestTriPass:
	NPCMsg msg_0483_T06_VermilionCity_Text_BoardSeagallopTriPass
	SetVar 0x8004, 0
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0483_T06_cv_mc_seagallop_123_0, 0
	ScrCmd_559 msg_0483_T06_cv_mc_seagallop_123_1, 1
	ScrCmd_559 msg_0483_T06_cv_mc_seagallop_123_2, 2
	ScrCmd_559 msg_0483_T06_cv_mc_seagallop_123_3, 3
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_10
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_10:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq EventScript_SailToOneIsland2
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq EventScript_SailToTwoIsland2
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq EventScript_SailToThreeIsland2
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfEq EventScript_CancelSail
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq EventScript_CancelSail
	CloseMsg
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
	NPCMsg msg_0483_T06_TypeTutor_Text_WhichMove
	// TODO(gba) special TypeTutor_PushMoves
	GoTo _cv_stop
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_12
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_12:
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq TypeTutor_EventScript_Bye
	CopyVar 0x8004, 0x8008
	// TODO(gba) special TypeTutor_SelectMove
	GoTo _cv_stop
	NPCMsg msg_0483_T06_TypeTutor_Text_WhichMon
	WaitButton
	Call EventScript_ChooseMoveTutorMon
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TypeTutor_EventScript_Teach
	NPCMsg msg_0483_T06_TypeTutor_Text_Taught
	WaitButton
	GoTo TypeTutor_EventScript_Teach
	
Johto_EventScript_VermilionFerryTrigger:
	NPCMsg msg_0483_T06_Johto_Text_FerryToOlivine
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_13
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_14
_cv_yes_13:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_14:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq VermilionCity_EventScript_WalkUpPier
	GoTo Johto_EventScript_SailToOlivine
	
VermilionCity_EventScript_CheckSeagallopPresentTrigger:
	SetVar 0x8004, 0
	CompareVarToValue 0x5029, 5
	GoToIfGe VermilionCity_EventScript_ChooseSeagallopDestRainbowPass
	CompareVarToValue 0x5029, 1
	GoToIfGe VermilionCity_EventScript_ChooseSeagallopDestTriPass
	NPCMsg msg_0483_T06_VermilionCity_Text_TheShipSetSail
	WaitButton
	CloseMsg
	GoTo VermilionCity_EventScript_WalkUpPier
	End
	
VermilionCity_EventScript_DontHaveSSTicket:
	BufferPlayersName 6
	NPCMsg msg_0483_T06_VermilionCity_Text_DontHaveNeededSSTicket
	WaitButton
	CloseMsg
	GoTo VermilionCity_EventScript_WalkUpPier
	End
	
VermilionCity_EventScript_ForemanDome:
	SetVar 0x8009, ITEM_DOME_FOSSIL
	Return
	
GymHack_EventScript_GiveStatItem:
	GiveItem 0x8009, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq GymHack_EventScript_GiveStatItemDone
	BufferItemName 1, 0x8009
	NPCMsg msg_0483_T06_GymHack_Text_GiftSentToPC
	WaitButton
	GoTo GymHack_EventScript_GiveStatItemDone
	
VermilionCity_EventScript_ForemanClaw:
	SetVar 0x8009, ITEM_CLAW_FOSSIL
	Return
	
VermilionCity_EventScript_ForemanArmor:
	SetVar 0x8009, ITEM_ARMOR_FOSSIL
	Return
	
EventScript_SetSail:
	CloseMsg
	Wait 20, VAR_SPECIAL_RESULT
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special DoSeagallopFerryScene
	GoTo _cv_stop
	End
	
VermilionCity_EventScript_CheckHasMysticTicket:
	GoToIfUnset 0x20F1, EventScript_SetResultFalse
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x20F2, _cv_has_15
	SetVar VAR_SPECIAL_RESULT, 1
_cv_has_15:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq EventScript_SetResultFalse
	GoTo EventScript_SetResultTrue
	End
	
VermilionCity_EventScript_HasMysticTicket:
	Call VermilionCity_EventScript_CheckHasAuroraTicket
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq VermilionCity_EventScript_HasMysticAndAuroraTickets
	CallIfUnset 0x20F3, VermilionCity_EventScript_ShowMysticTicket
	NPCMsg msg_0483_T06_VermilionCity_Text_BoardSeagallopFerry
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0483_T06_cv_mc_sevii_navel_0, 0
	ScrCmd_559 msg_0483_T06_cv_mc_sevii_navel_1, 1
	ScrCmd_559 msg_0483_T06_cv_mc_sevii_navel_2, 2
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_17
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_17:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq EventScript_SeviiDestinationsPage1
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq EventScript_SailToNavelRock
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq EventScript_CancelSail
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq EventScript_CancelSail
	CloseMsg
	End
	
VermilionCity_EventScript_CheckHasAuroraTicket:
	GoToIfUnset 0x20F4, EventScript_SetResultFalse
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x20F5, _cv_has_18
	SetVar VAR_SPECIAL_RESULT, 1
_cv_has_18:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq EventScript_SetResultFalse
	GoTo EventScript_SetResultTrue
	End
	
VermilionCity_EventScript_HasAuroraTicket:
	CallIfUnset 0x20F6, VermilionCity_EventScript_ShowAuroraTicket
	NPCMsg msg_0483_T06_VermilionCity_Text_BoardSeagallopFerry
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0483_T06_cv_mc_sevii_birth_0, 0
	ScrCmd_559 msg_0483_T06_cv_mc_sevii_birth_1, 1
	ScrCmd_559 msg_0483_T06_cv_mc_sevii_birth_2, 2
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_20
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_20:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq EventScript_SeviiDestinationsPage1
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq EventScript_SailToBirthIsland
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq EventScript_CancelSail
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq EventScript_CancelSail
	CloseMsg
	End
	
EventScript_SeviiDestinationsPage1:
	SetVar 0x8005, 0
	// TODO(gba) special DrawSeagallopDestinationMenu
	GoTo _cv_stop
	SetVar 0x8006, 0  // TODO(gba) specialvar GetSelectedSeagallopDestination
	GoTo _cv_stop
	CompareVarToValue 0x8006, 0
	GoToIfEq EventScript_SailToVermilionCity
	CompareVarToValue 0x8006, 1
	GoToIfEq EventScript_SailToOneIsland
	CompareVarToValue 0x8006, 2
	GoToIfEq EventScript_SailToTwoIsland
	CompareVarToValue 0x8006, 3
	GoToIfEq EventScript_SailToThreeIsland
	CompareVarToValue 0x8006, 4
	GoToIfEq EventScript_SailToFourIsland
	CompareVarToValue 0x8006, 254
	GoToIfEq EventScript_SeviiDestinationsPage2
	CompareVarToValue 0x8006, 127
	GoToIfEq EventScript_CancelSail
	End
	
EventScript_SailToOneIsland2:
	SetVar 0x8006, 1
	GoTo EventScript_SailToDest
	End
	
EventScript_SailToTwoIsland2:
	SetVar 0x8006, 2
	GoTo EventScript_SailToDest
	End
	
EventScript_SailToThreeIsland2:
	SetVar 0x8006, 3
	GoTo EventScript_SailToDest
	End
	
EventScript_CancelSail:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar IsPlayerLeftOfVermilionSailor
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq VermilionCity_EventScript_WalkUpPier
	ReleaseAll
	End
	
TypeTutor_EventScript_Bye:
	NPCMsg msg_0483_T06_TypeTutor_Text_Bye
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
	
VermilionCity_EventScript_WalkUpPier:
	CloseMsg
	ApplyMovement 6, Common_Movement_FaceOriginalDirection
	ApplyMovement obj_player, VermilionCity_Movement_WalkUp
	WaitMovement
	ReleaseAll
	End
	
GymHack_EventScript_GiveStatItemDone:
	Return
	
EventScript_SetResultFalse:
	SetVar VAR_SPECIAL_RESULT, 0
	Return
	
EventScript_SetResultTrue:
	SetVar VAR_SPECIAL_RESULT, 1
	Return
	
VermilionCity_EventScript_HasMysticAndAuroraTickets:
	CallIfUnset 0x20F3, VermilionCity_EventScript_ShowMysticTicket
	CallIfUnset 0x20F6, VermilionCity_EventScript_ShowAuroraTicket
	NPCMsg msg_0483_T06_VermilionCity_Text_BoardSeagallopFerry
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0483_T06_cv_mc_sevii_navel_birth_0, 0
	ScrCmd_559 msg_0483_T06_cv_mc_sevii_navel_birth_1, 1
	ScrCmd_559 msg_0483_T06_cv_mc_sevii_navel_birth_2, 2
	ScrCmd_559 msg_0483_T06_cv_mc_sevii_navel_birth_3, 3
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_22
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_22:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq EventScript_SeviiDestinationsPage1
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq EventScript_SailToNavelRock
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq EventScript_SailToBirthIsland
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfEq EventScript_CancelSail
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq EventScript_CancelSail
	CloseMsg
	End
	
VermilionCity_EventScript_ShowMysticTicket:
	SetFlag 0x20F3
	NPCMsg msg_0483_T06_VermilionCity_Text_OhMysticTicketTakeYouToNavelRock
	WaitButton
	Return
	
EventScript_SailToNavelRock:
	NPCMsg msg_0483_T06_VermilionCity_Text_Seagallop10Departing
	WaitButton
	SetVar 0x8004, 0
	SetVar 0x8006, 9
	GoTo EventScript_SetSail
	CloseMsg
	End
	
VermilionCity_EventScript_ShowAuroraTicket:
	SetFlag 0x20F6
	NPCMsg msg_0483_T06_VermilionCity_Text_OhAuroraTicketTakeYouToBirthIsland
	WaitButton
	Return
	
EventScript_SailToBirthIsland:
	NPCMsg msg_0483_T06_VermilionCity_Text_Seagallop12Departing
	WaitButton
	SetVar 0x8004, 0
	SetVar 0x8006, 10
	GoTo EventScript_SetSail
	CloseMsg
	End
	
EventScript_SailToVermilionCity:
	SetVar 0x8006, 0
	GoTo EventScript_SailToDest
	End
	
EventScript_SailToOneIsland:
	SetVar 0x8006, 1
	GoTo EventScript_SailToDest
	End
	
EventScript_SailToTwoIsland:
	SetVar 0x8006, 2
	GoTo EventScript_SailToDest
	End
	
EventScript_SailToThreeIsland:
	SetVar 0x8006, 3
	GoTo EventScript_SailToDest
	End
	
EventScript_SailToFourIsland:
	SetVar 0x8006, 4
	GoTo EventScript_SailToDest
	End
	
EventScript_SeviiDestinationsPage2:
	SetVar 0x8005, 1
	// TODO(gba) special DrawSeagallopDestinationMenu
	GoTo _cv_stop
	SetVar 0x8006, 0  // TODO(gba) specialvar GetSelectedSeagallopDestination
	GoTo _cv_stop
	CompareVarToValue 0x8006, 4
	GoToIfEq EventScript_SailToFourIsland
	CompareVarToValue 0x8006, 5
	GoToIfEq EventScript_SailToFiveIsland
	CompareVarToValue 0x8006, 6
	GoToIfEq EventScript_SailToSixIsland
	CompareVarToValue 0x8006, 7
	GoToIfEq EventScript_SailToSevenIsland
	CompareVarToValue 0x8006, 254
	GoToIfEq EventScript_SeviiDestinationsPage1
	CompareVarToValue 0x8006, 127
	GoToIfEq EventScript_CancelSail
	End
	
EventScript_SailToDest:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar GetSeagallopNumber
	GoTo _cv_stop
	BufferInt 0, VAR_SPECIAL_RESULT
	CompareVarToValue 0x8004, 0
	GoToIfEq EventScript_DepartingVermilion
	CompareVarToValue 0x8004, 0
	GoToIfNe EventScript_DepartingNotVermilion
	End
	
EventScript_SailToFiveIsland:
	SetVar 0x8006, 5
	GoTo EventScript_SailToDest
	End
	
EventScript_SailToSixIsland:
	SetVar 0x8006, 6
	GoTo EventScript_SailToDest
	End
	
EventScript_SailToSevenIsland:
	SetVar 0x8006, 7
	GoTo EventScript_SailToDest
	End
	
EventScript_DepartingVermilion:
	NPCMsg msg_0483_T06_VermilionCity_Text_Seagallop7Departing
	WaitButton
	GoTo EventScript_SetSail
	CloseMsg
	End
	
EventScript_DepartingNotVermilion:
	NPCMsg msg_0483_T06_Text_AllAboardSeagallopNum
	WaitButton
	GoTo EventScript_SetSail
	CloseMsg
	End

_cv_unported_14:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0483_T06_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_15:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0483_T06_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_str4:
	BufferPlayersName 6
	BufferRivalsName 7
	Return

_cv_stop:
	NPCMsg msg_0483_T06_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
VermilionCity_Movement_ExitSSAnne:
	WalkNormalNorth 2
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
Common_Movement_FaceOriginalDirection:
	EndMovement

	.balign 4, 0
VermilionCity_Movement_WalkUp:
	WalkNormalNorth
	EndMovement
	.balign 4, 0
