// Pokemon Canvas: the GBA game's challengers (src/gym_challenge.c) for engine/src/canvas_candidate.c.
// tools/canvas/port/challengers.py: don't edit.

static const struct CanvasChallengerClass sCanvasClasses[] = {
    { TRAINERCLASS_ACE_TRAINER_M_GS, 0 },   // Cooltrainer COOLTRAINER_M
    { TRAINERCLASS_ACE_TRAINER_F_GS, 1 },   // Cooltrainer COOLTRAINER_F
    { TRAINERCLASS_ACE_TRAINER_M_GS, 0 },   // Cooltrainer COOLTRAINER_M
    { TRAINERCLASS_ACE_TRAINER_F_GS, 1 },   // Cooltrainer COOLTRAINER_F
    { TRAINERCLASS_BLACK_BELT, 0 },   // Black Belt BLACK_BELT_FRLG
    { TRAINERCLASS_GENTLEMAN, 0 },   // Gentleman GENTLEMAN_FRLG
    { TRAINERCLASS_HIKER, 0 },   // Hiker HIKER_FRLG
    { TRAINERCLASS_GUITARIST, 0 },   // Rocker ROCKER
    { TRAINERCLASS_BIKER, 0 },   // Biker BIKER
    { TRAINERCLASS_WORKER, 0 },   // Engineer WORKER_M
    { TRAINERCLASS_SCIENTIST_GS, 0 },   // Scientist SCIENTIST
    { TRAINERCLASS_POKE_MANIAC, 0 },   // Pokemaniac POKE_MANIAC_FRLG
    { TRAINERCLASS_CAMPER, 0 },   // Camper CAMPER_FRLG
    { TRAINERCLASS_SAILOR, 0 },   // Sailor SAILOR_FRLG
    { TRAINERCLASS_FISHERMAN, 0 },   // Fisherman FISHER
    { TRAINERCLASS_YOUNGSTER, 0 },   // Youngster YOUNGSTER_FRLG
    { TRAINERCLASS_BEAUTY, 1 },   // Beauty BEAUTY_FRLG
    { TRAINERCLASS_LASS, 1 },   // Lass LASS_FRLG
    { TRAINERCLASS_PICNICKER, 1 },   // Picnicker PICNICKER_FRLG
    { TRAINERCLASS_BATTLE_GIRL, 1 },   // Crush Girl CRUSH_GIRL
    { TRAINERCLASS_SWIMMER_F, 1 },   // Swimmer F SWIMMER_F_LAND
    { TRAINERCLASS_SWIMMER_M, 0 },   // Swimmer M SWIMMER_M_LAND
};

static const u8 sCanvasMaleNames[][8] = {
    "Aiden",
    "Brody",
    "Caleb",
    "Dante",
    "Eli",
    "Felix",
    "Grant",
    "Hugo",
    "Ian",
    "Jasper",
    "Kai",
    "Leon",
    "Miles",
    "Nolan",
    "Oscar",
    "Parker",
    "Quinn",
    "Rowan",
    "Silas",
    "Tobias",
    "Victor",
    "Wesley",
    "Xavier",
    "Zane",
    "Marcus",
    "Derek",
    "Roy",
    "Gus",
};

static const u8 sCanvasFemaleNames[][8] = {
    "Ada",
    "Bella",
    "Cora",
    "Diana",
    "Ellie",
    "Fiona",
    "Gwen",
    "Hazel",
    "Ivy",
    "June",
    "Kira",
    "Luna",
    "Maya",
    "Nora",
    "Olive",
    "Piper",
    "Ruby",
    "Sadie",
    "Tessa",
    "Uma",
    "Vera",
    "Willa",
    "Yara",
    "Zoe",
    "Nina",
    "Claire",
    "Meg",
    "Lila",
};

static const u16 sCanvasHeldItems[] = { ITEM_LEFTOVERS, ITEM_SITRUS_BERRY, ITEM_LUM_BERRY, ITEM_QUICK_CLAW, ITEM_KINGS_ROCK, ITEM_FOCUS_BAND, ITEM_SHELL_BELL, ITEM_SCOPE_LENS, ITEM_BRIGHT_POWDER, ITEM_WHITE_HERB };

static const u32 sCanvasTierAI[] = { (F_PRIORITIZE_SUPER_EFFECTIVE), (F_PRIORITIZE_SUPER_EFFECTIVE | F_EVALUATE_ATTACKS | F_PRIORITIZE_DAMAGE), (F_TRAINER_EXPERT_AI | F_PRIORITIZE_DAMAGE) };

// a byte a species, Bulbasaur to Deoxys and then ours: first type (POOL_LEGENDARY: never picked) | stage << 5 | evolves << 7
static const u8 sCanvasPool[] = {
    TYPE_GRASS | 0 << 5 | 1 << 7,   // SPECIES_BULBASAUR
    TYPE_GRASS | 1 << 5 | 1 << 7,   // SPECIES_IVYSAUR
    TYPE_GRASS | 2 << 5 | 0 << 7,   // SPECIES_VENUSAUR
    TYPE_FIRE | 0 << 5 | 1 << 7,   // SPECIES_CHARMANDER
    TYPE_FIRE | 1 << 5 | 1 << 7,   // SPECIES_CHARMELEON
    TYPE_FIRE | 2 << 5 | 0 << 7,   // SPECIES_CHARIZARD
    TYPE_WATER | 0 << 5 | 1 << 7,   // SPECIES_SQUIRTLE
    TYPE_WATER | 1 << 5 | 1 << 7,   // SPECIES_WARTORTLE
    TYPE_WATER | 2 << 5 | 0 << 7,   // SPECIES_BLASTOISE
    TYPE_BUG | 0 << 5 | 1 << 7,   // SPECIES_CATERPIE
    TYPE_BUG | 1 << 5 | 1 << 7,   // SPECIES_METAPOD
    TYPE_BUG | 2 << 5 | 0 << 7,   // SPECIES_BUTTERFREE
    TYPE_BUG | 0 << 5 | 1 << 7,   // SPECIES_WEEDLE
    TYPE_BUG | 1 << 5 | 1 << 7,   // SPECIES_KAKUNA
    TYPE_BUG | 2 << 5 | 0 << 7,   // SPECIES_BEEDRILL
    TYPE_NORMAL | 0 << 5 | 1 << 7,   // SPECIES_PIDGEY
    TYPE_NORMAL | 1 << 5 | 1 << 7,   // SPECIES_PIDGEOTTO
    TYPE_NORMAL | 2 << 5 | 0 << 7,   // SPECIES_PIDGEOT
    TYPE_NORMAL | 0 << 5 | 1 << 7,   // SPECIES_RATTATA
    TYPE_NORMAL | 1 << 5 | 0 << 7,   // SPECIES_RATICATE
    TYPE_NORMAL | 0 << 5 | 1 << 7,   // SPECIES_SPEAROW
    TYPE_NORMAL | 1 << 5 | 0 << 7,   // SPECIES_FEAROW
    TYPE_POISON | 0 << 5 | 1 << 7,   // SPECIES_EKANS
    TYPE_POISON | 1 << 5 | 0 << 7,   // SPECIES_ARBOK
    TYPE_ELECTRIC | 1 << 5 | 1 << 7,   // SPECIES_PIKACHU
    TYPE_ELECTRIC | 2 << 5 | 0 << 7,   // SPECIES_RAICHU
    TYPE_GROUND | 0 << 5 | 1 << 7,   // SPECIES_SANDSHREW
    TYPE_GROUND | 1 << 5 | 0 << 7,   // SPECIES_SANDSLASH
    TYPE_POISON | 0 << 5 | 1 << 7,   // SPECIES_NIDORAN_F
    TYPE_POISON | 1 << 5 | 1 << 7,   // SPECIES_NIDORINA
    TYPE_POISON | 2 << 5 | 0 << 7,   // SPECIES_NIDOQUEEN
    TYPE_POISON | 0 << 5 | 1 << 7,   // SPECIES_NIDORAN_M
    TYPE_POISON | 1 << 5 | 1 << 7,   // SPECIES_NIDORINO
    TYPE_POISON | 2 << 5 | 0 << 7,   // SPECIES_NIDOKING
    TYPE_FAIRY | 1 << 5 | 1 << 7,   // SPECIES_CLEFAIRY
    TYPE_FAIRY | 2 << 5 | 0 << 7,   // SPECIES_CLEFABLE
    TYPE_FIRE | 0 << 5 | 1 << 7,   // SPECIES_VULPIX
    TYPE_FIRE | 1 << 5 | 0 << 7,   // SPECIES_NINETALES
    TYPE_NORMAL | 1 << 5 | 1 << 7,   // SPECIES_JIGGLYPUFF
    TYPE_NORMAL | 2 << 5 | 0 << 7,   // SPECIES_WIGGLYTUFF
    TYPE_POISON | 0 << 5 | 1 << 7,   // SPECIES_ZUBAT
    TYPE_POISON | 1 << 5 | 1 << 7,   // SPECIES_GOLBAT
    TYPE_GRASS | 0 << 5 | 1 << 7,   // SPECIES_ODDISH
    TYPE_GRASS | 1 << 5 | 1 << 7,   // SPECIES_GLOOM
    TYPE_GRASS | 2 << 5 | 0 << 7,   // SPECIES_VILEPLUME
    TYPE_BUG | 0 << 5 | 1 << 7,   // SPECIES_PARAS
    TYPE_BUG | 1 << 5 | 0 << 7,   // SPECIES_PARASECT
    TYPE_BUG | 0 << 5 | 1 << 7,   // SPECIES_VENONAT
    TYPE_BUG | 1 << 5 | 0 << 7,   // SPECIES_VENOMOTH
    TYPE_GROUND | 0 << 5 | 1 << 7,   // SPECIES_DIGLETT
    TYPE_GROUND | 1 << 5 | 0 << 7,   // SPECIES_DUGTRIO
    TYPE_NORMAL | 0 << 5 | 1 << 7,   // SPECIES_MEOWTH
    TYPE_NORMAL | 1 << 5 | 0 << 7,   // SPECIES_PERSIAN
    TYPE_WATER | 0 << 5 | 1 << 7,   // SPECIES_PSYDUCK
    TYPE_WATER | 1 << 5 | 0 << 7,   // SPECIES_GOLDUCK
    TYPE_FIGHTING | 0 << 5 | 1 << 7,   // SPECIES_MANKEY
    TYPE_FIGHTING | 1 << 5 | 0 << 7,   // SPECIES_PRIMEAPE
    TYPE_FIRE | 0 << 5 | 1 << 7,   // SPECIES_GROWLITHE
    TYPE_FIRE | 1 << 5 | 0 << 7,   // SPECIES_ARCANINE
    TYPE_WATER | 0 << 5 | 1 << 7,   // SPECIES_POLIWAG
    TYPE_WATER | 1 << 5 | 1 << 7,   // SPECIES_POLIWHIRL
    TYPE_WATER | 2 << 5 | 0 << 7,   // SPECIES_POLIWRATH
    TYPE_PSYCHIC | 0 << 5 | 1 << 7,   // SPECIES_ABRA
    TYPE_PSYCHIC | 1 << 5 | 1 << 7,   // SPECIES_KADABRA
    TYPE_PSYCHIC | 2 << 5 | 0 << 7,   // SPECIES_ALAKAZAM
    TYPE_FIGHTING | 0 << 5 | 1 << 7,   // SPECIES_MACHOP
    TYPE_FIGHTING | 1 << 5 | 1 << 7,   // SPECIES_MACHOKE
    TYPE_FIGHTING | 2 << 5 | 0 << 7,   // SPECIES_MACHAMP
    TYPE_GRASS | 0 << 5 | 1 << 7,   // SPECIES_BELLSPROUT
    TYPE_GRASS | 1 << 5 | 1 << 7,   // SPECIES_WEEPINBELL
    TYPE_GRASS | 2 << 5 | 0 << 7,   // SPECIES_VICTREEBEL
    TYPE_WATER | 0 << 5 | 1 << 7,   // SPECIES_TENTACOOL
    TYPE_WATER | 1 << 5 | 0 << 7,   // SPECIES_TENTACRUEL
    TYPE_ROCK | 0 << 5 | 1 << 7,   // SPECIES_GEODUDE
    TYPE_ROCK | 1 << 5 | 1 << 7,   // SPECIES_GRAVELER
    TYPE_ROCK | 2 << 5 | 0 << 7,   // SPECIES_GOLEM
    TYPE_FIRE | 0 << 5 | 1 << 7,   // SPECIES_PONYTA
    TYPE_FIRE | 1 << 5 | 0 << 7,   // SPECIES_RAPIDASH
    TYPE_WATER | 0 << 5 | 1 << 7,   // SPECIES_SLOWPOKE
    TYPE_WATER | 1 << 5 | 0 << 7,   // SPECIES_SLOWBRO
    TYPE_ELECTRIC | 0 << 5 | 1 << 7,   // SPECIES_MAGNEMITE
    TYPE_ELECTRIC | 1 << 5 | 0 << 7,   // SPECIES_MAGNETON
    TYPE_NORMAL | 0 << 5 | 0 << 7,   // SPECIES_FARFETCHD
    TYPE_NORMAL | 0 << 5 | 1 << 7,   // SPECIES_DODUO
    TYPE_NORMAL | 1 << 5 | 0 << 7,   // SPECIES_DODRIO
    TYPE_WATER | 0 << 5 | 1 << 7,   // SPECIES_SEEL
    TYPE_WATER | 1 << 5 | 0 << 7,   // SPECIES_DEWGONG
    TYPE_POISON | 0 << 5 | 1 << 7,   // SPECIES_GRIMER
    TYPE_POISON | 1 << 5 | 0 << 7,   // SPECIES_MUK
    TYPE_WATER | 0 << 5 | 1 << 7,   // SPECIES_SHELLDER
    TYPE_WATER | 1 << 5 | 0 << 7,   // SPECIES_CLOYSTER
    TYPE_GHOST | 0 << 5 | 1 << 7,   // SPECIES_GASTLY
    TYPE_GHOST | 1 << 5 | 1 << 7,   // SPECIES_HAUNTER
    TYPE_GHOST | 2 << 5 | 0 << 7,   // SPECIES_GENGAR
    TYPE_ROCK | 0 << 5 | 1 << 7,   // SPECIES_ONIX
    TYPE_PSYCHIC | 0 << 5 | 1 << 7,   // SPECIES_DROWZEE
    TYPE_PSYCHIC | 1 << 5 | 0 << 7,   // SPECIES_HYPNO
    TYPE_WATER | 0 << 5 | 1 << 7,   // SPECIES_KRABBY
    TYPE_WATER | 1 << 5 | 0 << 7,   // SPECIES_KINGLER
    TYPE_ELECTRIC | 0 << 5 | 1 << 7,   // SPECIES_VOLTORB
    TYPE_ELECTRIC | 1 << 5 | 0 << 7,   // SPECIES_ELECTRODE
    TYPE_GRASS | 0 << 5 | 1 << 7,   // SPECIES_EXEGGCUTE
    TYPE_GRASS | 1 << 5 | 0 << 7,   // SPECIES_EXEGGUTOR
    TYPE_GROUND | 0 << 5 | 1 << 7,   // SPECIES_CUBONE
    TYPE_GROUND | 1 << 5 | 0 << 7,   // SPECIES_MAROWAK
    TYPE_FIGHTING | 1 << 5 | 0 << 7,   // SPECIES_HITMONLEE
    TYPE_FIGHTING | 1 << 5 | 0 << 7,   // SPECIES_HITMONCHAN
    TYPE_NORMAL | 0 << 5 | 0 << 7,   // SPECIES_LICKITUNG
    TYPE_POISON | 0 << 5 | 1 << 7,   // SPECIES_KOFFING
    TYPE_POISON | 1 << 5 | 0 << 7,   // SPECIES_WEEZING
    TYPE_GROUND | 0 << 5 | 1 << 7,   // SPECIES_RHYHORN
    TYPE_GROUND | 1 << 5 | 0 << 7,   // SPECIES_RHYDON
    TYPE_NORMAL | 0 << 5 | 1 << 7,   // SPECIES_CHANSEY
    TYPE_GRASS | 0 << 5 | 0 << 7,   // SPECIES_TANGELA
    TYPE_NORMAL | 0 << 5 | 0 << 7,   // SPECIES_KANGASKHAN
    TYPE_WATER | 0 << 5 | 1 << 7,   // SPECIES_HORSEA
    TYPE_WATER | 1 << 5 | 1 << 7,   // SPECIES_SEADRA
    TYPE_WATER | 0 << 5 | 1 << 7,   // SPECIES_GOLDEEN
    TYPE_WATER | 1 << 5 | 0 << 7,   // SPECIES_SEAKING
    TYPE_WATER | 0 << 5 | 1 << 7,   // SPECIES_STARYU
    TYPE_WATER | 1 << 5 | 0 << 7,   // SPECIES_STARMIE
    TYPE_PSYCHIC | 0 << 5 | 0 << 7,   // SPECIES_MR_MIME
    TYPE_BUG | 0 << 5 | 1 << 7,   // SPECIES_SCYTHER
    TYPE_ICE | 1 << 5 | 0 << 7,   // SPECIES_JYNX
    TYPE_ELECTRIC | 1 << 5 | 0 << 7,   // SPECIES_ELECTABUZZ
    TYPE_FIRE | 1 << 5 | 0 << 7,   // SPECIES_MAGMAR
    TYPE_BUG | 0 << 5 | 0 << 7,   // SPECIES_PINSIR
    TYPE_NORMAL | 0 << 5 | 0 << 7,   // SPECIES_TAUROS
    TYPE_WATER | 0 << 5 | 1 << 7,   // SPECIES_MAGIKARP
    TYPE_WATER | 1 << 5 | 0 << 7,   // SPECIES_GYARADOS
    TYPE_WATER | 0 << 5 | 0 << 7,   // SPECIES_LAPRAS
    TYPE_NORMAL | 0 << 5 | 0 << 7,   // SPECIES_DITTO
    TYPE_NORMAL | 0 << 5 | 1 << 7,   // SPECIES_EEVEE
    TYPE_WATER | 1 << 5 | 0 << 7,   // SPECIES_VAPOREON
    TYPE_ELECTRIC | 1 << 5 | 0 << 7,   // SPECIES_JOLTEON
    TYPE_FIRE | 1 << 5 | 0 << 7,   // SPECIES_FLAREON
    TYPE_NORMAL | 0 << 5 | 1 << 7,   // SPECIES_PORYGON
    TYPE_ROCK | 0 << 5 | 1 << 7,   // SPECIES_OMANYTE
    TYPE_ROCK | 1 << 5 | 0 << 7,   // SPECIES_OMASTAR
    TYPE_ROCK | 0 << 5 | 1 << 7,   // SPECIES_KABUTO
    TYPE_ROCK | 1 << 5 | 0 << 7,   // SPECIES_KABUTOPS
    TYPE_ROCK | 0 << 5 | 0 << 7,   // SPECIES_AERODACTYL
    TYPE_NORMAL | 0 << 5 | 0 << 7,   // SPECIES_SNORLAX
    POOL_LEGENDARY | 0 << 5 | 0 << 7,   // SPECIES_ARTICUNO
    POOL_LEGENDARY | 0 << 5 | 0 << 7,   // SPECIES_ZAPDOS
    POOL_LEGENDARY | 0 << 5 | 0 << 7,   // SPECIES_MOLTRES
    TYPE_DRAGON | 0 << 5 | 1 << 7,   // SPECIES_DRATINI
    TYPE_DRAGON | 1 << 5 | 1 << 7,   // SPECIES_DRAGONAIR
    TYPE_DRAGON | 2 << 5 | 0 << 7,   // SPECIES_DRAGONITE
    POOL_LEGENDARY | 0 << 5 | 0 << 7,   // SPECIES_MEWTWO
    POOL_LEGENDARY | 0 << 5 | 0 << 7,   // SPECIES_MEW
    TYPE_GRASS | 0 << 5 | 1 << 7,   // SPECIES_CHIKORITA
    TYPE_GRASS | 1 << 5 | 1 << 7,   // SPECIES_BAYLEEF
    TYPE_GRASS | 2 << 5 | 0 << 7,   // SPECIES_MEGANIUM
    TYPE_FIRE | 0 << 5 | 1 << 7,   // SPECIES_CYNDAQUIL
    TYPE_FIRE | 1 << 5 | 1 << 7,   // SPECIES_QUILAVA
    TYPE_FIRE | 2 << 5 | 0 << 7,   // SPECIES_TYPHLOSION
    TYPE_WATER | 0 << 5 | 1 << 7,   // SPECIES_TOTODILE
    TYPE_WATER | 1 << 5 | 1 << 7,   // SPECIES_CROCONAW
    TYPE_WATER | 2 << 5 | 0 << 7,   // SPECIES_FERALIGATR
    TYPE_NORMAL | 0 << 5 | 1 << 7,   // SPECIES_SENTRET
    TYPE_NORMAL | 1 << 5 | 0 << 7,   // SPECIES_FURRET
    TYPE_NORMAL | 0 << 5 | 1 << 7,   // SPECIES_HOOTHOOT
    TYPE_NORMAL | 1 << 5 | 0 << 7,   // SPECIES_NOCTOWL
    TYPE_BUG | 0 << 5 | 1 << 7,   // SPECIES_LEDYBA
    TYPE_BUG | 1 << 5 | 0 << 7,   // SPECIES_LEDIAN
    TYPE_BUG | 0 << 5 | 1 << 7,   // SPECIES_SPINARAK
    TYPE_BUG | 1 << 5 | 0 << 7,   // SPECIES_ARIADOS
    TYPE_POISON | 2 << 5 | 0 << 7,   // SPECIES_CROBAT
    TYPE_WATER | 0 << 5 | 1 << 7,   // SPECIES_CHINCHOU
    TYPE_WATER | 1 << 5 | 0 << 7,   // SPECIES_LANTURN
    TYPE_ELECTRIC | 0 << 5 | 1 << 7,   // SPECIES_PICHU
    TYPE_FAIRY | 0 << 5 | 1 << 7,   // SPECIES_CLEFFA
    TYPE_NORMAL | 0 << 5 | 1 << 7,   // SPECIES_IGGLYBUFF
    TYPE_FAIRY | 0 << 5 | 1 << 7,   // SPECIES_TOGEPI
    TYPE_FAIRY | 1 << 5 | 0 << 7,   // SPECIES_TOGETIC
    TYPE_PSYCHIC | 0 << 5 | 1 << 7,   // SPECIES_NATU
    TYPE_PSYCHIC | 1 << 5 | 0 << 7,   // SPECIES_XATU
    TYPE_ELECTRIC | 0 << 5 | 1 << 7,   // SPECIES_MAREEP
    TYPE_ELECTRIC | 1 << 5 | 1 << 7,   // SPECIES_FLAAFFY
    TYPE_ELECTRIC | 2 << 5 | 0 << 7,   // SPECIES_AMPHAROS
    TYPE_GRASS | 2 << 5 | 0 << 7,   // SPECIES_BELLOSSOM
    TYPE_WATER | 1 << 5 | 1 << 7,   // SPECIES_MARILL
    TYPE_WATER | 2 << 5 | 0 << 7,   // SPECIES_AZUMARILL
    TYPE_ROCK | 0 << 5 | 0 << 7,   // SPECIES_SUDOWOODO
    TYPE_WATER | 2 << 5 | 0 << 7,   // SPECIES_POLITOED
    TYPE_GRASS | 0 << 5 | 1 << 7,   // SPECIES_HOPPIP
    TYPE_GRASS | 1 << 5 | 1 << 7,   // SPECIES_SKIPLOOM
    TYPE_GRASS | 2 << 5 | 0 << 7,   // SPECIES_JUMPLUFF
    TYPE_NORMAL | 0 << 5 | 0 << 7,   // SPECIES_AIPOM
    TYPE_GRASS | 0 << 5 | 1 << 7,   // SPECIES_SUNKERN
    TYPE_GRASS | 1 << 5 | 0 << 7,   // SPECIES_SUNFLORA
    TYPE_BUG | 0 << 5 | 0 << 7,   // SPECIES_YANMA
    TYPE_WATER | 0 << 5 | 1 << 7,   // SPECIES_WOOPER
    TYPE_WATER | 1 << 5 | 0 << 7,   // SPECIES_QUAGSIRE
    TYPE_PSYCHIC | 1 << 5 | 0 << 7,   // SPECIES_ESPEON
    TYPE_DARK | 1 << 5 | 0 << 7,   // SPECIES_UMBREON
    TYPE_DARK | 0 << 5 | 0 << 7,   // SPECIES_MURKROW
    TYPE_WATER | 1 << 5 | 0 << 7,   // SPECIES_SLOWKING
    TYPE_GHOST | 0 << 5 | 0 << 7,   // SPECIES_MISDREAVUS
    TYPE_PSYCHIC | 0 << 5 | 0 << 7,   // SPECIES_UNOWN
    TYPE_PSYCHIC | 1 << 5 | 0 << 7,   // SPECIES_WOBBUFFET
    TYPE_NORMAL | 0 << 5 | 0 << 7,   // SPECIES_GIRAFARIG
    TYPE_BUG | 0 << 5 | 1 << 7,   // SPECIES_PINECO
    TYPE_BUG | 1 << 5 | 0 << 7,   // SPECIES_FORRETRESS
    TYPE_NORMAL | 0 << 5 | 0 << 7,   // SPECIES_DUNSPARCE
    TYPE_GROUND | 0 << 5 | 0 << 7,   // SPECIES_GLIGAR
    TYPE_STEEL | 1 << 5 | 0 << 7,   // SPECIES_STEELIX
    TYPE_FAIRY | 0 << 5 | 1 << 7,   // SPECIES_SNUBBULL
    TYPE_FAIRY | 1 << 5 | 0 << 7,   // SPECIES_GRANBULL
    TYPE_WATER | 0 << 5 | 0 << 7,   // SPECIES_QWILFISH
    TYPE_BUG | 1 << 5 | 0 << 7,   // SPECIES_SCIZOR
    TYPE_BUG | 0 << 5 | 0 << 7,   // SPECIES_SHUCKLE
    TYPE_BUG | 0 << 5 | 0 << 7,   // SPECIES_HERACROSS
    TYPE_DARK | 0 << 5 | 0 << 7,   // SPECIES_SNEASEL
    TYPE_NORMAL | 0 << 5 | 1 << 7,   // SPECIES_TEDDIURSA
    TYPE_NORMAL | 1 << 5 | 0 << 7,   // SPECIES_URSARING
    TYPE_FIRE | 0 << 5 | 1 << 7,   // SPECIES_SLUGMA
    TYPE_FIRE | 1 << 5 | 0 << 7,   // SPECIES_MAGCARGO
    TYPE_ICE | 0 << 5 | 1 << 7,   // SPECIES_SWINUB
    TYPE_ICE | 1 << 5 | 0 << 7,   // SPECIES_PILOSWINE
    TYPE_WATER | 0 << 5 | 0 << 7,   // SPECIES_CORSOLA
    TYPE_WATER | 0 << 5 | 1 << 7,   // SPECIES_REMORAID
    TYPE_WATER | 1 << 5 | 0 << 7,   // SPECIES_OCTILLERY
    TYPE_ICE | 0 << 5 | 0 << 7,   // SPECIES_DELIBIRD
    TYPE_WATER | 0 << 5 | 0 << 7,   // SPECIES_MANTINE
    TYPE_STEEL | 0 << 5 | 0 << 7,   // SPECIES_SKARMORY
    TYPE_DARK | 0 << 5 | 1 << 7,   // SPECIES_HOUNDOUR
    TYPE_DARK | 1 << 5 | 0 << 7,   // SPECIES_HOUNDOOM
    TYPE_WATER | 2 << 5 | 0 << 7,   // SPECIES_KINGDRA
    TYPE_GROUND | 0 << 5 | 1 << 7,   // SPECIES_PHANPY
    TYPE_GROUND | 1 << 5 | 0 << 7,   // SPECIES_DONPHAN
    TYPE_NORMAL | 1 << 5 | 0 << 7,   // SPECIES_PORYGON2
    TYPE_NORMAL | 0 << 5 | 0 << 7,   // SPECIES_STANTLER
    TYPE_NORMAL | 0 << 5 | 0 << 7,   // SPECIES_SMEARGLE
    TYPE_FIGHTING | 0 << 5 | 1 << 7,   // SPECIES_TYROGUE
    TYPE_FIGHTING | 1 << 5 | 0 << 7,   // SPECIES_HITMONTOP
    TYPE_ICE | 0 << 5 | 1 << 7,   // SPECIES_SMOOCHUM
    TYPE_ELECTRIC | 0 << 5 | 1 << 7,   // SPECIES_ELEKID
    TYPE_FIRE | 0 << 5 | 1 << 7,   // SPECIES_MAGBY
    TYPE_NORMAL | 0 << 5 | 0 << 7,   // SPECIES_MILTANK
    TYPE_NORMAL | 1 << 5 | 0 << 7,   // SPECIES_BLISSEY
    POOL_LEGENDARY | 0 << 5 | 0 << 7,   // SPECIES_RAIKOU
    POOL_LEGENDARY | 0 << 5 | 0 << 7,   // SPECIES_ENTEI
    POOL_LEGENDARY | 0 << 5 | 0 << 7,   // SPECIES_SUICUNE
    TYPE_ROCK | 0 << 5 | 1 << 7,   // SPECIES_LARVITAR
    TYPE_ROCK | 1 << 5 | 1 << 7,   // SPECIES_PUPITAR
    TYPE_ROCK | 2 << 5 | 0 << 7,   // SPECIES_TYRANITAR
    POOL_LEGENDARY | 0 << 5 | 0 << 7,   // SPECIES_LUGIA
    POOL_LEGENDARY | 0 << 5 | 0 << 7,   // SPECIES_HO_OH
    POOL_LEGENDARY | 0 << 5 | 0 << 7,   // SPECIES_CELEBI
    TYPE_GRASS | 0 << 5 | 1 << 7,   // SPECIES_TREECKO
    TYPE_GRASS | 1 << 5 | 1 << 7,   // SPECIES_GROVYLE
    TYPE_GRASS | 2 << 5 | 0 << 7,   // SPECIES_SCEPTILE
    TYPE_FIRE | 0 << 5 | 1 << 7,   // SPECIES_TORCHIC
    TYPE_FIRE | 1 << 5 | 1 << 7,   // SPECIES_COMBUSKEN
    TYPE_FIRE | 2 << 5 | 0 << 7,   // SPECIES_BLAZIKEN
    TYPE_WATER | 0 << 5 | 1 << 7,   // SPECIES_MUDKIP
    TYPE_WATER | 1 << 5 | 1 << 7,   // SPECIES_MARSHTOMP
    TYPE_WATER | 2 << 5 | 0 << 7,   // SPECIES_SWAMPERT
    TYPE_DARK | 0 << 5 | 1 << 7,   // SPECIES_POOCHYENA
    TYPE_DARK | 1 << 5 | 0 << 7,   // SPECIES_MIGHTYENA
    TYPE_NORMAL | 0 << 5 | 1 << 7,   // SPECIES_ZIGZAGOON
    TYPE_NORMAL | 1 << 5 | 0 << 7,   // SPECIES_LINOONE
    TYPE_BUG | 0 << 5 | 1 << 7,   // SPECIES_WURMPLE
    TYPE_BUG | 1 << 5 | 1 << 7,   // SPECIES_SILCOON
    TYPE_BUG | 2 << 5 | 0 << 7,   // SPECIES_BEAUTIFLY
    TYPE_BUG | 1 << 5 | 1 << 7,   // SPECIES_CASCOON
    TYPE_BUG | 2 << 5 | 0 << 7,   // SPECIES_DUSTOX
    TYPE_WATER | 0 << 5 | 1 << 7,   // SPECIES_LOTAD
    TYPE_WATER | 1 << 5 | 1 << 7,   // SPECIES_LOMBRE
    TYPE_WATER | 2 << 5 | 0 << 7,   // SPECIES_LUDICOLO
    TYPE_GRASS | 0 << 5 | 1 << 7,   // SPECIES_SEEDOT
    TYPE_GRASS | 1 << 5 | 1 << 7,   // SPECIES_NUZLEAF
    TYPE_GRASS | 2 << 5 | 0 << 7,   // SPECIES_SHIFTRY
    TYPE_NORMAL | 0 << 5 | 1 << 7,   // SPECIES_TAILLOW
    TYPE_NORMAL | 1 << 5 | 0 << 7,   // SPECIES_SWELLOW
    TYPE_WATER | 0 << 5 | 1 << 7,   // SPECIES_WINGULL
    TYPE_WATER | 1 << 5 | 0 << 7,   // SPECIES_PELIPPER
    TYPE_PSYCHIC | 0 << 5 | 1 << 7,   // SPECIES_RALTS
    TYPE_PSYCHIC | 1 << 5 | 1 << 7,   // SPECIES_KIRLIA
    TYPE_PSYCHIC | 2 << 5 | 0 << 7,   // SPECIES_GARDEVOIR
    TYPE_BUG | 0 << 5 | 1 << 7,   // SPECIES_SURSKIT
    TYPE_BUG | 1 << 5 | 0 << 7,   // SPECIES_MASQUERAIN
    TYPE_GRASS | 0 << 5 | 1 << 7,   // SPECIES_SHROOMISH
    TYPE_GRASS | 1 << 5 | 0 << 7,   // SPECIES_BRELOOM
    TYPE_NORMAL | 0 << 5 | 1 << 7,   // SPECIES_SLAKOTH
    TYPE_NORMAL | 1 << 5 | 1 << 7,   // SPECIES_VIGOROTH
    TYPE_NORMAL | 2 << 5 | 0 << 7,   // SPECIES_SLAKING
    TYPE_BUG | 0 << 5 | 1 << 7,   // SPECIES_NINCADA
    TYPE_BUG | 1 << 5 | 0 << 7,   // SPECIES_NINJASK
    TYPE_BUG | 1 << 5 | 0 << 7,   // SPECIES_SHEDINJA
    TYPE_NORMAL | 0 << 5 | 1 << 7,   // SPECIES_WHISMUR
    TYPE_NORMAL | 1 << 5 | 1 << 7,   // SPECIES_LOUDRED
    TYPE_NORMAL | 2 << 5 | 0 << 7,   // SPECIES_EXPLOUD
    TYPE_FIGHTING | 0 << 5 | 1 << 7,   // SPECIES_MAKUHITA
    TYPE_FIGHTING | 1 << 5 | 0 << 7,   // SPECIES_HARIYAMA
    TYPE_NORMAL | 0 << 5 | 1 << 7,   // SPECIES_AZURILL
    TYPE_ROCK | 0 << 5 | 0 << 7,   // SPECIES_NOSEPASS
    TYPE_NORMAL | 0 << 5 | 1 << 7,   // SPECIES_SKITTY
    TYPE_NORMAL | 1 << 5 | 0 << 7,   // SPECIES_DELCATTY
    TYPE_DARK | 0 << 5 | 0 << 7,   // SPECIES_SABLEYE
    TYPE_STEEL | 0 << 5 | 0 << 7,   // SPECIES_MAWILE
    TYPE_STEEL | 0 << 5 | 1 << 7,   // SPECIES_ARON
    TYPE_STEEL | 1 << 5 | 1 << 7,   // SPECIES_LAIRON
    TYPE_STEEL | 2 << 5 | 0 << 7,   // SPECIES_AGGRON
    TYPE_FIGHTING | 0 << 5 | 1 << 7,   // SPECIES_MEDITITE
    TYPE_FIGHTING | 1 << 5 | 0 << 7,   // SPECIES_MEDICHAM
    TYPE_ELECTRIC | 0 << 5 | 1 << 7,   // SPECIES_ELECTRIKE
    TYPE_ELECTRIC | 1 << 5 | 0 << 7,   // SPECIES_MANECTRIC
    TYPE_ELECTRIC | 0 << 5 | 0 << 7,   // SPECIES_PLUSLE
    TYPE_ELECTRIC | 0 << 5 | 0 << 7,   // SPECIES_MINUN
    TYPE_BUG | 0 << 5 | 0 << 7,   // SPECIES_VOLBEAT
    TYPE_BUG | 0 << 5 | 0 << 7,   // SPECIES_ILLUMISE
    TYPE_GRASS | 0 << 5 | 0 << 7,   // SPECIES_ROSELIA
    TYPE_POISON | 0 << 5 | 1 << 7,   // SPECIES_GULPIN
    TYPE_POISON | 1 << 5 | 0 << 7,   // SPECIES_SWALOT
    TYPE_WATER | 0 << 5 | 1 << 7,   // SPECIES_CARVANHA
    TYPE_WATER | 1 << 5 | 0 << 7,   // SPECIES_SHARPEDO
    TYPE_WATER | 0 << 5 | 1 << 7,   // SPECIES_WAILMER
    TYPE_WATER | 1 << 5 | 0 << 7,   // SPECIES_WAILORD
    TYPE_FIRE | 0 << 5 | 1 << 7,   // SPECIES_NUMEL
    TYPE_FIRE | 1 << 5 | 0 << 7,   // SPECIES_CAMERUPT
    TYPE_FIRE | 0 << 5 | 0 << 7,   // SPECIES_TORKOAL
    TYPE_PSYCHIC | 0 << 5 | 1 << 7,   // SPECIES_SPOINK
    TYPE_PSYCHIC | 1 << 5 | 0 << 7,   // SPECIES_GRUMPIG
    TYPE_NORMAL | 0 << 5 | 0 << 7,   // SPECIES_SPINDA
    TYPE_GROUND | 0 << 5 | 1 << 7,   // SPECIES_TRAPINCH
    TYPE_GROUND | 1 << 5 | 1 << 7,   // SPECIES_VIBRAVA
    TYPE_GROUND | 2 << 5 | 0 << 7,   // SPECIES_FLYGON
    TYPE_GRASS | 0 << 5 | 1 << 7,   // SPECIES_CACNEA
    TYPE_GRASS | 1 << 5 | 0 << 7,   // SPECIES_CACTURNE
    TYPE_NORMAL | 0 << 5 | 1 << 7,   // SPECIES_SWABLU
    TYPE_DRAGON | 1 << 5 | 0 << 7,   // SPECIES_ALTARIA
    TYPE_NORMAL | 0 << 5 | 0 << 7,   // SPECIES_ZANGOOSE
    TYPE_POISON | 0 << 5 | 0 << 7,   // SPECIES_SEVIPER
    TYPE_ROCK | 0 << 5 | 0 << 7,   // SPECIES_LUNATONE
    TYPE_ROCK | 0 << 5 | 0 << 7,   // SPECIES_SOLROCK
    TYPE_WATER | 0 << 5 | 1 << 7,   // SPECIES_BARBOACH
    TYPE_WATER | 1 << 5 | 0 << 7,   // SPECIES_WHISCASH
    TYPE_WATER | 0 << 5 | 1 << 7,   // SPECIES_CORPHISH
    TYPE_WATER | 1 << 5 | 0 << 7,   // SPECIES_CRAWDAUNT
    TYPE_GROUND | 0 << 5 | 1 << 7,   // SPECIES_BALTOY
    TYPE_GROUND | 1 << 5 | 0 << 7,   // SPECIES_CLAYDOL
    TYPE_ROCK | 0 << 5 | 1 << 7,   // SPECIES_LILEEP
    TYPE_ROCK | 1 << 5 | 0 << 7,   // SPECIES_CRADILY
    TYPE_ROCK | 0 << 5 | 1 << 7,   // SPECIES_ANORITH
    TYPE_ROCK | 1 << 5 | 0 << 7,   // SPECIES_ARMALDO
    TYPE_WATER | 0 << 5 | 1 << 7,   // SPECIES_FEEBAS
    TYPE_WATER | 1 << 5 | 0 << 7,   // SPECIES_MILOTIC
    TYPE_NORMAL | 0 << 5 | 0 << 7,   // SPECIES_CASTFORM
    TYPE_NORMAL | 0 << 5 | 0 << 7,   // SPECIES_KECLEON
    TYPE_GHOST | 0 << 5 | 1 << 7,   // SPECIES_SHUPPET
    TYPE_GHOST | 1 << 5 | 0 << 7,   // SPECIES_BANETTE
    TYPE_GHOST | 0 << 5 | 1 << 7,   // SPECIES_DUSKULL
    TYPE_GHOST | 1 << 5 | 0 << 7,   // SPECIES_DUSCLOPS
    TYPE_GRASS | 0 << 5 | 0 << 7,   // SPECIES_TROPIUS
    TYPE_PSYCHIC | 0 << 5 | 0 << 7,   // SPECIES_CHIMECHO
    TYPE_DARK | 0 << 5 | 0 << 7,   // SPECIES_ABSOL
    TYPE_PSYCHIC | 0 << 5 | 1 << 7,   // SPECIES_WYNAUT
    TYPE_ICE | 0 << 5 | 1 << 7,   // SPECIES_SNORUNT
    TYPE_ICE | 1 << 5 | 0 << 7,   // SPECIES_GLALIE
    TYPE_ICE | 0 << 5 | 1 << 7,   // SPECIES_SPHEAL
    TYPE_ICE | 1 << 5 | 1 << 7,   // SPECIES_SEALEO
    TYPE_ICE | 2 << 5 | 0 << 7,   // SPECIES_WALREIN
    TYPE_WATER | 0 << 5 | 1 << 7,   // SPECIES_CLAMPERL
    TYPE_WATER | 1 << 5 | 0 << 7,   // SPECIES_HUNTAIL
    TYPE_WATER | 1 << 5 | 0 << 7,   // SPECIES_GOREBYSS
    TYPE_WATER | 0 << 5 | 0 << 7,   // SPECIES_RELICANTH
    TYPE_WATER | 0 << 5 | 0 << 7,   // SPECIES_LUVDISC
    TYPE_DRAGON | 0 << 5 | 1 << 7,   // SPECIES_BAGON
    TYPE_DRAGON | 1 << 5 | 1 << 7,   // SPECIES_SHELGON
    TYPE_DRAGON | 2 << 5 | 0 << 7,   // SPECIES_SALAMENCE
    TYPE_STEEL | 0 << 5 | 1 << 7,   // SPECIES_BELDUM
    TYPE_STEEL | 1 << 5 | 1 << 7,   // SPECIES_METANG
    TYPE_STEEL | 2 << 5 | 0 << 7,   // SPECIES_METAGROSS
    POOL_LEGENDARY | 0 << 5 | 0 << 7,   // SPECIES_REGIROCK
    POOL_LEGENDARY | 0 << 5 | 0 << 7,   // SPECIES_REGICE
    POOL_LEGENDARY | 0 << 5 | 0 << 7,   // SPECIES_REGISTEEL
    POOL_LEGENDARY | 0 << 5 | 0 << 7,   // SPECIES_LATIAS
    POOL_LEGENDARY | 0 << 5 | 0 << 7,   // SPECIES_LATIOS
    POOL_LEGENDARY | 0 << 5 | 0 << 7,   // SPECIES_KYOGRE
    POOL_LEGENDARY | 0 << 5 | 0 << 7,   // SPECIES_GROUDON
    POOL_LEGENDARY | 0 << 5 | 0 << 7,   // SPECIES_RAYQUAZA
    POOL_LEGENDARY | 0 << 5 | 0 << 7,   // SPECIES_JIRACHI
    POOL_LEGENDARY | 0 << 5 | 0 << 7,   // SPECIES_DEOXYS
    TYPE_NORMAL | 1 << 5 | 0 << 7,   // SPECIES_ODEON
    TYPE_FIGHTING | 1 << 5 | 0 << 7,   // SPECIES_ASSASSEON
    TYPE_FLYING | 1 << 5 | 0 << 7,   // SPECIES_HYPEREON
    TYPE_POISON | 1 << 5 | 0 << 7,   // SPECIES_POISEON
    TYPE_GROUND | 1 << 5 | 0 << 7,   // SPECIES_SUBTERRANEON
    TYPE_ROCK | 1 << 5 | 0 << 7,   // SPECIES_OBSIDEON
    TYPE_BUG | 1 << 5 | 0 << 7,   // SPECIES_LENNEON
    TYPE_GHOST | 1 << 5 | 0 << 7,   // SPECIES_APPARITEON
    TYPE_STEEL | 1 << 5 | 0 << 7,   // SPECIES_AUTOMATEON
    TYPE_DRAGON | 1 << 5 | 0 << 7,   // SPECIES_VALYREON
};
