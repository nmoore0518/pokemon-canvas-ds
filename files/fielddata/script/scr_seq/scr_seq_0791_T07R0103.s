#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T07R0103.h"
#include "msgdata/msg/msg_0496_T07R0103.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's CeladonCity_DepartmentStore_3F_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef CeladonCity_DepartmentStore_3F_EventScript_CounterTutor
	ScrDef CeladonCity_DepartmentStore_3F_EventScript_GBAKid1
	ScrDef CeladonCity_DepartmentStore_3F_EventScript_GBAKid3
	ScrDef CeladonCity_DepartmentStore_3F_EventScript_GBAKid2
	ScrDef CeladonCity_DepartmentStore_3F_EventScript_LittleGirl
	ScrDef CeladonCity_DepartmentStore_3F_EventScript_FloorSign
	ScrDef CeladonCity_DepartmentStore_3F_EventScript_TV1
	ScrDef CeladonCity_DepartmentStore_3F_EventScript_TV2
	ScrDef CeladonCity_DepartmentStore_3F_EventScript_TV3
	ScrDef CeladonCity_DepartmentStore_3F_EventScript_TV4
	ScrDef CeladonCity_DepartmentStore_3F_EventScript_SuperNES
	ScrDef CeladonCity_DepartmentStore_3F_EventScript_Poster
	ScrDefEnd
	
CeladonCity_DepartmentStore_3F_EventScript_CounterTutor:
	GoTo EventScript_CounterTutor
	End
	
CeladonCity_DepartmentStore_3F_EventScript_GBAKid1:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0496_T07R0103_CeladonCity_DepartmentStore_3F_Text_OTStandsForOriginalTrainer
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_DepartmentStore_3F_EventScript_GBAKid3:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0496_T07R0103_CeladonCity_DepartmentStore_3F_Text_HaunterEvolvedOnTrade
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_DepartmentStore_3F_EventScript_GBAKid2:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0496_T07R0103_CeladonCity_DepartmentStore_3F_Text_BuddyTradingKangaskhanForHaunter
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_DepartmentStore_3F_EventScript_LittleGirl:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0496_T07R0103_CeladonCity_DepartmentStore_3F_Text_CanIdentifyTradeMonsByID
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_DepartmentStore_3F_EventScript_FloorSign:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0496_T07R0103_CeladonCity_DepartmentStore_3F_Text_TVGameShop
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_DepartmentStore_3F_EventScript_TV1:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0496_T07R0103_CeladonCity_DepartmentStore_3F_Text_AnRPG
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_DepartmentStore_3F_EventScript_TV2:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0496_T07R0103_CeladonCity_DepartmentStore_3F_Text_SportsGame
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_DepartmentStore_3F_EventScript_TV3:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0496_T07R0103_CeladonCity_DepartmentStore_3F_Text_PuzzleGame
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_DepartmentStore_3F_EventScript_TV4:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0496_T07R0103_CeladonCity_DepartmentStore_3F_Text_FightingGame
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_DepartmentStore_3F_EventScript_SuperNES:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0496_T07R0103_CeladonCity_DepartmentStore_3F_Text_ItsSuperNES
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_DepartmentStore_3F_EventScript_Poster:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	NPCMsg msg_0496_T07R0103_CeladonCity_DepartmentStore_3F_Text_RedGreenBothArePokemon
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
EventScript_CounterTutor:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0496_T07R0103_Text_CounterTutor_Retired
	WaitButton
	CloseMsg
	ReleaseAll
	End

_cv_stop:
	NPCMsg msg_0496_T07R0103_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
