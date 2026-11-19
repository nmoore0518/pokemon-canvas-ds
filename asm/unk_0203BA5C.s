#include "constants/maps.h"
	.include "macros.inc"
	.include "unk_0203BA5C.inc"
	.include "global.inc"

	.rodata
	.macro spawn flagIdx, isBlackoutSpawn, isFlyPoint, deathSpawnMapNo, deathSpawnX, deathSpawnY, flyPointMapNo, flyPointX, flyPointY, specialWarpMapNo, specialWarpX, specialWarpY
	.short (\flagIdx & 0xFF) | ((\isBlackoutSpawn & 1) << 8) | ((\isFlyPoint & 1) << 9), \deathSpawnMapNo
	.short \deathSpawnX | (\deathSpawnY << 8)
	.short \flyPointMapNo, \flyPointX, \flyPointY, \specialWarpMapNo, \specialWarpX, \specialWarpY
	.endm

sSpawnMaps:   ; Canvas: entry 1 (home) and 13 (Pallet) point at our Pallet house
	spawn 0x0B, 1, 1, MAP_PALLET_TOWN_REDS_HOUSE_1F, 4, 7, MAP_PALLET, 0x0401, 0x0191, MAP_PALLET, 0x0401, 0x0191
	spawn 0x0C, 1, 1, MAP_CHERRYGROVE_POKECENTER_1F, 8, 13, MAP_CHERRYGROVE, 0x0234, 0x0188, MAP_CHERRYGROVE, 0x0234, 0x0188
	spawn 0x0D, 1, 1, MAP_VIOLET_POKECENTER_1F, 8, 13, MAP_VIOLET, 0x01F1, 0x0110, MAP_VIOLET, 0x01F1, 0x0110
	spawn 0x0E, 1, 1, MAP_AZALEA_POKECENTER_1F, 8, 13, MAP_AZALEA, 0x019A, 0x01CD, MAP_AZALEA, 0x019A, 0x01CD
	spawn 0x0F, 1, 1, MAP_CIANWOOD_POKECENTER_1F, 8, 13, MAP_CIANWOOD, 0x00BB, 0x0172, MAP_CIANWOOD, 0x00BB, 0x0172
	spawn 0x10, 1, 1, MAP_GOLDENROD_POKECENTER_1F, 8, 13, MAP_GOLDENROD, 0x0160, 0x0171, MAP_GOLDENROD, 0x0160, 0x0171
	spawn 0x11, 1, 1, MAP_OLIVINE_POKECENTER_1F, 8, 13, MAP_OLIVINE, 0x0110, 0x0102, MAP_OLIVINE, 0x0110, 0x0102
	spawn 0x12, 1, 1, MAP_ECRUTEAK_POKECENTER_1F, 8, 13, MAP_ECRUTEAK, 0x018D, 0x00B8, MAP_ECRUTEAK, 0x018D, 0x00B8
	spawn 0x13, 1, 1, MAP_MAHOGANY_POKECENTER_1F, 8, 13, MAP_MAHOGANY, 0x0216, 0x00B8, MAP_MAHOGANY, 0x0216, 0x00B8
	spawn 0x14, 0, 1, MAP_LAKE_OF_RAGE, 8, 13, MAP_LAKE_OF_RAGE, 0x0218, 0x005A, MAP_LAKE_OF_RAGE, 0x0218, 0x005A
	spawn 0x15, 1, 1, MAP_BLACKTHORN_POKECENTER_1F, 8, 13, MAP_BLACKTHORN, 0x02A2, 0x00B1, MAP_BLACKTHORN, 0x02A2, 0x00B1
	spawn 0x16, 1, 1, MAP_MOUNT_SILVER_POKECENTER_1F, 8, 13, MAP_MOUNT_SILVER, 0x0334, 0x010A, MAP_MOUNT_SILVER, 0x0334, 0x010A
	spawn 0x00, 0, 1, MAP_PALLET, 8, 13, MAP_PALLET, 0x0401, 0x0191, MAP_PALLET, 0x0401, 0x0191
	spawn 0x01, 1, 1, MAP_VIRIDIAN_POKECENTER_1F, 8, 13, MAP_VIRIDIAN, 0x0411, 0x012B, MAP_VIRIDIAN, 0x0411, 0x012B
	spawn 0x02, 1, 1, MAP_PEWTER_POKECENTER_1F, 8, 13, MAP_PEWTER, 0x0408, 0x00B2, MAP_PEWTER, 0x0408, 0x00B2
	spawn 0x03, 1, 1, MAP_CERULEAN_POKECENTER_1F, 8, 13, MAP_CERULEAN, 0x04E5, 0x0098, MAP_CERULEAN, 0x04E5, 0x0098
	spawn 0x04, 1, 1, MAP_LAVENDER_POKECENTER_1F, 8, 13, MAP_LAVENDER, 0x054D, 0x00E4, MAP_LAVENDER, 0x054D, 0x00E4
	spawn 0x05, 1, 1, MAP_VERMILION_POKECENTER_1F, 8, 13, MAP_VERMILION, 0x04DE, 0x012B, MAP_VERMILION, 0x04DE, 0x012B
	spawn 0x06, 1, 1, MAP_CELADON_POKECENTER_1F, 8, 13, MAP_CELADON, 0x04AB, 0x00E0, MAP_CELADON, 0x04AB, 0x00E0
	spawn 0x07, 1, 1, MAP_FUCHSIA_POKECENTER_1F, 8, 13, MAP_FUCHSIA, 0x04A0, 0x01A8, MAP_FUCHSIA, 0x04A0, 0x01A8
	spawn 0x08, 0, 1, MAP_CINNABAR_ISLAND_POKECENTER_1F, 8, 13, MAP_CINNABAR_ISLAND, 0x040F, 0x01F7, MAP_CINNABAR_ISLAND, 0x040F, 0x01F7
	spawn 0x09, 1, 1, MAP_POKEMON_LEAGUE_ENTRANCE, 6, 21, MAP_INDIGO_PLATEAU, 0x03D2, 0x006D, MAP_INDIGO_PLATEAU, 0x03D2, 0x006D
	spawn 0x0A, 1, 1, MAP_SAFFRON_POKECENTER_1F, 8, 13, MAP_SAFFRON, 0x04DD, 0x00F4, MAP_SAFFRON, 0x04DD, 0x00F4
	spawn 0x1E, 1, 1, MAP_SAFARI_ZONE_GATE_POKECENTER_1F, 8, 13, MAP_SAFARI_ZONE_GATE, 0x0052, 0x012F, MAP_SAFARI_ZONE_GATE, 0x0052, 0x012F
	spawn 0x1F, 1, 1, MAP_FRONTIER_ACCESS_POKECENTER_1F, 8, 13, MAP_BATTLE_FRONTIER_FRONTIER_ACCESS, 0x0008, 0x000F, MAP_ROUTE_40, 0x00ED, 0x010B
	spawn 0x23, 0, 0, MAP_POKEATHLON_DOME, 8, 13, MAP_POKEATHLON_DOME, 0x002A, 0x0017, MAP_ROUTE_35, 0x016A, 0x010B
	spawn 0x21, 0, 0, MAP_ROUTE_22_POKEMON_LEAGUE_RECEPTION_GATE, 8, 13, MAP_CANVAS_ROUTE_23, 0x03CF, 0x0114, MAP_CANVAS_ROUTE_23, 0x03CF, 0x0114
	spawn 0x1B, 1, 0, MAP_ROUTE_32_POKECENTER_1F, 8, 13, MAP_ROUTE_32, 0x01D4, 0x01A3, MAP_ROUTE_32, 0x01D4, 0x01A3
	spawn 0x24, 1, 0, MAP_ROUTE_3_POKECENTER_1F, 8, 13, MAP_ROUTE_4, 0x046F, 0x0094, MAP_ROUTE_4, 0x046F, 0x0094
	spawn 0x25, 1, 0, MAP_ROUTE_10_POKECENTER_1F, 8, 13, MAP_ROUTE_10, 0x0554, 0x00A3, MAP_ROUTE_10, 0x0554, 0x00A3

	.text

	thumb_func_start SpawnIdToTableIndex
SpawnIdToTableIndex: ; 0x0203BA5C
	push {r3, lr}
	cmp r0, #0
	ble _0203BA66
	cmp r0, #0x1e
	bls _0203BA6C
_0203BA66:
	bl GF_AssertFail
	mov r0, #1
_0203BA6C:
	sub r0, r0, #1
	pop {r3, pc}
	thumb_func_end SpawnIdToTableIndex

	thumb_func_start GetMomSpawnId
GetMomSpawnId: ; 0x0203BA70
	mov r0, #1
	bx lr
	thumb_func_end GetMomSpawnId

	thumb_func_start GetFlyWarpData
GetFlyWarpData: ; 0x0203BA74
	push {r4, lr}
	add r4, r1, #0
	bl SpawnIdToTableIndex
	add r1, r0, #0
	mov r2, #0x12
	mul r1, r2
	ldr r0, _0203BAA0 ; =sSpawnMaps + 6
	sub r2, #0x13
	ldrh r0, [r0, r1]
	str r0, [r4]
	ldr r0, _0203BAA4 ; =sSpawnMaps + 8
	str r2, [r4, #4]
	ldrh r0, [r0, r1]
	str r0, [r4, #8]
	ldr r0, _0203BAA8 ; =sSpawnMaps + 10
	ldrh r0, [r0, r1]
	str r0, [r4, #0xc]
	mov r0, #1
	str r0, [r4, #0x10]
	pop {r4, pc}
	nop
_0203BAA0: .word sSpawnMaps + 6
_0203BAA4: .word sSpawnMaps + 8
_0203BAA8: .word sSpawnMaps + 10
	thumb_func_end GetFlyWarpData

	thumb_func_start GetDeathWarpData
GetDeathWarpData: ; 0x0203BAAC
	push {r4, lr}
	add r4, r1, #0
	bl SpawnIdToTableIndex
	add r2, r0, #0
	mov r1, #0x12
	mul r2, r1
	ldr r0, _0203BAE0 ; =sSpawnMaps + 2
	sub r1, #0x13
	ldrh r0, [r0, r2]
	str r0, [r4]
	ldr r0, _0203BAE4 ; =sSpawnMaps
	str r1, [r4, #4]
	add r1, r0, r2
	ldrh r0, [r1, #4]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [r4, #8]
	ldrh r0, [r1, #4]
	lsl r0, r0, #0x10
	lsr r0, r0, #0x18
	str r0, [r4, #0xc]
	mov r0, #0
	str r0, [r4, #0x10]
	pop {r4, pc}
	nop
_0203BAE0: .word sSpawnMaps + 2
_0203BAE4: .word sSpawnMaps
	thumb_func_end GetDeathWarpData

	thumb_func_start GetSpecialSpawnWarpData
GetSpecialSpawnWarpData: ; 0x0203BAE8
	push {r4, lr}
	add r4, r1, #0
	bl SpawnIdToTableIndex
	add r1, r0, #0
	mov r2, #0x12
	mul r1, r2
	ldr r0, _0203BB14 ; =sSpawnMaps + 12
	sub r2, #0x13
	ldrh r0, [r0, r1]
	str r0, [r4]
	ldr r0, _0203BB18 ; =sSpawnMaps + 14
	str r2, [r4, #4]
	ldrh r0, [r0, r1]
	str r0, [r4, #8]
	ldr r0, _0203BB1C ; =sSpawnMaps + 16
	ldrh r0, [r0, r1]
	str r0, [r4, #0xc]
	mov r0, #1
	str r0, [r4, #0x10]
	pop {r4, pc}
	nop
_0203BB14: .word sSpawnMaps + 12
_0203BB18: .word sSpawnMaps + 14
_0203BB1C: .word sSpawnMaps + 16
	thumb_func_end GetSpecialSpawnWarpData

	thumb_func_start MapHeader_GetSpawnIdForDeathWarp
MapHeader_GetSpawnIdForDeathWarp: ; 0x0203BB20
	push {r3, r4}
	ldr r3, _0203BB4C ; =sSpawnMaps
	mov r2, #0
	add r4, r3, #0
_0203BB28:
	ldrh r1, [r3, #2]
	cmp r0, r1
	bne _0203BB3C
	ldrh r1, [r4]
	lsl r1, r1, #0x17
	lsr r1, r1, #0x1f
	beq _0203BB3C
	add r0, r2, #1
	pop {r3, r4}
	bx lr
_0203BB3C:
	add r2, r2, #1
	add r3, #0x12
	add r4, #0x12
	cmp r2, #0x1e
	blo _0203BB28
	mov r0, #0
	pop {r3, r4}
	bx lr
	.balign 4, 0
_0203BB4C: .word sSpawnMaps
	thumb_func_end MapHeader_GetSpawnIdForDeathWarp

	thumb_func_start sub_0203BB50
sub_0203BB50: ; 0x0203BB50
	ldr r3, _0203BB6C ; =sSpawnMaps
	mov r2, #0
_0203BB54:
	ldrh r1, [r3, #6]
	cmp r0, r1
	bne _0203BB5E
	add r0, r2, #1
	bx lr
_0203BB5E:
	add r2, r2, #1
	add r3, #0x12
	cmp r2, #0x1e
	blo _0203BB54
	mov r0, #0
	bx lr
	nop
_0203BB6C: .word sSpawnMaps
	thumb_func_end sub_0203BB50

	thumb_func_start FlypointFlagAction
FlypointFlagAction: ; 0x0203BB70
	push {r3, r4, r5, lr}
	ldr r2, _0203BBB0 ; =sSpawnMaps
	mov r4, #0
	add r3, r2, #0
_0203BB78:
	ldrh r5, [r2, #6]
	cmp r1, r5
	bne _0203BBA2
	ldrh r5, [r3]
	lsl r5, r5, #0x16
	lsr r5, r5, #0x1f
	beq _0203BBA2
	ldr r0, [r0, #0xc]
	bl Save_VarsFlags_Get
	mov r2, #0x12
	add r3, r4, #0
	mul r3, r2
	ldr r2, _0203BBB0 ; =sSpawnMaps
	mov r1, #1
	ldrh r2, [r2, r3]
	lsl r2, r2, #0x18
	lsr r2, r2, #0x18
	bl Save_VarsFlags_FlypointFlagAction
	pop {r3, r4, r5, pc}
_0203BBA2:
	add r4, r4, #1
	add r2, #0x12
	add r3, #0x12
	cmp r4, #0x1e
	blo _0203BB78
	pop {r3, r4, r5, pc}
	nop
_0203BBB0: .word sSpawnMaps
	thumb_func_end FlypointFlagAction
