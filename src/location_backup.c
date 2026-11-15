#include "location_backup.h"

#include "global.h"

#include "constants/maps.h"

#include "field_system.h"
#include "save_local_field_data.h"

static const Location sLocation_PlayerRoom = {
    .mapId = MAP_PALLET,
    .warpId = 0xFFFFFFFF,
    .x = 31 * 32 + 27 + 6,
    .y = 32 * 11 + 49,
    .direction = 0x00000001,
};

static const Location sLocation_OutsidePlayerHome = {   // Canvas: outside our Pallet house
    .mapId = MAP_PALLET,
    .warpId = 0xFFFFFFFF,
    .x = 31 * 32 + 27 + 6,
    .y = 32 * 11 + 49,
    .direction = 0x00000001,
};

void Location_SetToPlayerRoom(Location *dest) {
    const Location *src = &sLocation_PlayerRoom;
    *dest = *src;
}

void Location_SetToOutsidePlayerHome(Location *dest) {
    const Location *src = &sLocation_OutsidePlayerHome;
    *dest = *src;
}

void Save_SetPositionToPlayerRoom(SaveData *saveData) {
    Location *position = LocalFieldData_GetCurrentPosition(Save_LocalFieldData_Get(saveData));
    Location_SetToPlayerRoom(position);
}
