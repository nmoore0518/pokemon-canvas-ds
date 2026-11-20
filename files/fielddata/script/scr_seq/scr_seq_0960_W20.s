#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_W20.h"
#include "msgdata/msg/msg_0742_W20.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's Route20_Frlg#world by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef Route20_EventScript_Nora
	ScrDef Route20_EventScript_Shirley
	ScrDef Route20_EventScript_Camper
	ScrDef Route20_EventScript_SeafoamIslandsSign
	ScrDef Route20_OnTransition
	ScrDefEnd
	
Route20_EventScript_Nora:
	CheckTrainerFlag 1016
	GoToIf TRUE, _cv_beaten_1
	NPCMsg msg_0742_W20_Route20_Text_NoraIntro
	WaitButton
	CloseMsg
	TrainerBattle 1016, 1016, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_2
	WhiteOut
	End
_cv_won_2:
	SetTrainerFlag 1016
	GoTo GymCandidate_EventScript_RecruitIce
_cv_beaten_1:
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Route20_EventScript_NoraRematch
	SetVar 0x8004, 16
	Call GymCandidate_EventScript_RecruitOffer
	NPCMsg msg_0742_W20_Route20_Text_NoraPostBattle
	WaitButton
	CloseMsg
	End
	
Route20_EventScript_Shirley:
	CheckTrainerFlag 1024
	GoToIf TRUE, _cv_beaten_3
	NPCMsg msg_0742_W20_Route20_Text_ShirleyIntro
	WaitButton
	CloseMsg
	TrainerBattle 1024, 1024, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_4
	WhiteOut
	End
_cv_won_4:
	SetTrainerFlag 1024
	GoTo GymCandidate_EventScript_RecruitDragon
_cv_beaten_3:
	SetVar VAR_SPECIAL_RESULT, 0
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq Route20_EventScript_ShirleyRematch
	SetVar 0x8004, 17
	Call GymCandidate_EventScript_RecruitOffer
	NPCMsg msg_0742_W20_Route20_Text_ShirleyPostBattle
	WaitButton
	CloseMsg
	End
	
Route20_EventScript_Camper:
	LockAll
	FacePlayer
	NPCMsg msg_0742_W20_Route20_Text_MistyTrainsHere
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route20_EventScript_SeafoamIslandsSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0742_W20_Route20_Text_SeafoamIslands
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
Route20_OnTransition:
	CallIfUnset 0x2110, Route20_EventScript_ResetSeafoamBouldersForB3F
	CallIfUnset 0x2111, Route20_EventScript_ResetSeafoamBouldersForB4F
	End
	
GymCandidate_EventScript_RecruitIce:
	SetVar 0x8004, 16
	GoTo GymCandidate_EventScript_RecruitAfterBattle
	End
	
Route20_EventScript_NoraRematch:
	// (rematches come later)
	ReleaseAll
	End
	NPCMsg msg_0742_W20_Route20_Text_NoraPostBattle
	WaitButton
	CloseMsg
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
	GoToIfEq _cv_yes_5
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_6
_cv_yes_5:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_6:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_RecruitDeclined
	// TODO(gba) special GymCandidate_Recruit
	GoTo _cv_stop
	PlayFanfare SEQ_ME_ITEM
	NPCMsg msg_0742_W20_GymCandidate_Text_RecruitJoined
	WaitButton
	WaitFanfare
	NPCMsg msg_0742_W20_GymCandidate_Text_RecruitHowToPlace
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_RecruitDragon:
	SetVar 0x8004, 17
	GoTo GymCandidate_EventScript_RecruitAfterBattle
	End
	
Route20_EventScript_ShirleyRematch:
	// (rematches come later)
	ReleaseAll
	End
	NPCMsg msg_0742_W20_Route20_Text_ShirleyPostBattle
	WaitButton
	CloseMsg
	End
	
Route20_EventScript_ResetSeafoamBouldersForB3F:
	ClearFlag 0x2112
	ClearFlag 0x2113
	SetFlag 0x2114
	SetFlag 0x2115
	SetFlag 0x2116
	SetFlag 0x2117
	SetFlag 0x2118
	SetFlag 0x2119
	Return
	
Route20_EventScript_ResetSeafoamBouldersForB4F:
	ClearFlag 0x211A
	ClearFlag 0x211B
	ClearFlag 0x211C
	ClearFlag 0x211D
	SetFlag 0x211E
	SetFlag 0x211F
	Return
	
GymCandidate_EventScript_RecruitAfterBattle:
	Call GymCandidate_EventScript_RecruitOffer
	ReleaseAll
	End
	
GymCandidate_EventScript_Return:
	Return
	
GymCandidate_EventScript_RecruitDeclined:
	NPCMsg msg_0742_W20_GymCandidate_Text_RecruitDeclined
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_str4:
	BufferPlayersName 6
	BufferRivalsName 7
	Return

_cv_stop:
	NPCMsg msg_0742_W20_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
