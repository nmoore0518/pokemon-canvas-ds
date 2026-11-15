#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_FIGHT_AREA_UNUSED_1.h"
#include "msgdata/msg/msg_0855_CV_FIGHT_AREA_UNUSED_1.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's PalletTown_House2_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef PalletTown_House2_EventScript_Woman
	ScrDef PalletTown_House2_EventScript_LittleGirl
	ScrDef PalletTown_House2_EventScript_Meowth
	ScrDef PalletTown_House2_EventScript_Sign
	ScrDefEnd
	
PalletTown_House2_EventScript_Woman:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0855_CV_FIGHT_AREA_UNUSED_1_PalletTown_House2_Text_NewShops
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_House2_EventScript_LittleGirl:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0855_CV_FIGHT_AREA_UNUSED_1_PalletTown_House2_Text_Waterfall
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
PalletTown_House2_EventScript_Meowth:
	LockAll
	FacePlayer
	WaitSE SEQ_SE_DP_SELECT
	PlayCry SPECIES_MEOWTH, 0
	NPCMsg msg_0855_CV_FIGHT_AREA_UNUSED_1_PalletTown_House2_Text_Meowth
	WaitButton
	WaitCry
	CloseMsg
	ReleaseAll
	End
	
PalletTown_House2_EventScript_Sign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0855_CV_FIGHT_AREA_UNUSED_1_PalletTown_House2_Text_Sign
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0855_CV_FIGHT_AREA_UNUSED_1_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
