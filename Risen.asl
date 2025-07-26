// ASL by Jaffra

state("Risen", "Old Patch") {
	// POSITION VECTOR
	float x:        "Game.dll",    0x104418C;
	float y:        "Game.dll",    0x1044190;
	float z:        "Game.dll",    0x1044194;

	// LOADING & CUTSCENE
	bool isLoading: "Game.dll",    0xFEA66C;
	ulong cutscene: "binkw32.dll", 0x02F054;

	// eCSceneAdmin.gCClock_PS.secondsPlayed
	float playtime: "Game.dll",    0xFA63A0, 0x48, 0x24;

	// QUESTS
	// Quests are sorted into a bunch of different arrays depending on their type.
	// We only need two of the possible quest status values (1 = started, 2 = completed), stored at
	// gCQuestManager.<array>[i].questStatus
	ulong questManager: "Game.dll", 0x00FDC188;
	int chapter:        "Game.dll", 0x00FDC188, 0xCC;
	
	int Scordo_OpenHarborTunnelDoor:  "Game.dll", 0x00FDC188, 0x30, 0x12C, 0x78;
	int Oscar_DonsGoldSwordPieces:    "Game.dll", 0x00FDC188, 0x24,  0x4C, 0x78;
	int Eldric_GoToHut:               "Game.dll", 0x00FDC188, 0x78,  0x78, 0x78;
	int Inquisitor_OpenPortal:        "Game.dll", 0x00FDC188, 0x30, 0x1AC, 0x78;
	int Eldric_FixTitanArmor:         "Game.dll", 0x00FDC188, 0x24,  0x10, 0x78;

	int Player_FindAllTeleportstones: "Game.dll", 0x00FDC188, 0x24,  0xE0, 0x78;
	int Ursegor_Freedom:              "Game.dll", 0x00FDC188, 0x30,  0xFC, 0x78; 

	// NavigationAdmin.Player.PropertySets[15].Strength  (15 = Skills (gCSkills_PS))
	int strength: "Game.dll", 0x00FA4644, 0x198, 0x1C, 0x3C, 0x2C;
	int health:   "Game.dll", 0x00FA4644, 0x198, 0x1C, 0x3C, 0x10;

	// COUNTER FOR ScriptGame.PS_Titan_Begin()
	int titanCounter: "Script_Game.dll", 0x00213700;

	// eCWeatherAdmin.weatherStates.thunderProbability
	float thunderProbability: "Engine.dll", 0xA92B58, 0x328, 0x48;
}

state("Risen", "New Patch") {
	// POSITION VECTOR
	float x:        "Game.dll",    0x11C5F10;
	float y:        "Game.dll",    0x11C5F14;
	float z:        "Game.dll",    0x11C5F18;

	// LOADING & CUTSCENE
	bool isLoading: "Game.dll",    0x12AA0C8;
	ulong cutscene: "binkw64.dll", 0x003AE25;

	// eCSceneAdmin.gCClock_PS.secondsPlayed
	float playtime: "Game.dll",    0x01194880, 0x88, 0x34;

	// QUESTS
	// Quests are sorted into a bunch of different arrays depending on their type.
	// We only need two of the possible quest status values (1 = started, 2 = completed), stored at
	// gCQuestManager.<array>[i].questStatus
	ulong questManager: "Game.dll", 0x0126E7C8;
	int chapter:        "Game.dll", 0x0126E7C8, 0x190;
	
	int Scordo_OpenHarborTunnelDoor:  "Game.dll", 0x0126E7C8, 0x60, 0x258, 0xC8;
	int Oscar_DonsGoldSwordPieces:    "Game.dll", 0x0126E7C8, 0x48,  0x98, 0xC8;
	int Eldric_GoToHut:               "Game.dll", 0x0126E7C8, 0xF0,  0xF0, 0xC8;
	int Inquisitor_OpenPortal:        "Game.dll", 0x0126E7C8, 0x60, 0x358, 0xC8;
	int Eldric_FixTitanArmor:         "Game.dll", 0x0126E7C8, 0x48,  0x20, 0xC8;

	int Player_FindAllTeleportstones: "Game.dll", 0x0126E7C8, 0x48, 0x1C0, 0xC8;
	int Ursegor_Freedom:              "Game.dll", 0x0126E7C8, 0x60, 0x1F8, 0xC8; 


	// NavigationAdmin.Player.PropertySets[15].Strength  (15 = Skills (gCSkills_PS))
	int strength: "Game.dll", 0x01194858, 0x2C0, 0x40, 0x78, 0x3C;
	int health:   "Game.dll", 0x01194858, 0x2C0, 0x40, 0x78, 0x20;

	// COUNTER FOR ScriptGame.PS_Titan_Begin
	int titanCounter: "Script_Game.dll", 0x002D4000;

	// eCWeatherAdmin.weatherStates.thunderProbability
	float thunderProbability: "Engine.dll", 0xC6B880, 0x4C8, 0x54;
}

/*
	// Code to print the name of every quest in the game and where to find it
	IntPtr questManager = (IntPtr)current.questManager;

	for (int j = 0x48; j < 0x114; j += 0x18) {
		var arraySize = game.ReadValue<int>(questManager + j + 0x8);
		for (int i = 0; i < arraySize; i++) {
			var questName = new DeepPointer(questManager + j, i * 0x8, 0x10, 0x0).DerefString(game, 100);
			if (questName.Contains("Ursegor")) {
				var offset = i * 0x8;
				//print("Array " + j.ToString("X") + " : " + "[" + i + "]" + " (" + offset.ToString("X") + ")" + " = " + questName);
				print("0x" + j.ToString("X") + ", 0x" + offset.ToString("X") + " = " + questName);
			}	
		}
		print("-------------------");
	}
*/

startup {
	settings.Add("Any%", false, "Any% / No Annoying Glitches");
		settings.Add("City",                        true, "Reach the city",                    "Any%");
		settings.Add("Scordo_OpenHarborTunnelDoor", true, "Open the harbor tunnel door",       "Any%");
		settings.Add("Oscar_DonsGoldSwordPieces",   true, "Give Oscar the Gold Sword Pieces",  "Any%");
		settings.Add("Chapter2",                    true, "Reach Chapter 2",                   "Any%");
		settings.Add("Eldric_GoToHut_start",        true, "Start Eldric's Go To Hut quest",    "Any%");
		settings.Add("Eldric_GoToHut_complete",     true, "Complete Eldric's Go To Hut quest", "Any%");
		settings.Add("Inquisitor_OpenPortal",       true, "The Inquisitor opens the Portal",   "Any%");
		settings.Add("Chapter3",                    true, "Reach Chapter 3",                   "Any%");
		settings.Add("Chapter4",                    true, "Reach Chapter 4",                   "Any%");
		settings.Add("Eldric_FixTitanArmor",        true, "Eldric fixes Titan Armor",          "Any%");
		settings.Add("EnterTitanArena",             true, "Enter the Titan Arena",             "Any%");
		settings.Add("Credits",                     true, "Reach the credits",                 "Any%");

	settings.Add("Extra", false, "Extra splits");
		settings.Add("5Str",                        true, "Split every time you gain 5 Strength (Any%)", "Extra");

	settings.Add("NG+",   false, "NG+");
		settings.Add("NG+_Jail",                         true, "Be sent to monastery",                      "NG+");
		settings.Add("NG+_Player_FindAllTeleportstones", true, "Get Teleport Stones quest from Inquisitor", "NG+");
		settings.Add("NG+_Ursegor_Freedom_start",        true, "Start quest: Ursegor's ",                   "NG+");
		settings.Add("NG+_Ursegor_Freedom_complete",     true, "Complete quest: Ursegor's ",                "NG+");
		settings.Add("NG+_EnterTitanArena",              true, "Enter the Titan Arena",                     "NG+");
		settings.Add("NG+_Credits",                      true, "Reach the credits",                         "NG+");
	
	settings.Add("DisableLightning", false, "Disable lightning effect");

	vars.isTimerPaused = false;
}

init {
	var moduleSize = modules.First().ModuleMemorySize;
	print("Module Memory Size = " + moduleSize);

	if (moduleSize == 1343488) {
		version = "Old Patch";
	}
	else if (moduleSize == 1069056) {
		version = "New Patch";
	}
	else {
		version = "Unknown";
	}

	var module = modules.FirstOrDefault(m => m.ModuleName == "Script_Game.dll");

	if (module != null) {
		var ptr = (IntPtr)module.BaseAddress;

		if (version == "New Patch") {
			// E9 94 86 05 00 90
			byte[] jmp = new byte[]	{
				0xE9, 0x94, 0x86, 0x05, 0x00,       // jmp Script_Game.dll.text+1F6A31
				0x90                                // nop
			};

			// FF 15 71 B2 00 00 FE 05 C3 C5 0D 00 E9 5B 79 FA FF
			byte[] codecave = new byte[] {
				0xFF, 0x15, 0x71, 0xB2, 0x00, 0x00, // call qword ptr [Script_Game.dll.rdata+CA8]
				0xFE, 0x05, 0xC3, 0xC5, 0x0D, 0x00, // inc byte ptr [Script_Game.dll+2D4000]
				0xE9, 0x5B, 0x79, 0xFA, 0xFF        // jmp Script_Game.PS_Titan_Begin+8BD
			};

			game.WriteBytes(ptr + 0x19EAE0+0x8B8, jmp);
			game.WriteBytes(ptr + 0x1F7A31, codecave);

			print("Patched Script_Game.dll (New Patch)");
		}
		else if (version == "Old Patch") {
			// E9 2A 14 00 00 90
			byte[] jmp = new byte[]	{
				0xE9, 0x2A, 0x14, 0x00, 0x00,       // jmp Script_Game.dll.text+99EA0
				0x90                                // nop
			};

			// FF 15 50 44 D2 34 50 B8 00 37 D2 34 FE 00 58 E9 C2 EB FF FF
			byte[] codecave = new byte[] {
				0xFF, 0x15, 0x00, 0x00, 0x00, 0x00, // call dword ptr ________
				0x50,                               // push eax
				0xB8, 0x00, 0x00, 0x00, 0x00,       // mov eax, ________
				0xFE, 0x00,                         // inc byte ptr [eax]
				0x58,                               // pop eax
				0xE9, 0xC2, 0xEB, 0xFF, 0xFF        // jmp Script_Game.dll.text+98A76
			};

			// Get absolute addresses
			var counterAddr  = (int)ptr + 0x213700;
			var setStateAddr = (int)ptr + 0x214450; // [Script_Game.dll.idata+2450]

			byte[] bytes = BitConverter.GetBytes(counterAddr);
			codecave[8]  = bytes[0];
			codecave[9]  = bytes[1];
			codecave[10] = bytes[2];
			codecave[11] = bytes[3];

			bytes = BitConverter.GetBytes(setStateAddr);
			codecave[2] = bytes[0];
			codecave[3] = bytes[1];
			codecave[4] = bytes[2];
			codecave[5] = bytes[3];

			game.WriteBytes(ptr + 0x992E0+0x791, jmp);
			game.WriteBytes(ptr + 0x9AEA0, codecave);

			print("Patched Script_Game.dll (Old Patch)");
		}
	}
	else {
		throw new InvalidOperationException("Script_Game.dll not found. Trying again...");
	}

	vars.startX = -38558.72000;
	vars.startY =    -46.57122;
	vars.startZ =  -5770.01200;

	vars.cityX1 = -13890.23000;
	vars.cityZ1 = -13797.83000;
	vars.cityX2 = -14541.90000;
	vars.cityZ2 = -14063.06000;

	vars.landX1 = -11254.49023;
	vars.landZ1 = -22477.13086;
	vars.landX2 = -11354.64551;
	vars.landZ2 = -22771.71094;

	vars.completedSplits = new HashSet<string>();
}

update {
	// Deactivate ASL if unknown game version
	if (version == "Unknown") {
		return false;
	}

	// Disable annoying lightning effect
	if (settings["DisableLightning"] && current.thunderProbability != 0) {
		if (version == "New Patch") {
			var ptr = new DeepPointer("Engine.dll", 0xC6B880, 0x4C8).Deref<long>(game);
			game.WriteBytes((IntPtr)ptr + 0x54, new byte[] { 0, 0, 0, 0 });
		}
		else if (version == "Old Patch") {
			var ptr = new DeepPointer("Engine.dll", 0xA92B58, 0x328).Deref<int>(game);
			game.WriteBytes((IntPtr)ptr + 0x48, new byte[] { 0, 0, 0, 0 });
		}
	}

	// Handle timer during crashes and game restarts
	if (vars.isTimerPaused && current.cutscene != 0 && old.cutscene == 0) {
		vars.isTimerPaused = false;
	}
}

start {
	if (Math.Abs(current.x - vars.startX) < 0.01
	 && Math.Abs(current.y - vars.startY) < 0.01
	 && Math.Abs(current.z - vars.startZ) < 0.01) {
		if (old.isLoading && !current.isLoading) {
			return true;
		}
	}
}

onStart {
	vars.completedSplits.Clear();
}

reset {
	return 0 < current.playtime && current.playtime < 3.0;
}

split {
	// - Reach city
	if (settings["City"] && !vars.completedSplits.Contains("City")) {
		// Old Patch route
		if (Math.Sqrt(Math.Pow(-14137.02539 - current.x, 2) + Math.Pow(-13714.83887 - current.z, 2)) < 1000) {
			if (((vars.cityX2 - vars.cityX1) * (current.z - vars.cityZ1) - (vars.cityZ2 - vars.cityZ1) * (current.x - vars.cityX1)) > 0
			 && ((vars.cityX2 - vars.cityX1) * (    old.z - vars.cityZ1) - (vars.cityZ2 - vars.cityZ1) * (    old.x - vars.cityX1)) < 0) {
				vars.completedSplits.Add("City");
				return true;
			}
		}
		// C-Airwalk route
		else if (Math.Sqrt(Math.Pow(-11247.63184 - current.x, 2) + Math.Pow(-22480.66992 - current.z, 2)) < 1000) { 
			if (((vars.landX2 - vars.landX1) * (current.z - vars.landZ1) - (vars.landZ2 - vars.landZ1) * (current.x - vars.landX1)) > 0
			 && ((vars.landX2 - vars.landX1) * (    old.z - vars.landZ1) - (vars.landZ2 - vars.landZ1) * (    old.x - vars.landX1)) < 0) {
				vars.completedSplits.Add("City");
				return true;
			}
		}
	}
	// - Scordo_OpenHarborTunnelDoor
	if (settings["Scordo_OpenHarborTunnelDoor"] && current.Scordo_OpenHarborTunnelDoor == 2 && old.Scordo_OpenHarborTunnelDoor != 2 && vars.completedSplits.Add("Scordo_OpenHarborTunnelDoor")) {
		return true;
	}
	// - Oscar_DonsGoldSwordPieces
	else if (settings["Oscar_DonsGoldSwordPieces"] && current.Oscar_DonsGoldSwordPieces == 2 && old.Oscar_DonsGoldSwordPieces != 2 && vars.completedSplits.Add("Oscar_DonsGoldSwordPieces")) {
		return true;
	}
	// - Gain 5 Strength (repeatable)
	else if (settings["5Str"] && current.strength == old.strength + 5) {
		return true;
	}
	// - Chapter 2
	else if (settings["Chapter2"] && current.chapter == 2 && old.chapter == 1 && vars.completedSplits.Add("Chapter2")) {
		return true;
	}
	// - Eldric_GoToHut (started)
	else if (settings["Eldric_GoToHut_start"] && current.Eldric_GoToHut == 1 && old.Eldric_GoToHut != 1 && vars.completedSplits.Add("Eldric_GoToHut_start")) {
		return true;
	}
	// - Eldric_GoToHut (succeeded)
	else if (settings["Eldric_GoToHut_complete"] && current.Eldric_GoToHut == 2 && old.Eldric_GoToHut != 2 && vars.completedSplits.Add("Eldric_GoToHut_complete")) {
		return true;
	}
	// - Inquisitor_OpenPortal
	else if (settings["Inquisitor_OpenPortal"] && current.Inquisitor_OpenPortal == 2 && old.Inquisitor_OpenPortal != 2 && vars.completedSplits.Add("Inquisitor_OpenPortal")) {
		return true;
	}
	// - Chapter 3
	else if (settings["Chapter3"] && current.chapter == 3 && old.chapter == 2 && vars.completedSplits.Add("Chapter3")) {
		return true;
	}
	// - Chapter 4
	else if (settings["Chapter4"] && current.chapter == 4 && old.chapter == 3 && vars.completedSplits.Add("Chapter4")) {
		return true;
	}
	// - Eldric_FixTitanArmor
	else if (settings["Eldric_FixTitanArmor"] && current.Eldric_FixTitanArmor == 2 && old.Eldric_FixTitanArmor != 2 && vars.completedSplits.Add("Eldric_FixTitanArmor")) {
		return true;
	}
	// - Enter Titan arena
	else if ((settings["EnterTitanArena"] || settings["NG+_EnterTitanArena"]) 
	       && current.titanCounter == old.titanCounter + 1 && vars.completedSplits.Add("EnterTitanArena")) {
		return true;
	}
	// - Credits
	else if ((settings["Credits"] || settings["NG+_Credits"])
	      && current.cutscene != 0 && old.cutscene == 0 && current.x != 0 && current.y != 0 && current.z != 0) {
		return true;
	}

	// ------------ NG+ ------------
	// - Recover after being knocked out (get teleported to monastery jail)
	else if (settings["NG+_Jail"] && current.health == 80 && old.health != 80 && old.health > 50 && vars.completedSplits.Add("NG+_Jail")) {
		return true;
	}
	// - Player_FindAllTeleportstones (started)
	else if (settings["Player_FindAllTeleportstones_start"] && current.Player_FindAllTeleportstones == 1 && old.Player_FindAllTeleportstones != 1 && vars.completedSplits.Add("Player_FindAllTeleportstones_start")) {
		return true;
	}
	// - EPlayer_FindAllTeleportstones (succeeded)
	else if (settings["Player_FindAllTeleportstones_complete"] && current.Player_FindAllTeleportstones == 2 && old.Player_FindAllTeleportstones != 2 && vars.completedSplits.Add("Player_FindAllTeleportstones_complete")) {
		return true;
	}
}

isLoading {
	return current.isLoading || vars.isTimerPaused;
}

exit {
	timer.IsGameTimePaused = true;
	vars.isTimerPaused = true;
}