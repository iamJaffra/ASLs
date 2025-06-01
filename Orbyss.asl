state("Orbyss-Win64-Shipping") {}

startup {
	settings.Add("Splits"        , true , "Split on...");
		settings.Add("LevelSplits"      , false , "level transitions"            , "Splits");
		settings.Add("CheckpointSplits" , false , "checkpoints"                  , "Splits");
		settings.Add("DemoEndMenu"      , true  , "triggering the demo end menu" , "Splits");

	settings.Add("ResetMainMenu" , true , "Reset timer on main menu");
}

init {
#region Scans
	var scanner = new SignatureScanner(game, modules[0].BaseAddress, modules[0].ModuleMemorySize);

	SigScanTarget.OnFoundCallback onFound = (p, _, addr) => addr + 0x4 + p.ReadValue<int>(addr);

	var gWorldTrg    = new SigScanTarget( 3, "48 8B 1D ???????? 48 85 DB 74 ?? 41 B0 01") { OnFound = onFound };
	var fNamePoolTrg = new SigScanTarget(13, "89 5C 24 ?? 89 44 24 ?? 74 ?? 48 8D 15")    { OnFound = onFound };

	var gWorld    = scanner.Scan(gWorldTrg);
	var fNamePool = scanner.Scan(fNamePoolTrg);

	if (fNamePool == IntPtr.Zero || gWorld == IntPtr.Zero) {
		throw new InvalidOperationException("Not all signatures resolved. Trying again.");
	}
#endregion	

#region FNameToString()
	var fNamePoolCache = new Dictionary<ulong, string>() {{0, "None"}};

	vars.FNameToString = (Func<ulong, string>)(fName =>
	{
		var number     = (fName & 0xFFFFFFFF00000000) >> 0x20;
		var nameLookup = (fName & 0x00000000FFFFFFFF) >> 0x00;

		string name;
		if (fNamePoolCache.ContainsKey(nameLookup)) {
			name = fNamePoolCache[nameLookup];
		} 
		else {
			var chunkIdx = (fName & 0x00000000FFFF0000) >> 0x10;
			var nameIdx  = (fName & 0x000000000000FFFF) >> 0x00;

			var chunk = game.ReadPointer(fNamePool + 0x10 + (int)chunkIdx * 0x8);
			var nameEntry = chunk + (int)nameIdx * 0x2;

			var length = game.ReadValue<short>(nameEntry) >> 6;
			name = game.ReadString(nameEntry + 0x2, length);

			fNamePoolCache[nameLookup] = name;
		}

		return number == 0 ? name : name + "_" + number;
	});
#endregion

#region Watchers
	vars.Watchers = new Dictionary<string, MemoryWatcher> {
		// GWorld.FName
		{ "GWorldFName" , new MemoryWatcher<ulong>(new DeepPointer(gWorld, 0x18)) },

		// GWorld.AuthorityGameMode.CurrentCheckpoint.CheckpointIndex
		{ "Checkpoint"  , new MemoryWatcher<int>(new DeepPointer(gWorld, 0x118, 0x4A0, 0x2A4)) },

		// GWorld.AuthorityGameMode.bIsDemoEndMenu
		{ "DemoEndMenu" , new MemoryWatcher<bool>(new DeepPointer(gWorld, 0x118, 0xA60)) },

		// GWorld.AuthorityGameMode.Cinematic
		{ "Cinematic" , new MemoryWatcher<ulong>(new DeepPointer(gWorld, 0x118, 0x3E0)) },
	};

	// GWorld.AuthorityGameMode.Cinematic.FName
	vars.cinematicFName = new MemoryWatcher<ulong>(new DeepPointer(gWorld, 0x118, 0x3E0, 0x18));
#endregion
}

update {
	foreach (var watcher in vars.Watchers.Values) {
		watcher.Update(game);
	}

	current.world      = vars.FNameToString(vars.Watchers["GWorldFName"].Current);
	current.checkpoint = vars.Watchers["Checkpoint"].Current;
}

start {
	vars.cinematicFName.Update(game);
	var cinematic = vars.FNameToString(vars.cinematicFName.Current);
	
	if (current.world == "Level_01" && vars.Watchers["Cinematic"].Current != 0 && vars.Watchers["Cinematic"].Old == 0 && cinematic == "BP_CinematicTrack2_3") {
		timer.IsGameTimePaused = true;
		return true;
	}
}

reset {
	if (settings["ResetMainMenu"] && current.world == "MainMenu" && old.world != "MainMenu") {
		return true;
	}
}

split {
	if (vars.Watchers["DemoEndMenu"].Current && !vars.Watchers["DemoEndMenu"].Old) {
		return settings["DemoEndMenu"];
	}
	else if (settings["CheckpointSplits"] && current.checkpoint == old.checkpoint + 1 && old.checkpoint > 0) {
		// Don't split on the last checkpoint of the demo, as it's right before the end screen
		if (current.world != "Level_03" || current.checkpoint != 4) {
			print("Split due to reaching new Checkpoint: " + old.checkpoint + " -> " + current.checkpoint);
			return true;
		}
	}
	else if (settings["LevelSplits"] && current.world != old.world && current.world != "None" && current.world != "MainMenu") {
		print("Split due to reaching new level: " + current.world);
		return true;
	}
}

isLoading {
	return vars.Watchers["Cinematic"].Current != 0
	    || current.world == "None";
}