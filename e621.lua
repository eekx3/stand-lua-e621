util.require_natives("3095a", "g")
native_invoker.accept_bools_as_ints(true)
local SCRIPT_VERSION = "2.6.4"

local isDebugMode = false
local joaat, toast, yield, draw_debug_text, reverse_joaat = util.joaat, util.toast, util.yield, util.draw_debug_text, util.reverse_joaat

if SCRIPT_MANUAL_START then
end
local resources_dir = filesystem.resources_dir() .. '\\e621\\'
local store_dir = filesystem.store_dir() .. '\\e621\\'
local start_loading = directx.create_texture(resources_dir .. 'start.png')
if SCRIPT_MANUAL_START then
    logo_alpha = 0
    logo_alpha_incr = 0.01
    logo_alpha_thread = util.create_thread(function (thr)
        while true do
            logo_alpha = logo_alpha + logo_alpha_incr
            if logo_alpha > 1 then
                logo_alpha = 1
            elseif logo_alpha < 0 then 
                logo_alpha = 0
                util.stop_thread()
            end
            util.yield()
        end
    end)
    logo_thread = util.create_thread(function (thr)
        starttime = os.clock()
        local alpha = 0
        while true do
            directx.draw_texture(start_loading, 0.098, 0.098, 0.6, 0.5, 0.5, 0.5, 0, 1, 1, 1, logo_alpha) --directx.draw_texture(start_loading, 0.14, 0.14, 0.5, 0.5, 0.5, 0.5, 0, 1, 1, 1, logo_alpha)
            timepassed = os.clock() - starttime
            if timepassed > 3 then
                logo_alpha_incr = -0.01
            end
            if logo_alpha == 0 then
                util.stop_thread()
            end
            util.yield()
        end
    end)
end

local GlobalplayerBD = 2657921
local GlobalplayerBD_FM = 1845263
local GlobalplayerBD_FM_3 = 1886967

local gun_van_locations = {
    { name = "La Mesa", x = 729.6798, y = -736.43445, z = 26.240644 },
    { name = "La Mesa2", x = 971.3711, y = -1718.646, z = 30.504404 },
    { name = "Vespucci Beach", x = -1324.3976, y = -1163.7634, z = 4.6840196 },
    { name = "Paleto Bay", x = -31.904795, y = 6437.721, z = 31.450659 },
    { name = "Terminal", x = 779.1293, y = -3272.0833, z = 6.012522 },
    { name = "Tatavian Mountains", x = 1910.4598, y = 564.6093, z = 175.65532 },
    { name = "Sandy Shores", x = 1796.2365, y = 3896.4075, z = 34.02591 },
    { name = "Paleto Forest", x = -795.2769, y = 5402.7837, z = 34.10175 },
    { name = "Little Seoul", x = -473.65143, y = -741.56274, z = 30.563604 },
    { name = "Downtown Vinewood", x = 278.04364, y = 72.38032, z = 94.366356 },
    { name = "Mirror Park", x = 1098.1116, y = -337.02313, z = 67.2167 },
    { name = "North Chumash", x = -2165.6982, y = 4286.3994, z = 48.972054 },
    { name = "Palmen-Taylon Power Station", x = 2669.9106, y = 1469.542, z = 24.500776 },
    { name = "Murrieta Heights ", x = 1141.6555, y = -1358.6732, z = 34.617126 },
    { name = "Grand Senora Desert", x = 2343.5588, y = 3052.755, z = 48.151882 }
}

local cringe_locations = {
    { name = "City", command = "city", x = -598.0578, y = -715.8913, z = 131.04039 },
    { name = "LSIA", command = "lsia", x = -1335.8527, y = -3044.449, z = 13.944439 },
    { name = "Beach", command = "beach", x = -1443.6354, y = -1460.5477, z = 2.5691736 },
    { name = "Docks", command = "docks", x = 1020.8491, y = -3061.2935, z = 5.901044  },
    { name = "Maze Bank", command = "mb", x = -75.12867, y = -819.2142, z = 326.17514  },
    { name = "Del Perro", command = "dp", x = -1582.8209, y = -569.67413, z = 116.328445 },
    { name = "Sandy Shores", command = "sandy", x = 1674.1045, y = 3238.1682, z = 40.70262 },
}

local oob_locations = {
    { name = "Freakshop", x = 555.4394, y = -419.0929, z = -58.98762 },
    { name = "LSIA Metro Station", x = -872.9433, y = -2284.0183, z = 1.718886 },
    { name = "Zancudo Tunnel", x = -2603.019, y = 3010.4265, z = 12.422543 },
    { name = "Orbital Cannon", command = "orb", x = 331.3636, y = 4830.759, z = -59.40202, description = "You will need to own the 'Grand Senora Desert Facility' for this to work." },
    { name = "LSCM Interior", x = -2110.68, y = 1177.9203, z = 37.079876 },
    { name = "Aero's Home", x = 496.65686, y = -1467.392, z = 9.903037, description = "I was called a nigger for this." },
    { name = "LSIA Hangar Glitch", x = -1407.6158, y = -3288.1548, z = 24.585745 },
    { name = "Del Perro Lombank", x = -1576.7968, y = -576.2052, z = 45.107635 },
    { name = "Arcadius Glitch 1 ", command = "tg", x = -182.27792, y = -581.04913, z = 124.220276 },
    { name = "Arcadius Glitch 2", command = "tg2", x = -114.29317, y = -568.70154, z = 124.220245 },
    { name = "Arcadius Glitch 3", command = "tg3", x = -137.3184, y = -636.91113, z = 124.220245 },
    { name = "Murrieta Heights Drywall", x = 916.2871, y = -880.2023, z = 2.0877643, description = "Random drywall under the map." },
    { name = "Little Seoul Light", x = -448.24057, y = -605.90216, z = 1.2188458, description = "Little lamp under the map, close to the middle of LS." },
    { name = "MC Interior", x = 1004.10364, y = -3170.731, z = -30.022903 },
    { name = "Wind Farm OOB", x = 1209.9845, y = 1855.5875, z = -41.646027 },
    { name = "Santa Marina Rock", x = -1028.7477, y = -1865.7416, z = 3.1702237 },
    { name = "Sandy Shores Lamp", x = 2077.8765, y = 3862.9395, z = 1.1025487 },
    { name = "Terrorbyte Interior", command = "tbinter", x = -1419.0422, y = -3010.5852, z = -76.35101 },
    { name = "Submarine Interior", command = "sbinter", x = 1561.3093, y = 382.88113, z = -46.4849 },
    { name = "Under Map Beach Spot", command = "ump", x = -1078.0254, y = -1165.3585, z = -78.49683 },
    { name = "Tinsel Towers", command = "ump2", x = -614.6791, y = 47.121822, z = -178.77605 },
    { name = "Record A Studios", command = "ump3", x = -1010.5319, y = -58.991444, z = -94.59792 },
    { name = "Agency Garage", command = "ump4", x = -1072.477, y = -75.01728, z = -86.59713 },
    { name = "Rockford Hills Metro Station", x = -292.52103, y = -295.34946, z = 23.637678 },
    { name = "LSIA Terminal", x = -1051.7388, y = -2759.8142, z = 13.944587 },
    { name = "Apartment Interior", command = "opinter", x = 252.80753, y = -1001.6377, z = -96.010056, description = "Preferably have Levitation on when teleporting here." },
}

local interiors = {
    { name = "Creepy ass place", x = -1922.0615, y = 3749.7983, z = -99.64585, description = "I don't know what this is for, but the ambient music & noises in there make me uneasy." },
    { name = "Acid lab", x = 480.3165, y = -2623.9385, z = -47.227962, },
    { name = "Flying Shoes", x = -24.612347, y = -1463.7196, z = 41.772713 },
    { name = "Chilliad Tree", x = 1986.4318, y = 5726.588, z = 2.3640056 },
    { name = "prip's Home", x = 154.61754, y = -1004.18097, z = -98.41931 },
    { name = "prip's Home, But Outside", x = 150.92828, y = -1001.0686, z = -96.942215 },
    { name = "Your Home", command = "myhome", x = 932.1479, y = -2269.465, z = -50.406315 },
    { name = "Mugshot", x = 403.0112, y = -1002.5245, z = -99.004135 },
    { name = "Mugshot #2", x = 415.23752, y = -998.3157, z = -99.40417 },
    { name = "Warehouse Interior", x = 1006.4094, y = -3099.7756, z = -38.999916 },
    { name = "Winning Race Interior", x = 405.3385, y = -967.20825, z = -99.00419, description = "You want to teleport/levitate upwards and either fall or parachute on top of it in order to be able to see the outside world." },
    { name = "La Mesa Lamp Post", x = 692.2926, y = -900.46405, z = 1.3883853 },
    { name = "Random Fence", x = -2169.7388, y = 3068.5571, z = 2.6443794, description = "Literally just a floating fence under Fort Zancudo. The rotation resets on its own so you might just fall towards the void whenever you tp here." },
    { name = "Random Fence #2", x = 1025.8007, y = -2257.2246, z = 3.6108174, description = "Another one" },
    { name = "Salvage Yard", x = 1089.2979, y = -2276.842, z = -48.999935 },
    { name = "Nightclub Interior", x = -1618.4036, y = -3012.2046, z = -75.20511 },
    { name = "Arcade Interior", x = 2696.013, y = -369.06625, z = -54.78093 },
    { name = "Avenger Interior (LSIA)", command = "avengerlsiainterior", x = -880.7326, y = -2769.0347, z = -41.404156 },
    { name = "Casino Garage Interior", x = 1390.3984, y = 202.0952, z = -48.99538 },
    { name = "Lillium's eep place", x= -1869.1552, y = 3749.7407, z= -99.84548, description = "Lillium's fav place to sleep"},
}

local pearlTypes = {
    ["Metallic Black"] = 0, ["Metallic Graphite Black"] = 1, ["Metallic Black Steel"] = 2, ["Metallic Dark Silver"] = 3,
    ["Metallic Silver"] = 4, ["Metallic Blue Silver"] = 5, ["Metallic Steel Gray"] = 6, ["Metallic Shadow Silver"] = 7,
    ["Metallic Stone Silver"] = 8, ["Metallic Midnight Silver"] = 9, ["Metallic Gun Metal"] = 10, ["Metallic Anthracite Grey"] = 11,
    ["Matte Black"] = 12, ["Matte Gray"] = 13, ["Matte Light Grey"] = 14, ["Util Black"] = 15, ["Util Black Poly"] = 16,
    ["Util Dark silver"] = 17, ["Util Silver"] = 18, ["Util Gun Metal"] = 19, ["Util Shadow Silver"] = 20, ["Worn Black"] = 21,
    ["Worn Graphite"] = 22, ["Worn Silver Grey"] = 23, ["Worn Silver"] = 24, ["Worn Blue Silver"] = 25, ["Worn Shadow Silver"] = 26,
    ["Metallic Red"] = 27, ["Metallic Torino Red"] = 28, ["Metallic Formula Red"] = 29, ["Metallic Blaze Red"] = 30,
    ["Metallic Graceful Red"] = 31, ["Metallic Garnet Red"] = 32, ["Metallic Desert Red"] = 33, ["Metallic Cabernet Red"] = 34,
    ["Metallic Candy Red"] = 35, ["Metallic Sunrise Orange"] = 36, ["Metallic Classic Gold"] = 37, ["Metallic Orange"] = 38,
    ["Matte Red"] = 39, ["Matte Dark Red"] = 40, ["Matte Orange"] = 41, ["Matte Yellow"] = 42, ["Util Red"] = 43,
    ["Util Bright Red"] = 44, ["Util Garnet Red"] = 45, ["Worn Red"] = 46, ["Worn Golden Red"] = 47, ["Worn Dark Red"] = 48,
    ["Metallic Dark Green"] = 49, ["Metallic Racing Green"] = 50, ["Metallic Sea Green"] = 51, ["Metallic Olive Green"] = 52,
    ["Metallic Green"] = 53, ["Metallic Gasoline Blue Green"] = 54, ["Matte Lime Green"] = 55, ["Util Dark Green"] = 56,
    ["Util Green"] = 57, ["Worn Dark Green"] = 58, ["Worn Green"] = 59, ["Worn Sea Wash"] = 60, ["Metallic Midnight Blue"] = 61,
    ["Metallic Dark Blue"] = 62, ["Metallic Saxony Blue"] = 63, ["Metallic Blue"] = 64, ["Metallic Mariner Blue"] = 65,
    ["Metallic Harbor Blue"] = 66, ["Metallic Diamond Blue"] = 67, ["Metallic Surf Blue"] = 68, ["Metallic Nautical Blue"] = 69,
    ["Metallic Bright Blue"] = 70, ["Metallic Purple Blue"] = 71, ["Metallic Spinnaker Blue"] = 72, ["Metallic Ultra Blue"] = 73,
    ["Util Dark Blue"] = 75, ["Util Midnight Blue"] = 76, ["Util Blue"] = 77, ["Util Sea Foam Blue"] = 78, ["Util Lightning blue"] = 79,
    ["Util Maui Blue Poly"] = 80, ["Util Bright Blue"] = 81, ["Matte Dark Blue"] = 82, ["Matte Blue"] = 83, ["Matte Midnight Blue"] = 84,
    ["Worn Dark blue"] = 85, ["Worn Blue"] = 86, ["Worn Light blue"] = 87, ["Metallic Taxi Yellow"] = 88, ["Metallic Race Yellow"] = 89,
    ["Metallic Bronze"] = 90, ["Metallic Yellow Bird"] = 91, ["Metallic Lime"] = 92, ["Metallic Champagne"] = 93,
    ["Metallic Pueblo Beige"] = 94, ["Metallic Dark Ivory"] = 95, ["Metallic Choco Brown"] = 96, ["Metallic Golden Brown"] = 97,
    ["Metallic Light Brown"] = 98, ["Metallic Straw Beige"] = 99, ["Metallic Moss Brown"] = 100, ["Metallic Biston Brown"] = 101,
    ["Metallic Beechwood"] = 102, ["Metallic Dark Beechwood"] = 103, ["Metallic Choco Orange"] = 104, ["Metallic Beach Sand"] = 105,
    ["Metallic Sun Bleeched Sand"] = 106, ["Metallic Cream"] = 107, ["Util Brown"] = 108, ["Util Medium Brown"] = 109,
    ["Util Light Brown"] = 110, ["Metallic White"] = 111, ["Metallic Frost White"] = 112, ["Worn Honey Beige"] = 113,
    ["Worn Brown"] = 114, ["Worn Dark Brown"] = 115, ["Worn straw beige"] = 116, ["Brushed Steel"] = 117, ["Brushed Black steel"] = 118,
    ["Brushed Aluminium"] = 119, ["Chrome"] = 120, ["Worn Off White"] = 121, ["Util Off White"] = 122, ["Worn Orange"] = 123,
    ["Worn Light Orange"] = 124, ["Metallic Securicor Green"] = 125, ["Worn Taxi Yellow"] = 126, ["police car blue"] = 127,
    ["Matte Green"] = 128, ["Matte Brown"] = 129, ["Worn Orange"] = 130, ["Matte White"] = 131, ["Worn White"] = 132,
    ["Worn Olive Army Green"] = 133, ["Pure White"] = 134, ["Hot Pink"] = 135, ["Salmon pink"] = 136, ["Metallic Vermillion Pink"] = 137,
    ["Orange"] = 138, ["Green"] = 139, ["Blue"] = 140, ["Mettalic Black Blue"] = 141, ["Metallic Black Purple"] = 142,
    ["Metallic Black Red"] = 143, ["hunter green"] = 144, ["Metallic Purple"] = 145, ["Metaillic V Dark Blue"] = 146,
    ["MODSHOP BLACK1"] = 147, ["Matte Purple"] = 148, ["Matte Dark Purple"] = 149, ["Metallic Lava Red"] = 150,
    ["Matte Forest Green"] = 151, ["Matte Olive Drab"] = 152, ["Matte Desert Brown"] = 153, ["Matte Desert Tan"] = 154,
    ["Matte Foilage Green"] = 155, ["DEFAULT ALLOY COLOUR"] = 156, ["Epsilon Blue"] = 157, ["MP100 GOLD"] = 158, ["MP100 GOLD SATIN"] = 159,
    ["MP100 GOLD SPEC"] = 160
}

local trashWeapons = {
    "removegundoubleactionrevolver", "removegunteargas", "removegunhazardousjerrycan", "removegunproximitymine", "removegunjerrycan",
    "removegunbattlerifle", "removegunpumpshotgun", "removeguncarbinerifle","removeguncombatshotgun", "removegunadvancedrifle",
    "removegunbullpuprifle", "removeguncompactrifle", "removegunmilitaryrifle", "removegunheavyrifle", "removegunservicecarbine",
    "removegununholyhellbringer", "removegunmachinepistol", "removegunminismg", "removegunsmg", "removegunassaultsmg",
    "removeguncombatpdw", "removegunmg", "removegunmicrosmg", "removegungusenbergsweeper", "removegunnavyrevolver",
    "removegunwm29pistol", "removegunsnspistol", "removegunmarksmanpistol", "removegunmolotov", "removegungrenade",
    "removegunfireworklauncher", "removegunwidowmaker", "removegunbullpupshotgun", "removegunmusket", "removegunheavyshotgun",
    "removegundoublebarrelshotgun", "removegunsweepershotgun", "removegunprecisionrifle", "removeguntacticalsmg", "removegunpistol50"
}

local miscWeapons = {
    "removegunspecialcarbinemkii", "removegunassaultriflemkii", "removegunmarksmanriflemkii",
    "removegunpumpshotgunmkii", "removegunheavyrevolvermkii", "removegunpistolmkii", "removegunsawedoffshotgun",
    "removegunassaultshotgun", "removegunstonehatchet", "removeguncarbineriflemkii", "removegunflaregun",
    "removeguncombatmgmkii", "removegunupnatomizer", "removegunappistol", "removegunpistol",
}

local e621_messages = {
    -- Meow messages
    "Nya, purr!", "Meow, meow, purr, purr!", "Meow meow meow meow meow!", "Meow... *licks paw*",
    "Purr, meow!", "Nya, purr purr!", "Nya nya", "Meow meow!", "Purrrrrrr...", "Nya nya! Time for a cat nap.",
    "Purr purrr.. nya!", "Purr purr, meow!", "Nya... *licks paw*", "Meow, purr..", "Meow meow meow! Let's play!",
    "Purrrrrrr... *curls up*", "Meow!", "Meow meow meow...", "MEMEOEMWEMMOWEWEEMOWWWW", "MEOWEWME MEOW MEOWWW MEOEEWWOWW",
    "MRRRRPP", "Nya!", "Nya nya!", "Purr, purr, nya!", "Purr, purr, meow, meow!", "Meow, meow, purr!",
    "Nya, nya, purr!", "MEOWOMEWEWE MEOOWWW", "Mmrpfh.. Meoww", "MEOWOMEWEWE MEOOWWW", "Meow meow meow...",
    "MEMEOEMWEMMOWEWEEMOWWWW", "MEOWEWME MEOW MEOWWW MEOEEWWOWW", "MRRRRPP", "MEOWOMEWEWE MEOOWWW! Time for a cat nap.",
    "MEMEOEMWEMMOWEWEEMOWWWW!!", "MRRRRPP, meow!", "MEOWEWME... *licks paw*", "MEOOOOWWW MRRRPPP", "MEOWMEW MEMEOWWW",
    "MRPPP MEOOW MEMEOW", "MEMEOW MEOOWWWW", "MEOW MEOW MEMEOWWW", "MEMEMEM MEOWWWW", "MEOWOWOW MRRPPP",
    "MEOW MEW MEOWWWW", "MEOOOWWW MEMEOWWWW", "MEEEOWWWW", "MEOWW... MEOWWW", "MEOOOW MRRPPP",
    -- Woof messages
    "Bark bark woof!", "Woof woof bark!", "Bark bark... woof!", "Bark bark woof woof!", "Woof woof bark!",
    "Woof woof bark bark!", "Woof woof!", "Bark bark!", "Arf arf!", "Arf arf woof!", "Woof woof woof woof!",
    "Woof... *wags tail*", "Arffff...", "Arf arf arf!", "Woof woof arf arf!", "Bark bark woof woof!",
    "WOOF WOOF WOOF BARKBAKRABRK", "BARKBARK", "WOFOOWOFWWF WOOF", "BARKARBAKRK WOOF WOOF", "BARK BARK WOOOF!",
    "WOOOF WOOF WOOF WOOF", "WOOF WOOF... bark bark!", "BARK! WOOF! BARK!", "BARKBARK WOOF", "WOOF WOOOF WOOF",
    "BARKBARK! Time to play!", "WOOF WOOOF WOOF WOOOF!", "BARK BARK WOOF WOOF", "BARK! WOOF! BARK! WOOF!",
    "WOOF WOOF... *sniffs*", "BARK BARK... WOOF!", "WOOF WOOF! Let's go!", "BARK WOOF WOOF BARK",
    "WOOF WOOOF WOOF! BARK!",
    -- Additional message
    "BARK BARK BARK WOOF WOOF RUFF RUFF GRRR WOOOF RUFF RUFF BARK BARK WUFF AWOOOOOOOOOO AWOOOOOOOOOO BARK BRARK GRRR WOOF",
}

local CWeaponDamageEventTrigger = memory.rip(memory.scan("E8 ? ? ? ? 44 8B 65 80 41 FF C7") + 1)
enum eDamageFlags begin
	DF_None								= 0,
	DF_IsAccurate						= 1,
	DF_MeleeDamage						= 2,
	DF_SelfDamage						= 4,
	DF_ForceMeleeDamage					= 8,
	DF_IgnorePedFlags					= 16,
	DF_ForceInstantKill					= 32,
	DF_IgnoreArmor						= 64,
	DF_IgnoreStatModifiers				= 128,
	DF_FatalMeleeDamage					= 256,
	DF_AllowHeadShot					= 512,
	DF_AllowDriverKill					= 1024,
	DF_KillPriorToClearedWantedLevel	= 2048,
	DF_SuppressImpactAudio				= 4096,
	DF_ExpectedPlayerKill				= 8192,
	DF_DontReportCrimes					= 16384,
	DF_PtFxOnly							= 32768,
	DF_UsePlayerPendingDamage			= 65536,
	DF_AllowCloneMeleeDamage			= 131072,
	DF_NoAnimatedMeleeReaction			= 262144,
	DF_IgnoreRemoteDistCheck			= 524288,
	DF_VehicleMeleeHit					= 1048576,
	DF_EnduranceDamageOnly				= 2097152,
	DF_HealthDamageOnly					= 4194304,
	DF_DamageFromBentBullet				= 8388608
end

enum DRIVINGMODE begin
	DF_StopForCars					= 1,
	DF_StopForPeds					= 2,
	DF_SwerveAroundAllCars			= 4,
	DF_SteerAroundStationaryCars	= 8,
	DF_SteerAroundPeds				= 16,
	DF_SteerAroundObjects			= 32,
	DF_DontSteerAroundPlayerPed		= 64,
	DF_StopAtLights					= 128,
	DF_GoOffRoadWhenAvoiding		= 256,
	DF_DriveIntoOncomingTraffic		= 512,
	DF_DriveInReverse				= 1024,
	DF_UseWanderFallbackInsteadOfStraightLine = 2048,
	DF_AvoidRestrictedAreas			= 4096,
	DF_PreventBackgroundPathfinding		= 8192,
	DF_AdjustCruiseSpeedBasedOnRoadSpeed = 16384,
	DF_UseShortCutLinks				=  262144,
	DF_ChangeLanesAroundObstructions = 524288,
	DF_UseSwitchedOffNodes			=  2097152,
	DF_PreferNavmeshRoute			=  4194304,
	DF_PlaneTaxiMode				=  8388608,
	DF_ForceStraightLine			= 16777216,
	DF_UseStringPullingAtJunctions	= 33554432,
	DF_AvoidHighways				= 536870912,
	DF_ForceJoinInRoadDirection		= 1073741824
end

enum ENTER_EXIT_VEHICLE_FLAGS begin
	ECF_RESUME_IF_INTERRUPTED = 1,
	ECF_WARP_ENTRY_POINT = 2,
	ECF_JACK_ANYONE = 8,
	ECF_WARP_PED = 16,
	ECF_DONT_WAIT_FOR_VEHICLE_TO_STOP = 64,
	ECF_DONT_CLOSE_DOOR = 256,
	ECF_WARP_IF_DOOR_IS_BLOCKED = 512,
	ECF_JUMP_OUT = 4096,
	ECF_DONT_DEFAULT_WARP_IF_DOOR_BLOCKED = 65536,
	ECF_USE_LEFT_ENTRY = 131072,
	ECF_USE_RIGHT_ENTRY = 262144,
	ECF_JUST_PULL_PED_OUT = 524288,
	ECF_BLOCK_SEAT_SHUFFLING = 1048576,
	ECF_WARP_IF_SHUFFLE_LINK_IS_BLOCKED = 4194304,
	ECF_DONT_JACK_ANYONE = 8388608,
	ECF_WAIT_FOR_ENTRY_POINT_TO_BE_CLEAR = 16777216
end

local object_stuff = {
	{util.joaat("prop_ld_ferris_wheel"), "Ferris Wheel"},
	{util.joaat("p_spinning_anus_s"), "UFO"},
	{util.joaat("prop_windmill_01"), "Windmill"},
	{util.joaat("prop_staticmixer_01"), "Cement Mixer"},
	{util.joaat("prop_towercrane_02a"), "Tower Crane"},
	{util.joaat("des_scaffolding_root"), "Scaffolding"},
	{util.joaat("stt_prop_stunt_bowling_ball"), "Big Bowling Ball"},
	{util.joaat("stt_prop_stunt_soccer_ball"), "Big Soccer Ball"},
	{util.joaat("prop_juicestand"), "Big Orange Ball"},
	{util.joaat("stt_prop_stunt_jump_l"), "Stunt Ramp"},
}

local warnings = {
	joaat("NT_INV"),
	joaat("NT_INV_FREE"),
	joaat("NT_INV_PARTY_INVITE"),
	joaat("NT_INV_PARTY_INVITE_MP"),
	joaat("NT_INV_PARTY_INVITE_MP_SAVE"),
	joaat("NT_INV_PARTY_INVITE_SAVE"),
	joaat("NT_INV_MP_SAVE"),
	joaat("NT_INV_SP_SAVE"),
}

local transactionWarnings = {
	joaat("CTALERT_F"),
	joaat("CTALERT_F_1"),
	joaat("CTALERT_F_2"),
	joaat("CTALERT_F_3"),
	joaat("CTALERT_F_4"),
}

local colours = {
	{-1, "Default"},
	{1, "White"},
	{28, "Pastel Red"},
	{57, "Pastel Light Red"},
	{27, "Red"},
	{48, "Pastel Blue"},
	{26, "Blue"},
	{116, "Dark Blue"},
	{211, "Cyan"},
	{18, "Green"},
	{21, "Violet"},
	{49, "Purple"},
	{24, "Magenta"},
	{30, "Pink"},
	{45, "Pastel Pink"},
	{46, "Lime Green"},
	{12, "Yellow"},
	{109, "Gold"},
	{31, "Pastel Orange"},
	{15, "Orange"},
}

local randomPeds = {
	joaat("a_f_y_topless_01"),
	joaat("s_m_m_movalien_01"),
	joaat("s_m_y_mime"), 
	joaat("u_m_y_militarybum"),
	joaat("a_m_y_indian_01"),
	joaat("s_m_y_clown_01"),
	joaat("u_m_y_burgerdrug_01"),
	joaat("u_m_m_yulemonster")
}

local function createRandomPed(pos)
	local mdlHash = randomPeds[math.random(#randomPeds)]
	util.request_model(mdlHash)
	return entities.create_ped(26, mdlHash, pos, 0)
end

local root = menu.my_root()
local carYaw = 0
local carPitch = 0
local camYaw = 0
local camPitch = 0
local carFlySpeedSelect = 5
local vehicleFly
local carFlySpeed = carFlySpeedSelect*10
local vehicleFlyCheck
local noClipCar
local yourself
local carUsed
local keepMomentum = false

vect = {
	['new'] = function(x, y, z)
		return {['x'] = x, ['y'] = y, ['z'] = z}
	end,
	['subtract'] = function(a, b)
		return vect.new(a.x-b.x, a.y-b.y, a.z-b.z)
	end,
	['add'] = function(a, b)
		return vect.new(a.x+b.x, a.y+b.y, a.z+b.z)
	end,
	['mag'] = function(a)
		return math.sqrt(a.x^2 + a.y^2 + a.z^2)
	end,
	['norm'] = function(a)
		local mag = vect.mag(a)
		return vect.div(a, mag)
	end,
	['mult'] = function(a, b)
		return vect.new(a.x*b, a.y*b, a.z*b)
	end, 
	['div'] = function(a, b)
		return vect.new(a.x/b, a.y/b, a.z/b)
	end, 
	['dist'] = function(a, b) --returns the distance between two vectors
		return vect.mag(vect.subtract(a, b) )
	end
}

enum Labels begin
	CMDOTH = -1974706693,
	BLIPNFND = -1331937481,
	DT_T = -766393174,
	PLYNVEH = 1067523721,
	STNDUSR = 1729001290,
	TOOFAST = 1669138996
end

if vehicle == 0 then
    util.toast(lang.get_localised(1067523721):gsub("{}", players.get_name(playerID)))
    return 
end

function SET_ENT_FACE_ENT(ent1, ent2)
	local a = ENTITY.GET_ENTITY_COORDS(ent1)
	local b = ENTITY.GET_ENTITY_COORDS(ent2)
	local dx = b.x - a.x
	local dy = b.y - a.y
	local heading = MISC.GET_HEADING_FROM_VECTOR_2D(dx, dy)
	return ENTITY.SET_ENTITY_HEADING(ent1, heading)
end

local function isNetPlayerOk(playerID, assert_playing = false, assert_done_transition = true)
	if not NETWORK_IS_PLAYER_ACTIVE(playerID) then return false end
	if assert_playing and not IS_PLAYER_PLAYING(playerID) then return false end
	if assert_done_transition then
		if playerID == memory.read_int(memory.script_global(2672741 + 3)) then
			return memory.read_int(memory.script_global(2672741 + 2)) != 0
		elseif memory.read_int(memory.script_global(GlobalplayerBD + 1 + (playerID * 463))) != 4 then -- Global_2657921[iVar0 /*463*/] != 4
			return false
		end
	end
	return true
end

local function bitTest(bits, place)
	return (bits & (1 << place)) != 0
end

local function setBit(addr: number, bit: number)
	memory.write_int(addr, memory.read_int(addr) | 1 << bit)
end

local function clearBit(addr: number, bit: number)
	memory.write_int(addr, memory.read_int(addr) ~ 1 << bit)
end

local function isPlayerUsingOrbitalCannon(playerID)
	return bitTest(memory.read_int(memory.script_global(GlobalplayerBD + 1 + (playerID * 463) + 424)), 0) -- Global_2657921[PLAYER::PLAYER_ID() /*463*/].f_424
end

local function isPlayerRidingRollerCoaster(playerID)
	return bitTest(memory.read_int(memory.script_global(GlobalplayerBD_FM + 1 + (playerID * 877) + 873)), 15) -- Global_1845263[PLAYER::PLAYER_ID() /*877*/].f_873
end

local function getPlayerJobPoints(playerID)
	return memory.read_int(memory.script_global(GlobalplayerBD_FM + 1 + (playerID * 877) + 9))  -- Global_1845263[PLAYER::PLAYER_ID() /*877*/].f_9
end

local function getPlayerCurrentInterior(playerID)
	if not isNetPlayerOk(playerID) then return end -- to prevent random access violations
	return memory.read_int(memory.script_global(GlobalplayerBD + 1 + (playerID * 463) + 245)) -- Global_2657921[bVar0 /*463*/].f_245
end

local function IsPlayerInRcBandito(player)
    return BitTest(memory.read_int(memory.script_global(1853910 + (player * 834 + 1) + 267 + 348)), 29)  -- Global_1853910[PLAYER::PLAYER_ID() /*834*/].f_267.f_348, 29
end

local function IsPlayerInRcTank(player)
    return BitTest(memory.read_int(memory.script_global(1853910 + (player * 834 + 1) + 267 + 428 + 2)), 16) -- Global_1853910[PLAYER::PLAYER_ID() /*862*/].f_267.f_428.f_2
end

local function GetSpawnState(pid)
    return memory.read_int(memory.script_global(((2657589 + 1) + (pid * 466)) + 232)) -- Global_2657589[PLAYER::PLAYER_ID() /*466*/].f_232
end

local function GetInteriorPlayerIsIn(pid)
    return memory.read_int(memory.script_global(((2657589 + 1) + (pid * 466)) + 245)) -- Global_2657589[bVar0 /*466*/].f_245)
end

local function isFreemodeActive(playerID)
	return NETWORK_IS_PLAYER_A_PARTICIPANT_ON_SCRIPT(playerID, "freemode", -1)
end

local function getTransitionState()
	return memory.read_int(memory.script_global(1575008))  
end

local function isPlayerInInterior(playerID)
	if not isNetPlayerOk(playerID) then return end
    return GET_INTERIOR_GROUP_ID(getPlayerCurrentInterior(playerID)) == 0 and getPlayerCurrentInterior(playerID) != 0 or players.is_in_interior(playerID)
end

local function getPlayerCurrentShop(playerID)
	if not isNetPlayerOk(playerID) then return end
	return memory.read_int(memory.script_global(GlobalplayerBD + 1 + (playerID * 463) + 246)) -- Global_2657921[bVar0 /*463*/].f_246
end

local function isPlayerInCutscene(playerID)
	return NETWORK_IS_PLAYER_IN_MP_CUTSCENE(playerID) or IS_PLAYER_IN_CUTSCENE(playerID)
end

local function isPlayerGodmode(playerID)
	local pos = players.get_position(playerID)
	local ped = GET_PLAYER_PED_SCRIPT_INDEX(playerID)
	if isNetPlayerOk(playerID) and (players.is_godmode(playerID) or entities.is_invulnerable(ped)) and not isPlayerInInterior(playerID) and not isPlayerInCutscene(playerID) 
	and isFreemodeActive(playerID) and not players.is_using_rc_vehicle(playerID) and not isPlayerRidingRollerCoaster(playerID) and pos.z > 0.0 then
		return true
	end
	return false
end

local function getSeatPedIsIn(ped)
	local vehicle = GET_VEHICLE_PED_IS_USING(ped)
	if vehicle == 0 then
		return nil
	end
	local num_of_seats = GET_VEHICLE_MODEL_NUMBER_OF_SEATS(GET_ENTITY_MODEL(vehicle))
	for i = -1, num_of_seats - 1 do
		local ped_in_seat = GET_PED_IN_VEHICLE_SEAT(vehicle, i)
		if ped_in_seat == ped then
			return i
		end
	end
end

local function isPlayerInAnyVehicle(playerID)
	local ped = GET_PLAYER_PED_SCRIPT_INDEX(playerID)
	return IS_PED_IN_ANY_VEHICLE(ped) and not IS_REMOTE_PLAYER_IN_NON_CLONED_VEHICLE(playerID)
end

local function isDetectionPresent(playerID, detection)
	if players.exists(playerID) and menu.player_root(playerID):isValid() then
		for menu.player_root(playerID):getChildren() as cmd do
			if cmd:getType() == COMMAND_LIST_CUSTOM_SPECIAL_MEANING and cmd:refByRelPath(detection):isValid() and players.exists(playerID) then
				return true
			end
		end
	end
	return false
end

local function loadPtfxAsset(assetName)
	while not HAS_NAMED_PTFX_ASSET_LOADED(assetName) do
		REQUEST_NAMED_PTFX_ASSET(assetName)
		yield()
	end
end

local function getTeamID(playerID)
	if not isNetPlayerOk(playerID) then return end
	local ped = GET_PLAYER_PED_SCRIPT_INDEX(playerID)
	local pPed = entities.handle_to_pointer(ped)
	local net_obj = memory.read_long(pPed + 0xD0)
	if net_obj == 0 then return end
	local teamID = memory.read_byte(net_obj + 0x469)
	if net_obj != 0 and teamID != 6 then
		return teamID
	end
end

local function getInstanceID(playerID)
	if not isNetPlayerOk(playerID) then return end 
	local ped = GET_PLAYER_PED_SCRIPT_INDEX(playerID)
	local pPed = entities.handle_to_pointer(ped)
	local net_obj = memory.read_long(pPed + 0xD0)
	if net_obj == 0 then return end
	local instanceID = memory.read_byte(net_obj + 0x46A)
	if net_obj != 0 and instanceID != 64 then
		return instanceID
	end
end

local function createRandomPed(pos)
	local mdlHash = randomPeds[math.random(#randomPeds)]
	util.request_model(mdlHash)
	return entities.create_ped(26, mdlHash, pos, 0)
end


local function RequestModel(hash, timeout)
    timeout = timeout or 3
    STREAMING.REQUEST_MODEL(hash)
    local end_time = os.time() + timeout
    repeat
        util.yield()
    until STREAMING.HAS_MODEL_LOADED(hash) or os.time() >= end_time
    return STREAMING.HAS_MODEL_LOADED(hash)
end
local function IsPlayerFlyingAnyDrone(player)
   return BitTest(memory.read_int(memory.script_global(1853910 + (player * 862 + 1) + 267 + 365)), 26) -- Global_1853910[PLAYER::PLAYER_ID() /*862*/].f_267.f_365, 26
end
local function getSeatPedIsIn(ped)
	local vehicle = GET_VEHICLE_PED_IS_USING(ped)
	if vehicle == 0 then
		return nil
	end
	local num_of_seats = GET_VEHICLE_MODEL_NUMBER_OF_SEATS(GET_ENTITY_MODEL(vehicle))
	for i = -1, num_of_seats - 1 do
		local ped_in_seat = GET_PED_IN_VEHICLE_SEAT(vehicle, i)
		if ped_in_seat == ped then
			return i
		end
	end
end

local function get_transition_state(pid)
    return memory.read_int(memory.script_global(((2657589 + 1) + (pid * 466)) + 232)) -- Global_2657589[PLAYER::PLAYER_ID() /*466*/].f_232
end

local function get_interior_player_is_in(pid)
    return memory.read_int(memory.script_global(((2657589 + 1) + (pid * 466)) + 245)) -- Global_2657589[bVar0 /*466*/].f_245
end

local function is_player_in_interior(pid)
    return (memory.read_int(memory.script_global(2657589 + 1 + (pid * 466) + 245)) ~= 0)
end

local function player_toggle_loop(root, pid, menu_name, command_names, help_text, callback)
    return menu.toggle_loop(root, menu_name, command_names, help_text, function()
        if not players.exists(pid) then util.stop_thread() end
        callback()
    end)
end

local spawned_objects = {}
local function request_model(hash)
    STREAMING.REQUEST_MODEL(hash)
    while not STREAMING.HAS_MODEL_LOADED(hash) do
        util.yield()
    end
end

local function getSeatPedIsIn(ped)
	local vehicle = GET_VEHICLE_PED_IS_USING(ped)
	if vehicle == 0 then
		return nil
	end
	local num_of_seats = GET_VEHICLE_MODEL_NUMBER_OF_SEATS(GET_ENTITY_MODEL(vehicle))
	for i = -1, num_of_seats - 1 do
		local ped_in_seat = GET_PED_IN_VEHICLE_SEAT(vehicle, i)
		if ped_in_seat == ped then
			return i
		end
	end
end

local spawned_objects = {}

local function BitTest(bits, place)
    return (bits & (1 << place)) ~= 0
end

local function handle_player_list(pid)
    local ref = menus[pid]
    if not players.exists(pid) then
        if ref then
            menu.delete(ref)
            menus[pid] = nil
        end
    end
end

local values = {
    [0] = 0,
    [1] = 50,
    [2] = 88,
    [3] = 160,
    [4] = 208,
}

local http_pending = false

local function fetch_file(base_url, url_specification, directory, file_name)

    if not async_http.have_access() then
        util.toast("This script needs access to the internet to get a needed file, please disable 'Disable Internet Access'.")
        util.stop_script()
    end

    local absolute_directory = filesystem.scripts_dir() .. directory
    local absolute_file_path = absolute_directory .. "/" .. file_name
    local relative_file_path = directory .. "/" .. file_name

    if not filesystem.exists(absolute_directory) then
        filesystem.mkdirs(absolute_directory)
    end

    local function on_http_success(result)

        local lib_download_err = select(2, load(result))
        if lib_download_err then
            util.toast(lib_download_err, TOAST_LOGGER | TOAST_ABOVE_MAP)
        end

        if not filesystem.exists(absolute_file_path) then
            file, file_error = io.open(absolute_file_path, "w+")

            if file then
                file:write(result)
                file:flush()
                file:close()
            else
                util.log("File error: " .. file_error)
            end
        end
        http_pending = false
    end

    local function on_http_fail(result)
        util.log("Failed to get file from url...")
        http_pending = false
    end

    http_pending = true

    async_http.init(tostring(base_url), tostring(url_specification), on_http_success, on_http_fail)
    async_http.dispatch()
    while http_pending do
        util.yield()
    end

    while not filesystem.exists(absolute_file_path) do
        util.yield()
    end

    util.require_no_lag(relative_file_path:gsub(".lua", ""))
end

fetch_file("raw.githubusercontent.com", "/Kreeako/kreeakos_lib/main/kreeakos_lib.lua", "lib", "kreeakos_lib.lua")

local llkr_notification_path = "Online>Reactions>Love Letter Kick Reactions>Notification"

local user_state = menu.get_state(command.get_ref(llkr_notification_path))

util.create_tick_handler(function()
    if online.in_session() then
        if client.player == client.session_host then
            if menu.get_state(command.get_ref(llkr_notification_path)) ~= "Disabled" then
                menu.set_state(command.get_ref(llkr_notification_path), "Disabled")
            end
        else
            if menu.get_state(command.get_ref(llkr_notification_path)) ~= user_state then
                menu.set_state(command.get_ref(llkr_notification_path), user_state)
            end
        end
    end
end)

-- Auto Updater from https://github.com/hexarobi/stand-lua-auto-updater
local status, auto_updater = pcall(require, "auto-updater")
if not status then
    local auto_update_complete = nil util.toast("Installing auto-updater...", TOAST_ALL)
    async_http.init("raw.githubusercontent.com", "/hexarobi/stand-lua-auto-updater/main/auto-updater.lua",
        function(result, headers, status_code)
            local function parse_auto_update_result(result, headers, status_code)
                local error_prefix = "Error downloading auto-updater: "
                if status_code ~= 200 then util.toast(error_prefix..status_code, TOAST_ALL) return false end
                if not result or result == "" then util.toast(error_prefix.."Found empty file.", TOAST_ALL) return false end
                filesystem.mkdir(filesystem.scripts_dir() .. "lib")
                local file = io.open(filesystem.scripts_dir() .. "lib\\auto-updater.lua", "wb")
                if file == nil then util.toast(error_prefix.."Could not open file for writing.", TOAST_ALL) return false end
                file:write(result) file:close() util.toast("Successfully installed auto-updater lib", TOAST_ALL) return true
            end
            auto_update_complete = parse_auto_update_result(result, headers, status_code)
        end, function() util.toast("Error downloading auto-updater lib. Update failed to download.", TOAST_ALL) end)
    async_http.dispatch() local i = 1 while (auto_update_complete == nil and i < 40) do util.yield(250) i = i + 1 end
    if auto_update_complete == nil then error("Error downloading auto-updater lib. HTTP Request timeout") end
    auto_updater = require("auto-updater")
end
if auto_updater == true then error("Invalid auto-updater lib. Please delete your Stand/Lua Scripts/lib/auto-updater.lua and try again") end

-- Run auto-update
local auto_update_config = {
    source_url="https://raw.githubusercontent.com/eekx3/stand-lua-e621/main/e621.lua",
    script_relpath=SCRIPT_RELPATH
}
-- auto_updater.run_auto_update(auto_update_config)

local shortcuts = {
    { name = "Restart Script", command = {"rsc"}, description = "", action = function() util.restart_script() end },
    { name = "New Session", command = {"ns"}, description = "", action = function() menu.trigger_commands("gosolopublic") end },
    { name = "Find Session", command = {"fs"}, description = "", action = function() menu.trigger_commands("gopublic") end },
    { name = "Be Alone", command = {"ba"}, description = "", action = function() menu.trigger_commands("bealone") end },
}
local creditsList = {
    { name = "SetThreadContext", description = "Helping me understand how stuff works and giving me some things to copy paste" },
    { name = "Aero", description = "Silly Puppy" },
    { name = "Kreeako", description = "Fixed the code for the EWO function and had 'DisableLoveLetterKickNotificationsWhileHost' appended to the script without her knowledge." },
    { name = "Lillium", description = "Silly :3" },
    { name = "Ilana", description = "" },
    { name = "SimeonFootJobs", description = "SimeonCheapFootJobs" },
}

if not SCRIPT_SILENT_START then
    util.toast("HIHHIHIHIHIHI " .. players.get_name(players.user()) .. " !! >~< \nWELCOMEEEE CUTIE, MWAUHHH :3" .. "\ne621 - v" .. SCRIPT_VERSION)
end

--#root
local my_root = menu.my_root()
local self = my_root:list("Self", {"eself"})
local weapons = my_root:list("Weapons", {"eweapons"})
local vehicle = my_root:list("Vehicle", {"eveh"})
local online = my_root:list("Online", {"eonline"})
local world = my_root:list("World", {"eworld"})
local settings = my_root:list("Settings", {"esettings"})
local detections = my_root:list("Detections", {"edetection"})
local misc = my_root:list("Miscellaneous", {"emisc"})
--#menus
local selfMovement = self:list("Movement")
local vehicleCustomisation = vehicle:list("Vehicle Customisation")
local vehicleFly = vehicle:list("Vehicle Fly")
local playersList = online:list("Players")
local onlineGriefing = online:list("Griefing")
local onlineTrolling = online:list("Trolling")
local onlineChat = online:list("Chat")
local onlinePreMSG = onlineChat:list("Chat - Predefined Messages")
local teleports = world:list("Teleports")
local cleanse = world:list("Clear area")
local hudSettings = settings:list("HUD")
local freemodetweaks = settings:list("Freemode Tweaks")
local enhancements = settings:list("Enhancements")
local protections = settings:list("Protections")
local autoAccept = settings:list("Auto Accept")
local experimental = settings:list("Experimental", {}, "These are experimental for a reason.\nExpect some issues when using them.")
local credits = misc:list("Credits")
local e621githubHyperlink = misc:hyperlink("Changelog", "https://github.com/eekx3/stand-lua-e621", "")
local shortcuts_menu = menu.list(misc, "Shortcuts", {}, "", function() end)
for _, shortcut in ipairs(shortcuts) do
    if shortcut.toggle then
        menu.toggle(shortcuts_menu, shortcut.name, shortcut.command, shortcut.description, shortcut.toggle)
    else
        menu.action(shortcuts_menu, shortcut.name, shortcut.command, shortcut.description, shortcut.action)
    end
end
menu.set_visible(shortcuts_menu, false)
local shortcuts_menu_visible = false
local toggle_shortcuts_action = misc:toggle("Toggle Shortcuts", {}, "Show/Hide the shortcuts menu\nNote: The shortcuts are still available without this toggled, you just can't see them.", function(enabled)
    shortcuts_menu_visible = enabled
    menu.set_visible(shortcuts_menu, shortcuts_menu_visible)
end)
local developer_mode_enabled = false

menu.action(misc, "Check For Update", {}, "The script will automatically check for updates at most daily, but you can manually check using this option anytime.", function()
    auto_update_config.check_interval = 0
    util.toast("Checking for updates")
    auto_updater.run_auto_update(auto_update_config)
end)

local function createCreditAction(name, description)
    return function()
    end
end

for _, credit in ipairs(creditsList) do
    credits:action(credit.name, {}, credit.description, createCreditAction(credit.name, credit.description))
end

local menus = {}
local hasLink = {}
local function create_player_menu(playerID)
    if NETWORK_IS_SESSION_ACTIVE() and not menus[playerID] then
        local playerRoot = menu.player_root(playerID)
        menus[playerID] = playersList:list(players.get_name(playerID), {}, "", function()
            if not hasLink[playerID] then
                local spectateRef = menu.ref_by_rel_path(playerRoot, "Spectate")
                local griefingRef = menu.ref_by_rel_path(playerRoot, ">:33>Griefing")
                local trollingRef = menu.ref_by_rel_path(playerRoot, ">:33>Trolling")
                local miscellaneousRef = menu.ref_by_rel_path(playerRoot, ">:33>Miscellaneous")
                local godmodePlayerRef = menu.ref_by_rel_path(playerRoot, ">:33>Remove Player Godmode")
                local godmodeVehicleRef = menu.ref_by_rel_path(playerRoot, ">:33>Remove Vehicle Godmode")
                local orbitalStrikeRef = menu.ref_by_rel_path(playerRoot, ">:33>Orbital Strike")
                local orbitalStrikeGodmodeRef = menu.ref_by_rel_path(playerRoot, ">:33>Orbital Strike Godmode Player")
                
                if spectateRef and griefingRef and trollingRef and godmodePlayerRef and godmodeVehicleRef and orbitalStrikeRef and orbitalStrikeGodmodeRef then
                    menus[playerID]:link(spectateRef)
                    menus[playerID]:link(griefingRef)
                    menus[playerID]:link(trollingRef)
                    menus[playerID]:link(miscellaneousRef)
                    menus[playerID]:link(godmodePlayerRef)
                    menus[playerID]:link(godmodeVehicleRef)
                    menus[playerID]:link(orbitalStrikeRef)
                    menus[playerID]:link(orbitalStrikeGodmodeRef)
                    hasLink[playerID] = true
                else
                    util.toast("Error: Failed to get command references.", TOAST_DEFAULT)
                end
            end
        end)
    end
end

local function handle_player_list(playerID)
    local ref = menus[playerID]
    if not players.exists(playerID) then
        if ref then
            menu.delete(ref)
            menus[playerID] = nil
        end
    end
end

players.on_join(create_player_menu)
players.on_leave(handle_player_list)
players.dispatch_on_join()

menu.toggle_loop(freemodetweaks, "Disable Yacht Camera Shake", {"disableyachtcamerashake"}, "", function() --Credit to SetThreadContext for this.
    local val = memory.read_int(memory.script_global(262145 + 13319))
    if val != 1 then
    memory.write_int(memory.script_global(262145 + 13319), 1)
    end
end)

menu.toggle_loop(freemodetweaks, "Disable Yacht Defences", {}, "", function()
    local val = memory.read_int(memory.script_global(262145 + 13311))
    if val != 1 then
    memory.write_int(memory.script_global(262145 + 13311), 1)
    end
end)

menu.toggle_loop(freemodetweaks, "Disable RP Gain", {}, "Credits to Jesus_Is_Cap", function()
    memory.write_float(memory.script_global(262145 + 1), 0)
end, function()
    memory.write_float(memory.script_global(262145 + 1), 1)
end)

menu.toggle_loop(freemodetweaks, "Disable Casino Valet", {""}, "", function()
    local val = memory.read_int(memory.script_global(262145 + 27229))
    if val != 1 then
    memory.write_int(memory.script_global(262145 + 27229), 1)
    end
end)

menu.toggle_loop(freemodetweaks, "Disable Payphone Calls", {""}, "", function()
    local val = memory.read_int(memory.script_global(262145 + 32289))
    local val2 = memory.read_int(memory.script_global(262145 + 32288))
    local val3 = memory.read_float(memory.script_global(262145 + 32290))
    if val != 0 then
    memory.write_int(memory.script_global(262145 + 32289), 0)
    end
    if val2 != 0 then
    memory.write_int(memory.script_global(262145 + 32288), 0)
    end
    if val3 != 0 then
    memory.write_float(memory.script_global(262145 + 32290), 0.0)
    end
end)

menu.toggle_loop(freemodetweaks, "Enable Valentines Event", {""}, "", function()
    local val = memory.read_int(memory.script_global(262145 + 7131))
    if val != 1 then
    memory.write_int(memory.script_global(262145 + 7131), 1)
    end
end)

menu.toggle_loop(freemodetweaks, "Enable Independence Pack", {""}, "Not all features may be present/work", function()
    local val = memory.read_int(memory.script_global(262145 + 8436))
    local fireworks = memory.read_int(memory.script_global(262145 + 8445))
    if val != 1 then
    memory.write_int(memory.script_global(262145 + 8436), 1)
    memory.write_int(memory.script_global(262145 + 8445), 0)
    end
end)

menu.toggle_loop(freemodetweaks, "Disable Treasure Hunt", {""}, "", function()
    local val = memory.read_int(memory.script_global(262145 + 23655))
    if val == 1 then
        memory.write_int(memory.script_global(262145 + 23655), 0)
    end
end)

menu.toggle_loop(freemodetweaks, "Disable Simeon Showroom", {""}, "", function()
    local val = memory.read_int(memory.script_global(262145 + 33014))
    if val != 1 then
        memory.write_int(memory.script_global(262145 + 33014), 1)
    end
end)

menu.toggle_loop(freemodetweaks, "Block Music Locker Access", {""}, "", function()
    local val = memory.read_int(memory.script_global(1942781 + 4706 + 1))
    if not BitTest((memory.read_int(memory.script_global(1942781 + 4706 + 1))), 7) then
    memory.write_int(memory.script_global(1942781 + 4706 + 1), 128)
    end
end)

menu.toggle_loop(freemodetweaks, "Block RP Reset Telemetry", {""}, "", function()
    local val = memory.read_int(memory.script_global(262145 + 10255))
    if val != 1 then
    memory.write_int(memory.script_global(262145 + 10255), 1)
    end
end)

menu.toggle_loop(freemodetweaks, "Block Lester Player Bounty Cut", {""}, "", function()
    local val = memory.read_int(memory.script_global(262145 + 7178))
    if val != 0 then
    memory.write_int(memory.script_global(262145 + 7178), 0)
    end
end)

menu.toggle_loop(freemodetweaks, "Block Lester 'You have already set a Bounty'", {""}, "", function()
    local val = memory.read_int(memory.script_global(2738587 + 1893 + 1))
    if val != 0 then
    memory.write_int(memory.script_global(2738587 + 1893 + 1), 0)
    end
end)

menu.toggle_loop(freemodetweaks, "Disable Street Dealers", {""}, "", function()
    local val = memory.read_int(memory.script_global(262145 + 34551))
    if val != 0 then
        memory.write_int(memory.script_global(262145 + 34551), 0)
    end
end)

menu.toggle_loop(freemodetweaks, "Block G's Caches", {""}, "", function()
    local val = memory.read_int(memory.script_global(2707706 + 609))
    if val != 1 then
        memory.write_int(memory.script_global(2707706 + 609), 1)
    end
end)

menu.toggle_loop(freemodetweaks, "Block Junk Energy Skydives", {""}, "", function()
    local val = memory.read_int(memory.script_global(262145 + 33119))
    if val != 0 then
        memory.write_int(memory.script_global(262145 + 33119), 0)
    end
end)

menu.toggle_loop(freemodetweaks, "Block Freemode Missions", {""}, "Such as Gerald's stashes, Maude's Bounties etc", function()
    local val = memory.read_int(memory.script_global(262145 + 31220))
    if val != 0 then
        memory.write_int(memory.script_global(262145 + 31220), 0)
    end
end)

--#hud
hudSettings:toggle_loop("Display NAT Type In Overlay", {"displaynat"}, "", function()
	local natTypes = {"Open", "Moderate", "Strict"}
    local getNatType = util.stat_get_int64("_NatType")
    for nat, natType in natTypes do
        if getNatType == nat then
            draw_debug_text($"NAT Type: {natType}")
        end
    end
end)

local customTextDisplay = hudSettings:list("Custom Text Display", {})
local e621drawText = false
local textPositionX = 0.05
local textPositionY = 0
local customText = "Powered by e621.lua - v" .. SCRIPT_VERSION
local textSize = 0.5

customTextDisplay:toggle("Toggle Text Display", {"displaytext"}, "", function(state)
    e621drawText = state
end, false)
customTextDisplay:slider("Text Position X", {"hudtextx"}, "", 0, 1000, 50, 1, function(value)
    textPositionX = value / 1000
end)
customTextDisplay:slider("Text Position Y", {"hudtexty"}, "", 0, 1000, 0, 1, function(value)
    textPositionY = value / 1000
end)
customTextDisplay:slider("Text Size", {"textsize"}, "", 1, 100, 50, 1, function(value)
    textSize = value / 100
end)
customTextDisplay:text_input("Custom Text", {"customtext"}, "", function(input)
    customText = input
end, "Powered by e621.lua - v" .. SCRIPT_VERSION)

util.create_tick_handler(function()
    if e621drawText then
        directx.draw_text(textPositionX, textPositionY, customText, 1, textSize, 1, 1, 1, 1, true)
    end
end)

local overrideHudcolour = hudSettings:list("Change HUD Colour", {}, "Changes the colour of the weapon wheel and some other things.\nNote: Does not change the 'Custom Text' colour.")
local hudcolour = 57
overrideHudcolour:list_select("Colour", {}, "", colours, hudcolour, function(colours)
    hudcolour = colours
end)
overrideHudcolour:toggle_loop("Change HUD Colour", {}, "", function()
    SET_CUSTOM_MP_HUD_COLOR(hudcolour)
end)

--#protections
protections:toggle_loop("Block Ped Hijack", {"blockpedhijack"}, "", function()
	local vehicle = entities.get_user_vehicle_as_handle()
	if not IS_PED_IN_VEHICLE(players.user_ped(), vehicle, false) then return end
	for entities.get_all_peds_as_handles() as ped do
		local targetVehicle = GET_VEHICLE_PED_IS_TRYING_TO_ENTER(ped)
		local targetSeat = GET_SEAT_PED_IS_TRYING_TO_ENTER(ped)
		local owner = entities.get_owner(ped)
		if targetVehicle == vehicle and targetSeat == (seat := getSeatPedIsIn(players.user_ped())) and not IS_PED_A_PLAYER(ped) and owner != players.user() then
			entities.delete(ped)
			repeat
				SET_PED_INTO_VEHICLE(players.user_ped(), vehicle, seat)
				yield()
			until getSeatPedIsIn(players.user_ped()) == seat
			toast($"Prevented a Vehicle Takeover (Ped Hijack), likely caused by {players.get_name(owner)}")
			if not isDetectionPresent(owner, "Vehicle Hijack") then
				players.add_detection(owner, "Vehicle Hijack", TOAST_ALL, 75)
				break
			end
		end
	end
end)

protections:toggle_loop("Ghost Orbital Cannon", {"ghostorb"}, "", function()
	for players.list_except(true) as playerID do
		local ped = GET_PLAYER_PED_SCRIPT_INDEX(playerID)
		local pos = players.get_position(players.user())
		local distance = v3.distance(pos, v3.setZ(players.get_cam_pos(playerID), pos.z))
		if isPlayerUsingOrbitalCannon(playerID) and distance < 25.0 and not isPlayerInInterior(players.user()) then
			SET_REMOTE_PLAYER_AS_GHOST(playerID, true)
			repeat
				yield()
			until not isPlayerUsingOrbitalCannon(playerID)
			SET_REMOTE_PLAYER_AS_GHOST(playerID, false)
		end
	end
end, function()
	for players.list_except(true) as playerID do
		SET_REMOTE_PLAYER_AS_GHOST(playerID, false)
	end
end)

protections:toggle_loop("Ghost Modded Orbital Cannons", {"ghostmoddedorb"}, "", function()
	for players.list_except() as playerID do
		local ped = GET_PLAYER_PED_SCRIPT_INDEX(playerID)
		local cam_dist = v3.distance(players.get_position(players.user()), players.get_cam_pos(playerID))
		if isPlayerUsingOrbitalCannon(playerID) and not GET_IS_TASK_ACTIVE(ped, 135) then
			SET_REMOTE_PLAYER_AS_GHOST(playerID, true)
			repeat
				yield()
			until not isPlayerUsingOrbitalCannon(playerID)
			SET_REMOTE_PLAYER_AS_GHOST(playerID, false)
		end
	end
end, function()
	for players.list_except(true) as playerID do
		SET_REMOTE_PLAYER_AS_GHOST(playerID, false)
	end
end)

--#detections
local function tag_sender_as_e621_user(sender)
    if players.exists(sender) and util.is_session_started() then
        local player_name = players.get_name(sender) or "Unknown"
        if not menu.is_ref_valid(menu.ref_by_rel_path(menu.player_root(sender), "Classification: Modder>e621.lua user")) then
            players.add_detection(sender, "e621.lua user")
        end
    end
end
chat.on_message(function(sender, reserved, text, team_chat, networked, is_auto)
    if not is_auto then
        for _, msg in ipairs(e621_messages) do
            if text == msg then
                tag_sender_as_e621_user(sender)
                break
            end
        end
    end
end)

detections:toggle_loop("Bullshark Testosterone", {}, "Notifies you if a player has collected BST.", function()
    local data = memory.alloc(56 * 8)
    local user_id = players.user() -- Get the user ID

    for queue = 0, 2 do
        for index = 0, GET_NUMBER_OF_EVENTS(queue) - 1 do
            local event = GET_EVENT_AT_INDEX(queue, index)
            if event == 174 then
                if not GET_EVENT_DATA(queue, index, data, 54) then 
                    break 
                end
                if memory.read_int(data) == -584633745 then
                    local playerID = memory.read_int(data + 1 * 8)
                    if playerID ~= user_id then -- Check if the player is not the user
                        local playerName = players.get_name(playerID)
                        local message = string.format("%s has collected BST", playerName)
                        toast($"{players.get_name(playerID)} has collected BST", TOAST_CONSOLE)
                        toast($"{players.get_name(playerID)} has collected BST", TOAST_DEFAULT)
                    end
                end
            end
        end
    end
end)

detections:toggle_loop("Modded Orbital Cannon", {}, "Detects if someone is using a modded orbital cannon and displays the player name as info text.", function()
	for players.list_except(true) as playerID do
		local ped = GET_PLAYER_PED_SCRIPT_INDEX(playerID)
		if isPlayerUsingOrbitalCannon(playerID) and getPlayerCurrentInterior(playerID) != 269313 and not isDetectionPresent(playerID, "Modded Orbital Cannon") and isNetPlayerOk(playerID) then
			players.add_detection(playerID, "Modded Orbital Cannon", TOAST_ALL, 100)
			break
		end
	end
	yield(250)
end)

detections:toggle_loop("Orbital Cannon", {}, "Detects if someone is using an orbital cannon and displays the player name as info text.", function()
	for players.list_except(true) as playerID do
		local ped = GET_PLAYER_PED_SCRIPT_INDEX(playerID)
		local pos = players.get_position(players.user())
		local distance = v3.distance(pos, v3.setZ(players.get_cam_pos(playerID), pos.z))
		if isPlayerUsingOrbitalCannon(playerID) and GET_IS_TASK_ACTIVE(ped, 135) and getPlayerCurrentInterior(playerID) == 269313 then
			draw_debug_text($"{players.get_name(playerID)} is at the orbital cannon")
		end
		if isPlayerUsingOrbitalCannon(playerID) and GET_IS_TASK_ACTIVE(ped, 135) and distance < 25.0 and not isPlayerInInterior(players.user()) and getPlayerCurrentInterior(playerID) == 269313 then
			toast($"{players.get_name(playerID)} is targeting you with the orbital cannon")
		end
	end
end)

detections:toggle_loop("Damage Modifier", {}, "Detects menus with bad damage multiplier anti-detections that are not detected by stand.", function()
	local timer = util.current_time_millis() + 5000
	if NETWORK_IS_ACTIVITY_SESSION() then return end
	for players.list_except(true) as playerID do
		local pos = players.get_position(playerID)
		local ped = GET_PLAYER_PED_SCRIPT_INDEX(playerID)
		if isNetPlayerOk(players.user()) and isNetPlayerOk(playerID, true, true) and not isPlayerInInterior(playerID) and getPlayerJobPoints(playerID) == 0 then
			if players.get_weapon_damage_modifier(playerID) == 1 then
				repeat
					if players.get_weapon_damage_modifier(playerID) != 1 or not players.exists(playerID) then
						timer = util.current_time_millis() + 5000
						break
					end
					util.yield()
				until util.current_time_millis() > timer
				if util.current_time_millis() > timer and not isDetectionPresent(playerID, "Damage Modifier") then
					util.yield(1000)
					players.add_detection(playerID, "Damage Modifier", TOAST_ALL, 100)
					timer = util.current_time_millis() + 5000
					break
				end
			end
		end
		if isDetectionPresent(playerID, "Damage Modifier") then
			if players.get_weapon_damage_modifier(playerID) != 1 then
				for menu.player_root(playerID):getChildren() as cmd do
					if cmd:getType() == COMMAND_LIST_CUSTOM_SPECIAL_MEANING then
						cmd:refByRelPath("Damage Modifier"):trigger() -- pop the detection in the case of a false positive. (occurs when freemode fails to reset their damage multiplier back to 0.71 on spawn)
					end
				end
			end
		end
	end
	util.yield(250)
end)

detections:toggle_loop("2Take1 User", {}, "Detects people using 2Take1. (Note: player must be in a vehicle spawned by them)", function()
	for players.list_except() as playerID do
		local ped = GET_PLAYER_PED_SCRIPT_INDEX(playerID)
		local vehicle = GET_VEHICLE_PED_IS_USING(ped)
		local bitset = DECOR_GET_INT(vehicle, "MPBitset")
		local pegasusveh = DECOR_GET_BOOL(vehicle, "CreatedByPegasus")
		if isNetPlayerOk(playerID) and bitset == 1024 and players.get_weapon_damage_modifier(playerID) == 1 and not entities.is_invulnerable(ped) and not pegasusveh and getPlayerJobPoints(playerID) == 0 then
			if not isDetectionPresent(playerID, "2Take1 User") then
				players.add_detection(playerID, "2Take1 User", TOAST_ALL, 100)
				menu.trigger_commands($"historynote {players.get_name(playerID)} 2Take1 User")
				return
			end
		end
	end
	yield(250)
end)

detections:toggle_loop("YimMenu User", {}, "Detects people using YimMenu's \"Force Session Host\". This will also detect menus that have skidded from YimMenu such as Ethereal.", function()
	for players.list() as playerID do
		if tonumber(players.get_host_token(playerID)) == 41 then
			if not isDetectionPresent(playerID, "YimMenu User") then
				players.add_detection(playerID, "YimMenu User", TOAST_ALL, 100)
				menu.trigger_commands($"historynote {players.get_name(playerID)} YimMenu User")
				return
			end
		end
	end
	yield(250)
end)

detections:toggle_loop("Voice Chat", {"voicechat"}, "Detects who is talking in voice chat and displays the player name as info text.", function()
	for players.list_except() as playerID do
		if NETWORK_IS_PLAYER_TALKING(playerID) then
			draw_debug_text($"{players.get_name(playerID)} is talking")
		end
	end 
end)

local trackedPlayers = {}
local localPlayerName = players.get_name(players.user())
local loggingEnabled = false
local resources_dir = filesystem.resources_dir() .. '\\e621\\'
local playerDBFilePath = resources_dir .. "PlayerDB.md"
local loggedPlayersFilePath = resources_dir .. "LoggedPlayers.txt"

local function loadPlayerDB()
    local dbFile = io.open(playerDBFilePath, "r")
    if dbFile then
        for playerName in dbFile:lines() do
            trackedPlayers[playerName] = true
        end
        dbFile:close()
    end
end

local function savePlayerDB()
    local dbFile = io.open(playerDBFilePath, "w")
    if dbFile then
        for playerName in pairs(trackedPlayers) do
            dbFile:write(playerName .. "\n")
        end
        dbFile:close()
    end
end

local function logPlayerInfo(playerID, sesslog)
    if not loggingEnabled and not sesslog then return end
    local playerName = players.get_name(playerID)
    if playerName == localPlayerName or trackedPlayers[playerName] then return end

    local logFile = io.open(loggedPlayersFilePath, "a")
    if logFile then
        local dateSeen = os.date("%Y-%m-%d %H:%M:%S")
        local hostTokenHex = players.get_host_token_hex(playerID)
        logFile:write(string.format("Date Seen: %s \\ Name: %s \\ RID: %d \\ Host Token: %s\n", dateSeen, playerName, players.get_rockstar_id(playerID), hostTokenHex))
        logFile:close()

        trackedPlayers[playerName] = true
        savePlayerDB()
    else
        print("Failed to open log file for writing.")
    end
end

local function logPlayersInSession()
    for _, playerID in ipairs(players.list(false, true, true)) do
        logPlayerInfo(playerID, true)
    end
end

players.on_join(logPlayerInfo)
loadPlayerDB()
logPlayersInSession()
players.dispatch_on_join()

detections:toggle("Player Logging", {"playerlogging"}, "Logs players Name | RID | Host Token\nYou can find the txt file in:\n'Lua Scripts > Resources > e621'", function(toggle)
    loggingEnabled = toggle
end)

---#weapons
weapons:toggle_loop("Lock On To Players", {}, "Allows you to lock on to players with the homing launcher.", function()
	for players.list_except(true) as playerID do
		local ped = GET_PLAYER_PED_SCRIPT_INDEX(playerID)
		ADD_PLAYER_TARGETABLE_ENTITY(players.user(), ped)
		SET_ENTITY_IS_TARGET_PRIORITY(ped, false, 400.0)    
	end
end, function()
	for players.list_except(true) as playerID do
		local ped = GET_PLAYER_PED_SCRIPT_INDEX(playerID)
		REMOVE_PLAYER_TARGETABLE_ENTITY(players.user(), ped)
	end
end)

local lastExecutionTime = 0
local interval = 7500
weapons:toggle_loop("Remove Trash Weapons", {"removetrashweapons"}, "", function()
    local currentTime = util.current_time_millis()
    if currentTime - lastExecutionTime >= interval then
        for _, weaponCommand in ipairs(trashWeapons) do
            menu.trigger_commands(weaponCommand)
        end
        lastExecutionTime = currentTime
    end
end, function()
    lastExecutionTime = 0
end)

local function removeWeapons(weaponsList)
    for _, weaponCommand in ipairs(weaponsList) do
        menu.trigger_commands(weaponCommand)
    end
end
weapons:action("Remove Misc Weapons", {"removemiscweapons"}, "", function()
    removeWeapons(miscWeapons)
end)

---#vehicle
--#stunlock
vehicle:toggle_loop("Stun Lock", {}, "Mimics the ruiner 2000 stun lock for players trying to enter the vehicle when access is set to no-one.", function()
	for players.list_except(true) as playerID do
		local ped = GET_PLAYER_PED_SCRIPT_INDEX(playerID)
		local pPed =  entities.handle_to_pointer(ped)
		local pedPtr = entities.handle_to_pointer(players.user_ped())
		local vehicle = entities.get_user_vehicle_as_handle()
		local PersonalVehicle = DECOR_GET_INT(vehicle, "Player_Vehicle") != 0
		local boneCoords = GET_PED_BONE_COORDS(ped, 0xFCD9, v3())
		if GET_VEHICLE_DOORS_LOCKED_FOR_PLAYER(vehicle, playerID) and GET_VEHICLE_PED_IS_TRYING_TO_ENTER(ped) == vehicle and PersonalVehicle and IS_THIS_MODEL_A_CAR(GET_ENTITY_MODEL(vehicle)) then
			if HAS_ANIM_EVENT_FIRED(ped, -1526509349) then
				util.call_foreign_function(CWeaponDamageEventTrigger, pedPtr, pPed, boneCoords, 0, 1, joaat("weapon_stungun_mp"), 1.0, 0, 0, DF_IsAccurate | DF_IgnoreRemoteDistCheck, 0, 0, 0, 0, 0, 0, 0, 0.0)
				yield(1000)
			end
		end
	end
end)

--#accesslockedvehicle
vehicle:toggle_loop("Access Locked Vehicles", {"accesslockedvehicles"}, "", function()
	local vehicle = GET_VEHICLE_PED_IS_USING(players.user_ped())
	SET_VEHICLE_DOORS_LOCKED_FOR_PLAYER(vehicle, players.user(), false)
	DECOR_REMOVE(vehicle, "Player_Vehicle")
	SET_VEHICLE_EXCLUSIVE_DRIVER(vehicle, 0, 0)
end)

--#noradioentry
vehicle:toggle_loop("Disable Radio On Vehicle Entry", {}, "", function()
	local vehicle = GET_VEHICLE_PED_IS_USING(players.user_ped())
	if GET_PLAYER_RADIO_STATION_NAME() != "OFF" and GET_IS_VEHICLE_ENGINE_RUNNING(vehicle) then
		yield(150)
		SET_RADIO_TO_STATION_NAME("OFF")
		repeat
			local curVehicle = GET_VEHICLE_PED_IS_USING(players.user_ped())
			yield()
		until not IS_PED_IN_ANY_VEHICLE(players.user_ped()) or curVehicle != vehicle
	end
end)

--#disablevehgod
vehicle:toggle_loop("Disable Vehicle God On Exit", {}, "", function()
	local vehicle = entities.get_user_vehicle_as_handle()
	if entities.is_invulnerable(vehicle) then
		if not IS_PED_IN_ANY_VEHICLE(players.user_ped()) then
			SET_ENTITY_CAN_BE_DAMAGED(vehicle, true)
		end
	end
end)

--#pearlescents
local colourCategories = {
    Black = {"Black", "Graphite", "Anthracite", "Gun Metal"},
    Gray = {"Gray", "Silver", "Steel", "Shadow", "Stone"},
    Red = {"Red", "Garnet", "Desert", "Cabernet", "Candy", "Lava", "Graceful", "Golden"},
    Green = {"Green", "Olive", "Gasoline", "Lime", "Securicor", "hunter", "Forest", "Foliage", "Sea Wash"},
    Blue = {"Blue", "Midnight", "Saxony", "Mariner", "Harbor", "Diamond", "Surf", "Nautical", "Spinnaker", "Ultra"},
    Yellow = {"Yellow", "Taxi", "Race", "Bird"},
    Brown = {"Brown", "Choco", "Bronze", "Straw", "Moss", "Biston", "Beechwood", "Beach Sand", "Dark Ivory", "Pueblo Beige"},
    White = {"White", "Off White", "Frost", "Pure", "Honey Beige"},
    Pink = {"Pink", "Salmon", "Vermillion"},
    Purple = {"Purple", "Dark Purple"},
    Gold = {"Gold", "Classic", "Satin", "Spec"},
    Orange = {"Sunrise", "Orange", "Choco Orange"},
    Misc = {"Chrome", "Brushed", "Matte", "Metallic", "Worn", "DEFAULT ALLOY COLOUR", "Epsilon", "MODSHOP", "police", "Util"}
}

local pearlList = {}
for pearlName, index in pairs(pearlTypes) do
    local colourCategory = "Misc"
    for category, keywords in pairs(colourCategories) do
        for _, keyword in ipairs(keywords) do
            if string.find(pearlName:lower(), keyword:lower()) then
                colourCategory = category
                break
            end
        end
        if colourCategory ~= "Misc" then break end
    end
    table.insert(pearlList, {name = pearlName, index = index, category = colourCategory})
end

table.sort(pearlList, function(a, b)
    if a.category == b.category then
        return a.name < b.name
    else
        return a.category < b.category
    end
end)

local function createOnClickHandler(pearlIndex)
    return function()
        local veh = entities.get_user_vehicle_as_handle()
        if veh == -1 then return util.toast("Vehicle not found!") end
        local driver = NETWORK_GET_PLAYER_INDEX_FROM_PED(GET_PED_IN_VEHICLE_SEAT(veh, -1))
        if driver ~= players.user() then return util.toast("You must be driving a vehicle to change its pearl colour.") end
        SET_VEHICLE_EXTRA_COLOURS(veh, pearlIndex, 0)
        local tmess = "Applied new pearl to vehicle model " .. GET_DISPLAY_NAME_FROM_VEHICLE_MODEL(GET_ENTITY_MODEL(veh)) .. " (id: " .. veh .. ")"
        util.toast(tmess)
    end
end

local pearlmenulist = menu.list(vehicleCustomisation, "Change Pearl", {""}, "")
local sortedCategories = {}
for category, _ in pairs(colourCategories) do
    if category ~= "Misc" then
        table.insert(sortedCategories, category)
    end
end

table.sort(sortedCategories)
table.insert(sortedCategories, "Misc")

local submenus = {}
for _, category in ipairs(sortedCategories) do
    submenus[category] = menu.list(pearlmenulist, category, {""}, "")
end

for _, pearl in ipairs(pearlList) do
    menu.action(submenus[pearl.category], pearl.name, {""}, "", createOnClickHandler(pearl.index))
end

--#nitrous
local nitrous = vehicleCustomisation:list("Nitrous", {}, "Note: Other players can also see this, but, their game will have to load the ptfx asset on their side. The game usually does this rather quickly but sometimes it just doesn't load for others.")
local durationMod = 1.0
nitrous:slider_float("Duration", {"duration"}, "The amount of seconds that the nitrous will last.", 100, 1000, 300, 50, function(value)
	durationMod = value/300 -- this seems to be the exact conversion for converting the float to seconds
	--toast(value/300)
end)

local powerMod = 1.5
nitrous:slider_float("Power Multiplier", {"multiplier"}, "", 100, 1000, 150, 50, function(value)
	powerMod = value/100
end)

local rechargeMod = 2.0
nitrous:slider_float("Recharge Time", {"rechargetime"}, "Note: The recharge speed may change based on the duration.", 100, 1000, 200, 50, function(value)
	rechargeMod = value/100
end)

nitrous:toggle("Use Horn Button For Nitrous", {}, "", function(toggled)
	_SET_VEHICLE_USE_HORN_BUTTON_FOR_NITROUS(toggled)
end)

nitrous:toggle_loop("Disable On Key Release", {}, "Disables nitrous when you let go of the W key.", function(toggled)
	local vehicle = entities.get_user_vehicle_as_handle()
	if IS_CONTROL_JUST_RELEASED(0, 71) and IS_NITROUS_ACTIVE(vehicle) then
		SET_OVERRIDE_NITROUS_LEVEL(vehicle, false, durationMod, powerMod, rechargeMod, false) -- SET_NITROUS_IS_ACTIVE didnt wanna work here cus gay
	end
end)

nitrous:toggle_loop("Disable In Air", {}, "", function(toggled)
	local vehicle = entities.get_user_vehicle_as_handle()
	if IS_ENTITY_IN_AIR(vehicle) then
		SET_OVERRIDE_NITROUS_LEVEL(vehicle, false, durationMod, powerMod, rechargeMod, false) -- SET_NITROUS_IS_ACTIVE didnt wanna work here cus gay
	end
end)


local nitrousPtfxActive = false
nitrous:action("Load PTFX For Nearby Players", {"loadnitrousptfx"}, "Loads the nitrous PTFX for nearby players so that they can also see the flames.", function() 
	local vehicle = entities.get_user_vehicle_as_handle()
	loadPtfxAsset("veh_xs_vehicle_mods")
	USE_PARTICLE_FX_ASSET("veh_xs_vehicle_mods")
	if nitrousPtfxActive then
		toast("This is already active, please wait...")
		return
	end
	ptfx = START_NETWORKED_PARTICLE_FX_LOOPED_ON_ENTITY("veh_nitrous", vehicle, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, false, false, false, 0, 0, 0, 255)
	nitrousPtfxActive = true
	toast("Loading PTFX...")
	yield(5000)
	REMOVE_PARTICLE_FX(ptfx)
	toast("PTFX should now be loaded for nearby players. :D")
	nitrousPtfxActive = false
end)


local clearedNitrous = false
local nitrousTgl
nitrousTgl = nitrous:toggle_loop("Enable Nitrous", {"nitrous"}, "Default Nitrous button is X.", function()
	if GET_HAS_ROCKET_BOOST(entities.get_user_vehicle_as_handle()) then return end
	if not clearedNitrous then
		CLEAR_NITROUS(entities.get_user_vehicle_as_handle()) -- clearing nitrous on feature startup because the bar doesn't go down if enabled while full.
		clearedNitrous = true
		return
	else
		loadPtfxAsset("veh_xs_vehicle_mods")
		local vehicle = entities.get_user_vehicle_as_handle()
		SET_OVERRIDE_NITROUS_LEVEL(vehicle, true, durationMod, powerMod, rechargeMod, false)
		if not IS_NITROUS_ACTIVE(vehicle) then
			SET_NITROUS_IS_ACTIVE(vehicle, false) -- disable the nitrous ptfx when not active, removing the ptfx still left the lights from the ptfx behind
			return
		end
	end
end, function()
	SET_OVERRIDE_NITROUS_LEVEL(entities.get_user_vehicle_as_handle(), false, 0.0, 0.0, 0.0, false)
	clearedNitrous = false
end)

local flamethrowerTune = vehicleCustomisation:list("Flamethrower Tune", {}, "")
local redline
redline = flamethrowerTune:toggle_loop("On Redline", {}, "", function()
	if not nitrousTgl.value then 
		toast("Please enable nitrous to use this feature. :/")
		redline.value = false
		return
	end
	loadPtfxAsset("veh_xs_vehicle_mods")
	local vehPtr = entities.get_user_vehicle_as_pointer()
	local vehHandle = entities.get_user_vehicle_as_handle()
	if vehPtr == 0 then return end
	SET_NITROUS_IS_ACTIVE(vehHandle, entities.get_rpm(vehPtr) == 1.0 and entities.get_current_gear(vehPtr) == 1)
end)

local downshift
downshift = flamethrowerTune:toggle_loop("On Downshift", {}, "", function()
	if not nitrousTgl.value then 
		toast("Please enable nitrous to use this feature. :/")
		downshift.value = false
		return
	end
	loadPtfxAsset("veh_xs_vehicle_mods")
	local vehPtr = entities.get_user_vehicle_as_pointer()
	local vehHandle = entities.get_user_vehicle_as_handle()
	if vehPtr == 0 then return end
	local prevGear = entities.get_current_gear(vehPtr)
	yield()
	yield()
	local curGear = entities.get_current_gear(vehPtr)
	if curGear < prevGear then
		for i = 1, 25 do
			SET_NITROUS_IS_ACTIVE(vehHandle, true)
			yield()
		end
	end
end)

local upshift
upshift = flamethrowerTune:toggle_loop("On Upshift", {}, "", function()
	if not nitrousTgl.value then 
		toast("Please enable nitrous to use this feature. :/")
		upshift.value = false
		return
	end
	loadPtfxAsset("veh_xs_vehicle_mods")
	local vehPtr = entities.get_user_vehicle_as_pointer()
	local vehHandle = entities.get_user_vehicle_as_handle()
	if vehPtr == 0 then return end
	local prevGear = entities.get_current_gear(vehPtr)
	yield()
	yield()
	local curGear = entities.get_current_gear(vehPtr)
	if curGear > prevGear then
		for i = 1, 25 do
			SET_NITROUS_IS_ACTIVE(vehHandle, true)
			yield()
		end
	end
end)

local accelerating
accelrating = flamethrowerTune:toggle_loop("While Accelerating", {}, "", function()
	if not nitrousTgl.value then 
		toast("Please enable nitrous to use this feature. :/")
		accelrating.value = false
		return
	end
	loadPtfxAsset("veh_xs_vehicle_mods")
	local vehicle = entities.get_user_vehicle_as_handle()
	SET_NITROUS_IS_ACTIVE(vehicle, IS_CONTROL_PRESSED(0, 71))
end)

local alwaysOn
alwaysOn = flamethrowerTune:toggle_loop("Always On", {}, "", function()
	if not nitrousTgl.value then 
		toast("Please enable nitrous to use this feature. :/")
		alwaysOn.value = false
		return
	end
	loadPtfxAsset("veh_xs_vehicle_mods")
	local vehicle = entities.get_user_vehicle_as_handle()
	SET_NITROUS_IS_ACTIVE(vehicle, true)
end)

flamethrowerTune:action("Load PTFX For Nearby Players", {}, "Loads the nitrous PTFX for nearby players so that they can also see the flames.", function() 
	menu.trigger_commands("loadnitrous")
end)

local antilag = vehicleCustomisation:list("Anti-Lag", {}, "")
local antilagDelay = 100
antilag:slider("Delay", {"antilagdelay"}, "The interval in which the exhaust will pop.", 0, 1000, 100, 10, function(amount)
	antilagDelay = amount
end)

local random = false
antilag:toggle("Randomize", {}, "Randomizes the interval in which the exhaust will pop. (Note: randomize will use the delay as the max delay.)", function(toggled)
	random = toggled
end)

antilag:toggle_loop("Anti-Lag", {"antilag"}, "Rev your engine to use. Only works when vehicle is still. Doesn't network with other players.", function()
	local veh = entities.get_user_vehicle_as_pointer()
	if veh == 0 then return end
	local gear = entities.get_current_gear(veh)
	local rpm = entities.get_rpm(veh)
	if IS_CONTROL_PRESSED(0, 22) and IS_CONTROL_PRESSED(0, 71) then
		entities.set_rpm(veh, 0.9)
		yield(random ? math.random(100, antilagDelay) : antilagDelay)
		entities.set_rpm(veh, 0.1)
	end
end)

--#vehicleFly
vehicleFly:toggle_loop("Vehicle Fly", {""}, "", function()
    yourself = PLAYER.GET_PLAYER_PED(players.user())
    carUsed = PED.GET_VEHICLE_PED_IS_IN(yourself, false)
    ENTITY.SET_ENTITY_COLLISION(carUsed, true, true)
    if NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(carUsed) == false then
        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(carUsed)
        util.yield(3000)
    end
    if keepMomentum == false then
        ENTITY.SET_ENTITY_VELOCITY(carUsed, 0, 0, 0)
    end
    if PED.IS_PED_IN_VEHICLE(yourself, carUsed, false) then
        if noClipCar then
            ENTITY.SET_ENTITY_COLLISION(carUsed, false, true)
        else
            ENTITY.SET_ENTITY_COLLISION(carUsed, true, true)
        end
        local camRot = CAM.GET_GAMEPLAY_CAM_ROT(0) -- Fixed: added rotationOrder parameter
        camYaw = math.floor(camRot.Z*10)/10
        camPitch = math.floor(camRot.X*10)/10
        ENTITY.SET_ENTITY_ROTATION(carUsed, camPitch, 0, camYaw, 0, true)
        if util.is_key_down(0x57) then -- W key
            VEHICLE.SET_VEHICLE_FORWARD_SPEED(carUsed, carFlySpeed)
        end
        if util.is_key_down(0x53) then -- S key
            VEHICLE.SET_VEHICLE_FORWARD_SPEED(carUsed, -carFlySpeed)
        end
        if util.is_key_down(0x44) then -- D key
            local speedFly = carFlySpeed
            ENTITY.APPLY_FORCE_TO_ENTITY(carUsed, 1, speedFly*2, 0, 0, 0, 0, 0, 0, true, true, true, false)
        end
        if util.is_key_down(0x41) then -- A key
            local speedFly = carFlySpeed
            ENTITY.APPLY_FORCE_TO_ENTITY(carUsed, 1, -speedFly*2, 0, 0, 0, 0, 0, 0, true, true, true, false)
        end
        if util.is_key_down(0x10) then
            local speedFly = carFlySpeed
            ENTITY.APPLY_FORCE_TO_ENTITY(carUsed, 1, 0, 0, speedFly, 0, 0, 0, 0, true, true, true, false)
        end
        if util.is_key_down(0x11) then
            local speedFly = carFlySpeed
            ENTITY.APPLY_FORCE_TO_ENTITY(carUsed, 1, 0, 0, -speedFly, 0, 0, 0, 0, true, true, true, false)
        end
        if util.is_key_down(0x20) then
            carFlySpeed = carFlySpeedSelect*10*2
        else
            carFlySpeed = carFlySpeedSelect*10
        end
    else
        ENTITY.SET_ENTITY_COLLISION(carUsed, true, true)
    end
end)
vehicleFly:slider("Fly Speed", {}, "", 1, 100, 5, 1, function(a)
    carFlySpeedSelect = a
end)
vehicleFly:toggle("Keep Momentum", {}, "", function(a)
    keepMomentum = a
end)

---#self
--#bark
local shepherdPedHandle = nil
self:action("Bark", {}, "Note: The sound may not play consistently for all players every time.\n(It'll have to stay this way until I find a fix.)", function()
    local function BarkThenDelete(pedHandle)
        AUDIO.PLAY_ANIMAL_VOCALIZATION(pedHandle, 3, "BARK_SEQ")
        util.yield(1200)
        if ENTITY.DOES_ENTITY_EXIST(pedHandle) then
            entities.delete_by_handle(pedHandle)
        end
        shepherdPedHandle = nil
    end
    if shepherdPedHandle and ENTITY.DOES_ENTITY_EXIST(shepherdPedHandle) then
        BarkThenDelete(shepherdPedHandle)
        return
    end
    local pedHash = util.joaat("a_c_shepherd")
    if not STREAMING.HAS_MODEL_LOADED(pedHash) then
        STREAMING.REQUEST_MODEL(pedHash)
        while not STREAMING.HAS_MODEL_LOADED(pedHash) do
            util.yield(0)
        end
    end
    shepherdPedHandle = entities.create_ped(1, pedHash, ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), true), ENTITY.GET_ENTITY_HEADING(PLAYER.PLAYER_PED_ID()))
    if shepherdPedHandle ~= 0 then
        ENTITY.ATTACH_ENTITY_TO_ENTITY(shepherdPedHandle, PLAYER.PLAYER_PED_ID(), PED.GET_PED_BONE_INDEX(PLAYER.PLAYER_PED_ID(), 0), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, false, false, false, 2, true, 0)
        ENTITY.SET_ENTITY_INVINCIBLE(shepherdPedHandle, true)
        ENTITY.SET_ENTITY_VISIBLE(shepherdPedHandle, false)
        BarkThenDelete(shepherdPedHandle)
    end    
    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(pedHash)
end)

--#ewo
local function write_to_global()
    memory.write_int(memory.script_global(1574582 + 6), 1)
end
local function is_in_pause_menu()
    return IS_PAUSE_MENU_ACTIVE()
end
local toggleforoutside = false
self:action("EWO", {"zzz"}, "Sets the value of Global_1574582.f_6 to 1.", function()
    if is_in_pause_menu() then
        return
    end
    local playerPed = players.user_ped()
    local vehicle = GET_VEHICLE_PED_IS_USING(playerPed)
    if vehicle == 0 and toggleforoutside then
        write_to_global()
    elseif vehicle ~= 0 and toggleforoutside then
        return
    else
        write_to_global()
    end
end, nil, nil, COMMANDPERM_FRIENDLY)
self:toggle("Enable EWO Only On Foot", {}, "If enabled, EWO will only work when you are not in a vehicle.", function(on)
    toggleforoutside = on
end)

--#walkonwater/driveonwater
local function getWaterHeightInclRivers(pos_x, pos_y, z_hint)
    local outHeight = memory.alloc(4)
    if TEST_VERTICAL_PROBE_AGAINST_ALL_WATER(pos_x, pos_y, z_hint or 200.0, 0, outHeight) ~= 0 then
        return memory.read_float(outHeight)
    end
end
local function deleteEntities(entityTable)
    for _, entity in ipairs(entityTable) do
        NETWORK_REQUEST_CONTROL_OF_ENTITY(entity)
        SET_ENTITY_AS_MISSION_ENTITY(entity)
        entities.delete_by_handle(entity)
    end
end
local function loadModelAsync(hash)
    REQUEST_MODEL(hash)
    while not HAS_MODEL_LOADED(hash) do
        util.yield()
    end
end
local function DelEnt(ped_tab)
    for _, Pedm in ipairs(ped_tab) do
        NETWORK_REQUEST_CONTROL_OF_ENTITY(Pedm)
        SET_ENTITY_AS_MISSION_ENTITY(Pedm)
        entities.delete_by_handle(Pedm)
    end
end
local function Streament(hash)
    loadModelAsync(hash)
end
local waterwalkroot = selfMovement:list(('Walk/Drive on Water'), {}, '')
local block
local blocks = {}
local waterwalk = { height = -0.3 }
waterwalkroot:toggle_loop(('Walk/Drive on Water'), {'waterwalk'}, ('Walk or drive on water if you are in the water it will teleport you above it'), function (on)
    local pos, pos2
    local vmod = entities.get_user_vehicle_as_handle() or 0
    if vmod ~= 0 then
        pos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0.0, 0.3, 0)
        pos2 = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0.0, -0.3, 0)
    else
        pos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vmod, 0.0, 0.3, 0)
        pos2 = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vmod, 0.0, -0.3, 0)
    end
    local z = getWaterHeightInclRivers(pos.x, pos.y)
    local z2 = getWaterHeightInclRivers(pos2.x, pos2.y)
    if vmod ~= 0 then
        SET_VEHICLE_MAX_SPEED(vmod, 150)
        MODIFY_VEHICLE_TOP_SPEED(vmod, 50)
        SET_VEHICLE_BURNOUT(vmod, false)
        SET_IN_ARENA_MODE(true)
        local minimum = memory.alloc()
        local maximum = memory.alloc()
        GET_MODEL_DIMENSIONS(GET_ENTITY_MODEL(vmod), minimum, maximum)
        local maximum_vec = v3.new(maximum)
        local blockh
        if maximum_vec.x >= 3 then
            blockh = util.joaat('sr_prop_special_bblock_mdm3')
       elseif maximum_vec.y >= 3.1 then
            blockh = util.joaat('sr_prop_special_bblock_xl2')
        elseif vmod ~= 0 and maximum_vec.x >= 0.1 then
            blockh = util.joaat('sr_prop_special_bblock_sml2')
        else
            blockh = util.joaat('sr_prop_special_bblock_sml1')
        end
        Streament(blockh)
        local water = memory.alloc(4)
        if block == nil and z ~= nil then
            block = CREATE_OBJECT(blockh, pos.x, pos.y, z, true, true, true)
            table.insert(blocks, block)
        elseif z == nil and block ~= nil then
            if DOES_ENTITY_EXIST(block) then
                DelEnt(blocks)
                block = nil
            end
        else
            local pedrotYaw = GET_ENTITY_ROTATION(players.user_ped(), 2).z
            if z ~= nil and z2 ~= nil and pedrotYaw ~= nil then
                local pitch = math.asin((z - z2) / 0.3)
                SET_ENTITY_COORDS_NO_OFFSET(block, pos.x, pos.y, z + waterwalk.height, false, false, false)
                SET_ENTITY_ROTATION(block, 0, pitch * 10, pedrotYaw, 2, false)
                local waterped = GET_ENTITY_SUBMERGED_LEVEL(players.user_ped())
                local waterveh = GET_ENTITY_SUBMERGED_LEVEL(vmod)
                for _, blockEntity in ipairs(blocks) do
                    SET_ENTITY_ALPHA(blockEntity, 0, false)
                    SET_ENTITY_VISIBLE(blockEntity, false, 0)
                end
                if waterped >= 1.0 then
                    SET_ENTITY_COORDS(players.user_ped(), pos.x, pos.y, z + 1, false, false, false, false)
                elseif waterveh >= 1.0  then
                    SET_ENTITY_COORDS(vmod, pos.x, pos.y, z + 1, false, false, false, false)
                end
            else
                DelEnt(blocks)
                block = nil 
            end
        end
        return block
    end
end, function ()
    DelEnt(blocks)
    block = nil 
end)
waterwalkroot:slider_float(('Height above water'), {}, ('Adjust the height above or below water'), -90, 90, -30, 10, function (h)
   waterwalk.height = h * 0.01
end)

---#selfMovement
--#afk
selfMovement:toggle("AFK", {"afk"}, "Will bring you back to your original position after you turn this off.", function(on)
    if on then
        menu.trigger_commands("levitate on")
        local me = PLAYER.PLAYER_PED_ID()
        if me ~= nil then
            menu.trigger_commands("copycoords")
            util.yield(110)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(me, -8112.612, -15999.334, 2695.6704, 4, 0, 0, 0)
            menu.trigger_commands("shader stripnofog") --shader can be replaced with any of these: "shader vbahama" , "shader underwater" , "shader trailerexplosionoptimise" , "shader stripstage" , "shader stripoffice" , "shader stripchanging" , "shader stripnofog"
            menu.trigger_commands("lodscale min")
            menu.trigger_commands("noidlekick on")
            menu.trigger_commands("stealthlevitation on")
            menu.trigger_commands("anticrashcamera on")
            menu.trigger_commands("potatomode on")
            menu.trigger_commands("nosky on")
            menu.trigger_commands("potatomode on")
            menu.trigger_commands("norender on")
            menu.trigger_commands("time 3")
            menu.trigger_commands("locktime on")
            menu.trigger_commands("godmode on")
            menu.trigger_commands("infotps on")
            menu.trigger_commands("visexposurecurveoffset min")
        end
    else 
        menu.trigger_commands("shader off")
        menu.trigger_commands("lodscale 1")
        menu.trigger_commands("potatomode off")
        menu.trigger_commands("nosky off")
        menu.trigger_commands("norender off")
        menu.trigger_commands("synctime")
        menu.trigger_commands("locktime off")
        menu.trigger_commands("godmode off")
        menu.trigger_commands("infotps off")
        menu.trigger_commands("infotps off")
        menu.trigger_commands("levitate off")
        menu.trigger_commands("visexposurecurveoffset default")
        menu.trigger_commands("anticrashcamera off")
        util.yield(110)
        menu.trigger_commands("pastecoords")
    end
end)

--#fasthands
selfMovement:toggle_loop("Fast Hands", {"fasthands"}, "Swaps your weapons faster.", function()
    if TASK.GET_IS_TASK_ACTIVE(players.user_ped(), 56) then
        PED.FORCE_PED_AI_AND_ANIMATION_UPDATE(players.user_ped())
    end
end)

--#stealthLevitation
local invisibility = menu.ref_by_path("Self>Appearance>Invisibility")
local levitation = menu.ref_by_path("Self>Movement>Levitation>Levitation")
local vehInvisibility = menu.ref_by_path("Vehicle>Invisibility")
local positonSpoofing = menu.ref_by_path("Online>Spoofing>Position Spoofing>Position Spoofing")
local spoofedPos = menu.ref_by_path("Online>Spoofing>Position Spoofing>Spoofed Position")
local superJump = menu.ref_by_path("Self>Movement>Super Jump")
local gracefulLanding = menu.ref_by_path("Self>Movement>Graceful Landing")
local stealthLevitation
stealthLevitation = selfMovement:toggle_loop("Stealth Levitation", {"stealthlevitation"}, "", function()
	if levitation.value then
		vehInvisibility:setState("Locally Visible")
		invisibility:setState("Locally Visible")
		repeat
			util.yield()
			util.yield()
		until not levitation.value
		invisibility:setState("Disabled")
		vehInvisibility:setState("Disabled")
	else
		return
	end
end, function()
	invisibility:setState("Disabled") -- so invisibility doesnt stay on if the script or feature is toggled off while levitating
	vehInvisibility:setState("Disabled")
end)

local playerName = players.get_name(players.user())
self:toggle_loop("Script Host " .. playerName, {"sch"}, "Gives you constant Script Host.\nNote: Enabling this may lead to a slight drop in fps.", function()
    menu.trigger_commands("givesh" .. playerName)
    util.yield()
end)

---#online
--#passiveorg
local function write_to_global()
    memory.write_int(memory.script_global(1574582 + 0), 1) --Sets the value of Global_1574582.f_0 to 1.
end
online:action("Passive ORG", {}, "Lets you go passive while in an organization.", function()
    write_to_global()
end)

--#killfeed
local eventData = memory.alloc(13 * 8)
local killFeedEnabled = false
local function checkPlayerKills()
    for eventNum = 0, SCRIPT.GET_NUMBER_OF_EVENTS(1) - 1 do
        local eventId = SCRIPT.GET_EVENT_AT_INDEX(1, eventNum)
        if eventId == 186 then
            if SCRIPT.GET_EVENT_DATA(1, eventNum, eventData, 13) then
                local victim = memory.read_int(eventData)
                local attacker = memory.read_int(eventData + 1 * 8)
                local damage = memory.read_float(eventData + 2 * 8)
                local victimDestroyed = memory.read_int(eventData + 5 * 8)
                local weaponUsedHash = memory.read_int(eventData + 6 * 8)
                local weapon_name = util.reverse_joaat(weaponUsedHash)
                if weapon_name == "" then weapon_name = "unknown" end

                if victim ~= attacker and victim ~= -1 and attacker ~= -1 then
                    if NETWORK.NETWORK_GET_PLAYER_INDEX_FROM_PED(attacker) ~= -1 and NETWORK.NETWORK_GET_PLAYER_INDEX_FROM_PED(victim) ~= -1 then
                        if victimDestroyed == 1 then
                            util.toast(string.format("%s Killed %s With %s", players.get_name(NETWORK.NETWORK_GET_PLAYER_INDEX_FROM_PED(attacker)), players.get_name(NETWORK.NETWORK_GET_PLAYER_INDEX_FROM_PED(victim)), weapon_name), TOAST_ALL)
                        end
                    end
                elseif victim == attacker and victim ~= -1 and attacker ~= -1 then
                    if NETWORK.NETWORK_GET_PLAYER_INDEX_FROM_PED(attacker) ~= -1 and NETWORK.NETWORK_GET_PLAYER_INDEX_FROM_PED(victim) ~= -1 then
                        if victimDestroyed == 1 then
                            util.toast(string.format("%s Killed Themselves With %s", players.get_name(NETWORK.NETWORK_GET_PLAYER_INDEX_FROM_PED(victim)), weapon_name), TOAST_ALL)
                        end
                    end
                end
            end
        end
    end
end
online:toggle("Enable Kill Feed", {"killfeed"}, "Toggle the kill feed on or off.", function(on)
    killFeedEnabled = on
    if killFeedEnabled then
        while killFeedEnabled do
            checkPlayerKills()
            util.yield()
        end
    end
end)

---#onlineGriefing
--#smartsekick
onlineGriefing:action("Smart SE Kick", {"sekickall"}, "Kicks everyone else besides the host, thus the host won't be notified", function() -- Credit to nui for this
    local list = players.list(false, false, true)
    for list as pid do
        if players.get_name(players.get_host()) == players.get_name(pid) then
            goto continue
        end
        menu.trigger_commands("nonhostkick" .. players.get_name(pid))
        util.yield()
        ::continue::
    end
end)

--#orball
local obliterate_global = memory.script_global(GlobalplayerBD + 1 + (players.user() * 463) + 424)
onlineGriefing:action("Orbital Strike Everyone", { "orball" }, "", function()
    if isOrbActive then
        util.toast("Orbital strike is already active you silly goober :33")
        return
    end
    isOrbActive = true
    setBit(obliterate_global, 0)
    for _, playerID in ipairs(players.list_except(true, true, false, false)) do
        if not IS_PLAYER_DEAD(playerID) and isNetPlayerOk(playerID) then
            local pos = players.get_position(playerID)
            ADD_OWNED_EXPLOSION(players.user_ped(), pos, 59, 1.0, true, false, 1.0)
            USE_PARTICLE_FX_ASSET("scr_xm_orbital")
            START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD("scr_xm_orbital_blast", pos, v3(), 1.0, false, false, false, true)
            PLAY_SOUND_FROM_COORD(0, "DLC_XM_Explosions_Orbital_Cannon", pos, 0, true, 0, false)
        end
    end
    util.yield(1000)
    clearBit(obliterate_global, 0)
    util.yield(3000)
    isOrbActive = false
end)

--#shroulette
onlineGriefing:toggle_loop("Script Host Roulette", {}, "You're a nigger if you use this.", function(on)
    for _, pid in ipairs(players.list(false, true, true)) do
        menu.trigger_commands("givesh" .. players.get_name(pid))
        util.yield()
    end
end)

---#onlineTrolling
--#hijackall
onlineTrolling:action("Hijack All Vehicles", {"hijackall"}, "Spawns a ped to take them out of their vehicle and drive away.", function()
	for players.list_except(true) as playerID do
		local ped = GET_PLAYER_PED_SCRIPT_INDEX(playerID)
		local pos = players.get_position(playerID)
		if DOES_ENTITY_EXIST(ped) and IS_PED_IN_ANY_VEHICLE(ped) then
			menu.trigger_commands($"hijack {players.get_name(playerID)}")
		end
	end
end)

--#blockorbitalcannon
onlineTrolling:toggle_loop("Block Orbital Cannon", {"blockorb"}, "", function()
	local blockOrbMdl = joaat("h4_prop_h4_garage_door_01a")
	local blockOrbMdlSign = joaat("xm_prop_x17_screens_02a_07")
	util.request_model(blockOrbMdl)
	util.request_model(blockOrbMdlSign)
	if orbObj == nil or not DOES_ENTITY_EXIST(orbObj) then
		orbObj = entities.create_object(blockOrbMdl, v3(335.9, 4833.9, -59.0))
		orbSign = entities.create_object(blockOrbMdlSign, v3(335.9, 4834, -57.0))
		entities.set_can_migrate(orbObj, false)
		entities.set_can_migrate(orbSign, false)
		SET_ENTITY_HEADING(orbObj, 125.0)
		SET_ENTITY_HEADING(orbSign, 125.0)
		FREEZE_ENTITY_POSITION(orbObj, true)
		SET_ENTITY_NO_COLLISION_ENTITY(players.user_ped(), orbObj, false)
		SET_ENTITY_ROTATION(orbSign, -25.0, 0.0, 125.0, 2, true)
	end
	util.yield(50)
end, function()
	if orbObj != nil then
		entities.delete(orbObj)
	end
	if orbSign != nil then
		entities.delete(orbSign)
	end
end)

---#world
--#chaos
world:toggle_loop("Chaos", {}, "", function(on)
	local vehicle = entities.get_all_vehicles_as_handles()
	local me = players.user()  
	local maxspeed = 940
	local ct = 0
		for k,ent in pairs(entities.get_all_vehicles_as_handles()) do
			NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(ent)
			VEHICLE.SET_VEHICLE_FORWARD_SPEED(ent, 900000)
			ct = ct + 1
		end
end)

---#teleports
--#smoothtp2wp
teleports:action("Smooth TP2WP", {"smoothtp"}, "", function()
	if not IS_WAYPOINT_ACTIVE() then
		toast(lang.get_localised(BLIPNFND))
		return
	end

	local waypoint = GET_BLIP_INFO_ID_COORD(GET_FIRST_BLIP_INFO_ID(GET_WAYPOINT_BLIP_ENUM_ID()))
	local vehicle = GET_VEHICLE_PED_IS_USING(players.user_ped())

	local ground = false
	repeat
		ground, waypoint.z = util.get_ground_z(waypoint.x, waypoint.y)
		yield()
	until ground

	invisibility:setState("Enabled")

	if vehicle != 0 then
		SET_ENTITY_VISIBLE(vehicle, false)
	end

	SWITCH_TO_MULTI_FIRSTPART(players.user_ped(), 8, 1)
	BEGIN_TEXT_COMMAND_BUSYSPINNER_ON("PM_WAIT")
	END_TEXT_COMMAND_BUSYSPINNER_ON(4)

	repeat
		yield()
	until IS_SWITCH_TO_MULTI_FIRSTPART_FINISHED()

	if vehicle == 0 then
		SET_ENTITY_COORDS_NO_OFFSET(players.user_ped(), waypoint, false, false, false)
	else
		SET_ENTITY_VISIBLE(vehicle, false)
		SET_ENTITY_COORDS_NO_OFFSET(vehicle, waypoint, false, false, false)
	end

	SWITCH_TO_MULTI_SECONDPART(players.user_ped())
	ALLOW_PLAYER_SWITCH_OUTRO() 

	repeat
		yield()
	until not IS_PLAYER_SWITCH_IN_PROGRESS()
	
	if vehicle == 0 then
		NETWORK_FADE_IN_ENTITY(players.user_ped(), true, true)
	else
		NETWORK_FADE_IN_ENTITY(vehicle, true, 1)
		NETWORK_FADE_IN_ENTITY(players.user_ped(), true, true)
		SET_ENTITY_VISIBLE(vehicle, true)
	end
	
	invisibility:setState("Disabled")
	BUSYSPINNER_OFF()
end)

--#gun_van_locations
gunvan = teleports:list("Gun Van Locations", {"gunvan"}, "")
local function teleportPlayerAndVehicle(x, y, z)
    local me = PLAYER.PLAYER_PED_ID()
    local myVehicleHandle = entities.get_user_vehicle_as_handle()
    if myVehicleHandle ~= 0 and VEHICLE.IS_VEHICLE_DRIVEABLE(myVehicleHandle) then
        if VEHICLE.GET_PED_IN_VEHICLE_SEAT(myVehicleHandle, -1) == me then
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(myVehicleHandle, x, y, z, 0, 0, 0)
            ENTITY.SET_ENTITY_VELOCITY(myVehicleHandle, 0, 0, 0) -- Reset vehicle velocity
        else
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(me, x, y, z, 0, 0, 0)
        end
    else
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(me, x, y, z, 0, 0, 0)
    end
end
local function createTeleportAction(name, x, y, z)
    return function(on_click)
        teleportPlayerAndVehicle(x, y, z)
    end
end
for _, loc in ipairs(gun_van_locations) do
    gunvan:action(loc.name, {}, "", createTeleportAction(loc.name, loc.x, loc.y, loc.z))
end

--#oob_location
local function teleportPlayerAndVehicle(x, y, z)
    local me = PLAYER.PLAYER_PED_ID()
    local myVehicleHandle = entities.get_user_vehicle_as_handle()
    if myVehicleHandle ~= 0 and VEHICLE.IS_VEHICLE_DRIVEABLE(myVehicleHandle) then
        if VEHICLE.GET_PED_IN_VEHICLE_SEAT(myVehicleHandle, -1) == me then
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(myVehicleHandle, x, y, z, 0, 0, 0)
            ENTITY.SET_ENTITY_VELOCITY(myVehicleHandle, 0, 0, 0) -- Reset vehicle velocity
        else
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(me, x, y, z, 0, 0, 0)
        end
    else
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(me, x, y, z, 0, 0, 0)
    end
end

local oob_tps = teleports:list("Rat Locations", {}, "")
for _, loc in ipairs(oob_locations) do
    oob_tps:action(loc.name, {loc.command}, loc.description or "", function(on_click)
        teleportPlayerAndVehicle(loc.x, loc.y, loc.z)
    end)
end

--#interiors_inaccessible
local function teleportPlayerAndVehicle(x, y, z)
    local me = PLAYER.PLAYER_PED_ID()
    local myVehicleHandle = entities.get_user_vehicle_as_handle()
    if myVehicleHandle ~= 0 and VEHICLE.IS_VEHICLE_DRIVEABLE(myVehicleHandle) then
        if VEHICLE.GET_PED_IN_VEHICLE_SEAT(myVehicleHandle, -1) == me then
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(myVehicleHandle, x, y, z, 0, 0, 0)
            ENTITY.SET_ENTITY_VELOCITY(myVehicleHandle, 0, 0, 0)
        else
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(me, x, y, z, 0, 0, 0)
        end
    else
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(me, x, y, z, 0, 0, 0)
    end
end

local oob_tps = teleports:list("Interiors & Inaccessible", {}, "")
for _, loc in ipairs(interiors) do
    oob_tps:action(loc.name, {loc.command}, loc.description or "", function(on_click)
        teleportPlayerAndVehicle(loc.x, loc.y, loc.z)
    end)
end

--#cringe_locations
local function teleportPlayerAndVehicle(x, y, z)
    local me = PLAYER.PLAYER_PED_ID()
    local myVehicleHandle = entities.get_user_vehicle_as_handle()

    if myVehicleHandle ~= 0 and VEHICLE.IS_VEHICLE_DRIVEABLE(myVehicleHandle) then
        if VEHICLE.GET_PED_IN_VEHICLE_SEAT(myVehicleHandle, -1) == me then
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(myVehicleHandle, x, y, z, 0, 0, 0)
            ENTITY.SET_ENTITY_VELOCITY(myVehicleHandle, 0, 0, 0)
        else
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(me, x, y, z, 0, 0, 0)
        end
    else
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(me, x, y, z, 0, 0, 0)
    end
end

local oob_tps = teleports:list("Cringe Locations", {}, "")
for _, loc in ipairs(cringe_locations) do
    oob_tps:action(loc.name, {loc.command}, loc.description or "", function(on_click)
        teleportPlayerAndVehicle(loc.x, loc.y, loc.z)
    end)
end

---#autoAccept
--#joinmessages
autoAccept:toggle_loop("Join Messages", {"autoacceptjoinmessages"}, "", function() 
	local msgHash = GET_WARNING_SCREEN_MESSAGE_HASH()
	for warnings as hash do
		if msgHash == hash then
			SET_CONTROL_VALUE_NEXT_FRAME(2, 201, 1.0)
			yield()
			yield()
		end
	end
end)

--#transactionerrors
autoAccept:toggle_loop("Transaction Errors", {"autoaccepttransactionerrors"}, "", function() 
	local msgHash = GET_WARNING_SCREEN_MESSAGE_HASH()
	for transactionWarnings as hash do
		if msgHash == hash then
			SET_CONTROL_VALUE_NEXT_FRAME(2, 201, 1.0)
			yield()
			yield()
		end
	end
end)

---#enhancements
--#autoclaimbounties
enhancements:toggle_loop("Auto Claim Bounties", {"autoclaimbounties"}, "Automatically claims bounties that are placed on you.", function()
	local bounty = players.get_bounty(players.user())
	if bounty != nil then
		repeat
			menu.trigger_commands("removebounty")
			yield(1000)
			bounty = players.get_bounty(players.user())
		until bounty == nil
	end
end)

--#safeshopping
enhancements:toggle_loop("Safe Shopping", {"safeshopping"}, "Puts you into a locked session within your session while shopping to ensure a safe shopping experience. Other players will not be able to see that you are in a shop.", function()
	if getPlayerCurrentShop(players.user()) != -1 then
		NETWORK_START_SOLO_TUTORIAL_SESSION()
		while getPlayerCurrentShop(players.user()) != -1 do
			yield()
		end
	    NETWORK_END_TUTORIAL_SESSION()
	end	
end, function()
    NETWORK_END_TUTORIAL_SESSION()
end)

---#onlineChat
--#randome621link
onlineChat:action("Send Random e621 Link", {}, "", function()
    local randomNumber = math.random(1, 999999)
    local randomNumber2 = string.format("%06d", randomNumber)
    local url = "https://e621.net/posts/" .. randomNumber2
    chat.send_message(url, false, true, true)
end)

local function send_random_message(prefix)
    local filtered_messages = {}
    for _, message in ipairs(e621_messages) do
        if message:lower():find(prefix) then
            table.insert(filtered_messages, message)
        end
    end
    if #filtered_messages > 0 then
        local random_index = math.random(1, #filtered_messages)
        local selected_message = filtered_messages[random_index]
        chat.send_message(selected_message, false, true, true)
    end
end

local function send_specific_message(message)
    chat.send_message(message, false, true, true)
end

onlineChat:action("Meow >///<", {"meow"}, "", function()
    send_random_message("meow")
end, nil, nil, COMMANDPERM_FRIENDLY)

onlineChat:action("Woof Woof", {"woof"}, "", function()
    send_random_message("woof")
end, nil, nil, COMMANDPERM_FRIENDLY)

onlineChat:action("Horny pup :3", {"pubby"}, "", function()
    send_specific_message("BARK BARK BARK WOOF WOOF RUFF RUFF GRRR WOOOF RUFF RUFF BARK BARK WUFF AWOOOOOOOOOO AWOOOOOOOOOO BARK BRARK GRRR WOOF")
end, nil, nil, COMMANDPERM_FRIENDLY) -- Aero said: This is stupid and I should be shot over this. -- Prip said: I love this.

--#premsg
local customChatMessages = {"", "", ""}
onlinePreMSG:text_input("Predefined Chat Message Slot 1", {"1"}, "Set and save a message in slot 1 that you can send at any time.", function(input)
    customChatMessages[1] = input
end)
onlinePreMSG:text_input("Predefined Chat Message Slot 2", {"2"}, "Set and save a message in slot 2 that you can send at any time.", function(input)
    customChatMessages[2] = input
end)
onlinePreMSG:text_input("Predefined Chat Message Slot 3", {"3"}, "Set and save a message in slot 3 that you can send at any time.", function(input)
    customChatMessages[3] = input
end)
onlinePreMSG:click_slider("Send Saved Chat Message", {"sm"}, "Select the index (1-3) of the message you want to send.", 1, 3, 1, 1, function(index, click_type)
    local idx = tonumber(index)
    if customChatMessages[idx] and customChatMessages[idx] ~= "" then
        chat.send_message(customChatMessages[idx], false, true, true)
    else
        util.toast("Invalid index or message is empty!", TOAST_DEFAULT)
    end
end)

---#experimental
--#rgbskeleton
local bonePairs = {
    {0xE0FD, 0xE39F},
    {0xE0FD, 0xCA72},
    {0xE39F, 0xF9BB},
    {0xCA72, 0x9000},
    {0xF9BB, 0x3779},
    {0x9000, 0xCC4D},
    {0xE0FD, 0xFCD9},
    {0xFCD9, 0xB1C5},
    {0xB1C5, 0xEEEB},
    {0xEEEB, 0x49D9},
    {0xE0FD, 0x29D2},
    {0x29D2, 0x9D4D},
    {0x9D4D, 0x6E5C},
    {0x6E5C, 0xDEAD},
}

local screenCoord1 = memory.alloc(4)
local screenCoord1a = memory.alloc(4)
local screenCoord2 = memory.alloc(4)
local screenCoord2a = memory.alloc(4)

local r, g, b = 1.0, 0.0, 0.0
local increment = 0.001

menu.toggle_loop(experimental, "RGB Skeleton", {""}, "Note: It will change colours faster depending on the amount of lines visible.", function()
    for _, ped in ipairs(entities.get_all_peds_as_handles()) do
        if entities.is_player_ped(ped) then
            for _, pair in ipairs(bonePairs) do
                local bone1 = pair[1]
                local bone2 = pair[2]
                
                local boneCoord1 = GET_PED_BONE_COORDS(ped, bone1, 0.0, 0.0, 0.0)
                local boneCoord2 = GET_PED_BONE_COORDS(ped, bone2, 0.0, 0.0, 0.0)

                local boneCoord1X, boneCoord1Y, boneCoord1Z = boneCoord1.x, boneCoord1.y, boneCoord1.z
                local boneCoord2X, boneCoord2Y, boneCoord2Z = boneCoord2.x, boneCoord2.y, boneCoord2.z

                local a1 = GET_SCREEN_COORD_FROM_WORLD_COORD(boneCoord1X, boneCoord1Y, boneCoord1Z, screenCoord1, screenCoord1a)
                local a2 = GET_SCREEN_COORD_FROM_WORLD_COORD(boneCoord2X, boneCoord2Y, boneCoord2Z, screenCoord2, screenCoord2a)

                if a1 and a2 then
                    directx.draw_line(
                        memory.read_float(screenCoord1), 
                        memory.read_float(screenCoord1a), 
                        memory.read_float(screenCoord2), 
                        memory.read_float(screenCoord2a), 
                        r, g, b, 1.0
                    )

                    if r > 0 and b == 0 then
                        r = math.max(0, r - increment)
                        g = math.min(1, g + increment)
                    elseif g > 0 and r == 0 then
                        g = math.max(0, g - increment)
                        b = math.min(1, b + increment)
                    elseif b > 0 and g == 0 then
                        b = math.max(0, b - increment)
                        r = math.min(1, r + increment)
                    end
                end
            end
        end
    end
end)

--#cleanse
menu.toggle_loop(cleanse, "Vehicles", {"vehclear", "vclear"}, "", function(on_click)
    local ct = 0
    for k,ent in pairs(entities.get_all_vehicles_as_handles()) do
        entities.delete_by_handle(ent)
        ct = ct + 1
    end
end)
menu.toggle_loop(cleanse, "Objects", {"objectclear", "obclear"}, "", function(on_click)
    local ct = 0
    for k,ent in pairs(entities.get_all_objects_as_handles()) do
        entities.delete_by_handle(ent)
        ct = ct + 1
    end
end)
menu.toggle_loop(cleanse, "Peds", {"pedclear", "pclear"}, "", function(on_click)
	local ct = 0
    for k,ent in pairs(entities.get_all_peds_as_handles()) do
		if not is_ped_player(ent) then
			entities.delete_by_handle(ent)
        end
            ct = ct + 1
    end
end)
menu.toggle_loop(cleanse, "Clear All", {"cleanse", "clr"}, "", function(on_click)
	local ct = 0
	for k,ent in pairs(entities.get_all_vehicles_as_handles()) do
		entities.delete_by_handle(ent)
		ct = ct + 1
	end
	for k,ent in pairs(entities.get_all_peds_as_handles()) do
		if not is_ped_player(ent) then
			entities.delete_by_handle(ent)
		end
		ct = ct + 1
	end
	for k,ent in pairs(entities.get_all_objects_as_handles()) do
		entities.delete_by_handle(ent)
		ct = ct + 1
	end
end)
function is_ped_player(ped)
    if PED.GET_PED_TYPE(ped) >= 4 then
        return false
    else
        return true
    end
end
local config = {
    disable_traffic = true,
    disable_peds = true,
}
local pop_multiplier_id
cleanse:toggle("Clear Traffic", {"cleartraffic"}, "", function(on)
    if on then
        menu.trigger_command(menu.ref_by_path("World>Inhabitants>Traffic>Disable>Enabled, Including Parked Cars"))
        menu.trigger_commands("nomodpop off")
        local ped_sphere, traffic_sphere
        if config.disable_peds then ped_sphere = 0.0 else ped_sphere = 1.0 end
        if config.disable_traffic then traffic_sphere = 0.0 else traffic_sphere = 1.0 end
        pop_multiplier_id = MISC.ADD_POP_MULTIPLIER_SPHERE(1.1, 1.1, 1.1, 15000.0, ped_sphere, traffic_sphere, false, true)
        MISC.CLEAR_AREA(1.1, 1.1, 1.1, 19999.9, true, false, false, true)
    else
        MISC.REMOVE_POP_MULTIPLIER_SPHERE(pop_multiplier_id, false);
        menu.trigger_commands("notraffic off")
        menu.trigger_commands("nomodpop on")
    end
end)

---#playermenu
local alloc = memory.alloc
GenerateFeatures = function(pid)
menu.divider(menu.player_root(pid), "")
local playermenu = menu.list(menu.player_root(pid), ">:33", {}, "", function() end)
local griefing_playermenu = playermenu:list("Griefing", {}, "")
local trolling_playermenu = playermenu:list("Trolling", {}, "")
local miscPlayer = playermenu:list("Miscellaneous", {}, "")

local function godKill(playerID)
	local ped = GET_PLAYER_PED_SCRIPT_INDEX(playerID)
	local ping = ROUND(NETWORK_GET_AVERAGE_PING(playerID))
	local timer = (ping > 300) ? (util.current_time_millis() + 5000) : (util.current_time_millis() + 3000)
	local pPed =  entities.handle_to_pointer(ped)
	local pedPtr = entities.handle_to_pointer(players.user_ped())
	yield()
	yield()
	repeat
		util.trigger_script_event(1 << playerID, {800157557, players.user(), 225624744, math.random(0, 9999)})
		util.call_foreign_function(CWeaponDamageEventTrigger, pedPtr, pPed, pPed + 0x90, 0, 1, joaat("weapon_pistol"), 500.0, 0, 0, DF_IsAccurate | DF_IgnorePedFlags | DF_SuppressImpactAudio | DF_IgnoreRemoteDistCheck, 0, 0, 0, 0, 0, 0, 0, 0.0)
		if util.current_time_millis() > timer then
			toast($"{players.get_name(playerID)}'s godmode can't be removed :((")
			timer = util.current_time_millis() + 3000
			return
		end
		yield()
	until IS_PED_DEAD_OR_DYING(ped)
	yield()
	yield()
	timer = util.current_time_millis() + 3000
end

--#glitchVehicle
local glitchVehRoot = trolling_playermenu:list("Glitch Vehicle")
local glitchVehMdl = joaat("prop_ld_ferris_wheel")
glitchVehRoot:list_select("Object", {"glitchvehobj"}, "", object_stuff, object_stuff[1][1], function(mdlHash)
    glitchVehMdl = mdlHash
end)
local glitchveh
glitchveh = glitchVehRoot:toggle_loop("Glitch Vehicle", {"glitchvehicle"}, "Works on all menus and isn't detected by any.", function()
    local focusedPlayers = players.get_focused()
    if #focusedPlayers == 0 then
        toast("No player is focused.")
        return
    end

    local playerID = focusedPlayers[1]  -- Get the ID of the focused player

    local ped = GET_PLAYER_PED_SCRIPT_INDEX(playerID)
    local pos = GET_ENTITY_COORDS(ped, false)
    local vehicle = GET_VEHICLE_PED_IS_USING(ped)
    local veh_model = players.get_vehicle_model(playerID)
    local seat_count = GET_VEHICLE_MODEL_NUMBER_OF_SEATS(veh_model)
    util.request_model(glitchVehMdl)

    if IS_REMOTE_PLAYER_IN_NON_CLONED_VEHICLE(playerID) then
        toast(players.get_name(playerID) .. "'s vehicle has not been cloned yet. :/")
        return
    end

    if not IS_PED_IN_ANY_VEHICLE(ped) then
        toast(lang.get_localised(PLYNVEH):gsub("{}", players.get_name(playerID)))
        glitchveh.value = false
        util.stop_thread()
        return
    end

    if not ARE_ANY_VEHICLE_SEATS_FREE(vehicle) then
        toast("No free seats are available. :/")
        glitchveh.value = false
        util.stop_thread()
        return
    end

    local glitchPed = createRandomPed(pos)
    local glitchObj = entities.create_object(glitchVehMdl, pos)
    entities.set_can_migrate(glitchPed, false)
    entities.set_can_migrate(glitchObj, false)
    SET_ENTITY_VISIBLE(glitchObj, false)
    SET_ENTITY_INVINCIBLE(glitchPed, true)

    for i = 0, seat_count - 1 do
        if ARE_ANY_VEHICLE_SEATS_FREE(vehicle) then
            local emptyseat = i
            for l = 1, 25 do
                SET_PED_INTO_VEHICLE(glitchPed, vehicle, emptyseat)
                ATTACH_ENTITY_TO_ENTITY(glitchObj, glitchPed, 0, v3(), v3(), false, false, false, false, 0, true, false)
                SET_ENTITY_COLLISION(glitchObj, true, true)
                yield()
            end
        end
    end

    if glitchPed then
        entities.delete(glitchPed)
    end
    if glitchObj then 
        entities.delete(glitchObj)
    end
end, function()
    if glitchPed then
        entities.delete(glitchPed)
    end
    if glitchObj then 
        entities.delete(glitchObj)
    end
end)

--#glitchPlayer
local playerID = pid
local glitchPlyrRoot = trolling_playermenu:list("Glitch Player")
local glitchObjMdl = joaat("prop_ld_ferris_wheel")
glitchPlyrRoot:list_select("Object", {"glitchplayerobj"}, "", object_stuff, object_stuff[1][1], function(mdlHash)
    glitchObjMdl = mdlHash
end)

local spawnDelay = 150
glitchPlyrRoot:slider("Spawn Delay", {"spawndelay"}, "Note: Low spawn delays may be marked as a modded event if used on a stand user.", 50, 3000, 100, 10, function(amount)
    spawnDelay = amount
end)

local glitchplayer
glitchplayer = glitchPlyrRoot:toggle_loop("Glitch Player", {"glitchplayer"}, "Blocked by menus with entity spam protections.", function()
    local rallytruck = joaat("rallytruck")
    local ped = GET_PLAYER_PED_SCRIPT_INDEX(playerID)
    local pos = players.get_position(playerID)

    if not DOES_ENTITY_EXIST(ped) then
        toast(string.format("%s is too far. :/", players.get_name(playerID)))
        glitchvalue = false
        util.stop_thread()
    end

    util.request_model(glitchObjMdl)
    util.request_model(rallytruck)
    local obj = entities.create_object(glitchObjMdl, pos)
    local vehicle = entities.create_vehicle(rallytruck, pos, 0)
    SET_ENTITY_VISIBLE(obj, false)
    SET_ENTITY_VISIBLE(vehicle, false)
    SET_ENTITY_INVINCIBLE(obj, true)
    SET_ENTITY_COLLISION(obj, true, true)
    yield(delay)
    entities.delete(obj)
    entities.delete(vehicle)
    yield(delay)
end)

--#vehicleKick
local veh_kick = trolling_playermenu:list("Kick From Vehicle")
veh_kick:action("Drag Method", {"dragkick"}, "Spawns a ped to forcefully drag them out of their vehicle.", function()
    if playerID == players.user() then 
        toast(lang.get_localised(CMDOTH))
        return
    end
    local timer = util.current_time_millis() + 2500
    local ped = GET_PLAYER_PED_SCRIPT_INDEX(playerID)

    if IS_REMOTE_PLAYER_IN_NON_CLONED_VEHICLE(playerID) then
        toast($"{players.get_name(playerID)}'s vehicle has not been cloned yet. :/")
        return
    end
    
    if not IS_PED_IN_ANY_VEHICLE(ped) then
        toast(lang.get_localised(PLYNVEH):gsub("{}", players.get_name(playerID)))
        return 
    end
    
    local pos = players.get_position(playerID)
    local vehicle = GET_VEHICLE_PED_IS_USING(ped)
    local driver = NETWORK_GET_PLAYER_INDEX_FROM_PED(GET_PED_IN_VEHICLE_SEAT(vehicle, -1))
    local passenger = NETWORK_GET_PLAYER_INDEX_FROM_PED(GET_PED_IN_VEHICLE_SEAT(vehicle, -2))
    local seat = getSeatPedIsIn(ped)
    local ping = ROUND(NETWORK_GET_AVERAGE_PING(playerID))
    pos.z -= 50

    randomPed = createRandomPed(pos)
    entities.set_can_migrate(randomPed, false)
    SET_ENTITY_INVINCIBLE(randomPed, true)
    SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(randomPed, true)
    SET_PED_CONFIG_FLAG(randomPed, 366, true)
    while not GET_IS_TASK_ACTIVE(randomPed, 160) do
        if util.current_time_millis() > timer then
            if isDebugMode then
                toast("failed to assign CTaskEnterVehicle to ped. :/")
            else
                toast($"Failed to kick {players.get_name(playerID)} from the vehicle. :/")
            end
            entities.delete(randomPed)
            return
        end
        yield()
    end
    repeat
        if GET_IS_TASK_ACTIVE(ped, 2) and getSeatPedIsIn(randomPed) == seat then
            repeat
                yield()
            until not GET_IS_TASK_ACTIVE(ped, 2)
        end
        if util.current_time_millis() > timer and getSeatPedIsIn(randomPed) != seat then
            if ping > 80 then
                toast($"Failed to kick {players.get_name(playerID)} from the vehicle due to high ping ({ping}ms). :/")
            else
                toast($"Failed to kick {players.get_name(playerID)} from the vehicle. :/")
            end
            entities.delete(randomPed)
            timer = util.current_time_millis() + 2500
            break 
        end
        yield()
    until not IS_PED_IN_ANY_VEHICLE(ped)
    entities.delete(randomPed)
    timer = util.current_time_millis() + 2500
end)

veh_kick:action("Shuffle Method", {"shufflekick"}, 'Spawns a ped in the passenger seat and forces it to push them out. Works everytime unless the target is using "cant be dragged out".', function()
    if playerID == players.user() then 
        toast(lang.get_localised(CMDOTH))
        return
    end

    local timer = util.current_time_millis() + 2500
    local ped = GET_PLAYER_PED_SCRIPT_INDEX(playerID)
    local pos = players.get_position(playerID)
    local vehicle = GET_VEHICLE_PED_IS_USING(ped)
    if IS_REMOTE_PLAYER_IN_NON_CLONED_VEHICLE(playerID) then
        toast($"{players.get_name(playerID)}'s vehicle has not been cloned yet. :/")
        return
    end

    if vehicle == 0 then
        util.toast(lang.get_localised(1067523721):gsub("{}", players.get_name(playerID)))
        return 
    end

    if GET_VEHICLE_MODEL_NUMBER_OF_SEATS(GET_ENTITY_MODEL(vehicle)) == 1 then
        util.toast("Vehicle doesn't allow for passengers. :/")
        return
    end

    if not IS_VEHICLE_SEAT_FREE(vehicle, -2) then
        util.toast("Passenger seat is currently occupied. :/")
        return
    end

    if not CAN_SHUFFLE_SEAT(vehicle, -1) then 
        util.toast("Seat can not be shuffled into. :/")
        return
    end

    local randomPed = createRandomPed(pos)
    entities.set_can_migrate(randomPed, false)
    SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(randomPed, true)
    SET_PED_INTO_VEHICLE(randomPed, vehicle, -2)
    TASK_SHUFFLE_TO_NEXT_VEHICLE_SEAT(randomPed, vehicle)
    if IS_PED_IN_ANY_VEHICLE(ped) then
        repeat
            if GET_IS_TASK_ACTIVE(ped, 2) then
                timer = util.current_time_millis() + 2500
            end
            if util.current_time_millis() > timer then
                entities.delete(randomPed)
                util.toast("Ped failed to shuffle to drivers seat. :/")                
                timer = util.current_time_millis() + 2500
                break
            end
            util.yield()
        until not IS_PED_IN_ANY_VEHICLE(ped)
    end
    entities.delete(randomPed)
    SET_VEHICLE_DOORS_LOCKED_FOR_PLAYER(vehicle, playerID, true)
end)

veh_kick:action("Script Method", {"scriptkick"}, "Uses a script event to kick them from their vehicle.", function()
    local ped = GET_PLAYER_PED_SCRIPT_INDEX(playerID)
    local vehicle = GET_VEHICLE_PED_IS_USING(ped)
    SET_VEHICLE_EXCLUSIVE_DRIVER(vehicle, players.user_ped(), 0)
end)

--#towVehicle
local playerID = pid
trolling_playermenu:action("Tow Vehicle", {"tow"}, "It's honestly pretty shit and doesn't work properly half the time.", function()
    if not playerID then
        return
    end
    local towtruckMdl = joaat("towtruck3")
        if not towtruckMdl then
        return
    end
    local ped = GET_PLAYER_PED_SCRIPT_INDEX(playerID)
    local vehicle = GET_VEHICLE_PED_IS_USING(ped)
    if not IS_PED_IN_ANY_VEHICLE(ped) then
        toast(lang.get_localised(PLYNVEH):gsub("{}", players.get_name(playerID)))
        return
    end
    local pos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, 0.0, 7.0, 0.0)
    if towtruckMdl ~= 0 then
        util.request_model(towtruckMdl)
    else
        return
    end
    entities.request_control(vehicle, 2500)
    local randomPed = createRandomPed(pos)
    local towtruck = entities.create_vehicle(towtruckMdl, pos, GET_ENTITY_HEADING(vehicle))
    SET_ENTITY_INVINCIBLE(randomPed, true)
    SET_PED_INTO_VEHICLE(randomPed, towtruck, -1)
    ATTACH_VEHICLE_TO_TOW_TRUCK(towtruck, vehicle, false, 90.0, 90.0, -180.0)
    SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(randomPed, true)
    TASK_VEHICLE_DRIVE_WANDER(randomPed, towtruck, 9999.0, DF_SwerveAroundAllCars | DF_AvoidRestrictedAreas | DF_GoOffRoadWhenAvoiding | DF_SteerAroundObjects | DF_UseShortCutLinks | DF_ChangeLanesAroundObstructions)
end)

--#ghostPlayer
local ghostPlayer
local playerID = pid
local ghostPlayer
ghostPlayer = miscPlayer:toggle_loop("Ghost Player", {"ghost"}, "Ghosts the selected player.", function()
    if not playerID then 
        return
    end
    if playerID == players.user() then 
        toast(lang.get_localised(CMDOTH))
        ghostPlayer.value = false
        return
    end
        if not players.exists(playerID) then
        ghostPlayer.value = false
        return
    end
    SET_REMOTE_PLAYER_AS_GHOST(playerID, true)
end, function()
    if not playerID then 
        return
    end
    SET_REMOTE_PLAYER_AS_GHOST(playerID, false)
end)

--#removeGodmode
local playerID = pid 
playermenu:toggle_loop("Remove Player Godmode", {}, lang.get_localised(-748077967), function()
    util.trigger_script_event(1 << playerID, {800157557, players.user(), 225624744, math.random(0, 9999)})
end)
playermenu:toggle_loop("Remove Vehicle Godmode", {}, lang.get_localised(-748077967), function()
    local playerID = pid
    local ped = GET_PLAYER_PED_SCRIPT_INDEX(playerID)
    if not IS_PED_IN_ANY_VEHICLE(ped) then
        util.toast(lang.get_localised(PLYNVEH):gsub("{}", players.get_name(playerID)))
        glitchveh.value = false
        util.stop_thread() 
    end
    local vehicle = GET_VEHICLE_PED_IS_USING(ped)
    entities.request_control(vehicle, 2500)
    if IS_PED_IN_ANY_VEHICLE(ped) and not IS_PLAYER_DEAD(ped) then
        SET_ENTITY_CAN_BE_DAMAGED(vehicle, true)
        SET_ENTITY_INVINCIBLE(vehicle, false)
        SET_ENTITY_PROOFS(vehicle, false, false, false, false, false, false, false, false)
    end
end)

--#playerOrbital
playermenu:action("Orbital Strike", {"orb"}, "Just a 'Normal' Orbital Strike.", function()
    local playerID = pid
    local timer = util.current_time_millis() + 3000
    if playerID == players.user() then
        util.toast("Erhm, you can't do this >:( Bad pet.")
        return
    end
    if isOrbActive then
        util.toast("Orbital strike is already active you silly goober :33")
        return
    end
    if IS_PLAYER_DEAD(playerID) or not isNetPlayerOk(playerID) then
        return
    end
    local ped = GET_PLAYER_PED_SCRIPT_INDEX(playerID)
    isOrbActive = true
    setBit(memory.script_global(GlobalplayerBD + 1 + (players.user() * 463) + 424), 0)
    util.yield(1000) -- yielding a second because it's a bit iffy on high(ish) ping players (150ms+)
    local pos = players.get_position(playerID)
    ADD_OWNED_EXPLOSION(players.user_ped(), pos, 59, 1.0, true, false, 1.0)
    USE_PARTICLE_FX_ASSET("scr_xm_orbital")
    START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD("scr_xm_orbital_blast", pos, v3(), 1.0, false, false, false, true)
    PLAY_SOUND_FROM_COORD(0, "DLC_XM_Explosions_Orbital_Cannon", pos, 0, true, 0, false) -- hardcoding sound id because GET_SOUND_ID doesn't work sometimes
    util.yield(1000)
    clearBit(memory.script_global(GlobalplayerBD + 1 + (players.user() * 463) + 424), 0)
    repeat
        if util.current_time_millis() > timer and not IS_PED_DEAD_OR_DYING(ped) then
            util.toast("I failed... I'm sorry :(")
            timer = util.current_time_millis() + 3000
            return
        end
        util.yield()
    until not IS_PED_DEAD_OR_DYING(ped)

    STOP_SOUND(0)
    isOrbActive = false
    timer = util.current_time_millis() + 3000
end)
local isGodmodeRemovable = {}
playermenu:action("Orbital Strike Godmode Player", {"orbgod"}, "", function()
    local focusedPlayers = players.get_focused()
    if #focusedPlayers == 0 then
        return
    end
    local playerID = focusedPlayers[1]
    local timer = util.current_time_millis() + 3500
    local ped = GET_PLAYER_PED_SCRIPT_INDEX(playerID)
    local vehicle = GET_VEHICLE_PED_IS_USING(ped)
    if IS_PLAYER_DEAD(playerID) then
        util.toast("They're already dead, calm down :3")
        return
    end
    if IS_REMOTE_PLAYER_IN_NON_CLONED_VEHICLE(playerID) then
        util.toast(players.get_name(playerID) .. "'s ped hasn't been cloned yet you silly :3\nSpectate them or get closer to them.")
        return
    end
    if not players.is_godmode(playerID) then 
        util.toast(players.get_name(playerID) .. " is not in godmode or is using anti-detections :( Sowwy")
        return 
    end
    repeat
        util.toast("NGHH~ I'm so close >~<")
        if util.current_time_millis() > timer then
            util.toast("I'm sorry... I couldn't do it :((")
            return
        end
        util.trigger_script_event(1 << playerID, {800157557, players.user(), 225624744, math.random(0, 9999)})
        util.yield()
    until not players.is_godmode(playerID)
    isGodmodeRemovable[playerID] = true
    if isGodmodeRemovable[playerID] then
        util.toast("Did I do a good job? >///<")
        if isPlayerInAnyVehicle(playerID) and entities.is_invulnerable(vehicle) then
            entities.request_control(vehicle, 2500)
            SET_ENTITY_CAN_BE_DAMAGED(vehicle, true)
            SET_ENTITY_INVINCIBLE(vehicle, false)
            SET_ENTITY_PROOFS(vehicle, false, false, false, false, false, false, false, false)
        end
        setBit(memory.script_global(GlobalplayerBD + 1 + (players.user() * 463) + 424), 0)
        util.yield(500) -- yielding so their game realizes I'm using the orb
        local pos = players.get_position(playerID)
        ADD_OWNED_EXPLOSION(players.user_ped(), pos, 59, 1.0, true, false, 1.0)
        USE_PARTICLE_FX_ASSET("scr_xm_orbital")
        START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD("scr_xm_orbital_blast", pos, v3(), 1.0, false, false, false, true)
        PLAY_SOUND_FROM_COORD(0, "DLC_XM_Explosions_Orbital_Cannon", pos, 0, true, 0, false) -- hardcoding sound id because GET_SOUND_ID doesn't work sometimes
        godKill(playerID)
        util.yield(1000) -- yielding here isn't needed but it gives yourself the notification that you orbed them
        clearBit(memory.script_global(GlobalplayerBD + 1 + (players.user() * 463) + 424), 0)
        util.yield(3000)
        STOP_SOUND(0)
        isGodmodeRemovable[playerID] = false
    end
end)
griefing_playermenu:toggle_loop("Orbital Strike Loop", {"orbloop"}, "Will show the kill as You Killed ...\nNot, You Obliterated ...", function()
    local playerID = pid
    local timer = util.current_time_millis() + 3000
    if playerID == players.user() then
        util.toast("Erhm, you can't do this >:( Bad pet.")
        return
    end
    if IS_PLAYER_DEAD(playerID) or not isNetPlayerOk(playerID) then
        return
    end
    local ped = GET_PLAYER_PED_SCRIPT_INDEX(playerID)
    isOrbActive = true
    setBit(memory.script_global(GlobalplayerBD + 1 + (players.user() * 463) + 424), 0)
    local pos = players.get_position(playerID)
    ADD_OWNED_EXPLOSION(players.user_ped(), pos, 59, 1.0, true, false, 1.0)
    USE_PARTICLE_FX_ASSET("scr_xm_orbital")
    START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD("scr_xm_orbital_blast", pos, v3(), 1.0, false, false, false, true)
    PLAY_SOUND_FROM_COORD(0, "DLC_XM_Explosions_Orbital_Cannon", pos, 0, true, 0, false) -- hardcoding sound id because GET_SOUND_ID doesn't work sometimes
    clearBit(memory.script_global(GlobalplayerBD + 1 + (players.user() * 463) + 424), 0)
    repeat
        if util.current_time_millis() > timer and not IS_PED_DEAD_OR_DYING(ped) then
            util.toast("I failed... I'm sorry :(")
            timer = util.current_time_millis() + 3000
            return
        end
        util.yield()
    until not IS_PED_DEAD_OR_DYING(ped)

    STOP_SOUND(0)
    isOrbActive = false
    timer = util.current_time_millis() + 3000
end)

--#restrainPlayer
griefing_playermenu:toggle_loop("Restraining Order", {"restrain"}, "", function()
    local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
    local theta = (math.random() + math.random(0, 1)) * math.pi
    local coord = vect.new(
        pos.x + 8 * math.cos(theta),
        pos.y - 13 * math.sin(theta),
        pos.z - 3 * math.sin(theta)
    )
    local veh_hash = util.joaat("khanjali")
    STREAMING.REQUEST_MODEL(veh_hash)
    while not STREAMING.HAS_MODEL_LOADED(veh_hash) do
        util.yield()
    end
    local veh = entities.create_vehicle(veh_hash, coord, CAM.GET_GAMEPLAY_CAM_ROT(-8).z)
    SET_ENT_FACE_ENT(veh, player_ped)
    VEHICLE.SET_VEHICLE_DOORS_LOCKED(veh, 2)
    VEHICLE.SET_VEHICLE_FORWARD_SPEED(veh, 125)
    util.yield(100)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(veh)
    entities.delete_by_handle(veh)
    if not players.exists(pid) then
        util.stop_thread()
    end
end)

--#hijackPlayer
trolling_playermenu:action("Hijack Vehicle", {"hijack"}, "Note: May be inconsistent on higher ping players or just not work at all for some players.", function()
    if playerID == players.user() then 
        toast(lang.get_localised(CMDOTH))
        return
    end

    local timer = util.current_time_millis() + 2500
    local ped = GET_PLAYER_PED_SCRIPT_INDEX(playerID)
    local pos = players.get_position(playerID)
    local vehicle = GET_VEHICLE_PED_IS_USING(ped)
    local driver = NETWORK_GET_PLAYER_INDEX_FROM_PED(GET_PED_IN_VEHICLE_SEAT(vehicle, -1))
    local passenger = NETWORK_GET_PLAYER_INDEX_FROM_PED(GET_PED_IN_VEHICLE_SEAT(vehicle, -2))
    local drivingStyle = DF_SwerveAroundAllCars | DF_AvoidRestrictedAreas | DF_GoOffRoadWhenAvoiding | DF_SteerAroundObjects | DF_UseShortCutLinks | DF_ChangeLanesAroundObstructions
    local ping = ROUND(NETWORK_GET_AVERAGE_PING(playerID))
    if IS_REMOTE_PLAYER_IN_NON_CLONED_VEHICLE(playerID) then
        toast($"{players.get_name(playerID)}'s vehicle has not been cloned yet. :/")
        return
    end

    if vehicle == 0 then
        toast(lang.get_localised(PLYNVEH):gsub("{}", players.get_name(playerID)))
        return 
    end

    pos.z -= 30
    if not IS_PED_A_PLAYER(GET_PED_IN_VEHICLE_SEAT(vehicle, -1)) then
        toast("Vehicle has already been hijacked. :D")
        return 
    end
    randomPed = createRandomPed(pos)
    SET_ENTITY_INVINCIBLE(randomPed, true)
    SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(randomPed, true)
    entities.set_can_migrate(randomPed, false)
    TASK_ENTER_VEHICLE(randomPed, vehicle, 1000, -1, 1.0, ECF_WARP_ENTRY_POINT | ECF_DONT_WAIT_FOR_VEHICLE_TO_STOP | ECF_JACK_ANYONE | ECF_WARP_PED | ECF_WARP_IF_DOOR_IS_BLOCKED, 0, false)
    while not GET_IS_TASK_ACTIVE(randomPed, 160) do
        if util.current_time_millis() > timer then
            if isDebugMode then
                toast("failed to assign CTaskEnterVehicle to ped. :/")
            else
                toast("Failed to hijack their vehicle. :/")
            end
            entities.delete(randomPed)
            return
        end
        yield()
    end
    repeat
        if GET_IS_TASK_ACTIVE(ped, 2) then
            timer = util.current_time_millis() + 2500
        end
        if util.current_time_millis() > timer and IS_PED_IN_ANY_VEHICLE(ped) then
            if ping > 80 then -- this is high enough to interfere with the hijack process
                toast($"Failed to hijack their vehicle due to high ping ({ping}ms). :/")
            else
                toast("Failed to hijack their vehicle. :/")
            end
            entities.delete(randomPed)
            timer = util.current_time_millis() + 2500
            return 
        end
        yield()
    until not IS_PED_IN_ANY_VEHICLE(ped)
    if getSeatPedIsIn(randomPed) == -1 then
        entities.request_control(vehicle, 2500)
        TASK_VEHICLE_DRIVE_WANDER(randomPed, vehicle, 9999.0, drivingStyle) 
        toast("Bippity boppity their car is now your property :D")
        if not GET_VEHICLE_DOORS_LOCKED_FOR_PLAYER(vehicle, playerID) then
            SET_VEHICLE_DOORS_LOCKED_FOR_PLAYER(vehicle, playerID, true)
        end
    end
    yield(1000)
    if not GET_IS_TASK_ACTIVE(randomPed, 151) then
        if not IS_PED_IN_ANY_VEHICLE(randomPed) then
            repeat
                if util.current_time_millis() > timer then
                    if isDebugMode then
                        toast("failed to assign CTaskEnterVehicle to ped. :/")
                    else
                        toast("Failed to hijack their vehicle. :/")
                    end
                    entities.delete(randomPed)
                    return
                end
                SET_PED_INTO_VEHICLE(randomPed, vehicle, -1)
                yield()
            until GET_VEHICLE_PED_IS_USING(randomPed) == vehicle
            entities.request_control(randomPed, 2500)
            TASK_VEHICLE_DRIVE_WANDER(randomPed, vehicle, 9999.0, drivingStyle)
        end

    end
    yield(5000)
    if randomPed != nil and not IS_PED_IN_ANY_VEHICLE(randomPed, false) then -- 2nd check cus sometimes doesnt delete the first time
        entities.delete(randomPed)
    end
end)

IS_PLAYER_DEAD = function(player)
    return native_invoker.unified_bool(player, 0x424D4687FA1E5652, "i")
end
end

util.create_tick_handler(function()
local local_player = players.user_ped()
end)

players.on_join(GenerateFeatures)

for pid = 0, 30 do
if players.exists(pid) then
    GenerateFeatures(pid)
end
end

function delete_entity(ent)
menu.delete(ent_lists[ent])
ent_lists[ent] = nil
entities.delete_by_handle(ent)
end

util.keep_running()