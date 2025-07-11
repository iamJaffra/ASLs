// ASL by Jaffra

state("Risen", "Old Patch") {
	// POSITION VECTOR
	float x:        "Game.dll",    0x104418C;
	float y:        "Game.dll",    0x1044190;
	float z:        "Game.dll",    0x1044194;

	// LOADING & CUTSCENE
	bool isLoading: "Game.dll",    0xFEA66C;
	ulong cutscene: "binkw32.dll", 0x02F054;

	// QUESTS
	// Quests are sorted into a bunch of different arrays depending on their type.
	// We only need two of the possible quest status values (1 = started, 2 = completed), stored at
	// gCQuestManager.<array>[i].questStatus
	ulong questManager: "Game.dll", 0x00FDC188;
	int chapter:        "Game.dll", 0x00FDC188, 0xCC;
	
	int Scordo_OpenHarborTunnelDoor: "Game.dll", 0x00FDC188, 0x30, 0x12C, 0x78;
	int Oscar_DonsGoldSwordPieces:   "Game.dll", 0x00FDC188, 0x24,  0x4C, 0x78;
	int Eldric_GoToHut:              "Game.dll", 0x00FDC188, 0x78,  0x78, 0x78;
	int Inquisitor_OpenPortal:       "Game.dll", 0x00FDC188, 0x30, 0x1AC, 0x78;
	int Eldric_FixTitanArmor:        "Game.dll", 0x00FDC188, 0x24,  0x10, 0x78;

	// COUNTER FOR ScriptGame.PS_Titan_Begin
	int titanCounter: "Script_Game.dll", 0x00213700;
}

state("Risen", "New Patch") {
	// POSITION VECTOR
	float x:        "Game.dll",    0x11C5F10;
	float y:        "Game.dll",    0x11C5F14;
	float z:        "Game.dll",    0x11C5F18;

	// LOADING & CUTSCENE
	bool isLoading: "Game.dll",    0x12AA0C8;
	ulong cutscene: "binkw64.dll", 0x003AE25;

	// QUESTS
	// Quests are sorted into a bunch of different arrays depending on their type.
	// We only need two of the possible quest status values (1 = started, 2 = completed), stored at
	// gCQuestManager.<array>[i].questStatus
	ulong questManager: "Game.dll", 0x0126E7C8;
	int chapter:        "Game.dll", 0x0126E7C8, 0x190;
	
	int Scordo_OpenHarborTunnelDoor: "Game.dll", 0x0126E7C8, 0x60, 0x258, 0xC8;
	int Oscar_DonsGoldSwordPieces:   "Game.dll", 0x0126E7C8, 0x48,  0x98, 0xC8;
	int Eldric_GoToHut:              "Game.dll", 0x0126E7C8, 0xF0,  0xF0, 0xC8;
	int Inquisitor_OpenPortal:       "Game.dll", 0x0126E7C8, 0x60, 0x358, 0xC8;
	int Eldric_FixTitanArmor:        "Game.dll", 0x0126E7C8, 0x48,  0x20, 0xC8;

	// COUNTER FOR ScriptGame.PS_Titan_Begin
	int titanCounter: "Script_Game.dll", 0x002D4000;
}

/*
	// This code prints the name of every quest in the game and where to find it
	IntPtr questManager = (IntPtr)current.questManager;

	if (version == "Old Patch") {
		for (int j = 0x24; j < 0x84; j += 0xC) {
			var arraySize = game.ReadValue<int>(questManager + j + 0x4);
			for (int i = 0; i < arraySize; i++) {
				var questName = new DeepPointer(questManager + j, i * 0x4, 0x8, 0x0).DerefString(game, 100);
				if (questName.Contains("Inquisitor")) {
					var offset = i * 0x4;
					//print("Array " + j.ToString("X") + " : " + "[" + i + "]" + " (" + offset.ToString("X") + ")" + " = " + questName);
					print("0x" + j.ToString("X") + ", 0x" + offset.ToString("X") + " = " + questName);
				}	
			}
			print("-------------------");
		}
	}
*/

startup {
	settings.Add("Any%", true, "Any% No Annoy");
		settings.Add("Any%_Chest", false, "Acquire orc dog spell from chest", "Any%");
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

	if (module != null)	{
		var ptr = (IntPtr)module.BaseAddress;

		if (version == "New Patch") {
			// E9 4C 8F 05 00
			byte[] jmp = new byte[]	{
				0xE9, 0x4C, 0x8F, 0x05, 0x00        // jmp Script_Game.dll.text+1F6A31 (RIP: 0x58F4C)
			};

			// 40 55 53 56 57 FE 05 C4 C5 0D 00 E9 A4 70 FA FF
			byte[] codecave = new byte[] {
				0x40, 0x55,                         // push rbp
				0x53,                               // push rbx
				0x56,                               // push rsi
				0x57,                               // push rdi
				0xFE, 0x05, 0xC4, 0xC5, 0x0D, 0x00, // inc byte ptr [Script_Game.dll+2D4000]
				0xE9, 0xA4, 0x70, 0xFA, 0xFF        // jmp Script_Game.PS_Titan_Begin+5
			};

			game.WriteBytes(ptr + 0x19EAE0, jmp);
			game.WriteBytes(ptr + 0x1F7A31, codecave);
		}
		else if (version == "Old Patch") {
			// E9 BB 1B 00 00
			byte[] jmp = new byte[]	{
				0xE9, 0xBB, 0x1B, 0x00, 0x00   // jmp Script_Game.dll.text+99EA0
			};

			// 83 EC 44 53 55 50 B8 00 37 AA 2A FE 00 58 E9 32 E4 FF FF
			byte[] codecave = new byte[] {
				0x83, 0xEC, 0x44,              // sub esp,44
				0x53,                          // push ebx
				0x55,                          // push ebp
				0x50,                          // push eax
				0xB8, 0x00, 0x00, 0x00, 0x00,  // mov eax,________
				0xFE, 0x00,                    // inc byte ptr [eax]
				0x58,                          // pop eax
				0xE9, 0x32, 0xE4, 0xFF, 0xFF   // jmp Script_Game.dll.text+982E5
			};

			// Get the absolute address of the counter
			var counterAddr = (int)ptr + 0x9AEA0 + 0x7 + 0x178859;
			print("Counter at: " + counterAddr.ToString("X"));

			byte[] bytes = BitConverter.GetBytes(counterAddr);
			codecave[7]  = bytes[0];
			codecave[8]  = bytes[1];
			codecave[9]  = bytes[2];
			codecave[10] = bytes[3];

			print("Final bytes: " + string.Join(" ", codecave.Select(b => "0x" + b.ToString("X2"))));

			game.WriteBytes(ptr + 0x992E0, jmp);
			game.WriteBytes(ptr + 0x9AEA0, codecave);
		}
	}
	else {
		throw new InvalidOperationException("Script_Game.dll not found. Trying again...");
	}

	print("Patched Script_Game.dll");

	vars.startX = -38558.72000;
	vars.startY =    -46.57122;
	vars.startZ =  -5770.01200;

	vars.cityX1 = -13890.23000;
	vars.cityZ1 = -13797.83000;
	vars.cityX2 = -14541.90000;
	vars.cityZ2 = -14063.06000;

	vars.completedSplits = new HashSet<string>();

	vars.initialTitanCounter = 0;
}

update {
	if (version == "Unkown") {
		print("Deactivating ASL due to unknown game version.");
		return false;
	}
	
	/*
	if (current.x != old.x || current.y != old.y || current.z != old.z) {
		print("Current pos = (" + current.x.ToString("0.00000") + ", " + current.y.ToString("0.00000") + ", " + current.z.ToString("0.00000") + ")");
	}
	*/

	if (current.isLoading != old.isLoading) {
		vars.initialTitanCounter = current.titanCounter;
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
	vars.initialTitanCounter = current.titanCounter;
	vars.completedSplits.Clear();
}

split {
	// - Credits
	if (current.cutscene != 0 && old.cutscene == 0) {
		return true;
	}
	// - Reach city
	else if (((vars.cityX2 - vars.cityX1) * (current.z - vars.cityZ1) - (vars.cityZ2 - vars.cityZ1) * (current.x - vars.cityX1)) > 0 && vars.completedSplits.Add("CITY")) {
		return true;
	}
	// - Scordo_OpenHarborTunnelDoor
	else if (current.Scordo_OpenHarborTunnelDoor == 2 && old.Scordo_OpenHarborTunnelDoor != 2) {
		return true;
	}
	// - Oscar_DonsGoldSwordPieces
	else if (current.Oscar_DonsGoldSwordPieces == 2 && old.Oscar_DonsGoldSwordPieces != 2) {
		return true;
	}
	// - Chapter 2
	else if (current.chapter == 2 && old.chapter == 1) {
		return true;
	}
	// - Eldric_GoToHut (started)
	else if (current.Eldric_GoToHut == 1 && old.Eldric_GoToHut != 1) {
		return true;
	}
	// - Eldric_GoToHut (succeeded)
	else if (current.Eldric_GoToHut == 2 && old.Eldric_GoToHut != 2) {
		return true;
	}
	// - Inquisitor_OpenPortal
	else if (current.Inquisitor_OpenPortal == 2 && old.Inquisitor_OpenPortal != 2) {
		return true;
	}
	// - Chapter 3
	else if (current.chapter == 3 && old.chapter == 2) {
		return true;
	}
	// - Eldric_FixTitanArmor
	else if (current.Eldric_FixTitanArmor == 2 && old.Eldric_FixTitanArmor != 2) {
		return true;
	}
	// - Enter Titan arena
	else if (current.titanCounter != old.titanCounter) {
		if (version == "Old Patch") {
			if (current.titanCounter == vars.initialTitanCounter + 7) {
				return true;
			}
		}
		else if (version == "New Patch") {
			if (current.titanCounter == vars.initialTitanCounter + 5) {
				return true;
			}
		}
	}
}

isLoading {
	return current.isLoading;
}