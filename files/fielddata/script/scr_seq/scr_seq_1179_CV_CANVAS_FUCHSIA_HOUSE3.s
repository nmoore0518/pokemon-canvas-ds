#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_FUCHSIA_HOUSE3.h"
#include "msgdata/msg/msg_0961_CV_CANVAS_FUCHSIA_HOUSE3.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's FuchsiaCity_House3_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef FuchsiaCity_House3_EventScript_MoveDeleter
	ScrDef TrainingHouse_EventScript_Augustus
	ScrDefEnd
	
FuchsiaCity_House3_EventScript_MoveDeleter:
	LockAll
	FacePlayer
	NPCMsg msg_0961_CV_CANVAS_FUCHSIA_HOUSE3_FuchsiaCity_House3_Text_WouldYouLikeToForgetMove
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_1
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_2
_cv_yes_1:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_2:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq FuchsiaCity_House3_EventScript_ChooseMonForMoveDeleter
	GoTo FuchsiaCity_House3_EventScript_CancelForgetMove
	CloseMsg
	End
	
TrainingHouse_EventScript_Augustus:
	LockAll
	FacePlayer
	NPCMsg msg_0961_CV_CANVAS_FUCHSIA_HOUSE3_TrainingHouse_Text_AugustusIntro
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_3
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_4
_cv_yes_3:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_4:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq TrainingHouse_EventScript_Declined
	ClearTrainerFlag 1458
	CheckTrainerFlag 1458
	GoToIf TRUE, _cv_beaten_5
	TrainerBattle 1458, 0, 0, 0
	CheckBattleWon VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfNe _cv_won_6
	WhiteOut
	End
_cv_won_6:
	SetTrainerFlag 1458
	ReleaseAll
	End
_cv_beaten_5:
	NPCMsg msg_0961_CV_CANVAS_FUCHSIA_HOUSE3_TrainingHouse_Text_After
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_House3_EventScript_ChooseMonForMoveDeleter:
	NPCMsg msg_0961_CV_CANVAS_FUCHSIA_HOUSE3_FuchsiaCity_House3_Text_WhichMonShouldForgetMove
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
	GoToIfGe FuchsiaCity_House3_EventScript_CancelForgetMove
	// TODO(gba) special IsSelectedMonEgg
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq FuchsiaCity_House3_EventScript_CantForgetMoveEgg
	// TODO(gba) special GetNumMovesSelectedMonHas
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq FuchsiaCity_House3_EventScript_CantForgetOnlyMove
	NPCMsg msg_0961_CV_CANVAS_FUCHSIA_HOUSE3_FuchsiaCity_House3_Text_WhichMoveShouldBeForgotten
	WaitButton
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	// TODO(gba) special MoveDeleterChooseMoveToForget
	GoTo _cv_stop
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	CompareVarToValue 0x8005, 4
	GoToIfEq FuchsiaCity_House3_EventScript_ChooseMonForMoveDeleter
	// TODO(gba) special BufferMoveDeleterNicknameAndMove
	GoTo _cv_stop
	NPCMsg msg_0961_CV_CANVAS_FUCHSIA_HOUSE3_FuchsiaCity_House3_Text_MonsMoveShouldBeForgotten
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_7
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_8
_cv_yes_7:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_8:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq FuchsiaCity_House3_EventScript_ForgetMove
	GoTo FuchsiaCity_House3_EventScript_CancelForgetMove
	CloseMsg
	End
	
FuchsiaCity_House3_EventScript_CancelForgetMove:
	NPCMsg msg_0961_CV_CANVAS_FUCHSIA_HOUSE3_FuchsiaCity_House3_Text_ComeAgainToForgetOtherMoves
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
TrainingHouse_EventScript_Declined:
	NPCMsg msg_0961_CV_CANVAS_FUCHSIA_HOUSE3_TrainingHouse_Text_Declined
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_House3_EventScript_CantForgetMoveEgg:
	NPCMsg msg_0961_CV_CANVAS_FUCHSIA_HOUSE3_FuchsiaCity_House3_Text_NoEggShouldKnowMoves
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_House3_EventScript_CantForgetOnlyMove:
	// TODO(gba) special BufferMoveDeleterNicknameAndMove
	GoTo _cv_stop
	NPCMsg msg_0961_CV_CANVAS_FUCHSIA_HOUSE3_FuchsiaCity_House3_Text_MonOnlyKnowsOneMove
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
FuchsiaCity_House3_EventScript_ForgetMove:
	// TODO(gba) special MoveDeleterForgetMove
	GoTo _cv_stop
	PlayFanfare SEQ_ME_ITEM
	WaitFanfare
	NPCMsg msg_0961_CV_CANVAS_FUCHSIA_HOUSE3_FuchsiaCity_House3_Text_MonHasForgottenMoveCompletely
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0961_CV_CANVAS_FUCHSIA_HOUSE3_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
