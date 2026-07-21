state("Gothic2") {
	long igt:               "ZSPEEDRUNTIMER.DLL", 0x19FE0;

	// POS VECTOR
	float x:                "Gothic2.exe", 0x4CEF4C;
	float y:                "Gothic2.exe", 0x4CEF44;

	// WORLD
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
		Tuple.Create("SnapperWeed",        "Overlay",    "HUMANS_SPRINT.MDS",      "Eat Snapperweed",                  new[] { "All Chapters" }),
		Tuple.Create("BlackOre",           "Item",       "ITMI_ZEITSPALT_ADDON",   "Collect Black Ore",                new[] { "All Chapters" }),
		Tuple.Create("Zuris",              "Talk",       "Zuris",                  "Talk to Zuris",                    new[] { "Any%", "All Chapters" }),
		Tuple.Create("Ignaz",              "Talk",       "Ignaz",                  "Talk to Ignaz",                    new[] { "Any%" }),
		Tuple.Create("Chapter2",           "Chapter",    "2",                      "Reach Chapter 2",                  new[] { "All Chapters" }),
		Tuple.Create("EnterValley",        "EnterWorld", "OLDWORLD",               "Enter the Valley of Mines",        new[] { "Any%", "All Chapters" }),
		Tuple.Create("RuneTeleportCastle", "Item",       "ITRU_TELEPORTOC",        "Collect teleport rune to castle",  new[] { "All Chapters" }),
		Tuple.Create("FireDragon",         "Global",     "FREDRAGNISDEAD",         "Kill the Fire Dragon",             new[] { "Any%", "All Chapters" }),
		Tuple.Create("RockDragon",         "Global",     "RCKDRAGNISDEAD",         "Kill the Rock Dragon",             new[] { "Any%", "All Chapters" }),
		Tuple.Create("Chapter3",           "Chapter",    "3",                      "Reach Chapter 3",                  new[] { "All Chapters" }),
		Tuple.Create("EnterJharkendar",    "EnterWorld", "ADDONWORLD",             "Enter Jharkendar",                 new[] { "All Chapters" }),
		Tuple.Create("Raven",              "Global",     "RAVENISDEAD",            "Kill Raven",                       new[] { "All Chapters" }),
		Tuple.Create("LeaveJharkendar",    "LeaveWorld", "ADDONWORLD",             "Leave Jharkendar",                 new[] { "All Chapters" }),
		Tuple.Create("JoinMilitia",        "Guild",      "2",                      "Join the Militia",                 new[] { "All Chapters" }),
		Tuple.Create("BrokenEyeOfInnos",   "Item",       "ITMI_INNOSEYE_BROKEN",   "Collect broken Eye of Innos",      new[] { "All Chapters" }),
		Tuple.Create("RuneOnar",           "Item",       "ITRU_TELEPORTFARM",      "Get teleport rune from Lee",       new[] { "All Chapters" }),
		Tuple.Create("Chapter4",           "Chapter",    "4",                      "Reach Chapter 4",                  new[] { "All Chapters" }),
		Tuple.Create("SwampDragon",        "Global",     "SWAPDRAGNISDEAD",        "Kill the Swamp Dragon",            new[] { "Any%", "All Chapters" }),
		Tuple.Create("IceDragon",          "Global",     "ICDRAGNISDEAD",          "Kill the Ice Dragon",              new[] { "Any%" }),
		Tuple.Create("Chapter5",           "Chapter",    "5",                      "Reach Chapter 5",                  new[] { "Any%", "All Chapters" }),
		Tuple.Create("SeaMap",             "Item",       "ITWR_SEAMAP_IRDORATH",   "Collect the sea map to Irdorath",  new[] { "Any%" }),
		Tuple.Create("Bed",                "Animation",  "T_BEDHIGH_BACK_S0_2_S1", "Go to bed",                        new[] { "Any%" }),
		//Tuple.Create("BrianLighthouse",    "Lighthouse", "2",                    "Brian becomes Lighthouse officer", new[] { "Any%" }),
		Tuple.Create("EnterIrdorath",      "EnterWorld", "DRAGONISLAND",           "Enter Irdorath",                   new[] { "Any%", "All Chapters" }),
		Tuple.Create("UndeadDragon",       "EnterWorld", "UNDEADDRAGONISDEAD",     "Kill the Undead Dragon",           new[] { "Any%", "All Chapters" }),
		Tuple.Create("End",                "End",        "",                       "Finish the game",                  new[] { "Any%", "All Chapters" }),
	};
	
	settings.Add("NewGame", true, "Reset+Start timer on New Game");

	settings.Add("Splits", true, "Splits");
		settings.Add("Any%", true, "Any%", "Splits");
		settings.Add("All Chapters", true, "All Chapters", "Splits");

	foreach (var split in vars.Splits) {
		string name         = split.Item1;
		string description  = split.Item4;
		string[] categories = split.Item5;
		
		foreach (var category in categories) {
			settings.Add(category + ":" + name, false, description, category);
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
		"EXTRO_KDF",
		"EXTRO_XARDAS",
		"CREDITS_EXTRO",
		"CREDITS2"
	};

	vars.Worlds = new HashSet<string> {
		"OLDWORLD",
		"NEWWORLD",
		"ADDONWORLD",
		"DRAGONISLAND"
	};

	#region Offsets
	
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

	// cur_table.table
	int symtab = new DeepPointer("Gothic2.exe", 0x6B6428, 0x8).Deref<int>(game);
	int size = new DeepPointer("Gothic2.exe", 0x6B6428, 0x8 + 0x4).Deref<int>(game);
	
	for (int i = 0; i < size; i++) {
		var symbol = new DeepPointer((IntPtr)symtab + i * 0x4).Deref<int>(game); 
		string name = new DeepPointer((IntPtr)symbol + 0x8, 0x0).DerefString(game, 100); 
		int address = symbol + 0x18;

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

	vars.canReset = true;
	current.cutscene = old.cutscene = "";
}

start {
	if (settings["NewGame"]) {
		if (current.igt < 500000
				&& Math.Abs(current.x - vars.startX) < 0.0001
				&& Math.Abs(current.y - vars.startY) < 0.0001) {

			vars.canReset = false;
			return true;
		}
	}
}

onStart {
	vars.CompletedSplits.Clear();
	vars.timeKeeper = TimeSpan.FromMilliseconds(0);

	vars.Info("--- START ---");
}

reset {
	if (settings["NewGame"]) {
		if (current.igt < 500000 && vars.canReset
				&& Math.Abs(current.x - vars.startX) < 0.0001
				&& Math.Abs(current.y - vars.startY) < 0.0001) {

			return true;
		}
	}
}

onReset {
	vars.Info("--- RESET ---");
}

update {
	foreach (var watcher in vars.Globals.Values) {
		watcher.Update(game);
	}

	vars.UpdateOwnedItems();

	if (!vars.canReset && current.igt > 500000) {
		vars.canReset = true;
	}
	
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
}

split {
	foreach (var split in vars.Splits) {
		string name         = split.Item1;
		string type         = split.Item2;
		string arg          = split.Item3;
		string[] categories = split.Item5;

		foreach (var category in categories) {
			string setting = category + ":" + name;

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