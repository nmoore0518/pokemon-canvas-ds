#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_POKEMON_TOWER_6F.h"
#include "msgdata/msg/msg_0890_CV_CANVAS_POKEMON_TOWER_6F.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PokemonTower_6F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef PokemonTower_6F_EventScript_Angelica
	ScrDef PokemonTower_6F_EventScript_ItemRareCandy
	ScrDef PokemonTower_6F_EventScript_ItemXAccuracy
	ScrDef BerryField_EventScript_FindGhost
	ScrDef _cv_unported_4
	ScrDefEnd
	
PokemonTower_6F_EventScript_Angelica:
	CheckTrainerFlag 1172
	GoToIf TRUE, _cv_beaten_1
	NPCMsg msg_0890_CV_CANVAS_POKEMON_TOWER_6F_PokemonTower_6F_Text_AngelicaIntro
	WaitButton
	CloseMsg
	TrainerBattle 1172, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_2
	WhiteOut
	End
_cv_won_2:
	SetTrainerFlag 1172
	GoTo GymCandidate_EventScript_RecruitGhost
_cv_beaten_1:
	SetVar 0x8004, 8
	Call GymCandidate_EventScript_RecruitOffer
	NPCMsg msg_0890_CV_CANVAS_POKEMON_TOWER_6F_PokemonTower_6F_Text_AngelicaPostBattle
	WaitButton
	CloseMsg
	End
	
PokemonTower_6F_EventScript_ItemRareCandy:
	SetVar 0x8004, ITEM_RARE_CANDY
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
PokemonTower_6F_EventScript_ItemXAccuracy:
	SetVar 0x8004, ITEM_X_ACCURACY
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
BerryField_EventScript_FindGhost:
	SetVar 0x8004, ITEM_KASIB_BERRY
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End
	
PokemonTower_6F_EventScript_MarowakGhost:
	LockAll
	NPCMsg msg_0890_CV_CANVAS_POKEMON_TOWER_6F_PokemonTower_6F_Text_BeGoneIntruders
	WaitButton
	// TODO(gba) special StartMarowakBattle
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq PokemonTower_6F_EventScript_DefeatedMarowakGhost
	ApplyMovement obj_player, PokemonTower_6F_Movement_ForcePlayerUp
	WaitMovement
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_RecruitGhost:
	SetVar 0x8004, 8
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
	GoToIfEq _cv_yes_3
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_4
_cv_yes_3:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq GymCandidate_EventScript_RecruitDeclined
	// TODO(gba) special GymCandidate_Recruit
	GoTo _cv_stop
	PlayFanfare SEQ_ME_ITEM
	NPCMsg msg_0890_CV_CANVAS_POKEMON_TOWER_6F_GymCandidate_Text_RecruitJoined
	WaitButton
	WaitFanfare
	NPCMsg msg_0890_CV_CANVAS_POKEMON_TOWER_6F_GymCandidate_Text_RecruitHowToPlace
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PokemonTower_6F_EventScript_DefeatedMarowakGhost:
	NPCMsg msg_0890_CV_CANVAS_POKEMON_TOWER_6F_PokemonTower_6F_Text_GhostWasCubonesMother
	WaitSE SEQ_SE_DP_SELECT
	PlayCry SPECIES_MAROWAK, 0
	WaitButton
	WaitCry
	NPCMsg msg_0890_CV_CANVAS_POKEMON_TOWER_6F_PokemonTower_6F_Text_MothersSpiritWasCalmed
	WaitButton
	SetVar 0x503E, 1
	CloseMsg
	ReleaseAll
	End
	
GymCandidate_EventScript_RecruitAfterBattle:
	Call GymCandidate_EventScript_RecruitOffer
	ReleaseAll
	End
	
GymCandidate_EventScript_Return:
	Return
	
GymCandidate_EventScript_RecruitDeclined:
	NPCMsg msg_0890_CV_CANVAS_POKEMON_TOWER_6F_GymCandidate_Text_RecruitDeclined
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_unported_4:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0890_CV_CANVAS_POKEMON_TOWER_6F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_str4:
	BufferPlayersName 6
	BufferRivalsName 7
	Return

_cv_stop:
	NPCMsg msg_0890_CV_CANVAS_POKEMON_TOWER_6F_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End

	.balign 4, 0
PokemonTower_6F_Movement_ForcePlayerUp:
	WalkNormalNorth
	EndMovement
	.balign 4, 0
