// Canvas: maps past HeartGold's 540. These don't live in the ARM9 (hg-engine needs its layout left alone):
// tools/canvas/build_map_headers.py compiles this table and hands it to the engine (a/0/2/8 member 21), whose
// MapNumberBoundsCheck hook copies an entry into a spare slot of HeartGold's table when one of these maps is
// asked about. Index by [MAP_x - MAP_CANVAS_FIRST]; same fields as data/map_headers.h.
// (written by the canvas tools; entries are kept in map id order)
static const MapHeader sCanvasMapHeaders[] = {
    [MAP_CANVAS_VIRIDIAN_PENNYS_HOUSE - MAP_CANVAS_FIRST] = {
                        .wildEncounterBank = ENCDATA_NA,
                        .areaDataBank = 43,
                        .moveModelBank = 15,
                        .worldMapX = 32,
                        .worldMapY = 7,
                        .matrixId = NARC_map_matrix_map_matrix_0299_CV_CANVAS_VIRIDIAN_PENNYS_HOUSE_bin,
                        .scriptsBank = scr_seq_0977_CV_CANVAS_VIRIDIAN_PENNYS_HOUSE_bin,
                        .scriptHeaderBank = scr_seq_0978_CV_CANVAS_VIRIDIAN_PENNYS_HOUSE_hdr_bin,
                        .msgBank = msg_0860_CV_CANVAS_VIRIDIAN_PENNYS_HOUSE,
                        .dayMusicId = SEQ_GS_C_TOKIWA,
                        .nightMusicId = SEQ_GS_C_TOKIWA,
                        .eventsBank = NARC_zone_event_506_CV_CANVAS_VIRIDIAN_PENNYS_HOUSE_bin,
                        .mapsec = MAPSEC_VIRIDIAN_CITY,
                        .areaIcon = 9,
                        .momCallIntroParam = 12,
                        .regionNo = MAP_REGION_KANTO,
                        .weather = 0,
                        .mapType = MAP_TYPE_INTERIOR,
                        .cameraType = 4,
                        .followMode = MAP_FOLLOWMODE_HEIGHT_RESTRICT,
                        .battleBg = BATTLE_BG_BUILDING_1,
                        .bikeAllowed = FALSE,
                        .runningAllowed_Unused = TRUE,
                        .escapeRopeAllowed = FALSE,
                        .flyAllowed = FALSE,
                        .outgoingCalls = TRUE,
                        .incomingCalls = TRUE,
                        .radioSignal = TRUE,
                        },
};
