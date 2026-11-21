#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T06R0301.h"
#include "msgdata/msg/msg_0488_T06R0301.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's VermilionCity_PokemonFanClub_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef VermilionCity_PokemonFanClub_EventScript_Chairman
	ScrDef VermilionCity_PokemonFanClub_EventScript_WorkerF
	ScrDef VermilionCity_PokemonFanClub_EventScript_Pikachu
	ScrDef VermilionCity_PokemonFanClub_EventScript_Seel
	ScrDef VermilionCity_PokemonFanClub_EventScript_Woman
	ScrDef VermilionCity_PokemonFanClub_EventScript_FatMan
	ScrDef VermilionCity_PokemonFanClub_EventScript_RulesSign1
	ScrDef VermilionCity_PokemonFanClub_EventScript_RulesSign2
	ScrDefEnd
	
VermilionCity_PokemonFanClub_EventScript_Chairman:
	LockAll
	FacePlayer
	GoToIfSet 0x20E1, VermilionCity_PokemonFanClub_EventScript_AlreadyHeardStory
	NPCMsg msg_0488_T06R0301_VermilionCity_PokemonFanClub_Text_DidYouComeToHearAboutMyMons
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq VermilionCity_PokemonFanClub_EventScript_ChairmanStory
	NPCMsg msg_0488_T06R0301_VermilionCity_PokemonFanClub_Text_ComeBackToHearStory
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_PokemonFanClub_EventScript_WorkerF:
	LockAll
	FacePlayer
	GoToIfSet FLAG_GAME_CLEAR, VermilionCity_PokemonFanClub_EventScript_WorkerFGameClear
	NPCMsg msg_0488_T06R0301_VermilionCity_PokemonFanClub_Text_ChairmanVeryVocalAboutPokemon
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_PokemonFanClub_EventScript_Pikachu:
	LockAll
	FacePlayer
	WaitSE SEQ_SE_DP_SELECT
	PlayCry SPECIES_PIKACHU, 0
	NPCMsg msg_0488_T06R0301_VermilionCity_PokemonFanClub_Text_Pikachu
	WaitButton
	WaitCry
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_PokemonFanClub_EventScript_Seel:
	LockAll
	FacePlayer
	WaitSE SEQ_SE_DP_SELECT
	PlayCry SPECIES_SEEL, 0
	NPCMsg msg_0488_T06R0301_VermilionCity_PokemonFanClub_Text_Seel
	WaitButton
	WaitCry
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_PokemonFanClub_EventScript_Woman:
	LockAll
	FacePlayer
	GoToIfSet 3, VermilionCity_PokemonFanClub_EventScript_WomanSpokeToFatMan
	NPCMsg msg_0488_T06R0301_VermilionCity_PokemonFanClub_Text_AdoreMySeel
	WaitButton
	CanvasCloseMsg
	ApplyMovement 5, Common_Movement_FaceOriginalDirection
	WaitMovement
	SetFlag 2
	CanvasCloseMsg
	ReleaseAll
	End
	
VermilionCity_PokemonFanClub_EventScript_FatMan:
	LockAll
	FacePlayer
	GoToIfSet 2, VermilionCity_PokemonFanClub_EventScript_FatManSpokeToWoman
	NPCMsg msg_0488_T06R0301_VermilionCity_PokemonFanClub_Text_AdmirePikachusTail
	WaitButton
	CanvasCloseMsg
	ApplyMovement 6, Common_Movement_FaceOriginalDirection
	WaitMovement
	SetFlag 3
	CanvasCloseMsg
	ReleaseAll
	End
	
VermilionCity_PokemonFanClub_EventScript_RulesSign1:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0488_T06R0301_VermilionCity_PokemonFanClub_Text_ListenPolitelyToOtherTrainers
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_PokemonFanClub_EventScript_RulesSign2:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0488_T06R0301_VermilionCity_PokemonFanClub_Text_SomeoneBragsBragBack
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_PokemonFanClub_EventScript_AlreadyHeardStory:
	BufferPlayersName 6
	NPCMsg msg_0488_T06R0301_VermilionCity_PokemonFanClub_Text_DidntComeToSeeAboutMonsAgain
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_PokemonFanClub_EventScript_ChairmanStory:
	NPCMsg msg_0488_T06R0301_VermilionCity_PokemonFanClub_Text_ChairmansStory
	WaitButton
	SetVar VAR_SPECIAL_RESULT, 1
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq VermilionCity_PokemonFanClub_EventScript_NoRoomForBikeVoucher
	SetFlag 0x20E1
	SetFlag 0x20E2
	SetVar VAR_SPECIAL_RESULT, 1
	BufferItemName 1, 0
	BufferPlayersName 6
	NPCMsg msg_0488_T06R0301_VermilionCity_PokemonFanClub_Text_ReceivedBikeVoucherFromChairman
	PlayFanfare SEQ_ME_ITEM
	WaitFanfare
	WaitButton
	NPCMsg msg_0488_T06R0301_VermilionCity_PokemonFanClub_Text_ExplainBikeVoucher
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_PokemonFanClub_EventScript_WorkerFGameClear:
	NPCMsg msg_0488_T06R0301_VermilionCity_PokemonFanClub_Text_ChairmanReallyAdoresHisMons
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
VermilionCity_PokemonFanClub_EventScript_WomanSpokeToFatMan:
	NPCMsg msg_0488_T06R0301_VermilionCity_PokemonFanClub_Text_SeelFarMoreAttractive
	WaitButton
	CanvasCloseMsg
	ApplyMovement 5, Common_Movement_FaceOriginalDirection
	WaitMovement
	ClearFlag 3
	CanvasCloseMsg
	ReleaseAll
	End
	
VermilionCity_PokemonFanClub_EventScript_FatManSpokeToWoman:
	NPCMsg msg_0488_T06R0301_VermilionCity_PokemonFanClub_Text_PikachuTwiceAsCute
	WaitButton
	CanvasCloseMsg
	ApplyMovement 6, Common_Movement_FaceOriginalDirection
	WaitMovement
	ClearFlag 2
	CanvasCloseMsg
	ReleaseAll
	End
	
VermilionCity_PokemonFanClub_EventScript_NoRoomForBikeVoucher:
	NPCMsg msg_0488_T06R0301_VermilionCity_PokemonFanClub_Text_MakeRoomForThis
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0488_T06R0301_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
Common_Movement_FaceOriginalDirection:
	EndMovement
	.balign 4, 0
