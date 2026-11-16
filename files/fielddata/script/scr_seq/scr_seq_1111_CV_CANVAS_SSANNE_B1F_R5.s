#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_SSANNE_B1F_R5.h"
#include "msgdata/msg/msg_0927_CV_CANVAS_SSANNE_B1F_R5.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's SSAnne_B1F_Room5_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef SSAnne_B1F_Room5_EventScript_Boy
	ScrDef SSAnne_B1F_Room5_EventScript_Machoke
	ScrDef SSAnne_B1F_Room5_EventScript_ItemSuperPotion
	ScrDefEnd
	
SSAnne_B1F_Room5_EventScript_Boy:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0927_CV_CANVAS_SSANNE_B1F_R5_SSAnne_B1F_Room5_Text_MachokeHasStrengthToMoveRocks
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
SSAnne_B1F_Room5_EventScript_Machoke:
	LockAll
	FacePlayer
	WaitSE SEQ_SE_DP_SELECT
	PlayCry SPECIES_MACHOKE, 0
	NPCMsg msg_0927_CV_CANVAS_SSANNE_B1F_R5_SSAnne_B1F_Room5_Text_Machoke
	WaitButton
	WaitCry
	CloseMsg
	ReleaseAll
	End
	
SSAnne_B1F_Room5_EventScript_ItemSuperPotion:
	SetVar 0x8004, ITEM_SUPER_POTION
	SetVar 0x8005, 1
	CallStd std_obtain_item_verbose
	HidePerson VAR_SPECIAL_LAST_TALKED
	End

_cv_stop:
	NPCMsg msg_0927_CV_CANVAS_SSANNE_B1F_R5_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
