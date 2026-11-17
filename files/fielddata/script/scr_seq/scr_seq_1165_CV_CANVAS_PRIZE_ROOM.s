#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_CV_CANVAS_PRIZE_ROOM.h"
#include "msgdata/msg/msg_0954_CV_CANVAS_PRIZE_ROOM.h"
#include "macros/script.inc"

// Pokemon Canvas: ported from the GBA game's CeladonCity_GameCorner_PrizeRoom_Frlg by tools/canvas/port/port_map.py. Edit the GBA scripts
// or the porter, not this file.

	ScrDef CeladonCity_GameCorner_PrizeRoom_EventScript_BaldingMan
	ScrDef CeladonCity_GameCorner_PrizeRoom_EventScript_OldMan
	ScrDef CeladonCity_GameCorner_PrizeRoom_EventScript_PrizeClerkMons
	ScrDef CeladonCity_GameCorner_PrizeRoom_EventScript_PrizeClerkTMs
	ScrDef CeladonCity_GameCorner_PrizeRoom_EventScript_PrizeClerkItems
	ScrDefEnd
	
CeladonCity_GameCorner_PrizeRoom_EventScript_BaldingMan:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0954_CV_CANVAS_PRIZE_ROOM_CeladonCity_GameCorner_PrizeRoom_Text_FancyThatPorygon
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_OldMan:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0954_CV_CANVAS_PRIZE_ROOM_CeladonCity_GameCorner_PrizeRoom_Text_RakedItInToday
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_PrizeClerkMons:
	LockAll
	FacePlayer
	GoToIfUnset 0x2136, CeladonCity_GameCorner_PrizeRoom_EventScript_NeedCoinCase
	// TODO(gba) showcoinsbox 0, 0
	GoTo _cv_stop
	NPCMsg msg_0954_CV_CANVAS_PRIZE_ROOM_CeladonCity_GameCorner_PrizeRoom_Text_WeExchangeCoinsForPrizes
	WaitButton
	GoTo CeladonCity_GameCorner_PrizeRoom_EventScript_ChoosePrizeMon
	CloseMsg
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_PrizeClerkTMs:
	LockAll
	FacePlayer
	GoToIfUnset 0x2136, CeladonCity_GameCorner_PrizeRoom_EventScript_NeedCoinCase
	// TODO(gba) showcoinsbox 0, 0
	GoTo _cv_stop
	NPCMsg msg_0954_CV_CANVAS_PRIZE_ROOM_CeladonCity_GameCorner_PrizeRoom_Text_WeExchangeCoinsForPrizes
	WaitButton
	GoTo CeladonCity_GameCorner_PrizeRoom_EventScript_ChoosePrizeTM
	CloseMsg
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_PrizeClerkItems:
	LockAll
	FacePlayer
	GoToIfUnset 0x2136, CeladonCity_GameCorner_PrizeRoom_EventScript_NeedCoinCase
	// TODO(gba) showcoinsbox 0, 0
	GoTo _cv_stop
	NPCMsg msg_0954_CV_CANVAS_PRIZE_ROOM_CeladonCity_GameCorner_PrizeRoom_Text_WeExchangeCoinsForPrizes
	WaitButton
	GoTo CeladonCity_GameCorner_PrizeRoom_EventScript_ChoosePrizeItem
	CloseMsg
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_NeedCoinCase:
	NPCMsg msg_0954_CV_CANVAS_PRIZE_ROOM_CeladonCity_GameCorner_PrizeRoom_Text_CoinCaseRequired
	WaitButton
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_ChoosePrizeMon:
	NPCMsg msg_0954_CV_CANVAS_PRIZE_ROOM_CeladonCity_GameCorner_PrizeRoom_Text_WhichPrize
	TouchscreenMenuHide
_cv_page_1:
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0954_CV_CANVAS_PRIZE_ROOM_cv_mc_game_corner_pokemon_prizes_0, 0
	ScrCmd_559 msg_0954_CV_CANVAS_PRIZE_ROOM_cv_mc_game_corner_pokemon_prizes_1, 1
	ScrCmd_559 msg_0954_CV_CANVAS_PRIZE_ROOM_cv_mc_game_corner_pokemon_prizes_2, 2
	ScrCmd_559 msg_0954_CV_CANVAS_PRIZE_ROOM_cv_mc_game_corner_pokemon_prizes_3, 3
	ScrCmd_559 msg_0954_CV_CANVAS_PRIZE_ROOM_cv_mc_game_corner_pokemon_prizes_4, 4
	ScrCmd_559 msg_0954_CV_CANVAS_PRIZE_ROOM_cv_mc_game_corner_pokemon_prizes_5, 5
	ScrCmd_559 msg_0954_CV_CANVAS_PRIZE_ROOM_cv_more, 254
	ScrCmd_067
	CompareVarToValue VAR_SPECIAL_RESULT, 254
	GoToIfEq _cv_page_2
	GoTo _cv_page_2_end
_cv_page_2:
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0954_CV_CANVAS_PRIZE_ROOM_cv_mc_game_corner_pokemon_prizes_6, 6
	ScrCmd_559 msg_0954_CV_CANVAS_PRIZE_ROOM_cv_mc_game_corner_pokemon_prizes_7, 7
	ScrCmd_559 msg_0954_CV_CANVAS_PRIZE_ROOM_cv_mc_game_corner_pokemon_prizes_8, 8
	ScrCmd_559 msg_0954_CV_CANVAS_PRIZE_ROOM_cv_mc_game_corner_pokemon_prizes_9, 9
	ScrCmd_559 msg_0954_CV_CANVAS_PRIZE_ROOM_cv_more, 254
	ScrCmd_067
	CompareVarToValue VAR_SPECIAL_RESULT, 254
	GoToIfEq _cv_page_1
_cv_page_2_end:
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_3
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_3:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CeladonCity_GameCorner_PrizeRoom_EventScript_Abra
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq CeladonCity_GameCorner_PrizeRoom_EventScript_Clefairy
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq CeladonCity_GameCorner_PrizeRoom_EventScript_DratiniPinsir
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfEq CeladonCity_GameCorner_PrizeRoom_EventScript_ScytherDratini
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfEq CeladonCity_GameCorner_PrizeRoom_EventScript_Porygon
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfEq CeladonCity_GameCorner_PrizeRoom_EventScript_EndPrizeExchange
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq CeladonCity_GameCorner_PrizeRoom_EventScript_EndPrizeExchange
	CloseMsg
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_ChoosePrizeTM:
	NPCMsg msg_0954_CV_CANVAS_PRIZE_ROOM_CeladonCity_GameCorner_PrizeRoom_Text_WhichPrize
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0954_CV_CANVAS_PRIZE_ROOM_cv_mc_game_corner_tmprizes_0, 0
	ScrCmd_559 msg_0954_CV_CANVAS_PRIZE_ROOM_cv_mc_game_corner_tmprizes_1, 1
	ScrCmd_559 msg_0954_CV_CANVAS_PRIZE_ROOM_cv_mc_game_corner_tmprizes_2, 2
	ScrCmd_559 msg_0954_CV_CANVAS_PRIZE_ROOM_cv_mc_game_corner_tmprizes_3, 3
	ScrCmd_559 msg_0954_CV_CANVAS_PRIZE_ROOM_cv_mc_game_corner_tmprizes_4, 4
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_5
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_5:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CeladonCity_GameCorner_PrizeRoom_EventScript_TM13
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq CeladonCity_GameCorner_PrizeRoom_EventScript_TM23
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq CeladonCity_GameCorner_PrizeRoom_EventScript_TM24
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfEq CeladonCity_GameCorner_PrizeRoom_EventScript_TM30
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfEq CeladonCity_GameCorner_PrizeRoom_EventScript_TM35
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfEq CeladonCity_GameCorner_PrizeRoom_EventScript_EndPrizeExchange
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq CeladonCity_GameCorner_PrizeRoom_EventScript_EndPrizeExchange
	CloseMsg
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_ChoosePrizeItem:
	NPCMsg msg_0954_CV_CANVAS_PRIZE_ROOM_CeladonCity_GameCorner_PrizeRoom_Text_WhichPrize
	TouchscreenMenuHide
	ScrCmd_065 1, 1, 0, 1, VAR_SPECIAL_RESULT
	ScrCmd_559 msg_0954_CV_CANVAS_PRIZE_ROOM_cv_mc_game_corner_battle_item_prizes_0, 0
	ScrCmd_559 msg_0954_CV_CANVAS_PRIZE_ROOM_cv_mc_game_corner_battle_item_prizes_1, 1
	ScrCmd_559 msg_0954_CV_CANVAS_PRIZE_ROOM_cv_mc_game_corner_battle_item_prizes_2, 2
	ScrCmd_559 msg_0954_CV_CANVAS_PRIZE_ROOM_cv_mc_game_corner_battle_item_prizes_3, 3
	ScrCmd_559 msg_0954_CV_CANVAS_PRIZE_ROOM_cv_mc_game_corner_battle_item_prizes_4, 4
	ScrCmd_067
	TouchscreenMenuShow
	CompareVarToValue VAR_SPECIAL_RESULT, 65000
	GoToIfLt _cv_menu_7
	SetVar VAR_SPECIAL_RESULT, 127
_cv_menu_7:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CeladonCity_GameCorner_PrizeRoom_EventScript_SmokeBall
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq CeladonCity_GameCorner_PrizeRoom_EventScript_MiracleSeed
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq CeladonCity_GameCorner_PrizeRoom_EventScript_Charcoal
	CompareVarToValue VAR_SPECIAL_RESULT, 3
	GoToIfEq CeladonCity_GameCorner_PrizeRoom_EventScript_MysticWater
	CompareVarToValue VAR_SPECIAL_RESULT, 4
	GoToIfEq CeladonCity_GameCorner_PrizeRoom_EventScript_YellowFlute
	CompareVarToValue VAR_SPECIAL_RESULT, 5
	GoToIfEq CeladonCity_GameCorner_PrizeRoom_EventScript_EndPrizeExchange
	CompareVarToValue VAR_SPECIAL_RESULT, 127
	GoToIfEq CeladonCity_GameCorner_PrizeRoom_EventScript_EndPrizeExchange
	CloseMsg
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_Abra:
	// TODO(gba) #ifdef FIRERED
	GoTo _cv_stop
	SetVar 0x4001, SPECIES_ABRA
	SetVar 0x4002, 180
	// TODO(gba) #else 
	GoTo _cv_stop
	// TODO(gba) #ifdef LEAFGREEN
	GoTo _cv_stop
	SetVar 0x4001, SPECIES_ABRA
	SetVar 0x4002, 120
	// TODO(gba) #endif 
	GoTo _cv_stop
	// TODO(gba) #endif 
	GoTo _cv_stop
	GoTo CeladonCity_GameCorner_PrizeRoom_EventScript_ConfirmPrizeMon
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_Clefairy:
	// TODO(gba) #ifdef FIRERED
	GoTo _cv_stop
	SetVar 0x4001, SPECIES_CLEFAIRY
	SetVar 0x4002, 500
	// TODO(gba) #else 
	GoTo _cv_stop
	// TODO(gba) #ifdef LEAFGREEN
	GoTo _cv_stop
	SetVar 0x4001, SPECIES_CLEFAIRY
	SetVar 0x4002, 750
	// TODO(gba) #endif 
	GoTo _cv_stop
	// TODO(gba) #endif 
	GoTo _cv_stop
	GoTo CeladonCity_GameCorner_PrizeRoom_EventScript_ConfirmPrizeMon
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_DratiniPinsir:
	// TODO(gba) #ifdef FIRERED
	GoTo _cv_stop
	SetVar 0x4001, SPECIES_DRATINI
	SetVar 0x4002, 2800
	// TODO(gba) #else 
	GoTo _cv_stop
	// TODO(gba) #ifdef LEAFGREEN
	GoTo _cv_stop
	SetVar 0x4001, SPECIES_PINSIR
	SetVar 0x4002, 2500
	// TODO(gba) #endif 
	GoTo _cv_stop
	// TODO(gba) #endif 
	GoTo _cv_stop
	GoTo CeladonCity_GameCorner_PrizeRoom_EventScript_ConfirmPrizeMon
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_ScytherDratini:
	// TODO(gba) #ifdef FIRERED
	GoTo _cv_stop
	SetVar 0x4001, SPECIES_SCYTHER
	SetVar 0x4002, 5500
	// TODO(gba) #else 
	GoTo _cv_stop
	// TODO(gba) #ifdef LEAFGREEN
	GoTo _cv_stop
	SetVar 0x4001, SPECIES_DRATINI
	SetVar 0x4002, 4600
	// TODO(gba) #endif 
	GoTo _cv_stop
	// TODO(gba) #endif 
	GoTo _cv_stop
	GoTo CeladonCity_GameCorner_PrizeRoom_EventScript_ConfirmPrizeMon
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_Porygon:
	// TODO(gba) #ifdef FIRERED
	GoTo _cv_stop
	SetVar 0x4001, SPECIES_PORYGON
	SetVar 0x4002, 9999
	// TODO(gba) #else 
	GoTo _cv_stop
	// TODO(gba) #ifdef LEAFGREEN
	GoTo _cv_stop
	SetVar 0x4001, SPECIES_PORYGON
	SetVar 0x4002, 6500
	// TODO(gba) #endif 
	GoTo _cv_stop
	// TODO(gba) #endif 
	GoTo _cv_stop
	GoTo CeladonCity_GameCorner_PrizeRoom_EventScript_ConfirmPrizeMon
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_EndPrizeExchange:
	// TODO(gba) hidecoinsbox 
	GoTo _cv_stop
	ReleaseAll
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_TM13:
	SetVar 0x4001, ITEM_TM13
	SetVar 0x4002, 4000
	BufferMoveName 1, MOVE_ICE_BEAM
	GoTo CeladonCity_GameCorner_PrizeRoom_EventScript_ConfirmPrizeTM
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_TM23:
	SetVar 0x4001, ITEM_TM23
	SetVar 0x4002, 3500
	BufferMoveName 1, MOVE_IRON_TAIL
	GoTo CeladonCity_GameCorner_PrizeRoom_EventScript_ConfirmPrizeTM
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_TM24:
	SetVar 0x4001, ITEM_TM24
	SetVar 0x4002, 4000
	BufferMoveName 1, MOVE_THUNDERBOLT
	GoTo CeladonCity_GameCorner_PrizeRoom_EventScript_ConfirmPrizeTM
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_TM30:
	SetVar 0x4001, ITEM_TM30
	SetVar 0x4002, 4500
	BufferMoveName 1, MOVE_SHADOW_BALL
	GoTo CeladonCity_GameCorner_PrizeRoom_EventScript_ConfirmPrizeTM
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_TM35:
	SetVar 0x4001, ITEM_TM35
	SetVar 0x4002, 4000
	BufferMoveName 1, MOVE_FLAMETHROWER
	GoTo CeladonCity_GameCorner_PrizeRoom_EventScript_ConfirmPrizeTM
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_SmokeBall:
	SetVar 0x4001, ITEM_SMOKE_BALL
	SetVar 0x4002, 800
	GoTo CeladonCity_GameCorner_PrizeRoom_EventScript_ConfirmPrizeItem
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_MiracleSeed:
	SetVar 0x4001, ITEM_MIRACLE_SEED
	SetVar 0x4002, 1000
	GoTo CeladonCity_GameCorner_PrizeRoom_EventScript_ConfirmPrizeItem
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_Charcoal:
	SetVar 0x4001, ITEM_CHARCOAL
	SetVar 0x4002, 1000
	GoTo CeladonCity_GameCorner_PrizeRoom_EventScript_ConfirmPrizeItem
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_MysticWater:
	SetVar 0x4001, ITEM_MYSTIC_WATER
	SetVar 0x4002, 1000
	GoTo CeladonCity_GameCorner_PrizeRoom_EventScript_ConfirmPrizeItem
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_YellowFlute:
	SetVar 0x4001, ITEM_YELLOW_FLUTE
	SetVar 0x4002, 1600
	GoTo CeladonCity_GameCorner_PrizeRoom_EventScript_ConfirmPrizeItem
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_ConfirmPrizeMon:
	BufferSpeciesName 0, 0x4001, 0, 0
	NPCMsg msg_0954_CV_CANVAS_PRIZE_ROOM_CeladonCity_GameCorner_PrizeRoom_Text_YouWantPrize
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_8
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_9
_cv_yes_8:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_9:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CeladonCity_GameCorner_PrizeRoom_EventScript_EndPrizeExchange
	// TODO(gba) checkcoins VAR_RESULT
	GoTo _cv_stop
	CompareVarToVar VAR_SPECIAL_RESULT, 0x4002
	GoToIfLt CeladonCity_GameCorner_PrizeRoom_EventScript_NotEnoughCoins
	CompareVarToValue 0x4001, SPECIES_ABRA
	GoToIfEq CeladonCity_GameCorner_PrizeRoom_EventScript_GiveAbra
	CompareVarToValue 0x4001, SPECIES_CLEFAIRY
	GoToIfEq CeladonCity_GameCorner_PrizeRoom_EventScript_GiveClefairy
	CompareVarToValue 0x4001, SPECIES_DRATINI
	GoToIfEq CeladonCity_GameCorner_PrizeRoom_EventScript_GiveDratini
	CompareVarToValue 0x4001, SPECIES_SCYTHER
	GoToIfEq CeladonCity_GameCorner_PrizeRoom_EventScript_GiveScyther
	CompareVarToValue 0x4001, SPECIES_PORYGON
	GoToIfEq CeladonCity_GameCorner_PrizeRoom_EventScript_GivePorygon
	CompareVarToValue 0x4001, SPECIES_PINSIR
	GoToIfEq CeladonCity_GameCorner_PrizeRoom_EventScript_GivePinsir
	CloseMsg
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_ConfirmPrizeTM:
	NPCMsg msg_0954_CV_CANVAS_PRIZE_ROOM_CeladonCity_GameCorner_PrizeRoom_Text_YouWantTM
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_10
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_11
_cv_yes_10:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_11:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CeladonCity_GameCorner_PrizeRoom_EventScript_EndPrizeExchange
	GoTo CeladonCity_GameCorner_PrizeRoom_EventScript_TryGivePrize
	CloseMsg
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_ConfirmPrizeItem:
	BufferItemName 0, 0x4001
	NPCMsg msg_0954_CV_CANVAS_PRIZE_ROOM_CeladonCity_GameCorner_PrizeRoom_Text_YouWantPrize
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_12
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_13
_cv_yes_12:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_13:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CeladonCity_GameCorner_PrizeRoom_EventScript_EndPrizeExchange
	GoTo CeladonCity_GameCorner_PrizeRoom_EventScript_TryGivePrize
	CloseMsg
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_NotEnoughCoins:
	NPCMsg msg_0954_CV_CANVAS_PRIZE_ROOM_CeladonCity_GameCorner_PrizeRoom_Text_NeedMoreCoins
	WaitButton
	GoTo CeladonCity_GameCorner_PrizeRoom_EventScript_EndPrizeExchange
	CloseMsg
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_GiveAbra:
	// TODO(gba) #ifdef FIRERED
	GoTo _cv_stop
	GiveMon 0x4001, 9, 0, 0, 0, VAR_SPECIAL_RESULT
	// TODO(gba) #else 
	GoTo _cv_stop
	// TODO(gba) #ifdef LEAFGREEN
	GoTo _cv_stop
	GiveMon 0x4001, 7, 0, 0, 0, VAR_SPECIAL_RESULT
	// TODO(gba) #endif 
	GoTo _cv_stop
	// TODO(gba) #endif 
	GoTo _cv_stop
	GoTo CeladonCity_GameCorner_PrizeRoom_EventScript_CheckReceivedMon
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_GiveClefairy:
	// TODO(gba) #ifdef FIRERED
	GoTo _cv_stop
	GiveMon 0x4001, 8, 0, 0, 0, VAR_SPECIAL_RESULT
	// TODO(gba) #else 
	GoTo _cv_stop
	// TODO(gba) #ifdef LEAFGREEN
	GoTo _cv_stop
	GiveMon 0x4001, 12, 0, 0, 0, VAR_SPECIAL_RESULT
	// TODO(gba) #endif 
	GoTo _cv_stop
	// TODO(gba) #endif 
	GoTo _cv_stop
	GoTo CeladonCity_GameCorner_PrizeRoom_EventScript_CheckReceivedMon
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_GiveDratini:
	// TODO(gba) #ifdef FIRERED
	GoTo _cv_stop
	GiveMon 0x4001, 18, 0, 0, 0, VAR_SPECIAL_RESULT
	// TODO(gba) #else 
	GoTo _cv_stop
	// TODO(gba) #ifdef LEAFGREEN
	GoTo _cv_stop
	GiveMon 0x4001, 24, 0, 0, 0, VAR_SPECIAL_RESULT
	// TODO(gba) #endif 
	GoTo _cv_stop
	// TODO(gba) #endif 
	GoTo _cv_stop
	GoTo CeladonCity_GameCorner_PrizeRoom_EventScript_CheckReceivedMon
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_GiveScyther:
	GiveMon 0x4001, 25, 0, 0, 0, VAR_SPECIAL_RESULT
	GoTo CeladonCity_GameCorner_PrizeRoom_EventScript_CheckReceivedMon
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_GivePorygon:
	// TODO(gba) #ifdef FIRERED
	GoTo _cv_stop
	GiveMon 0x4001, 26, 0, 0, 0, VAR_SPECIAL_RESULT
	// TODO(gba) #else 
	GoTo _cv_stop
	// TODO(gba) #ifdef LEAFGREEN
	GoTo _cv_stop
	GiveMon 0x4001, 18, 0, 0, 0, VAR_SPECIAL_RESULT
	// TODO(gba) #endif 
	GoTo _cv_stop
	// TODO(gba) #endif 
	GoTo _cv_stop
	GoTo CeladonCity_GameCorner_PrizeRoom_EventScript_CheckReceivedMon
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_GivePinsir:
	GiveMon 0x4001, 18, 0, 0, 0, VAR_SPECIAL_RESULT
	GoTo CeladonCity_GameCorner_PrizeRoom_EventScript_CheckReceivedMon
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_TryGivePrize:
	BufferItemName 0, 0x4001
	// TODO(gba) checkcoins VAR_RESULT
	GoTo _cv_stop
	CompareVarToVar VAR_SPECIAL_RESULT, 0x4002
	GoToIfLt CeladonCity_GameCorner_PrizeRoom_EventScript_NotEnoughCoins
	HasSpaceForItem 0x4001, 1, VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CeladonCity_GameCorner_PrizeRoom_EventScript_BagFull
	// TODO(gba) removecoins VAR_TEMP_2
	GoTo _cv_stop
	// TODO(gba) updatecoinsbox 
	GoTo _cv_stop
	GiveItem 0x4001, 1, VAR_SPECIAL_RESULT
	GoTo CeladonCity_GameCorner_PrizeRoom_EventScript_EndPrizeExchange
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_CheckReceivedMon:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CeladonCity_GameCorner_PrizeRoom_EventScript_ReceivedMonParty
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq CeladonCity_GameCorner_PrizeRoom_EventScript_ReceivedMonPC
	CompareVarToValue VAR_SPECIAL_RESULT, 2
	GoToIfEq CeladonCity_GameCorner_PrizeRoom_EventScript_PartyFull
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_BagFull:
	NPCMsg msg_0954_CV_CANVAS_PRIZE_ROOM_gText_TooBadBagIsFull
	WaitButton
	// TODO(gba) hidecoinsbox 
	GoTo _cv_stop
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_ReceivedMonParty:
	// TODO(gba) removecoins VAR_TEMP_2
	GoTo _cv_stop
	// TODO(gba) updatecoinsbox 
	GoTo _cv_stop
	BufferSpeciesName 0, 0x4001, 0, 0
	PlayFanfare SEQ_ME_LVUP
	BufferPlayersName 6
	NPCMsg msg_0954_CV_CANVAS_PRIZE_ROOM_gText_PlayerObtainedTheMon
	WaitFanfare
	NPCMsg msg_0954_CV_CANVAS_PRIZE_ROOM_gText_NicknameThisPokemon
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_14
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_15
_cv_yes_14:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_15:
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq CeladonCity_GameCorner_PrizeRoom_EventScript_NicknamePartyMon
	GoTo CeladonCity_GameCorner_PrizeRoom_EventScript_EndPrizeExchange
	CloseMsg
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_ReceivedMonPC:
	// TODO(gba) removecoins VAR_TEMP_2
	GoTo _cv_stop
	// TODO(gba) updatecoinsbox 
	GoTo _cv_stop
	BufferSpeciesName 0, 0x4001, 0, 0
	PlayFanfare SEQ_ME_LVUP
	BufferPlayersName 6
	NPCMsg msg_0954_CV_CANVAS_PRIZE_ROOM_gText_PlayerObtainedTheMon
	WaitFanfare
	NPCMsg msg_0954_CV_CANVAS_PRIZE_ROOM_gText_NicknameThisPokemon
	YesNo VAR_SPECIAL_RESULT
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq _cv_yes_16
	SetVar VAR_SPECIAL_RESULT, 0
	GoTo _cv_yn_17
_cv_yes_16:
	SetVar VAR_SPECIAL_RESULT, 1
_cv_yn_17:
	CompareVarToValue VAR_SPECIAL_RESULT, 0
	GoToIfEq CeladonCity_GameCorner_PrizeRoom_EventScript_TransferredToPC
	Call Common_EventScript_NameReceivedBoxMon
	GoTo CeladonCity_GameCorner_PrizeRoom_EventScript_TransferredToPC
	CloseMsg
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_PartyFull:
	NPCMsg msg_0954_CV_CANVAS_PRIZE_ROOM_gText_NoMoreRoomForPokemon
	WaitButton
	// TODO(gba) hidecoinsbox 
	GoTo _cv_stop
	CloseMsg
	ReleaseAll
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_NicknamePartyMon:
	// TODO(gba) getpartysize 
	GoTo _cv_stop
	SubVar VAR_SPECIAL_RESULT, 1
	CopyVar 0x8004, VAR_SPECIAL_RESULT
	Call Common_EventScript_NameReceivedPartyMon
	GoTo CeladonCity_GameCorner_PrizeRoom_EventScript_EndPrizeExchange
	End
	
CeladonCity_GameCorner_PrizeRoom_EventScript_TransferredToPC:
	Call Common_EventScript_TransferredToPC
	GoTo CeladonCity_GameCorner_PrizeRoom_EventScript_EndPrizeExchange
	End
	
Common_EventScript_NameReceivedBoxMon:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	SetVar 0x8004, 0
	NicknameInput 0x8004, VAR_SPECIAL_RESULT
	LockAll
	FacePlayer
	Return
	
Common_EventScript_NameReceivedPartyMon:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	NicknameInput 0x8004, VAR_SPECIAL_RESULT
	Return
	
Common_EventScript_TransferredToPC:
	// TODO(gba) bufferboxname STR_VAR_1, VAR_PC_BOX_TO_SEND_MON
	GoTo _cv_stop
	BufferSpeciesName 1, 0x5024, 0, 0
	CallIfUnset 0x20D0, EventScript_TransferredSomeonesPC
	CallIfSet 0x20D0, EventScript_TransferredLanettesPC
	Return
	
EventScript_TransferredSomeonesPC:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar ShouldShowBoxWasFullMessage
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq EventScript_SomeonesPCBoxFull
	NPCMsg msg_0954_CV_CANVAS_PRIZE_ROOM_gText_PkmnTransferredSomeonesPC
	WaitButton
	Return
	
EventScript_TransferredLanettesPC:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar ShouldShowBoxWasFullMessage
	GoTo _cv_stop
	CompareVarToValue VAR_SPECIAL_RESULT, 1
	GoToIfEq EventScript_LanettesPCBoxFull
	NPCMsg msg_0954_CV_CANVAS_PRIZE_ROOM_gText_PkmnTransferredLanettesPC
	WaitButton
	Return
	
EventScript_SomeonesPCBoxFull:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar GetPCBoxToSendMon
	GoTo _cv_stop
	// TODO(gba) bufferboxname STR_VAR_3, VAR_RESULT
	GoTo _cv_stop
	NPCMsg msg_0954_CV_CANVAS_PRIZE_ROOM_gText_PkmnTransferredSomeonesPCBoxFull
	WaitButton
	Return
	
EventScript_LanettesPCBoxFull:
	SetVar VAR_SPECIAL_RESULT, 0  // TODO(gba) specialvar GetPCBoxToSendMon
	GoTo _cv_stop
	// TODO(gba) bufferboxname STR_VAR_3, VAR_RESULT
	GoTo _cv_stop
	NPCMsg msg_0954_CV_CANVAS_PRIZE_ROOM_gText_PkmnTransferredLanettesPCBoxFull
	WaitButton
	Return

_cv_stop:
	NPCMsg msg_0954_CV_CANVAS_PRIZE_ROOM_cv_unported
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
