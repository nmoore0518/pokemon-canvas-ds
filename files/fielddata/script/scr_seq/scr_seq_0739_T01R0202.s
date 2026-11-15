#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T01R0202.h"
#include "msgdata/msg/msg_0450_T01R0202.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PalletTown_House1_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef PalletTown_House1_EventScript_OldMan
	ScrDef EventMons_EventScript_CapBoy
	ScrDef PalletTown_House1_EventScript_Pidgey
	ScrDef PalletTown_House1_EventScript_Sign
	ScrDefEnd
	
PalletTown_House1_EventScript_OldMan:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0450_T01R0202_PalletTown_House1_Text_GymOnTheHill
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventMons_EventScript_CapBoy:
	LockAll
	FacePlayer
	SetVar VAR_SPECIAL_RESULT, 0
	GoToIfUnset 0x202B, _cv_has_1
	SetVar VAR_SPECIAL_RESULT, 1
_cv_has_1:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq EventMons_EventScript_CapBoyRewards
	NPCMsg msg_0450_T01R0202_EventMons_Text_CapBoyIntro
	WaitButton
	SetFlag 0x202B
	SetVar VAR_SPECIAL_RESULT, 1
	NPCMsg msg_0450_T01R0202_EventMons_Text_CapBoyCase
	WaitButton
	End
	
PalletTown_House1_EventScript_Pidgey:
	LockAll
	FacePlayer
	WaitSE SEQ_SE_DP_SELECT
	PlayCry SPECIES_PIDGEY, 0
	NPCMsg msg_0450_T01R0202_PalletTown_House1_Text_Pidgey
	WaitButton
	WaitCry
	CloseMsg
	ReleaseAll
	End
	
PalletTown_House1_EventScript_Sign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0450_T01R0202_PalletTown_House1_Text_Sign
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventMons_EventScript_CapBoyRewards:
	// TODO(gba) special EventMons_CapReward
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, SPECIES_NONE
	GoToIfEq EventMons_EventScript_CapBoyHint
	CopyVar 0x8009, 0x8005
	CopyVar 0x800A, VAR_SPECIAL_RESULT
	CompareVarToValue 0x8005, 7
	GoToIfEq EventMons_EventScript_CapBoyPartner
	NPCMsg msg_0450_T01R0202_EventMons_Text_CapBoyThanks
	WaitButton
	GoTo EventMons_EventScript_CapBoyGive
	
EventMons_EventScript_CapBoyHint:
	// TODO(gba) special EventMons_CapHint
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq EventMons_EventScript_CapBoyDone
	BufferInt 2, VAR_SPECIAL_RESULT
	NPCMsg msg_0450_T01R0202_EventMons_Text_CapBoyHint
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventMons_EventScript_CapBoyPartner:
	NPCMsg msg_0450_T01R0202_EventMons_Text_CapBoyAll
	WaitButton
	End
	
EventMons_EventScript_CapBoyGive:
	CopyVar 0x8004, 0x800A
	SetVar 0x8005, 5
	SetVar 0x8006, 0
	Call EventMons_EventScript_Gift
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq EventMons_EventScript_ReleaseEnd
	CopyVar 0x8005, 0x8009
	// TODO(gba) special EventMons_CapRewardGiven
	GoTo _cv_stop
	GoTo EventMons_EventScript_CapBoyRewards
	
EventMons_EventScript_CapBoyDone:
	NPCMsg msg_0450_T01R0202_EventMons_Text_CapBoyDone
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventMons_EventScript_Gift:
	// TODO(gba) special EventMons_GiveMon
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq EventMons_EventScript_GiftFull
	PlayFanfare SEQ_ME_LVUP
	BufferPlayersName 6
	NPCMsg msg_0450_T01R0202_EventMons_Text_Received
	WaitFanfare
	SetVar VAR_SPECIAL_RESULT, 1
	Return
	
EventMons_EventScript_ReleaseEnd:
	ReleaseAll
	End
	
EventMons_EventScript_GiftFull:
	NPCMsg msg_0450_T01R0202_EventMons_Text_NoRoom
	WaitButton
	SetVar VAR_SPECIAL_RESULT, 0
	Return

_cv_stop:
	NPCMsg msg_0450_T01R0202_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
