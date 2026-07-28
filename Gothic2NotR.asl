state("Gothic2") {
	long igt:               "ZSPEEDRUNTIMER.DLL", 0x19FE0;

	// POS VECTOR
	float x:                "Gothic2.exe", 0x4CEF4C;
	float y:                "Gothic2.exe", 0x4CEF44;

	// WORLD worldName
	string20 world:         "Gothic2.exe", 0x6B0884, 0x8, 0x6274, 0x0;

	// PLAYER
	int guild:              "Gothic2.exe", 0x6B2684, 0x230;
	int exp:                "Gothic2.exe", 0x6B2684, 0x42C;
	int isPlayerInDialogue: "Gothic2.exe", 0x6B2684, 0x298;
	                        // player.visual.activeAniList.protoAni.aniName
	string32 ani:           "Gothic2.exe", 0x6B2684, 0xC8, 0x50, 0x0, 0x2C, 0x0;
	                        // player.timedOverlays[0].mdsOverlayName
	string32 overlay:       "Gothic2.exe", 0x6B2684, 0x564, 0x0, 0x8, 0x0;
}

startup {
	vars.Splits = new List<Tuple<string, string, string, string, string[]>> {
		//           name,                 type,         arg,                      description,                        categories
		Tuple.Create("SnapperWeed",        "Overlay",    "HUMANS_SPRINT.MDS",      "Eat Snapperweed",                  new[] { "AllChapters" }),
		Tuple.Create("BlackOre",           "Item",       "ITMI_ZEITSPALT_ADDON",   "Collect Black Ore",                new[] { "AllChapters" }),
		Tuple.Create("Zuris",              "Talk",       "Zuris",                  "Talk to Zuris",                    new[] { "Any%", "AllChapters" }),
		Tuple.Create("Ignaz",              "Talk",       "Ignaz",                  "Talk to Ignaz",                    new[] { "Any%" }),
		Tuple.Create("Chapter2",           "Chapter",    "2",                      "Reach Chapter 2",                  new[] { "AllChapters" }),
		Tuple.Create("EnterValley",        "EnterWorld", "OLDWORLD",               "Enter the Valley of Mines",        new[] { "Any%", "AllChapters" }),
		Tuple.Create("RuneTeleportCastle", "Item",       "ITRU_TELEPORTOC",        "Collect teleport rune to castle",  new[] { "AllChapters" }),
		Tuple.Create("FireDragon",         "Global",     "FREDRAGNISDEAD",         "Kill the Fire Dragon",             new[] { "Any%", "AllChapters" }),
		Tuple.Create("RockDragon",         "Global",     "RCKDRAGNISDEAD",         "Kill the Rock Dragon",             new[] { "Any%", "AllChapters" }),
		Tuple.Create("Chapter3",           "Chapter",    "3",                      "Reach Chapter 3",                  new[] { "AllChapters" }),
		Tuple.Create("EnterJharkendar",    "EnterWorld", "ADDONWORLD",             "Enter Jharkendar",                 new[] { "AllChapters" }),
		Tuple.Create("Raven",              "Global",     "RAVENISDEAD",            "Kill Raven",                       new[] { "AllChapters" }),
		Tuple.Create("LeaveJharkendar",    "LeaveWorld", "ADDONWORLD",             "Leave Jharkendar",                 new[] { "AllChapters" }),
		Tuple.Create("JoinMilitia",        "Guild",      "2",                      "Join the Militia",                 new[] { "AllChapters" }),
		Tuple.Create("BrokenEyeOfInnos",   "Item",       "ITMI_INNOSEYE_BROKEN",   "Collect broken Eye of Innos",      new[] { "AllChapters" }),
		Tuple.Create("RuneOnar",           "Item",       "ITRU_TELEPORTFARM",      "Get teleport rune from Lee",       new[] { "AllChapters" }),
		Tuple.Create("Chapter4",           "Chapter",    "4",                      "Reach Chapter 4",                  new[] { "AllChapters" }),
		Tuple.Create("SwampDragon",        "Global",     "SWAPDRAGNISDEAD",        "Kill the Swamp Dragon",            new[] { "Any%", "AllChapters" }),
		Tuple.Create("IceDragon",          "Global",     "ICDRAGNISDEAD",          "Kill the Ice Dragon",              new[] { "Any%" }),
		Tuple.Create("Chapter5",           "Chapter",    "5",                      "Reach Chapter 5",                  new[] { "Any%", "AllChapters" }),
		Tuple.Create("SeaMap",             "Item",       "ITWR_SEAMAP_IRDORATH",   "Collect the sea map to Irdorath",  new[] { "Any%" }),
		Tuple.Create("Bed",                "Animation",  "T_BEDHIGH_BACK_S0_2_S1", "Go to bed",                        new[] { "Any%" }),
		//Tuple.Create("BrianLighthouse",    "Lighthouse", "2",                    "Brian becomes Lighthouse officer", new[] { "Any%" }),
		Tuple.Create("EnterIrdorath",      "EnterWorld", "DRAGONISLAND",           "Enter Irdorath",                   new[] { "Any%", "AllChapters" }),
		Tuple.Create("UndeadDragon",       "Global",     "UNDEADDRAGONISDEAD",     "Kill the Undead Dragon",           new[] { "Any%", "AllChapters" }),
		Tuple.Create("End",                "End",        "",                       "Finish the game",                  new[] { "Any%", "AllChapters" }),
	};
	
	settings.Add("NewGame", true, "Reset+Start timer on New Game");

	settings.Add("Splits", true, "Splits");
		settings.Add("Any%", true, "Any%", "Splits");
		settings.Add("AllChapters", true, "All Chapters", "Splits");

	foreach (var split in vars.Splits) {
		string name         = split.Item1;
		string description  = split.Item4;
		string[] categories = split.Item5;
		
		foreach (var category in categories) {
			settings.Add(category + "_" + name, false, description, category);
		}
	}

	vars.Info = (Action<string>)((msg) => {
		print("[Gothic 2 NotR ASL] " + msg);
	});

	// Variable to save IGT in case the game crashes or softlocks
	vars.TimeKeeper = new TimeSpan();

	// Flags
	vars.CompletedSplits = new HashSet<string>();
}

init {
	// Starting coordinates
	vars.startX = -15710.02637; 
	vars.startY =  29912.93750;

	// NPC IDs
	vars.NPCs = new Dictionary<string, int> {
		{ "Zuris",        409 }, 
		{ "Ignaz",        498 }, 
		{ "Raven",        1090 }, 
		{ "UndeadDragon", 12377 }, 
	};
	
	vars.EndingCutscenes = new HashSet<string> {
		"EXTRO_XARDAS",
		"CREDITS_EXTRO"
	};

	vars.Worlds = new HashSet<string> {
		"OLDWORLD",
		"NEWWORLD",
		"ADDONWORLD",
		"DRAGONISLAND"
	};

	vars.Watchers = new Dictionary<string, MemoryWatcher>();

	#region Offsets
	
	// Base
	IntPtr BASE = modules[0].BaseAddress;

	// Statics
	const int GAME_MANAGER = 0x004C2958;
	const int PLAYER       = 0x002B2684;

	// VideoPlayer
	const int VIDEO_PLAYER_OFFSET     = 0x78;
		const int M_VIDEO_FILENAME_OFFSET = 0x04;
		const int M_PLAYING_OFFSET        = 0x20;
	
	#endregion
	
	#region VideoPlayer

	vars.GetCurrentCutscene = (Func<string>)(() => {
		IntPtr videoPlayer = (IntPtr) new DeepPointer("Gothic2.exe", GAME_MANAGER, VIDEO_PLAYER_OFFSET).Deref<int>(game);
		if (videoPlayer == IntPtr.Zero) return "";
		
		bool isVideoPlaying = new DeepPointer((IntPtr)videoPlayer + M_PLAYING_OFFSET).Deref<bool>(game);

		if (isVideoPlaying) {
			string cutscenePath = new DeepPointer((IntPtr)videoPlayer + M_VIDEO_FILENAME_OFFSET + 0x8, 0x0)
				.DerefString(game, 1000);

			string cutscene = Path.GetFileNameWithoutExtension(cutscenePath);

			return cutscene;
		}
		
		return "";
	});

	#endregion

	#region Global Symbol Table

	vars.Globals = new Dictionary<string, MemoryWatcher>();

	var requiredGlobals = new List<string> {
		{ "KAPITEL" },
		{ "RCKDRAGNISDEAD" },
		{ "FREDRAGNISDEAD" },
		{ "SWAPDRAGNISDEAD" },
		{ "ICDRAGNISDEAD" },
		{ "UNDEADDRAGONISDEAD" },
		{ "RAVENISDEAD" },
		{ "MIS_JACK_NEWLIGHTHOUSEOFFICER" },
	};

	const int PARSER = 0x00AB40C0;   // zCParser* parser = (zCParser* )

	const int SYMTAB_OFFSET = 0x10;  // zCPar_SymbolTable symtab;
	const int TABLE_OFFSET = 0x8;    // zCArray<zCPar_Symbol*> table;

	IntPtr tablePtr = (IntPtr)new DeepPointer((IntPtr)PARSER + SYMTAB_OFFSET + TABLE_OFFSET).Deref<int>(game);
	int size = new DeepPointer((IntPtr)PARSER + SYMTAB_OFFSET + TABLE_OFFSET + 0x4).Deref<int>(game);
	
	for (int i = 0; i < size; i++) {
		IntPtr symbolPtr = (IntPtr)new DeepPointer((IntPtr)tablePtr + i * 0x4).Deref<int>(game); 
		string name = new DeepPointer((IntPtr)symbolPtr + 0x8, 0x0).DerefString(game, 100); 
		IntPtr address = symbolPtr + 0x18;
		
		foreach (var global in requiredGlobals) {
			if (name == global) {
				vars.Info(name + " = table[" + i + "] at 0x" + address.ToString("X"));

				vars.Globals[global] = new MemoryWatcher<int>(new DeepPointer((IntPtr)address));
			}
		} 
	}

	foreach (var global in requiredGlobals) {
		if (!vars.Globals.ContainsKey(global)) {
			throw new InvalidOperationException("Global " + global + " not found. Trying again.");
		}
	}

	#endregion

	#region NPCs

	vars.IsDead = (Func<int, bool>)((npcID) => {
		// ogame.world.voblist_npc.data
		IntPtr npc = (IntPtr) new DeepPointer("Gothic2.exe", 0x6B0884, 0x8, 0x6284, 0x8).Deref<int>(game);

		while (npc != IntPtr.Zero) {
			var npcData = game.ReadPointer(npc + 0x4);
			var id = game.ReadValue<int>(npcData + 0x120);
			var hp = game.ReadValue<int>(npcData + 0x1B8);
			
			if (id == npcID && hp == 0) {
				return true;
			}
	
			npc = game.ReadPointer(npc + 0x8);
		}

		return false;
	});
	
	vars.IsInDialogue = (Func<int, bool>)((npcID) => {
		// ogame.world.voblist_npc.data
		IntPtr npc = (IntPtr) new DeepPointer("Gothic2.exe", 0x6B0884, 0x8, 0x6284, 0x8).Deref<int>(game);

		while (npc != IntPtr.Zero) {
			var npcData = game.ReadPointer(npc + 0x4);
			var id = game.ReadValue<int>(npcData + 0x120);
			var inDialogue = game.ReadValue<int>(npcData + 0x298);

			if (id == npcID && inDialogue == 1) {
				return true;
			}
	
			npc = game.ReadPointer(npc + 0x8);
		}

		return false;
	});

	#endregion

	#region Inventory

	vars.OwnedItems = new HashSet<string>();

	vars.UpdateOwnedItems = (Action)(() => {
		vars.OwnedItems.Clear();

		// player.inventory2.contents
		IntPtr item = (IntPtr) new DeepPointer("Gothic2.exe", 0x006B2684, 0x66C, 0x8).Deref<int>(game);
		
		while (item != IntPtr.Zero) {
			var itemData = game.ReadPointer(item + 0x4);
			string itemName = game.ReadString(game.ReadPointer(itemData + 0x18), 20);
			
			vars.OwnedItems.Add(itemName);
	
			item = game.ReadPointer(item + 0x8);
		}
	});

	#endregion

	#region HandleSelAction Hook

	const int COUNTER_ADDR = 0x004C1600;
	const int MESSAGE_ADDR = 0x004C1604;
	const int HOOK_ADDR    = 0x000DC896;
	const int DETOUR_ADDR  = 0x0042D800;

	// --

	byte[] newGameMessage = { 0x4E, 0x45, 0x57, 0x5F, 0x47, 0x41, 0x4D, 0x45 };	 // NEW_GAME

	game.WriteBytes((IntPtr)(BASE + MESSAGE_ADDR), newGameMessage);

	// --

	byte[] detour = {
		0x8B, 0xB4, 0x24, 0xCC, 0x00, 0x00, 0x00,  // mov esi,[esp+000000CC]
		0x60,                                      // pushad 
		0x9C,                                      // pushfd 
		0x8B, 0x46, 0x0C,                          // mov eax,[esi+0C]
		0x83, 0xF8, 0x08,                          // cmp eax,08 { 8 }
		0x75, 0x1A,                                // jne Gothic2.exe+42D82B
		0x56,                                      // push esi
		0x8B, 0x76, 0x08,                          // mov esi,[esi+08]
		0x8D, 0x3D, 0x04, 0x16, 0x8C, 0x00,        // lea edi,[Gothic2.exe+4C1604] { ("NEW_GAME") }
		0xB9, 0x08, 0x00, 0x00, 0x00,              // mov ecx,00000008 { 8 }
		0xF3, 0xA6,                                // repe cmpsb 
		0x5E,                                      // pop esi
		0x75, 0x06,                                // jne Gothic2.exe+42D82B
		0xFF, 0x05, 0x00, 0x16, 0x8C, 0x00,        // inc [Gothic2.exe+4C1600] { (0) }
		0x9D,                                      // popfd 
		0x61,                                      // popad 
		0xE9, 0x6B, 0xF0, 0xCA, 0xFF               // jmp Gothic2.exe+DC89D
	};

	game.WriteBytes((IntPtr)(BASE + DETOUR_ADDR), detour);

	// --
	byte[] hook = { 0xE9, 0x65, 0x0F, 0x35, 0x00, 0x90, 0x90 };

	game.WriteBytes((IntPtr)(BASE + HOOK_ADDR), hook);

	// --

	vars.Info("Applied HandleSelAction hook.");

	vars.Watchers["NewGames"] = new MemoryWatcher<int>(new DeepPointer((IntPtr)(BASE + COUNTER_ADDR)));

	#endregion

	vars.IsNewGame = false;
	current.cutscene = old.cutscene = "";
}

update {
	foreach (var watcher in vars.Globals.Values) {
		watcher.Update(game);
	}

	foreach (var watcher in vars.Watchers.Values) {
		watcher.Update(game);
	}

	vars.UpdateOwnedItems();
	
	current.cutscene = vars.GetCurrentCutscene();
	if (current.cutscene != old.cutscene) {
		if (!string.IsNullOrEmpty(current.cutscene)) {
			vars.Info("Cutscene -> " + current.cutscene);
		}
		else {
			vars.Info("Cutscene ended.");
		}
	}

	if (current.world != old.world) {
		vars.Info("World: " + old.world + " -> " + current.world);
	}

	/*
	if (current.ani != old.ani) {
		if (!string.IsNullOrEmpty(current.ani)) {
			vars.Info("Ani -> " + current.ani);
		}
		else {
			vars.Info("Ani -> none");
		}
	}
	*/

	if (vars.Watchers["NewGames"].Changed && vars.Watchers["NewGames"].Current != 0) {
		vars.Info("Selected NEW_GAME.");
		vars.IsNewGame = true;
	}
}

start { 
	if (vars.IsNewGame && current.igt < 500000 && current.igt != 0) {
		vars.IsNewGame = false;
		return settings["NewGame"];
	}
}

onStart {
	vars.CompletedSplits.Clear();
	vars.TimeKeeper = TimeSpan.FromMilliseconds(0);

	vars.Info("--- START ---");
}

reset {		
	return vars.IsNewGame && settings["NewGame"];
}

onReset {
	vars.Info("--- RESET ---");
}

split {
	foreach (var split in vars.Splits) {
		string name         = split.Item1;
		string type         = split.Item2;
		string arg          = split.Item3;
		string[] categories = split.Item5;

		foreach (var category in categories) {
			string setting = category + "_" + name;

			if (!settings[setting] || vars.CompletedSplits.Contains(name)) continue;

			bool shouldSplit = false;

			switch (type) {
				case "Overlay": 
					shouldSplit = current.overlay == arg;
					break;
				case "Item": 
					shouldSplit = vars.OwnedItems.Contains(arg);
					break;
				case "Talk":
					shouldSplit = 
						current.isPlayerInDialogue == 1 && vars.IsInDialogue(vars.NPCs[arg]);
					break;
				case "Chapter":
					int chapter = int.Parse(arg);
					shouldSplit = vars.Globals["KAPITEL"].Current == chapter;
					break;
				case "EnterWorld": 
					shouldSplit = current.world != old.world && current.world == arg;
					break;
				case "LeaveWorld": 
					shouldSplit = current.world != old.world && old.world == arg
						&& vars.Worlds.Contains(current.world);
					break;
				case "Global":
					shouldSplit = vars.Globals[arg].Current == 1;
					break;
				case "Guild":
					int guild = int.Parse(arg);
					shouldSplit = current.guild == guild;
					break;
				case "Animation":
					shouldSplit = current.ani == arg;
					break;
				case "End":
					shouldSplit = vars.EndingCutscenes.Contains(current.cutscene);
					break;
			}

			if (shouldSplit) {
				vars.Info("Split: " + name + " (" + arg + ")");
				vars.CompletedSplits.Add(name);
				return true;
			}
		}
	}
}

isLoading {
	return true;
}

gameTime {
	return (vars.TimeKeeper + TimeSpan.FromMilliseconds(current.igt / 1000));
}

exit {
	vars.TimeKeeper = timer.CurrentTime.GameTime;
}